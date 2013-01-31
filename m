Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755050Ab3AaNiU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 08:38:20 -0500
Received: from mail-ve0-f178.google.com ([209.85.128.178]:63943 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484Ab3AaNiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 08:38:16 -0500
X-Greylist: delayed 131460 seconds by postgrey-1.27 at vger.kernel.org; Thu, 31 Jan 2013 08:38:16 EST
MIME-Version: 1.0
In-Reply-To: <CAF6AEGtH=RjmRjq0XuV345QG73a04xpD9V8JmxX_PO1v5awugg@mail.gmail.com>
References: <1358253244-11453-1-git-send-email-maarten.lankhorst@canonical.com>
	<1358253244-11453-3-git-send-email-maarten.lankhorst@canonical.com>
	<CAF6AEGv2XqJB49Q-6BUtU80qMZx9tXHuwTV0Ds6c7L1J+4xwBw@mail.gmail.com>
	<CAKMK7uGxbL=kZ1eeJYKVkCh0rz2gunmr8FBQWUNK5JsxMsjRgQ@mail.gmail.com>
	<CAF6AEGtH=RjmRjq0XuV345QG73a04xpD9V8JmxX_PO1v5awugg@mail.gmail.com>
Date: Thu, 31 Jan 2013 07:38:13 -0600
Message-ID: <CAF6AEGu=mS7yYJjALGoDVUnbMzf0KyJhBjwT8hMJ1E=z9bJDOw@mail.gmail.com>
Subject: Re: [PATCH 2/7] mutex: add support for reservation style locks
From: Rob Clark <robdclark@gmail.com>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: Maarten Lankhorst <m.b.lankhorst@gmail.com>,
        linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 30, 2013 at 5:52 AM, Rob Clark <robdclark@gmail.com> wrote:
> On Wed, Jan 30, 2013 at 5:08 AM, Daniel Vetter <daniel@ffwll.ch> wrote:
>> On Wed, Jan 30, 2013 at 2:07 AM, Rob Clark <robdclark@gmail.com> wrote:
>>> ==========================
>>> Basic problem statement:
>>> ----- ------- ---------
>>> GPU's do operations that commonly involve many buffers.  Those buffers
>>> can be shared across contexts/processes, exist in different memory
>>> domains (for example VRAM vs system memory), and so on.  And with
>>> PRIME / dmabuf, they can even be shared across devices.  So there are
>>> a handful of situations where the driver needs to wait for buffers to
>>> become ready.  If you think about this in terms of waiting on a buffer
>>> mutex for it to become available, this presents a problem because
>>> there is no way to guarantee that buffers appear in a execbuf/batch in
>>> the same order in all contexts.  That is directly under control of
>>> userspace, and a result of the sequence of GL calls that an
>>> application makes.  Which results in the potential for deadlock.  The
>>> problem gets more complex when you consider that the kernel may need
>>> to migrate the buffer(s) into VRAM before the GPU operates on the
>>> buffer(s), which main in turn require evicting some other buffers (and
>>> you don't want to evict other buffers which are already queued up to
>>> the GPU), but for a simplified understanding of the problem you can
>>> ignore this.
>>>
>>> The algorithm that TTM came up with for dealing with this problem is
>>> quite simple.  For each group of buffers (execbuf) that need to be
>>> locked, the caller would be assigned a unique reservation_id, from a
>>> global counter.  In case of deadlock in the process of locking all the
>>> buffers associated with a execbuf, the one with the lowest
>>> reservation_id wins, and the one with the higher reservation_id
>>> unlocks all of the buffers that it has already locked, and then tries
>>> again.
>>>
>>> Originally TTM implemented this algorithm on top of an event-queue and
>>> atomic-ops, but Maarten Lankhorst realized that by merging this with
>>> the mutex code we could take advantage of the existing mutex fast-path
>>> code and result in a simpler solution, and so ticket_mutex was born.
>>> (Well, there where also some additional complexities with the original
>>> implementation when you start adding in cross-device buffer sharing
>>> for PRIME.. Maarten could probably better explain.)
>>
>> I think the motivational writeup above is really nice, but the example
>> code below is a bit wrong
>>
>>> How it is used:
>>> --- -- -- -----
>>>
>>> A very simplified version:
>>>
>>>   int submit_execbuf(execbuf)
>>>   {
>>>       /* acquiring locks, before queuing up to GPU: */
>>>       seqno = assign_global_seqno();
>>>   retry:
>>>       for (buf in execbuf->buffers) {
>>>           ret = mutex_reserve_lock(&buf->lock, seqno);
>>>           switch (ret) {
>>>           case 0:
>>>               /* we got the lock */
>>>               break;
>>>           case -EAGAIN:
>>>               /* someone with a lower seqno, so unreserve and try again: */
>>>               for (buf2 in reverse order starting before buf in
>>> execbuf->buffers)
>>>                   mutex_unreserve_unlock(&buf2->lock);
>>>               goto retry;
>>>           default:
>>>               goto err;
>>>           }
>>>       }
>>>
>>>       /* now everything is good to go, submit job to GPU: */
>>>       ...
>>>   }
>>>
>>>   int finish_execbuf(execbuf)
>>>   {
>>>       /* when GPU is finished: */
>>>       for (buf in execbuf->buffers)
>>>           mutex_unreserve_unlock(&buf->lock);
>>>   }
>>> ==========================
>>
>> Since gpu command submission is all asnyc (hopefully at least) we
>> don't unlock once it completes, but right away after the commands are
>> submitted. Otherwise you wouldn't be able to submit new execbufs using
>> the same buffer objects (and besides, holding locks while going back
>> out to userspace is evil).
>
> right.. but I was trying to simplify the explanation for non-gpu
> folk.. maybe that was an over-simplification ;-)
>

