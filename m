Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933516Ab3CNCBO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 22:01:14 -0400
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:39960 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932565Ab3CNCBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 22:01:13 -0400
Message-ID: <1363226451.25976.170.camel@thor.lan>
Subject: Re: [PATCH 11/12] rwsem: wake all readers when first waiter is a
 reader
From: Peter Hurley <peter@hurleysoftware.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Michel Lespinasse <walken@google.com>, Alex Shi <alex.shi@intel.com>,
        Ingo Molnar <mingo@kernel.org>, David Howells <dhowells@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Date: Wed, 13 Mar 2013 22:00:51 -0400
In-Reply-To: <20130313032334.GU21651@dastard>
References: <1362612111-28673-1-git-send-email-walken@google.com>
	 <1362612111-28673-12-git-send-email-walken@google.com>
	 <20130309003221.GE23616@dastard>
	 <CANN689F9Zy=cTdi3D4d4iw66eeGLTtpudmAJgxYHGgDUsNU2Mg@mail.gmail.com>
	 <20130311001650.GB20565@dastard>
	 <CANN689FF+fjphwNqRz_ixpo4hW-rkXq6fbmJf7xDacBbP48BXw@mail.gmail.com>
	 <20130312023658.GH21651@dastard>
	 <CANN689Hu4S6hQaZ0tytNuToCpwtdJmyisyqyrDrNK+buJXTsKA@mail.gmail.com>
	 <20130313032334.GU21651@dastard>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-0pjh1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-03-13 at 14:23 +1100, Dave Chinner wrote:
> On Mon, Mar 11, 2013 at 11:43:34PM -0700, Michel Lespinasse wrote:
> > Hi Dave,
> > 
> > On Mon, Mar 11, 2013 at 7:36 PM, Dave Chinner <david@fromorbit.com> wrote:
> > > On Sun, Mar 10, 2013 at 10:17:42PM -0700, Michel Lespinasse wrote:
> > >> - since all readers are woken at once, you might see burst of direct
> > >> IO operations followed by bursts of truncate operations, instead of
> > >> having them interleaved in smaller groups as before.
> > >
> > > And this will result in the same application IO pattern giving
> > > vastly different results. e.g. a read IO promoted ahead of a
> > > truncate will now return data instead of -1 (beyond EOF).
> > 
> > I will reply to this part first, as I think this gives a more concrete
> > anchor to the discussion.
> > 
> > The crucial point is that the truncate system call hasn't completed
> > yet - that thread is still queued in the rwsem.
> > 
> > You still have the guarantee that the truncate will complete
> > eventually (even if there is a never-ending stream of IOs), and that
> > all IO system calls that start after the truncate system call
> > completes will see the file as truncated.
> 
> Sure, but the problem is not about when the syscall completes - the
> problem is that you are changing where in the pipeline of IO the
> truncate is initially executed.  i.e. ordering is not defined by
> when an operation completes, but by the order ing which the queue is
> processed after a blocking operation completes. That is not when the
> syscall completes, but when the filesystem drops the exclusive lock.
> 
> From a single threaded userspace application perspective or
> multithreaded apps with their own userspace locking, truncates
> complete when either the syscall completes or some time after when
> the application drops it's lock. Either way, we're looking at
> completion time serialisation, and in that case what XFS or the
> kernel does simply doesn't matter.
> 
> However, if we are talking about userspace applications that use
> lockless IO algorithms or kernel side applications (like knfsd) that
> are exposed directly to the filesystem locking semantics,
> serialisation behaviour is actually defined by filesystem's
> submission side locking behaviour. There is no external
> serialisation of IO completion, so serialisation and ordering is
> defined (for XFS) solely by the rwsem behaviour.
> 
> > You don't have guarantees about which system call will "appear to run
> > before the other" if the execution times of the two system calls
> > overlap each other, but you actually never had such a guarantee from a
> > correctness perspective (i.e. you could never guarantee which of the
> > two would get queued on the rwsem ahead of the other).
> 
> Sure, but as long as the submission side ordering is deterministic,
> it doesn't matter.
> 
> > > Ok, so I can see where your latency figure comes from, but it's
> > > still a change of ordering in that W2 is no longer a barrier to the
> > > reads queued after it.
> > 
> > My claim is that it's not a visible change from a correctness
> > perspective
> 
> I am not arguing that it is incorrect. I'm arguing that the change
> of ordering semantics breaks assumptions a lot of code makes about
> how these locks work.
> 
> > > similar to this:
> > >
> > >         W1R1W2R2W3R3.....WnRm
> > >
> > > By my reading of the algorithm you are proposing, after W1 is
> > > released, we end up with the queue being treated like this:
> > >
> > >         R1R2R3....RmW2W3....Wn
> > >
> > > Right?
> > 
> > Yes, if what you are representing is the state of the queue at a given
> > point of time (which implies R1..Rm must be distinct threads, not just
> > the same thread doing repeated requests).
> 
> Yup, that's very typical.
> 
> > As new requests come in over time, one important point to remember is
> > that each writer will see at most one batch of readers wake up ahead
> > of it (though this batch may include readers that were originally
> > queued both before and after it).
> 
> And that's *exactly* the problem with the changes you are proposing
> - rwsems will no longer provide strongly ordered write vs read
> barrier semantics.
> 
> > I find the name 'barrier' actually confusing when used to describe
> > synchronous operations.  To me a barrier is usualy between
> > asynchronous operations, and it is well defined which operations
> > are ahead or behind of the barrier (either because they were
> > queued by the same thread, or they were queued by different
> > threads which may have synchronized together some other way).
> 
> When you have hundreds or thousands of threads doing IO to the one
> file, it doesn't matter if the IO is issued synchronously or
> asynchronously by the threads - you simply have a huge amount of
> data IO concurrency and very, very deep pipelines.
> 
> Inserting a metadata modification (truncate, preallocation,
> holepunch, etc) into that pipeline currently causes all new
> submissions to queue behind the metadata modification, waits for
> everything submitted before the metadata modification to complete
> and then runs the metadata modification. Once it completes, it then
> allows everything queued up to the next metadata modification to
> run....
> 
> That matches your definition of a barrier pretty well, I think.
> 
> > But in this case, we have two
> > synchronous operations with overlapping execution times - they don't
> > have a way to know which one is 'supposed to' be ahead of the other.
> > The two threads can't observe their relative ordering since they are
> > blocked during the operation...
> 
> We don't care about the ordering between multiple concurrent
> metadata modifications - what matters is whether the ongoing data IO
> around them is ordered correctly.

