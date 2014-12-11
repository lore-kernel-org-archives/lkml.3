Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758072AbaLKTKE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 14:10:04 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:34737 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752973AbaLKTKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 14:10:02 -0500
Date: Thu, 11 Dec 2014 11:09:57 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Miroslav Benes <mbenes@suse.cz>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: rcu_sched stall detected, but no state dump
Message-ID: <20141211190957.GA28172@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <alpine.LNX.2.00.1412101334380.22639@pobox.suse.cz>
 <20141210162823.GT25340@linux.vnet.ibm.com>
 <alpine.LNX.2.00.1412111024010.17929@pobox.suse.cz>
 <20141211165010.GI25340@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141211165010.GI25340@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14121119-0025-0000-0000-000006D904A8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 11, 2014 at 08:50:10AM -0800, Paul E. McKenney wrote:
> On Thu, Dec 11, 2014 at 10:35:15AM +0100, Miroslav Benes wrote:
> > On Wed, 10 Dec 2014, Paul E. McKenney wrote:
> > 
> > > On Wed, Dec 10, 2014 at 01:52:02PM +0100, Miroslav Benes wrote:
> > > > 
> > > > Hi,
> > > > 
> > > > today I came across RCU stall which was correctly detected, but there is 
> > > > no state dump. This is a bit suspicious, I think. 
> > > > 
> > > > This is the output in serial console:
> > > > 
> > > > [  105.727003] INFO: rcu_sched detected stalls on CPUs/tasks:
> > > > [  105.727003]  (detected by 0, t=21002 jiffies, g=3269, c=3268, q=138)
> > > > [  105.727003] INFO: Stall ended before state dump start
> > > > [  168.732006] INFO: rcu_sched detected stalls on CPUs/tasks:
> > > > [  168.732006]  (detected by 0, t=84007 jiffies, g=3269, c=3268, q=270)
> > > > [  168.732006] INFO: Stall ended before state dump start
> > > > [  231.737003] INFO: rcu_sched detected stalls on CPUs/tasks:
> > > > [  231.737003]  (detected by 0, t=147012 jiffies, g=3269, c=3268, q=388)
> > > > [  231.737003] INFO: Stall ended before state dump start
> > > > [  294.742003] INFO: rcu_sched detected stalls on CPUs/tasks:
> > > > [  294.742003]  (detected by 0, t=210017 jiffies, g=3269, c=3268, q=539)
> > > > [  294.742003] INFO: Stall ended before state dump start
> > > > [  357.747003] INFO: rcu_sched detected stalls on CPUs/tasks:
> > > > [  357.747003]  (detected by 0, t=273022 jiffies, g=3269, c=3268, q=693)
> > > > [  357.747003] INFO: Stall ended before state dump start
> > > > [  420.752003] INFO: rcu_sched detected stalls on CPUs/tasks:
> > > > [  420.752003]  (detected by 0, t=336027 jiffies, g=3269, c=3268, q=806)
> > > > [  420.752003] INFO: Stall ended before state dump start
> > > > ...
> > > > 
> > > > It can be reproduced by trivial code attached to this mail (infinite 
> > > > loop in kernel thread created in kernel module). I have CONFIG_PREEMPT=n. 
> > > > The kernel thread is scheduled on the same CPU which causes soft lockup 
> > > > (reliably detected when lockup detector is on). There is certainly RCU 
> > > > stall, but I would expect a state dump. Is this an expected behaviour? 
> > > > Maybe I overlooked some config option, don't know.
> > > 
> > > Definitely not expected behavior!  Unless you have only one CPU, but in
> > > that case you should be running tiny RCU, not tree RCU.
> > 
> > So indeed I messed up my configs somehow and run the code on uniprocessor 
> > with SMP=y and tree RCU. With more processors RCU stall is detected and 
> > correct state is dumped. On uniprocessor with SMP=n and tiny RCU 
> > softlockup is detected, but no RCU stall in the log (is this correct?). So 
> > I'm really sorry for the noise.
> > 
> > Anyway I still think that running SMP kernel with tree RCU on 
> > uniprocessor is possible option (albeit suboptimal and maybe improbable). 
> > Should I proceed with your patch below and bisection or am I mistaken 
> > completely and we can leave it because there is no problem?
> 
> Not a problem, there have been some interesting RCU CPU stall warnings
> recently, and your data did add some insight.
> 
> So the combination SMP=n PREEMPT=y can happen straightforwardly via
> kbuild.  The combination SMP=n PREEMPT=n can happen (somewhat less)
> straightforwardly by running an SMP=y PREEMPT=n kernel on a single-CPU
> system.  In both cases, what can happen is that RCU's grace-period
> kthreads are starved, which can result in those reports.
> 
> And these reports are confusing.  I am considering attempting to improve
> the diagnostics.  If I do, would you be willing to test the resulting
> patches?

