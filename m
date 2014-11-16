Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755480AbaKPMd1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 07:33:27 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35540 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755183AbaKPMdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 07:33:25 -0500
Date: Sun, 16 Nov 2014 04:32:47 -0800
From: tip-bot for Wanpeng Li <tipbot@zytor.com>
Message-ID: <tip-c51b8ab5ad972df26fd9c0ffad34870e98273c4c@git.kernel.org>
Cc: tglx@linutronix.de, ktkhai@parallels.com, linux-kernel@vger.kernel.org,
        juri.lelli@arm.com, hpa@zytor.com, wanpeng.li@linux.intel.com,
        mingo@kernel.org, torvalds@linux-foundation.org, peterz@infradead.org
Reply-To: tglx@linutronix.de, ktkhai@parallels.com,
        linux-kernel@vger.kernel.org, juri.lelli@arm.com, hpa@zytor.com,
        wanpeng.li@linux.intel.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org
In-Reply-To: <1415258564-8573-1-git-send-email-wanpeng.li@linux.intel.com>
References: <1415258564-8573-1-git-send-email-wanpeng.li@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/deadline: Fix rq->
 dl.pushable_tasks bug in push_dl_task()
Git-Commit-ID: c51b8ab5ad972df26fd9c0ffad34870e98273c4c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c51b8ab5ad972df26fd9c0ffad34870e98273c4c
Gitweb:     http://git.kernel.org/tip/c51b8ab5ad972df26fd9c0ffad34870e98273c4c
Author:     Wanpeng Li <wanpeng.li@linux.intel.com>
AuthorDate: Thu, 6 Nov 2014 15:22:44 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sun, 16 Nov 2014 10:58:57 +0100

sched/deadline: Fix rq->dl.pushable_tasks bug in push_dl_task()

Do not call dequeue_pushable_dl_task() when failing to push an eligible
task, as it remains pushable, merely not at this particular moment.

Actually the patch is the same behavior as commit 311e800e16f6 ("sched,
rt: Fix rq->rt.pushable_tasks bug in push_rt_task()" in -rt side.

Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Juri Lelli <juri.lelli@arm.com>
Cc: Kirill Tkhai <ktkhai@parallels.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1415258564-8573-1-git-send-email-wanpeng.li@linux.intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/deadline.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index bb1464b..9594c12 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -1328,6 +1328,7 @@ static int push_dl_task(struct rq *rq)
 {
 	struct task_struct *next_task;
 	struct rq *later_rq;
+	int ret = 0;
 
 	if (!rq->dl.overloaded)
 		return 0;
@@ -1373,7 +1374,6 @@ retry:
 			 * The task is still there. We don't try
 			 * again, some other cpu will pull it when ready.
 			 */
-			dequeue_pushable_dl_task(rq, next_task);
 			goto out;
 		}
 
@@ -1389,6 +1389,7 @@ retry:
 	deactivate_task(rq, next_task, 0);
 	set_task_cpu(next_task, later_rq->cpu);
 	activate_task(later_rq, next_task, 0);
+	ret = 1;
 
 	resched_curr(later_rq);
 
@@ -1397,7 +1398,7 @@ retry:
 out:
 	put_task_struct(next_task);
 
-	return 1;
+	return ret;
 }
 
 static void push_dl_tasks(struct rq *rq)
