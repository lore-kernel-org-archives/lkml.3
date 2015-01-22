Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753260AbbAVSyC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 13:54:02 -0500
Received: from mga03.intel.com ([134.134.136.65]:45881 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752768AbbAVSx7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 13:53:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,450,1418112000"; 
   d="scan'208";a="516178780"
Message-ID: <1421952836.2399.58.camel@schen9-desk2.jf.intel.com>
Subject: [PATCH] sched-rt: Reduce excessive task push rate by not pushing
 tasks with equal priority as the current task
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
        Shawn Bohrer <sbohrer@rgmadvisors.com>,
        Suruchi Kadu <suruchi.a.kadu@intel.com>,
        Doug Nelson <doug.nelson@intel.com>, linux-kernel@vger.kernel.org
Date: Thu, 22 Jan 2015 10:53:56 -0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Commit 3be209a8 tries to migrate task of equal priority as the running
one to other cpus to balance load and eliminate any idle cpus.  However,
for system that is fully busy and running workload of a few priorities,
we found this change to cause tasks getting pushed around without
improving cpu utilization. On a fully loaded system running a well known
OLTP benchmark, it causes 70% more run queue locking in the push task
path without improving cpu utilization and make throughput degrade by
1.5%. We observe much higher rq lock contention due to excessive lockings
of target run queues on task wakeup.

A previous patch we submitted that added a check only to 
acquire lock on rq with lower priority tasks helped, 
otherwise the regression will be 2.0%. 
Our suspicion is there are higher priority tasks that wake up and run
for a short time, and balancing these tasks too much could hurt. 

This patch reverts the change and we got 1.5% improvement to the well
known OLTP database benchmark.  If reverting commit 3be209a8 is not an option,
I would appreciate suggestions on other ways to fix this regression.
Or perhaps provide an option not to push equal priority tasks on wake up?

Thanks.

Tim

Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
---
 kernel/sched/rt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 0e4382e..7cadc92 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -1334,7 +1334,7 @@ select_task_rq_rt(struct task_struct *p, int cpu, int sd_flag, int flags)
 	 */
 	if (curr && unlikely(rt_task(curr)) &&
 	    (curr->nr_cpus_allowed < 2 ||
-	     curr->prio <= p->prio)) {
+	     curr->prio < p->prio)) {
 		int target = find_lowest_rq(p);
 
 		if (target != -1 &&
@@ -1867,7 +1867,7 @@ static void task_woken_rt(struct rq *rq, struct task_struct *p)
 	    p->nr_cpus_allowed > 1 &&
 	    (dl_task(rq->curr) || rt_task(rq->curr)) &&
 	    (rq->curr->nr_cpus_allowed < 2 ||
-	     rq->curr->prio <= p->prio))
+	     rq->curr->prio < p->prio))
 		push_rt_tasks(rq);
 }
 
-- 
1.8.3.1