Like this one, for example.  ;-)

							Thanx, Paul

------------------------------------------------------------------------

rcu: Improve diagnostics for spurious RCU CPU stall warnings

The current RCU CPU stall warning code will print "Stall ended before
state dump start" any time that the stall-warning code is triggered on
a CPU that has already reported a quiescent state for the current grace
period and if all quiescent states have been reported for the current
grace period.  However, a true stall can result in these symptoms, for
example, by preventing RCU's grace-period kthreads from ever running

This commit therefore checks for this condition, reporting the end of
the stall only if one of the grace-period counters has actually advanced.
Otherwise, it reports the last time that the grace-period kthread made
meaningful progress.  (In normal situations, the grace-period kthread
should make meaningful progress at least every jiffies_till_next_fqs
jiffies.)

Reported-by: Miroslav Benes <mbenes@suse.cz>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/Documentation/RCU/stallwarn.txt b/Documentation/RCU/stallwarn.txt
index 4f8e33952b88..8085bc133791 100644
--- a/Documentation/RCU/stallwarn.txt
+++ b/Documentation/RCU/stallwarn.txt
@@ -187,6 +187,11 @@ o	For !CONFIG_PREEMPT kernels, a CPU looping anywhere in the
 	behavior, you might need to replace some of the cond_resched()
 	calls with calls to cond_resched_rcu_qs().
 
+o	Anything that prevents RCU's grace-period kthreads from running.
+	This can result in the "All QSes seen" console-log message.
+	This message will include information on when the kthread last
+	ran and how often it should be expected to run.
+
 o	A CPU-bound real-time task in a CONFIG_PREEMPT kernel, which might
 	happen to preempt a low-priority task in the middle of an RCU
 	read-side critical section.   This is especially damaging if
diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 7497dfe6ff3f..6a43836b61b0 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -1096,7 +1096,7 @@ static void rcu_dump_cpu_stacks(struct rcu_state *rsp)
 	}
 }
 
-static void print_other_cpu_stall(struct rcu_state *rsp)
+static void print_other_cpu_stall(struct rcu_state *rsp, unsigned long gpnum)
 {
 	int cpu;
 	long delta;
@@ -1144,10 +1144,18 @@ static void print_other_cpu_stall(struct rcu_state *rsp)
 	pr_cont("(detected by %d, t=%ld jiffies, g=%ld, c=%ld, q=%lu)\n",
 	       smp_processor_id(), (long)(jiffies - rsp->gp_start),
 	       (long)rsp->gpnum, (long)rsp->completed, totqlen);
-	if (ndetected == 0)
-		pr_err("INFO: Stall ended before state dump start\n");
-	else
+	if (ndetected) {
 		rcu_dump_cpu_stacks(rsp);
+	} else {
+		if (ACCESS_ONCE(rsp->gpnum) != gpnum ||
+		    ACCESS_ONCE(rsp->completed) == gpnum)
+			pr_err("INFO: Stall ended before state dump start\n");
+		else
+			pr_err("All QSes seen, last %s kthread activity %ld/%ld, jiffies_till_next_fqs=%ld\n",
+			       rsp->name,
+			       ACCESS_ONCE(rsp->gp_activity), jiffies,
+			       jiffies_till_next_fqs);
+	}
 
 	/* Complain about tasks blocking the grace period. */
 
@@ -1247,7 +1255,7 @@ static void check_cpu_stall(struct rcu_state *rsp, struct rcu_data *rdp)
 		   ULONG_CMP_GE(j, js + RCU_STALL_RAT_DELAY)) {
 
 		/* They had a few time units to dump stack, so complain. */
-		print_other_cpu_stall(rsp);
+		print_other_cpu_stall(rsp, gpnum);
 	}
 }
 
