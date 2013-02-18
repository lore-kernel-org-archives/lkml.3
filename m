Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755788Ab3BRQQN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 11:16:13 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:5866 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753336Ab3BRQOA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 11:14:00 -0500
X-IronPort-AV: E=Sophos;i="4.84,688,1355068800"; 
   d="scan'208";a="6724946"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH V2 07/15] workqueue: change argument of worker_maybe_bind_and_lock() to pool
Date: Tue, 19 Feb 2013 00:12:08 +0800
Message-Id: <1361203940-6300-8-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1361203940-6300-1-git-send-email-laijs@cn.fujitsu.com>
References: <1361203940-6300-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/19 00:13:22,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/19 00:13:22,
	Serialize complete at 2013/02/19 00:13:22
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We plan to only set rescuer->pool in the C.S. of pool->lock,
so when worker_maybe_bind_and_lock() is called, the worker(rescuer)->pool
may NULL. Thus we need to change the worker_maybe_bind_and_lock() API,
we need to add a @pool argument to it or use @pool argument instead of
@worker argument. we choice the later one.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index b47d1af..b987195 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1552,8 +1552,10 @@ static void worker_leave_idle(struct worker *worker)
 }
 
 /**
- * worker_maybe_bind_and_lock - bind worker to its cpu if possible and lock pool
- * @worker: self
+ * worker_maybe_bind_and_lock - bind current worker if possible and lock pool
+ * @pool: target pool
+ *
+ * Bind the worker(of current task) to the cpu of the pool if it is associated.
  *
  * Works which are scheduled while the cpu is online must at least be
  * scheduled to a worker which is bound to the cpu so that if they are
@@ -1581,11 +1583,9 @@ static void worker_leave_idle(struct worker *worker)
  * %true if the associated pool is online (@worker is successfully
  * bound), %false if offline.
  */
-static bool worker_maybe_bind_and_lock(struct worker *worker)
+static bool worker_maybe_bind_and_lock(struct worker_pool *pool)
 __acquires(&pool->lock)
 {
-	struct worker_pool *pool = worker->pool;
-
 	while (true) {
 		/*
 		 * The following call may fail, succeed or succeed
@@ -1623,7 +1623,7 @@ __acquires(&pool->lock)
 static void idle_worker_rebind(struct worker *worker)
 {
 	/* CPU may go down again inbetween, clear UNBOUND only on success */
-	if (worker_maybe_bind_and_lock(worker))
+	if (worker_maybe_bind_and_lock(worker->pool))
 		worker_clr_flags(worker, WORKER_UNBOUND);
 
 	/* rebind complete, become available again */
@@ -1641,7 +1641,7 @@ static void busy_worker_rebind_fn(struct work_struct *work)
 {
 	struct worker *worker = container_of(work, struct worker, rebind_work);
 
-	if (worker_maybe_bind_and_lock(worker))
+	if (worker_maybe_bind_and_lock(worker->pool))
 		worker_clr_flags(worker, WORKER_UNBOUND);
 
 	spin_unlock_irq(&worker->pool->lock);
@@ -2093,7 +2093,7 @@ static bool manage_workers(struct worker *worker)
 		 * on @pool's current state.  Try it and adjust
 		 * %WORKER_UNBOUND accordingly.
 		 */
-		if (worker_maybe_bind_and_lock(worker))
+		if (worker_maybe_bind_and_lock(pool))
 			worker->flags &= ~WORKER_UNBOUND;
 		else
 			worker->flags |= WORKER_UNBOUND;
@@ -2413,7 +2413,7 @@ repeat:
 
 		/* migrate to the target cpu if possible */
 		rescuer->pool = pool;
-		worker_maybe_bind_and_lock(rescuer);
+		worker_maybe_bind_and_lock(pool);
 
 		/*
 		 * Slurp in all works issued via this workqueue and
-- 
1.7.7.6

