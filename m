Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758085AbaEKXeQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 19:34:16 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:59995 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757367AbaEKXeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 19:34:07 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Kevin Hilman <khilman@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 2/5] irq_work: Force non-lazy works on IPI
Date: Mon, 12 May 2014 01:33:54 +0200
Message-Id: <1399851237-2226-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1399851237-2226-1-git-send-email-fweisbec@gmail.com>
References: <1399851237-2226-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As we plan to handle the full nohz IPI using irq work, we need to
enforce non-lazy works outside the tick because it's called under
hrtimer lock. This is not desired from the nohz callback revaluating the
tick because it can take hrtimer lock itself.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Kevin Hilman <khilman@linaro.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 include/linux/irq_work.h |  1 +
 kernel/irq_work.c        | 58 ++++++++++++++++++++++++++----------------------
 kernel/timer.c           |  2 +-
 3 files changed, 34 insertions(+), 27 deletions(-)

diff --git a/include/linux/irq_work.h b/include/linux/irq_work.h
index 19ae05d..429b1ba 100644
--- a/include/linux/irq_work.h
+++ b/include/linux/irq_work.h
@@ -34,6 +34,7 @@ void init_irq_work(struct irq_work *work, void (*func)(struct irq_work *))
 
 bool irq_work_queue(struct irq_work *work);
 void irq_work_run(void);
+void irq_work_run_tick(void);
 void irq_work_sync(struct irq_work *work);
 
 #ifdef CONFIG_IRQ_WORK
diff --git a/kernel/irq_work.c b/kernel/irq_work.c
index 2559383..0a554a6 100644
--- a/kernel/irq_work.c
+++ b/kernel/irq_work.c
@@ -19,8 +19,8 @@
 #include <asm/processor.h>
 
 
-static DEFINE_PER_CPU(struct llist_head, irq_work_list);
-static DEFINE_PER_CPU(int, irq_work_raised);
+static DEFINE_PER_CPU(struct llist_head, lazy_list);
+static DEFINE_PER_CPU(struct llist_head, raised_list);
 
 /*
  * Claim the entry so that no one else will poke at it.
@@ -63,14 +63,14 @@ void __weak arch_irq_work_raise(int cpu)
  */
 bool irq_work_queue(struct irq_work *work)
 {
+	unsigned long flags;
+
 	/* Only queue if not already pending */
 	if (!irq_work_claim(work))
 		return false;
 
 	/* Queue the entry and raise the IPI if needed. */
-	preempt_disable();
-
-	llist_add(&work->llnode, &__get_cpu_var(irq_work_list));
+	local_irq_save(flags);
 
 	/*
 	 * If the work is not "lazy" or the tick is stopped, raise the irq
@@ -78,11 +78,13 @@ bool irq_work_queue(struct irq_work *work)
 	 * for the next tick.
 	 */
 	if (!(work->flags & IRQ_WORK_LAZY) || tick_nohz_tick_stopped()) {
-		if (!this_cpu_cmpxchg(irq_work_raised, 0, 1))
+		if (llist_add(&work->llnode, &__get_cpu_var(raised_list)))
 			arch_irq_work_raise(smp_processor_id());
+	} else {
+		llist_add(&work->llnode, &__get_cpu_var(lazy_list));
 	}
 
-	preempt_enable();
+	local_irq_restore(flags);
 
 	return true;
 }
@@ -90,10 +92,7 @@ EXPORT_SYMBOL_GPL(irq_work_queue);
 
 bool irq_work_needs_cpu(void)
 {
-	struct llist_head *this_list;
-
-	this_list = &__get_cpu_var(irq_work_list);
-	if (llist_empty(this_list))
+	if (llist_empty(&__get_cpu_var(lazy_list)))
 		return false;
 
 	/* All work should have been flushed before going offline */
@@ -102,28 +101,18 @@ bool irq_work_needs_cpu(void)
 	return true;
 }
 
-static void __irq_work_run(void)
+static void __irq_work_run(struct llist_head *list)
 {
 	unsigned long flags;
 	struct irq_work *work;
-	struct llist_head *this_list;
 	struct llist_node *llnode;
 
-
-	/*
-	 * Reset the "raised" state right before we check the list because
-	 * an NMI may enqueue after we find the list empty from the runner.
-	 */
-	__this_cpu_write(irq_work_raised, 0);
-	barrier();
-
-	this_list = &__get_cpu_var(irq_work_list);
-	if (llist_empty(this_list))
+	if (llist_empty(list))
 		return;
 
 	BUG_ON(!irqs_disabled());
 
-	llnode = llist_del_all(this_list);
+	llnode = llist_del_all(list);
 	while (llnode != NULL) {
 		work = llist_entry(llnode, struct irq_work, llnode);
 
@@ -155,11 +144,27 @@ static void __irq_work_run(void)
 void irq_work_run(void)
 {
 	BUG_ON(!in_irq());
-	__irq_work_run();
+	__irq_work_run(&__get_cpu_var(raised_list));
+	__irq_work_run(&__get_cpu_var(lazy_list));
 }
 EXPORT_SYMBOL_GPL(irq_work_run);
 
 /*
+ * Run the lazy irq_work entries on this cpu from the tick. But let
+ * the IPI handle the others. Some works may require to work outside
+ * the tick due to its locking dependencies (hrtimer lock).
+ */
+void irq_work_run_tick(void)
+{
+	BUG_ON(!in_irq());
+#ifndef CONFIG_HAVE_IRQ_WORK_IPI
+	/* No IPI support, we don't have the choice... */
+	__irq_work_run(&__get_cpu_var(raised_list));
+#endif
+	__irq_work_run(&__get_cpu_var(lazy_list));
+}
+
+/*
  * Synchronize against the irq_work @entry, ensures the entry is not
  * currently in use.
  */
@@ -183,7 +188,8 @@ static int irq_work_cpu_notify(struct notifier_block *self,
 		/* Called from stop_machine */
 		if (WARN_ON_ONCE(cpu != smp_processor_id()))
 			break;
-		__irq_work_run();
+		__irq_work_run(&__get_cpu_var(raised_list));
+		__irq_work_run(&__get_cpu_var(lazy_list));
 		break;
 	default:
 		break;
diff --git a/kernel/timer.c b/kernel/timer.c
index 3bb01a3..0251dfa 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1384,7 +1384,7 @@ void update_process_times(int user_tick)
 	rcu_check_callbacks(cpu, user_tick);
 #ifdef CONFIG_IRQ_WORK
 	if (in_irq())
-		irq_work_run();
+		irq_work_run_tick();
 #endif
 	scheduler_tick();
 	run_posix_cpu_timers(p);
-- 
1.8.3.1

