Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482AbaJ1V5i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 17:57:38 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:50946 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755339AbaJ1V5e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 17:57:34 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, Christoph Lameter <cl@linux.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 01/10] rcu: Remove rcu_dynticks * parameters when they are always this_cpu_ptr(&rcu_dynticks)
Date: Tue, 28 Oct 2014 14:53:28 -0700
Message-Id: <1414533217-24910-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <20141028215140.GA23970@linux.vnet.ibm.com>
References: <20141028215140.GA23970@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102821-0029-0000-0000-000000F4ECA6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Lameter <cl@linux.com>

For some functions in kernel/rcu/tree* the rdtp parameter is always
this_cpu_ptr(rdtp).  Remove the parameter if constant and calculate the
pointer in function.

This will have the advantage that it is obvious that the address are
all per cpu offsets and thus it will enable the use of this_cpu_ops in
the future.

Signed-off-by: Christoph Lameter <cl@linux.com>
[ paulmck: Forward-ported to rcu/dev, whitespace adjustment. ]
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcu/tree.c        | 25 +++++++++++++------------
 kernel/rcu/tree.h        |  4 ++--
 kernel/rcu/tree_plugin.h | 11 +++++++----
 3 files changed, 22 insertions(+), 18 deletions(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 9815447d22e0..c0673c56fb1a 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -510,11 +510,11 @@ cpu_needs_another_gp(struct rcu_state *rsp, struct rcu_data *rdp)
  * we really have entered idle, and must do the appropriate accounting.
  * The caller must have disabled interrupts.
  */
-static void rcu_eqs_enter_common(struct rcu_dynticks *rdtp, long long oldval,
-				bool user)
+static void rcu_eqs_enter_common(long long oldval, bool user)
 {
 	struct rcu_state *rsp;
 	struct rcu_data *rdp;
+	struct rcu_dynticks *rdtp = this_cpu_ptr(&rcu_dynticks);
 
 	trace_rcu_dyntick(TPS("Start"), oldval, rdtp->dynticks_nesting);
 	if (!user && !is_idle_task(current)) {
@@ -565,7 +565,7 @@ static void rcu_eqs_enter(bool user)
 	WARN_ON_ONCE((oldval & DYNTICK_TASK_NEST_MASK) == 0);
 	if ((oldval & DYNTICK_TASK_NEST_MASK) == DYNTICK_TASK_NEST_VALUE) {
 		rdtp->dynticks_nesting = 0;
-		rcu_eqs_enter_common(rdtp, oldval, user);
+		rcu_eqs_enter_common(oldval, user);
 	} else {
 		rdtp->dynticks_nesting -= DYNTICK_TASK_NEST_VALUE;
 	}
@@ -589,7 +589,7 @@ void rcu_idle_enter(void)
 
 	local_irq_save(flags);
 	rcu_eqs_enter(false);
-	rcu_sysidle_enter(this_cpu_ptr(&rcu_dynticks), 0);
+	rcu_sysidle_enter(0);
 	local_irq_restore(flags);
 }
 EXPORT_SYMBOL_GPL(rcu_idle_enter);
@@ -639,8 +639,8 @@ void rcu_irq_exit(void)
 	if (rdtp->dynticks_nesting)
 		trace_rcu_dyntick(TPS("--="), oldval, rdtp->dynticks_nesting);
 	else
-		rcu_eqs_enter_common(rdtp, oldval, true);
-	rcu_sysidle_enter(rdtp, 1);
+		rcu_eqs_enter_common(oldval, true);
+	rcu_sysidle_enter(1);
 	local_irq_restore(flags);
 }
 
@@ -651,9 +651,10 @@ void rcu_irq_exit(void)
  * we really have exited idle, and must do the appropriate accounting.
  * The caller must have disabled interrupts.
  */
-static void rcu_eqs_exit_common(struct rcu_dynticks *rdtp, long long oldval,
-			       int user)
+static void rcu_eqs_exit_common(long long oldval, int user)
 {
+	struct rcu_dynticks *rdtp = this_cpu_ptr(&rcu_dynticks);
+
 	rcu_dynticks_task_exit();
 	smp_mb__before_atomic();  /* Force ordering w/previous sojourn. */
 	atomic_inc(&rdtp->dynticks);
@@ -691,7 +692,7 @@ static void rcu_eqs_exit(bool user)
 		rdtp->dynticks_nesting += DYNTICK_TASK_NEST_VALUE;
 	} else {
 		rdtp->dynticks_nesting = DYNTICK_TASK_EXIT_IDLE;
-		rcu_eqs_exit_common(rdtp, oldval, user);
+		rcu_eqs_exit_common(oldval, user);
 	}
 }
 
