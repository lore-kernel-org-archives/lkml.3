Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934508Ab3CNC6o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 22:58:44 -0400
Received: from mail-qe0-f43.google.com ([209.85.128.43]:37741 "EHLO
	mail-qe0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933477Ab3CNC5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 22:57:42 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: laijs@cn.fujitsu.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 5/7] workqueue: separate out pool and workqueue locking into wq_mutex
Date: Wed, 13 Mar 2013 19:57:23 -0700
Message-Id: <1363229845-6831-6-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1363229845-6831-1-git-send-email-tj@kernel.org>
References: <1363229845-6831-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, workqueue_lock protects most shared workqueue resources -
the pools, workqueues, pool_workqueues, draining, ID assignments,
mayday handling and so on.  The coverage has grown organically and
there is no identified bottleneck coming from workqueue_lock, but it
has grown a bit too much and scheduled rebinding changes need the
pools and workqueues to be protected by a mutex instead of a spinlock.

This patch breaks out pool and workqueue synchronization from
workqueue_lock into a new mutex - wq_mutex.  The followings are
protected by wq_mutex.

* worker_pool_idr and unbound_pool_hash
* pool->refcnt
* workqueues list
* workqueue->flags, ->nr_drainers

Most changes are mostly straight-forward.  workqueue_lock is replaced
with wq_mutex where applicable and workqueue_lock lock/unlocks are
added where wq_mutex conversion leaves data structures not protected
by wq_mutex without locking.  irq / preemption flippings were added
where the conversion affects them.  Things worth noting are

* New WQ and WR locking lables added along with
  assert_rcu_or_wq_mutex().

* worker_pool_assign_id() now expects to be called under wq_mutex.

* create_mutex is removed from get_unbound_pool().  It now just holds
  wq_mutex.

