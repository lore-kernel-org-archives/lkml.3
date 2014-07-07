Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565AbaGGWk3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 18:40:29 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:45126 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976AbaGGWia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 18:38:30 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu, Pranith Kumar <bobby.prani@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 09/17] rcu: Check both root and current rcu_node when setting up future grace period
Date: Mon,  7 Jul 2014 15:38:13 -0700
Message-Id: <1404772701-8804-9-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1404772701-8804-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140707223756.GA7187@linux.vnet.ibm.com>
 <1404772701-8804-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14070722-7164-0000-0000-000002F47FC6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pranith Kumar <bobby.prani@gmail.com>

The rcu_start_future_gp() function checks the current rcu_node's ->gpnum
and ->completed twice, once without ACCESS_ONCE() and once with it.
Which is pointless because we hold that rcu_node's ->lock at that point.
The intent was to check the current rcu_node structure and the root
rcu_node structure, the latter locklessly with ACCESS_ONCE().  This
commit therefore makes that change.

The reason that it is safe to locklessly check the root rcu_nodes's
->gpnum and ->completed fields is that we hold the current rcu_node's
->lock, which constrains the root rcu_node's ability to change its
->gpnum and ->completed fields.  Of course, if there is a single rcu_node
structure, then rnp_root==rnp, and holding the lock prevents all changes.
If there is more than one rcu_node structure, then the code updates the
fields in the following order:

1.	Increment rnp_root->gpnum to start new grace period.
2.	Increment rnp->gpnum to initialize the current rcu_node,
	continuing initialization for the new grace period.
3.	Increment rnp_root->completed to end the current grace period.
4.	Increment rnp->completed to continue cleaning up after the
	old grace period.

So there are four possible combinations of relative values of these
four fields:

N   N   N   N:  RCU idle, new grace period must be initiated.
		Although rnp_root->gpnum might be incremented immediately
		after we check, that will just result in unnecessary work.
		The grace period already started, and we try to start it.

N+1 N   N   N:  RCU grace period just started.  No further change is
		possible because we hold rnp->lock, so the checks of
		rnp_root->gpnum and rnp_root->completed are stable.
		We know that our request for a future grace period will
		be seen during grace-period cleanup.

N+1 N   N+1 N:  RCU grace period is ongoing.  Because rnp->gpnum is
		different than rnp->completed, we won't even look at
		rnp_root->gpnum and rnp_root->completed, so the possible
		concurrent change to rnp_root->completed does not matter.
		We know that our request for a future grace period will
		be seen during grace-period cleanup, which cannot pass
		this rcu_node because we hold its ->lock.

N+1 N+1 N+1 N:  RCU grace period has ended, but not yet been cleaned up.
		Because rnp->gpnum is different than rnp->completed, we
		won't look at rnp_root->gpnum and rnp_root->completed, so
		the possible concurrent change to rnp_root->completed does
		not matter.  We know that our request for a future grace
		period will be seen during grace-period cleanup, which
		cannot pass this rcu_node because we hold its ->lock.

Therefore, despite initial appearances, the lockless check is safe.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
[ paulmck: Update comment to say why the lockless check is safe. ]
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcu/tree.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index bcd635e42841..3f93033d3c61 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -1305,10 +1305,16 @@ rcu_start_future_gp(struct rcu_node *rnp, struct rcu_data *rdp,
 	 * believe that a grace period is in progress, then we must wait
 	 * for the one following, which is in "c".  Because our request
 	 * will be noticed at the end of the current grace period, we don't
-	 * need to explicitly start one.
+	 * need to explicitly start one.  We only do the lockless check
+	 * of rnp_root's fields if the current rcu_node structure thinks
+	 * there is no grace period in flight, and because we hold rnp->lock,
+	 * the only possible change is when rnp_root's two fields are
+	 * equal, in which case rnp_root->gpnum might be concurrently
+	 * incremented.  But that is OK, as it will just result in our
+	 * doing some extra useless work.
 	 */
 	if (rnp->gpnum != rnp->completed ||
-	    ACCESS_ONCE(rnp->gpnum) != ACCESS_ONCE(rnp->completed)) {
+	    ACCESS_ONCE(rnp_root->gpnum) != ACCESS_ONCE(rnp_root->completed)) {
 		rnp->need_future_gp[c & 0x1]++;
 		trace_rcu_future_gp(rnp, rdp, c, TPS("Startedleaf"));
 		goto out;
-- 
1.8.1.5

