Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757957Ab3APG26 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 01:28:58 -0500
Received: from mail-ob0-f176.google.com ([209.85.214.176]:44895 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037Ab3APG2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 01:28:55 -0500
MIME-Version: 1.0
In-Reply-To: <1358253244-11453-6-git-send-email-maarten.lankhorst@canonical.com>
References: <1358253244-11453-1-git-send-email-maarten.lankhorst@canonical.com>
	<1358253244-11453-6-git-send-email-maarten.lankhorst@canonical.com>
Date: Wed, 16 Jan 2013 15:28:55 +0900
X-Google-Sender-Auth: 8d2ZQkNY5OjZ6R43PhdA5mYnqkg
Message-ID: <CAAQKjZNiVE7Eknyfjf+d5o-SMzSd8wKHJ=Jn6_2=BprZXLcYbA@mail.gmail.com>
Subject: Re: [Linaro-mm-sig] [PATCH 5/7] seqno-fence: Hardware dma-buf
 implementation of fencing (v4)
From: Inki Dae <inki.dae@samsung.com>
To: Maarten Lankhorst <m.b.lankhorst@gmail.com>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/1/15 Maarten Lankhorst <m.b.lankhorst@gmail.com>:
> This type of fence can be used with hardware synchronization for simple
> hardware that can block execution until the condition
> (dma_buf[offset] - value) >= 0 has been met.
>
> A software fallback still has to be provided in case the fence is used
> with a device that doesn't support this mechanism. It is useful to expose
> this for graphics cards that have an op to support this.
>
> Some cards like i915 can export those, but don't have an option to wait,
> so they need the software fallback.
>
> I extended the original patch by Rob Clark.
>
> v1: Original
> v2: Renamed from bikeshed to seqno, moved into dma-fence.c since
>     not much was left of the file. Lots of documentation added.
> v3: Use fence_ops instead of custom callbacks. Moved to own file
>     to avoid circular dependency between dma-buf.h and fence.h
> v4: Add spinlock pointer to seqno_fence_init
>
> Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
> ---
>  Documentation/DocBook/device-drivers.tmpl |   1 +
>  drivers/base/fence.c                      |  38 +++++++++++
>  include/linux/seqno-fence.h               | 105 ++++++++++++++++++++++++++++++
>  3 files changed, 144 insertions(+)
>  create mode 100644 include/linux/seqno-fence.h
>
> diff --git a/Documentation/DocBook/device-drivers.tmpl b/Documentation/DocBook/device-drivers.tmpl
> index 6f53fc0..ad14396 100644
> --- a/Documentation/DocBook/device-drivers.tmpl
> +++ b/Documentation/DocBook/device-drivers.tmpl
> @@ -128,6 +128,7 @@ X!Edrivers/base/interface.c
>  !Edrivers/base/dma-buf.c
>  !Edrivers/base/fence.c
>  !Iinclude/linux/fence.h
> +!Iinclude/linux/seqno-fence.h
>  !Edrivers/base/dma-coherent.c
>  !Edrivers/base/dma-mapping.c
>       </sect1>
> diff --git a/drivers/base/fence.c b/drivers/base/fence.c
> index 28e5ffd..1d3f29c 100644
> --- a/drivers/base/fence.c
> +++ b/drivers/base/fence.c
> @@ -24,6 +24,7 @@
>  #include <linux/slab.h>
>  #include <linux/export.h>
>  #include <linux/fence.h>
> +#include <linux/seqno-fence.h>
>
>  atomic_t fence_context_counter = ATOMIC_INIT(0);
>  EXPORT_SYMBOL(fence_context_counter);
> @@ -284,3 +285,40 @@ out:
>         return ret;
>  }
>  EXPORT_SYMBOL(fence_default_wait);
> +
> +static bool seqno_enable_signaling(struct fence *fence)
> +{
> +       struct seqno_fence *seqno_fence = to_seqno_fence(fence);
> +       return seqno_fence->ops->enable_signaling(fence);
> +}
> +
> +static bool seqno_signaled(struct fence *fence)
> +{
> +       struct seqno_fence *seqno_fence = to_seqno_fence(fence);
> +       return seqno_fence->ops->signaled && seqno_fence->ops->signaled(fence);
> +}
> +
> +static void seqno_release(struct fence *fence)
> +{
> +       struct seqno_fence *f = to_seqno_fence(fence);
> +
> +       dma_buf_put(f->sync_buf);
> +       if (f->ops->release)
> +               f->ops->release(fence);
> +       else
> +               kfree(f);
> +}
> +
> +static long seqno_wait(struct fence *fence, bool intr, signed long timeout)
> +{
> +       struct seqno_fence *f = to_seqno_fence(fence);
> +       return f->ops->wait(fence, intr, timeout);
> +}
> +
> +const struct fence_ops seqno_fence_ops = {
> +       .enable_signaling = seqno_enable_signaling,
> +       .signaled = seqno_signaled,
> +       .wait = seqno_wait,
> +       .release = seqno_release
> +};
> +EXPORT_SYMBOL_GPL(seqno_fence_ops);
> diff --git a/include/linux/seqno-fence.h b/include/linux/seqno-fence.h
> new file mode 100644
> index 0000000..603adc0
> --- /dev/null
> +++ b/include/linux/seqno-fence.h
> @@ -0,0 +1,105 @@
> +/*
> + * seqno-fence, using a dma-buf to synchronize fencing
> + *
> + * Copyright (C) 2012 Texas Instruments
> + * Copyright (C) 2012 Canonical Ltd
> + * Authors:
> + *   Rob Clark <rob.clark@linaro.org>
> + *   Maarten Lankhorst <maarten.lankhorst@canonical.com>
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License version 2 as published by
> + * the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + *
> + * You should have received a copy of the GNU General Public License along with
> + * this program.  If not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +#ifndef __LINUX_SEQNO_FENCE_H
> +#define __LINUX_SEQNO_FENCE_H
> +
> +#include <linux/fence.h>
> +#include <linux/dma-buf.h>
> +
> +struct seqno_fence {
> +       struct fence base;
> +
> +       const struct fence_ops *ops;
> +       struct dma_buf *sync_buf;
> +       uint32_t seqno_ofs;
> +};

Hi maarten,

I'm applying dma-fence v11 and seqno-fence v4 to exynos drm and have
some proposals.

The above seqno_fence structure has only one dmabuf. Shouldn't it have
mutiple dmabufs? For example, in case of drm driver, when pageflip is
requested, one framebuffer could have one more gem buffer for NV12M
format. And this means that one more exported dmabufs should be
sychronized with other devices. Below is simple structure for it,

struct seqno_fence_dmabuf {
        struct list_head        list;
        int                            id;
        struct dmabuf          *sync_buf;
        uint32_t                   seqno_ops;
        uint32_t                   seqno;
};

The member, id, could be used to identify which device sync_buf is
going to be accessed by. In case of drm driver, one framebuffer could
be accessed by one more devices, one is Display controller and another
is HDMI controller. So id would have crtc number.

And seqno_fence structure could be defined like below,

struct seqno_fence {
        struct list_head                sync_buf_list;
        struct fence                      base;
        const struct fence_ops     *ops;
};

In addition, I have implemented fence-helper framework for sw sync as
WIP and below is intefaces for it,

struct fence_helper {
        struct list_head                    entries;
        struct reservation_ticket       ticket;
        struct seqno_fence              *sf;
        spinlock_t                             lock;
        void                                      *priv;
};

int fence_helper_init(struct fence_helper *fh, void *priv, void
(*remease)(struct fence *fence));
- This function is called at driver open so process unique context
would have a new seqno_fence instance. This function does just
seqno_fence_init call, initialize entries list and set device specific
fence release callback.

bool fence_helper_check_sync_buf(struct fence_helper *fh, struct
dma_buf *sync_buf, int id);
- This function is called before dma is started and checks if same
sync_bufs had already be committed to reservation_object,
bo->fence_shared[n]. And id could be used to identy which device
sync_buf is going to be accessed by.

int fence_helper_add_sync_buf(struct fence_helper *fh, struct dma_buf
*sync_buf, int id);
- This function is called if fence_helper_check_sync_buf() is true and
adds it seqno_fence's sync_buf_list wrapping sync_buf as
seqno_fence_dma_buf structure. With this function call, one
seqno_fence instance would have more sync_bufs. At this time, the
reference count to this sync_buf is taken.

void fence_helper_del_sync_buf(struct fence_helper *fh, int id);
- This function is called if some operation is failed after
fence_helper_add_sync_buf call to release relevant resources.

int fence_helper_init_reservation_entry(struct fence_helper *fh,
struct dma_buf *dmabuf, bool shared, int id);
- This function is called after fence_helper_add_sync_buf call and
calls reservation_entry_init function to set a reservation object of
sync_buf to a new reservation_entry object. And then the new
reservation_entry is added to fh->entries to track all sync_bufs this
device is going to access.

void fence_helper_fini_reservation_entry(struct fence_helper *fh, int id);
- This function is called if some operation is failed after
fence_helper_init_reservation_entry call to releae relevant resources.

int fence_helper_ticket_reserve(struct fence_helper *fh, int id);
- This function is called after fence_helper_init_reservation_entry
call and calls ticket_reserve function to reserve a ticket(locked for
each reservation entry in fh->entires)

void fence_helper_ticket_commit(struct fence_helper *fh, int id);
- This function is called after fence_helper_ticket_reserve() is
called to commit this device's fence to all reservation_objects of
each sync_buf. After that, once other devices try to access these
buffers, they would be blocked and unlock each reservation entry in
fh->entires.

int fence_helper_wait(struct fence_helper *fh, struct dma_buf *dmabuf,
bool intr);
- This function is called before fence_helper_add_sync_buf() is called
to wait for a signal from other devices.

int fence_helper_signal(struct fence_helper *fh, int id);
- This function is called by device's interrupt handler or somewhere
when dma access to this buffer has been completed and calls
fence_signal() with each fence registed to each reservation object in
fh->entries to notify dma access completion to other deivces. At this
time, other devices blocked would be waked up and forward their next
step.

For more detail, in addition, this function does the following,
- delete each reservation entry in fh->entries.
- release each seqno_fence_dmabuf object in seqno_fence's
sync_buf_list and call dma_buf_put() to put the reference count to
dmabuf.


Now the fence-helper framework is just WIP yet so there may be my
missing points. If you are ok, I'd like to post it as RFC.

Thanks,
Inki Dae


> +
> +extern const struct fence_ops seqno_fence_ops;
> +
> +/**
> + * to_seqno_fence - cast a fence to a seqno_fence
> + * @fence: fence to cast to a seqno_fence
> + *
> + * Returns NULL if the fence is not a seqno_fence,
> + * or the seqno_fence otherwise.
> + */
> +static inline struct seqno_fence *
> +to_seqno_fence(struct fence *fence)
> +{
> +       if (fence->ops != &seqno_fence_ops)
> +               return NULL;
> +       return container_of(fence, struct seqno_fence, base);
> +}
> +
> +/**
> + * seqno_fence_init - initialize a seqno fence
> + * @fence: seqno_fence to initialize
> + * @lock: pointer to spinlock to use for fence
> + * @sync_buf: buffer containing the memory location to signal on
> + * @context: the execution context this fence is a part of
> + * @seqno_ofs: the offset within @sync_buf
> + * @seqno: the sequence # to signal on
> + * @ops: the fence_ops for operations on this seqno fence
> + *
> + * This function initializes a struct seqno_fence with passed parameters,
> + * and takes a reference on sync_buf which is released on fence destruction.
> + *
> + * A seqno_fence is a dma_fence which can complete in software when
> + * enable_signaling is called, but it also completes when
> + * (s32)((sync_buf)[seqno_ofs] - seqno) >= 0 is true
> + *
> + * The seqno_fence will take a refcount on the sync_buf until it's
> + * destroyed, but actual lifetime of sync_buf may be longer if one of the
> + * callers take a reference to it.
> + *
> + * Certain hardware have instructions to insert this type of wait condition
> + * in the command stream, so no intervention from software would be needed.
> + * This type of fence can be destroyed before completed, however a reference
> + * on the sync_buf dma-buf can be taken. It is encouraged to re-use the same
> + * dma-buf for sync_buf, since mapping or unmapping the sync_buf to the
> + * device's vm can be expensive.
> + *
> + * It is recommended for creators of seqno_fence to call fence_signal
> + * before destruction. This will prevent possible issues from wraparound at
> + * time of issue vs time of check, since users can check fence_is_signaled
> + * before submitting instructions for the hardware to wait on the fence.
> + * However, when ops.enable_signaling is not called, it doesn't have to be
> + * done as soon as possible, just before there's any real danger of seqno
> + * wraparound.
> + */
> +static inline void
> +seqno_fence_init(struct seqno_fence *fence, spinlock_t *lock,
> +                struct dma_buf *sync_buf,  uint32_t context, uint32_t seqno_ofs,
> +                uint32_t seqno, const struct fence_ops *ops)
> +{
> +       BUG_ON(!fence || !sync_buf || !ops->enable_signaling || !ops->wait);
> +
> +       __fence_init(&fence->base, &seqno_fence_ops, lock, context, seqno);
> +
> +       get_dma_buf(sync_buf);
> +       fence->ops = ops;
> +       fence->sync_buf = sync_buf;
> +       fence->seqno_ofs = seqno_ofs;
> +}
> +
> +#endif /* __LINUX_SEQNO_FENCE_H */
> --
> 1.8.0.3
>
>
> _______________________________________________
> Linaro-mm-sig mailing list
> Linaro-mm-sig@lists.linaro.org
> http://lists.linaro.org/mailman/listinfo/linaro-mm-sig
