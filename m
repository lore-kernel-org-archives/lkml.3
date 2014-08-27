Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935852AbaH0UQd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 16:16:33 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:34101 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935764AbaH0UPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 16:15:45 -0400
From: Lina Iyer <lina.iyer@linaro.org>
To: khilman@linaro.org, ulf.hansson@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, rjw@rjwysocki.net
Cc: daniel.lezcano@linaro.org, Lina Iyer <lina.iyer@linaro.org>
Subject: [PATCH v3 3/4] irq: Allow multiple clients to register for irq affinity notification
Date: Wed, 27 Aug 2014 14:14:38 -0600
Message-Id: <1409170479-29955-4-git-send-email-lina.iyer@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1409170479-29955-1-git-send-email-lina.iyer@linaro.org>
References: <1409170479-29955-1-git-send-email-lina.iyer@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PM QoS and other idle frameworks can do a better job of addressing power
and performance requirements for a cpu, knowing the IRQs that are
affine to that cpu. If a performance request is placed against serving
the IRQ faster and if the IRQ is affine to a set of cpus, then setting
the performance requirements only on those cpus help save power on the
rest of the cpus. PM QoS framework is one such framework interested in
knowing the smp_affinity of an IRQ and the change notificiation in this
regard. QoS requests for the CPU_DMA_LATENCY constraint currently apply
to all cpus, but when attached to an IRQ, can be applied only to the set
of cpus that IRQ's smp_affinity is set to. This allows other cpus to
enter deeper sleep states to save power. More than one framework/driver
can be interested in such information.

The current implementation allows only a single notification callback
whenever the IRQ's SMP affinity is changed. Adding a second notification
punts the existing notifier function out of registration.  Add a list of
notifiers, allowing multiple clients to register for irq affinity
notifications.

The kref object associated with the struct irq_affinity_notify was used
to prevent the notifier object from being released if there is a pending
notification. It was incremented before the work item was scheduled and
was decremented when the notification was completed. If the kref count
was zero at the end of it, the release function gets a callback allowing
the module to release the irq_affinity_notify memory. This works well
for a single notification. When multiple clients are registered, no
single kref object can be used. Hence, the work function when scheduled,
will increase the kref count using the kref_get_unless_zero(), so if the
module had already unregistered the irq_affinity_notify object while the
work function was scheduled, it will not be notified.

Signed-off-by: Lina Iyer <lina.iyer@linaro.org>

diff --git a/drivers/infiniband/hw/qib/qib_iba7322.c b/drivers/infiniband/hw/qib/qib_iba7322.c
index a7eb325..62cb77d 100644
--- a/drivers/infiniband/hw/qib/qib_iba7322.c
+++ b/drivers/infiniband/hw/qib/qib_iba7322.c
@@ -3345,9 +3345,7 @@ static void reset_dca_notifier(struct qib_devdata *dd, struct qib_msix_entry *m)
 		"Disabling notifier on HCA %d irq %d\n",
 		dd->unit,
 		m->msix.vector);
-	irq_set_affinity_notifier(
-		m->msix.vector,
-		NULL);
+	irq_release_affinity_notifier(m->notifier);
 	m->notifier = NULL;
 }
 
diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 698ad05..c1e227c 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -203,7 +203,7 @@ static inline int check_wakeup_irqs(void) { return 0; }
  * struct irq_affinity_notify - context for notification of IRQ affinity changes
  * @irq:		Interrupt to which notification applies
  * @kref:		Reference count, for internal use
- * @work:		Work item, for internal use
+ * @list:		Add to the notifier list, for internal use
  * @notify:		Function to be called on change.  This will be
  *			called in process context.
  * @release:		Function to be called on release.  This will be
@@ -214,7 +214,7 @@ static inline int check_wakeup_irqs(void) { return 0; }
 struct irq_affinity_notify {
 	unsigned int irq;
 	struct kref kref;
-	struct work_struct work;
+	struct list_head list;
 	void (*notify)(struct irq_affinity_notify *, const cpumask_t *mask);
 	void (*release)(struct kref *ref);
 };
@@ -265,6 +265,8 @@ extern int irq_set_affinity_hint(unsigned int irq, const struct cpumask *m);
 extern int
 irq_set_affinity_notifier(unsigned int irq, struct irq_affinity_notify *notify);
 