Dave,

The point that Michel is making is that there never was any ordering
guarantee by rwsem. It's an illusion.

The reason is simple: to even get to the lock the cpu has to be
sleep-able. So for every submission that you believe is ordered, is by
its very nature __not ordered__, even when used by kernel code.

Why? Because any thread on its way to claim the lock (reader or writer)
could be pre-empted for some other task, thus delaying the submission of
whatever i/o you believed to be ordered.

So just to reiterate: there is no 'queue' and no 'barrier'. The
guarantees that rwsem makes are;
1. Multiple readers can own the lock.
2. Only a single writer can own the lock.
3. Readers will not starve writers.


> On Tue, 2013-03-12 at 13:36 +1100, Dave Chinner wrote:
> > On Sun, Mar 10, 2013 at 10:17:42PM -0700, Michel Lespinasse wrote:
> > - since all readers are woken at once, you might see burst of direct
> > IO operations followed by bursts of truncate operations, instead of
> > having them interleaved in smaller groups as before.
> 
> And this will result in the same application IO pattern giving
> vastly different results. e.g. a read IO promoted ahead of a
> truncate will now return data instead of -1 (beyond EOF).

The 'same application IO pattern' will give you 'vastly different
results' with the __current__ implementation for any given
machine/day/time/run. The reason is that you cannot control which cpu
submits which IO, and is delayed because it's busy handling which
network interrupt, etc.

Where lock policy can have a significant impact is on performance. But
predicting that impact is difficult -- it's better just to measure.

It's not my intention to convince you (or anyone else) that there should
only be One True Rwsem, because I don't believe that. But I didn't want
the impression to persist that rwsem does anything more than implement a
fair reader/writer semaphore.

Regards,
Peter Hurley

