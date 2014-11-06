Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751565AbaKFHW7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 02:22:59 -0500
Received: from mga14.intel.com ([192.55.52.115]:47162 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750926AbaKFHW5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 02:22:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="412277193"
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@arm.com>
Cc: Kirill Tkhai <ktkhai@parallels.com>, linux-kernel@vger.kernel.org,
        Wanpeng Li <wanpeng.li@linux.intel.com>
Subject: [PATCH] sched/deadline: fix rq->dl.pushable_tasks bug in push_dl_task()
Date: Thu,  6 Nov 2014 15:22:44 +0800
Message-Id: <1415258564-8573-1-git-send-email-wanpeng.li@linux.intel.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do not call dequeue_pushable_dl_task() when failing to push an eligible
task, as it remains pushable, merely not at this particular moment. 
Actually the patch is the same behavior as commit 311e800e16f6 ("sched, 
rt: Fix rq->rt.pushable_tasks bug in push_rt_task()" in -rt side.

Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
---
 kernel/sched/deadline.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index f3d7776..00324af 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -1331,6 +1331,7 @@ static int push_dl_task(struct rq *rq)
 {
 	struct task_struct *next_task;
 	struct rq *later_rq;
+	int ret = 0;
 
 	if (!rq->dl.overloaded)
 		return 0;
@@ -1376,7 +1377,6 @@ retry:
 			 * The task is still there. We don't try
 			 * again, some other cpu will pull it when ready.
 			 */
-			dequeue_pushable_dl_task(rq, next_task);
 			goto out;
 		}
 
@@ -1392,6 +1392,7 @@ retry:
 	deactivate_task(rq, next_task, 0);
 	set_task_cpu(next_task, later_rq->cpu);
 	activate_task(later_rq, next_task, 0);
+	ret = 1;
 
 	resched_curr(later_rq);
 
@@ -1400,7 +1401,7 @@ retry:
 out:
 	put_task_struct(next_task);
 
-	return 1;
+	return ret;
 }
 
 static void push_dl_tasks(struct rq *rq)
-- 
1.9.1

