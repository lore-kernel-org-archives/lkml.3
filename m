Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863AbaKKJVm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 04:21:42 -0500
Received: from mga11.intel.com ([192.55.52.93]:22161 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752124AbaKKJVS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 04:21:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,359,1413270000"; 
   d="scan'208";a="630031194"
From: "Wu, Feng" <feng.wu@intel.com>
To: "'Alex Williamson'" <alex.williamson@redhat.com>
CC: "gleb@kernel.org" <gleb@kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Wu, Feng" <feng.wu@intel.com>
Subject: RE: [PATCH 02/13] KVM: Initialize VT-d Posted-Interrtups Descriptor
Thread-Topic: [PATCH 02/13] KVM: Initialize VT-d Posted-Interrtups Descriptor
Thread-Index: Ac/9kMcyfZiiiYnIRDaRHWh0ykj5wA==
Date: Tue, 11 Nov 2014 09:20:59 +0000
Message-ID: <E959C4978C3B6342920538CF579893F00226EF19@SHSMSX104.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sAB9Lq9a002350



> -----Original Message-----
> From: Alex Williamson [mailto:alex.williamson@redhat.com]
> Sent: Tuesday, November 11, 2014 5:57 AM
> To: Wu, Feng
> Cc: gleb@kernel.org; pbonzini@redhat.com; dwmw2@infradead.org;
> joro@8bytes.org; tglx@linutronix.de; mingo@redhat.com; hpa@zytor.com;
> x86@kernel.org; kvm@vger.kernel.org; iommu@lists.linux-foundation.org;
> linux-kernel@vger.kernel.org
> Subject: Re: [PATCH 02/13] KVM: Initialize VT-d Posted-Interrtups Descriptor
> 
> On Mon, 2014-11-10 at 14:26 +0800, Feng Wu wrote:
> > This patch initialize the VT-d Posted-interrupt Descritpor.
> >
> > Signed-off-by: Feng Wu <feng.wu@intel.com>
> > ---
> >  arch/x86/include/asm/irq_remapping.h |    1 +
> >  arch/x86/kernel/apic/apic.c          |    1 +
> >  arch/x86/kvm/vmx.c                   |   56
> ++++++++++++++++++++++++++++++++-
> >  3 files changed, 56 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/x86/include/asm/irq_remapping.h
> b/arch/x86/include/asm/irq_remapping.h
> > index b7747c4..a3cc437 100644
> > --- a/arch/x86/include/asm/irq_remapping.h
> > +++ b/arch/x86/include/asm/irq_remapping.h
> > @@ -57,6 +57,7 @@ extern bool setup_remapped_irq(int irq,
> >  			       struct irq_chip *chip);
> >
> >  void irq_remap_modify_chip_defaults(struct irq_chip *chip);
> > +extern int irq_post_enabled;
> >
> >  #else  /* CONFIG_IRQ_REMAP */
> >
> > diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
> > index ba6cc04..987408d 100644
> > --- a/arch/x86/kernel/apic/apic.c
> > +++ b/arch/x86/kernel/apic/apic.c
> > @@ -162,6 +162,7 @@ __setup("apicpmtimer", setup_apicpmtimer);
> >  #endif
> >
> >  int x2apic_mode;
> > +EXPORT_SYMBOL_GPL(x2apic_mode);
> >  #ifdef CONFIG_X86_X2APIC
> >  /* x2apic enabled before OS handover */
> >  int x2apic_preenabled;
> > diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
> > index 3e556c6..a4670d3 100644
> > --- a/arch/x86/kvm/vmx.c
> > +++ b/arch/x86/kvm/vmx.c
> > @@ -45,6 +45,7 @@
> >  #include <asm/perf_event.h>
> >  #include <asm/debugreg.h>
> >  #include <asm/kexec.h>
> > +#include <asm/irq_remapping.h>
> >
> >  #include "trace.h"
> >
> > @@ -408,13 +409,32 @@ struct nested_vmx {
> >  };
> >
> >  #define POSTED_INTR_ON  0
> > +#define POSTED_INTR_SN  1
> > +
> >  /* Posted-Interrupt Descriptor */
> >  struct pi_desc {
> >  	u32 pir[8];     /* Posted interrupt requested */
> > -	u32 control;	/* bit 0 of control is outstanding notification bit */
> > -	u32 rsvd[7];
> > +	union {
> > +		struct {
> > +			u64	on	: 1,
> > +				sn	: 1,
> > +				rsvd_1	: 13,
> > +				ndm	: 1,
> > +				nv	: 8,
> > +				rsvd_2	: 8,
> > +				ndst	: 32;
> > +		};
> > +		u64 control;
> > +	};
> > +	u32 rsvd[6];
> >  } __aligned(64);
> >
> > +static void pi_clear_sn(struct pi_desc *pi_desc)
> > +{
> > +	return clear_bit(POSTED_INTR_SN,
> > +			(unsigned long *)&pi_desc->control);
> > +}
> > +
> >  static bool pi_test_and_set_on(struct pi_desc *pi_desc)
> >  {
> >  	return test_and_set_bit(POSTED_INTR_ON,
> > @@ -4396,6 +4416,33 @@ static void ept_set_mmio_spte_mask(void)
> >  	kvm_mmu_set_mmio_spte_mask((0x3ull << 62) | 0x6ull);
> >  }
> >
> > +static bool pi_desc_init(struct vcpu_vmx *vmx)
> > +{
> > +	unsigned int dest;
> > +
> > +	if (irq_post_enabled == 0)
> > +		return true;
> > +
> > +	/*
> > +	 * Initialize Posted-Interrupt Descriptor
> > +	 */
> > +
> > +	pi_clear_sn(&vmx->pi_desc);
> > +	vmx->pi_desc.nv = POSTED_INTR_VECTOR;
> > +
> > +	/* Physical mode for Notificaiton Event */
> > +	vmx->pi_desc.ndm = 0;
> > +	dest = cpu_physical_id(vmx->vcpu.cpu);
> > +
> > +	if (x2apic_mode)
> > +		vmx->pi_desc.ndst = dest;
> > +	else
> > +		vmx->pi_desc.ndst = (dest << 8) & 0xFF00;
> > +
> > +	return true;
> 
> Why does this bother to return anything since it can only return true?

Yes, I will make this function void. Thanks for the comments!

Thanks,
Feng

> 
> > +}
> > +
> > +
> >  /*
> >   * Sets up the vmcs for emulated real mode.
> >   */
> > @@ -4439,6 +4486,11 @@ static int vmx_vcpu_setup(struct vcpu_vmx
> *vmx)
> >
> >  		vmcs_write64(POSTED_INTR_NV, POSTED_INTR_VECTOR);
> >  		vmcs_write64(POSTED_INTR_DESC_ADDR, __pa((&vmx->pi_desc)));
> > +
> > +		if (!pi_desc_init(vmx)) {
> 
> And therefore this cannot happen.
> 
> > +			printk(KERN_ERR "Initialize PI descriptor error!\n");
> > +			return 1;
> 
> This is the wrong error anyway, vmx_create_vcpu() returns ERR_PTR(1)
> which fails the reverse IS_ERR()
> 
> Thanks,
> Alex
> 
> > +		}
> >  	}
> >
> >  	if (ple_gap) {
> 
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
