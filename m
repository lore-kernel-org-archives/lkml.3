Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932677AbaGZDEa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 23:04:30 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:52648 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751858AbaGZDEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 23:04:06 -0400
X-IronPort-AV: E=Sophos;i="5.00,965,1396972800"; 
   d="scan'208";a="33802428"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>
CC: Tejun Heo <tj@kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 2/3] workqueue: use dedicated creater kthread for all pools
Date: Sat, 26 Jul 2014 11:04:50 +0800
Message-ID: <1406343900-32423-3-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1406343900-32423-1-git-send-email-laijs@cn.fujitsu.com>
References: <1406343900-32423-1-git-send-email-laijs@cn.fujitsu.com>
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
  2) managers among different pools can be parallel, but actually
     their major work are serialized on the kernel thread "kthreadd".
     These managers are sleeping and wasted when the system is lack
     of memory.

This patch introduces a dedicated creater kthread which offloads the
managing from the workers, thus every worker makes effort to process work
rather than create worker, and there is no manager wasting on sleeping
when the system is lack of memory.  This dedicated creater kthread causes
a little more work serialized than before, but it is acceptable.

Implement Detail:
  1) the creater_work:		do the creation, creation exclusion
  2) the cooldown timer:	cool down when fail
  3) the mayday timer:		dismiss itself when pool->nr_idle > 0
  4) the semantic for "pool->nr_idle == 0" active the creater_work, cooldown and mayday timer
  5) the routine of the creater_work:	create worker on two conditions
  6) worker_thread():		start management without unlock/wait/recheck/retry
  7) put_unbound_pool():	group destruction code by functionality
  8) init_workqueues():		init creater kthread earlier than pools/workers

  1) the creater_work
Every pool has a struct kthread_work creater_work to create worker, and
the dedicated creater kthread processes all these creater_works of
all pools. struct kthread_work has itself execution exclusion, so we don't
need the manager_arb to handle the creating exclusion any more.
put_unbound_pool() uses the flush_kthread_work() to synchronize with
the creating rather than uses the manager_arb.

  2) the cooldown timer
The cooldown timer is introduced to implement the cool-down mechanism
rather than to causes the creater to sleep.  When the create_worker()
fails, the cooldown timer is requested and it will restart the creater_work.

  3) the mayday timer
The mayday timer is changed so it doesn't restart itself when
pool->nr_idle > 0.  If it always restarts itself as before, we will add
a lot of complication in creater_work.  The creater_work will need to
call del_timer_sync() after successful creation and grab the pool->lock
to check and restart the timer when pool->nr_idle becomes zero.
We don't want that complication, let the timer dismiss itself.

  4) the semantic for "pool->nr_idle == 0"
Any moment when pool->nr_idle == 0, the pool must on the creating state.
The mayday timer must be active (pending or running) to ensure the mayday
can be sent, and at least one of the creater_work or the cooldown timer
must be active to ensure the creating is in progress or standby.  So the
last worker who causes the pool->nr_idle reduce to 0 has the responsibility
to kick the mayday timer and the creater_work. And may_start_working()
becomes misleading due to the meaning of "!pool->nr_idle" is changed and
any worker should start working in spite of the value of pool->nr_idle.
may_start_working() will be cleanup in the next patch with the intention
that the size of this patch can be shorter for reviewing.

  5) the routine of the creater_work
The creater_work creates a worker in these two conditions:
  A) pool->nr_idle == 0
     A new worker is needed to be created obviously even there is no
     work item pending.  The busy workers may sleep and the pool can't
     serves the future new work items if no new worker is standby or
     being created.
  B) pool->nr_idle == 1 && pool->nr_running == 0
     It should create a worker but not strictly needed since we still
     have a free idle worker and it can restart the creation when it goes
     to busy.  But if we don't create worker in this condition, this
     condition may occur frequently.  If a work item is queued and the
     last idle worker starts creater_work.  But if the work item is
     finished before the creater_work, this condition happens again,
     and it can happen again and again in this way.  So we had better
     to create a worker in this condition.
The creater_work will quit directly in other conditions.

  6) worker_thread()
There is no recheck nor retry when creating is required in worker_thread(),
it just kicks out the mayday timer and the creater work and goes to
process the work items directly.

  7) put_unbound_pool()
