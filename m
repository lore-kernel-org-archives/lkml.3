Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753202AbaELGwe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 02:52:34 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:2376 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752926AbaELGwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 02:52:30 -0400
X-IronPort-AV: E=Sophos;i="4.97,1033,1389715200"; 
   d="scan'208";a="30389389"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>
CC: Tejun Heo <tj@kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 02/10 V2] workqueue: destroy_worker() should destroy idle workers only
Date: Mon, 12 May 2014 14:56:14 +0800
Message-ID: <1399877792-13046-3-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1399877792-13046-1-git-send-email-laijs@cn.fujitsu.com>
References: <20140505150514.GI11231@htj.dyndns.org>
 <1399877792-13046-1-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We used to have the CPU online failure path where a worker is created
and then destroyed without being started. A worker was created for
the CPU coming online and if the online operation failed the created worker
was shut down without being started.  But this behavior was changed.
The first worker is created and started at the same time for the CPU coming
online.

It means that we had already ensured in the code that destroy_worker()
destroys idle workers only. And we don't want to allow it destroys any
non-idle worker future. Otherwise, it may be buggy and it may be
extremely hard to check. We should force destroy_worker()
to destroy idle workers only explicitly.

Since destroy_worker() destroys idle only, this patch does not change any
functionality. We just need to update the comments and the sanity check code.

In the sanity check code, we will refuse to destroy the worker
if !(worker->flags & WORKER_IDLE).

If the worker entered idle which means it is already started,
so we remove the check of "worker->flags & WORKER_STARTED",
after this removal, WORKER_STARTED is totally unneeded,
so we remove WORKER_STARTED too.

In the comments for create_worker(), "Create a new worker which is bound..."
is changed to "... which is attached..." due to we change the name of this
behavior to attaching.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   17 +++++++----------
 1 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index d38d07c..752e109 100644
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
+ * Create a new worker which is attached to @pool.
+ * The new worker must be started and enter idle via start_worker().
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
+ * The worker should be idle.
  *
  * CONTEXT:
  * spin_lock_irq(pool->lock) which is released and regrabbed.
@@ -1828,13 +1826,12 @@ static void destroy_worker(struct worker *worker)
 
 	/* sanity check frenzy */
 	if (WARN_ON(worker->current_work) ||
-	    WARN_ON(!list_empty(&worker->scheduled)))
+	    WARN_ON(!list_empty(&worker->scheduled)) ||
+	    WARN_ON(!(worker->flags & WORKER_IDLE)))
 		return;
 
-	if (worker->flags & WORKER_STARTED)
-		pool->nr_workers--;
-	if (worker->flags & WORKER_IDLE)
-		pool->nr_idle--;
+	pool->nr_workers--;
+	pool->nr_idle--;
 
 	/*
 	 * Once WORKER_DIE is set, the kworker may destroy itself at any
-- 
1.7.4.4

