Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755293AbaIPUmE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 16:42:04 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:52261 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752840AbaIPUmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 16:42:01 -0400
Date: Tue, 16 Sep 2014 13:41:56 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Clark Williams <clark.williams@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rcu: unify boost and kthread priorities
Message-ID: <20140916204156.GP4723@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140915100524.2cd80d2e@sluggy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140915100524.2cd80d2e@sluggy>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14091620-6688-0000-0000-000004D8C03A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 15, 2014 at 10:05:24AM -0500, Clark Williams wrote:
> Paul,
> 
> Here's the result of our conversation Friday, regarding the per-CPU and
> boost priorities:
> 
> Rename CONFIG_RCU_BOOST_PRIO to CONFIG_RCU_KTHREAD_PRIO and use this
> value for both the per-CPU kthreads (rcuc/N) and the rcu boosting
> threads (rcub/n).
> 
> Also, create the module_parameter rcutree.kthread_prio to be used on
> the kernel command line at boot to set a new value
> (rcutree.kthread_prio=N).
> 
> Signed-off-by: Clark Williams <clark.williams@gmail.com>

Thank you, Clark!

I queued this, porting to rcu/dev, which resulted in the following
patch.  Please check this to make sure it still reflects your intent.
In the meantime, I will start testing.

							Thanx, Paul

------------------------------------------------------------------------

rcu: unify boost and kthread priorities

Rename CONFIG_RCU_BOOST_PRIO to CONFIG_RCU_KTHREAD_PRIO and use this
value for both the per-CPU kthreads (rcuc/N) and the rcu boosting
threads (rcub/n).

Also, create the module_parameter rcutree.kthread_prio to be used on
the kernel command line at boot to set a new value (rcutree.kthread_prio=N).

Signed-off-by: Clark Williams <clark.williams@gmail.com>
[ paulmck: Ported to rcu/dev. ]
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index e95b0f43229f..c40395720a6f 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2899,6 +2899,12 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			quiescent states.  Units are jiffies, minimum
 			value is one, and maximum value is HZ.
 
+	rcutree.kthread_prio= 	 [KNL,BOOT]
+			Set the SCHED_FIFO priority of the RCU
+			per-CPU kthreads (rcuc/N). This value is also
+			used for the priority of the RCU boost threads
+			(rcub/N). Valid values are 1-99.
+
 	rcutree.rcu_nocb_leader_stride= [KNL]
 			Set the number of NOCB kthread groups, which
 			defaults to the square root of the number of
diff --git a/init/Kconfig b/init/Kconfig
index 95a1447a33bd..8a2b97c4026a 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -672,30 +672,31 @@ config RCU_BOOST
 	  Say Y here if you are working with real-time apps or heavy loads
 	  Say N here if you are unsure.
 
-config RCU_BOOST_PRIO
-	int "Real-time priority to boost RCU readers to"
+config RCU_KTHREAD_PRIO
+	int "Real-time priority to use for RCU worker threads"
 	range 1 99
 	depends on RCU_BOOST
 	default 1
 	help
-	  This option specifies the real-time priority to which long-term
-	  preempted RCU readers are to be boosted.  If you are working
-	  with a real-time application that has one or more CPU-bound
-	  threads running at a real-time priority level, you should set
-	  RCU_BOOST_PRIO to a priority higher then the highest-priority
-	  real-time CPU-bound thread.  The default RCU_BOOST_PRIO value
-	  of 1 is appropriate in the common case, which is real-time
+	  This option specifies the SCHED_FIFO priority value that will be
+	  assigned to the rcuc/n and rcub/n threads and is also the value
+	  used for RCU_BOOST (if enabled). If you are working with a
+	  real-time application that has one or more CPU-bound threads
+	  running at a real-time priority level, you should set
+	  RCU_KTHREAD_PRIO to a priority higher than the highest-priority
+	  real-time CPU-bound application thread.  The default RCU_KTHREAD_PRIO
+	  value of 1 is appropriate in the common case, which is real-time
 	  applications that do not have any CPU-bound threads.
 
 	  Some real-time applications might not have a single real-time
 	  thread that saturates a given CPU, but instead might have
 	  multiple real-time threads that, taken together, fully utilize
