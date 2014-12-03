Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446AbaLCLmW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 06:42:22 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54705 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752521AbaLCL1g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 06:27:36 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Pranith Kumar <bobby.prani@gmail.com>,
        Kamal Mostafa <kamal@canonical.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 066/101] rcu: Make callers awaken grace-period kthread
Date: Wed,  3 Dec 2014 12:26:28 +0100
Message-Id: <9b3128c465d0ad59ca8739b8028bcad4042eb170.1417605922.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
References: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
In-Reply-To: <cover.1417605922.git.jslaby@suse.cz>
References: <cover.1417605922.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 48a7639ce80cf279834d0d44865e49ecd714f37d upstream.

The rcu_start_gp_advanced() function currently uses irq_work_queue()
to defer wakeups of the RCU grace-period kthread.  This deferring
is necessary to avoid RCU-scheduler deadlocks involving the rcu_node
structure's lock, meaning that RCU cannot call any of the scheduler's
wake-up functions while holding one of these locks.

Unfortunately, the second and subsequent calls to irq_work_queue() are
ignored, and the first call will be ignored (aside from queuing the work
item) if the scheduler-clock tick is turned off.  This is OK for many
uses, especially those where irq_work_queue() is called from an interrupt
or softirq handler, because in those cases the scheduler-clock-tick state
will be re-evaluated, which will turn the scheduler-clock tick back on.
On the next tick, any deferred work will then be processed.

However, this strategy does not always work for RCU, which can be invoked
at process level from idle CPUs.  In this case, the tick might never
be turned back on, indefinitely defering a grace-period start request.
Note that the RCU CPU stall detector cannot see this condition, because
there is no RCU grace period in progress.  Therefore, we can (and do!)
see long tens-of-seconds stalls in grace-period handling.  In theory,
we could see a full grace-period hang, but rcutorture testing to date
has seen only the tens-of-seconds stalls.  Event tracing demonstrates
that irq_work_queue() is being called repeatedly to no effect during
these stalls: The "newreq" event appears repeatedly from a task that is
not one of the grace-period kthreads.

In theory, irq_work_queue() might be fixed to avoid this sort of issue,
but RCU's requirements are unusual and it is quite straightforward to pass
wake-up responsibility up through RCU's call chain, so that the wakeup
happens when the offending locks are released.

This commit therefore makes this change.  The rcu_start_gp_advanced(),
rcu_start_future_gp(), rcu_accelerate_cbs(), rcu_advance_cbs(),
__note_gp_changes(), and rcu_start_gp() functions now return a boolean
which indicates when a wake-up is needed.  A new rcu_gp_kthread_wake()
does the wakeup when it is necessary and safe to do so: No self-wakes,
no wake-ups if the ->gp_flags field indicates there is no need (as in
someone else did the wake-up before we got around to it), and no wake-ups
before the grace-period kthread has been created.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
[ Pranith: backport to 3.13-stable: just rcu_gp_kthread_wake(),
  prereq for 2aa792e "rcu: Use rcu_gp_kthread_wake() to wake up grace
  period kthreads" ]
Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 kernel/rcutree.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 32618b3fe4e6..ec5848e9d5d9 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1131,6 +1131,22 @@ static int rcu_future_gp_cleanup(struct rcu_state *rsp, struct rcu_node *rnp)
 }
 
 /*
+ * Awaken the grace-period kthread for the specified flavor of RCU.
+ * Don't do a self-awaken, and don't bother awakening when there is
+ * nothing for the grace-period kthread to do (as in several CPUs
+ * raced to awaken, and we lost), and finally don't try to awaken
+ * a kthread that has not yet been created.
+ */
+static void rcu_gp_kthread_wake(struct rcu_state *rsp)
+{
+	if (current == rsp->gp_kthread ||
+	    !ACCESS_ONCE(rsp->gp_flags) ||
+	    !rsp->gp_kthread)
+		return;
+	wake_up(&rsp->gp_wq);
+}
+
+/*
  * If there is room, assign a ->completed number to any callbacks on
  * this CPU that have not already been assigned.  Also accelerate any
  * callbacks that were previously assigned a ->completed number that has
@@ -1528,7 +1544,7 @@ static void rsp_wakeup(struct irq_work *work)
 	struct rcu_state *rsp = container_of(work, struct rcu_state, wakeup_work);
 
 	/* Wake up rcu_gp_kthread() to start the grace period. */
-	wake_up(&rsp->gp_wq);
+	rcu_gp_kthread_wake(rsp);
 }
 
 /*
-- 
2.1.3

