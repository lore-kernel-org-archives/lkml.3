Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754382AbaIAOPI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 10:15:08 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:57111 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753438AbaIAOLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 10:11:21 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Dmitry Torokhov <dtor@google.com>, Aubrey Li <aubrey.li@intel.com>
Subject: [PATCH 10/13] genirq: Simplify wakeup mechanism
Date: Mon, 01 Sep 2014 16:27:22 +0200
Message-ID: <1618455.xcqKAKx7vG@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <2516134.pmOxkEuOOy@vostro.rjw.lan>
References: <26580319.OZP7jvJnA9@vostro.rjw.lan> <5320472.coYotHR1d0@vostro.rjw.lan> <2516134.pmOxkEuOOy@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

Currently we suspend wakeup interrupts by lazy disabling them and
check later whether the interrupt has fired, but that's not sufficient
for suspend to idle as there is no way to check that once we
transitioned into the CPU idle state.

So we change the mechanism in the following way:

1) Leave the wakeup interrupts enabled across suspend

2) Add a check to irq_may_run() which is called at the beginning of
   each flow handler whether the interrupt is an armed wakeup source.

   This check is basically free as it just extends the existing check
   for IRQD_IRQ_INPROGRESS. So no new conditional in the hot path.

   If the IRQD_WAKEUP_ARMED flag is set, then the interrupt is
   disabled, marked as pending/suspended and the pm core is notified
   about the wakeup event.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
[ rjw: syscore.c and irq_pm_check_wakeup() in pm.c ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/base/syscore.c    |    7 ++---
 include/linux/interrupt.h |    5 ----
 kernel/irq/chip.c         |   20 +++++++++++++++-
 kernel/irq/internals.h    |    2 +
 kernel/irq/pm.c           |   55 ++++++++++++++++++++++++----------------------
 5 files changed, 53 insertions(+), 36 deletions(-)

Index: linux-pm/drivers/base/syscore.c
===================================================================
--- linux-pm.orig/drivers/base/syscore.c
+++ linux-pm/drivers/base/syscore.c
@@ -9,7 +9,7 @@
 #include <linux/syscore_ops.h>
 #include <linux/mutex.h>
 #include <linux/module.h>
-#include <linux/interrupt.h>
+#include <linux/suspend.h>
 #include <trace/events/power.h>
 
 static LIST_HEAD(syscore_ops_list);
@@ -54,9 +54,8 @@ int syscore_suspend(void)
 	pr_debug("Checking wakeup interrupts\n");
 
 	/* Return error code if there are any wakeup interrupts pending. */
-	ret = check_wakeup_irqs();
-	if (ret)
-		return ret;
+	if (pm_wakeup_pending())
+		return -EBUSY;
 
 	WARN_ONCE(!irqs_disabled(),
 		"Interrupts enabled before system core suspend.\n");
Index: linux-pm/include/linux/interrupt.h
===================================================================
--- linux-pm.orig/include/linux/interrupt.h
+++ linux-pm/include/linux/interrupt.h
@@ -193,11 +193,6 @@ extern void irq_wake_thread(unsigned int
 /* The following three functions are for the core kernel use only. */
 extern void suspend_device_irqs(void);
 extern void resume_device_irqs(void);
-#ifdef CONFIG_PM_SLEEP
-extern int check_wakeup_irqs(void);
-#else
-static inline int check_wakeup_irqs(void) { return 0; }
-#endif
 
 /**
  * struct irq_affinity_notify - context for notification of IRQ affinity changes
Index: linux-pm/kernel/irq/chip.c
===================================================================
--- linux-pm.orig/kernel/irq/chip.c
+++ linux-pm/kernel/irq/chip.c
@@ -344,8 +344,26 @@ static bool irq_check_poll(struct irq_de
 
 static bool irq_may_run(struct irq_desc *desc)
 {
-	if (!irqd_irq_inprogress(&desc->irq_data))
+	unsigned int mask = IRQD_IRQ_INPROGRESS | IRQD_WAKEUP_ARMED;
+
+	/*
+	 * If the interrupt is not in progress and is not an armed
+	 * wakeup interrupt, proceed.
+	 */
+	if (!irqd_has_set(&desc->irq_data, mask))
 		return true;
+
+	/*
+	 * If the interrupt is an armed wakeup source, mark it pending
+	 * and suspended, disable it and notify the pm core about the
+	 * event.
+	 */
+	if (irq_pm_check_wakeup(desc))
+		return false;
+
+	/*
+	 * Handle a potential concurrent poll on a different core.
+	 */
 	return irq_check_poll(desc);
 }
 
Index: linux-pm/kernel/irq/pm.c
===================================================================
--- linux-pm.orig/kernel/irq/pm.c
+++ linux-pm/kernel/irq/pm.c
@@ -9,10 +9,24 @@
 #include <linux/irq.h>
 #include <linux/module.h>
 #include <linux/interrupt.h>
+#include <linux/suspend.h>
 #include <linux/syscore_ops.h>
 
 #include "internals.h"
 
+bool irq_pm_check_wakeup(struct irq_desc *desc)
+{
+	if (irqd_is_wakeup_armed(&desc->irq_data)) {
+		irqd_clear(&desc->irq_data, IRQD_WAKEUP_ARMED);
+		desc->istate |= IRQS_SUSPENDED | IRQS_PENDING;
+		desc->depth++;
+		irq_disable(desc);
+		pm_system_wakeup();
+		return true;
+	}
+	return false;
+}
+
 /*
  * Called from __setup_irq() with desc->lock held after @action has
  * been installed in the action chain.
@@ -54,8 +68,16 @@ static bool suspend_device_irq(struct ir
 	if (!desc->action || desc->no_suspend_depth)
 		return false;
 
-	if (irqd_is_wakeup_set(&desc->irq_data))
+	if (irqd_is_wakeup_set(&desc->irq_data)) {
 		irqd_set(&desc->irq_data, IRQD_WAKEUP_ARMED);
+		/*
+		 * We return true here to force the caller to issue
+		 * synchronize_irq(). We need to make sure that the
+		 * IRQD_WAKEUP_ARMED is visible before we return from
+		 * suspend_device_irqs().
+		 */
+		return true;
+	}
 
 	desc->istate |= IRQS_SUSPENDED;
 	__disable_irq(desc, irq);
