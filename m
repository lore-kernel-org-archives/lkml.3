Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751825AbaKKNix (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 08:38:53 -0500
Received: from mga03.intel.com ([134.134.136.65]:13838 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751010AbaKKNik (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 08:38:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,361,1413270000"; 
   d="scan'208";a="635050790"
Message-ID: <5462114E.1060901@linux.intel.com>
Date: Tue, 11 Nov 2014 21:38:22 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Feng Wu <feng.wu@intel.com>, gleb@kernel.org, pbonzini@redhat.com,
        dwmw2@infradead.org, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, x86@kernel.org
CC: kvm@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/13] iommu/vt-d: VT-d Posted-Interrupts feature detection
References: <1415600812-27773-1-git-send-email-feng.wu@intel.com> <1415600812-27773-2-git-send-email-feng.wu@intel.com>
In-Reply-To: <1415600812-27773-2-git-send-email-feng.wu@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 2014/11/10 14:26, Feng Wu wrote:
> VT-d Posted-Interrupts is an enhancement to CPU side Posted-Interrupt.
> With VT-d Posted-Interrupts enabled, external interrupts from
> direct-assigned devices can be delivered to guests without VMM
> intervention when guest is running in non-root mode.
> 
> This patch adds feature detection logic for VT-d posted-interrupt.
> 
> Signed-off-by: Feng Wu <feng.wu@intel.com>
> ---
>  drivers/iommu/intel_irq_remapping.c |   13 +++++++++++++
>  drivers/iommu/irq_remapping.c       |    4 ++++
>  drivers/iommu/irq_remapping.h       |    5 +++++
>  include/linux/intel-iommu.h         |    1 +
>  4 files changed, 23 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/iommu/intel_irq_remapping.c b/drivers/iommu/intel_irq_remapping.c
> index 7c80661..f99f0f1 100644
> --- a/drivers/iommu/intel_irq_remapping.c
> +++ b/drivers/iommu/intel_irq_remapping.c
> @@ -580,6 +580,19 @@ static int __init intel_irq_remapping_supported(void)
>  		if (!ecap_ir_support(iommu->ecap))
>  			return 0;
>  
> +	/* VT-d posted-interrupt feature detection*/
> +	if (disable_irq_post == 0)
> +		for_each_drhd_unit(drhd) {
> +			struct intel_iommu *iommu = drhd->iommu;
Hi Feng,
	You may use for_each_active_iommu() here.
Regards!
Gerry

> +
> +			if (!cap_pi_support(iommu->cap)) {
> +				irq_post_enabled = 0;
> +				disable_irq_post = 1;
> +				break;
> +			}
> +			irq_post_enabled = 1;
> +		}
> +
>  	return 1;
>  }
>  
> diff --git a/drivers/iommu/irq_remapping.c b/drivers/iommu/irq_remapping.c
> index 74a1767..2f8ee00 100644
> --- a/drivers/iommu/irq_remapping.c
> +++ b/drivers/iommu/irq_remapping.c
> @@ -23,6 +23,10 @@ int irq_remap_broken;
>  int disable_sourceid_checking;
>  int no_x2apic_optout;
>  
> +int disable_irq_post = 1;
> +int irq_post_enabled = 0;
> +EXPORT_SYMBOL_GPL(irq_post_enabled);
> +
>  static struct irq_remap_ops *remap_ops;
>  
>  static int msi_alloc_remapped_irq(struct pci_dev *pdev, int irq, int nvec);
> diff --git a/drivers/iommu/irq_remapping.h b/drivers/iommu/irq_remapping.h
> index fde250f..7bb5913 100644
> --- a/drivers/iommu/irq_remapping.h
> +++ b/drivers/iommu/irq_remapping.h
> @@ -37,6 +37,9 @@ extern int disable_sourceid_checking;
>  extern int no_x2apic_optout;
>  extern int irq_remapping_enabled;
>  
> +extern int disable_irq_post;
> +extern int irq_post_enabled;
> +
>  struct irq_remap_ops {
>  	/* Check whether Interrupt Remapping is supported */
>  	int (*supported)(void);
> @@ -91,6 +94,8 @@ extern struct irq_remap_ops amd_iommu_irq_ops;
>  #define irq_remapping_enabled 0
>  #define disable_irq_remap     1
>  #define irq_remap_broken      0
> +#define disable_irq_post      1
> +#define irq_post_enabled      0
>  
>  #endif /* CONFIG_IRQ_REMAP */
>  
> diff --git a/include/linux/intel-iommu.h b/include/linux/intel-iommu.h
> index a65208a..5b1a124 100644
> --- a/include/linux/intel-iommu.h
> +++ b/include/linux/intel-iommu.h
> @@ -87,6 +87,7 @@ static inline void dmar_writeq(void __iomem *addr, u64 val)
>  /*
>   * Decoding Capability Register
>   */
> +#define cap_pi_support(c)	(((c) >> 59) & 1)
>  #define cap_read_drain(c)	(((c) >> 55) & 1)
>  #define cap_write_drain(c)	(((c) >> 54) & 1)
>  #define cap_max_amask_val(c)	(((c) >> 48) & 0x3f)
> 
