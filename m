Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753060AbaBQQiU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 11:38:20 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:40911 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886AbaBQQiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 11:38:18 -0500
MIME-Version: 1.0
In-Reply-To: <20140217155832.20337.83163.stgit@patser>
References: <20140217155056.20337.25254.stgit@patser>
	<20140217155832.20337.83163.stgit@patser>
Date: Mon, 17 Feb 2014 11:38:17 -0500
Message-ID: <CAF6AEGtnQAAM-p=Q83Ha=9_PyzaXF9omhY4O1UOv=4+45xvUXg@mail.gmail.com>
Subject: Re: [PATCH 6/6] dma-buf: add poll support, v2
From: Rob Clark <robdclark@gmail.com>
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arch@vger.kernel.org, Colin Cross <ccross@google.com>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Daniel Vetter <daniel@ffwll.ch>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 17, 2014 at 10:58 AM, Maarten Lankhorst
<maarten.lankhorst@canonical.com> wrote:
> Thanks to Fengguang Wu for spotting a missing static cast.
>
> v2:
> - Kill unused variable need_shared.
>
> Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
> ---
>  drivers/base/dma-buf.c  |  101 +++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/dma-buf.h |   12 ++++++
>  2 files changed, 113 insertions(+)
>
> diff --git a/drivers/base/dma-buf.c b/drivers/base/dma-buf.c
> index 85e792c2c909..77ea621ab59d 100644
> --- a/drivers/base/dma-buf.c
> +++ b/drivers/base/dma-buf.c
> @@ -30,6 +30,7 @@
>  #include <linux/export.h>
>  #include <linux/debugfs.h>
>  #include <linux/seq_file.h>
> +#include <linux/poll.h>
>  #include <linux/reservation.h>
>
>  static inline int is_dma_buf_file(struct file *);
> @@ -52,6 +53,13 @@ static int dma_buf_release(struct inode *inode, struct file *file)
>
>         BUG_ON(dmabuf->vmapping_counter);
>
> +       /*
> +        * Any fences that a dma-buf poll can wait on should be signaled
> +        * before releasing dma-buf. This is the responsibility of each
> +        * driver that uses the reservation objects.

minor nit.. but wouldn't hurt to mention in the comment that if you
hit this BUG_ON it is because someone isn't holding a ref to the
dmabuf while there is a pending fence

> +        */
> +       BUG_ON(dmabuf->cb_shared.active || dmabuf->cb_excl.active);
> +
>         dmabuf->ops->release(dmabuf);
>
>         mutex_lock(&db_list.lock);
> @@ -108,10 +116,99 @@ static loff_t dma_buf_llseek(struct file *file, loff_t offset, int whence)
>         return base + offset;
>  }
>
> +static void dma_buf_poll_cb(struct fence *fence, struct fence_cb *cb)
> +{
> +       struct dma_buf_poll_cb_t *dcb = (struct dma_buf_poll_cb_t*) cb;
> +       unsigned long flags;
> +
> +       spin_lock_irqsave(&dcb->poll->lock, flags);
> +       wake_up_locked_poll(dcb->poll, dcb->active);
> +       dcb->active = 0;
> +       spin_unlock_irqrestore(&dcb->poll->lock, flags);
> +}
> +
> +static unsigned int dma_buf_poll(struct file *file, poll_table *poll)
> +{
> +       struct dma_buf *dmabuf;
> +       struct reservation_object *resv;
> +       unsigned long events;
> +
> +       dmabuf = file->private_data;
> +       if (!dmabuf || !dmabuf->resv)
> +               return POLLERR;
> +
> +       resv = dmabuf->resv;
> +
> +       poll_wait(file, &dmabuf->poll, poll);
> +
> +       events = poll_requested_events(poll) & (POLLIN | POLLOUT);
> +       if (!events)
> +               return 0;
> +
> +       ww_mutex_lock(&resv->lock, NULL);
> +
> +       if (resv->fence_excl && (!(events & POLLOUT) || resv->fence_shared_count == 0)) {
> +               struct dma_buf_poll_cb_t *dcb = &dmabuf->cb_excl;
> +               unsigned long pevents = POLLIN;
> +
> +               if (resv->fence_shared_count == 0)
> +                       pevents |= POLLOUT;
> +
> +               spin_lock_irq(&dmabuf->poll.lock);
> +               if (dcb->active) {
> +                       dcb->active |= pevents;
> +                       events &= ~pevents;
> +               } else
> +                       dcb->active = pevents;
> +               spin_unlock_irq(&dmabuf->poll.lock);
> +
> +               if (events & pevents) {
> +                       if (!fence_add_callback(resv->fence_excl,
> +                                               &dcb->cb, dma_buf_poll_cb))
> +                               events &= ~pevents;
> +                       else
> +                       // No callback queued, wake up any additional waiters.

couple spots w/ c++ comments, which I assume you didn't mean to leave?

Anyways, other than those minor things,

Reviewed-by: Rob Clark <robdclark@gmail.com>

> +                               dma_buf_poll_cb(NULL, &dcb->cb);
> +               }
> +       }
> +
> +       if ((events & POLLOUT) && resv->fence_shared_count > 0) {
> +               struct dma_buf_poll_cb_t *dcb = &dmabuf->cb_shared;
> +               int i;
> +
> +               /* Only queue a new callback if no event has fired yet */
> +               spin_lock_irq(&dmabuf->poll.lock);
> +               if (dcb->active)
> +                       events &= ~POLLOUT;
> +               else
> +                       dcb->active = POLLOUT;
> +               spin_unlock_irq(&dmabuf->poll.lock);
> +
> +               if (!(events & POLLOUT))
> +                       goto out;
> +
> +               for (i = 0; i < resv->fence_shared_count; ++i)
> +                       if (!fence_add_callback(resv->fence_shared[i],
> +                                               &dcb->cb, dma_buf_poll_cb)) {
> +                               events &= ~POLLOUT;
> +                               break;
> +                       }
> +
> +               // No callback queued, wake up any additional waiters.
> +               if (i == resv->fence_shared_count)
> +                       dma_buf_poll_cb(NULL, &dcb->cb);
> +       }
> +
> +out:
> +       ww_mutex_unlock(&resv->lock);
> +       return events;
> +}
> +
>  static const struct file_operations dma_buf_fops = {
>         .release        = dma_buf_release,
>         .mmap           = dma_buf_mmap_internal,
>         .llseek         = dma_buf_llseek,
> +       .poll           = dma_buf_poll,
>  };
>
>  /*
> @@ -171,6 +268,10 @@ struct dma_buf *dma_buf_export_named(void *priv, const struct dma_buf_ops *ops,
>         dmabuf->ops = ops;
>         dmabuf->size = size;
>         dmabuf->exp_name = exp_name;
> +       init_waitqueue_head(&dmabuf->poll);
> +       dmabuf->cb_excl.poll = dmabuf->cb_shared.poll = &dmabuf->poll;
> +       dmabuf->cb_excl.active = dmabuf->cb_shared.active = 0;
> +
>         if (!resv) {
>                 resv = (struct reservation_object*)&dmabuf[1];
>                 reservation_object_init(resv);
> diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
> index 34cfbac52c03..e1df18f584ef 100644
> --- a/include/linux/dma-buf.h
> +++ b/include/linux/dma-buf.h
> @@ -30,6 +30,8 @@
>  #include <linux/list.h>
>  #include <linux/dma-mapping.h>
>  #include <linux/fs.h>
> +#include <linux/fence.h>
> +#include <linux/wait.h>
>
>  struct device;
>  struct dma_buf;
> @@ -130,6 +132,16 @@ struct dma_buf {
>         struct list_head list_node;
>         void *priv;
>         struct reservation_object *resv;
> +
> +       /* poll support */
> +       wait_queue_head_t poll;
> +
> +       struct dma_buf_poll_cb_t {
> +               struct fence_cb cb;
> +               wait_queue_head_t *poll;
> +
> +               unsigned long active;
> +       } cb_excl, cb_shared;
>  };
>
>  /**
>
