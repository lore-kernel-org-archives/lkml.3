Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755485Ab3AXTkE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 14:40:04 -0500
Received: from mail-qa0-f49.google.com ([209.85.216.49]:44863 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755127Ab3AXTju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 14:39:50 -0500
Date: Thu, 24 Jan 2013 11:39:44 -0800
From: Tejun Heo <tj@kernel.org>
To: Joonsoo Kim <js1304@gmail.com>, Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH wq/for-3.9] workqueue: move nr_running into worker_pool
Message-ID: <20130124193944.GR2373@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As nr_running is likely to be accessed from other CPUs during
try_to_wake_up(), it was kept outside worker_pool; however, while less
frequent, other fields in worker_pool are accessed from other CPUs
for, e.g., non-reentrancy check.  Also, with recent pool related
changes, accessing nr_running matching the worker_pool isn't as simple
as it used to be.

Move nr_running inside worker_pool.  Keep it aligned to cacheline and
define CPU pools using DEFINE_PER_CPU_SHARED_ALIGNED().  This should
give at least the same cacheline behavior.

get_pool_nr_running() is replaced with direct pool->nr_running
accesses.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Joonsoo Kim <js1304@gmail.com>
---
 kernel/workqueue.c |   63 ++++++++++++++++++-----------------------------------
 1 file changed, 22 insertions(+), 41 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 577de10..a49cc88 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -144,6 +144,13 @@ struct worker_pool {
 
 	struct mutex		assoc_mutex;	/* protect POOL_DISASSOCIATED */
 	struct ida		worker_ida;	/* L: for worker IDs */
+
+	/*
+	 * The current concurrency level.  As it's likely to be accessed
+	 * from other CPUs during try_to_wake_up(), put it in a separate
+	 * cacheline.
+	 */
+	atomic_t		nr_running ____cacheline_aligned_in_smp;
 } ____cacheline_aligned_in_smp;
 
 /*
@@ -417,23 +424,12 @@ static LIST_HEAD(workqueues);
 static bool workqueue_freezing;		/* W: have wqs started freezing? */
 
 /*
- * The CPU standard worker pools.  nr_running is the only field which is
- * expected to be used frequently by other cpus via try_to_wake_up().  Put
- * it in a separate cacheline.
- */
-static DEFINE_PER_CPU(struct worker_pool [NR_STD_WORKER_POOLS],
-		      cpu_std_worker_pools);
-static DEFINE_PER_CPU_SHARED_ALIGNED(atomic_t [NR_STD_WORKER_POOLS],
-				     cpu_std_pool_nr_running);
-
-/*
- * Standard worker pools and nr_running counter for unbound CPU.  The pools
- * have POOL_DISASSOCIATED set, and all workers have WORKER_UNBOUND set.
+ * The CPU and unbound standard worker pools.  The unbound ones have
+ * POOL_DISASSOCIATED set, and their workers have WORKER_UNBOUND set.
  */
+static DEFINE_PER_CPU_SHARED_ALIGNED(struct worker_pool [NR_STD_WORKER_POOLS],
+				     cpu_std_worker_pools);
 static struct worker_pool unbound_std_worker_pools[NR_STD_WORKER_POOLS];
-static atomic_t unbound_std_pool_nr_running[NR_STD_WORKER_POOLS] = {
-	[0 ... NR_STD_WORKER_POOLS - 1]	= ATOMIC_INIT(0),	/* always 0 */
-};
 
 /* idr of all pools */
 static DEFINE_MUTEX(worker_pool_idr_mutex);
@@ -483,17 +479,6 @@ static struct worker_pool *get_std_worker_pool(int cpu, bool highpri)
 	return &pools[highpri];
 }
 
