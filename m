Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934427Ab3CNC5j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 22:57:39 -0400
Received: from mail-qa0-f51.google.com ([209.85.216.51]:62992 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933477Ab3CNC5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 22:57:35 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: laijs@cn.fujitsu.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/7] workqueue: rename worker_pool->assoc_mutex to ->manager_mutex
Date: Wed, 13 Mar 2013 19:57:19 -0700
Message-Id: <1363229845-6831-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1363229845-6831-1-git-send-email-tj@kernel.org>
References: <1363229845-6831-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Manager operations are currently governed by two mutexes -
pool->manager_arb and ->assoc_mutex.  The former is used to decide who
gets to be the manager and the latter to exclude the actual manager
operations including creation and destruction of workers.  Anyone who
grabs ->manager_arb must perform manager role; otherwise, the pool
might stall.

Grabbing ->assoc_mutex blocks everyone else from performing manager
operations but doesn't require the holder to perform manager duties as
it's merely blocking manager operations without becoming the manager.

Because the blocking was necessary when [dis]associating per-cpu
workqueues during CPU hotplug events, the latter was named
assoc_mutex.  The mutex is scheduled to be used for other purposes, so
this patch gives it a more fitting generic name - manager_mutex - and
updates / adds comments to explain synchronization around the manager
role and operations.

