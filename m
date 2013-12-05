Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756247Ab3LEAQU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 19:16:20 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:59871 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753843Ab3LEAQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 19:16:19 -0500
Date: Wed, 4 Dec 2013 16:16:14 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: lots of brief rcu stalls.
Message-ID: <20131205001614.GI15492@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20131204232838.GA25592@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131204232838.GA25592@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13120500-9332-0000-0000-000002624B4D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 04, 2013 at 06:28:38PM -0500, Dave Jones wrote:
> Paul,
> I'm seeing this happening more and more lately...
> 
> [  771.786462] INFO: rcu_preempt detected stalls on CPUs/tasks:
> [  771.786552] 	Tasks blocked on level-0 rcu_node (CPUs 0-3):
> [  771.786574] 	Tasks blocked on level-0 rcu_node (CPUs 0-3):
> [  771.786595] 	(detected by 0, t=6502 jiffies, g=20611, c=20610, q=0)
> [  771.786620] INFO: Stall ended before state dump start
> [  966.724546] INFO: rcu_preempt detected stalls on CPUs/tasks:
> [  966.724854] 	Tasks blocked on level-0 rcu_node (CPUs 0-3):
> [  966.724931] 	Tasks blocked on level-0 rcu_node (CPUs 0-3):
> [  966.725005] 	(detected by 0, t=26007 jiffies, g=20611, c=20610, q=0)
> [  966.725093] INFO: Stall ended before state dump start
> [ 1161.661459] INFO: rcu_preempt detected stalls on CPUs/tasks:
> [ 1161.661763] 	Tasks blocked on level-0 rcu_node (CPUs 0-3):
> [ 1161.661840] 	Tasks blocked on level-0 rcu_node (CPUs 0-3):
> [ 1161.661915] 	(detected by 0, t=45512 jiffies, g=20611, c=20610, q=0)
> [ 1161.662001] INFO: Stall ended before state dump start
> [ 1356.598205] INFO: rcu_preempt detected stalls on CPUs/tasks:
> [ 1356.598513] 	Tasks blocked on level-0 rcu_node (CPUs 0-3):
> [ 1356.598590] 	Tasks blocked on level-0 rcu_node (CPUs 0-3):
> [ 1356.598664] 	(detected by 0, t=65017 jiffies, g=20611, c=20610, q=0)
> [ 1356.598751] INFO: Stall ended before state dump start
> [ 1551.536099] INFO: rcu_preempt detected stalls on CPUs/tasks:
> [ 1551.536408] 	Tasks blocked on level-0 rcu_node (CPUs 0-3):
> [ 1551.536485] 	Tasks blocked on level-0 rcu_node (CPUs 0-3):
> [ 1551.536559] 	(detected by 0, t=84522 jiffies, g=20611, c=20610, q=0)
> [ 1551.536645] INFO: Stall ended before state dump start
> 
> While it's apparently a non-problem, it's pretty noisy.
> Any ideas?

Does the following help?

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

