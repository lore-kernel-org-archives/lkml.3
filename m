Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751602AbaLOQQD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 11:16:03 -0500
Received: from down.free-electrons.com ([37.187.137.238]:57017 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751015AbaLOQP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 11:15:57 -0500
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        Mike Turquette <mturquette@linaro.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: [PATCH 1/5] genirq: Support mixing IRQF_NO_SUSPEND/IRQF_SUSPEND on shared irqs
Date: Mon, 15 Dec 2014 17:15:48 +0100
Message-Id: <1418660152-17185-2-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1418660152-17185-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1418660152-17185-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current implementation forbid sharing an irq line on devices that do
not request the same behavior on suspend/resume (controlled via the
IRQF_NO_SUSPEND/IRQF_FORCE_RESUME flags).

Add a flag (IRQF_SUSPEND_NOACTION) to specify that you don't want to be
called in suspend mode, and that you already took care of disabling the
interrupt on the device side.

The suspend_device_irq will now move actions specifying the
IRQF_SUSPEND_NOACTION into a temporary list so that they won't be called
when the interrupt is triggered, and resume_irq_actions restores the
suspended actions into the active action list.

Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
---
 include/linux/interrupt.h | 11 ++++++++
 include/linux/irqdesc.h   |  3 ++
 kernel/irq/pm.c           | 71 +++++++++++++++++++++++++++++++++++++++++++++--
 3 files changed, 82 insertions(+), 3 deletions(-)

diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index d9b05b5..aba3f36 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -57,6 +57,16 @@
  * IRQF_NO_THREAD - Interrupt cannot be threaded
  * IRQF_EARLY_RESUME - Resume IRQ early during syscore instead of at device
  *                resume time.
+ * IRQF_SUSPEND_NOACTION - When sharing an irq, a specific handler can ask to
+ *                         be disabled when entering suspend. This is
+ *                         particularly useful on shared irqs where at least
+ *                         one user is requesting IRQF_NO_SUSPEND while the
+ *                         others don't want to be active on suspend.
+ *                         Setting this flag implies taking the appropriate
+ *                         action to disable device interrupts when entering
+ *                         suspend, otherwise you might experience spurious
+ *                         interrupts.
+ *
  */
 #define IRQF_DISABLED		0x00000020
 #define IRQF_SHARED		0x00000080
@@ -70,6 +80,7 @@
 #define IRQF_FORCE_RESUME	0x00008000
 #define IRQF_NO_THREAD		0x00010000
 #define IRQF_EARLY_RESUME	0x00020000
+#define IRQF_SUSPEND_NOACTION	0x00040000
 
 #define IRQF_TIMER		(__IRQF_TIMER | IRQF_NO_SUSPEND | IRQF_NO_THREAD)
 
diff --git a/include/linux/irqdesc.h b/include/linux/irqdesc.h
index faf433a..64a577f 100644
--- a/include/linux/irqdesc.h
+++ b/include/linux/irqdesc.h
@@ -22,6 +22,7 @@ struct pt_regs;
  * @handle_irq:		highlevel irq-events handler
  * @preflow_handler:	handler called before the flow handler (currently used by sparc)
  * @action:		the irq action chain
+ * @suspended_action:	the irq suspended action chain
  * @status:		status information
  * @core_internal_state__do_not_mess_with_it: core internal status information
  * @depth:		disable-depth, for nested irq_disable() calls
@@ -54,6 +55,7 @@ struct irq_desc {
 	irq_preflow_handler_t	preflow_handler;
 #endif
 	struct irqaction	*action;	/* IRQ action list */
+	struct irqaction	*suspended_action; /* IRQ suspended action list */
 	unsigned int		status_use_accessors;
 	unsigned int		core_internal_state__do_not_mess_with_it;
 	unsigned int		depth;		/* nested irq disables */
@@ -79,6 +81,7 @@ struct irq_desc {
 	unsigned int		nr_actions;
 	unsigned int		no_suspend_depth;
 	unsigned int		force_resume_depth;
+	unsigned int		suspend_noaction_depth;
 #endif
 #ifdef CONFIG_PROC_FS
 	struct proc_dir_entry	*dir;
diff --git a/kernel/irq/pm.c b/kernel/irq/pm.c
index 3ca5325..45446e1 100644
--- a/kernel/irq/pm.c
+++ b/kernel/irq/pm.c
@@ -35,17 +35,24 @@ void irq_pm_install_action(struct irq_desc *desc, struct irqaction *action)
 {
 	desc->nr_actions++;
 
+	if (action->flags & IRQF_SUSPEND_NOACTION) {
+		desc->suspend_noaction_depth++;
+		return;
+	}
+
 	if (action->flags & IRQF_FORCE_RESUME)
 		desc->force_resume_depth++;
 
 	WARN_ON_ONCE(desc->force_resume_depth &&
-		     desc->force_resume_depth != desc->nr_actions);
+		     (desc->force_resume_depth +
+		      desc->suspend_noaction_depth) != desc->nr_actions);
 
 	if (action->flags & IRQF_NO_SUSPEND)
 		desc->no_suspend_depth++;
 
 	WARN_ON_ONCE(desc->no_suspend_depth &&
-		     desc->no_suspend_depth != desc->nr_actions);
+		     (desc->no_suspend_depth +
+		      desc->suspend_noaction_depth) != desc->nr_actions);
 }
 
 /*
@@ -56,6 +63,11 @@ void irq_pm_remove_action(struct irq_desc *desc, struct irqaction *action)
 {
 	desc->nr_actions--;
 
+	if (action->flags & IRQF_SUSPEND_NOACTION) {
+		desc->suspend_noaction_depth--;
+		return;
+	}
+
 	if (action->flags & IRQF_FORCE_RESUME)
 		desc->force_resume_depth--;
 
@@ -63,11 +75,63 @@ void irq_pm_remove_action(struct irq_desc *desc, struct irqaction *action)
 		desc->no_suspend_depth--;
 }
 
+/*
+ * Move all irq actions that specifically set IRQF_SUSPEND_NOACTION
+ * into the suspended action list so that they won't be called if an
+ * interrupt happens.
+ */
+static void suspend_irq_actions(struct irq_desc *desc)
+{
+	struct irqaction *action;
+	struct irqaction *suspended_action = NULL;
+
+	for (action = desc->action; action; action = action->next) {
+		if (!(action->flags & IRQF_SUSPEND_NOACTION))
+			continue;
+
+		if (!suspended_action) {
+			suspended_action = action->next;
+		} else {
+			suspended_action->next = action;
+			suspended_action = action;
+		}
+	}
+
+	BUG_ON(!suspended_action);
+	suspended_action->next = NULL;
+}
+
+/*
+ * Restore all irq actions pushed into the suspended action list.
+ */
+static void resume_irq_actions(struct irq_desc *desc)
+{
+	struct irqaction *action;
+
+	if (!desc->suspended_action)
+		return;
+
+	for (action = desc->action; action && action->next;
+	     action = action->next)
+		;
+
+	BUG_ON(!action);
+	action->next = desc->suspended_action;
+	desc->suspended_action = NULL;
+}
+
 static bool suspend_device_irq(struct irq_desc *desc, int irq)
 {
-	if (!desc->action || desc->no_suspend_depth)
+	if (!desc->action)
 		return false;
 
+	if (desc->no_suspend_depth) {
+		if (desc->no_suspend_depth != desc->nr_actions)
+			suspend_irq_actions(desc);
+
+		return false;
+	}
+
 	if (irqd_is_wakeup_set(&desc->irq_data)) {
 		irqd_set(&desc->irq_data, IRQD_WAKEUP_ARMED);
 		/*
@@ -131,6 +195,7 @@ EXPORT_SYMBOL_GPL(suspend_device_irqs);
 static void resume_irq(struct irq_desc *desc, int irq)
 {
 	irqd_clear(&desc->irq_data, IRQD_WAKEUP_ARMED);
+	resume_irq_actions(desc);
 
 	if (desc->istate & IRQS_SUSPENDED)
 		goto resume;
-- 
1.9.1

