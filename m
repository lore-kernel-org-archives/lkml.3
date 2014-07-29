Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753153AbaG2JPN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 05:15:13 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:3832 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750746AbaG2JPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 05:15:06 -0400
X-IronPort-AV: E=Sophos;i="5.00,986,1396972800"; 
   d="scan'208";a="33906447"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>
CC: Tejun Heo <tj@kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH RFC 2/2 V2] workqueue: use dedicated creater kthread for all pools
Date: Tue, 29 Jul 2014 17:16:07 +0800
Message-ID: <1406625376-19177-1-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <20140729021643.GA22241@mtj.dyndns.org>
References: <20140729021643.GA22241@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are some problems with the managers:
  1) The last idle worker prefer managing to processing.
     It is better that the processing of work items should be the first
     priority to make the whole system make progress earlier.
  2) each pool always needs an additional idle worker, it is just wasting.
  3) managers among different pools can be parallel, but actually
     their major work are serialized on the kernel thread "kthreadd".
     These managers are sleeping and wasted when the system is lack
     of memory.
  4) it causes much complication and tricky when manager is implemented
     inside worker

This patch introduces a dedicated creater kthread which offloads the
managing from the workers, thus every worker makes effort to process work
rather than create worker. And there is no idle worker nor manager wasting
on sleeping.  And all the manager code is removed.  This dedicated creater
kthread causes a little more work serialized than before, but it is
acceptable since their major works are already serialized.

We introduce the kthread_work creater_work which calls create_worker()
to create a worker and the start_creater_work() which starts the
mayday_timer and the creater_work when needed and the pool->creating
which handles the exclusion for the mayday_timer and the creater_work.

We create worker only when the worklist has work items pending but no
idle worker ready.  So start_creater_work() is only called on
insert_work() or the last idle does go to busy with other work items
remained.  And we don't create worker when init_workqueues() nor
get_unbound_pool() nor CPU_UP_PREPARE nor the last idle worker leaves
idle any more, it saves code and unneeded workers.

put_unbound_pool() groups code by functionality not by the name, it
stops creation activity (creater_work, mayday_timer) at first and then
stops idle workers and idle_timer.

(1/2 patch is the 1/3 patch of the v1, so it is not resent.)

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |  238 ++++++++++++++--------------------------------------
 1 files changed, 63 insertions(+), 175 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 1d44d8d..03e253f 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -153,16 +153,16 @@ struct worker_pool {
 	struct timer_list	idle_timer;	/* L: worker idle timeout */
 	struct timer_list	mayday_timer;	/* L: SOS timer for workers */
 
-	/* a workers is either on busy_hash or idle_list, or the manager */
+	/* a workers is either on busy_hash or idle_list */
 	DECLARE_HASHTABLE(busy_hash, BUSY_WORKER_HASH_ORDER);
 						/* L: hash of busy workers */
 
-	/* see manage_workers() for details on the two manager mutexes */
-	struct mutex		manager_arb;	/* manager arbitration */
 	struct mutex		attach_mutex;	/* attach/detach exclusion */
 	struct list_head	workers;	/* A: attached workers */
 	struct completion	*detach_completion; /* all workers detached */
 
+	struct kthread_work	creater_work;	/* L: work for creating a new worker */
+	bool			creating;	/* L: creater_work is busy */
 	struct ida		worker_ida;	/* worker IDs for task name */
 
 	struct workqueue_attrs	*attrs;		/* I: worker attributes */
@@ -291,6 +291,10 @@ static DEFINE_SPINLOCK(wq_mayday_lock);	/* protects wq->maydays list */
 static LIST_HEAD(workqueues);		/* PL: list of all workqueues */
 static bool workqueue_freezing;		/* PL: have wqs started freezing? */
 
+/* kthread worker for creating workers for pools */
+static DEFINE_KTHREAD_WORKER(kworker_creater);
+static struct task_struct *kworker_creater_thread __read_mostly;
+
 /* the per-cpu worker pools */
 static DEFINE_PER_CPU_SHARED_ALIGNED(struct worker_pool [NR_STD_WORKER_POOLS],
 				     cpu_worker_pools);
@@ -731,12 +735,6 @@ static bool need_more_worker(struct worker_pool *pool)
 	return !list_empty(&pool->worklist) && __need_more_worker(pool);
 }
 
-/* Can I start working?  Called from busy but !running workers. */
-static bool may_start_working(struct worker_pool *pool)
-{
-	return pool->nr_idle;
-}
-
 /* Do I need to keep working?  Called from currently running workers. */
 static bool keep_working(struct worker_pool *pool)
 {
@@ -744,17 +742,10 @@ static bool keep_working(struct worker_pool *pool)
 		atomic_read(&pool->nr_running) <= 1;
 }
 
