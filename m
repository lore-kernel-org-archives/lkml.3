Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149AbaEHMHv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 08:07:51 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:45189 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752756AbaEHMHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 08:07:49 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [patch 03/32] genirq: Provide generic hwirq allocation facility
To: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Anvin <hpa@zytor.com>,
        Tony Luck <tony.luck@intel.com>, Peter Zijlstra <peterz@infradead.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Fenghua Yu <fenghua.yu@intel.com>
In-Reply-To: <20140507154334.208629358@linutronix.de>
References: <20140507153622.703412101@linutronix.de>
	<20140507154334.208629358@linutronix.de>
Date: Thu, 08 May 2014 13:07:38 +0100
Message-Id: <20140508120738.B70FDC40D85@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 07 May 2014 15:44:05 -0000, Thomas Gleixner <tglx@linutronix.de> wrote:
> Not really the solution to the problem, but at least it confines the
> mess in the core code and allows to get rid of the create/destroy_irq
> variants from hell, i.e. 3 implementations with different semantics
> plus the x86 specific variants __create_irqs and create_irq_nr
> which have been invented in another circle of hell.
> 
> x86 : x86 should be converted to irq domains and I'm deliberately
>       making it impossible to do the multi-vector MSI support by
>       adding more crap to the current mess. It's not that hard to do
>       and I'm really tired of the trainwrecks which have been invented
>       by baindaid engineering so far. Any attempt to do multi-vector
>       MSI or ioapic hotplug without converting to irq domains is NAKed
>       hereby.
> 
> tile: Might use irq domains as well, but it has a very limited
>       interrupt space, so handling it via this functionality might be
>       the right thing to do even in the long run.
> 
> ia64: That's an hopeless case, as I doubt that anyone has the stomach
>       to rewrite the homebrewn dynamic allocation facilities. I stared
>       at it for a couple of hours and gave up. The create/destroy_irq
>       mess could be made private to itanic right away if there
>       wouldn't be the iommu/dmar driver being shared with x86. So to
>       do that I'm going to add a separate ia64 specific implementation
>       later in order not to deep-six itanic right away.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: x86@kernel.org
> Cc: Chris Metcalf <cmetcalf@tilera.com>
> Cc: Tony Luck <tony.luck@intel.com>
> Cc: Fenghua Yu <fenghua.yu@intel.com>
> 
> ---
>  include/linux/irq.h  |   15 +++++++++++++++
>  kernel/irq/Kconfig   |    5 +++++
>  kernel/irq/irqdesc.c |   51 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 71 insertions(+)
> 
> Index: tip/include/linux/irq.h
> ===================================================================
> --- tip.orig/include/linux/irq.h
> +++ tip/include/linux/irq.h
> @@ -637,6 +637,21 @@ static inline int irq_reserve_irq(unsign
>  	return irq_reserve_irqs(irq, 1);
>  }
>  
> +#ifdef CONFIG_GENERIC_IRQ_LEGACY_ALLOC_HWIRQ
> +unsigned int irq_alloc_hwirqs(int cnt, int node);
> +static inline unsigned int irq_alloc_hwirq(int node)
> +{
> +	return irq_alloc_hwirqs(1, node);
> +}
> +void irq_free_hwirqs(unsigned int from, int cnt);
> +static inline void irq_free_hwirq(unsigned int irq)
> +{
> +	return irq_free_hwirqs(irq, 1);
> +}
> +int arch_setup_hwirq(unsigned int irq, int node);
> +void arch_teardown_hwirq(unsigned int irq);
> +#endif
> +
>  #ifndef irq_reg_writel
>  # define irq_reg_writel(val, addr)	writel(val, addr)
>  #endif
> Index: tip/kernel/irq/Kconfig
> ===================================================================
> --- tip.orig/kernel/irq/Kconfig
> +++ tip/kernel/irq/Kconfig
> @@ -17,6 +17,11 @@ config GENERIC_IRQ_SHOW
>  config GENERIC_IRQ_SHOW_LEVEL
>         bool
>  
> +# Facility to allocate an hardware interrupt. This is legacy support
> +# and should not be used in new code. Use irq domains instead.
> +config GENERIC_IRQ_LEGACY_ALLOC_HWIRQ
> +       bool
> +
>  # Support for delayed migration from interrupt context
>  config GENERIC_PENDING_IRQ
>  	bool
> Index: tip/kernel/irq/irqdesc.c
> ===================================================================
> --- tip.orig/kernel/irq/irqdesc.c
> +++ tip/kernel/irq/irqdesc.c
> @@ -396,6 +396,57 @@ err:
>  }
>  EXPORT_SYMBOL_GPL(__irq_alloc_descs);
>  
> +#ifdef CONFIG_GENERIC_IRQ_LEGACY_ALLOC_HWIRQ
> +/**
> + * irq_alloc_hwirqs - Allocate an irq descriptor and initialize the hardware
> + * @cnt:	number of interrupts to allocate
> + * @node:	node on which to allocate
> + *
> + * Returns an interrupt number > 0 or 0, if the allocation fails.
> + */
> +unsigned int irq_alloc_hwirqs(int cnt, int node)
> +{
> +	int i, irq = __irq_alloc_descs(-1, 0, cnt, node, NULL);
> +
> +	if (irq < 0)
> +		return 0;
> +
> +	for (i = irq; cnt > 0; i++, cnt--) {
> +		if (arch_setup_hwirq(i, node))
> +			goto err;
> +		irq_clear_status_flags(i, _IRQ_NOREQUEST);
> +	}
> +	return irq;
> +
> +err:
> +	for (i--; i >= irq; i--) {
> +		irq_set_status_flags(i, _IRQ_NOREQUEST | _IRQ_NOPROBE);
> +		arch_teardown_hwirq(i);
> +	}
> +	irq_free_descs(irq, cnt);
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(irq_alloc_hwirqs);

Okay, so regarding this and irq_domains, I think the functionality
overlaps and irq_domain conversion wouldn't directly use this API. I
could see two ways that it would be wired up in an irq_domain
conversion...

1) use an irq_domain to represent the root of the interrupt tree and be
responsible for all of the hardware irqs. Child interrupt controllers
would allocate a hwirq from the root irq_domain and program itself
accordingly. This approach would either not use this API, or make it
entirely internal to the root irq_domain.

2) Use this API as the root of the interrupt tree and make first level
of child interrupt controllers use this API to allocate HWIRQs to use
for their irq outputs.

Most of the platforms using irq_domain now fall in the first category,
which I think makes the most sense. Any platform like x86 that has
multiple hwirq vectors and the option of per-cpu vectors would be best
to keep all of that detail in one place. We could add a cpumask variant
to the irqdomain APIs, and add a stock implementation of an allocator
that can intelligently allocate when cpumasks are used.

g.

> +
> +/**
> + * irq_free_hwirqs - Free irq descriptor and cleanup the hardware
> + * @from:	Free from irq number
> + * @cnt:	number of interrupts to free
> + *
> + */
> +void irq_free_hwirqs(unsigned int from, int cnt)
> +{
> +	int i;
> +
> +	for (i = from; cnt > 0; i++, cnt--) {
> +		irq_set_status_flags(i, _IRQ_NOREQUEST | _IRQ_NOPROBE);
> +		arch_teardown_hwirq(i);
> +	}
> +	irq_free_descs(from, cnt);
> +}
> +EXPORT_SYMBOL_GPL(irq_free_hwirqs);
> +#endif
> +
>  /**
>   * irq_reserve_irqs - mark irqs allocated
>   * @from:	mark from irq number
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

