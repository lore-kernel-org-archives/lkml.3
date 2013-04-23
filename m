Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755985Ab3DWI3u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 04:29:50 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:55449 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755348Ab3DWI1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 04:27:48 -0400
X-AuditID: 9c93016f-b7c5fae00000791a-8f-517646008408
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Jason Low <jason.low2@hp.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH v3 3/6] sched: don't consider other cpus in our group in case of NEWLY_IDLE
Date: Tue, 23 Apr 2013 17:27:39 +0900
Message-Id: <1366705662-3587-4-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1366705662-3587-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1366705662-3587-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 88b8dac0 makes load_balance() consider other cpus in its group,
regardless of idle type. When we do NEWLY_IDLE balancing, we should not
consider it, because a motivation of NEWLY_IDLE balancing is to turn
this cpu to non idle state if needed. This is not the case of other cpus.
So, change code not to consider other cpus for NEWLY_IDLE balancing.

With this patch, assign 'if (pulled_task) this_rq->idle_stamp = 0'
in idle_balance() is corrected, because NEWLY_IDLE balancing doesn't
consider other cpus. Assigning to 'this_rq->idle_stamp' is now valid.

Cc: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Tested-by: Jason Low <jason.low2@hp.com>
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 726e129..dfa92b7 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5026,8 +5026,21 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 		.cpus		= cpus,
 	};
 
+	/*
+	 * For NEWLY_IDLE load_balancing, we don't need to consider
+	 * other cpus in our group
+	 */
+	if (idle == CPU_NEWLY_IDLE) {
+		env.dst_grpmask = NULL;
+		/*
+		 * we don't care max_lb_iterations in this case,
+		 * in following patch, this will be removed
+		 */
+		max_lb_iterations = 0;
+	} else
+		max_lb_iterations = cpumask_weight(env.dst_grpmask);
+
 	cpumask_copy(cpus, cpu_active_mask);
-	max_lb_iterations = cpumask_weight(env.dst_grpmask);
 
 	schedstat_inc(sd, lb_count[idle]);
 
-- 
1.7.9.5

