Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755838AbaHEPMN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 11:12:13 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:62791 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753768AbaHEPLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 11:11:00 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Linux PM list <linux-pm@vger.kernel.org>,
        Dmitry Torokhov <dtor@google.com>
Subject: [PATCH 3/5] irq / PM: Make wakeup interrupts wake up from suspend-to-idle
Date: Tue, 05 Aug 2014 17:26:27 +0200
Message-ID: <1811897.nanFq2OCTN@vostro.rjw.lan>
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

Make IRQs enabled for system wakeup via enable_irq_wake() wake up
the system from suspend-to-idle.

For this purpose, introduce a new routine for enabling or disabling
wakeup interrupts, set_wakeup_irqs(), and make freeze_enter() call
it to enable them before starting the suspend-to-idle loop and to
disable them after the loop has been terminated.

Also make note_interrupt() check the wakeup status of the IRQ when
irqs_suspended is set and wake up the system (or abort system
suspend in progress) for wakeup interrupts as well as for unhandled
ones.  This is necessary to handle wakeup IRQs that aren't shared,
because their handlers may still return IRQ_HANDLED when
irqs_suspended is set.

Thus callers of enable_irq_wake() still need to be prepared for
handling interrupts from the given IRQ during the entire system
suspend and resume, but it is not guaranteed that those handlers
will be invoked every time between suspend_device_irqs() and
resume_device_irqs() (the core may simply wake up the system or
abort system suspend in progress without invoking original
interrupt handlers for the IRQ).

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 include/linux/interrupt.h |    1 +
 kernel/irq/pm.c           |   25 +++++++++++++++++++++++++
 kernel/irq/spurious.c     |    7 +++++--
 kernel/power/suspend.c    |    3 +++
 4 files changed, 34 insertions(+), 2 deletions(-)

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
@@ -130,3 +130,28 @@ int check_wakeup_irqs(void)
 
 	return 0;
 }
+
+void set_wakeup_irqs(bool enable)
+{
+	struct irq_desc *desc;
+	int irq;
+
+	for_each_irq_desc(irq, desc) {
+		unsigned long flags;
+
+		raw_spin_lock_irqsave(&desc->lock, flags);
+
+		if (desc->action && irqd_is_wakeup_set(&desc->irq_data) &&
+		    !desc->skip_suspend) {
+			if (enable) {
+				desc->istate &= ~IRQS_SUSPENDED;
+				__enable_irq(desc, irq, false);
+			} else if (!(desc->istate & IRQS_SUSPENDED)) {
+				__disable_irq(desc, irq, false);
+				desc->istate |= IRQS_SUSPENDED;
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
@@ -276,8 +276,11 @@ try_misrouted_irq(unsigned int irq, stru
 void note_interrupt(unsigned int irq, struct irq_desc *desc,
 		    irqreturn_t action_ret)
 {
-	if (unlikely(irqs_suspended && action_ret == IRQ_NONE)) {
-		pr_err("IRQ %d: Unhandled while suspended\n", irq);
+	if (unlikely(irqs_suspended &&
+	    (action_ret == IRQ_NONE || irqd_is_wakeup_set(&desc->irq_data)))) {
+		if (!irqd_is_wakeup_set(&desc->irq_data))
+			pr_err("IRQ %d: Unhandled while suspended\n", irq);
+
 		desc->istate |= IRQS_SUSPENDED;
 		desc->depth++;
 		irq_disable(desc);

