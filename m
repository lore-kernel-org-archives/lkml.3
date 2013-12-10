Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506Ab3LJRWP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 12:22:15 -0500
Received: from g1t0027.austin.hp.com ([15.216.28.34]:36932 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752717Ab3LJRWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 12:22:12 -0500
Message-ID: <1386696128.2731.11.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH v2 4/4] futex: Avoid taking hb lock if nothing to wakeup
From: Davidlohr Bueso <davidlohr@hp.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, dvhart@linux.intel.com,
        tglx@linutronix.de, paulmck@linux.vnet.ibm.com, efault@gmx.de,
        jeffm@suse.com, torvalds@linux-foundation.org, scott.norton@hp.com,
        tom.vaden@hp.com, aswin@hp.com, Waiman.Long@hp.com, jason.low2@hp.com
Date: Tue, 10 Dec 2013 09:22:08 -0800
In-Reply-To: <20131210165736.GN12849@twins.programming.kicks-ass.net>
References: <1386063927-6545-1-git-send-email-davidlohr@hp.com>
	 <1386063927-6545-5-git-send-email-davidlohr@hp.com>
	 <20131210165736.GN12849@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-12-10 at 17:57 +0100, Peter Zijlstra wrote:
> On Tue, Dec 03, 2013 at 01:45:27AM -0800, Davidlohr Bueso wrote:
> > --- a/kernel/futex.c
> > +++ b/kernel/futex.c
> > @@ -82,10 +82,12 @@
> >   * The waker side modifies the user space value of the futex and calls
> >   * futex_wake(). It computes the hash bucket and acquires the hash
> >   * bucket lock. Then it looks for waiters on that futex in the hash
> > - * bucket and wakes them.
> > - *
> > - * Note that the spin_lock serializes waiters and wakers, so that the
> > - * following scenario is avoided:
> > + * bucket and wakes them.
> 
> Why not let this be the start of a new paragraph?
> 
> > In scenarios where wakeups are called and no
> > + * tasks are blocked on a futex, taking the hb spinlock can be avoided
> > + * and simply return. In order for this optimization to work, ordering
> > + * guarantees must exist so that the waiter being added to the list is
> > + * acknowledged when the list is concurrently being checked by the waker,
> > + * avoiding scenarios like the following:
> >   *
> >   * CPU 0                               CPU 1
> >   * val = *futex;
> > @@ -106,24 +108,40 @@
> >   * This would cause the waiter on CPU 0 to wait forever because it
> >   * missed the transition of the user space value from val to newval
> >   * and the waker did not find the waiter in the hash bucket queue.
> > + * The correct serialization ensures that a waiter either observes
> > + * the changed user space value before blocking or is woken by a
> > + * concurrent waker:
> >   *
> >   * CPU 0                               CPU 1
> >   * val = *futex;
> >   * sys_futex(WAIT, futex, val);
> >   *   futex_wait(futex, val);
> > + *
> > + *   mb(); <-- paired with ------
> > + *                              |
> > + *   lock(hash_bucket(futex));  |
> > + *                              |
> > + *   uval = *futex;             |
> > + *                              |        *futex = newval;
> > + *                              |        sys_futex(WAKE, futex);
> > + *                              |          futex_wake(futex);
> > + *                              |
> > + *                              -------->   mb();
> >   *   if (uval == val)
> > + *     queue();
> >   *     unlock(hash_bucket(futex));
> > + *     schedule();                         if (!queue_empty())
> > + *                                           lock(hash_bucket(futex));
> > + *                                           wake_waiters(futex);
> > + *                                           unlock(hash_bucket(futex));
> > + *
> > + * The length of the list is tracked with atomic ops (hb->waiters),
> > + * providing the necessary memory barriers for the waiters. For the
> > + * waker side, however, we rely on get_futex_key_refs(), using either
> > + * ihold() or the atomic_inc(), for shared futexes. The former provides
> > + * a full mb on all architectures. For architectures that do not have an
> > + * implicit barrier in atomic_inc/dec, we explicitly add it - please
> > + * refer to futex_get_mm() and hb_waiters_inc/dec().
> >   */
> 
> This comment actually confuses me :/

Well that explains where the required barriers are coming from.

> 
> It isn't at all explained what purpose the memory barriers serve.

Why doesn't this explain it?

"The correct serialization ensures that a waiter either observes
the changed user space value before blocking or is woken by a
concurrent waker."

Perhaps adding an example?
 plist_add()    |    uaddr = newval
 smp_mb()       |    smp_mb()
 verify uaddr   |    plist_head_empty()

Thanks,
Davidlohr

