Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752143Ab3LPWkN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 17:40:13 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:51441 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962Ab3LPWkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 17:40:11 -0500
Date: Mon, 16 Dec 2013 14:40:06 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Jochen Striepe <jochen@tolot.escape.de>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: 3.10.5: rcu_sched detected stalls on CPUs/tasks
Message-ID: <20131216224006.GA5919@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130818180232.GL29406@linux.vnet.ibm.com>
 <20130818184848.GA2398@pompeji.miese-zwerge.org>
 <20130909215836.GD17483@pompeji.miese-zwerge.org>
 <20130909222751.GL3966@linux.vnet.ibm.com>
 <20130914112834.GM1509@pompeji.miese-zwerge.org>
 <20130923164931.GC2322@pompeji.miese-zwerge.org>
 <20131206002614.GD15492@linux.vnet.ibm.com>
 <20131206135804.GI2208@pompeji.miese-zwerge.org>
 <20131206145441.GA24148@linux.vnet.ibm.com>
 <20131210112257.GJ2208@pompeji.miese-zwerge.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="vtzGhvizbBRQ85DL"
Content-Disposition: inline
In-Reply-To: <20131210112257.GJ2208@pompeji.miese-zwerge.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13121622-1542-0000-0000-000004514D3B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vtzGhvizbBRQ85DL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 10, 2013 at 12:22:57PM +0100, Jochen Striepe wrote:
> 	Hi again,
> 
> On Fri, Dec 06, 2013 at 06:54:41AM -0800, Paul E. McKenney wrote:
> > On Fri, Dec 06, 2013 at 02:58:04PM +0100, Jochen Striepe wrote:
> > > On Thu, Dec 05, 2013 at 04:26:14PM -0800, Paul E. McKenney wrote:
> > > > Hmmm...  Does the following patch help?
> > > [...]
> > > > rcu: Kick CPU halfway to RCU CPU stall warning
> > > 
> > > The stall didn't appear at all since my last email, running 3.12.x
> > > kernels since release. But I will test your patch later today. I assume
> > > applying on top of 3.12.3 is correct?
> > 
> > 3.12.3 should take that patch just fine.
> 
> Sorry for the delay. On my copy of 3.12.3, the patch does not apply.
> kernel/rcu/ does not exist, and the patch did not apply cleanly on
> kernel/rcutree.c: record_gp_stall_check_time() is a little different
> from what your patch expects, and I'm not that much into rcu work as
> to understand the implications. :)
> 
> If you want me to go back to 3.12.0 I can do so, but as the issue
> does not reproduce very well I doubt that would help very much.
> Ideas? Is there a version of the patch for -stable, or does the
> patch conflict with the work done there?

And you are quite right, there is a prerequisite commit.  I have attached
both, please apply in numeric order.

The subdirectory causes problems for patches, but git cherry-pick actually
deals with this sort of thing.

Because patch.2 has not yet made it to mainline, it is not yet eligible
for -stable.  I expect it to hit mainline in the 3.14 merge window,
which will likely be coming up in a few weeks.

							Thanx, Paul

--vtzGhvizbBRQ85DL
Content-Type: text/plain; charset=us-ascii
Content-Description: stall.1
Content-Disposition: attachment; filename="stall.1"

