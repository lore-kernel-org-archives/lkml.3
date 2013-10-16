Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388Ab3JPGSf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 02:18:35 -0400
Received: from mga14.intel.com ([143.182.124.37]:59891 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750885Ab3JPGSe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 02:18:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,505,1378882800"; 
   d="scan'208";a="375363220"
Subject: sched/rt: Pick up the throttled rt tasks in case no other non-rt
 tasks
From: Chuansheng Liu <chuansheng.liu@intel.com>
To: mingo@kernel.org, peterz@infradead.org
Cc: linux-kernel@vger.kernel.org, chuansheng.liu@intel.com
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Oct 2013 23:43:36 +0800
Message-ID: <1381938216.26153.63.camel@cliu38-desktop-build>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Meet the case that on CPU2, there are just two tasks to be run,
one is one rt task A, another is idle task, but at this time,
and the rt_rq is throttled.

CPU1		                 CPU2
				 staying in idle task;
waking up rt task A on
target CPU 2;

                                 exiting from idle task;
                                 DO schedule()
                                   pick up RT next task
					pick_next_task_rt()
						_pick_next_task_rt()
						rt_rq is throttled
					return NULL rt task to be picked

				 CPU2 then went into idle task AGAIN;
                                 after 2s, CPU2 is waken up again;
                                 rt task A is get running;

Here rt task A is delayed for some time, even when CPU2 is in idle state.

so in case there are just rt tasks running, we can pick up one of them
even rt_rq is throttled.

Signed-off-by: Liu, Chuansheng <chuansheng.liu@intel.com>
---
 kernel/sched/rt.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 01970c8..d521050 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -1305,8 +1305,16 @@ static struct task_struct *_pick_next_task_rt(struct rq *rq)
 	if (!rt_rq->rt_nr_running)
 		return NULL;
 
-	if (rt_rq_throttled(rt_rq))
-		return NULL;
+	if (rt_rq_throttled(rt_rq)) {
+		/*
+		 * If in current rq, expects for idle task, the other tasks
+		 * are rt tasks, we should continue to pick one of the rt tasks.
+		 * Otherwise, the rt tasks will be delayed while current
+		 * CPU is in idle.
+		*/
+		if ((rt_rq->rt_nr_running + 1) != rq->nr_running)
+			return NULL;
+	}
 
 	do {
 		rt_se = pick_next_rt_entity(rq, rt_rq);
-- 
1.7.9.5