-	  that CPU.  In this case, you should set RCU_BOOST_PRIO to
+	  that CPU.  In this case, you should set RCU_KTHREAD_PRIO to
 	  a priority higher than the lowest-priority thread that is
 	  conspiring to prevent the CPU from running any non-real-time
 	  tasks.  For example, if one thread at priority 10 and another
 	  thread at priority 5 are between themselves fully consuming
-	  the CPU time on a given CPU, then RCU_BOOST_PRIO should be
+	  the CPU time on a given CPU, then RCU_KTHREAD_PRIO should be
 	  set to priority 6 or higher.
 
 	  Specify the real-time priority, or take the default if unsure.
diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index cbd08fc4b706..77f9376f3f8d 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -30,12 +30,13 @@
 #include <linux/smpboot.h>
 #include "../time/tick-internal.h"
 
-#define RCU_KTHREAD_PRIO 1
-
 #ifdef CONFIG_RCU_BOOST
 
 #include "../locking/rtmutex_common.h"
-#define RCU_BOOST_PRIO CONFIG_RCU_BOOST_PRIO
+
+/* rcuc/rcub kthread realtime priority */
+static int kthread_prio = CONFIG_RCU_KTHREAD_PRIO;
+module_param(kthread_prio, int, 0644);
 
 /*
  * Control variables for per-CPU and per-rcu_node kthreads.  These
@@ -46,11 +47,7 @@ DEFINE_PER_CPU(unsigned int, rcu_cpu_kthread_status);
 DEFINE_PER_CPU(unsigned int, rcu_cpu_kthread_loops);
 DEFINE_PER_CPU(char, rcu_cpu_has_work);
 
-#else /* #ifdef CONFIG_RCU_BOOST */
-
-#define RCU_BOOST_PRIO RCU_KTHREAD_PRIO
-
-#endif /* #else #ifdef CONFIG_RCU_BOOST */
+#endif /* #ifdef CONFIG_RCU_BOOST */
 
 #ifdef CONFIG_RCU_NOCB_CPU
 static cpumask_var_t rcu_nocb_mask; /* CPUs to have callbacks offloaded. */
@@ -95,6 +92,9 @@ static void __init rcu_bootup_announce_oddness(void)
 		pr_info("\tBoot-time adjustment of leaf fanout to %d.\n", rcu_fanout_leaf);
 	if (nr_cpu_ids != NR_CPUS)
 		pr_info("\tRCU restricting CPUs from NR_CPUS=%d to nr_cpu_ids=%d.\n", NR_CPUS, nr_cpu_ids);
+#ifdef CONFIG_RCU_BOOST
+	pr_info("\tRCU kthread priority: %d.\n", kthread_prio);
+#endif
 }
 
 #ifdef CONFIG_TREE_PREEMPT_RCU
@@ -1326,7 +1326,7 @@ static int rcu_spawn_one_boost_kthread(struct rcu_state *rsp,
 	smp_mb__after_unlock_lock();
 	rnp->boost_kthread_task = t;
 	raw_spin_unlock_irqrestore(&rnp->lock, flags);
-	sp.sched_priority = RCU_BOOST_PRIO;
+	sp.sched_priority = kthread_prio;
 	sched_setscheduler_nocheck(t, SCHED_FIFO, &sp);
 	wake_up_process(t); /* get to TASK_INTERRUPTIBLE quickly. */
 	return 0;
@@ -1343,7 +1343,7 @@ static void rcu_cpu_kthread_setup(unsigned int cpu)
 {
 	struct sched_param sp;
 
-	sp.sched_priority = RCU_KTHREAD_PRIO;
+	sp.sched_priority = kthread_prio;
 	sched_setscheduler_nocheck(current, SCHED_FIFO, &sp);
 }
 

