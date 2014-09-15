Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753137AbaIOBk6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 21:40:58 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:52953 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752939AbaIOBkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 21:40:55 -0400
Message-ID: <54164372.40806@huawei.com>
Date: Mon, 15 Sep 2014 09:40:02 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Jiang Liu <jiang.liu@linux.intel.com>, Joerg Roedel <joro@8bytes.org>,
        David Woodhouse <dwmw2@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        "Bjorn Helgaas" <bhelgaas@google.com>,
        Dan Williams <dan.j.williams@intel.com>,
        "Vinod Koul" <vinod.koul@intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>
CC: Ashok Raj <ashok.raj@intel.com>, Tony Luck <tony.luck@intel.com>,
        <iommu@lists.linux-foundation.org>, <linux-pci@vger.kernel.org>,
        <linux-hotplug@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <dmaengine@vger.kernel.org>
Subject: Re: [Patch Part3 V5 3/8] iommu/vt-d: Implement DMAR unit hotplug
 framework
References: <1410487848-6027-1-git-send-email-jiang.liu@linux.intel.com> <1410487848-6027-4-git-send-email-jiang.liu@linux.intel.com>
In-Reply-To: <1410487848-6027-4-git-send-email-jiang.liu@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.27.212]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/9/12 10:10, Jiang Liu wrote:
> On Intel platforms, an IO Hub (PCI/PCIe host bridge) may contain DMAR
> units, so we need to support DMAR hotplug when supporting PCI host
> bridge hotplug on Intel platforms.
> 
> According to Section 8.8 "Remapping Hardware Unit Hot Plug" in "Intel
> Virtualization Technology for Directed IO Architecture Specification
> Rev 2.2", ACPI BIOS should implement ACPI _DSM method under the ACPI
> object for the PCI host bridge to support DMAR hotplug.
> 
> This patch introduces interfaces to parse ACPI _DSM method for
> DMAR unit hotplug. It also implements state machines for DMAR unit
> hot-addition and hot-removal.
> 
> The PCI host bridge hotplug driver should call dmar_hotplug_hotplug()
> before scanning PCI devices connected for hot-addition and after
> destroying all PCI devices for hot-removal.
>

Reviewed-by: Yijing Wang <wangyijing@huawei.com>


> Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
> ---
>  drivers/iommu/dmar.c                |  268 +++++++++++++++++++++++++++++++++--
>  drivers/iommu/intel-iommu.c         |   78 +++++++++-
>  drivers/iommu/intel_irq_remapping.c |    5 +
>  include/linux/dmar.h                |   33 +++++
>  4 files changed, 370 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/iommu/dmar.c b/drivers/iommu/dmar.c
> index b3405c50627f..e77b5d3f2f5c 100644
> --- a/drivers/iommu/dmar.c
> +++ b/drivers/iommu/dmar.c
> @@ -75,7 +75,7 @@ static unsigned long dmar_seq_ids[BITS_TO_LONGS(DMAR_UNITS_SUPPORTED)];
>  static int alloc_iommu(struct dmar_drhd_unit *drhd);
>  static void free_iommu(struct intel_iommu *iommu);
>  
> -static void __init dmar_register_drhd_unit(struct dmar_drhd_unit *drhd)
> +static void dmar_register_drhd_unit(struct dmar_drhd_unit *drhd)
>  {
>  	/*
>  	 * add INCLUDE_ALL at the tail, so scan the list will find it at
> @@ -336,24 +336,45 @@ static struct notifier_block dmar_pci_bus_nb = {
>  	.priority = INT_MIN,
>  };
>  
> +static struct dmar_drhd_unit *
> +dmar_find_dmaru(struct acpi_dmar_hardware_unit *drhd)
> +{
> +	struct dmar_drhd_unit *dmaru;
> +
> +	list_for_each_entry_rcu(dmaru, &dmar_drhd_units, list)
> +		if (dmaru->segment == drhd->segment &&
> +		    dmaru->reg_base_addr == drhd->address)
> +			return dmaru;
> +
> +	return NULL;
> +}
> +
>  /**
>   * dmar_parse_one_drhd - parses exactly one DMA remapping hardware definition
>   * structure which uniquely represent one DMA remapping hardware unit
>   * present in the platform
>   */
> -static int __init
> -dmar_parse_one_drhd(struct acpi_dmar_header *header, void *arg)
> +static int dmar_parse_one_drhd(struct acpi_dmar_header *header, void *arg)
>  {
>  	struct acpi_dmar_hardware_unit *drhd;
>  	struct dmar_drhd_unit *dmaru;
>  	int ret = 0;
>  
>  	drhd = (struct acpi_dmar_hardware_unit *)header;
> -	dmaru = kzalloc(sizeof(*dmaru), GFP_KERNEL);
> +	dmaru = dmar_find_dmaru(drhd);
> +	if (dmaru)
> +		goto out;
> +
> +	dmaru = kzalloc(sizeof(*dmaru) + header->length, GFP_KERNEL);
>  	if (!dmaru)
>  		return -ENOMEM;
>  
> -	dmaru->hdr = header;
> +	/*
> +	 * If header is allocated from slab by ACPI _DSM method, we need to
> +	 * copy the content because the memory buffer will be freed on return.
> +	 */
> +	dmaru->hdr = (void *)(dmaru + 1);
> +	memcpy(dmaru->hdr, header, header->length);
>  	dmaru->reg_base_addr = drhd->address;
>  	dmaru->segment = drhd->segment;
>  	dmaru->include_all = drhd->flags & 0x1; /* BIT0: INCLUDE_ALL */
> @@ -374,6 +395,7 @@ dmar_parse_one_drhd(struct acpi_dmar_header *header, void *arg)
>  	}
>  	dmar_register_drhd_unit(dmaru);
>  
> +out:
>  	if (arg)
>  		(*(int *)arg)++;
>  
> @@ -411,8 +433,7 @@ static int __init dmar_parse_one_andd(struct acpi_dmar_header *header,
>  }
>  
>  #ifdef CONFIG_ACPI_NUMA
> -static int __init
> -dmar_parse_one_rhsa(struct acpi_dmar_header *header, void *arg)
> +static int dmar_parse_one_rhsa(struct acpi_dmar_header *header, void *arg)
>  {
>  	struct acpi_dmar_rhsa *rhsa;
>  	struct dmar_drhd_unit *drhd;
> @@ -805,14 +826,22 @@ dmar_validate_one_drhd(struct acpi_dmar_header *entry, void *arg)
>  		return -EINVAL;
>  	}
>  
> -	addr = early_ioremap(drhd->address, VTD_PAGE_SIZE);
> +	if (arg)
> +		addr = ioremap(drhd->address, VTD_PAGE_SIZE);
> +	else
> +		addr = early_ioremap(drhd->address, VTD_PAGE_SIZE);
>  	if (!addr) {
>  		pr_warn("IOMMU: can't validate: %llx\n", drhd->address);
>  		return -EINVAL;
>  	}
> +
>  	cap = dmar_readq(addr + DMAR_CAP_REG);
>  	ecap = dmar_readq(addr + DMAR_ECAP_REG);
> -	early_iounmap(addr, VTD_PAGE_SIZE);
> +
> +	if (arg)
> +		iounmap(addr);
> +	else
> +		early_iounmap(addr, VTD_PAGE_SIZE);
>  
>  	if (cap == (uint64_t)-1 && ecap == (uint64_t)-1) {
>  		warn_invalid_dmar(drhd->address, " returns all ones");
> @@ -1686,12 +1715,17 @@ int __init dmar_ir_support(void)
>  	return dmar->flags & 0x1;
>  }
>  
> +/* Check whether DMAR units are in use */
> +static inline bool dmar_in_use(void)
> +{
> +	return irq_remapping_enabled || intel_iommu_enabled;
> +}
> +
>  static int __init dmar_free_unused_resources(void)
>  {
>  	struct dmar_drhd_unit *dmaru, *dmaru_n;
>  
> -	/* DMAR units are in use */
> -	if (irq_remapping_enabled || intel_iommu_enabled)
> +	if (dmar_in_use())
>  		return 0;
>  
>  	if (dmar_dev_scope_status != 1 && !list_empty(&dmar_drhd_units))
> @@ -1709,3 +1743,215 @@ static int __init dmar_free_unused_resources(void)
>  
>  late_initcall(dmar_free_unused_resources);
>  IOMMU_INIT_POST(detect_intel_iommu);
> +
> +/*
> + * DMAR Hotplug Support
> + * For more details, please refer to Intel(R) Virtualization Technology
> + * for Directed-IO Architecture Specifiction, Rev 2.2, Section 8.8
> + * "Remapping Hardware Unit Hot Plug".
> + */
> +static u8 dmar_hp_uuid[] = {
> +	/* 0000 */    0xA6, 0xA3, 0xC1, 0xD8, 0x9B, 0xBE, 0x9B, 0x4C,
> +	/* 0008 */    0x91, 0xBF, 0xC3, 0xCB, 0x81, 0xFC, 0x5D, 0xAF
> +};
> +
> +/*
> + * Currently there's only one revision and BIOS will not check the revision id,
> + * so use 0 for safety.
> + */
> +#define	DMAR_DSM_REV_ID			0
> +#define	DMAR_DSM_FUNC_DRHD		1
> +#define	DMAR_DSM_FUNC_ATSR		2
> +#define	DMAR_DSM_FUNC_RHSA		3
> +
> +static inline bool dmar_detect_dsm(acpi_handle handle, int func)
> +{
> +	return acpi_check_dsm(handle, dmar_hp_uuid, DMAR_DSM_REV_ID, 1 << func);
> +}
> +
> +static int dmar_walk_dsm_resource(acpi_handle handle, int func,
> +				  dmar_res_handler_t handler, void *arg)
> +{
> +	int ret = -ENODEV;
> +	union acpi_object *obj;
> +	struct acpi_dmar_header *start;
> +	struct dmar_res_callback callback;
> +	static int res_type[] = {
> +		[DMAR_DSM_FUNC_DRHD] = ACPI_DMAR_TYPE_HARDWARE_UNIT,
> +		[DMAR_DSM_FUNC_ATSR] = ACPI_DMAR_TYPE_ROOT_ATS,
> +		[DMAR_DSM_FUNC_RHSA] = ACPI_DMAR_TYPE_HARDWARE_AFFINITY,
> +	};
> +
> +	if (!dmar_detect_dsm(handle, func))
> +		return 0;
> +
> +	obj = acpi_evaluate_dsm_typed(handle, dmar_hp_uuid, DMAR_DSM_REV_ID,
> +				      func, NULL, ACPI_TYPE_BUFFER);
> +	if (!obj)
> +		return -ENODEV;
> +
> +	memset(&callback, 0, sizeof(callback));
> +	callback.cb[res_type[func]] = handler;
> +	callback.arg[res_type[func]] = arg;
> +	start = (struct acpi_dmar_header *)obj->buffer.pointer;
> +	ret = dmar_walk_resources(start, obj->buffer.length, &callback);
> +
> +	ACPI_FREE(obj);
> +
> +	return ret;
> +}
> +
> +static int dmar_hp_add_drhd(struct acpi_dmar_header *header, void *arg)
> +{
> +	int ret;
> +	struct dmar_drhd_unit *dmaru;
> +
> +	dmaru = dmar_find_dmaru((struct acpi_dmar_hardware_unit *)header);
> +	if (!dmaru)
> +		return -ENODEV;
> +
> +	ret = dmar_ir_hotplug(dmaru, true);
> +	if (ret == 0)
> +		ret = dmar_iommu_hotplug(dmaru, true);
> +
> +	return ret;
> +}
> +
> +static int dmar_hp_remove_drhd(struct acpi_dmar_header *header, void *arg)
> +{
> +	int i, ret;
> +	struct device *dev;
> +	struct dmar_drhd_unit *dmaru;
> +
> +	dmaru = dmar_find_dmaru((struct acpi_dmar_hardware_unit *)header);
> +	if (!dmaru)
> +		return 0;
> +
> +	/*
> +	 * All PCI devices managed by this unit should have been destroyed.
> +	 */
> +	if (!dmaru->include_all && dmaru->devices && dmaru->devices_cnt)
> +		for_each_active_dev_scope(dmaru->devices,
> +					  dmaru->devices_cnt, i, dev)
> +			return -EBUSY;
> +
> +	ret = dmar_ir_hotplug(dmaru, false);
> +	if (ret == 0)
> +		ret = dmar_iommu_hotplug(dmaru, false);
> +
> +	return ret;
> +}
> +
> +static int dmar_hp_release_drhd(struct acpi_dmar_header *header, void *arg)
> +{
> +	struct dmar_drhd_unit *dmaru;
> +
> +	dmaru = dmar_find_dmaru((struct acpi_dmar_hardware_unit *)header);
> +	if (dmaru) {
> +		list_del_rcu(&dmaru->list);
> +		synchronize_rcu();
> +		dmar_free_drhd(dmaru);
> +	}
> +
> +	return 0;
> +}
> +
> +static int dmar_hotplug_insert(acpi_handle handle)
> +{
> +	int ret;
> +	int drhd_count = 0;
> +
> +	ret = dmar_walk_dsm_resource(handle, DMAR_DSM_FUNC_DRHD,
> +				     &dmar_validate_one_drhd, (void *)1);
> +	if (ret)
> +		goto out;
> +
> +	ret = dmar_walk_dsm_resource(handle, DMAR_DSM_FUNC_DRHD,
> +				     &dmar_parse_one_drhd, (void *)&drhd_count);
> +	if (ret == 0 && drhd_count == 0) {
> +		pr_warn(FW_BUG "No DRHD structures in buffer returned by _DSM method\n");
> +		goto out;
> +	} else if (ret) {
> +		goto release_drhd;
> +	}
> +
> +	ret = dmar_walk_dsm_resource(handle, DMAR_DSM_FUNC_RHSA,
> +				     &dmar_parse_one_rhsa, NULL);
> +	if (ret)
> +		goto release_drhd;
> +
> +	ret = dmar_walk_dsm_resource(handle, DMAR_DSM_FUNC_ATSR,
> +				     &dmar_parse_one_atsr, NULL);
> +	if (ret)
> +		goto release_atsr;
> +
> +	ret = dmar_walk_dsm_resource(handle, DMAR_DSM_FUNC_DRHD,
> +				     &dmar_hp_add_drhd, NULL);
> +	if (!ret)
> +		return 0;
> +
> +	dmar_walk_dsm_resource(handle, DMAR_DSM_FUNC_DRHD,
> +			       &dmar_hp_remove_drhd, NULL);
> +release_atsr:
> +	dmar_walk_dsm_resource(handle, DMAR_DSM_FUNC_ATSR,
> +			       &dmar_release_one_atsr, NULL);
> +release_drhd:
> +	dmar_walk_dsm_resource(handle, DMAR_DSM_FUNC_DRHD,
> +			       &dmar_hp_release_drhd, NULL);
> +out:
> +	return ret;
> +}
> +
> +static int dmar_hotplug_remove(acpi_handle handle)
> +{
> +	int ret;
> +
> +	ret = dmar_walk_dsm_resource(handle, DMAR_DSM_FUNC_ATSR,
> +				     &dmar_check_one_atsr, NULL);
> +	if (ret)
> +		return ret;
> +
> +	ret = dmar_walk_dsm_resource(handle, DMAR_DSM_FUNC_DRHD,
> +				     &dmar_hp_remove_drhd, NULL);
> +	if (ret == 0) {
> +		WARN_ON(dmar_walk_dsm_resource(handle, DMAR_DSM_FUNC_ATSR,
> +					       &dmar_release_one_atsr, NULL));
> +		WARN_ON(dmar_walk_dsm_resource(handle, DMAR_DSM_FUNC_DRHD,
> +					       &dmar_hp_release_drhd, NULL));
> +	} else {
> +		dmar_walk_dsm_resource(handle, DMAR_DSM_FUNC_DRHD,
> +				       &dmar_hp_add_drhd, NULL);
> +	}
> +
> +	return ret;
> +}
> +
> +static int dmar_device_hotplug(acpi_handle handle, bool insert)
> +{
> +	int ret;
> +
> +	if (!dmar_in_use())
> +		return 0;
> +
> +	if (!dmar_detect_dsm(handle, DMAR_DSM_FUNC_DRHD))
> +		return 0;
> +
> +	down_write(&dmar_global_lock);
> +	if (insert)
> +		ret = dmar_hotplug_insert(handle);
> +	else
> +		ret = dmar_hotplug_remove(handle);
> +	up_write(&dmar_global_lock);
> +
> +	return ret;
> +}
> +
> +int dmar_device_add(acpi_handle handle)
> +{
> +	return dmar_device_hotplug(handle, true);
> +}
> +
> +int dmar_device_remove(acpi_handle handle)
> +{
> +	return dmar_device_hotplug(handle, false);
> +}
> diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
> index 7daa74ed46d0..70d9d47eaeda 100644
> --- a/drivers/iommu/intel-iommu.c
> +++ b/drivers/iommu/intel-iommu.c
> @@ -3701,17 +3701,48 @@ int __init dmar_parse_one_rmrr(struct acpi_dmar_header *header, void *arg)
>  	return 0;
>  }
>  
> -int __init dmar_parse_one_atsr(struct acpi_dmar_header *hdr, void *arg)
> +static struct dmar_atsr_unit *dmar_find_atsr(struct acpi_dmar_atsr *atsr)
> +{
> +	struct dmar_atsr_unit *atsru;
> +	struct acpi_dmar_atsr *tmp;
> +
> +	list_for_each_entry_rcu(atsru, &dmar_atsr_units, list) {
> +		tmp = (struct acpi_dmar_atsr *)atsru->hdr;
> +		if (atsr->segment != tmp->segment)
> +			continue;
> +		if (atsr->header.length != tmp->header.length)
> +			continue;
> +		if (memcmp(atsr, tmp, atsr->header.length) == 0)
> +			return atsru;
> +	}
> +
> +	return NULL;
> +}
> +
> +int dmar_parse_one_atsr(struct acpi_dmar_header *hdr, void *arg)
>  {
>  	struct acpi_dmar_atsr *atsr;
>  	struct dmar_atsr_unit *atsru;
>  
> +	if (system_state != SYSTEM_BOOTING && !intel_iommu_enabled)
> +		return 0;
> +
>  	atsr = container_of(hdr, struct acpi_dmar_atsr, header);
> -	atsru = kzalloc(sizeof(*atsru), GFP_KERNEL);
> +	atsru = dmar_find_atsr(atsr);
> +	if (atsru)
> +		return 0;
> +
> +	atsru = kzalloc(sizeof(*atsru) + hdr->length, GFP_KERNEL);
>  	if (!atsru)
>  		return -ENOMEM;
>  
> -	atsru->hdr = hdr;
> +	/*
> +	 * If memory is allocated from slab by ACPI _DSM method, we need to
> +	 * copy the memory content because the memory buffer will be freed
> +	 * on return.
> +	 */
> +	atsru->hdr = (void *)(atsru + 1);
> +	memcpy(atsru->hdr, hdr, hdr->length);
>  	atsru->include_all = atsr->flags & 0x1;
>  	if (!atsru->include_all) {
>  		atsru->devices = dmar_alloc_dev_scope((void *)(atsr + 1),
> @@ -3734,6 +3765,47 @@ static void intel_iommu_free_atsr(struct dmar_atsr_unit *atsru)
>  	kfree(atsru);
>  }
>  
> +int dmar_release_one_atsr(struct acpi_dmar_header *hdr, void *arg)
> +{
> +	struct acpi_dmar_atsr *atsr;
> +	struct dmar_atsr_unit *atsru;
> +
> +	atsr = container_of(hdr, struct acpi_dmar_atsr, header);
> +	atsru = dmar_find_atsr(atsr);
> +	if (atsru) {
> +		list_del_rcu(&atsru->list);
> +		synchronize_rcu();
> +		intel_iommu_free_atsr(atsru);
> +	}
> +
> +	return 0;
> +}
> +
> +int dmar_check_one_atsr(struct acpi_dmar_header *hdr, void *arg)
> +{
> +	int i;
> +	struct device *dev;
> +	struct acpi_dmar_atsr *atsr;
> +	struct dmar_atsr_unit *atsru;
> +
> +	atsr = container_of(hdr, struct acpi_dmar_atsr, header);
> +	atsru = dmar_find_atsr(atsr);
> +	if (!atsru)
> +		return 0;
> +
> +	if (!atsru->include_all && atsru->devices && atsru->devices_cnt)
> +		for_each_active_dev_scope(atsru->devices, atsru->devices_cnt,
> +					  i, dev)
> +			return -EBUSY;
> +
> +	return 0;
> +}
> +
> +int dmar_iommu_hotplug(struct dmar_drhd_unit *dmaru, bool insert)
> +{
> +	return intel_iommu_enabled ? -ENOSYS : 0;
> +}
> +
>  static void intel_iommu_free_dmars(void)
>  {
>  	struct dmar_rmrr_unit *rmrru, *rmrr_n;
> diff --git a/drivers/iommu/intel_irq_remapping.c b/drivers/iommu/intel_irq_remapping.c
> index 0df41f6264f5..9b140ed854ec 100644
> --- a/drivers/iommu/intel_irq_remapping.c
> +++ b/drivers/iommu/intel_irq_remapping.c
> @@ -1172,3 +1172,8 @@ struct irq_remap_ops intel_irq_remap_ops = {
>  	.msi_setup_irq		= intel_msi_setup_irq,
>  	.setup_hpet_msi		= intel_setup_hpet_msi,
>  };
> +
> +int dmar_ir_hotplug(struct dmar_drhd_unit *dmaru, bool insert)
> +{
> +	return irq_remapping_enabled ? -ENOSYS : 0;
> +}
> diff --git a/include/linux/dmar.h b/include/linux/dmar.h
> index c8a576bc3a98..594d4ac79e75 100644
> --- a/include/linux/dmar.h
> +++ b/include/linux/dmar.h
> @@ -120,6 +120,8 @@ extern int dmar_remove_dev_scope(struct dmar_pci_notify_info *info,
>  /* Intel IOMMU detection */
>  extern int detect_intel_iommu(void);
>  extern int enable_drhd_fault_handling(void);
> +extern int dmar_device_add(acpi_handle handle);
> +extern int dmar_device_remove(acpi_handle handle);
>  
>  static inline int dmar_res_noop(struct acpi_dmar_header *hdr, void *arg)
>  {
> @@ -131,17 +133,48 @@ extern int iommu_detected, no_iommu;
>  extern int intel_iommu_init(void);
>  extern int dmar_parse_one_rmrr(struct acpi_dmar_header *header, void *arg);
>  extern int dmar_parse_one_atsr(struct acpi_dmar_header *header, void *arg);
> +extern int dmar_check_one_atsr(struct acpi_dmar_header *hdr, void *arg);
> +extern int dmar_release_one_atsr(struct acpi_dmar_header *hdr, void *arg);
> +extern int dmar_iommu_hotplug(struct dmar_drhd_unit *dmaru, bool insert);
>  extern int dmar_iommu_notify_scope_dev(struct dmar_pci_notify_info *info);
>  #else /* !CONFIG_INTEL_IOMMU: */
>  static inline int intel_iommu_init(void) { return -ENODEV; }
> +
>  #define	dmar_parse_one_rmrr		dmar_res_noop
>  #define	dmar_parse_one_atsr		dmar_res_noop
> +#define	dmar_check_one_atsr		dmar_res_noop
> +#define	dmar_release_one_atsr		dmar_res_noop
> +
>  static inline int dmar_iommu_notify_scope_dev(struct dmar_pci_notify_info *info)
>  {
>  	return 0;
>  }
> +
> +static inline int dmar_iommu_hotplug(struct dmar_drhd_unit *dmaru, bool insert)
> +{
> +	return 0;
> +}
>  #endif /* CONFIG_INTEL_IOMMU */
>  
> +#ifdef CONFIG_IRQ_REMAP
> +extern int dmar_ir_hotplug(struct dmar_drhd_unit *dmaru, bool insert);
> +#else  /* CONFIG_IRQ_REMAP */
> +static inline int dmar_ir_hotplug(struct dmar_drhd_unit *dmaru, bool insert)
> +{ return 0; }
> +#endif /* CONFIG_IRQ_REMAP */
> +
> +#else /* CONFIG_DMAR_TABLE */
> +
> +static inline int dmar_device_add(void *handle)
> +{
> +	return 0;
> +}
> +
> +static inline int dmar_device_remove(void *handle)
> +{
> +	return 0;
> +}
> +
>  #endif /* CONFIG_DMAR_TABLE */
>  
>  struct irte {
> 


-- 
Thanks!
Yijing

