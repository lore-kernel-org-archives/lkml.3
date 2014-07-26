Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760578AbaGZDE2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 23:04:28 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:16072 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752014AbaGZDEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 23:04:06 -0400
X-IronPort-AV: E=Sophos;i="5.00,965,1396972800"; 
   d="scan'208";a="33802429"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>
CC: Tejun Heo <tj@kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 3/3] workqueue: cleanup may_start_working()
Date: Sat, 26 Jul 2014 11:04:51 +0800
Message-ID: <1406343900-32423-4-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1406343900-32423-1-git-send-email-laijs@cn.fujitsu.com>
References: <1406343900-32423-1-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The name of may_start_working() became misleading due to the semantics of
"!pool->nr_idle" is changed and any worker can start working in spite of
the value of pool->nr_idle.

So we remove the may_start_working() and use "!pool->nr_idle" directly,
need_to_create_worker() is also removed along with it.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   37 +++++++++++++------------------------
 1 files changed, 13 insertions(+), 24 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index ce8e3fc..e1ab4f9 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -735,12 +735,6 @@ static bool need_more_worker(struct worker_pool *pool)
 	return !list_empty(&pool->worklist) && __need_more_worker(pool);
 }
 
-/* Can I start working?  Called from busy but !running workers. */
-static bool may_start_working(struct worker_pool *pool)
-{
-	return pool->nr_idle;
-}
-
 /* Do I need to keep working?  Called from currently running workers. */
 static bool keep_working(struct worker_pool *pool)
 {
@@ -748,12 +742,6 @@ static bool keep_working(struct worker_pool *pool)
 		atomic_read(&pool->nr_running) <= 1;
 }
 
-/* Do we need a new worker?  Called from manager. */
-static bool need_to_create_worker(struct worker_pool *pool)
-{
-	return need_more_worker(pool) && !may_start_working(pool);
-}
-
 /* Do we have too many workers and should some go away? */
 static bool too_many_workers(struct worker_pool *pool)
 {
@@ -1815,19 +1803,20 @@ static void pool_mayday_timeout(unsigned long __pool)
 	spin_lock_irq(&wq_mayday_lock);		/* for wq->maydays */
 	spin_lock(&pool->lock);
 
-	if (need_to_create_worker(pool)) {
-		/*
-		 * We've been trying to create a new worker but
-		 * haven't been successful.  We might be hitting an
-		 * allocation deadlock.  Send distress signals to
-		 * rescuers.
-		 */
-		list_for_each_entry(work, &pool->worklist, entry)
-			send_mayday(work);
-	}
+	if (!pool->nr_idle) {
+		if (need_more_worker(pool)) {
+			/*
+			 * We've been trying to create a new worker but
+			 * haven't been successful.  We might be hitting an
+			 * allocation deadlock.  Send distress signals to
+			 * rescuers.
+			 */
+			list_for_each_entry(work, &pool->worklist, entry)
+				send_mayday(work);
+		}
 
-	if (!pool->nr_idle)
 		mod_timer(&pool->mayday_timer, jiffies + MAYDAY_INTERVAL);
+	}
 
 	spin_unlock(&pool->lock);
 	spin_unlock_irq(&wq_mayday_lock);
@@ -2097,7 +2086,7 @@ woke_up:
 		goto sleep;
 
 	/* do we need to create worker? */
-	if (unlikely(!may_start_working(pool)))
+	if (unlikely(!pool->nr_idle))
 		start_creater_work(pool);
 
 	/*
-- 
1.7.4.4

