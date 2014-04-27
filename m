Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753301AbaD0EJA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 00:09:00 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:6442 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752618AbaD0EF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 00:05:29 -0400
X-IronPort-AV: E=Sophos;i="4.97,936,1389715200"; 
   d="scan'208";a="29778302"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>
CC: Tejun Heo <tj@kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 01/10] workqueue: use manager lock only to protect worker_idr
Date: Sun, 27 Apr 2014 12:08:56 +0800
Message-ID: <1398571754-12443-2-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1398571754-12443-1-git-send-email-laijs@cn.fujitsu.com>
References: <1398571754-12443-1-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

worker_idr is highly bound to managers and is always/only accessed in manager
lock context. So we don't need pool->lock for it.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   34 ++++++----------------------------
 1 files changed, 6 insertions(+), 28 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index c3f076f..48a22e4 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -124,8 +124,7 @@ enum {
  *    cpu or grabbing pool->lock is enough for read access.  If
  *    POOL_DISASSOCIATED is set, it's identical to L.
  *
- * MG: pool->manager_mutex and pool->lock protected.  Writes require both
- *     locks.  Reads can happen under either lock.
+ * M: pool->manager_mutex protected.
  *
  * PL: wq_pool_mutex protected.
  *
@@ -164,7 +163,7 @@ struct worker_pool {
 	/* see manage_workers() for details on the two manager mutexes */
 	struct mutex		manager_arb;	/* manager arbitration */
 	struct mutex		manager_mutex;	/* manager exclusion */
-	struct idr		worker_idr;	/* MG: worker IDs and iteration */
+	struct idr		worker_idr;	/* M: worker IDs and iteration */
 
 	struct workqueue_attrs	*attrs;		/* I: worker attributes */
 	struct hlist_node	hash_node;	/* PL: unbound_pool_hash node */
@@ -340,16 +339,6 @@ static void copy_workqueue_attrs(struct workqueue_attrs *to,
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
@@ -378,14 +367,14 @@ static void copy_workqueue_attrs(struct workqueue_attrs *to,
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
@@ -1725,13 +1714,7 @@ static struct worker *create_worker(struct worker_pool *pool)
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
 
@@ -1773,18 +1756,13 @@ static struct worker *create_worker(struct worker_pool *pool)
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

