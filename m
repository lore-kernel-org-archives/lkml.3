Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758355Ab3AQBnK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 20:43:10 -0500
Received: from mail-ie0-f169.google.com ([209.85.223.169]:59682 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758298Ab3AQBnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 20:43:07 -0500
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Tejun Heo <tj@kernel.org>
Subject: [PATCH 08/17] workqueue: move busy_hash from global_cwq to worker_pool
Date: Wed, 16 Jan 2013 17:42:40 -0800
Message-Id: <1358386969-945-9-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <1358386969-945-1-git-send-email-tj@kernel.org>
References: <1358386969-945-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no functional necessity for the two pools on the same CPU to
share the busy hash table.  It's also likely to be a bottleneck when
implementing pools with user-specified attributes.

This patch makes busy_hash per-pool.  The conversion is mostly
straight-forward.  Changes worth noting are,

* Large block of changes in rebind_workers() is moving the block
  inside for_each_worker_pool() as now there are separate hash tables
  for each pool.  This changes the order of operations but doesn't
  break anything.

* Thre for_each_worker_pool() loops in gcwq_unbind_fn() are combined
  into one.  This again changes the order of operaitons but doesn't
  break anything.

This is part of an effort to remove global_cwq and make worker_pool
the top level abstraction, which in turn will help implementing worker
pools with user-specified attributes.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c | 111 ++++++++++++++++++++++++++++-------------------------
 1 file changed, 59 insertions(+), 52 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 3b4d8a7..092d14aa 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -164,6 +164,10 @@ struct worker_pool {
 	struct timer_list	idle_timer;	/* L: worker idle timeout */
 	struct timer_list	mayday_timer;	/* L: SOS timer for workers */
 
+	/* workers are chained either in busy_hash or idle_list */
+	DECLARE_HASHTABLE(busy_hash, BUSY_WORKER_HASH_ORDER);
+						/* L: hash of busy workers */
+
 	struct mutex		assoc_mutex;	/* protect POOL_DISASSOCIATED */
 	struct ida		worker_ida;	/* L: for worker IDs */
 };
@@ -177,10 +181,6 @@ struct global_cwq {
 	spinlock_t		lock;		/* the gcwq lock */
 	unsigned int		cpu;		/* I: the associated cpu */
 
-	/* workers are chained either in busy_hash or pool idle_list */
-	DECLARE_HASHTABLE(busy_hash, BUSY_WORKER_HASH_ORDER);
-						/* L: hash of busy workers */
-
 	struct worker_pool	pools[NR_STD_WORKER_POOLS];
 						/* normal and highpri pools */
 } ____cacheline_aligned_in_smp;
@@ -282,8 +282,8 @@ EXPORT_SYMBOL_GPL(system_freezable_wq);
 	for ((pool) = &(gcwq)->pools[0];				\
 	     (pool) < &(gcwq)->pools[NR_STD_WORKER_POOLS]; (pool)++)
 
-#define for_each_busy_worker(worker, i, pos, gcwq)			\
-	hash_for_each(gcwq->busy_hash, i, pos, worker, hentry)
+#define for_each_busy_worker(worker, i, pos, pool)			\
+	hash_for_each(pool->busy_hash, i, pos, worker, hentry)
 
 static inline int __next_gcwq_cpu(int cpu, const struct cpumask *mask,
 				  unsigned int sw)
@@ -911,11 +911,11 @@ static inline void worker_clr_flags(struct worker *worker, unsigned int flags)
 
 /**
  * find_worker_executing_work - find worker which is executing a work
- * @gcwq: gcwq of interest
+ * @pool: pool of interest
  * @work: work to find worker for
  *
- * Find a worker which is executing @work on @gcwq by searching
- * @gcwq->busy_hash which is keyed by the address of @work.  For a worker
+ * Find a worker which is executing @work on @pool by searching
+ * @pool->busy_hash which is keyed by the address of @work.  For a worker
  * to match, its current execution should match the address of @work and
  * its work function.  This is to avoid unwanted dependency between
  * unrelated work executions through a work item being recycled while still
@@ -943,13 +943,13 @@ static inline void worker_clr_flags(struct worker *worker, unsigned int flags)
  * Pointer to worker which is executing @work if found, NULL
  * otherwise.
  */
-static struct worker *find_worker_executing_work(struct global_cwq *gcwq,
+static struct worker *find_worker_executing_work(struct worker_pool *pool,
 						 struct work_struct *work)
 {
 	struct worker *worker;
 	struct hlist_node *tmp;
 
-	hash_for_each_possible(gcwq->busy_hash, worker, tmp, hentry,
+	hash_for_each_possible(pool->busy_hash, worker, tmp, hentry,
 			       (unsigned long)work)
 		if (worker->current_work == work &&
 		    worker->current_func == work->func)
@@ -1210,13 +1210,15 @@ static bool is_chained_work(struct workqueue_struct *wq)
 	unsigned int cpu;
 
 	for_each_gcwq_cpu(cpu) {
-		struct global_cwq *gcwq = get_gcwq(cpu);
+		struct cpu_workqueue_struct *cwq = get_cwq(cpu, wq);
+		struct worker_pool *pool = cwq->pool;
+		struct global_cwq *gcwq = pool->gcwq;
 		struct worker *worker;
 		struct hlist_node *pos;
 		int i;
 
 		spin_lock_irqsave(&gcwq->lock, flags);
-		for_each_busy_worker(worker, i, pos, gcwq) {
+		for_each_busy_worker(worker, i, pos, pool) {
 			if (worker->task != current)
 				continue;
 			spin_unlock_irqrestore(&gcwq->lock, flags);
@@ -1257,7 +1259,7 @@ static void __queue_work(unsigned int cpu, struct workqueue_struct *wq,
 
 	/* determine gcwq to use */
 	if (!(wq->flags & WQ_UNBOUND)) {
-		struct global_cwq *last_gcwq;
+		struct worker_pool *last_pool;
 
 		if (cpu == WORK_CPU_UNBOUND)
 			cpu = raw_smp_processor_id();
@@ -1269,14 +1271,15 @@ static void __queue_work(unsigned int cpu, struct workqueue_struct *wq,
 		 * non-reentrancy.
 		 */
 		gcwq = get_gcwq(cpu);
-		last_gcwq = get_work_gcwq(work);
+		last_pool = get_work_pool(work);
 
-		if (last_gcwq && last_gcwq != gcwq) {
+		if (last_pool && last_pool->gcwq != gcwq) {
+			struct global_cwq *last_gcwq = last_pool->gcwq;
 			struct worker *worker;
 
 			spin_lock(&last_gcwq->lock);
 
-			worker = find_worker_executing_work(last_gcwq, work);
+			worker = find_worker_executing_work(last_pool, work);
 
 			if (worker && worker->current_cwq->wq == wq)
 				gcwq = last_gcwq;
@@ -1741,31 +1744,32 @@ static void rebind_workers(struct global_cwq *gcwq)
 			 */
 			wake_up_process(worker->task);
 		}
-	}
 
-	/* rebind busy workers */
-	for_each_busy_worker(worker, i, pos, gcwq) {
-		struct work_struct *rebind_work = &worker->rebind_work;
-		struct workqueue_struct *wq;
+		/* rebind busy workers */
+		for_each_busy_worker(worker, i, pos, pool) {
+			struct work_struct *rebind_work = &worker->rebind_work;
+			struct workqueue_struct *wq;
 
-		if (test_and_set_bit(WORK_STRUCT_PENDING_BIT,
-				     work_data_bits(rebind_work)))
-			continue;
+			if (test_and_set_bit(WORK_STRUCT_PENDING_BIT,
+					     work_data_bits(rebind_work)))
+				continue;
 
-		debug_work_activate(rebind_work);
+			debug_work_activate(rebind_work);
 
-		/*
-		 * wq doesn't really matter but let's keep @worker->pool
-		 * and @cwq->pool consistent for sanity.
-		 */
-		if (std_worker_pool_pri(worker->pool))
-			wq = system_highpri_wq;
-		else
-			wq = system_wq;
-
-		insert_work(get_cwq(gcwq->cpu, wq), rebind_work,
-			worker->scheduled.next,
-			work_color_to_flags(WORK_NO_COLOR));
+			/*
+			 * wq doesn't really matter but let's keep
+			 * @worker->pool and @cwq->pool consistent for
+			 * sanity.
+			 */
+			if (std_worker_pool_pri(worker->pool))
+				wq = system_highpri_wq;
+			else
+				wq = system_wq;
+
+			insert_work(get_cwq(gcwq->cpu, wq), rebind_work,
+				    worker->scheduled.next,
+				    work_color_to_flags(WORK_NO_COLOR));
+		}
 	}
 }
 
@@ -2216,7 +2220,7 @@ __acquires(&gcwq->lock)
 	 * already processing the work.  If so, defer the work to the
 	 * currently executing one.
 	 */
-	collision = find_worker_executing_work(gcwq, work);
+	collision = find_worker_executing_work(pool, work);
 	if (unlikely(collision)) {
 		move_linked_works(work, &collision->scheduled, NULL);
 		return;
@@ -2224,7 +2228,7 @@ __acquires(&gcwq->lock)
 
 	/* claim and dequeue */
 	debug_work_deactivate(work);
-	hash_add(gcwq->busy_hash, &worker->hentry, (unsigned long)work);
+	hash_add(pool->busy_hash, &worker->hentry, (unsigned long)work);
 	worker->current_work = work;
 	worker->current_func = work->func;
 	worker->current_cwq = cwq;
@@ -2843,13 +2847,15 @@ EXPORT_SYMBOL_GPL(drain_workqueue);
 static bool start_flush_work(struct work_struct *work, struct wq_barrier *barr)
 {
 	struct worker *worker = NULL;
+	struct worker_pool *pool;
 	struct global_cwq *gcwq;
 	struct cpu_workqueue_struct *cwq;
 
 	might_sleep();
-	gcwq = get_work_gcwq(work);
-	if (!gcwq)
+	pool = get_work_pool(work);
+	if (!pool)
 		return false;
+	gcwq = pool->gcwq;
 
 	spin_lock_irq(&gcwq->lock);
 	if (!list_empty(&work->entry)) {
@@ -2863,7 +2869,7 @@ static bool start_flush_work(struct work_struct *work, struct wq_barrier *barr)
 		if (unlikely(!cwq || gcwq != cwq->pool->gcwq))
 			goto already_gone;
 	} else {
-		worker = find_worker_executing_work(gcwq, work);
+		worker = find_worker_executing_work(pool, work);
 		if (!worker)
 			goto already_gone;
 		cwq = worker->current_cwq;
@@ -3491,18 +3497,20 @@ EXPORT_SYMBOL_GPL(workqueue_congested);
  */
 unsigned int work_busy(struct work_struct *work)
 {
-	struct global_cwq *gcwq = get_work_gcwq(work);
+	struct worker_pool *pool = get_work_pool(work);
+	struct global_cwq *gcwq;
 	unsigned long flags;
 	unsigned int ret = 0;
 
-	if (!gcwq)
+	if (!pool)
 		return 0;
+	gcwq = pool->gcwq;
 
 	spin_lock_irqsave(&gcwq->lock, flags);
 
 	if (work_pending(work))
 		ret |= WORK_BUSY_PENDING;
-	if (find_worker_executing_work(gcwq, work))
+	if (find_worker_executing_work(pool, work))
 		ret |= WORK_BUSY_RUNNING;
 
 	spin_unlock_irqrestore(&gcwq->lock, flags);
@@ -3564,15 +3572,15 @@ static void gcwq_unbind_fn(struct work_struct *work)
 	 * ones which are still executing works from before the last CPU
 	 * down must be on the cpu.  After this, they may become diasporas.
 	 */
-	for_each_worker_pool(pool, gcwq)
+	for_each_worker_pool(pool, gcwq) {
 		list_for_each_entry(worker, &pool->idle_list, entry)
 			worker->flags |= WORKER_UNBOUND;
 
-	for_each_busy_worker(worker, i, pos, gcwq)
-		worker->flags |= WORKER_UNBOUND;
+		for_each_busy_worker(worker, i, pos, pool)
+			worker->flags |= WORKER_UNBOUND;
 
-	for_each_worker_pool(pool, gcwq)
 		pool->flags |= POOL_DISASSOCIATED;
+	}
 
 	gcwq_release_assoc_and_unlock(gcwq);
 
@@ -3863,13 +3871,12 @@ static int __init init_workqueues(void)
 		spin_lock_init(&gcwq->lock);
 		gcwq->cpu = cpu;
 
-		hash_init(gcwq->busy_hash);
-
 		for_each_worker_pool(pool, gcwq) {
 			pool->gcwq = gcwq;
 			pool->flags |= POOL_DISASSOCIATED;
 			INIT_LIST_HEAD(&pool->worklist);
 			INIT_LIST_HEAD(&pool->idle_list);
+			hash_init(pool->busy_hash);
 
 			init_timer_deferrable(&pool->idle_timer);
 			pool->idle_timer.function = idle_worker_timeout;
-- 
1.8.0.2

