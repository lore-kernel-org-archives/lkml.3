Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753179AbaGNIMj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 04:12:39 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:43077 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751025AbaGNIMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 04:12:19 -0400
X-IronPort-AV: E=Sophos;i="5.00,887,1396972800"; 
   d="scan'208";a="33229592"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>
CC: Tejun Heo <tj@kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 1/1 V2] workqueue: remove the del_timer_sync()s in maybe_create_worker()
Date: Mon, 14 Jul 2014 16:13:21 +0800
Message-ID: <1405325601-12437-2-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1405325601-12437-1-git-send-email-laijs@cn.fujitsu.com>
References: <1405265479-827-1-git-send-email-laijs@cn.fujitsu.com>
 <1405325601-12437-1-git-send-email-laijs@cn.fujitsu.com>
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
  1) don't requeue the mayday timer unless the manager is working
       it is a preparation/cleanup step for the fix. Otherwise the timer
       will repeat forever if we only do the 2).
  2) remove the del_timer_sync()s in maybe_create_worker()
       the timer is still repeating, we should not use del_timer_sync(),
       let the timer dismiss itself.

Change from V1:
  V1 incorrectly stops the timer when !need_to_create_worker(),
  but no one can restart it when needed. In V2, we stops the
  timer only when manager is not working.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 338d418..9c86a64 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1864,10 +1864,11 @@ static void pool_mayday_timeout(unsigned long __pool)
 			send_mayday(work);
 	}
 
+	if (mutex_is_locked(&pool->manager_arb))
+		mod_timer(&pool->mayday_timer, jiffies + MAYDAY_INTERVAL);
+
 	spin_unlock(&pool->lock);
 	spin_unlock_irq(&wq_mayday_lock);
-
-	mod_timer(&pool->mayday_timer, jiffies + MAYDAY_INTERVAL);
 }
 
 /**
@@ -1909,7 +1910,6 @@ restart:
 
 		worker = create_worker(pool);
 		if (worker) {
-			del_timer_sync(&pool->mayday_timer);
 			spin_lock_irq(&pool->lock);
 			start_worker(worker);
 			if (WARN_ON_ONCE(need_to_create_worker(pool)))
@@ -1926,7 +1926,6 @@ restart:
 			break;
 	}
 
-	del_timer_sync(&pool->mayday_timer);
 	spin_lock_irq(&pool->lock);
 	if (need_to_create_worker(pool))
 		goto restart;
-- 
1.7.4.4

