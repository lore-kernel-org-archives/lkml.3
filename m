Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751553AbaG1U6u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 16:58:50 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:57599 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750708AbaG1U6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 16:58:48 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH, v3] irq / PM: Fix IRQF_NO_SUSPEND problem with shared interrupts (was: Re: [PATCH, v2])
Date: Mon, 28 Jul 2014 23:17:18 +0200
Message-ID: <4823828.8eNZIeQFq1@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <alpine.DEB.2.10.1407281350550.23352@nanos>
References: <20140724212620.GO3935@laptop> <3337421.bsfMykWVnZ@vostro.rjw.lan> <alpine.DEB.2.10.1407281350550.23352@nanos>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, July 28, 2014 02:11:35 PM Thomas Gleixner wrote:
> On Mon, 28 Jul 2014, Rafael J. Wysocki wrote:
> > On Sunday, July 27, 2014 05:53:07 PM Rafael J. Wysocki wrote:
> >  irqreturn_t
> > +do_irqaction(struct irq_desc *desc, struct irqaction *action,
> > +	     unsigned int irq, void *dev_id)
> > +{
> > +	irqreturn_t ret;
> > +
> > +	if (unlikely((desc->istate & IRQS_SHARED_SUSPENDED) &&
> > +		     !(action->flags & IRQF_NO_SUSPEND)))
> > +		return IRQ_NONE;
> 
> I really want to avoid that conditional. We burden it on every
> interrupt just to deal with this nonsense.

Yes, that's concerning.  I had an idea to use a dummy interrupt
handler for the suspended ones, but ->

> A simple solution for this is to add irq_desc::action_suspended and
> move the shared actions which are not flagged NO_SUSPEND over and
> bring them back on resume.

-> this is a better idea even, thanks!  And it doesn't matter if they are
reordered in the process, right?

> > Index: linux-pm/kernel/irq/spurious.c
> > ===================================================================
> > --- linux-pm.orig/kernel/irq/spurious.c
> > +++ linux-pm/kernel/irq/spurious.c
> > @@ -275,6 +275,8 @@ try_misrouted_irq(unsigned int irq, stru
> >  void note_interrupt(unsigned int irq, struct irq_desc *desc,
> >  		    irqreturn_t action_ret)
> >  {
> > +	int misrouted;
> > +
> >  	if (desc->istate & IRQS_POLL_INPROGRESS ||
> >  	    irq_settings_is_polled(desc))
> >  		return;
> > @@ -384,6 +386,9 @@ void note_interrupt(unsigned int irq, st
> >  		}
> >  	}
> >  
> > +	misrouted = unlikely(try_misrouted_irq(irq, desc, action_ret)) ?
> > +			misrouted_irq(irq) : 0;
> 
> If the system is suspended, why would we try misrouted irqs at all?
> All non wakeup irqs are disabled,

Well, not only wakeup interrupts are enabled then.  Timer interrupts are still
enabled too as well as the ACPI ones, for example.

> so we just spend a gazillion of cycles for nothing.

My concern was that if turned out to be misrouted for some oddball reason, it
would get the penalty for nothing, but perhaps that doesn't matter anyway.

Version 3 of the patch is below.  I moved the PM-related code to pm.c in this
one.  Tested on MSI Wind with some debug stuff on top.

Rafael


---
From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Subject: irq / PM: Fix IRQF_NO_SUSPEND problem with shared interrupts

Since __disable_irq() only checks IRQF_NO_SUSPEND for the first
irqaction in a given irq_desc, that value of that bit for the
first irqaction affects all of the other irqactions sharing the
interrupt with it.  This is problematic in two cases.

First, if IRQF_NO_SUSPEND is set in the first irqaction and unset
in at least one of the other irqactions sharing the same interrupt,
the interrupt handlers in the other irqactions with IRQF_NO_SUSPEND
unset will be invoked after suspend_device_irqs() has returned even
though they are not supposed to.  That shouldn't be a problem if
those interrupt handlers are implemented correctly and the
corresponding devices are properly suspended, but it may lead to
functional issues otherwise.

Second, if IRQF_NO_SUSPEND is unset in the first irqaction and set
in at least one of the other irqactions sharing the same interrupt,
the interrupt handlers in the other irqactions with IRQF_NO_SUSPEND
set will not be invoked after suspend_device_irqs() has returned, but
they are supposed to be invoked then.  That may be a problem if the
corresponding devices are wakeup devices or if their interrupts have
to be properly handled during system suspend/resume too for other
reasons, which is the case for timer interrupts or the ACPI SCI for
example.

To address this, modify the handling of IRQF_NO_SUSPEND by
suspend_device_irqs() and resume_device_irqs() and make
note_interrupt() handle suspended interrupts.

First of all, make suspend_device_irqs() check IRQF_NO_SUSPEND for
all irqactions sharing the same irq_desc and avoid disabling the IRQ
if at least one of them has IRQF_NO_SUSPEND set.  If that flag is
also unset for at least one irqaction in the given irq_desc, however,
suspend_device_irqs() will move the irqactions with IRQF_NO_SUSPEND
unset over to a list of "suspended actions" whose interrupt handlers
won't be invoked going forward.

Second, modify note_interrupt() to disable misbehaving IRQs faster if
spuroius interrupts occur during system suspend/resume (that is, for
an irq_desc with IRQS_SUSPENDED set).

Finally, make resume_device_irqs() move irqactions from the list of
"suspended actions" created by suspend_device_irqs() back to the
regular "action" list.  It also will clear the IRQS_SPURIOUS_DISABLED
flag for IRQS_SUSPENDED IRQs that were emergency disabled after
suspend_device_irqs() had returned and will log warning messages for
them.

This should address the problematic case (when IRQF_NO_SUSPEND is set
for at least one and unset for at least one irqaction sharing one
irq_desc) and that case only without changing behavior in any other
cases.

It also effectively reverts a previous change to refuse interrupt
requests with IRQF_NO_SUSPEND settings that do not match the
existing ones (as it is not needed any more) and a previous change
that added a IRQD_WAKEUP_STATE check to __disable_irqs() (as that
mechanism has the same problem with shared interrupts as described
above).

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 include/linux/irqdesc.h |    2 +
 kernel/irq/internals.h  |    4 +-
 kernel/irq/manage.c     |   31 +++--------------
 kernel/irq/pm.c         |   86 ++++++++++++++++++++++++++++++++++++++++++++++--
 kernel/irq/spurious.c   |   14 ++++++-
 5 files changed, 106 insertions(+), 31 deletions(-)

Index: linux-pm/kernel/irq/manage.c
===================================================================
--- linux-pm.orig/kernel/irq/manage.c
+++ linux-pm/kernel/irq/manage.c
@@ -382,15 +382,8 @@ setup_affinity(unsigned int irq, struct
 }
 #endif
 
-void __disable_irq(struct irq_desc *desc, unsigned int irq, bool suspend)
+void __disable_irq(struct irq_desc *desc, unsigned int irq)
 {
-	if (suspend) {
-		if (!desc->action || (desc->action->flags & IRQF_NO_SUSPEND)
-		    || irqd_has_set(&desc->irq_data, IRQD_WAKEUP_STATE))
-			return;
-		desc->istate |= IRQS_SUSPENDED;
-	}
-
 	if (!desc->depth++)
 		irq_disable(desc);
 }
@@ -402,7 +395,7 @@ static int __disable_irq_nosync(unsigned
 
 	if (!desc)
 		return -EINVAL;
-	__disable_irq(desc, irq, false);
+	__disable_irq(desc, irq);
 	irq_put_desc_busunlock(desc, flags);
 	return 0;
 }
@@ -443,20 +436,8 @@ void disable_irq(unsigned int irq)
 }
 EXPORT_SYMBOL(disable_irq);
 
-void __enable_irq(struct irq_desc *desc, unsigned int irq, bool resume)
+void __enable_irq(struct irq_desc *desc, unsigned int irq)
 {
-	if (resume) {
-		if (!(desc->istate & IRQS_SUSPENDED)) {
-			if (!desc->action)
-				return;
-			if (!(desc->action->flags & IRQF_FORCE_RESUME))
-				return;
-			/* Pretend that it got disabled ! */
-			desc->depth++;
-		}
-		desc->istate &= ~IRQS_SUSPENDED;
-	}
-
 	switch (desc->depth) {
 	case 0:
  err_out:
@@ -498,7 +479,7 @@ void enable_irq(unsigned int irq)
 		 KERN_ERR "enable_irq before setup/request_irq: irq %u\n", irq))
 		goto out;
 
-	__enable_irq(desc, irq, false);
+	__enable_irq(desc, irq);
 out:
 	irq_put_desc_busunlock(desc, flags);
 }
