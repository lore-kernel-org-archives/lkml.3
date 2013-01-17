Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758548Ab3AQBqt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 20:46:49 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:33208 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758191Ab3AQBm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 20:42:58 -0500
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Tejun Heo <tj@kernel.org>
Subject: [PATCH 03/17] workqueue: make GCWQ_DISASSOCIATED a pool flag
Date: Wed, 16 Jan 2013 17:42:35 -0800
Message-Id: <1358386969-945-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <1358386969-945-1-git-send-email-tj@kernel.org>
References: <1358386969-945-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make GCWQ_DISASSOCIATED a pool flag POOL_DISASSOCIATED.  This patch
doesn't change locking - DISASSOCIATED on both pools of a CPU are set
or clear together while holding gcwq->lock.  It shouldn't cause any
functional difference.

This is part of an effort to remove global_cwq and make worker_pool
the top level abstraction, which in turn will help implementing worker
pools with user-specified attributes.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c | 66 +++++++++++++++++++++++++++++-------------------------
 1 file changed, 35 insertions(+), 31 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 5e74cd2..8feef7e 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -48,26 +48,28 @@
 enum {
 	/*
 	 * global_cwq flags
+	 */
+	GCWQ_FREEZING		= 1 << 1,	/* freeze in progress */
+
+	/*
+	 * worker_pool flags
 	 *
-	 * A bound gcwq is either associated or disassociated with its CPU.
+	 * A bound pool is either associated or disassociated with its CPU.
 	 * While associated (!DISASSOCIATED), all workers are bound to the
 	 * CPU and none has %WORKER_UNBOUND set and concurrency management
 	 * is in effect.
 	 *
 	 * While DISASSOCIATED, the cpu may be offline and all workers have
 	 * %WORKER_UNBOUND set and concurrency management disabled, and may
-	 * be executing on any CPU.  The gcwq behaves as an unbound one.
+	 * be executing on any CPU.  The pool behaves as an unbound one.
 	 *
 	 * Note that DISASSOCIATED can be flipped only while holding
-	 * assoc_mutex of all pools on the gcwq to avoid changing binding
-	 * state while create_worker() is in progress.
+	 * assoc_mutex to avoid changing binding state while
+	 * create_worker() is in progress.
 	 */
-	GCWQ_DISASSOCIATED	= 1 << 0,	/* cpu can't serve workers */
-	GCWQ_FREEZING		= 1 << 1,	/* freeze in progress */
-
-	/* pool flags */
 	POOL_MANAGE_WORKERS	= 1 << 0,	/* need to manage workers */
 	POOL_MANAGING_WORKERS   = 1 << 1,       /* managing workers */
+	POOL_DISASSOCIATED	= 1 << 2,	/* cpu can't serve workers */
 
 	/* worker flags */
 	WORKER_STARTED		= 1 << 0,	/* started */
@@ -115,7 +117,7 @@ enum {
  * X: During normal operation, modification requires gcwq->lock and
  *    should be done only from local cpu.  Either disabling preemption
  *    on local cpu or grabbing gcwq->lock is enough for read access.
- *    If GCWQ_DISASSOCIATED is set, it's identical to L.
+ *    If POOL_DISASSOCIATED is set, it's identical to L.
  *
  * F: wq->flush_mutex protected.
  *
@@ -165,7 +167,7 @@ struct worker_pool {
 	struct timer_list	idle_timer;	/* L: worker idle timeout */
 	struct timer_list	mayday_timer;	/* L: SOS timer for workers */
 
-	struct mutex		assoc_mutex;	/* protect GCWQ_DISASSOCIATED */
+	struct mutex		assoc_mutex;	/* protect POOL_DISASSOCIATED */
 	struct ida		worker_ida;	/* L: for worker IDs */
 };
 
@@ -466,9 +468,9 @@ static DEFINE_PER_CPU(struct global_cwq, global_cwq);
 static DEFINE_PER_CPU_SHARED_ALIGNED(atomic_t, pool_nr_running[NR_STD_WORKER_POOLS]);
 
 /*
- * Global cpu workqueue and nr_running counter for unbound gcwq.  The
- * gcwq is always online, has GCWQ_DISASSOCIATED set, and all its
- * workers have WORKER_UNBOUND set.
+ * Global cpu workqueue and nr_running counter for unbound gcwq.  The pools
+ * for online CPUs have POOL_DISASSOCIATED set, and all their workers have
+ * WORKER_UNBOUND set.
  */
 static struct global_cwq unbound_global_cwq;
 static atomic_t unbound_pool_nr_running[NR_STD_WORKER_POOLS] = {
@@ -1493,7 +1495,6 @@ EXPORT_SYMBOL_GPL(mod_delayed_work);
 static void worker_enter_idle(struct worker *worker)
 {
 	struct worker_pool *pool = worker->pool;
-	struct global_cwq *gcwq = pool->gcwq;
 
 	BUG_ON(worker->flags & WORKER_IDLE);
 	BUG_ON(!list_empty(&worker->entry) &&
@@ -1516,7 +1517,7 @@ static void worker_enter_idle(struct worker *worker)
 	 * nr_running, the warning may trigger spuriously.  Check iff
 	 * unbind is not in progress.
 	 */
-	WARN_ON_ONCE(!(gcwq->flags & GCWQ_DISASSOCIATED) &&
+	WARN_ON_ONCE(!(pool->flags & POOL_DISASSOCIATED) &&
 		     pool->nr_workers == pool->nr_idle &&
 		     atomic_read(get_pool_nr_running(pool)));
 }
@@ -1557,7 +1558,7 @@ static void worker_leave_idle(struct worker *worker)
  * [dis]associated in the meantime.
  *
  * This function tries set_cpus_allowed() and locks gcwq and verifies the
- * binding against %GCWQ_DISASSOCIATED which is set during
+ * binding against %POOL_DISASSOCIATED which is set during
  * %CPU_DOWN_PREPARE and cleared during %CPU_ONLINE, so if the worker
  * enters idle state or fetches works without dropping lock, it can
  * guarantee the scheduling requirement described in the first paragraph.
@@ -1573,7 +1574,8 @@ static void worker_leave_idle(struct worker *worker)
 static bool worker_maybe_bind_and_lock(struct worker *worker)
 __acquires(&gcwq->lock)
 {
-	struct global_cwq *gcwq = worker->pool->gcwq;
+	struct worker_pool *pool = worker->pool;
+	struct global_cwq *gcwq = pool->gcwq;
 	struct task_struct *task = worker->task;
 
 	while (true) {
@@ -1581,13 +1583,13 @@ __acquires(&gcwq->lock)
 		 * The following call may fail, succeed or succeed
 		 * without actually migrating the task to the cpu if
 		 * it races with cpu hotunplug operation.  Verify
-		 * against GCWQ_DISASSOCIATED.
+		 * against POOL_DISASSOCIATED.
 		 */
-		if (!(gcwq->flags & GCWQ_DISASSOCIATED))
+		if (!(pool->flags & POOL_DISASSOCIATED))
 			set_cpus_allowed_ptr(task, get_cpu_mask(gcwq->cpu));
 
 		spin_lock_irq(&gcwq->lock);
-		if (gcwq->flags & GCWQ_DISASSOCIATED)
+		if (pool->flags & POOL_DISASSOCIATED)
 			return false;
 		if (task_cpu(task) == gcwq->cpu &&
 		    cpumask_equal(&current->cpus_allowed,
@@ -1785,14 +1787,14 @@ static struct worker *create_worker(struct worker_pool *pool)
 
 	/*
 	 * Determine CPU binding of the new worker depending on
-	 * %GCWQ_DISASSOCIATED.  The caller is responsible for ensuring the
+	 * %POOL_DISASSOCIATED.  The caller is responsible for ensuring the
 	 * flag remains stable across this function.  See the comments
 	 * above the flag definition for details.
 	 *
 	 * As an unbound worker may later become a regular one if CPU comes
 	 * online, make sure every worker has %PF_THREAD_BOUND set.
 	 */
-	if (!(gcwq->flags & GCWQ_DISASSOCIATED)) {
+	if (!(pool->flags & POOL_DISASSOCIATED)) {
 		kthread_bind(worker->task, gcwq->cpu);
 	} else {
 		worker->task->flags |= PF_THREAD_BOUND;
@@ -2153,10 +2155,10 @@ __acquires(&gcwq->lock)
 	/*
 	 * Ensure we're on the correct CPU.  DISASSOCIATED test is
 	 * necessary to avoid spurious warnings from rescuers servicing the
-	 * unbound or a disassociated gcwq.
+	 * unbound or a disassociated pool.
 	 */
 	WARN_ON_ONCE(!(worker->flags & WORKER_UNBOUND) &&
-		     !(gcwq->flags & GCWQ_DISASSOCIATED) &&
+		     !(pool->flags & POOL_DISASSOCIATED) &&
 		     raw_smp_processor_id() != gcwq->cpu);
 
 	/*
@@ -3481,7 +3483,7 @@ EXPORT_SYMBOL_GPL(work_busy);
  * gcwqs serve mix of short, long and very long running works making
  * blocked draining impractical.
  *
- * This is solved by allowing a gcwq to be disassociated from the CPU
+ * This is solved by allowing the pools to be disassociated from the CPU
  * running as an unbound one and allowing it to be reattached later if the
  * cpu comes back online.
  */
@@ -3531,7 +3533,8 @@ static void gcwq_unbind_fn(struct work_struct *work)
 	for_each_busy_worker(worker, i, pos, gcwq)
 		worker->flags |= WORKER_UNBOUND;
 
-	gcwq->flags |= GCWQ_DISASSOCIATED;
+	for_each_worker_pool(pool, gcwq)
+		pool->flags |= POOL_DISASSOCIATED;
 
 	gcwq_release_assoc_and_unlock(gcwq);
 
@@ -3590,7 +3593,8 @@ static int __cpuinit workqueue_cpu_up_callback(struct notifier_block *nfb,
 	case CPU_DOWN_FAILED:
 	case CPU_ONLINE:
 		gcwq_claim_assoc_and_lock(gcwq);
-		gcwq->flags &= ~GCWQ_DISASSOCIATED;
+		for_each_worker_pool(pool, gcwq)
+			pool->flags &= ~POOL_DISASSOCIATED;
 		rebind_workers(gcwq);
 		gcwq_release_assoc_and_unlock(gcwq);
 		break;
@@ -3815,12 +3819,12 @@ static int __init init_workqueues(void)
 
 		spin_lock_init(&gcwq->lock);
 		gcwq->cpu = cpu;
-		gcwq->flags |= GCWQ_DISASSOCIATED;
 
 		hash_init(gcwq->busy_hash);
 
 		for_each_worker_pool(pool, gcwq) {
 			pool->gcwq = gcwq;
+			pool->flags |= POOL_DISASSOCIATED;
 			INIT_LIST_HEAD(&pool->worklist);
 			INIT_LIST_HEAD(&pool->idle_list);
 
@@ -3841,12 +3845,12 @@ static int __init init_workqueues(void)
 		struct global_cwq *gcwq = get_gcwq(cpu);
 		struct worker_pool *pool;
 
-		if (cpu != WORK_CPU_UNBOUND)
-			gcwq->flags &= ~GCWQ_DISASSOCIATED;
-
 		for_each_worker_pool(pool, gcwq) {
 			struct worker *worker;
 
+			if (cpu != WORK_CPU_UNBOUND)
+				pool->flags &= ~POOL_DISASSOCIATED;
+
 			worker = create_worker(pool);
 			BUG_ON(!worker);
 			spin_lock_irq(&gcwq->lock);
-- 
1.8.0.2

