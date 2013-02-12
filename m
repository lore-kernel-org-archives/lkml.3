Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933379Ab3BLRH0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 12:07:26 -0500
Received: from mga03.intel.com ([143.182.124.21]:41475 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932327Ab3BLRHZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 12:07:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,650,1355126400"; 
   d="scan'208";a="255978314"
Message-ID: <1360688840.5578.75.camel@localhost>
Subject: Re: [PATCH v2] lib/scatterlist: add simple page iterator
From: Imre Deak <imre.deak@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Maxim Levitsky <maximlevitsky@gmail.com>,
        Tejun Heo <tj@kernel.org>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        linaro-mm-sig@lists.linaro.org
Date: Tue, 12 Feb 2013 19:07:20 +0200
In-Reply-To: <20130211125422.978c1e99.akpm@linux-foundation.org>
References: <1353590706-1366-5-git-send-email-imre.deak@intel.com>
	 <1360608604-3520-1-git-send-email-imre.deak@intel.com>
	 <20130211125422.978c1e99.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-02-11 at 12:54 -0800, Andrew Morton wrote:
> On Mon, 11 Feb 2013 20:50:04 +0200
> Imre Deak <imre.deak@intel.com> wrote:
> 
> > Add an iterator to walk through a scatter list a page at a time starting
> > at a specific page offset. As opposed to the mapping iterator this is
> 
> What is "the mapping iterator"?

It's the one implemented by sg_miter_{start,stop} in scatterlist.c. It
also iterates through a scatterlist a page at a time, but it also kmaps
these pages. Since in our use case we don't need to map the pages we
needed a solution without this overhead.

> > meant to be small, performing well even in simple loops like collecting
> > all pages on the scatterlist into an array or setting up an iommu table
> > based on the pages' DMA address.
> 
> Where will this new macro be used?  What is driving this effort?

At the moment the only user of the macro would be the i915 driver, see
[1] for the patches that takes it into use. In the patchset the macro
was added as a DRM specific macro, but since it might be useful in the
future for other drivers too (anything using dma-buf) I'd like to add it
to a more generic place.

> > v2:
> > - In each iteration sg_pgoffset pointed incorrectly at the next page not
> >   the current one.
> > 
> > Signed-off-by: Imre Deak <imre.deak@intel.com>
> > ---
> >  include/linux/scatterlist.h |   50 +++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 50 insertions(+)
> > 
> > diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
> > index 4bd6c06..72578b5 100644
> > --- a/include/linux/scatterlist.h
> > +++ b/include/linux/scatterlist.h
> > @@ -231,6 +231,56 @@ size_t sg_copy_to_buffer(struct scatterlist *sgl, unsigned int nents,
> >   */
> >  #define SG_MAX_SINGLE_ALLOC		(PAGE_SIZE / sizeof(struct scatterlist))
> >  
> > +struct sg_page_iter {
> > +	struct scatterlist *sg;
> > +	int sg_pgoffset;
> > +	struct page *page;
> > +};
> 
> Some documentation wouldn't hurt.   What it's used for, why it exists.

Ok, will add it.

> 
> > +static inline int
> > +sg_page_cnt(struct scatterlist *sg)
> 
> unneeded newline here.
> 
> A more typical name would be "sg_page_count".  Stripping words of their
> vowels makes the symbols harder to remember.

Ok, will fix this.

> > +{
> > +	BUG_ON(sg->offset || sg->length & ~PAGE_MASK);
> > +
> > +	return sg->length >> PAGE_SHIFT;
> > +}
> > +
> > +static inline struct page *
> > +sg_page_iter_get_page(struct sg_page_iter *iter)
> > +{
> > +	while (iter->sg && iter->sg_pgoffset >= sg_page_cnt(iter->sg)) {
> > +		iter->sg_pgoffset -= sg_page_cnt(iter->sg);
> > +		iter->sg = sg_next(iter->sg);
> > +	}
> > +
> > +	return iter->sg ? nth_page(sg_page(iter->sg), iter->sg_pgoffset) : NULL;
> > +}
> > +
> > +static inline void
> > +sg_page_iter_next(struct sg_page_iter *iter)
> > +{
> > +	iter->sg_pgoffset++;
> > +	iter->page = sg_page_iter_get_page(iter);
> > +}
> > +
> > +static inline void
> > +sg_page_iter_start(struct sg_page_iter *iter, struct scatterlist *sglist,
> > +		   unsigned long pgoffset)
> > +{
> > +	iter->sg = sglist;
> > +	iter->sg_pgoffset = pgoffset;
> > +	iter->page = sg_page_iter_get_page(iter);
> > +}
> 
> All the above are undocumented also.  I guess that's acceptable if they
> are only ever to be used by for_each_sg_page().  Although if that's the
> case then perhaps the identifiers should be a bit more obscure-looking.
> Usually we prefix them with "__" to say "this is in internal thing".

Yes, they are meant to be used only internally, so I'll add the __
prefix.

> > +/*
> > + * Simple sg page iterator, starting off at the given page offset. Each entry
> > + * on the sglist must start at offset 0 and can contain only full pages.
> > + * iter->page will point to the current page, iter->sg_pgoffset to the page
> > + * offset within the sg holding that page.
> > + */
> > +#define for_each_sg_page(sglist, iter, pgoffset)				\
> > +	for (sg_page_iter_start((iter), (sglist), (pgoffset));		\
> > +	     (iter)->page; sg_page_iter_next(iter))
> 
> Because all the helper functions are inlined, this will expand to a
> quite large amount of code.  And large code can be slow code due to
> I-cache eviction.
> 
> I don't know *how* big this thing will be because the patch didn't
> include a caller and I can't be bothered writing my own.  (And the lack
> of any caller means that the code will not be tested).
> 
> So, exactly how big is this thing, and how do we know it's better this
> way than if we were to uninline some/all of the helpers?

I admit I only hoped compiler optimization would keep the inlined parts
at a minimum, but now I actually checked (on Intel CPU). I applied the
patchset from [1] and uninlined sg_page_iter_start as it's not
significant for speed:

 size drivers/gpu/drm/i915/i915.ko
 514855	  15996	    272	 531123	  81ab3	drivers/gpu/drm/i915/i915.ko

Then uninlined all helpers:
 size drivers/gpu/drm/i915/i915.ko
 513447	  15996	    272	 529715	  81533	drivers/gpu/drm/i915/i915.ko

Since there are 8 invocations of the macro, the overhead for a single
invocation is about (531123 - 529715) / 8 = 191 bytes.

For speed, I benchmarked a simple loop which was basically:

page = vmalloc(sizeof(*page) * 1000, GFP_KERNEL);
for_each_sg_page(sglist, iter, 0)
	*page++ = iter.page;

where each entry on the sglist contained 16 consecutive pages. This
takes ~10% more time for the uninlined version to run. This is a rather
artificial test and I couldn't come up with something more real-life
using only the i915 driver's ioctl interface that would show a
significant change in speed.

So at least for now I'm ok with just uninlining all the helpers.

Thanks for the review,
Imre

[1]
http://lists.freedesktop.org/archives/intel-gfx/2013-February/024589.html

