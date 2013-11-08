Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752964Ab3KHDXu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 22:23:50 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:49193 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752935Ab3KHDXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 22:23:48 -0500
Date: Thu, 7 Nov 2013 19:23:43 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mike Galbraith <bitbucket@online.de>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        RT <linux-rt-users@vger.kernel.org>
Subject: Re: CONFIG_NO_HZ_FULL + CONFIG_PREEMPT_RT_FULL = nogo
Message-ID: <20131108032343.GA18245@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1383228427.5272.36.camel@marge.simpson.net>
 <alpine.DEB.2.02.1311061842160.23353@ionos.tec.linutronix.de>
 <1383794799.5441.16.camel@marge.simpson.net>
 <1383798668.5441.25.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383798668.5441.25.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13110803-7164-0000-0000-0000031C4850
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 07, 2013 at 05:31:08AM +0100, Mike Galbraith wrote:
> On Thu, 2013-11-07 at 04:26 +0100, Mike Galbraith wrote: 
> > On Wed, 2013-11-06 at 18:49 +0100, Thomas Gleixner wrote: 
> 
> > > I bet you are trying to work around some of the side effects of the
> > > occasional tick which is still necessary despite of full nohz, right?
> > 
> > Nope, I wanted to check out cost of nohz_full for rt, and found that it
> > doesn't work at all instead, looked, and found that the sole running
> > task has just awakened ksoftirqd when it wants to shut the tick down, so
> > that shutdown never happens. 
> 
> Like so in virgin 3.10-rt.  Box is x3550 M3 booted nowatchdog
> rcu_nocbs=1-3 nohz_full=1-3, and CPUs1-3 are completely isolated via
> cpusets as well.

Hmmm...  The fact that the CPU is getting scheduling-clock interrupts
is what is causing the RCU_SOFTIRQs.  If you take a scheduling-clock
interrupt on a CPU that RCU is waiting for, it will do raise_softirq()
in order to get the CPU to respond to RCU.

So the RCU_SOFTIRQs are a direct consequence of the scheduling-clock
interrupts.

An untested patch that gets rid of the RCU_SOFTIRQs in this case is below.
Not sure how to help with the scheduling-clock interrupts.

							Thanx, Paul

