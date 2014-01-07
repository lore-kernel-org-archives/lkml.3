Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757062AbaAGD3t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 22:29:49 -0500
Received: from g1t0026.austin.hp.com ([15.216.28.33]:37408 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753005AbaAGD3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 22:29:48 -0500
Message-ID: <1389065371.9937.15.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH v5 4/4] futex: Avoid taking hb lock if nothing to wakeup
From: Davidlohr Bueso <davidlohr@hp.com>
To: Darren Hart <dvhart@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, peterz@infradead.org,
        tglx@linutronix.de, paulmck@linux.vnet.ibm.com, efault@gmx.de,
        jeffm@suse.com, torvalds@linux-foundation.org, jason.low2@hp.com,
        Waiman.Long@hp.com, tom.vaden@hp.com, scott.norton@hp.com,
        aswin@hp.com
Date: Mon, 06 Jan 2014 19:29:31 -0800
In-Reply-To: <1389041524.30730.43.camel@dvhart-mobl4.amr.corp.intel.com>
References: <1388675120-8017-1-git-send-email-davidlohr@hp.com>
	 <1388675120-8017-5-git-send-email-davidlohr@hp.com>
	 <1389041524.30730.43.camel@dvhart-mobl4.amr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-01-06 at 12:52 -0800, Darren Hart wrote:
> On Thu, 2014-01-02 at 07:05 -0800, Davidlohr Bueso wrote:
> > From: Davidlohr Bueso <davidlohr@hp.com>
> > 
> > In futex_wake() there is clearly no point in taking the hb->lock if we know
> > beforehand that there are no tasks to be woken. While the hash bucket's plist
> > head is a cheap way of knowing this, we cannot rely 100% on it as there is a
> > racy window between the futex_wait call and when the task is actually added to
> > the plist. To this end, we couple it with the spinlock check as tasks trying to
> > enter the critical region are most likely potential waiters that will be added
> > to the plist, thus preventing tasks sleeping forever if wakers don't acknowledge
> > all possible waiters.
> > 
> > Furthermore, the futex ordering guarantees are preserved, ensuring that waiters
> > either observe the changed user space value before blocking or is woken by a
> > concurrent waker. For wakers, this is done by relying on the barriers in
> > get_futex_key_refs() -- for archs that do have implicit mb in atomic_inc() we
> 
> do NOT have implicit mb in atomic_inc()
>    ^

oh, yes!

> 
> Sorry to be a pedant, but this is gnarly stuff and we have to get the
> documentation right.
> 

Absolutely!

> > explicitly add them through a new futex_get_mm function. For waiters we rely
> > on the fact that spin_lock calls already update the head counter, so spinners
> > are visible even if the lock hasn't been acquired yet.
> > 
> > For more details please refer to the updated comments in the code and related
> > discussion: https://lkml.org/lkml/2013/11/26/556
> > 
> > Special thanks to tglx for careful review and feedback.
> > 
> > Cc: Ingo Molnar <mingo@kernel.org>
> > Cc: Darren Hart <dvhart@linux.intel.com>
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > Cc: Mike Galbraith <efault@gmx.de>
> > Cc: Jeff Mahoney <jeffm@suse.com>
> > Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
> > Cc: Scott Norton <scott.norton@hp.com>
> > Cc: Tom Vaden <tom.vaden@hp.com>
> > Cc: Aswin Chandramouleeswaran <aswin@hp.com>
> > Cc: Waiman Long <Waiman.Long@hp.com>
> > Cc: Jason Low <jason.low2@hp.com>
> > Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
> > ---
> >  kernel/futex.c | 113 +++++++++++++++++++++++++++++++++++++++++++++------------
> >  1 file changed, 90 insertions(+), 23 deletions(-)
> > 
> > diff --git a/kernel/futex.c b/kernel/futex.c
> > index fcc6850..5b4d09e 100644
> > --- a/kernel/futex.c
> > +++ b/kernel/futex.c
> > @@ -75,17 +75,20 @@
> >   * The waiter reads the futex value in user space and calls
> >   * futex_wait(). This function computes the hash bucket and acquires
> >   * the hash bucket lock. After that it reads the futex user space value
> > - * again and verifies that the data has not changed. If it has not
> > - * changed it enqueues itself into the hash bucket, releases the hash
> > - * bucket lock and schedules.
> > + * again and verifies that the data has not changed. If it has not changed
> > + * it enqueues itself into the hash bucket, releases the hash bucket lock
> > + * and schedules.
> >   *
> >   * The waker side modifies the user space value of the futex and calls
> > - * futex_wake(). This functions computes the hash bucket and acquires
> > - * the hash bucket lock. Then it looks for waiters on that futex in the
> > - * hash bucket and wakes them.
> > + * futex_wake(). This function computes the hash bucket and acquires the
> > + * hash bucket lock. Then it looks for waiters on that futex in the hash
> > + * bucket and wakes them.
> >   *
> > - * Note that the spin_lock serializes waiters and wakers, so that the
> > - * following scenario is avoided:
> > + * In scenarios where wakeups are called and no tasks are blocked on a futex,
> 
> 
> "wakeups are called" reads awkwardly to me. Perhaps:
> 
> "In futex wake up scenarios where no tasks are blocked on the
> futex, ..."
> 

