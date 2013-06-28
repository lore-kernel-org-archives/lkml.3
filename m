Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753680Ab3F1UKp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 16:10:45 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:42057 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753628Ab3F1UKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 16:10:43 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC nohz_full v2 7/7] nohz_full: Force RCU's grace-period kthreads onto timekeeping CPU
Date: Fri, 28 Jun 2013 13:10:22 -0700
Message-Id: <1372450222-19420-7-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1372450222-19420-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130628200949.GA17458@linux.vnet.ibm.com>
 <1372450222-19420-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13062820-7282-0000-0000-000018C63825
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
---
 kernel/rcutree.c        |  1 +
 kernel/rcutree.h        |  1 +
 kernel/rcutree_plugin.h | 20 +++++++++++++++++++-
 3 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 06cfd75..ad9a5ec 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1286,6 +1286,7 @@ static int rcu_gp_init(struct rcu_state *rsp)
 	struct rcu_data *rdp;
 	struct rcu_node *rnp = rcu_get_root(rsp);
 
+	rcu_bind_gp_kthread();
 	raw_spin_lock_irq(&rnp->lock);
 	rsp->gp_flags = 0; /* Clear all flags: New grace period. */
 
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index 7326a3c..1602c21 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -558,6 +558,7 @@ static void rcu_sysidle_exit(struct rcu_dynticks *rdtp, int irq);
 static void rcu_sysidle_check_cpu(struct rcu_data *rdp, bool *isidle,
 				  unsigned long *maxj);
 static bool is_sysidle_rcu_state(struct rcu_state *rsp);
+static void rcu_bind_gp_kthread(void);
 static void rcu_sysidle_report(struct rcu_state *rsp, int isidle,
 			       unsigned long maxj);
 static void rcu_sysidle_init_percpu_data(struct rcu_dynticks *rdtp);
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 9b60df5..4478cfd 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -2543,7 +2543,7 @@ static void rcu_sysidle_check_cpu(struct rcu_data *rdp, bool *isidle,
 	if (!*isidle || rdp->rsp != rcu_sysidle_state ||
 	    cpu_is_offline(rdp->cpu) || rdp->cpu == tick_do_timer_cpu)
 		return;
-	/* WARN_ON_ONCE(smp_processor_id() != tick_do_timer_cpu); */
+	WARN_ON_ONCE(smp_processor_id() != tick_do_timer_cpu);
 
 	/*
 	 * Pick up current idle and NMI-nesting counters, check.  We check
@@ -2577,6 +2577,20 @@ static bool is_sysidle_rcu_state(struct rcu_state *rsp)
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
@@ -2744,6 +2758,10 @@ static bool is_sysidle_rcu_state(struct rcu_state *rsp)
 	return false;
 }
 
+static void rcu_bind_gp_kthread(void)
+{
+}
+
 static void rcu_sysidle_report(struct rcu_state *rsp, int isidle,
 			       unsigned long maxj)
 {
-- 
1.8.1.5

