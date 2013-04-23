Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755842Ab3DWI1w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 04:27:52 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:60389 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755304Ab3DWI1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 04:27:46 -0400
X-AuditID: 9c93016f-b7c5fae00000791a-8c-517646008a54
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Jason Low <jason.low2@hp.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH v3 1/6] sched: change position of resched_cpu() in load_balance()
Date: Tue, 23 Apr 2013 17:27:37 +0900
Message-Id: <1366705662-3587-2-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1366705662-3587-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1366705662-3587-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cur_ld_moved is reset if env.flags hit LBF_NEED_BREAK.
So, there is possibility that we miss doing resched_cpu().
Correct it as changing position of resched_cpu()
before checking LBF_NEED_BREAK.

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Tested-by: Jason Low <jason.low2@hp.com>
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 1c97735..25aaf93 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5080,17 +5080,17 @@ more_balance:
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

