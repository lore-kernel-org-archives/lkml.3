Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751945Ab3A3LwZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 06:52:25 -0500
Received: from mail-ia0-f177.google.com ([209.85.210.177]:39250 "EHLO
	mail-ia0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104Ab3A3LwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 06:52:22 -0500
MIME-Version: 1.0
In-Reply-To: <CAKMK7uGxbL=kZ1eeJYKVkCh0rz2gunmr8FBQWUNK5JsxMsjRgQ@mail.gmail.com>
References: <1358253244-11453-1-git-send-email-maarten.lankhorst@canonical.com>
	<1358253244-11453-3-git-send-email-maarten.lankhorst@canonical.com>
	<CAF6AEGv2XqJB49Q-6BUtU80qMZx9tXHuwTV0Ds6c7L1J+4xwBw@mail.gmail.com>
	<CAKMK7uGxbL=kZ1eeJYKVkCh0rz2gunmr8FBQWUNK5JsxMsjRgQ@mail.gmail.com>
Date: Wed, 30 Jan 2013 05:52:21 -0600
Message-ID: <CAF6AEGtH=RjmRjq0XuV345QG73a04xpD9V8JmxX_PO1v5awugg@mail.gmail.com>
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

On Wed, Jan 30, 2013 at 5:08 AM, Daniel Vetter <daniel@ffwll.ch> wrote:
> On Wed, Jan 30, 2013 at 2:07 AM, Rob Clark <robdclark@gmail.com> wrote:
>> ==========================
>> Basic problem statement:
>> ----- ------- ---------
>> GPU's do operations that commonly involve many buffers.  Those buffers
>> can be shared across contexts/processes, exist in different memory
>> domains (for example VRAM vs system memory), and so on.  And with
>> PRIME / dmabuf, they can even be shared across devices.  So there are
>> a handful of situations where the driver needs to wait for buffers to
>> become ready.  If you think about this in terms of waiting on a buffer
>> mutex for it to become available, this presents a problem because
>> there is no way to guarantee that buffers appear in a execbuf/batch in
>> the same order in all contexts.  That is directly under control of
>> userspace, and a result of the sequence of GL calls that an
>> application makes.  Which results in the potential for deadlock.  The
>> problem gets more complex when you consider that the kernel may need
>> to migrate the buffer(s) into VRAM before the GPU operates on the
>> buffer(s), which main in turn require evicting some other buffers (and
>> you don't want to evict other buffers which are already queued up to
>> the GPU), but for a simplified understanding of the problem you can
>> ignore this.
>>
>> The algorithm that TTM came up with for dealing with this problem is
>> quite simple.  For each group of buffers (execbuf) that need to be
>> locked, the caller would be assigned a unique reservation_id, from a
>> global counter.  In case of deadlock in the process of locking all the
>> buffers associated with a execbuf, the one with the lowest
>> reservation_id wins, and the one with the higher reservation_id
>> unlocks all of the buffers that it has already locked, and then tries
>> again.
>>
>> Originally TTM implemented this algorithm on top of an event-queue and
>> atomic-ops, but Maarten Lankhorst realized that by merging this with
>> the mutex code we could take advantage of the existing mutex fast-path
>> code and result in a simpler solution, and so ticket_mutex was born.
>> (Well, there where also some additional complexities with the original
>> implementation when you start adding in cross-device buffer sharing
>> for PRIME.. Maarten could probably better explain.)
>
> I think the motivational writeup above is really nice, but the example
> code below is a bit wrong
>
>> How it is used:
>> --- -- -- -----
>>
>> A very simplified version:
>>
>>   int submit_execbuf(execbuf)
>>   {
>>       /* acquiring locks, before queuing up to GPU: */
>>       seqno = assign_global_seqno();
>>   retry:
>>       for (buf in execbuf->buffers) {
>>           ret = mutex_reserve_lock(&buf->lock, seqno);
>>           switch (ret) {
>>           case 0:
>>               /* we got the lock */
>>               break;
>>           case -EAGAIN:
>>               /* someone with a lower seqno, so unreserve and try again: */
>>               for (buf2 in reverse order starting before buf in
>> execbuf->buffers)
>>                   mutex_unreserve_unlock(&buf2->lock);
>>               goto retry;
>>           default:
>>               goto err;
>>           }
>>       }
>>
>>       /* now everything is good to go, submit job to GPU: */
>>       ...
>>   }
>>
>>   int finish_execbuf(execbuf)
>>   {
>>       /* when GPU is finished: */
>>       for (buf in execbuf->buffers)
>>           mutex_unreserve_unlock(&buf->lock);
>>   }
>> ==========================
>
> Since gpu command submission is all asnyc (hopefully at least) we
> don't unlock once it completes, but right away after the commands are
> submitted. Otherwise you wouldn't be able to submit new execbufs using
> the same buffer objects (and besides, holding locks while going back
> out to userspace is evil).

right.. but I was trying to simplify the explanation for non-gpu
folk.. maybe that was an over-simplification ;-)

BR,
-R

> The trick is to add a fence object for async operation (essentially a
> waitqueue on steriods to support gpu->gpu direct signalling). And
> updating fences for a given execbuf needs to happen atomically for all
> buffers, for otherwise userspace could trick the kernel into creating
> a circular fence chain. This wouldn't deadlock the kernel, since
> everything is async, but it'll nicely deadlock the gpus involved.
> Hence why we need ticketing locks to get dma_buf fences off the
> ground.
>
> Maybe wait for Maarten's feedback, then update your motivational blurb a bit?
>
> Cheers, Daniel
> --
> Daniel Vetter
> Software Engineer, Intel Corporation
> +41 (0) 79 365 57 48 - http://blog.ffwll.ch
