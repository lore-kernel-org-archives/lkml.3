Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932106Ab3CLChF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 22:37:05 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:17293 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752714Ab3CLChD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 22:37:03 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqodADOTPlF5LKiV/2dsb2JhbABDv0yFFgECAYFeF3SCKQEBBAE6FAgjBQsIAw4KCSUPBR0IAyEICwkUBIdsBQ2vXpAdFY1CATUYH0oHg0ADkxCDRIEfikGFFoMeKIEuAR8
Date: Tue, 12 Mar 2013 13:36:58 +1100
From: Dave Chinner <david@fromorbit.com>
To: Michel Lespinasse <walken@google.com>
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
Message-ID: <20130312023658.GH21651@dastard>
References: <1362612111-28673-1-git-send-email-walken@google.com>
 <1362612111-28673-12-git-send-email-walken@google.com>
 <20130309003221.GE23616@dastard>
 <CANN689F9Zy=cTdi3D4d4iw66eeGLTtpudmAJgxYHGgDUsNU2Mg@mail.gmail.com>
 <20130311001650.GB20565@dastard>
 <CANN689FF+fjphwNqRz_ixpo4hW-rkXq6fbmJf7xDacBbP48BXw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANN689FF+fjphwNqRz_ixpo4hW-rkXq6fbmJf7xDacBbP48BXw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 10, 2013 at 10:17:42PM -0700, Michel Lespinasse wrote:
> On Sun, Mar 10, 2013 at 5:16 PM, Dave Chinner <david@fromorbit.com> wrote:
> > On Fri, Mar 08, 2013 at 05:20:34PM -0800, Michel Lespinasse wrote:
> >> On Fri, Mar 8, 2013 at 4:32 PM, Dave Chinner <david@fromorbit.com> wrote:
> >> > Isn't this a significant change of semantics for the rwsem? i.e.
> >> > that read lock requests that come after a write lock request now
> >> > jump ahead of the write lock request? i.e.the write lock request is
> >> > no longer a barrier in the queue?
> >>
> >> Yes, I am allowing readers to skip ahead of writers in the queue (but
> >> only if they can run with another reader that was already ahead).
> >>
> >> I don't see that this is a change of observable semantics for correct
> >> programs. If a reader and a writer both block on the rwsem, how do you
> >> known for sure which one got queued first ? rwsem API doesn't give you
> >> any easy way to know whether a thread is currently queued on the rwsem
> >> (it could also be descheduled before it gets onto the rwsem queue).
> >
> > There are algorithms that rely on write locks to act as read-side
> > barriers to prevent write side starvation. i.e. if you keep queuing
> > up read locks, the writer never gets the lock, thereby starving the
> > writer.
> 
> What I propose actually isn't as bad as a reader preference rwlock
> like rwlock_t. When a reader makes it to the head of the queue, all
> readers gets woken. At that point there are only writers left in the
> queue, and new readers will get queued after them and won't be able to
> skip over them (since they have no earlier reader to join up with).
> So, I am not throwing reader/writer fairness out the window here.

OK, but....

> > My point isn't that XFS gets the serialisation wrong - my point is
> > that the change of queuing order will change the userspace visible
> > behaviour of the filesystem *significantly*.
> >
> > For example: - direct IO only takes read locks, while truncate takes
> > a write lock.  Right now we can drop a truncate, preallocation or
> > hole punch operation into a stream of concurrent direct IO and have
> > it execute almost immediately - the barrier mechanism in the rwsem
> > ensures that it will be executed ahead of any future IO that is
> > issued by the application. With your proposed change, that operation
> > won't take place until all current *and all future* IOs stop and the
> > read lock is no longer held by anyone.
> 
> You actually wouldn't get such starvation with my proposal.
> 
> What you might see would be:
> 
> - Assuming you have up to N concurrent reads in progress, a writer
> might see up to 2N-1 readers proceed in front of it. This limit is
> reached if you first had N-1 readers grabbing the rwsem with an empty
> queue, then another writer W1 got queued,

So something like

	RRRRRRRRRRRRRW1

> then a reader RN (note that
> it will get queued after W1 and not run concurrently with the existing
> N-1 readers), then our writer W2 gets queued.

So:

	RRRRRRRRRRRRRW1rrrrrrrrrrrrW2
>
> As our N-1 readers
> complete their IO operations, they might get queued again after W2,

So:
	W1rrrrrrrrrrrrW2RRRRRRRRRRRRR

> and then skip ahead of W2 when RN reaches the front of the queue. So,
> W2 is still guaranteed to run eventually, but with a worst case
> latency that is ~2x worse than before

So, when W1 is released, the queue is treated as though it was:

	rrrrrrrrrrrrRRRRRRRRRRRRRW2

yes? Ok, so I can see where your latency figure comes from, but it's
still a change of ordering in that W2 is no longer a barrier to the
reads queued after it.

And if we extend that to WN, we have an interleaved queue
similar to this:

	W1R1W2R2W3R3.....WnRm

By my reading of the algorithm you are proposing, after W1 is
released, we end up with the queue being treated like this:

	R1R2R3....RmW2W3....Wn

Right?

If so, that is definitely a change of lock ordering semantics -
writes do not have barrier properties anymore.

> - since all readers are woken at once, you might see burst of direct
> IO operations followed by bursts of truncate operations, instead of
> having them interleaved in smaller groups as before.

And this will result in the same application IO pattern giving
vastly different results. e.g. a read IO promoted ahead of a
truncate will now return data instead of -1 (beyond EOF).

> I'm not sure if these characteristics are good enough for the XFS use
> case. It seems tougher than many rwsem use cases, since the benefits
> of increased reader parallelism are not as clear here (i.e. the IO

Well defined, predictable, deterministc ordering of operations takes
far more precedence over parallelism when it comes to filesystem
behaviour. The rwsems already have enough parallelism to allow us to
drive more than 2 million 4k IOPS to a single file via
multi-threaded direct IO(*), so we aren't limited by parallelism and
concurrency in rwsems.

> So if
> this explanation still didn't made you comfortable with the proposal,
> I will rework it to avoid the queue reordering.

Not really, but I'm still not sure I fully understand the different
queuing/queue jumping semantics fully....

Cheers,

Dave.
> 
> -- 
> Michel "Walken" Lespinasse
> A program is never fully debugged until the last user dies.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> -- 
> This message has been scanned for viruses and
> dangerous content by MailScanner, and is
> believed to be clean.
> 
> 

-- 
Dave Chinner
david@fromorbit.com
