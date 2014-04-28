Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754663AbaD1X4n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 19:56:43 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:50935 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752513AbaD1X4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 19:56:41 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 01/19] rcu: Protect ->gp_flags accesses with ACCESS_ONCE()
Date: Mon, 28 Apr 2014 16:56:14 -0700
Message-Id: <1398729392-15087-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <20140428235600.GA12200@linux.vnet.ibm.com>
References: <20140428235600.GA12200@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042823-0928-0000-0000-0000018CF5A1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

A number of ->gp_flags accesses don't have ACCESS_ONCE(), but all of
the can race against other loads or stores.  This commit therefore
applies ACCESS_ONCE() to the unprotected ->gp_flags accesses.

Reported-by: Alexey Roytman <alexey.roytman@oracle.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcu/tree.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 0c47e300210a..2c53ac924cab 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -1403,12 +1403,12 @@ static int rcu_gp_init(struct rcu_state *rsp)
 	rcu_bind_gp_kthread();
 	raw_spin_lock_irq(&rnp->lock);
 	smp_mb__after_unlock_lock();
-	if (rsp->gp_flags == 0) {
+	if (!ACCESS_ONCE(rsp->gp_flags)) {
 		/* Spurious wakeup, tell caller to go back to sleep.  */
 		raw_spin_unlock_irq(&rnp->lock);
 		return 0;
 	}
-	rsp->gp_flags = 0; /* Clear all flags: New grace period. */
+	ACCESS_ONCE(rsp->gp_flags) = 0; /* Clear all flags: New grace period. */
 
 	if (WARN_ON_ONCE(rcu_gp_in_progress(rsp))) {
 		/*
@@ -1501,7 +1501,7 @@ static int rcu_gp_fqs(struct rcu_state *rsp, int fqs_state_in)
 	if (ACCESS_ONCE(rsp->gp_flags) & RCU_GP_FLAG_FQS) {
 		raw_spin_lock_irq(&rnp->lock);
 		smp_mb__after_unlock_lock();
-		rsp->gp_flags &= ~RCU_GP_FLAG_FQS;
+		ACCESS_ONCE(rsp->gp_flags) &= ~RCU_GP_FLAG_FQS;
 		raw_spin_unlock_irq(&rnp->lock);
 	}
 	return fqs_state;
@@ -1566,7 +1566,7 @@ static void rcu_gp_cleanup(struct rcu_state *rsp)
 	rdp = this_cpu_ptr(rsp->rda);
 	rcu_advance_cbs(rsp, rnp, rdp);  /* Reduce false positives below. */
 	if (cpu_needs_another_gp(rsp, rdp)) {
-		rsp->gp_flags = RCU_GP_FLAG_INIT;
+		ACCESS_ONCE(rsp->gp_flags) = RCU_GP_FLAG_INIT;
 		trace_rcu_grace_period(rsp->name,
 				       ACCESS_ONCE(rsp->gpnum),
 				       TPS("newreq"));
@@ -1695,7 +1695,7 @@ rcu_start_gp_advanced(struct rcu_state *rsp, struct rcu_node *rnp,
 		 */
 		return;
 	}
-	rsp->gp_flags = RCU_GP_FLAG_INIT;
+	ACCESS_ONCE(rsp->gp_flags) = RCU_GP_FLAG_INIT;
 	trace_rcu_grace_period(rsp->name, ACCESS_ONCE(rsp->gpnum),
 			       TPS("newreq"));
 
@@ -2320,7 +2320,7 @@ static void force_quiescent_state(struct rcu_state *rsp)
 		raw_spin_unlock_irqrestore(&rnp_old->lock, flags);
 		return;  /* Someone beat us to it. */
 	}
-	rsp->gp_flags |= RCU_GP_FLAG_FQS;
+	ACCESS_ONCE(rsp->gp_flags) |= RCU_GP_FLAG_FQS;
 	raw_spin_unlock_irqrestore(&rnp_old->lock, flags);
 	wake_up(&rsp->gp_wq);  /* Memory barrier implied by wake_up() path. */
 }
-- 
1.8.1.5

