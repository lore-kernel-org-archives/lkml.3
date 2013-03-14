Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753778Ab3CNXBm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 19:01:42 -0400
Received: from mail-ve0-f182.google.com ([209.85.128.182]:34795 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753718Ab3CNXBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 19:01:40 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: laijs@cn.fujitsu.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/5] workqueue: convert worker_pool->worker_ida to idr and implement for_each_pool_worker()
Date: Thu, 14 Mar 2013 16:01:27 -0700
Message-Id: <1363302090-16117-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1363302090-16117-1-git-send-email-tj@kernel.org>
References: <1363302090-16117-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make worker_ida an idr - worker_idr and use it to implement
for_each_pool_worker() which will be used to simplify worker rebinding
on CPU_ONLINE.

pool->worker_idr is protected by both pool->manager_mutex and
pool->lock so that it can be iterated while holding either lock.

* create_worker() allocates ID without installing worker pointer and
  installs the pointer later using idr_replace().  This is because
  worker ID is needed when creating the actual task to name it and the
  new worker shouldn't be visible to iterations before fully
  initialized.

* In destroy_worker(), ID removal is moved before kthread_stop().
  This is again to guarantee that only fully working workers are
  visible to for_each_pool_worker().

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c | 63 +++++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 51 insertions(+), 12 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 39a591f..384ff34 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -119,6 +119,9 @@ enum {
  *
  * F: wq->flush_mutex protected.
  *
+ * MG: pool->manager_mutex and pool->lock protected.  Writes require both
+ *     locks.  Reads can happen under either lock.
+ *
  * WQ: wq_mutex protected.
  *
  * WR: wq_mutex protected for writes.  Sched-RCU protected for reads.
@@ -156,7 +159,7 @@ struct worker_pool {
 	/* see manage_workers() for details on the two manager mutexes */
 	struct mutex		manager_arb;	/* manager arbitration */
 	struct mutex		manager_mutex;	/* manager exclusion */
-	struct ida		worker_ida;	/* L: for worker IDs */
+	struct idr		worker_idr;	/* MG: worker IDs and iteration */
 
 	struct workqueue_attrs	*attrs;		/* I: worker attributes */
 	struct hlist_node	hash_node;	/* WQ: unbound_pool_hash node */
@@ -299,6 +302,15 @@ static void copy_workqueue_attrs(struct workqueue_attrs *to,
 			   lockdep_is_held(&pwq_lock),			\
 			   "sched RCU or pwq_lock should be held")
 
+#ifdef CONFIG_LOCKDEP
+#define assert_manager_or_pool_lock(pool)				\
+	WARN_ONCE(!lockdep_is_held(&(pool)->manager_mutex) &&		\
+		  !lockdep_is_held(&(pool)->lock),			\
+		  "pool->manager_mutex or ->lock should be held")
+#else
+#define assert_manager_or_pool_lock(pool)	do { } while (0)
+#endif
+
 #define for_each_cpu_worker_pool(pool, cpu)				\
 	for ((pool) = &per_cpu(cpu_worker_pools, cpu)[0];		\
 	     (pool) < &per_cpu(cpu_worker_pools, cpu)[NR_STD_WORKER_POOLS]; \
@@ -325,6 +337,22 @@ static void copy_workqueue_attrs(struct workqueue_attrs *to,
 		else
 
 /**
+ * for_each_pool_worker - iterate through all workers of a worker_pool
+ * @worker: iteration cursor
+ * @wi: integer used for iteration
+ * @pool: worker_pool to iterate workers of
+ *
+ * This must be called with either @pool->manager_mutex or ->lock held.
+ *
+ * The if/else clause exists only for the lockdep assertion and can be
+ * ignored.
+ */
+#define for_each_pool_worker(worker, wi, pool)				\
+	idr_for_each_entry(&(pool)->worker_idr, (worker), (wi))		\
+		if (({ assert_manager_or_pool_lock((pool)); false; })) { } \
+		else
+
+/**
  * for_each_pwq - iterate through all pool_workqueues of the specified workqueue
  * @pwq: iteration cursor
  * @wq: the target workqueue
@@ -1723,14 +1751,19 @@ static struct worker *create_worker(struct worker_pool *pool)
 
 	lockdep_assert_held(&pool->manager_mutex);
 
+	/*
+	 * ID is needed to determine kthread name.  Allocate ID first
+	 * without installing the pointer.
+	 */
+	idr_preload(GFP_KERNEL);
 	spin_lock_irq(&pool->lock);
-	while (ida_get_new(&pool->worker_ida, &id)) {
-		spin_unlock_irq(&pool->lock);
-		if (!ida_pre_get(&pool->worker_ida, GFP_KERNEL))
-			goto fail;
-		spin_lock_irq(&pool->lock);
-	}
+
+	id = idr_alloc(&pool->worker_idr, NULL, 0, 0, GFP_NOWAIT);
+
 	spin_unlock_irq(&pool->lock);
+	idr_preload_end();
+	if (id < 0)
+		goto fail;
 
 	worker = alloc_worker();
 	if (!worker)
@@ -1768,11 +1801,17 @@ static struct worker *create_worker(struct worker_pool *pool)
 	if (pool->flags & POOL_DISASSOCIATED)
 		worker->flags |= WORKER_UNBOUND;
 
+	/* successful, commit the pointer to idr */
+	spin_lock_irq(&pool->lock);
+	idr_replace(&pool->worker_idr, worker, worker->id);
+	spin_unlock_irq(&pool->lock);
+
 	return worker;
+
 fail:
 	if (id >= 0) {
 		spin_lock_irq(&pool->lock);
-		ida_remove(&pool->worker_ida, id);
+		idr_remove(&pool->worker_idr, id);
 		spin_unlock_irq(&pool->lock);
 	}
 	kfree(worker);
@@ -1832,7 +1871,6 @@ static int create_and_start_worker(struct worker_pool *pool)
 static void destroy_worker(struct worker *worker)
 {
 	struct worker_pool *pool = worker->pool;
-	int id = worker->id;
 
 	lockdep_assert_held(&pool->manager_mutex);
 	lockdep_assert_held(&pool->lock);
@@ -1850,13 +1888,14 @@ static void destroy_worker(struct worker *worker)
 	list_del_init(&worker->entry);
 	worker->flags |= WORKER_DIE;
 
+	idr_remove(&pool->worker_idr, worker->id);
+
 	spin_unlock_irq(&pool->lock);
 
 	kthread_stop(worker->task);
 	kfree(worker);
 
 	spin_lock_irq(&pool->lock);
-	ida_remove(&pool->worker_ida, id);
 }
 
 static void idle_worker_timeout(unsigned long __pool)
@@ -3482,7 +3521,7 @@ static int init_worker_pool(struct worker_pool *pool)
 
 	mutex_init(&pool->manager_arb);
 	mutex_init(&pool->manager_mutex);
-	ida_init(&pool->worker_ida);
+	idr_init(&pool->worker_idr);
 
 	INIT_HLIST_NODE(&pool->hash_node);
 	pool->refcnt = 1;
@@ -3498,7 +3537,7 @@ static void rcu_free_pool(struct rcu_head *rcu)
 {
 	struct worker_pool *pool = container_of(rcu, struct worker_pool, rcu);
 
-	ida_destroy(&pool->worker_ida);
+	idr_destroy(&pool->worker_idr);
 	free_workqueue_attrs(pool->attrs);
 	kfree(pool);
 }
-- 
1.8.1.4

