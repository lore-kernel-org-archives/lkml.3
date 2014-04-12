Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756369AbaDLKnO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2014 06:43:14 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:51779 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756092AbaDLKml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2014 06:42:41 -0400
X-IronPort-AV: E=Sophos;i="4.97,847,1389715200"; 
   d="scan'208";a="29176933"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>
CC: Lai Jiangshan <laijs@cn.fujitsu.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/6] workqueue: remove manager_mutex
Date: Sat, 12 Apr 2014 18:45:34 +0800
Message-ID: <1397299543-12012-6-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1397299543-12012-1-git-send-email-laijs@cn.fujitsu.com>
References: <1397299543-12012-1-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now bind_mutex is used for coordinating workers' cpumask with the pool.
pool->lock is used for coordinating workers' concurrency with the pool.

cpumask is coordinated at first and then concurrency.
manager_mutex don't need for cpumask nor concurrency.

In restore_workers_cpumask(), we don't need manager_mutex,
pool->bind_mutex handle the cpumasks corrently VS. bind_worker()
and unbind_worker().

In restore_workers_concurrency()/disable_workers_concurrency(),
we don't need manager_mutex, pool->lock handle the concurrency
correctly VS. create_worker() and destroy_worker().

In put_unbound_pool(), we don't need manager_mutex before this
patchset. It has manager_arb VS. manager_workers() and it has
wq_pool_mutex VS. restore_workers_cpumask(unbound_pool).
and it has wq_pool_mutex VS. create_and_start_worker(unbound_pool).

For percpu pool's create_and_start_worker(), other routines
can't be called at the some time. so create_and_start_worker()
don't need manager_mutex too.

