Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593Ab3F1UKl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 16:10:41 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:44695 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612Ab3F1UKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 16:10:35 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC nohz_full v2 2/7] nohz_full: Add rcu_dyntick data for scalable detection of all-idle state
Date: Fri, 28 Jun 2013 13:10:17 -0700
Message-Id: <1372450222-19420-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1372450222-19420-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130628200949.GA17458@linux.vnet.ibm.com>
 <1372450222-19420-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13062820-5518-0000-0000-00000FF3A554
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

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/rcutree.c        |  5 +++++
 kernel/rcutree.h        |  9 +++++++++
 kernel/rcutree_plugin.h | 19 +++++++++++++++++++
 3 files changed, 33 insertions(+)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 78745ae..259e300 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -209,6 +209,10 @@ EXPORT_SYMBOL_GPL(rcu_note_context_switch);
 DEFINE_PER_CPU(struct rcu_dynticks, rcu_dynticks) = {
 	.dynticks_nesting = DYNTICK_TASK_EXIT_IDLE,
 	.dynticks = ATOMIC_INIT(1),
+#ifdef CONFIG_NO_HZ_FULL_SYSIDLE
+	.dynticks_idle_nesting = DYNTICK_TASK_NEST_VALUE,
+	.dynticks_idle = ATOMIC_INIT(1),
+#endif /* #ifdef CONFIG_NO_HZ_FULL_SYSIDLE */
 };
 
 static long blimit = 10;	/* Maximum callbacks per rcu_do_batch. */
@@ -2902,6 +2906,7 @@ rcu_init_percpu_data(int cpu, struct rcu_state *rsp, int preemptible)
 	rdp->blimit = blimit;
 	init_callback_list(rdp);  /* Re-enable callbacks on this CPU. */
 	rdp->dynticks->dynticks_nesting = DYNTICK_TASK_EXIT_IDLE;
+	rcu_sysidle_init_percpu_data(rdp->dynticks);
 	atomic_set(&rdp->dynticks->dynticks,
 		   (atomic_read(&rdp->dynticks->dynticks) & ~0x1) + 1);
 	raw_spin_unlock(&rnp->lock);		/* irqs remain disabled. */
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index b383258..bd99d59 100644
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
index 769e12e..6937eb6 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -2375,3 +2375,22 @@ static void rcu_kick_nohz_cpu(int cpu)
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

