Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752818AbaILJRb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 05:17:31 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:28212 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140AbaILJR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 05:17:27 -0400
Message-ID: <5412B9EE.3070708@huawei.com>
Date: Fri, 12 Sep 2014 17:16:30 +0800
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
Subject: Re: [Patch Part3 V5 1/8] iommu/vt-d: Introduce helper function dmar_walk_resources()
References: <1410487848-6027-1-git-send-email-jiang.liu@linux.intel.com> <1410487848-6027-2-git-send-email-jiang.liu@linux.intel.com>
In-Reply-To: <1410487848-6027-2-git-send-email-jiang.liu@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.27.212]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020203.5412BA1F.00A3,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2011-05-27 18:58:46
X-Mirapoint-Loop-Id: dd0de5907e2d952bc56c1514f971fd2a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/9/12 10:10, Jiang Liu wrote:
> Introduce helper function dmar_walk_resources to walk resource entries
> in DMAR table and ACPI buffer object returned by ACPI _DSM method
> for IOMMU hot-plug.
> 
> Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>

Hi Gerry. some comments below.


> ---
>  drivers/iommu/dmar.c        |  209 +++++++++++++++++++++++--------------------
>  drivers/iommu/intel-iommu.c |    4 +-
>  include/linux/dmar.h        |   19 ++--
>  3 files changed, 122 insertions(+), 110 deletions(-)
> 
> diff --git a/drivers/iommu/dmar.c b/drivers/iommu/dmar.c
> index 60ab474bfff3..afd46eb9a5de 100644
> --- a/drivers/iommu/dmar.c
> +++ b/drivers/iommu/dmar.c
> @@ -44,6 +44,14 @@
>  
>  #include "irq_remapping.h"
>  
> +typedef int (*dmar_res_handler_t)(struct acpi_dmar_header *, void *);
> +struct dmar_res_callback {
> +	dmar_res_handler_t	cb[ACPI_DMAR_TYPE_RESERVED];
> +	void			*arg[ACPI_DMAR_TYPE_RESERVED];
> +	bool			ignore_unhandled;
> +	bool			print_entry;

Why do we need a switch to control print ?

> +};
> +
>  
> +static int dmar_walk_resources(struct acpi_dmar_header *start, size_t len,
> +			       struct dmar_res_callback *cb)

The name dmar_walk_resources easily make people think this is related with I/O or memory resources.
Do you have a better idea of this ?  What about dmar_walk_remapping_entry() or dmar_walk_remapping_structure() ?

