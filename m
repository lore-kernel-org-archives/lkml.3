Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932486Ab3BISyZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2013 13:54:25 -0500
Received: from mail-ee0-f49.google.com ([74.125.83.49]:44897 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760818Ab3BISyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2013 13:54:24 -0500
Date: Sat, 9 Feb 2013 19:56:37 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Imre Deak <imre.deak@intel.com>
Cc: intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        Rahul Sharma <rahul.sharma@samsung.com>,
        LKML <linux-kernel@vger.kernel.org>, linaro-mm-sig@lists.linaro.org
Subject: Re: [Intel-gfx] [PATCH 1/4] drm: add helper to walk a dma scatter
 list a page at a time
Message-ID: <20130209185637.GT5813@phenom.ffwll.local>
Mail-Followup-To: Imre Deak <imre.deak@intel.com>,
	intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
	Rahul Sharma <rahul.sharma@samsung.com>,
	LKML <linux-kernel@vger.kernel.org>, linaro-mm-sig@lists.linaro.org
References: <1360423656-10816-1-git-send-email-imre.deak@intel.com>
 <1360423656-10816-2-git-send-email-imre.deak@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360423656-10816-2-git-send-email-imre.deak@intel.com>
X-Operating-System: Linux phenom 3.7.0-rc4+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Imre!

On Sat, Feb 09, 2013 at 05:27:33PM +0200, Imre Deak wrote:
> Add a helper to walk through a scatter list a page at a time. Needed by
> upcoming patches fixing the scatter list walking logic in the i915 driver.

Nice patch, but I think this would make a rather nice addition to the
common scatterlist api in scatterlist.h, maybe called sg_page_iter.
There's already another helper which does cpu mappings, but it has a
different use-case (gives you the page mapped, which we don't neeed and
can cope with not page-aligned sg tables). With dma-buf using sg tables I
expect more users of such a sg page iterator to pop up. Most possible
users of this will hang around on linaro-mm-sig, so please also cc that
besides the usual suspects.

Cheers, Daniel

> 
> Signed-off-by: Imre Deak <imre.deak@intel.com>
> ---
>  include/drm/drmP.h |   44 ++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 44 insertions(+)
> 
> diff --git a/include/drm/drmP.h b/include/drm/drmP.h
> index fad21c9..0c0c213 100644
> --- a/include/drm/drmP.h
> +++ b/include/drm/drmP.h
> @@ -1578,6 +1578,50 @@ extern int drm_sg_alloc_ioctl(struct drm_device *dev, void *data,
>  extern int drm_sg_alloc(struct drm_device *dev, struct drm_scatter_gather * request);
>  extern int drm_sg_free(struct drm_device *dev, void *data,
>  		       struct drm_file *file_priv);
> +struct drm_sg_iter {
> +	struct scatterlist *sg;
> +	int sg_offset;

Imo using sg_pfn_offset (i.e. sg_offset >> PAGE_SIZE) would make it
clearer that this is all about iterating page-aligned sg tables.

> +	struct page *page;
> +};
> +
> +static inline int
> +__drm_sg_iter_seek(struct drm_sg_iter *iter)
> +{
> +	while (iter->sg && iter->sg_offset >= iter->sg->length) {
> +		iter->sg_offset -= iter->sg->length;
> +		iter->sg = sg_next(iter->sg);

And adding a WARN_ON(sg->legnth & ~PAGE_MASK); here would enforce that.

> +	}
> +
> +	return iter->sg ? 0 : -1;
> +}
> +
> +static inline struct page *
> +drm_sg_iter_next(struct drm_sg_iter *iter)
> +{
> +	struct page *page;
> +
> +	if (__drm_sg_iter_seek(iter))
> +		return NULL;
> +
> +	page = nth_page(sg_page(iter->sg), iter->sg_offset >> PAGE_SHIFT);
> +	iter->sg_offset = (iter->sg_offset + PAGE_SIZE) & PAGE_MASK;
> +
> +	return page;
> +}
> +
> +static inline struct page *
> +drm_sg_iter_start(struct drm_sg_iter *iter, struct scatterlist *sg,
> +		   unsigned long offset)
> +{
> +	iter->sg = sg;
> +	iter->sg_offset = offset;
> +
> +	return drm_sg_iter_next(iter);
> +}
> +
> +#define drm_for_each_sg_page(iter, sg, pgoffset)			\
> +	for ((iter)->page = drm_sg_iter_start((iter), (sg), (pgoffset));\
> +	     (iter)->page; (iter)->page = drm_sg_iter_next(iter))

Again, for the initialization I'd go with page numbers, not an offset in
bytes.

>  
>  			       /* ATI PCIGART support (ati_pcigart.h) */
>  extern int drm_ati_pcigart_init(struct drm_device *dev,
> -- 
> 1.7.10.4
> 
> _______________________________________________
> Intel-gfx mailing list
> Intel-gfx@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/intel-gfx

-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
