Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752169Ab3HTCrk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 22:47:40 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:43613 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032Ab3HTCrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 22:47:32 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 4/9] nohz_full: Add rcu_dyntick data for scalable detection of all-idle state
Date: Mon, 19 Aug 2013 19:47:16 -0700
Message-Id: <1376966841-31774-4-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1376966841-31774-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130820024700.GA31075@linux.vnet.ibm.com>
 <1376966841-31774-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082002-1542-0000-0000-000000A790EA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

This commit adds fields to the rcu_dyntick structure that are used to
detect idle CPUs.  These new fields differ from the existing ones in
that the existing ones consider a CPU executing in user mode to be idle,
where the new ones consider CPUs executing in user mode to be busy.
The handling of these new fields is otherwise quite similar to that for
the exiting fields.  This commit also adds the initialization required
for these fields.

So, why is usermode execution treated differently, with RCU considering
it a quiescent state equivalent to idle, while in contrast the new
full-system idle state detection considers usermode execution to be
non-idle?

It turns out that although one of RCU's quiescent states is usermode
execution, it is not a full-system idle state.  This is because the
purpose of the full-system idle state is not RCU, but rather determining
when accurate timekeeping can safely be disabled.  Whenever accurate
timekeeping is required in a CONFIG_NO_HZ_FULL kernel, at least one
CPU must keep the scheduling-clock tick going.  If even one CPU is
executing in user mode, accurate timekeeping is requires, particularly for
architectures where gettimeofday() and friends do not enter the kernel.
Only when all CPUs are really and truly idle can accurate timekeeping be
disabled, allowing all CPUs to turn off the scheduling clock interrupt,
thus greatly improving energy efficiency.

This naturally raises the question "Why is this code in RCU rather than in
timekeeping?", and the answer is that RCU has the data and infrastructure
to efficiently make this determination.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 kernel/rcutree.c        |  5 +++++
 kernel/rcutree.h        |  9 +++++++++
 kernel/rcutree_plugin.h | 19 +++++++++++++++++++
 3 files changed, 33 insertions(+)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 8807019..4f27b85 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -224,6 +224,10 @@ EXPORT_SYMBOL_GPL(rcu_note_context_switch);
 DEFINE_PER_CPU(struct rcu_dynticks, rcu_dynticks) = {
 	.dynticks_nesting = DYNTICK_TASK_EXIT_IDLE,
 	.dynticks = ATOMIC_INIT(1),
+#ifdef CONFIG_NO_HZ_FULL_SYSIDLE
+	.dynticks_idle_nesting = DYNTICK_TASK_NEST_VALUE,
+	.dynticks_idle = ATOMIC_INIT(1),
+#endif /* #ifdef CONFIG_NO_HZ_FULL_SYSIDLE */
 };
 
 static long blimit = 10;	/* Maximum callbacks per rcu_do_batch. */
@@ -2904,6 +2908,7 @@ rcu_init_percpu_data(int cpu, struct rcu_state *rsp, int preemptible)
 	rdp->blimit = blimit;
 	init_callback_list(rdp);  /* Re-enable callbacks on this CPU. */
 	rdp->dynticks->dynticks_nesting = DYNTICK_TASK_EXIT_IDLE;
+	rcu_sysidle_init_percpu_data(rdp->dynticks);
 	atomic_set(&rdp->dynticks->dynticks,
 		   (atomic_read(&rdp->dynticks->dynticks) & ~0x1) + 1);
 	raw_spin_unlock(&rnp->lock);		/* irqs remain disabled. */
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index cbdeac6..52d1be1 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -88,6 +88,14 @@ struct rcu_dynticks {
 				    /* Process level is worth LLONG_MAX/2. */
 	int dynticks_nmi_nesting;   /* Track NMI nesting level. */
 	atomic_t dynticks;	    /* Even value for idle, else odd. */
+#ifdef CONFIG_NO_HZ_FULL_SYSIDLE
+	long long dynticks_idle_nesting;
+				    /* irq/process nesting level from idle. */
+	atomic_t dynticks_idle;	    /* Even value for idle, else odd. */
+				    /*  "Idle" excludes userspace execution. */
+	unsigned long dynticks_idle_jiffies;
+				    /* End of last non-NMI non-idle period. */
+#endif /* #ifdef CONFIG_NO_HZ_FULL_SYSIDLE */
 #ifdef CONFIG_RCU_FAST_NO_HZ
 	bool all_lazy;		    /* Are all CPU's CBs lazy? */
 	unsigned long nonlazy_posted;
@@ -545,6 +553,7 @@ static void rcu_boot_init_nocb_percpu_data(struct rcu_data *rdp);
 static void rcu_spawn_nocb_kthreads(struct rcu_state *rsp);
 static void rcu_kick_nohz_cpu(int cpu);
 static bool init_nocb_callback_list(struct rcu_data *rdp);
+static void rcu_sysidle_init_percpu_data(struct rcu_dynticks *rdtp);
 
 #endif /* #ifndef RCU_TREE_NONCORE */
 
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index dff86f5..e5baccb 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -2373,3 +2373,22 @@ static void rcu_kick_nohz_cpu(int cpu)
 		smp_send_reschedule(cpu);
 #endif /* #ifdef CONFIG_NO_HZ_FULL */
 }
+
+
+#ifdef CONFIG_NO_HZ_FULL_SYSIDLE
+
+/*
+ * Initialize dynticks sysidle state for CPUs coming online.
+ */
+static void rcu_sysidle_init_percpu_data(struct rcu_dynticks *rdtp)
+{
+	rdtp->dynticks_idle_nesting = DYNTICK_TASK_NEST_VALUE;
+}
+
+#else /* #ifdef CONFIG_NO_HZ_FULL_SYSIDLE */
+
+static void rcu_sysidle_init_percpu_data(struct rcu_dynticks *rdtp)
+{
+}
+
+#endif /* #else #ifdef CONFIG_NO_HZ_FULL_SYSIDLE */
-- 
1.8.1.5

