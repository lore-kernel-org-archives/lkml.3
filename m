Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045Ab3APMAp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 07:00:45 -0500
Received: from mail-ob0-f182.google.com ([209.85.214.182]:58027 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752423Ab3APMAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 07:00:08 -0500
MIME-Version: 1.0
In-Reply-To: <50F682C0.3030009@canonical.com>
References: <1358253244-11453-1-git-send-email-maarten.lankhorst@canonical.com>
	<1358253244-11453-6-git-send-email-maarten.lankhorst@canonical.com>
	<CAAQKjZNiVE7Eknyfjf+d5o-SMzSd8wKHJ=Jn6_2=BprZXLcYbA@mail.gmail.com>
	<50F682C0.3030009@canonical.com>
Date: Wed, 16 Jan 2013 21:00:07 +0900
X-Google-Sender-Auth: wMVByc8Hm60kgpf2aqO9ZwtT6jQ
Message-ID: <CAAQKjZO22V268sfEtmpXqa4D0yDpy=7Be-AN44_VEDN7SyBU9A@mail.gmail.com>
Subject: Re: [Linaro-mm-sig] [PATCH 5/7] seqno-fence: Hardware dma-buf
 implementation of fencing (v4)
From: Inki Dae <inki.dae@samsung.com>
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: linaro-mm-sig@lists.linaro.org,
        Maarten Lankhorst <m.b.lankhorst@gmail.com>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/1/16 Maarten Lankhorst <maarten.lankhorst@canonical.com>:
> Op 16-01-13 07:28, Inki Dae schreef:
>> 2013/1/15 Maarten Lankhorst <m.b.lankhorst@gmail.com>:
>>> This type of fence can be used with hardware synchronization for simple
>>> hardware that can block execution until the condition
>>> (dma_buf[offset] - value) >= 0 has been met.
>>>
>>> A software fallback still has to be provided in case the fence is used
>>> with a device that doesn't support this mechanism. It is useful to expose
>>> this for graphics cards that have an op to support this.
>>>
>>> Some cards like i915 can export those, but don't have an option to wait,
>>> so they need the software fallback.
>>>
>>> I extended the original patch by Rob Clark.
>>>
>>> v1: Original
>>> v2: Renamed from bikeshed to seqno, moved into dma-fence.c since
>>>     not much was left of the file. Lots of documentation added.
>>> v3: Use fence_ops instead of custom callbacks. Moved to own file
>>>     to avoid circular dependency between dma-buf.h and fence.h
>>> v4: Add spinlock pointer to seqno_fence_init
>>>
>>> Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
>>> ---
>>>  Documentation/DocBook/device-drivers.tmpl |   1 +
>>>  drivers/base/fence.c                      |  38 +++++++++++
>>>  include/linux/seqno-fence.h               | 105 ++++++++++++++++++++++++++++++
>>>  3 files changed, 144 insertions(+)
>>>  create mode 100644 include/linux/seqno-fence.h
>>>
>>> diff --git a/Documentation/DocBook/device-drivers.tmpl b/Documentation/DocBook/device-drivers.tmpl
>>> index 6f53fc0..ad14396 100644
>>> --- a/Documentation/DocBook/device-drivers.tmpl
>>> +++ b/Documentation/DocBook/device-drivers.tmpl
>>> @@ -128,6 +128,7 @@ X!Edrivers/base/interface.c
>>>  !Edrivers/base/dma-buf.c
>>>  !Edrivers/base/fence.c
>>>  !Iinclude/linux/fence.h
>>> +!Iinclude/linux/seqno-fence.h
>>>  !Edrivers/base/dma-coherent.c
>>>  !Edrivers/base/dma-mapping.c
>>>       </sect1>
>>> diff --git a/drivers/base/fence.c b/drivers/base/fence.c
>>> index 28e5ffd..1d3f29c 100644
>>> --- a/drivers/base/fence.c
>>> +++ b/drivers/base/fence.c
>>> @@ -24,6 +24,7 @@
>>>  #include <linux/slab.h>
>>>  #include <linux/export.h>
>>>  #include <linux/fence.h>
>>> +#include <linux/seqno-fence.h>
>>>
>>>  atomic_t fence_context_counter = ATOMIC_INIT(0);
>>>  EXPORT_SYMBOL(fence_context_counter);
>>> @@ -284,3 +285,40 @@ out:
>>>         return ret;
>>>  }
>>>  EXPORT_SYMBOL(fence_default_wait);
>>> +
>>> +static bool seqno_enable_signaling(struct fence *fence)
>>> +{
>>> +       struct seqno_fence *seqno_fence = to_seqno_fence(fence);
>>> +       return seqno_fence->ops->enable_signaling(fence);
>>> +}
>>> +
>>> +static bool seqno_signaled(struct fence *fence)
>>> +{
>>> +       struct seqno_fence *seqno_fence = to_seqno_fence(fence);
>>> +       return seqno_fence->ops->signaled && seqno_fence->ops->signaled(fence);
>>> +}
>>> +
>>> +static void seqno_release(struct fence *fence)
>>> +{
>>> +       struct seqno_fence *f = to_seqno_fence(fence);
>>> +
>>> +       dma_buf_put(f->sync_buf);
>>> +       if (f->ops->release)
>>> +               f->ops->release(fence);
>>> +       else
>>> +               kfree(f);
>>> +}
>>> +
>>> +static long seqno_wait(struct fence *fence, bool intr, signed long timeout)
>>> +{
>>> +       struct seqno_fence *f = to_seqno_fence(fence);
>>> +       return f->ops->wait(fence, intr, timeout);
>>> +}
>>> +
>>> +const struct fence_ops seqno_fence_ops = {
>>> +       .enable_signaling = seqno_enable_signaling,
>>> +       .signaled = seqno_signaled,
>>> +       .wait = seqno_wait,
>>> +       .release = seqno_release
>>> +};
>>> +EXPORT_SYMBOL_GPL(seqno_fence_ops);
>>> diff --git a/include/linux/seqno-fence.h b/include/linux/seqno-fence.h
>>> new file mode 100644
>>> index 0000000..603adc0
>>> --- /dev/null
>>> +++ b/include/linux/seqno-fence.h
>>> @@ -0,0 +1,105 @@
>>> +/*
>>> + * seqno-fence, using a dma-buf to synchronize fencing
>>> + *
>>> + * Copyright (C) 2012 Texas Instruments
>>> + * Copyright (C) 2012 Canonical Ltd
>>> + * Authors:
>>> + *   Rob Clark <rob.clark@linaro.org>
>>> + *   Maarten Lankhorst <maarten.lankhorst@canonical.com>
>>> + *
>>> + * This program is free software; you can redistribute it and/or modify it
>>> + * under the terms of the GNU General Public License version 2 as published by
>>> + * the Free Software Foundation.
>>> + *
>>> + * This program is distributed in the hope that it will be useful, but WITHOUT
>>> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
>>> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
>>> + * more details.
>>> + *
>>> + * You should have received a copy of the GNU General Public License along with
>>> + * this program.  If not, see <http://www.gnu.org/licenses/>.
>>> + */
>>> +
>>> +#ifndef __LINUX_SEQNO_FENCE_H
>>> +#define __LINUX_SEQNO_FENCE_H
>>> +
>>> +#include <linux/fence.h>
>>> +#include <linux/dma-buf.h>
>>> +
>>> +struct seqno_fence {
>>> +       struct fence base;
>>> +
>>> +       const struct fence_ops *ops;
>>> +       struct dma_buf *sync_buf;
>>> +       uint32_t seqno_ofs;
>>> +};
>> Hi maarten,
>>
>> I'm applying dma-fence v11 and seqno-fence v4 to exynos drm and have
>> some proposals.
>>
>> The above seqno_fence structure has only one dmabuf. Shouldn't it have
>> mutiple dmabufs? For example, in case of drm driver, when pageflip is
>> requested, one framebuffer could have one more gem buffer for NV12M
>> format. And this means that one more exported dmabufs should be
>> sychronized with other devices. Below is simple structure for it,
> The fence guards a single operation, as such I didn't feel like more than one
> dma-buf was needed to guard it.
>
> Have you considered simply attaching multiple fences instead? Each with their own dma-buf.