put_unbound_pool() groups code by functionality not by the name, it
stops creation activity (creater_work, cooldown_timer, mayday_timer)
at first and then stops idle workers and idle_tiemr.

  8) init_workqueues()
The struct kthread_worker kworker_creater is initialized earlier than
worker_pools in init_workqueues() so that kworker_creater_thread is
created than all early kworkers.  Although the early kworkers are not
depends on kworker_creater_thread, but this initialization order makes
the pid of kworker_creater_thread smaller than kworkers which
seems more smooth.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |  190 ++++++++++++++++++++++------------------------------
 1 files changed, 80 insertions(+), 110 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 1d44d8d..ce8e3fc 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -152,17 +152,17 @@ struct worker_pool {
 	struct list_head	idle_list;	/* X: list of idle workers */
 	struct timer_list	idle_timer;	/* L: worker idle timeout */
 	struct timer_list	mayday_timer;	/* L: SOS timer for workers */
+	struct timer_list	cooldown_timer;	/* L: cool down before retry */
 
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
@@ -753,8 +757,7 @@ static bool need_to_create_worker(struct worker_pool *pool)
 /* Do we have too many workers and should some go away? */
 static bool too_many_workers(struct worker_pool *pool)
 {
-	bool managing = mutex_is_locked(&pool->manager_arb);
-	int nr_idle = pool->nr_idle + managing; /* manager is considered idle */
+	int nr_idle = pool->nr_idle;
 	int nr_busy = pool->nr_workers - nr_idle;
 
 	return nr_idle > 2 && (nr_idle - 2) * MAX_IDLE_WORKERS_RATIO >= nr_busy;
@@ -1823,113 +1826,78 @@ static void pool_mayday_timeout(unsigned long __pool)
 			send_mayday(work);
 	}
 
+	if (!pool->nr_idle)
+		mod_timer(&pool->mayday_timer, jiffies + MAYDAY_INTERVAL);
+
 	spin_unlock(&pool->lock);
 	spin_unlock_irq(&wq_mayday_lock);
+}
+
+static void pool_cooldown_timeout(unsigned long __pool)
+{
+	struct worker_pool *pool = (void *)__pool;
 
-	mod_timer(&pool->mayday_timer, jiffies + MAYDAY_INTERVAL);
+	spin_lock_irq(&pool->lock);
+	if (!pool->nr_idle)
+		queue_kthread_work(&kworker_creater, &pool->creater_work);
+	spin_unlock_irq(&pool->lock);
 }
 
-/**
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
+/*
+ * Start the mayday timer and the creater when pool->nr_idle is reduced to 0.
  *
- * Return:
- * %false if no action was taken and pool->lock stayed locked, %true
- * otherwise.
+ * Any moment when pool->nr_idle == 0, the mayday timer must be active
+ * (pending or running) to ensure the mayday can be sent, and at least one
+ * of the creater_work or the cooldown timer must be active to ensure
+ * the creating is in progress or standby.
  */
-static bool maybe_create_worker(struct worker_pool *pool)
-__releases(&pool->lock)
-__acquires(&pool->lock)
+static void start_creater_work(struct worker_pool *pool)
 {
-	if (!need_to_create_worker(pool))
-		return false;
-restart:
-	spin_unlock_irq(&pool->lock);
-
 	/* if we don't make progress in MAYDAY_INITIAL_TIMEOUT, call for help */
 	mod_timer(&pool->mayday_timer, jiffies + MAYDAY_INITIAL_TIMEOUT);
 
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
+	queue_kthread_work(&kworker_creater, &pool->creater_work);
 }
 
 /**
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
+ * pool_create_worker - create a new workqueue worker when needed
+ * @work: the struct kthread_work creater_work of the target pool
+ *
+ * The routine of the creater_work to create a new worker for the pool.
+ * The creater_work must be requested anytime when the last worker
+ * goes to process work item. And it should create a worker in some
+ * conditions when it is invoked:
+ *
+ * 1) pool->nr_idle == 0:
+ *    It must create a worker or else the pool will lead to lengthy stall.
+ * 2) pool->nr_idle == 1 and there is no running worker
+ *    It should create a worker but not strictly needed. It happens when
+ *    a work item was just finished and the worker is available, but
+ *    creater_work would be requested again if a new work item is queued.
+ *    So it is better to create a worker in this case to avoid
+ *    the creater_work being requested often without doing any thing.
+ * 3) other case
+ *    Doesn't need to create an additional worker
  *
  * CONTEXT:
- * spin_lock_irq(pool->lock) which may be released and regrabbed
- * multiple times.  Does GFP_KERNEL allocations.
- *
- * Return:
- * %false if the pool don't need management and the caller can safely start
- * processing works, %true indicates that the function released pool->lock
- * and reacquired it to perform some management function and that the
- * conditions that the caller verified while holding the lock before
- * calling the function might no longer be true.
+ * Might sleep.  Does GFP_KERNEL allocations.  Called from kthread_work.
  */
