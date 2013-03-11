Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418Ab3CKAQ4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 20:16:56 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:17091 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753259Ab3CKAQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 20:16:54 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtgeAIMhPVF5LaFk/2dsb2JhbABDhzO3eoUWAQIBgUwXdIImAQEEAScTHCMFCwgDDgoJJQ8FJQMhE4gNBbt5FY14GB9KB4JfYQOTEINEkHaDHig
Date: Mon, 11 Mar 2013 11:16:50 +1100
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
Message-ID: <20130311001650.GB20565@dastard>
References: <1362612111-28673-1-git-send-email-walken@google.com>
 <1362612111-28673-12-git-send-email-walken@google.com>
 <20130309003221.GE23616@dastard>
 <CANN689F9Zy=cTdi3D4d4iw66eeGLTtpudmAJgxYHGgDUsNU2Mg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANN689F9Zy=cTdi3D4d4iw66eeGLTtpudmAJgxYHGgDUsNU2Mg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 08, 2013 at 05:20:34PM -0800, Michel Lespinasse wrote:
> On Fri, Mar 8, 2013 at 4:32 PM, Dave Chinner <david@fromorbit.com> wrote:
> > On Wed, Mar 06, 2013 at 03:21:50PM -0800, Michel Lespinasse wrote:
> >> When the first queued waiter is a reader, wake all readers instead of
> >> just those that are at the front of the queue. There are really two
> >> motivations for this change:
> >
> > Isn't this a significant change of semantics for the rwsem? i.e.
> > that read lock requests that come after a write lock request now
> > jump ahead of the write lock request? i.e.the write lock request is
> > no longer a barrier in the queue?
> 
> Yes, I am allowing readers to skip ahead of writers in the queue (but
> only if they can run with another reader that was already ahead).
> 
> I don't see that this is a change of observable semantics for correct
> programs. If a reader and a writer both block on the rwsem, how do you
> known for sure which one got queued first ? rwsem API doesn't give you
> any easy way to know whether a thread is currently queued on the rwsem
> (it could also be descheduled before it gets onto the rwsem queue).

There are algorithms that rely on write locks to act as read-side
barriers to prevent write side starvation. i.e. if you keep queuing
up read locks, the writer never gets the lock, thereby starving the
writer.

> But yes, if you're making assumptions about queuing order the change
> makes it more likely that they'll be observably wrong.
> 
> > XFS has long assumed that a rwsem write lock is a barrier that
> > stops new read locks from being taken, and this change will break
> > that assumption. Given that this barrier assumption is used as the
> > basis for serialisation of operations like IO vs truncate, there's a
> > bit more at stake than just improving parallelism here.  i.e. IO
> > issued after truncate/preallocate/hole punch could now be issued
> > ahead of the pending metadata operation, whereas currently the IO
> > issued after the pending metadata operation is waiting for the write
> > lock will be only be processed -after- the metadata modification
> > operation completes...
> >
> > That is a recipe for weird data corruption problems because
> > applications are likely to have implicit dependencies on the barrier
> > effect of metadata operations on data IO...
> 
> I am confused as to exactly what XFS is doing, could you point me to
> the code / indicate a scenario where this would go wrong ? If you
> really rely on this for correctness you'd have to do something already
> to guarantee that your original queueing order is as desired, and I
> just don't see how it'd be done...

My point isn't that XFS gets the serialisation wrong - my point is
that the change of queuing order will change the userspace visible
behaviour of the filesystem *significantly*.

For example: - direct IO only takes read locks, while truncate takes
a write lock.  Right now we can drop a truncate, preallocation or
hole punch operation into a stream of concurrent direct IO and have
it execute almost immediately - the barrier mechanism in the rwsem
ensures that it will be executed ahead of any future IO that is
issued by the application. With your proposed change, that operation
won't take place until all current *and all future* IOs stop and the
read lock is no longer held by anyone.

To put this in context, here's the Irix XFS iolock initialisation
code from mid 1997, where the barrier semantics are first explicitly
documented:

	mrlock_init(&ip->i_iolock, MRLOCK_BARRIER, "xfsio", (long)vp->v_number);

It was only coded like this in 1997, because the Irix multi-reader
lock only grew read-side queue jumping and priority inheritence at
this time. This changed the default behaviour from write lock
barrier semantics to something similar to what you are proposing for
rwsems right now. All the locks that relied on barrier semantics of
write locks had to be configured explicitly to have that behaviour
rather than implicitly relying on the fact that mrlocks had provided
write barrier semantics.

So, that's my concern - we've got 20 years of algorithms in XFS
designed around rwsem write locks providing read-side barriers, and
it's been down this road once before (over 15 years ago).  Changing
the semantics of rwsems is going to break stuff in subtle and
unpredictable ways....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
