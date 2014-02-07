Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752901AbaBGRWo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 12:22:44 -0500
Received: from mail-oa0-f47.google.com ([209.85.219.47]:37365 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752822AbaBGRWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 12:22:39 -0500
MIME-Version: 1.0
In-Reply-To: <20140207164313.GA32655@kroah.com>
References: <1387586630-1954-1-git-send-email-ccross@android.com>
	<CAF6AEGuQSWOw6KWVo-uorJ+8M3-kLzYHdOOfdHWUDi=SkzUUVA@mail.gmail.com>
	<20140207164313.GA32655@kroah.com>
Date: Fri, 7 Feb 2014 09:22:37 -0800
X-Google-Sender-Auth: 2ZAYbdLsUx7Qmw0QTsLJwu8AC5U
Message-ID: <CAMbhsRQXUZH_n13X78HEvXuF58T-ubAXnEXXPa7Za9L-KEduMQ@mail.gmail.com>
Subject: Re: [PATCH] dma-buf: avoid using IS_ERR_OR_NULL
From: Colin Cross <ccross@android.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Rob Clark <robdclark@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        David Airlie <airlied@linux.ie>, Inki Dae <inki.dae@samsung.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        "open list:DMA BUFFER SHARIN..." <linux-media@vger.kernel.org>,
        "open list:DMA BUFFER SHARIN..." <dri-devel@lists.freedesktop.org>,
        "open list:DMA BUFFER SHARIN..." <linaro-mm-sig@lists.linaro.org>,
        "moderated list:ARM/S5P EXYNOS AR..." 
	<linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/S5P EXYNOS AR..." 
	<linux-samsung-soc@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 7, 2014 at 8:43 AM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Sat, Dec 21, 2013 at 07:42:17AM -0500, Rob Clark wrote:
>> On Fri, Dec 20, 2013 at 7:43 PM, Colin Cross <ccross@android.com> wrote:
>> > dma_buf_map_attachment and dma_buf_vmap can return NULL or
>> > ERR_PTR on a error.  This encourages a common buggy pattern in
>> > callers:
>> >         sgt = dma_buf_map_attachment(attach, DMA_BIDIRECTIONAL);
>> >         if (IS_ERR_OR_NULL(sgt))
>> >                 return PTR_ERR(sgt);
>> >
>> > This causes the caller to return 0 on an error.  IS_ERR_OR_NULL
>> > is almost always a sign of poorly-defined error handling.
>> >
>> > This patch converts dma_buf_map_attachment to always return
>> > ERR_PTR, and fixes the callers that incorrectly handled NULL.
>> > There are a few more callers that were not checking for NULL
>> > at all, which would have dereferenced a NULL pointer later.
>> > There are also a few more callers that correctly handled NULL
>> > and ERR_PTR differently, I left those alone but they could also
>> > be modified to delete the NULL check.
>> >
>> > This patch also converts dma_buf_vmap to always return NULL.
>> > All the callers to dma_buf_vmap only check for NULL, and would
>> > have dereferenced an ERR_PTR and panic'd if one was ever
>> > returned. This is not consistent with the rest of the dma buf
>> > APIs, but matches the expectations of all of the callers.
>> >
>> > Signed-off-by: Colin Cross <ccross@android.com>
>> > ---
>> >  drivers/base/dma-buf.c                         | 18 +++++++++++-------
>> >  drivers/gpu/drm/drm_prime.c                    |  2 +-
>> >  drivers/gpu/drm/exynos/exynos_drm_dmabuf.c     |  2 +-
>> >  drivers/media/v4l2-core/videobuf2-dma-contig.c |  2 +-
>> >  4 files changed, 14 insertions(+), 10 deletions(-)
>> >
>> > diff --git a/drivers/base/dma-buf.c b/drivers/base/dma-buf.c
>> > index 1e16cbd61da2..cfe1d8bc7bb8 100644
>> > --- a/drivers/base/dma-buf.c
>> > +++ b/drivers/base/dma-buf.c
>> > @@ -251,9 +251,8 @@ EXPORT_SYMBOL_GPL(dma_buf_put);
>> >   * @dmabuf:    [in]    buffer to attach device to.
>> >   * @dev:       [in]    device to be attached.
>> >   *
>> > - * Returns struct dma_buf_attachment * for this attachment; may return negative
>> > - * error codes.
>> > - *
>> > + * Returns struct dma_buf_attachment * for this attachment; returns ERR_PTR on
>> > + * error.
>> >   */
>> >  struct dma_buf_attachment *dma_buf_attach(struct dma_buf *dmabuf,
>> >                                           struct device *dev)
>> > @@ -319,9 +318,8 @@ EXPORT_SYMBOL_GPL(dma_buf_detach);
>> >   * @attach:    [in]    attachment whose scatterlist is to be returned
>> >   * @direction: [in]    direction of DMA transfer
>> >   *
>> > - * Returns sg_table containing the scatterlist to be returned; may return NULL
>> > - * or ERR_PTR.
>> > - *
>> > + * Returns sg_table containing the scatterlist to be returned; returns ERR_PTR
>> > + * on error.
>> >   */
>> >  struct sg_table *dma_buf_map_attachment(struct dma_buf_attachment *attach,
>> >                                         enum dma_data_direction direction)
>> > @@ -334,6 +332,8 @@ struct sg_table *dma_buf_map_attachment(struct dma_buf_attachment *attach,
>> >                 return ERR_PTR(-EINVAL);
>> >
>> >         sg_table = attach->dmabuf->ops->map_dma_buf(attach, direction);
>> > +       if (!sg_table)
>> > +               sg_table = ERR_PTR(-ENOMEM);
>> >
>> >         return sg_table;
>> >  }
>> > @@ -544,6 +544,8 @@ EXPORT_SYMBOL_GPL(dma_buf_mmap);
>> >   * These calls are optional in drivers. The intended use for them
>> >   * is for mapping objects linear in kernel space for high use objects.
>> >   * Please attempt to use kmap/kunmap before thinking about these interfaces.
>> > + *
>> > + * Returns NULL on error.
>> >   */
>> >  void *dma_buf_vmap(struct dma_buf *dmabuf)
>> >  {
>> > @@ -566,7 +568,9 @@ void *dma_buf_vmap(struct dma_buf *dmabuf)
>> >         BUG_ON(dmabuf->vmap_ptr);
>> >
>> >         ptr = dmabuf->ops->vmap(dmabuf);
>> > -       if (IS_ERR_OR_NULL(ptr))
>> > +       if (WARN_ON_ONCE(IS_ERR(ptr)))
>>
>> since vmap is optional, the WARN_ON might be a bit strong..  although
>> it would be a bit strange for an exporter to supply a vmap fxn which
>> always returned NULL, not sure about that.  Just thought I'd mention
>> it in case anyone else had an opinion about that.
>
> Yeah, I don't like this, it could cause unnecessary reports of problems.

The WARN_ON_ONCE is only if the vmap op returns ERR_PTR, not if it
returns NULL.  This is designed to catch vmap ops that don't follow
the spec, so I would call them necessary reports, but I can take it
out if you still disagree.