This patch is pure rename / doc update.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c | 62 +++++++++++++++++++++++++++++++++---------------------
 1 file changed, 38 insertions(+), 24 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index f37421f..bc25bdf 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -60,8 +60,8 @@ enum {
 	 * %WORKER_UNBOUND set and concurrency management disabled, and may
 	 * be executing on any CPU.  The pool behaves as an unbound one.
 	 *
-	 * Note that DISASSOCIATED can be flipped only while holding
-	 * assoc_mutex to avoid changing binding state while
+	 * Note that DISASSOCIATED should be flipped only while holding
+	 * manager_mutex to avoid changing binding state while
 	 * create_worker() is in progress.
 	 */
 	POOL_MANAGE_WORKERS	= 1 << 0,	/* need to manage workers */
@@ -149,8 +149,9 @@ struct worker_pool {
 	DECLARE_HASHTABLE(busy_hash, BUSY_WORKER_HASH_ORDER);
 						/* L: hash of busy workers */
 
+	/* see manage_workers() for details on the two manager mutexes */
 	struct mutex		manager_arb;	/* manager arbitration */
-	struct mutex		assoc_mutex;	/* protect POOL_DISASSOCIATED */
+	struct mutex		manager_mutex;	/* manager exclusion */
 	struct ida		worker_ida;	/* L: for worker IDs */
 
 	struct workqueue_attrs	*attrs;		/* I: worker attributes */
@@ -1635,7 +1636,7 @@ static void rebind_workers(struct worker_pool *pool)
 	struct worker *worker, *n;
 	int i;
 
-	lockdep_assert_held(&pool->assoc_mutex);
+	lockdep_assert_held(&pool->manager_mutex);
 	lockdep_assert_held(&pool->lock);
 
 	/* dequeue and kick idle ones */
@@ -2022,31 +2023,44 @@ static bool manage_workers(struct worker *worker)
 	struct worker_pool *pool = worker->pool;
 	bool ret = false;
 
+	/*
+	 * Managership is governed by two mutexes - manager_arb and
+	 * manager_mutex.  manager_arb handles arbitration of manager role.
+	 * Anyone who successfully grabs manager_arb wins the arbitration
+	 * and becomes the manager.  mutex_trylock() on pool->manager_arb
+	 * failure while holding pool->lock reliably indicates that someone
+	 * else is managing the pool and the worker which failed trylock
+	 * can proceed to executing work items.  This means that anyone
+	 * grabbing manager_arb is responsible for actually performing
+	 * manager duties.  If manager_arb is grabbed and released without
+	 * actual management, the pool may stall indefinitely.
+	 *
+	 * manager_mutex is used for exclusion of actual management
+	 * operations.  The holder of manager_mutex can be sure that none
+	 * of management operations, including creation and destruction of
+	 * workers, won't take place until the mutex is released.  Because
+	 * manager_mutex doesn't interfere with manager role arbitration,
+	 * it is guaranteed that the pool's management, while may be
+	 * delayed, won't be disturbed by someone else grabbing
+	 * manager_mutex.
+	 */
 	if (!mutex_trylock(&pool->manager_arb))
 		return ret;
 
 	/*
-	 * To simplify both worker management and CPU hotplug, hold off
-	 * management while hotplug is in progress.  CPU hotplug path can't
-	 * grab @pool->manager_arb to achieve this because that can lead to
-	 * idle worker depletion (all become busy thinking someone else is
-	 * managing) which in turn can result in deadlock under extreme
-	 * circumstances.  Use @pool->assoc_mutex to synchronize manager
-	 * against CPU hotplug.
-	 *
-	 * assoc_mutex would always be free unless CPU hotplug is in
-	 * progress.  trylock first without dropping @pool->lock.
+	 * With manager arbitration won, manager_mutex would be free in
+	 * most cases.  trylock first without dropping @pool->lock.
 	 */
-	if (unlikely(!mutex_trylock(&pool->assoc_mutex))) {
+	if (unlikely(!mutex_trylock(&pool->manager_mutex))) {
 		spin_unlock_irq(&pool->lock);
-		mutex_lock(&pool->assoc_mutex);
+		mutex_lock(&pool->manager_mutex);
 		/*
 		 * CPU hotplug could have happened while we were waiting
 		 * for assoc_mutex.  Hotplug itself can't handle us
 		 * because manager isn't either on idle or busy list, and
 		 * @pool's state and ours could have deviated.
 		 *
-		 * As hotplug is now excluded via assoc_mutex, we can
+		 * As hotplug is now excluded via manager_mutex, we can
 		 * simply try to bind.  It will succeed or fail depending
 		 * on @pool's current state.  Try it and adjust
 		 * %WORKER_UNBOUND accordingly.
@@ -2068,7 +2082,7 @@ static bool manage_workers(struct worker *worker)
 	ret |= maybe_destroy_workers(pool);
 	ret |= maybe_create_worker(pool);
 
-	mutex_unlock(&pool->assoc_mutex);
+	mutex_unlock(&pool->manager_mutex);
 	mutex_unlock(&pool->manager_arb);
 	return ret;
 }
@@ -3436,7 +3450,7 @@ static int init_worker_pool(struct worker_pool *pool)
 		    (unsigned long)pool);
 
 	mutex_init(&pool->manager_arb);
-	mutex_init(&pool->assoc_mutex);
+	mutex_init(&pool->manager_mutex);
 	ida_init(&pool->worker_ida);
 
 	INIT_HLIST_NODE(&pool->hash_node);
@@ -4076,11 +4090,11 @@ static void wq_unbind_fn(struct work_struct *work)
 	for_each_cpu_worker_pool(pool, cpu) {
 		WARN_ON_ONCE(cpu != smp_processor_id());
 
-		mutex_lock(&pool->assoc_mutex);
+		mutex_lock(&pool->manager_mutex);
 		spin_lock_irq(&pool->lock);
 
 		/*
-		 * We've claimed all manager positions.  Make all workers
+		 * We've blocked all manager operations.  Make all workers
 		 * unbound and set DISASSOCIATED.  Before this, all workers
 		 * except for the ones which are still executing works from
 		 * before the last CPU down must be on the cpu.  After
@@ -4095,7 +4109,7 @@ static void wq_unbind_fn(struct work_struct *work)
 		pool->flags |= POOL_DISASSOCIATED;
 
 		spin_unlock_irq(&pool->lock);
-		mutex_unlock(&pool->assoc_mutex);
+		mutex_unlock(&pool->manager_mutex);
 	}
 
 	/*
@@ -4152,14 +4166,14 @@ static int __cpuinit workqueue_cpu_up_callback(struct notifier_block *nfb,
 	case CPU_DOWN_FAILED:
 	case CPU_ONLINE:
 		for_each_cpu_worker_pool(pool, cpu) {
-			mutex_lock(&pool->assoc_mutex);
+			mutex_lock(&pool->manager_mutex);
 			spin_lock_irq(&pool->lock);
 
 			pool->flags &= ~POOL_DISASSOCIATED;
 			rebind_workers(pool);
 
 			spin_unlock_irq(&pool->lock);
-			mutex_unlock(&pool->assoc_mutex);
+			mutex_unlock(&pool->manager_mutex);
 		}
 		break;
 	}
-- 
1.8.1.4

