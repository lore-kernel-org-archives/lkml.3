Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936041AbaH0VrN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 17:47:13 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:38118 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932246AbaH0VrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 17:47:11 -0400
Date: Wed, 27 Aug 2014 14:47:06 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        "open list:READ-COPY UPDATE..." <linux-kernel@vger.kernel.org>,
        amit.shah@redhat.com
Subject: Re: [PATCH] rcu: Make nocb leader kthreads process pending callbacks
 after spawning
Message-ID: <20140827214706.GO2663@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1409172220-2804-1-git-send-email-bobby.prani@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409172220-2804-1-git-send-email-bobby.prani@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14082721-7164-0000-0000-00000424D9A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2014 at 04:43:40PM -0400, Pranith Kumar wrote:
> The nocb callbacks generated before the nocb kthreads are spawned are
> enqueued in the nocb queue for later processing. Commit fbce7497ee5af ("rcu:
> Parallelize and economize NOCB kthread wakeups") introduced nocb leader kthreads
> which checked the nocb_leader_wake flag to see if there were any such pending
> callbacks. A case was reported in which newly spawned leader kthreads were not
> processing the pending callbacks as this flag was not set, which led to a boot
> hang.
> 
> The following commit ensures that the newly spawned nocb kthreads process the
> pending callbacks by allowing the kthreads to run immediately after spawning
> instead of waiting. This is done by inverting the logic of nocb_leader_wake
> tests to nocb_leader_sleep which allows us to use the default initialization of
> this flag to 0 to let the kthreads run.
> 
> Reported-by: Amit Shah <amit.shah@redhat.com>
> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
> Link: http://www.spinics.net/lists/kernel/msg1802899.html

Thank you, Pranith, queued.  I have also backported to v3.17-rc2,
and am testing both.  A sneak preview of the backport is shown below,
please let me know if you see any problems with it.  (The reason for
the backport is to submit to 3.17 as a fix for a regression.)

							Thanx, Paul

------------------------------------------------------------------------

rcu: Make nocb leader kthreads process pending callbacks after spawning

The nocb callbacks generated before the nocb kthreads are spawned are
enqueued in the nocb queue for later processing. Commit fbce7497ee5af ("rcu:
Parallelize and economize NOCB kthread wakeups") introduced nocb leader kthreads
which checked the nocb_leader_wake flag to see if there were any such pending
callbacks. A case was reported in which newly spawned leader kthreads were not
processing the pending callbacks as this flag was not set, which led to a boot
hang.

The following commit ensures that the newly spawned nocb kthreads process the
pending callbacks by allowing the kthreads to run immediately after spawning
instead of waiting. This is done by inverting the logic of nocb_leader_wake
tests to nocb_leader_sleep which allows us to use the default initialization of
this flag to 0 to let the kthreads run.

Reported-by: Amit Shah <amit.shah@redhat.com>
Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
Link: http://www.spinics.net/lists/kernel/msg1802899.html
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/kernel/rcu/tree.h b/kernel/rcu/tree.h
index 71e64c718f75..6a86eb7bac45 100644
--- a/kernel/rcu/tree.h
+++ b/kernel/rcu/tree.h
@@ -358,7 +358,7 @@ struct rcu_data {
 	struct rcu_head **nocb_gp_tail;
 	long nocb_gp_count;
 	long nocb_gp_count_lazy;
-	bool nocb_leader_wake;		/* Is the nocb leader thread awake? */
+	bool nocb_leader_sleep;		/* Is the nocb leader thread asleep? */
 	struct rcu_data *nocb_next_follower;
 					/* Next follower in wakeup chain. */
 
diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 00dc411e9676..a7997e272564 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -2074,9 +2074,9 @@ static void wake_nocb_leader(struct rcu_data *rdp, bool force)
 
 	if (!ACCESS_ONCE(rdp_leader->nocb_kthread))
 		return;
-	if (!ACCESS_ONCE(rdp_leader->nocb_leader_wake) || force) {
+	if (ACCESS_ONCE(rdp_leader->nocb_leader_sleep) || force) {
 		/* Prior xchg orders against prior callback enqueue. */
-		ACCESS_ONCE(rdp_leader->nocb_leader_wake) = true;
+		ACCESS_ONCE(rdp_leader->nocb_leader_sleep) = false;
 		wake_up(&rdp_leader->nocb_wq);
 	}
 }
@@ -2253,7 +2253,7 @@ wait_again:
 	if (!rcu_nocb_poll) {
 		trace_rcu_nocb_wake(my_rdp->rsp->name, my_rdp->cpu, "Sleep");
 		wait_event_interruptible(my_rdp->nocb_wq,
-					 ACCESS_ONCE(my_rdp->nocb_leader_wake));
+				!ACCESS_ONCE(my_rdp->nocb_leader_sleep));
 		/* Memory barrier handled by smp_mb() calls below and repoll. */
 	} else if (firsttime) {
 		firsttime = false; /* Don't drown trace log with "Poll"! */
@@ -2292,12 +2292,12 @@ wait_again:
 		schedule_timeout_interruptible(1);
 
 		/* Rescan in case we were a victim of memory ordering. */
-		my_rdp->nocb_leader_wake = false;
-		smp_mb();  /* Ensure _wake false before scan. */
+		my_rdp->nocb_leader_sleep = true;
+		smp_mb();  /* Ensure _sleep true before scan. */
 		for (rdp = my_rdp; rdp; rdp = rdp->nocb_next_follower)
 			if (ACCESS_ONCE(rdp->nocb_head)) {
 				/* Found CB, so short-circuit next wait. */
-				my_rdp->nocb_leader_wake = true;
+				my_rdp->nocb_leader_sleep = false;
 				break;
 			}
 		goto wait_again;
@@ -2307,17 +2307,17 @@ wait_again:
 	rcu_nocb_wait_gp(my_rdp);
 
 	/*
-	 * We left ->nocb_leader_wake set to reduce cache thrashing.
-	 * We clear it now, but recheck for new callbacks while
+	 * We left ->nocb_leader_sleep unset to reduce cache thrashing.
+	 * We set it now, but recheck for new callbacks while
 	 * traversing our follower list.
 	 */
-	my_rdp->nocb_leader_wake = false;
-	smp_mb(); /* Ensure _wake false before scan of ->nocb_head. */
+	my_rdp->nocb_leader_sleep = true;
+	smp_mb(); /* Ensure _sleep true before scan of ->nocb_head. */
 
 	/* Each pass through the following loop wakes a follower, if needed. */
 	for (rdp = my_rdp; rdp; rdp = rdp->nocb_next_follower) {
 		if (ACCESS_ONCE(rdp->nocb_head))
-			my_rdp->nocb_leader_wake = true; /* No need to wait. */
+			my_rdp->nocb_leader_sleep = false;/* No need to sleep.*/
 		if (!rdp->nocb_gp_head)
 			continue; /* No CBs, so no need to wake follower. */
 

