Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753466AbaGGWkR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 18:40:17 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:57485 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752680AbaGGWib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 18:38:31 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 06/17] rcu: Eliminate read-modify-write ACCESS_ONCE() calls
Date: Mon,  7 Jul 2014 15:38:10 -0700
Message-Id: <1404772701-8804-6-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1404772701-8804-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140707223756.GA7187@linux.vnet.ibm.com>
 <1404772701-8804-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14070722-8236-0000-0000-000003A71C85
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

RCU contains code of the following forms:

	ACCESS_ONCE(x)++;
	ACCESS_ONCE(x) += y;
	ACCESS_ONCE(x) -= y;

Now these constructs do operate correctly, but they really result in a
pair of volatile accesses, one to do the load and another to do the store.
This can be confusing, as the casual reader might well assume that (for
example) gcc might generate a memory-to-memory add instruction for each
of these three cases.  In fact, gcc will do no such thing.  Also, there
is a good chance that the kernel will move to separate load and store
variants of ACCESS_ONCE(), and constructs like the above could easily
confuse both people and scripts attempting to make that sort of change.
Finally, most of RCU's read-modify-write uses of ACCESS_ONCE() really
only need the store to be volatile, so that the read-modify-write form
might be misleading.

This commit therefore changes the above forms in RCU so that each instance
of ACCESS_ONCE() either does a load or a store, but not both.  In a few
cases, ACCESS_ONCE() was not critical, for example, for maintaining
statisitics.  In these cases, ACCESS_ONCE() has been dispensed with
entirely.

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcu/srcu.c |  4 ++--
 kernel/rcu/tree.c | 12 ++++++------
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/kernel/rcu/srcu.c b/kernel/rcu/srcu.c
index c639556f3fa0..e037f3eb2f7b 100644
--- a/kernel/rcu/srcu.c
+++ b/kernel/rcu/srcu.c
@@ -298,9 +298,9 @@ int __srcu_read_lock(struct srcu_struct *sp)
 
 	idx = ACCESS_ONCE(sp->completed) & 0x1;
 	preempt_disable();
-	ACCESS_ONCE(this_cpu_ptr(sp->per_cpu_ref)->c[idx]) += 1;
+	__this_cpu_inc(sp->per_cpu_ref->c[idx]);
 	smp_mb(); /* B */  /* Avoid leaking the critical section. */
-	ACCESS_ONCE(this_cpu_ptr(sp->per_cpu_ref)->seq[idx]) += 1;
+	__this_cpu_inc(sp->per_cpu_ref->seq[idx]);
 	preempt_enable();
 	return idx;
 }
diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index ebd99af2214e..6bf7daebcc6b 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -2347,7 +2347,7 @@ static void rcu_do_batch(struct rcu_state *rsp, struct rcu_data *rdp)
 	}
 	smp_mb(); /* List handling before counting for rcu_barrier(). */
 	rdp->qlen_lazy -= count_lazy;
-	ACCESS_ONCE(rdp->qlen) -= count;
+	ACCESS_ONCE(rdp->qlen) = rdp->qlen - count;
 	rdp->n_cbs_invoked += count;
 
 	/* Reinstate batch limit if we have worked down the excess. */
@@ -2492,7 +2492,7 @@ static void force_quiescent_state(struct rcu_state *rsp)
 		if (rnp_old != NULL)
 			raw_spin_unlock(&rnp_old->fqslock);
 		if (ret) {
-			ACCESS_ONCE(rsp->n_force_qs_lh)++;
+			rsp->n_force_qs_lh++;
 			return;
 		}
 		rnp_old = rnp;
@@ -2504,7 +2504,7 @@ static void force_quiescent_state(struct rcu_state *rsp)
 	smp_mb__after_unlock_lock();
 	raw_spin_unlock(&rnp_old->fqslock);
 	if (ACCESS_ONCE(rsp->gp_flags) & RCU_GP_FLAG_FQS) {
-		ACCESS_ONCE(rsp->n_force_qs_lh)++;
+		rsp->n_force_qs_lh++;
 		raw_spin_unlock_irqrestore(&rnp_old->lock, flags);
 		return;  /* Someone beat us to it. */
 	}
@@ -2693,7 +2693,7 @@ __call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu),
 		local_irq_restore(flags);
 		return;
 	}
-	ACCESS_ONCE(rdp->qlen)++;
+	ACCESS_ONCE(rdp->qlen) = rdp->qlen + 1;
 	if (lazy)
 		rdp->qlen_lazy++;
 	else
@@ -3257,7 +3257,7 @@ static void _rcu_barrier(struct rcu_state *rsp)
 	 * ACCESS_ONCE() to prevent the compiler from speculating
 	 * the increment to precede the early-exit check.
 	 */
-	ACCESS_ONCE(rsp->n_barrier_done)++;
+	ACCESS_ONCE(rsp->n_barrier_done) = rsp->n_barrier_done + 1;
 	WARN_ON_ONCE((rsp->n_barrier_done & 0x1) != 1);
 	_rcu_barrier_trace(rsp, "Inc1", -1, rsp->n_barrier_done);
 	smp_mb(); /* Order ->n_barrier_done increment with below mechanism. */
@@ -3307,7 +3307,7 @@ static void _rcu_barrier(struct rcu_state *rsp)
 
 	/* Increment ->n_barrier_done to prevent duplicate work. */
 	smp_mb(); /* Keep increment after above mechanism. */
-	ACCESS_ONCE(rsp->n_barrier_done)++;
+	ACCESS_ONCE(rsp->n_barrier_done) = rsp->n_barrier_done + 1;
 	WARN_ON_ONCE((rsp->n_barrier_done & 0x1) != 0);
 	_rcu_barrier_trace(rsp, "Inc2", -1, rsp->n_barrier_done);
 	smp_mb(); /* Keep increment before caller's subsequent code. */
-- 
1.8.1.5