> ... 
>             pert-5229  [003] d..h2..   684.481615: hrtimer_cancel: hrtimer=ffff88017fccbac0
>             pert-5229  [003] d..h1..   684.481616: hrtimer_expire_entry: hrtimer=ffff88017fccbac0 function=tick_sched_timer now=683820187877
>             pert-5229  [003] d..h2..   684.481616: sched_stat_runtime: comm=pert pid=5229 runtime=993917 [ns] vruntime=179048871558 [ns]
>             pert-5229  [003] d..h1..   684.481616: softirq_raise: vec=1 [action=TIMER]
>             pert-5229  [003] d..h1..   684.481616: hrtimer_expire_exit: hrtimer=ffff88017fccbac0
>             pert-5229  [003] d..h2..   684.481617: hrtimer_start: hrtimer=ffff88017fccbac0 function=tick_sched_timer expires=683821187500 softexpires=683821187500
>             pert-5229  [003] d...3..   684.481618: sched_stat_runtime: comm=pert pid=5229 runtime=1634 [ns] vruntime=179048873192 [ns]
>             pert-5229  [003] d.L.3..   684.481618: sched_wakeup: comm=ksoftirqd/3 pid=49 prio=120 success=1 target_cpu=003
>             pert-5229  [003] d.L.1..   684.481618: tick_stop: success=no msg=more than 1 task in runqueue
> 
>             pert-5229  [003] d.L.1..   684.481619: tick_stop: success=no msg=more than 1 task in runqueue
> 
>             pert-5229  [003] d.L.3..   684.481620: sched_stat_runtime: comm=pert pid=5229 runtime=2096 [ns] vruntime=179048875288 [ns]
>             pert-5229  [003] d...3..   684.481620: sched_switch: prev_comm=pert prev_pid=5229 prev_prio=120 prev_state=R+ ==> next_comm=ksoftirqd/3 next_pid=49 next_prio=120
>      ksoftirqd/3-49    [003] ....111   684.481621: softirq_entry: vec=1 [action=TIMER]
>      ksoftirqd/3-49    [003] ....111   684.481621: softirq_exit: vec=1 [action=TIMER]
>      ksoftirqd/3-49    [003] d...3..   684.481622: sched_stat_runtime: comm=ksoftirqd/3 pid=49 runtime=1934 [ns] vruntime=179039875126 [ns]
>      ksoftirqd/3-49    [003] d...3..   684.481622: sched_switch: prev_comm=ksoftirqd/3 prev_pid=49 prev_prio=120 prev_state=S ==> next_comm=pert next_pid=5229 next_prio=120
>             pert-5229  [003] d...3..   684.481623: sched_stat_runtime: comm=pert pid=5229 runtime=1289 [ns] vruntime=179048876577 [ns]
>             pert-5229  [003] d..h2..   684.482616: hrtimer_cancel: hrtimer=ffff88017fccbac0
>             pert-5229  [003] d..h1..   684.482617: hrtimer_expire_entry: hrtimer=ffff88017fccbac0 function=tick_sched_timer now=683821188024
>             pert-5229  [003] d..h2..   684.482617: sched_stat_runtime: comm=pert pid=5229 runtime=994281 [ns] vruntime=179049870858 [ns]
>             pert-5229  [003] d..h1..   684.482617: softirq_raise: vec=1 [action=TIMER]
>             pert-5229  [003] d..h1..   684.482618: softirq_raise: vec=9 [action=RCU]
>             pert-5229  [003] d..h1..   684.482618: hrtimer_expire_exit: hrtimer=ffff88017fccbac0
>             pert-5229  [003] d..h2..   684.482618: hrtimer_start: hrtimer=ffff88017fccbac0 function=tick_sched_timer expires=683822187500 softexpires=683822187500
>             pert-5229  [003] d...3..   684.482619: sched_stat_runtime: comm=pert pid=5229 runtime=1719 [ns] vruntime=179049872577 [ns]
>             pert-5229  [003] d.L.3..   684.482619: sched_wakeup: comm=ksoftirqd/3 pid=49 prio=120 success=1 target_cpu=003
>             pert-5229  [003] d.L.1..   684.482619: tick_stop: success=no msg=more than 1 task in runqueue
> 
>             pert-5229  [003] d.L.1..   684.482620: tick_stop: success=no msg=more than 1 task in runqueue
> 
>             pert-5229  [003] d.L.3..   684.482621: sched_stat_runtime: comm=pert pid=5229 runtime=2204 [ns] vruntime=179049874781 [ns]
>             pert-5229  [003] d...3..   684.482621: sched_switch: prev_comm=pert prev_pid=5229 prev_prio=120 prev_state=R+ ==> next_comm=ksoftirqd/3 next_pid=49 next_prio=120
>      ksoftirqd/3-49    [003] ....111   684.482622: softirq_entry: vec=1 [action=TIMER]
>      ksoftirqd/3-49    [003] ....111   684.482623: softirq_exit: vec=1 [action=TIMER]
>      ksoftirqd/3-49    [003] ....111   684.482623: softirq_entry: vec=9 [action=RCU]
>      ksoftirqd/3-49    [003] ....111   684.482624: softirq_exit: vec=9 [action=RCU]
>      ksoftirqd/3-49    [003] d...3..   684.482624: sched_stat_runtime: comm=ksoftirqd/3 pid=49 runtime=3049 [ns] vruntime=179040875626 [ns]
>      ksoftirqd/3-49    [003] d...3..   684.482624: sched_switch: prev_comm=ksoftirqd/3 prev_pid=49 prev_prio=120 prev_state=S ==> next_comm=pert next_pid=5229 next_prio=120
>             pert-5229  [003] d...3..   684.482626: sched_stat_runtime: comm=pert pid=5229 runtime=1422 [ns] vruntime=179049876203 [ns]
>             pert-5229  [003] d..h2..   684.483617: hrtimer_cancel: hrtimer=ffff88017fccbac0
>             pert-5229  [003] d..h1..   684.483617: hrtimer_expire_entry: hrtimer=ffff88017fccbac0 function=tick_sched_timer now=683822187923
>             pert-5229  [003] d..h2..   684.483618: sched_stat_runtime: comm=pert pid=5229 runtime=992021 [ns] vruntime=179050868224 [ns]
>             pert-5229  [003] d..h1..   684.483618: softirq_raise: vec=1 [action=TIMER]
>             pert-5229  [003] d..h1..   684.483618: softirq_raise: vec=9 [action=RCU]
>             pert-5229  [003] d..h1..   684.483618: hrtimer_expire_exit: hrtimer=ffff88017fccbac0
>             pert-5229  [003] d..h2..   684.483618: hrtimer_start: hrtimer=ffff88017fccbac0 function=tick_sched_timer expires=683823187500 softexpires=683823187500
>             pert-5229  [003] d...3..   684.483619: sched_stat_runtime: comm=pert pid=5229 runtime=1778 [ns] vruntime=179050870002 [ns]
>             pert-5229  [003] d.L.3..   684.483620: sched_wakeup: comm=ksoftirqd/3 pid=49 prio=120 success=1 target_cpu=003
>             pert-5229  [003] d.L.1..   684.483620: tick_stop: success=no msg=more than 1 task in runqueue
> 
>             pert-5229  [003] d.L.1..   684.483621: tick_stop: success=no msg=more than 1 task in runqueue
> 
>             pert-5229  [003] d.L.3..   684.483621: sched_stat_runtime: comm=pert pid=5229 runtime=2096 [ns] vruntime=179050872098 [ns]
>             pert-5229  [003] d...3..   684.483622: sched_switch: prev_comm=pert prev_pid=5229 prev_prio=120 prev_state=R+ ==> next_comm=ksoftirqd/3 next_pid=49 next_prio=120
>      ksoftirqd/3-49    [003] ....111   684.483623: softirq_entry: vec=1 [action=TIMER]
>      ksoftirqd/3-49    [003] ....111   684.483623: softirq_exit: vec=1 [action=TIMER]
>      ksoftirqd/3-49    [003] ....111   684.483623: softirq_entry: vec=9 [action=RCU]
>      ksoftirqd/3-49    [003] ....111   684.483624: softirq_exit: vec=9 [action=RCU]
>      ksoftirqd/3-49    [003] d...3..   684.483625: sched_stat_runtime: comm=ksoftirqd/3 pid=49 runtime=3187 [ns] vruntime=179041873189 [ns]
>      ksoftirqd/3-49    [003] d...3..   684.483625: sched_switch: prev_comm=ksoftirqd/3 prev_pid=49 prev_prio=120 prev_state=S ==> next_comm=pert next_pid=5229 next_prio=120
>             pert-5229  [003] d...3..   684.483626: sched_stat_runtime: comm=pert pid=5229 runtime=1331 [ns] vruntime=179050873429 [ns]

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 32618b3fe4e6..ee4de3f6a77e 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -2658,6 +2658,10 @@ static int __rcu_pending(struct rcu_state *rsp, struct rcu_data *rdp)
 	/* Check for CPU stalls, if enabled. */
 	check_cpu_stall(rsp, rdp);
 
