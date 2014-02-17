Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754011AbaBQSOu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 13:14:50 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:43349 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753020AbaBQSOq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 13:14:46 -0500
X-IronPort-AV: E=Sophos;i="4.95,862,1384272000"; 
   d="scan'208";a="9545762"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] workqueue: kick worker to die directly in idle timeout handler
Date: Tue, 18 Feb 2014 00:24:03 +0800
Message-Id: <1392654243-2829-4-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1392654243-2829-1-git-send-email-laijs@cn.fujitsu.com>
References: <1392472948-2486-1-git-send-email-laijs@cn.fujitsu.com>
 <1392654243-2829-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/02/18 00:22:13,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/02/18 00:22:15,
	Serialize complete at 2014/02/18 00:22:15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

since original destroy_worker() does not do the full-destruction,
its main work just deprives the worker-duty from worker-thread and kick
it to die, so we rename it to kick_worker_to_die().

And since kick_worker_to_die() don't need manager_mutex and sleeping,
so we move maybe_destroy_worker() out from manager and kick worker to die
directly in idle timeout handler. And we remove %POOL_MANAGE_WORKERS which
help us remove a branch in worker_thread().

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   85 ++++++++--------------------------------------------
 1 files changed, 13 insertions(+), 72 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 6634326..1a672c5 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -68,7 +68,6 @@ enum {
 	 * manager_mutex to avoid changing binding state while
 	 * create_worker() is in progress.
 	 */
-	POOL_MANAGE_WORKERS	= 1 << 0,	/* need to manage workers */
 	POOL_DISASSOCIATED	= 1 << 2,	/* cpu can't serve workers */
 	POOL_FREEZING		= 1 << 3,	/* freeze in progress */
 
@@ -756,13 +755,6 @@ static bool need_to_create_worker(struct worker_pool *pool)
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
@@ -1698,7 +1690,7 @@ static struct worker *alloc_worker(void)
  *
  * Create a new worker which is bound to @pool.  The returned worker
  * can be started by calling start_worker() or destroyed using
- * destroy_worker().
+ * kick_worker_to_die().
  *
  * CONTEXT:
  * Might sleep.  Does GFP_KERNEL allocations.
@@ -1826,19 +1818,19 @@ static int create_and_start_worker(struct worker_pool *pool)
 }
 
 /**
- * destroy_worker - destroy a workqueue worker
- * @worker: worker to be destroyed
+ * kick_worker_to_die - kick a workqueue worker to die
+ * @worker: worker to die
  *
- * Destroy @worker and adjust @pool stats accordingly.
+ * Kick @worker to die and adjust @pool stats accordingly.
+ * The @worker will be dying in the flight.
  *
  * CONTEXT:
- * spin_lock_irq(pool->lock) which is released and regrabbed.
+ * spin_lock_irq(pool->lock).
  */
-static void destroy_worker(struct worker *worker)
+static void kick_worker_to_die(struct worker *worker)
 {
 	struct worker_pool *pool = worker->pool;
 
-	lockdep_assert_held(&pool->manager_mutex);
 	lockdep_assert_held(&pool->lock);
 
 	/* sanity check frenzy */
@@ -1861,8 +1853,7 @@ static void idle_worker_timeout(unsigned long __pool)
 	struct worker_pool *pool = (void *)__pool;
 
 	spin_lock_irq(&pool->lock);
-
-	if (too_many_workers(pool)) {
+	while (too_many_workers(pool)) {
 		struct worker *worker;
 		unsigned long expires;
 
@@ -1870,15 +1861,13 @@ static void idle_worker_timeout(unsigned long __pool)
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
 
+		kick_worker_to_die(worker);
+	}
 	spin_unlock_irq(&pool->lock);
 }
 
@@ -1989,44 +1978,6 @@ restart:
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
@@ -2089,13 +2040,6 @@ static bool manage_workers(struct worker *worker)
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
@@ -2342,9 +2286,6 @@ recheck:
 
 	worker_set_flags(worker, WORKER_PREP, false);
 sleep:
-	if (unlikely(need_to_manage_workers(pool)) && manage_workers(worker))
-		goto recheck;
-
 	/*
 	 * pool->lock is held and there's no work to process and no need to
 	 * manage, sleep.  Workers are woken up only while holding
@@ -3577,7 +3518,7 @@ static void put_unbound_pool(struct worker_pool *pool)
 
 	spin_lock_irq(&pool->lock);
 	while ((worker = first_worker(pool)))
-		destroy_worker(worker);
+		kick_worker_to_die(worker);
 	WARN_ON(pool->nr_workers || pool->nr_idle);
 	spin_unlock_irq(&pool->lock);
 
-- 
1.7.7.6

