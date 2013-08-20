Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134Ab3HTCrf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 22:47:35 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:58842 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026Ab3HTCrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 22:47:31 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 5/9] nohz_full: Add per-CPU idle-state tracking
Date: Mon, 19 Aug 2013 19:47:17 -0700
Message-Id: <1376966841-31774-5-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1376966841-31774-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130820024700.GA31075@linux.vnet.ibm.com>
 <1376966841-31774-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082002-5406-0000-0000-00000B9B35B7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

This commit adds the code that updates the rcu_dyntick structure's
new fields to track the per-CPU idle state based on interrupts and
transitions into and out of the idle loop (NMIs are ignored because NMI
handlers cannot cleanly read out the time anyway).  This code is similar
to the code that maintains RCU's idea of per-CPU idleness, but differs
in that RCU treats CPUs running in user mode as idle, where this new
code does not.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 kernel/rcutree.c        |  4 +++
 kernel/rcutree.h        |  2 ++
 kernel/rcutree_plugin.h | 79 +++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 85 insertions(+)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 4f27b85..b0d2cc3 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -431,6 +431,7 @@ void rcu_idle_enter(void)
 
 	local_irq_save(flags);
 	rcu_eqs_enter(false);
+	rcu_sysidle_enter(&__get_cpu_var(rcu_dynticks), 0);
 	local_irq_restore(flags);
 }
 EXPORT_SYMBOL_GPL(rcu_idle_enter);
@@ -481,6 +482,7 @@ void rcu_irq_exit(void)
 		trace_rcu_dyntick(TPS("--="), oldval, rdtp->dynticks_nesting);
 	else
 		rcu_eqs_enter_common(rdtp, oldval, true);
+	rcu_sysidle_enter(rdtp, 1);
 	local_irq_restore(flags);
 }
 
@@ -549,6 +551,7 @@ void rcu_idle_exit(void)
 
 	local_irq_save(flags);
 	rcu_eqs_exit(false);
+	rcu_sysidle_exit(&__get_cpu_var(rcu_dynticks), 0);
 	local_irq_restore(flags);
 }
 EXPORT_SYMBOL_GPL(rcu_idle_exit);
@@ -600,6 +603,7 @@ void rcu_irq_enter(void)
 		trace_rcu_dyntick(TPS("++="), oldval, rdtp->dynticks_nesting);
 	else
 		rcu_eqs_exit_common(rdtp, oldval, true);
+	rcu_sysidle_exit(rdtp, 1);
 	local_irq_restore(flags);
 }
 
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index 52d1be1..9dd8b17 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -553,6 +553,8 @@ static void rcu_boot_init_nocb_percpu_data(struct rcu_data *rdp);
 static void rcu_spawn_nocb_kthreads(struct rcu_state *rsp);
 static void rcu_kick_nohz_cpu(int cpu);
 static bool init_nocb_callback_list(struct rcu_data *rdp);
+static void rcu_sysidle_enter(struct rcu_dynticks *rdtp, int irq);
+static void rcu_sysidle_exit(struct rcu_dynticks *rdtp, int irq);
 static void rcu_sysidle_init_percpu_data(struct rcu_dynticks *rdtp);
 
 #endif /* #ifndef RCU_TREE_NONCORE */
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index e5baccb..eab81da 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -2378,6 +2378,77 @@ static void rcu_kick_nohz_cpu(int cpu)
 #ifdef CONFIG_NO_HZ_FULL_SYSIDLE
 
 /*
+ * Invoked to note exit from irq or task transition to idle.  Note that
+ * usermode execution does -not- count as idle here!  After all, we want
+ * to detect full-system idle states, not RCU quiescent states and grace
+ * periods.  The caller must have disabled interrupts.
+ */
+static void rcu_sysidle_enter(struct rcu_dynticks *rdtp, int irq)
+{
+	unsigned long j;
+
+	/* Adjust nesting, check for fully idle. */
+	if (irq) {
+		rdtp->dynticks_idle_nesting--;
+		WARN_ON_ONCE(rdtp->dynticks_idle_nesting < 0);
+		if (rdtp->dynticks_idle_nesting != 0)
+			return;  /* Still not fully idle. */
+	} else {
+		if ((rdtp->dynticks_idle_nesting & DYNTICK_TASK_NEST_MASK) ==
+		    DYNTICK_TASK_NEST_VALUE) {
+			rdtp->dynticks_idle_nesting = 0;
+		} else {
+			rdtp->dynticks_idle_nesting -= DYNTICK_TASK_NEST_VALUE;
+			WARN_ON_ONCE(rdtp->dynticks_idle_nesting < 0);
+			return;  /* Still not fully idle. */
+		}
+	}
+
+	/* Record start of fully idle period. */
+	j = jiffies;
+	ACCESS_ONCE(rdtp->dynticks_idle_jiffies) = j;
+	smp_mb__before_atomic_inc();
+	atomic_inc(&rdtp->dynticks_idle);
+	smp_mb__after_atomic_inc();
+	WARN_ON_ONCE(atomic_read(&rdtp->dynticks_idle) & 0x1);
+}
+
+/*
+ * Invoked to note entry to irq or task transition from idle.  Note that
+ * usermode execution does -not- count as idle here!  The caller must
+ * have disabled interrupts.
+ */
+static void rcu_sysidle_exit(struct rcu_dynticks *rdtp, int irq)
+{
+	/* Adjust nesting, check for already non-idle. */
+	if (irq) {
+		rdtp->dynticks_idle_nesting++;
+		WARN_ON_ONCE(rdtp->dynticks_idle_nesting <= 0);
+		if (rdtp->dynticks_idle_nesting != 1)
+			return; /* Already non-idle. */
+	} else {
+		/*
+		 * Allow for irq misnesting.  Yes, it really is possible
+		 * to enter an irq handler then never leave it, and maybe
+		 * also vice versa.  Handle both possibilities.
+		 */
+		if (rdtp->dynticks_idle_nesting & DYNTICK_TASK_NEST_MASK) {
+			rdtp->dynticks_idle_nesting += DYNTICK_TASK_NEST_VALUE;
+			WARN_ON_ONCE(rdtp->dynticks_idle_nesting <= 0);
+			return; /* Already non-idle. */
+		} else {
+			rdtp->dynticks_idle_nesting = DYNTICK_TASK_EXIT_IDLE;
+		}
+	}
+
+	/* Record end of idle period. */
+	smp_mb__before_atomic_inc();
+	atomic_inc(&rdtp->dynticks_idle);
+	smp_mb__after_atomic_inc();
+	WARN_ON_ONCE(!(atomic_read(&rdtp->dynticks_idle) & 0x1));
+}
+
+/*
  * Initialize dynticks sysidle state for CPUs coming online.
  */
 static void rcu_sysidle_init_percpu_data(struct rcu_dynticks *rdtp)
@@ -2387,6 +2458,14 @@ static void rcu_sysidle_init_percpu_data(struct rcu_dynticks *rdtp)
 
 #else /* #ifdef CONFIG_NO_HZ_FULL_SYSIDLE */
 
+static void rcu_sysidle_enter(struct rcu_dynticks *rdtp, int irq)
+{
+}
+
+static void rcu_sysidle_exit(struct rcu_dynticks *rdtp, int irq)
+{
+}
+
 static void rcu_sysidle_init_percpu_data(struct rcu_dynticks *rdtp)
 {
 }
-- 
1.8.1.5

