Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755072AbaDRNXP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 09:23:15 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:11381 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754618AbaDRNWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 09:22:21 -0400
X-IronPort-AV: E=Sophos;i="4.97,883,1389715200"; 
   d="scan'208";a="29446813"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, <linux-kernel@vger.kernel.org>
CC: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 1/2 V4] workqueue: rescuer_thread() processes all pwqs before exit
Date: Fri, 18 Apr 2014 21:25:54 +0800
Message-ID: <1397827555-19641-1-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <20140417162720.GQ15326@htj.dyndns.org>
References: <20140417162720.GQ15326@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before the rescuer is picked to running, the works of the @pwq
may be processed by some other workers, and destroy_workqueue()
may called at the same time. This may result a nasty situation
that rescuer may exit with non-empty mayday list.

It is no harm currently, destroy_workqueue() can safely to free
them all(workqueue&pwqs) togerther, since the rescuer is stopped.
No rescuer nor mayday-timer can access the mayday list.

But it is nasty and error-prone in future development. Fix it.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   21 +++++++++++++++------
 1 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 0ee63af..7539244 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2398,6 +2398,7 @@ static int rescuer_thread(void *__rescuer)
 	struct worker *rescuer = __rescuer;
 	struct workqueue_struct *wq = rescuer->rescue_wq;
 	struct list_head *scheduled = &rescuer->scheduled;
+	bool should_stop;
 
 	set_user_nice(current, RESCUER_NICE_LEVEL);
 
@@ -2408,12 +2409,14 @@ static int rescuer_thread(void *__rescuer)
 	rescuer->task->flags |= PF_WQ_WORKER;
 repeat:
 	set_current_state(TASK_INTERRUPTIBLE);
-
-	if (kthread_should_stop()) {
-		__set_current_state(TASK_RUNNING);
-		rescuer->task->flags &= ~PF_WQ_WORKER;
-		return 0;
-	}
+	/*
+	 * When the rescuer is requested to stop, the workqueue has no
+	 * work pending, but wq->maydays may still have pwq(s) queued.
+	 * This can happend when some other workers process all works
+	 * before this rescuer is scheduled. The rescuer must process
+	 * all pwq(s) before exit.
+	 */
+	should_stop = kthread_should_stop();
 
 	/* see whether any pwq is asking for help */
 	spin_lock_irq(&wq_mayday_lock);
@@ -2459,6 +2462,12 @@ repeat:
 
 	spin_unlock_irq(&wq_mayday_lock);
 
+	if (should_stop) {
+		__set_current_state(TASK_RUNNING);
+		rescuer->task->flags &= ~PF_WQ_WORKER;
+		return 0;
+	}
+
 	/* rescuers should never participate in concurrency management */
 	WARN_ON_ONCE(!(rescuer->flags & WORKER_NOT_RUNNING));
 	schedule();
-- 
1.7.4.4

