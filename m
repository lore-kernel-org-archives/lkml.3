Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752412AbaJVAhJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 20:37:09 -0400
Received: from mga02.intel.com ([134.134.136.20]:28981 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750769AbaJVAhI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 20:37:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,765,1406617200"; 
   d="scan'208";a="593411671"
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: Juri Lelli <juri.lelli@arm.com>, Kirill V Tkhai <tkhai@yandex.ru>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Wanpeng Li <wanpeng.li@linux.intel.com>
Subject: [PATCH v3] sched/deadline: do not try to push tasks if pinned task switches to dl
Date: Wed, 22 Oct 2014 08:36:43 +0800
Message-Id: <1413938203-224610-1-git-send-email-wanpeng.li@linux.intel.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As Kirill mentioned(https://lkml.org/lkml/2013/1/29/118):
| If rq has already had 2 or more pushable tasks and we try to add a 
| pinned task then call of push_rt_task will just waste a time.

Just switched pinned task is not able to be pushed. If the rq has had
several dl tasks before they have already been considered as candidates
to be pushed (or pulled). This patch implements the same behavior as rt 
class which introduced by commit 10447917551e ("sched/rt: Do not try to 
push tasks if pinned task switches to RT"). 

Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
---
v2 -> v3:
 * cleanup patch description
 * align && to p->nr_cpus_allowed
v1 -> v2:
 * use 12 or more chars for the git commit ID

 kernel/sched/deadline.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index abfaf3d..bd5e479 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -1603,7 +1603,8 @@ static void switched_to_dl(struct rq *rq, struct task_struct *p)
 
 	if (task_on_rq_queued(p) && rq->curr != p) {
 #ifdef CONFIG_SMP
-		if (rq->dl.overloaded && push_dl_task(rq) && rq != task_rq(p))
+		if (p->nr_cpus_allowed > 1 && rq->dl.overloaded &&
+			push_dl_task(rq) && rq != task_rq(p))
 			/* Only reschedule if pushing failed */
 			check_resched = 0;
 #endif /* CONFIG_SMP */
-- 
1.9.1

