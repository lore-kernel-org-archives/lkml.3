Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752838AbaCFTFw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 14:05:52 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:56259 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444AbaCFTFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 14:05:50 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 108.39.110.144
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/i0Ljp2y/xPhpnbb/s2f2Ocs8qgh8Q6NU=
X-DKIM: OpenDKIM Filter v2.0.1 titan 8DF3553C113
Date: Thu, 6 Mar 2014 14:05:31 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>
Subject: Re: [patch 5/5] irqchip: armanda: Sanitize set_irq_affinity()
Message-ID: <20140306190531.GF1872@titan.lakedaemon.net>
References: <20140304202425.102779779@linutronix.de>
 <20140304203101.088889302@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140304203101.088889302@linutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas,

nit: s/armanda/armada/ in the patch subject.

Gregory,

Mind providing an Ack on this?

thx,

Jason.

On Tue, Mar 04, 2014 at 08:43:41PM -0000, Thomas Gleixner wrote:
> The set_irq_affinity() function has two issues:
> 
> 1) It has no protection against selecting an offline cpu from the
>    given mask.
> 
> 2) It pointlessly restricts the affinity masks to have a single cpu
>    set. This collides with the irq migration code of arm.
> 
>    irq affinity is set to core 3
>    core 3 goes offline
> 
>    migration code sets mask to cpu_online_mask and calls the
>    irq_set_affinity() callback of the irq_chip which fails due to bit
>    0,1,2 set.
> 
> So instead of doing silly for_each_cpu() loops just pick any bit of
> the mask which intersects with the online mask.
> 
> The read back of the routing register is pointless as well. We can
> simply write the new mask as the bits in this register reflect one
> core.
> 
> Get rid of fiddling with the default_irq_affinity as well.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Gregory CLEMENT <gregory.clement@free-electrons.com>
> Cc: Jason Cooper <jason@lakedaemon.net>
> 
> ---
>  drivers/irqchip/irq-armada-370-xp.c |   38 ++++--------------------------------
>  1 file changed, 5 insertions(+), 33 deletions(-)
> 
> Index: tip/drivers/irqchip/irq-armada-370-xp.c
> ===================================================================
> --- tip.orig/drivers/irqchip/irq-armada-370-xp.c
> +++ tip/drivers/irqchip/irq-armada-370-xp.c
> @@ -244,35 +244,16 @@ static DEFINE_RAW_SPINLOCK(irq_controlle
>  static int armada_xp_set_affinity(struct irq_data *d,
>  				  const struct cpumask *mask_val, bool force)
>  {
> -	unsigned long reg;
> -	unsigned long new_mask = 0;
> -	unsigned long online_mask = 0;
> -	unsigned long count = 0;
>  	irq_hw_number_t hwirq = irqd_to_hwirq(d);
> +	unsigned long mask;
>  	int cpu;
>  
> -	for_each_cpu(cpu, mask_val) {
> -		new_mask |= 1 << cpu_logical_map(cpu);
> -		count++;
> -	}
> -
> -	/*
> -	 * Forbid mutlicore interrupt affinity
> -	 * This is required since the MPIC HW doesn't limit
> -	 * several CPUs from acknowledging the same interrupt.
> -	 */
> -	if (count > 1)
> -		return -EINVAL;
> -
> -	for_each_cpu(cpu, cpu_online_mask)
> -		online_mask |= 1 << cpu_logical_map(cpu);
> +	/* Select a single core from the affinity mask which is online */
> +	cpu = cpumask_any_and(mask_val, cpu_online_mask);
> +	mask = 1UL << cpu_logical_map(cpu);
>  
>  	raw_spin_lock(&irq_controller_lock);
> -
> -	reg = readl(main_int_base + ARMADA_370_XP_INT_SOURCE_CTL(hwirq));
> -	reg = (reg & (~online_mask)) | new_mask;
> -	writel(reg, main_int_base + ARMADA_370_XP_INT_SOURCE_CTL(hwirq));
> -
> +	writel(mask, main_int_base + ARMADA_370_XP_INT_SOURCE_CTL(hwirq));
>  	raw_spin_unlock(&irq_controller_lock);
>  
>  	return 0;
> @@ -494,15 +475,6 @@ static int __init armada_370_xp_mpic_of_
>  
>  #ifdef CONFIG_SMP
>  	armada_xp_mpic_smp_cpu_init();
> -
> -	/*
> -	 * Set the default affinity from all CPUs to the boot cpu.
> -	 * This is required since the MPIC doesn't limit several CPUs
> -	 * from acknowledging the same interrupt.
> -	 */
> -	cpumask_clear(irq_default_affinity);
> -	cpumask_set_cpu(smp_processor_id(), irq_default_affinity);
> -
>  #endif
>  
>  	armada_370_xp_msi_init(node, main_int_res.start);
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
