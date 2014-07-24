Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759789AbaGXWwO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 18:52:14 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:63876 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759740AbaGXWwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 18:52:12 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Dmitry Torokhov <dtor@google.com>
Subject: Re: [RFC][PATCH] irq: Rework IRQF_NO_SUSPENDED
Date: Fri, 25 Jul 2014 01:10:36 +0200
Message-ID: <13290270.IfKaUSRMLR@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140724212620.GO3935@laptop>
References: <20140724212620.GO3935@laptop>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, July 24, 2014 11:26:20 PM Peter Zijlstra wrote:
> Subject: irq: Rework IRQF_NO_SUSPENDED
> From: Peter Zijlstra <peterz@infradead.org>
> Date: Thu Jul 24 22:34:50 CEST 2014
> 
> Typically when devices are suspended they're quiesced such that they
> will not generate any further interrupts.
> 
> However some devices should still generate interrupts, even when
> suspended, typically used to wake the machine back up.
> 
> Such logic should ideally be contained inside each driver, if it can
> generate interrupts when suspended, it knows about this and the
> interrupt handler can deal with it.
> 
> Except of course for shared interrupts, when such a wakeup device is
> sharing an interrupt line with a device that does not expect
> interrupts while suspended things can go funny.
> 
> This is where IRQF_NO_SUSPEND comes in, the idea is that drivers that
> have the capability to wake the machine set IRQF_NO_SUSPEND and their
> handler will still be called, even when the IRQ subsystem is formally
> suspended. Handlers without IRQF_NO_SUSPEND will not be called.
> 
> This replaced the prior implementation of IRQF_NO_SUSPEND which had
> a number of fatal issues in that it didn't actually work for the
> shared case, exactly the case it should be helping.
> 
> There is still enable_irq_wake()/IRQD_WAKEUP_STATE that tries to serve
> a similar purpose but is equially wrecked for shared interrupts,
> ideally this would be removed.

Let me comment about this particular thing.

I had a discussion with Dmitry about that and his argument was that
enable_irq_wake() should imply IRQF_NO_SUSPEND, because drivers that
set up interrupts for system wakeup should expect those interrupts to
trigger at any time, including system suspend.  Hence the patch that
added the IRQD_WAKEUP_STATE check to __disable_irq().

However, in the face of the problem that is being addressed here I'm
not really sure that this argument is valid, because if the driver
calling enable_irq_wake() is sharing the IRQ with another one, the
other driver may not actually know that the IRQ will be a wakeup one
and still may not expect interrupts to come to it during system
suspend/resume.

Yes, drivers using enable_irq_wake() will likely want IRQF_NO_SUSPEND to
be set for their irqactions, but that should not imply "no suspend" for
all irqactions sharing the same desc.  So I guess it may be better to go
forth and use a global "interrupts suspended" state variable instead of the
IRQS_SUSPENDED flag for each desc and throw away the IRQD_WAKEUP_STATE
check from suspend_device_irqs() entirely.

Peter, it looks like you'd prefer that?

Rafael


