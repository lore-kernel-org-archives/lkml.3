Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932075AbaHZXhk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 19:37:40 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:53578 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755592AbaHZXg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 19:36:59 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Dmitry Torokhov <dtor@google.com>, Aubrey Li <aubrey.li@intel.com>
Subject: [PATCH 2/5 v3] irq / PM: Make wakeup interrupts work with suspend-to-idle
Date: Wed, 27 Aug 2014 01:49:49 +0200
Message-ID: <16387974.EqoNYrShmO@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <5320472.coYotHR1d0@vostro.rjw.lan>
References: <26580319.OZP7jvJnA9@vostro.rjw.lan> <5320472.coYotHR1d0@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Make IRQs enabled for system wakeup via enable_irq_wake() wake up
the system from suspend-to-idle.

For this purpose, introduce a new routine, wakeup_mode_for_irqs(),
for switching wakeup IRQs into a special "wakeup mode" and back from
it and make freeze_enter() call it to turn the "wakeup mode" on
before starting the suspend-to-idle loop and to turn it off after
that loop has been terminated.

The "wakeup mode" switch works by substituting a special "wakeup mode"
interrupt handler for all interrupt handlers in all irqactions of all
wakeup IRQs and enabling those IRQs, previously disabled by
suspend_device_irqs().  The "wakeup mode" interrupt handler returns
IRQ_NONE for all irqactions except for the last one in the given chain
and for that one it disables the IRQ, marks it as "suspended" and
pending and triggers a system wakeup.

The switch back from the "wakeup mode" restores the original
interrupt handlers for wakeup IRQs and disables them so that they
are in the state that they were put into by suspend_device_irqs().

As a result, when in suspend-to-idle, every wakeup interrupt will
trigger a system wakeup, but the original interrupt handlers will not
be invoked for those interrupts.

The line of reasoning leading to that is as follows.

The way suspend_device_irqs() works and the existing code in
check_wakeup_irqs(), called by syscore_suspend(), imply that:

  (1) Interrupt handlers are not invoked for wakeup interrupts
      after suspend_device_irqs().

  (2) All interrups from system wakeup IRQs received after\
      suspend_device_irqs() cause full system suspends to be aborted.

In addition to the above, there is the requirement that

  (3) System wakeup interrupts should wake up the system from
      suspend-to-idle.

It immediately follows from (1) and (2) that no effort is made to
distinguish "genuine" wakeup interrupts from "spurious" ones.  They
all are treated in the same way.  Since (3) means that "genuine"
wakeup interrupts are supposed to wake up the system from
suspend-to-idle too, consistency with (1) and (2) requires that
"spurious" wakeup interrupts should do the same thing.  Thus there is
no reason to invoke interrupt handlers for wakeup interrups after
suspend_device_irqs() in the suspend-to-idle case.  Moreover, doing
so would go against rule (1).

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 include/linux/interrupt.h |    7 +++
 kernel/irq/internals.h    |   14 +++++++
 kernel/irq/manage.c       |    4 +-
 kernel/irq/pm.c           |   85 ++++++++++++++++++++++++++++++++++++++++++++++
 kernel/power/suspend.c    |    3 +
 5 files changed, 112 insertions(+), 1 deletion(-)

