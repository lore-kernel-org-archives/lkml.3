Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103AbaIAOLd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 10:11:33 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:53639 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754045AbaIAOL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 10:11:27 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Dmitry Torokhov <dtor@google.com>, Aubrey Li <aubrey.li@intel.com>
Subject: [PATCH 02/13] genirq: Move suspend/resume logic into irq/pm code
Date: Mon, 01 Sep 2014 16:20:37 +0200
Message-ID: <1504806.eH5pWVEYTM@vostro.rjw.lan>
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

No functional change. Preparatory patch for cleaning up the suspend
abort functionality. Update the comments while at it.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 kernel/irq/internals.h |    4 ++--
 kernel/irq/manage.c    |   28 +++++-----------------------
 kernel/irq/pm.c        |   44 ++++++++++++++++++++++++++++++++++++++------
 3 files changed, 45 insertions(+), 31 deletions(-)

Index: linux/kernel/irq/internals.h
===================================================================
--- linux.orig/kernel/irq/internals.h
+++ linux/kernel/irq/internals.h
@@ -63,8 +63,8 @@ enum {
 
 extern int __irq_set_trigger(struct irq_desc *desc, unsigned int irq,
 		unsigned long flags);
-extern void __disable_irq(struct irq_desc *desc, unsigned int irq, bool susp);
-extern void __enable_irq(struct irq_desc *desc, unsigned int irq, bool resume);
+extern void __disable_irq(struct irq_desc *desc, unsigned int irq);
+extern void __enable_irq(struct irq_desc *desc, unsigned int irq);
 
 extern int irq_startup(struct irq_desc *desc, bool resend);
 extern void irq_shutdown(struct irq_desc *desc);
Index: linux/kernel/irq/manage.c
===================================================================
--- linux.orig/kernel/irq/manage.c
+++ linux/kernel/irq/manage.c
@@ -382,14 +382,8 @@ setup_affinity(unsigned int irq, struct
 }
 #endif
 
-void __disable_irq(struct irq_desc *desc, unsigned int irq, bool suspend)
+void __disable_irq(struct irq_desc *desc, unsigned int irq)
 {
-	if (suspend) {
-		if (!desc->action || (desc->action->flags & IRQF_NO_SUSPEND))
-			return;
-		desc->istate |= IRQS_SUSPENDED;
-	}
-
 	if (!desc->depth++)
 		irq_disable(desc);
 }
@@ -401,7 +395,7 @@ static int __disable_irq_nosync(unsigned
 
 	if (!desc)
 		return -EINVAL;
-	__disable_irq(desc, irq, false);
+	__disable_irq(desc, irq);
 	irq_put_desc_busunlock(desc, flags);
 	return 0;
 }
@@ -442,20 +436,8 @@ void disable_irq(unsigned int irq)
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
@@ -497,7 +479,7 @@ void enable_irq(unsigned int irq)
 		 KERN_ERR "enable_irq before setup/request_irq: irq %u\n", irq))
 		goto out;
 
-	__enable_irq(desc, irq, false);
+	__enable_irq(desc, irq);
 out:
 	irq_put_desc_busunlock(desc, flags);
 }
@@ -1228,7 +1210,7 @@ __setup_irq(unsigned int irq, struct irq
 	 */
 	if (shared && (desc->istate & IRQS_SPURIOUS_DISABLED)) {
 		desc->istate &= ~IRQS_SPURIOUS_DISABLED;
-		__enable_irq(desc, irq, false);
+		__enable_irq(desc, irq);
 	}
 
 	raw_spin_unlock_irqrestore(&desc->lock, flags);
Index: linux/kernel/irq/pm.c
===================================================================
--- linux.orig/kernel/irq/pm.c
+++ linux/kernel/irq/pm.c
@@ -13,13 +13,26 @@
 
 #include "internals.h"
 
+static void suspend_device_irq(struct irq_desc *desc, int irq)
+{
+	if (!desc->action || (desc->action->flags & IRQF_NO_SUSPEND))
+		return;
+
+	desc->istate |= IRQS_SUSPENDED;
+	__disable_irq(desc, irq);
+}
+
 /**
  * suspend_device_irqs - disable all currently enabled interrupt lines
  *
- * During system-wide suspend or hibernation device drivers need to be prevented
- * from receiving interrupts and this function is provided for this purpose.
- * It marks all interrupt lines in use, except for the timer ones, as disabled
- * and sets the IRQS_SUSPENDED flag for each of them.
+ * During system-wide suspend or hibernation device drivers need to be
+ * prevented from receiving interrupts and this function is provided
+ * for this purpose.
+ *
+ * So we disable all interrupts and mark them IRQS_SUSPENDED except
+ * for those which are unused and those which are marked as not
+ * suspendable via an interrupt request with the flag IRQF_NO_SUSPEND
+ * set.
  */
 void suspend_device_irqs(void)
 {
@@ -30,7 +43,7 @@ void suspend_device_irqs(void)
 		unsigned long flags;
 
 		raw_spin_lock_irqsave(&desc->lock, flags);
-		__disable_irq(desc, irq, true);
+		suspend_device_irq(desc, irq);
 		raw_spin_unlock_irqrestore(&desc->lock, flags);
 	}
 
@@ -40,6 +53,25 @@ void suspend_device_irqs(void)
 }
 EXPORT_SYMBOL_GPL(suspend_device_irqs);
 
+static void resume_irq(struct irq_desc *desc, int irq)
+{
+	if (desc->istate & IRQS_SUSPENDED)
+		goto resume;
+
+	if (!desc->action)
+		return;
+
+	/* Interrupts marked with that flag are force reenabled */
+	if (!(desc->action->flags & IRQF_FORCE_RESUME))
+		return;
+
+	/* Pretend that it got disabled ! */
+	desc->depth++;
+resume:
+	desc->istate &= ~IRQS_SUSPENDED;
+	__enable_irq(desc, irq);
+}
+
 static void resume_irqs(bool want_early)
 {
 	struct irq_desc *desc;
@@ -54,7 +86,7 @@ static void resume_irqs(bool want_early)
 			continue;
 
 		raw_spin_lock_irqsave(&desc->lock, flags);
-		__enable_irq(desc, irq, true);
+		resume_irq(desc, irq);
 		raw_spin_unlock_irqrestore(&desc->lock, flags);
 	}
 }

