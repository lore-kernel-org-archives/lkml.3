Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932Ab3CRPYd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 11:24:33 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:46095 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752356Ab3CRPY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 11:24:28 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: pjt@google.com, paul.mckenney@linaro.org, tglx@linutronix.de,
        tj@kernel.org, suresh.b.siddha@intel.com, venki@google.com,
        mingo@redhat.com, peterz@infradead.org, rostedt@goodmis.org
Cc: linaro-kernel@lists.linaro.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, Arvind.Chauhan@arm.com,
        linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V3 3/7] workqueue: Add helpers to schedule work on any cpu
Date: Mon, 18 Mar 2013 20:53:25 +0530
Message-Id: <fb2e721fc43fbc3517a7ebb905aa573b12bb83a5.1363617402.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1363617402.git.viresh.kumar@linaro.org>
References: <cover.1363617402.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1363617402.git.viresh.kumar@linaro.org>
References: <cover.1363617402.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

queue_work() queues work on current cpu. This may wake up an idle CPU, which is
actually not required.

Some of these works can be processed by any CPU and so we must select a non-idle
CPU here. The initial idea was to modify implementation of queue_work(), but
that may end up breaking lots of kernel code that would be a nightmare to debug.

So, we finalized to adding new workqueue interfaces, for works that don't depend
on a cpu to execute them.

This patch adds following new routines:
- queue_work_on_any_cpu
- queue_delayed_work_on_any_cpu

These routines would look for the closest (via scheduling domains) non-idle cpu
(non-idle from schedulers perspective). If the current cpu is not idle or all
cpus are idle, work will be scheduled on local cpu.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 include/linux/workqueue.h |   5 ++
 kernel/workqueue.c        | 163 ++++++++++++++++++++++++++++++++--------------
 2 files changed, 118 insertions(+), 50 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index df30763..f0f7068 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -114,6 +114,7 @@ struct delayed_work {
 	/* target workqueue and CPU ->timer uses to queue ->work */
 	struct workqueue_struct *wq;
 	int cpu;
+	bool on_any_cpu;
 };
 
 /*
@@ -418,10 +419,14 @@ int apply_workqueue_attrs(struct workqueue_struct *wq,
 extern bool queue_work_on(int cpu, struct workqueue_struct *wq,
 			struct work_struct *work);
 extern bool queue_work(struct workqueue_struct *wq, struct work_struct *work);
+extern bool queue_work_on_any_cpu(struct workqueue_struct *wq,
+			struct work_struct *work);
 extern bool queue_delayed_work_on(int cpu, struct workqueue_struct *wq,
 			struct delayed_work *work, unsigned long delay);
 extern bool queue_delayed_work(struct workqueue_struct *wq,
 			struct delayed_work *work, unsigned long delay);
+extern bool queue_delayed_work_on_any_cpu(struct workqueue_struct *wq,
+			struct delayed_work *dwork, unsigned long delay);
 extern bool mod_delayed_work_on(int cpu, struct workqueue_struct *wq,
 			struct delayed_work *dwork, unsigned long delay);
 extern bool mod_delayed_work(struct workqueue_struct *wq,
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 0e4fa1d..cf9c570 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1215,7 +1215,7 @@ static bool is_chained_work(struct workqueue_struct *wq)
 }
 
 static void __queue_work(int cpu, struct workqueue_struct *wq,
-			 struct work_struct *work)
+			 struct work_struct *work, bool on_any_cpu)
 {
 	struct pool_workqueue *pwq;
 	struct worker_pool *last_pool;
@@ -1240,8 +1240,13 @@ static void __queue_work(int cpu, struct workqueue_struct *wq,
 retry:
 	/* pwq which will be used unless @work is executing elsewhere */
 	if (!(wq->flags & WQ_UNBOUND)) {
-		if (cpu == WORK_CPU_UNBOUND)
-			cpu = raw_smp_processor_id();
+		if (cpu == WORK_CPU_UNBOUND) {
+			if (on_any_cpu)
+				cpu = sched_select_cpu(0);
+			else
+				cpu = raw_smp_processor_id();
+		}
+
 		pwq = per_cpu_ptr(wq->cpu_pwqs, cpu);
 	} else {
 		pwq = first_pwq(wq);
@@ -1315,6 +1320,22 @@ retry:
 	spin_unlock(&pwq->pool->lock);
 }
 
