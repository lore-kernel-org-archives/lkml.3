Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755338Ab3LJRe2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 12:34:28 -0500
Received: from merlin.infradead.org ([205.233.59.134]:56709 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929Ab3LJRe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 12:34:27 -0500
Date: Tue, 10 Dec 2013 18:34:11 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, dvhart@linux.intel.com,
        tglx@linutronix.de, paulmck@linux.vnet.ibm.com, efault@gmx.de,
        jeffm@suse.com, torvalds@linux-foundation.org, scott.norton@hp.com,
        tom.vaden@hp.com, aswin@hp.com, Waiman.Long@hp.com, jason.low2@hp.com
Subject: Re: [PATCH v2 4/4] futex: Avoid taking hb lock if nothing to wakeup
Message-ID: <20131210173411.GR12849@twins.programming.kicks-ass.net>
References: <1386063927-6545-1-git-send-email-davidlohr@hp.com>
 <1386063927-6545-5-git-send-email-davidlohr@hp.com>
 <20131210165736.GN12849@twins.programming.kicks-ass.net>
 <1386696128.2731.11.camel@buesod1.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386696128.2731.11.camel@buesod1.americas.hpqcorp.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 10, 2013 at 09:22:08AM -0800, Davidlohr Bueso wrote:
> On Tue, 2013-12-10 at 17:57 +0100, Peter Zijlstra wrote:
> > > @@ -106,24 +108,40 @@
> > >   * This would cause the waiter on CPU 0 to wait forever because it
> > >   * missed the transition of the user space value from val to newval
> > >   * and the waker did not find the waiter in the hash bucket queue.
> > > + * The correct serialization ensures that a waiter either observes
> > > + * the changed user space value before blocking or is woken by a
> > > + * concurrent waker:
> > >   *
> > >   * CPU 0                               CPU 1
> > >   * val = *futex;
> > >   * sys_futex(WAIT, futex, val);
> > >   *   futex_wait(futex, val);
> > > + *
> > > + *   mb(); <-- paired with ------
> > > + *                              |
> > > + *   lock(hash_bucket(futex));  |
> > > + *                              |
> > > + *   uval = *futex;             |
> > > + *                              |        *futex = newval;
> > > + *                              |        sys_futex(WAKE, futex);
> > > + *                              |          futex_wake(futex);
> > > + *                              |
> > > + *                              -------->   mb();
> > >   *   if (uval == val)
> > > + *     queue();
> > >   *     unlock(hash_bucket(futex));
> > > + *     schedule();                         if (!queue_empty())
> > > + *                                           lock(hash_bucket(futex));
> > > + *                                           wake_waiters(futex);
> > > + *                                           unlock(hash_bucket(futex));
> > > + *
> > > + * The length of the list is tracked with atomic ops (hb->waiters),
> > > + * providing the necessary memory barriers for the waiters. For the
> > > + * waker side, however, we rely on get_futex_key_refs(), using either
> > > + * ihold() or the atomic_inc(), for shared futexes. The former provides
> > > + * a full mb on all architectures. For architectures that do not have an
> > > + * implicit barrier in atomic_inc/dec, we explicitly add it - please
> > > + * refer to futex_get_mm() and hb_waiters_inc/dec().
> > >   */

> > It isn't at all explained what purpose the memory barriers serve.
> 
> Why doesn't this explain it?

Because you failed to explain what is ordered against what and what
the resulting order guarantees.

> "The correct serialization ensures that a waiter either observes
> the changed user space value before blocking or is woken by a
> concurrent waker."

Or both. For the given case:

X = Y = 0

w[X]=1  w[Y]=1
MB	MB
r[Y]=y	r[X]=x

x==1 && y==1 is a valid result. The only invalid result is both 0.

But then we're still short of how we end up at that guarantee.

> Perhaps adding an example?
>  plist_add()    |    uaddr = newval
>  smp_mb()       |    smp_mb()
>  verify uaddr   |    plist_head_empty()

Except of course you don't actually use plist_add() and
plist_head_empty() for anything much at all, only creating more
confusion.

Just add the waiters variable and explicitly mention what you're doing.
