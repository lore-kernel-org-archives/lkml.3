Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161420AbaDPXam (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 19:30:42 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:15625 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753294AbaDPXak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 19:30:40 -0400
X-IronPort-AV: E=Sophos;i="4.97,875,1389715200"; 
   d="scan'208";a="29364837"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, <linux-kernel@vger.kernel.org>
CC: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 1/2] workqueue: rescuer_thread() processes all pwqs before exit
Date: Thu, 17 Apr 2014 07:34:08 +0800
Message-ID: <1397691258-11639-1-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <20140416165052.GK1257@htj.dyndns.org>
References: <20140416165052.GK1257@htj.dyndns.org>
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

But it is nasty and error-prone in future develop. Fix it.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 0ee63af..832125f 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2409,12 +2409,6 @@ static int rescuer_thread(void *__rescuer)
 repeat:
 	set_current_state(TASK_INTERRUPTIBLE);
 
-	if (kthread_should_stop()) {
-		__set_current_state(TASK_RUNNING);
-		rescuer->task->flags &= ~PF_WQ_WORKER;
-		return 0;
-	}
-
 	/* see whether any pwq is asking for help */
 	spin_lock_irq(&wq_mayday_lock);
 
@@ -2459,6 +2453,12 @@ repeat:
 
 	spin_unlock_irq(&wq_mayday_lock);
 
+	if (kthread_should_stop()) {
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