-/* Do we need a new worker?  Called from manager. */
-static bool need_to_create_worker(struct worker_pool *pool)
-{
-	return need_more_worker(pool) && !may_start_working(pool);
-}
-
 /* Do we have too many workers and should some go away? */
 static bool too_many_workers(struct worker_pool *pool)
 {
-	bool managing = mutex_is_locked(&pool->manager_arb);
-	int nr_idle = pool->nr_idle + managing; /* manager is considered idle */
+	int nr_idle = pool->nr_idle;
 	int nr_busy = pool->nr_workers - nr_idle;
 
 	return nr_idle > 2 && (nr_idle - 2) * MAX_IDLE_WORKERS_RATIO >= nr_busy;
@@ -1228,6 +1219,21 @@ fail:
 	return -EAGAIN;
 }
 
+/* Start the mayday timer and the creater when needed */
+static inline void start_creater_work(struct worker_pool *pool)
+{
+	if (pool->nr_idle || pool->creating || list_empty(&pool->worklist))
+		return;
+
+	pool->creating = true;
+	pool->mayday_timer.expires = jiffies + MAYDAY_INITIAL_TIMEOUT;
+	if (pool->flags & POOL_DISASSOCIATED)
+		add_timer(&pool->mayday_timer);
+	else
+		add_timer_on(&pool->mayday_timer, pool->cpu);
+	queue_kthread_work(&kworker_creater, &pool->creater_work);
+}
+
 /**
  * insert_work - insert a work into a pool
  * @pwq: pwq @work belongs to
@@ -1249,6 +1255,7 @@ static void insert_work(struct pool_workqueue *pwq, struct work_struct *work,
 	/* we own @work, set data and link */
 	set_work_pwq(work, pwq, extra_flags);
 	list_add_tail(&work->entry, head);
+	start_creater_work(pool);
 	get_pwq(pwq);
 
 	/*
@@ -1658,18 +1665,17 @@ static void worker_detach_from_pool(struct worker *worker,
 
 /**
  * create_worker - create a new workqueue worker
- * @pool: pool the new worker will belong to
+ * @work: the struct kthread_work creater_work of the target pool
  *
- * Create and start a new worker which is attached to @pool.
+ * Create and start a new worker which is attached to the target pool.
  *
  * CONTEXT:
  * Might sleep.  Does GFP_KERNEL allocations.
- *
- * Return:
- * Pointer to the newly created worker.
  */
-static struct worker *create_worker(struct worker_pool *pool)
+static void create_worker(struct kthread_work *work)
 {
+	struct worker_pool *pool = container_of(work, struct worker_pool,
+						creater_work);
 	struct worker *worker = NULL;
 	int id = -1;
 	char id_buf[16];
@@ -1697,6 +1703,8 @@ static struct worker *create_worker(struct worker_pool *pool)
 	if (IS_ERR(worker->task))
 		goto fail;
 
+	del_timer_sync(&pool->mayday_timer);
+
 	set_user_nice(worker->task, pool->attrs->nice);
 
 	/* prevent userland from meddling with cpumask of workqueue workers */
@@ -1715,15 +1723,24 @@ static struct worker *create_worker(struct worker_pool *pool)
 	 */
 	wake_up_process(worker->task);
 	worker_enter_idle(worker);
+	pool->creating = false;
 	spin_unlock_irq(&pool->lock);
 
-	return worker;
+	return;
 
 fail:
 	if (id >= 0)
 		ida_simple_remove(&pool->worker_ida, id);
 	kfree(worker);
-	return NULL;
+
+	/* cool down before next create_worker() */
+	schedule_timeout_interruptible(CREATE_COOLDOWN);
+	del_timer_sync(&pool->mayday_timer);
+
+	spin_lock_irq(&pool->lock);
+	pool->creating = false;
+	start_creater_work(pool);
+	spin_unlock_irq(&pool->lock);
 }
 
 /**
@@ -1812,7 +1829,7 @@ static void pool_mayday_timeout(unsigned long __pool)
 	spin_lock_irq(&wq_mayday_lock);		/* for wq->maydays */
 	spin_lock(&pool->lock);
 
