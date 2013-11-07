Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027Ab3KGSHW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 13:07:22 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:63213 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752674Ab3KGSHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 13:07:18 -0500
Date: Thu, 7 Nov 2013 11:07:13 -0700
From: Bjorn Helgaas <bhelgaas@google.com>
To: Yijing Wang <wangyijing@huawei.com>
Cc: Joerg Roedel <joro@8bytes.org>, linux-pci@vger.kernel.org,
        David Woodhouse <dwmw2@infradead.org>,
        Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>, dmaengine@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Hanjun Guo <guohanjun@huawei.com>
Subject: Re: [PATCH 1/1] IOMMU: Save pci device id instead of pci_dev*
 pointer for DMAR devices
Message-ID: <20131107180713.GA2955@google.com>
References: <1383639898-48776-1-git-send-email-wangyijing@huawei.com>
 <1383639898-48776-2-git-send-email-wangyijing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383639898-48776-2-git-send-email-wangyijing@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 05, 2013 at 04:24:58PM +0800, Yijing Wang wrote:
> Currently, DMAR driver save target pci devices pointers for drhd/rmrr/atsr
> in (pci_dev *) array. This is not safe, because pci devices maybe
> hot added or removed during system running. They will have new pci_dev *
> pointer. So if there have two IOMMUs or more in system, these devices
> will find a wrong drhd during DMA mapping. And DMAR faults will occur.
> This patch save pci device id insted of (pci_dev *) to fix this issue,
> Because DMAR table just provide pci device id under a specific IOMMU,
> so there is no reason to bind IOMMU with the (pci_dev *). Other, here
> use list to manage devices' id for IOMMU, we can easily use list helper
> to manage device id.
> 
> after remove and rescan a pci device
> [  611.857095] dmar: DRHD: handling fault status reg 2
> [  611.857109] dmar: DMAR:[DMA Read] Request device [86:00.3] fault addr ffff7000
> [  611.857109] DMAR:[fault reason 02] Present bit in context entry is clear
> [  611.857524] dmar: DRHD: handling fault status reg 102
> [  611.857534] dmar: DMAR:[DMA Read] Request device [86:00.3] fault addr ffff6000
> [  611.857534] DMAR:[fault reason 02] Present bit in context entry is clear
> [  611.857936] dmar: DRHD: handling fault status reg 202
> [  611.857947] dmar: DMAR:[DMA Read] Request device [86:00.3] fault addr ffff5000
> [  611.857947] DMAR:[fault reason 02] Present bit in context entry is clear
> [  611.858351] dmar: DRHD: handling fault status reg 302
> [  611.858362] dmar: DMAR:[DMA Read] Request device [86:00.3] fault addr ffff4000
> [  611.858362] DMAR:[fault reason 02] Present bit in context entry is clear
> [  611.860819] IPv6: ADDRCONF(NETDEV_UP): eth3: link is not ready
> [  611.860983] dmar: DRHD: handling fault status reg 402
> [  611.860995] dmar: INTR-REMAP: Request device [[86:00.3] fault index a4
> [  611.860995] INTR-REMAP:[fault reason 34] Present field in the IRTE entry is clear
> 
> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
> ---
>  drivers/iommu/dmar.c        |   93 +++++++++++++-------------
>  drivers/iommu/intel-iommu.c |  155 ++++++++++++++++++++++++++++---------------
>  include/linux/dmar.h        |   20 ++++--
>  3 files changed, 159 insertions(+), 109 deletions(-)
> 
> diff --git a/drivers/iommu/dmar.c b/drivers/iommu/dmar.c
> index 785675a..9aa65a3 100644
> --- a/drivers/iommu/dmar.c
> +++ b/drivers/iommu/dmar.c
> @@ -65,12 +65,13 @@ static void __init dmar_register_drhd_unit(struct dmar_drhd_unit *drhd)
>  }
>  
>  static int __init dmar_parse_one_dev_scope(struct acpi_dmar_device_scope *scope,
> -					   struct pci_dev **dev, u16 segment)
> +					    u16 segment, struct list_head *head)
>  {
>  	struct pci_bus *bus;
>  	struct pci_dev *pdev = NULL;
>  	struct acpi_dmar_pci_path *path;
>  	int count;
> +	struct dmar_device *dmar_dev;
>  
>  	bus = pci_find_bus(segment, scope->bus);
>  	path = (struct acpi_dmar_pci_path *)(scope + 1);
> @@ -100,7 +101,6 @@ static int __init dmar_parse_one_dev_scope(struct acpi_dmar_device_scope *scope,
>  	if (!pdev) {
>  		pr_warn("Device scope device [%04x:%02x:%02x.%02x] not found\n",
>  			segment, scope->bus, path->dev, path->fn);
> -		*dev = NULL;
>  		return 0;
>  	}
>  	if ((scope->entry_type == ACPI_DMAR_SCOPE_TYPE_ENDPOINT && \
> @@ -111,54 +111,39 @@ static int __init dmar_parse_one_dev_scope(struct acpi_dmar_device_scope *scope,
>  			pci_name(pdev));
>  		return -EINVAL;
>  	}
> -	*dev = pdev;
> +
> +	dmar_dev = kzalloc(sizeof(struct dmar_device), GFP_KERNEL);
> +	if (!dmar_dev) {
> +		pci_dev_put(pdev);
> +		return -ENOMEM;
> +	}
> +
> +	dmar_dev->segment = segment;
> +	dmar_dev->bus = pdev->bus->number;
> +	dmar_dev->devfn = pdev->devfn;
> +	list_add_tail(&dmar_dev->list, head);
> +
> +	pci_dev_put(pdev);
>  	return 0;
>  }
>  
> -int __init dmar_parse_dev_scope(void *start, void *end, int *cnt,
> -				struct pci_dev ***devices, u16 segment)
> +int __init dmar_parse_dev_scope(void *start, void *end, u16 segment, 
> +	struct list_head *head)
>  {
>  	struct acpi_dmar_device_scope *scope;
> -	void * tmp = start;
> -	int index;
>  	int ret;
>  
> -	*cnt = 0;
> -	while (start < end) {
> -		scope = start;
> -		if (scope->entry_type == ACPI_DMAR_SCOPE_TYPE_ENDPOINT ||
> -		    scope->entry_type == ACPI_DMAR_SCOPE_TYPE_BRIDGE)
> -			(*cnt)++;
> -		else if (scope->entry_type != ACPI_DMAR_SCOPE_TYPE_IOAPIC &&
> -			scope->entry_type != ACPI_DMAR_SCOPE_TYPE_HPET) {
> -			pr_warn("Unsupported device scope\n");
> -		}
> -		start += scope->length;
> -	}
> -	if (*cnt == 0)
> -		return 0;
> -
> -	*devices = kcalloc(*cnt, sizeof(struct pci_dev *), GFP_KERNEL);
> -	if (!*devices)
> -		return -ENOMEM;
> -
> -	start = tmp;
> -	index = 0;
>  	while (start < end) {
>  		scope = start;
>  		if (scope->entry_type == ACPI_DMAR_SCOPE_TYPE_ENDPOINT ||
>  		    scope->entry_type == ACPI_DMAR_SCOPE_TYPE_BRIDGE) {
> -			ret = dmar_parse_one_dev_scope(scope,
> -				&(*devices)[index], segment);
> -			if (ret) {
> -				kfree(*devices);
> +			ret = dmar_parse_one_dev_scope(scope, segment, head);
> +			if (ret)
>  				return ret;
> -			}
> -			index ++;
>  		}
>  		start += scope->length;
>  	}
> -
> +    
>  	return 0;
>  }
>  
> @@ -183,6 +168,7 @@ dmar_parse_one_drhd(struct acpi_dmar_header *header)
>  	dmaru->reg_base_addr = drhd->address;
>  	dmaru->segment = drhd->segment;
>  	dmaru->include_all = drhd->flags & 0x1; /* BIT0: INCLUDE_ALL */
> +	INIT_LIST_HEAD(&dmaru->head);
>  
>  	ret = alloc_iommu(dmaru);
>  	if (ret) {
> @@ -193,6 +179,19 @@ dmar_parse_one_drhd(struct acpi_dmar_header *header)
>  	return 0;
>  }
>  
> +static void drhd_free(struct dmar_drhd_unit *dmaru)
> +{
> +	struct dmar_device *dev, *tmp;
> +
> +	list_for_each_entry_safe(dev, tmp, &dmaru->head,
> +	    list) {
> +		list_del(&dev->list);
> +		kfree(dev);
> +	}
> +
> +	kfree(dmaru);
> +}
> +
>  static int __init dmar_parse_dev(struct dmar_drhd_unit *dmaru)
>  {
>  	struct acpi_dmar_hardware_unit *drhd;
> @@ -205,11 +204,10 @@ static int __init dmar_parse_dev(struct dmar_drhd_unit *dmaru)
>  
>  	ret = dmar_parse_dev_scope((void *)(drhd + 1),
>  				((void *)drhd) + drhd->header.length,
> -				&dmaru->devices_cnt, &dmaru->devices,
> -				drhd->segment);
> +				drhd->segment, &dmaru->head);
>  	if (ret) {
>  		list_del(&dmaru->list);
> -		kfree(dmaru);
> +		drhd_free(dmaru);
>  	}
>  	return ret;
>  }
> @@ -378,16 +376,18 @@ parse_dmar_table(void)
>  	return ret;
>  }
>  
> -static int dmar_pci_device_match(struct pci_dev *devices[], int cnt,
> -			  struct pci_dev *dev)
> +static int dmar_pci_device_match(struct pci_dev *dev, 
> +	struct list_head *head)
>  {
> -	int index;
> +	struct dmar_device *dmar_dev;
>  
>  	while (dev) {
> -		for (index = 0; index < cnt; index++)
> -			if (dev == devices[index])
> -				return 1;
> -
> +		list_for_each_entry(dmar_dev, head, list)
> +		    if (dmar_dev->segment == pci_domain_nr(dev->bus)
> +			    && dmar_dev->bus == dev->bus->number
> +			    && dmar_dev->devfn == dev->devfn)
> +			return 1;
> +		
>  		/* Check our parent */
>  		dev = dev->bus->self;

You didn't change this, but it looks like this may have the same problem
we've been talking about here:

http://lkml.kernel.org/r/20131105232903.3790.8738.stgit@bhelgaas-glaptop.roam.corp.google.com

Namely, if "dev" is a VF on a virtual bus, "dev->bus->self == NULL", so
we won't search for any of the bridges leading to the VF.  I proposed a
pci_upstream_bridge() interface that could be used like this:

	/* Check our parent */
	dev = pci_upstream_bridge(dev);

>  	}
> @@ -412,8 +412,7 @@ dmar_find_matched_drhd_unit(struct pci_dev *dev)
>  		    drhd->segment == pci_domain_nr(dev->bus))
>  			return dmaru;
>  
> -		if (dmar_pci_device_match(dmaru->devices,
> -					  dmaru->devices_cnt, dev))
> +		if (dmar_pci_device_match(dev, &dmaru->head))
>  			return dmaru;
>  	}
>  
> diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
> index 15e9b57..b33fe0e 100644
> --- a/drivers/iommu/intel-iommu.c
> +++ b/drivers/iommu/intel-iommu.c
> @@ -650,7 +650,8 @@ static void domain_update_iommu_cap(struct dmar_domain *domain)
>  static struct intel_iommu *device_to_iommu(int segment, u8 bus, u8 devfn)
>  {
>  	struct dmar_drhd_unit *drhd = NULL;
> -	int i;
> +	struct dmar_device *dmar_dev;
> +	struct pci_dev *pdev;
>  
>  	for_each_drhd_unit(drhd) {
>  		if (drhd->ignored)
> @@ -658,16 +659,22 @@ static struct intel_iommu *device_to_iommu(int segment, u8 bus, u8 devfn)
>  		if (segment != drhd->segment)
>  			continue;
>  
> -		for (i = 0; i < drhd->devices_cnt; i++) {
> -			if (drhd->devices[i] &&
> -			    drhd->devices[i]->bus->number == bus &&
> -			    drhd->devices[i]->devfn == devfn)
> -				return drhd->iommu;
> -			if (drhd->devices[i] &&
> -			    drhd->devices[i]->subordinate &&
> -			    drhd->devices[i]->subordinate->number <= bus &&
> -			    drhd->devices[i]->subordinate->busn_res.end >= bus)
> -				return drhd->iommu;
> +		list_for_each_entry(dmar_dev, &drhd->head, list) {
> +		    if (dmar_dev->bus == bus && 
> +			    dmar_dev->devfn == devfn)
> +			return drhd->iommu;
> +
> +		    pdev = pci_get_domain_bus_and_slot(dmar_dev->segment, 
> +			    dmar_dev->bus, dmar_dev->devfn);
> +		    if (pdev->subordinate && 
> +			    pdev->subordinate->number <= bus &&
> +			    pdev->subordinate->busn_res.end >= bus) {
> +			pci_dev_put(pdev);
> +			return drhd->iommu;

I don't know the details of how device_to_iommu() is used, but this
style (acquire ref to pci_dev, match it to some other object, drop
pci_dev ref, return object) makes me nervous.  How do we know the
caller isn't depending on pci_dev to remain attached to the object?
What happens if the pci_dev disappears when we do the pci_dev_put()
here?

> +		    }
> +
> +		    if (pdev)
> +			pci_dev_put(pdev);
>  		}
>  
>  		if (drhd->include_all)
> @@ -2331,18 +2338,20 @@ static int domain_add_dev_info(struct dmar_domain *domain,
>  static bool device_has_rmrr(struct pci_dev *dev)
>  {
>  	struct dmar_rmrr_unit *rmrr;
> -	int i;
> +	struct dmar_device *dmar_dev;
>  
>  	for_each_rmrr_units(rmrr) {
> -		for (i = 0; i < rmrr->devices_cnt; i++) {
> -			/*
> -			 * Return TRUE if this RMRR contains the device that
> -			 * is passed in.
> -			 */
> -			if (rmrr->devices[i] == dev)
> -				return true;
> -		}
> +	    list_for_each_entry(dmar_dev, &rmrr->head, list)
> +		/*
> +		 * Return TRUE if this RMRR contains the device that
> +		 * is passed in.
> +		 */
> +	if (dmar_dev->segment == pci_domain_nr(dev->bus) && 
> +			dmar_dev->bus == dev->bus->number && 
> +			dmar_dev->devfn == dev->devfn)
> +		return true;
>  	}
> +	
>  	return false;
>  }
>  
> @@ -2451,7 +2460,7 @@ static int __init init_dmars(void)
>  	struct dmar_rmrr_unit *rmrr;
>  	struct pci_dev *pdev;
>  	struct intel_iommu *iommu;
> -	int i, ret;
> +	int ret;
>  
>  	/*
>  	 * for each drhd
> @@ -2605,8 +2614,10 @@ static int __init init_dmars(void)
>  	 */
>  	printk(KERN_INFO "IOMMU: Setting RMRR:\n");
>  	for_each_rmrr_units(rmrr) {
> -		for (i = 0; i < rmrr->devices_cnt; i++) {
> -			pdev = rmrr->devices[i];
> +		struct dmar_device *dmar_dev;
> +	    list_for_each_entry(dmar_dev, &rmrr->head, list) {
> +			pdev = pci_get_domain_bus_and_slot(dmar_dev->segment, 
> +					dmar_dev->bus, dmar_dev->devfn);
>  			/*
>  			 * some BIOS lists non-exist devices in DMAR
>  			 * table.
> @@ -2615,9 +2626,11 @@ static int __init init_dmars(void)
>  				continue;
>  			ret = iommu_prepare_rmrr_dev(rmrr, pdev);
>  			if (ret)
> -				printk(KERN_ERR
> -				       "IOMMU: mapping reserved region failed\n");
> -		}
> +				printk(KERN_ERR 
> +					"IOMMU: mapping reserved region failed\n");
> +		
> +			pci_dev_put(pdev);
> +	    }
>  	}
>  
>  	iommu_prepare_isa();
> @@ -3301,30 +3314,30 @@ DECLARE_PCI_FIXUP_ENABLE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_IOAT_SNB, quir
>  static void __init init_no_remapping_devices(void)
>  {
>  	struct dmar_drhd_unit *drhd;
> +	struct dmar_device *dmar_dev;
> +	struct pci_dev *pdev = NULL;
>  
> -	for_each_drhd_unit(drhd) {
> -		if (!drhd->include_all) {
> -			int i;
> -			for (i = 0; i < drhd->devices_cnt; i++)
> -				if (drhd->devices[i] != NULL)
> -					break;
> +	for_each_drhd_unit(drhd) 
> +		if (!drhd->include_all) 
>  			/* ignore DMAR unit if no pci devices exist */
> -			if (i == drhd->devices_cnt)
> +			if (list_empty(&drhd->head))
>  				drhd->ignored = 1;
> -		}
> -	}
> -
> +	
>  	for_each_drhd_unit(drhd) {
> -		int i;
>  		if (drhd->ignored || drhd->include_all)
>  			continue;
>  
> -		for (i = 0; i < drhd->devices_cnt; i++)
> -			if (drhd->devices[i] &&
> -			    !IS_GFX_DEVICE(drhd->devices[i]))
> +		list_for_each_entry(dmar_dev, &drhd->head, list) {
> +			pdev = pci_get_domain_bus_and_slot(dmar_dev->segment,
> +				dmar_dev->bus, dmar_dev->devfn);
> +			if (!IS_GFX_DEVICE(pdev)) {
> +				pci_dev_put(pdev);
>  				break;
> +			}
> +			pci_dev_put(pdev);
> +		}
>  
> -		if (i < drhd->devices_cnt)
> +		if (!IS_GFX_DEVICE(pdev))

I think this is clearly wrong.  You acquire a pdev reference, drop the
reference, then look at pdev again after dropping the reference.  But
as soon as you do the pci_dev_put(), you have to assume pdev is no
longer valid.

>  			continue;
>  
>  		/* This IOMMU has *only* gfx devices. Either bypass it or
> @@ -3333,10 +3346,15 @@ static void __init init_no_remapping_devices(void)
>  			intel_iommu_gfx_mapped = 1;
>  		} else {
>  			drhd->ignored = 1;
> -			for (i = 0; i < drhd->devices_cnt; i++) {
> -				if (!drhd->devices[i])
> +			list_for_each_entry(dmar_dev, &drhd->head, list) {
> +				pdev = pci_get_domain_bus_and_slot(
> +						dmar_dev->segment, 
> +						dmar_dev->bus, 
> +						dmar_dev->devfn);
> +				if (!pdev)
>  					continue;
> -				drhd->devices[i]->dev.archdata.iommu = DUMMY_DEVICE_DOMAIN_INFO;
> +				pdev->dev.archdata.iommu = DUMMY_DEVICE_DOMAIN_INFO;
> +				pci_dev_put(pdev);
>  			}
>  		}
>  	}
> @@ -3501,11 +3519,25 @@ int __init dmar_parse_one_rmrr(struct acpi_dmar_header *header)
>  	rmrr = (struct acpi_dmar_reserved_memory *)header;
>  	rmrru->base_address = rmrr->base_address;
>  	rmrru->end_address = rmrr->end_address;
> +	INIT_LIST_HEAD(&rmrru->head);
>  
>  	dmar_register_rmrr_unit(rmrru);
>  	return 0;
>  }
>  
> +static void rmrr_free(struct dmar_rmrr_unit *rmrru) 
> +{
> +	struct dmar_device *dev, *tmp;
> +
> +	list_for_each_entry_safe(dev, tmp, &rmrru->head,
> +	    list) {
> +		list_del(&dev->list);
> +		kfree(dev);
> +	}
> +    
> +	kfree(rmrru);
> +}
> +
>  static int __init
>  rmrr_parse_dev(struct dmar_rmrr_unit *rmrru)
>  {
> @@ -3515,11 +3547,11 @@ rmrr_parse_dev(struct dmar_rmrr_unit *rmrru)
>  	rmrr = (struct acpi_dmar_reserved_memory *) rmrru->hdr;
>  	ret = dmar_parse_dev_scope((void *)(rmrr + 1),
>  		((void *)rmrr) + rmrr->header.length,
> -		&rmrru->devices_cnt, &rmrru->devices, rmrr->segment);
> +		rmrr->segment, &rmrru->head);
>  
> -	if (ret || (rmrru->devices_cnt == 0)) {
> +	if (ret || list_empty(&rmrru->head)) {
>  		list_del(&rmrru->list);
> -		kfree(rmrru);
> +		rmrr_free(rmrru);
>  	}
>  	return ret;
>  }
> @@ -3538,12 +3570,25 @@ int __init dmar_parse_one_atsr(struct acpi_dmar_header *hdr)
>  
>  	atsru->hdr = hdr;
>  	atsru->include_all = atsr->flags & 0x1;
> +	INIT_LIST_HEAD(&atsru->head);
>  
>  	list_add(&atsru->list, &dmar_atsr_units);
>  
>  	return 0;
>  }
>  
> +static void atsr_free(struct dmar_atsr_unit *atsr) 
> +{
> +	struct dmar_device *dev, *tmp;
> +    
> +	list_for_each_entry_safe(dev, tmp, &atsr->head, list) {
> +		list_del(&dev->list);
> +		kfree(dev);
> +	}
> +
> +	kfree(atsr);
> +}
> +
>  static int __init atsr_parse_dev(struct dmar_atsr_unit *atsru)
>  {
>  	int rc;
> @@ -3555,11 +3600,10 @@ static int __init atsr_parse_dev(struct dmar_atsr_unit *atsru)
>  	atsr = container_of(atsru->hdr, struct acpi_dmar_atsr, header);
>  	rc = dmar_parse_dev_scope((void *)(atsr + 1),
>  				(void *)atsr + atsr->header.length,
> -				&atsru->devices_cnt, &atsru->devices,
> -				atsr->segment);
> -	if (rc || !atsru->devices_cnt) {
> +				atsr->segment, &atsru->head);
> +	if (rc || list_empty(&atsru->head)) {
>  		list_del(&atsru->list);
> -		kfree(atsru);
> +		atsr_free(atsru);
>  	}
>  
>  	return rc;
> @@ -3567,7 +3611,6 @@ static int __init atsr_parse_dev(struct dmar_atsr_unit *atsru)
>  
>  int dmar_find_matched_atsr_unit(struct pci_dev *dev)
>  {
> -	int i;
>  	struct pci_bus *bus;
>  	struct acpi_dmar_atsr *atsr;
>  	struct dmar_atsr_unit *atsru;
> @@ -3584,6 +3627,7 @@ int dmar_find_matched_atsr_unit(struct pci_dev *dev)
>  
>  found:
>  	for (bus = dev->bus; bus; bus = bus->parent) {
> +		struct dmar_device *dmar_dev;
>  		struct pci_dev *bridge = bus->self;
>  
>  		if (!bridge || !pci_is_pcie(bridge) ||
> @@ -3591,8 +3635,11 @@ found:
>  			return 0;
>  
>  		if (pci_pcie_type(bridge) == PCI_EXP_TYPE_ROOT_PORT) {
> -			for (i = 0; i < atsru->devices_cnt; i++)
> -				if (atsru->devices[i] == bridge)
> +			list_for_each_entry(dmar_dev, &atsru->head, list)
> +				if (dmar_dev->segment == 
> +					pci_domain_nr(bridge->bus) && 
> +					dmar_dev->bus == bridge->bus->number &&
> +					dmar_dev->devfn == bridge->devfn)
>  					return 1;
>  			break;
>  		}
> diff --git a/include/linux/dmar.h b/include/linux/dmar.h
> index b029d1a..5317cb0 100644
> --- a/include/linux/dmar.h
> +++ b/include/linux/dmar.h
> @@ -32,6 +32,13 @@ struct acpi_dmar_header;
>  #define DMAR_INTR_REMAP		0x1
>  #define DMAR_X2APIC_OPT_OUT	0x2
>  
> +struct dmar_device {
> +	struct list_head list;
> +	u8 segment;

I think this should be u16.  I didn't chase down how you're using it,
but Table 8.3 in the Intel VT-d spec shows Segment Number in a DRHD
structure as 16 bits.

> +	u8 bus;
> +	u8 devfn;
> +};
> +
>  struct intel_iommu;
>  #ifdef CONFIG_DMAR_TABLE
>  extern struct acpi_table_header *dmar_tbl;
> @@ -39,8 +46,7 @@ struct dmar_drhd_unit {
>  	struct list_head list;		/* list of drhd units	*/
>  	struct  acpi_dmar_header *hdr;	/* ACPI header		*/
>  	u64	reg_base_addr;		/* register base address*/
> -	struct	pci_dev **devices; 	/* target device array	*/
> -	int	devices_cnt;		/* target device count	*/
> +	struct list_head head;	/* target devices' list */

s/devices'/device/ (also below).  This is not a contraction or a
possessive construct, so no apostrophe is needed.

>  	u16	segment;		/* PCI domain		*/
>  	u8	ignored:1; 		/* ignore drhd		*/
>  	u8	include_all:1;
> @@ -139,8 +145,7 @@ struct dmar_rmrr_unit {
>  	struct acpi_dmar_header *hdr;	/* ACPI header		*/
>  	u64	base_address;		/* reserved base address*/
>  	u64	end_address;		/* reserved end address */
> -	struct pci_dev **devices;	/* target devices */
> -	int	devices_cnt;		/* target device count */
> +	struct list_head head;	/* target devices' list */
>  };
>  
>  #define for_each_rmrr_units(rmrr) \
> @@ -149,16 +154,15 @@ struct dmar_rmrr_unit {
>  struct dmar_atsr_unit {
>  	struct list_head list;		/* list of ATSR units */
>  	struct acpi_dmar_header *hdr;	/* ACPI header */
> -	struct pci_dev **devices;	/* target devices */
> -	int devices_cnt;		/* target device count */
>  	u8 include_all:1;		/* include all ports */
> +	struct list_head head;	/* target devices' list */
>  };
>  
>  int dmar_parse_rmrr_atsr_dev(void);
>  extern int dmar_parse_one_rmrr(struct acpi_dmar_header *header);
>  extern int dmar_parse_one_atsr(struct acpi_dmar_header *header);
> -extern int dmar_parse_dev_scope(void *start, void *end, int *cnt,
> -				struct pci_dev ***devices, u16 segment);
> +extern int dmar_parse_dev_scope(void *start, void *end, u16 segment, 
> +				struct list_head *head);
>  extern int intel_iommu_init(void);
>  #else /* !CONFIG_INTEL_IOMMU: */
>  static inline int intel_iommu_init(void) { return -ENODEV; }
> -- 
> 1.7.1
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