+static bool __queue_work_on(int cpu, struct workqueue_struct *wq,
+		   struct work_struct *work, bool on_any_cpu)
+{
+	bool ret = false;
+	unsigned long flags;
+
+	local_irq_save(flags);
+
+	if (!test_and_set_bit(WORK_STRUCT_PENDING_BIT, work_data_bits(work))) {
+		__queue_work(cpu, wq, work, on_any_cpu);
+		ret = true;
+	}
+
+	local_irq_restore(flags);
+	return ret;
+}
 /**
  * queue_work_on - queue work on specific cpu
  * @cpu: CPU number to execute work on
@@ -1329,18 +1350,7 @@ retry:
 bool queue_work_on(int cpu, struct workqueue_struct *wq,
 		   struct work_struct *work)
 {
-	bool ret = false;
-	unsigned long flags;
-
-	local_irq_save(flags);
-
-	if (!test_and_set_bit(WORK_STRUCT_PENDING_BIT, work_data_bits(work))) {
-		__queue_work(cpu, wq, work);
-		ret = true;
-	}
-
-	local_irq_restore(flags);
-	return ret;
+	return __queue_work_on(cpu, wq, work, false);
 }
 EXPORT_SYMBOL_GPL(queue_work_on);
 
@@ -1356,21 +1366,38 @@ EXPORT_SYMBOL_GPL(queue_work_on);
  */
 bool queue_work(struct workqueue_struct *wq, struct work_struct *work)
 {
-	return queue_work_on(WORK_CPU_UNBOUND, wq, work);
+	return __queue_work_on(WORK_CPU_UNBOUND, wq, work, false);
 }
 EXPORT_SYMBOL_GPL(queue_work);
 
