Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934527Ab3CMX64 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 19:58:56 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:56850 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934449Ab3CMX6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 19:58:32 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: laijs@cn.fujitsu.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 4/6] workqueue: update comments and a warning message
Date: Wed, 13 Mar 2013 16:58:16 -0700
Message-Id: <1363219098-16083-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1363219098-16083-1-git-send-email-tj@kernel.org>
References: <1363219098-16083-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Update incorrect and add missing synchronization labels.

* Update incorrect or misleading comments.  Add new comments where
  clarification is necessary.  Reformat / rephrase some comments.

* drain_workqueue() can be used separately from destroy_workqueue()
  but its warning message was incorrectly referring to destruction.

Other than the warning message change, this patch doesn't make any
functional changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c | 84 ++++++++++++++++++++++++++++--------------------------
 1 file changed, 44 insertions(+), 40 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 7567614..248a1e9 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -145,7 +145,7 @@ struct worker_pool {
 	struct timer_list	idle_timer;	/* L: worker idle timeout */
 	struct timer_list	mayday_timer;	/* L: SOS timer for workers */
 
-	/* workers are chained either in busy_hash or idle_list */
+	/* a workers is either on busy_hash or idle_list, or the manager */
 	DECLARE_HASHTABLE(busy_hash, BUSY_WORKER_HASH_ORDER);
 						/* L: hash of busy workers */
 
@@ -154,8 +154,8 @@ struct worker_pool {
 	struct ida		worker_ida;	/* L: for worker IDs */
 
 	struct workqueue_attrs	*attrs;		/* I: worker attributes */
-	struct hlist_node	hash_node;	/* R: unbound_pool_hash node */
-	int			refcnt;		/* refcnt for unbound pools */
+	struct hlist_node	hash_node;	/* W: unbound_pool_hash node */
+	int			refcnt;		/* W: refcnt for unbound pools */
 
 	/*
 	 * The current concurrency level.  As it's likely to be accessed
@@ -213,8 +213,8 @@ struct wq_flusher {
 struct wq_device;
 
 /*
- * The externally visible workqueue abstraction is an array of
- * per-CPU workqueues:
+ * The externally visible workqueue.  It relays the issued work items to
+ * the appropriate worker_pool through its pool_workqueues.
  */
 struct workqueue_struct {
 	unsigned int		flags;		/* W: WQ_* flags */
@@ -247,9 +247,10 @@ struct workqueue_struct {
 
 static struct kmem_cache *pwq_cache;
 
-/* hash of all unbound pools keyed by pool->attrs */
+/* W: hash of all unbound pools keyed by pool->attrs */
 static DEFINE_HASHTABLE(unbound_pool_hash, UNBOUND_POOL_HASH_ORDER);
 
+/* I: attributes used when instantiating standard unbound pools on demand */
 static struct workqueue_attrs *unbound_std_wq_attrs[NR_STD_WORKER_POOLS];
 
 struct workqueue_struct *system_wq __read_mostly;
@@ -434,16 +435,13 @@ static DEFINE_SPINLOCK(workqueue_lock);
 static LIST_HEAD(workqueues);
 static bool workqueue_freezing;		/* W: have wqs started freezing? */
 
-/*
- * The CPU and unbound standard worker pools.  The unbound ones have
- * POOL_DISASSOCIATED set, and their workers have WORKER_UNBOUND set.
- */
+/* the per-cpu worker pools */
 static DEFINE_PER_CPU_SHARED_ALIGNED(struct worker_pool [NR_STD_WORKER_POOLS],
 				     cpu_worker_pools);
 
 /*
- * idr of all pools.  Modifications are protected by workqueue_lock.  Read
- * accesses are protected by sched-RCU protected.
+ * R: idr of all pools.  Modifications are protected by workqueue_lock.
+ * Read accesses are protected by sched-RCU protected.
  */
 static DEFINE_IDR(worker_pool_idr);
 
@@ -890,13 +888,12 @@ static inline void worker_clr_flags(struct worker *worker, unsigned int flags)
  * recycled work item as currently executing and make it wait until the
  * current execution finishes, introducing an unwanted dependency.
  *
- * This function checks the work item address, work function and workqueue
- * to avoid false positives.  Note that this isn't complete as one may
- * construct a work function which can introduce dependency onto itself
- * through a recycled work item.  Well, if somebody wants to shoot oneself
- * in the foot that badly, there's only so much we can do, and if such
- * deadlock actually occurs, it should be easy to locate the culprit work
- * function.
+ * This function checks the work item address and work function to avoid
+ * false positives.  Note that this isn't complete as one may construct a
+ * work function which can introduce dependency onto itself through a
+ * recycled work item.  Well, if somebody wants to shoot oneself in the
+ * foot that badly, there's only so much we can do, and if such deadlock
+ * actually occurs, it should be easy to locate the culprit work function.
  *
  * CONTEXT:
  * spin_lock_irq(pool->lock).
@@ -1187,9 +1184,9 @@ static void insert_work(struct pool_workqueue *pwq, struct work_struct *work,
 	get_pwq(pwq);
 
 	/*
-	 * Ensure either worker_sched_deactivated() sees the above
-	 * list_add_tail() or we see zero nr_running to avoid workers
-	 * lying around lazily while there are works to be processed.
+	 * Ensure either wq_worker_sleeping() sees the above
+	 * list_add_tail() or we see zero nr_running to avoid workers lying
+	 * around lazily while there are works to be processed.
 	 */
 	smp_mb();
 
@@ -1790,6 +1787,10 @@ static struct worker *create_worker(struct worker_pool *pool)
 	if (IS_ERR(worker->task))
 		goto fail;
 
+	/*
+	 * set_cpus_allowed_ptr() will fail if the cpumask doesn't have any
+	 * online CPUs.  It'll be re-applied when any of the CPUs come up.
+	 */
 	set_user_nice(worker->task, pool->attrs->nice);
 	set_cpus_allowed_ptr(worker->task, pool->attrs->cpumask);
 
@@ -1950,8 +1951,8 @@ static void pool_mayday_timeout(unsigned long __pool)
  * sent to all rescuers with works scheduled on @pool to resolve
  * possible allocation deadlock.
  *
- * On return, need_to_create_worker() is guaranteed to be false and
- * may_start_working() true.
+ * On return, need_to_create_worker() is guaranteed to be %false and
+ * may_start_working() %true.
  *
  * LOCKING:
  * spin_lock_irq(pool->lock) which may be released and regrabbed
@@ -1959,7 +1960,7 @@ static void pool_mayday_timeout(unsigned long __pool)
  * manager.
  *
  * RETURNS:
- * false if no action was taken and pool->lock stayed locked, true
+ * %false if no action was taken and pool->lock stayed locked, %true
  * otherwise.
  */
 static bool maybe_create_worker(struct worker_pool *pool)
@@ -2016,7 +2017,7 @@ restart:
  * multiple times.  Called only from manager.
  *
  * RETURNS:
- * false if no action was taken and pool->lock stayed locked, true
+ * %false if no action was taken and pool->lock stayed locked, %true
  * otherwise.
  */
 static bool maybe_destroy_workers(struct worker_pool *pool)
@@ -2268,11 +2269,11 @@ static void process_scheduled_works(struct worker *worker)
  * worker_thread - the worker thread function
  * @__worker: self
  *
- * The worker thread function.  There are NR_CPU_WORKER_POOLS dynamic pools
- * of these per each cpu.  These workers process all works regardless of
- * their specific target workqueue.  The only exception is works which
- * belong to workqueues with a rescuer which will be explained in
- * rescuer_thread().
+ * The worker thread function.  All workers belong to a worker_pool -
+ * either a per-cpu one or dynamic unbound one.  These workers process all
+ * work items regardless of their specific target workqueue.  The only
+ * exception is work items which belong to workqueues with a rescuer which
+ * will be explained in rescuer_thread().
  */
 static int worker_thread(void *__worker)
 {
@@ -2600,11 +2601,8 @@ static bool flush_workqueue_prep_pwqs(struct workqueue_struct *wq,
  * flush_workqueue - ensure that any scheduled work has run to completion.
  * @wq: workqueue to flush
  *
- * Forces execution of the workqueue and blocks until its completion.
- * This is typically used in driver shutdown handlers.
- *
- * We sleep until all works which were queued on entry have been handled,
- * but we are not livelocked by new incoming ones.
+ * This function sleeps until all work items which were queued on entry
+ * have finished execution, but it is not livelocked by new incoming ones.
  */
 void flush_workqueue(struct workqueue_struct *wq)
 {
@@ -2794,7 +2792,7 @@ reflush:
 
 		if (++flush_cnt == 10 ||
 		    (flush_cnt % 100 == 0 && flush_cnt <= 1000))
-			pr_warn("workqueue %s: flush on destruction isn't complete after %u tries\n",
+			pr_warn("workqueue %s: drain_workqueue() isn't complete after %u tries\n",
 				wq->name, flush_cnt);
 
 		local_irq_enable();
@@ -3576,7 +3574,9 @@ static void rcu_free_pool(struct rcu_head *rcu)
  * @pool: worker_pool to put
  *
  * Put @pool.  If its refcnt reaches zero, it gets destroyed in sched-RCU
- * safe manner.
+ * safe manner.  get_unbound_pool() calls this function on its failure path
+ * and this function should be able to release pools which went through,
+ * successfully or not, init_worker_pool().
  */
 static void put_unbound_pool(struct worker_pool *pool)
 {
@@ -3602,7 +3602,11 @@ static void put_unbound_pool(struct worker_pool *pool)
 
 	spin_unlock_irq(&workqueue_lock);
 
-	/* lock out manager and destroy all workers */
+	/*
+	 * Become the manager and destroy all workers.  Grabbing
+	 * manager_arb prevents @pool's workers from blocking on
+	 * manager_mutex.
+	 */
 	mutex_lock(&pool->manager_arb);
 	spin_lock_irq(&pool->lock);
 
@@ -4339,7 +4343,7 @@ EXPORT_SYMBOL_GPL(work_on_cpu);
  * freeze_workqueues_begin - begin freezing workqueues
  *
  * Start freezing workqueues.  After this function returns, all freezable
- * workqueues will queue new works to their frozen_works list instead of
+ * workqueues will queue new works to their delayed_works list instead of
  * pool->worklist.
  *
  * CONTEXT:
-- 
1.8.1.4

