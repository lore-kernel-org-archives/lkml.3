Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754108AbaF0OXz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 10:23:55 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:39904 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753469AbaF0OXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 10:23:53 -0400
Date: Mon, 23 Jun 2014 12:16:46 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Waiman.Long@hp.com, tglx@linutronix.de, mingo@kernel.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        paolo.bonzini@gmail.com, boris.ostrovsky@oracle.com,
        paulmck@linux.vnet.ibm.com, riel@redhat.com,
        torvalds@linux-foundation.org, raghavendra.kt@linux.vnet.ibm.com,
        david.vrabel@citrix.com, oleg@redhat.com, gleb@redhat.com,
        scott.norton@hp.com, chegu_vinod@hp.com
Subject: Re: [PATCH 01/11] qspinlock: A simple generic 4-byte queue spinlock
Message-ID: <20140623161646.GA9321@laptop.dumpdata.com>
References: <20140615124657.264658593@chello.nl>
 <20140615130152.912524881@chello.nl>
 <20140616204918.GA26140@laptop.dumpdata.com>
 <20140623155650.GF19860@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140623155650.GF19860@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2014 at 05:56:50PM +0200, Peter Zijlstra wrote:
> On Mon, Jun 16, 2014 at 04:49:18PM -0400, Konrad Rzeszutek Wilk wrote:
> > > Index: linux-2.6/kernel/locking/mcs_spinlock.h
> > > ===================================================================
> > > --- linux-2.6.orig/kernel/locking/mcs_spinlock.h
> > > +++ linux-2.6/kernel/locking/mcs_spinlock.h
> > > @@ -17,6 +17,7 @@
> > >  struct mcs_spinlock {
> > >  	struct mcs_spinlock *next;
> > >  	int locked; /* 1 if lock acquired */
> > > +	int count;
> > 
> > This could use a comment.
> 
> like so?
> 
> 	int count; /* nesting count, see qspinlock.c */

/* nested level -  in user, softirq, hard irq or nmi context. */ ?

> 
> 
> > > +static inline u32 encode_tail(int cpu, int idx)
> > > +{
> > > +	u32 tail;
> > > +
> > > +	tail  = (cpu + 1) << _Q_TAIL_CPU_OFFSET;
> > > +	tail |= idx << _Q_TAIL_IDX_OFFSET; /* assume < 4 */
> > 
> > Should there an
> > 
> > ASSSERT (idx < 4)
> > 
> > just in case we screw up somehow (I can't figure out how, but
> > that is partially why ASSERTS are added).
> 
> #ifdef CONFIG_DEBUG_SPINLOCK
> 	BUG_ON(idx > 3);
> #endif
> 
> might do, I suppose.

<nods>
> 
> > > +/**
> > > + * queue_spin_lock_slowpath - acquire the queue spinlock
> > > + * @lock: Pointer to queue spinlock structure
> > > + * @val: Current value of the queue spinlock 32-bit word
> > > + *
> > > + * (queue tail, lock bit)
> > 
> > Except it is not a lock bit. It is a lock uint8_t.
> 
> It is indeed, although that's an accident of implementation. I could do
> s/bit// and not mention the entire storage angle at all?

I think giving as much details as possible is good.

What you said 'accident of implementation' is a could be woven
in there?
> 
> > Is the queue tail at this point the composite of 'cpu|idx'?
> 
> Yes, as per {en,de}code_tail() above.
> 
> > > + *
> > > + *              fast      :    slow                                  :    unlock
> > > + *                        :                                          :
> > > + * uncontended  (0,0)   --:--> (0,1) --------------------------------:--> (*,0)
> > > + *                        :       | ^--------.                    /  :
> > > + *                        :       v           \                   |  :
> > > + * uncontended            :    (n,x) --+--> (n,0)                 |  :
> > 
> > So many CPUn come in right? Is 'n' for the number of CPUs?
> 
> Nope, 'n' for any one specific tail, in particular the first one to
> arrive. This is the 'uncontended queue' case as per the label, so we
> need a named value for the first, in order to distinguish between the
> state to the right (same tail, but unlocked) and the state below
> (different tail).
> 
> > > + *   queue                :       | ^--'                          |  :
> > > + *                        :       v                               |  :
> > > + * contended              :    (*,x) --+--> (*,0) -----> (*,1) ---'  :
> > > + *   queue                :         ^--'                             :
> > 
> > And here um, what are the '*' for? Are they the four different
> > types of handlers that can be nested? So task, sofitrq, hardisk, and
> > nmi?
> 
> '*' as in wildcard, any tail, specifically not 'n'.

Ah, thank you for the explanation! Would it be possible to include
that in the comment please?

> 
> > > +void queue_spin_lock_slowpath(struct qspinlock *lock, u32 val)
> > > +{
> > > +	struct mcs_spinlock *prev, *next, *node;
> > > +	u32 new, old, tail;
> > > +	int idx;
> > > +
> > > +	BUILD_BUG_ON(CONFIG_NR_CPUS >= (1U << _Q_TAIL_CPU_BITS));
> > > +
> > > +	node = this_cpu_ptr(&mcs_nodes[0]);
> > > +	idx = node->count++;
> > 
> > If this is the first time we enter this, wouldn't idx end up
> > being 1?
> 
> Nope, postfix ++ returns first and increments later.

<blushes> Yes it does.
> 
> > > +	tail = encode_tail(smp_processor_id(), idx);
> > > +
> > > +	node += idx;
> > 
> > Meaning we end up skipping the 'mcs_nodes[0]' one altogether - even
> > on the first 'level' (task, softirq, hardirq, nmi)? Won't that
> > cause us to blow past the array when we are nested at the nmi
> > handler?
> 
> Seeing how its all static storage, which is automagically initialized to
> 0, combined with the postfix ++ (as opposed to the prefix ++) we should
> be getting 0 here.

I've no idea what I was thinking, but thank you for setting me straight.

> 
> > > +	node->locked = 0;
> > > +	node->next = NULL;
> > > +
> > > +	/*
> > > +	 * trylock || xchg(lock, node)
> > > +	 *
> > > +	 * 0,0 -> 0,1 ; trylock
> > > +	 * p,x -> n,x ; prev = xchg(lock, node)
> > 
> > I looked at that for 10 seconds and I was not sure what you meant.
> > Is this related to the MCS document you had pointed to? It would help
> > if you mention that the comments follow the document. (But they
> > don't seem to)
> > 
> > I presume what you mean is that if we are the next after the
> > lock-holder we need only to update the 'next' (or the
> > composite value of smp_processor_idx | idx) to point to us.
> > 
> > As in, swap the 'L' with 'I' (looking at the doc)
> 
> They are the 'tail','lock' tuples, so this composite atomic operation
> completes either:
> 
>   0,0 -> 0,1  -- we had no tail, not locked; into: no tail, locked.
> 
> OR
> 
>   p,x -> n,x  -- tail was p; into: tail is n; preserving locked.

Oh this is good!
> 
> > > +	 */
> > > +	for (;;) {
> > > +		new = _Q_LOCKED_VAL;
> > > +		if (val)
> > 
> > Could you add a comment here, like this:
> > 
> > /*
> >  * N.B. Initially 'val' will have some value (as we are called
> >  * after the _Q_LOCKED_VAL could not be set by queue_spin_lock).
> >  * But on subsequent iterations, either the lock holder will
> >  * decrement the val (queue_spin_unlock - to zero) and we
> >  * needn't to record our status in the queue as we have set the
> >  * Q_LOCKED_VAL (new) and are the lock holder. Or we are next
> >  * in line and need to record our 'next' (aka, smp_processor_id() | idx)
> >  * position. */
> >  */
> 
> The idea was that:
> 
>   0,0 -> 0,1
>   p,x -> n,x
> 
> Completely covers what this composite atomic does.
> 
> > > +			new = tail | (val & _Q_LOCKED_MASK);
> > > +
> > > +		old = atomic_cmpxchg(&lock->val, val, new);
> > > +		if (old == val)
> > > +			break;
> > > +
> > > +		val = old;
> > > +	}
> > > +
> > > +	/*
> > > +	 * we won the trylock; forget about queueing.
> > > +	 */
> > > +	if (new == _Q_LOCKED_VAL)
> > > +		goto release;
> > > +
> > > +	/*
> > > +	 * if there was a previous node; link it and wait.
> > > +	 */
> > > +	if (old & ~_Q_LOCKED_MASK) {
> > > +		prev = decode_tail(old);
> > > +		ACCESS_ONCE(prev->next) = node;
> > > +
> > > +		arch_mcs_spin_lock_contended(&node->locked);
> > > +	}
> > > +
> > > +	/*
> > > +	 * we're at the head of the waitqueue, wait for the owner to go away.
> > > +	 *
> > > +	 * *,x -> *,0
> > > +	 */
> > > +	while ((val = atomic_read(&lock->val)) & _Q_LOCKED_MASK)
> > > +		cpu_relax();
> > > +
> > > +	/*
> > > +	 * claim the lock:
> > > +	 *
> > > +	 * n,0 -> 0,1 : lock, uncontended
> > > +	 * *,0 -> *,1 : lock, contended
> > > +	 */
> > > +	for (;;) {
> > > +		new = _Q_LOCKED_VAL;
> > > +		if (val != tail)
> > > +			new |= val;
> > 
> > You lost me here. If we are at the head of the queue, and the owner
> > has called queue_spin_unlock (hence made us get out of the 'val = atomic_read'
> > loop, how can val != tail?
> 
> Remember:
> 
> > > +	tail = encode_tail(smp_processor_id(), idx);
> 
> So if value != tail, that means the tail pointer doesn't point to us
> anymore, another cpu/idx queued itself and is now last.
> 
> > I suspect it has something to do with the comment, but I am still unsure
> > what it means.
> > 
> > Could you help a bit in explaining it in English please?
> 
> (refer to the state diagram, if we count states left->right,
> top->bottom, then this is: 5->2 or 7->8
> 
>  n,0 -> 0,1:
> 
>    the lock is free and the tail points to the first queued; this means
>    that unqueueing implies wiping the tail, at the same time, acquire
>    the lock.
> 
>  *,0 -> *,1:
> 
>    the lock is free and the tail doesn't point to the first queued; this
>    means that unqueueing doesn't touch the tail pointer but only sets
>    the lock.
> 
> > > +
> > > +		old = atomic_cmpxchg(&lock->val, val, new);
> > > +		if (old == val)
> > > +			break;
> > > +
> > > +		val = old;
> > > +	}
> > > +
> > > +	/*
> > > +	 * contended path; wait for next, release.
> > > +	 */
> > > +	if (new != _Q_LOCKED_VAL) {
> > 
> > Hm, wouldn't it be just easier to do a 'goto restart' where
> > restart label points at the first loop statement? Ah never
> > mind - we have already inserted ourselves in the previous's
> > node.
> > 
> > But that is confusing - we have done: "prev->next = node;"
> > 
> > And then exited out of 'val = atomic_read(&lock->val))' which
> > suggests that queue_spin_unlock has called us. How can we be
> > contended again?
> 
> We're not contended again; we're in the 'contended queued' case, which
> means that 'tail' didn't point to us anymore, in that case, we must kick
> our next node such that it will now drop out of
> arch_mcs_spin_lock_contended() and goes wait on the 'locked' state.

<nods>
> 
> So what we do here is wait for 'node->next' to be set; it might still be
> NULL if the other cpu is between:
> 
>   prev = xchg(lock->tail, node);
> 
> and:
> 
>   prev->next = node;
> 
> Once we observe the next node, we call arch_mcs_spin_unlock_contended()
> on it, which sets its mcs_spinlock::locked and makes the new 'top of
> queue' drop out of arch_mcs_spin_lock_contended and spin on the 'locked'
> state as said above.

Thank you for your detailed explanation!
