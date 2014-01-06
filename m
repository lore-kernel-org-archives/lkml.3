Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752581AbaAFCZk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 21:25:40 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:4565 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460AbaAFCZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 21:25:37 -0500
Message-ID: <52CA13A8.4060808@huawei.com>
Date: Mon, 6 Jan 2014 10:23:36 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        "Tony Luck" <tony.luck@intel.com>, Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, x86 <x86@kernel.org>
CC: <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-acpi@vger.kernel.org>, Len Brown <lenb@kernel.org>,
        Joerg Roedel <joro@8bytes.org>, Donald Dutile <ddutile@redhat.com>
Subject: Re: [PATCH v2 10/10] IOMMU: Add intel iommu irq-remapping and dmar
 hotplug support
References: <1388707697-16800-1-git-send-email-yinghai@kernel.org> <1388707697-16800-11-git-send-email-yinghai@kernel.org>
In-Reply-To: <1388707697-16800-11-git-send-email-yinghai@kernel.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.27.212]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yinghai,
   There is a problem, consider that static DMAR table contains the hotplug CPU DMAR info(include drhd and atsr).
So, if we enable irq remapping, all DMAR drhd unit and atsr unit will be parsed during boot path. When IOH hub object in
DSDT was enumerated, we found device that support _DSM, by _DSM, we get the hotplug DMAR info(which has been initialized during irq remapping boot path).
We cannot identify the DMAR info in _DSM whether has been initialized.

For DRHD, I think we can use reg_base_addr to identify whether has been registered.
But for ATSR, maybe it's a Thorny issue.

Thanks!
Yijing.

