Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934552Ab3CMX67 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 19:58:59 -0400
Received: from mail-qc0-f177.google.com ([209.85.216.177]:40993 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934451Ab3CMX6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 19:58:35 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: laijs@cn.fujitsu.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 6/6] workqueue: inline trivial wrappers
Date: Wed, 13 Mar 2013 16:58:18 -0700
Message-Id: <1363219098-16083-7-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1363219098-16083-1-git-send-email-tj@kernel.org>
References: <1363219098-16083-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no reason to make these trivial wrappers full (exported)
functions.  Inline the followings.

 queue_work()
 queue_delayed_work()
 mod_delayed_work()
 schedule_work_on()
 schedule_work()
 schedule_delayed_work_on()
 schedule_delayed_work()
 keventd_up()

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/workqueue.h | 123 +++++++++++++++++++++++++++++++++++++++++-----
 kernel/workqueue.c        | 111 -----------------------------------------
 2 files changed, 111 insertions(+), 123 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index df30763..835d12b 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -417,28 +417,16 @@ int apply_workqueue_attrs(struct workqueue_struct *wq,
 
 extern bool queue_work_on(int cpu, struct workqueue_struct *wq,
 			struct work_struct *work);
-extern bool queue_work(struct workqueue_struct *wq, struct work_struct *work);
 extern bool queue_delayed_work_on(int cpu, struct workqueue_struct *wq,
 			struct delayed_work *work, unsigned long delay);
-extern bool queue_delayed_work(struct workqueue_struct *wq,
-			struct delayed_work *work, unsigned long delay);
 extern bool mod_delayed_work_on(int cpu, struct workqueue_struct *wq,
 			struct delayed_work *dwork, unsigned long delay);
-extern bool mod_delayed_work(struct workqueue_struct *wq,
-			struct delayed_work *dwork, unsigned long delay);
 
 extern void flush_workqueue(struct workqueue_struct *wq);
 extern void drain_workqueue(struct workqueue_struct *wq);
 extern void flush_scheduled_work(void);
 
-extern bool schedule_work_on(int cpu, struct work_struct *work);
-extern bool schedule_work(struct work_struct *work);
-extern bool schedule_delayed_work_on(int cpu, struct delayed_work *work,
-				     unsigned long delay);
-extern bool schedule_delayed_work(struct delayed_work *work,
-				  unsigned long delay);
 extern int schedule_on_each_cpu(work_func_t func);
-extern int keventd_up(void);
 
 int execute_in_process_context(work_func_t fn, struct execute_work *);
 
@@ -455,6 +443,117 @@ extern bool current_is_workqueue_rescuer(void);
 extern bool workqueue_congested(int cpu, struct workqueue_struct *wq);
 extern unsigned int work_busy(struct work_struct *work);
 
+/**
+ * queue_work - queue work on a workqueue
+ * @wq: workqueue to use
+ * @work: work to queue
+ *
+ * Returns %false if @work was already on a queue, %true otherwise.
+ *
+ * We queue the work to the CPU on which it was submitted, but if the CPU dies
+ * it can be processed by another CPU.
+ */
+static inline bool queue_work(struct workqueue_struct *wq,
+			      struct work_struct *work)
+{
+	return queue_work_on(WORK_CPU_UNBOUND, wq, work);
+}
+
+/**
+ * queue_delayed_work - queue work on a workqueue after delay
+ * @wq: workqueue to use
+ * @dwork: delayable work to queue
+ * @delay: number of jiffies to wait before queueing
+ *
+ * Equivalent to queue_delayed_work_on() but tries to use the local CPU.
+ */
+static inline bool queue_delayed_work(struct workqueue_struct *wq,
+				      struct delayed_work *dwork,
+				      unsigned long delay)
+{
+	return queue_delayed_work_on(WORK_CPU_UNBOUND, wq, dwork, delay);
+}
+
+/**
+ * mod_delayed_work - modify delay of or queue a delayed work
+ * @wq: workqueue to use
+ * @dwork: work to queue
+ * @delay: number of jiffies to wait before queueing
+ *
+ * mod_delayed_work_on() on local CPU.
+ */
+static inline bool mod_delayed_work(struct workqueue_struct *wq,
+				    struct delayed_work *dwork,
+				    unsigned long delay)
+{
+	return mod_delayed_work_on(WORK_CPU_UNBOUND, wq, dwork, delay);
+}
+
+/**
+ * schedule_work_on - put work task on a specific cpu
+ * @cpu: cpu to put the work task on
+ * @work: job to be done
+ *
+ * This puts a job on a specific cpu
+ */
+static inline bool schedule_work_on(int cpu, struct work_struct *work)
+{
+	return queue_work_on(cpu, system_wq, work);
+}
+
+/**
+ * schedule_work - put work task in global workqueue
+ * @work: job to be done
+ *
+ * Returns %false if @work was already on the kernel-global workqueue and
+ * %true otherwise.
+ *
+ * This puts a job in the kernel-global workqueue if it was not already
+ * queued and leaves it in the same position on the kernel-global
+ * workqueue otherwise.
+ */
+static inline bool schedule_work(struct work_struct *work)
+{
+	return queue_work(system_wq, work);
+}
+
+/**
+ * schedule_delayed_work_on - queue work in global workqueue on CPU after delay
+ * @cpu: cpu to use
+ * @dwork: job to be done
+ * @delay: number of jiffies to wait
+ *
+ * After waiting for a given time this puts a job in the kernel-global
+ * workqueue on the specified CPU.
+ */
+static inline bool schedule_delayed_work_on(int cpu, struct delayed_work *dwork,
+					    unsigned long delay)
+{
+	return queue_delayed_work_on(cpu, system_wq, dwork, delay);
+}
+
+/**
+ * schedule_delayed_work - put work task in global workqueue after delay
+ * @dwork: job to be done
+ * @delay: number of jiffies to wait or 0 for immediate execution
+ *
+ * After waiting for a given time this puts a job in the kernel-global
+ * workqueue.
+ */
+static inline bool schedule_delayed_work(struct delayed_work *dwork,
+					 unsigned long delay)
+{
+	return queue_delayed_work(system_wq, dwork, delay);
+}
+
+/**
+ * keventd_up - is workqueue initialized yet?
+ */
+static inline bool keventd_up(void)
+{
+	return system_wq != NULL;
+}
+
 /*
  * Like above, but uses del_timer() instead of del_timer_sync(). This means,
  * if it returns 0 the timer function may be running and the queueing is in
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 147fc5a..f37421f 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1340,22 +1340,6 @@ bool queue_work_on(int cpu, struct workqueue_struct *wq,
 }
 EXPORT_SYMBOL_GPL(queue_work_on);
 
-/**
- * queue_work - queue work on a workqueue
- * @wq: workqueue to use
- * @work: work to queue
- *
- * Returns %false if @work was already on a queue, %true otherwise.
- *
- * We queue the work to the CPU on which it was submitted, but if the CPU dies
- * it can be processed by another CPU.
- */
-bool queue_work(struct workqueue_struct *wq, struct work_struct *work)
-{
-	return queue_work_on(WORK_CPU_UNBOUND, wq, work);
-}
-EXPORT_SYMBOL_GPL(queue_work);
-
 void delayed_work_timer_fn(unsigned long __data)
 {
 	struct delayed_work *dwork = (struct delayed_work *)__data;
@@ -1431,21 +1415,6 @@ bool queue_delayed_work_on(int cpu, struct workqueue_struct *wq,
 EXPORT_SYMBOL_GPL(queue_delayed_work_on);
 
 /**
- * queue_delayed_work - queue work on a workqueue after delay
- * @wq: workqueue to use
- * @dwork: delayable work to queue
- * @delay: number of jiffies to wait before queueing
- *
- * Equivalent to queue_delayed_work_on() but tries to use the local CPU.
- */
-bool queue_delayed_work(struct workqueue_struct *wq,
-			struct delayed_work *dwork, unsigned long delay)
-{
-	return queue_delayed_work_on(WORK_CPU_UNBOUND, wq, dwork, delay);
-}
-EXPORT_SYMBOL_GPL(queue_delayed_work);
-
-/**
  * mod_delayed_work_on - modify delay of or queue a delayed work on specific CPU
  * @cpu: CPU number to execute work on
  * @wq: workqueue to use
@@ -1484,21 +1453,6 @@ bool mod_delayed_work_on(int cpu, struct workqueue_struct *wq,
 EXPORT_SYMBOL_GPL(mod_delayed_work_on);
 
 /**
- * mod_delayed_work - modify delay of or queue a delayed work
- * @wq: workqueue to use
- * @dwork: work to queue
- * @delay: number of jiffies to wait before queueing
- *
- * mod_delayed_work_on() on local CPU.
- */
-bool mod_delayed_work(struct workqueue_struct *wq, struct delayed_work *dwork,
-		      unsigned long delay)
-{
-	return mod_delayed_work_on(WORK_CPU_UNBOUND, wq, dwork, delay);
-}
-EXPORT_SYMBOL_GPL(mod_delayed_work);
-
-/**
  * worker_enter_idle - enter idle state
  * @worker: worker which is entering idle state
  *
@@ -3002,66 +2956,6 @@ bool cancel_delayed_work_sync(struct delayed_work *dwork)
 EXPORT_SYMBOL(cancel_delayed_work_sync);
 
 /**
- * schedule_work_on - put work task on a specific cpu
- * @cpu: cpu to put the work task on
- * @work: job to be done
- *
- * This puts a job on a specific cpu
- */
-bool schedule_work_on(int cpu, struct work_struct *work)
-{
-	return queue_work_on(cpu, system_wq, work);
-}
-EXPORT_SYMBOL(schedule_work_on);
-
-/**
- * schedule_work - put work task in global workqueue
- * @work: job to be done
- *
- * Returns %false if @work was already on the kernel-global workqueue and
- * %true otherwise.
- *
- * This puts a job in the kernel-global workqueue if it was not already
- * queued and leaves it in the same position on the kernel-global
- * workqueue otherwise.
- */
-bool schedule_work(struct work_struct *work)
-{
-	return queue_work(system_wq, work);
-}
-EXPORT_SYMBOL(schedule_work);
-
-/**
- * schedule_delayed_work_on - queue work in global workqueue on CPU after delay
- * @cpu: cpu to use
- * @dwork: job to be done
- * @delay: number of jiffies to wait
- *
- * After waiting for a given time this puts a job in the kernel-global
- * workqueue on the specified CPU.
- */
-bool schedule_delayed_work_on(int cpu, struct delayed_work *dwork,
-			      unsigned long delay)
-{
-	return queue_delayed_work_on(cpu, system_wq, dwork, delay);
-}
-EXPORT_SYMBOL(schedule_delayed_work_on);
-
-/**
- * schedule_delayed_work - put work task in global workqueue after delay
- * @dwork: job to be done
- * @delay: number of jiffies to wait or 0 for immediate execution
- *
- * After waiting for a given time this puts a job in the kernel-global
- * workqueue.
- */
-bool schedule_delayed_work(struct delayed_work *dwork, unsigned long delay)
-{
-	return queue_delayed_work(system_wq, dwork, delay);
-}
-EXPORT_SYMBOL(schedule_delayed_work);
-
-/**
  * schedule_on_each_cpu - execute a function synchronously on each online CPU
  * @func: the function to call
  *
@@ -3154,11 +3048,6 @@ int execute_in_process_context(work_func_t fn, struct execute_work *ew)
 }
 EXPORT_SYMBOL_GPL(execute_in_process_context);
 
-int keventd_up(void)
-{
-	return system_wq != NULL;
-}
-
 #ifdef CONFIG_SYSFS
 /*
  * Workqueues with WQ_SYSFS flag set is visible to userland via
-- 
1.8.1.4

