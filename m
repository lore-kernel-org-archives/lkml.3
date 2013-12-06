Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757125Ab3LFA0Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 19:26:24 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:42958 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003Ab3LFA0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 19:26:19 -0500
Date: Thu, 5 Dec 2013 16:26:14 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Jochen Striepe <jochen@tolot.escape.de>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: 3.10.5: rcu_sched detected stalls on CPUs/tasks
Message-ID: <20131206002614.GD15492@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130813103202.GB2338@pompeji.miese-zwerge.org>
 <20130818180232.GL29406@linux.vnet.ibm.com>
 <20130818184848.GA2398@pompeji.miese-zwerge.org>
 <20130909215836.GD17483@pompeji.miese-zwerge.org>
 <20130909222751.GL3966@linux.vnet.ibm.com>
 <20130914112834.GM1509@pompeji.miese-zwerge.org>
 <20130923164931.GC2322@pompeji.miese-zwerge.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130923164931.GC2322@pompeji.miese-zwerge.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13120600-1542-0000-0000-000003F33E54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 23, 2013 at 06:49:31PM +0200, Jochen Striepe wrote:
> 	Hello again,
> 
> On Sat, Sep 14, 2013 at 01:28:34PM +0200, Jochen Striepe wrote:
> > On Mon, Sep 09, 2013 at 03:27:51PM -0700, Paul E. McKenney wrote:
> > > rcu: Reject memory-order-induced stall-warning false positives
> > 
> > I run this patch on top of 3.10.11 vanilla since Wednesday, so far
> > without any further stalls, on light to heavy loads. Works smooth
> > as pie.
> 
> Hmm, perhaps it is not as easy as I thought. On exactly this machine
> with exactly this kernel (3.10.11 vanilla with your patch from this
> thread), some minutes ago another one came up. The system should have
> been mostly idle at that moment. Dmesg appended ... do you need
> anything else to have an educated guess? I waited 10 minutes after
> the stall message (following your earlier advise), but no further
> dmesg lines appeared after that.

Hmmm...  Does the following patch help?

							Thanx, Paul

------------------------------------------------------------------------

rcu: Kick CPU halfway to RCU CPU stall warning

When an RCU CPU stall warning occurs, the CPU invokes resched_cpu() on
itself.  This can help move the grace period forward in some situations,
but it would be even better to do this -before- the RCU CPU stall warning.
This commit therefore causes resched_cpu() to be called every five jiffies
once the system is halfway to an RCU CPU stall warning.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index dd081987a8ec..5243ebea0fc1 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -755,6 +755,12 @@ static int dyntick_save_progress_counter(struct rcu_data *rdp,
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
@@ -812,16 +818,34 @@ static int rcu_implicit_dynticks_qs(struct rcu_data *rdp,
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
diff --git a/kernel/rcu/tree.h b/kernel/rcu/tree.h
index 52be957c9fe2..8e34d8674a4e 100644
--- a/kernel/rcu/tree.h
+++ b/kernel/rcu/tree.h
@@ -453,6 +453,8 @@ struct rcu_state {
 						/*  but in jiffies. */
 	unsigned long jiffies_stall;		/* Time at which to check */
 						/*  for CPU stalls. */
+	unsigned long jiffies_resched;		/* Time at which to resched */
+						/*  a reluctant CPU. */
 	unsigned long gp_max;			/* Maximum GP duration in */
 						/*  jiffies. */
 	const char *name;			/* Name of structure. */

