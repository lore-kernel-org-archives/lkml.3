Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933289Ab3CLSVf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 14:21:35 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:44455 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933145Ab3CLSVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 14:21:33 -0400
Date: Tue, 12 Mar 2013 11:21:28 -0700
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com
Cc: axboe@kernel.dk, jmoyer@redhat.com, zab@redhat.com
Subject: [PATCH v2 17/31] workqueue: implement attribute-based unbound
 worker_pool management
Message-ID: <20130312182128.GF25266@htj.dyndns.org>
References: <1362194662-2344-1-git-send-email-tj@kernel.org>
 <1362194662-2344-18-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362194662-2344-18-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 9b5057946252dce279acdd899d9b1513671a1ff7 Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Tue, 12 Mar 2013 11:14:49 -0700

This patch makes unbound worker_pools reference counted and
dynamically created and destroyed as workqueues needing them come and
go.  All unbound worker_pools are hashed on unbound_pool_hash which is
keyed by the content of worker_pool->attrs.

When an unbound workqueue is allocated, get_unbound_pool() is called
with the attributes of the workqueue.  If there already is a matching
worker_pool, the reference count is bumped and the pool is returned.
If not, a new worker_pool with matching attributes is created and
returned.

When an unbound workqueue is destroyed, put_unbound_pool() is called
which decrements the reference count of the associated worker_pool.
If the refcnt reaches zero, the worker_pool is destroyed in sched-RCU
safe way.

Note that the standard unbound worker_pools - normal and highpri ones
with no specific cpumask affinity - are no longer created explicitly
during init_workqueues().  init_workqueues() only initializes
workqueue_attrs to be used for standard unbound pools -
unbound_std_wq_attrs[].  The pools are spawned on demand as workqueues
are created.

v2: - Comment added to init_worker_pool() explaining that @pool should
      be in a condition which can be passed to put_unbound_pool() even
      on failure.

    - pool->refcnt reaching zero and the pool being removed from
      unbound_pool_hash should be dynamic.  pool->refcnt is converted
      to int from atomic_t and now manipulated inside workqueue_lock.

    - Removed an incorrect sanity check on nr_idle in
      put_unbound_pool() which may trigger spuriously.

    All changes were suggested by Lai Jiangshan.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c | 237 ++++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 224 insertions(+), 13 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index b0d3cbb..7203956 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -41,6 +41,7 @@
 #include <linux/debug_locks.h>
 #include <linux/lockdep.h>
 #include <linux/idr.h>
+#include <linux/jhash.h>
 #include <linux/hashtable.h>
 #include <linux/rculist.h>
 
@@ -80,6 +81,7 @@ enum {
 
 	NR_STD_WORKER_POOLS	= 2,		/* # standard pools per cpu */
 
+	UNBOUND_POOL_HASH_ORDER	= 6,		/* hashed by pool->attrs */
 	BUSY_WORKER_HASH_ORDER	= 6,		/* 64 pointers */
 
 	MAX_IDLE_WORKERS_RATIO	= 4,		/* 1/4 of busy can be idle */
@@ -149,6 +151,8 @@ struct worker_pool {
 	struct ida		worker_ida;	/* L: for worker IDs */
 
 	struct workqueue_attrs	*attrs;		/* I: worker attributes */
+	struct hlist_node	hash_node;	/* R: unbound_pool_hash node */
+	int			refcnt;		/* refcnt for unbound pools */
 
 	/*
 	 * The current concurrency level.  As it's likely to be accessed
@@ -156,6 +160,12 @@ struct worker_pool {
 	 * cacheline.
 	 */
 	atomic_t		nr_running ____cacheline_aligned_in_smp;
+
+	/*
+	 * Destruction of pool is sched-RCU protected to allow dereferences
+	 * from get_work_pool().
+	 */
+	struct rcu_head		rcu;
 } ____cacheline_aligned_in_smp;
 
 /*
@@ -218,6 +228,11 @@ struct workqueue_struct {
 
 static struct kmem_cache *pwq_cache;
 
+/* hash of all unbound pools keyed by pool->attrs */
+static DEFINE_HASHTABLE(unbound_pool_hash, UNBOUND_POOL_HASH_ORDER);
+
+static struct workqueue_attrs *unbound_std_wq_attrs[NR_STD_WORKER_POOLS];
+
 struct workqueue_struct *system_wq __read_mostly;
 EXPORT_SYMBOL_GPL(system_wq);
 struct workqueue_struct *system_highpri_wq __read_mostly;
@@ -1742,7 +1757,7 @@ static struct worker *create_worker(struct worker_pool *pool)
 	worker->pool = pool;
 	worker->id = id;
 
-	if (pool->cpu != WORK_CPU_UNBOUND)
+	if (pool->cpu >= 0)
 		worker->task = kthread_create_on_node(worker_thread,
 					worker, cpu_to_node(pool->cpu),
 					"kworker/%d:%d%s", pool->cpu, id, pri);
@@ -3161,16 +3176,68 @@ fail:
 	return NULL;
 }
 