> +{
> +	int ret = 0;
> +	struct acpi_dmar_header *iter, *next;
> +	struct acpi_dmar_header *end = ((void *)start) + len;
> +
> +	for (iter = start; iter < end && ret == 0; iter = next) {
> +		next = (void *)iter + iter->length;
> +		if (iter->length == 0) {
> +			/* Avoid looping forever on bad ACPI tables */
> +			pr_debug(FW_BUG "Invalid 0-length structure\n");

What about use pr_warn() instead of pr_debug(), pr_debug() default is off.

> +			break;
> +		} else if (next > end) {
> +			/* Avoid passing table end */
> +			pr_warn(FW_BUG "record passes table end\n");
> +			ret = -EINVAL;
> +			break;
> +		}
> +
> +		if (cb->print_entry)
> +			dmar_table_print_dmar_entry(iter);
> +
> +		if (iter->type >= ACPI_DMAR_TYPE_RESERVED) {
> +			/* continue for forward compatibility */
> +			pr_debug("Unknown DMAR structure type %d\n",
> +				 iter->type);

Same as above.

> +		} else if (cb->cb[iter->type]) {
> +			ret = cb->cb[iter->type](iter, cb->arg[iter->type]);
> +		} else if (!cb->ignore_unhandled) {
> +			pr_warn("No handler for DMAR structure type %d\n",
> +				iter->type);
> +			ret = -EINVAL;
> +		}
> +	}
> +
> +	return ret;
> +}
> +
> +static inline int dmar_walk_dmar_table(struct acpi_table_dmar *dmar,
> +				       struct dmar_res_callback *cb)
> +{
> +	return dmar_walk_resources((struct acpi_dmar_header *)(dmar + 1),
> +				   dmar->header.length - sizeof(*dmar), cb);
> +}
> +
>  /**
>   * parse_dmar_table - parses the DMA reporting table
>   */
> @@ -493,9 +554,18 @@ static int __init
>  parse_dmar_table(void)
>  {
>  	struct acpi_table_dmar *dmar;
> -	struct acpi_dmar_header *entry_header;
>  	int ret = 0;
>  	int drhd_count = 0;
> +	struct dmar_res_callback cb = {
> +		.print_entry = true,
> +		.ignore_unhandled = true,
> +		.arg[ACPI_DMAR_TYPE_HARDWARE_UNIT] = &drhd_count,
> +		.cb[ACPI_DMAR_TYPE_HARDWARE_UNIT] = &dmar_parse_one_drhd,
> +		.cb[ACPI_DMAR_TYPE_RESERVED_MEMORY] = &dmar_parse_one_rmrr,
> +		.cb[ACPI_DMAR_TYPE_ROOT_ATS] = &dmar_parse_one_atsr,
> +		.cb[ACPI_DMAR_TYPE_HARDWARE_AFFINITY] = &dmar_parse_one_rhsa,
> +		.cb[ACPI_DMAR_TYPE_NAMESPACE] = &dmar_parse_one_andd,
> +	};
>  
>  	/*
>  	 * Do it again, earlier dmar_tbl mapping could be mapped with
> @@ -519,51 +589,10 @@ parse_dmar_table(void)
>  	}
>  
>  	pr_info("Host address width %d\n", dmar->width + 1);
> -
> -	entry_header = (struct acpi_dmar_header *)(dmar + 1);
> -	while (((unsigned long)entry_header) <
> -			(((unsigned long)dmar) + dmar_tbl->length)) {
> -		/* Avoid looping forever on bad ACPI tables */
> -		if (entry_header->length == 0) {
> -			pr_warn("Invalid 0-length structure\n");
> -			ret = -EINVAL;
> -			break;
> -		}
> -
> -		dmar_table_print_dmar_entry(entry_header);
> -
> -		switch (entry_header->type) {
> -		case ACPI_DMAR_TYPE_HARDWARE_UNIT:
> -			drhd_count++;
> -			ret = dmar_parse_one_drhd(entry_header);
> -			break;
> -		case ACPI_DMAR_TYPE_RESERVED_MEMORY:
> -			ret = dmar_parse_one_rmrr(entry_header);
> -			break;
> -		case ACPI_DMAR_TYPE_ROOT_ATS:
> -			ret = dmar_parse_one_atsr(entry_header);
> -			break;
> -		case ACPI_DMAR_TYPE_HARDWARE_AFFINITY:
> -#ifdef CONFIG_ACPI_NUMA
> -			ret = dmar_parse_one_rhsa(entry_header);
> -#endif
> -			break;
> -		case ACPI_DMAR_TYPE_NAMESPACE:
> -			ret = dmar_parse_one_andd(entry_header);
> -			break;
> -		default:
> -			pr_warn("Unknown DMAR structure type %d\n",
> -				entry_header->type);
> -			ret = 0; /* for forward compatibility */
> -			break;
> -		}
> -		if (ret)
> -			break;
> -
> -		entry_header = ((void *)entry_header + entry_header->length);
> -	}
> -	if (drhd_count == 0)
> +	ret = dmar_walk_dmar_table(dmar, &cb);
> +	if (ret == 0 && drhd_count == 0)
>  		pr_warn(FW_BUG "No DRHD structure found in DMAR table\n");
> +
>  	return ret;
>  }
>  
> @@ -762,76 +791,60 @@ static void warn_invalid_dmar(u64 addr, const char *message)
>  		dmi_get_system_info(DMI_PRODUCT_VERSION));
>  }
>  
> -static int __init check_zero_address(void)
> +static int __ref
> +dmar_validate_one_drhd(struct acpi_dmar_header *entry, void *arg)
>  {
> -	struct acpi_table_dmar *dmar;
> -	struct acpi_dmar_header *entry_header;
>  	struct acpi_dmar_hardware_unit *drhd;
> +	void __iomem *addr;
> +	u64 cap, ecap;
>  
> -	dmar = (struct acpi_table_dmar *)dmar_tbl;
> -	entry_header = (struct acpi_dmar_header *)(dmar + 1);
> -
> -	while (((unsigned long)entry_header) <
> -			(((unsigned long)dmar) + dmar_tbl->length)) {
> -		/* Avoid looping forever on bad ACPI tables */
> -		if (entry_header->length == 0) {
> -			pr_warn("Invalid 0-length structure\n");
> -			return 0;
> -		}
> -
> -		if (entry_header->type == ACPI_DMAR_TYPE_HARDWARE_UNIT) {
> -			void __iomem *addr;
> -			u64 cap, ecap;
> -
> -			drhd = (void *)entry_header;
> -			if (!drhd->address) {
> -				warn_invalid_dmar(0, "");
> -				goto failed;
> -			}
> +	drhd = (void *)entry;
> +	if (!drhd->address) {
> +		warn_invalid_dmar(0, "");
> +		return -EINVAL;
> +	}
>  
> -			addr = early_ioremap(drhd->address, VTD_PAGE_SIZE);
> -			if (!addr ) {
> -				printk("IOMMU: can't validate: %llx\n", drhd->address);
> -				goto failed;
> -			}
> -			cap = dmar_readq(addr + DMAR_CAP_REG);
> -			ecap = dmar_readq(addr + DMAR_ECAP_REG);
> -			early_iounmap(addr, VTD_PAGE_SIZE);
> -			if (cap == (uint64_t)-1 && ecap == (uint64_t)-1) {
> -				warn_invalid_dmar(drhd->address,
> -						  " returns all ones");
> -				goto failed;
> -			}
> -		}
> +	addr = early_ioremap(drhd->address, VTD_PAGE_SIZE);
> +	if (!addr) {
> +		pr_warn("IOMMU: can't validate: %llx\n", drhd->address);
> +		return -EINVAL;
> +	}
> +	cap = dmar_readq(addr + DMAR_CAP_REG);
> +	ecap = dmar_readq(addr + DMAR_ECAP_REG);
> +	early_iounmap(addr, VTD_PAGE_SIZE);
>  
> -		entry_header = ((void *)entry_header + entry_header->length);
> +	if (cap == (uint64_t)-1 && ecap == (uint64_t)-1) {
> +		warn_invalid_dmar(drhd->address, " returns all ones");
> +		return -EINVAL;
>  	}
> -	return 1;
>  
> -failed:
>  	return 0;
>  }
>  
>  int __init detect_intel_iommu(void)
>  {
>  	int ret;
> +	struct dmar_res_callback validate_drhd_cb = {
> +		.cb[ACPI_DMAR_TYPE_HARDWARE_UNIT] = &dmar_validate_one_drhd,
> +		.ignore_unhandled = true,
> +	};
>  
>  	down_write(&dmar_global_lock);
>  	ret = dmar_table_detect();
>  	if (ret)
> -		ret = check_zero_address();
> -	{
> -		if (ret && !no_iommu && !iommu_detected && !dmar_disabled) {
> -			iommu_detected = 1;
> -			/* Make sure ACS will be enabled */
> -			pci_request_acs();
> -		}
> +		ret = !dmar_walk_dmar_table((struct acpi_table_dmar *)dmar_tbl,
> +					    &validate_drhd_cb);
> +	if (ret && !no_iommu && !iommu_detected && !dmar_disabled) {
> +		iommu_detected = 1;
> +		/* Make sure ACS will be enabled */
> +		pci_request_acs();
> +	}
>  
>  #ifdef CONFIG_X86
> -		if (ret)
> -			x86_init.iommu.iommu_init = intel_iommu_init;
> +	if (ret)
> +		x86_init.iommu.iommu_init = intel_iommu_init;
>  #endif
> -	}
> +
>  	early_acpi_os_unmap_memory((void __iomem *)dmar_tbl, dmar_tbl_size);
>  	dmar_tbl = NULL;
>  	up_write(&dmar_global_lock);
> diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
> index 5619f264862d..4af2206e41bc 100644
> --- a/drivers/iommu/intel-iommu.c
> +++ b/drivers/iommu/intel-iommu.c
> @@ -3682,7 +3682,7 @@ static inline void init_iommu_pm_ops(void) {}
>  #endif	/* CONFIG_PM */
>  
>  
> -int __init dmar_parse_one_rmrr(struct acpi_dmar_header *header)
> +int __init dmar_parse_one_rmrr(struct acpi_dmar_header *header, void *arg)
>  {
>  	struct acpi_dmar_reserved_memory *rmrr;
>  	struct dmar_rmrr_unit *rmrru;
> @@ -3708,7 +3708,7 @@ int __init dmar_parse_one_rmrr(struct acpi_dmar_header *header)
>  	return 0;
>  }
>  
> -int __init dmar_parse_one_atsr(struct acpi_dmar_header *hdr)
> +int __init dmar_parse_one_atsr(struct acpi_dmar_header *hdr, void *arg)
>  {
>  	struct acpi_dmar_atsr *atsr;
>  	struct dmar_atsr_unit *atsru;
> diff --git a/include/linux/dmar.h b/include/linux/dmar.h
> index 1deece46a0ca..fac8ca34f9a8 100644
> --- a/include/linux/dmar.h
> +++ b/include/linux/dmar.h
> @@ -115,22 +115,21 @@ extern int dmar_remove_dev_scope(struct dmar_pci_notify_info *info,
>  extern int detect_intel_iommu(void);
>  extern int enable_drhd_fault_handling(void);
>  
> +static inline int dmar_res_noop(struct acpi_dmar_header *hdr, void *arg)
> +{
> +	return 0;
> +}
> +
>  #ifdef CONFIG_INTEL_IOMMU
>  extern int iommu_detected, no_iommu;
>  extern int intel_iommu_init(void);
> -extern int dmar_parse_one_rmrr(struct acpi_dmar_header *header);
> -extern int dmar_parse_one_atsr(struct acpi_dmar_header *header);
> +extern int dmar_parse_one_rmrr(struct acpi_dmar_header *header, void *arg);
> +extern int dmar_parse_one_atsr(struct acpi_dmar_header *header, void *arg);
>  extern int dmar_iommu_notify_scope_dev(struct dmar_pci_notify_info *info);
>  #else /* !CONFIG_INTEL_IOMMU: */
>  static inline int intel_iommu_init(void) { return -ENODEV; }
> -static inline int dmar_parse_one_rmrr(struct acpi_dmar_header *header)
> -{
> -	return 0;
> -}
> -static inline int dmar_parse_one_atsr(struct acpi_dmar_header *header)
> -{
> -	return 0;
> -}
> +#define	dmar_parse_one_rmrr		dmar_res_noop
> +#define	dmar_parse_one_atsr		dmar_res_noop
>  static inline int dmar_iommu_notify_scope_dev(struct dmar_pci_notify_info *info)
>  {
>  	return 0;
> 


-- 
Thanks!
Yijing