@@ -1079,7 +1060,7 @@ __setup_irq(unsigned int irq, struct irq
 		 */
 
 #define IRQF_MISMATCH \
-	(IRQF_TRIGGER_MASK | IRQF_ONESHOT | IRQF_NO_SUSPEND)
+	(IRQF_TRIGGER_MASK | IRQF_ONESHOT)
 
 		if (!((old->flags & new->flags) & IRQF_SHARED) ||
 		    ((old->flags ^ new->flags) & IRQF_MISMATCH))
@@ -1232,7 +1213,7 @@ __setup_irq(unsigned int irq, struct irq
 	 */
 	if (shared && (desc->istate & IRQS_SPURIOUS_DISABLED)) {
 		desc->istate &= ~IRQS_SPURIOUS_DISABLED;
-		__enable_irq(desc, irq, false);
+		__enable_irq(desc, irq);
 	}
 
 	raw_spin_unlock_irqrestore(&desc->lock, flags);
Index: linux-pm/kernel/irq/spurious.c
===================================================================
--- linux-pm.orig/kernel/irq/spurious.c
+++ linux-pm/kernel/irq/spurious.c
@@ -391,10 +391,20 @@ void note_interrupt(unsigned int irq, st
 		 * otherwise the counter becomes a doomsday timer for otherwise
 		 * working systems
 		 */
-		if (time_after(jiffies, desc->last_unhandled + HZ/10))
+		if (time_after(jiffies, desc->last_unhandled + HZ/10)) {
 			desc->irqs_unhandled = 1;
-		else
+		} else {
 			desc->irqs_unhandled++;
+			if (unlikely(desc->istate & IRQS_SUSPENDED)) {
+				/*
+				 * That shouldn't happen.  It means IRQs from
+				 * a device that is supposed to be suspended at
+				 * this point.  Decay faster.
+				 */
+				desc->irqs_unhandled += 999;
+				desc->irq_count += 999;
+			}
+		}
 		desc->last_unhandled = jiffies;
 	}
 
Index: linux-pm/include/linux/irqdesc.h
===================================================================
--- linux-pm.orig/include/linux/irqdesc.h
+++ linux-pm/include/linux/irqdesc.h
@@ -20,6 +20,7 @@ struct irq_desc;
  * @handle_irq:		highlevel irq-events handler
  * @preflow_handler:	handler called before the flow handler (currently used by sparc)
  * @action:		the irq action chain
+ * @action_suspended:	suspended irq action chain
  * @status:		status information
  * @core_internal_state__do_not_mess_with_it: core internal status information
  * @depth:		disable-depth, for nested irq_disable() calls
@@ -47,6 +48,7 @@ struct irq_desc {
 	irq_preflow_handler_t	preflow_handler;
 #endif
 	struct irqaction	*action;	/* IRQ action list */
+	struct irqaction	*action_suspended;
 	unsigned int		status_use_accessors;
 	unsigned int		core_internal_state__do_not_mess_with_it;
 	unsigned int		depth;		/* nested irq disables */
Index: linux-pm/kernel/irq/internals.h
===================================================================
--- linux-pm.orig/kernel/irq/internals.h
+++ linux-pm/kernel/irq/internals.h
@@ -63,8 +63,8 @@ enum {
 
 extern int __irq_set_trigger(struct irq_desc *desc, unsigned int irq,
 		unsigned long flags);
-extern void __disable_irq(struct irq_desc *desc, unsigned int irq, bool susp);
-extern void __enable_irq(struct irq_desc *desc, unsigned int irq, bool resume);
+extern void __disable_irq(struct irq_desc *desc, unsigned int irq);
+extern void __enable_irq(struct irq_desc *desc, unsigned int irq);
 
 extern int irq_startup(struct irq_desc *desc, bool resend);
 extern void irq_shutdown(struct irq_desc *desc);
Index: linux-pm/kernel/irq/pm.c
===================================================================
--- linux-pm.orig/kernel/irq/pm.c
+++ linux-pm/kernel/irq/pm.c
@@ -13,6 +13,47 @@
 
 #include "internals.h"
 
+static bool suspend_irq(struct irq_desc *desc)
+{
+	struct irqaction *action = desc->action;
+	unsigned int no_suspend, flags;
+
+	if (!action)
+		return false;
+
+	no_suspend = IRQF_NO_SUSPEND;
+	flags = 0;
+	do {
+		no_suspend &= action->flags;
+		flags |= action->flags;
+		action = action->next;
+	} while (action);
+	if (no_suspend)
+		return false;
+
+	desc->istate |= IRQS_SUSPENDED;
+
+	if ((flags & IRQF_NO_SUSPEND) &&
+	    !(desc->istate & IRQS_SPURIOUS_DISABLED)) {
+		struct irqaction *no_suspend = NULL;
+
+		do {
+			action = desc->action;
+			desc->action = action->next;
+			if (action->flags & IRQF_NO_SUSPEND) {
+				action->next = no_suspend;
+				no_suspend = action;
+			} else {
+				action->next = desc->action_suspended;
+				desc->action_suspended = action;
+			}
+		} while (desc->action);
+		desc->action = no_suspend;
+		return false;
+	}
+	return true;
+}
+
 /**
  * suspend_device_irqs - disable all currently enabled interrupt lines
  *
@@ -30,7 +71,10 @@ void suspend_device_irqs(void)
 		unsigned long flags;
 
 		raw_spin_lock_irqsave(&desc->lock, flags);
-		__disable_irq(desc, irq, true);
+
+		if (suspend_irq(desc))
+			__disable_irq(desc, irq);
+
 		raw_spin_unlock_irqrestore(&desc->lock, flags);
 	}
 
@@ -40,6 +84,41 @@ void suspend_device_irqs(void)
 }
 EXPORT_SYMBOL_GPL(suspend_device_irqs);
 
+static bool resume_irq(struct irq_desc *desc, int irq)
+{
+	if (desc->istate & IRQS_SUSPENDED) {
+		desc->istate &= ~IRQS_SUSPENDED;
+		if (desc->action_suspended) {
+			struct irqaction *action;
+
+			do {
+				action = desc->action_suspended;
+				desc->action_suspended = action->next;
+				action->next = desc->action;
+				desc->action = action;
+			} while (desc->action_suspended);
+
+			if (desc->istate & IRQS_SPURIOUS_DISABLED) {
+				pr_err("Re-enabling emergency disabled IRQ %d\n",
+				       irq);
+				desc->istate &= ~IRQS_SPURIOUS_DISABLED;
+			} else {
+				return false;
+			}
+		}
+	} else {
+		if (!desc->action)
+			return false;
+
+		if (!(desc->action->flags & IRQF_FORCE_RESUME))
+			return false;
+
+		/* Pretend that it got disabled ! */
+		desc->depth++;
+	}
+	return true;
+}
+
 static void resume_irqs(bool want_early)
 {
 	struct irq_desc *desc;
@@ -54,7 +133,10 @@ static void resume_irqs(bool want_early)
 			continue;
 
 		raw_spin_lock_irqsave(&desc->lock, flags);
-		__enable_irq(desc, irq, true);
+
+		if (resume_irq(desc, irq))
+			__enable_irq(desc, irq);
+
 		raw_spin_unlock_irqrestore(&desc->lock, flags);
 	}
 }

