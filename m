Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757928Ab3APX70 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 18:59:26 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:47742 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755120Ab3APX7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 18:59:25 -0500
X-AuditID: 9c93016f-b7b70ae000000e36-5f-50f73edaa205
Date: Thu, 17 Jan 2013 08:59:22 +0900
From: Minchan Kim <minchan@kernel.org>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        js1304@gmail.com, Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Nitin Gupta <ngupta@vflare.org>
Subject: Re: [RFC PATCH 1/3] staging, zsmalloc: introduce zs_mem_[read/write]
Message-ID: <20130116235922.GA18669@blaptop>
References: <1358323737-13396-1-git-send-email-iamjoonsoo.kim@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358323737-13396-1-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joonsoo,

On Wed, Jan 16, 2013 at 05:08:55PM +0900, Joonsoo Kim wrote:
> If object is on boundary of page, zs_map_object() copy content of object
> to pre-allocated page and return virtual address of

IMHO, for reviewer reading easily, it would be better to specify explict
word instead of abstract.

pre-allocated pages : vm_buf which is reserved pages for zsmalloc
    
> this pre-allocated page. If user inform zsmalloc of memcpy region,
> we can avoid this copy overhead.

That's a good idea!

> This patch implement two API and these get information of memcpy region.
> Using this information, we can do memcpy without overhead.

For the clarification,

                          we can reduce copy overhead with this patch
                          in !USE_PGTABLE_MAPPING case.

> 
> For USE_PGTABLE_MAPPING case, we can avoid flush cache and tlb overhead
> via these API.

Yeb!

> 
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> ---
> These are [RFC] patches, because I don't test and
> I don't have test environment, yet. Just compile test done.
> If there is positive comment, I will setup test env and check correctness.
> These are based on v3.8-rc3.
> If rebase is needed, please notify me what tree I should rebase.

Whenever you send zsmalloc/zram/zcache, you have to based on recent linux-next.
But I hope we send the patches to akpm by promoting soon. :(

> 
> diff --git a/drivers/staging/zsmalloc/zsmalloc-main.c b/drivers/staging/zsmalloc/zsmalloc-main.c
> index 09a9d35..e3ef5a5 100644
> --- a/drivers/staging/zsmalloc/zsmalloc-main.c
> +++ b/drivers/staging/zsmalloc/zsmalloc-main.c
> @@ -1045,6 +1045,118 @@ void zs_unmap_object(struct zs_pool *pool, unsigned long handle)
>  }
>  EXPORT_SYMBOL_GPL(zs_unmap_object);
>  

It's exported function. Please write description.

> +void zs_mem_read(struct zs_pool *pool, unsigned long handle,
> +			void *dest, unsigned long src_off, size_t n)

n is meaningless, please use meaningful word.
How about this?
                        void *buf, unsigned long offset, size_t count

> +{
> +	struct page *page;
> +	unsigned long obj_idx, off;
> +
> +	unsigned int class_idx;
> +	enum fullness_group fg;
> +	struct size_class *class;
> +	struct page *pages[2];
> +	int sizes[2];
> +	void *addr;
> +
> +	BUG_ON(!handle);
> +
> +	/*
> +	 * Because we use per-cpu mapping areas shared among the
> +	 * pools/users, we can't allow mapping in interrupt context
> +	 * because it can corrupt another users mappings.
> +	 */
> +	BUG_ON(in_interrupt());
> +
> +	obj_handle_to_location(handle, &page, &obj_idx);
> +	get_zspage_mapping(get_first_page(page), &class_idx, &fg);
> +	class = &pool->size_class[class_idx];
> +	off = obj_idx_to_offset(page, obj_idx, class->size);
> +	off += src_off;
> +
> +	BUG_ON(class->size < n);
> +
> +	if (off + n <= PAGE_SIZE) {
> +		/* this object is contained entirely within a page */
> +		addr = kmap_atomic(page);
> +		memcpy(dest, addr + off, n);
> +		kunmap_atomic(addr);
> +		return;
> +	}
> +
> +	/* this object spans two pages */
> +	pages[0] = page;
> +	pages[1] = get_next_page(page);
> +	BUG_ON(!pages[1]);
> +
> +	sizes[0] = PAGE_SIZE - off;
> +	sizes[1] = n - sizes[0];
> +
> +	addr = kmap_atomic(pages[0]);
> +	memcpy(dest, addr + off, sizes[0]);
> +	kunmap_atomic(addr);
> +
> +	addr = kmap_atomic(pages[1]);
> +	memcpy(dest + sizes[0], addr, sizes[1]);
> +	kunmap_atomic(addr);
> +}
> +EXPORT_SYMBOL_GPL(zs_mem_read);
> +

