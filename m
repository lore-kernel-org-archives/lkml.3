Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209Ab3LVOMU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Dec 2013 09:12:20 -0500
Received: from mailout3.w2.samsung.com ([211.189.100.13]:53561 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752290Ab3LVOMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Dec 2013 09:12:18 -0500
X-AuditID: cbfec372-b7fa96d000006a7b-50-52b6f3403c71
Date: Sun, 22 Dec 2013 12:12:06 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Rob Clark <robdclark@gmail.com>
Cc: Colin Cross <ccross@android.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Airlie <airlied@linux.ie>, Inki Dae <inki.dae@samsung.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        "open list:DMA BUFFER SHARIN..." <linux-media@vger.kernel.org>,
        "open list:DMA BUFFER SHARIN..." <dri-devel@lists.freedesktop.org>,
        "open list:DMA BUFFER SHARIN..." <linaro-mm-sig@lists.linaro.org>,
        "moderated list:ARM/S5P EXYNOS AR..." 
	<linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/S5P EXYNOS AR..." 
	<linux-samsung-soc@vger.kernel.org>
Subject: Re: [PATCH] dma-buf: avoid using IS_ERR_OR_NULL
Message-id: <20131222121206.624e56fe@samsung.com>
In-reply-to: <CAF6AEGuQSWOw6KWVo-uorJ+8M3-kLzYHdOOfdHWUDi=SkzUUVA@mail.gmail.com>
References: <1387586630-1954-1-git-send-email-ccross@android.com>
 <CAF6AEGuQSWOw6KWVo-uorJ+8M3-kLzYHdOOfdHWUDi=SkzUUVA@mail.gmail.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIIsWRmVeSWpSXmKPExsVy+t/hIF2Hz9uCDGYdNrLoPXeSyWL7xm+s
	Fle+vmezaF68ns1i0v0JLBYv7l1ksehdcJXN4mzTG3aLL1ceMllsenyN1eLyrjlsFj0btrJa
	zDi/j8li7ZG77BZT3v5kt3i+8Aezxam7n9ktZkx+yeYg5LFt9zZWj52z7rJ73Lm2h81j+7cH
	rB77565h97jffZzJY/OSeo/b/x4zezz+9ZLNo2/LKkaPz5vkArijuGxSUnMyy1KL9O0SuDIW
	X+cpWGpR8eL6HZYGxl1aXYycHBICJhJHLzxkh7DFJC7cW8/WxcjFISSwhFHie+M1Zginh0ni
	3eQeRpAqFgFViQv3H4HZbAJGEq8aW1hBbBEBZYlVW/ezgNjMAo/YJD72WYPYwgIWEgt2n2cG
	sXkFDCUOHoGo5xQIlnh5oQ1qQQejxIzufUBncACd4SSx+4AURL2gxI/J96Bmakls3tbECmHL
	S2xe85Z5AqPALCRls5CUzUJStoCReRWjaGlxckFxUnquoV5xYm5xaV66XnJ+7iZGSDQW7WB8
	tsHqEKMAB6MSD2+G2LYgIdbEsuLK3EOMEhzMSiK8IdeBQrwpiZVVqUX58UWlOanFhxiZODil
	Ghitzk1sk9+6gvOhPKPQk8/6tTrSDTrn3P4/MCgO/l77ZFvzqcpLJis6/U+ryjF/uKn7VZ33
	9S795KtCJj/8Fu7m9WOx3+o4ccOTyOUVrVMOHvq9IFn8/qPHb1a9ZnzE3OUjLhZ42fkv8zax
	y6pnZk22zZvNJnV89qf9n4pCu44d3T5R48rKnHc7lViKMxINtZiLihMBmq5RKaQCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sat, 21 Dec 2013 07:42:17 -0500
Rob Clark <robdclark@gmail.com> escreveu:

> On Fri, Dec 20, 2013 at 7:43 PM, Colin Cross <ccross@android.com> wrote:
> > dma_buf_map_attachment and dma_buf_vmap can return NULL or
> > ERR_PTR on a error.  This encourages a common buggy pattern in
> > callers:
> >         sgt = dma_buf_map_attachment(attach, DMA_BIDIRECTIONAL);
> >         if (IS_ERR_OR_NULL(sgt))
> >                 return PTR_ERR(sgt);
> >
> > This causes the caller to return 0 on an error.  IS_ERR_OR_NULL
> > is almost always a sign of poorly-defined error handling.
> >
> > This patch converts dma_buf_map_attachment to always return
> > ERR_PTR, and fixes the callers that incorrectly handled NULL.
> > There are a few more callers that were not checking for NULL
> > at all, which would have dereferenced a NULL pointer later.
> > There are also a few more callers that correctly handled NULL
> > and ERR_PTR differently, I left those alone but they could also
> > be modified to delete the NULL check.
> >
> > This patch also converts dma_buf_vmap to always return NULL.
> > All the callers to dma_buf_vmap only check for NULL, and would
> > have dereferenced an ERR_PTR and panic'd if one was ever
> > returned. This is not consistent with the rest of the dma buf
> > APIs, but matches the expectations of all of the callers.
> >
> > Signed-off-by: Colin Cross <ccross@android.com>
> > ---
> >  drivers/base/dma-buf.c                         | 18 +++++++++++-------
> >  drivers/gpu/drm/drm_prime.c                    |  2 +-
> >  drivers/gpu/drm/exynos/exynos_drm_dmabuf.c     |  2 +-
> >  drivers/media/v4l2-core/videobuf2-dma-contig.c |  2 +-
> >  4 files changed, 14 insertions(+), 10 deletions(-)
> >
> > diff --git a/drivers/base/dma-buf.c b/drivers/base/dma-buf.c
> > index 1e16cbd61da2..cfe1d8bc7bb8 100644
> > --- a/drivers/base/dma-buf.c
> > +++ b/drivers/base/dma-buf.c
> > @@ -251,9 +251,8 @@ EXPORT_SYMBOL_GPL(dma_buf_put);
> >   * @dmabuf:    [in]    buffer to attach device to.
> >   * @dev:       [in]    device to be attached.
> >   *
> > - * Returns struct dma_buf_attachment * for this attachment; may return negative
> > - * error codes.
> > - *
> > + * Returns struct dma_buf_attachment * for this attachment; returns ERR_PTR on
> > + * error.
> >   */
> >  struct dma_buf_attachment *dma_buf_attach(struct dma_buf *dmabuf,
> >                                           struct device *dev)
> > @@ -319,9 +318,8 @@ EXPORT_SYMBOL_GPL(dma_buf_detach);
> >   * @attach:    [in]    attachment whose scatterlist is to be returned
> >   * @direction: [in]    direction of DMA transfer
> >   *
> > - * Returns sg_table containing the scatterlist to be returned; may return NULL
> > - * or ERR_PTR.
> > - *
> > + * Returns sg_table containing the scatterlist to be returned; returns ERR_PTR
> > + * on error.
> >   */
> >  struct sg_table *dma_buf_map_attachment(struct dma_buf_attachment *attach,
> >                                         enum dma_data_direction direction)
> > @@ -334,6 +332,8 @@ struct sg_table *dma_buf_map_attachment(struct dma_buf_attachment *attach,
> >                 return ERR_PTR(-EINVAL);
> >
> >         sg_table = attach->dmabuf->ops->map_dma_buf(attach, direction);
> > +       if (!sg_table)
> > +               sg_table = ERR_PTR(-ENOMEM);
> >
> >         return sg_table;
> >  }
> > @@ -544,6 +544,8 @@ EXPORT_SYMBOL_GPL(dma_buf_mmap);
> >   * These calls are optional in drivers. The intended use for them
> >   * is for mapping objects linear in kernel space for high use objects.
> >   * Please attempt to use kmap/kunmap before thinking about these interfaces.
> > + *
> > + * Returns NULL on error.
> >   */
> >  void *dma_buf_vmap(struct dma_buf *dmabuf)
> >  {
> > @@ -566,7 +568,9 @@ void *dma_buf_vmap(struct dma_buf *dmabuf)
> >         BUG_ON(dmabuf->vmap_ptr);
> >
> >         ptr = dmabuf->ops->vmap(dmabuf);
> > -       if (IS_ERR_OR_NULL(ptr))
> > +       if (WARN_ON_ONCE(IS_ERR(ptr)))
> 
> since vmap is optional, the WARN_ON might be a bit strong..  although
> it would be a bit strange for an exporter to supply a vmap fxn which
> always returned NULL, not sure about that.  Just thought I'd mention
> it in case anyone else had an opinion about that.
> 
> But either way:
> 
> Reviewed-by: Rob Clark <robdclark@gmail.com>

IMHO, a WARN_ON_ONCE() here (or some other error report printk) seems ok, 
as, if this function is called, the caller would be expecting it to not
fail.

Either way:

Reviewed-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

> 
> 
> > +               ptr = NULL;
> > +       if (!ptr)
> >                 goto out_unlock;
> >
> >         dmabuf->vmap_ptr = ptr;
> > diff --git a/drivers/gpu/drm/drm_prime.c b/drivers/gpu/drm/drm_prime.c
> > index 56805c39c906..bb516fdd195d 100644
> > --- a/drivers/gpu/drm/drm_prime.c
> > +++ b/drivers/gpu/drm/drm_prime.c
> > @@ -471,7 +471,7 @@ struct drm_gem_object *drm_gem_prime_import(struct drm_device *dev,
> >         get_dma_buf(dma_buf);
> >
> >         sgt = dma_buf_map_attachment(attach, DMA_BIDIRECTIONAL);
> > -       if (IS_ERR_OR_NULL(sgt)) {
> > +       if (IS_ERR(sgt)) {
> >                 ret = PTR_ERR(sgt);
> >                 goto fail_detach;
> >         }
> > diff --git a/drivers/gpu/drm/exynos/exynos_drm_dmabuf.c b/drivers/gpu/drm/exynos/exynos_drm_dmabuf.c
> > index 59827cc5e770..c786cd4f457b 100644
> > --- a/drivers/gpu/drm/exynos/exynos_drm_dmabuf.c
> > +++ b/drivers/gpu/drm/exynos/exynos_drm_dmabuf.c
> > @@ -224,7 +224,7 @@ struct drm_gem_object *exynos_dmabuf_prime_import(struct drm_device *drm_dev,
> >         get_dma_buf(dma_buf);
> >
> >         sgt = dma_buf_map_attachment(attach, DMA_BIDIRECTIONAL);
> > -       if (IS_ERR_OR_NULL(sgt)) {
> > +       if (IS_ERR(sgt)) {
> >                 ret = PTR_ERR(sgt);
> >                 goto err_buf_detach;
> >         }
> > diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
> > index 33d3871d1e13..880be0782dd9 100644
> > --- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
> > +++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
> > @@ -719,7 +719,7 @@ static int vb2_dc_map_dmabuf(void *mem_priv)
> >
> >         /* get the associated scatterlist for this buffer */
> >         sgt = dma_buf_map_attachment(buf->db_attach, buf->dma_dir);
> > -       if (IS_ERR_OR_NULL(sgt)) {
> > +       if (IS_ERR(sgt)) {
> >                 pr_err("Error getting dmabuf scatterlist\n");
> >                 return -EINVAL;
> >         }
> > --
> > 1.8.5.1
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 

Cheers,
Mauro
