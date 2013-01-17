Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758407Ab3AQBnR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 20:43:17 -0500
Received: from mail-ie0-f178.google.com ([209.85.223.178]:44605 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758360Ab3AQBnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 20:43:12 -0500
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Tejun Heo <tj@kernel.org>
Subject: [PATCH 11/17] workqueue: make hotplug processing per-pool
Date: Wed, 16 Jan 2013 17:42:43 -0800
Message-Id: <1358386969-945-12-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <1358386969-945-1-git-send-email-tj@kernel.org>
References: <1358386969-945-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of holding locks from both pools and then processing the pools
together, make hotplug processing per-pool - grab locks of one pool,
process it, release it and then proceed to the next pool.

rebind_workers() is updated to take and process @pool instead of @gcwq
which results in a lot of de-indentation.  gcwq_claim_assoc_and_lock()
and its counterpart are replaced with in-line per-pool locking.

While this patch changes processing order across pools, order within
each pool remains the same.  As each pool is independent, this
shouldn't break anything.

This is part of an effort to remove global_cwq and make worker_pool
the top level abstraction, which in turn will help implementing worker
pools with user-specified attributes.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c | 149 ++++++++++++++++++++++-------------------------------
 1 file changed, 62 insertions(+), 87 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 755d2c4..92e4d99 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1689,10 +1689,10 @@ static void busy_worker_rebind_fn(struct work_struct *work)
 }
 
 /**
- * rebind_workers - rebind all workers of a gcwq to the associated CPU
- * @gcwq: gcwq of interest
+ * rebind_workers - rebind all workers of a pool to the associated CPU
+ * @pool: pool of interest
  *
- * @gcwq->cpu is coming online.  Rebind all workers to the CPU.  Rebinding
+ * @pool->cpu is coming online.  Rebind all workers to the CPU.  Rebinding
  * is different for idle and busy ones.
  *
  * Idle ones will be removed from the idle_list and woken up.  They will
@@ -1710,60 +1710,53 @@ static void busy_worker_rebind_fn(struct work_struct *work)
  * including the manager will not appear on @idle_list until rebind is
  * complete, making local wake-ups safe.
  */
