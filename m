Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934096AbaDIQOq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 12:14:46 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:33613 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933923AbaDIQLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 12:11:35 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH 3/5] hung_task: Convert process iteration to use for_each_process_thread()
Date: Wed,  9 Apr 2014 18:11:20 +0200
Message-Id: <1397059882-23063-4-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1397059882-23063-1-git-send-email-fweisbec@gmail.com>
References: <1397059882-23063-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

do_each_thread/while_each_thread iterators are deprecated by
for_each_thread/for_each_process_thread() APIs.

Lets convert the callers in the hung task detector code. The ultimate
goal is to remove the struct task_struct::thread_group field and
the corresponding do_each_thread/while_each_thread iterators that are
RCU unsafe.

It also makes the hung task threads iteration eventually RCU safe.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/hung_task.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/hung_task.c b/kernel/hung_task.c
index 06bb141..d19744b 100644
--- a/kernel/hung_task.c
+++ b/kernel/hung_task.c
@@ -157,7 +157,7 @@ static void check_hung_uninterruptible_tasks(unsigned long timeout)
 {
 	int max_count = sysctl_hung_task_check_count;
 	int batch_count = HUNG_TASK_BATCHING;
-	struct task_struct *g, *t;
+	struct task_struct *p, *t;
 
 	/*
 	 * If the system crashed already then all bets are off,
@@ -167,18 +167,18 @@ static void check_hung_uninterruptible_tasks(unsigned long timeout)
 		return;
 
 	rcu_read_lock();
-	do_each_thread(g, t) {
+	for_each_process_thread(p, t) {
 		if (!max_count--)
 			goto unlock;
 		if (!--batch_count) {
 			batch_count = HUNG_TASK_BATCHING;
-			if (!rcu_lock_break(g, t))
+			if (!rcu_lock_break(p, t))
 				goto unlock;
 		}
 		/* use "==" to skip the TASK_KILLABLE tasks waiting on NFS */
 		if (t->state == TASK_UNINTERRUPTIBLE)
 			check_hung_task(t, timeout);
-	} while_each_thread(g, t);
+	}
  unlock:
 	rcu_read_unlock();
 }
-- 
1.8.3.1

