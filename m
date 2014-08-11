Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753889AbaHKNqu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 09:46:50 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:65097 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753673AbaHKNox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 09:44:53 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>
Subject: [PATCH 3/6 v2] irq / PM: Make wakeup interrupts work with suspend-to-idle
Date: Mon, 11 Aug 2014 16:00:02 +0200
Message-ID: <1851736.ujj1bO3Shk@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <26580319.OZP7jvJnA9@vostro.rjw.lan>
References: <26580319.OZP7jvJnA9@vostro.rjw.lan>
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

The "wakeup mode" switch works by replaceing interrupt handlers for
all wakeup IRQs and all their irqactions with a special "wakeup mode"
handler and enabling all wakeup IRQs, previously disabled by
suspend_device_irqs().  The "wakeup mode" interrupt handler returns
IRQ_NONE for all irqactions except for the last one in the given chain
and for that one it disables the IRQ, marks it as "suspended" and
pending and triggers system wakeup.

The switch back from the "wakeup mode" restores the original
interrupt handlers for wakeup IRQs and disables them so that they
are in the state that they were put into by suspend_device_irqs().

As a result, when in suspend-to-idle, every wakeup interrupt will
trigger a system wakeup, but the original interrupt handlers will not
be invoked for wakeup interrupts.

The line of reasoning leading to that is as follows.

The way suspend_device_irqs() works and the existing code in
check_wakeup_irqs(), called by syscore_suspend(), imply that:

  (1) Interrupt handlers are not invoked for wakeup interrupts
      after suspend_device_irqs().

  (2) System wakeup interrups after suspend_device_irqs() cause
      full system suspends to be aborted.

In addition to the above, there is the requirement that

  (3) System wakeup interrupts should wake up the system from
      suspend-to-idle.

It immediately follows from (1) and (2) that no effort is made to
distinguish "genuine" wakeup interrupts from "spurious" ones.  They
all are treated in the same way.  Since (3) means that "genuine"
wakeup interrupts are supposed to wake up the system from
suspend-to-idle too, consistency with (1) and (2) requires that
"spurious" wakeup interrupts should do the same thing.  That also is
consistent with the rule

  (4) Unhandled interrupts after suspend_device_irqs() abort system
      suspends in progress (or wake up the system from suspend-to-idle
      if already there).

introduced by the previous changeset and implies that there is no
reason to invoke interrupt handlers for wakeup interrups after
suspend_device_irqs() in the suspend-to-idle case.  Moreover, doing
so would go against rule (1).

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 include/linux/interrupt.h |    5 +-
 kernel/irq/pm.c           |   84 +++++++++++++++++++++++++++++++++++++++-------
 kernel/power/suspend.c    |    3 +
 3 files changed, 79 insertions(+), 13 deletions(-)

Index: linux-pm/include/linux/interrupt.h
===================================================================
--- linux-pm.orig/include/linux/interrupt.h
+++ linux-pm/include/linux/interrupt.h
@@ -101,8 +101,8 @@ typedef irqreturn_t (*irq_handler_t)(int
  * @thread_flags:	flags related to @thread
  * @thread_mask:	bitmask for keeping track of @thread activity
  * @dir:	pointer to the proc/irq/NN/name entry
- * @s_handler:	original interrupt handler for suspend mode interrupts
- * @s_dev_id:	original device identification cookie for suspend mode
+ * @s_handler:	original interrupt handler for suspend/wakeup mode interrupts
+ * @s_dev_id:	original device identification cookie for suspend/wakeup mode
  * @prev_ret:	suspend mode return code from the previous action
  */
 struct irqaction {
@@ -201,6 +201,7 @@ extern void irq_wake_thread(unsigned int
 /* The following three functions are for the core kernel use only. */
 extern void suspend_device_irqs(void);
 extern void resume_device_irqs(void);
+extern void wakeup_mode_for_irqs(bool enable);
 #ifdef CONFIG_PM_SLEEP
 extern int check_wakeup_irqs(void);
 #else
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
Index: linux-pm/kernel/irq/pm.c
===================================================================
--- linux-pm.orig/kernel/irq/pm.c
+++ linux-pm/kernel/irq/pm.c
@@ -14,6 +14,17 @@
 
 #include "internals.h"
 
+static void irq_pm_replace_handler(struct irqaction *action,
+				   irq_handler_t new_handler)
+{
+	if (!action->s_handler) {
+		action->s_handler = action->handler;
+		action->handler = new_handler;
+		action->s_dev_id = action->dev_id;
+		action->dev_id = action;
+	}
+}
+
 static void irq_pm_restore_handler(struct irqaction *action)
 {
 	if (action->s_handler) {
@@ -24,14 +35,36 @@ static void irq_pm_restore_handler(struc
 	}
 }
 
-static void irq_pm_disable_and_wakeup(int irq)
+static void irq_pm_disable_and_wakeup(struct irq_desc *desc)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
+	if (!(desc->istate & IRQS_SUSPENDED)) {
+		desc->istate |= IRQS_SUSPENDED;
+		desc->depth++;
+		irq_disable(desc);
+		pm_system_wakeup();
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
+	desc->istate |= IRQS_PENDING;
+	irq_pm_disable_and_wakeup(desc);
+	return IRQ_HANDLED;
+}
+
+static void irq_pm_wakeup_mode(struct irq_desc *desc)
+{
+	struct irqaction *action;
 
-	desc->istate |= IRQS_SUSPENDED;
-	desc->depth++;
-	irq_disable(desc);
-	pm_system_wakeup();
+	for (action = desc->action; action; action = action->next)
+		irq_pm_replace_handler(action, irq_wakeup_mode_handler);
 }
 
 static irqreturn_t irq_suspend_mode_handler(int irq, void *dev_id)
@@ -52,7 +85,7 @@ static irqreturn_t irq_suspend_mode_hand
 		 * trigger wakeup.
 		 */
 		pr_err("IRQ %d: Unhandled while suspended\n", irq);
-		irq_pm_disable_and_wakeup(irq);
+		irq_pm_disable_and_wakeup(irq_to_desc(irq));
 	}
 	return ret;
 }
@@ -69,10 +102,7 @@ bool irq_pm_suspend_mode(struct irq_desc
 		return true;
 
 	for (action = desc->action; action; action = action->next) {
-		action->s_handler = action->handler;
-		action->handler = irq_suspend_mode_handler;
-		action->s_dev_id = action->dev_id;
-		action->dev_id = action;
+		irq_pm_replace_handler(action, irq_suspend_mode_handler);
 		action->prev_ret = IRQ_NONE;
 	}
 	return true;
@@ -213,3 +243,35 @@ int check_wakeup_irqs(void)
 
 	return 0;
 }
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
+		if (action && irqd_is_wakeup_set(&desc->irq_data) &&
+		    !desc->skip_suspend_depth) {
+			if (enable) {
+				irq_pm_wakeup_mode(desc);
+				if (desc->istate & IRQS_SUSPENDED) {
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

