Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932470Ab3BKUyZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 15:54:25 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40785 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932309Ab3BKUyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 15:54:24 -0500
Date: Mon, 11 Feb 2013 12:54:22 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Imre Deak <imre.deak@intel.com>
Cc: linux-kernel@vger.kernel.org, Maxim Levitsky <maximlevitsky@gmail.com>,
        Tejun Heo <tj@kernel.org>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        linaro-mm-sig@lists.linaro.org
Subject: Re: [PATCH v2] lib/scatterlist: add simple page iterator
Message-Id: <20130211125422.978c1e99.akpm@linux-foundation.org>
In-Reply-To: <1360608604-3520-1-git-send-email-imre.deak@intel.com>
References: <1353590706-1366-5-git-send-email-imre.deak@intel.com>
	<1360608604-3520-1-git-send-email-imre.deak@intel.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Feb 2013 20:50:04 +0200
Imre Deak <imre.deak@intel.com> wrote:

> Add an iterator to walk through a scatter list a page at a time starting
> at a specific page offset. As opposed to the mapping iterator this is

What is "the mapping iterator"?

> meant to be small, performing well even in simple loops like collecting
> all pages on the scatterlist into an array or setting up an iommu table
> based on the pages' DMA address.

Where will this new macro be used?  What is driving this effort?

> v2:
> - In each iteration sg_pgoffset pointed incorrectly at the next page not
>   the current one.
> 
> Signed-off-by: Imre Deak <imre.deak@intel.com>
> ---
>  include/linux/scatterlist.h |   50 +++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 50 insertions(+)
> 
> diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
> index 4bd6c06..72578b5 100644
> --- a/include/linux/scatterlist.h
> +++ b/include/linux/scatterlist.h
> @@ -231,6 +231,56 @@ size_t sg_copy_to_buffer(struct scatterlist *sgl, unsigned int nents,
>   */
>  #define SG_MAX_SINGLE_ALLOC		(PAGE_SIZE / sizeof(struct scatterlist))
>  
> +struct sg_page_iter {
> +	struct scatterlist *sg;
> +	int sg_pgoffset;
> +	struct page *page;
> +};

Some documentation wouldn't hurt.   What it's used for, why it exists.

> +static inline int
> +sg_page_cnt(struct scatterlist *sg)

unneeded newline here.

A more typical name would be "sg_page_count".  Stripping words of their
vowels makes the symbols harder to remember.

> +{
> +	BUG_ON(sg->offset || sg->length & ~PAGE_MASK);
> +
> +	return sg->length >> PAGE_SHIFT;
> +}
> +
> +static inline struct page *
> +sg_page_iter_get_page(struct sg_page_iter *iter)
> +{
> +	while (iter->sg && iter->sg_pgoffset >= sg_page_cnt(iter->sg)) {
> +		iter->sg_pgoffset -= sg_page_cnt(iter->sg);
> +		iter->sg = sg_next(iter->sg);
> +	}
> +
> +	return iter->sg ? nth_page(sg_page(iter->sg), iter->sg_pgoffset) : NULL;
> +}
> +
> +static inline void
> +sg_page_iter_next(struct sg_page_iter *iter)
> +{
> +	iter->sg_pgoffset++;
> +	iter->page = sg_page_iter_get_page(iter);
> +}
> +
> +static inline void
> +sg_page_iter_start(struct sg_page_iter *iter, struct scatterlist *sglist,
> +		   unsigned long pgoffset)
> +{
> +	iter->sg = sglist;
> +	iter->sg_pgoffset = pgoffset;
> +	iter->page = sg_page_iter_get_page(iter);
> +}

All the above are undocumented also.  I guess that's acceptable if they
are only ever to be used by for_each_sg_page().  Although if that's the
case then perhaps the identifiers should be a bit more obscure-looking.
Usually we prefix them with "__" to say "this is in internal thing".

> +/*
> + * Simple sg page iterator, starting off at the given page offset. Each entry
> + * on the sglist must start at offset 0 and can contain only full pages.
> + * iter->page will point to the current page, iter->sg_pgoffset to the page
> + * offset within the sg holding that page.
> + */
> +#define for_each_sg_page(sglist, iter, pgoffset)				\
> +	for (sg_page_iter_start((iter), (sglist), (pgoffset));		\
> +	     (iter)->page; sg_page_iter_next(iter))

Because all the helper functions are inlined, this will expand to a
quite large amount of code.  And large code can be slow code due to
I-cache eviction.

I don't know *how* big this thing will be because the patch didn't
include a caller and I can't be bothered writing my own.  (And the lack
of any caller means that the code will not be tested).

So, exactly how big is this thing, and how do we know it's better this
way than if we were to uninline some/all of the helpers?

