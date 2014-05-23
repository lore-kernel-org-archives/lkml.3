Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753612AbaEWP5s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 11:57:48 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:54616 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752302AbaEWPyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 11:54:07 -0400
From: Vincent Guittot <vincent.guittot@linaro.org>
To: peterz@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org
Cc: preeti@linux.vnet.ibm.com, Morten.Rasmussen@arm.com, efault@gmx.de,
        nicolas.pitre@linaro.org, linaro-kernel@lists.linaro.org,
        daniel.lezcano@linaro.org,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: [PATCH v2 01/11] sched: fix imbalance flag reset
Date: Fri, 23 May 2014 17:52:55 +0200
Message-Id: <1400860385-14555-2-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1400860385-14555-1-git-send-email-vincent.guittot@linaro.org>
References: <1400860385-14555-1-git-send-email-vincent.guittot@linaro.org>
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
state.

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
---
 kernel/sched/fair.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index c9617b7..9587ed1 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6610,10 +6610,8 @@ more_balance:
 		if (sd_parent) {
 			int *group_imbalance = &sd_parent->groups->sgp->imbalance;
 
-			if ((env.flags & LBF_SOME_PINNED) && env.imbalance > 0) {
+			if ((env.flags & LBF_SOME_PINNED) && env.imbalance > 0)
 				*group_imbalance = 1;
-			} else if (*group_imbalance)
-				*group_imbalance = 0;
 		}
 
 		/* All tasks on this runqueue were pinned by CPU affinity */
@@ -6698,6 +6696,16 @@ more_balance:
 	goto out;
 
 out_balanced:
+	/*
+	 * We reach balance although we may have faced some affinity
+	 * constraints. Clear the imbalance flag if it was set.
+	 */
+	if (sd_parent) {
+		int *group_imbalance = &sd_parent->groups->sgp->imbalance;
+		if (*group_imbalance)
+			*group_imbalance = 0;
+	}
+
 	schedstat_inc(sd, lb_balanced[idle]);
 
 	sd->nr_balance_failed = 0;
-- 
1.9.1