@@ -79,9 +101,13 @@ static bool suspend_device_irq(struct ir
  * for this purpose.
  *
  * So we disable all interrupts and mark them IRQS_SUSPENDED except
- * for those which are unused and those which are marked as not
+ * for those which are unused, those which are marked as not
  * suspendable via an interrupt request with the flag IRQF_NO_SUSPEND
- * set.
+ * set and those which are marked as active wakeup sources.
+ *
+ * The active wakeup sources are handled by the flow handler entry
+ * code which checks for the IRQD_WAKEUP_ARMED flag, suspends the
+ * interrupt and notifies the pm core about the wakeup.
  */
 void suspend_device_irqs(void)
 {
@@ -173,26 +199,3 @@ void resume_device_irqs(void)
 	resume_irqs(false);
 }
 EXPORT_SYMBOL_GPL(resume_device_irqs);
-
-/**
- * check_wakeup_irqs - check if any wake-up interrupts are pending
- */
-int check_wakeup_irqs(void)
-{
-	struct irq_desc *desc;
-	int irq;
-
-	for_each_irq_desc(irq, desc) {
-		/*
-		 * Only interrupts which are marked as wakeup source
-		 * and have not been disabled before the suspend check
-		 * can abort suspend.
-		 */
-		if (irqd_is_wakeup_set(&desc->irq_data)) {
-			if (desc->depth == 1 && desc->istate & IRQS_PENDING)
-				return -EBUSY;
-		}
-	}
-
-	return 0;
-}
Index: linux-pm/kernel/irq/internals.h
===================================================================
--- linux-pm.orig/kernel/irq/internals.h
+++ linux-pm/kernel/irq/internals.h
@@ -196,9 +196,11 @@ static inline void kstat_incr_irqs_this_
 }
 
 #ifdef CONFIG_PM_SLEEP
+bool irq_pm_check_wakeup(struct irq_desc *desc);
 void irq_pm_install_action(struct irq_desc *desc, struct irqaction *action);
 void irq_pm_remove_action(struct irq_desc *desc, struct irqaction *action);
 #else
+static inline bool irq_pm_check_wakeup(struct irq_desc *desc) { return false; }
 static inline void
 irq_pm_install_action(struct irq_desc *desc, struct irqaction *action) { }
 static inline void