> Cc: rjw@rjwysocki.net
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> ---
>  kernel/irq/chip.c      |    4 +---
>  kernel/irq/handle.c    |   24 +++++++++++++++++++++---
>  kernel/irq/internals.h |    6 ++++--
>  kernel/irq/manage.c    |   31 ++++++-------------------------
>  kernel/irq/pm.c        |   17 +++++++++--------
>  5 files changed, 41 insertions(+), 41 deletions(-)
> 
> --- a/kernel/irq/chip.c
> +++ b/kernel/irq/chip.c
> @@ -677,9 +677,7 @@ void handle_percpu_devid_irq(unsigned in
>  	if (chip->irq_ack)
>  		chip->irq_ack(&desc->irq_data);
>  
> -	trace_irq_handler_entry(irq, action);
> -	res = action->handler(irq, dev_id);
> -	trace_irq_handler_exit(irq, action, res);
> +	res = do_irqaction(desc, action, irq, dev_id);
>  
>  	if (chip->irq_eoi)
>  		chip->irq_eoi(&desc->irq_data);
> --- a/kernel/irq/handle.c
> +++ b/kernel/irq/handle.c
> @@ -131,6 +131,23 @@ void __irq_wake_thread(struct irq_desc *
>  }
>  
>  irqreturn_t
> +do_irqaction(struct irq_desc *desc, struct irqaction *action,
> +	     unsigned int irq, void *dev_id)
> +{
> +	irqreturn_t ret;
> +
> +	if (unlikely((desc->istate & IRQS_SUSPENDED) &&
> +		     !(action->flags & IRQF_NO_SUSPEND)))
> +		return IRQ_NONE;
> +
> +	trace_irq_handler_entry(irq, action);
> +	ret = action->handler(irq, dev_id);
> +	trace_irq_handler_exit(irq, action, ret);
> +
> +	return ret;
> +}
> +
> +irqreturn_t
>  handle_irq_event_percpu(struct irq_desc *desc, struct irqaction *action)
>  {
>  	irqreturn_t retval = IRQ_NONE;
> @@ -139,9 +156,7 @@ handle_irq_event_percpu(struct irq_desc
>  	do {
>  		irqreturn_t res;
>  
> -		trace_irq_handler_entry(irq, action);
> -		res = action->handler(irq, action->dev_id);
> -		trace_irq_handler_exit(irq, action, res);
> +		res = do_irqaction(desc, action, irq, action->dev_id);
>  
>  		if (WARN_ONCE(!irqs_disabled(),"irq %u handler %pF enabled interrupts\n",
>  			      irq, action->handler))
> @@ -175,6 +190,9 @@ handle_irq_event_percpu(struct irq_desc
>  
>  	add_interrupt_randomness(irq, flags);
>  
> +	if (unlikely(desc->istate & IRQS_SUSPENDED) && retval == IRQ_NONE)
> +		retval = IRQ_HANDLED;
> +
>  	if (!noirqdebug)
>  		note_interrupt(irq, desc, retval);
>  	return retval;
> --- a/kernel/irq/internals.h
> +++ b/kernel/irq/internals.h
> @@ -63,8 +63,10 @@ enum {
>  
>  extern int __irq_set_trigger(struct irq_desc *desc, unsigned int irq,
>  		unsigned long flags);
> -extern void __disable_irq(struct irq_desc *desc, unsigned int irq, bool susp);
> -extern void __enable_irq(struct irq_desc *desc, unsigned int irq, bool resume);
> +
> +extern irqreturn_t
> +do_irqaction(struct irq_desc *desc, struct irqaction *action,
> +	     unsigned int irq, void *dev_id);
>  
>  extern int irq_startup(struct irq_desc *desc, bool resend);
>  extern void irq_shutdown(struct irq_desc *desc);
> --- a/kernel/irq/manage.c
> +++ b/kernel/irq/manage.c
> @@ -382,15 +382,8 @@ setup_affinity(unsigned int irq, struct
>  }
>  #endif
>  
> -void __disable_irq(struct irq_desc *desc, unsigned int irq, bool suspend)
> +void __disable_irq(struct irq_desc *desc, unsigned int irq)
>  {
> -	if (suspend) {
> -		if (!desc->action || (desc->action->flags & IRQF_NO_SUSPEND) ||
> -		    irqd_has_set(&desc->irq_data, IRQD_WAKEUP_STATE))
> -			return;
> -		desc->istate |= IRQS_SUSPENDED;
> -	}
> -
>  	if (!desc->depth++)
>  		irq_disable(desc);
>  }
> @@ -402,7 +395,7 @@ static int __disable_irq_nosync(unsigned
>  
>  	if (!desc)
>  		return -EINVAL;
> -	__disable_irq(desc, irq, false);
> +	__disable_irq(desc, irq);
>  	irq_put_desc_busunlock(desc, flags);
>  	return 0;
>  }
> @@ -443,20 +436,8 @@ void disable_irq(unsigned int irq)
>  }
>  EXPORT_SYMBOL(disable_irq);
>  
> -void __enable_irq(struct irq_desc *desc, unsigned int irq, bool resume)
> +void __enable_irq(struct irq_desc *desc, unsigned int irq)
>  {
> -	if (resume) {
> -		if (!(desc->istate & IRQS_SUSPENDED)) {
> -			if (!desc->action)
> -				return;
> -			if (!(desc->action->flags & IRQF_FORCE_RESUME))
> -				return;
> -			/* Pretend that it got disabled ! */
> -			desc->depth++;
> -		}
> -		desc->istate &= ~IRQS_SUSPENDED;
> -	}
> -
>  	switch (desc->depth) {
>  	case 0:
>   err_out:
> @@ -498,7 +479,7 @@ void enable_irq(unsigned int irq)
>  		 KERN_ERR "enable_irq before setup/request_irq: irq %u\n", irq))
>  		goto out;
>  
> -	__enable_irq(desc, irq, false);
> +	__enable_irq(desc, irq);
>  out:
>  	irq_put_desc_busunlock(desc, flags);
>  }
> @@ -1079,7 +1060,7 @@ __setup_irq(unsigned int irq, struct irq
>  		 */
>  
>  #define IRQF_MISMATCH \
> -	(IRQF_TRIGGER_MASK | IRQF_ONESHOT | IRQF_NO_SUSPEND)
> +	(IRQF_TRIGGER_MASK | IRQF_ONESHOT)
>  
>  		if (!((old->flags & new->flags) & IRQF_SHARED) ||
>  		    ((old->flags ^ new->flags) & IRQF_MISMATCH))
> @@ -1232,7 +1213,7 @@ __setup_irq(unsigned int irq, struct irq
>  	 */
>  	if (shared && (desc->istate & IRQS_SPURIOUS_DISABLED)) {
>  		desc->istate &= ~IRQS_SPURIOUS_DISABLED;
> -		__enable_irq(desc, irq, false);
> +		__enable_irq(desc, irq);
>  	}
>  
>  	raw_spin_unlock_irqrestore(&desc->lock, flags);
> --- a/kernel/irq/pm.c
> +++ b/kernel/irq/pm.c
> @@ -29,14 +29,20 @@ void suspend_device_irqs(void)
>  	for_each_irq_desc(irq, desc) {
>  		unsigned long flags;
>  
> +		/*
> +		 * Ideally this would be a global state, but we cannot
> +		 * for the trainwreck that is IRQD_WAKEUP_STATE.
> +		 */
>  		raw_spin_lock_irqsave(&desc->lock, flags);
> -		__disable_irq(desc, irq, true);
> +		if (!irqd_has_set(&desc->irq_data, IRQD_WAKEUP_STATE))
> +			desc->istate |= IRQS_SUSPENDED;
>  		raw_spin_unlock_irqrestore(&desc->lock, flags);
>  	}
>  
> -	for_each_irq_desc(irq, desc)
> +	for_each_irq_desc(irq, desc) {
>  		if (desc->istate & IRQS_SUSPENDED)
>  			synchronize_irq(irq);
> +	}
>  }
>  EXPORT_SYMBOL_GPL(suspend_device_irqs);
>  
> @@ -47,14 +53,9 @@ static void resume_irqs(bool want_early)
>  
>  	for_each_irq_desc(irq, desc) {
>  		unsigned long flags;
> -		bool is_early = desc->action &&
> -			desc->action->flags & IRQF_EARLY_RESUME;
> -
> -		if (!is_early && want_early)
> -			continue;
>  
>  		raw_spin_lock_irqsave(&desc->lock, flags);
> -		__enable_irq(desc, irq, true);
> +		desc->istate &= ~IRQS_SUSPENDED;
>  		raw_spin_unlock_irqrestore(&desc->lock, flags);
>  	}
>  }
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
