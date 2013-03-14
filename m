Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753805Ab3CNXBq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 19:01:46 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:56209 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753718Ab3CNXBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 19:01:43 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: laijs@cn.fujitsu.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 4/5] workqueue: directly restore CPU affinity of workers from CPU_ONLINE
Date: Thu, 14 Mar 2013 16:01:29 -0700
Message-Id: <1363302090-16117-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1363302090-16117-1-git-send-email-tj@kernel.org>
References: <1363302090-16117-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rebinding workers of a per-cpu pool after a CPU comes online involves
a lot of back-and-forth mostly because only the task itself could
adjust CPU affinity if PF_THREAD_BOUND was set.

As CPU_ONLINE itself couldn't adjust affinity, it had to somehow
coerce the workers themselves to perform set_cpus_allowed_ptr().  Due
to the various states a worker can be in, this led to three different
paths a worker may be rebound.  worker->rebind_work is queued to busy
workers.  Idle ones are signaled by unlinking worker->entry and call
idle_worker_rebind().  The manager isn't covered by either and
implements its own mechanism.

PF_THREAD_BOUND has been relaced with PF_NO_SETAFFINITY and CPU_ONLINE
itself now can manipulate CPU affinity of workers.  This patch
replaces the existing rebind mechanism with direct one where
CPU_ONLINE iterates over all workers using for_each_pool_worker(),
restores CPU affinity, and clears WORKER_UNBOUND.

There are a couple subtleties.  All bound idle workers should have
their runqueues set to that of the bound CPU; however, if the target
task isn't running, set_cpus_allowed_ptr() just updates the
cpus_allowed mask deferring the actual migration to when the task
wakes up.  This is worked around by waking up idle workers after
restoring CPU affinity before any workers can become bound.

Another subtlety is stems from matching @pool->nr_running with the
number of running unbound workers.  While DISASSOCIATED, all workers
are unbound and nr_running is zero.  As workers become bound again,
nr_running needs to be adjusted accordingly; however, there is no good
way to tell whether a given worker is running without poking into
scheduler internals.  Instead of clearing UNBOUND directly,
rebind_workers() replaces UNBOUND with another new NOT_RUNNING flag -
REBOUND, which will later be cleared by the workers themselves while
preparing for the next round of work item execution.  The only change
needed for the workers is clearing REBOUND along with PREP.

* This patch leaves for_each_busy_worker() without any user.  Removed.

* idle_worker_rebind(), busy_worker_rebind_fn(), worker->rebind_work
  and rebind logic in manager_workers() removed.

