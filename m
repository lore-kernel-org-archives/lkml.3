Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752137AbaG1Rzy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 13:55:54 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:62595 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064AbaG1Rwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 13:52:38 -0400
From: Vincent Guittot <vincent.guittot@linaro.org>
To: peterz@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        preeti@linux.vnet.ibm.com, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org
Cc: riel@redhat.com, Morten.Rasmussen@arm.com, efault@gmx.de,
        nicolas.pitre@linaro.org, linaro-kernel@lists.linaro.org,
        daniel.lezcano@linaro.org, dietmar.eggemann@arm.com,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: [PATCH v4 01/12] sched: fix imbalance flag reset
Date: Mon, 28 Jul 2014 19:51:35 +0200
Message-Id: <1406569906-9763-2-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406569906-9763-1-git-send-email-vincent.guittot@linaro.org>
References: <1406569906-9763-1-git-send-email-vincent.guittot@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The imbalance flag can stay set whereas there is no imbalance.

Let assume that we have 3 tasks that run on a dual cores /dual cluster system.
We will have some idle load balance which are triggered during tick.
Unfortunately, the tick is also used to queue background work so we can reach
the situation where short work has been queued on a CPU which already runs a
task. The load balance will detect this imbalance (2 tasks on 1 CPU and an idle
CPU) and will try to pull the waiting task on the idle CPU. The waiting task is
a worker thread that is pinned on a CPU so an imbalance due to pinned task is
detected and the imbalance flag is set.
Then, we will not be able to clear the flag because we have at most 1 task on
each CPU but the imbalance flag will trig to useless active load balance
between the idle CPU and the busy CPU.

We need to reset of the imbalance flag as soon as we have reached a balanced
state. If all tasks are pinned, we don't consider that as a balanced state and
let the imbalance flag set.

Reviewed-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
---
 kernel/sched/fair.c | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 923fe32..7eb9126 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6672,10 +6672,8 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 		if (sd_parent) {
 			int *group_imbalance = &sd_parent->groups->sgc->imbalance;
 
-			if ((env.flags & LBF_SOME_PINNED) && env.imbalance > 0) {
+			if ((env.flags & LBF_SOME_PINNED) && env.imbalance > 0)
 				*group_imbalance = 1;
-			} else if (*group_imbalance)
-				*group_imbalance = 0;
 		}
 
 		/* All tasks on this runqueue were pinned by CPU affinity */
@@ -6686,7 +6684,7 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 				env.loop_break = sched_nr_migrate_break;
 				goto redo;
 			}
-			goto out_balanced;
+			goto out_all_pinned;
 		}
 	}
 
@@ -6760,6 +6758,23 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 	goto out;
 
 out_balanced:
+	/*
+	 * We reach balance although we may have faced some affinity
+	 * constraints. Clear the imbalance flag if it was set.
+	 */
+	if (sd_parent) {
+		int *group_imbalance = &sd_parent->groups->sgc->imbalance;
+
+		if (*group_imbalance)
+			*group_imbalance = 0;
+	}
+
+out_all_pinned:
+	/*
+	 * We reach balance because all tasks are pinned at this level so
+	 * we can't migrate them. Let the imbalance flag set so parent level
+	 * can try to migrate them.
+	 */
 	schedstat_inc(sd, lb_balanced[idle]);
 
 	sd->nr_balance_failed = 0;
-- 
1.9.1

