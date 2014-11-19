Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756918AbaKSVOS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 16:14:18 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57177 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756517AbaKSVOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 16:14:15 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Pranith Kumar <bobby.prani@gmail.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.14 088/122] rcu: Make callers awaken grace-period kthread
Date: Wed, 19 Nov 2014 12:52:18 -0800
Message-Id: <20141119205211.733460077@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141119205208.812884198@linuxfoundation.org>
References: <20141119205208.812884198@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/rcu/tree.c |   18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -1228,6 +1228,22 @@ static int rcu_future_gp_cleanup(struct
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
@@ -1670,7 +1686,7 @@ static void rsp_wakeup(struct irq_work *
 	struct rcu_state *rsp = container_of(work, struct rcu_state, wakeup_work);
 
 	/* Wake up rcu_gp_kthread() to start the grace period. */
-	wake_up(&rsp->gp_wq);
+	rcu_gp_kthread_wake(rsp);
 }
 
 /*


