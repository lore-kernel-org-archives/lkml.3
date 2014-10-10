Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751219AbaJJCng (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 22:43:36 -0400
Received: from mga02.intel.com ([134.134.136.20]:18975 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751067AbaJJCnd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 22:43:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,689,1406617200"; 
   d="scan'208";a="586448241"
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: Juri Lelli <juri.lelli@arm.com>, Kirill V Tkhai <tkhai@yandex.ru>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Wanpeng Li <wanpeng.li@linux.intel.com>
Subject: [PATCH] sched/deadline: do not try to push tasks if pinned task switches to dl
Date: Fri, 10 Oct 2014 10:43:17 +0800
Message-Id: <1412908997-15396-1-git-send-email-wanpeng.li@linux.intel.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As Kirill mentioned(https://lkml.org/lkml/2013/1/29/118):
| If rq has already had 2 or more pushable tasks and we try to add a 
| pinned task then call of push_rt_task will just waste a time.

Just switched pinned task is not able to be pushed. If the rq had had
several dl tasks before they have already been considered as candidates
to be pushed (or pulled). This patch does the same behavior as rt class 
which introduced by commit 104479 (sched/rt: Do not try to push tasks 
if pinned task switches to RT). 

Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
---
 kernel/sched/deadline.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index abfaf3d..cf7c9b6 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -1603,7 +1603,8 @@ static void switched_to_dl(struct rq *rq, struct task_struct *p)
 
 	if (task_on_rq_queued(p) && rq->curr != p) {
 #ifdef CONFIG_SMP
-		if (rq->dl.overloaded && push_dl_task(rq) && rq != task_rq(p))
+		if (p->nr_cpus_allowed > 1 && rq->dl.overloaded
+				&& push_dl_task(rq) && rq != task_rq(p))
 			/* Only reschedule if pushing failed */
 			check_resched = 0;
 #endif /* CONFIG_SMP */
-- 
1.9.1

