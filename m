Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751425AbaG1XRf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 19:17:35 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:53343 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764AbaG1XRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 19:17:33 -0400
Date: Mon, 28 Jul 2014 16:17:25 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Pranith Kumar <bobby.prani@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Josh Triplett <josh@joshtriplett.org>, tglx@linutronix.de,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        David Howells <dhowells@redhat.com>,
        Eric Dumazet <edumazet@google.com>, dvhart@linux.intel.com,
        Oleg Nesterov <oleg@redhat.com>, Sasha Levin <sasha.levin@oracle.com>
Subject: Re: [PATCH RFC tip/core/rcu] Fix attempt to avoid offloading
 callbacks unless requested
Message-ID: <20140728231725.GH11241@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140725233623.GA18537@linux.vnet.ibm.com>
 <53D2F211.4090509@gmail.com>
 <20140726023013.GG16182@localhost.localdomain>
 <CAJhHMCCkS9_bO3PHc+cWSMw-eEZfnYVKdXyk6E5P5p7RbU7oLQ@mail.gmail.com>
 <20140728210303.GB26017@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140728210303.GB26017@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14072823-9332-0000-0000-00000186FB2A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2014 at 11:03:06PM +0200, Frederic Weisbecker wrote:
> On Sat, Jul 26, 2014 at 09:51:52PM -0400, Pranith Kumar wrote:
> > On Fri, Jul 25, 2014 at 10:30 PM, Frederic Weisbecker
> > <fweisbec@gmail.com> wrote:
> > 
> > >> I understand that if CONFIG_NO_HZ_FULL_ALL is set then CONFIG_NOCB_CPU_ALL
> > >> will also be set and there is no need for this cpumask_or().
> > >>
> > >> Is there any reason for the coupling between CONFIG_NO_HZ_FULL_ALL
> > >> and CONFIG_NOCB_CPU_ALL?
> > >
> > > Yeah, for any nohz full CPU, we need the corresponding CPU to be rcu_nocb.
> > > So if all CPUs are full dynticks, all CPUs must be rcunocb.
> > >
> > > That said with this patch, the dependency is perhaps not needed anymore.
> > >
> > >>
> > >> I ask because a user can override CONFIG_NO_HZ_FULL_ALL=y at boot time
> > >> using the nohz_full= boot time parameter.
> > >
> > > No, the content of nohz_full= is ignored with CONFIG_NO_HZ_FULL_ALL=y.
> > >
> > 
> > Please correct me if I am wrong but that does not seem to be the case.
> > If a boot parameter is passed, we are setting up tick_nohz_full_mask
> > from tick_nohz_full_setup() and marking tick_nohz_full_running as true.
> > Later on we check this flag and skip the CONFIG_NO_HZ_FULL_ALL
> > initialization.
> 
> You're right, I missed the tick_nohz_full_running check :)
> 
> So if nohz_full is passed, we ignore CONFIG_NO_HZ_FULL_ALL. That looks like
> the right behaviour though.
> 
> Paul what do you think? If we keep that behaviour, Maybe you could blindly do
> rcu_nocb_mask |= tick_nohz_full and remove the CONFIG_NO_HZ_FULL_ALL dependency
> on RCU_NOCB_ALL?

You mean something like the following updated patch?

							Thanx, Paul

------------------------------------------------------------------------

rcu: Fix attempt to avoid unsolicited offloading of callbacks

Commit b58cc46c5f6b (rcu: Don't offload callbacks unless specifically
requested) failed to adjust the callback lists of the CPUs that are
known to be no-CBs CPUs only because they are also nohz_full= CPUs.
This failure can result in callbacks that are posted during early boot
getting stranded on nxtlist for CPUs whose no-CBs property becomes
apparent late, and there can also be spurious warnings about offline
CPUs posting callbacks.

This commit fixes these problems by adding an early-boot rcu_init_nohz()
that properly initializes the no-CBs CPUs.

Note that kernels built with CONFIG_RCU_NOCB_CPU_ALL=y or with
CONFIG_RCU_NOCB_CPU=n do not exhibit this bug.  Neither do kernels
booted without the nohz_full= boot parameter.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Reviewed-by: Pranith Kumar <bobby.prani@gmail.com>

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index d231aa17b1d7..cc7bed1c90dc 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -269,6 +269,14 @@ static inline void rcu_user_hooks_switch(struct task_struct *prev,
 					 struct task_struct *next) { }
 #endif /* CONFIG_RCU_USER_QS */
 
