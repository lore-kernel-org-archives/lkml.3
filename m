Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933694Ab3CSTdX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 15:33:23 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:14615 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S933008Ab3CST2s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 15:28:48 -0400
X-IronPort-AV: E=Sophos;i="4.84,874,1355068800"; 
   d="scan'208";a="6904501"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 06/21] workqueue: separate out pools locking into pools_mutex
Date: Wed, 20 Mar 2013 03:28:06 +0800
Message-Id: <1363721306-2030-7-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1363721306-2030-1-git-send-email-laijs@cn.fujitsu.com>
References: <1363721306-2030-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/20 03:27:21,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/20 03:27:21,
	Serialize complete at 2013/03/20 03:27:21
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

currently wq_mutext protects:

* worker_pool_idr and unbound_pool_hash
* pool->refcnt
* workqueues list
* workqueue->flags, ->nr_drainers
* workqueue_freezing

We can see that it protects very different things.
So we need to split it and introduce a pools_mutex to protect:

* worker_pool_idr and unbound_pool_hash
* pool->refcnt

(all are pools related field.)

workqueue_freezing is special, it is protected by both of wq_mutext
pools_mutex. All are because get_unbound_pool() need to read it,
which are because POOL_FREEZING is a bad design which will be fixed later.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   66 ++++++++++++++++++++++++++++-----------------------
 1 files changed, 36 insertions(+), 30 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index fb81159..cc5eb61 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -125,7 +125,9 @@ enum {
  *
  * WQ: wq_mutex protected.
  *
- * WR: wq_mutex protected for writes.  Sched-RCU protected for reads.
+ * PS: pools_mutex protected.
+ *
+ * PR: pools_mutex protected for writes.  Sched-RCU protected for reads.
  *
  * PW: pwq_lock protected.
  *
@@ -163,8 +165,8 @@ struct worker_pool {
 	struct idr		worker_idr;	/* MG: worker IDs and iteration */
 
 	struct workqueue_attrs	*attrs;		/* I: worker attributes */
-	struct hlist_node	hash_node;	/* WQ: unbound_pool_hash node */
-	int			refcnt;		/* WQ: refcnt for unbound pools */
+	struct hlist_node	hash_node;	/* PS: unbound_pool_hash node */
+	int			refcnt;		/* PS: refcnt for unbound pools */
 
 	/*
 	 * The current concurrency level.  As it's likely to be accessed
@@ -256,20 +258,21 @@ struct workqueue_struct {
 
 static struct kmem_cache *pwq_cache;
 
-static DEFINE_MUTEX(wq_mutex);		/* protects workqueues and pools */
+static DEFINE_MUTEX(wq_mutex);		/* protects workqueues */
+static DEFINE_MUTEX(pools_mutex);	/* protects pools */
 static DEFINE_SPINLOCK(pwq_lock);	/* protects pool_workqueues */
 static DEFINE_SPINLOCK(wq_mayday_lock);	/* protects wq->maydays list */
 
 static LIST_HEAD(workqueues);		/* WQ: list of all workqueues */
-static bool workqueue_freezing;		/* WQ: have wqs started freezing? */
+static bool workqueue_freezing;		/* WQ&PS: have wqs started freezing? */
 
 /* the per-cpu worker pools */
 static DEFINE_PER_CPU_SHARED_ALIGNED(struct worker_pool [NR_STD_WORKER_POOLS],
 				     cpu_worker_pools);
 
-static DEFINE_IDR(worker_pool_idr);	/* WR: idr of all pools */
+static DEFINE_IDR(worker_pool_idr);	/* PR: idr of all pools */
 
-/* WQ: hash of all unbound pools keyed by pool->attrs */
+/* PS: hash of all unbound pools keyed by pool->attrs */
 static DEFINE_HASHTABLE(unbound_pool_hash, UNBOUND_POOL_HASH_ORDER);
 
 /* I: attributes used when instantiating standard unbound pools on demand */
@@ -293,10 +296,10 @@ static void copy_workqueue_attrs(struct workqueue_attrs *to,
 #define CREATE_TRACE_POINTS
 #include <trace/events/workqueue.h>
 
-#define assert_rcu_or_wq_mutex()					\
+#define assert_rcu_or_pools_mutex()					\
 	rcu_lockdep_assert(rcu_read_lock_sched_held() ||		\
-			   lockdep_is_held(&wq_mutex),			\
-			   "sched RCU or wq_mutex should be held")
+			   lockdep_is_held(&pools_mutex),		\
+			   "sched RCU or pools_mutex should be held")
 
 #define assert_rcu_or_pwq_lock()					\
 	rcu_lockdep_assert(rcu_read_lock_sched_held() ||		\
@@ -322,7 +325,7 @@ static void copy_workqueue_attrs(struct workqueue_attrs *to,
  * @pool: iteration cursor
  * @pi: integer used for iteration
  *
- * This must be called either with wq_mutex held or sched RCU read locked.
+ * This must be called either with pools_mutex held or sched RCU read locked.
  * If the pool needs to be used beyond the locking in effect, the caller is
  * responsible for guaranteeing that the pool stays online.
  *
@@ -331,7 +334,7 @@ static void copy_workqueue_attrs(struct workqueue_attrs *to,
  */
 #define for_each_pool(pool, pi)						\
 	idr_for_each_entry(&worker_pool_idr, pool, pi)			\
-		if (({ assert_rcu_or_wq_mutex(); false; })) { }		\
+		if (({ assert_rcu_or_pools_mutex(); false; })) { }		\
 		else
 
 /**
@@ -488,7 +491,7 @@ static int worker_pool_assign_id(struct worker_pool *pool)
 {
 	int ret;
 
-	lockdep_assert_held(&wq_mutex);
+	lockdep_assert_held(&pools_mutex);
 
 	do {
 		if (!idr_pre_get(&worker_pool_idr, GFP_KERNEL))
@@ -606,9 +609,9 @@ static struct pool_workqueue *get_work_pwq(struct work_struct *work)
  *
  * Return the worker_pool @work was last associated with.  %NULL if none.
  *
- * Pools are created and destroyed under wq_mutex, and allows read access
+ * Pools are created and destroyed under pools_mutex, and allows read access
  * under sched-RCU read lock.  As such, this function should be called
- * under wq_mutex or with preemption disabled.
+ * under pools_mutex or with preemption disabled.
  *
  * All fields of the returned pool are accessible as long as the above
  * mentioned locking is in effect.  If the returned pool needs to be used
@@ -620,7 +623,7 @@ static struct worker_pool *get_work_pool(struct work_struct *work)
 	unsigned long data = atomic_long_read(&work->data);
 	int pool_id;
 
-	assert_rcu_or_wq_mutex();
+	assert_rcu_or_pools_mutex();
 
 	if (data & WORK_STRUCT_PWQ)
 		return ((struct pool_workqueue *)
@@ -3428,16 +3431,16 @@ static void put_unbound_pool(struct worker_pool *pool)
 {
 	struct worker *worker;
 
-	mutex_lock(&wq_mutex);
+	mutex_lock(&pools_mutex);
 	if (--pool->refcnt) {
-		mutex_unlock(&wq_mutex);
+		mutex_unlock(&pools_mutex);
 		return;
 	}
 
 	/* sanity checks */
 	if (WARN_ON(!(pool->flags & POOL_DISASSOCIATED)) ||
 	    WARN_ON(!list_empty(&pool->worklist))) {
-		mutex_unlock(&wq_mutex);
+		mutex_unlock(&pools_mutex);
 		return;
 	}
 
@@ -3446,7 +3449,7 @@ static void put_unbound_pool(struct worker_pool *pool)
 		idr_remove(&worker_pool_idr, pool->id);
 	hash_del(&pool->hash_node);
 
-	mutex_unlock(&wq_mutex);
+	mutex_unlock(&pools_mutex);
 
 	/*
 	 * Become the manager and destroy all workers.  Grabbing
@@ -3488,7 +3491,7 @@ static struct worker_pool *get_unbound_pool(const struct workqueue_attrs *attrs)
 	u32 hash = wqattrs_hash(attrs);
 	struct worker_pool *pool;
 
-	mutex_lock(&wq_mutex);
+	mutex_lock(&pools_mutex);
 
 	/* do we already have a matching pool? */
 	hash_for_each_possible(unbound_pool_hash, pool, hash_node, hash) {
@@ -3519,10 +3522,10 @@ static struct worker_pool *get_unbound_pool(const struct workqueue_attrs *attrs)
 	/* install */
 	hash_add(unbound_pool_hash, &pool->hash_node, hash);
 out_unlock:
-	mutex_unlock(&wq_mutex);
+	mutex_unlock(&pools_mutex);
 	return pool;
 fail:
-	mutex_unlock(&wq_mutex);
+	mutex_unlock(&pools_mutex);
 	if (pool)
 		put_unbound_pool(pool);
 	return NULL;
@@ -4199,7 +4202,7 @@ static int __cpuinit workqueue_cpu_up_callback(struct notifier_block *nfb,
 
 	case CPU_DOWN_FAILED:
 	case CPU_ONLINE:
-		mutex_lock(&wq_mutex);
+		mutex_lock(&pools_mutex);
 
 		for_each_pool(pool, pi) {
 			mutex_lock(&pool->manager_mutex);
@@ -4217,7 +4220,7 @@ static int __cpuinit workqueue_cpu_up_callback(struct notifier_block *nfb,
 			mutex_unlock(&pool->manager_mutex);
 		}
 
-		mutex_unlock(&wq_mutex);
+		mutex_unlock(&pools_mutex);
 		break;
 	}
 	return NOTIFY_OK;
@@ -4304,16 +4307,18 @@ void freeze_workqueues_begin(void)
 
 	mutex_lock(&wq_mutex);
 
+	/* set FREEZING */
+	mutex_lock(&pools_mutex);
 	WARN_ON_ONCE(workqueue_freezing);
 	workqueue_freezing = true;
 
-	/* set FREEZING */
 	for_each_pool(pool, pi) {
 		spin_lock_irq(&pool->lock);
 		WARN_ON_ONCE(pool->flags & POOL_FREEZING);
 		pool->flags |= POOL_FREEZING;
 		spin_unlock_irq(&pool->lock);
 	}
+	mutex_unlock(&pools_mutex);
 
 	/* suppress further executions by setting max_active to zero */
 	spin_lock_irq(&pwq_lock);
@@ -4394,12 +4399,15 @@ void thaw_workqueues(void)
 		goto out_unlock;
 
 	/* clear FREEZING */
+	mutex_lock(&pools_mutex);
+	workqueue_freezing = false;
 	for_each_pool(pool, pi) {
 		spin_lock_irq(&pool->lock);
 		WARN_ON_ONCE(!(pool->flags & POOL_FREEZING));
 		pool->flags &= ~POOL_FREEZING;
 		spin_unlock_irq(&pool->lock);
 	}
+	mutex_unlock(&pools_mutex);
 
 	/* restore max_active and repopulate worklist */
 	spin_lock_irq(&pwq_lock);
@@ -4408,8 +4416,6 @@ void thaw_workqueues(void)
 			pwq_adjust_max_active(pwq);
 	}
 	spin_unlock_irq(&pwq_lock);
-
-	workqueue_freezing = false;
 out_unlock:
 	mutex_unlock(&wq_mutex);
 }
@@ -4443,9 +4449,9 @@ static int __init init_workqueues(void)
 			pool->attrs->nice = std_nice[i++];
 
 			/* alloc pool ID */
-			mutex_lock(&wq_mutex);
+			mutex_lock(&pools_mutex);
 			BUG_ON(worker_pool_assign_id(pool));
-			mutex_unlock(&wq_mutex);
+			mutex_unlock(&pools_mutex);
 		}
 	}
 
-- 
1.7.7.6

