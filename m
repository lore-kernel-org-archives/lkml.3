Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755072Ab3CLGnh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 02:43:37 -0400
Received: from mail-ia0-f179.google.com ([209.85.210.179]:34500 "EHLO
	mail-ia0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752594Ab3CLGnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 02:43:35 -0400
MIME-Version: 1.0
In-Reply-To: <20130312023658.GH21651@dastard>
References: <1362612111-28673-1-git-send-email-walken@google.com>
	<1362612111-28673-12-git-send-email-walken@google.com>
	<20130309003221.GE23616@dastard>
	<CANN689F9Zy=cTdi3D4d4iw66eeGLTtpudmAJgxYHGgDUsNU2Mg@mail.gmail.com>
	<20130311001650.GB20565@dastard>
	<CANN689FF+fjphwNqRz_ixpo4hW-rkXq6fbmJf7xDacBbP48BXw@mail.gmail.com>
	<20130312023658.GH21651@dastard>
Date: Mon, 11 Mar 2013 23:43:34 -0700
Message-ID: <CANN689Hu4S6hQaZ0tytNuToCpwtdJmyisyqyrDrNK+buJXTsKA@mail.gmail.com>
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

Hi Dave,

On Mon, Mar 11, 2013 at 7:36 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Sun, Mar 10, 2013 at 10:17:42PM -0700, Michel Lespinasse wrote:
>> - since all readers are woken at once, you might see burst of direct
>> IO operations followed by bursts of truncate operations, instead of
>> having them interleaved in smaller groups as before.
>
> And this will result in the same application IO pattern giving
> vastly different results. e.g. a read IO promoted ahead of a
> truncate will now return data instead of -1 (beyond EOF).

I will reply to this part first, as I think this gives a more concrete
anchor to the discussion.

The crucial point is that the truncate system call hasn't completed
yet - that thread is still queued in the rwsem.

You still have the guarantee that the truncate will complete
eventually (even if there is a never-ending stream of IOs), and that
all IO system calls that start after the truncate system call
completes will see the file as truncated.

You don't have guarantees about which system call will "appear to run
before the other" if the execution times of the two system calls
overlap each other, but you actually never had such a guarantee from a
correctness perspective (i.e. you could never guarantee which of the
two would get queued on the rwsem ahead of the other).

> So:
>
>         RRRRRRRRRRRRRW1rrrrrrrrrrrrW2
>>
>> As our N-1 readers
>> complete their IO operations, they might get queued again after W2,
>
> So:
>         W1rrrrrrrrrrrrW2RRRRRRRRRRRRR
>
>> and then skip ahead of W2 when RN reaches the front of the queue. So,
>> W2 is still guaranteed to run eventually, but with a worst case
>> latency that is ~2x worse than before
>
> So, when W1 is released, the queue is treated as though it was:
>
>         rrrrrrrrrrrrRRRRRRRRRRRRRW2
>
> yes?

Yes.

> Ok, so I can see where your latency figure comes from, but it's
> still a change of ordering in that W2 is no longer a barrier to the
> reads queued after it.

My claim is that it's not a visible change from a correctness
perspective - if the extra readers R are submitted before W2 completes
then they can't assume their execution order vs W2. From a correctness
perspective, the outcome won't look any different as if W2's thread
had been delayed right before entering the truncate system call.

Now from a performance point of view, I concede there IS a difference
as this will happen more often than before. But from a correctness
point of view, this is not a new possible outcome - it was already
possible before.

> And if we extend that to WN, we have an interleaved queue
> similar to this:
>
>         W1R1W2R2W3R3.....WnRm
>
> By my reading of the algorithm you are proposing, after W1 is
> released, we end up with the queue being treated like this:
>
>         R1R2R3....RmW2W3....Wn
>
> Right?

Yes, if what you are representing is the state of the queue at a given
point of time (which implies R1..Rm must be distinct threads, not just
the same thread doing repeated requests).

As new requests come in over time, one important point to remember is
that each writer will see at most one batch of readers wake up ahead
of it (though this batch may include readers that were originally
queued both before and after it). This guarantees that the writer
won't get starved / will get its turn running eventually.

> If so, that is definitely a change of lock ordering semantics -
> writes do not have barrier properties anymore.

I find the name 'barrier' actually confusing when used to describe
synchronous operations. To me a barrier is usualy between asynchronous
operations, and it is well defined which operations are ahead or
behind of the barrier (either because they were queued by the same
thread, or they were queued by different threads which may have
synchronized together some other way). But in this case, we have two
synchronous operations with overlapping execution times - they don't
have a way to know which one is 'supposed to' be ahead of the other.
The two threads can't observe their relative ordering since they are
blocked during the operation...

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
