Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760323AbaGYM3D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 08:29:03 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:50715 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1760148AbaGYM3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 08:29:00 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [RFC][PATCH] irq: Rework IRQF_NO_SUSPENDED
Date: Fri, 25 Jul 2014 14:47:25 +0200
Message-ID: <1805200.1exkRoNuC2@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <alpine.DEB.2.10.1407251135590.23352@nanos>
References: <20140724212620.GO3935@laptop> <alpine.DEB.2.10.1407251135590.23352@nanos>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, July 25, 2014 11:40:48 AM Thomas Gleixner wrote:
> On Thu, 24 Jul 2014, Peter Zijlstra wrote:
> > @@ -29,14 +29,20 @@ void suspend_device_irqs(void)
> >  	for_each_irq_desc(irq, desc) {
> >  		unsigned long flags;
> >  
> > +		/*
> > +		 * Ideally this would be a global state, but we cannot
> > +		 * for the trainwreck that is IRQD_WAKEUP_STATE.
> > +		 */
> >  		raw_spin_lock_irqsave(&desc->lock, flags);
> > -		__disable_irq(desc, irq, true);
> > +		if (!irqd_has_set(&desc->irq_data, IRQD_WAKEUP_STATE))
> > +			desc->istate |= IRQS_SUSPENDED;
> >  		raw_spin_unlock_irqrestore(&desc->lock, flags);
> >  	}
> >  
> > -	for_each_irq_desc(irq, desc)
> > +	for_each_irq_desc(irq, desc) {
> >  		if (desc->istate & IRQS_SUSPENDED)
> >  			synchronize_irq(irq);
> > +	}
> >  }
> 
> So, instead of disabling the interrupt you just mark it
> suspended. Good luck with level triggered interrupt lines then.
> 
> Assume the interrupt fires after you marked it suspended. Then the
> flow handler will call handle_irq_event() which will do nothing and
> return handled. So the flow handler will reenable the interrupt line,
> which will cause the interrupt to fire immediately again after the
> RETI. Guess how much progress the system is going to make when that
> happens.

Good point.

So it looks like we really need the "suspend" thing to either disable
the interrupt entirely (in which case all handlers for all actions
will not be invoked after it's been suspended) or leave it enabled
(causing all handlers to be invoked all the time).

I'm not sure if we can do much beyond what's already in your tree
about that, then.

Well, perhaps the patch failing the irq request in case of the
IRQF_NO_SUSPEND mismatch is a bit too drastic.  Instead, we could
just print a warning in __setup_irq() in that case and then check
IRQF_NO_SUSPEND for all actions in __disable_irq().

What about this?

---
 kernel/irq/manage.c |   22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

Index: linux-pm/kernel/irq/manage.c
===================================================================
--- linux-pm.orig/kernel/irq/manage.c
+++ linux-pm/kernel/irq/manage.c
@@ -385,8 +385,17 @@ setup_affinity(unsigned int irq, struct
 void __disable_irq(struct irq_desc *desc, unsigned int irq, bool suspend)
 {
 	if (suspend) {
-		if (!desc->action || (desc->action->flags & IRQF_NO_SUSPEND)
-		    || irqd_has_set(&desc->irq_data, IRQD_WAKEUP_STATE))
+		struct irqaction *action = desc->action;
+		unsigned int flags;
+
+		if (!action || irqd_has_set(&desc->irq_data, IRQD_WAKEUP_STATE))
+			return;
+		flags = IRQF_NO_SUSPEND;
+		do {
+			flags &= action->flags;
+			action = action->next;
+		} while (action);
+		if (flags)
 			return;
 		desc->istate |= IRQS_SUSPENDED;
 	}
@@ -1079,7 +1088,7 @@ __setup_irq(unsigned int irq, struct irq
 		 */
 
 #define IRQF_MISMATCH \
-	(IRQF_TRIGGER_MASK | IRQF_ONESHOT | IRQF_NO_SUSPEND)
+	(IRQF_TRIGGER_MASK | IRQF_ONESHOT)
 
 		if (!((old->flags & new->flags) & IRQF_SHARED) ||
 		    ((old->flags ^ new->flags) & IRQF_MISMATCH))
@@ -1090,6 +1099,13 @@ __setup_irq(unsigned int irq, struct irq
 		    (new->flags & IRQF_PERCPU))
 			goto mismatch;
 
+		if ((old->flags & IRQF_NO_SUSPEND) !=
+		    (new->flags & IRQF_NO_SUSPEND)) {
+			pr_err("irq %d: IRQF_NO_SUSPEND mismatch %08x (%s) vs. %08x (%s)\n",
+			       irq, new->flags, new->name, old->flags, old->name);
+			pr_err("irq %d: IRQF_NO_SUSPEND will be ignored\n");
+		}
+
 		/* add new interrupt at end of irq queue */
 		do {
 			/*