+static void copy_workqueue_attrs(struct workqueue_attrs *to,
+				 const struct workqueue_attrs *from)
+{
+	to->nice = from->nice;
+	cpumask_copy(to->cpumask, from->cpumask);
+}
+
+/*
+ * Hacky implementation of jhash of bitmaps which only considers the
+ * specified number of bits.  We probably want a proper implementation in
+ * include/linux/jhash.h.
+ */
+static u32 jhash_bitmap(const unsigned long *bitmap, int bits, u32 hash)
+{
+	int nr_longs = bits / BITS_PER_LONG;
+	int nr_leftover = bits % BITS_PER_LONG;
+	unsigned long leftover = 0;
+
+	if (nr_longs)
+		hash = jhash(bitmap, nr_longs * sizeof(long), hash);
+	if (nr_leftover) {
+		bitmap_copy(&leftover, bitmap + nr_longs, nr_leftover);
+		hash = jhash(&leftover, sizeof(long), hash);
+	}
+	return hash;
+}
+
+/* hash value of the content of @attr */
+static u32 wqattrs_hash(const struct workqueue_attrs *attrs)
+{
+	u32 hash = 0;
+
+	hash = jhash_1word(attrs->nice, hash);
+	hash = jhash_bitmap(cpumask_bits(attrs->cpumask), nr_cpu_ids, hash);
+	return hash;
+}
+
+/* content equality test */
+static bool wqattrs_equal(const struct workqueue_attrs *a,
+			  const struct workqueue_attrs *b)
+{
+	if (a->nice != b->nice)
+		return false;
+	if (!cpumask_equal(a->cpumask, b->cpumask))
+		return false;
+	return true;
+}
+
 /**
  * init_worker_pool - initialize a newly zalloc'd worker_pool
  * @pool: worker_pool to initialize
  *
  * Initiailize a newly zalloc'd @pool.  It also allocates @pool->attrs.
- * Returns 0 on success, -errno on failure.
+ * Returns 0 on success, -errno on failure.  Even on failure, all fields
+ * inside @pool proper are initialized and put_unbound_pool() can be called
+ * on @pool safely to release it.
  */
 static int init_worker_pool(struct worker_pool *pool)
 {
 	spin_lock_init(&pool->lock);
+	pool->id = -1;
+	pool->cpu = -1;
 	pool->flags |= POOL_DISASSOCIATED;
 	INIT_LIST_HEAD(&pool->worklist);
 	INIT_LIST_HEAD(&pool->idle_list);
@@ -3187,12 +3254,136 @@ static int init_worker_pool(struct worker_pool *pool)
 	mutex_init(&pool->assoc_mutex);
 	ida_init(&pool->worker_ida);
 
+	INIT_HLIST_NODE(&pool->hash_node);
+	pool->refcnt = 1;
+
+	/* shouldn't fail above this point */
 	pool->attrs = alloc_workqueue_attrs(GFP_KERNEL);
 	if (!pool->attrs)
 		return -ENOMEM;
 	return 0;
 }
 
