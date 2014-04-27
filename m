Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753270AbaD0EIe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 00:08:34 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:44510 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752631AbaD0EFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 00:05:30 -0400
X-IronPort-AV: E=Sophos;i="4.97,936,1389715200"; 
   d="scan'208";a="29778303"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>
CC: Tejun Heo <tj@kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 02/10] workqueue: destroy_worker() should destroy idle workers only
Date: Sun, 27 Apr 2014 12:08:57 +0800
Message-ID: <1398571754-12443-3-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1398571754-12443-1-git-send-email-laijs@cn.fujitsu.com>
References: <1398571754-12443-1-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If destroy_worker() destroys a non-idle worker, it will be buggy
and it is extremely hard to check. We should force destroy_worker()
to destroy idle workers only.

We had already ensured in the code that we only pass idle workers
to destroy_worker(), so this change has no functionality changed.
We just need to update the comments and the sanity check code.

In the sanity check code, we will refuse to destroy the worker
if !(worker->flags & WORKER_IDLE).

If the worker entered idle which means it is already started,
so we remove the check of "worker->flags & WORKER_STARTED",
after this removal, WORKER_STARTED is totally unneeded,
so we remove WORKER_STARTED too.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   19 +++++++++----------
 1 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 48a22e4..7690d0c 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -73,7 +73,6 @@ enum {
 	POOL_FREEZING		= 1 << 3,	/* freeze in progress */
 
 	/* worker flags */
-	WORKER_STARTED		= 1 << 0,	/* started */
 	WORKER_DIE		= 1 << 1,	/* die die die */
 	WORKER_IDLE		= 1 << 2,	/* is idle */
 	WORKER_PREP		= 1 << 3,	/* preparing to run works */
@@ -1692,9 +1691,8 @@ static struct worker *alloc_worker(void)
  * create_worker - create a new workqueue worker
  * @pool: pool the new worker will belong to
  *
- * Create a new worker which is bound to @pool.  The returned worker
- * can be started by calling start_worker() or destroyed using
- * destroy_worker().
+ * Create a new worker which is bound to @pool.
+ * The new worker should be started and enter idle by start_worker().
  *
  * CONTEXT:
  * Might sleep.  Does GFP_KERNEL allocations.
@@ -1778,7 +1776,6 @@ fail:
  */
 static void start_worker(struct worker *worker)
 {
-	worker->flags |= WORKER_STARTED;
 	worker->pool->nr_workers++;
 	worker_enter_idle(worker);
 	wake_up_process(worker->task);
@@ -1815,6 +1812,7 @@ static int create_and_start_worker(struct worker_pool *pool)
  * @worker: worker to be destroyed
  *
  * Destroy @worker and adjust @pool stats accordingly.
+ * The worker should be idle(WORKER_IDLE).
  *
  * CONTEXT:
  * spin_lock_irq(pool->lock) which is released and regrabbed.
@@ -1828,13 +1826,13 @@ static void destroy_worker(struct worker *worker)
 
 	/* sanity check frenzy */
 	if (WARN_ON(worker->current_work) ||
-	    WARN_ON(!list_empty(&worker->scheduled)))
+	    WARN_ON(!list_empty(&worker->scheduled)) ||
+	    WARN_ON(!(worker->flags & WORKER_IDLE)) ||
+	    WARN_ON(pool->nr_workers == 1 && !list_empty(&pool->worklist)))
 		return;
 
-	if (worker->flags & WORKER_STARTED)
-		pool->nr_workers--;
-	if (worker->flags & WORKER_IDLE)
-		pool->nr_idle--;
+	pool->nr_workers--;
+	pool->nr_idle--;
 
 	/*
 	 * Once WORKER_DIE is set, the kworker may destroy itself at any
@@ -3589,6 +3587,7 @@ static void put_unbound_pool(struct worker_pool *pool)
 	mutex_lock(&pool->manager_mutex);
 	spin_lock_irq(&pool->lock);
 
+	WARN_ON(pool->nr_workers != pool->nr_idle);
 	while ((worker = first_worker(pool)))
 		destroy_worker(worker);
 	WARN_ON(pool->nr_workers || pool->nr_idle);
-- 
1.7.4.4

