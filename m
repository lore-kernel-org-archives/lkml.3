Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517AbaBSQ3D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 11:29:03 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56621 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754395AbaBSQ21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 11:28:27 -0500
Date: Wed, 19 Feb 2014 08:27:41 -0800
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-a92444c6b2225a9115d661c950cb48a22aeace20@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        linux@arm.linux.org.uk, peterz@infradead.org, chris@printf.net,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk, chris@printf.net, peterz@infradead.org,
        tglx@linutronix.de
In-Reply-To: <20140215003823.772565780@linutronix.de>
References: <20140215003823.772565780@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] genirq: Provide irq_wake_thread()
Git-Commit-ID: a92444c6b2225a9115d661c950cb48a22aeace20
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a92444c6b2225a9115d661c950cb48a22aeace20
Gitweb:     http://git.kernel.org/tip/a92444c6b2225a9115d661c950cb48a22aeace20
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Sat, 15 Feb 2014 00:55:19 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 19 Feb 2014 17:22:44 +0100

genirq: Provide irq_wake_thread()

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
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Chris Ball <chris@printf.net>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20140215003823.772565780@linutronix.de

---
 include/linux/interrupt.h |  1 +
 kernel/irq/handle.c       |  4 ++--
 kernel/irq/internals.h    |  1 +
 kernel/irq/manage.c       | 27 +++++++++++++++++++++++++++
 4 files changed, 31 insertions(+), 2 deletions(-)

diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index a2678d3..c7bfac1 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -188,6 +188,7 @@ extern void disable_irq(unsigned int irq);
 extern void disable_percpu_irq(unsigned int irq);
 extern void enable_irq(unsigned int irq);
 extern void enable_percpu_irq(unsigned int irq, unsigned int type);
+extern void irq_wake_thread(unsigned int irq, void *dev_id);
 
 /* The following three functions are for the core kernel use only. */
 extern void suspend_device_irqs(void);
diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index 131ca17..bfec453 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -51,7 +51,7 @@ static void warn_no_thread(unsigned int irq, struct irqaction *action)
 	       "but no thread function available.", irq, action->name);
 }
 
-static void irq_wake_thread(struct irq_desc *desc, struct irqaction *action)
+void __irq_wake_thread(struct irq_desc *desc, struct irqaction *action)
 {
 	/*
 	 * In case the thread crashed and was killed we just pretend that
@@ -157,7 +157,7 @@ handle_irq_event_percpu(struct irq_desc *desc, struct irqaction *action)
 				break;
 			}
 
-			irq_wake_thread(desc, action);
+			__irq_wake_thread(desc, action);
 
 			/* Fall through to add to randomness */
 		case IRQ_HANDLED:
diff --git a/kernel/irq/internals.h b/kernel/irq/internals.h
index 001fa5b..d61ac29 100644
--- a/kernel/irq/internals.h
+++ b/kernel/irq/internals.h
@@ -82,6 +82,7 @@ irqreturn_t handle_irq_event(struct irq_desc *desc);
 /* Resending of interrupts :*/
 void check_irq_resend(struct irq_desc *desc, unsigned int irq);
 bool irq_wait_for_poll(struct irq_desc *desc);
+void __irq_wake_thread(struct irq_desc *desc, struct irqaction *action);
 
 #ifdef CONFIG_PROC_FS
 extern void register_irq_proc(unsigned int irq, struct irq_desc *desc);
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 274ba92..54eb5c9 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -911,6 +911,33 @@ static int irq_thread(void *data)
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
