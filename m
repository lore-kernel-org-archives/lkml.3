Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757517Ab3IHP4u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 11:56:50 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:18000 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753313Ab3IHP4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 11:56:45 -0400
X-Authority-Analysis: v=2.0 cv=ddwCLAre c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=0RwJNaDwE-0A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=qJjMsBi07U4A:10 a=VwQbUJbxAAAA:8 a=PRS0kguCKcSZEYgeq30A:9 a=Zh68SRI7RUMA:10 a=yKd8XQAxV8kKYKP1:21 a=M-nld2JXMtTBgiWn:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130908151448.833507988@goodmis.org>
User-Agent: quilt/0.60-1
Date: Sun, 08 Sep 2013 11:14:13 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        John Kacur <jkacur@redhat.com>, <stable-rt@vger.kernel.org>
Subject: [PATCH RT 18/19] genirq: do not invoke the affinity callback via a workqueue
References: <20130908151355.362583092@goodmis.org>
Content-Disposition: inline; filename=0018-genirq-do-not-invoke-the-affinity-callback-via-a-wor.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Joe Korty reported, that __irq_set_affinity_locked() schedules a
workqueue while holding a rawlock which results in a might_sleep()
warning.
This patch moves the invokation into a process context so that we only
wakeup() a process while holding the lock.

Cc: stable-rt@vger.kernel.org
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 include/linux/interrupt.h |    1 +
 kernel/irq/manage.c       |   79 +++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 77 insertions(+), 3 deletions(-)

diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index fb81baa..16fbe2b 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -263,6 +263,7 @@ struct irq_affinity_notify {
 	unsigned int irq;
 	struct kref kref;
 	struct work_struct work;
+	struct list_head list;
 	void (*notify)(struct irq_affinity_notify *, const cpumask_t *mask);
 	void (*release)(struct kref *ref);
 };
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 2ecc232..0fe99a4 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -163,6 +163,62 @@ int irq_do_set_affinity(struct irq_data *data, const struct cpumask *mask,
 	return ret;
 }
 
+#ifdef CONFIG_PREEMPT_RT_FULL
+static void _irq_affinity_notify(struct irq_affinity_notify *notify);
+static struct task_struct *set_affinity_helper;
+static LIST_HEAD(affinity_list);
+static DEFINE_RAW_SPINLOCK(affinity_list_lock);
+
+static int set_affinity_thread(void *unused)
+{
+	while (1) {
+		struct irq_affinity_notify *notify;
+		int empty;
+
+		set_current_state(TASK_INTERRUPTIBLE);
+
+		raw_spin_lock_irq(&affinity_list_lock);
+		empty = list_empty(&affinity_list);
+		raw_spin_unlock_irq(&affinity_list_lock);
+
+		if (empty)
+			schedule();
+		if (kthread_should_stop())
+			break;
+		set_current_state(TASK_RUNNING);
+try_next:
+		notify = NULL;
+
+		raw_spin_lock_irq(&affinity_list_lock);
+		if (!list_empty(&affinity_list)) {
+			notify = list_first_entry(&affinity_list,
+					struct irq_affinity_notify, list);
+			list_del_init(&notify->list);
+		}
+		raw_spin_unlock_irq(&affinity_list_lock);
+
+		if (!notify)
+			continue;
+		_irq_affinity_notify(notify);
+		goto try_next;
+	}
+	return 0;
+}
+
+static void init_helper_thread(void)
+{
+	if (set_affinity_helper)
+		return;
+	set_affinity_helper = kthread_run(set_affinity_thread, NULL,
+			"affinity-cb");
+	WARN_ON(IS_ERR(set_affinity_helper));
+}
+#else
+
+static inline void init_helper_thread(void) { }
+
+#endif
+
 int __irq_set_affinity_locked(struct irq_data *data, const struct cpumask *mask)
 {
 	struct irq_chip *chip = irq_data_get_irq_chip(data);
@@ -181,7 +237,17 @@ int __irq_set_affinity_locked(struct irq_data *data, const struct cpumask *mask)
 
 	if (desc->affinity_notify) {
 		kref_get(&desc->affinity_notify->kref);
+
+#ifdef CONFIG_PREEMPT_RT_FULL
+		raw_spin_lock(&affinity_list_lock);
+		if (list_empty(&desc->affinity_notify->list))
+			list_add_tail(&affinity_list,
+					&desc->affinity_notify->list);
+		raw_spin_unlock(&affinity_list_lock);
+		wake_up_process(set_affinity_helper);
+#else
 		schedule_work(&desc->affinity_notify->work);
+#endif
 	}
 	irqd_set(data, IRQD_AFFINITY_SET);
 
@@ -222,10 +288,8 @@ int irq_set_affinity_hint(unsigned int irq, const struct cpumask *m)
 }
 EXPORT_SYMBOL_GPL(irq_set_affinity_hint);
 
-static void irq_affinity_notify(struct work_struct *work)
+static void _irq_affinity_notify(struct irq_affinity_notify *notify)
 {
-	struct irq_affinity_notify *notify =
-		container_of(work, struct irq_affinity_notify, work);
 	struct irq_desc *desc = irq_to_desc(notify->irq);
 	cpumask_var_t cpumask;
 	unsigned long flags;
@@ -247,6 +311,13 @@ out:
 	kref_put(&notify->kref, notify->release);
 }
 
+static void irq_affinity_notify(struct work_struct *work)
+{
+	struct irq_affinity_notify *notify =
+		container_of(work, struct irq_affinity_notify, work);
+	_irq_affinity_notify(notify);
+}
+
 /**
  *	irq_set_affinity_notifier - control notification of IRQ affinity changes
  *	@irq:		Interrupt for which to enable/disable notification
@@ -276,6 +347,8 @@ irq_set_affinity_notifier(unsigned int irq, struct irq_affinity_notify *notify)
 		notify->irq = irq;
 		kref_init(&notify->kref);
 		INIT_WORK(&notify->work, irq_affinity_notify);
+		INIT_LIST_HEAD(&notify->list);
+		init_helper_thread();
 	}
 
 	raw_spin_lock_irqsave(&desc->lock, flags);
-- 
1.7.10.4