+static void rcu_free_pool(struct rcu_head *rcu)
+{
+	struct worker_pool *pool = container_of(rcu, struct worker_pool, rcu);
+
+	ida_destroy(&pool->worker_ida);
+	free_workqueue_attrs(pool->attrs);
+	kfree(pool);
+}
+
+/**
+ * put_unbound_pool - put a worker_pool
+ * @pool: worker_pool to put
+ *
+ * Put @pool.  If its refcnt reaches zero, it gets destroyed in sched-RCU
+ * safe manner.
+ */
+static void put_unbound_pool(struct worker_pool *pool)
+{
+	struct worker *worker;
+
+	spin_lock_irq(&workqueue_lock);
+	if (--pool->refcnt) {
+		spin_unlock_irq(&workqueue_lock);
+		return;
+	}
+
+	/* sanity checks */
+	if (WARN_ON(!(pool->flags & POOL_DISASSOCIATED)) ||
+	    WARN_ON(!list_empty(&pool->worklist))) {
+		spin_unlock_irq(&workqueue_lock);
+		return;
+	}
+
+	/* release id and unhash */
+	if (pool->id >= 0)
+		idr_remove(&worker_pool_idr, pool->id);
+	hash_del(&pool->hash_node);
+
+	spin_unlock_irq(&workqueue_lock);
+
+	/* lock out manager and destroy all workers */
+	mutex_lock(&pool->manager_mutex);
+	spin_lock_irq(&pool->lock);
+
+	while ((worker = first_worker(pool)))
+		destroy_worker(worker);
+	WARN_ON(pool->nr_workers || pool->nr_idle);
+
+	spin_unlock_irq(&pool->lock);
+	mutex_unlock(&pool->manager_mutex);
+
+	/* shut down the timers */
+	del_timer_sync(&pool->idle_timer);
+	del_timer_sync(&pool->mayday_timer);
+
+	/* sched-RCU protected to allow dereferences from get_work_pool() */
+	call_rcu_sched(&pool->rcu, rcu_free_pool);
+}
+
+/**
+ * get_unbound_pool - get a worker_pool with the specified attributes
+ * @attrs: the attributes of the worker_pool to get
+ *
+ * Obtain a worker_pool which has the same attributes as @attrs, bump the
+ * reference count and return it.  If there already is a matching
+ * worker_pool, it will be used; otherwise, this function attempts to
+ * create a new one.  On failure, returns NULL.
+ */
+static struct worker_pool *get_unbound_pool(const struct workqueue_attrs *attrs)
+{
+	static DEFINE_MUTEX(create_mutex);
+	u32 hash = wqattrs_hash(attrs);
+	struct worker_pool *pool;
+	struct worker *worker;
+
+	mutex_lock(&create_mutex);
+
+	/* do we already have a matching pool? */
+	spin_lock_irq(&workqueue_lock);
+	hash_for_each_possible(unbound_pool_hash, pool, hash_node, hash) {
+		if (wqattrs_equal(pool->attrs, attrs)) {
+			pool->refcnt++;
+			goto out_unlock;
+		}
+	}
+	spin_unlock_irq(&workqueue_lock);
+
+	/* nope, create a new one */
+	pool = kzalloc(sizeof(*pool), GFP_KERNEL);
+	if (!pool || init_worker_pool(pool) < 0)
+		goto fail;
+
+	copy_workqueue_attrs(pool->attrs, attrs);
+
+	if (worker_pool_assign_id(pool) < 0)
+		goto fail;
+
+	/* create and start the initial worker */
+	worker = create_worker(pool);
+	if (!worker)
+		goto fail;
+
+	spin_lock_irq(&pool->lock);
+	start_worker(worker);
+	spin_unlock_irq(&pool->lock);
+
+	/* install */
+	spin_lock_irq(&workqueue_lock);
+	hash_add(unbound_pool_hash, &pool->hash_node, hash);
+out_unlock:
+	spin_unlock_irq(&workqueue_lock);
+	mutex_unlock(&create_mutex);
+	return pool;
+fail:
+	mutex_unlock(&create_mutex);
+	if (pool)
+		put_unbound_pool(pool);
+	return NULL;
+}
+
 static int alloc_and_link_pwqs(struct workqueue_struct *wq)
 {
 	bool highpri = wq->flags & WQ_HIGHPRI;
@@ -3217,7 +3408,12 @@ static int alloc_and_link_pwqs(struct workqueue_struct *wq)
 		if (!pwq)
 			return -ENOMEM;
 
-		pwq->pool = get_std_worker_pool(WORK_CPU_UNBOUND, highpri);
+		pwq->pool = get_unbound_pool(unbound_std_wq_attrs[highpri]);
+		if (!pwq->pool) {
+			kmem_cache_free(pwq_cache, pwq);
+			return -ENOMEM;
+		}
+
 		list_add_tail_rcu(&pwq->pwqs_node, &wq->pwqs);
 	}
 
