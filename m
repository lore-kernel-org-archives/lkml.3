Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936064AbaH0WcB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 18:32:01 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:54624 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932305AbaH0WcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 18:32:00 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Dmitry Torokhov <dtor@google.com>, Aubrey Li <aubrey.li@intel.com>
Subject: Re: [PATCH 2/5 v3] irq / PM: Make wakeup interrupts work with suspend-to-idle
Date: Thu, 28 Aug 2014 00:51:09 +0200
Message-ID: <7346724.A5YknVMkmd@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <alpine.DEB.2.10.1408272130350.3323@nanos>
References: <26580319.OZP7jvJnA9@vostro.rjw.lan> <16387974.EqoNYrShmO@vostro.rjw.lan> <alpine.DEB.2.10.1408272130350.3323@nanos>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, August 27, 2014 10:32:23 PM Thomas Gleixner wrote:
> On Wed, 27 Aug 2014, Rafael J. Wysocki wrote:
> > The line of reasoning leading to that is as follows.
> > 
> > The way suspend_device_irqs() works and the existing code in
> > check_wakeup_irqs(), called by syscore_suspend(), imply that:
> > 
> >   (1) Interrupt handlers are not invoked for wakeup interrupts
> >       after suspend_device_irqs().
> > 
> >   (2) All interrups from system wakeup IRQs received after\
> >       suspend_device_irqs() cause full system suspends to be aborted.
> > 
> > In addition to the above, there is the requirement that
> > 
> >   (3) System wakeup interrupts should wake up the system from
> >       suspend-to-idle.
> > 
> > It immediately follows from (1) and (2) that no effort is made to
> > distinguish "genuine" wakeup interrupts from "spurious" ones.  They
> > all are treated in the same way.  Since (3) means that "genuine"
> > wakeup interrupts are supposed to wake up the system from
> > suspend-to-idle too, consistency with (1) and (2) requires that
> > "spurious" wakeup interrupts should do the same thing.  Thus there is
> > no reason to invoke interrupt handlers for wakeup interrups after
> > suspend_device_irqs() in the suspend-to-idle case.  Moreover, doing
> > so would go against rule (1).
> 
> I agree with that, but I disagree with the implementation.
> 
> We now have two separate mechanisms to abort suspend:
> 
> 1) The existing suspend_device_irqs() / check_wakeup_irqs() 
> 
> 2) The new suspend_device_irqs() /
>    reenable_stuff_and_fiddle_with_irq_action()
> 
> So why do we need those two mechanisms in the first place?
> 
> AFAICT there is no reason why we cant use the abort_suspend mechanics
> to replace the suspend_device_irqs() / check_wakeup_irqs() pair.
> 
> All it needs is to do the handler substitution in
> suspend_device_irqs() right away and replace the loop in
> check_wakeup_irqs() with a check for abort_suspend == true. The roll
> back of the handler substitution can happen in resume_device_irqs()
> for both scenarios.

We can do that of course.

> Aside of that the whole irqaction based substitution is silly. What's
> wrong with doing it at the real interrupt handler level?

Nothing I suppose. :-)

> static void handle_wakeup_irq(unsigned int irq, struct irq_desc *desc)
> {
> 	raw_spin_lock(&desc->lock);
> 
> 	desc->istate |= IRQS_SUSPENDED | IRQS_PENDING;
> 	desc->depth++;
> 	irq_disable(desc);
> 	pm_system_wakeup();
> 
> 	raw_spin_unlock(&desc->lock);
> }
> 
> void suspend_device_irqs(void)
> {
> 	for_each_irq_desc(irq, desc) {
> 		/* Disable the interrupt unconditionally */	       
> 		disable_irq(irq);

We still need to skip the IRQF_NO_SUSPEND stuff (eg. timers), so I guess
everything left disabled here needs to be IRQS_SUSPENDED, so we know which
ones to re-enable in resume_device_irqs().

> 
> 		/* Is the irq a wakeup source? */
> 		if (!irqd_is_wakeup_set(&desc->irq_data))
> 			continue;
> 
> 		/* Replace the handler */
> 		raw_spin_lock_irqsave(&desc->lock, flags);
> 	     	desc->saved_handler = desc->handler;
> 		desc->handler = handle_wakeup_irq;

Hmm.  There's no handler field in struct irq_desc (/me is puzzled).

Did you mean handle_irq (I think you did)?

> 		raw_spin_unlock_irqrestore(&desc->lock, flags);
> 
> 		/* Reenable the wakeup irq */
> 		enable_irq(irq);
> 	}
> }
> 
> /* Move that into the pm core code */
> bool check_wakeup_irqs(void)
> {
> 	return abort_suspend;
> }
> 
> void resume_device_irqs(void)
> {
> 	for_each_irq_desc(irq, desc) {
> 
> 		/* Prevent the wakeup handler from running */
> 		disable_irq();
> 
> 		raw_spin_lock_irqsave(&desc->lock, flags);
> 
> 		/* Do we need to restore the handler? */
> 		if (desc->handler == handle_wakeup_irq)
> 		   	desc->handler = desc->saved_handler;
> 
> 		/* Is the irq a wakeup source? */
> 		if (!irqd_is_wakeup_set(&desc->irq_data))
> 		   	__enable_irq(irq, desc);
> 
> 		/* Did it get disabled in the wakeup handler? */
> 		else if (desc->istate & IRQS_SUSPENDED)
> 		   	__enable_irq(irq, desc);
> 
> 		raw_spin_unlock_irqrestore(&desc->lock, flags);
> 
> 		enable_irq();
> 	}
> }
> 
> Hmm?

OK

There is quite some ugliness related to resume_irqs(), the want_early thing
and IRQF_EARLY_RESUME / IRQF_FORCE_RESUME.  I guess that needs to be preserved?

> One thing we might think about is having flow specific
> handle_wakeup_irq variants as some hardware might require an ack or
> eoi, but that's a simple to solve problem and way simpler than
> fiddling with the irqaction chain and avoids the whole mess of
> sprinkling irq_pm_saved_id() and irq_pm_restore_handler() calls all
> over the place. I wonder why you added them to __free_irq() at all,
> but no, we dont want that.

I was concerned about the (unlikely) possibility of freeing an interrupt
having a temporary handler.  Never mind.

Rafael