+extern int
+irq_release_affinity_notifier(struct irq_affinity_notify *notify);
 #else /* CONFIG_SMP */
 
 static inline int irq_set_affinity(unsigned int irq, const struct cpumask *m)
@@ -295,6 +297,12 @@ irq_set_affinity_notifier(unsigned int irq, struct irq_affinity_notify *notify)
 {
 	return 0;
 }
+
+static inline int
+irq_release_affinity_notifier(struct irq_affinity_notify *notify)
+{
+	return 0;
+}
 #endif /* CONFIG_SMP */
 
 /*
diff --git a/include/linux/irqdesc.h b/include/linux/irqdesc.h
index 472c021..db3509e 100644
--- a/include/linux/irqdesc.h
+++ b/include/linux/irqdesc.h
@@ -31,7 +31,8 @@ struct irq_desc;
  * @threads_handled_last: comparator field for deferred spurious detection of theraded handlers
  * @lock:		locking for SMP
  * @affinity_hint:	hint to user space for preferred irq affinity
- * @affinity_notify:	context for notification of affinity changes
+ * @affinity_notify:	list of notification clients for affinity changes
+ * @affinity_work:	Work queue for handling affinity change notifications
  * @pending_mask:	pending rebalanced interrupts
  * @threads_oneshot:	bitfield to handle shared oneshot threads
  * @threads_active:	number of irqaction threads currently running
@@ -60,7 +61,8 @@ struct irq_desc {
 	struct cpumask		*percpu_enabled;
 #ifdef CONFIG_SMP
 	const struct cpumask	*affinity_hint;
-	struct irq_affinity_notify *affinity_notify;
+	struct list_head	affinity_notify;
+	struct work_struct	affinity_work;
 #ifdef CONFIG_GENERIC_PENDING_IRQ
 	cpumask_var_t		pending_mask;
 #endif
diff --git a/kernel/irq/irqdesc.c b/kernel/irq/irqdesc.c
index 1487a12..c95e1f3 100644
--- a/kernel/irq/irqdesc.c
+++ b/kernel/irq/irqdesc.c
@@ -91,6 +91,7 @@ static void desc_set_defaults(unsigned int irq, struct irq_desc *desc, int node,
 	for_each_possible_cpu(cpu)
 		*per_cpu_ptr(desc->kstat_irqs, cpu) = 0;
 	desc_smp_init(desc, node);
+	INIT_LIST_HEAD(&desc->affinity_notify);
 }
 
 int nr_irqs = NR_IRQS;
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 3dc6a61..b6ff79c 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -209,10 +209,9 @@ int irq_set_affinity_locked(struct irq_data *data, const struct cpumask *mask,
 		irq_copy_pending(desc, mask);
 	}
 
-	if (desc->affinity_notify) {
-		kref_get(&desc->affinity_notify->kref);
-		schedule_work(&desc->affinity_notify->work);
-	}
+	if (!list_empty(&desc->affinity_notify))
+		schedule_work(&desc->affinity_work);
+
 	irqd_set(data, IRQD_AFFINITY_SET);
 
 	return ret;
@@ -248,14 +247,14 @@ EXPORT_SYMBOL_GPL(irq_set_affinity_hint);
 
 static void irq_affinity_notify(struct work_struct *work)
 {
-	struct irq_affinity_notify *notify =
-		container_of(work, struct irq_affinity_notify, work);
-	struct irq_desc *desc = irq_to_desc(notify->irq);
+	struct irq_desc *desc =
+			container_of(work, struct irq_desc, affinity_work);
 	cpumask_var_t cpumask;
 	unsigned long flags;
+	struct irq_affinity_notify *notify;
 
 	if (!desc || !alloc_cpumask_var(&cpumask, GFP_KERNEL))
-		goto out;
+		return;
 
 	raw_spin_lock_irqsave(&desc->lock, flags);
 	if (irq_move_pending(&desc->irq_data))
@@ -264,11 +263,20 @@ static void irq_affinity_notify(struct work_struct *work)
 		cpumask_copy(cpumask, desc->irq_data.affinity);
 	raw_spin_unlock_irqrestore(&desc->lock, flags);
 
-	notify->notify(notify, cpumask);
+	list_for_each_entry(notify, &desc->affinity_notify, list) {
+		/**
+		 * Check and get the kref only if the kref has not been
+		 * released by now. Its possible that the reference count
+		 * is already 0, we dont want to notify those if they are
+		 * already released.
+		 */
+		if (!kref_get_unless_zero(&notify->kref))
+			continue;
+		notify->notify(notify, cpumask);
+		kref_put(&notify->kref, notify->release);
+	}
 
 	free_cpumask_var(cpumask);