On 2014/1/3 8:08, Yinghai Lu wrote:
> during hostbridge hotadd/hotremove, we call acpi_pci_iommu_add/remove in
> acpi_pci_root_add/remove.
> 
> For add, need to after ioapic add.
> 
> Run dsm in acpi root device to get iommu entries, and init dmar/irq_remapping
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> Cc: Len Brown <lenb@kernel.org>
> Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
> Cc: Bjorn Helgaas <bhelgaas@google.com>
> Cc: Joerg Roedel <joro@8bytes.org>
> Cc: Donald Dutile <ddutile@redhat.com>
> Cc: linux-acpi@vger.kernel.org
> Cc: linux-pci@vger.kernel.org
> ---
>  drivers/acpi/pci_root.c  |   2 +
>  drivers/iommu/dmar.c     | 201 +++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/pci-acpi.h |   8 ++
>  3 files changed, 211 insertions(+)
> 
> diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
> index e666be3..dd82d8b 100644
> --- a/drivers/acpi/pci_root.c
> +++ b/drivers/acpi/pci_root.c
> @@ -600,6 +600,7 @@ static int acpi_pci_root_add(struct acpi_device *device,
>  	}
>  
>  	acpi_pci_ioapic_add(root);
> +	acpi_pci_iommu_add(root);
>  
>  	pci_bus_add_devices(root->bus);
>  	return 1;
> @@ -615,6 +616,7 @@ static void acpi_pci_root_remove(struct acpi_device *device)
>  
>  	pci_stop_root_bus(root->bus);
>  
> +	acpi_pci_iommu_remove(root);
>  	acpi_pci_ioapic_remove(root);
>  
>  	device_set_run_wake(root->bus->bridge, false);
> diff --git a/drivers/iommu/dmar.c b/drivers/iommu/dmar.c
> index 31d7942..c74f112 100644
> --- a/drivers/iommu/dmar.c
> +++ b/drivers/iommu/dmar.c
> @@ -38,6 +38,7 @@
>  #include <linux/tboot.h>
>  #include <linux/dmi.h>
>  #include <linux/slab.h>
> +#include <acpi/acpi.h>
>  #include <asm/irq_remapping.h>
>  #include <asm/iommu_table.h>
>  
> @@ -1548,3 +1549,203 @@ int __init dmar_ir_support(void)
>  	return dmar->flags & 0x1;
>  }
>  IOMMU_INIT_POST(detect_intel_iommu);
> +
> +static u8 dmar_uuid_str[] = "D8C1A3A6-BE9B-4C9B-91BF-C3CB81FC5DAF";
> +
> +static int acpi_dmar_dsm_support(acpi_handle handle)
> +{
> +	int support = 0;
> +	struct acpi_dsm_context context = {
> +		.uuid_str = dmar_uuid_str,
> +		.rev = 1,
> +		.func_idx = 0,
> +	};
> +
> +	if (ACPI_SUCCESS(acpi_run_dsm(handle, &context))) {
> +		u32 *ret = context.ret.pointer;
> +		support = ret[0];
> +		kfree(context.ret.pointer);
> +	}
> +
> +	if (support & 1)
> +		return support & 0x0e;
> +
> +	return 0;
> +}
> +
> +static void *acpi_dmar_dsm_run(acpi_handle handle, int idx)
> +{
> +	struct acpi_dsm_context context = {
> +		.uuid_str = dmar_uuid_str,
> +		.rev = 1,
> +		.func_idx = idx,
> +	};
> +
> +	if (ACPI_SUCCESS(acpi_run_dsm(handle, &context)))
> +		return context.ret.pointer;
> +
> +	return NULL;
> +}
> +
> +static void handle_iommu_add(acpi_handle handle, void **d, void **a)
> +{
> +	int support;
> +	struct acpi_dmar_header *header;
> +	struct dmar_drhd_unit *dmaru = NULL;
> +	struct dmar_atsr_unit *atsru = NULL;
> +
> +	*d = NULL;
> +	*a = NULL;
> +
> +	support = acpi_dmar_dsm_support(handle);
> +
> +	if (!support)
> +		return;
> +
> +	/* DRHD */
> +	if (support & (1<<1)) {
> +		header = acpi_dmar_dsm_run(handle, 1);
> +		dmar_table_print_dmar_entry(header);
> +		__dmar_parse_one_drhd(header, &dmaru);
> +	}
> +
> +	if (!dmaru)
> +		return;
> +
> +	/* ATSR */
> +	if (support & (1<<2)) {
> +		header = acpi_dmar_dsm_run(handle, 2);
> +		dmar_table_print_dmar_entry(header);
> +		__dmar_parse_one_atsr(header, &atsru);
> +	}
> +
> +	/* RHSA */
> +	if (support & (1<<3)) {
> +		header = acpi_dmar_dsm_run(handle, 3);
> +		dmar_table_print_dmar_entry(header);
> +		dmar_parse_one_rhsa(header);
> +		kfree(header);
> +	}
> +
> +	/*
> +	 *  only need to init intr_remap and dmar for hot-add ones
> +	 *  after enable_IR() or pci_iommu_init
> +	 */
> +	/*
> +	 * TODO: handle parsing failure for pre-installed hotplug one
> +	 *	Could make every parse_one duplicate the entry table?
> +	 */
> +	if (irq_remapping_enabled == 1)
> +		intel_enable_irq_remapping_one(dmaru);
> +	if (irq_remapping_enabled == 1 || intel_iommu_enabled == 1)
> +		dmar_parse_dev(dmaru);
> +	if (intel_iommu_enabled == 1) {
> +		init_dmar_one(dmaru);
> +		if (atsru) {
> +			header = atsru->hdr;
> +			if (atsr_parse_dev(atsru)) {
> +				kfree(header);
> +				atsru = NULL;
> +			}
> +			*a = atsru;
> +		}
> +	}
> +	*d = dmaru;
> +}
> +
> +static void handle_iommu_remove(void *drhd, void *atsr)
> +{
> +	struct dmar_drhd_unit *dmaru = drhd;
> +	struct dmar_atsr_unit *atsru = atsr;
> +
> +	if (!dmaru)
> +		return;
> +
> +	if (irq_remapping_enabled == 1)
> +		disable_irq_remapping_one(dmaru);
> +	if (intel_iommu_enabled == 1) {
> +		free_dmar_iommu(dmaru->iommu);
> +		if (atsru) {
> +			kfree(atsru->devices);
> +			remove_atsru_from_saved_dev_atsru_list(atsru);
> +		}
> +	}
> +	if (irq_remapping_enabled == 1 || intel_iommu_enabled == 1) {
> +		kfree(dmaru->devices);
> +		remove_dmaru_from_saved_dev_drhd_list(dmaru);
> +	}
> +	if (atsru) {
> +		kfree(atsru->hdr);
> +		list_del(&atsru->list);
> +		kfree(atsru);
> +	}
> +	free_iommu(dmaru->iommu);
> +	kfree(dmaru->hdr);
> +	list_del(&dmaru->list);
> +	kfree(dmaru);
> +}
> +
> +struct acpi_pci_iommu {
> +	acpi_handle root_handle;
> +	void *dmaru;
> +	void *atsru;
> +	struct list_head list;
> +};
> +
> +static LIST_HEAD(iommu_list);
> +static DEFINE_MUTEX(iommu_list_lock);
> +
> +static acpi_status register_iommu(acpi_handle handle, u32 lvl,
> +				  void *context, void **rv)
> +{
> +	acpi_handle root_handle = context;
> +	void *dmaru, *atsru;
> +	struct acpi_pci_iommu *iommu;
> +
> +	handle_iommu_add(handle, &dmaru, &atsru);
> +	if (!dmaru)
> +		return AE_OK;
> +
> +	iommu = kzalloc(sizeof(*iommu), GFP_KERNEL);
> +	if (!iommu) {
> +		pr_err("%s: cannot allocate memory\n", __func__);
> +		handle_iommu_remove(dmaru, atsru);
> +		return AE_OK;
> +	}
> +	iommu->root_handle = root_handle;
> +	iommu->dmaru = dmaru;
> +	iommu->atsru = atsru;
> +
> +	mutex_lock(&iommu_list_lock);
> +	list_add(&iommu->list, &iommu_list);
> +	mutex_unlock(&iommu_list_lock);
> +
> +	return AE_OK;
> +}
> +
> +void acpi_pci_iommu_add(struct acpi_pci_root *root)
> +{
> +	acpi_status status;
> +
> +	status = acpi_walk_namespace(ACPI_TYPE_DEVICE, root->device->handle,
> +				     (u32)1, register_iommu, NULL,
> +				     root->device->handle,
> +				     NULL);
> +	if (ACPI_FAILURE(status))
> +		pr_err("%s: register_iommu failure - %d", __func__, status);
> +}
> +
> +void acpi_pci_iommu_remove(struct acpi_pci_root *root)
> +{
> +	struct acpi_pci_iommu *iommu, *tmp;
> +
> +	mutex_lock(&iommu_list_lock);
> +	list_for_each_entry_safe(iommu, tmp, &iommu_list, list) {
> +		if (root->device->handle != iommu->root_handle)
> +			continue;
> +		list_del(&iommu->list);
> +		handle_iommu_remove(iommu->dmaru, iommu->atsru);
> +		kfree(iommu);
> +	}
> +	mutex_unlock(&iommu_list_lock);
> +}
> diff --git a/include/linux/pci-acpi.h b/include/linux/pci-acpi.h
> index d2a976a..f00a89f 100644
> --- a/include/linux/pci-acpi.h
> +++ b/include/linux/pci-acpi.h
> @@ -86,4 +86,12 @@ extern bool aer_acpi_firmware_first(void);
>  static inline bool aer_acpi_firmware_first(void) { return false; }
>  #endif
>  
> +#ifdef CONFIG_DMAR_TABLE
> +void acpi_pci_iommu_add(struct acpi_pci_root *root);
> +void acpi_pci_iommu_remove(struct acpi_pci_root *root);
> +#else
> +static inline void acpi_pci_iommu_add(struct acpi_pci_root *root) { }
> +static inline void acpi_pci_iommu_remove(struct acpi_pci_root *root) { }
> +#endif
> +
>  #endif	/* _PCI_ACPI_H_ */
> 


-- 
Thanks!
Yijing

