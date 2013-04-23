Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755808Ab3DWI1v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 04:27:51 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:53936 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755345Ab3DWI1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 04:27:46 -0400
X-AuditID: 9c93016f-b7c5fae00000791a-8e-51764600241f
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Jason Low <jason.low2@hp.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH v3 2/6] sched: explicitly cpu_idle_type checking in rebalance_domains()
Date: Tue, 23 Apr 2013 17:27:38 +0900
Message-Id: <1366705662-3587-3-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1366705662-3587-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1366705662-3587-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After commit 88b8dac0, dst-cpu can be changed in load_balance(),
then we can't know cpu_idle_type of dst-cpu when load_balance()
return positive. So, add explicit cpu_idle_type checking.

Cc: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Tested-by: Jason Low <jason.low2@hp.com>
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 25aaf93..726e129 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5523,10 +5523,11 @@ static void rebalance_domains(int cpu, enum cpu_idle_type idle)
 		if (time_after_eq(jiffies, sd->last_balance + interval)) {
 			if (load_balance(cpu, rq, sd, idle, &balance)) {
 				/*
-				 * We've pulled tasks over so either we're no
-				 * longer idle.
+				 * The LBF_SOME_PINNED logic could have changed
+				 * env->dst_cpu, so we can't know our idle
+				 * state even if we migrated tasks. Update it.
 				 */
-				idle = CPU_NOT_IDLE;
+				idle = idle_cpu(cpu) ? CPU_IDLE : CPU_NOT_IDLE;
 			}
 			sd->last_balance = jiffies;
 		}
-- 
1.7.9.5

