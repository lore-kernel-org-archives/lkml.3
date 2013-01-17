Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758498Ab3AQBn2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 20:43:28 -0500
Received: from mail-ie0-f179.google.com ([209.85.223.179]:61974 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758477Ab3AQBnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 20:43:25 -0500
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Tejun Heo <tj@kernel.org>
Subject: [PATCH 17/17] workqueue: post global_cwq removal cleanups
Date: Wed, 16 Jan 2013 17:42:49 -0800
Message-Id: <1358386969-945-18-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <1358386969-945-1-git-send-email-tj@kernel.org>
References: <1358386969-945-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove remaining references to gcwq.

* __next_gcwq_cpu() steals __next_wq_cpu() name.  The original
  __next_wq_cpu() became __next_cwq_cpu().

* s/for_each_gcwq_cpu/for_each_wq_cpu/
  s/for_each_online_gcwq_cpu/for_each_online_wq_cpu/

* s/gcwq_mayday_timeout/pool_mayday_timeout/

* s/gcwq_unbind_fn/wq_unbind_fn/

* Drop references to gcwq in comments.

This patch doesn't introduce any functional changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c | 104 ++++++++++++++++++++++++++---------------------------
 1 file changed, 52 insertions(+), 52 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 52ca95b..7507609 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -272,8 +272,8 @@ EXPORT_SYMBOL_GPL(system_freezable_wq);
 #define for_each_busy_worker(worker, i, pos, pool)			\
 	hash_for_each(pool->busy_hash, i, pos, worker, hentry)
 
-static inline int __next_gcwq_cpu(int cpu, const struct cpumask *mask,
-				  unsigned int sw)
+static inline int __next_wq_cpu(int cpu, const struct cpumask *mask,
+				unsigned int sw)
 {
 	if (cpu < nr_cpu_ids) {
 		if (sw & 1) {
@@ -287,39 +287,39 @@ static inline int __next_gcwq_cpu(int cpu, const struct cpumask *mask,
 	return WORK_CPU_NONE;
 }
 
-static inline int __next_wq_cpu(int cpu, const struct cpumask *mask,
-				struct workqueue_struct *wq)
+static inline int __next_cwq_cpu(int cpu, const struct cpumask *mask,
+				 struct workqueue_struct *wq)
 {
-	return __next_gcwq_cpu(cpu, mask, !(wq->flags & WQ_UNBOUND) ? 1 : 2);
+	return __next_wq_cpu(cpu, mask, !(wq->flags & WQ_UNBOUND) ? 1 : 2);
 }
 
 /*
  * CPU iterators
  *
- * An extra gcwq is defined for an invalid cpu number
+ * An extra cpu number is defined using an invalid cpu number
  * (WORK_CPU_UNBOUND) to host workqueues which are not bound to any
- * specific CPU.  The following iterators are similar to
- * for_each_*_cpu() iterators but also considers the unbound gcwq.
+ * specific CPU.  The following iterators are similar to for_each_*_cpu()
+ * iterators but also considers the unbound CPU.
  *
- * for_each_gcwq_cpu()		: possible CPUs + WORK_CPU_UNBOUND
- * for_each_online_gcwq_cpu()	: online CPUs + WORK_CPU_UNBOUND
+ * for_each_wq_cpu()		: possible CPUs + WORK_CPU_UNBOUND
+ * for_each_online_wq_cpu()	: online CPUs + WORK_CPU_UNBOUND
  * for_each_cwq_cpu()		: possible CPUs for bound workqueues,
  *				  WORK_CPU_UNBOUND for unbound workqueues
  */
-#define for_each_gcwq_cpu(cpu)						\
-	for ((cpu) = __next_gcwq_cpu(-1, cpu_possible_mask, 3);		\
+#define for_each_wq_cpu(cpu)						\
+	for ((cpu) = __next_wq_cpu(-1, cpu_possible_mask, 3);		\
 	     (cpu) < WORK_CPU_NONE;					\
-	     (cpu) = __next_gcwq_cpu((cpu), cpu_possible_mask, 3))
+	     (cpu) = __next_wq_cpu((cpu), cpu_possible_mask, 3))
 
-#define for_each_online_gcwq_cpu(cpu)					\
-	for ((cpu) = __next_gcwq_cpu(-1, cpu_online_mask, 3);		\
+#define for_each_online_wq_cpu(cpu)					\
+	for ((cpu) = __next_wq_cpu(-1, cpu_online_mask, 3);		\
 	     (cpu) < WORK_CPU_NONE;					\
-	     (cpu) = __next_gcwq_cpu((cpu), cpu_online_mask, 3))
+	     (cpu) = __next_wq_cpu((cpu), cpu_online_mask, 3))
 
 #define for_each_cwq_cpu(cpu, wq)					\
-	for ((cpu) = __next_wq_cpu(-1, cpu_possible_mask, (wq));	\
+	for ((cpu) = __next_cwq_cpu(-1, cpu_possible_mask, (wq));	\
 	     (cpu) < WORK_CPU_NONE;					\
-	     (cpu) = __next_wq_cpu((cpu), cpu_possible_mask, (wq)))
+	     (cpu) = __next_cwq_cpu((cpu), cpu_possible_mask, (wq)))
 
 #ifdef CONFIG_DEBUG_OBJECTS_WORK
 
@@ -681,7 +681,7 @@ static bool __need_more_worker(struct worker_pool *pool)
  * running workers.
  *
  * Note that, because unbound workers never contribute to nr_running, this
- * function will always return %true for unbound gcwq as long as the
+ * function will always return %true for unbound pools as long as the
  * worklist isn't empty.
  */
 static bool need_more_worker(struct worker_pool *pool)
@@ -1147,14 +1147,14 @@ fail:
 }
 
 /**
- * insert_work - insert a work into gcwq
+ * insert_work - insert a work into a pool
  * @cwq: cwq @work belongs to
  * @work: work to insert
  * @head: insertion point
  * @extra_flags: extra WORK_STRUCT_* flags to set
  *
- * Insert @work which belongs to @cwq into @gcwq after @head.
- * @extra_flags is or'd to work_struct flags.
+ * Insert @work which belongs to @cwq after @head.  @extra_flags is or'd to
+ * work_struct flags.
  *
  * CONTEXT:
  * spin_lock_irq(pool->lock).
@@ -1197,7 +1197,7 @@ static bool is_chained_work(struct workqueue_struct *wq)
 	unsigned long flags;
 	unsigned int cpu;
 
-	for_each_gcwq_cpu(cpu) {
+	for_each_wq_cpu(cpu) {
 		struct cpu_workqueue_struct *cwq = get_cwq(cpu, wq);
 		struct worker_pool *pool = cwq->pool;
 		struct worker *worker;
@@ -1551,7 +1551,7 @@ static void worker_enter_idle(struct worker *worker)
 		mod_timer(&pool->idle_timer, jiffies + IDLE_WORKER_TIMEOUT);
 
 	/*
-	 * Sanity check nr_running.  Because gcwq_unbind_fn() releases
+	 * Sanity check nr_running.  Because wq_unbind_fn() releases
 	 * pool->lock between setting %WORKER_UNBOUND and zapping
 	 * nr_running, the warning may trigger spuriously.  Check iff
 	 * unbind is not in progress.
@@ -1581,7 +1581,7 @@ static void worker_leave_idle(struct worker *worker)
 }
 
 /**
- * worker_maybe_bind_and_lock - bind worker to its cpu if possible and lock gcwq
+ * worker_maybe_bind_and_lock - bind worker to its cpu if possible and lock pool
  * @worker: self
  *
  * Works which are scheduled while the cpu is online must at least be
@@ -1593,10 +1593,10 @@ static void worker_leave_idle(struct worker *worker)
  * themselves to the target cpu and may race with cpu going down or
  * coming online.  kthread_bind() can't be used because it may put the
  * worker to already dead cpu and set_cpus_allowed_ptr() can't be used
- * verbatim as it's best effort and blocking and gcwq may be
+ * verbatim as it's best effort and blocking and pool may be
  * [dis]associated in the meantime.
  *
- * This function tries set_cpus_allowed() and locks gcwq and verifies the
+ * This function tries set_cpus_allowed() and locks pool and verifies the
  * binding against %POOL_DISASSOCIATED which is set during
  * %CPU_DOWN_PREPARE and cleared during %CPU_ONLINE, so if the worker
  * enters idle state or fetches works without dropping lock, it can
@@ -1607,7 +1607,7 @@ static void worker_leave_idle(struct worker *worker)
  * held.
  *
  * RETURNS:
- * %true if the associated gcwq is online (@worker is successfully
+ * %true if the associated pool is online (@worker is successfully
  * bound), %false if offline.
  */
 static bool worker_maybe_bind_and_lock(struct worker *worker)
@@ -1844,7 +1844,7 @@ fail:
  * start_worker - start a newly created worker
  * @worker: worker to start
  *
- * Make the gcwq aware of @worker and start it.
+ * Make the pool aware of @worker and start it.
  *
  * CONTEXT:
  * spin_lock_irq(pool->lock).
@@ -1861,7 +1861,7 @@ static void start_worker(struct worker *worker)
  * destroy_worker - destroy a workqueue worker
  * @worker: worker to be destroyed
  *
- * Destroy @worker and adjust @gcwq stats accordingly.
+ * Destroy @worker and adjust @pool stats accordingly.
  *
  * CONTEXT:
  * spin_lock_irq(pool->lock) which is released and regrabbed.
@@ -1937,7 +1937,7 @@ static bool send_mayday(struct work_struct *work)
 	return true;
 }
 
-static void gcwq_mayday_timeout(unsigned long __pool)
+static void pool_mayday_timeout(unsigned long __pool)
 {
 	struct worker_pool *pool = (void *)__pool;
 	struct work_struct *work;
@@ -2065,9 +2065,9 @@ static bool maybe_destroy_workers(struct worker_pool *pool)
  * manage_workers - manage worker pool
  * @worker: self
  *
- * Assume the manager role and manage gcwq worker pool @worker belongs
+ * Assume the manager role and manage the worker pool @worker belongs
  * to.  At any given time, there can be only zero or one manager per
- * gcwq.  The exclusion is handled automatically by this function.
+ * pool.  The exclusion is handled automatically by this function.
  *
  * The caller can safely start processing works on false return.  On
  * true return, it's guaranteed that need_to_create_worker() is false
@@ -2110,11 +2110,11 @@ static bool manage_workers(struct worker *worker)
 		 * CPU hotplug could have happened while we were waiting
 		 * for assoc_mutex.  Hotplug itself can't handle us
 		 * because manager isn't either on idle or busy list, and
-		 * @gcwq's state and ours could have deviated.
+		 * @pool's state and ours could have deviated.
 		 *
 		 * As hotplug is now excluded via assoc_mutex, we can
 		 * simply try to bind.  It will succeed or fail depending
-		 * on @gcwq's current state.  Try it and adjust
+		 * on @pool's current state.  Try it and adjust
 		 * %WORKER_UNBOUND accordingly.
 		 */
 		if (worker_maybe_bind_and_lock(worker))
@@ -2289,8 +2289,8 @@ static void process_scheduled_works(struct worker *worker)
  * worker_thread - the worker thread function
  * @__worker: self
  *
- * The gcwq worker thread function.  There's a single dynamic pool of
- * these per each cpu.  These workers process all works regardless of
+ * The worker thread function.  There are NR_CPU_WORKER_POOLS dynamic pools
+ * of these per each cpu.  These workers process all works regardless of
  * their specific target workqueue.  The only exception is works which
  * belong to workqueues with a rescuer which will be explained in
  * rescuer_thread().
@@ -2386,14 +2386,14 @@ sleep:
  * Workqueue rescuer thread function.  There's one rescuer for each
  * workqueue which has WQ_RESCUER set.
  *
- * Regular work processing on a gcwq may block trying to create a new
+ * Regular work processing on a pool may block trying to create a new
  * worker which uses GFP_KERNEL allocation which has slight chance of
  * developing into deadlock if some works currently on the same queue
  * need to be processed to satisfy the GFP_KERNEL allocation.  This is
  * the problem rescuer solves.
  *
- * When such condition is possible, the gcwq summons rescuers of all
- * workqueues which have works queued on the gcwq and let them process
+ * When such condition is possible, the pool summons rescuers of all
+ * workqueues which have works queued on the pool and let them process
  * those works so that forward progress can be guaranteed.
  *
  * This should happen rarely.
@@ -3484,7 +3484,7 @@ EXPORT_SYMBOL_GPL(work_busy);
  *
  * There are two challenges in supporting CPU hotplug.  Firstly, there
  * are a lot of assumptions on strong associations among work, cwq and
- * gcwq which make migrating pending and scheduled works very
+ * pool which make migrating pending and scheduled works very
  * difficult to implement without impacting hot paths.  Secondly,
  * worker pools serve mix of short, long and very long running works making
  * blocked draining impractical.
@@ -3494,7 +3494,7 @@ EXPORT_SYMBOL_GPL(work_busy);
  * cpu comes back online.
  */
 
-static void gcwq_unbind_fn(struct work_struct *work)
+static void wq_unbind_fn(struct work_struct *work)
 {
 	int cpu = smp_processor_id();
 	struct worker_pool *pool;
@@ -3609,7 +3609,7 @@ static int __cpuinit workqueue_cpu_down_callback(struct notifier_block *nfb,
 	switch (action & ~CPU_TASKS_FROZEN) {
 	case CPU_DOWN_PREPARE:
 		/* unbinding should happen on the local CPU */
-		INIT_WORK_ONSTACK(&unbind_work, gcwq_unbind_fn);
+		INIT_WORK_ONSTACK(&unbind_work, wq_unbind_fn);
 		queue_work_on(cpu, system_highpri_wq, &unbind_work);
 		flush_work(&unbind_work);
 		break;
@@ -3662,7 +3662,7 @@ EXPORT_SYMBOL_GPL(work_on_cpu);
  *
  * Start freezing workqueues.  After this function returns, all freezable
  * workqueues will queue new works to their frozen_works list instead of
- * gcwq->worklist.
+ * pool->worklist.
  *
  * CONTEXT:
  * Grabs and releases workqueue_lock and pool->lock's.
@@ -3676,7 +3676,7 @@ void freeze_workqueues_begin(void)
 	BUG_ON(workqueue_freezing);
 	workqueue_freezing = true;
 
-	for_each_gcwq_cpu(cpu) {
+	for_each_wq_cpu(cpu) {
 		struct worker_pool *pool;
 		struct workqueue_struct *wq;
 
@@ -3723,7 +3723,7 @@ bool freeze_workqueues_busy(void)
 
 	BUG_ON(!workqueue_freezing);
 
-	for_each_gcwq_cpu(cpu) {
+	for_each_wq_cpu(cpu) {
 		struct workqueue_struct *wq;
 		/*
 		 * nr_active is monotonically decreasing.  It's safe
@@ -3751,7 +3751,7 @@ out_unlock:
  * thaw_workqueues - thaw workqueues
  *
  * Thaw workqueues.  Normal queueing is restored and all collected
- * frozen works are transferred to their respective gcwq worklists.
+ * frozen works are transferred to their respective pool worklists.
  *
  * CONTEXT:
  * Grabs and releases workqueue_lock and pool->lock's.
@@ -3765,7 +3765,7 @@ void thaw_workqueues(void)
 	if (!workqueue_freezing)
 		goto out_unlock;
 
-	for_each_gcwq_cpu(cpu) {
+	for_each_wq_cpu(cpu) {
 		struct worker_pool *pool;
 		struct workqueue_struct *wq;
 
@@ -3809,8 +3809,8 @@ static int __init init_workqueues(void)
 	cpu_notifier(workqueue_cpu_up_callback, CPU_PRI_WORKQUEUE_UP);
 	hotcpu_notifier(workqueue_cpu_down_callback, CPU_PRI_WORKQUEUE_DOWN);
 
-	/* initialize gcwqs */
-	for_each_gcwq_cpu(cpu) {
+	/* initialize CPU pools */
+	for_each_wq_cpu(cpu) {
 		struct worker_pool *pool;
 
 		for_each_std_worker_pool(pool, cpu) {
@@ -3825,7 +3825,7 @@ static int __init init_workqueues(void)
 			pool->idle_timer.function = idle_worker_timeout;
 			pool->idle_timer.data = (unsigned long)pool;
 
-			setup_timer(&pool->mayday_timer, gcwq_mayday_timeout,
+			setup_timer(&pool->mayday_timer, pool_mayday_timeout,
 				    (unsigned long)pool);
 
 			mutex_init(&pool->assoc_mutex);
@@ -3837,7 +3837,7 @@ static int __init init_workqueues(void)
 	}
 
 	/* create the initial worker */
-	for_each_online_gcwq_cpu(cpu) {
+	for_each_online_wq_cpu(cpu) {
 		struct worker_pool *pool;
 
 		for_each_std_worker_pool(pool, cpu) {
-- 
1.8.0.2

