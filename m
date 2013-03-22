Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933652Ab3CVPVS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 11:21:18 -0400
Received: from www.sr71.net ([198.145.64.142]:60812 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933160Ab3CVPVP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 11:21:15 -0400
Message-ID: <514C773A.6070000@sr71.net>
Date: Fri, 22 Mar 2013 08:22:34 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
CC: Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Hillf Danton <dhillf@gmail.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2, RFC 14/30] thp, mm: naive support of thp in generic
 read/write routines
References: <1363283435-7666-1-git-send-email-kirill.shutemov@linux.intel.com> <1363283435-7666-15-git-send-email-kirill.shutemov@linux.intel.com>
In-Reply-To: <1363283435-7666-15-git-send-email-kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/14/2013 10:50 AM, Kirill A. Shutemov wrote:
> From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> 
> For now we still write/read at most PAGE_CACHE_SIZE bytes a time.
> 
> This implementation doesn't cover address spaces with backing store.
...
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -1165,12 +1165,23 @@ find_page:
>  			if (unlikely(page == NULL))
>  				goto no_cached_page;
>  		}
> +		if (PageTransTail(page)) {
> +			page_cache_release(page);
> +			page = find_get_page(mapping,
> +					index & ~HPAGE_CACHE_INDEX_MASK);
> +			if (!PageTransHuge(page)) {
> +				page_cache_release(page);
> +				goto find_page;
> +			}
> +		}

So, we're going to do a read of a file, and we pulled a tail page out of
the page cache.  Why can't we just deal with the tail page directly?
What prevents this?

Is there something special about THP pages that keeps the head page in
the page cache after the tail has been released?  I'd normally be
worried that the find_get_page() here might fail.

It's probably also worth a quick comment like:

	/* can't deal with tail pages directly, move to head page */

otherwise the reassignment of "page" starts to seem a bit odd.

>  		if (PageReadahead(page)) {
> +			BUG_ON(PageTransHuge(page));
>  			page_cache_async_readahead(mapping,
>  					ra, filp, page,
>  					index, last_index - index);
>  		}

Is this because we only do readahead for fs's with backing stores?
Could we have a comment to this effect?

>  		if (!PageUptodate(page)) {
> +			BUG_ON(PageTransHuge(page));
>  			if (inode->i_blkbits == PAGE_CACHE_SHIFT ||
>  					!mapping->a_ops->is_partially_uptodate)
>  				goto page_not_up_to_date;

Same question. :)

Since your two-line description covers two topics, it's not immediately
obvious which one this BUG_ON() applies to.

> @@ -1212,18 +1223,25 @@ page_ok:
>  		}
>  		nr = nr - offset;
>  
> +		/* Recalculate offset in page if we've got a huge page */
> +		if (PageTransHuge(page)) {
> +			offset = (((loff_t)index << PAGE_CACHE_SHIFT) + offset);
> +			offset &= ~HPAGE_PMD_MASK;
> +		}

Does this need to be done in cases other than the path that goes through
"if(PageTransTail(page))" above?  If not, I'd probably stick this code
up with the other part.

>  		/* If users can be writing to this page using arbitrary
>  		 * virtual addresses, take care about potential aliasing
>  		 * before reading the page on the kernel side.
>  		 */
>  		if (mapping_writably_mapped(mapping))
> -			flush_dcache_page(page);
> +			flush_dcache_page(page + (offset >> PAGE_CACHE_SHIFT));

This is another case where I think adding another local variable would
essentially help the code self-document.  The way it stands, it's fairly
subtle how (offset>>PAGE_CACHE_SHIFT) works and that it's conditional on
THP being enabled.

		int tail_page_index = (offset >> PAGE_CACHE_SHIFT)
...
> +			flush_dcache_page(page + tail_page_index);

This makes it obvious that we're indexing off something, *and* that it's
only going to be relevant when dealing with tail pages.

>  		/*
>  		 * When a sequential read accesses a page several times,
>  		 * only mark it as accessed the first time.
>  		 */
> -		if (prev_index != index || offset != prev_offset)
> +		if (prev_index != index ||
> +				(offset & ~PAGE_CACHE_MASK) != prev_offset)
>  			mark_page_accessed(page);
>  		prev_index = index;
>  
> @@ -1238,8 +1256,9 @@ page_ok:
>  		 * "pos" here (the actor routine has to update the user buffer
>  		 * pointers and the remaining count).
>  		 */
> -		ret = file_read_actor(desc, page, offset, nr);
> -		offset += ret;
> +		ret = file_read_actor(desc, page + (offset >> PAGE_CACHE_SHIFT),
> +				offset & ~PAGE_CACHE_MASK, nr);
> +		offset =  (offset & ~PAGE_CACHE_MASK) + ret;

^^ There's an extra space in that last line.

>  		index += offset >> PAGE_CACHE_SHIFT;
>  		offset &= ~PAGE_CACHE_MASK;
>  		prev_offset = offset;
> @@ -2440,8 +2459,13 @@ again:
>  		if (mapping_writably_mapped(mapping))
>  			flush_dcache_page(page);
>  
> +		if (PageTransHuge(page))
> +			offset = pos & ~HPAGE_PMD_MASK;
> +
>  		pagefault_disable();
> -		copied = iov_iter_copy_from_user_atomic(page, i, offset, bytes);
> +		copied = iov_iter_copy_from_user_atomic(
> +				page + (offset >> PAGE_CACHE_SHIFT),
> +				i, offset & ~PAGE_CACHE_MASK, bytes);
>  		pagefault_enable();
>  		flush_dcache_page(page);
>  
> @@ -2464,6 +2488,7 @@ again:
>  			 * because not all segments in the iov can be copied at
>  			 * once without a pagefault.
>  			 */
> +			offset = pos & ~PAGE_CACHE_MASK;
>  			bytes = min_t(unsigned long, PAGE_CACHE_SIZE - offset,
>  						iov_iter_single_seg_count(i));
>  			goto again;
> 

I think the difficulty in this function is that you're now dealing with
two 'struct page's, two offsets, and two indexes.  It isn't blindingly
obvious which one should be used in a given situation.

The way you've done it here might just be the best way.  I'd *really*
encourage you to make sure that this is tested exhaustively, and make
sure you hit all the different paths in that function.  I'd suspect
there is still a bug or two in there outside the diff context.

Would it be sane to have a set of variables like:

    struct page *thp_tail_page = page + (offset >> PAGE_CACHE_SHIFT);

instead of just open-coding the masks and shifts every time?
