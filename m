Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752202AbbAMKih (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 05:38:37 -0500
Received: from www.linutronix.de ([62.245.132.108]:43899 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967AbbAMKif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 05:38:35 -0500
Date: Tue, 13 Jan 2015 11:38:14 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Boris Brezillon <boris.brezillon@free-electrons.com>
cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [RFC PATCH] irqchip: add dumb demultiplexer implementation
In-Reply-To: <1420725159-20720-1-git-send-email-boris.brezillon@free-electrons.com>
Message-ID: <alpine.DEB.2.11.1501131117120.17382@nanos>
References: <alpine.DEB.2.11.1412162125000.17382@nanos> <1420725159-20720-1-git-send-email-boris.brezillon@free-electrons.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Jan 2015, Boris Brezillon wrote:
> 1) Is it close to what you had in mind ?

Yes.

> 2) I'm not sure which part of the code should go where, so don't hesitate
>    to point out misplaced sections.

Looks sane. Nits below.

> 3) Do I need to disable the source irq (the one feeding the irqchip) when
>    entering suspend (and enable it on resume) ?

That probably needs to be part of the dumb mask/unmask functions.,
i.e. if no demux interrupt is enabled, the source irq should be
masked.

> 4) I'm not sure of what flags should be set/cleared when mapping an
>    interrupt. Should I let the caller decide of this config (something
>    similar to what is done in generic-chip) ?

I don't think you need to set/clear anything. Lets look at that dumb
demux chip as a real electronic circuit

     	     	  |----------------|
		  |                |
     	     	  |  --|Unmasked|--|---- Demux0
		  |  |             |
     SRC irq -----|-- -|Unmasked|--|---- Demux1
		  |  |             |
     	     	  |  --|Unmasked|--|---- Demux2
		  |                |
     	     	  |----------------|

Whether a demultiplexed interrupt is mapped or not is not really
important. The only relevant information is whether its masked or
not. So the default state is masked until a demultiplexed interrupt
gets requested.

> +/**
> + * enum irq_dumb_demux_flags - Initialization flags for generic irq chips
> + * @IRQ_DD_INIT_NESTED_LOCK:	Set the lock class of the irqs to nested for
> + *				irq chips which need to call irq_set_wake() on
> + *				the parent irq. Usually GPIO implementations
> + */
> +enum irq_dumb_demux_flags {
> +	IRQ_DD_INIT_NESTED_LOCK		= 1 << 0,
> +};
> +
> +/**
> + * struct irq_chip_dumb_demux - Dumb demultiplexer irq chip data structure
> + * @domain:		irq domain pointer
> + * @max_irq:		Last valid irq
> + * @available:		Bitfield of valid irqs
> + * @unmasked:		Bitfield containing irqs status
> + * @flags:		irq_dumb_demux_flags flags
> + *
> + * Note, that irq_chip_generic can have multiple irq_chip_type
> + * implementations which can be associated to a particular irq line of
> + * an irq_chip_generic instance. That allows to share and protect
> + * state in an irq_chip_generic instance when we need to implement
> + * different flow mechanisms (level/edge) for it.
> + */
> +struct irq_chip_dumb_demux {
> +	struct irq_domain *domain;
> +	int max_irq;
> +	unsigned long *available;
> +	unsigned long *unmasked;

Why pointers? A single ulong is certainly enough.

> +/**
> + *	handle_dumb_demux_irq - Dumb demuxer irq handle function.
> + *	@irq:	the interrupt number
> + *	@desc:	the interrupt description structure for this irq
> + *
> + *	Dumb demux interrupts are sent from a demultiplexing interrupt handler
> + *	which is not able to decide which child interrupt interrupt handler
> + *	should be called.
> + *
> + *	Note: The caller is expected to handle the ack, clear, mask and
> + *	unmask issues if necessary.
> + */
> +irqreturn_t
> +handle_dumb_demux_irq(unsigned int irq, struct irq_desc *desc)
> +{
> +	irqreturn_t retval = IRQ_NONE;
> +
> +	raw_spin_lock(&desc->lock);
> +
> +	if (!irq_may_run(desc))
> +		goto out_unlock;
> +
> +	desc->istate &= ~(IRQS_REPLAY | IRQS_WAITING);
> +	kstat_incr_irqs_this_cpu(irq, desc);
> +
> +	if (unlikely(!desc->action || irqd_irq_disabled(&desc->irq_data))) {
> +		desc->istate |= IRQS_PENDING;
> +		goto out_unlock;
> +	}
> +
> +	retval = handle_irq_event_no_spurious_check(desc);
> +
> +out_unlock:
> +	raw_spin_unlock(&desc->lock);
> +
> +	return retval;
> +}
> +EXPORT_SYMBOL_GPL(handle_dumb_demux_irq);

This should go into the new file as well, so it gets compiled out when
not enabled.

> +static void irq_dumb_demux_mask(struct irq_data *d)
> +{
> +	struct irq_chip_dumb_demux *demux = irq_data_get_irq_chip_data(d);
> +
> +	clear_bit(d->hwirq, demux->unmasked);
> +}
> +
> +static void irq_dumb_demux_unmask(struct irq_data *d)
> +{
> +	struct irq_chip_dumb_demux *demux = irq_data_get_irq_chip_data(d);
> +
> +	set_bit(d->hwirq, demux->unmasked);
> +}

So this needs the handling of enabling/disabling the source irq.

> +static struct irq_chip irq_dumb_demux_chip = {
> +	.name = "dumb-demux-irq",
> +	.irq_mask = irq_dumb_demux_mask,
> +	.irq_unmask = irq_dumb_demux_unmask,

+	.name		= "dumb-demux-irq",
+	.irq_mask	= irq_dumb_demux_mask,
+	.irq_unmask	= irq_dumb_demux_unmask,

Makes it simpler to read.

> +struct irq_domain_ops irq_dumb_demux_domain_ops = {
> +	.map	= irq_map_dumb_demux_chip,
> +	.xlate	= irq_domain_xlate_onecell,
> +};
> +EXPORT_SYMBOL(irq_dumb_demux_domain_ops);

SYMBOL_GPL please

Rest looks good.

Thanks,

	tglx
