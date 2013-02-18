Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756022Ab3BRQOq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 11:14:46 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:42372 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755264Ab3BRQOo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 11:14:44 -0500
X-IronPort-AV: E=Sophos;i="4.84,688,1355068800"; 
   d="scan'208";a="6724954"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH V2 14/15] workqueue: convert busy hash to busy list
Date: Tue, 19 Feb 2013 00:12:15 +0800
Message-Id: <1361203940-6300-15-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1361203940-6300-1-git-send-email-laijs@cn.fujitsu.com>
References: <1361203940-6300-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/19 00:14:04,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/19 00:14:04,
	Serialize complete at 2013/02/19 00:14:04
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since we don't use the hashtable, thus we can use list to implement
the for_each_busy_worker().

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c          |   27 ++++++++++-----------------
 kernel/workqueue_internal.h |    9 +++------
 2 files changed, 13 insertions(+), 23 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index a23f4fc..6d7dd78 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -41,7 +41,6 @@
 #include <linux/debug_locks.h>
 #include <linux/lockdep.h>
 #include <linux/idr.h>
-#include <linux/hashtable.h>
 #include <linux/rcupdate.h>
 
 #include "workqueue_internal.h"
@@ -138,9 +137,8 @@ struct worker_pool {
 	struct timer_list	idle_timer;	/* L: worker idle timeout */
 	struct timer_list	mayday_timer;	/* L: SOS timer for workers */
 
-	/* workers are chained either in busy_hash or idle_list */
-	DECLARE_HASHTABLE(busy_hash, BUSY_WORKER_HASH_ORDER);
-						/* L: hash of busy workers */
+	/* workers are chained either in busy_list or idle_list */
+	struct list_head	busy_list;	/* L: list of busy workers */
 
 	struct mutex		assoc_mutex;	/* protect POOL_DISASSOCIATED */
 	struct ida		worker_ida;	/* L: for worker IDs */
@@ -250,8 +248,8 @@ EXPORT_SYMBOL_GPL(system_freezable_wq);
 	for ((pool) = &std_worker_pools(cpu)[0];			\
 	     (pool) < &std_worker_pools(cpu)[NR_STD_WORKER_POOLS]; (pool)++)
 
-#define for_each_busy_worker(worker, i, pos, pool)			\
-	hash_for_each(pool->busy_hash, i, pos, worker, hentry)
+#define for_each_busy_worker(worker, pool)			\
+	list_for_each_entry(worker, &pool->busy_list, entry)
 
 static inline int __next_wq_cpu(int cpu, const struct cpumask *mask,
 				unsigned int sw)
@@ -1499,8 +1497,7 @@ static void worker_enter_idle(struct worker *worker)
 	struct worker_pool *pool = worker->pool;
 
 	BUG_ON(worker->flags & WORKER_IDLE);
-	BUG_ON(!list_empty(&worker->entry) &&
-	       (worker->hentry.next || worker->hentry.pprev));
+	BUG_ON(!list_empty(&worker->entry));
 
 	/* can't use worker_set_flags(), also called from start_worker() */
 	worker->flags |= WORKER_IDLE;
@@ -1664,8 +1661,6 @@ static void busy_worker_rebind_fn(struct work_struct *work)
 static void rebind_workers(struct worker_pool *pool)
 {
 	struct worker *worker, *n;
-	struct hlist_node *pos;
-	int i;
 
 	lockdep_assert_held(&pool->assoc_mutex);
 	lockdep_assert_held(&pool->lock);
@@ -1686,7 +1681,7 @@ static void rebind_workers(struct worker_pool *pool)
 	}
 
 	/* rebind busy workers */
-	for_each_busy_worker(worker, i, pos, pool) {
+	for_each_busy_worker(worker, pool) {
 		struct work_struct *rebind_work = &worker->rebind_work;
 		struct workqueue_struct *wq;
 
@@ -2175,7 +2170,7 @@ __acquires(&pool->lock)
 
 	/* claim and dequeue */
 	debug_work_deactivate(work);
-	hash_add(pool->busy_hash, &worker->hentry, (unsigned long)work);
+	list_add(&worker->entry, &pool->busy_list);
 	worker->current_work = work;
 	worker->current_func = work->func;
 	worker->current_cwq = cwq;
@@ -2236,7 +2231,7 @@ __acquires(&pool->lock)
 		worker_clr_flags(worker, WORKER_CPU_INTENSIVE);
 
 	/* we're done with it, release */
-	hash_del(&worker->hentry);
+	list_del_init(&worker->entry);
 	worker->current_work = NULL;
 	worker->current_func = NULL;
 	worker->current_cwq = NULL;
@@ -3490,8 +3485,6 @@ static void wq_unbind_fn(struct work_struct *work)
 	int cpu = smp_processor_id();
 	struct worker_pool *pool;
 	struct worker *worker;
-	struct hlist_node *pos;
-	int i;
 
 	for_each_std_worker_pool(pool, cpu) {
 		BUG_ON(cpu != smp_processor_id());
@@ -3509,7 +3502,7 @@ static void wq_unbind_fn(struct work_struct *work)
 		list_for_each_entry(worker, &pool->idle_list, entry)
 			worker->flags |= WORKER_UNBOUND;
 
-		for_each_busy_worker(worker, i, pos, pool)
+		for_each_busy_worker(worker, pool)
 			worker->flags |= WORKER_UNBOUND;
 
 		pool->flags |= POOL_DISASSOCIATED;
@@ -3812,7 +3805,7 @@ static int __init init_workqueues(void)
 			pool->flags |= POOL_DISASSOCIATED;
 			INIT_LIST_HEAD(&pool->worklist);
 			INIT_LIST_HEAD(&pool->idle_list);
-			hash_init(pool->busy_hash);
+			INIT_LIST_HEAD(&pool->busy_list);
 
 			init_timer_deferrable(&pool->idle_timer);
 			pool->idle_timer.function = idle_worker_timeout;
diff --git a/kernel/workqueue_internal.h b/kernel/workqueue_internal.h
index bc0ce95..3406f2e 100644
--- a/kernel/workqueue_internal.h
+++ b/kernel/workqueue_internal.h
@@ -14,17 +14,14 @@ struct worker_pool;
 
 /*
  * The poor guys doing the actual heavy lifting.  All on-duty workers are
- * either serving the manager role, on idle list or on busy hash.  For
+ * either serving the manager role, on idle list or on busy list.  For
  * details on the locking annotation (L, I, X...), refer to workqueue.c.
  *
  * Only to be used in workqueue and async.
  */
 struct worker {
-	/* on idle list while idle, on busy hash table while busy */
-	union {
-		struct list_head	entry;	/* L: while idle */
-		struct hlist_node	hentry;	/* L: while busy */
-	};
+	/* on idle list while idle, on busy list while busy */
+	struct list_head	entry;		/* L: idle/busy list */
 
 	struct work_struct	*current_work;	/* L: work being processed */
 	work_func_t		current_func;	/* L: current_work's fn */
-- 
1.7.7.6

