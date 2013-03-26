Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934048Ab3CZGBe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 02:01:34 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:52460 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933514Ab3CZGA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 02:00:58 -0400
X-AuditID: 9c930179-b7c78ae000000e4b-52-51513997fefd
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH v2 3/6] sched: don't consider other cpus in our group in case of NEWLY_IDLE
Date: Tue, 26 Mar 2013 15:01:37 +0900
Message-Id: <1364277700-7509-4-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1364277700-7509-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1364277700-7509-1-git-send-email-iamjoonsoo.kim@lge.com>
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
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 9d693d0..3f8c4f2 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5007,8 +5007,17 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 		.cpus		= cpus,
 	};
 
+	/* For NEWLY_IDLE load_balancing, we don't need to consider
+	 * other cpus in our group */
+	if (idle == CPU_NEWLY_IDLE) {
+		env.dst_grpmask = NULL;
+		/* we don't care max_lb_iterations in this case,
+		 * in following patch, this will be removed */
+		max_lb_iterations = 0;
+	} else {
+		max_lb_iterations = cpumask_weight(env.dst_grpmask);
+	}
 	cpumask_copy(cpus, cpu_active_mask);
-	max_lb_iterations = cpumask_weight(env.dst_grpmask);
 
 	schedstat_inc(sd, lb_count[idle]);
 
-- 
1.7.9.5