I thought each context per device should have one fence. If not so, I
think we could use multiple fences instead.

> There has been some muttering about allowing multiple exclusive fences to be attached, for arm soc's.
>
> But I'm also considering getting rid of the dma-buf member and add a function call to retrieve it, since
> the sync dma-buf member should not be changing often, and it would zap 2 atomic ops on every fence,
> but I want it replaced by something that's not 10x more complicated.
>
> Maybe "int get_sync_dma_buf(fence, old_dma_buf, &new_dma_buf)" that will set new_dma_buf = NULL
> if the old_dma_buf is unchanged, and return true + return a new reference to the sync dma_buf if it's not identical to old_dma_buf.
> old_dma_buf can also be NULL or a dma_buf that belongs to a different fence->context entirely. It might be capable of
> returning an error, in which case the fence would count as being signaled. This could reduce the need for separately checking
> fence_is_signaled first.
>
> I think this would allow caching the synchronization dma_buf in a similar way without each fence needing
> to hold a reference to the dma_buf all the time, even for fences that are only used internally.
>
>> struct seqno_fence_dmabuf {
>>         struct list_head        list;
>>         int                            id;
>>         struct dmabuf          *sync_buf;
>>         uint32_t                   seqno_ops;
>>         uint32_t                   seqno;
>> };
>>
>> The member, id, could be used to identify which device sync_buf is
>> going to be accessed by. In case of drm driver, one framebuffer could
>> be accessed by one more devices, one is Display controller and another
>> is HDMI controller. So id would have crtc number.
> Why do you need this? the base fence already has a context member.
>
> In fact I don't see why you need a linked list, at worst you'd need a static array since the amount of
> dma-bufs should already be known during allocation time.
>
> I would prefer to simply make reservation_object->fence_exclusive an array, since it would be easier to implement,
> and there have been some calls that arm might need such a thing.
>

