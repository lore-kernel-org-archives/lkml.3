Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925AbaBQR1V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 12:27:21 -0500
Received: from mail-ie0-f178.google.com ([209.85.223.178]:45991 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753776AbaBQR1Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 12:27:16 -0500
MIME-Version: 1.0
In-Reply-To: <53023F3E.3080107@vodafone.de>
References: <20140217155056.20337.25254.stgit@patser>
	<20140217155556.20337.37589.stgit@patser>
	<53023F3E.3080107@vodafone.de>
Date: Mon, 17 Feb 2014 12:27:13 -0500
Message-ID: <CAF6AEGtHSg=qESbGE8LZsQPrRfHnrSQOjpEAVKeZ5o9k07ZNcA@mail.gmail.com>
Subject: Re: [PATCH 2/6] seqno-fence: Hardware dma-buf implementation of
 fencing (v4)
From: Rob Clark <robdclark@gmail.com>
To: =?ISO-8859-1?Q?Christian_K=F6nig?= <deathsimple@vodafone.de>
Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arch@vger.kernel.org,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        Colin Cross <ccross@google.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 17, 2014 at 11:56 AM, Christian König
<deathsimple@vodafone.de> wrote:
> Am 17.02.2014 16:56, schrieb Maarten Lankhorst:
>
>> This type of fence can be used with hardware synchronization for simple
>> hardware that can block execution until the condition
>> (dma_buf[offset] - value) >= 0 has been met.
>
>
> Can't we make that just "dma_buf[offset] != 0" instead? As far as I know
> this way it would match the definition M$ uses in their WDDM specification
> and so make it much more likely that hardware supports it.

well 'buf[offset] >= value' at least means the same slot can be used
for multiple operations (with increasing values of 'value').. not sure
if that is something people care about.

>=value seems to be possible with adreno and radeon.  I'm not really sure about others (although I presume it as least supported for nv desktop stuff).  For hw that cannot do >=value, we can either have a different fence implementation which uses the !=0 approach.  Or change seqno-fence implementation later if needed.  But if someone has hw that can do !=0 but not >=value, speak up now ;-)


> Apart from that I still don't like the idea of leaking a drivers IRQ context
> outside of the driver, but without a proper GPU scheduler there probably
> isn't much alternative.

I guess it will be not uncommon scenario for gpu device to just need
to kick display device to write a few registers for a page flip..
probably best not to schedule a worker just for this (unless the
signalled device otherwise needs to).  I think it is better in this
case to give the signalee some rope to hang themselves, and make it
the responsibility of the callback to kick things off to a worker if
needed.

BR,
-R

> Christian.
>
>>
>> A software fallback still has to be provided in case the fence is used
>> with a device that doesn't support this mechanism. It is useful to expose
>> this for graphics cards that have an op to support this.
>>
>> Some cards like i915 can export those, but don't have an option to wait,
>> so they need the software fallback.
>>
>> I extended the original patch by Rob Clark.
>>
>> v1: Original
>> v2: Renamed from bikeshed to seqno, moved into dma-fence.c since
>>      not much was left of the file. Lots of documentation added.
>> v3: Use fence_ops instead of custom callbacks. Moved to own file
>>      to avoid circular dependency between dma-buf.h and fence.h
>> v4: Add spinlock pointer to seqno_fence_init
>>
>> Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
>> ---
>>   Documentation/DocBook/device-drivers.tmpl |    1
>>   drivers/base/fence.c                      |   50 +++++++++++++
>>   include/linux/seqno-fence.h               |  109
>> +++++++++++++++++++++++++++++
>>   3 files changed, 160 insertions(+)
>>   create mode 100644 include/linux/seqno-fence.h
>>
>> diff --git a/Documentation/DocBook/device-drivers.tmpl
>> b/Documentation/DocBook/device-drivers.tmpl
>> index 7a0c9ddb4818..8c85c20942c2 100644
>> --- a/Documentation/DocBook/device-drivers.tmpl
>> +++ b/Documentation/DocBook/device-drivers.tmpl
>> @@ -131,6 +131,7 @@ X!Edrivers/base/interface.c
>>   !Edrivers/base/dma-buf.c
>>   !Edrivers/base/fence.c
>>   !Iinclude/linux/fence.h
>> +!Iinclude/linux/seqno-fence.h
>>   !Edrivers/base/reservation.c
>>   !Iinclude/linux/reservation.h
>>   !Edrivers/base/dma-coherent.c
>> diff --git a/drivers/base/fence.c b/drivers/base/fence.c
>> index 12df2bf62034..cd0937127a89 100644
>> --- a/drivers/base/fence.c
>> +++ b/drivers/base/fence.c
>> @@ -25,6 +25,7 @@
>>   #include <linux/export.h>
>>   #include <linux/atomic.h>
>>   #include <linux/fence.h>
>> +#include <linux/seqno-fence.h>
>>     #define CREATE_TRACE_POINTS
>>   #include <trace/events/fence.h>
>> @@ -413,3 +414,52 @@ __fence_init(struct fence *fence, const struct
>> fence_ops *ops,
>>         trace_fence_init(fence);
>>   }
>>   EXPORT_SYMBOL(__fence_init);
>> +
>> +static const char *seqno_fence_get_driver_name(struct fence *fence) {
>> +       struct seqno_fence *seqno_fence = to_seqno_fence(fence);
>> +       return seqno_fence->ops->get_driver_name(fence);
>> +}
>> +
>> +static const char *seqno_fence_get_timeline_name(struct fence *fence) {
>> +       struct seqno_fence *seqno_fence = to_seqno_fence(fence);
>> +       return seqno_fence->ops->get_timeline_name(fence);
>> +}
>> +
>> +static bool seqno_enable_signaling(struct fence *fence)
>> +{
>> +       struct seqno_fence *seqno_fence = to_seqno_fence(fence);
>> +       return seqno_fence->ops->enable_signaling(fence);
>> +}
>> +
>> +static bool seqno_signaled(struct fence *fence)
>> +{
>> +       struct seqno_fence *seqno_fence = to_seqno_fence(fence);
>> +       return seqno_fence->ops->signaled &&
>> seqno_fence->ops->signaled(fence);
>> +}
>> +
>> +static void seqno_release(struct fence *fence)
>> +{
>> +       struct seqno_fence *f = to_seqno_fence(fence);
>> +
>> +       dma_buf_put(f->sync_buf);
>> +       if (f->ops->release)
>> +               f->ops->release(fence);
>> +       else
>> +               kfree(f);
>> +}
>> +
>> +static long seqno_wait(struct fence *fence, bool intr, signed long
>> timeout)
>> +{
>> +       struct seqno_fence *f = to_seqno_fence(fence);
>> +       return f->ops->wait(fence, intr, timeout);
>> +}
>> +
>> +const struct fence_ops seqno_fence_ops = {
>> +       .get_driver_name = seqno_fence_get_driver_name,
>> +       .get_timeline_name = seqno_fence_get_timeline_name,
>> +       .enable_signaling = seqno_enable_signaling,
>> +       .signaled = seqno_signaled,
>> +       .wait = seqno_wait,
>> +       .release = seqno_release,
>> +};
>> +EXPORT_SYMBOL(seqno_fence_ops);
>> diff --git a/include/linux/seqno-fence.h b/include/linux/seqno-fence.h
>> new file mode 100644
>> index 000000000000..952f7909128c
>> --- /dev/null
>> +++ b/include/linux/seqno-fence.h
>> @@ -0,0 +1,109 @@
>> +/*
>> + * seqno-fence, using a dma-buf to synchronize fencing
>> + *
>> + * Copyright (C) 2012 Texas Instruments
>> + * Copyright (C) 2012 Canonical Ltd
>> + * Authors:
>> + * Rob Clark <robdclark@gmail.com>
>> + *   Maarten Lankhorst <maarten.lankhorst@canonical.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> it
>> + * under the terms of the GNU General Public License version 2 as
>> published by
>> + * the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful, but
>> WITHOUT
>> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
>> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
>> for
>> + * more details.
>> + *
>> + * You should have received a copy of the GNU General Public License
>> along with
>> + * this program.  If not, see <http://www.gnu.org/licenses/>.
>> + */
>> +
>> +#ifndef __LINUX_SEQNO_FENCE_H
>> +#define __LINUX_SEQNO_FENCE_H
>> +
>> +#include <linux/fence.h>
>> +#include <linux/dma-buf.h>
>> +
>> +struct seqno_fence {
>> +       struct fence base;
>> +
>> +       const struct fence_ops *ops;
>> +       struct dma_buf *sync_buf;
>> +       uint32_t seqno_ofs;
>> +};
>> +
>> +extern const struct fence_ops seqno_fence_ops;
>> +
>> +/**
>> + * to_seqno_fence - cast a fence to a seqno_fence
>> + * @fence: fence to cast to a seqno_fence
>> + *
>> + * Returns NULL if the fence is not a seqno_fence,
>> + * or the seqno_fence otherwise.
>> + */
>> +static inline struct seqno_fence *
>> +to_seqno_fence(struct fence *fence)
>> +{
>> +       if (fence->ops != &seqno_fence_ops)
>> +               return NULL;
>> +       return container_of(fence, struct seqno_fence, base);
>> +}
>> +
>> +/**
>> + * seqno_fence_init - initialize a seqno fence
>> + * @fence: seqno_fence to initialize
>> + * @lock: pointer to spinlock to use for fence
>> + * @sync_buf: buffer containing the memory location to signal on
>> + * @context: the execution context this fence is a part of
>> + * @seqno_ofs: the offset within @sync_buf
>> + * @seqno: the sequence # to signal on
>> + * @ops: the fence_ops for operations on this seqno fence
>> + *
>> + * This function initializes a struct seqno_fence with passed parameters,
>> + * and takes a reference on sync_buf which is released on fence
>> destruction.
>> + *
>> + * A seqno_fence is a dma_fence which can complete in software when
>> + * enable_signaling is called, but it also completes when
>> + * (s32)((sync_buf)[seqno_ofs] - seqno) >= 0 is true
>> + *
>> + * The seqno_fence will take a refcount on the sync_buf until it's
>> + * destroyed, but actual lifetime of sync_buf may be longer if one of the
>> + * callers take a reference to it.
>> + *
>> + * Certain hardware have instructions to insert this type of wait
>> condition
>> + * in the command stream, so no intervention from software would be
>> needed.
>> + * This type of fence can be destroyed before completed, however a
>> reference
>> + * on the sync_buf dma-buf can be taken. It is encouraged to re-use the
>> same
>> + * dma-buf for sync_buf, since mapping or unmapping the sync_buf to the
>> + * device's vm can be expensive.
>> + *
>> + * It is recommended for creators of seqno_fence to call fence_signal
>> + * before destruction. This will prevent possible issues from wraparound
>> at
>> + * time of issue vs time of check, since users can check
>> fence_is_signaled
>> + * before submitting instructions for the hardware to wait on the fence.
>> + * However, when ops.enable_signaling is not called, it doesn't have to
>> be
>> + * done as soon as possible, just before there's any real danger of seqno
>> + * wraparound.
>> + */
>> +static inline void
>> +seqno_fence_init(struct seqno_fence *fence, spinlock_t *lock,
>> +                struct dma_buf *sync_buf,  uint32_t context, uint32_t
>> seqno_ofs,
>> +                uint32_t seqno, const struct fence_ops *ops)
>> +{
>> +       BUG_ON(!fence || !sync_buf || !ops);
>> +       BUG_ON(!ops->wait || !ops->enable_signaling ||
>> !ops->get_driver_name || !ops->get_timeline_name);
>> +
>> +       /*
>> +        * ops is used in __fence_init for get_driver_name, so needs to be
>> +        * initialized first
>> +        */
>> +       fence->ops = ops;
>> +       __fence_init(&fence->base, &seqno_fence_ops, lock, context,
>> seqno);
>> +       get_dma_buf(sync_buf);
>> +       fence->sync_buf = sync_buf;
>> +       fence->seqno_ofs = seqno_ofs;
>> +}
>> +
>> +#endif /* __LINUX_SEQNO_FENCE_H */
>>
>> _______________________________________________
>> dri-devel mailing list
>> dri-devel@lists.freedesktop.org
>> http://lists.freedesktop.org/mailman/listinfo/dri-devel
>
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
