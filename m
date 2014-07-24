Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934631AbaGXV01 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 17:26:27 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:50919 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759640AbaGXV00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 17:26:26 -0400
Date: Thu, 24 Jul 2014 23:26:20 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: rjw@rjwysocki.net, linux-kernel@vger.kernel.org
Subject: [RFC][PATCH] irq: Rework IRQF_NO_SUSPENDED
Message-ID: <20140724212620.GO3935@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: irq: Rework IRQF_NO_SUSPENDED
From: Peter Zijlstra <peterz@infradead.org>
Date: Thu Jul 24 22:34:50 CEST 2014

Typically when devices are suspended they're quiesced such that they
will not generate any further interrupts.

However some devices should still generate interrupts, even when
suspended, typically used to wake the machine back up.

Such logic should ideally be contained inside each driver, if it can
generate interrupts when suspended, it knows about this and the
interrupt handler can deal with it.

Except of course for shared interrupts, when such a wakeup device is
sharing an interrupt line with a device that does not expect
interrupts while suspended things can go funny.

This is where IRQF_NO_SUSPEND comes in, the idea is that drivers that
have the capability to wake the machine set IRQF_NO_SUSPEND and their
handler will still be called, even when the IRQ subsystem is formally
suspended. Handlers without IRQF_NO_SUSPEND will not be called.

This replaced the prior implementation of IRQF_NO_SUSPEND which had
a number of fatal issues in that it didn't actually work for the
shared case, exactly the case it should be helping.

There is still enable_irq_wake()/IRQD_WAKEUP_STATE that tries to serve
a similar purpose but is equially wrecked for shared interrupts,
ideally this would be removed.

Cc: rjw@rjwysocki.net
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 kernel/irq/chip.c      |    4 +---
 kernel/irq/handle.c    |   24 +++++++++++++++++++++---
 kernel/irq/internals.h |    6 ++++--
 kernel/irq/manage.c    |   31 ++++++-------------------------
 kernel/irq/pm.c        |   17 +++++++++--------
 5 files changed, 41 insertions(+), 41 deletions(-)

--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -677,9 +677,7 @@ void handle_percpu_devid_irq(unsigned in
 	if (chip->irq_ack)
 		chip->irq_ack(&desc->irq_data);
 
-	trace_irq_handler_entry(irq, action);
-	res = action->handler(irq, dev_id);
-	trace_irq_handler_exit(irq, action, res);
+	res = do_irqaction(desc, action, irq, dev_id);
 
 	if (chip->irq_eoi)
 		chip->irq_eoi(&desc->irq_data);
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -131,6 +131,23 @@ void __irq_wake_thread(struct irq_desc *
 }
 
 irqreturn_t
+do_irqaction(struct irq_desc *desc, struct irqaction *action,
+	     unsigned int irq, void *dev_id)
+{
+	irqreturn_t ret;
+
+	if (unlikely((desc->istate & IRQS_SUSPENDED) &&
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
@@ -175,6 +190,9 @@ handle_irq_event_percpu(struct irq_desc
 
 	add_interrupt_randomness(irq, flags);
 
+	if (unlikely(desc->istate & IRQS_SUSPENDED) && retval == IRQ_NONE)
+		retval = IRQ_HANDLED;
+
 	if (!noirqdebug)
 		note_interrupt(irq, desc, retval);
 	return retval;
--- a/kernel/irq/internals.h
+++ b/kernel/irq/internals.h
@@ -63,8 +63,10 @@ enum {
 
 extern int __irq_set_trigger(struct irq_desc *desc, unsigned int irq,
 		unsigned long flags);
-extern void __disable_irq(struct irq_desc *desc, unsigned int irq, bool susp);
-extern void __enable_irq(struct irq_desc *desc, unsigned int irq, bool resume);
+
+extern irqreturn_t
+do_irqaction(struct irq_desc *desc, struct irqaction *action,
+	     unsigned int irq, void *dev_id);
 
 extern int irq_startup(struct irq_desc *desc, bool resend);
 extern void irq_shutdown(struct irq_desc *desc);
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -382,15 +382,8 @@ setup_affinity(unsigned int irq, struct
 }
 #endif
 
-void __disable_irq(struct irq_desc *desc, unsigned int irq, bool suspend)
+void __disable_irq(struct irq_desc *desc, unsigned int irq)
 {
-	if (suspend) {
-		if (!desc->action || (desc->action->flags & IRQF_NO_SUSPEND) ||
-		    irqd_has_set(&desc->irq_data, IRQD_WAKEUP_STATE))
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
--- a/kernel/irq/pm.c
+++ b/kernel/irq/pm.c
@@ -29,14 +29,20 @@ void suspend_device_irqs(void)
 	for_each_irq_desc(irq, desc) {
 		unsigned long flags;
 
+		/*
+		 * Ideally this would be a global state, but we cannot
+		 * for the trainwreck that is IRQD_WAKEUP_STATE.
+		 */
 		raw_spin_lock_irqsave(&desc->lock, flags);
-		__disable_irq(desc, irq, true);
+		if (!irqd_has_set(&desc->irq_data, IRQD_WAKEUP_STATE))
+			desc->istate |= IRQS_SUSPENDED;
 		raw_spin_unlock_irqrestore(&desc->lock, flags);
 	}
 
-	for_each_irq_desc(irq, desc)
+	for_each_irq_desc(irq, desc) {
 		if (desc->istate & IRQS_SUSPENDED)
 			synchronize_irq(irq);
+	}
 }
 EXPORT_SYMBOL_GPL(suspend_device_irqs);
 
@@ -47,14 +53,9 @@ static void resume_irqs(bool want_early)
 
 	for_each_irq_desc(irq, desc) {
 		unsigned long flags;
-		bool is_early = desc->action &&
-			desc->action->flags & IRQF_EARLY_RESUME;
-
-		if (!is_early && want_early)
-			continue;
 
 		raw_spin_lock_irqsave(&desc->lock, flags);
-		__enable_irq(desc, irq, true);
+		desc->istate &= ~IRQS_SUSPENDED;
 		raw_spin_unlock_irqrestore(&desc->lock, flags);
 	}
 }
