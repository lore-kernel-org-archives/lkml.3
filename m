Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758387Ab3AQBnP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 20:43:15 -0500
Received: from mail-ie0-f180.google.com ([209.85.223.180]:52914 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758339Ab3AQBnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 20:43:10 -0500
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Tejun Heo <tj@kernel.org>
Subject: [PATCH 10/17] workqueue: move global_cwq->lock to worker_pool
Date: Wed, 16 Jan 2013 17:42:42 -0800
Message-Id: <1358386969-945-11-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <1358386969-945-1-git-send-email-tj@kernel.org>
References: <1358386969-945-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move gcwq->lock to pool->lock.  The conversion is mostly
straight-forward.  Things worth noting are

* In many places, this removes the need to use gcwq completely.  pool
  is used directly instead.  get_std_worker_pool() is added to help
  some of these conversions.  This also leaves get_work_gcwq() without
  any user.  Removed.

* In hotplug and freezer paths, the pools belonging to a CPU are often
  processed together.  This patch makes those paths hold locks of all
  pools, with highpri lock nested inside, to keep the conversion
  straight-forward.  These nested lockings will be removed by
  following patches.

This is part of an effort to remove global_cwq and make worker_pool
the top level abstraction, which in turn will help implementing worker
pools with user-specified attributes.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c | 316 ++++++++++++++++++++++++++---------------------------
 1 file changed, 154 insertions(+), 162 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 1720da7..755d2c4 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -108,12 +108,12 @@ enum {
  * P: Preemption protected.  Disabling preemption is enough and should
  *    only be modified and accessed from the local cpu.
  *
- * L: gcwq->lock protected.  Access with gcwq->lock held.
+ * L: pool->lock protected.  Access with pool->lock held.
  *
- * X: During normal operation, modification requires gcwq->lock and
- *    should be done only from local cpu.  Either disabling preemption
- *    on local cpu or grabbing gcwq->lock is enough for read access.
- *    If POOL_DISASSOCIATED is set, it's identical to L.
+ * X: During normal operation, modification requires pool->lock and should
+ *    be done only from local cpu.  Either disabling preemption on local
+ *    cpu or grabbing pool->lock is enough for read access.  If
+ *    POOL_DISASSOCIATED is set, it's identical to L.
  *
  * F: wq->flush_mutex protected.
  *
@@ -151,6 +151,7 @@ struct worker {
 
 struct worker_pool {
 	struct global_cwq	*gcwq;		/* I: the owning gcwq */
+	spinlock_t		lock;		/* the pool lock */
 	unsigned int		cpu;		/* I: the associated cpu */
 	int			id;		/* I: pool ID */
 	unsigned int		flags;		/* X: flags */
@@ -179,8 +180,6 @@ struct worker_pool {
  * target workqueues.
  */
 struct global_cwq {
-	spinlock_t		lock;		/* the gcwq lock */
-
 	struct worker_pool	pools[NR_STD_WORKER_POOLS];
 						/* normal and highpri pools */
 } ____cacheline_aligned_in_smp;
@@ -514,6 +513,13 @@ static struct worker_pool *worker_pool_by_id(int pool_id)
 	return idr_find(&worker_pool_idr, pool_id);
 }
 
+static struct worker_pool *get_std_worker_pool(int cpu, bool highpri)
+{
+	struct global_cwq *gcwq = get_gcwq(cpu);
+
+	return &gcwq->pools[highpri];
+}
+
 static atomic_t *get_pool_nr_running(struct worker_pool *pool)
 {
 	int cpu = pool->cpu;
@@ -655,13 +661,6 @@ static int get_work_pool_id(struct work_struct *work)
 	return pool ? pool->id : WORK_OFFQ_POOL_NONE;
 }
 
-static struct global_cwq *get_work_gcwq(struct work_struct *work)
-{
-	struct worker_pool *pool = get_work_pool(work);
-
-	return pool ? pool->gcwq : NULL;
-}
-
 static void mark_work_canceling(struct work_struct *work)
 {
 	unsigned long pool_id = get_work_pool_id(work);
@@ -680,7 +679,7 @@ static bool work_is_canceling(struct work_struct *work)
 /*
  * Policy functions.  These define the policies on how the global worker
  * pools are managed.  Unless noted otherwise, these functions assume that
- * they're being called with gcwq->lock held.
+ * they're being called with pool->lock held.
  */
 
 static bool __need_more_worker(struct worker_pool *pool)
@@ -765,7 +764,7 @@ static struct worker *first_worker(struct worker_pool *pool)
  * Wake up the first idle worker of @pool.
  *
  * CONTEXT:
- * spin_lock_irq(gcwq->lock).
+ * spin_lock_irq(pool->lock).
  */
 static void wake_up_worker(struct worker_pool *pool)
 {
@@ -832,7 +831,7 @@ struct task_struct *wq_worker_sleeping(struct task_struct *task,
 	 * NOT_RUNNING is clear.  This means that we're bound to and
 	 * running on the local cpu w/ rq lock held and preemption
 	 * disabled, which in turn means that none else could be
-	 * manipulating idle_list, so dereferencing idle_list without gcwq
+	 * manipulating idle_list, so dereferencing idle_list without pool
 	 * lock is safe.
 	 */
 	if (atomic_dec_and_test(nr_running) && !list_empty(&pool->worklist))
@@ -851,7 +850,7 @@ struct task_struct *wq_worker_sleeping(struct task_struct *task,
  * woken up.
  *
  * CONTEXT:
- * spin_lock_irq(gcwq->lock)
+ * spin_lock_irq(pool->lock)
  */
 static inline void worker_set_flags(struct worker *worker, unsigned int flags,
 				    bool wakeup)
@@ -888,7 +887,7 @@ static inline void worker_set_flags(struct worker *worker, unsigned int flags,
  * Clear @flags in @worker->flags and adjust nr_running accordingly.
  *
  * CONTEXT:
- * spin_lock_irq(gcwq->lock)
+ * spin_lock_irq(pool->lock)
  */
 static inline void worker_clr_flags(struct worker *worker, unsigned int flags)
 {
@@ -937,7 +936,7 @@ static inline void worker_clr_flags(struct worker *worker, unsigned int flags)
  * function.
  *
  * CONTEXT:
- * spin_lock_irq(gcwq->lock).
+ * spin_lock_irq(pool->lock).
  *
  * RETURNS:
  * Pointer to worker which is executing @work if found, NULL
@@ -973,7 +972,7 @@ static struct worker *find_worker_executing_work(struct worker_pool *pool,
  * nested inside outer list_for_each_entry_safe().
  *
  * CONTEXT:
- * spin_lock_irq(gcwq->lock).
+ * spin_lock_irq(pool->lock).
  */
 static void move_linked_works(struct work_struct *work, struct list_head *head,
 			      struct work_struct **nextp)
@@ -1026,7 +1025,7 @@ static void cwq_activate_first_delayed(struct cpu_workqueue_struct *cwq)
  * decrement nr_in_flight of its cwq and handle workqueue flushing.
  *
  * CONTEXT:
- * spin_lock_irq(gcwq->lock).
+ * spin_lock_irq(pool->lock).
  */
 static void cwq_dec_nr_in_flight(struct cpu_workqueue_struct *cwq, int color)
 {
@@ -1090,7 +1089,7 @@ static void cwq_dec_nr_in_flight(struct cpu_workqueue_struct *cwq, int color)
 static int try_to_grab_pending(struct work_struct *work, bool is_dwork,
 			       unsigned long *flags)
 {
-	struct global_cwq *gcwq;
+	struct worker_pool *pool;
 
 	local_irq_save(*flags);
 
@@ -1115,19 +1114,19 @@ static int try_to_grab_pending(struct work_struct *work, bool is_dwork,
 	 * The queueing is in progress, or it is already queued. Try to
 	 * steal it from ->worklist without clearing WORK_STRUCT_PENDING.
 	 */
-	gcwq = get_work_gcwq(work);
-	if (!gcwq)
+	pool = get_work_pool(work);
+	if (!pool)
 		goto fail;
 
-	spin_lock(&gcwq->lock);
+	spin_lock(&pool->lock);
 	if (!list_empty(&work->entry)) {
 		/*
-		 * This work is queued, but perhaps we locked the wrong gcwq.
-		 * In that case we must see the new value after rmb(), see
-		 * insert_work()->wmb().
+		 * This work is queued, but perhaps we locked the wrong
+		 * pool.  In that case we must see the new value after
+		 * rmb(), see insert_work()->wmb().
 		 */
 		smp_rmb();
-		if (gcwq == get_work_gcwq(work)) {
+		if (pool == get_work_pool(work)) {
 			debug_work_deactivate(work);
 
 			/*
@@ -1145,11 +1144,11 @@ static int try_to_grab_pending(struct work_struct *work, bool is_dwork,
 			cwq_dec_nr_in_flight(get_work_cwq(work),
 				get_work_color(work));
 
-			spin_unlock(&gcwq->lock);
+			spin_unlock(&pool->lock);
 			return 1;
 		}
 	}
-	spin_unlock(&gcwq->lock);
+	spin_unlock(&pool->lock);
 fail:
 	local_irq_restore(*flags);
 	if (work_is_canceling(work))
@@ -1169,7 +1168,7 @@ fail:
  * @extra_flags is or'd to work_struct flags.
  *
  * CONTEXT:
- * spin_lock_irq(gcwq->lock).
+ * spin_lock_irq(pool->lock).
  */
 static void insert_work(struct cpu_workqueue_struct *cwq,
 			struct work_struct *work, struct list_head *head,
@@ -1212,23 +1211,22 @@ static bool is_chained_work(struct workqueue_struct *wq)
 	for_each_gcwq_cpu(cpu) {
 		struct cpu_workqueue_struct *cwq = get_cwq(cpu, wq);
 		struct worker_pool *pool = cwq->pool;
-		struct global_cwq *gcwq = pool->gcwq;
 		struct worker *worker;
 		struct hlist_node *pos;
 		int i;
 
-		spin_lock_irqsave(&gcwq->lock, flags);
+		spin_lock_irqsave(&pool->lock, flags);
 		for_each_busy_worker(worker, i, pos, pool) {
 			if (worker->task != current)
 				continue;
-			spin_unlock_irqrestore(&gcwq->lock, flags);
+			spin_unlock_irqrestore(&pool->lock, flags);
 			/*
 			 * I'm @worker, no locking necessary.  See if @work
 			 * is headed to the same workqueue.
 			 */
 			return worker->current_cwq->wq == wq;
 		}
-		spin_unlock_irqrestore(&gcwq->lock, flags);
+		spin_unlock_irqrestore(&pool->lock, flags);
 	}
 	return false;
 }
@@ -1236,7 +1234,8 @@ static bool is_chained_work(struct workqueue_struct *wq)
 static void __queue_work(unsigned int cpu, struct workqueue_struct *wq,
 			 struct work_struct *work)
 {
-	struct global_cwq *gcwq;
+	bool highpri = wq->flags & WQ_HIGHPRI;
+	struct worker_pool *pool;
 	struct cpu_workqueue_struct *cwq;
 	struct list_head *worklist;
 	unsigned int work_flags;
@@ -1257,7 +1256,7 @@ static void __queue_work(unsigned int cpu, struct workqueue_struct *wq,
 	    WARN_ON_ONCE(!is_chained_work(wq)))
 		return;
 
-	/* determine gcwq to use */
+	/* determine pool to use */
 	if (!(wq->flags & WQ_UNBOUND)) {
 		struct worker_pool *last_pool;
 
@@ -1270,38 +1269,37 @@ static void __queue_work(unsigned int cpu, struct workqueue_struct *wq,
 		 * work needs to be queued on that cpu to guarantee
 		 * non-reentrancy.
 		 */
-		gcwq = get_gcwq(cpu);
+		pool = get_std_worker_pool(cpu, highpri);
 		last_pool = get_work_pool(work);
 
-		if (last_pool && last_pool->gcwq != gcwq) {
-			struct global_cwq *last_gcwq = last_pool->gcwq;
+		if (last_pool && last_pool != pool) {
 			struct worker *worker;
 
-			spin_lock(&last_gcwq->lock);
+			spin_lock(&last_pool->lock);
 
 			worker = find_worker_executing_work(last_pool, work);
 
 			if (worker && worker->current_cwq->wq == wq)
-				gcwq = last_gcwq;
+				pool = last_pool;
 			else {
 				/* meh... not running there, queue here */
-				spin_unlock(&last_gcwq->lock);
-				spin_lock(&gcwq->lock);
+				spin_unlock(&last_pool->lock);
+				spin_lock(&pool->lock);
 			}
 		} else {
-			spin_lock(&gcwq->lock);
+			spin_lock(&pool->lock);
 		}
 	} else {
-		gcwq = get_gcwq(WORK_CPU_UNBOUND);
-		spin_lock(&gcwq->lock);
+		pool = get_std_worker_pool(WORK_CPU_UNBOUND, highpri);
+		spin_lock(&pool->lock);
 	}
 
-	/* gcwq determined, get cwq and queue */
-	cwq = get_cwq(gcwq->pools[0].cpu, wq);
+	/* pool determined, get cwq and queue */
+	cwq = get_cwq(pool->cpu, wq);
 	trace_workqueue_queue_work(req_cpu, cwq, work);
 
 	if (WARN_ON(!list_empty(&work->entry))) {
-		spin_unlock(&gcwq->lock);
+		spin_unlock(&pool->lock);
 		return;
 	}
 
@@ -1319,7 +1317,7 @@ static void __queue_work(unsigned int cpu, struct workqueue_struct *wq,
 
 	insert_work(cwq, work, worklist, work_flags);
 
-	spin_unlock(&gcwq->lock);
+	spin_unlock(&pool->lock);
 }
 
 /**
@@ -1542,7 +1540,7 @@ EXPORT_SYMBOL_GPL(mod_delayed_work);
  * necessary.
  *
  * LOCKING:
- * spin_lock_irq(gcwq->lock).
+ * spin_lock_irq(pool->lock).
  */
 static void worker_enter_idle(struct worker *worker)
 {
@@ -1565,7 +1563,7 @@ static void worker_enter_idle(struct worker *worker)
 
 	/*
 	 * Sanity check nr_running.  Because gcwq_unbind_fn() releases
-	 * gcwq->lock between setting %WORKER_UNBOUND and zapping
+	 * pool->lock between setting %WORKER_UNBOUND and zapping
 	 * nr_running, the warning may trigger spuriously.  Check iff
 	 * unbind is not in progress.
 	 */
@@ -1581,7 +1579,7 @@ static void worker_enter_idle(struct worker *worker)
  * @worker is leaving idle state.  Update stats.
  *
  * LOCKING:
- * spin_lock_irq(gcwq->lock).
+ * spin_lock_irq(pool->lock).
  */
 static void worker_leave_idle(struct worker *worker)
 {
@@ -1616,7 +1614,7 @@ static void worker_leave_idle(struct worker *worker)
  * guarantee the scheduling requirement described in the first paragraph.
  *
  * CONTEXT:
- * Might sleep.  Called without any lock but returns with gcwq->lock
+ * Might sleep.  Called without any lock but returns with pool->lock
  * held.
  *
  * RETURNS:
@@ -1624,10 +1622,9 @@ static void worker_leave_idle(struct worker *worker)
  * bound), %false if offline.
  */
 static bool worker_maybe_bind_and_lock(struct worker *worker)
-__acquires(&gcwq->lock)
+__acquires(&pool->lock)
 {
 	struct worker_pool *pool = worker->pool;
-	struct global_cwq *gcwq = pool->gcwq;
 	struct task_struct *task = worker->task;
 
 	while (true) {
@@ -1640,14 +1637,14 @@ __acquires(&gcwq->lock)
 		if (!(pool->flags & POOL_DISASSOCIATED))
 			set_cpus_allowed_ptr(task, get_cpu_mask(pool->cpu));
 
-		spin_lock_irq(&gcwq->lock);
+		spin_lock_irq(&pool->lock);
 		if (pool->flags & POOL_DISASSOCIATED)
 			return false;
 		if (task_cpu(task) == pool->cpu &&
 		    cpumask_equal(&current->cpus_allowed,
 				  get_cpu_mask(pool->cpu)))
 			return true;
-		spin_unlock_irq(&gcwq->lock);
+		spin_unlock_irq(&pool->lock);
 
 		/*
 		 * We've raced with CPU hot[un]plug.  Give it a breather
@@ -1666,15 +1663,13 @@ __acquires(&gcwq->lock)
  */
 static void idle_worker_rebind(struct worker *worker)
 {
-	struct global_cwq *gcwq = worker->pool->gcwq;
-
 	/* CPU may go down again inbetween, clear UNBOUND only on success */
 	if (worker_maybe_bind_and_lock(worker))
 		worker_clr_flags(worker, WORKER_UNBOUND);
 
 	/* rebind complete, become available again */
 	list_add(&worker->entry, &worker->pool->idle_list);
-	spin_unlock_irq(&gcwq->lock);
+	spin_unlock_irq(&worker->pool->lock);
 }
 
 /*
@@ -1686,12 +1681,11 @@ static void idle_worker_rebind(struct worker *worker)
 static void busy_worker_rebind_fn(struct work_struct *work)
 {
 	struct worker *worker = container_of(work, struct worker, rebind_work);
-	struct global_cwq *gcwq = worker->pool->gcwq;
 
 	if (worker_maybe_bind_and_lock(worker))
 		worker_clr_flags(worker, WORKER_UNBOUND);
 
-	spin_unlock_irq(&gcwq->lock);
+	spin_unlock_irq(&worker->pool->lock);
 }
 
 /**
@@ -1723,10 +1717,10 @@ static void rebind_workers(struct global_cwq *gcwq)
 	struct hlist_node *pos;
 	int i;
 
-	lockdep_assert_held(&gcwq->lock);
-
-	for_each_worker_pool(pool, gcwq)
+	for_each_worker_pool(pool, gcwq) {
 		lockdep_assert_held(&pool->assoc_mutex);
+		lockdep_assert_held(&pool->lock);
+	}
 
 	/* dequeue and kick idle ones */
 	for_each_worker_pool(pool, gcwq) {
@@ -1804,19 +1798,18 @@ static struct worker *alloc_worker(void)
  */
 static struct worker *create_worker(struct worker_pool *pool)
 {
-	struct global_cwq *gcwq = pool->gcwq;
 	const char *pri = std_worker_pool_pri(pool) ? "H" : "";
 	struct worker *worker = NULL;
 	int id = -1;
 
-	spin_lock_irq(&gcwq->lock);
+	spin_lock_irq(&pool->lock);
 	while (ida_get_new(&pool->worker_ida, &id)) {
-		spin_unlock_irq(&gcwq->lock);
+		spin_unlock_irq(&pool->lock);
 		if (!ida_pre_get(&pool->worker_ida, GFP_KERNEL))
 			goto fail;
-		spin_lock_irq(&gcwq->lock);
+		spin_lock_irq(&pool->lock);
 	}
-	spin_unlock_irq(&gcwq->lock);
+	spin_unlock_irq(&pool->lock);
 
 	worker = alloc_worker();
 	if (!worker)
@@ -1857,9 +1850,9 @@ static struct worker *create_worker(struct worker_pool *pool)
 	return worker;
 fail:
 	if (id >= 0) {
-		spin_lock_irq(&gcwq->lock);
+		spin_lock_irq(&pool->lock);
 		ida_remove(&pool->worker_ida, id);
-		spin_unlock_irq(&gcwq->lock);
+		spin_unlock_irq(&pool->lock);
 	}
 	kfree(worker);
 	return NULL;
@@ -1872,7 +1865,7 @@ fail:
  * Make the gcwq aware of @worker and start it.
  *
  * CONTEXT:
- * spin_lock_irq(gcwq->lock).
+ * spin_lock_irq(pool->lock).
  */
 static void start_worker(struct worker *worker)
 {
@@ -1889,12 +1882,11 @@ static void start_worker(struct worker *worker)
  * Destroy @worker and adjust @gcwq stats accordingly.
  *
  * CONTEXT:
- * spin_lock_irq(gcwq->lock) which is released and regrabbed.
+ * spin_lock_irq(pool->lock) which is released and regrabbed.
  */
 static void destroy_worker(struct worker *worker)
 {
 	struct worker_pool *pool = worker->pool;
-	struct global_cwq *gcwq = pool->gcwq;
 	int id = worker->id;
 
 	/* sanity check frenzy */
@@ -1909,21 +1901,20 @@ static void destroy_worker(struct worker *worker)
 	list_del_init(&worker->entry);
 	worker->flags |= WORKER_DIE;
 
-	spin_unlock_irq(&gcwq->lock);
+	spin_unlock_irq(&pool->lock);
 
 	kthread_stop(worker->task);
 	kfree(worker);
 
-	spin_lock_irq(&gcwq->lock);
+	spin_lock_irq(&pool->lock);
 	ida_remove(&pool->worker_ida, id);
 }
 
 static void idle_worker_timeout(unsigned long __pool)
 {
 	struct worker_pool *pool = (void *)__pool;
-	struct global_cwq *gcwq = pool->gcwq;
 
-	spin_lock_irq(&gcwq->lock);
+	spin_lock_irq(&pool->lock);
 
 	if (too_many_workers(pool)) {
 		struct worker *worker;
@@ -1942,7 +1933,7 @@ static void idle_worker_timeout(unsigned long __pool)
 		}
 	}
 
-	spin_unlock_irq(&gcwq->lock);
+	spin_unlock_irq(&pool->lock);
 }
 
 static bool send_mayday(struct work_struct *work)
@@ -1967,10 +1958,9 @@ static bool send_mayday(struct work_struct *work)
 static void gcwq_mayday_timeout(unsigned long __pool)
 {
 	struct worker_pool *pool = (void *)__pool;
-	struct global_cwq *gcwq = pool->gcwq;
 	struct work_struct *work;
 
-	spin_lock_irq(&gcwq->lock);
+	spin_lock_irq(&pool->lock);
 
 	if (need_to_create_worker(pool)) {
 		/*
@@ -1983,7 +1973,7 @@ static void gcwq_mayday_timeout(unsigned long __pool)
 			send_mayday(work);
 	}
 
-	spin_unlock_irq(&gcwq->lock);
+	spin_unlock_irq(&pool->lock);
 
 	mod_timer(&pool->mayday_timer, jiffies + MAYDAY_INTERVAL);
 }
@@ -2002,24 +1992,22 @@ static void gcwq_mayday_timeout(unsigned long __pool)
  * may_start_working() true.
  *
  * LOCKING:
- * spin_lock_irq(gcwq->lock) which may be released and regrabbed
+ * spin_lock_irq(pool->lock) which may be released and regrabbed
  * multiple times.  Does GFP_KERNEL allocations.  Called only from
  * manager.
  *
  * RETURNS:
- * false if no action was taken and gcwq->lock stayed locked, true
+ * false if no action was taken and pool->lock stayed locked, true
  * otherwise.
  */
 static bool maybe_create_worker(struct worker_pool *pool)
-__releases(&gcwq->lock)
-__acquires(&gcwq->lock)
+__releases(&pool->lock)
+__acquires(&pool->lock)
 {
-	struct global_cwq *gcwq = pool->gcwq;
-
 	if (!need_to_create_worker(pool))
 		return false;
 restart:
-	spin_unlock_irq(&gcwq->lock);
+	spin_unlock_irq(&pool->lock);
 
 	/* if we don't make progress in MAYDAY_INITIAL_TIMEOUT, call for help */
 	mod_timer(&pool->mayday_timer, jiffies + MAYDAY_INITIAL_TIMEOUT);
@@ -2030,7 +2018,7 @@ restart:
 		worker = create_worker(pool);
 		if (worker) {
 			del_timer_sync(&pool->mayday_timer);
-			spin_lock_irq(&gcwq->lock);
+			spin_lock_irq(&pool->lock);
 			start_worker(worker);
 			BUG_ON(need_to_create_worker(pool));
 			return true;
@@ -2047,7 +2035,7 @@ restart:
 	}
 
 	del_timer_sync(&pool->mayday_timer);
-	spin_lock_irq(&gcwq->lock);
+	spin_lock_irq(&pool->lock);
 	if (need_to_create_worker(pool))
 		goto restart;
 	return true;
@@ -2061,11 +2049,11 @@ restart:
  * IDLE_WORKER_TIMEOUT.
  *
  * LOCKING:
- * spin_lock_irq(gcwq->lock) which may be released and regrabbed
+ * spin_lock_irq(pool->lock) which may be released and regrabbed
  * multiple times.  Called only from manager.
  *
  * RETURNS:
- * false if no action was taken and gcwq->lock stayed locked, true
+ * false if no action was taken and pool->lock stayed locked, true
  * otherwise.
  */
 static bool maybe_destroy_workers(struct worker_pool *pool)
@@ -2104,12 +2092,12 @@ static bool maybe_destroy_workers(struct worker_pool *pool)
  * and may_start_working() is true.
  *
  * CONTEXT:
- * spin_lock_irq(gcwq->lock) which may be released and regrabbed
+ * spin_lock_irq(pool->lock) which may be released and regrabbed
  * multiple times.  Does GFP_KERNEL allocations.
  *
  * RETURNS:
- * false if no action was taken and gcwq->lock stayed locked, true if
- * some action was taken.
+ * spin_lock_irq(pool->lock) which may be released and regrabbed
+ * multiple times.  Does GFP_KERNEL allocations.
  */
 static bool manage_workers(struct worker *worker)
 {
@@ -2131,10 +2119,10 @@ static bool manage_workers(struct worker *worker)
 	 * manager against CPU hotplug.
 	 *
 	 * assoc_mutex would always be free unless CPU hotplug is in
-	 * progress.  trylock first without dropping @gcwq->lock.
+	 * progress.  trylock first without dropping @pool->lock.
 	 */
 	if (unlikely(!mutex_trylock(&pool->assoc_mutex))) {
-		spin_unlock_irq(&pool->gcwq->lock);
+		spin_unlock_irq(&pool->lock);
 		mutex_lock(&pool->assoc_mutex);
 		/*
 		 * CPU hotplug could have happened while we were waiting
@@ -2181,15 +2169,14 @@ static bool manage_workers(struct worker *worker)
  * call this function to process a work.
  *
  * CONTEXT:
- * spin_lock_irq(gcwq->lock) which is released and regrabbed.
+ * spin_lock_irq(pool->lock) which is released and regrabbed.
  */
 static void process_one_work(struct worker *worker, struct work_struct *work)
-__releases(&gcwq->lock)
-__acquires(&gcwq->lock)
+__releases(&pool->lock)
+__acquires(&pool->lock)
 {
 	struct cpu_workqueue_struct *cwq = get_work_cwq(work);
 	struct worker_pool *pool = worker->pool;
-	struct global_cwq *gcwq = pool->gcwq;
 	bool cpu_intensive = cwq->wq->flags & WQ_CPU_INTENSIVE;
 	int work_color;
 	struct worker *collision;
@@ -2244,7 +2231,7 @@ __acquires(&gcwq->lock)
 		worker_set_flags(worker, WORKER_CPU_INTENSIVE, true);
 
 	/*
-	 * Unbound gcwq isn't concurrency managed and work items should be
+	 * Unbound pool isn't concurrency managed and work items should be
 	 * executed ASAP.  Wake up another worker if necessary.
 	 */
 	if ((worker->flags & WORKER_UNBOUND) && need_more_worker(pool))
@@ -2252,13 +2239,13 @@ __acquires(&gcwq->lock)
 
 	/*
 	 * Record the last pool and clear PENDING which should be the last
-	 * update to @work.  Also, do this inside @gcwq->lock so that
+	 * update to @work.  Also, do this inside @pool->lock so that
 	 * PENDING and queued state changes happen together while IRQ is
 	 * disabled.
 	 */
 	set_work_pool_and_clear_pending(work, pool->id);
 
-	spin_unlock_irq(&gcwq->lock);
+	spin_unlock_irq(&pool->lock);
 
 	lock_map_acquire_read(&cwq->wq->lockdep_map);
 	lock_map_acquire(&lockdep_map);
@@ -2281,7 +2268,7 @@ __acquires(&gcwq->lock)
 		dump_stack();
 	}
 
-	spin_lock_irq(&gcwq->lock);
+	spin_lock_irq(&pool->lock);
 
 	/* clear cpu intensive status */
 	if (unlikely(cpu_intensive))
@@ -2304,7 +2291,7 @@ __acquires(&gcwq->lock)
  * fetches a work from the top and executes it.
  *
  * CONTEXT:
- * spin_lock_irq(gcwq->lock) which may be released and regrabbed
+ * spin_lock_irq(pool->lock) which may be released and regrabbed
  * multiple times.
  */
 static void process_scheduled_works(struct worker *worker)
@@ -2330,16 +2317,15 @@ static int worker_thread(void *__worker)
 {
 	struct worker *worker = __worker;
 	struct worker_pool *pool = worker->pool;
-	struct global_cwq *gcwq = pool->gcwq;
 
 	/* tell the scheduler that this is a workqueue worker */
 	worker->task->flags |= PF_WQ_WORKER;
 woke_up:
-	spin_lock_irq(&gcwq->lock);
+	spin_lock_irq(&pool->lock);
 
 	/* we are off idle list if destruction or rebind is requested */
 	if (unlikely(list_empty(&worker->entry))) {
-		spin_unlock_irq(&gcwq->lock);
+		spin_unlock_irq(&pool->lock);
 
 		/* if DIE is set, destruction is requested */
 		if (worker->flags & WORKER_DIE) {
@@ -2398,15 +2384,15 @@ sleep:
 		goto recheck;
 
 	/*
-	 * gcwq->lock is held and there's no work to process and no
-	 * need to manage, sleep.  Workers are woken up only while
-	 * holding gcwq->lock or from local cpu, so setting the
-	 * current state before releasing gcwq->lock is enough to
-	 * prevent losing any event.
+	 * pool->lock is held and there's no work to process and no need to
+	 * manage, sleep.  Workers are woken up only while holding
+	 * pool->lock or from local cpu, so setting the current state
+	 * before releasing pool->lock is enough to prevent losing any
+	 * event.
 	 */
 	worker_enter_idle(worker);
 	__set_current_state(TASK_INTERRUPTIBLE);
-	spin_unlock_irq(&gcwq->lock);
+	spin_unlock_irq(&pool->lock);
 	schedule();
 	goto woke_up;
 }
@@ -2455,7 +2441,6 @@ repeat:
 		unsigned int tcpu = is_unbound ? WORK_CPU_UNBOUND : cpu;
 		struct cpu_workqueue_struct *cwq = get_cwq(tcpu, wq);
 		struct worker_pool *pool = cwq->pool;
-		struct global_cwq *gcwq = pool->gcwq;
 		struct work_struct *work, *n;
 
 		__set_current_state(TASK_RUNNING);
@@ -2477,14 +2462,14 @@ repeat:
 		process_scheduled_works(rescuer);
 
 		/*
-		 * Leave this gcwq.  If keep_working() is %true, notify a
+		 * Leave this pool.  If keep_working() is %true, notify a
 		 * regular worker; otherwise, we end up with 0 concurrency
 		 * and stalling the execution.
 		 */
 		if (keep_working(pool))
 			wake_up_worker(pool);
 
-		spin_unlock_irq(&gcwq->lock);
+		spin_unlock_irq(&pool->lock);
 	}
 
 	schedule();
@@ -2524,7 +2509,7 @@ static void wq_barrier_func(struct work_struct *work)
  * underneath us, so we can't reliably determine cwq from @target.
  *
  * CONTEXT:
- * spin_lock_irq(gcwq->lock).
+ * spin_lock_irq(pool->lock).
  */
 static void insert_wq_barrier(struct cpu_workqueue_struct *cwq,
 			      struct wq_barrier *barr,
@@ -2534,7 +2519,7 @@ static void insert_wq_barrier(struct cpu_workqueue_struct *cwq,
 	unsigned int linked = 0;
 
 	/*
-	 * debugobject calls are safe here even with gcwq->lock locked
+	 * debugobject calls are safe here even with pool->lock locked
 	 * as we know for sure that this will not trigger any of the
 	 * checks and call back into the fixup functions where we
 	 * might deadlock.
@@ -2607,9 +2592,9 @@ static bool flush_workqueue_prep_cwqs(struct workqueue_struct *wq,
 
 	for_each_cwq_cpu(cpu, wq) {
 		struct cpu_workqueue_struct *cwq = get_cwq(cpu, wq);
-		struct global_cwq *gcwq = cwq->pool->gcwq;
+		struct worker_pool *pool = cwq->pool;
 
-		spin_lock_irq(&gcwq->lock);
+		spin_lock_irq(&pool->lock);
 
 		if (flush_color >= 0) {
 			BUG_ON(cwq->flush_color != -1);
@@ -2626,7 +2611,7 @@ static bool flush_workqueue_prep_cwqs(struct workqueue_struct *wq,
 			cwq->work_color = work_color;
 		}
 
-		spin_unlock_irq(&gcwq->lock);
+		spin_unlock_irq(&pool->lock);
 	}
 
 	if (flush_color >= 0 && atomic_dec_and_test(&wq->nr_cwqs_to_flush))
@@ -2823,9 +2808,9 @@ reflush:
 		struct cpu_workqueue_struct *cwq = get_cwq(cpu, wq);
 		bool drained;
 
-		spin_lock_irq(&cwq->pool->gcwq->lock);
+		spin_lock_irq(&cwq->pool->lock);
 		drained = !cwq->nr_active && list_empty(&cwq->delayed_works);
-		spin_unlock_irq(&cwq->pool->gcwq->lock);
+		spin_unlock_irq(&cwq->pool->lock);
 
 		if (drained)
 			continue;
@@ -2848,25 +2833,23 @@ static bool start_flush_work(struct work_struct *work, struct wq_barrier *barr)
 {
 	struct worker *worker = NULL;
 	struct worker_pool *pool;
-	struct global_cwq *gcwq;
 	struct cpu_workqueue_struct *cwq;
 
 	might_sleep();
 	pool = get_work_pool(work);
 	if (!pool)
 		return false;
-	gcwq = pool->gcwq;
 
-	spin_lock_irq(&gcwq->lock);
+	spin_lock_irq(&pool->lock);
 	if (!list_empty(&work->entry)) {
 		/*
 		 * See the comment near try_to_grab_pending()->smp_rmb().
-		 * If it was re-queued to a different gcwq under us, we
+		 * If it was re-queued to a different pool under us, we
 		 * are not going to wait.
 		 */
 		smp_rmb();
 		cwq = get_work_cwq(work);
-		if (unlikely(!cwq || gcwq != cwq->pool->gcwq))
+		if (unlikely(!cwq || pool != cwq->pool))
 			goto already_gone;
 	} else {
 		worker = find_worker_executing_work(pool, work);
@@ -2876,7 +2859,7 @@ static bool start_flush_work(struct work_struct *work, struct wq_barrier *barr)
 	}
 
 	insert_wq_barrier(cwq, barr, work, worker);
-	spin_unlock_irq(&gcwq->lock);
+	spin_unlock_irq(&pool->lock);
 
 	/*
 	 * If @max_active is 1 or rescuer is in use, flushing another work
@@ -2892,7 +2875,7 @@ static bool start_flush_work(struct work_struct *work, struct wq_barrier *barr)
 
 	return true;
 already_gone:
-	spin_unlock_irq(&gcwq->lock);
+	spin_unlock_irq(&pool->lock);
 	return false;
 }
 
@@ -3413,7 +3396,7 @@ EXPORT_SYMBOL_GPL(destroy_workqueue);
  * increased.
  *
  * CONTEXT:
- * spin_lock_irq(gcwq->lock).
+ * spin_lock_irq(pool->lock).
  */
 static void cwq_set_max_active(struct cpu_workqueue_struct *cwq, int max_active)
 {
@@ -3447,15 +3430,14 @@ void workqueue_set_max_active(struct workqueue_struct *wq, int max_active)
 	for_each_cwq_cpu(cpu, wq) {
 		struct cpu_workqueue_struct *cwq = get_cwq(cpu, wq);
 		struct worker_pool *pool = cwq->pool;
-		struct global_cwq *gcwq = pool->gcwq;
 
-		spin_lock_irq(&gcwq->lock);
+		spin_lock_irq(&pool->lock);
 
 		if (!(wq->flags & WQ_FREEZABLE) ||
 		    !(pool->flags & POOL_FREEZING))
 			cwq_set_max_active(cwq, max_active);
 
-		spin_unlock_irq(&gcwq->lock);
+		spin_unlock_irq(&pool->lock);
 	}
 
 	spin_unlock(&workqueue_lock);
@@ -3498,22 +3480,20 @@ EXPORT_SYMBOL_GPL(workqueue_congested);
 unsigned int work_busy(struct work_struct *work)
 {
 	struct worker_pool *pool = get_work_pool(work);
-	struct global_cwq *gcwq;
 	unsigned long flags;
 	unsigned int ret = 0;
 
 	if (!pool)
 		return 0;
-	gcwq = pool->gcwq;
 
-	spin_lock_irqsave(&gcwq->lock, flags);
+	spin_lock_irqsave(&pool->lock, flags);
 
 	if (work_pending(work))
 		ret |= WORK_BUSY_PENDING;
 	if (find_worker_executing_work(pool, work))
 		ret |= WORK_BUSY_RUNNING;
 
-	spin_unlock_irqrestore(&gcwq->lock, flags);
+	spin_unlock_irqrestore(&pool->lock, flags);
 
 	return ret;
 }
@@ -3541,7 +3521,10 @@ static void gcwq_claim_assoc_and_lock(struct global_cwq *gcwq)
 
 	for_each_worker_pool(pool, gcwq)
 		mutex_lock_nested(&pool->assoc_mutex, pool - gcwq->pools);
-	spin_lock_irq(&gcwq->lock);
+
+	local_irq_disable();
+	for_each_worker_pool(pool, gcwq)
+		spin_lock_nested(&pool->lock, pool - gcwq->pools);
 }
 
 /* release manager positions */
@@ -3549,7 +3532,10 @@ static void gcwq_release_assoc_and_unlock(struct global_cwq *gcwq)
 {
 	struct worker_pool *pool;
 
-	spin_unlock_irq(&gcwq->lock);
+	for_each_worker_pool(pool, gcwq)
+		spin_unlock(&pool->lock);
+	local_irq_enable();
+
 	for_each_worker_pool(pool, gcwq)
 		mutex_unlock(&pool->assoc_mutex);
 }
@@ -3630,9 +3616,9 @@ static int __cpuinit workqueue_cpu_up_callback(struct notifier_block *nfb,
 			if (!worker)
 				return NOTIFY_BAD;
 
-			spin_lock_irq(&gcwq->lock);
+			spin_lock_irq(&pool->lock);
 			start_worker(worker);
-			spin_unlock_irq(&gcwq->lock);
+			spin_unlock_irq(&pool->lock);
 		}
 		break;
 
@@ -3718,7 +3704,7 @@ EXPORT_SYMBOL_GPL(work_on_cpu);
  * gcwq->worklist.
  *
  * CONTEXT:
- * Grabs and releases workqueue_lock and gcwq->lock's.
+ * Grabs and releases workqueue_lock and pool->lock's.
  */
 void freeze_workqueues_begin(void)
 {
@@ -3734,9 +3720,11 @@ void freeze_workqueues_begin(void)
 		struct worker_pool *pool;
 		struct workqueue_struct *wq;
 
-		spin_lock_irq(&gcwq->lock);
+		local_irq_disable();
 
 		for_each_worker_pool(pool, gcwq) {
+			spin_lock_nested(&pool->lock, pool - gcwq->pools);
+
 			WARN_ON_ONCE(pool->flags & POOL_FREEZING);
 			pool->flags |= POOL_FREEZING;
 		}
@@ -3748,7 +3736,9 @@ void freeze_workqueues_begin(void)
 				cwq->max_active = 0;
 		}
 
-		spin_unlock_irq(&gcwq->lock);
+		for_each_worker_pool(pool, gcwq)
+			spin_unlock(&pool->lock);
+		local_irq_enable();
 	}
 
 	spin_unlock(&workqueue_lock);
@@ -3807,7 +3797,7 @@ out_unlock:
  * frozen works are transferred to their respective gcwq worklists.
  *
  * CONTEXT:
- * Grabs and releases workqueue_lock and gcwq->lock's.
+ * Grabs and releases workqueue_lock and pool->lock's.
  */
 void thaw_workqueues(void)
 {
@@ -3823,9 +3813,11 @@ void thaw_workqueues(void)
 		struct worker_pool *pool;
 		struct workqueue_struct *wq;
 
-		spin_lock_irq(&gcwq->lock);
+		local_irq_disable();
 
 		for_each_worker_pool(pool, gcwq) {
+			spin_lock_nested(&pool->lock, pool - gcwq->pools);
+
 			WARN_ON_ONCE(!(pool->flags & POOL_FREEZING));
 			pool->flags &= ~POOL_FREEZING;
 		}
@@ -3840,10 +3832,11 @@ void thaw_workqueues(void)
 			cwq_set_max_active(cwq, wq->saved_max_active);
 		}
 
-		for_each_worker_pool(pool, gcwq)
+		for_each_worker_pool(pool, gcwq) {
 			wake_up_worker(pool);
-
-		spin_unlock_irq(&gcwq->lock);
+			spin_unlock(&pool->lock);
+		}
+		local_irq_enable();
 	}
 
 	workqueue_freezing = false;
@@ -3868,10 +3861,9 @@ static int __init init_workqueues(void)
 		struct global_cwq *gcwq = get_gcwq(cpu);
 		struct worker_pool *pool;
 
-		spin_lock_init(&gcwq->lock);
-
 		for_each_worker_pool(pool, gcwq) {
 			pool->gcwq = gcwq;
+			spin_lock_init(&pool->lock);
 			pool->cpu = cpu;
 			pool->flags |= POOL_DISASSOCIATED;
 			INIT_LIST_HEAD(&pool->worklist);
@@ -3906,9 +3898,9 @@ static int __init init_workqueues(void)
 
 			worker = create_worker(pool);
 			BUG_ON(!worker);
-			spin_lock_irq(&gcwq->lock);
+			spin_lock_irq(&pool->lock);
 			start_worker(worker);
-			spin_unlock_irq(&gcwq->lock);
+			spin_unlock_irq(&pool->lock);
 		}
 	}
 
-- 
1.8.0.2