@@ -1643,6 +1651,7 @@ static int rcu_gp_init(struct rcu_state *rsp)
 	struct rcu_data *rdp;
 	struct rcu_node *rnp = rcu_get_root(rsp);
 
+	ACCESS_ONCE(rsp->gp_activity) = jiffies;
 	rcu_bind_gp_kthread();
 	raw_spin_lock_irq(&rnp->lock);
 	smp_mb__after_unlock_lock();
@@ -1703,6 +1712,7 @@ static int rcu_gp_init(struct rcu_state *rsp)
 					    rnp->grphi, rnp->qsmask);
 		raw_spin_unlock_irq(&rnp->lock);
 		cond_resched_rcu_qs();
+		ACCESS_ONCE(rsp->gp_activity) = jiffies;
 	}
 
 	mutex_unlock(&rsp->onoff_mutex);
@@ -1719,6 +1729,7 @@ static int rcu_gp_fqs(struct rcu_state *rsp, int fqs_state_in)
 	unsigned long maxj;
 	struct rcu_node *rnp = rcu_get_root(rsp);
 
+	ACCESS_ONCE(rsp->gp_activity) = jiffies;
 	rsp->n_force_qs++;
 	if (fqs_state == RCU_SAVE_DYNTICK) {
 		/* Collect dyntick-idle snapshots. */
@@ -1757,6 +1768,7 @@ static void rcu_gp_cleanup(struct rcu_state *rsp)
 	struct rcu_data *rdp;
 	struct rcu_node *rnp = rcu_get_root(rsp);
 
+	ACCESS_ONCE(rsp->gp_activity) = jiffies;
 	raw_spin_lock_irq(&rnp->lock);
 	smp_mb__after_unlock_lock();
 	gp_duration = jiffies - rsp->gp_start;
@@ -1793,6 +1805,7 @@ static void rcu_gp_cleanup(struct rcu_state *rsp)
 		nocb += rcu_future_gp_cleanup(rsp, rnp);
 		raw_spin_unlock_irq(&rnp->lock);
 		cond_resched_rcu_qs();
+		ACCESS_ONCE(rsp->gp_activity) = jiffies;
 	}
 	rnp = rcu_get_root(rsp);
 	raw_spin_lock_irq(&rnp->lock);
@@ -1842,6 +1855,7 @@ static int __noreturn rcu_gp_kthread(void *arg)
 			if (rcu_gp_init(rsp))
 				break;
 			cond_resched_rcu_qs();
+			ACCESS_ONCE(rsp->gp_activity) = jiffies;
 			WARN_ON(signal_pending(current));
 			trace_rcu_grace_period(rsp->name,
 					       ACCESS_ONCE(rsp->gpnum),
@@ -1885,9 +1899,11 @@ static int __noreturn rcu_gp_kthread(void *arg)
 						       ACCESS_ONCE(rsp->gpnum),
 						       TPS("fqsend"));
 				cond_resched_rcu_qs();
+				ACCESS_ONCE(rsp->gp_activity) = jiffies;
 			} else {
 				/* Deal with stray signal. */
 				cond_resched_rcu_qs();
+				ACCESS_ONCE(rsp->gp_activity) = jiffies;
 				WARN_ON(signal_pending(current));
 				trace_rcu_grace_period(rsp->name,
 						       ACCESS_ONCE(rsp->gpnum),
diff --git a/kernel/rcu/tree.h b/kernel/rcu/tree.h
index 44e9ccfe6570..856518c8dcfa 100644
--- a/kernel/rcu/tree.h
+++ b/kernel/rcu/tree.h
@@ -483,6 +483,8 @@ struct rcu_state {
 						/*  due to no GP active. */
 	unsigned long gp_start;			/* Time at which GP started, */
 						/*  but in jiffies. */
+	unsigned long gp_activity;		/* Time of last GP kthread */
+						/*  activity in jiffies. */
 	unsigned long jiffies_stall;		/* Time at which to check */
 						/*  for CPU stalls. */
 	unsigned long jiffies_resched;		/* Time at which to resched */

