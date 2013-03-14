Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751272Ab3CNH7T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 03:59:19 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:2913 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750913Ab3CNH7S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 03:59:18 -0400
X-IronPort-AV: E=Sophos;i="4.84,843,1355068800"; 
   d="scan'208";a="6870983"
From: liguang <lig.fnst@cn.fujitsu.com>
To: viro@zeniv.linux.org.uk, oleg@redhat.com, edumazet@google.com,
        linux-kernel@vger.kernel.org
Cc: liguang <lig.fnst@cn.fujitsu.com>
Subject: [PATCH 1/2] task_work: make FIFO task_work list
Date: Thu, 14 Mar 2013 15:57:44 +0800
Message-Id: <1363247865-3531-1-git-send-email-lig.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.2.5
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/14 15:57:55,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/14 15:57:55,
	Serialize complete at 2013/03/14 15:57:55
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: liguang <lig.fnst@cn.fujitsu.com>
---
 kernel/task_work.c |   15 +++------------
 1 files changed, 3 insertions(+), 12 deletions(-)

diff --git a/kernel/task_work.c b/kernel/task_work.c
index 65bd3c9..0bf4258 100644
--- a/kernel/task_work.c
+++ b/kernel/task_work.c
@@ -13,11 +13,12 @@ task_work_add(struct task_struct *task, struct callback_head *work, bool notify)
 		head = ACCESS_ONCE(task->task_works);
 		if (unlikely(head == &work_exited))
 			return -ESRCH;
-		work->next = head;
-	} while (cmpxchg(&task->task_works, head, work) != head);
+		head = head->next;
+	} while (cmpxchg(&head, NULL, work) == head);
 
 	if (notify)
 		set_notify_resume(task);
+
 	return 0;
 }
 
@@ -72,16 +73,6 @@ void task_work_run(void)
 		raw_spin_unlock_wait(&task->pi_lock);
 		smp_mb();
 
-		/* Reverse the list to run the works in fifo order */
-		head = NULL;
-		do {
-			next = work->next;
-			work->next = head;
-			head = work;
-			work = next;
-		} while (work);
-
-		work = head;
 		do {
 			next = work->next;
 			work->func(work);
-- 
1.7.2.5

