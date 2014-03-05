Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932594AbaCEOmg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 09:42:36 -0500
Received: from www.linutronix.de ([62.245.132.108]:43891 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606AbaCEOmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 09:42:33 -0500
Date: Wed, 5 Mar 2014 15:42:34 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@googlemail.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] Revert "irqchip: irq-dove: Add PMU interrupt
 controller."
In-Reply-To: <20140305004139.GT21483@n2100.arm.linux.org.uk>
Message-ID: <alpine.DEB.2.02.1403051445020.18573@ionos.tec.linutronix.de>
References: <20140304030838.GA1872@titan.lakedaemon.net> <1393911160-7688-1-git-send-email-jason@lakedaemon.net> <20140305004139.GT21483@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Mar 2014, Russell King - ARM Linux wrote:
> In some ways, this is good news - it shows that the bits in this register
> latch '1' when an interrupt is pending, and remain '1' while the block
> continues to assert its interrupt signal - but can we say that the other
> interrupt functions in this register have that behaviour?
> 
> >From the spec, it looks like this is probably true of DFSDone as well.
> DVSDone - I see no separate status register containing status bits
> indicating what the cause of the DVSDone status is.  The thermal bits -
> if it's a transitory excursion, may not hold.  Battery fault... we
> can guess.
> 
> Now, genirq doesn't have a good way to handle this.  I'll also say that
> because of the above, I've always been worried about hardware races when
> trying to clear down interrupts in this register - I'd much prefer not
> to touch it unless absolutely necessary.  So... how about this instead?
> 
>         u32 stat = readl_relaxed(gc->reg_base + DOVE_PMC_IRQ_CAUSE) &
>                    gc->mask_cache;
> 	u32 done = ~0;
> 
> 	while (stat) {
> 		unsigned hwirq = ffs(stat) - 1;
> 
> 		stat &= ~(1 << hwirq);
> 		done &= ~(1 << hwirq);
> 
> 		generic_handle_irq(irq_find_mapping(domain, hwirq));
> 	}
> 
> 	irq_gc_lock(gc);
> 	done &= readl_relaxed(gc->reg_base + DOVE_PMC_IRQ_CAUSE);
> 	writel_relaxed(done, gc->reg_base + DOVE_PMC_IRQ_CAUSE);
> 	irq_gc_unlock(gc);
> 
> This results in the RTC alarm test receiving exactly one interrupt for
> each alarm expiry, as it should do.  Thoughts?

You are worried about clearing an interrupt which is transitory and
not kept active at the device level until you handled it for real,
right?

Is the datasheet for this stuff public available?

> Another question: ffs(stat) - any reason to use ffs() there rather than
> fls(stat) which would result in simpler code?  r1 = ffs(r4 = stat) creates:
> 
>  198:   e2641000        rsb     r1, r4, #0
>  19c:   e1a00006        mov     r0, r6
>  1a0:   e0011004        and     r1, r1, r4
>  1a4:   e16f1f11        clz     r1, r1
>  1a8:   e261101f        rsb     r1, r1, #31
> 
> whereas fls(stat):
> 
>  198:   e16f1f14        clz     r1, r4
>  19c:   e261101f        rsb     r1, r1, #31
>  1a0:   e1a00006        mov     r0, r6
> 
> Kind of a micro-optimisation, but I see no reason to prefer one over the
> other except for this - and I think the switch to ffs() was made in the
> hope of optimising this code!

I don't think it matters in which order you process multiple pending
interrupts.

Thanks,

	tglx