* worker_thread() now looks at WORKER_DIE instead of testing whether
  @worker->entry is empty to determine whether it needs to do
  something special as dying is the only special thing now.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c          | 192 +++++++++++++++-----------------------------
 kernel/workqueue_internal.h |   3 -
 2 files changed, 64 insertions(+), 131 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 3e297c5..9508b5e 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -75,9 +75,10 @@ enum {
 	WORKER_PREP		= 1 << 3,	/* preparing to run works */
 	WORKER_CPU_INTENSIVE	= 1 << 6,	/* cpu intensive */
 	WORKER_UNBOUND		= 1 << 7,	/* worker is unbound */
+	WORKER_REBOUND		= 1 << 8,	/* worker was rebound */
 
-	WORKER_NOT_RUNNING	= WORKER_PREP | WORKER_UNBOUND |
-				  WORKER_CPU_INTENSIVE,
+	WORKER_NOT_RUNNING	= WORKER_PREP | WORKER_CPU_INTENSIVE |
+				  WORKER_UNBOUND | WORKER_REBOUND,
 
 	NR_STD_WORKER_POOLS	= 2,		/* # standard pools per cpu */
 
@@ -316,9 +317,6 @@ static void copy_workqueue_attrs(struct workqueue_attrs *to,
 	     (pool) < &per_cpu(cpu_worker_pools, cpu)[NR_STD_WORKER_POOLS]; \
 	     (pool)++)
 
-#define for_each_busy_worker(worker, i, pool)				\
-	hash_for_each(pool->busy_hash, i, worker, hentry)
-
 /**
  * for_each_pool - iterate through all worker_pools in the system
  * @pool: iteration cursor
@@ -1612,37 +1610,6 @@ __acquires(&pool->lock)
 	}
 }
 
-/*
- * Rebind an idle @worker to its CPU.  worker_thread() will test
- * list_empty(@worker->entry) before leaving idle and call this function.
- */
-static void idle_worker_rebind(struct worker *worker)
-{
-	/* CPU may go down again inbetween, clear UNBOUND only on success */
-	if (worker_maybe_bind_and_lock(worker->pool))
-		worker_clr_flags(worker, WORKER_UNBOUND);
-
-	/* rebind complete, become available again */
-	list_add(&worker->entry, &worker->pool->idle_list);
-	spin_unlock_irq(&worker->pool->lock);
-}
-
-/*
- * Function for @worker->rebind.work used to rebind unbound busy workers to
- * the associated cpu which is coming back online.  This is scheduled by
- * cpu up but can race with other cpu hotplug operations and may be
- * executed twice without intervening cpu down.
- */
-static void busy_worker_rebind_fn(struct work_struct *work)
-{
-	struct worker *worker = container_of(work, struct worker, rebind_work);
-
-	if (worker_maybe_bind_and_lock(worker->pool))
-		worker_clr_flags(worker, WORKER_UNBOUND);
-
-	spin_unlock_irq(&worker->pool->lock);
-}
-
 static struct worker *alloc_worker(void)
 {
 	struct worker *worker;
@@ -1651,7 +1618,6 @@ static struct worker *alloc_worker(void)
 	if (worker) {
 		INIT_LIST_HEAD(&worker->entry);
 		INIT_LIST_HEAD(&worker->scheduled);
-		INIT_WORK(&worker->rebind_work, busy_worker_rebind_fn);
 		/* on creation a worker is in !idle && prep state */
 		worker->flags = WORKER_PREP;
 	}
@@ -2053,22 +2019,6 @@ static bool manage_workers(struct worker *worker)
 	if (unlikely(!mutex_trylock(&pool->manager_mutex))) {
 		spin_unlock_irq(&pool->lock);
 		mutex_lock(&pool->manager_mutex);
-		/*
-		 * CPU hotplug could have happened while we were waiting
-		 * for assoc_mutex.  Hotplug itself can't handle us
-		 * because manager isn't either on idle or busy list, and
-		 * @pool's state and ours could have deviated.
-		 *
-		 * As hotplug is now excluded via manager_mutex, we can
-		 * simply try to bind.  It will succeed or fail depending
-		 * on @pool's current state.  Try it and adjust
-		 * %WORKER_UNBOUND accordingly.
-		 */
-		if (worker_maybe_bind_and_lock(pool))
-			worker->flags &= ~WORKER_UNBOUND;
-		else
-			worker->flags |= WORKER_UNBOUND;
-
 		ret = true;
 	}
 
@@ -2252,19 +2202,12 @@ static int worker_thread(void *__worker)
 woke_up:
 	spin_lock_irq(&pool->lock);
 
-	/* we are off idle list if destruction or rebind is requested */
-	if (unlikely(list_empty(&worker->entry))) {
+	/* am I supposed to die? */
+	if (unlikely(worker->flags & WORKER_DIE)) {
 		spin_unlock_irq(&pool->lock);
-
-		/* if DIE is set, destruction is requested */
-		if (worker->flags & WORKER_DIE) {
-			worker->task->flags &= ~PF_WQ_WORKER;
-			return 0;
-		}
-
-		/* otherwise, rebind */
-		idle_worker_rebind(worker);
-		goto woke_up;
+		WARN_ON_ONCE(!list_empty(&worker->entry));
+		worker->task->flags &= ~PF_WQ_WORKER;
+		return 0;
 	}
 
 	worker_leave_idle(worker);
@@ -2285,11 +2228,13 @@ recheck:
 	WARN_ON_ONCE(!list_empty(&worker->scheduled));
 
 	/*
-	 * When control reaches this point, we're guaranteed to have
-	 * at least one idle worker or that someone else has already
-	 * assumed the manager role.
+	 * Finish PREP stage.  We're guaranteed to have at least one idle
+	 * worker or that someone else has already assumed the manager
+	 * role.  This is where @worker starts participating in concurrency
+	 * management if applicable and concurrency management is restored
+	 * after being rebound.  See rebind_workers() for details.
 	 */
-	worker_clr_flags(worker, WORKER_PREP);
+	worker_clr_flags(worker, WORKER_PREP | WORKER_REBOUND);
 
 	do {
 		struct work_struct *work =
@@ -4076,7 +4021,7 @@ static void wq_unbind_fn(struct work_struct *work)
 	int cpu = smp_processor_id();
 	struct worker_pool *pool;
 	struct worker *worker;
-	int i;
+	int wi;
 
 	for_each_cpu_worker_pool(pool, cpu) {
 		WARN_ON_ONCE(cpu != smp_processor_id());
@@ -4091,10 +4036,7 @@ static void wq_unbind_fn(struct work_struct *work)
 		 * before the last CPU down must be on the cpu.  After
 		 * this, they may become diasporas.
 		 */
-		list_for_each_entry(worker, &pool->idle_list, entry)
-			worker->flags |= WORKER_UNBOUND;
-
-		for_each_busy_worker(worker, i, pool)
+		for_each_pool_worker(worker, wi, pool)
 			worker->flags |= WORKER_UNBOUND;
 
 		pool->flags |= POOL_DISASSOCIATED;
@@ -4129,71 +4071,64 @@ static void wq_unbind_fn(struct work_struct *work)
  * rebind_workers - rebind all workers of a pool to the associated CPU
  * @pool: pool of interest
  *
- * @pool->cpu is coming online.  Rebind all workers to the CPU.  Rebinding
- * is different for idle and busy ones.
- *
- * Idle ones will be removed from the idle_list and woken up.  They will
- * add themselves back after completing rebind.  This ensures that the
- * idle_list doesn't contain any unbound workers when re-bound busy workers
- * try to perform local wake-ups for concurrency management.
- *
- * Busy workers can rebind after they finish their current work items.
- * Queueing the rebind work item at the head of the scheduled list is
- * enough.  Note that nr_running will be properly bumped as busy workers
- * rebind.
- *
- * On return, all non-manager workers are scheduled for rebind - see
- * manage_workers() for the manager special case.  Any idle worker
- * including the manager will not appear on @idle_list until rebind is
- * complete, making local wake-ups safe.
+ * @pool->cpu is coming online.  Rebind all workers to the CPU.
  */
 static void rebind_workers(struct worker_pool *pool)
 {
-	struct worker *worker, *n;
-	int i;
+	struct worker *worker;
+	int wi;
 
 	lockdep_assert_held(&pool->manager_mutex);
-	lockdep_assert_held(&pool->lock);
-
-	/* dequeue and kick idle ones */
-	list_for_each_entry_safe(worker, n, &pool->idle_list, entry) {
-		/*
-		 * idle workers should be off @pool->idle_list until rebind
-		 * is complete to avoid receiving premature local wake-ups.
-		 */
-		list_del_init(&worker->entry);
 
-		/*
-		 * worker_thread() will see the above dequeuing and call
-		 * idle_worker_rebind().
-		 */
-		wake_up_process(worker->task);
-	}
-
-	/* rebind busy workers */
-	for_each_busy_worker(worker, i, pool) {
-		struct work_struct *rebind_work = &worker->rebind_work;
-		struct workqueue_struct *wq;
+	/*
+	 * Restore CPU affinity of all workers.  As all idle workers should
+	 * be on the run-queue of the associated CPU before any local
+	 * wake-ups for concurrency management happen, restore CPU affinty
+	 * of all workers first and then clear UNBOUND.  As we're called
+	 * from CPU_ONLINE, the following shouldn't fail.
+	 */
+	for_each_pool_worker(worker, wi, pool)
+		WARN_ON_ONCE(set_cpus_allowed_ptr(worker->task,
+						  pool->attrs->cpumask) < 0);
 
-		if (test_and_set_bit(WORK_STRUCT_PENDING_BIT,
-				     work_data_bits(rebind_work)))
-			continue;
+	spin_lock_irq(&pool->lock);
 
-		debug_work_activate(rebind_work);
+	for_each_pool_worker(worker, wi, pool) {
+		unsigned int worker_flags = worker->flags;
 
 		/*
-		 * wq doesn't really matter but let's keep @worker->pool
-		 * and @pwq->pool consistent for sanity.
+		 * A bound idle worker should actually be on the runqueue
+		 * of the associated CPU for local wake-ups targeting it to
+		 * work.  Kick all idle workers so that they migrate to the
+		 * associated CPU.  Doing this in the same loop as
+		 * replacing UNBOUND with REBOUND is safe as no worker will
+		 * be bound before @pool->lock is released.
 		 */
-		if (worker->pool->attrs->nice < 0)
-			wq = system_highpri_wq;
-		else
-			wq = system_wq;
+		if (worker_flags & WORKER_IDLE)
+			wake_up_process(worker->task);
 
-		insert_work(per_cpu_ptr(wq->cpu_pwqs, pool->cpu), rebind_work,
-			    worker->scheduled.next,
-			    work_color_to_flags(WORK_NO_COLOR));
+		/*
+		 * We want to clear UNBOUND but can't directly call
+		 * worker_clr_flags() or adjust nr_running.  Atomically
+		 * replace UNBOUND with another NOT_RUNNING flag REBOUND.
+		 * @worker will clear REBOUND using worker_clr_flags() when
+		 * it initiates the next execution cycle thus restoring
+		 * concurrency management.  Note that when or whether
+		 * @worker clears REBOUND doesn't affect correctness.
+		 *
+		 * ACCESS_ONCE() is necessary because @worker->flags may be
+		 * tested without holding any lock in
+		 * wq_worker_waking_up().  Without it, NOT_RUNNING test may
+		 * fail incorrectly leading to premature concurrency
+		 * management operations.
+		 */
+		WARN_ON_ONCE(!(worker_flags & WORKER_UNBOUND));
+		worker_flags |= WORKER_REBOUND;
+		worker_flags &= ~WORKER_UNBOUND;
+		ACCESS_ONCE(worker->flags) = worker_flags;
 	}
+
+	spin_unlock_irq(&pool->lock);
 }
 
 /*
@@ -4221,12 +4156,13 @@ static int __cpuinit workqueue_cpu_up_callback(struct notifier_block *nfb,
 	case CPU_ONLINE:
 		for_each_cpu_worker_pool(pool, cpu) {
 			mutex_lock(&pool->manager_mutex);
-			spin_lock_irq(&pool->lock);
 
+			spin_lock_irq(&pool->lock);
 			pool->flags &= ~POOL_DISASSOCIATED;
+			spin_unlock_irq(&pool->lock);
+
 			rebind_workers(pool);
 
-			spin_unlock_irq(&pool->lock);
 			mutex_unlock(&pool->manager_mutex);
 		}
 		break;
diff --git a/kernel/workqueue_internal.h b/kernel/workqueue_internal.h
index f116f07..84ab6e1 100644
--- a/kernel/workqueue_internal.h
+++ b/kernel/workqueue_internal.h
@@ -38,9 +38,6 @@ struct worker {
 	unsigned int		flags;		/* X: flags */
 	int			id;		/* I: worker id */
 
-	/* for rebinding worker to CPU */
-	struct work_struct	rebind_work;	/* L: for busy worker */
-
 	/* used only by rescuers to point to the target workqueue */
 	struct workqueue_struct	*rescue_wq;	/* I: the workqueue to rescue */
 };
-- 
1.8.1.4

