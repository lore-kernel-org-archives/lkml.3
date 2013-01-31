Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756723Ab3AaSni (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 13:43:38 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:63106 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756648Ab3AaSmB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 13:42:01 -0500
X-IronPort-AV: E=Sophos;i="4.84,578,1355068800"; 
   d="scan'208";a="6672840"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 09/13] workqueue: add lock_pool_queued_work()
Date: Fri, 1 Feb 2013 02:41:32 +0800
Message-Id: <1359657696-2767-10-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1359657696-2767-1-git-send-email-laijs@cn.fujitsu.com>
References: <1359657696-2767-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/01 02:40:50,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/01 02:40:51,
	Serialize complete at 2013/02/01 02:40:51
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Extract lock code from try_to_grab_pending() and name it lock_pool_queued_work().
It makes the code better readability and make try_to_grab_pending() shorter,

And this new function can be reused by other(later patch).

Add/Use proper locking API.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |  100 ++++++++++++++++++++++++++++++---------------------
 1 files changed, 59 insertions(+), 41 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 6e92f18..a108788 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -971,6 +971,45 @@ static struct worker_pool *lock_pool_executing_work(struct work_struct *work,
 	return NULL;
 }
 
+/** lock_pool_queued_work - lock the pool a given work is queued on
+ * @work: work of interest
+ *
+ * CONTEXT:
+ * local_irq_disable()
+ *
+ * RETURNS:
+ * Pointer to work pool(and locked) on which @work is queued if found,
+ * NULL otherwise.
+ */
+static struct worker_pool *lock_pool_queued_work(struct work_struct *work)
+{
+	struct cpu_workqueue_struct *cwq = get_work_cwq(work);
+	struct worker_pool *pool;
+
+	if (!cwq)
+		return NULL;
+
+	pool = cwq->pool;
+	spin_lock(&pool->lock);
+	/*
+	 * The CWQ bit is set/cleared only when we do enqueue/dequeue the work
+	 * When a work is enqueued(insert_work()) to a pool:
+	 *	we set cwq(CWQ bit) with pool->lock held
+	 * when a work is dequeued(process_one_work(),try_to_grab_pending()):
+	 *	we clear cwq(CWQ bit) with pool->lock held
+	 *
+	 * So when if the pool->lock is held, we can determine:
+	 * 	CWQ bit is set and the cwq->pool == pool
+	 * 	<==> the work is queued on the pool
+	 */
+	cwq = get_work_cwq(work);
+	if (cwq && cwq->pool == pool)
+		return pool;
+	spin_unlock(&pool->lock);
+
+	return NULL;
+}
+
 /**
  * move_linked_works - move linked works to a list
  * @work: start of series of works to be scheduled
@@ -1104,7 +1143,6 @@ static int try_to_grab_pending(struct work_struct *work, bool is_dwork,
 			       unsigned long *flags)
 {
 	struct worker_pool *pool;
-	struct cpu_workqueue_struct *cwq;
 
 	local_irq_save(*flags);
 
@@ -1129,49 +1167,29 @@ static int try_to_grab_pending(struct work_struct *work, bool is_dwork,
 	 * The queueing is in progress, or it is already queued. Try to
 	 * steal it from ->worklist without clearing WORK_STRUCT_PENDING.
 	 */
-	pool = get_work_pool(work);
-	if (!pool)
-		goto fail;
-
-	spin_lock(&pool->lock);
-	/*
-	 * The CWQ bit is set/cleared only when we do enqueue/dequeue the work
-	 * When a work is enqueued(insert_work()) to a pool:
-	 *	we set cwq(CWQ bit) with pool->lock held
-	 * when a work is dequeued(process_one_work(),try_to_grab_pending()):
-	 *	we clear cwq(CWQ bit) with pool->lock held
-	 *
-	 * So when if the pool->lock is held, we can determine:
-	 * 	CWQ bit is set and the cwq->pool == pool
-	 * 	<==> the work is queued on the pool
-	 */
-	cwq = get_work_cwq(work);
-	if (cwq) {
-		if (pool == cwq->pool) {
-			debug_work_deactivate(work);
+	pool = lock_pool_queued_work(work);
+	if (pool) {
+		debug_work_deactivate(work);
 
-			/*
-			 * A delayed work item cannot be grabbed directly
-			 * because it might have linked NO_COLOR work items
-			 * which, if left on the delayed_list, will confuse
-			 * cwq->nr_active management later on and cause
-			 * stall.  Make sure the work item is activated
-			 * before grabbing.
-			 */
-			if (*work_data_bits(work) & WORK_STRUCT_DELAYED)
-				cwq_activate_delayed_work(work);
+		/*
+		 * A delayed work item cannot be grabbed directly
+		 * because it might have linked NO_COLOR work items
+		 * which, if left on the delayed_list, will confuse
+		 * cwq->nr_active management later on and cause
+		 * stall.  Make sure the work item is activated
+		 * before grabbing.
+		 */
+		if (*work_data_bits(work) & WORK_STRUCT_DELAYED)
+			cwq_activate_delayed_work(work);
 
-			list_del_init(&work->entry);
-			cwq_dec_nr_in_flight(get_work_cwq(work),
-				get_work_color(work));
+		list_del_init(&work->entry);
+		cwq_dec_nr_in_flight(get_work_cwq(work), get_work_color(work));
 
-			clear_work_cwq(work, pool->id);
-			spin_unlock(&pool->lock);
-			return 1;
-		}
+		clear_work_cwq(work, pool->id);
+		spin_unlock(&pool->lock);
+		return 1;
 	}
-	spin_unlock(&pool->lock);
-fail:
+
 	local_irq_restore(*flags);
 	if (work_is_canceling(work))
 		return -ENOENT;
@@ -2821,7 +2839,7 @@ static bool start_flush_work(struct work_struct *work, struct wq_barrier *barr)
 		return false;
 
 	spin_lock_irq(&pool->lock);
-	/* See the comment near try_to_grab_pending() with the same code */
+	/* See the comment near lock_pool_queued_work() with the same code */
 	cwq = get_work_cwq(work);
 	if (cwq) {
 		if (unlikely(pool != cwq->pool))
-- 
1.7.7.6