-out:
-	kref_put(&notify->kref, notify->release);
 }
 
 /**
@@ -286,34 +294,50 @@ int
 irq_set_affinity_notifier(unsigned int irq, struct irq_affinity_notify *notify)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
-	struct irq_affinity_notify *old_notify;
 	unsigned long flags;
 
-	/* The release function is promised process context */
-	might_sleep();
-
 	if (!desc)
 		return -EINVAL;
 
-	/* Complete initialisation of *notify */
-	if (notify) {
-		notify->irq = irq;
-		kref_init(&notify->kref);
-		INIT_WORK(&notify->work, irq_affinity_notify);
+	if (!notify) {
+		WARN("%s called with NULL notifier - use irq_release_affinity_notifier function instead.\n",
+				__func__);
+		return -EINVAL;
 	}
 
+	notify->irq = irq;
+	kref_init(&notify->kref);
+	INIT_LIST_HEAD(&notify->list);
 	raw_spin_lock_irqsave(&desc->lock, flags);
-	old_notify = desc->affinity_notify;
-	desc->affinity_notify = notify;
+	list_add(&notify->list, &desc->affinity_notify);
 	raw_spin_unlock_irqrestore(&desc->lock, flags);
 
-	if (old_notify)
-		kref_put(&old_notify->kref, old_notify->release);
-
 	return 0;
 }
 EXPORT_SYMBOL_GPL(irq_set_affinity_notifier);
 
+/**
+ *	irq_release_affinity_notifier - Remove us from notifications
+ *	@notify: Context for notification
+ */
+int irq_release_affinity_notifier(struct irq_affinity_notify *notify)
+{
+	struct irq_desc *desc;
+	unsigned long flags;
+
+	if (!notify)
+		return -EINVAL;
+
+	desc = irq_to_desc(notify->irq);
+	raw_spin_lock_irqsave(&desc->lock, flags);
+	list_del(&notify->list);
+	raw_spin_unlock_irqrestore(&desc->lock, flags);
+	kref_put(&notify->kref, notify->release);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(irq_release_affinity_notifier);
+
 #ifndef CONFIG_AUTO_IRQ_AFFINITY
 /*
  * Generic version of the affinity autoselector.
@@ -348,6 +372,8 @@ setup_affinity(unsigned int irq, struct irq_desc *desc, struct cpumask *mask)
 		if (cpumask_intersects(mask, nodemask))
 			cpumask_and(mask, mask, nodemask);
 	}
+	INIT_LIST_HEAD(&desc->affinity_notify);
+	INIT_WORK(&desc->affinity_work, irq_affinity_notify);
 	irq_do_set_affinity(&desc->irq_data, mask, false);
 	return 0;
 }
@@ -1413,14 +1439,15 @@ EXPORT_SYMBOL_GPL(remove_irq);
 void free_irq(unsigned int irq, void *dev_id)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
+	struct irq_affinity_notify *notify;
 
 	if (!desc || WARN_ON(irq_settings_is_per_cpu_devid(desc)))
 		return;
 
-#ifdef CONFIG_SMP
-	if (WARN_ON(desc->affinity_notify))
-		desc->affinity_notify = NULL;
-#endif
+	WARN_ON(!list_empty(&desc->affinity_notify));
+
+	list_for_each_entry(notify, &desc->affinity_notify, list)
+		kref_put(&notify->kref, notify->release);
 
 	chip_bus_lock(desc);
 	kfree(__free_irq(irq, dev_id));
diff --git a/lib/cpu_rmap.c b/lib/cpu_rmap.c
index 4f134d8..0c8da50 100644
--- a/lib/cpu_rmap.c
+++ b/lib/cpu_rmap.c
@@ -235,7 +235,7 @@ void free_irq_cpu_rmap(struct cpu_rmap *rmap)
 
 	for (index = 0; index < rmap->used; index++) {
 		glue = rmap->obj[index];
-		irq_set_affinity_notifier(glue->notify.irq, NULL);
+		irq_release_affinity_notifier(&glue->notify);
 	}
 
 	cpu_rmap_put(rmap);
-- 
1.9.1