+/**
+ * queue_work_on_any_cpu - queue work on any cpu on a workqueue
+ * @wq: workqueue to use
+ * @work: work to queue
+ *
+ * Returns %false if @work was already on a queue, %true otherwise.
+ *
+ * We queue the work to any non-idle (from schedulers perspective) cpu.
+ */
+bool queue_work_on_any_cpu(struct workqueue_struct *wq,
+		struct work_struct *work)
+{
+	return __queue_work_on(WORK_CPU_UNBOUND, wq, work, true);
+}
+EXPORT_SYMBOL_GPL(queue_work_on_any_cpu);
+
 void delayed_work_timer_fn(unsigned long __data)
 {
 	struct delayed_work *dwork = (struct delayed_work *)__data;
 
 	/* should have been called from irqsafe timer with irq already off */
-	__queue_work(dwork->cpu, dwork->wq, &dwork->work);
+	__queue_work(dwork->cpu, dwork->wq, &dwork->work, dwork->on_any_cpu);
 }
 EXPORT_SYMBOL(delayed_work_timer_fn);
 
 static void __queue_delayed_work(int cpu, struct workqueue_struct *wq,
-				struct delayed_work *dwork, unsigned long delay)
+				struct delayed_work *dwork, unsigned long delay,
+				bool on_any_cpu)
 {
 	struct timer_list *timer = &dwork->timer;
 	struct work_struct *work = &dwork->work;
@@ -1387,7 +1414,7 @@ static void __queue_delayed_work(int cpu, struct workqueue_struct *wq,
 	 * on that there's no such delay when @delay is 0.
 	 */
 	if (!delay) {
-		__queue_work(cpu, wq, &dwork->work);
+		__queue_work(cpu, wq, &dwork->work, on_any_cpu);
 		return;
 	}
 
@@ -1395,6 +1422,7 @@ static void __queue_delayed_work(int cpu, struct workqueue_struct *wq,
 
 	dwork->wq = wq;
 	dwork->cpu = cpu;
+	dwork->on_any_cpu = on_any_cpu;
 	timer->expires = jiffies + delay;
 
 	if (unlikely(cpu != WORK_CPU_UNBOUND))
@@ -1403,19 +1431,9 @@ static void __queue_delayed_work(int cpu, struct workqueue_struct *wq,
 		add_timer(timer);
 }
 
-/**
- * queue_delayed_work_on - queue work on specific CPU after delay
- * @cpu: CPU number to execute work on
- * @wq: workqueue to use
- * @dwork: work to queue
- * @delay: number of jiffies to wait before queueing
- *
- * Returns %false if @work was already on a queue, %true otherwise.  If
- * @delay is zero and @dwork is idle, it will be scheduled for immediate
- * execution.
- */
-bool queue_delayed_work_on(int cpu, struct workqueue_struct *wq,
-			   struct delayed_work *dwork, unsigned long delay)
+static bool __queue_delayed_work_on(int cpu, struct workqueue_struct *wq,
+			   struct delayed_work *dwork, unsigned long delay,
+			   bool on_any_cpu)
 {
 	struct work_struct *work = &dwork->work;
 	bool ret = false;
@@ -1425,13 +1443,30 @@ bool queue_delayed_work_on(int cpu, struct workqueue_struct *wq,
 	local_irq_save(flags);
 
 	if (!test_and_set_bit(WORK_STRUCT_PENDING_BIT, work_data_bits(work))) {
-		__queue_delayed_work(cpu, wq, dwork, delay);
+		__queue_delayed_work(cpu, wq, dwork, delay, on_any_cpu);
 		ret = true;
 	}
 
 	local_irq_restore(flags);
 	return ret;
 }
+
+/**
+ * queue_delayed_work_on - queue work on specific CPU after delay
+ * @cpu: CPU number to execute work on
+ * @wq: workqueue to use
+ * @dwork: work to queue
+ * @delay: number of jiffies to wait before queueing
+ *
+ * Returns %false if @work was already on a queue, %true otherwise.  If
+ * @delay is zero and @dwork is idle, it will be scheduled for immediate
+ * execution.
+ */
+bool queue_delayed_work_on(int cpu, struct workqueue_struct *wq,
+			   struct delayed_work *dwork, unsigned long delay)
+{
+	return __queue_delayed_work_on(cpu, wq, dwork, delay, false);
+}
 EXPORT_SYMBOL_GPL(queue_delayed_work_on);
 
 /**
@@ -1445,11 +1480,50 @@ EXPORT_SYMBOL_GPL(queue_delayed_work_on);
 bool queue_delayed_work(struct workqueue_struct *wq,
 			struct delayed_work *dwork, unsigned long delay)
 {
-	return queue_delayed_work_on(WORK_CPU_UNBOUND, wq, dwork, delay);
+	return __queue_delayed_work_on(WORK_CPU_UNBOUND, wq, dwork, delay,
+			false);
 }
 EXPORT_SYMBOL_GPL(queue_delayed_work);
 
 /**
+ * queue_delayed_work_on_any_cpu - queue work on any non-idle cpu on a workqueue
+ * after delay
+ * @wq: workqueue to use
+ * @dwork: delayable work to queue
+ * @delay: number of jiffies to wait before queueing
+ *
+ * Equivalent to queue_delayed_work() but tries to use any non-idle (from
+ * schedulers perspective) CPU.
+ */
+bool queue_delayed_work_on_any_cpu(struct workqueue_struct *wq,
+			struct delayed_work *dwork, unsigned long delay)
+{
+	return __queue_delayed_work_on(WORK_CPU_UNBOUND, wq, dwork, delay,
+			true);
+}
+EXPORT_SYMBOL_GPL(queue_delayed_work_on_any_cpu);
+
+static bool __mod_delayed_work_on(int cpu, struct workqueue_struct *wq,
+			 struct delayed_work *dwork, unsigned long delay,
+			 bool on_any_cpu)
+{
+	unsigned long flags;
+	int ret;
+
+	do {
+		ret = try_to_grab_pending(&dwork->work, true, &flags);
+	} while (unlikely(ret == -EAGAIN));
+
+	if (likely(ret >= 0)) {
+		__queue_delayed_work(cpu, wq, dwork, delay, on_any_cpu);
+		local_irq_restore(flags);
+	}
+
+	/* -ENOENT from try_to_grab_pending() becomes %true */
+	return ret;
+}
+
+/**
  * mod_delayed_work_on - modify delay of or queue a delayed work on specific CPU
  * @cpu: CPU number to execute work on
  * @wq: workqueue to use
@@ -1470,20 +1544,7 @@ EXPORT_SYMBOL_GPL(queue_delayed_work);
 bool mod_delayed_work_on(int cpu, struct workqueue_struct *wq,
 			 struct delayed_work *dwork, unsigned long delay)
 {
-	unsigned long flags;
-	int ret;
-
-	do {
-		ret = try_to_grab_pending(&dwork->work, true, &flags);
-	} while (unlikely(ret == -EAGAIN));
-
-	if (likely(ret >= 0)) {
-		__queue_delayed_work(cpu, wq, dwork, delay);
-		local_irq_restore(flags);
-	}
-
-	/* -ENOENT from try_to_grab_pending() becomes %true */
-	return ret;
+	return __mod_delayed_work_on(cpu, wq, dwork, delay, false);
 }
 EXPORT_SYMBOL_GPL(mod_delayed_work_on);
 
@@ -1498,7 +1559,8 @@ EXPORT_SYMBOL_GPL(mod_delayed_work_on);
 bool mod_delayed_work(struct workqueue_struct *wq, struct delayed_work *dwork,
 		      unsigned long delay)
 {
-	return mod_delayed_work_on(WORK_CPU_UNBOUND, wq, dwork, delay);
+	return __mod_delayed_work_on(WORK_CPU_UNBOUND, wq, dwork, delay,
+			dwork->on_any_cpu);
 }
 EXPORT_SYMBOL_GPL(mod_delayed_work);
 
@@ -2952,7 +3014,8 @@ bool flush_delayed_work(struct delayed_work *dwork)
 {
 	local_irq_disable();
 	if (del_timer_sync(&dwork->timer))
-		__queue_work(dwork->cpu, dwork->wq, &dwork->work);
+		__queue_work(dwork->cpu, dwork->wq, &dwork->work,
+				dwork->on_any_cpu);
 	local_irq_enable();
 	return flush_work(&dwork->work);
 }
-- 
1.7.12.rc2.18.g61b472e

