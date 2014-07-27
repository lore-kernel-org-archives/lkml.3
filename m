Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728AbaG0VmP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2014 17:42:15 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:51411 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752546AbaG0VmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2014 17:42:13 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH, v2]
Date: Mon, 28 Jul 2014 00:00:41 +0200
Message-ID: <3337421.bsfMykWVnZ@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <3637397.iCmFpOsayO@vostro.rjw.lan>
References: <20140724212620.GO3935@laptop> <1663327.PISiM9sMHC@vostro.rjw.lan> <3637397.iCmFpOsayO@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, July 27, 2014 05:53:07 PM Rafael J. Wysocki wrote:
> On Saturday, July 26, 2014 12:25:29 AM Rafael J. Wysocki wrote:
> > On Friday, July 25, 2014 11:00:12 PM Thomas Gleixner wrote:
> > > On Fri, 25 Jul 2014, Rafael J. Wysocki wrote:
> > > > On Friday, July 25, 2014 03:25:41 PM Peter Zijlstra wrote:
> > > > > OK, so Rafael said there's devices that keep on raising their interrupt
> > > > > until they get attention. Ideally this won't happen because the device
> > > > > is suspended etc.. But I'm sure there's some broken piece of hardware
> > > > > out there that'll make it go boom.
> > > > 
> > > > So here's an idea.
> > > > 
> > > > What about returning IRQ_NONE rather than IRQ_HANDLED for "suspended"
> > > > interrupts (after all, that's what a sane driver would do for a
> > > > suspended device I suppose)?
> > > > 
> > > > If the line is really shared and the interrupt is taken care of by
> > > > the other guy sharing the line, we'll be all fine.
> > > > 
> > > > If that is not the case, on the other hand, and something's really
> > > > broken, we'll end up disabling the interrupt and marking it as
> > > > IRQS_SPURIOUS_DISABLED (if I understand things correctly).
> > > 
> > > We should not wait 100k unhandled interrupts in that case. We know
> > > already at the first unhandled interrupt that the shit hit the fan.
> > 
> > The first one may be a bus glitch or some such.  Also I guess we still need to
> > allow the legitimate "no suspend" guy to handle his interrupts until it gets
> > too worse.
> > 
> > Also does it really hurt to rely on the generic mechanism here?  We regard
> > it as fine at all other times after all.
> 
> Having considered this for some more time, I think that we need to address
> the IRQF_NO_SUSPEND problem with shared interrupts regardless of what's
> decided about the device wakeup and suspending interrupts, because (1) it's
> already there (and the Peter's patch to add IRQF_NO_SUSPEND to "mismatch"
> flags may break working systems that aren't even buggy, sorry for noticing
> that so late) and (2) we'll need something like IRQF_NO_SUSPEND idependently
> of wakeup anyway, for timers and things like the ACPI SCI.
> 
> Below is my attempt to do that based on the prototype I sent previously.
> It contains a mechanism to disable IRQs generating spurious interrupts
> during system suspend/resume faster, but otherwise works along the same
> lines.

I realized that it had a problem where resume_device_irqs() theoretically
could re-enable an IRQ that was not disabled by suspend_device_irqs().

Unfortunately, to plug that hole I needed a new IRQS_ flag that would be
set for shared suspended interrupts that required special handling.

I also fixed up the changelog as it had one thing described upside down.

Updated patch below (I tested it on my MSI Wind in which PCI PME IRQs are
shared with other devices).

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
handle_irq_event_percpu() and note_interrupt() handle suspended
interrupts.

First of all, make suspend_device_irqs() check IRQF_NO_SUSPEND for
all irqactions sharing the same irq_desc and avoid disabling the IRQ
if at least one of them has IRQF_NO_SUSPEND set.  If that flag is
also unset for at least one irqaction in the given irq_desc, however,
suspend_device_irqs() will mark the IRQ as IRQS_SHARED_SUSPENDED
(new flag).

