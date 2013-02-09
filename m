Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760868Ab3BIWzO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2013 17:55:14 -0500
Received: from mga02.intel.com ([134.134.136.20]:43723 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757982Ab3BIWzM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2013 17:55:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,634,1355126400"; 
   d="scan'208";a="283599896"
Message-ID: <1360450508.5252.15.camel@ideak-mobl>
Subject: Re: [Intel-gfx] [PATCH 1/4] drm: add helper to walk a dma scatter
 list a page at a time
From: Imre Deak <imre.deak@intel.com>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        Rahul Sharma <rahul.sharma@samsung.com>,
        LKML <linux-kernel@vger.kernel.org>, linaro-mm-sig@lists.linaro.org
Date: Sun, 10 Feb 2013 00:55:08 +0200
In-Reply-To: <20130209185637.GT5813@phenom.ffwll.local>
References: <1360423656-10816-1-git-send-email-imre.deak@intel.com>
	 <1360423656-10816-2-git-send-email-imre.deak@intel.com>
	 <20130209185637.GT5813@phenom.ffwll.local>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-02-09 at 19:56 +0100, Daniel Vetter wrote:
> Hi Imre!
> 
> On Sat, Feb 09, 2013 at 05:27:33PM +0200, Imre Deak wrote:
> > Add a helper to walk through a scatter list a page at a time. Needed by
> > upcoming patches fixing the scatter list walking logic in the i915 driver.
> 
> Nice patch, but I think this would make a rather nice addition to the
> common scatterlist api in scatterlist.h, maybe called sg_page_iter.
> There's already another helper which does cpu mappings, but it has a
> different use-case (gives you the page mapped, which we don't neeed and
> can cope with not page-aligned sg tables). With dma-buf using sg tables I
> expect more users of such a sg page iterator to pop up. Most possible
> users of this will hang around on linaro-mm-sig, so please also cc that
> besides the usual suspects.

Ok, I wanted to sneak this in to drm (and win some time) thinking there
isn't any other user of it atm. But I agree the ideal place for it is in
scatterlist.h, so will send it there.

> Cheers, Daniel
> 
> > 
> > Signed-off-by: Imre Deak <imre.deak@intel.com>
> > ---
> >  include/drm/drmP.h |   44 ++++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 44 insertions(+)
> > 
> > diff --git a/include/drm/drmP.h b/include/drm/drmP.h
> > index fad21c9..0c0c213 100644
> > --- a/include/drm/drmP.h
> > +++ b/include/drm/drmP.h
> > @@ -1578,6 +1578,50 @@ extern int drm_sg_alloc_ioctl(struct drm_device *dev, void *data,
> >  extern int drm_sg_alloc(struct drm_device *dev, struct drm_scatter_gather * request);
> >  extern int drm_sg_free(struct drm_device *dev, void *data,
> >  		       struct drm_file *file_priv);
> > +struct drm_sg_iter {
> > +	struct scatterlist *sg;
> > +	int sg_offset;
> 
> Imo using sg_pfn_offset (i.e. sg_offset >> PAGE_SIZE) would make it
> clearer that this is all about iterating page-aligned sg tables.
> 
> > +	struct page *page;
> > +};
> > +
> > +static inline int
> > +__drm_sg_iter_seek(struct drm_sg_iter *iter)
> > +{
> > +	while (iter->sg && iter->sg_offset >= iter->sg->length) {
> > +		iter->sg_offset -= iter->sg->length;
> > +		iter->sg = sg_next(iter->sg);
> 
> And adding a WARN_ON(sg->legnth & ~PAGE_MASK); here would enforce that.
> 
> > +	}
> > +
> > +	return iter->sg ? 0 : -1;
> > +}
> > +
> > +static inline struct page *
> > +drm_sg_iter_next(struct drm_sg_iter *iter)
> > +{
> > +	struct page *page;
> > +
> > +	if (__drm_sg_iter_seek(iter))
> > +		return NULL;
> > +
> > +	page = nth_page(sg_page(iter->sg), iter->sg_offset >> PAGE_SHIFT);
> > +	iter->sg_offset = (iter->sg_offset + PAGE_SIZE) & PAGE_MASK;
> > +
> > +	return page;
> > +}
> > +
> > +static inline struct page *
> > +drm_sg_iter_start(struct drm_sg_iter *iter, struct scatterlist *sg,
> > +		   unsigned long offset)
> > +{
> > +	iter->sg = sg;
> > +	iter->sg_offset = offset;
> > +
> > +	return drm_sg_iter_next(iter);
> > +}
> > +
> > +#define drm_for_each_sg_page(iter, sg, pgoffset)			\
> > +	for ((iter)->page = drm_sg_iter_start((iter), (sg), (pgoffset));\
> > +	     (iter)->page; (iter)->page = drm_sg_iter_next(iter))
> 
> Again, for the initialization I'd go with page numbers, not an offset in
> bytes.

Ok, can change it to use page numbers instead.

--Imre


