Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752714AbaIGRnR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2014 13:43:17 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:57199 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752583AbaIGRnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2014 13:43:15 -0400
Date: Sun, 7 Sep 2014 19:43:10 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "Paul E. McKenney" <paulmck@us.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] RCU fix
Message-ID: <20140907174310.GA29811@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git core-urgent-for-linus

   # HEAD: 651bc1a474ad5f3a94587117cf509d7fa9247f69 Merge branch 'rcu/urgent' of git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu into core/urgent

A boot hang fix for the offloaded callback RCU model 
(RCU_NOCB_CPU=y && (TREE_CPU=y || TREE_PREEMPT_RC))
in certain bootup scenarios.

 Thanks,

	Ingo

------------------>
Pranith Kumar (1):
      rcu: Make nocb leader kthreads process pending callbacks after spawning


 kernel/rcu/tree.h        |  2 +-
 kernel/rcu/tree_plugin.h | 22 +++++++++++-----------
 2 files changed, 12 insertions(+), 12 deletions(-)

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
@@ -2253,7 +2253,7 @@ static void nocb_leader_wait(struct rcu_data *my_rdp)
 	if (!rcu_nocb_poll) {
 		trace_rcu_nocb_wake(my_rdp->rsp->name, my_rdp->cpu, "Sleep");
 		wait_event_interruptible(my_rdp->nocb_wq,
-					 ACCESS_ONCE(my_rdp->nocb_leader_wake));
+				!ACCESS_ONCE(my_rdp->nocb_leader_sleep));
 		/* Memory barrier handled by smp_mb() calls below and repoll. */
 	} else if (firsttime) {
 		firsttime = false; /* Don't drown trace log with "Poll"! */
@@ -2292,12 +2292,12 @@ static void nocb_leader_wait(struct rcu_data *my_rdp)
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
@@ -2307,17 +2307,17 @@ static void nocb_leader_wait(struct rcu_data *my_rdp)
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
 