This patch shouldn't introduce any visible behavior changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c | 146 ++++++++++++++++++++++++++++-------------------------
 1 file changed, 77 insertions(+), 69 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 9a0cbb2..c3b59ff 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -119,9 +119,11 @@ enum {
  *
  * F: wq->flush_mutex protected.
  *
- * W: workqueue_lock protected.
+ * WQ: wq_mutex protected.
+ *
+ * WR: wq_mutex protected for writes.  Sched-RCU protected for reads.
  *
- * R: workqueue_lock protected for writes.  Sched-RCU protected for reads.
+ * W: workqueue_lock protected.
  *
  * FR: wq->flush_mutex and workqueue_lock protected for writes.  Sched-RCU
  *     protected for reads.
@@ -155,8 +157,8 @@ struct worker_pool {
 	struct ida		worker_ida;	/* L: for worker IDs */
 
 	struct workqueue_attrs	*attrs;		/* I: worker attributes */
-	struct hlist_node	hash_node;	/* W: unbound_pool_hash node */
-	int			refcnt;		/* W: refcnt for unbound pools */
+	struct hlist_node	hash_node;	/* WQ: unbound_pool_hash node */
+	int			refcnt;		/* WQ: refcnt for unbound pools */
 
 	/*
 	 * The current concurrency level.  As it's likely to be accessed
@@ -218,10 +220,10 @@ struct wq_device;
  * the appropriate worker_pool through its pool_workqueues.
  */
 struct workqueue_struct {
-	unsigned int		flags;		/* W: WQ_* flags */
+	unsigned int		flags;		/* WQ: WQ_* flags */
 	struct pool_workqueue __percpu *cpu_pwqs; /* I: per-cpu pwq's */
 	struct list_head	pwqs;		/* FR: all pwqs of this wq */
-	struct list_head	list;		/* W: list of all workqueues */
+	struct list_head	list;		/* WQ: list of all workqueues */
 
 	struct mutex		flush_mutex;	/* protects wq flushing */
 	int			work_color;	/* F: current work color */
@@ -234,7 +236,7 @@ struct workqueue_struct {
 	struct list_head	maydays;	/* W: pwqs requesting rescue */
 	struct worker		*rescuer;	/* I: rescue worker */
 
-	int			nr_drainers;	/* W: drain in progress */
+	int			nr_drainers;	/* WQ: drain in progress */
 	int			saved_max_active; /* W: saved pwq max_active */
 
 #ifdef CONFIG_SYSFS
@@ -248,22 +250,19 @@ struct workqueue_struct {
 
 static struct kmem_cache *pwq_cache;
 
-/* Serializes the accesses to the list of workqueues. */
+static DEFINE_MUTEX(wq_mutex);		/* protects workqueues and pools */
 static DEFINE_SPINLOCK(workqueue_lock);
-static LIST_HEAD(workqueues);
-static bool workqueue_freezing;		/* W: have wqs started freezing? */
+
+static LIST_HEAD(workqueues);		/* WQ: list of all workqueues */
+static bool workqueue_freezing;		/* WQ: have wqs started freezing? */
 
 /* the per-cpu worker pools */
 static DEFINE_PER_CPU_SHARED_ALIGNED(struct worker_pool [NR_STD_WORKER_POOLS],
 				     cpu_worker_pools);
 
-/*
- * R: idr of all pools.  Modifications are protected by workqueue_lock.
- * Read accesses are protected by sched-RCU protected.
- */
-static DEFINE_IDR(worker_pool_idr);
+static DEFINE_IDR(worker_pool_idr);	/* WR: idr of all pools */
 
-/* W: hash of all unbound pools keyed by pool->attrs */
+/* WQ: hash of all unbound pools keyed by pool->attrs */
 static DEFINE_HASHTABLE(unbound_pool_hash, UNBOUND_POOL_HASH_ORDER);
 
 /* I: attributes used when instantiating standard unbound pools on demand */
@@ -287,6 +286,11 @@ static void copy_workqueue_attrs(struct workqueue_attrs *to,
 #define CREATE_TRACE_POINTS
 #include <trace/events/workqueue.h>
 
+#define assert_rcu_or_wq_mutex()					\
+	rcu_lockdep_assert(rcu_read_lock_sched_held() ||		\
+			   lockdep_is_held(&wq_mutex),			\
+			   "sched RCU or wq_mutex should be held")
+
 #define assert_rcu_or_wq_lock()						\
 	rcu_lockdep_assert(rcu_read_lock_sched_held() ||		\
 			   lockdep_is_held(&workqueue_lock),		\
@@ -305,16 +309,16 @@ static void copy_workqueue_attrs(struct workqueue_attrs *to,
  * @pool: iteration cursor
  * @pi: integer used for iteration
  *
- * This must be called either with workqueue_lock held or sched RCU read
- * locked.  If the pool needs to be used beyond the locking in effect, the
- * caller is responsible for guaranteeing that the pool stays online.
+ * This must be called either with wq_mutex held or sched RCU read locked.
+ * If the pool needs to be used beyond the locking in effect, the caller is
+ * responsible for guaranteeing that the pool stays online.
  *
  * The if/else clause exists only for the lockdep assertion and can be
  * ignored.
  */
 #define for_each_pool(pool, pi)						\
 	idr_for_each_entry(&worker_pool_idr, pool, pi)			\
-		if (({ assert_rcu_or_wq_lock(); false; })) { }		\
+		if (({ assert_rcu_or_wq_mutex(); false; })) { }		\
 		else
 
 /**
@@ -455,13 +459,12 @@ static int worker_pool_assign_id(struct worker_pool *pool)
 {
 	int ret;
 
+	lockdep_assert_held(&wq_mutex);
+
 	do {
 		if (!idr_pre_get(&worker_pool_idr, GFP_KERNEL))
 			return -ENOMEM;
-
-		spin_lock_irq(&workqueue_lock);
 		ret = idr_get_new(&worker_pool_idr, pool, &pool->id);
-		spin_unlock_irq(&workqueue_lock);
 	} while (ret == -EAGAIN);
 
 	return ret;
@@ -574,9 +577,9 @@ static struct pool_workqueue *get_work_pwq(struct work_struct *work)
  *
  * Return the worker_pool @work was last associated with.  %NULL if none.
  *
- * Pools are created and destroyed under workqueue_lock, and allows read
- * access under sched-RCU read lock.  As such, this function should be
- * called under workqueue_lock or with preemption disabled.
+ * Pools are created and destroyed under wq_mutex, and allows read access
+ * under sched-RCU read lock.  As such, this function should be called
+ * under wq_mutex or with preemption disabled.
  *
  * All fields of the returned pool are accessible as long as the above
  * mentioned locking is in effect.  If the returned pool needs to be used
@@ -588,7 +591,7 @@ static struct worker_pool *get_work_pool(struct work_struct *work)
 	unsigned long data = atomic_long_read(&work->data);
 	int pool_id;
 
-	assert_rcu_or_wq_lock();
+	assert_rcu_or_wq_mutex();
 
 	if (data & WORK_STRUCT_PWQ)
 		return ((struct pool_workqueue *)
@@ -2768,10 +2771,10 @@ void drain_workqueue(struct workqueue_struct *wq)
 	 * hotter than drain_workqueue() and already looks at @wq->flags.
 	 * Use __WQ_DRAINING so that queue doesn't have to check nr_drainers.
 	 */
-	spin_lock_irq(&workqueue_lock);
+	mutex_lock(&wq_mutex);
 	if (!wq->nr_drainers++)
 		wq->flags |= __WQ_DRAINING;
-	spin_unlock_irq(&workqueue_lock);
+	mutex_unlock(&wq_mutex);
 reflush:
 	flush_workqueue(wq);
 
@@ -2796,12 +2799,12 @@ reflush:
 		goto reflush;
 	}
 
-	spin_lock(&workqueue_lock);
+	local_irq_enable();
+
+	mutex_lock(&wq_mutex);
 	if (!--wq->nr_drainers)
 		wq->flags &= ~__WQ_DRAINING;
-	spin_unlock(&workqueue_lock);
-
-	local_irq_enable();
+	mutex_unlock(&wq_mutex);
 }
 EXPORT_SYMBOL_GPL(drain_workqueue);
 
@@ -3514,16 +3517,16 @@ static void put_unbound_pool(struct worker_pool *pool)
 {
 	struct worker *worker;
 
-	spin_lock_irq(&workqueue_lock);
+	mutex_lock(&wq_mutex);
 	if (--pool->refcnt) {
-		spin_unlock_irq(&workqueue_lock);
+		mutex_unlock(&wq_mutex);
 		return;
 	}
 
 	/* sanity checks */
 	if (WARN_ON(!(pool->flags & POOL_DISASSOCIATED)) ||
 	    WARN_ON(!list_empty(&pool->worklist))) {
-		spin_unlock_irq(&workqueue_lock);
+		mutex_unlock(&wq_mutex);
 		return;
 	}
 
@@ -3532,7 +3535,7 @@ static void put_unbound_pool(struct worker_pool *pool)
 		idr_remove(&worker_pool_idr, pool->id);
 	hash_del(&pool->hash_node);
 
-	spin_unlock_irq(&workqueue_lock);
+	mutex_unlock(&wq_mutex);
 
 	/*
 	 * Become the manager and destroy all workers.  Grabbing
@@ -3570,21 +3573,18 @@ static void put_unbound_pool(struct worker_pool *pool)
  */
 static struct worker_pool *get_unbound_pool(const struct workqueue_attrs *attrs)
 {
-	static DEFINE_MUTEX(create_mutex);
 	u32 hash = wqattrs_hash(attrs);
 	struct worker_pool *pool;
 
-	mutex_lock(&create_mutex);
+	mutex_lock(&wq_mutex);
 
 	/* do we already have a matching pool? */
-	spin_lock_irq(&workqueue_lock);
 	hash_for_each_possible(unbound_pool_hash, pool, hash_node, hash) {
 		if (wqattrs_equal(pool->attrs, attrs)) {
 			pool->refcnt++;
 			goto out_unlock;
 		}
 	}
-	spin_unlock_irq(&workqueue_lock);
 
 	/* nope, create a new one */
 	pool = kzalloc(sizeof(*pool), GFP_KERNEL);
@@ -3602,14 +3602,12 @@ static struct worker_pool *get_unbound_pool(const struct workqueue_attrs *attrs)
 		goto fail;
 
 	/* install */
-	spin_lock_irq(&workqueue_lock);
 	hash_add(unbound_pool_hash, &pool->hash_node, hash);
 out_unlock:
-	spin_unlock_irq(&workqueue_lock);
-	mutex_unlock(&create_mutex);
+	mutex_unlock(&wq_mutex);
 	return pool;
 fail:
-	mutex_unlock(&create_mutex);
+	mutex_unlock(&wq_mutex);
 	if (pool)
 		put_unbound_pool(pool);
 	return NULL;
@@ -3883,18 +3881,19 @@ struct workqueue_struct *__alloc_workqueue_key(const char *fmt,
 		goto err_destroy;
 
 	/*
-	 * workqueue_lock protects global freeze state and workqueues list.
-	 * Grab it, adjust max_active and add the new workqueue to
-	 * workqueues list.
+	 * wq_mutex protects global freeze state and workqueues list.  Grab
+	 * it, adjust max_active and add the new @wq to workqueues list.
 	 */
-	spin_lock_irq(&workqueue_lock);
+	mutex_lock(&wq_mutex);
 
+	spin_lock_irq(&workqueue_lock);
 	for_each_pwq(pwq, wq)
 		pwq_adjust_max_active(pwq);
+	spin_unlock_irq(&workqueue_lock);
 
 	list_add(&wq->list, &workqueues);
 
-	spin_unlock_irq(&workqueue_lock);
+	mutex_unlock(&wq_mutex);
 
 	return wq;
 
@@ -3920,9 +3919,8 @@ void destroy_workqueue(struct workqueue_struct *wq)
 	/* drain it before proceeding with destruction */
 	drain_workqueue(wq);
 
-	spin_lock_irq(&workqueue_lock);
-
 	/* sanity checks */
+	spin_lock_irq(&workqueue_lock);
 	for_each_pwq(pwq, wq) {
 		int i;
 
@@ -3940,14 +3938,15 @@ void destroy_workqueue(struct workqueue_struct *wq)
 			return;
 		}
 	}
+	spin_unlock_irq(&workqueue_lock);
 
 	/*
 	 * wq list is used to freeze wq, remove from list after
 	 * flushing is complete in case freeze races us.
 	 */
+	mutex_lock(&wq_mutex);
 	list_del_init(&wq->list);
-
-	spin_unlock_irq(&workqueue_lock);
+	mutex_unlock(&wq_mutex);
 
 	workqueue_sysfs_unregister(wq);
 
@@ -4267,7 +4266,7 @@ EXPORT_SYMBOL_GPL(work_on_cpu);
  * pool->worklist.
  *
  * CONTEXT:
- * Grabs and releases workqueue_lock and pool->lock's.
+ * Grabs and releases wq_mutex, workqueue_lock and pool->lock's.
  */
 void freeze_workqueues_begin(void)
 {
@@ -4276,26 +4275,28 @@ void freeze_workqueues_begin(void)
 	struct pool_workqueue *pwq;
 	int pi;
 
-	spin_lock_irq(&workqueue_lock);
+	mutex_lock(&wq_mutex);
 
 	WARN_ON_ONCE(workqueue_freezing);
 	workqueue_freezing = true;
 
 	/* set FREEZING */
 	for_each_pool(pool, pi) {
-		spin_lock(&pool->lock);
+		spin_lock_irq(&pool->lock);
 		WARN_ON_ONCE(pool->flags & POOL_FREEZING);
 		pool->flags |= POOL_FREEZING;
-		spin_unlock(&pool->lock);
+		spin_unlock_irq(&pool->lock);
 	}
 
 	/* suppress further executions by setting max_active to zero */
+	spin_lock_irq(&workqueue_lock);
 	list_for_each_entry(wq, &workqueues, list) {
 		for_each_pwq(pwq, wq)
 			pwq_adjust_max_active(pwq);
 	}
-
 	spin_unlock_irq(&workqueue_lock);
+
+	mutex_unlock(&wq_mutex);
 }
 
 /**
@@ -4305,7 +4306,7 @@ void freeze_workqueues_begin(void)
  * between freeze_workqueues_begin() and thaw_workqueues().
  *
  * CONTEXT:
- * Grabs and releases workqueue_lock.
+ * Grabs and releases wq_mutex.
  *
  * RETURNS:
  * %true if some freezable workqueues are still busy.  %false if freezing
@@ -4317,7 +4318,7 @@ bool freeze_workqueues_busy(void)
 	struct workqueue_struct *wq;
 	struct pool_workqueue *pwq;
 
-	spin_lock_irq(&workqueue_lock);
+	mutex_lock(&wq_mutex);
 
 	WARN_ON_ONCE(!workqueue_freezing);
 
@@ -4328,16 +4329,19 @@ bool freeze_workqueues_busy(void)
 		 * nr_active is monotonically decreasing.  It's safe
 		 * to peek without lock.
 		 */
+		preempt_disable();
 		for_each_pwq(pwq, wq) {
 			WARN_ON_ONCE(pwq->nr_active < 0);
 			if (pwq->nr_active) {
 				busy = true;
+				preempt_enable();
 				goto out_unlock;
 			}
 		}
+		preempt_enable();
 	}
 out_unlock:
-	spin_unlock_irq(&workqueue_lock);
+	mutex_unlock(&wq_mutex);
 	return busy;
 }
 
@@ -4348,7 +4352,7 @@ out_unlock:
  * frozen works are transferred to their respective pool worklists.
  *
  * CONTEXT:
- * Grabs and releases workqueue_lock and pool->lock's.
+ * Grabs and releases wq_mutex, workqueue_lock and pool->lock's.
  */
 void thaw_workqueues(void)
 {
@@ -4357,35 +4361,37 @@ void thaw_workqueues(void)
 	struct worker_pool *pool;
 	int pi;
 
-	spin_lock_irq(&workqueue_lock);
+	mutex_lock(&wq_mutex);
 
 	if (!workqueue_freezing)
 		goto out_unlock;
 
 	/* clear FREEZING */
 	for_each_pool(pool, pi) {
-		spin_lock(&pool->lock);
+		spin_lock_irq(&pool->lock);
 		WARN_ON_ONCE(!(pool->flags & POOL_FREEZING));
 		pool->flags &= ~POOL_FREEZING;
-		spin_unlock(&pool->lock);
+		spin_unlock_irq(&pool->lock);
 	}
 
 	/* restore max_active and repopulate worklist */
+	spin_lock_irq(&workqueue_lock);
 	list_for_each_entry(wq, &workqueues, list) {
 		for_each_pwq(pwq, wq)
 			pwq_adjust_max_active(pwq);
 	}
+	spin_unlock_irq(&workqueue_lock);
 
 	/* kick workers */
 	for_each_pool(pool, pi) {
-		spin_lock(&pool->lock);
+		spin_lock_irq(&pool->lock);
 		wake_up_worker(pool);
-		spin_unlock(&pool->lock);
+		spin_unlock_irq(&pool->lock);
 	}
 
 	workqueue_freezing = false;
 out_unlock:
-	spin_unlock_irq(&workqueue_lock);
+	mutex_unlock(&wq_mutex);
 }
 #endif /* CONFIG_FREEZER */
 
@@ -4417,7 +4423,9 @@ static int __init init_workqueues(void)
 			pool->attrs->nice = std_nice[i++];
 
 			/* alloc pool ID */
+			mutex_lock(&wq_mutex);
 			BUG_ON(worker_pool_assign_id(pool));
+			mutex_unlock(&wq_mutex);
 		}
 	}
 
-- 
1.8.1.4

