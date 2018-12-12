#
# Description: <Method description here>
#

module Operations
  class VMwareDatastores
    def initialize(handle = $evm)
      @handle = handle
    end

    def main
      fill_dialog_field(fetch_list_data)
    end

    def fetch_list_data
      list = { nil => "<default>" }
      
      # VMware datastore ems ref always includes 'datastore', for example 'datastore-661'.
      
      # All datastores, filtered by ems_ref
      vmware_datastores = @handle.vmdb(:Storage).where("ems_ref like '%datastore%'")
      #vmware_datastores = @handle.vmdb(:Storage).all.find_all{|s|s.ems_ref.match(/datastore/)}
      
      # Specified (by name) provider's datastores
      #vmware_datastores = @handle.vmdb(:ExtManagementSystem).find_by(:name=>'vCenter').storages
      
      vmware_datastores.each {|datastore| list[datastore.id] = datastore.name}
      
      list
    end

    def fill_dialog_field(list)
      dialog_field = @handle.object

      # sort_by: value / description / none
      dialog_field["sort_by"] = "description"

      # sort_order: ascending / descending
      dialog_field["sort_order"] = "ascending"

      # data_type: string / integer
      dialog_field["data_type"] = "string"

      # required: true / false
      dialog_field["required"] = "false"

      dialog_field["values"] = list
      dialog_field["default_value"] = nil
    end
  end
end

Operations::VMwareDatastores.new.main
