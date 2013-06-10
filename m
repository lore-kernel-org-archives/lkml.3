Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045Ab3FJVyk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 17:54:40 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:45649 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753824Ab3FJVyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 17:54:38 -0400
Date: Mon, 10 Jun 2013 14:54:31 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, edumazet@google.com,
        darren@dvhart.com, fweisbec@gmail.com, sbw@mit.edu,
        torvalds@linux-foundation.org
Subject: Re: [PATCH RFC ticketlock] Auto-queued ticketlock
Message-ID: <20130610215431.GT5146@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130609193657.GA13392@linux.vnet.ibm.com>
 <1370900106.3252.11.camel@edumazet-glaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370900106.3252.11.camel@edumazet-glaptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13061021-5518-0000-0000-00000F844BDE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 10, 2013 at 02:35:06PM -0700, Eric Dumazet wrote:
> On Sun, 2013-06-09 at 12:36 -0700, Paul E. McKenney wrote:
> > Breaking up locks is better than implementing high-contention locks, but
> > if we must have high-contention locks, why not make them automatically
> > switch between light-weight ticket locks at low contention and queued
> > locks at high contention?
> > 
> > This commit therefore allows ticket locks to automatically switch between
> > pure ticketlock and queued-lock operation as needed.  If too many CPUs
> > are spinning on a given ticket lock, a queue structure will be allocated
> > and the lock will switch to queued-lock operation.  When the lock becomes
> > free, it will switch back into ticketlock operation.  The low-order bit
> > of the head counter is used to indicate that the lock is in queued mode,
> > which forces an unconditional mismatch between the head and tail counters.
> > This approach means that the common-case code path under conditions of
> > low contention is very nearly that of a plain ticket lock.
> > 
> > A fixed number of queueing structures is statically allocated in an
> > array.  The ticket-lock address is used to hash into an initial element,
> > but if that element is already in use, it moves to the next element.  If
> > the entire array is already in use, continue to spin in ticket mode.
> > 
> > This has been only lightly tested in the kernel, though a userspace
> > implementation has survived substantial testing.
> > 
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> This looks a great idea ;)

Glad you like it!  Hopefully workloads like it as well.  ;-)

> > +
> > +static __always_inline void __ticket_spin_unlock(arch_spinlock_t *lock)
> > +{
> > +	__ticket_t head = 2;
> > +
> > +	head = xadd(&lock->tickets.head, 2);
> 
> 	head = xadd(&lock->tickets.head, head);

Yikes!  Good catch, fixed.

> > +	if (head & 0x1)
> > +		tkt_q_do_wake(lock);
> > +}
> > +#endif /* #else #ifndef CONFIG_TICKET_LOCK_QUEUED */
> 
> > + */
> > +void tkt_q_do_wake(arch_spinlock_t *asp)
> > +{
> > +	struct tkt_q_head *tqhp;
> > +	struct tkt_q *tqp;
> > +
> > +	/* If the queue is still being set up, wait for it. */
> > +	while ((tqhp = tkt_q_find_head(asp)) == NULL)
> > +		cpu_relax();
> > +
> > +	for (;;) {
> > +
> > +		/* Find the first queue element. */
> > +		tqp = ACCESS_ONCE(tqhp->spin);
> > +		if (tqp != NULL)
> > +			break;  /* Element exists, hand off lock. */
> > +		if (tkt_q_try_unqueue(asp, tqhp))
> > +			return; /* No element, successfully removed queue. */
> > +		cpu_relax();
> > +	}
> > +	if (ACCESS_ONCE(tqhp->head_tkt) != -1)
> > +		ACCESS_ONCE(tqhp->head_tkt) = -1;
> > +	smp_mb(); /* Order pointer fetch and assignment against handoff. */
> > +	ACCESS_ONCE(tqp->cpu) = -1;
> > +}
> 
> EXPORT_SYMBOL(tkt_q_do_wake) ?

Good point, just in case we want to use spinlocks in modules.  ;-)
Same for tkt_spin_pass(), I guess.

> Hmm, unfortunately I lack time this week to fully read the patch !

I suspect that there is very little danger of this patch going in this
week, so you should have some additional time.  ;-)

							Thanx, Paul