All other routines don't need manager_mutex. so manager_workers()
don't need manager_mutex too.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   73 +++++----------------------------------------------
 1 files changed, 8 insertions(+), 65 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 3a6be02..8199e7f 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -119,9 +119,6 @@ enum {
  *    cpu or grabbing pool->lock is enough for read access.  If
  *    POOL_DISASSOCIATED is set, it's identical to L.
  *
- * MG: pool->manager_mutex and pool->lock protected.  Writes require both
- *     locks.  Reads can happen under either lock.
- *
  * PL: wq_pool_mutex protected.
  *
  * PR: wq_pool_mutex protected for writes.  Sched-RCU protected for reads.
@@ -158,10 +155,8 @@ struct worker_pool {
 	DECLARE_HASHTABLE(busy_hash, BUSY_WORKER_HASH_ORDER);
 						/* L: hash of busy workers */
 
-	/* see manage_workers() for details on the two manager mutexes */
 	struct mutex		manager_arb;	/* manager arbitration */
-	struct mutex		manager_mutex;	/* manager exclusion */
-	struct idr		worker_idr;	/* MG: worker IDs and iteration */
+	struct idr		worker_idr;	/* L: worker IDs and iteration */
 
 	/*
 	 * A worker is bound to the pool, it means:
@@ -353,16 +348,6 @@ static void copy_workqueue_attrs(struct workqueue_attrs *to,
 			   lockdep_is_held(&wq->mutex),			\
 			   "sched RCU or wq->mutex should be held")
 
-#ifdef CONFIG_LOCKDEP
-#define assert_manager_or_pool_lock(pool)				\
-	WARN_ONCE(debug_locks &&					\
-		  !lockdep_is_held(&(pool)->manager_mutex) &&		\
-		  !lockdep_is_held(&(pool)->lock),			\
-		  "pool->manager_mutex or ->lock should be held")
-#else
-#define assert_manager_or_pool_lock(pool)	do { } while (0)
-#endif
-
 #define for_each_cpu_worker_pool(pool, cpu)				\
 	for ((pool) = &per_cpu(cpu_worker_pools, cpu)[0];		\
 	     (pool) < &per_cpu(cpu_worker_pools, cpu)[NR_STD_WORKER_POOLS]; \
@@ -391,14 +376,14 @@ static void copy_workqueue_attrs(struct workqueue_attrs *to,
  * @wi: integer used for iteration
  * @pool: worker_pool to iterate workers of
  *
- * This must be called with either @pool->manager_mutex or ->lock held.
+ * This must be called with ->lock held.
  *
  * The if/else clause exists only for the lockdep assertion and can be
  * ignored.
  */
 #define for_each_pool_worker(worker, wi, pool)				\
 	idr_for_each_entry(&(pool)->worker_idr, (worker), (wi))		\
-		if (({ assert_manager_or_pool_lock((pool)); false; })) { } \
+		if (({ lockdep_assert_held(&pool->lock); false; })) { } \
 		else
 
 /**
@@ -1700,8 +1685,6 @@ static struct worker *create_worker(struct worker_pool *pool)
 	int id = -1;
 	char id_buf[16];
 
-	lockdep_assert_held(&pool->manager_mutex);
-
 	/*
 	 * ID is needed to determine kthread name.  Allocate ID first
 	 * without installing the pointer.
@@ -1781,7 +1764,7 @@ static void start_worker(struct worker *worker)
  * create_and_start_worker - create and start a worker for a pool
  * @pool: the target pool
  *
- * Grab the managership of @pool and create and start a new worker for it.
+ * Create and start a new worker for it.
  *
  * Return: 0 on success. A negative error code otherwise.
  */
@@ -1789,8 +1772,6 @@ static int create_and_start_worker(struct worker_pool *pool)
 {
 	struct worker *worker;
 
-	mutex_lock(&pool->manager_mutex);
-
 	worker = create_worker(pool);
 	if (worker) {
 		spin_lock_irq(&pool->lock);
@@ -1798,8 +1779,6 @@ static int create_and_start_worker(struct worker_pool *pool)
 		spin_unlock_irq(&pool->lock);
 	}
 
-	mutex_unlock(&pool->manager_mutex);
-
 	return worker ? 0 : -ENOMEM;
 }
 
@@ -1816,7 +1795,6 @@ static void destroy_worker(struct worker *worker)
 {
 	struct worker_pool *pool = worker->pool;
 
-	lockdep_assert_held(&pool->manager_mutex);
 	lockdep_assert_held(&pool->lock);
 
 	/* sanity check frenzy */
@@ -2048,8 +2026,7 @@ static bool manage_workers(struct worker *worker)
 	bool ret = false;
 
 	/*
-	 * Managership is governed by two mutexes - manager_arb and
-	 * manager_mutex.  manager_arb handles arbitration of manager role.
+	 * Managership is governed by manager_arb.
 	 * Anyone who successfully grabs manager_arb wins the arbitration
 	 * and becomes the manager.  mutex_trylock() on pool->manager_arb
 	 * failure while holding pool->lock reliably indicates that someone
@@ -2058,30 +2035,10 @@ static bool manage_workers(struct worker *worker)
 	 * grabbing manager_arb is responsible for actually performing
 	 * manager duties.  If manager_arb is grabbed and released without
 	 * actual management, the pool may stall indefinitely.
-	 *
-	 * manager_mutex is used for exclusion of actual management
-	 * operations.  The holder of manager_mutex can be sure that none
-	 * of management operations, including creation and destruction of
-	 * workers, won't take place until the mutex is released.  Because
-	 * manager_mutex doesn't interfere with manager role arbitration,
-	 * it is guaranteed that the pool's management, while may be
-	 * delayed, won't be disturbed by someone else grabbing
-	 * manager_mutex.
 	 */
 	if (!mutex_trylock(&pool->manager_arb))
 		return ret;
 
-	/*
-	 * With manager arbitration won, manager_mutex would be free in
-	 * most cases.  trylock first without dropping @pool->lock.
-	 */
-	if (unlikely(!mutex_trylock(&pool->manager_mutex))) {
-		spin_unlock_irq(&pool->lock);
-		mutex_lock(&pool->manager_mutex);
-		spin_lock_irq(&pool->lock);
-		ret = true;
-	}
-
 	pool->flags &= ~POOL_MANAGE_WORKERS;
 
 	/*
@@ -2091,7 +2048,6 @@ static bool manage_workers(struct worker *worker)
 	ret |= maybe_destroy_workers(pool);
 	ret |= maybe_create_worker(pool);
 
-	mutex_unlock(&pool->manager_mutex);
 	mutex_unlock(&pool->manager_arb);
 	return ret;
 }
@@ -3513,7 +3469,6 @@ static int init_worker_pool(struct worker_pool *pool)
 		    (unsigned long)pool);
 
 	mutex_init(&pool->manager_arb);
-	mutex_init(&pool->manager_mutex);
 	idr_init(&pool->worker_idr);
 
 	mutex_init(&pool->bind_mutex);
@@ -3571,11 +3526,9 @@ static void put_unbound_pool(struct worker_pool *pool)
 
 	/*
 	 * Become the manager and destroy all workers.  Grabbing
-	 * manager_arb prevents @pool's workers from blocking on
-	 * manager_mutex.
+	 * manager_arb ensure @pool's manage worker's finished.
 	 */
 	mutex_lock(&pool->manager_arb);
-	mutex_lock(&pool->manager_mutex);
 	spin_lock_irq(&pool->lock);
 
 	WARN_ON(pool->nr_workers != pool->nr_idle);
@@ -3584,7 +3537,6 @@ static void put_unbound_pool(struct worker_pool *pool)
 	WARN_ON(pool->nr_workers || pool->nr_idle);
 
 	spin_unlock_irq(&pool->lock);
-	mutex_unlock(&pool->manager_mutex);
 	mutex_unlock(&pool->manager_arb);
 
 	wait_for_completion(&pool->workers_leave);
@@ -4571,12 +4523,11 @@ static void disable_workers_concurrency(struct work_struct *work)
 	for_each_cpu_worker_pool(pool, cpu) {
 		WARN_ON_ONCE(cpu != smp_processor_id());
 
-		mutex_lock(&pool->manager_mutex);
 		spin_lock_irq(&pool->lock);
 
 		/*
-		 * We've blocked all manager operations.  Make all workers
-		 * unbound and set DISASSOCIATED.  Before this, all workers
+		 * Make all workers unbound and set DISASSOCIATED. Newly created
+		 * workers will do it by themself. Before this, all workers
 		 * except for the ones which are still executing works from
 		 * before the last CPU down must be on the cpu.  After
 		 * this, they may become diasporas.
@@ -4587,7 +4538,6 @@ static void disable_workers_concurrency(struct work_struct *work)
 		pool->flags |= POOL_DISASSOCIATED;
 
 		spin_unlock_irq(&pool->lock);
-		mutex_unlock(&pool->manager_mutex);
 
 		/*
 		 * Call schedule() so that we cross rq->lock and thus can
@@ -4629,8 +4579,6 @@ static void restore_workers_concurrency(struct worker_pool *pool)
 	struct worker *worker;
 	int wi;
 
-	lockdep_assert_held(&pool->manager_mutex);
-
 	spin_lock_irq(&pool->lock);
 	pool->flags &= ~POOL_DISASSOCIATED;
 
@@ -4687,8 +4635,6 @@ static void restore_workers_cpumask(struct worker_pool *pool, int cpu)
 	static cpumask_t cpumask;
 	struct worker *worker;
 
-	lockdep_assert_held(&pool->manager_mutex);
-
 	/* is @cpu allowed for @pool? */
 	if (!cpumask_test_cpu(cpu, pool->attrs->cpumask))
 		return;
@@ -4734,13 +4680,10 @@ static int workqueue_cpu_up_callback(struct notifier_block *nfb,
 		mutex_lock(&wq_pool_mutex);
 
 		for_each_pool(pool, pi) {
-			mutex_lock(&pool->manager_mutex);
 			restore_workers_cpumask(pool, cpu);
 
 			if (pool->cpu == cpu)
 				restore_workers_concurrency(pool);
-
-			mutex_unlock(&pool->manager_mutex);
 		}
 
 		/* update NUMA affinity of unbound workqueues */
-- 
1.7.4.4

