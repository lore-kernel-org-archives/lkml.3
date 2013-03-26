Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933888Ab3CZAHt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 20:07:49 -0400
Received: from mail-ve0-f178.google.com ([209.85.128.178]:48245 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758813Ab3CZAHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 20:07:43 -0400
From: Tejun Heo <tj@kernel.org>
To: laijs@cn.fujitsu.com
Cc: linux-kernel@vger.kernel.org, js1304@gmail.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/6] workqueue: rename wq_mutex to wq_pool_mutex
Date: Mon, 25 Mar 2013 17:07:24 -0700
Message-Id: <1364256449-11401-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1364256449-11401-1-git-send-email-tj@kernel.org>
References: <1364256449-11401-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

wq->flush_mutex will be renamed to wq->mutex and cover all fields
specific to each workqueue and eventually replace pwq_lock, which will
make locking simpler and easier to understand.

Rename wq_mutex to wq_pool_mutex to avoid confusion with wq->mutex.
After the scheduled changes, wq_pool_mutex won't be protecting
anything specific to each workqueue instance anyway.

This patch is pure rename.

tj: s/wqs_mutex/wq_pool_mutex/.  Rewrote description.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c | 109 +++++++++++++++++++++++++++--------------------------
 1 file changed, 55 insertions(+), 54 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 47f2587..064157e 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -123,9 +123,9 @@ enum {
  * MG: pool->manager_mutex and pool->lock protected.  Writes require both
  *     locks.  Reads can happen under either lock.
  *
- * WQ: wq_mutex protected.
+ * PL: wq_pool_mutex protected.
  *
- * WR: wq_mutex protected for writes.  Sched-RCU protected for reads.
+ * PR: wq_pool_mutex protected for writes.  Sched-RCU protected for reads.
  *
  * PW: pwq_lock protected.
  *
@@ -163,8 +163,8 @@ struct worker_pool {
 	struct idr		worker_idr;	/* MG: worker IDs and iteration */
 
 	struct workqueue_attrs	*attrs;		/* I: worker attributes */
-	struct hlist_node	hash_node;	/* WQ: unbound_pool_hash node */
-	int			refcnt;		/* WQ: refcnt for unbound pools */
+	struct hlist_node	hash_node;	/* PL: unbound_pool_hash node */
+	int			refcnt;		/* PL: refcnt for unbound pools */
 
 	/*
 	 * The current concurrency level.  As it's likely to be accessed
@@ -226,10 +226,10 @@ struct wq_device;
  * the appropriate worker_pool through its pool_workqueues.
  */
 struct workqueue_struct {
-	unsigned int		flags;		/* WQ: WQ_* flags */
+	unsigned int		flags;		/* PL: WQ_* flags */
 	struct pool_workqueue __percpu *cpu_pwqs; /* I: per-cpu pwq's */
 	struct list_head	pwqs;		/* FR: all pwqs of this wq */
-	struct list_head	list;		/* WQ: list of all workqueues */
+	struct list_head	list;		/* PL: list of all workqueues */
 
 	struct mutex		flush_mutex;	/* protects wq flushing */
 	int			work_color;	/* F: current work color */
@@ -242,7 +242,7 @@ struct workqueue_struct {
 	struct list_head	maydays;	/* MD: pwqs requesting rescue */
 	struct worker		*rescuer;	/* I: rescue worker */
 
-	int			nr_drainers;	/* WQ: drain in progress */
+	int			nr_drainers;	/* PL: drain in progress */
 	int			saved_max_active; /* PW: saved pwq max_active */
 
 #ifdef CONFIG_SYSFS
@@ -256,20 +256,20 @@ struct workqueue_struct {
 
 static struct kmem_cache *pwq_cache;
 
-static DEFINE_MUTEX(wq_mutex);		/* protects workqueues and pools */
+static DEFINE_MUTEX(wq_pool_mutex);	/* protects pools and workqueues list */
 static DEFINE_SPINLOCK(pwq_lock);	/* protects pool_workqueues */
 static DEFINE_SPINLOCK(wq_mayday_lock);	/* protects wq->maydays list */
 
-static LIST_HEAD(workqueues);		/* WQ: list of all workqueues */
-static bool workqueue_freezing;		/* WQ: have wqs started freezing? */
+static LIST_HEAD(workqueues);		/* PL: list of all workqueues */
+static bool workqueue_freezing;		/* PL: have wqs started freezing? */
 
 /* the per-cpu worker pools */
 static DEFINE_PER_CPU_SHARED_ALIGNED(struct worker_pool [NR_STD_WORKER_POOLS],
 				     cpu_worker_pools);
 
-static DEFINE_IDR(worker_pool_idr);	/* WR: idr of all pools */
+static DEFINE_IDR(worker_pool_idr);	/* PR: idr of all pools */
 
-/* WQ: hash of all unbound pools keyed by pool->attrs */
+/* PL: hash of all unbound pools keyed by pool->attrs */
 static DEFINE_HASHTABLE(unbound_pool_hash, UNBOUND_POOL_HASH_ORDER);
 
 /* I: attributes used when instantiating standard unbound pools on demand */
@@ -293,10 +293,10 @@ static void copy_workqueue_attrs(struct workqueue_attrs *to,
 #define CREATE_TRACE_POINTS
 #include <trace/events/workqueue.h>
 
-#define assert_rcu_or_wq_mutex()					\
+#define assert_rcu_or_pool_mutex()					\
 	rcu_lockdep_assert(rcu_read_lock_sched_held() ||		\
-			   lockdep_is_held(&wq_mutex),			\
-			   "sched RCU or wq_mutex should be held")
+			   lockdep_is_held(&wq_pool_mutex),		\
+			   "sched RCU or wq_pool_mutex should be held")
 
 #define assert_rcu_or_pwq_lock()					\
 	rcu_lockdep_assert(rcu_read_lock_sched_held() ||		\
@@ -323,16 +323,16 @@ static void copy_workqueue_attrs(struct workqueue_attrs *to,
  * @pool: iteration cursor
  * @pi: integer used for iteration
  *
- * This must be called either with wq_mutex held or sched RCU read locked.
- * If the pool needs to be used beyond the locking in effect, the caller is
- * responsible for guaranteeing that the pool stays online.
+ * This must be called either with wq_pool_mutex held or sched RCU read
+ * locked.  If the pool needs to be used beyond the locking in effect, the
+ * caller is responsible for guaranteeing that the pool stays online.
  *
  * The if/else clause exists only for the lockdep assertion and can be
  * ignored.
  */
 #define for_each_pool(pool, pi)						\
 	idr_for_each_entry(&worker_pool_idr, pool, pi)			\
-		if (({ assert_rcu_or_wq_mutex(); false; })) { }		\
+		if (({ assert_rcu_or_pool_mutex(); false; })) { }	\
 		else
 
 /**
@@ -489,7 +489,7 @@ static int worker_pool_assign_id(struct worker_pool *pool)
 {
 	int ret;
 
-	lockdep_assert_held(&wq_mutex);
+	lockdep_assert_held(&wq_pool_mutex);
 
 	do {
 		if (!idr_pre_get(&worker_pool_idr, GFP_KERNEL))
@@ -607,9 +607,9 @@ static struct pool_workqueue *get_work_pwq(struct work_struct *work)
  *
  * Return the worker_pool @work was last associated with.  %NULL if none.
  *
- * Pools are created and destroyed under wq_mutex, and allows read access
- * under sched-RCU read lock.  As such, this function should be called
- * under wq_mutex or with preemption disabled.
+ * Pools are created and destroyed under wq_pool_mutex, and allows read
+ * access under sched-RCU read lock.  As such, this function should be
+ * called under wq_pool_mutex or with preemption disabled.
  *
  * All fields of the returned pool are accessible as long as the above
  * mentioned locking is in effect.  If the returned pool needs to be used
@@ -621,7 +621,7 @@ static struct worker_pool *get_work_pool(struct work_struct *work)
 	unsigned long data = atomic_long_read(&work->data);
 	int pool_id;
 
-	assert_rcu_or_wq_mutex();
+	assert_rcu_or_pool_mutex();
 
 	if (data & WORK_STRUCT_PWQ)
 		return ((struct pool_workqueue *)
@@ -2684,10 +2684,10 @@ void drain_workqueue(struct workqueue_struct *wq)
 	 * hotter than drain_workqueue() and already looks at @wq->flags.
 	 * Use __WQ_DRAINING so that queue doesn't have to check nr_drainers.
 	 */
-	mutex_lock(&wq_mutex);
+	mutex_lock(&wq_pool_mutex);
 	if (!wq->nr_drainers++)
 		wq->flags |= __WQ_DRAINING;
-	mutex_unlock(&wq_mutex);
+	mutex_unlock(&wq_pool_mutex);
 reflush:
 	flush_workqueue(wq);
 
@@ -2714,10 +2714,10 @@ reflush:
 
 	local_irq_enable();
 
-	mutex_lock(&wq_mutex);
+	mutex_lock(&wq_pool_mutex);
 	if (!--wq->nr_drainers)
 		wq->flags &= ~__WQ_DRAINING;
-	mutex_unlock(&wq_mutex);
+	mutex_unlock(&wq_pool_mutex);
 }
 EXPORT_SYMBOL_GPL(drain_workqueue);
 
@@ -3430,16 +3430,16 @@ static void put_unbound_pool(struct worker_pool *pool)
 {
 	struct worker *worker;
 
-	mutex_lock(&wq_mutex);
+	mutex_lock(&wq_pool_mutex);
 	if (--pool->refcnt) {
-		mutex_unlock(&wq_mutex);
+		mutex_unlock(&wq_pool_mutex);
 		return;
 	}
 
 	/* sanity checks */
 	if (WARN_ON(!(pool->flags & POOL_DISASSOCIATED)) ||
 	    WARN_ON(!list_empty(&pool->worklist))) {
-		mutex_unlock(&wq_mutex);
+		mutex_unlock(&wq_pool_mutex);
 		return;
 	}
 
@@ -3448,7 +3448,7 @@ static void put_unbound_pool(struct worker_pool *pool)
 		idr_remove(&worker_pool_idr, pool->id);
 	hash_del(&pool->hash_node);
 
-	mutex_unlock(&wq_mutex);
+	mutex_unlock(&wq_pool_mutex);
 
 	/*
 	 * Become the manager and destroy all workers.  Grabbing
@@ -3489,7 +3489,7 @@ static struct worker_pool *get_unbound_pool(const struct workqueue_attrs *attrs)
 	u32 hash = wqattrs_hash(attrs);
 	struct worker_pool *pool;
 
-	mutex_lock(&wq_mutex);
+	mutex_lock(&wq_pool_mutex);
 
 	/* do we already have a matching pool? */
 	hash_for_each_possible(unbound_pool_hash, pool, hash_node, hash) {
@@ -3520,10 +3520,10 @@ static struct worker_pool *get_unbound_pool(const struct workqueue_attrs *attrs)
 	/* install */
 	hash_add(unbound_pool_hash, &pool->hash_node, hash);
 out_unlock:
-	mutex_unlock(&wq_mutex);
+	mutex_unlock(&wq_pool_mutex);
 	return pool;
 fail:
-	mutex_unlock(&wq_mutex);
+	mutex_unlock(&wq_pool_mutex);
 	if (pool)
 		put_unbound_pool(pool);
 	return NULL;
@@ -3803,10 +3803,11 @@ struct workqueue_struct *__alloc_workqueue_key(const char *fmt,
 		goto err_destroy;
 
 	/*
-	 * wq_mutex protects global freeze state and workqueues list.  Grab
-	 * it, adjust max_active and add the new @wq to workqueues list.
+	 * wq_pool_mutex protects global freeze state and workqueues list.
+	 * Grab it, adjust max_active and add the new @wq to workqueues
+	 * list.
 	 */
-	mutex_lock(&wq_mutex);
+	mutex_lock(&wq_pool_mutex);
 
 	spin_lock_irq(&pwq_lock);
 	for_each_pwq(pwq, wq)
@@ -3815,7 +3816,7 @@ struct workqueue_struct *__alloc_workqueue_key(const char *fmt,
 
 	list_add(&wq->list, &workqueues);
 
-	mutex_unlock(&wq_mutex);
+	mutex_unlock(&wq_pool_mutex);
 
 	return wq;
 
@@ -3866,9 +3867,9 @@ void destroy_workqueue(struct workqueue_struct *wq)
 	 * wq list is used to freeze wq, remove from list after
 	 * flushing is complete in case freeze races us.
 	 */
-	mutex_lock(&wq_mutex);
+	mutex_lock(&wq_pool_mutex);
 	list_del_init(&wq->list);
-	mutex_unlock(&wq_mutex);
+	mutex_unlock(&wq_pool_mutex);
 
 	workqueue_sysfs_unregister(wq);
 
@@ -4198,7 +4199,7 @@ static int __cpuinit workqueue_cpu_up_callback(struct notifier_block *nfb,
 
 	case CPU_DOWN_FAILED:
 	case CPU_ONLINE:
-		mutex_lock(&wq_mutex);
+		mutex_lock(&wq_pool_mutex);
 
 		for_each_pool(pool, pi) {
 			mutex_lock(&pool->manager_mutex);
@@ -4216,7 +4217,7 @@ static int __cpuinit workqueue_cpu_up_callback(struct notifier_block *nfb,
 			mutex_unlock(&pool->manager_mutex);
 		}
 
-		mutex_unlock(&wq_mutex);
+		mutex_unlock(&wq_pool_mutex);
 		break;
 	}
 	return NOTIFY_OK;
@@ -4292,7 +4293,7 @@ EXPORT_SYMBOL_GPL(work_on_cpu);
  * pool->worklist.
  *
  * CONTEXT:
- * Grabs and releases wq_mutex, pwq_lock and pool->lock's.
+ * Grabs and releases wq_pool_mutex, pwq_lock and pool->lock's.
  */
 void freeze_workqueues_begin(void)
 {
@@ -4301,7 +4302,7 @@ void freeze_workqueues_begin(void)
 	struct pool_workqueue *pwq;
 	int pi;
 
-	mutex_lock(&wq_mutex);
+	mutex_lock(&wq_pool_mutex);
 
 	WARN_ON_ONCE(workqueue_freezing);
 	workqueue_freezing = true;
@@ -4322,7 +4323,7 @@ void freeze_workqueues_begin(void)
 	}
 	spin_unlock_irq(&pwq_lock);
 
-	mutex_unlock(&wq_mutex);
+	mutex_unlock(&wq_pool_mutex);
 }
 
 /**
@@ -4332,7 +4333,7 @@ void freeze_workqueues_begin(void)
  * between freeze_workqueues_begin() and thaw_workqueues().
  *
  * CONTEXT:
- * Grabs and releases wq_mutex.
+ * Grabs and releases wq_pool_mutex.
  *
  * RETURNS:
  * %true if some freezable workqueues are still busy.  %false if freezing
@@ -4344,7 +4345,7 @@ bool freeze_workqueues_busy(void)
 	struct workqueue_struct *wq;
 	struct pool_workqueue *pwq;
 
-	mutex_lock(&wq_mutex);
+	mutex_lock(&wq_pool_mutex);
 
 	WARN_ON_ONCE(!workqueue_freezing);
 
@@ -4367,7 +4368,7 @@ bool freeze_workqueues_busy(void)
 		rcu_read_unlock_sched();
 	}
 out_unlock:
-	mutex_unlock(&wq_mutex);
+	mutex_unlock(&wq_pool_mutex);
 	return busy;
 }
 
@@ -4378,7 +4379,7 @@ out_unlock:
  * frozen works are transferred to their respective pool worklists.
  *
  * CONTEXT:
- * Grabs and releases wq_mutex, pwq_lock and pool->lock's.
+ * Grabs and releases wq_pool_mutex, pwq_lock and pool->lock's.
  */
 void thaw_workqueues(void)
 {
@@ -4387,7 +4388,7 @@ void thaw_workqueues(void)
 	struct worker_pool *pool;
 	int pi;
 
-	mutex_lock(&wq_mutex);
+	mutex_lock(&wq_pool_mutex);
 
 	if (!workqueue_freezing)
 		goto out_unlock;
@@ -4410,7 +4411,7 @@ void thaw_workqueues(void)
 
 	workqueue_freezing = false;
 out_unlock:
-	mutex_unlock(&wq_mutex);
+	mutex_unlock(&wq_pool_mutex);
 }
 #endif /* CONFIG_FREEZER */
 
@@ -4442,9 +4443,9 @@ static int __init init_workqueues(void)
 			pool->attrs->nice = std_nice[i++];
 
 			/* alloc pool ID */
-			mutex_lock(&wq_mutex);
+			mutex_lock(&wq_pool_mutex);
 			BUG_ON(worker_pool_assign_id(pool));
-			mutex_unlock(&wq_mutex);
+			mutex_unlock(&wq_pool_mutex);
 		}
 	}
 
-- 
1.8.1.4

