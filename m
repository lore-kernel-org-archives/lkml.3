Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171Ab3HTCsy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 22:48:54 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:35062 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752110Ab3HTCre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 22:47:34 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 9/9] nohz_full: Force RCU's grace-period kthreads onto timekeeping CPU
Date: Mon, 19 Aug 2013 19:47:21 -0700
Message-Id: <1376966841-31774-9-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1376966841-31774-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130820024700.GA31075@linux.vnet.ibm.com>
 <1376966841-31774-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082002-2398-0000-0000-000001A4742B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Because RCU's quiescent-state-forcing mechanism is used to drive the
full-system-idle state machine, and because this mechanism is executed
by RCU's grace-period kthreads, this commit forces these kthreads to
run on the timekeeping CPU (tick_do_timer_cpu).  To do otherwise would
mean that the RCU grace-period kthreads would force the system into
non-idle state every time they drove the state machine, which would
be just a bit on the futile side.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 kernel/rcutree.c        |  1 +
 kernel/rcutree.h        |  1 +
 kernel/rcutree_plugin.h | 21 ++++++++++++++++++++-
 3 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index eca70f44..64eaafb 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1303,6 +1303,7 @@ static int rcu_gp_init(struct rcu_state *rsp)
 	struct rcu_data *rdp;
 	struct rcu_node *rnp = rcu_get_root(rsp);
 
+	rcu_bind_gp_kthread();
 	raw_spin_lock_irq(&rnp->lock);
 	rsp->gp_flags = 0; /* Clear all flags: New grace period. */
 
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index 6fd3659..5f97eab 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -560,6 +560,7 @@ static void rcu_sysidle_check_cpu(struct rcu_data *rdp, bool *isidle,
 static bool is_sysidle_rcu_state(struct rcu_state *rsp);
 static void rcu_sysidle_report_gp(struct rcu_state *rsp, int isidle,
 				  unsigned long maxj);
+static void rcu_bind_gp_kthread(void);
 static void rcu_sysidle_init_percpu_data(struct rcu_dynticks *rdtp);
 
 #endif /* #ifndef RCU_TREE_NONCORE */
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 90c3fba..dc7f0d4 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -2531,7 +2531,8 @@ static void rcu_sysidle_check_cpu(struct rcu_data *rdp, bool *isidle,
 	if (!*isidle || rdp->rsp != rcu_sysidle_state ||
 	    cpu_is_offline(rdp->cpu) || rdp->cpu == tick_do_timer_cpu)
 		return;
-	/* WARN_ON_ONCE(smp_processor_id() != tick_do_timer_cpu); */
+	if (rcu_gp_in_progress(rdp->rsp))
+		WARN_ON_ONCE(smp_processor_id() != tick_do_timer_cpu);
 
 	/* Pick up current idle and NMI-nesting counter and check. */
 	cur = atomic_read(&rdtp->dynticks_idle);
@@ -2557,6 +2558,20 @@ static bool is_sysidle_rcu_state(struct rcu_state *rsp)
 }
 
 /*
+ * Bind the grace-period kthread for the sysidle flavor of RCU to the
+ * timekeeping CPU.
+ */
+static void rcu_bind_gp_kthread(void)
+{
+	int cpu = ACCESS_ONCE(tick_do_timer_cpu);
+
+	if (cpu < 0 || cpu >= nr_cpu_ids)
+		return;
+	if (raw_smp_processor_id() != cpu)
+		set_cpus_allowed_ptr(current, cpumask_of(cpu));
+}
+
+/*
  * Return a delay in jiffies based on the number of CPUs, rcu_node
  * leaf fanout, and jiffies tick rate.  The idea is to allow larger
  * systems more time to transition to full-idle state in order to
@@ -2754,6 +2769,10 @@ static bool is_sysidle_rcu_state(struct rcu_state *rsp)
 	return false;
 }
 
+static void rcu_bind_gp_kthread(void)
+{
+}
+
 static void rcu_sysidle_report_gp(struct rcu_state *rsp, int isidle,
 				  unsigned long maxj)
 {
-- 
1.8.1.5

