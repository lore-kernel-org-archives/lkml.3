Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753845Ab3CNXCi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 19:02:38 -0400
Received: from mail-vb0-f42.google.com ([209.85.212.42]:46544 "EHLO
	mail-vb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753665Ab3CNXBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 19:01:42 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: laijs@cn.fujitsu.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 3/5] workqueue: relocate rebind_workers()
Date: Thu, 14 Mar 2013 16:01:28 -0700
Message-Id: <1363302090-16117-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1363302090-16117-1-git-send-email-tj@kernel.org>
References: <1363302090-16117-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rebind_workers() will be reimplemented in a way which makes it mostly
decoupled from the rest of worker management.  Move rebind_workers()
so that it's located with other CPU hotplug related functions.

This patch is pure function relocation.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c | 142 ++++++++++++++++++++++++++---------------------------
 1 file changed, 71 insertions(+), 71 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 384ff34..3e297c5 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1643,77 +1643,6 @@ static void busy_worker_rebind_fn(struct work_struct *work)
 	spin_unlock_irq(&worker->pool->lock);
 }
 
-/**
- * rebind_workers - rebind all workers of a pool to the associated CPU
- * @pool: pool of interest
- *
- * @pool->cpu is coming online.  Rebind all workers to the CPU.  Rebinding
- * is different for idle and busy ones.
- *
- * Idle ones will be removed from the idle_list and woken up.  They will
- * add themselves back after completing rebind.  This ensures that the
- * idle_list doesn't contain any unbound workers when re-bound busy workers
- * try to perform local wake-ups for concurrency management.
- *
- * Busy workers can rebind after they finish their current work items.
- * Queueing the rebind work item at the head of the scheduled list is
- * enough.  Note that nr_running will be properly bumped as busy workers
- * rebind.
- *
- * On return, all non-manager workers are scheduled for rebind - see
- * manage_workers() for the manager special case.  Any idle worker
- * including the manager will not appear on @idle_list until rebind is
- * complete, making local wake-ups safe.
- */
-static void rebind_workers(struct worker_pool *pool)
-{
-	struct worker *worker, *n;
-	int i;
-
-	lockdep_assert_held(&pool->manager_mutex);
-	lockdep_assert_held(&pool->lock);
-
-	/* dequeue and kick idle ones */
-	list_for_each_entry_safe(worker, n, &pool->idle_list, entry) {
-		/*
-		 * idle workers should be off @pool->idle_list until rebind
-		 * is complete to avoid receiving premature local wake-ups.
-		 */
-		list_del_init(&worker->entry);
-
-		/*
-		 * worker_thread() will see the above dequeuing and call
-		 * idle_worker_rebind().
-		 */
-		wake_up_process(worker->task);
-	}
-
-	/* rebind busy workers */
-	for_each_busy_worker(worker, i, pool) {
-		struct work_struct *rebind_work = &worker->rebind_work;
-		struct workqueue_struct *wq;
-
-		if (test_and_set_bit(WORK_STRUCT_PENDING_BIT,
-				     work_data_bits(rebind_work)))
-			continue;
-
-		debug_work_activate(rebind_work);
-
-		/*
-		 * wq doesn't really matter but let's keep @worker->pool
-		 * and @pwq->pool consistent for sanity.
-		 */
-		if (worker->pool->attrs->nice < 0)
-			wq = system_highpri_wq;
-		else
-			wq = system_wq;
-
-		insert_work(per_cpu_ptr(wq->cpu_pwqs, pool->cpu), rebind_work,
-			    worker->scheduled.next,
-			    work_color_to_flags(WORK_NO_COLOR));
-	}
-}
-
 static struct worker *alloc_worker(void)
 {
 	struct worker *worker;
@@ -4196,6 +4125,77 @@ static void wq_unbind_fn(struct work_struct *work)
 		atomic_set(&pool->nr_running, 0);
 }
 
+/**
+ * rebind_workers - rebind all workers of a pool to the associated CPU
+ * @pool: pool of interest
+ *
+ * @pool->cpu is coming online.  Rebind all workers to the CPU.  Rebinding
+ * is different for idle and busy ones.
+ *
+ * Idle ones will be removed from the idle_list and woken up.  They will
+ * add themselves back after completing rebind.  This ensures that the
+ * idle_list doesn't contain any unbound workers when re-bound busy workers
+ * try to perform local wake-ups for concurrency management.
+ *
+ * Busy workers can rebind after they finish their current work items.
+ * Queueing the rebind work item at the head of the scheduled list is
+ * enough.  Note that nr_running will be properly bumped as busy workers
+ * rebind.
+ *
+ * On return, all non-manager workers are scheduled for rebind - see
+ * manage_workers() for the manager special case.  Any idle worker
+ * including the manager will not appear on @idle_list until rebind is
+ * complete, making local wake-ups safe.
+ */
+static void rebind_workers(struct worker_pool *pool)
+{
+	struct worker *worker, *n;
+	int i;
+
+	lockdep_assert_held(&pool->manager_mutex);
+	lockdep_assert_held(&pool->lock);
+
+	/* dequeue and kick idle ones */
+	list_for_each_entry_safe(worker, n, &pool->idle_list, entry) {
+		/*
+		 * idle workers should be off @pool->idle_list until rebind
+		 * is complete to avoid receiving premature local wake-ups.
+		 */
+		list_del_init(&worker->entry);
+
+		/*
+		 * worker_thread() will see the above dequeuing and call
+		 * idle_worker_rebind().
+		 */
+		wake_up_process(worker->task);
+	}
+
+	/* rebind busy workers */
+	for_each_busy_worker(worker, i, pool) {
+		struct work_struct *rebind_work = &worker->rebind_work;
+		struct workqueue_struct *wq;
+
+		if (test_and_set_bit(WORK_STRUCT_PENDING_BIT,
+				     work_data_bits(rebind_work)))
+			continue;
+
+		debug_work_activate(rebind_work);
+
+		/*
+		 * wq doesn't really matter but let's keep @worker->pool
+		 * and @pwq->pool consistent for sanity.
+		 */
+		if (worker->pool->attrs->nice < 0)
+			wq = system_highpri_wq;
+		else
+			wq = system_wq;
+
+		insert_work(per_cpu_ptr(wq->cpu_pwqs, pool->cpu), rebind_work,
+			    worker->scheduled.next,
+			    work_color_to_flags(WORK_NO_COLOR));
+	}
+}
+
 /*
  * Workqueues should be brought up before normal priority CPU notifiers.
  * This will be registered high priority CPU notifier.
-- 
1.8.1.4