Right, the array could be used instead. I just had quick implemention
so it's not perfect.

>
>> And seqno_fence structure could be defined like below,
>>
>> struct seqno_fence {
>>         struct list_head                sync_buf_list;
>>         struct fence                      base;
>>         const struct fence_ops     *ops;
>> };
>>
>> In addition, I have implemented fence-helper framework for sw sync as
>> WIP and below is intefaces for it,
>>
>> struct fence_helper {
>>         struct list_head                    entries;
>>         struct reservation_ticket       ticket;
>>         struct seqno_fence              *sf;
>>         spinlock_t                             lock;
>>         void                                      *priv;
>> };
>>
>> int fence_helper_init(struct fence_helper *fh, void *priv, void
>> (*remease)(struct fence *fence));
>> - This function is called at driver open so process unique context
>> would have a new seqno_fence instance. This function does just
>> seqno_fence_init call, initialize entries list and set device specific
>> fence release callback.
>>
>> bool fence_helper_check_sync_buf(struct fence_helper *fh, struct
>> dma_buf *sync_buf, int id);
>> - This function is called before dma is started and checks if same
>> sync_bufs had already be committed to reservation_object,
>> bo->fence_shared[n]. And id could be used to identy which device
>> sync_buf is going to be accessed by.
>>
>> int fence_helper_add_sync_buf(struct fence_helper *fh, struct dma_buf
>> *sync_buf, int id);
>> - This function is called if fence_helper_check_sync_buf() is true and
>> adds it seqno_fence's sync_buf_list wrapping sync_buf as
>> seqno_fence_dma_buf structure. With this function call, one
>> seqno_fence instance would have more sync_bufs. At this time, the
>> reference count to this sync_buf is taken.
>>
>> void fence_helper_del_sync_buf(struct fence_helper *fh, int id);
>> - This function is called if some operation is failed after
>> fence_helper_add_sync_buf call to release relevant resources.
>>
>> int fence_helper_init_reservation_entry(struct fence_helper *fh,
>> struct dma_buf *dmabuf, bool shared, int id);
>> - This function is called after fence_helper_add_sync_buf call and
>> calls reservation_entry_init function to set a reservation object of
>> sync_buf to a new reservation_entry object. And then the new
>> reservation_entry is added to fh->entries to track all sync_bufs this
>> device is going to access.
>>
>> void fence_helper_fini_reservation_entry(struct fence_helper *fh, int id);
>> - This function is called if some operation is failed after
>> fence_helper_init_reservation_entry call to releae relevant resources.
>>
>> int fence_helper_ticket_reserve(struct fence_helper *fh, int id);
>> - This function is called after fence_helper_init_reservation_entry
>> call and calls ticket_reserve function to reserve a ticket(locked for
>> each reservation entry in fh->entires)
>>
>> void fence_helper_ticket_commit(struct fence_helper *fh, int id);
>> - This function is called after fence_helper_ticket_reserve() is
>> called to commit this device's fence to all reservation_objects of
>> each sync_buf. After that, once other devices try to access these
>> buffers, they would be blocked and unlock each reservation entry in
>> fh->entires.
>>
>> int fence_helper_wait(struct fence_helper *fh, struct dma_buf *dmabuf,
>> bool intr);
>> - This function is called before fence_helper_add_sync_buf() is called
>> to wait for a signal from other devices.
>>
>> int fence_helper_signal(struct fence_helper *fh, int id);
>> - This function is called by device's interrupt handler or somewhere
>> when dma access to this buffer has been completed and calls
>> fence_signal() with each fence registed to each reservation object in
>> fh->entries to notify dma access completion to other deivces. At this
>> time, other devices blocked would be waked up and forward their next
>> step.
>>
>> For more detail, in addition, this function does the following,
>> - delete each reservation entry in fh->entries.
>> - release each seqno_fence_dmabuf object in seqno_fence's
>> sync_buf_list and call dma_buf_put() to put the reference count to
>> dmabuf.
>>
>>
>> Now the fence-helper framework is just WIP yet so there may be my
>> missing points. If you are ok, I'd like to post it as RFC.
> Way too complicated..

The purpose to the fence-helper is to use the dma-fence more simply.
With the fence-helper, we doesn't need to consider fence and
reservation interfaces for it. All we have to do is to call only the
fence-helper interfaces without considering two things(fence and
reservation).

For example(In consumer case),

driver_open()
{
        struct fence-helper *fh;
        ...
        ctx->fh = kzalloc();
        ...
        fence_helper_init(fh, ...);
}

driver_addfb()
{
       ...
       fence_helper_add_sync_buf(fh, sync_buf, ...);
       ...
}

driver_pageflip()
{
       ...
       fence_helper_wait(fh, sync_buf, ...);
       fence_helper_init_reservation_entry(fh, sync_buf, ...);
       fence_helper_ticket_reserve(fh, ...);
       fence_helper_ticket_commit(fh, ...);
       ...
}

driver_pageflip_handler()
{
       ...
       fence_helper_signal(fh, ...);
}

The above functions are called in the following order,
1. driver_open() -> 2. driver_addfb() -> 3. driver_pageflip() ->
4.driver_pageflip_handler()

Step 3 and 4 would be called repeatedly. And also producer could use
similar way.

I'm not sure that I understand the dma-fence framework fully so there
might be something wrong and better way.

Thanks,
Inki Dae

>
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
