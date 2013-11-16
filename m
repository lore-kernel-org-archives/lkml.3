Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989Ab3KPAYu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 19:24:50 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:41621 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753863Ab3KPAX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 19:23:56 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 13/16] rcu: Don't activate RCU core on NO_HZ_FULL CPUs
Date: Fri, 15 Nov 2013 16:23:35 -0800
Message-Id: <1384561418-30575-13-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1384561418-30575-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20131116002316.GA29049@linux.vnet.ibm.com>
 <1384561418-30575-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13111600-9332-0000-0000-0000022BBCF5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Whenever a CPU receives a scheduling-clock interrupt, RCU checks to see
if the RCU core needs anything from this CPU.  If so, RCU raises
RCU_SOFTIRQ to carry out any needed processing.

This approach has worked well historically, but it is undesirable on
NO_HZ_FULL CPUs.  Such CPUs are expected to spend almost all of their time
in userspace, so that scheduling-clock interrupts can be disabled while
there is only one runnable task on the CPU in question.  Unfortunately,
raising any softirq has the potential to wake up ksoftirqd, which would
provide the second runnable task on that CPU, preventing disabling of
scheduling-clock interrupts.

What is needed instead is for RCU to leave NO_HZ_FULL CPUs alone,
relying on the grace-period kthreads' quiescent-state forcing to
do any needed RCU work on behalf of those CPUs.

This commit therefore refrains from raising RCU_SOFTIRQ on any
NO_HZ_FULL CPUs during any grace periods that have been in effect
for less than one second.  The one-second limit handles the case
where an inappropriate workload is running on a NO_HZ_FULL CPU
that features lots of scheduling-clock interrupts, but no idle
or userspace time.

Reported-by: Mike Galbraith <bitbucket@online.de>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Tested-by: Mike Galbraith <bitbucket@online.de>
Toasted-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/rcu/tree.c        |  4 ++++
 kernel/rcu/tree.h        |  1 +
 kernel/rcu/tree_plugin.h | 20 ++++++++++++++++++++
 3 files changed, 25 insertions(+)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 13d1a1a0d60a..7be5efd62fe5 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -2783,6 +2783,10 @@ static int __rcu_pending(struct rcu_state *rsp, struct rcu_data *rdp)
 	/* Check for CPU stalls, if enabled. */
 	check_cpu_stall(rsp, rdp);
 
+	/* Is this CPU a NO_HZ_FULL CPU that should ignore RCU? */
+	if (rcu_nohz_full_cpu(rsp))
+		return 0;
+
 	/* Is the RCU core waiting for a quiescent state from this CPU? */
 	if (rcu_scheduler_fully_active &&
 	    rdp->qs_pending && !rdp->passed_quiesce) {
diff --git a/kernel/rcu/tree.h b/kernel/rcu/tree.h
index a87adfc2916b..8c19873f1ac9 100644
--- a/kernel/rcu/tree.h
+++ b/kernel/rcu/tree.h
@@ -571,6 +571,7 @@ static void rcu_sysidle_report_gp(struct rcu_state *rsp, int isidle,
 				  unsigned long maxj);
 static void rcu_bind_gp_kthread(void);
 static void rcu_sysidle_init_percpu_data(struct rcu_dynticks *rdtp);
+static bool rcu_nohz_full_cpu(struct rcu_state *rsp);
 
 #endif /* #ifndef RCU_TREE_NONCORE */
 
diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 29335faf96e7..1aa33a59fadc 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -2872,3 +2872,23 @@ static void rcu_sysidle_init_percpu_data(struct rcu_dynticks *rdtp)
 }
 
 #endif /* #else #ifdef CONFIG_NO_HZ_FULL_SYSIDLE */
+
+/*
+ * Is this CPU a NO_HZ_FULL CPU that should ignore RCU so that the
+ * grace-period kthread will do force_quiescent_state() processing?
+ * The idea is to avoid waking up RCU core processing on such a
+ * CPU unless the grace period has extended for too long.
+ *
+ * This code relies on the fact that all NO_HZ_FULL CPUs are also
+ * CONFIG_RCU_NOCB_CPUs.
+ */
+static bool rcu_nohz_full_cpu(struct rcu_state *rsp)
+{
+#ifdef CONFIG_NO_HZ_FULL
+	if (tick_nohz_full_cpu(smp_processor_id()) &&
+	    (!rcu_gp_in_progress(rsp) ||
+	     ULONG_CMP_LT(jiffies, ACCESS_ONCE(rsp->gp_start) + HZ)))
+		return 1;
+#endif /* #ifdef CONFIG_NO_HZ_FULL */
+	return 0;
+}
-- 
1.8.1.5

