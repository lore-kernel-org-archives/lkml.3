Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755527AbaJ1V6J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 17:58:09 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:43324 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755356AbaJ1V5e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 17:57:34 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 08/10] rcu: Remove "cpu" argument to rcu_prepare_for_idle()
Date: Tue, 28 Oct 2014 14:53:35 -0700
Message-Id: <1414533217-24910-8-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1414533217-24910-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20141028215140.GA23970@linux.vnet.ibm.com>
 <1414533217-24910-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102821-0033-0000-0000-000000E3EBB6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The "cpu" argument to rcu_prepare_for_idle() is always the current
CPU, so drop it.  This in turn allows two of the uses of "cpu" in
this function to be replaced with a this_cpu_ptr() and the third by
smp_processor_id(), replacing that of the call to rcu_prepare_for_idle().
Again, the anticipated cross-CPU uses of these functions has been replaced
by NO_HZ_FULL.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcu/tree.c        |  2 +-
 kernel/rcu/tree.h        |  2 +-
 kernel/rcu/tree_plugin.h | 10 +++++-----
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index d678a98caf1d..8251938fb4ae 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -531,7 +531,7 @@ static void rcu_eqs_enter_common(long long oldval, bool user)
 		rdp = this_cpu_ptr(rsp->rda);
 		do_nocb_deferred_wakeup(rdp);
 	}
-	rcu_prepare_for_idle(smp_processor_id());
+	rcu_prepare_for_idle();
 	/* CPUs seeing atomic_inc() must see prior RCU read-side crit sects */
 	smp_mb__before_atomic();  /* See above. */
 	atomic_inc(&rdtp->dynticks);
diff --git a/kernel/rcu/tree.h b/kernel/rcu/tree.h
index 238ac39053fc..8bc3cacbe14a 100644
--- a/kernel/rcu/tree.h
+++ b/kernel/rcu/tree.h
@@ -580,7 +580,7 @@ static int rcu_spawn_one_boost_kthread(struct rcu_state *rsp,
 static void __init rcu_spawn_boost_kthreads(void);
 static void rcu_prepare_kthreads(int cpu);
 static void rcu_cleanup_after_idle(int cpu);
-static void rcu_prepare_for_idle(int cpu);
+static void rcu_prepare_for_idle(void);
 static void rcu_idle_count_callbacks_posted(void);
 static void print_cpu_stall_info_begin(void);
 static void print_cpu_stall_info(struct rcu_state *rsp, int cpu);
diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 1797b76cb3ff..5e68ab5fe317 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -1531,7 +1531,7 @@ static void rcu_cleanup_after_idle(int cpu)
  * Do the idle-entry grace-period work, which, because CONFIG_RCU_FAST_NO_HZ=n,
  * is nothing.
  */
-static void rcu_prepare_for_idle(int cpu)
+static void rcu_prepare_for_idle(void)
 {
 }
 
@@ -1666,12 +1666,12 @@ int rcu_needs_cpu(unsigned long *dj)
  *
  * The caller must have disabled interrupts.
  */
-static void rcu_prepare_for_idle(int cpu)
+static void rcu_prepare_for_idle(void)
 {
 #ifndef CONFIG_RCU_NOCB_CPU_ALL
 	bool needwake;
 	struct rcu_data *rdp;
-	struct rcu_dynticks *rdtp = &per_cpu(rcu_dynticks, cpu);
+	struct rcu_dynticks *rdtp = this_cpu_ptr(&rcu_dynticks);
 	struct rcu_node *rnp;
 	struct rcu_state *rsp;
 	int tne;
@@ -1688,7 +1688,7 @@ static void rcu_prepare_for_idle(int cpu)
 		return;
 
 	/* If this is a no-CBs CPU, no callbacks, just return. */
-	if (rcu_is_nocb_cpu(cpu))
+	if (rcu_is_nocb_cpu(smp_processor_id()))
 		return;
 
 	/*
@@ -1712,7 +1712,7 @@ static void rcu_prepare_for_idle(int cpu)
 		return;
 	rdtp->last_accelerate = jiffies;
 	for_each_rcu_flavor(rsp) {
-		rdp = per_cpu_ptr(rsp->rda, cpu);
+		rdp = this_cpu_ptr(rsp->rda);
 		if (!*rdp->nxttail[RCU_DONE_TAIL])
 			continue;
 		rnp = rdp->mynode;
-- 
1.8.1.5

