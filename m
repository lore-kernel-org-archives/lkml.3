Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757893Ab3DXJf2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 05:35:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39274 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754072Ab3DXJf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 05:35:26 -0400
Date: Wed, 24 Apr 2013 02:35:01 -0700
From: tip-bot for Joonsoo Kim <tipbot@zytor.com>
Message-ID: <tip-cfc03118047172f5bdc58d63c607d16d33ce5305@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, vatsa@linux.vnet.ibm.com, hpa@zytor.com,
        mingo@kernel.org, davidlohr.bueso@hp.com, a.p.zijlstra@chello.nl,
        peterz@infradead.org, jason.low2@hp.com, tglx@linutronix.de,
        iamjoonsoo.kim@lge.com
Reply-To: mingo@kernel.org, hpa@zytor.com, vatsa@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, davidlohr.bueso@hp.com,
        a.p.zijlstra@chello.nl, peterz@infradead.org, jason.low2@hp.com,
        iamjoonsoo.kim@lge.com, tglx@linutronix.de
In-Reply-To: <1366705662-3587-4-git-send-email-iamjoonsoo.kim@lge.com>
References: <1366705662-3587-4-git-send-email-iamjoonsoo.kim@lge.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Don'
 t consider other cpus in our group in case of NEWLY_IDLE
Git-Commit-ID: cfc03118047172f5bdc58d63c607d16d33ce5305
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

Commit-ID:  cfc03118047172f5bdc58d63c607d16d33ce5305
Gitweb:     http://git.kernel.org/tip/cfc03118047172f5bdc58d63c607d16d33ce5305
Author:     Joonsoo Kim <iamjoonsoo.kim@lge.com>
AuthorDate: Tue, 23 Apr 2013 17:27:39 +0900
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 24 Apr 2013 08:52:44 +0200

sched: Don't consider other cpus in our group in case of NEWLY_IDLE

Commit 88b8dac0 makes load_balance() consider other cpus in its
group, regardless of idle type. When we do NEWLY_IDLE balancing,
we should not consider it, because a motivation of NEWLY_IDLE
balancing is to turn this cpu to non idle state if needed. This
is not the case of other cpus. So, change code not to consider
other cpus for NEWLY_IDLE balancing.

With this patch, assign 'if (pulled_task) this_rq->idle_stamp =
0' in idle_balance() is corrected, because NEWLY_IDLE balancing
doesn't consider other cpus. Assigning to 'this_rq->idle_stamp'
is now valid.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Tested-by: Jason Low <jason.low2@hp.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Cc: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1366705662-3587-4-git-send-email-iamjoonsoo.kim@lge.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

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
 
