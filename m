Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932273AbbAGR4L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 12:56:11 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:52657 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755050AbbAGRw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 12:52:58 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 08/10] rcu: Add GP-kthread-starvation checks to CPU stall warnings
Date: Wed,  7 Jan 2015 09:52:46 -0800
Message-Id: <1420653168-6434-8-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1420653168-6434-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20150107175225.GA4237@linux.vnet.ibm.com>
 <1420653168-6434-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15010717-0009-0000-0000-000007C65C64
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

This commit adds a message that is printed if the relevant grace-period
kthread has not been able to run for the two seconds preceding the
stall warning.  (The two seconds is double the maximum interval between
successive bouts of quiescent-state forcing.)

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 Documentation/RCU/stallwarn.txt |  9 +++++++++
 kernel/rcu/tree.c               | 21 ++++++++++++++++++++-
 2 files changed, 29 insertions(+), 1 deletion(-)

diff --git a/Documentation/RCU/stallwarn.txt b/Documentation/RCU/stallwarn.txt
index 55f9707fe60a..53e7d2856db6 100644
--- a/Documentation/RCU/stallwarn.txt
+++ b/Documentation/RCU/stallwarn.txt
@@ -152,6 +152,15 @@ no non-lazy callbacks ("." is printed otherwise, as shown above) and
 "D" indicates that dyntick-idle processing is enabled ("." is printed
 otherwise, for example, if disabled via the "nohz=" kernel boot parameter).
 
+If the relevant grace-period kthread has been unable to run prior to
+the stall warning, the following additional line is printed:
+
+	rcu_preempt kthread starved for 2023 jiffies!
+
+Starving the grace-period kthreads of CPU time can of course result in
+RCU CPU stall warnings even when all CPUs and tasks have passed through
+the required quiescent states.
+
 
 Multiple Warnings From One Stall
 
diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 6284c19b39ba..5110a1767c22 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -1073,6 +1073,21 @@ static void record_gp_stall_check_time(struct rcu_state *rsp)
 }
 
 /*
+ * Complain about starvation of grace-period kthread.
+ */
+static void rcu_check_gp_kthread_starvation(struct rcu_state *rsp)
+{
+	unsigned long gpa;
+	unsigned long j;
+
+	j = jiffies;
+	gpa = ACCESS_ONCE(rsp->gp_activity);
+	if (j - gpa > 2 * HZ)
+		pr_err("%s kthread starved for %ld jiffies!\n",
+		       rsp->name, j - gpa);
+}
+
+/*
  * Dump stacks of all tasks running on stalled CPUs.
  */
 static void rcu_dump_cpu_stacks(struct rcu_state *rsp)
@@ -1169,9 +1184,10 @@ static void print_other_cpu_stall(struct rcu_state *rsp, unsigned long gpnum)
 	}
 
 	/* Complain about tasks blocking the grace period. */
-
 	rcu_print_detail_task_stall(rsp);
 
+	rcu_check_gp_kthread_starvation(rsp);
+
 	force_quiescent_state(rsp);  /* Kick them all. */
 }
 
@@ -1196,6 +1212,9 @@ static void print_cpu_stall(struct rcu_state *rsp)
 	pr_cont(" (t=%lu jiffies g=%ld c=%ld q=%lu)\n",
 		jiffies - rsp->gp_start,
 		(long)rsp->gpnum, (long)rsp->completed, totqlen);
+
+	rcu_check_gp_kthread_starvation(rsp);
+
 	rcu_dump_cpu_stacks(rsp);
 
 	raw_spin_lock_irqsave(&rnp->lock, flags);
-- 
1.8.1.5

