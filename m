Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932718Ab3BSNON (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 08:14:13 -0500
Received: from www.linutronix.de ([62.245.132.108]:32860 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758423Ab3BSNOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 08:14:12 -0500
Date: Tue, 19 Feb 2013 14:14:09 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Magnus Damm <magnus.damm@gmail.com>
cc: linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
        benh@kernel.crashing.org, grant.likely@secretlab.ca,
        horms@verge.net.au
Subject: Re: [PATCH] irqchip: Renesas INTC External IRQ pin driver
In-Reply-To: <CANqRtoSPmDkCF8fuxMrwr9AyU5vr10dhnEmbKwyE4A3MXZ0KUg@mail.gmail.com>
Message-ID: <alpine.LFD.2.02.1302191400170.22263@ionos>
References: <20130218142834.28739.39417.sendpatchset@w520> <alpine.LFD.2.02.1302191029510.22263@ionos> <CANqRtoSPmDkCF8fuxMrwr9AyU5vr10dhnEmbKwyE4A3MXZ0KUg@mail.gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Feb 2013, Magnus Damm wrote:
> On Tue, Feb 19, 2013 at 7:11 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> >> +static DEFINE_RAW_SPINLOCK(intc_irqpin_lock); /* only used by slow path */
> >
> > Shouldn't the lock be part of struct intc_irqpin_priv ?
> 
> Good idea, but I need to lock access to the SENSE register against
> multiple driver instances. This is not the case for PRIO. But because
> both PRIO and SENSE are accessed in the slow path I decided to be lazy
> and use the same way of locking to reduce the code size.

Fair enough.

> >> +static void intc_irqpin_irq_enable_force(struct irq_data *d)
> >> +{
> >> +     struct intc_irqpin_priv *p = irq_data_get_irq_chip_data(d);
> >> +     int irq = p->irq[irqd_to_hwirq(d)].irq;
> >> +
> >> +     intc_irqpin_irq_enable(d);
> >> +     irq_get_chip(irq)->irq_unmask(irq_get_irq_data(irq));
> >> +}
> >> +
> >> +static void intc_irqpin_irq_disable_force(struct irq_data *d)
> >> +{
> >> +     struct intc_irqpin_priv *p = irq_data_get_irq_chip_data(d);
> >> +     int irq = p->irq[irqd_to_hwirq(d)].irq;
> >> +
> >> +     irq_get_chip(irq)->irq_mask(irq_get_irq_data(irq));
> >> +     intc_irqpin_irq_disable(d);
> >
> > Hmm. If I understand that code correctly, then the _force functions
> > are (un)masking another interrupt line. But this happens without
> > holding irq_desc[irq]->lock. Looks unsafe at least and if correct
> > wants a big fat comment.
> 
> On some SoCs the masking for some IRQs seems busted, and the only sane
> way to work around that is to (un)mask the parent interrupt. The
> parent happens to be the GIC. I will look into how to add locking.

Is there a 1:1 relationship between the intc interrupt and the GIC? If
yes and if nothing else fiddles with that particular GIC interrupt,
then you might get away without extra locking, but that wants a
comment at least.
 
> >> +     irq_set_chip_and_handler(virq, &p->irq_chip, handle_level_irq);
> >> +     set_irq_flags(virq, IRQF_VALID); /* kill me now */
> >
> > What needs to be killed? -ENOPARSE
> 
> I'd like to not have to set this flag in my interrupt code.

Ah.
 
> I've written interrupt code on other architectures before, and from my
> experience only ARM requires the IRQF_VALID flag to be set because the
> ARM architecture software believes it is a special case. I may be
> behind times - I have to admit that I've not checked the latest state
> - this flag may not be needed anymore, hurray if so - but at least a
> couple of years ago it was needed in case of ARM for our shared INTC
> code (shared between sh and ARM).
> 
> What is your opinion about this matter?

It provides an extra paranoia level, but I'm not sure if it's really
worth the trouble.

Thanks,

	tglx