commit 23d8cc5442afcd86cd0fcd116512e85c6cb6ecc8
Author: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Date:   Wed Sep 4 10:51:13 2013 -0700

    rcu: Reject memory-order-induced stall-warning false positives
    
    If a system is idle from an RCU perspective for longer than specified
    by CONFIG_RCU_CPU_STALL_TIMEOUT, and if one CPU starts a grace period
    just as a second checks for CPU stalls, and if this second CPU happens
    to see the old value of rsp->jiffies_stall, it will incorrectly report a
    CPU stall.  This is quite rare, but apparently occurs deterministically
    on systems with about 6TB of memory.
    
    This commit therefore orders accesses to the data used to determine
    whether or not a CPU stall is in progress.  Grace-period initialization
    and cleanup first increments rsp->completed to mark the end of the
    previous grace period, then records the current jiffies in rsp->gp_start,
    then records the jiffies at which a stall can be expected to occur in
    rsp->jiffies_stall, and finally increments rsp->gpnum to mark the start
    of the new grace period.  Now, this ordering by itself does not prevent
    false positives.  For example, if grace-period initialization was delayed
    between recording rsp->gp_start and rsp->jiffies_stall, the CPU stall
    warning code might still see an old value of rsp->jiffies_stall.
    
    Therefore, this commit also orders the CPU stall warning accesses as
    well, loading rsp->gpnum and jiffies, then rsp->jiffies_stall, then
    rsp->gp_start, and finally rsp->completed.  This ordering means that
    the false-positive scenario in the previous paragraph would result
    in rsp->completed being greater than or equal to rsp->gpnum, which is
    never valid for a CPU stall, allowing the false positive to be rejected.
    Furthermore, any fetch that gets an old value of rsp->jiffies_stall
    must also get an old value of rsp->gpnum, which will again be rejected
    by the comparison of rsp->gpnum and rsp->completed.  Situations where
    rsp->gp_start is later than rsp->jiffies_stall are also rejected, as
    are situations where jiffies is less than rsp->jiffies_stall.
    
    Although use of unsynchronized accesses means that there are likely
    still some false-positive scenarios (synchronization has proven to be
    a very bad idea on large systems), this should get rid of a large class
    of these scenarios.
    
    Reported-by: Fabian Herschel <fabian.herschel@suse.com>
    Reported-by: Michal Hocko <mhocko@suse.com>
    Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
    Reviewed-by: Michal Hocko <mhocko@suse.cz>
    Tested-by: Jochen Striepe <jochen@tolot.escape.de>

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 32618b3fe4e6..44c50950a47f 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -802,8 +802,11 @@ static int rcu_implicit_dynticks_qs(struct rcu_data *rdp,
 
 static void record_gp_stall_check_time(struct rcu_state *rsp)
 {
-	rsp->gp_start = jiffies;
-	rsp->jiffies_stall = jiffies + rcu_jiffies_till_stall_check();
+	unsigned long j = ACCESS_ONCE(jiffies);
+
+	rsp->gp_start = j;
+	smp_wmb(); /* Record start time before stall time. */
+	rsp->jiffies_stall = j + rcu_jiffies_till_stall_check();
 }
 
 /*
@@ -932,17 +935,48 @@ static void print_cpu_stall(struct rcu_state *rsp)
 
 static void check_cpu_stall(struct rcu_state *rsp, struct rcu_data *rdp)
 {
+	unsigned long completed;
+	unsigned long gpnum;
+	unsigned long gps;
 	unsigned long j;
 	unsigned long js;
 	struct rcu_node *rnp;
 
-	if (rcu_cpu_stall_suppress)
+	if (rcu_cpu_stall_suppress || !rcu_gp_in_progress(rsp))
 		return;
 	j = ACCESS_ONCE(jiffies);
+
+	/*
+	 * Lots of memory barriers to reject false positives.
+	 *
+	 * The idea is to pick up rsp->gpnum, then rsp->jiffies_stall,
+	 * then rsp->gp_start, and finally rsp->completed.  These values
+	 * are updated in the opposite order with memory barriers (or
+	 * equivalent) during grace-period initialization and cleanup.
+	 * Now, a false positive can occur if we get an new value of
+	 * rsp->gp_start and a old value of rsp->jiffies_stall.  But given
+	 * the memory barriers, the only way that this can happen is if one
+	 * grace period ends and another starts between these two fetches.
+	 * Detect this by comparing rsp->completed with the previous fetch
+	 * from rsp->gpnum.
+	 *
+	 * Given this check, comparisons of jiffies, rsp->jiffies_stall,
+	 * and rsp->gp_start suffice to forestall false positives.
+	 */
+	gpnum = ACCESS_ONCE(rsp->gpnum);
+	smp_rmb(); /* Pick up ->gpnum first... */
 	js = ACCESS_ONCE(rsp->jiffies_stall);
+	smp_rmb(); /* ...then ->jiffies_stall before the rest... */
+	gps = ACCESS_ONCE(rsp->gp_start);
+	smp_rmb(); /* ...and finally ->gp_start before ->completed. */
+	completed = ACCESS_ONCE(rsp->completed);
+	if (ULONG_CMP_GE(completed, gpnum) ||
+	    ULONG_CMP_LT(j, js) ||
+	    ULONG_CMP_GE(gps, js))
+		return; /* No stall or GP completed since entering function. */
 	rnp = rdp->mynode;
 	if (rcu_gp_in_progress(rsp) &&
-	    (ACCESS_ONCE(rnp->qsmask) & rdp->grpmask) && ULONG_CMP_GE(j, js)) {
+	    (ACCESS_ONCE(rnp->qsmask) & rdp->grpmask)) {
 
 		/* We haven't checked in, so go dump stack. */
 		print_cpu_stall(rsp);
@@ -1315,9 +1349,10 @@ static int rcu_gp_init(struct rcu_state *rsp)
 	}
 
 	/* Advance to a new grace period and initialize state. */
+	record_gp_stall_check_time(rsp);
+	smp_wmb(); /* Record GP times before starting GP. */
 	rsp->gpnum++;
 	trace_rcu_grace_period(rsp->name, rsp->gpnum, TPS("start"));
-	record_gp_stall_check_time(rsp);
 	raw_spin_unlock_irq(&rnp->lock);
 
 	/* Exclude any concurrent CPU-hotplug operations. */

--vtzGhvizbBRQ85DL
Content-Type: text/plain; charset=us-ascii
Content-Description: stall.2
Content-Disposition: attachment; filename="stall.2"

commit 3e640672638442e5df4d2d89687562bec37a8ef3
Author: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Date:   Mon Sep 23 13:57:18 2013 -0700

    rcu: Kick CPU halfway to RCU CPU stall warning
    
    When an RCU CPU stall warning occurs, the CPU invokes resched_cpu() on
    itself.  This can help move the grace period forward in some situations,
    but it would be even better to do this -before- the RCU CPU stall warning.
    This commit therefore causes resched_cpu() to be called every five jiffies
    once the system is halfway to an RCU CPU stall warning.
    
    Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 44c50950a47f..e6fd0f2ca2c6 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -740,6 +740,12 @@ static int dyntick_save_progress_counter(struct rcu_data *rdp,
 }
 
 /*
+ * This function really isn't for public consumption, but RCU is special in
+ * that context switches can allow the state machine to make progress.
+ */
+extern void resched_cpu(int cpu);
+
+/*
  * Return true if the specified CPU has passed through a quiescent
  * state by virtue of being in or having passed through an dynticks
  * idle state since the last call to dyntick_save_progress_counter()
@@ -797,16 +803,34 @@ static int rcu_implicit_dynticks_qs(struct rcu_data *rdp,
 	 */
 	rcu_kick_nohz_cpu(rdp->cpu);
 
+	/*
+	 * Alternatively, the CPU might be running in the kernel
+	 * for an extended period of time without a quiescent state.
+	 * Attempt to force the CPU through the scheduler to gain the
+	 * needed quiescent state, but only if the grace period has gone
+	 * on for an uncommonly long time.  If there are many stuck CPUs,
+	 * we will beat on the first one until it gets unstuck, then move
+	 * to the next.  Only do this for the primary flavor of RCU.
+	 */
+	if (rdp->rsp == rcu_state &&
+	    ULONG_CMP_GE(ACCESS_ONCE(jiffies), rdp->rsp->jiffies_resched)) {
+		rdp->rsp->jiffies_resched += 5;
+		resched_cpu(rdp->cpu);
+	}
+
 	return 0;
 }
 
 static void record_gp_stall_check_time(struct rcu_state *rsp)
 {
 	unsigned long j = ACCESS_ONCE(jiffies);
+	unsigned long j1;
 
 	rsp->gp_start = j;
 	smp_wmb(); /* Record start time before stall time. */
-	rsp->jiffies_stall = j + rcu_jiffies_till_stall_check();
+	j1 = rcu_jiffies_till_stall_check();
+	rsp->jiffies_stall = j + j1;
+	rsp->jiffies_resched = j + j1 / 2;
 }
 
 /*
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index 5f97eab602cd..9515222fdf88 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -451,6 +451,8 @@ struct rcu_state {
 						/*  but in jiffies. */
 	unsigned long jiffies_stall;		/* Time at which to check */
 						/*  for CPU stalls. */
+	unsigned long jiffies_resched;		/* Time at which to resched */
+						/*  a reluctant CPU. */
 	unsigned long gp_max;			/* Maximum GP duration in */
 						/*  jiffies. */
 	const char *name;			/* Name of structure. */

--vtzGhvizbBRQ85DL--

