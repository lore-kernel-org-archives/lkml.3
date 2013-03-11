Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751857Ab3CKFRp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 01:17:45 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:64142 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952Ab3CKFRn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 01:17:43 -0400
MIME-Version: 1.0
In-Reply-To: <20130311001650.GB20565@dastard>
References: <1362612111-28673-1-git-send-email-walken@google.com>
	<1362612111-28673-12-git-send-email-walken@google.com>
	<20130309003221.GE23616@dastard>
	<CANN689F9Zy=cTdi3D4d4iw66eeGLTtpudmAJgxYHGgDUsNU2Mg@mail.gmail.com>
	<20130311001650.GB20565@dastard>
Date: Sun, 10 Mar 2013 22:17:42 -0700
Message-ID: <CANN689FF+fjphwNqRz_ixpo4hW-rkXq6fbmJf7xDacBbP48BXw@mail.gmail.com>
Subject: Re: [PATCH 11/12] rwsem: wake all readers when first waiter is a reader
From: Michel Lespinasse <walken@google.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Alex Shi <alex.shi@intel.com>, Ingo Molnar <mingo@kernel.org>,
        David Howells <dhowells@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 10, 2013 at 5:16 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Fri, Mar 08, 2013 at 05:20:34PM -0800, Michel Lespinasse wrote:
>> On Fri, Mar 8, 2013 at 4:32 PM, Dave Chinner <david@fromorbit.com> wrote:
>> > Isn't this a significant change of semantics for the rwsem? i.e.
>> > that read lock requests that come after a write lock request now
>> > jump ahead of the write lock request? i.e.the write lock request is
>> > no longer a barrier in the queue?
>>
>> Yes, I am allowing readers to skip ahead of writers in the queue (but
>> only if they can run with another reader that was already ahead).
>>
>> I don't see that this is a change of observable semantics for correct
>> programs. If a reader and a writer both block on the rwsem, how do you
>> known for sure which one got queued first ? rwsem API doesn't give you
>> any easy way to know whether a thread is currently queued on the rwsem
>> (it could also be descheduled before it gets onto the rwsem queue).
>
> There are algorithms that rely on write locks to act as read-side
> barriers to prevent write side starvation. i.e. if you keep queuing
> up read locks, the writer never gets the lock, thereby starving the
> writer.

What I propose actually isn't as bad as a reader preference rwlock
like rwlock_t. When a reader makes it to the head of the queue, all
readers gets woken. At that point there are only writers left in the
queue, and new readers will get queued after them and won't be able to
skip over them (since they have no earlier reader to join up with).
So, I am not throwing reader/writer fairness out the window here.

>> > XFS has long assumed that a rwsem write lock is a barrier that
>> > stops new read locks from being taken, and this change will break
>> > that assumption. Given that this barrier assumption is used as the
>> > basis for serialisation of operations like IO vs truncate, there's a
>> > bit more at stake than just improving parallelism here.  i.e. IO
>> > issued after truncate/preallocate/hole punch could now be issued
>> > ahead of the pending metadata operation, whereas currently the IO
>> > issued after the pending metadata operation is waiting for the write
>> > lock will be only be processed -after- the metadata modification
>> > operation completes...
>> >
>> > That is a recipe for weird data corruption problems because
>> > applications are likely to have implicit dependencies on the barrier
>> > effect of metadata operations on data IO...
>>
>> I am confused as to exactly what XFS is doing, could you point me to
>> the code / indicate a scenario where this would go wrong ? If you
>> really rely on this for correctness you'd have to do something already
>> to guarantee that your original queueing order is as desired, and I
>> just don't see how it'd be done...
>
> My point isn't that XFS gets the serialisation wrong - my point is
> that the change of queuing order will change the userspace visible
> behaviour of the filesystem *significantly*.
>
> For example: - direct IO only takes read locks, while truncate takes
> a write lock.  Right now we can drop a truncate, preallocation or
> hole punch operation into a stream of concurrent direct IO and have
> it execute almost immediately - the barrier mechanism in the rwsem
> ensures that it will be executed ahead of any future IO that is
> issued by the application. With your proposed change, that operation
> won't take place until all current *and all future* IOs stop and the
> read lock is no longer held by anyone.

You actually wouldn't get such starvation with my proposal.

What you might see would be:

- Assuming you have up to N concurrent reads in progress, a writer
might see up to 2N-1 readers proceed in front of it. This limit is
reached if you first had N-1 readers grabbing the rwsem with an empty
queue, then another writer W1 got queued, then a reader RN (note that
it will get queued after W1 and not run concurrently with the existing
N-1 readers), then our writer W2 gets queued. As our N-1 readers
complete their IO operations, they might get queued again after W2,
and then skip ahead of W2 when RN reaches the front of the queue. So,
W2 is still guaranteed to run eventually, but with a worst case
latency that is ~2x worse than before

- since all readers are woken at once, you might see burst of direct
IO operations followed by bursts of truncate operations, instead of
having them interleaved in smaller groups as before.

I'm not sure if these characteristics are good enough for the XFS use
case. It seems tougher than many rwsem use cases, since the benefits
of increased reader parallelism are not as clear here (i.e. the IO
operations still have to hit disk so you don't get much further
benefit if you already had more IO parallelism than platters). So if
this explanation still didn't made you comfortable with the proposal,
I will rework it to avoid the queue reordering.

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