Ok, a bit expanded version.. I meant to send this yesterday, but I forgot..

============================
Basic problem statement:
----- ------- ---------

GPU's do operations that commonly involve many buffers.  Those buffers
can be shared across contexts/processes, exist in different memory
domains (for example VRAM vs system memory), and so on.  And with
PRIME / dmabuf, they can even be shared across devices.  So there are
a handful of situations where the driver needs to wait for buffers to
become ready.  If you think about this in terms of waiting on a buffer
mutex for it to become available, this presents a problem because
there is no way to guarantee that buffers appear in a execbuf/batch in
the same order in all contexts.  That is directly under control of
userspace, and a result of the sequence of GL calls that an application
makes.  Which results in the potential for deadlock.  The problem gets
more complex when you consider that the kernel may need to migrate the
buffer(s) into VRAM before the GPU operates on the buffer(s), which
may in turn require evicting some other buffers (and you don't want to
evict other buffers which are already queued up to the GPU), but for a
simplified understanding of the problem you can ignore this.

The algorithm that TTM came up with for dealing with this problem is
quite simple.  For each group of buffers (execbuf) that need to be
locked, the caller would be assigned a unique reservation_id, from a
global counter.  In case of deadlock in the process of locking all the
buffers associated with a execbuf, the one with the lowest
reservation_id wins, and the one with the higher reservation_id
unlocks all of the buffers that it has already locked, and then tries
again.

Originally TTM implemented this algorithm on top of an event-queue and
atomic-ops, but Maarten Lankhorst realized that by merging this with
the mutex code we could take advantage of the existing mutex fast-path
code and result in a simpler solution, and so ticket_mutex was born.
(Well, there where also some additional complexities with the original
implementation when you start adding in cross-device buffer sharing
for PRIME.. Maarten could probably better explain.)


How it is used:
--- -- -- -----

A very simplified version:

    int lock_execbuf(execbuf)
    {
        struct buf *res_buf = NULL;

        /* acquiring locks, before queuing up to GPU: */
        seqno = assign_global_seqno();

    retry:
        for (buf in execbuf->buffers) {
            if (buf == res_buf) {
                res_buf = NULL;
                continue;
            }
            ret = mutex_reserve_lock(&buf->lock, seqno);
            if (ret < 0)
                goto err;
        }

        /* now everything is good to go, submit job to GPU: */
        ...

        return 0;

    err:
        for (all buf2 before buf in execbuf->buffers)
            mutex_unreserve_unlock(&buf2->lock);
        if (res_buf)
            mutex_unreserve_unlock(&res_buf->lock);

        if (ret == -EAGAIN) {
            /* we lost out in a seqno race, lock and retry.. */
            mutex_reserve_lock_slow(&buf->lock, seqno);
            res_buf = buf;
            goto retry;
        }

        return ret;
    }

    int unlock_execbuf(execbuf)
    {
        /* when GPU is finished; */
        for (buf in execbuf->buffers)
            mutex_unreserve_unlock(&buf->lock);
    }


What Really Happens:
---- ------ -------

(TODO maybe this should be Documentation/dma-fence-reservation.txt and
this file should just refer to it??  Well, we can shuffle things around
later..)

In real life, you want to keep the GPU operating asynchronously to the
CPU as much as possible, and not have to wait to queue up more work for
the GPU until the previous work is finished.  So in practice, you are
unlocking (unreserving) all the buffers once the execbuf is queued up
to the GPU.  The dma-buf fence objects, and the reservation code which
manages the fence objects (and is the primary user of ticket_mutex)
takes care of the synchronization of different buffer users from this
point.

If you really left the buffers locked until you got some irq back from
the GPU to let you know that the GPU was finished, then you would be
unable to queue up more rendering involving the same buffer(s), which
would be quite horrible for performance.

To just understand ticket_mutex, you can probably ignore this section.
If you want to make your driver share buffers with a GPU properly, then
you really need to be using reservation/fence, so you should read on.

NOTE: the reservation object and fence are split out from dma-buf so
      that a driver can use them both for it's own internal buffers
      and for imported dma-bufs, without having to create a dma-buf
      for every internal buffer.

For each rendering command queued up to the GPU, a fence object is
created. You can think of the fence as a sort of waitqueue, except that
(if it is supported by other devices waiting on the same buffer), it
can be used for hw->hw signaling, so that CPU involvement is not
required.  A fence object is a transient, one-use, object, with two
states.  Initially it is created un-signaled.  And later after the hw
is done with the operation, it becomes signaled.

(TODO probably should refer to a different .txt with more details
about fences, hw->hw vs hw->sw vs sw->sw signaling, etc)

The same fence is attached to the reservation_object of all buffers
involved in a rendering command.  In the fence_excl slot, if the buffer
is being written to, otherwise in one of the fence_shared slots.  (A
buffer can safely have many readers at once.)

If when preparing to submit the rendering command, a buffer has an un-
signaled exclusive fence attached, then there must be some way to wait
for that fence to become signaled before the hw uses that buffer.  In
the simple case, if that fence isn't one that the driver understands
how to instruct the hw to wait for, then it must call fence_wait() to
block until other devices have finished writing to the buffer.  But if
the driver has a way to instruct the hw to wait until the fence is
signaled, it can just emit commands to instruct the GPU to wait in
order to avoid blocking.

NOTE: in actuality, if the fence is created on the same ring, and you
      therefore know that it will be signaled by the earlier render
      command before the hw sees the current render command, then
      inserting fence cmds to the hw can be skipped.

============================

It made me realize we also need some docs about fence/reservation..
not sure if I'll get a chance before fosdem, but I can take a stab at
that too

BR,
-R
