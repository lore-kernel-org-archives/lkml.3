Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965497AbaFCQsi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 12:48:38 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:48296 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965312AbaFCQse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 12:48:34 -0400
Date: Tue, 3 Jun 2014 09:48:26 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Waiman Long <waiman.long@hp.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>, John David Anglin <dave.anglin@bell.net>,
        Parisc List <linux-parisc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Vinod, Chegu" <chegu_vinod@hp.com>,
        Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Davidlohr Bueso <davidlohr@hp.com>, Peter Anvin <hpa@zytor.com>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>, Jason Low <jason.low2@hp.com>
Subject: Re: [PATCH v2] introduce atomic_pointer to fix a race condition in
 cancelable mcs spinlocks
Message-ID: <20140603164826.GA22288@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <alpine.LRH.2.02.1406021158360.20627@file01.intranet.prod.int.rdu2.redhat.com>
 <20140602162525.GH16155@laptop.programming.kicks-ass.net>
 <20140602163032.GI16155@laptop.programming.kicks-ass.net>
 <538CB56E.5010709@hp.com>
 <20140602200525.GD13930@laptop.programming.kicks-ass.net>
 <CA+55aFwJwVf_MbcwNNWg-KrLdoOaV2xse2jzvBZTJHJgC_Htvg@mail.gmail.com>
 <20140602210227.GE22231@linux.vnet.ibm.com>
 <CA+55aFzX3oDvzqh4AfkJ7-X1Yfo8obFM+jOOmwzeN-GyqOPLJg@mail.gmail.com>
 <20140602220831.GG22231@linux.vnet.ibm.com>
 <CA+55aFz7P0y1gZx7K2TCAKE7JQ6XseEprqXAQEOdq-j540KRYA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFz7P0y1gZx7K2TCAKE7JQ6XseEprqXAQEOdq-j540KRYA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14060316-8236-0000-0000-000002D39F0E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 02, 2014 at 03:55:57PM -0700, Linus Torvalds wrote:
> On Mon, Jun 2, 2014 at 3:08 PM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> >
> > rcu: Eliminate read-modify-write ACCESS_ONCE() calls
> >
> >         preempt_disable();
> > -       ACCESS_ONCE(this_cpu_ptr(sp->per_cpu_ref)->c[idx]) += 1;
> > +       lp = this_cpu_ptr(&sp->per_cpu_ref->c[idx]);
> > +       ACCESS_ONCE(*lp) = *lp + 1;
> >         smp_mb(); /* B */  /* Avoid leaking the critical section. */
> > -       ACCESS_ONCE(this_cpu_ptr(sp->per_cpu_ref)->seq[idx]) += 1;
> > +       lp = this_cpu_ptr(&sp->per_cpu_ref->seq[idx]);
> > +       ACCESS_ONCE(*lp) = *lp + 1;
> >         preempt_enable();
> >         return idx;
> 
> What Eric said. This should just use "this_cpu_inc()" instead.
> Particularly with the smp_mb() and the preempt_enable(), there's no
> way that could/should leak, and the ACCESS_ONCE() seems pointless and
> ugly.
> 
> And the good news is, gcc _will_ generate good code for that.

And here is the update, which passes light rcutorture testing.

							Thanx, Paul

------------------------------------------------------------------------

rcu: Eliminate read-modify-write ACCESS_ONCE() calls
    
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
index d1c8e4a85b92..f0ed867070cd 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -2275,7 +2275,7 @@ static void rcu_do_batch(struct rcu_state *rsp, struct rcu_data *rdp)
 	}
 	smp_mb(); /* List handling before counting for rcu_barrier(). */
 	rdp->qlen_lazy -= count_lazy;
-	ACCESS_ONCE(rdp->qlen) -= count;
+	ACCESS_ONCE(rdp->qlen) = rdp->qlen - count;
 	rdp->n_cbs_invoked += count;
 
 	/* Reinstate batch limit if we have worked down the excess. */
@@ -2420,7 +2420,7 @@ static void force_quiescent_state(struct rcu_state *rsp)
 		if (rnp_old != NULL)
 			raw_spin_unlock(&rnp_old->fqslock);
 		if (ret) {
-			ACCESS_ONCE(rsp->n_force_qs_lh)++;
+			rsp->n_force_qs_lh++;
 			return;
 		}
 		rnp_old = rnp;
@@ -2432,7 +2432,7 @@ static void force_quiescent_state(struct rcu_state *rsp)
 	smp_mb__after_unlock_lock();
 	raw_spin_unlock(&rnp_old->fqslock);
 	if (ACCESS_ONCE(rsp->gp_flags) & RCU_GP_FLAG_FQS) {
-		ACCESS_ONCE(rsp->n_force_qs_lh)++;
+		rsp->n_force_qs_lh++;
 		raw_spin_unlock_irqrestore(&rnp_old->lock, flags);
 		return;  /* Someone beat us to it. */
 	}
@@ -2621,7 +2621,7 @@ __call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu),
 		local_irq_restore(flags);
 		return;
 	}
-	ACCESS_ONCE(rdp->qlen)++;
+	ACCESS_ONCE(rdp->qlen) = rdp->qlen + 1;
 	if (lazy)
 		rdp->qlen_lazy++;
 	else
@@ -3185,7 +3185,7 @@ static void _rcu_barrier(struct rcu_state *rsp)
 	 * ACCESS_ONCE() to prevent the compiler from speculating
 	 * the increment to precede the early-exit check.
 	 */
-	ACCESS_ONCE(rsp->n_barrier_done)++;
+	ACCESS_ONCE(rsp->n_barrier_done) = rsp->n_barrier_done + 1;
 	WARN_ON_ONCE((rsp->n_barrier_done & 0x1) != 1);
 	_rcu_barrier_trace(rsp, "Inc1", -1, rsp->n_barrier_done);
 	smp_mb(); /* Order ->n_barrier_done increment with below mechanism. */
@@ -3235,7 +3235,7 @@ static void _rcu_barrier(struct rcu_state *rsp)
 
 	/* Increment ->n_barrier_done to prevent duplicate work. */
 	smp_mb(); /* Keep increment after above mechanism. */
-	ACCESS_ONCE(rsp->n_barrier_done)++;
+	ACCESS_ONCE(rsp->n_barrier_done) = rsp->n_barrier_done + 1;
 	WARN_ON_ONCE((rsp->n_barrier_done & 0x1) != 0);
 	_rcu_barrier_trace(rsp, "Inc2", -1, rsp->n_barrier_done);
 	smp_mb(); /* Keep increment before caller's subsequent code. */
diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index aee1e924b048..7ce734040a5e 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -2274,8 +2274,8 @@ static int rcu_nocb_kthread(void *arg)
 		tail = xchg(&rdp->nocb_tail, &rdp->nocb_head);
 		c = atomic_long_xchg(&rdp->nocb_q_count, 0);
 		cl = atomic_long_xchg(&rdp->nocb_q_count_lazy, 0);
-		ACCESS_ONCE(rdp->nocb_p_count) += c;
-		ACCESS_ONCE(rdp->nocb_p_count_lazy) += cl;
+		rdp->nocb_p_count += c;
+		rdp->nocb_p_count_lazy += cl;
 		rcu_nocb_wait_gp(rdp);
 
 		/* Each pass through the following loop invokes a callback. */

