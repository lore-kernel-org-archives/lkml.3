Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755746AbaHEPLg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 11:11:36 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:51531 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755488AbaHEPLC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 11:11:02 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Linux PM list <linux-pm@vger.kernel.org>,
        Dmitry Torokhov <dtor@google.com>
Subject: [PATCH 2/5] irq / PM: Fix IRQF_NO_SUSPEND problem with shared interrupts
Date: Tue, 05 Aug 2014 17:25:42 +0200
Message-ID: <1871482.OQTHsF7T50@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <3321219.itH23ZEDt4@vostro.rjw.lan>
References: <20140724212620.GO3935@laptop> <3855585.ek3PTQLkmN@vostro.rjw.lan> <3321219.itH23ZEDt4@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

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

To address this, introduce a wrapper interrupt handler for shared
interrupts, irq_shared_wrapper_handler(), and make __setup_irq()
use it for shared interrupts by default.  That wrapper handler
simply invokes the original handler supplied while requesting the
IRQ if the (new) irqs_suspended global variable is unset.  Otherwise
it returns IRQ_NONE.  The wrapper handler is used for all irqactions
sharing IRQs except for irqactions with IRQF_NO_SUSPEND set that
retain their original handlers.

The irqs_suspended variable is set by suspend_device_irqs() and
unset by resume_device_irqs().  It is checked by note_interrupt()
(now called unconditionally) and if set, any unhandled interrupt
will cause the system to wake up (or system suspend in progress
to be aborted).

The additional (new) skip_suspend field in struct irq_desc is
used to track if any irqactions in the given desc have
IRQF_NO_SUSPEND set.  It is used by suspend_device_irqs() to
decide which IRQs to disable during system suspends.  This way,
all IRQs with at least one irqaction having IRQF_NO_SUSPEND set
(skip_suspend greater than 0) will stay enabled after
suspend_device_irqs(), but if any irqactions belonging to them
have IRQF_NO_SUSPEND unset, they will use the wrapper handler
that will return IRQ_NONE for them (causing system suspend to
be aborted or system wakeup from suspend-to-idle to happen).

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 include/linux/interrupt.h |    4 +++
 include/linux/irqdesc.h   |    1 
 kernel/irq/handle.c       |    3 --
 kernel/irq/internals.h    |    3 ++
 kernel/irq/manage.c       |   52 ++++++++++++++++++++++++++++++++++++++++++++--
 kernel/irq/pm.c           |   10 +++++---
 kernel/irq/spurious.c     |   13 +++++++++++
 7 files changed, 78 insertions(+), 8 deletions(-)

