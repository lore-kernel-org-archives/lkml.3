Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756989Ab3CNLjs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 07:39:48 -0400
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:46813 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755972Ab3CNLjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 07:39:45 -0400
Message-ID: <1363261167.25976.221.camel@thor.lan>
Subject: Re: [PATCH 11/12] rwsem: wake all readers when first waiter is a
 reader
From: Peter Hurley <peter@hurleysoftware.com>
To: Michel Lespinasse <walken@google.com>
Cc: Alex Shi <alex.shi@intel.com>, Ingo Molnar <mingo@kernel.org>,
        David Howells <dhowells@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Date: Thu, 14 Mar 2013 07:39:27 -0400
In-Reply-To: <20130314070303.GA10956@google.com>
References: <1362612111-28673-1-git-send-email-walken@google.com>
	 <1362612111-28673-12-git-send-email-walken@google.com>
	 <1363034207.27803.8.camel@thor.lan> <20130314070303.GA10956@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-0pjh1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-03-14 at 00:03 -0700, Michel Lespinasse wrote:
> On Mon, Mar 11, 2013 at 04:36:47PM -0400, Peter Hurley wrote:
> > 
> > On Wed, 2013-03-06 at 15:21 -0800, Michel Lespinasse wrote:
> > > + retry_reader_grants:
> > > +	oldcount = rwsem_atomic_update(adjustment, sem) - adjustment;
> > > +	if (unlikely(oldcount < RWSEM_WAITING_BIAS)) {
> > > +		/* A writer stole the lock.  Undo our reader grants. */
> > > +		if (rwsem_atomic_update(-adjustment, sem) < RWSEM_WAITING_BIAS)
> > > +			goto out;
> > > +		/* The writer left.  Retry waking readers. */
> > > +		goto retry_reader_grants;
> > > +	}
> > 
> > This can be reduced to single looping cmpxchg in the grant reversal
> > path; then if reversing the grant fails, the count can simply be
> > re-tested for grant success, rather than trying to atomically re-grant.
> > For example, with a helper function, rwsem_cmpxchg():
> > 
> > static inline int rwsem_cmpxchg(long *old, long new, struct rw_semaphore *sem)
> > {
> > 	long tmp = *old;
> > 	*old = cmpxchg(&sem->count, *old, new);
> > 	return tmp == *old;
> > }
> > 
> > ... then above becomes ...
> > 
> > 	count = rwsem_atomic_update(adjustment, sem);
> > 	do {
> > 		if (count - adjustment >= RWSEM_WAITING_BIAS)
> > 			break;
> > 		if (rwsem_cmpxchg(&count, count - adjustment, sem))
> > 			goto out;   /* or simply return sem */
> > 	} while (1);
> > 
> > 	< wake up readers >
> 
> This would work, but I don't see a benefit as we still end up with a
> retry loop. Also, the loop would have to retry whenever the counter
> value changed instead of only when writer(s) appear or are removed.

It's a minor optimization in that, while the count is unstable, this CPU
will stay here and while it does so, it's only inflicting one bus lock
rather than two. Feel free to ignore it.

> > Also, this series and the original rwsem can mistakenly sleep reader(s)
> > when the lock is transitioned from writer-owned to waiting readers-owned
> > with no waiting writers. For example,
> > 
> > 
> >   CPU 0                               |  CPU 1
> >                                       |
> >                                       | down_write()
> > 
> > ... CPU 1 has the write lock for the semaphore.
> >     Meanwhile, 1 or more down_read(s) are attempted and fail;
> >     these are put on the wait list.
> 
> I'm not sure of the relevance of these other down_read() calls -
> please note that as these extra readers are put on the wait list,
> their +read_bias adjustments are canceled so that the count value
> ends up at write_bias + waiting_bias (for a total active count of 1)

The relevance of the waiting readers is that when CPU 1 drops the writer
___and grabs the spin lock___, it then wakes up these already-waiting
readers (CPU 0 is still parked in down_read_failed() waiting to acquire
the spin lock).

When CPU 1 wakes up these readers, the sem count goes > 0 and the
waiting list is emptied. CPU 1 then drops the spin lock and leaves
up_write().

CPU 0 has been spinning on the wait_lock during this time. It now
acquires the lock, and discovers the wait list is empty and ups the
adjustment(+wait bias). The count is already (+ # of waiting readers) so
it never does the wake up.

> > Then ...
> > 
> > down_read()                           | up_write()
> >   local = atomic_update(+read_bias)   |
> >   local <= 0?                         |   local = atomic_update(-write_bias)
> >   if (true)                           |   local < 0?
> >      down_read_failed()               |   if (true)
> >                                       |      wake()
> >                                       |         grab wait_lock
> >         wait for wait_lock            |         wake all readers
> >                                       |         release wait_lock
> > 
> > ... At this point, sem->count > 0 and the wait list is empty,
> >     but down_read_failed() will sleep the reader.
> > 
> > In this case, CPU 0 has observed the sem count with the write lock (and
> > the other waiters) and so is detoured to down_read_failed(). But if 
> > CPU 0 can't grab the wait_lock before the up_write() does (via
> > rwsem_wake()), then down_read_failed() will wake no one and sleep the
> > reader.
> 
> Actually - down_read_failed() will insert the reader on the wait_list
> and do an atomic update(-read_bias). If there are no active lockers at
> the time of that atomic update, it calls __rwsem_do_wake() to unqueued
> the first queued waiter - which may well be itself.
> 
> In your specific example, __rwsem_do_wake() will wake the previously queued
> readers as well as current.

Hopefully my comments above make it clear that there are no queued
readers once CPU 0 can advance with the spin lock in down_read_failed().

> > Unfortunately, this means readers and writers which observe the sem
> > count after the adjustment is committed by CPU 0 in down_read_failed()
> > will sleep as well, until the sem count returns to 0.
> 
> Note that the active count does go back to 0 in your example.

No. The final semaphore value =

   wait bias + # of queued readers that were woken by CPU 1

The reader on CPU 0 is on the wait list.
(If you want I can toss together a simple simulation of what's going on
here and tack it in a reply).

> However, thinking about it made me consider the following case:
> 
> CPU 0               CPU 1                                   CPU 2
> 
> down_write()
> 
>                     down_read()
>                       local = atomic_update(+read_bias)
> 
> up_write()
> 
>                                                             down_read()
> 
>                       if (local <= 0)
>                         down_read_failed()
> 
> At this point CPU 0 doesn't hold the write lock anymore;
> CPU 2 grabbed a read lock;
> CPU 1 should grab an additional read lock but it won't - instead, it will
> queue itself (and get woken by CPU 2 when that read lock is released).
> 
> This is indeed slightly suboptimal. Could be fixed in an additional patch.

Exactly. As with my original example, a failed reader has observed the
count < 0 but by the time it can grab the spin lock the count may
actually be > 0, in which case the reader should early-out and not
sleep.

> As you mentioned, this is not any new issue caused by this patch series
> though - it's been there forever as far as I know.

Yeah, just to be clear. These issues are not caused by this series.

I brought them to your attention because I didn't see the problem until
you split the failed paths of reader and writer. Rather than fix the old
code, I thought it would be easier for maintainers if it went in as one
series, rather than a dependent patch following.

Regards,
Peter Hurley

