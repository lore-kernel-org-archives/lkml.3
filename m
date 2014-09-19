Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932125AbaISLwk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 07:52:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56253 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756513AbaISLsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 07:48:06 -0400
Date: Fri, 19 Sep 2014 04:47:14 -0700
From: tip-bot for Vincent Guittot <tipbot@zytor.com>
Message-ID: <tip-afdeee0510db918b31bb4aba47452df2ddbdbcf2@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        preeti@linux.vnet.ibm.com, vincent.guittot@linaro.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        preeti@linux.vnet.ibm.com, vincent.guittot@linaro.org,
        tglx@linutronix.de
In-Reply-To: <1409051215-16788-2-git-send-email-vincent.guittot@linaro.org>
References: <1409051215-16788-2-git-send-email-vincent.guittot@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Fix imbalance flag reset
Git-Commit-ID: afdeee0510db918b31bb4aba47452df2ddbdbcf2
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

Commit-ID:  afdeee0510db918b31bb4aba47452df2ddbdbcf2
Gitweb:     http://git.kernel.org/tip/afdeee0510db918b31bb4aba47452df2ddbdbcf2
Author:     Vincent Guittot <vincent.guittot@linaro.org>
AuthorDate: Tue, 26 Aug 2014 13:06:44 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 19 Sep 2014 12:35:24 +0200

sched: Fix imbalance flag reset

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

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
Reviewed-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: riel@redhat.com
Cc: Morten.Rasmussen@arm.com
Cc: efault@gmx.de
Cc: nicolas.pitre@linaro.org
Cc: daniel.lezcano@linaro.org
Cc: dietmar.eggemann@arm.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1409051215-16788-2-git-send-email-vincent.guittot@linaro.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 9807a99..01856a8 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6765,10 +6765,8 @@ more_balance:
 		if (sd_parent) {
 			int *group_imbalance = &sd_parent->groups->sgc->imbalance;
 
-			if ((env.flags & LBF_SOME_PINNED) && env.imbalance > 0) {
+			if ((env.flags & LBF_SOME_PINNED) && env.imbalance > 0)
 				*group_imbalance = 1;
-			} else if (*group_imbalance)
-				*group_imbalance = 0;
 		}
 
 		/* All tasks on this runqueue were pinned by CPU affinity */
@@ -6779,7 +6777,7 @@ more_balance:
 				env.loop_break = sched_nr_migrate_break;
 				goto redo;
 			}
-			goto out_balanced;
+			goto out_all_pinned;
 		}
 	}
 
@@ -6853,6 +6851,23 @@ more_balance:
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
