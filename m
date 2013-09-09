Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753678Ab3IINcW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 09:32:22 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:7357 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753547Ab3IIN0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 09:26:51 -0400
X-Authority-Analysis: v=2.0 cv=fJG7LOme c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=v8jgAOqRqeAA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=qJjMsBi07U4A:10 a=VwQbUJbxAAAA:8 a=PRS0kguCKcSZEYgeq30A:9 a=Zh68SRI7RUMA:10 a=BFeE0_prAAv7tewp:21 a=hXhVpHU6IfPDYlDg:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130909124558.450347261@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 09 Sep 2013 08:45:46 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        John Kacur <jkacur@redhat.com>, <stable-rt@vger.kernel.org>
Subject: [PATCH RT 15/16] genirq: do not invoke the affinity callback via a workqueue
References: <20130909124531.445392664@goodmis.org>
Content-Disposition: inline; filename=0015-genirq-do-not-invoke-the-affinity-callback-via-a-wor.patch
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
index 773dbc9..fb05761 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -269,6 +269,7 @@ struct irq_affinity_notify {
 	unsigned int irq;
 	struct kref kref;
 	struct work_struct work;
+	struct list_head list;
 	void (*notify)(struct irq_affinity_notify *, const cpumask_t *mask);
 	void (*release)(struct kref *ref);
 };
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index ff54ceb..a6bea19 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -141,6 +141,62 @@ static inline void
 irq_get_pending(struct cpumask *mask, struct irq_desc *desc) { }
 #endif
 
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
@@ -166,7 +222,17 @@ int __irq_set_affinity_locked(struct irq_data *data, const struct cpumask *mask)
 
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
 
@@ -207,10 +273,8 @@ int irq_set_affinity_hint(unsigned int irq, const struct cpumask *m)
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
@@ -232,6 +296,13 @@ out:
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
@@ -261,6 +332,8 @@ irq_set_affinity_notifier(unsigned int irq, struct irq_affinity_notify *notify)
 		notify->irq = irq;
 		kref_init(&notify->kref);
 		INIT_WORK(&notify->work, irq_affinity_notify);
+		INIT_LIST_HEAD(&notify->list);
+		init_helper_thread();
 	}
 
 	raw_spin_lock_irqsave(&desc->lock, flags);
-- 
1.7.10.4


