Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934AbaGJQAz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 12:00:55 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:60630 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752461AbaGJQAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 12:00:20 -0400
X-IronPort-AV: E=Sophos;i="5.00,869,1396972800"; 
   d="scan'208";a="33107679"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>
CC: Tejun Heo <tj@kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 1/3] workqueue: remove the first check and the return value of maybe_create_worker()
Date: Fri, 11 Jul 2014 00:01:03 +0800
Message-ID: <1405008074-11031-2-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1405008074-11031-1-git-send-email-laijs@cn.fujitsu.com>
References: <1405008074-11031-1-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pool->lock is kept locked during the time the worker_thread() checks the
condition and maybe_create_worker() is called, therefore, the condition
is unchanged and the first condition check is unneeded.

After this unneeded check is removed, maybe_create_worker() only returns
true, so we remove the return value of it and adjust the call-site.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   18 +++++-------------
 1 files changed, 5 insertions(+), 13 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index f344334..92f7ea0c 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1887,17 +1887,11 @@ static void pool_mayday_timeout(unsigned long __pool)
  * spin_lock_irq(pool->lock) which may be released and regrabbed
  * multiple times.  Does GFP_KERNEL allocations.  Called only from
  * manager.
- *
- * Return:
- * %false if no action was taken and pool->lock stayed locked, %true
- * otherwise.
  */
-static bool maybe_create_worker(struct worker_pool *pool)
+static void maybe_create_worker(struct worker_pool *pool)
 __releases(&pool->lock)
 __acquires(&pool->lock)
 {
-	if (!need_to_create_worker(pool))
-		return false;
 restart:
 	spin_unlock_irq(&pool->lock);
 
@@ -1914,7 +1908,7 @@ restart:
 			start_worker(worker);
 			if (WARN_ON_ONCE(need_to_create_worker(pool)))
 				goto restart;
-			return true;
+			return;
 		}
 
 		if (!need_to_create_worker(pool))
@@ -1930,7 +1924,6 @@ restart:
 	spin_lock_irq(&pool->lock);
 	if (need_to_create_worker(pool))
 		goto restart;
-	return true;
 }
 
 /**
@@ -1959,7 +1952,6 @@ restart:
 static bool manage_workers(struct worker *worker)
 {
 	struct worker_pool *pool = worker->pool;
-	bool ret = false;
 
 	/*
 	 * Anyone who successfully grabs manager_arb wins the arbitration
@@ -1972,12 +1964,12 @@ static bool manage_workers(struct worker *worker)
 	 * actual management, the pool may stall indefinitely.
 	 */
 	if (!mutex_trylock(&pool->manager_arb))
-		return ret;
+		return false;
 
-	ret |= maybe_create_worker(pool);
+	maybe_create_worker(pool);
 
 	mutex_unlock(&pool->manager_arb);
-	return ret;
+	return true;
 }
 
 /**
-- 
1.7.4.4

