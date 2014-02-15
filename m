Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328AbaBOAzQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 19:55:16 -0500
Received: from www.linutronix.de ([62.245.132.108]:45558 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752934AbaBOAzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 19:55:14 -0500
Message-Id: <20140215003823.772565780@linutronix.de>
User-Agent: quilt/0.60-1
Date: Sat, 15 Feb 2014 00:55:19 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Russell King <linux@arm.linux.org.uk>, Chris Ball <chris@printf.net>,
        linux-mmc@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [patch 2/2] genirq: Provide irq_wake_thread()
References: <20140215002742.507053194@linutronix.de>
Content-Disposition: inline; filename=genirq-irq-kick-thread.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In course of the sdhci/sdio discussion with Russell about killing the
sdio kthread hackery we discovered the need to be able to wake an
interrupt thread from software.

The rationale for this is, that sdio hardware can lack proper
interrupt support for certain features. So the driver needs to poll
the status registers, but at the same time it needs to be woken up by
an hardware interrupt.

To be able to get rid of the home brewn kthread construct of sdio we
need a way to wake an irq thread independent of an actual hardware
interrupt.

Provide an irq_wake_thread() function which wakes up the thread which
is associated to a given dev_id. This allows sdio to invoke the irq
thread from the hardware irq handler via the IRQ_WAKE_THREAD return
value and provides a possibility to wake it via a timer for the
polling scenarios. That allows to simplify the sdio logic
significantly.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/interrupt.h |    1 +
 kernel/irq/handle.c       |    4 ++--
 kernel/irq/internals.h    |    1 +
 kernel/irq/manage.c       |   27 +++++++++++++++++++++++++++
 4 files changed, 31 insertions(+), 2 deletions(-)

Index: linux-2.6/include/linux/interrupt.h
===================================================================
--- linux-2.6.orig/include/linux/interrupt.h
+++ linux-2.6/include/linux/interrupt.h
@@ -183,6 +183,7 @@ extern void disable_irq(unsigned int irq
 extern void disable_percpu_irq(unsigned int irq);
 extern void enable_irq(unsigned int irq);
 extern void enable_percpu_irq(unsigned int irq, unsigned int type);
+extern void irq_wake_thread(unsigned int irq, void *dev_id);
 
 /* The following three functions are for the core kernel use only. */
 extern void suspend_device_irqs(void);
Index: linux-2.6/kernel/irq/handle.c
===================================================================
--- linux-2.6.orig/kernel/irq/handle.c
+++ linux-2.6/kernel/irq/handle.c
@@ -51,7 +51,7 @@ static void warn_no_thread(unsigned int
 	       "but no thread function available.", irq, action->name);
 }
 
-static void irq_wake_thread(struct irq_desc *desc, struct irqaction *action)
+void __irq_wake_thread(struct irq_desc *desc, struct irqaction *action)
 {
 	/*
 	 * In case the thread crashed and was killed we just pretend that
@@ -157,7 +157,7 @@ handle_irq_event_percpu(struct irq_desc
 				break;
 			}
 
-			irq_wake_thread(desc, action);
+			__irq_wake_thread(desc, action);
 
 			/* Fall through to add to randomness */
 		case IRQ_HANDLED:
Index: linux-2.6/kernel/irq/internals.h
===================================================================
--- linux-2.6.orig/kernel/irq/internals.h
+++ linux-2.6/kernel/irq/internals.h
@@ -82,6 +82,7 @@ irqreturn_t handle_irq_event(struct irq_
 /* Resending of interrupts :*/
 void check_irq_resend(struct irq_desc *desc, unsigned int irq);
 bool irq_wait_for_poll(struct irq_desc *desc);
+void __irq_wake_thread(struct irq_desc *desc, struct irqaction *action);
 
 #ifdef CONFIG_PROC_FS
 extern void register_irq_proc(unsigned int irq, struct irq_desc *desc);
Index: linux-2.6/kernel/irq/manage.c
===================================================================
--- linux-2.6.orig/kernel/irq/manage.c
+++ linux-2.6/kernel/irq/manage.c
@@ -908,6 +908,33 @@ static int irq_thread(void *data)
 	return 0;
 }
 
+/**
+ *	irq_wake_thread - wake the irq thread for the action identified by dev_id
+ *	@irq:		Interrupt line
+ *	@dev_id:	Device identity for which the thread should be woken
+ *
+ */
+void irq_wake_thread(unsigned int irq, void *dev_id)
+{
+	struct irq_desc *desc = irq_to_desc(irq);
+	struct irqaction *action;
+	unsigned long flags;
+
+	if (!desc || WARN_ON(irq_settings_is_per_cpu_devid(desc)))
+		return;
+
+	raw_spin_lock_irqsave(&desc->lock, flags);
+	for (action = desc->action; action; action = action->next) {
+		if (action->dev_id == dev_id) {
+			if (action->thread)
+				__irq_wake_thread(desc, action);
+			break;
+		}
+	}
+	raw_spin_unlock_irqrestore(&desc->lock, flags);
+}
+EXPORT_SYMBOL_GPL(irq_wake_thread);
+
 static void irq_setup_forced_threading(struct irqaction *new)
 {
 	if (!force_irqthreads)