Second, make handle_irq_event_percpu() return IRQ_NONE without
invoking the interrupt handler for irqactions with IRQF_NO_SUSPEND
unset if their irq_desc is marked as IRQS_SHARED_SUSPENDED.

Next, modify note_interrupt() to disable misbehaving IRQs faster if
spuroius interrupts occur during system suspend/resume (that is, for
an irq_desc with IRQS_SHARED_SUSPENDED set).

Finally, make resume_device_irqs() clear the IRQS_SPURIOUS_DISABLED
flag for IRQS_SHARED_SUSPENDED IRQs that were emergency disabled
after suspend_device_irqs() had returned and log warning messages for
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
 kernel/irq/handle.c    |   21 ++++++++++++++++++---
 kernel/irq/internals.h |    2 ++
 kernel/irq/manage.c    |   35 +++++++++++++++++++++++++++++++----
 kernel/irq/spurious.c  |   27 ++++++++++++++++++---------
 4 files changed, 69 insertions(+), 16 deletions(-)

Index: linux-pm/kernel/irq/manage.c
===================================================================
--- linux-pm.orig/kernel/irq/manage.c
+++ linux-pm/kernel/irq/manage.c
@@ -385,9 +385,27 @@ setup_affinity(unsigned int irq, struct
 void __disable_irq(struct irq_desc *desc, unsigned int irq, bool suspend)
 {
 	if (suspend) {
-		if (!desc->action || (desc->action->flags & IRQF_NO_SUSPEND)
-		    || irqd_has_set(&desc->irq_data, IRQD_WAKEUP_STATE))
+		struct irqaction *action = desc->action;
+
+		if (!action)
 			return;
+		if (!(desc->istate & IRQS_SPURIOUS_DISABLED)) {
+			unsigned int no_suspend, flags;
+
+			no_suspend = IRQF_NO_SUSPEND;
+			flags = 0;
+			do {
+				no_suspend &= action->flags;
+				flags |= action->flags;
+				action = action->next;
+			} while (action);
+			if (no_suspend)
+				return;
+			if (flags & IRQF_NO_SUSPEND) {
+				desc->istate |= IRQS_SHARED_SUSPENDED;
+				return;
+			}
+		}
 		desc->istate |= IRQS_SUSPENDED;
 	}
 
@@ -446,7 +464,16 @@ EXPORT_SYMBOL(disable_irq);
 void __enable_irq(struct irq_desc *desc, unsigned int irq, bool resume)
 {
 	if (resume) {
-		if (!(desc->istate & IRQS_SUSPENDED)) {
+		if (desc->istate & IRQS_SHARED_SUSPENDED) {
+			desc->istate &= ~IRQS_SHARED_SUSPENDED;
+			if (desc->istate & IRQS_SPURIOUS_DISABLED) {
+				pr_err("Re-enabling emergency disabled IRQ %d\n",
+				       irq);
+				desc->istate &= ~IRQS_SPURIOUS_DISABLED;
+			} else {
+				return;
+			}
+		} else if (!(desc->istate & IRQS_SUSPENDED)) {
 			if (!desc->action)
 				return;
 			if (!(desc->action->flags & IRQF_FORCE_RESUME))
@@ -1079,7 +1106,7 @@ __setup_irq(unsigned int irq, struct irq
 		 */
 
 #define IRQF_MISMATCH \
-	(IRQF_TRIGGER_MASK | IRQF_ONESHOT | IRQF_NO_SUSPEND)
+	(IRQF_TRIGGER_MASK | IRQF_ONESHOT)
 
 		if (!((old->flags & new->flags) & IRQF_SHARED) ||
 		    ((old->flags ^ new->flags) & IRQF_MISMATCH))
Index: linux-pm/kernel/irq/handle.c
===================================================================
--- linux-pm.orig/kernel/irq/handle.c
+++ linux-pm/kernel/irq/handle.c
@@ -131,6 +131,23 @@ void __irq_wake_thread(struct irq_desc *
 }
 
 irqreturn_t
+do_irqaction(struct irq_desc *desc, struct irqaction *action,
+	     unsigned int irq, void *dev_id)
+{
+	irqreturn_t ret;
+
+	if (unlikely((desc->istate & IRQS_SHARED_SUSPENDED) &&
+		     !(action->flags & IRQF_NO_SUSPEND)))
+		return IRQ_NONE;
+
+	trace_irq_handler_entry(irq, action);
+	ret = action->handler(irq, dev_id);
+	trace_irq_handler_exit(irq, action, ret);
+
+	return ret;
+}
+
+irqreturn_t
 handle_irq_event_percpu(struct irq_desc *desc, struct irqaction *action)
 {
 	irqreturn_t retval = IRQ_NONE;
@@ -139,9 +156,7 @@ handle_irq_event_percpu(struct irq_desc
 	do {
 		irqreturn_t res;
 
-		trace_irq_handler_entry(irq, action);
-		res = action->handler(irq, action->dev_id);
-		trace_irq_handler_exit(irq, action, res);
+		res = do_irqaction(desc, action, irq, action->dev_id);
 
 		if (WARN_ONCE(!irqs_disabled(),"irq %u handler %pF enabled interrupts\n",
 			      irq, action->handler))
Index: linux-pm/kernel/irq/spurious.c
===================================================================
--- linux-pm.orig/kernel/irq/spurious.c
+++ linux-pm/kernel/irq/spurious.c
@@ -275,6 +275,8 @@ try_misrouted_irq(unsigned int irq, stru
 void note_interrupt(unsigned int irq, struct irq_desc *desc,
 		    irqreturn_t action_ret)
 {
+	int misrouted;
+
 	if (desc->istate & IRQS_POLL_INPROGRESS ||
 	    irq_settings_is_polled(desc))
 		return;
@@ -384,6 +386,9 @@ void note_interrupt(unsigned int irq, st
 		}
 	}
 
+	misrouted = unlikely(try_misrouted_irq(irq, desc, action_ret)) ?
+			misrouted_irq(irq) : 0;
+
 	if (unlikely(action_ret == IRQ_NONE)) {
 		/*
 		 * If we are seeing only the odd spurious IRQ caused by
@@ -391,19 +396,23 @@ void note_interrupt(unsigned int irq, st
 		 * otherwise the counter becomes a doomsday timer for otherwise
 		 * working systems
 		 */
-		if (time_after(jiffies, desc->last_unhandled + HZ/10))
-			desc->irqs_unhandled = 1;
-		else
+		if (time_after(jiffies, desc->last_unhandled + HZ/10)) {
+			desc->irqs_unhandled = 1 - misrouted;
+		} else if (!misrouted) {
 			desc->irqs_unhandled++;
+			if (unlikely(desc->istate & IRQS_SHARED_SUSPENDED)) {
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
 
-	if (unlikely(try_misrouted_irq(irq, desc, action_ret))) {
-		int ok = misrouted_irq(irq);
-		if (action_ret == IRQ_NONE)
-			desc->irqs_unhandled -= ok;
-	}
-
 	desc->irq_count++;
 	if (likely(desc->irq_count < 100000))
 		return;
Index: linux-pm/kernel/irq/internals.h
===================================================================
--- linux-pm.orig/kernel/irq/internals.h
+++ linux-pm/kernel/irq/internals.h
@@ -43,6 +43,7 @@ enum {
  * IRQS_REPLAY			- irq is replayed
  * IRQS_WAITING			- irq is waiting
  * IRQS_PENDING			- irq is pending and replayed later
+ * IRQS_SHARED_SUSPENDED	- irq is shared, some handlers are suspended
  * IRQS_SUSPENDED		- irq is suspended
  */
 enum {
@@ -53,6 +54,7 @@ enum {
 	IRQS_REPLAY		= 0x00000040,
 	IRQS_WAITING		= 0x00000080,
 	IRQS_PENDING		= 0x00000200,
+	IRQS_SHARED_SUSPENDED	= 0x00000400,
 	IRQS_SUSPENDED		= 0x00000800,
 };
 