+#ifdef CONFIG_RCU_NOCB_CPU
+void rcu_init_nohz(void);
+#else /* #ifdef CONFIG_RCU_NOCB_CPU */
+static inline void rcu_init_nohz(void)
+{
+}
+#endif /* #else #ifdef CONFIG_RCU_NOCB_CPU */
+
 /**
  * RCU_NONIDLE - Indicate idle-loop code that needs RCU readers
  * @a: Code that RCU needs to pay attention to.
diff --git a/init/Kconfig b/init/Kconfig
index 41066e49e880..6944acd00dff 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -737,7 +737,7 @@ choice
 
 config RCU_NOCB_CPU_NONE
 	bool "No build_forced no-CBs CPUs"
-	depends on RCU_NOCB_CPU && !NO_HZ_FULL_ALL
+	depends on RCU_NOCB_CPU
 	help
 	  This option does not force any of the CPUs to be no-CBs CPUs.
 	  Only CPUs designated by the rcu_nocbs= boot parameter will be
@@ -751,7 +751,7 @@ config RCU_NOCB_CPU_NONE
 
 config RCU_NOCB_CPU_ZERO
 	bool "CPU 0 is a build_forced no-CBs CPU"
-	depends on RCU_NOCB_CPU && !NO_HZ_FULL_ALL
+	depends on RCU_NOCB_CPU
 	help
 	  This option forces CPU 0 to be a no-CBs CPU, so that its RCU
 	  callbacks are invoked by a per-CPU kthread whose name begins
diff --git a/init/main.c b/init/main.c
index e8ae1fef0908..5d8c83ae6c55 100644
--- a/init/main.c
+++ b/init/main.c
@@ -577,6 +577,7 @@ asmlinkage __visible void __init start_kernel(void)
 	idr_init_cache();
 	rcu_init();
 	tick_nohz_init();
+	rcu_init_nohz();
 	context_tracking_init();
 	radix_tree_init();
 	/* init some links before init_ISA_irqs() */
diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 00dc411e9676..91208497e407 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -85,33 +85,6 @@ static void __init rcu_bootup_announce_oddness(void)
 		pr_info("\tBoot-time adjustment of leaf fanout to %d.\n", rcu_fanout_leaf);
 	if (nr_cpu_ids != NR_CPUS)
 		pr_info("\tRCU restricting CPUs from NR_CPUS=%d to nr_cpu_ids=%d.\n", NR_CPUS, nr_cpu_ids);
-#ifdef CONFIG_RCU_NOCB_CPU
-#ifndef CONFIG_RCU_NOCB_CPU_NONE
-	if (!have_rcu_nocb_mask) {
-		zalloc_cpumask_var(&rcu_nocb_mask, GFP_KERNEL);
-		have_rcu_nocb_mask = true;
-	}
-#ifdef CONFIG_RCU_NOCB_CPU_ZERO
-	pr_info("\tOffload RCU callbacks from CPU 0\n");
-	cpumask_set_cpu(0, rcu_nocb_mask);
-#endif /* #ifdef CONFIG_RCU_NOCB_CPU_ZERO */
-#ifdef CONFIG_RCU_NOCB_CPU_ALL
-	pr_info("\tOffload RCU callbacks from all CPUs\n");
-	cpumask_copy(rcu_nocb_mask, cpu_possible_mask);
-#endif /* #ifdef CONFIG_RCU_NOCB_CPU_ALL */
-#endif /* #ifndef CONFIG_RCU_NOCB_CPU_NONE */
-	if (have_rcu_nocb_mask) {
-		if (!cpumask_subset(rcu_nocb_mask, cpu_possible_mask)) {
-			pr_info("\tNote: kernel parameter 'rcu_nocbs=' contains nonexistent CPUs.\n");
-			cpumask_and(rcu_nocb_mask, cpu_possible_mask,
-				    rcu_nocb_mask);
-		}
-		cpulist_scnprintf(nocb_buf, sizeof(nocb_buf), rcu_nocb_mask);
-		pr_info("\tOffload RCU callbacks from CPUs: %s.\n", nocb_buf);
-		if (rcu_nocb_poll)
-			pr_info("\tPoll for callbacks from no-CBs CPUs.\n");
-	}
-#endif /* #ifdef CONFIG_RCU_NOCB_CPU */
 }
 
 #ifdef CONFIG_TREE_PREEMPT_RCU
