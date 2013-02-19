Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934002Ab3BSUVE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 15:21:04 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:42124 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933529Ab3BSUVC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 15:21:02 -0500
Date: Tue, 19 Feb 2013 12:20:57 -0800
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] workqueue: change argument of
 worker_maybe_bind_and_lock() to @pool
Message-ID: <20130219202057.GW17414@htj.dyndns.org>
References: <1361203940-6300-1-git-send-email-laijs@cn.fujitsu.com>
 <1361203940-6300-8-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1361203940-6300-8-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From f8d038f52a57c25e37c547b80d327a9d4f03fd2d Mon Sep 17 00:00:00 2001
From: Lai Jiangshan <laijs@cn.fujitsu.com>
Date: Tue, 19 Feb 2013 12:17:02 -0800

worker_maybe_bind_and_lock() currently takes @worker but only cares
about @worker->pool.  This patch updates worker_maybe_bind_and_lock()
to take @pool instead of @worker.  This will be used to better define
synchronization rules regarding rescuer->pool updates.

This doesn't introduce any functional change.

tj: Updated the comments and description.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
Applied to wq/for-3.10-tmp.  Note that I'm gonna reabse the branch
once 3.9-rc1 is out.

Thanks.

 kernel/workqueue.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index cebde5b..1770b09 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1505,8 +1505,10 @@ static void worker_leave_idle(struct worker *worker)
 }
 
 /**
- * worker_maybe_bind_and_lock - bind worker to its cpu if possible and lock pool
- * @worker: self
+ * worker_maybe_bind_and_lock - try to bind %current to worker_pool and lock it
+ * @pool: target worker_pool
+ *
+ * Bind %current to the cpu of @pool if it is associated and lock @pool.
  *
  * Works which are scheduled while the cpu is online must at least be
  * scheduled to a worker which is bound to the cpu so that if they are
@@ -1534,11 +1536,9 @@ static void worker_leave_idle(struct worker *worker)
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
@@ -1576,7 +1576,7 @@ __acquires(&pool->lock)
 static void idle_worker_rebind(struct worker *worker)
 {
 	/* CPU may go down again inbetween, clear UNBOUND only on success */
-	if (worker_maybe_bind_and_lock(worker))
+	if (worker_maybe_bind_and_lock(worker->pool))
 		worker_clr_flags(worker, WORKER_UNBOUND);
 
 	/* rebind complete, become available again */
@@ -1594,7 +1594,7 @@ static void busy_worker_rebind_fn(struct work_struct *work)
 {
 	struct worker *worker = container_of(work, struct worker, rebind_work);
 
-	if (worker_maybe_bind_and_lock(worker))
+	if (worker_maybe_bind_and_lock(worker->pool))
 		worker_clr_flags(worker, WORKER_UNBOUND);
 
 	spin_unlock_irq(&worker->pool->lock);
@@ -2040,7 +2040,7 @@ static bool manage_workers(struct worker *worker)
 		 * on @pool's current state.  Try it and adjust
 		 * %WORKER_UNBOUND accordingly.
 		 */
-		if (worker_maybe_bind_and_lock(worker))
+		if (worker_maybe_bind_and_lock(pool))
 			worker->flags &= ~WORKER_UNBOUND;
 		else
 			worker->flags |= WORKER_UNBOUND;
@@ -2360,7 +2360,7 @@ repeat:
 
 		/* migrate to the target cpu if possible */
 		rescuer->pool = pool;
-		worker_maybe_bind_and_lock(rescuer);
+		worker_maybe_bind_and_lock(pool);
 
 		/*
 		 * Slurp in all works issued via this workqueue and
-- 
1.8.1

