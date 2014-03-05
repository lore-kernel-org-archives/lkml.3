Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756505AbaCEAlx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 19:41:53 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:38004 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754758AbaCEAlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 19:41:52 -0500
Date: Wed, 5 Mar 2014 00:41:39 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jason Cooper <jason@lakedaemon.net>, Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@googlemail.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] Revert "irqchip: irq-dove: Add PMU interrupt
	controller."
Message-ID: <20140305004139.GT21483@n2100.arm.linux.org.uk>
References: <20140304030838.GA1872@titan.lakedaemon.net> <1393911160-7688-1-git-send-email-jason@lakedaemon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393911160-7688-1-git-send-email-jason@lakedaemon.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 04, 2014 at 05:32:40AM +0000, Jason Cooper wrote:
> -static void dove_pmu_irq_handler(unsigned int irq, struct irq_desc *desc)
> -{
> -	struct irq_domain *d = irq_get_handler_data(irq);
> -	struct irq_chip_generic *gc = irq_get_domain_generic_chip(d, 0);
> -	u32 stat = readl_relaxed(gc->reg_base + DOVE_PMU_IRQ_CAUSE) &
> -		   gc->mask_cache;
> -
> -	while (stat) {
> -		u32 hwirq = ffs(stat) - 1;
> -
> -		generic_handle_irq(irq_find_mapping(d, gc->irq_base + hwirq));
> -		stat &= ~(1 << hwirq);
> -	}
> -}
> -
> -static void pmu_irq_ack(struct irq_data *d)
> -{
> -	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
> -	struct irq_chip_type *ct = irq_data_get_chip_type(d);
> -	u32 mask = ~d->mask;
> -
> -	/*
> -	 * The PMU mask register is not RW0C: it is RW.	 This means that
> -	 * the bits take whatever value is written to them; if you write
> -	 * a '1', you will set the interrupt.
> -	 *
> -	 * Unfortunately this means there is NO race free way to clear
> -	 * these interrupts.
> -	 *
> -	 * So, let's structure the code so that the window is as small as
> -	 * possible.
> -	 */
> -	irq_gc_lock(gc);
> -	mask &= irq_reg_readl(gc->reg_base +  ct->regs.ack);
> -	irq_reg_writel(mask, gc->reg_base +  ct->regs.ack);
> -	irq_gc_unlock(gc);
> -}

Jason, Thomas,

I've just been giving the above a whirl here with the RTC, and it
doesn't seem to quite work as it should.  Not your problem, because it's
as the code is originally.

Let's say you set an alarm for 10sec time.  When the alarm fires:

- we read the PMU interrupt status, mask it with the mask register,
  and find the RTC pending.
- we call the genirq layer for this interrupt.
- genirq does the mask + ack thing.
- the RTC interrupt handler is called, and there's the RTC says there's
  an interrupt pending.
- the RTC handler clears the interrupt, and returns.
- genirq unmasks the interrupt, and returns.
- dove_pmu_irq_handler() is re-entered, and again, we find that the
  RTC interrupt is pending.
- follow the above...
- the RTC interrupt handler is called, but this time there's no interrupt
  pending, so returns IRQ_NONE
- genirq unmasks the interrupt, and returns.

The reason this happens is that the attempt to "ack" - rather "clear" the
interrupt the first time around has no effect - the RTC is still asserting
the interrupt, so the write to clear the register results in the bit
remaining set.

The second time around, we've already cleared the RTC interrupt, so this
time, the ack clears the interrupt down properly.

In some ways, this is good news - it shows that the bits in this register
latch '1' when an interrupt is pending, and remain '1' while the block
continues to assert its interrupt signal - but can we say that the other
interrupt functions in this register have that behaviour?

>From the spec, it looks like this is probably true of DFSDone as well.
DVSDone - I see no separate status register containing status bits
indicating what the cause of the DVSDone status is.  The thermal bits -
if it's a transitory excursion, may not hold.  Battery fault... we
can guess.

Now, genirq doesn't have a good way to handle this.  I'll also say that
because of the above, I've always been worried about hardware races when
trying to clear down interrupts in this register - I'd much prefer not
to touch it unless absolutely necessary.  So... how about this instead?

        u32 stat = readl_relaxed(gc->reg_base + DOVE_PMC_IRQ_CAUSE) &
                   gc->mask_cache;
	u32 done = ~0;

	while (stat) {
		unsigned hwirq = ffs(stat) - 1;

		stat &= ~(1 << hwirq);
		done &= ~(1 << hwirq);

		generic_handle_irq(irq_find_mapping(domain, hwirq));
	}

	irq_gc_lock(gc);
	done &= readl_relaxed(gc->reg_base + DOVE_PMC_IRQ_CAUSE);
	writel_relaxed(done, gc->reg_base + DOVE_PMC_IRQ_CAUSE);
	irq_gc_unlock(gc);

This results in the RTC alarm test receiving exactly one interrupt for
each alarm expiry, as it should do.  Thoughts?

Another question: ffs(stat) - any reason to use ffs() there rather than
fls(stat) which would result in simpler code?  r1 = ffs(r4 = stat) creates:

 198:   e2641000        rsb     r1, r4, #0
 19c:   e1a00006        mov     r0, r6
 1a0:   e0011004        and     r1, r1, r4
 1a4:   e16f1f11        clz     r1, r1
 1a8:   e261101f        rsb     r1, r1, #31

whereas fls(stat):

 198:   e16f1f14        clz     r1, r4
 19c:   e261101f        rsb     r1, r1, #31
 1a0:   e1a00006        mov     r0, r6

Kind of a micro-optimisation, but I see no reason to prefer one over the
other except for this - and I think the switch to ffs() was made in the
hope of optimising this code!

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