+	/* Is this CPU a NO_HZ_FULL CPU that should ignore RCU? */
+	if (rcu_nohz_full_cpu(rsp))
+		return 0;
+
 	/* Is the RCU core waiting for a quiescent state from this CPU? */
 	if (rcu_scheduler_fully_active &&
 	    rdp->qs_pending && !rdp->passed_quiesce) {
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index 5f97eab602cd..42cdc77dc7f1 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -562,6 +562,7 @@ static void rcu_sysidle_report_gp(struct rcu_state *rsp, int isidle,
 				  unsigned long maxj);
 static void rcu_bind_gp_kthread(void);
 static void rcu_sysidle_init_percpu_data(struct rcu_dynticks *rdtp);
+static bool rcu_nohz_full_cpu(struct rcu_state *rsp);
 
 #endif /* #ifndef RCU_TREE_NONCORE */
 
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 130c97b027f2..3e7087d3b9df 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -2795,3 +2795,23 @@ static void rcu_sysidle_init_percpu_data(struct rcu_dynticks *rdtp)
 }
 
 #endif /* #else #ifdef CONFIG_NO_HZ_FULL_SYSIDLE */
+
+/*
+ * Is this CPU a NO_HZ_FULL CPU that should ignore RCU so that the
+ * grace-period kthread will do force_quiescent_state() processing?
+ * The idea is to avoid waking up RCU core processing on such a
+ * CPU unless the grace period has extended for too long.
+ *
+ * This code relies on the fact that all NO_HZ_FULL CPUs are also
+ * CONFIG_RCU_NOCB_CPUs.
+ */
+static bool rcu_nohz_full_cpu(struct rcu_state *rsp)
+{
+#ifdef CONFIG_NO_HZ_FULL
+	if (tick_nohz_full_cpu(smp_processor_id()) &&
+	    (!rcu_gp_in_progress(rsp) ||
+	     ULONG_CMP_LT(jiffies, ACCESS_ONCE(rsp->gp_start) + HZ)))
+		return 1;
+#endif /* #ifdef CONFIG_NO_HZ_FULL */
+	return 0;
+}

