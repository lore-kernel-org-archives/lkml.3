Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404AbaGGWkN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 18:40:13 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:45138 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686AbaGGWic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 18:38:32 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 12/17] rcu: Don't use NMIs to dump other CPUs' stacks
Date: Mon,  7 Jul 2014 15:38:16 -0700
Message-Id: <1404772701-8804-12-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1404772701-8804-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140707223756.GA7187@linux.vnet.ibm.com>
 <1404772701-8804-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14070722-7164-0000-0000-000002F47FC8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Although NMI-based stack dumps are in principle more accurate, they are
also more likely to trigger deadlocks.  This commit therefore replaces
all uses of trigger_all_cpu_backtrace() with rcu_dump_cpu_stacks(), so
that the CPU detecting an RCU CPU stall does the stack dumping.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcu/tree.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 3f93033d3c61..8f3e4d43d736 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -1013,10 +1013,7 @@ static void record_gp_stall_check_time(struct rcu_state *rsp)
 }
 
 /*
- * Dump stacks of all tasks running on stalled CPUs.  This is a fallback
- * for architectures that do not implement trigger_all_cpu_backtrace().
- * The NMI-triggered stack traces are more accurate because they are
- * printed by the target CPU.
+ * Dump stacks of all tasks running on stalled CPUs.
  */
 static void rcu_dump_cpu_stacks(struct rcu_state *rsp)
 {
@@ -1094,7 +1091,7 @@ static void print_other_cpu_stall(struct rcu_state *rsp)
 	       (long)rsp->gpnum, (long)rsp->completed, totqlen);
 	if (ndetected == 0)
 		pr_err("INFO: Stall ended before state dump start\n");
-	else if (!trigger_all_cpu_backtrace())
+	else
 		rcu_dump_cpu_stacks(rsp);
 
 	/* Complain about tasks blocking the grace period. */
@@ -1125,8 +1122,7 @@ static void print_cpu_stall(struct rcu_state *rsp)
 	pr_cont(" (t=%lu jiffies g=%ld c=%ld q=%lu)\n",
 		jiffies - rsp->gp_start,
 		(long)rsp->gpnum, (long)rsp->completed, totqlen);
-	if (!trigger_all_cpu_backtrace())
-		dump_stack();
+	rcu_dump_cpu_stacks(rsp);
 
 	raw_spin_lock_irqsave(&rnp->lock, flags);
 	if (ULONG_CMP_GE(jiffies, ACCESS_ONCE(rsp->jiffies_stall)))
-- 
1.8.1.5

