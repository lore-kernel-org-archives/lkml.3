Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274AbaELGwh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 02:52:37 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:36795 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753136AbaELGwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 02:52:35 -0400
X-IronPort-AV: E=Sophos;i="4.97,1033,1389715200"; 
   d="scan'208";a="30389393"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>
CC: Tejun Heo <tj@kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 04/10 V2] workqueue: destroy worker directly in the idle timeout handler
Date: Mon, 12 May 2014 14:56:16 +0800
Message-ID: <1399877792-13046-5-git-send-email-laijs@cn.fujitsu.com>
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

Since destroy_worker() doesn't need to sleep nor require manager_mutex,
destroy_worker() can be directly called in the idle timeout
handler, it helps us remove POOL_MANAGE_WORKERS and
maybe_destroy_worker() and simplify the manage_workers()

After POOL_MANAGE_WORKERS is removed, worker_thread() doesn't
need to test whether it needs to manage after processed works.
So we can remove the test branch.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   69 ++++------------------------------------------------
 1 files changed, 5 insertions(+), 64 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 465e751..95695c3 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -68,7 +68,6 @@ enum {
 	 * manager_mutex to avoid changing binding state while
 	 * create_worker() is in progress.
 	 */
-	POOL_MANAGE_WORKERS	= 1 << 0,	/* need to manage workers */
 	POOL_DISASSOCIATED	= 1 << 2,	/* cpu can't serve workers */
 	POOL_FREEZING		= 1 << 3,	/* freeze in progress */
 
@@ -752,13 +751,6 @@ static bool need_to_create_worker(struct worker_pool *pool)
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
@@ -1867,8 +1859,7 @@ static void idle_worker_timeout(unsigned long __pool)
 	struct worker_pool *pool = (void *)__pool;
 
 	spin_lock_irq(&pool->lock);
-
-	if (too_many_workers(pool)) {
+	while (too_many_workers(pool)) {
 		struct worker *worker;
 		unsigned long expires;
 
@@ -1876,15 +1867,13 @@ static void idle_worker_timeout(unsigned long __pool)
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
 
@@ -2001,44 +1990,6 @@ restart:
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
@@ -2101,13 +2052,6 @@ static bool manage_workers(struct worker *worker)
 		ret = true;
 	}
 
-	pool->flags &= ~POOL_MANAGE_WORKERS;
-
-	/*
-	 * Destroy and then create so that may_start_working() is true
-	 * on return.
-	 */
-	ret |= maybe_destroy_workers(pool);
 	ret |= maybe_create_worker(pool);
 
 	mutex_unlock(&pool->manager_mutex);
@@ -2349,9 +2293,6 @@ recheck:
 
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

