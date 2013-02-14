Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754634Ab3BNFsu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 00:48:50 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:54445 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059Ab3BNFss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 00:48:48 -0500
X-AuditID: 9c93016f-b7b1fae000006419-15-511c7abefbe1
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH 1/8] sched: change position of resched_cpu() in load_balance()
Date: Thu, 14 Feb 2013 14:48:34 +0900
Message-Id: <1360820921-2513-2-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360820921-2513-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1360820921-2513-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cur_ld_moved is reset if env.flags hit LBF_NEED_BREAK.
So, there is possibility that we miss doing resched_cpu().
Correct it as changing position of resched_cpu()
before checking LBF_NEED_BREAK.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 81fa536..6f72851 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5070,17 +5070,17 @@ more_balance:
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

