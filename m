Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759368Ab3CZGA7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 02:00:59 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:52460 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753677Ab3CZGA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 02:00:57 -0400
X-AuditID: 9c930179-b7c78ae000000e4b-4e-51513997711a
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH v2 1/6] sched: change position of resched_cpu() in load_balance()
Date: Tue, 26 Mar 2013 15:01:35 +0900
Message-Id: <1364277700-7509-2-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1364277700-7509-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1364277700-7509-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cur_ld_moved is reset if env.flags hit LBF_NEED_BREAK.
So, there is possibility that we miss doing resched_cpu().
Correct it as changing position of resched_cpu()
before checking LBF_NEED_BREAK.

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 7a33e59..f084069 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5061,17 +5061,17 @@ more_balance:
 		double_rq_unlock(env.dst_rq, busiest);
 		local_irq_restore(flags);
 
-		if (env.flags & LBF_NEED_BREAK) {
-			env.flags &= ~LBF_NEED_BREAK;
-			goto more_balance;
-		}
-
 		/*
 		 * some other cpu did the load balance for us.
 		 */
 		if (cur_ld_moved && env.dst_cpu != smp_processor_id())
 			resched_cpu(env.dst_cpu);
 
+		if (env.flags & LBF_NEED_BREAK) {
+			env.flags &= ~LBF_NEED_BREAK;
+			goto more_balance;
+		}
+
 		/*
 		 * Revisit (affine) tasks on src_cpu that couldn't be moved to
 		 * us and move them to an alternate dst_cpu in our sched_group
-- 
1.7.9.5

