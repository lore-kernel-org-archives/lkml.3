Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754079AbaIAOLb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 10:11:31 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:53615 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754022AbaIAOL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 10:11:27 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Dmitry Torokhov <dtor@google.com>, Aubrey Li <aubrey.li@intel.com>
Subject: [PATCH 03/13] genirq: Add sanity checks for PM options on shared interrupt lines
Date: Mon, 01 Sep 2014 16:21:18 +0200
Message-ID: <1858713.x4D7GFtaer@vostro.rjw.lan>
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

Account the IRQF_NO_SUSPEND and IRQF_RESUME_EARLY actions on shared
interrupt lines and yell loudly if there is a mismatch.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 include/linux/irqdesc.h |   10 ++++++++++
 kernel/irq/internals.h  |   10 ++++++++++
 kernel/irq/manage.c     |    4 ++++
 kernel/irq/pm.c         |   36 ++++++++++++++++++++++++++++++++++++
 4 files changed, 60 insertions(+)

Index: linux/include/linux/irqdesc.h
===================================================================
--- linux.orig/include/linux/irqdesc.h
+++ linux/include/linux/irqdesc.h
@@ -36,6 +36,11 @@ struct irq_desc;
  * @threads_oneshot:	bitfield to handle shared oneshot threads
  * @threads_active:	number of irqaction threads currently running
  * @wait_for_threads:	wait queue for sync_irq to wait for threaded handlers
+ * @nr_actions:		number of installed actions on this descriptor
+ * @no_suspend_depth:	number of irqactions on a irq descriptor with
+ *			IRQF_NO_SUSPEND set
+ * @force_resume_depth:	number of irqactions on a irq descriptor with
+ *			IRQF_FORCE_RESUME set
  * @dir:		/proc/irq/ procfs entry
  * @name:		flow handler name for /proc/interrupts output
  */
@@ -68,6 +73,11 @@ struct irq_desc {
 	unsigned long		threads_oneshot;
 	atomic_t		threads_active;
 	wait_queue_head_t       wait_for_threads;
+#ifdef CONFIG_PM_SLEEP
+	unsigned int		nr_actions;
+	unsigned int		no_suspend_depth;
+	unsigned int		force_resume_depth;
+#endif
 #ifdef CONFIG_PROC_FS
 	struct proc_dir_entry	*dir;
 #endif
Index: linux/kernel/irq/internals.h
===================================================================
--- linux.orig/kernel/irq/internals.h
+++ linux/kernel/irq/internals.h
@@ -194,3 +194,13 @@ static inline void kstat_incr_irqs_this_
 	__this_cpu_inc(*desc->kstat_irqs);
 	__this_cpu_inc(kstat.irqs_sum);
 }
+
+#ifdef CONFIG_PM_SLEEP
+void irq_pm_install_action(struct irq_desc *desc, struct irqaction *action);
+void irq_pm_remove_action(struct irq_desc *desc, struct irqaction *action);
+#else
+static inline void
+irq_pm_install_action(struct irq_desc *desc, struct irqaction *action) { }
+static inline void
+irq_pm_remove_action(struct irq_desc *desc, struct irqaction *action) { }
+#endif
Index: linux/kernel/irq/manage.c
===================================================================
--- linux.orig/kernel/irq/manage.c
+++ linux/kernel/irq/manage.c
@@ -1200,6 +1200,8 @@ __setup_irq(unsigned int irq, struct irq
 	new->irq = irq;
 	*old_ptr = new;
 
+	irq_pm_install_action(desc, new);
+
 	/* Reset broken irq detection when installing new handler */
 	desc->irq_count = 0;
 	desc->irqs_unhandled = 0;
@@ -1318,6 +1320,8 @@ static struct irqaction *__free_irq(unsi
 	/* Found it - now remove it from the list of entries: */
 	*action_ptr = action->next;
 
+	irq_pm_remove_action(desc, action);
+
 	/* If this was the last handler, shut down the IRQ line: */
 	if (!desc->action) {
 		irq_shutdown(desc);
Index: linux/kernel/irq/pm.c
===================================================================
--- linux.orig/kernel/irq/pm.c
+++ linux/kernel/irq/pm.c
@@ -13,6 +13,42 @@
 
 #include "internals.h"
 
+/*
+ * Called from __setup_irq() with desc->lock held after @action has
+ * been installed in the action chain.
+ */
+void irq_pm_install_action(struct irq_desc *desc, struct irqaction *action)
+{
+	desc->nr_actions++;
+
+	if (action->flags & IRQF_FORCE_RESUME)
+		desc->force_resume_depth++;
+
+	WARN_ON_ONCE(desc->force_resume_depth &&
+		     desc->force_resume_depth != desc->nr_actions);
+
+	if (action->flags & IRQF_NO_SUSPEND)
+		desc->no_suspend_depth++;
+
+	WARN_ON_ONCE(desc->no_suspend_depth &&
+		     desc->no_suspend_depth != desc->nr_actions);
+}
+
+/*
+ * Called from __free_irq() with desc->lock held after @action has
+ * been removed from the action chain.
+ */
+void irq_pm_remove_action(struct irq_desc *desc, struct irqaction *action)
+{
+	desc->nr_actions--;
+
+	if (action->flags & IRQF_FORCE_RESUME)
+		desc->force_resume_depth--;
+
+	if (action->flags & IRQF_NO_SUSPEND)
+		desc->no_suspend_depth--;
+}
+
 static void suspend_device_irq(struct irq_desc *desc, int irq)
 {
 	if (!desc->action || (desc->action->flags & IRQF_NO_SUSPEND))