-	if (need_to_create_worker(pool)) {
+	if (!pool->nr_idle && need_more_worker(pool)) {
 		/*
 		 * We've been trying to create a new worker but
 		 * haven't been successful.  We might be hitting an
@@ -1830,109 +1847,6 @@ static void pool_mayday_timeout(unsigned long __pool)
 }
 
 /**
- * maybe_create_worker - create a new worker if necessary
- * @pool: pool to create a new worker for
- *
- * Create a new worker for @pool if necessary.  @pool is guaranteed to
- * have at least one idle worker on return from this function.  If
- * creating a new worker takes longer than MAYDAY_INTERVAL, mayday is
- * sent to all rescuers with works scheduled on @pool to resolve
- * possible allocation deadlock.
- *
- * On return, need_to_create_worker() is guaranteed to be %false and
- * may_start_working() %true.
- *
- * LOCKING:
- * spin_lock_irq(pool->lock) which may be released and regrabbed
- * multiple times.  Does GFP_KERNEL allocations.  Called only from
- * manager.
- *
- * Return:
- * %false if no action was taken and pool->lock stayed locked, %true
- * otherwise.
- */
-static bool maybe_create_worker(struct worker_pool *pool)
-__releases(&pool->lock)
-__acquires(&pool->lock)
-{
-	if (!need_to_create_worker(pool))
-		return false;
-restart:
-	spin_unlock_irq(&pool->lock);
-
-	/* if we don't make progress in MAYDAY_INITIAL_TIMEOUT, call for help */
-	mod_timer(&pool->mayday_timer, jiffies + MAYDAY_INITIAL_TIMEOUT);
-
-	while (true) {
-		if (create_worker(pool) || !need_to_create_worker(pool))
-			break;
-
-		schedule_timeout_interruptible(CREATE_COOLDOWN);
-
-		if (!need_to_create_worker(pool))
-			break;
-	}
-
-	del_timer_sync(&pool->mayday_timer);
-	spin_lock_irq(&pool->lock);
-	/*
-	 * This is necessary even after a new worker was just successfully
-	 * created as @pool->lock was dropped and the new worker might have
-	 * already become busy.
-	 */
-	if (need_to_create_worker(pool))
-		goto restart;
-	return true;
-}
-
-/**
- * manage_workers - manage worker pool
- * @worker: self
- *
- * Assume the manager role and manage the worker pool @worker belongs
- * to.  At any given time, there can be only zero or one manager per
- * pool.  The exclusion is handled automatically by this function.
- *
- * The caller can safely start processing works on false return.  On
- * true return, it's guaranteed that need_to_create_worker() is false
- * and may_start_working() is true.
- *
- * CONTEXT:
- * spin_lock_irq(pool->lock) which may be released and regrabbed
- * multiple times.  Does GFP_KERNEL allocations.
- *
- * Return:
- * %false if the pool don't need management and the caller can safely start
- * processing works, %true indicates that the function released pool->lock
- * and reacquired it to perform some management function and that the
- * conditions that the caller verified while holding the lock before
- * calling the function might no longer be true.
- */
-static bool manage_workers(struct worker *worker)
-{
-	struct worker_pool *pool = worker->pool;
-	bool ret = false;
-
-	/*
-	 * Anyone who successfully grabs manager_arb wins the arbitration
-	 * and becomes the manager.  mutex_trylock() on pool->manager_arb
-	 * failure while holding pool->lock reliably indicates that someone
-	 * else is managing the pool and the worker which failed trylock
-	 * can proceed to executing work items.  This means that anyone
-	 * grabbing manager_arb is responsible for actually performing
-	 * manager duties.  If manager_arb is grabbed and released without
-	 * actual management, the pool may stall indefinitely.
-	 */
-	if (!mutex_trylock(&pool->manager_arb))
-		return ret;
-
-	ret |= maybe_create_worker(pool);
-
-	mutex_unlock(&pool->manager_arb);
-	return ret;
-}
-
-/**
  * process_one_work - process single work
  * @worker: self
  * @work: work to process
@@ -1991,6 +1905,7 @@ __acquires(&pool->lock)
 	work_color = get_work_color(work);
 
 	list_del_init(&work->entry);
+	start_creater_work(pool);
 
 	/*
 	 * CPU intensive works don't participate in concurrency management.
@@ -2123,15 +2038,11 @@ woke_up:
 	}
 
 	worker_leave_idle(worker);
-recheck:
+
 	/* no more worker necessary? */
 	if (!need_more_worker(pool))
 		goto sleep;
 
-	/* do we need to manage? */
-	if (unlikely(!may_start_working(pool)) && manage_workers(worker))
-		goto recheck;
-
 	/*
 	 * ->scheduled list can only be filled while a worker is
 	 * preparing to process a work or actually processing it.
@@ -2140,11 +2051,9 @@ recheck:
 	WARN_ON_ONCE(!list_empty(&worker->scheduled));
 
 	/*
-	 * Finish PREP stage.  We're guaranteed to have at least one idle
-	 * worker or that someone else has already assumed the manager
-	 * role.  This is where @worker starts participating in concurrency
-	 * management if applicable and concurrency management is restored
-	 * after being rebound.  See rebind_workers() for details.
+	 * Finish PREP stage. This is where @worker starts participating in
+	 * concurrency management if applicable and concurrency management is
+	 * restored after being rebound.  See rebind_workers() for details.
 	 */
 	worker_clr_flags(worker, WORKER_PREP | WORKER_REBOUND);
 
@@ -3355,10 +3264,10 @@ static int init_worker_pool(struct worker_pool *pool)
 	setup_timer(&pool->mayday_timer, pool_mayday_timeout,
 		    (unsigned long)pool);
 
-	mutex_init(&pool->manager_arb);
 	mutex_init(&pool->attach_mutex);
 	INIT_LIST_HEAD(&pool->workers);
 
+	init_kthread_work(&pool->creater_work, create_worker);
 	ida_init(&pool->worker_ida);
 	INIT_HLIST_NODE(&pool->hash_node);
 	pool->refcnt = 1;
@@ -3410,19 +3319,19 @@ static void put_unbound_pool(struct worker_pool *pool)
 		idr_remove(&worker_pool_idr, pool->id);
 	hash_del(&pool->hash_node);
 
-	/*
-	 * Become the manager and destroy all workers.  Grabbing
-	 * manager_arb prevents @pool's workers from blocking on
-	 * attach_mutex.
-	 */
-	mutex_lock(&pool->manager_arb);
+	/* wait for unfinished creating and shut down the mayday timer */
+	flush_kthread_work(&pool->creater_work);
+	del_timer_sync(&pool->mayday_timer);
 
+	/* all workers are anchored in idle_list, destroy them all at once */
 	spin_lock_irq(&pool->lock);
 	while ((worker = first_idle_worker(pool)))
 		destroy_worker(worker);
 	WARN_ON(pool->nr_workers || pool->nr_idle);
 	spin_unlock_irq(&pool->lock);
 
+	del_timer_sync(&pool->idle_timer);
+
 	mutex_lock(&pool->attach_mutex);
 	if (!list_empty(&pool->workers))
 		pool->detach_completion = &detach_completion;
@@ -3431,12 +3340,6 @@ static void put_unbound_pool(struct worker_pool *pool)
 	if (pool->detach_completion)
 		wait_for_completion(pool->detach_completion);
 
-	mutex_unlock(&pool->manager_arb);
-
-	/* shut down the timers */
-	del_timer_sync(&pool->idle_timer);
-	del_timer_sync(&pool->mayday_timer);
-
 	/* sched-RCU protected to allow dereferences from get_work_pool() */
 	call_rcu_sched(&pool->rcu, rcu_free_pool);
 }
@@ -3499,10 +3402,6 @@ static struct worker_pool *get_unbound_pool(const struct workqueue_attrs *attrs)
 	if (worker_pool_assign_id(pool) < 0)
 		goto fail;
 
-	/* create and start the initial worker */
-	if (!create_worker(pool))
-		goto fail;
-
 	/* install */
 	hash_add(unbound_pool_hash, &pool->hash_node, hash);
 
@@ -4562,15 +4461,6 @@ static int workqueue_cpu_up_callback(struct notifier_block *nfb,
 	int pi;
 
 	switch (action & ~CPU_TASKS_FROZEN) {
-	case CPU_UP_PREPARE:
-		for_each_cpu_worker_pool(pool, cpu) {
-			if (pool->nr_workers)
-				continue;
-			if (!create_worker(pool))
-				return NOTIFY_BAD;
-		}
-		break;
-
 	case CPU_DOWN_FAILED:
 	case CPU_ONLINE:
 		mutex_lock(&wq_pool_mutex);
@@ -4837,6 +4727,11 @@ static int __init init_workqueues(void)
 
 	wq_numa_init();
 
+	kworker_creater_thread = kthread_run(kthread_worker_fn,
+					     &kworker_creater,
+					     "kworker/creater");
+	BUG_ON(IS_ERR(kworker_creater_thread));
+
 	/* initialize CPU pools */
 	for_each_possible_cpu(cpu) {
 		struct worker_pool *pool;
@@ -4849,6 +4744,9 @@ static int __init init_workqueues(void)
 			pool->attrs->nice = std_nice[i++];
 			pool->node = cpu_to_node(cpu);
 
+			if (cpu_online(cpu))
+				pool->flags &= ~POOL_DISASSOCIATED;
+
 			/* alloc pool ID */
 			mutex_lock(&wq_pool_mutex);
 			BUG_ON(worker_pool_assign_id(pool));
@@ -4856,16 +4754,6 @@ static int __init init_workqueues(void)
 		}
 	}
 
-	/* create the initial worker */
-	for_each_online_cpu(cpu) {
-		struct worker_pool *pool;
-
-		for_each_cpu_worker_pool(pool, cpu) {
-			pool->flags &= ~POOL_DISASSOCIATED;
-			BUG_ON(!create_worker(pool));
-		}
-	}
-
 	/* create default unbound and ordered wq attrs */
 	for (i = 0; i < NR_STD_WORKER_POOLS; i++) {
 		struct workqueue_attrs *attrs;
-- 
1.7.4.4