@@ -712,7 +713,7 @@ void rcu_idle_exit(void)
 
 	local_irq_save(flags);
 	rcu_eqs_exit(false);
-	rcu_sysidle_exit(this_cpu_ptr(&rcu_dynticks), 0);
+	rcu_sysidle_exit(0);
 	local_irq_restore(flags);
 }
 EXPORT_SYMBOL_GPL(rcu_idle_exit);
@@ -763,8 +764,8 @@ void rcu_irq_enter(void)
 	if (oldval)
 		trace_rcu_dyntick(TPS("++="), oldval, rdtp->dynticks_nesting);
 	else
-		rcu_eqs_exit_common(rdtp, oldval, true);
-	rcu_sysidle_exit(rdtp, 1);
+		rcu_eqs_exit_common(oldval, true);
+	rcu_sysidle_exit(1);
 	local_irq_restore(flags);
 }
 
diff --git a/kernel/rcu/tree.h b/kernel/rcu/tree.h
index bbdc45d8d74f..8e90562010ec 100644
--- a/kernel/rcu/tree.h
+++ b/kernel/rcu/tree.h
@@ -606,8 +606,8 @@ static void __init rcu_organize_nocb_kthreads(struct rcu_state *rsp);
 #endif /* #ifdef CONFIG_RCU_NOCB_CPU */
 static void __maybe_unused rcu_kick_nohz_cpu(int cpu);
 static bool init_nocb_callback_list(struct rcu_data *rdp);
-static void rcu_sysidle_enter(struct rcu_dynticks *rdtp, int irq);
-static void rcu_sysidle_exit(struct rcu_dynticks *rdtp, int irq);
+static void rcu_sysidle_enter(int irq);
+static void rcu_sysidle_exit(int irq);
 static void rcu_sysidle_check_cpu(struct rcu_data *rdp, bool *isidle,
 				  unsigned long *maxj);
 static bool is_sysidle_rcu_state(struct rcu_state *rsp);
diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index c1d7f27bd38f..09547143628a 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -2761,9 +2761,10 @@ static int full_sysidle_state;		/* Current system-idle state. */
  * to detect full-system idle states, not RCU quiescent states and grace
  * periods.  The caller must have disabled interrupts.
  */
-static void rcu_sysidle_enter(struct rcu_dynticks *rdtp, int irq)
+static void rcu_sysidle_enter(int irq)
 {
 	unsigned long j;
+	struct rcu_dynticks *rdtp = this_cpu_ptr(&rcu_dynticks);
 
 	/* If there are no nohz_full= CPUs, no need to track this. */
 	if (!tick_nohz_full_enabled())
@@ -2832,8 +2833,10 @@ void rcu_sysidle_force_exit(void)
  * usermode execution does -not- count as idle here!  The caller must
  * have disabled interrupts.
  */
-static void rcu_sysidle_exit(struct rcu_dynticks *rdtp, int irq)
+static void rcu_sysidle_exit(int irq)
 {
+	struct rcu_dynticks *rdtp = this_cpu_ptr(&rcu_dynticks);
+
 	/* If there are no nohz_full= CPUs, no need to track this. */
 	if (!tick_nohz_full_enabled())
 		return;
@@ -3127,11 +3130,11 @@ static void rcu_sysidle_init_percpu_data(struct rcu_dynticks *rdtp)
 
 #else /* #ifdef CONFIG_NO_HZ_FULL_SYSIDLE */
 
-static void rcu_sysidle_enter(struct rcu_dynticks *rdtp, int irq)
+static void rcu_sysidle_enter(int irq)
 {
 }
 
-static void rcu_sysidle_exit(struct rcu_dynticks *rdtp, int irq)
+static void rcu_sysidle_exit(int irq)
 {
 }
 
-- 
1.8.1.5