I have no particular preference, so I'll update it.

> 
> > + * taking the hb spinlock can be avoided and simply return. In order for this
> > + * optimization to work, ordering guarantees must exist so that the waiter
> > + * being added to the list is acknowledged when the list is concurrently being
> > + * checked by the waker, avoiding scenarios like the following:
> >   *
> >   * CPU 0                               CPU 1
> >   * val = *futex;
> > @@ -106,24 +109,50 @@
> >   * This would cause the waiter on CPU 0 to wait forever because it
> >   * missed the transition of the user space value from val to newval
> >   * and the waker did not find the waiter in the hash bucket queue.
> > - * The spinlock serializes that:
> > + *
> > + * The correct serialization ensures that a waiter either observes
> > + * the changed user space value before blocking or is woken by a
> > + * concurrent waker:
> >   *
> >   * CPU 0                               CPU 1
> >   * val = *futex;
> >   * sys_futex(WAIT, futex, val);
> >   *   futex_wait(futex, val);
> > - *   lock(hash_bucket(futex));
> > - *   uval = *futex;
> > - *                                     *futex = newval;
> > - *                                     sys_futex(WAKE, futex);
> > - *                                       futex_wake(futex);
> > - *                                       lock(hash_bucket(futex));
> > + *
> > + *   waiters++;
> > + *   mb(); (A) <-- paired with -.
> > + *                              |
> > + *   lock(hash_bucket(futex));  |
> > + *                              |
> > + *   uval = *futex;             |
> > + *                              |        *futex = newval;
> > + *                              |        sys_futex(WAKE, futex);
> > + *                              |          futex_wake(futex);
> > + *                              |
> > + *                              `------->   mb(); (B)
> >   *   if (uval == val)
> > - *      queue();
> > + *     queue();
> >   *     unlock(hash_bucket(futex));
> > - *     schedule();                       if (!queue_empty())
> > - *                                         wake_waiters(futex);
> > - *                                       unlock(hash_bucket(futex));
> > + *     schedule();                         if (waiters)
> > + *                                           lock(hash_bucket(futex));
> > + *                                           wake_waiters(futex);
> > + *                                           unlock(hash_bucket(futex));
> > + *
> > + * Where (A) orders the waiters increment and the futex value read -- this
> > + * is guaranteed by the head counter in the hb spinlock; and where (B)
> > + * orders the write to futex and the waiters read.
> > + *
> > + * This yields the following case (where X:=waiters, Y:=futex):
> > + *
> > + *	X = Y = 0
> > + *
> > + *	w[X]=1		w[Y]=1
> > + *	MB		MB
> > + *	r[Y]=y		r[X]=x
> > + *
> > + * Which guarantees that x==0 && y==0 is impossible; which translates back into
> > + * the guarantee that we cannot both miss the futex variable change and the
> > + * enqueue.
> >   */
> >  
> >  int __read_mostly futex_cmpxchg_enabled;
> > @@ -211,6 +240,38 @@ static unsigned long __read_mostly futex_hashsize;
> >  
> >  static struct futex_hash_bucket *futex_queues;
> >  
> > +static inline void futex_get_mm(union futex_key *key)
> > +{
> > +	atomic_inc(&key->private.mm->mm_count);
> > +#ifdef CONFIG_SMP
> > +	/*
> > +	 * Ensure futex_get_mm() implies a full barrier such that
> > +	 * get_futex_key() implies a full barrier. This is relied upon
> > +	 * as full barrier (B), see the ordering comment above.
> > +	 */
> > +	smp_mb__after_atomic_inc();
> > +#endif
> > +}
> > +
> > +static inline bool hb_waiters_pending(struct futex_hash_bucket *hb)
> > +{
> > +#ifdef CONFIG_SMP
> > +	/*
> > +	 * Tasks trying to enter the critical region are most likely
> > +	 * potential waiters that will be added to the plist. Ensure
> > +	 * that wakers won't miss to-be-slept tasks in the window between
> > +	 * the wait call and the actual plist_add.
> > +	 */
> > +	if (spin_is_locked(&hb->lock))
> > +		return true;
> > +	smp_rmb(); /* Make sure we check the lock state first */
> > +
> > +	return !plist_head_empty(&hb->chain);
> > +#else
> > +	return true;
> > +#endif
> > +}
> 
> 
> I thought someone, Peter Z?, had commented on these CONFIG_SMP bits. Are
> they really necessary? Does smp_mb__after_atomic_inc() and smp_rmb() not
> already just do the right thing as far as we're concerned here?

I don't think so. Thomas and I agreed that this was in fact the way to
go. I rechecked old email and didn't notice any objections to
CONFIG_SMP. Also for things like hb_waiters_pending we definitely need
it.

> > +
> >  /*
> >   * We hash on the keys returned from get_futex_key (see below).
> >   */
> > @@ -245,10 +306,10 @@ static void get_futex_key_refs(union futex_key *key)
> >  
> >  	switch (key->both.offset & (FUT_OFF_INODE|FUT_OFF_MMSHARED)) {
> >  	case FUT_OFF_INODE:
> > -		ihold(key->shared.inode);
> > +		ihold(key->shared.inode); /* implies MB (B) */
> >  		break;
> >  	case FUT_OFF_MMSHARED:
> > -		atomic_inc(&key->private.mm->mm_count);
> > +		futex_get_mm(key); /* implies MB (B) */
> >  		break;
> >  	}
> >  }
> > @@ -322,7 +383,7 @@ get_futex_key(u32 __user *uaddr, int fshared, union futex_key *key, int rw)
> >  	if (!fshared) {
> >  		key->private.mm = mm;
> >  		key->private.address = address;
> > -		get_futex_key_refs(key);
> > +		get_futex_key_refs(key);  /* implies MB (B) */
> >  		return 0;
> >  	}
> >  
> > @@ -1052,6 +1113,11 @@ futex_wake(u32 __user *uaddr, unsigned int flags, int nr_wake, u32 bitset)
> >  		goto out;
> >  
> 
> 
> Given the subtlety of the implementation - I think it would be good to
> explicitly annotate the get_futex_key() call site in futex_wake() as
> providing the MB (B). 
> 
> Similar comment for futex_wait() and futex_requeue() for MB (A).
> 
> These will also raise the appropriate red flags for people looking to
> optimize or modify these paths in the future. It would be good to have
> it in the top level futex_* function to make the MB placement and
> relationship explicitly clear.
> 

Something quite similar was already there for v2 but PeterZ's feedback
made me update the main documentation at the top of futex.c to as it is
now...

> 
> >  	hb = hash_futex(&key);
> > +
> > +	/* Make sure we really have tasks to wakeup */
> > +	if (!hb_waiters_pending(hb))
> > +		goto out_put_key;
> > +
> >  	spin_lock(&hb->lock);
> >  
> >  	plist_for_each_entry_safe(this, next, &hb->chain, list) {
> > @@ -1072,6 +1138,7 @@ futex_wake(u32 __user *uaddr, unsigned int flags, int nr_wake, u32 bitset)
> >  	}
> >  
> >  	spin_unlock(&hb->lock);
> > +out_put_key:
> >  	put_futex_key(&key);
> >  out:
> >  	return ret;
> > @@ -1535,7 +1602,7 @@ static inline struct futex_hash_bucket *queue_lock(struct futex_q *q)
> >  	hb = hash_futex(&q->key);
> >  	q->lock_ptr = &hb->lock;
> >  
> > -	spin_lock(&hb->lock);
> > +	spin_lock(&hb->lock); /* implies MB (A) */
> >  	return hb;
> >  }
> >  
> 
> Functionally, this looks correct to me and Davidlohr's testing has been
> well documented.
> 
> Reviewed-by: Darren Hart <dvhart@linux.intel.com>

Thanks for looking into this Darren!

