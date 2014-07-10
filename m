Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753878AbaGJQAZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 12:00:25 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:31651 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752750AbaGJQAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 12:00:21 -0400
X-IronPort-AV: E=Sophos;i="5.00,869,1396972800"; 
   d="scan'208";a="33107680"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>
CC: Tejun Heo <tj@kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 2/3] workqueue: remove the guarantee and the retrying of maybe_create_worker()
Date: Fri, 11 Jul 2014 00:01:04 +0800
Message-ID: <1405008074-11031-3-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1405008074-11031-1-git-send-email-laijs@cn.fujitsu.com>
References: <1405008074-11031-1-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

maybe_create_worker() has a strong guarantee that there has at least
one idle worker on return from this function.  This guarantee is guaranteed
via the check and the retrying in this function.

But the caller (worker_thread()) also has the same check and retrying,
so the guarantee is not really required and the check and the retrying in
maybe_create_worker() are unnecessary and redundant.

So we remove the guarantee as well as the check and the retrying.  The caller
takes responsibility to retry when needed.

The only trade-off is that the mayday timer will be removed and re-added
across retrying. Since retrying is expected as rare case, the trade-off
is acceptible.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   49 ++++++++++++++++++-------------------------------
 1 files changed, 18 insertions(+), 31 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 92f7ea0c..4fdd6d0 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1875,14 +1875,17 @@ static void pool_mayday_timeout(unsigned long __pool)
  * @pool: pool to create a new worker for
  *
  * Create a new worker for @pool if necessary.  @pool is guaranteed to
- * have at least one idle worker on return from this function.  If
- * creating a new worker takes longer than MAYDAY_INTERVAL, mayday is
+ * make some progresses on return from this function.
+ *   1) success to create a new idle worker.  Or
+ *   2) cool down a while after it failed.  Or
+ *   3) condition changed (no longer need to create worker) after it failed.
+ * In any case, the caller will recheck the condition and retry when needed,
+ * so this function doesn't need to retry.
+ *
+ * If creating a new worker takes longer than MAYDAY_INTERVAL, mayday is
  * sent to all rescuers with works scheduled on @pool to resolve
  * possible allocation deadlock.
  *
- * On return, need_to_create_worker() is guaranteed to be %false and
- * may_start_working() %true.
- *
  * LOCKING:
  * spin_lock_irq(pool->lock) which may be released and regrabbed
  * multiple times.  Does GFP_KERNEL allocations.  Called only from
@@ -1892,38 +1895,26 @@ static void maybe_create_worker(struct worker_pool *pool)
 __releases(&pool->lock)
 __acquires(&pool->lock)
 {
-restart:
+	struct worker *worker;
+
 	spin_unlock_irq(&pool->lock);
 
 	/* if we don't make progress in MAYDAY_INITIAL_TIMEOUT, call for help */
 	mod_timer(&pool->mayday_timer, jiffies + MAYDAY_INITIAL_TIMEOUT);
 
-	while (true) {
-		struct worker *worker;
-
-		worker = create_worker(pool);
-		if (worker) {
-			del_timer_sync(&pool->mayday_timer);
-			spin_lock_irq(&pool->lock);
-			start_worker(worker);
-			if (WARN_ON_ONCE(need_to_create_worker(pool)))
-				goto restart;
-			return;
-		}
-
-		if (!need_to_create_worker(pool))
-			break;
+	worker = create_worker(pool);
+	if (worker) {
+		del_timer_sync(&pool->mayday_timer);
+		spin_lock_irq(&pool->lock);
+		start_worker(worker);
+		return;
+	}
 
+	if (need_to_create_worker(pool))
 		schedule_timeout_interruptible(CREATE_COOLDOWN);
 
-		if (!need_to_create_worker(pool))
-			break;
-	}
-
 	del_timer_sync(&pool->mayday_timer);
 	spin_lock_irq(&pool->lock);
-	if (need_to_create_worker(pool))
-		goto restart;
 }
 
 /**
@@ -1934,10 +1925,6 @@ restart:
  * to.  At any given time, there can be only zero or one manager per
  * pool.  The exclusion is handled automatically by this function.
  *
- * The caller can safely start processing works on false return.  On
- * true return, it's guaranteed that need_to_create_worker() is false
- * and may_start_working() is true.
- *
  * CONTEXT:
  * spin_lock_irq(pool->lock) which may be released and regrabbed
  * multiple times.  Does GFP_KERNEL allocations.
-- 
1.7.4.4

