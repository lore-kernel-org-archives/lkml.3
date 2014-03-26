Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755135AbaCZOii (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 10:38:38 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:10445 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751616AbaCZOih (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 10:38:37 -0400
X-IronPort-AV: E=Sophos;i="4.97,735,1389715200"; 
   d="scan'208";a="9771567"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH] workqueue: use manager lock only to protect worker_idr
Date: Wed, 26 Mar 2014 22:41:47 +0800
Message-Id: <1395844907-24186-1-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/26 22:35:22,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/26 22:35:22,
	Serialize complete at 2014/03/26 22:35:22
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

worker_idr is always accessed in manager lock context currently.
worker_idr is highly related to managers, it will be unlikely
accessed in pool->lock only in future.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   34 ++++++----------------------------
 1 files changed, 6 insertions(+), 28 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 0c74979..f5b68a3 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -123,8 +123,7 @@ enum {
  *    cpu or grabbing pool->lock is enough for read access.  If
  *    POOL_DISASSOCIATED is set, it's identical to L.
  *
- * MG: pool->manager_mutex and pool->lock protected.  Writes require both
- *     locks.  Reads can happen under either lock.
+ * M: pool->manager_mutex protected.
  *
  * PL: wq_pool_mutex protected.
  *
@@ -163,7 +162,7 @@ struct worker_pool {
 	/* see manage_workers() for details on the two manager mutexes */
 	struct mutex		manager_arb;	/* manager arbitration */
 	struct mutex		manager_mutex;	/* manager exclusion */
-	struct idr		worker_idr;	/* MG: worker IDs and iteration */
+	struct idr		worker_idr;	/* M: worker IDs and iteration */
 
 	struct workqueue_attrs	*attrs;		/* I: worker attributes */
 	struct hlist_node	hash_node;	/* PL: unbound_pool_hash node */
@@ -339,16 +338,6 @@ static void copy_workqueue_attrs(struct workqueue_attrs *to,
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
@@ -377,14 +366,14 @@ static void copy_workqueue_attrs(struct workqueue_attrs *to,
  * @wi: integer used for iteration
  * @pool: worker_pool to iterate workers of
  *
- * This must be called with either @pool->manager_mutex or ->lock held.
+ * This must be called with either @pool->manager_mutex.
  *
  * The if/else clause exists only for the lockdep assertion and can be
  * ignored.
  */
 #define for_each_pool_worker(worker, wi, pool)				\
 	idr_for_each_entry(&(pool)->worker_idr, (worker), (wi))		\
-		if (({ assert_manager_or_pool_lock((pool)); false; })) { } \
+		if (({ lockdep_assert_held(&pool->manager_mutex); false; })) { } \
 		else
 
 /**
@@ -1717,13 +1706,7 @@ static struct worker *create_worker(struct worker_pool *pool)
 	 * ID is needed to determine kthread name.  Allocate ID first
 	 * without installing the pointer.
 	 */
-	idr_preload(GFP_KERNEL);
-	spin_lock_irq(&pool->lock);
-
-	id = idr_alloc(&pool->worker_idr, NULL, 0, 0, GFP_NOWAIT);
-
-	spin_unlock_irq(&pool->lock);
-	idr_preload_end();
+	id = idr_alloc(&pool->worker_idr, NULL, 0, 0, GFP_KERNEL);
 	if (id < 0)
 		goto fail;
 
@@ -1765,18 +1748,13 @@ static struct worker *create_worker(struct worker_pool *pool)
 		worker->flags |= WORKER_UNBOUND;
 
 	/* successful, commit the pointer to idr */
-	spin_lock_irq(&pool->lock);
 	idr_replace(&pool->worker_idr, worker, worker->id);
-	spin_unlock_irq(&pool->lock);
 
 	return worker;
 
 fail:
-	if (id >= 0) {
-		spin_lock_irq(&pool->lock);
+	if (id >= 0)
 		idr_remove(&pool->worker_idr, id);
-		spin_unlock_irq(&pool->lock);
-	}
 	kfree(worker);
 	return NULL;
 }
-- 
1.7.4.4

