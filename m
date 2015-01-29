Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763504AbbA2DAq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 22:00:46 -0500
Received: from mga03.intel.com ([134.134.136.65]:19645 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760865AbbA2DAT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 22:00:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,484,1418112000"; 
   d="scan'208";a="677767192"
Message-ID: <54C9A23C.4080807@linux.intel.com>
Date: Thu, 29 Jan 2015 11:00:12 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Lv Zheng <lv.zheng@intel.com>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Tony Luck <tony.luck@intel.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [Patch v2 19/22] x86/PCI/ACPI: Use common ACPI resource interfaces
 to simplify implementation
References: <1422442660-455-1-git-send-email-jiang.liu@linux.intel.com> <1422442660-455-20-git-send-email-jiang.liu@linux.intel.com> <20150128233700.GE17623@google.com>
In-Reply-To: <20150128233700.GE17623@google.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2015/1/29 7:37, Bjorn Helgaas wrote:
> On Wed, Jan 28, 2015 at 06:57:37PM +0800, Jiang Liu wrote:
>> Use common ACPI resource discovery interfaces to simplify PCI host bridge
>> resource enumeration.
>>
>> It also fixes the issue discovered by Thomas that function setup_resource()
>> incorrectly validates IO port resources against iomem_resource.
> 
> Is it possible to split this bug fix into its own separate patch?  Mixing
> things together makes git archaeology harder because it hides tiny bug
> fixes inside big changes.
Hi Bjorn,
	I will split out a patch to fix the issue in next version.
Thanks!
Gerry

> 
>> Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
>> ---
>>  arch/x86/pci/acpi.c |  296 ++++++++++++++++-----------------------------------
>>  1 file changed, 94 insertions(+), 202 deletions(-)
>>
>> diff --git a/arch/x86/pci/acpi.c b/arch/x86/pci/acpi.c
>> index bb98afd0591e..3404ea703ecc 100644
>> --- a/arch/x86/pci/acpi.c
>> +++ b/arch/x86/pci/acpi.c
>> @@ -10,9 +10,6 @@
>>  struct pci_root_info {
>>  	struct acpi_device *bridge;
>>  	char name[16];
>> -	unsigned int res_num;
>> -	struct resource *res;
>> -	resource_size_t *res_offset;
>>  	struct pci_sysdata sd;
>>  #ifdef	CONFIG_PCI_MMCONFIG
>>  	bool mcfg_added;
>> @@ -218,130 +215,44 @@ static void teardown_mcfg_map(struct pci_root_info *info)
>>  }
>>  #endif
>>  
>> -static acpi_status resource_to_addr(struct acpi_resource *resource,
>> -				    struct acpi_resource_address64 *addr)
>> -{
>> -	acpi_status status;
>> -	struct acpi_resource_memory24 *memory24;
>> -	struct acpi_resource_memory32 *memory32;
>> -	struct acpi_resource_fixed_memory32 *fixed_memory32;
>> -
>> -	memset(addr, 0, sizeof(*addr));
>> -	switch (resource->type) {
>> -	case ACPI_RESOURCE_TYPE_MEMORY24:
>> -		memory24 = &resource->data.memory24;
>> -		addr->resource_type = ACPI_MEMORY_RANGE;
>> -		addr->address.minimum = memory24->minimum;
>> -		addr->address.address_length = memory24->address_length;
>> -		addr->address.maximum = addr->address.minimum + addr->address.address_length - 1;
>> -		return AE_OK;
>> -	case ACPI_RESOURCE_TYPE_MEMORY32:
>> -		memory32 = &resource->data.memory32;
>> -		addr->resource_type = ACPI_MEMORY_RANGE;
>> -		addr->address.minimum = memory32->minimum;
>> -		addr->address.address_length = memory32->address_length;
>> -		addr->address.maximum = addr->address.minimum + addr->address.address_length - 1;
>> -		return AE_OK;
>> -	case ACPI_RESOURCE_TYPE_FIXED_MEMORY32:
>> -		fixed_memory32 = &resource->data.fixed_memory32;
>> -		addr->resource_type = ACPI_MEMORY_RANGE;
>> -		addr->address.minimum = fixed_memory32->address;
>> -		addr->address.address_length = fixed_memory32->address_length;
>> -		addr->address.maximum = addr->address.minimum + addr->address.address_length - 1;
>> -		return AE_OK;
>> -	case ACPI_RESOURCE_TYPE_ADDRESS16:
>> -	case ACPI_RESOURCE_TYPE_ADDRESS32:
>> -	case ACPI_RESOURCE_TYPE_ADDRESS64:
>> -		status = acpi_resource_to_address64(resource, addr);
>> -		if (ACPI_SUCCESS(status) &&
>> -		    (addr->resource_type == ACPI_MEMORY_RANGE ||
>> -		    addr->resource_type == ACPI_IO_RANGE) &&
>> -		    addr->address.address_length > 0) {
>> -			return AE_OK;
>> -		}
>> -		break;
>> -	}
>> -	return AE_ERROR;
>> -}
>> -
>> -static acpi_status count_resource(struct acpi_resource *acpi_res, void *data)
>> +static void validate_resources(struct device *dev, struct list_head *crs_res,
>> +			       unsigned long type)
>>  {
>> -	struct pci_root_info *info = data;
>> -	struct acpi_resource_address64 addr;
>> -	acpi_status status;
>> -
>> -	status = resource_to_addr(acpi_res, &addr);
>> -	if (ACPI_SUCCESS(status))
>> -		info->res_num++;
>> -	return AE_OK;
>> -}
>> -
>> -static acpi_status setup_resource(struct acpi_resource *acpi_res, void *data)
>> -{
>> -	struct pci_root_info *info = data;
>> -	struct resource *res;
>> -	struct acpi_resource_address64 addr;
>> -	acpi_status status;
>> -	unsigned long flags;
>> -	u64 start, orig_end, end;
>> -
>> -	status = resource_to_addr(acpi_res, &addr);
>> -	if (!ACPI_SUCCESS(status))
>> -		return AE_OK;
>> -
>> -	if (addr.resource_type == ACPI_MEMORY_RANGE) {
>> -		flags = IORESOURCE_MEM;
>> -		if (addr.info.mem.caching == ACPI_PREFETCHABLE_MEMORY)
>> -			flags |= IORESOURCE_PREFETCH;
>> -	} else if (addr.resource_type == ACPI_IO_RANGE) {
>> -		flags = IORESOURCE_IO;
>> -	} else
>> -		return AE_OK;
>> -
>> -	start = addr.address.minimum + addr.address.translation_offset;
>> -	orig_end = end = addr.address.maximum + addr.address.translation_offset;
>> -
>> -	/* Exclude non-addressable range or non-addressable portion of range */
>> -	end = min(end, (u64)iomem_resource.end);
>> -	if (end <= start) {
>> -		dev_info(&info->bridge->dev,
>> -			"host bridge window [%#llx-%#llx] "
>> -			"(ignored, not CPU addressable)\n", start, orig_end);
>> -		return AE_OK;
>> -	} else if (orig_end != end) {
>> -		dev_info(&info->bridge->dev,
>> -			"host bridge window [%#llx-%#llx] "
>> -			"([%#llx-%#llx] ignored, not CPU addressable)\n", 
>> -			start, orig_end, end + 1, orig_end);
>> -	}
>> +	LIST_HEAD(list);
>> +	struct resource *res1, *res2, *root = NULL;
>> +	struct resource_list_entry *tmp, *entry, *entry2;
>>  
>> -	res = &info->res[info->res_num];
>> -	res->name = info->name;
>> -	res->flags = flags;
>> -	res->start = start;
>> -	res->end = end;
>> -	info->res_offset[info->res_num] = addr.address.translation_offset;
>> -	info->res_num++;
>> +	BUG_ON((type & (IORESOURCE_MEM | IORESOURCE_IO)) == 0);
>> +	root = (type & IORESOURCE_MEM) ? &iomem_resource : &ioport_resource;
>>  
>> -	if (!pci_use_crs)
>> -		dev_printk(KERN_DEBUG, &info->bridge->dev,
>> -			   "host bridge window %pR (ignored)\n", res);
>> +	list_splice_init(crs_res, &list);
>> +	resource_list_for_each_entry_safe(entry, tmp, &list) {
>> +		bool free = false;
>> +		resource_size_t end;
>>  
>> -	return AE_OK;
>> -}
>> -
>> -static void coalesce_windows(struct pci_root_info *info, unsigned long type)
>> -{
>> -	int i, j;
>> -	struct resource *res1, *res2;
>> -
>> -	for (i = 0; i < info->res_num; i++) {
>> -		res1 = &info->res[i];
>> +		res1 = entry->res;
>>  		if (!(res1->flags & type))
>> -			continue;
>> +			goto next;
>> +
>> +		/* Exclude non-addressable range or non-addressable portion */
>> +		end = min(res1->end, root->end);
>> +		if (end <= res1->start) {
>> +			dev_info(dev, "host bridge window [%#llx-%#llx] (ignored, not CPU addressable)\n",
>> +				 (unsigned long long)res1->start,
>> +				 (unsigned long long)res1->end);
>> +			free = true;
>> +			goto next;
>> +		} else if (res1->end != end) {
>> +			dev_info(dev, "host bridge window [%#llx-%#llx] ([%#llx-%#llx] ignored, not CPU addressable)\n",
>> +				 (unsigned long long)res1->start,
>> +				 (unsigned long long)res1->end,
>> +				 (unsigned long long)end + 1,
>> +				 (unsigned long long)res1->end);
>> +			res1->end = end;
>> +		}
>>  
>> -		for (j = i + 1; j < info->res_num; j++) {
>> -			res2 = &info->res[j];
>> +		resource_list_for_each_entry(entry2, crs_res) {
>> +			res2 = entry2->res;
>>  			if (!(res2->flags & type))
>>  				continue;
>>  
>> @@ -353,118 +264,92 @@ static void coalesce_windows(struct pci_root_info *info, unsigned long type)
>>  			if (resource_overlaps(res1, res2)) {
>>  				res2->start = min(res1->start, res2->start);
>>  				res2->end = max(res1->end, res2->end);
>> -				dev_info(&info->bridge->dev,
>> -					 "host bridge window expanded to %pR; %pR ignored\n",
>> +				dev_info(dev, "host bridge window expanded to %pR; %pR ignored\n",
>>  					 res2, res1);
>> -				res1->flags = 0;
>> +				free = true;
>> +				goto next;
>>  			}
>>  		}
>> +
>> +next:
>> +		resource_list_del(entry);
>> +		if (free)
>> +			resource_list_free_entry(entry);
>> +		else
>> +			resource_list_add_tail(entry, crs_res);
>>  	}
>>  }
>>  
>>  static void add_resources(struct pci_root_info *info,
>> -			  struct list_head *resources)
>> +			  struct list_head *resources,
>> +			  struct list_head *crs_res)
>>  {
>> -	int i;
>> -	struct resource *res, *root, *conflict;
>> -
>> -	coalesce_windows(info, IORESOURCE_MEM);
>> -	coalesce_windows(info, IORESOURCE_IO);
>> +	struct resource_list_entry *entry, *tmp;
>> +	struct resource *res, *conflict, *root = NULL;
>>  
>> -	for (i = 0; i < info->res_num; i++) {
>> -		res = &info->res[i];
>> +	validate_resources(&info->bridge->dev, crs_res, IORESOURCE_MEM);
>> +	validate_resources(&info->bridge->dev, crs_res, IORESOURCE_IO);
>>  
>> +	resource_list_for_each_entry_safe(entry, tmp, crs_res) {
>> +		res = entry->res;
>>  		if (res->flags & IORESOURCE_MEM)
>>  			root = &iomem_resource;
>>  		else if (res->flags & IORESOURCE_IO)
>>  			root = &ioport_resource;
>>  		else
>> -			continue;
>> +			BUG_ON(res);
>>  
>>  		conflict = insert_resource_conflict(root, res);
>> -		if (conflict)
>> +		if (conflict) {
>>  			dev_info(&info->bridge->dev,
>>  				 "ignoring host bridge window %pR (conflicts with %s %pR)\n",
>>  				 res, conflict->name, conflict);
>> -		else
>> -			pci_add_resource_offset(resources, res,
>> -					info->res_offset[i]);
>> +			resource_list_destroy_entry(entry);
>> +		}
>>  	}
>> -}
>>  
>> -static void free_pci_root_info_res(struct pci_root_info *info)
>> -{
>> -	kfree(info->res);
>> -	info->res = NULL;
>> -	kfree(info->res_offset);
>> -	info->res_offset = NULL;
>> -	info->res_num = 0;
>> +	list_splice_tail(crs_res, resources);
>>  }
>>  
>> -static void __release_pci_root_info(struct pci_root_info *info)
>> +static void release_pci_root_info(struct pci_host_bridge *bridge)
>>  {
>> -	int i;
>>  	struct resource *res;
>> +	struct resource_list_entry *entry;
>> +	struct pci_root_info *info = bridge->release_data;
>>  
>> -	for (i = 0; i < info->res_num; i++) {
>> -		res = &info->res[i];
>> -
>> -		if (!res->parent)
>> -			continue;
>> -
>> -		if (!(res->flags & (IORESOURCE_MEM | IORESOURCE_IO)))
>> -			continue;
>> -
>> -		release_resource(res);
>> +	resource_list_for_each_entry(entry, &bridge->windows) {
>> +		res = entry->res;
>> +		if (res->parent &&
>> +		    (res->flags & (IORESOURCE_MEM | IORESOURCE_IO)))
>> +			release_resource(res);
>>  	}
>>  
>> -	free_pci_root_info_res(info);
>> -
>>  	teardown_mcfg_map(info);
>> -
>>  	kfree(info);
>>  }
>>  
>> -static void release_pci_root_info(struct pci_host_bridge *bridge)
>> -{
>> -	struct pci_root_info *info = bridge->release_data;
>> -
>> -	__release_pci_root_info(info);
>> -}
>> -
>>  static void probe_pci_root_info(struct pci_root_info *info,
>>  				struct acpi_device *device,
>> -				int busnum, int domain)
>> +				int busnum, int domain,
>> +				struct list_head *list)
>>  {
>> -	size_t size;
>> +	int ret;
>> +	struct resource_list_entry *entry;
>>  
>>  	sprintf(info->name, "PCI Bus %04x:%02x", domain, busnum);
>>  	info->bridge = device;
>> -
>> -	info->res_num = 0;
>> -	acpi_walk_resources(device->handle, METHOD_NAME__CRS, count_resource,
>> -				info);
>> -	if (!info->res_num)
>> -		return;
>> -
>> -	size = sizeof(*info->res) * info->res_num;
>> -	info->res = kzalloc_node(size, GFP_KERNEL, info->sd.node);
>> -	if (!info->res) {
>> -		info->res_num = 0;
>> -		return;
>> -	}
>> -
>> -	size = sizeof(*info->res_offset) * info->res_num;
>> -	info->res_num = 0;
>> -	info->res_offset = kzalloc_node(size, GFP_KERNEL, info->sd.node);
>> -	if (!info->res_offset) {
>> -		kfree(info->res);
>> -		info->res = NULL;
>> -		return;
>> -	}
>> -
>> -	acpi_walk_resources(device->handle, METHOD_NAME__CRS, setup_resource,
>> -				info);
>> +	ret = acpi_dev_get_resources(device, list,
>> +				     acpi_dev_filter_resource_type_cb,
>> +				     (void *)(IORESOURCE_IO | IORESOURCE_MEM));
>> +	if (ret < 0)
>> +		dev_warn(&device->dev,
>> +			 "failed to parse _CRS method, error code %d.\n", ret);
>> +	else if (ret == 0)
>> +		dev_dbg(&device->dev,
>> +			"no IO and memory resources present in _CRS.\n");
>> +	else
>> +		resource_list_for_each_entry(entry, list)
>> +			entry->res->name = info->name;
>>  }
>>  
>>  struct pci_bus *pci_acpi_scan_root(struct acpi_pci_root *root)
>> @@ -473,6 +358,8 @@ struct pci_bus *pci_acpi_scan_root(struct acpi_pci_root *root)
>>  	struct pci_root_info *info;
>>  	int domain = root->segment;
>>  	int busnum = root->secondary.start;
>> +	struct resource_list_entry *res_entry;
>> +	LIST_HEAD(crs_res);
>>  	LIST_HEAD(resources);
>>  	struct pci_bus *bus;
>>  	struct pci_sysdata *sd;
>> @@ -520,18 +407,22 @@ struct pci_bus *pci_acpi_scan_root(struct acpi_pci_root *root)
>>  		memcpy(bus->sysdata, sd, sizeof(*sd));
>>  		kfree(info);
>>  	} else {
>> -		probe_pci_root_info(info, device, busnum, domain);
>> -
>>  		/* insert busn res at first */
>>  		pci_add_resource(&resources,  &root->secondary);
>> +
>>  		/*
>>  		 * _CRS with no apertures is normal, so only fall back to
>>  		 * defaults or native bridge info if we're ignoring _CRS.
>>  		 */
>> -		if (pci_use_crs)
>> -			add_resources(info, &resources);
>> -		else {
>> -			free_pci_root_info_res(info);
>> +		probe_pci_root_info(info, device, busnum, domain, &crs_res);
>> +		if (pci_use_crs) {
>> +			add_resources(info, &resources, &crs_res);
>> +		} else {
>> +			resource_list_for_each_entry(res_entry, &crs_res)
>> +				dev_printk(KERN_DEBUG, &device->dev,
>> +					   "host bridge window %pR (ignored)\n",
>> +					   res_entry->res);
>> +			resource_list_free(&crs_res);
>>  			x86_pci_root_bus_resources(busnum, &resources);
>>  		}
>>  
>> @@ -546,8 +437,9 @@ struct pci_bus *pci_acpi_scan_root(struct acpi_pci_root *root)
>>  				to_pci_host_bridge(bus->bridge),
>>  				release_pci_root_info, info);
>>  		} else {
>> -			pci_free_resource_list(&resources);
>> -			__release_pci_root_info(info);
>> +			resource_list_free(&resources);
>> +			teardown_mcfg_map(info);
>> +			kfree(info);
>>  		}
>>  	}
>>  
>> -- 
>> 1.7.10.4
>>