-static atomic_t *get_pool_nr_running(struct worker_pool *pool)
-{
-	int cpu = pool->cpu;
-	int idx = std_worker_pool_pri(pool);
-
-	if (cpu != WORK_CPU_UNBOUND)
-		return &per_cpu(cpu_std_pool_nr_running, cpu)[idx];
-	else
-		return &unbound_std_pool_nr_running[idx];
-}
-
 static struct cpu_workqueue_struct *get_cwq(unsigned int cpu,
 					    struct workqueue_struct *wq)
 {
@@ -647,7 +632,7 @@ static bool work_is_canceling(struct work_struct *work)
 
 static bool __need_more_worker(struct worker_pool *pool)
 {
-	return !atomic_read(get_pool_nr_running(pool));
+	return !atomic_read(&pool->nr_running);
 }
 
 /*
@@ -672,9 +657,8 @@ static bool may_start_working(struct worker_pool *pool)
 /* Do I need to keep working?  Called from currently running workers. */
 static bool keep_working(struct worker_pool *pool)
 {
-	atomic_t *nr_running = get_pool_nr_running(pool);
-
-	return !list_empty(&pool->worklist) && atomic_read(nr_running) <= 1;
+	return !list_empty(&pool->worklist) &&
+		atomic_read(&pool->nr_running) <= 1;
 }
 
 /* Do we need a new worker?  Called from manager. */
@@ -754,7 +738,7 @@ void wq_worker_waking_up(struct task_struct *task, unsigned int cpu)
 
 	if (!(worker->flags & WORKER_NOT_RUNNING)) {
 		WARN_ON_ONCE(worker->pool->cpu != cpu);
-		atomic_inc(get_pool_nr_running(worker->pool));
+		atomic_inc(&worker->pool->nr_running);
 	}
 }
 
@@ -778,7 +762,6 @@ struct task_struct *wq_worker_sleeping(struct task_struct *task,
 {
 	struct worker *worker = kthread_data(task), *to_wakeup = NULL;
 	struct worker_pool *pool;
-	atomic_t *nr_running;
 
 	/*
 	 * Rescuers, which may not have all the fields set up like normal
@@ -789,7 +772,6 @@ struct task_struct *wq_worker_sleeping(struct task_struct *task,
 		return NULL;
 
 	pool = worker->pool;
-	nr_running = get_pool_nr_running(pool);
 
 	/* this can only happen on the local cpu */
 	BUG_ON(cpu != raw_smp_processor_id());
@@ -805,7 +787,8 @@ struct task_struct *wq_worker_sleeping(struct task_struct *task,
 	 * manipulating idle_list, so dereferencing idle_list without pool
 	 * lock is safe.
 	 */
-	if (atomic_dec_and_test(nr_running) && !list_empty(&pool->worklist))
+	if (atomic_dec_and_test(&pool->nr_running) &&
+	    !list_empty(&pool->worklist))
 		to_wakeup = first_worker(pool);
 	return to_wakeup ? to_wakeup->task : NULL;
 }
@@ -837,14 +820,12 @@ static inline void worker_set_flags(struct worker *worker, unsigned int flags,
 	 */
 	if ((flags & WORKER_NOT_RUNNING) &&
 	    !(worker->flags & WORKER_NOT_RUNNING)) {
-		atomic_t *nr_running = get_pool_nr_running(pool);
-
 		if (wakeup) {
-			if (atomic_dec_and_test(nr_running) &&
+			if (atomic_dec_and_test(&pool->nr_running) &&
 			    !list_empty(&pool->worklist))
 				wake_up_worker(pool);
 		} else
-			atomic_dec(nr_running);
+			atomic_dec(&pool->nr_running);
 	}
 
 	worker->flags |= flags;
@@ -876,7 +857,7 @@ static inline void worker_clr_flags(struct worker *worker, unsigned int flags)
 	 */
 	if ((flags & WORKER_NOT_RUNNING) && (oflags & WORKER_NOT_RUNNING))
 		if (!(worker->flags & WORKER_NOT_RUNNING))
-			atomic_inc(get_pool_nr_running(pool));
+			atomic_inc(&pool->nr_running);
 }
 
 /**
@@ -1540,7 +1521,7 @@ static void worker_enter_idle(struct worker *worker)
 	 */
 	WARN_ON_ONCE(!(pool->flags & POOL_DISASSOCIATED) &&
 		     pool->nr_workers == pool->nr_idle &&
-		     atomic_read(get_pool_nr_running(pool)));
+		     atomic_read(&pool->nr_running));
 }
 
 /**
@@ -3538,7 +3519,7 @@ static void wq_unbind_fn(struct work_struct *work)
 	 * didn't already.
 	 */
 	for_each_std_worker_pool(pool, cpu)
-		atomic_set(get_pool_nr_running(pool), 0);
+		atomic_set(&pool->nr_running, 0);
 }
 
 /*