-static bool manage_workers(struct worker *worker)
+static void pool_create_worker(struct kthread_work *work)
 {
-	struct worker_pool *pool = worker->pool;
-	bool ret = false;
+	struct worker_pool *pool = container_of(work, struct worker_pool,
+						creater_work);
+	int nr_idle;
 
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
+	spin_lock_irq(&pool->lock);
+	nr_idle = pool->nr_idle;
+	spin_unlock_irq(&pool->lock);
 
-	ret |= maybe_create_worker(pool);
+	if (nr_idle == 0 || (nr_idle == 1 && !atomic_read(&pool->nr_running))) {
+		if (create_worker(pool))
+			return;
 
-	mutex_unlock(&pool->manager_arb);
-	return ret;
+		mod_timer(&pool->cooldown_timer, jiffies + CREATE_COOLDOWN);
+	}
 }
 
 /**
@@ -2123,14 +2091,14 @@ woke_up:
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
+	/* do we need to create worker? */
+	if (unlikely(!may_start_working(pool)))
+		start_creater_work(pool);
 
 	/*
 	 * ->scheduled list can only be filled while a worker is
@@ -2141,8 +2109,8 @@ recheck:
 
 	/*
 	 * Finish PREP stage.  We're guaranteed to have at least one idle
-	 * worker or that someone else has already assumed the manager
-	 * role.  This is where @worker starts participating in concurrency
+	 * worker or the creater_work is issued.
+	 * This is where @worker starts participating in concurrency
 	 * management if applicable and concurrency management is restored
 	 * after being rebound.  See rebind_workers() for details.
 	 */
@@ -3354,11 +3322,13 @@ static int init_worker_pool(struct worker_pool *pool)
 
 	setup_timer(&pool->mayday_timer, pool_mayday_timeout,
 		    (unsigned long)pool);
+	setup_timer(&pool->cooldown_timer, pool_cooldown_timeout,
+		    (unsigned long)pool);
 
-	mutex_init(&pool->manager_arb);
 	mutex_init(&pool->attach_mutex);
 	INIT_LIST_HEAD(&pool->workers);
 
+	init_kthread_work(&pool->creater_work, pool_create_worker);
 	ida_init(&pool->worker_ida);
 	INIT_HLIST_NODE(&pool->hash_node);
 	pool->refcnt = 1;
@@ -3410,19 +3380,20 @@ static void put_unbound_pool(struct worker_pool *pool)
 		idr_remove(&worker_pool_idr, pool->id);
 	hash_del(&pool->hash_node);
 
-	/*
-	 * Become the manager and destroy all workers.  Grabbing
-	 * manager_arb prevents @pool's workers from blocking on
-	 * attach_mutex.
-	 */
-	mutex_lock(&pool->manager_arb);
+	/* wait for unfinished creating and shut down the associated timers */
+	flush_kthread_work(&pool->creater_work);
+	del_timer_sync(&pool->cooldown_timer);
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
@@ -3431,12 +3402,6 @@ static void put_unbound_pool(struct worker_pool *pool)
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
@@ -4837,6 +4802,11 @@ static int __init init_workqueues(void)
 
 	wq_numa_init();
 
+	kworker_creater_thread = kthread_run(kthread_worker_fn,
+					     &kworker_creater,
+					     "kworker/creater");
+	BUG_ON(!kworker_creater_thread);
+
 	/* initialize CPU pools */
 	for_each_possible_cpu(cpu) {
 		struct worker_pool *pool;
-- 
1.7.4.4

