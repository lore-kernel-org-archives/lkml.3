Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731Ab3CNHDJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 03:03:09 -0400
Received: from mail-da0-f48.google.com ([209.85.210.48]:60782 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648Ab3CNHDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 03:03:07 -0400
Date: Thu, 14 Mar 2013 00:03:03 -0700
From: Michel Lespinasse <walken@google.com>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Alex Shi <alex.shi@intel.com>, Ingo Molnar <mingo@kernel.org>,
        David Howells <dhowells@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/12] rwsem: wake all readers when first waiter is a
 reader
Message-ID: <20130314070303.GA10956@google.com>
References: <1362612111-28673-1-git-send-email-walken@google.com>
 <1362612111-28673-12-git-send-email-walken@google.com>
 <1363034207.27803.8.camel@thor.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363034207.27803.8.camel@thor.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 04:36:47PM -0400, Peter Hurley wrote:
> 
> On Wed, 2013-03-06 at 15:21 -0800, Michel Lespinasse wrote:
> > + retry_reader_grants:
> > +	oldcount = rwsem_atomic_update(adjustment, sem) - adjustment;
> > +	if (unlikely(oldcount < RWSEM_WAITING_BIAS)) {
> > +		/* A writer stole the lock.  Undo our reader grants. */
> > +		if (rwsem_atomic_update(-adjustment, sem) < RWSEM_WAITING_BIAS)
> > +			goto out;
> > +		/* The writer left.  Retry waking readers. */
> > +		goto retry_reader_grants;
> > +	}
> 
> This can be reduced to single looping cmpxchg in the grant reversal
> path; then if reversing the grant fails, the count can simply be
> re-tested for grant success, rather than trying to atomically re-grant.
> For example, with a helper function, rwsem_cmpxchg():
> 
> static inline int rwsem_cmpxchg(long *old, long new, struct rw_semaphore *sem)
> {
> 	long tmp = *old;
> 	*old = cmpxchg(&sem->count, *old, new);
> 	return tmp == *old;
> }
> 
> ... then above becomes ...
> 
> 	count = rwsem_atomic_update(adjustment, sem);
> 	do {
> 		if (count - adjustment >= RWSEM_WAITING_BIAS)
> 			break;
> 		if (rwsem_cmpxchg(&count, count - adjustment, sem))
> 			goto out;   /* or simply return sem */
> 	} while (1);
> 
> 	< wake up readers >

This would work, but I don't see a benefit as we still end up with a
retry loop. Also, the loop would have to retry whenever the counter
value changed instead of only when writer(s) appear or are removed.

> Also, this series and the original rwsem can mistakenly sleep reader(s)
> when the lock is transitioned from writer-owned to waiting readers-owned
> with no waiting writers. For example,
> 
> 
>   CPU 0                               |  CPU 1
>                                       |
>                                       | down_write()
> 
> ... CPU 1 has the write lock for the semaphore.
>     Meanwhile, 1 or more down_read(s) are attempted and fail;
>     these are put on the wait list.

I'm not sure of the relevance of these other down_read() calls -
please note that as these extra readers are put on the wait list,
their +read_bias adjustments are canceled so that the count value
ends up at write_bias + waiting_bias (for a total active count of 1)

> Then ...
> 
> down_read()                           | up_write()
>   local = atomic_update(+read_bias)   |
>   local <= 0?                         |   local = atomic_update(-write_bias)
>   if (true)                           |   local < 0?
>      down_read_failed()               |   if (true)
>                                       |      wake()
>                                       |         grab wait_lock
>         wait for wait_lock            |         wake all readers
>                                       |         release wait_lock
> 
> ... At this point, sem->count > 0 and the wait list is empty,
>     but down_read_failed() will sleep the reader.
> 
> In this case, CPU 0 has observed the sem count with the write lock (and
> the other waiters) and so is detoured to down_read_failed(). But if 
> CPU 0 can't grab the wait_lock before the up_write() does (via
> rwsem_wake()), then down_read_failed() will wake no one and sleep the
> reader.

Actually - down_read_failed() will insert the reader on the wait_list
and do an atomic update(-read_bias). If there are no active lockers at
the time of that atomic update, it calls __rwsem_do_wake() to unqueued
the first queued waiter - which may well be itself.

In your specific example, __rwsem_do_wake() will wake the previously queued
readers as well as current.

> Unfortunately, this means readers and writers which observe the sem
> count after the adjustment is committed by CPU 0 in down_read_failed()
> will sleep as well, until the sem count returns to 0.

Note that the active count does go back to 0 in your example.

However, thinking about it made me consider the following case:

CPU 0               CPU 1                                   CPU 2

down_write()

                    down_read()
                      local = atomic_update(+read_bias)

up_write()

                                                            down_read()

                      if (local <= 0)
                        down_read_failed()

At this point CPU 0 doesn't hold the write lock anymore;
CPU 2 grabbed a read lock;
CPU 1 should grab an additional read lock but it won't - instead, it will
queue itself (and get woken by CPU 2 when that read lock is released).

This is indeed slightly suboptimal. Could be fixed in an additional patch.

As you mentioned, this is not any new issue caused by this patch series
though - it's been there forever as far as I know.

Thanks,

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
