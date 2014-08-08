Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756047AbaHHBjW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 21:39:22 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:59807 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755202AbaHHBjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 21:39:20 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Linux PM list <linux-pm@vger.kernel.org>,
        Dmitry Torokhov <dtor@google.com>
Subject: [Update][PATCH 3/5] irq / PM: Make wakeup interrupts wake up from suspend-to-idle
Date: Fri, 08 Aug 2014 03:58:02 +0200
Message-ID: <1925225.kgb6kA80iC@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1811897.nanFq2OCTN@vostro.rjw.lan>
References: <20140724212620.GO3935@laptop> <3321219.itH23ZEDt4@vostro.rjw.lan> <1811897.nanFq2OCTN@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Make IRQs enabled for system wakeup via enable_irq_wake() wake up
the system from suspend-to-idle.

For this purpose, introduce a new routine for enabling and disabling
wakeup interrupts, set_wakeup_irqs(), and make freeze_enter() call it
to enable them before starting the suspend-to-idle loop and to
disable them after that loop has been terminated.

When enabling an IRQ which is not a shared one, that routine
replaces its original handler with a stub one always returning
IRQ_NONE.  When disabling it, set_wakeup_irqs() restores the
original handler for it.  This way, IRQ_NONE is returned for all
of the wakeup interrupts during suspend-to-idle and that triggers
the abort-suspend-or-wakeup condition in note_interrupt() causing
the system to wake up.

To avoid losing wakeup events, make note_interrupt() mark wakeup
interrupts as pending before triggering wakeup for irqs_suspended
set.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---

When I was working on the doc (that I'm going to send shortly), it
occured to me that it actually would be better to always return
IRQ_NONE from interrupt handlers for wakeup interrupts when
irqs_suspended is set - and mark them as pending to avoid losing
wakeup events.  That way they'll work uniformly, even if someone is
insane enough to use enable_irq_wake() on an IRQF_NO_SUSPEND IRQ.

Rafael

---
 include/linux/interrupt.h |    1 +
 kernel/irq/pm.c           |   45 +++++++++++++++++++++++++++++++++++++++++++++
 kernel/irq/spurious.c     |    6 +++++-
 kernel/power/suspend.c    |    3 +++
 4 files changed, 54 insertions(+), 1 deletion(-)

Index: linux-pm/include/linux/interrupt.h
===================================================================
--- linux-pm.orig/include/linux/interrupt.h
+++ linux-pm/include/linux/interrupt.h
@@ -197,6 +197,7 @@ extern void irq_wake_thread(unsigned int
 /* The following three functions are for the core kernel use only. */
 extern void suspend_device_irqs(void);
 extern void resume_device_irqs(void);
+extern void set_wakeup_irqs(bool enable);
 #ifdef CONFIG_PM_SLEEP
 extern int check_wakeup_irqs(void);
 #else
Index: linux-pm/kernel/irq/pm.c
===================================================================
--- linux-pm.orig/kernel/irq/pm.c
+++ linux-pm/kernel/irq/pm.c
@@ -130,3 +130,48 @@ int check_wakeup_irqs(void)
 
 	return 0;
 }
+
+static irqreturn_t irq_pm_empty_handler(int irq, void *dev_id)
+{
+	return IRQ_NONE;
+}
+
+void set_wakeup_irqs(bool enable)
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
+		    !desc->skip_suspend) {
+			if (enable) {
+				/*
+				 * Replace handlers for not shared interrupts.
+				 * Shared ones have wrapper handlers already.
+				 */
+				if (!action->next) {
+					action->s_handler = action->handler;
+					action->handler = irq_pm_empty_handler;
+				}
+				desc->istate &= ~IRQS_SUSPENDED;
+				__enable_irq(desc, irq, false);
+			} else {
+				if (!(desc->istate & IRQS_SUSPENDED)) {
+					__disable_irq(desc, irq, false);
+					desc->istate |= IRQS_SUSPENDED;
+				}
+				if (action->handler == irq_pm_empty_handler) {
+					action->handler = action->s_handler;
+					action->s_handler = NULL;
+				}
+			}
+		}
+
+		raw_spin_unlock_irqrestore(&desc->lock, flags);
+	}
+}
Index: linux-pm/kernel/power/suspend.c
===================================================================
--- linux-pm.orig/kernel/power/suspend.c
+++ linux-pm/kernel/power/suspend.c
@@ -12,6 +12,7 @@
 #include <linux/delay.h>
 #include <linux/errno.h>
 #include <linux/init.h>
+#include <linux/interrupt.h>
 #include <linux/console.h>
 #include <linux/cpu.h>
 #include <linux/cpuidle.h>
@@ -55,7 +56,9 @@ static void freeze_enter(void)
 {
 	cpuidle_use_deepest_state(true);
 	cpuidle_resume();
+	set_wakeup_irqs(true);
 	wait_event(suspend_freeze_wait_head, suspend_freeze_wake);
+	set_wakeup_irqs(false);
 	cpuidle_pause();
 	cpuidle_use_deepest_state(false);
 }
Index: linux-pm/kernel/irq/spurious.c
===================================================================
--- linux-pm.orig/kernel/irq/spurious.c
+++ linux-pm/kernel/irq/spurious.c
@@ -277,7 +277,11 @@ void note_interrupt(unsigned int irq, st
 		    irqreturn_t action_ret)
 {
 	if (unlikely(irqs_suspended && action_ret == IRQ_NONE)) {
-		pr_err("IRQ %d: Unhandled while suspended\n", irq);
+		if (irqd_is_wakeup_set(&desc->irq_data))
+			desc->istate |= IRQS_PENDING;
+		else
+			pr_err("IRQ %d: Unhandled while suspended\n", irq);
+
 		desc->istate |= IRQS_SUSPENDED;
 		desc->depth++;
 		irq_disable(desc);