Index: linux-pm/include/linux/interrupt.h
===================================================================
--- linux-pm.orig/include/linux/interrupt.h
+++ linux-pm/include/linux/interrupt.h
@@ -101,6 +101,8 @@ typedef irqreturn_t (*irq_handler_t)(int
  * @thread_flags:	flags related to @thread
  * @thread_mask:	bitmask for keeping track of @thread activity
  * @dir:	pointer to the proc/irq/NN/name entry
+ * @s_handler:	original interrupt handler for wakeup mode interrupts
+ * @s_dev_id:	original device identification cookie for wakeup mode
  */
 struct irqaction {
 	irq_handler_t		handler;
@@ -115,6 +117,10 @@ struct irqaction {
 	unsigned long		thread_mask;
 	const char		*name;
 	struct proc_dir_entry	*dir;
+#ifdef CONFIG_PM_SLEEP
+	irq_handler_t		s_handler;
+	void			*s_dev_id;
+#endif
 } ____cacheline_internodealigned_in_smp;
 
 extern irqreturn_t no_action(int cpl, void *dev_id);
@@ -193,6 +199,7 @@ extern void irq_wake_thread(unsigned int
 /* The following three functions are for the core kernel use only. */
 extern void suspend_device_irqs(void);
 extern void resume_device_irqs(void);
+extern void wakeup_mode_for_irqs(bool enable);
 #ifdef CONFIG_PM_SLEEP
 extern int check_wakeup_irqs(void);
 #else
Index: linux-pm/kernel/irq/internals.h
===================================================================
--- linux-pm.orig/kernel/irq/internals.h
+++ linux-pm/kernel/irq/internals.h
@@ -194,3 +194,17 @@ static inline void kstat_incr_irqs_this_
 	__this_cpu_inc(*desc->kstat_irqs);
 	__this_cpu_inc(kstat.irqs_sum);
 }
+
+#ifdef CONFIG_PM_SLEEP
+static inline bool irq_pm_saved_id(struct irqaction *action, void *dev_id)
+{
+	return action->s_dev_id == dev_id;
+}
+extern void irq_pm_restore_handler(struct irqaction *action);
+#else
+static inline bool irq_pm_saved_id(struct irqaction *action, void *dev_id)
+{
+	return false;
+}
+static inline void irq_pm_restore_handler(struct irqaction *action) {}
+#endif
Index: linux-pm/kernel/irq/manage.c
===================================================================
--- linux-pm.orig/kernel/irq/manage.c
+++ linux-pm/kernel/irq/manage.c
@@ -1328,7 +1328,7 @@ static struct irqaction *__free_irq(unsi
 			return NULL;
 		}
 
-		if (action->dev_id == dev_id)
+		if (action->dev_id == dev_id || irq_pm_saved_id(action, dev_id))
 			break;
 		action_ptr = &action->next;
 	}
@@ -1336,6 +1336,8 @@ static struct irqaction *__free_irq(unsi
 	/* Found it - now remove it from the list of entries: */
 	*action_ptr = action->next;
 
+	irq_pm_restore_handler(action);
+
 	/* If this was the last handler, shut down the IRQ line: */
 	if (!desc->action) {
 		irq_shutdown(desc);
Index: linux-pm/kernel/irq/pm.c
===================================================================
--- linux-pm.orig/kernel/irq/pm.c
+++ linux-pm/kernel/irq/pm.c
@@ -9,10 +9,95 @@
 #include <linux/irq.h>
 #include <linux/module.h>
 #include <linux/interrupt.h>
+#include <linux/suspend.h>
 #include <linux/syscore_ops.h>
 
 #include "internals.h"
 
+void irq_pm_restore_handler(struct irqaction *action)
+{
+	if (action->s_handler) {
+		action->handler = action->s_handler;
+		action->s_handler = NULL;
+		action->dev_id = action->s_dev_id;
+		action->s_dev_id = NULL;
+	}
+}
+
+static void irq_pm_substitute_handler(struct irqaction *action,
+				      irq_handler_t new_handler)
+{
+	if (!action->s_handler) {
+		action->s_handler = action->handler;
+		action->handler = new_handler;
+		action->s_dev_id = action->dev_id;
+		action->dev_id = action;
+	}
+}
+
+static irqreturn_t irq_wakeup_mode_handler(int irq, void *dev_id)
+{
+	struct irqaction *action = dev_id;
+	struct irq_desc *desc;
+
+	if (action->next)
+		return IRQ_NONE;
+
+	desc = irq_to_desc(irq);
+	desc->istate |= IRQS_SUSPENDED | IRQS_PENDING;
+	desc->depth++;
+	irq_disable(desc);
+	pm_system_wakeup();
+	return IRQ_HANDLED;
+}
+
+static void irq_pm_wakeup_mode(struct irq_desc *desc)
+{
+	struct irqaction *action;
+
+	for (action = desc->action; action; action = action->next)
+		irq_pm_substitute_handler(action, irq_wakeup_mode_handler);
+}
+
+static void irq_pm_normal_mode(struct irq_desc *desc)
+{
+	struct irqaction *action;
+
+	for (action = desc->action; action; action = action->next)
+		irq_pm_restore_handler(action);
+}
+
+void wakeup_mode_for_irqs(bool enable)
+{
+	struct irq_desc *desc;
+	int irq;
+
+	for_each_irq_desc(irq, desc) {
+		struct irqaction *action = desc->action;
+		unsigned long flags;
+
+		raw_spin_lock_irqsave(&desc->lock, flags);
+
+		if (action && irqd_is_wakeup_set(&desc->irq_data)) {
+			if (enable) {
+				if (desc->istate & IRQS_SUSPENDED) {
+					irq_pm_wakeup_mode(desc);
+					desc->istate &= ~IRQS_SUSPENDED;
+					__enable_irq(desc, irq, false);
+				}
+			} else {
+				if (!(desc->istate & IRQS_SUSPENDED)) {
+					__disable_irq(desc, irq, false);
+					desc->istate |= IRQS_SUSPENDED;
+				}
+				irq_pm_normal_mode(desc);
+			}
+		}
+
+		raw_spin_unlock_irqrestore(&desc->lock, flags);
+	}
+}
+
 /**
  * suspend_device_irqs - disable all currently enabled interrupt lines
  *
Index: linux-pm/kernel/power/suspend.c
===================================================================
--- linux-pm.orig/kernel/power/suspend.c
+++ linux-pm/kernel/power/suspend.c
@@ -28,6 +28,7 @@
 #include <linux/ftrace.h>
 #include <trace/events/power.h>
 #include <linux/compiler.h>
+#include <linux/interrupt.h>
 
 #include "power.h"
 
@@ -55,7 +56,9 @@ static void freeze_enter(void)
 {
 	cpuidle_use_deepest_state(true);
 	cpuidle_resume();
+	wakeup_mode_for_irqs(true);
 	wait_event(suspend_freeze_wait_head, suspend_freeze_wake);
+	wakeup_mode_for_irqs(false);
 	cpuidle_pause();
 	cpuidle_use_deepest_state(false);
 }