Index: linux-pm/kernel/irq/manage.c
===================================================================
--- linux-pm.orig/kernel/irq/manage.c
+++ linux-pm/kernel/irq/manage.c
@@ -385,7 +385,7 @@ setup_affinity(unsigned int irq, struct
 void __disable_irq(struct irq_desc *desc, unsigned int irq, bool suspend)
 {
 	if (suspend) {
-		if (!desc->action || (desc->action->flags & IRQF_NO_SUSPEND))
+		if (!desc->action || desc->skip_suspend)
 			return;
 		desc->istate |= IRQS_SUSPENDED;
 	}
@@ -658,6 +658,43 @@ int irq_set_parent(int irq, int parent_i
 }
 #endif
 
+bool irqs_suspended __read_mostly;
+
+void set_irqs_suspended(bool on)
+{
+	struct irq_desc *desc;
+	int irq;
+
+	irqs_suspended = on;
+	for_each_irq_desc(irq, desc)
+		synchronize_irq(irq);
+}
+
+/*
+ * Wrapper handler for shared interrupts.
+ */
+static irqreturn_t irq_shared_wrapper_handler(int irq, void *dev_id)
+{
+	struct irqaction *action = dev_id;
+
+	if (unlikely(irqs_suspended))
+		return IRQ_NONE;
+
+	return action->s_handler(irq, action->s_dev_id);
+}
+
+static void irq_shared_wrap_handler(struct irqaction *action)
+{
+	if (action->handler == irq_shared_wrapper_handler ||
+	    (action->flags & IRQF_NO_SUSPEND))
+		return;
+
+	action->s_handler = action->handler;
+	action->handler = irq_shared_wrapper_handler;
+	action->s_dev_id = action->dev_id;
+	action->dev_id = action;
+}
+
 /*
  * Default primary interrupt handler for threaded interrupts. Is
  * assigned as primary handler when request_threaded_irq is called
@@ -1088,6 +1125,7 @@ __setup_irq(unsigned int irq, struct irq
 
 		/* add new interrupt at end of irq queue */
 		do {
+			irq_shared_wrap_handler(old);
 			/*
 			 * Or all existing action->thread_mask bits,
 			 * so we can find the next zero bit for this
@@ -1097,6 +1135,7 @@ __setup_irq(unsigned int irq, struct irq
 			old_ptr = &old->next;
 			old = *old_ptr;
 		} while (old);
+		irq_shared_wrap_handler(new);
 		shared = 1;
 	}
 
@@ -1222,6 +1261,9 @@ __setup_irq(unsigned int irq, struct irq
 	desc->irq_count = 0;
 	desc->irqs_unhandled = 0;
 
+	if (new->flags & IRQF_NO_SUSPEND)
+		desc->skip_suspend++;
+
 	/*
 	 * Check whether we disabled the irq via the spurious handler
 	 * before. Reenable it and give it another chance.
@@ -1328,13 +1370,19 @@ static struct irqaction *__free_irq(unsi
 			return NULL;
 		}
 
-		if (action->dev_id == dev_id)
+		if (action->dev_id == dev_id || action->s_dev_id == dev_id)
 			break;
 		action_ptr = &action->next;
 	}
 
 	/* Found it - now remove it from the list of entries: */
 	*action_ptr = action->next;
+	if (action->flags & IRQF_NO_SUSPEND) {
+		desc->skip_suspend--;
+	} else if (action->handler == irq_shared_wrapper_handler) {
+		action->handler = action->s_handler;
+		action->dev_id = action->s_dev_id;
+	}
 
 	/* If this was the last handler, shut down the IRQ line: */
 	if (!desc->action) {
Index: linux-pm/include/linux/interrupt.h
===================================================================
--- linux-pm.orig/include/linux/interrupt.h
+++ linux-pm/include/linux/interrupt.h
@@ -90,8 +90,10 @@ typedef irqreturn_t (*irq_handler_t)(int
 /**
  * struct irqaction - per interrupt action descriptor
  * @handler:	interrupt handler function
+ * @s_handler:	interrupt handler function for shared interrupts
  * @name:	name of the device
  * @dev_id:	cookie to identify the device
+ * @s_dev_id:	cookie to identify the device for shared interrupts
  * @percpu_dev_id:	cookie to identify the device
  * @next:	pointer to the next irqaction for shared interrupts
  * @irq:	interrupt number
@@ -105,6 +107,8 @@ typedef irqreturn_t (*irq_handler_t)(int
 struct irqaction {
 	irq_handler_t		handler;
 	void			*dev_id;
+	irq_handler_t		s_handler;
+	void			*s_dev_id;
 	void __percpu		*percpu_dev_id;
 	struct irqaction	*next;
 	irq_handler_t		thread_fn;
Index: linux-pm/kernel/irq/handle.c
===================================================================
--- linux-pm.orig/kernel/irq/handle.c
+++ linux-pm/kernel/irq/handle.c
@@ -175,8 +175,7 @@ handle_irq_event_percpu(struct irq_desc
 
 	add_interrupt_randomness(irq, flags);
 
-	if (!noirqdebug)
-		note_interrupt(irq, desc, retval);
+	note_interrupt(irq, desc, retval);
 	return retval;
 }
 
Index: linux-pm/kernel/irq/spurious.c
===================================================================
--- linux-pm.orig/kernel/irq/spurious.c
+++ linux-pm/kernel/irq/spurious.c
@@ -13,6 +13,7 @@
 #include <linux/interrupt.h>
 #include <linux/moduleparam.h>
 #include <linux/timer.h>
+#include <linux/suspend.h>
 
 #include "internals.h"
 
@@ -275,6 +276,18 @@ try_misrouted_irq(unsigned int irq, stru
 void note_interrupt(unsigned int irq, struct irq_desc *desc,
 		    irqreturn_t action_ret)
 {
+	if (unlikely(irqs_suspended && action_ret == IRQ_NONE)) {
+		pr_err("IRQ %d: Unhandled while suspended\n", irq);
+		desc->istate |= IRQS_SUSPENDED;
+		desc->depth++;
+		irq_disable(desc);
+		pm_system_wakeup();
+		return;
+	}
+
+	if (noirqdebug)
+		return;
+
 	if (desc->istate & IRQS_POLL_INPROGRESS ||
 	    irq_settings_is_polled(desc))
 		return;
Index: linux-pm/kernel/irq/pm.c
===================================================================
--- linux-pm.orig/kernel/irq/pm.c
+++ linux-pm/kernel/irq/pm.c
@@ -10,6 +10,7 @@
 #include <linux/module.h>
 #include <linux/interrupt.h>
 #include <linux/syscore_ops.h>
+#include <linux/suspend.h>
 
 #include "internals.h"
 
@@ -33,10 +34,7 @@ void suspend_device_irqs(void)
 		__disable_irq(desc, irq, true);
 		raw_spin_unlock_irqrestore(&desc->lock, flags);
 	}
-
-	for_each_irq_desc(irq, desc)
-		if (desc->istate & IRQS_SUSPENDED)
-			synchronize_irq(irq);
+	set_irqs_suspended(true);
 }
 EXPORT_SYMBOL_GPL(suspend_device_irqs);
 
@@ -90,6 +88,7 @@ device_initcall(irq_pm_init_ops);
  */
 void resume_device_irqs(void)
 {
+	set_irqs_suspended(false);
 	resume_irqs(false);
 }
 EXPORT_SYMBOL_GPL(resume_device_irqs);
@@ -102,6 +101,9 @@ int check_wakeup_irqs(void)
 	struct irq_desc *desc;
 	int irq;
 
+	if (pm_wakeup_pending())
+		return -EBUSY;
+
 	for_each_irq_desc(irq, desc) {
 		/*
 		 * Only interrupts which are marked as wakeup source
Index: linux-pm/kernel/irq/internals.h
===================================================================
--- linux-pm.orig/kernel/irq/internals.h
+++ linux-pm/kernel/irq/internals.h
@@ -17,6 +17,9 @@
 #define istate core_internal_state__do_not_mess_with_it
 
 extern bool noirqdebug;
+extern bool irqs_suspended;
+
+extern void set_irqs_suspended(bool on);
 
 /*
  * Bits used by threaded handlers:
Index: linux-pm/include/linux/irqdesc.h
===================================================================
--- linux-pm.orig/include/linux/irqdesc.h
+++ linux-pm/include/linux/irqdesc.h
@@ -51,6 +51,7 @@ struct irq_desc {
 	unsigned int		core_internal_state__do_not_mess_with_it;
 	unsigned int		depth;		/* nested irq disables */
 	unsigned int		wake_depth;	/* nested wake enables */
+	unsigned int		skip_suspend;
 	unsigned int		irq_count;	/* For detecting broken IRQs */
 	unsigned long		last_unhandled;	/* Aging timer for unhandled count */
 	unsigned int		irqs_unhandled;