Ditto. Write descriptoin.

> +void zs_mem_write(struct zs_pool *pool, unsigned long handle,
> +			const void *src, unsigned long dest_off, size_t n)
> +{
> +	struct page *page;
> +	unsigned long obj_idx, off;
> +
> +	unsigned int class_idx;
> +	enum fullness_group fg;
> +	struct size_class *class;
> +	struct page *pages[2];
> +	int sizes[2];
> +	void *addr;
> +
> +	BUG_ON(!handle);
> +
> +	/*
> +	 * Because we use per-cpu mapping areas shared among the
> +	 * pools/users, we can't allow mapping in interrupt context
> +	 * because it can corrupt another users mappings.
> +	 */
> +	BUG_ON(in_interrupt());
> +
> +	obj_handle_to_location(handle, &page, &obj_idx);
> +	get_zspage_mapping(get_first_page(page), &class_idx, &fg);
> +	class = &pool->size_class[class_idx];
> +	off = obj_idx_to_offset(page, obj_idx, class->size);
> +	off += dest_off;
> +
> +	BUG_ON(class->size < n);
> +
> +	if (off + n <= PAGE_SIZE) {
> +		/* this object is contained entirely within a page */
> +		addr = kmap_atomic(page);
> +		memcpy(addr + off, src, n);
> +		kunmap_atomic(addr);
> +		return;
> +	}
> +
> +	/* this object spans two pages */
> +	pages[0] = page;
> +	pages[1] = get_next_page(page);
> +	BUG_ON(!pages[1]);
> +
> +	sizes[0] = PAGE_SIZE - off;
> +	sizes[1] = n - sizes[0];
> +
> +	addr = kmap_atomic(pages[0]);
> +	memcpy(addr + off, src, sizes[0]);
> +	kunmap_atomic(addr);
> +
> +	addr = kmap_atomic(pages[1]);
> +	memcpy(addr, src + sizes[0], sizes[1]);
> +	kunmap_atomic(addr);
> +}
> +EXPORT_SYMBOL_GPL(zs_mem_write);

Two API have same logic but just different memcpy argument order for input/output
so you can factor out common logic.

Patch looks good to me but I have a concern.
I'd like to promote zram/zsmalloc as soon as possible.
My last hurdle was LOCKDEP complaint so I decided to stop sending promoting patches
until it was solved. At that same time, Nitin was sending some patches on zram meta
diet and critical bug fix. Of course, they was conflict so we should line patches up
following as

1. Critical bug fix and merge <- merged two days ago.
2. Nitin diet patch merge <- pending
3. Minchan Lockdep patch merge <- pending

And then, my plan was trying to promote again.
But unfortunately, I was not convinced of 2 at that time while we all agree on 3.
So it takes some time to discuss 2 again and finally merge.
So I would like to merge lockdep patch as top priority and then,
Joonsoo/Nitin/Seth could try to send your patches to staging.
(Seth already had a patch to solve lockdep problem simply in his zswap series
but I don't like it although I didn't reply his patch.)

If anyone has objection, please raise your hand.
I will do best effort to send lockdep patch until early next week.

-- 
Kind regards,
Minchan Kim
