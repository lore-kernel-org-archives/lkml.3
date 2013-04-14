Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752854Ab3DNQmn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 12:42:43 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:7826 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752061Ab3DNQmk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 12:42:40 -0400
X-IronPort-AV: E=Sophos;i="4.87,471,1363104000"; 
   d="scan'208";a="7051543"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 2/8] workqueue: use create_and_start_worker() in manage_workers()
Date: Mon, 15 Apr 2013 00:41:50 +0800
Message-Id: <1365957716-7631-3-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1365957716-7631-1-git-send-email-laijs@cn.fujitsu.com>
References: <1365957716-7631-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/15 00:41:03,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/15 00:41:03,
	Serialize complete at 2013/04/15 00:41:03
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After we allocated worker, we are free to access the worker without and
protection before it is visiable/published.

In old code, worker is published by start_worker(), and it is visiable only
after start_worker(), but in current code, it is visiable by
for_each_pool_worker() after
"idr_replace(&pool->worker_idr, worker, worker->id);"

It means the step of publishing worker is not atomic, it is very fragile.
(although I did not find any bug from it in current code). it should be fixed.

It can be fixed by moving "idr_replace(&pool->worker_idr, worker, worker->id);"
to start_worker() or by folding start_worker() in to create_worker().

I choice the second one. It makes the code much simple.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   62 +++++++++++++++------------------------------------
 1 files changed, 18 insertions(+), 44 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index b3095ad..d1e10c5 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -64,7 +64,7 @@ enum {
 	 *
 	 * Note that DISASSOCIATED should be flipped only while holding
 	 * manager_mutex to avoid changing binding state while
-	 * create_worker() is in progress.
+	 * create_and_start_worker_locked() is in progress.
 	 */
 	POOL_MANAGE_WORKERS	= 1 << 0,	/* need to manage workers */
 	POOL_DISASSOCIATED	= 1 << 2,	/* cpu can't serve workers */
@@ -1542,7 +1542,10 @@ static void worker_enter_idle(struct worker *worker)
 			 (worker->hentry.next || worker->hentry.pprev)))
 		return;
 
-	/* can't use worker_set_flags(), also called from start_worker() */
+	/*
+	 * can't use worker_set_flags(), also called from
+	 * create_and_start_worker_locked().
+	 */
 	worker->flags |= WORKER_IDLE;
 	pool->nr_idle++;
 	worker->last_active = jiffies;
@@ -1663,12 +1666,10 @@ static struct worker *alloc_worker(void)
 }
 
 /**
- * create_worker - create a new workqueue worker
+ * create_and_start_worker_locked - create and start a worker for a pool
  * @pool: pool the new worker will belong to
  *
- * Create a new worker which is bound to @pool.  The returned worker
- * can be started by calling start_worker() or destroyed using
- * destroy_worker().
+ * Create a new worker which is bound to @pool and start it.
  *
  * CONTEXT:
  * Might sleep.  Does GFP_KERNEL allocations.
@@ -1676,7 +1677,7 @@ static struct worker *alloc_worker(void)
  * RETURNS:
  * Pointer to the newly created worker.
  */
-static struct worker *create_worker(struct worker_pool *pool)
+static struct worker *create_and_start_worker_locked(struct worker_pool *pool)
 {
 	struct worker *worker = NULL;
 	int id = -1;
@@ -1734,9 +1735,15 @@ static struct worker *create_worker(struct worker_pool *pool)
 	if (pool->flags & POOL_DISASSOCIATED)
 		worker->flags |= WORKER_UNBOUND;
 
-	/* successful, commit the pointer to idr */
 	spin_lock_irq(&pool->lock);
+	/* successful, commit the pointer to idr */
 	idr_replace(&pool->worker_idr, worker, worker->id);
+
+	/* start worker */
+	worker->flags |= WORKER_STARTED;
+	worker->pool->nr_workers++;
+	worker_enter_idle(worker);
+	wake_up_process(worker->task);
 	spin_unlock_irq(&pool->lock);
 
 	return worker;
@@ -1752,23 +1759,6 @@ fail:
 }
 
 /**
- * start_worker - start a newly created worker
- * @worker: worker to start
- *
- * Make the pool aware of @worker and start it.
- *
- * CONTEXT:
- * spin_lock_irq(pool->lock).
- */
-static void start_worker(struct worker *worker)
-{
-	worker->flags |= WORKER_STARTED;
-	worker->pool->nr_workers++;
-	worker_enter_idle(worker);
-	wake_up_process(worker->task);
-}
-
-/**
  * create_and_start_worker - create and start a worker for a pool
  * @pool: the target pool
  *
@@ -1779,14 +1769,7 @@ static int create_and_start_worker(struct worker_pool *pool)
 	struct worker *worker;
 
 	mutex_lock(&pool->manager_mutex);
-
-	worker = create_worker(pool);
-	if (worker) {
-		spin_lock_irq(&pool->lock);
-		start_worker(worker);
-		spin_unlock_irq(&pool->lock);
-	}
-
+	worker = create_and_start_worker_locked(pool);
 	mutex_unlock(&pool->manager_mutex);
 
 	return worker ? 0 : -ENOMEM;
@@ -1934,17 +1917,8 @@ restart:
 	mod_timer(&pool->mayday_timer, jiffies + MAYDAY_INITIAL_TIMEOUT);
 
 	while (true) {
-		struct worker *worker;
-
-		worker = create_worker(pool);
-		if (worker) {
-			del_timer_sync(&pool->mayday_timer);
-			spin_lock_irq(&pool->lock);
-			start_worker(worker);
-			if (WARN_ON_ONCE(need_to_create_worker(pool)))
-				goto restart;
-			return true;
-		}
+		if (create_and_start_worker_locked(pool))
+			break;
 
 		if (!need_to_create_worker(pool))
 			break;
-- 
1.7.7.6

