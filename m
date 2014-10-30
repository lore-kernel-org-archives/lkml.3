Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161175AbaJ3P7I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 11:59:08 -0400
Received: from www.linutronix.de ([62.245.132.108]:36234 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759739AbaJ3P7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 11:59:06 -0400
Date: Thu, 30 Oct 2014 16:59:02 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Marc Zyngier <marc.zyngier@arm.com>
cc: Jason Cooper <jason@lakedaemon.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/3] genirq: Add support for priority-drop/deactivate
 interrupt controllers
In-Reply-To: <54524804.4080501@arm.com>
Message-ID: <alpine.DEB.2.11.1410301627570.5308@nanos>
References: <1414235215-10468-1-git-send-email-marc.zyngier@arm.com> <1414235215-10468-2-git-send-email-marc.zyngier@arm.com> <alpine.DEB.2.11.1410252144170.5308@nanos> <544E67D8.3020504@arm.com> <alpine.DEB.2.11.1410272158160.5308@nanos> <544FF183.9030705@arm.com>
 <alpine.DEB.2.11.1410282054490.5308@nanos> <5450BD61.10102@arm.com> <alpine.DEB.2.11.1410291115310.5308@nanos> <54524804.4080501@arm.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Oct 2014, Marc Zyngier wrote:
> So I actually implemented this, and did hit another snag: per cpu interrupts.
> They don't use the startup/shutdown methods, and reproducing the above logic
> on a per-cpu basis is not very pretty.

Hmm. Have not looked at the percpu stuff yet.
 
>  /**
> + *	handle_spliteoi_irq - irq handler for 2-phase-eoi controllers
> + *	@irq:	the interrupt number
> + *	@desc:	the interrupt description structure for this irq
> + *
> + *	This relies on mask being a very cheap operation, and on
> + *	unmask performing both unmask+EOI. This avoids additional
> + *	operations for threaded interrupts (typically ARM's GICv2/v3).
> + */
> +void
> +handle_spliteoi_irq(unsigned int irq, struct irq_desc *desc)
> +{
> +	raw_spin_lock(&desc->lock);
> +
> +	if (!irq_may_run(desc))
> +		goto out;
> +
> +	desc->istate &= ~(IRQS_REPLAY | IRQS_WAITING);
> +	kstat_incr_irqs_this_cpu(irq, desc);
> +
> +	/* Mark the IRQ as in progress */
> +	mask_irq(desc);
> +
> +	/*
> +	 * If it's disabled or no action available
> +	 * then just get out of here:
> +	 */
> +	if (unlikely(!desc->action || irqd_irq_disabled(&desc->irq_data))) {
> +		desc->istate |= IRQS_PENDING;
> +		goto out_unmask;

If this handler is used with the lazy disable approach then this goto
causes an irq storm if the interrupt stays active (LEVEL).

So this relies on irq_disable() actually disabling the interrupt at
the hardware level. That really wants a big fat comment if we take
this approach.

Now there is another issue. Assume the following:

CPU 0	     	     	    	CPU 1
handle_spliteoi_irq()
  mask_irq();
     handle_event();
        wake_thread();
  return;

run_thread()
   call_handler();
				disable_irq()
				    irq_disable()
   finalize_oneshot()
     if (disabled)
     	return;

So that particular interrupt gets never acknowledged with a write to
DIR. 

What happens if you enable it again at the hardware level via
enable_irq()? Is it still in dropped priority mode and waits for the
write to DIR forever? That's what I tried to avoid with my approach.

Thanks,

	tglx
