Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751808AbaKKNfw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 08:35:52 -0500
Received: from mga02.intel.com ([134.134.136.20]:64304 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750924AbaKKNfu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 08:35:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,361,1413270000"; 
   d="scan'208";a="635049820"
Message-ID: <546210B1.7060007@linux.intel.com>
Date: Tue, 11 Nov 2014 21:35:45 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Feng Wu <feng.wu@intel.com>, gleb@kernel.org, pbonzini@redhat.com,
        dwmw2@infradead.org, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, x86@kernel.org
CC: kvm@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/13] KVM: Initialize VT-d Posted-Interrtups Descriptor
References: <1415600812-27773-1-git-send-email-feng.wu@intel.com> <1415600812-27773-3-git-send-email-feng.wu@intel.com>
In-Reply-To: <1415600812-27773-3-git-send-email-feng.wu@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/11/10 14:26, Feng Wu wrote:
> This patch initialize the VT-d Posted-interrupt Descritpor.
> 
> Signed-off-by: Feng Wu <feng.wu@intel.com>
> ---
>  arch/x86/include/asm/irq_remapping.h |    1 +
>  arch/x86/kernel/apic/apic.c          |    1 +
>  arch/x86/kvm/vmx.c                   |   56 ++++++++++++++++++++++++++++++++-
>  3 files changed, 56 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/include/asm/irq_remapping.h b/arch/x86/include/asm/irq_remapping.h
> index b7747c4..a3cc437 100644
> --- a/arch/x86/include/asm/irq_remapping.h
> +++ b/arch/x86/include/asm/irq_remapping.h
> @@ -57,6 +57,7 @@ extern bool setup_remapped_irq(int irq,
>  			       struct irq_chip *chip);
>  
>  void irq_remap_modify_chip_defaults(struct irq_chip *chip);
> +extern int irq_post_enabled;
>  
>  #else  /* CONFIG_IRQ_REMAP */
>  
> diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
> index ba6cc04..987408d 100644
> --- a/arch/x86/kernel/apic/apic.c
> +++ b/arch/x86/kernel/apic/apic.c
> @@ -162,6 +162,7 @@ __setup("apicpmtimer", setup_apicpmtimer);
>  #endif
>  
>  int x2apic_mode;
> +EXPORT_SYMBOL_GPL(x2apic_mode);
>  #ifdef CONFIG_X86_X2APIC
>  /* x2apic enabled before OS handover */
>  int x2apic_preenabled;
> diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
> index 3e556c6..a4670d3 100644
> --- a/arch/x86/kvm/vmx.c
> +++ b/arch/x86/kvm/vmx.c
> @@ -45,6 +45,7 @@
>  #include <asm/perf_event.h>
>  #include <asm/debugreg.h>
>  #include <asm/kexec.h>
> +#include <asm/irq_remapping.h>
>  
>  #include "trace.h"
>  
> @@ -408,13 +409,32 @@ struct nested_vmx {
>  };
>  
>  #define POSTED_INTR_ON  0
> +#define POSTED_INTR_SN  1
> +
>  /* Posted-Interrupt Descriptor */
>  struct pi_desc {
>  	u32 pir[8];     /* Posted interrupt requested */
> -	u32 control;	/* bit 0 of control is outstanding notification bit */
> -	u32 rsvd[7];
> +	union {
> +		struct {
> +			u64	on	: 1,
> +				sn	: 1,
> +				rsvd_1	: 13,
> +				ndm	: 1,
> +				nv	: 8,
> +				rsvd_2	: 8,
> +				ndst	: 32;
> +		};
> +		u64 control;
> +	};
> +	u32 rsvd[6];
>  } __aligned(64);
>  
> +static void pi_clear_sn(struct pi_desc *pi_desc)
> +{
> +	return clear_bit(POSTED_INTR_SN,
> +			(unsigned long *)&pi_desc->control);
> +}
> +
>  static bool pi_test_and_set_on(struct pi_desc *pi_desc)
>  {
>  	return test_and_set_bit(POSTED_INTR_ON,
> @@ -4396,6 +4416,33 @@ static void ept_set_mmio_spte_mask(void)
>  	kvm_mmu_set_mmio_spte_mask((0x3ull << 62) | 0x6ull);
>  }
>  
> +static bool pi_desc_init(struct vcpu_vmx *vmx)
> +{
> +	unsigned int dest;
> +
> +	if (irq_post_enabled == 0)
> +		return true;
> +
> +	/*
> +	 * Initialize Posted-Interrupt Descriptor
> +	 */
> +
> +	pi_clear_sn(&vmx->pi_desc);
> +	vmx->pi_desc.nv = POSTED_INTR_VECTOR;
> +
> +	/* Physical mode for Notificaiton Event */
> +	vmx->pi_desc.ndm = 0;
> +	dest = cpu_physical_id(vmx->vcpu.cpu);
> +
> +	if (x2apic_mode)
Hi Feng,
	Could you try to use x2apic_enabled() here so you don't
need to export x2apic_mode?
Regards!
Gerry
> +		vmx->pi_desc.ndst = dest;
> +	else
> +		vmx->pi_desc.ndst = (dest << 8) & 0xFF00;
> +
> +	return true;
> +}
> +
> +
>  /*
>   * Sets up the vmcs for emulated real mode.
>   */
> @@ -4439,6 +4486,11 @@ static int vmx_vcpu_setup(struct vcpu_vmx *vmx)
>  
>  		vmcs_write64(POSTED_INTR_NV, POSTED_INTR_VECTOR);
>  		vmcs_write64(POSTED_INTR_DESC_ADDR, __pa((&vmx->pi_desc)));
> +
> +		if (!pi_desc_init(vmx)) {
> +			printk(KERN_ERR "Initialize PI descriptor error!\n");
> +			return 1;
> +		}
>  	}
>  
>  	if (ple_gap) {
> 