-static void rebind_workers(struct global_cwq *gcwq)
+static void rebind_workers(struct worker_pool *pool)
 {
-	struct worker_pool *pool;
 	struct worker *worker, *n;
 	struct hlist_node *pos;
 	int i;
 
-	for_each_worker_pool(pool, gcwq) {
-		lockdep_assert_held(&pool->assoc_mutex);
-		lockdep_assert_held(&pool->lock);
-	}
+	lockdep_assert_held(&pool->assoc_mutex);
+	lockdep_assert_held(&pool->lock);
 
 	/* dequeue and kick idle ones */
-	for_each_worker_pool(pool, gcwq) {
-		list_for_each_entry_safe(worker, n, &pool->idle_list, entry) {
-			/*
-			 * idle workers should be off @pool->idle_list
-			 * until rebind is complete to avoid receiving
-			 * premature local wake-ups.
-			 */
-			list_del_init(&worker->entry);
+	list_for_each_entry_safe(worker, n, &pool->idle_list, entry) {
+		/*
+		 * idle workers should be off @pool->idle_list until rebind
+		 * is complete to avoid receiving premature local wake-ups.
+		 */
+		list_del_init(&worker->entry);
 
-			/*
-			 * worker_thread() will see the above dequeuing
-			 * and call idle_worker_rebind().
-			 */
-			wake_up_process(worker->task);
-		}
+		/*
+		 * worker_thread() will see the above dequeuing and call
+		 * idle_worker_rebind().
+		 */
+		wake_up_process(worker->task);
+	}
 
-		/* rebind busy workers */
-		for_each_busy_worker(worker, i, pos, pool) {
-			struct work_struct *rebind_work = &worker->rebind_work;
-			struct workqueue_struct *wq;
+	/* rebind busy workers */
+	for_each_busy_worker(worker, i, pos, pool) {
+		struct work_struct *rebind_work = &worker->rebind_work;
+		struct workqueue_struct *wq;
 
-			if (test_and_set_bit(WORK_STRUCT_PENDING_BIT,
-					     work_data_bits(rebind_work)))
-				continue;
+		if (test_and_set_bit(WORK_STRUCT_PENDING_BIT,
+				     work_data_bits(rebind_work)))
+			continue;
 
-			debug_work_activate(rebind_work);
+		debug_work_activate(rebind_work);
 
-			/*
-			 * wq doesn't really matter but let's keep
-			 * @worker->pool and @cwq->pool consistent for
-			 * sanity.
-			 */
-			if (std_worker_pool_pri(worker->pool))
-				wq = system_highpri_wq;
-			else
-				wq = system_wq;
-
-			insert_work(get_cwq(pool->cpu, wq), rebind_work,
-				    worker->scheduled.next,
-				    work_color_to_flags(WORK_NO_COLOR));
-		}
+		/*
+		 * wq doesn't really matter but let's keep @worker->pool
+		 * and @cwq->pool consistent for sanity.
+		 */
+		if (std_worker_pool_pri(worker->pool))
+			wq = system_highpri_wq;
+		else
+			wq = system_wq;
+
+		insert_work(get_cwq(pool->cpu, wq), rebind_work,
+			    worker->scheduled.next,
+			    work_color_to_flags(WORK_NO_COLOR));
 	}
 }
 
@@ -3506,7 +3499,7 @@ EXPORT_SYMBOL_GPL(work_busy);
  * are a lot of assumptions on strong associations among work, cwq and
  * gcwq which make migrating pending and scheduled works very
  * difficult to implement without impacting hot paths.  Secondly,
- * gcwqs serve mix of short, long and very long running works making
+ * worker pools serve mix of short, long and very long running works making
  * blocked draining impractical.
  *
  * This is solved by allowing the pools to be disassociated from the CPU
@@ -3514,32 +3507,6 @@ EXPORT_SYMBOL_GPL(work_busy);
  * cpu comes back online.
  */
 
-/* claim manager positions of all pools */
-static void gcwq_claim_assoc_and_lock(struct global_cwq *gcwq)
-{
-	struct worker_pool *pool;
-
-	for_each_worker_pool(pool, gcwq)
-		mutex_lock_nested(&pool->assoc_mutex, pool - gcwq->pools);
-
-	local_irq_disable();
-	for_each_worker_pool(pool, gcwq)
-		spin_lock_nested(&pool->lock, pool - gcwq->pools);
-}
-
-/* release manager positions */
-static void gcwq_release_assoc_and_unlock(struct global_cwq *gcwq)
-{
-	struct worker_pool *pool;
-
-	for_each_worker_pool(pool, gcwq)
-		spin_unlock(&pool->lock);
-	local_irq_enable();
-
-	for_each_worker_pool(pool, gcwq)
-		mutex_unlock(&pool->assoc_mutex);
-}
-
 static void gcwq_unbind_fn(struct work_struct *work)
 {
 	struct global_cwq *gcwq = get_gcwq(smp_processor_id());
@@ -3548,17 +3515,19 @@ static void gcwq_unbind_fn(struct work_struct *work)
 	struct hlist_node *pos;
 	int i;
 
-	BUG_ON(gcwq->pools[0].cpu != smp_processor_id());
+	for_each_worker_pool(pool, gcwq) {
+		BUG_ON(pool->cpu != smp_processor_id());
 
-	gcwq_claim_assoc_and_lock(gcwq);
+		mutex_lock(&pool->assoc_mutex);
+		spin_lock_irq(&pool->lock);
 
-	/*
-	 * We've claimed all manager positions.  Make all workers unbound
-	 * and set DISASSOCIATED.  Before this, all workers except for the
-	 * ones which are still executing works from before the last CPU
-	 * down must be on the cpu.  After this, they may become diasporas.
-	 */
-	for_each_worker_pool(pool, gcwq) {
+		/*
+		 * We've claimed all manager positions.  Make all workers
+		 * unbound and set DISASSOCIATED.  Before this, all workers
+		 * except for the ones which are still executing works from
+		 * before the last CPU down must be on the cpu.  After
+		 * this, they may become diasporas.
+		 */
 		list_for_each_entry(worker, &pool->idle_list, entry)
 			worker->flags |= WORKER_UNBOUND;
 
@@ -3566,9 +3535,10 @@ static void gcwq_unbind_fn(struct work_struct *work)
 			worker->flags |= WORKER_UNBOUND;
 
 		pool->flags |= POOL_DISASSOCIATED;
-	}
 
-	gcwq_release_assoc_and_unlock(gcwq);
+		spin_unlock_irq(&pool->lock);
+		mutex_unlock(&pool->assoc_mutex);
+	}
 
 	/*
 	 * Call schedule() so that we cross rq->lock and thus can guarantee
@@ -3624,11 +3594,16 @@ static int __cpuinit workqueue_cpu_up_callback(struct notifier_block *nfb,
 
 	case CPU_DOWN_FAILED:
 	case CPU_ONLINE:
-		gcwq_claim_assoc_and_lock(gcwq);
-		for_each_worker_pool(pool, gcwq)
+		for_each_worker_pool(pool, gcwq) {
+			mutex_lock(&pool->assoc_mutex);
+			spin_lock_irq(&pool->lock);
+
 			pool->flags &= ~POOL_DISASSOCIATED;
-		rebind_workers(gcwq);
-		gcwq_release_assoc_and_unlock(gcwq);
+			rebind_workers(pool);
+
+			spin_unlock_irq(&pool->lock);
+			mutex_unlock(&pool->assoc_mutex);
+		}
 		break;
 	}
 	return NOTIFY_OK;
-- 
1.8.0.2