@@ -3395,6 +3591,15 @@ void destroy_workqueue(struct workqueue_struct *wq)
 		kfree(wq->rescuer);
 	}
 
+	/*
+	 * We're the sole accessor of @wq at this point.  Directly access
+	 * the first pwq and put its pool.
+	 */
+	if (wq->flags & WQ_UNBOUND) {
+		pwq = list_first_entry(&wq->pwqs, struct pool_workqueue,
+				       pwqs_node);
+		put_unbound_pool(pwq->pool);
+	}
 	free_pwqs(wq);
 	kfree(wq);
 }
@@ -3857,19 +4062,14 @@ static int __init init_workqueues(void)
 	hotcpu_notifier(workqueue_cpu_down_callback, CPU_PRI_WORKQUEUE_DOWN);
 
 	/* initialize CPU pools */
-	for_each_wq_cpu(cpu) {
+	for_each_possible_cpu(cpu) {
 		struct worker_pool *pool;
 
 		i = 0;
 		for_each_std_worker_pool(pool, cpu) {
 			BUG_ON(init_worker_pool(pool));
 			pool->cpu = cpu;
-
-			if (cpu != WORK_CPU_UNBOUND)
-				cpumask_copy(pool->attrs->cpumask, cpumask_of(cpu));
-			else
-				cpumask_setall(pool->attrs->cpumask);
-
+			cpumask_copy(pool->attrs->cpumask, cpumask_of(cpu));
 			pool->attrs->nice = std_nice[i++];
 
 			/* alloc pool ID */
@@ -3878,14 +4078,13 @@ static int __init init_workqueues(void)
 	}
 
 	/* create the initial worker */
-	for_each_online_wq_cpu(cpu) {
+	for_each_online_cpu(cpu) {
 		struct worker_pool *pool;
 
 		for_each_std_worker_pool(pool, cpu) {
 			struct worker *worker;
 
-			if (cpu != WORK_CPU_UNBOUND)
-				pool->flags &= ~POOL_DISASSOCIATED;
+			pool->flags &= ~POOL_DISASSOCIATED;
 
 			worker = create_worker(pool);
 			BUG_ON(!worker);
@@ -3895,6 +4094,18 @@ static int __init init_workqueues(void)
 		}
 	}
 
+	/* create default unbound wq attrs */
+	for (i = 0; i < NR_STD_WORKER_POOLS; i++) {
+		struct workqueue_attrs *attrs;
+
+		BUG_ON(!(attrs = alloc_workqueue_attrs(GFP_KERNEL)));
+
+		attrs->nice = std_nice[i];
+		cpumask_setall(attrs->cpumask);
+
+		unbound_std_wq_attrs[i] = attrs;
+	}
+
 	system_wq = alloc_workqueue("events", 0, 0);
 	system_highpri_wq = alloc_workqueue("events_highpri", WQ_HIGHPRI, 0);
 	system_long_wq = alloc_workqueue("events_long", 0, 0);
-- 
1.8.1.4

