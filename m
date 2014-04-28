Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932997AbaD1X6H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 19:58:07 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:40180 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755043AbaD1X4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 19:56:44 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 15/19] rcu: Bind RCU grace-period kthreads if NO_HZ_FULL
Date: Mon, 28 Apr 2014 16:56:28 -0700
Message-Id: <1398729392-15087-15-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1398729392-15087-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140428235600.GA12200@linux.vnet.ibm.com>
 <1398729392-15087-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042823-1542-0000-0000-00000169B425
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Currently, RCU binds the grace-period kthreads to the timekeeping
CPU only if CONFIG_NO_HZ_FULL_SYSIDLE=y.  This means that these
kthreads must be bound manually when CONFIG_NO_HZ_FULL_SYSIDLE=n and
CONFIG_NO_HZ_FULL=y: Otherwise, these kthreads will induce OS jitter on
random CPUs.  Given that we are trying to reduce the amount of manual
tweaking required to make CONFIG_NO_HZ_FULL=y work nicely, this commit
makes this binding happen when CONFIG_NO_HZ_FULL=y, even in cases where
CONFIG_NO_HZ_FULL_SYSIDLE=n.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcu/tree_plugin.h | 34 ++++++++++++++++------------------
 1 file changed, 16 insertions(+), 18 deletions(-)

diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 1af19e006899..045c6d04ed3f 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -2596,20 +2596,6 @@ static bool is_sysidle_rcu_state(struct rcu_state *rsp)
 }
 
 /*
- * Bind the grace-period kthread for the sysidle flavor of RCU to the
- * timekeeping CPU.
- */
-static void rcu_bind_gp_kthread(void)
-{
-	int cpu = ACCESS_ONCE(tick_do_timer_cpu);
-
-	if (cpu < 0 || cpu >= nr_cpu_ids)
-		return;
-	if (raw_smp_processor_id() != cpu)
-		set_cpus_allowed_ptr(current, cpumask_of(cpu));
-}
-
-/*
  * Return a delay in jiffies based on the number of CPUs, rcu_node
  * leaf fanout, and jiffies tick rate.  The idea is to allow larger
  * systems more time to transition to full-idle state in order to
@@ -2819,10 +2805,6 @@ static bool is_sysidle_rcu_state(struct rcu_state *rsp)
 	return false;
 }
 
-static void rcu_bind_gp_kthread(void)
-{
-}
-
 static void rcu_sysidle_report_gp(struct rcu_state *rsp, int isidle,
 				  unsigned long maxj)
 {
@@ -2853,3 +2835,19 @@ static bool rcu_nohz_full_cpu(struct rcu_state *rsp)
 #endif /* #ifdef CONFIG_NO_HZ_FULL */
 	return 0;
 }
+
+/*
+ * Bind the grace-period kthread for the sysidle flavor of RCU to the
+ * timekeeping CPU.
+ */
+static void rcu_bind_gp_kthread(void)
+{
+#ifdef CONFIG_NO_HZ_FULL
+	int cpu = ACCESS_ONCE(tick_do_timer_cpu);
+
+	if (cpu < 0 || cpu >= nr_cpu_ids)
+		return;
+	if (raw_smp_processor_id() != cpu)
+		set_cpus_allowed_ptr(current, cpumask_of(cpu));
+#endif /* #ifdef CONFIG_NO_HZ_FULL */
+}
-- 
1.8.1.5

