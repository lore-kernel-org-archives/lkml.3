Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755995Ab3IIW14 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 18:27:56 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:38522 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755469Ab3IIW1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 18:27:54 -0400
Date: Mon, 9 Sep 2013 15:27:51 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Jochen Striepe <jochen@tolot.escape.de>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: 3.10.5: rcu_sched detected stalls on CPUs/tasks
Message-ID: <20130909222751.GL3966@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130813103202.GB2338@pompeji.miese-zwerge.org>
 <20130818180232.GL29406@linux.vnet.ibm.com>
 <20130818184848.GA2398@pompeji.miese-zwerge.org>
 <20130909215836.GD17483@pompeji.miese-zwerge.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130909215836.GD17483@pompeji.miese-zwerge.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13090922-9332-0000-0000-0000015C2032
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 09, 2013 at 11:58:36PM +0200, Jochen Striepe wrote:
> 	Hi again,
> 
> On Sun, Aug 18, 2013 at 08:48:49PM +0200, Jochen Striepe wrote:
> > Unfortunately, I was not able to reproduce that behaviour since.
> 
> I just got this on 3.10.11 on the same machine. Could that be
> related?
> 
> Just curious,
> Jochen.

Several people helped track down another source of spurious stall
warnings on large systems, please see below for the patch.

							Thanx, Paul

------------------------------------------------------------------------

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

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 5f0bddf..a06d172 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -797,8 +797,11 @@ static int rcu_implicit_dynticks_qs(struct rcu_data *rdp,
 
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
@@ -927,17 +930,48 @@ static void print_cpu_stall(struct rcu_state *rsp)
 
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
@@ -1318,9 +1352,10 @@ static int rcu_gp_init(struct rcu_state *rsp)
 	}
 
 	/* Advance to a new grace period and initialize state. */
+	record_gp_stall_check_time(rsp);
+	smp_wmb(); /* Record GP times before starting GP. */
 	rsp->gpnum++;
 	trace_rcu_grace_period(rsp->name, rsp->gpnum, TPS("start"));
-	record_gp_stall_check_time(rsp);
 	raw_spin_unlock_irq(&rnp->lock);
 
 	/* Exclude any concurrent CPU-hotplug operations. */

