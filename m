Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753377AbaEEP0Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 11:26:16 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:49844 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882AbaEEP0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 11:26:15 -0400
Date: Mon, 5 May 2014 08:26:10 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: lock_task_sighand() && rcu_boost()
Message-ID: <20140505152610.GK8754@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140503161133.GA8838@redhat.com>
 <20140504180145.GC8754@linux.vnet.ibm.com>
 <20140504191757.GA11319@redhat.com>
 <20140504223804.GF8754@linux.vnet.ibm.com>
 <20140505132659.GA17996@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140505132659.GA17996@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14050515-9332-0000-0000-000000B1562A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 05, 2014 at 03:26:59PM +0200, Oleg Nesterov wrote:
> On 05/04, Paul E. McKenney wrote:
> >
> > --- a/include/linux/rcupdate.h
> > +++ b/include/linux/rcupdate.h
> > @@ -884,6 +884,27 @@ static inline void rcu_read_lock(void)
> >  /**
> >   * rcu_read_unlock() - marks the end of an RCU read-side critical section.
> >   *
> > + * In most situations, rcu_read_unlock() is immune from deadlock.
> > + * However, in kernels built with CONFIG_RCU_BOOST, rcu_read_unlock()
> > + * is responsible for deboosting, which it does via rt_mutex_unlock().
> > + * However, this function acquires the scheduler's runqueue and
> > + * priority-inheritance spinlocks.  Thus, deadlock could result if the
> > + * caller of rcu_read_unlock() already held one of these locks or any lock
> > + * acquired while holding them.
> > + *
> > + * That said, RCU readers are never priority boosted unless they were
> > + * preempted.  Therefore, one way to avoid deadlock is to make sure
> > + * that preemption never happens within any RCU read-side critical
> > + * section whose outermost rcu_read_unlock() is called with one of
> > + * rt_mutex_unlock()'s locks held.
> > + *
> > + * Given that the set of locks acquired by rt_mutex_unlock() might change
> > + * at any time, a somewhat more future-proofed approach is to make sure that
> > + * that preemption never happens within any RCU read-side critical
> > + * section whose outermost rcu_read_unlock() is called with one of
> > + * irqs disabled.  This approach relies on the fact that rt_mutex_unlock()
> > + * currently only acquires irq-disabled locks.
> > + *
> >   * See rcu_read_lock() for more information.
> >   */
> >  static inline void rcu_read_unlock(void)
> 
> Great! And I agree with "might change at any time" part.
> 
> I'll update lock_task_sighand() after you push this change (or please feel
> free to do this yourself). Cleanup is not that important, of course, but a
> short comment referring the documentation above can help another reader to
> understand the "unnecessary" local_irq_save/preempt_disable calls.
> 
> Thanks Paul.

Does the patch below cover it?

							Thanx, Paul

------------------------------------------------------------------------

signal: Explain local_irq_save() call

The explicit local_irq_save() in __lock_task_sighand() is needed to avoid
a potential deadlock condition, as noted in a841796f11c90d53 (signal:
align __lock_task_sighand() irq disabling and RCU).  However, someone
reading the code might be forgiven for concluding that this separate
local_irq_save() was completely unnecessary.  This commit therefore adds
a comment referencing the shiny new block comment on rcu_read_unlock().

Reported-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/kernel/signal.c b/kernel/signal.c
index 6ea13c09ae56..513e8c252aa4 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1288,6 +1288,10 @@ struct sighand_struct *__lock_task_sighand(struct task_struct *tsk,
 	struct sighand_struct *sighand;
 
 	for (;;) {
+		/*
+		 * Disable interrupts early to avoid deadlocks.
+		 * See rcu_read_unlock comment header for details.
+		 */
 		local_irq_save(*flags);
 		rcu_read_lock();
 		sighand = rcu_dereference(tsk->sighand);

