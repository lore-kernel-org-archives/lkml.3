Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616AbaH2Bc0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 21:32:26 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:56119 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750892AbaH2BcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 21:32:24 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Dmitry Torokhov <dtor@google.com>, Aubrey Li <aubrey.li@intel.com>
Subject: Re: [PATCH 2/5 v3] irq / PM: Make wakeup interrupts work with suspend-to-idle
Date: Fri, 29 Aug 2014 03:51:35 +0200
Message-ID: <2033792.OsOnfZ7sX5@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <alpine.DEB.2.10.1408281109110.23342@nanos>
References: <26580319.OZP7jvJnA9@vostro.rjw.lan> <7346724.A5YknVMkmd@vostro.rjw.lan> <alpine.DEB.2.10.1408281109110.23342@nanos>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, August 28, 2014 11:23:11 AM Thomas Gleixner wrote:
> On Thu, 28 Aug 2014, Rafael J. Wysocki wrote:
> > On Wednesday, August 27, 2014 10:32:23 PM Thomas Gleixner wrote:
> > > void suspend_device_irqs(void)
> > > {
> > > 	for_each_irq_desc(irq, desc) {
> > > 		/* Disable the interrupt unconditionally */	       
> > > 		disable_irq(irq);
> > 
> > We still need to skip the IRQF_NO_SUSPEND stuff (eg. timers), so I guess
> > everything left disabled here needs to be IRQS_SUSPENDED, so we know which
> > ones to re-enable in resume_device_irqs().
> 
> Right. I skipped that one for simplicity. I wanted to look into the
> whole maze today again with brain awake. I think it's simple to
> integrate the no suspend magic here and have a separate handler for
> it.

Well, I've already read your message about this particular thing. :-)

Before that I was about to say that I'd rather leave the no suspend stuff as
is for now until we have working wakeup IRQs for suspend-to-idle at least.

> > > 
> > > 		/* Is the irq a wakeup source? */
> > > 		if (!irqd_is_wakeup_set(&desc->irq_data))
> > > 			continue;
> > > 
> > > 		/* Replace the handler */
> > > 		raw_spin_lock_irqsave(&desc->lock, flags);
> > > 	     	desc->saved_handler = desc->handler;
> > > 		desc->handler = handle_wakeup_irq;
> > 
> > Hmm.  There's no handler field in struct irq_desc (/me is puzzled).
> > 
> > Did you mean handle_irq (I think you did)?
> 
> Yup.

So I got that to work earlier today, but with some more stuff in the handler
which doesn't look particularly generic to me.  Namely, my (working) wakeup
handler looks like this at the moment:

static void handle_wakeup_irq(unsigned int irq, struct irq_desc *desc)
{
	struct irq_chip *chip = irq_desc_get_chip(desc);

	raw_spin_lock(&desc->lock);

	desc->istate &= ~(IRQS_REPLAY | IRQS_WAITING);
	kstat_incr_irqs_this_cpu(irq, desc);

	if (irqd_irq_disabled(&desc->irq_data)) {
		desc->istate |= IRQS_PENDING;
		mask_irq(desc);
	} else {
		desc->istate |= IRQS_SUSPENDED | IRQS_PENDING;
		desc->depth++;
		irq_disable(desc);
		pm_system_wakeup();
	}

	if (chip->irq_eoi && !(chip->flags & IRQCHIP_EOI_IF_HANDLED))
		chip->irq_eoi(&desc->irq_data);

	raw_spin_unlock(&desc->lock);
}

but it only works on a particular machine with a particular wakeup interrupt.

I had to add the

	if (chip->irq_eoi && !(chip->flags & IRQCHIP_EOI_IF_HANDLED))
		chip->irq_eoi(&desc->irq_data);

check, because otherwise it hanged the system solid once the interrupt happened.

I also had to add this:


	if (irqd_irq_disabled(&desc->irq_data)) {
		desc->istate |= IRQS_PENDING;
		mask_irq(desc);
	} ...

because otherwise the IRQ didn't work correctly after resume.

However, both those things appear to be needed just because that's a fastEOI
interrupt and some other manipulations would need to be done for edge interrupts
etc.

I'm not sure, then, if we really can come up with a perfectly generic handle_irq
wakeup interrupt handler that would work with all kinds of IRQs.  It looks like
the part that could be replaced in all of them in principle is the handle_irq_event()
call, but the rest seems to be too specific to me.

So I'm not sure what to do at this point.

It is tempting to do the following:
(1) Add a handle_event callback to struct irq_desc.
(2) Rename the existing handle_irq_event() to handle_irq_event_common().
(3) Point desc->handle_event to handle_irq_event_common() for every desc at init.
(4) Make (new, possibly static inline) handle_irq_event() invoke desc->handle_event().
(5) During suspend_device_irqs() point desc->handle_event to handle_irq_event_wakeup()
    for all wakeup IRQs.
(6) During resume_device_irqs() point desc->handle_event back to handle_irq_event_common()
    for everybody.
Then, for CONFIG_PM_SLEEP unset, handle_irq_event() can be defined as
handle_irq_event_common().

Of course, that adds a function pointer dereference overhead to every interrupt
event, so I'm not sure if it's acceptable.

One alternative may be to add a handle_wakeup_irq pointer to struct irq_desc and
check in handle_irq_event() if that is present and call it instead of the usual
stuff if that's the case.

Another way may be to introduce an irq_desc flag that will be checked by
handle_irq_event() and will indicate "wakeup mode" to it, in which it will do
the simplified wakeup handling instead of the usual stuff.  This, however, like
the previous one, will add a branch to handle_irq_event() that will be checked
every time even though it only is really necessary during system suspend.

And handlers can be replaced at the irqaction level in a couple of ways too.

Rafael

