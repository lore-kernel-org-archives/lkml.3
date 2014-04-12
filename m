Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756397AbaDLKnP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2014 06:43:15 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:41984 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756097AbaDLKmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2014 06:42:40 -0400
X-IronPort-AV: E=Sophos;i="4.97,847,1389715200"; 
   d="scan'208";a="29176934"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>
CC: Lai Jiangshan <laijs@cn.fujitsu.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 6/6] workqueue: destroy worker directly in idle timeout handler
Date: Sat, 12 Apr 2014 18:45:35 +0800
Message-ID: <1397299543-12012-7-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1397299543-12012-1-git-send-email-laijs@cn.fujitsu.com>
References: <1397299543-12012-1-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since destroy_worker() is working atomically, we move maybe_destroy_worker()
out from manager and destroy worker directly in idle timeout handler.
And we remove %POOL_MANAGE_WORKERS which help us remove a branch in
worker_thread().

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   71 ++++-----------------------------------------------
 1 files changed, 6 insertions(+), 65 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 8199e7f..92c9ada 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -64,7 +64,6 @@ enum {
 	 * %WORKER_UNBOUND set and concurrency management disabled, and may
 	 * be executing on any CPU.  The pool behaves as an unbound one.
 	 */
-	POOL_MANAGE_WORKERS	= 1 << 0,	/* need to manage workers */
 	POOL_DISASSOCIATED	= 1 << 2,	/* cpu can't serve workers */
 
 	/* worker flags */
@@ -754,13 +753,6 @@ static bool need_to_create_worker(struct worker_pool *pool)
 	return need_more_worker(pool) && !may_start_working(pool);
 }
 
-/* Do I need to be the manager? */
-static bool need_to_manage_workers(struct worker_pool *pool)
-{
-	return need_to_create_worker(pool) ||
-		(pool->flags & POOL_MANAGE_WORKERS);
-}
-
 /* Do we have too many workers and should some go away? */
 static bool too_many_workers(struct worker_pool *pool)
 {
@@ -1789,7 +1781,7 @@ static int create_and_start_worker(struct worker_pool *pool)
  * Destroy @worker and adjust @pool stats accordingly.
  *
  * CONTEXT:
- * spin_lock_irq(pool->lock) which is released and regrabbed.
+ * spin_lock_irq(pool->lock).
  */
 static void destroy_worker(struct worker *worker)
 {
@@ -1819,8 +1811,7 @@ static void idle_worker_timeout(unsigned long __pool)
 	struct worker_pool *pool = (void *)__pool;
 
 	spin_lock_irq(&pool->lock);
-
-	if (too_many_workers(pool)) {
+	while (too_many_workers(pool)) {
 		struct worker *worker;
 		unsigned long expires;
 
@@ -1828,15 +1819,13 @@ static void idle_worker_timeout(unsigned long __pool)
 		worker = list_entry(pool->idle_list.prev, struct worker, entry);
 		expires = worker->last_active + IDLE_WORKER_TIMEOUT;
 
-		if (time_before(jiffies, expires))
+		if (time_before(jiffies, expires)) {
 			mod_timer(&pool->idle_timer, expires);
-		else {
-			/* it's been idle for too long, wake up manager */
-			pool->flags |= POOL_MANAGE_WORKERS;
-			wake_up_worker(pool);
+			break;
 		}
-	}
 
+		destroy_worker(worker);
+	}
 	spin_unlock_irq(&pool->lock);
 }
 
@@ -1960,44 +1949,6 @@ restart:
 }
 
 /**
- * maybe_destroy_worker - destroy workers which have been idle for a while
- * @pool: pool to destroy workers for
- *
- * Destroy @pool workers which have been idle for longer than
- * IDLE_WORKER_TIMEOUT.
- *
- * LOCKING:
- * spin_lock_irq(pool->lock) which may be released and regrabbed
- * multiple times.  Called only from manager.
- *
- * Return:
- * %false if no action was taken and pool->lock stayed locked, %true
- * otherwise.
- */
-static bool maybe_destroy_workers(struct worker_pool *pool)
-{
-	bool ret = false;
-
-	while (too_many_workers(pool)) {
-		struct worker *worker;
-		unsigned long expires;
-
-		worker = list_entry(pool->idle_list.prev, struct worker, entry);
-		expires = worker->last_active + IDLE_WORKER_TIMEOUT;
-
-		if (time_before(jiffies, expires)) {
-			mod_timer(&pool->idle_timer, expires);
-			break;
-		}
-
-		destroy_worker(worker);
-		ret = true;
-	}
-
-	return ret;
-}
-
-/**
  * manage_workers - manage worker pool
  * @worker: self
  *
@@ -2039,13 +1990,6 @@ static bool manage_workers(struct worker *worker)
 	if (!mutex_trylock(&pool->manager_arb))
 		return ret;
 
-	pool->flags &= ~POOL_MANAGE_WORKERS;
-
-	/*
-	 * Destroy and then create so that may_start_working() is true
-	 * on return.
-	 */
-	ret |= maybe_destroy_workers(pool);
 	ret |= maybe_create_worker(pool);
 
 	mutex_unlock(&pool->manager_arb);
@@ -2285,9 +2229,6 @@ recheck:
 
 	worker_set_flags(worker, WORKER_PREP, false);
 sleep:
-	if (unlikely(need_to_manage_workers(pool)) && manage_workers(worker))
-		goto recheck;
-
 	/*
 	 * pool->lock is held and there's no work to process and no need to
 	 * manage, sleep.  Workers are woken up only while holding
-- 
1.7.4.4