@@ -2451,6 +2424,67 @@ static void do_nocb_deferred_wakeup(struct rcu_data *rdp)
 	trace_rcu_nocb_wake(rdp->rsp->name, rdp->cpu, TPS("DeferredWakeEmpty"));
 }
 
+void __init rcu_init_nohz(void)
+{
+	int cpu;
+	bool need_rcu_nocb_mask = true;
+	struct rcu_state *rsp;
+
+#ifdef CONFIG_RCU_NOCB_CPU_NONE
+	need_rcu_nocb_mask = false;
+#endif /* #ifndef CONFIG_RCU_NOCB_CPU_NONE */
+
+#if defined(CONFIG_NO_HZ_FULL) && !defined(CONFIG_NO_HZ_FULL_ALL)
+	if (tick_nohz_full_running && cpumask_weight(tick_nohz_full_mask))
+		need_rcu_nocb_mask = true;
+#endif /* #if defined(CONFIG_NO_HZ_FULL) && !defined(CONFIG_NO_HZ_FULL_ALL) */
+
+	if (!have_rcu_nocb_mask && need_rcu_nocb_mask) {
+		zalloc_cpumask_var(&rcu_nocb_mask, GFP_KERNEL);
+		have_rcu_nocb_mask = true;
+	}
+	if (!have_rcu_nocb_mask)
+		return;
+
+#ifdef CONFIG_RCU_NOCB_CPU_ZERO
+	pr_info("\tOffload RCU callbacks from CPU 0\n");
+	cpumask_set_cpu(0, rcu_nocb_mask);
+#endif /* #ifdef CONFIG_RCU_NOCB_CPU_ZERO */
+#ifdef CONFIG_RCU_NOCB_CPU_ALL
+	pr_info("\tOffload RCU callbacks from all CPUs\n");
+	cpumask_copy(rcu_nocb_mask, cpu_possible_mask);
+#endif /* #ifdef CONFIG_RCU_NOCB_CPU_ALL */
+#if defined(CONFIG_NO_HZ_FULL)
+	if (tick_nohz_full_running)
+		cpumask_or(rcu_nocb_mask, rcu_nocb_mask, tick_nohz_full_mask);
+#endif /* #if defined(CONFIG_NO_HZ_FULL)
+
+	if (!cpumask_subset(rcu_nocb_mask, cpu_possible_mask)) {
+		pr_info("\tNote: kernel parameter 'rcu_nocbs=' contains nonexistent CPUs.\n");
+		cpumask_and(rcu_nocb_mask, cpu_possible_mask,
+			    rcu_nocb_mask);
+	}
+	cpulist_scnprintf(nocb_buf, sizeof(nocb_buf), rcu_nocb_mask);
+	pr_info("\tOffload RCU callbacks from CPUs: %s.\n", nocb_buf);
+	if (rcu_nocb_poll)
+		pr_info("\tPoll for callbacks from no-CBs CPUs.\n");
+
+	for_each_rcu_flavor(rsp) {
+		for_each_cpu(cpu, rcu_nocb_mask) {
+			struct rcu_data *rdp = per_cpu_ptr(rsp->rda, cpu);
+
+			/*
+			 * If there are early callbacks, they will need
+			 * to be moved to the nocb lists.
+			 */
+			WARN_ON_ONCE(rdp->nxttail[RCU_NEXT_TAIL] !=
+				     &rdp->nxtlist &&
+				     rdp->nxttail[RCU_NEXT_TAIL] != NULL);
+			init_nocb_callback_list(rdp);
+		}
+	}
+}
+
 /* Initialize per-rcu_data variables for no-CBs CPUs. */
 static void __init rcu_boot_init_nocb_percpu_data(struct rcu_data *rdp)
 {
@@ -2479,10 +2513,6 @@ static void __init rcu_spawn_nocb_kthreads(struct rcu_state *rsp)
 
 	if (rcu_nocb_mask == NULL)
 		return;
-#if defined(CONFIG_NO_HZ_FULL) && !defined(CONFIG_NO_HZ_FULL_ALL)
-	if (tick_nohz_full_running)
-		cpumask_or(rcu_nocb_mask, rcu_nocb_mask, tick_nohz_full_mask);
-#endif /* #if defined(CONFIG_NO_HZ_FULL) && !defined(CONFIG_NO_HZ_FULL_ALL) */
 	if (ls == -1) {
 		ls = int_sqrt(nr_cpu_ids);
 		rcu_nocb_leader_stride = ls;

