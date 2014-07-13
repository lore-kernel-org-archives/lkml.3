Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983AbaGMPaW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 11:30:22 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:8420 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753860AbaGMPaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 11:30:18 -0400
X-IronPort-AV: E=Sophos;i="5.00,885,1396972800"; 
   d="scan'208";a="33207295"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>
CC: Tejun Heo <tj@kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH] workqueue: remove the del_timer_sync()s in maybe_create_worker()
Date: Sun, 13 Jul 2014 23:31:19 +0800
Message-ID: <1405265479-827-1-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is said in the document that the timer which is being
deleted by del_timer_sync() should not be restarted:
  Synchronization rules: Callers must prevent restarting of
  the timer, otherwise this function is meaningless.

Repeating timer may cause the del_timer_sync() spin longer,
or even spin forever in very very very very extreme condition.

It is not considered a bug for me, but it disobeys the document.

To fix it, we need:
  1) don't requeue the mayday timer when !need_to_create_worker()
       it is a preparation/cleaup step for the fix. Otherwise the timer
       will repeat forever if we only do the 2).
  2) remove the del_timer_sync()s in maybe_create_worker()
       Fix the problem. It is not enough if we only do the 1),
       need_to_create_worker() would be probably true when the time
       del_timer_sync() is called, the timer is still repeating.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 35974ac..593b9bc 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1866,12 +1866,12 @@ static void pool_mayday_timeout(unsigned long __pool)
 		 */
 		list_for_each_entry(work, &pool->worklist, entry)
 			send_mayday(work);
+
+		mod_timer(&pool->mayday_timer, jiffies + MAYDAY_INTERVAL);
 	}
 
 	spin_unlock(&pool->lock);
 	spin_unlock_irq(&wq_mayday_lock);
-
-	mod_timer(&pool->mayday_timer, jiffies + MAYDAY_INTERVAL);
 }
 
 /**
@@ -1913,7 +1913,6 @@ restart:
 
 		worker = create_worker(pool);
 		if (worker) {
-			del_timer_sync(&pool->mayday_timer);
 			spin_lock_irq(&pool->lock);
 			start_worker(worker);
 			if (WARN_ON_ONCE(need_to_create_worker(pool)))
@@ -1931,7 +1930,6 @@ restart:
 			break;
 	}
 
-	del_timer_sync(&pool->mayday_timer);
 	spin_lock_irq(&pool->lock);
 	if (need_to_create_worker(pool))
 		goto restart;
-- 
1.7.7.6

