Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755569Ab3BNFtH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 00:49:07 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:62764 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754188Ab3BNFsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 00:48:51 -0500
X-AuditID: 9c93016f-b7b1fae000006419-28-511c7abf351c
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH 8/8] sched: reset lb_env when redo in load_balance()
Date: Thu, 14 Feb 2013 14:48:41 +0900
Message-Id: <1360820921-2513-9-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360820921-2513-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1360820921-2513-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 88b8dac0 makes load_balance() consider other cpus in its group.
So, now, When we redo in load_balance(), we should reset some fields of
lb_env to ensure that load_balance() works for initial cpu, not for other
cpus in its group. So correct it.

Cc: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 70631e8..25c798c 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5014,14 +5014,20 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 
 	struct lb_env env = {
 		.sd		= sd,
-		.dst_cpu	= this_cpu,
-		.dst_rq		= this_rq,
 		.dst_grpmask    = dst_grp,
 		.idle		= idle,
-		.loop_break	= sched_nr_migrate_break,
 		.cpus		= cpus,
 	};
 
+	schedstat_inc(sd, lb_count[idle]);
+	cpumask_copy(cpus, cpu_active_mask);
+
+redo:
+	env.dst_cpu = this_cpu;
+	env.dst_rq = this_rq;
+	env.loop = 0;
+	env.loop_break = sched_nr_migrate_break;
+
 	/* For NEWLY_IDLE load_balancing, we don't need to consider
 	 * other cpus in our group */
 	if (idle == CPU_NEWLY_IDLE) {
@@ -5030,11 +5036,7 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 		cpumask_copy(dst_grp, sched_group_cpus(sd->groups));
 		cpumask_clear_cpu(env.dst_cpu, env.dst_grpmask);
 	}
-	cpumask_copy(cpus, cpu_active_mask);
 
-	schedstat_inc(sd, lb_count[idle]);
-
-redo:
 	group = find_busiest_group(&env, balance);
 
 	if (*balance == 0)
@@ -5133,11 +5135,9 @@ more_balance:
 		/* All tasks on this runqueue were pinned by CPU affinity */
 		if (unlikely(env.flags & LBF_ALL_PINNED)) {
 			cpumask_clear_cpu(cpu_of(busiest), cpus);
-			if (!cpumask_empty(cpus)) {
-				env.loop = 0;
-				env.loop_break = sched_nr_migrate_break;
+			if (!cpumask_empty(cpus))
 				goto redo;
-			}
+
 			goto out_balanced;
 		}
 	}
-- 
1.7.9.5

