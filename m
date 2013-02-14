Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932367Ab3BNFu7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 00:50:59 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:55486 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752578Ab3BNFst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 00:48:49 -0500
X-AuditID: 9c93016f-b7b1fae000006419-21-511c7abeab49
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH 3/8] sched: don't consider other cpus in our group in case of NEWLY_IDLE
Date: Thu, 14 Feb 2013 14:48:36 +0900
Message-Id: <1360820921-2513-4-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360820921-2513-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1360820921-2513-1-git-send-email-iamjoonsoo.kim@lge.com>
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
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 0c6aaf6..97498f4 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5016,8 +5016,15 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 		.cpus		= cpus,
 	};
 
+	/* For NEWLY_IDLE load_balancing, we don't need to consider
+	 * other cpus in our group */
+	if (idle == CPU_NEWLY_IDLE) {
+		env.dst_grpmask = NULL;
+		max_lb_iterations = 0;
+	} else {
+		max_lb_iterations = cpumask_weight(env.dst_grpmask);
+	}
 	cpumask_copy(cpus, cpu_active_mask);
-	max_lb_iterations = cpumask_weight(env.dst_grpmask);
 
 	schedstat_inc(sd, lb_count[idle]);
 
-- 
1.7.9.5

