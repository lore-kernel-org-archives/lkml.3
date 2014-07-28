Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751943AbaG1UaV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 16:30:21 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:57900 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751162AbaG1UaS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 16:30:18 -0400
Date: Mon, 28 Jul 2014 16:29:52 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, Hugh Dickins <hughd@google.com>,
        Rik van Riel <riel@redhat.com>, Hillf Danton <dhillf@gmail.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Naoya Horiguchi <nao.horiguchi@gmail.com>
Subject: Re: [PATCH -mm] mm: refactor page index/offset getters
Message-ID: <20140728202952.GP1725@cmpxchg.org>
References: <1404225982-22739-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <20140701180739.GA4985@node.dhcp.inet.fi>
 <20140701185021.GA10356@nhori.bos.redhat.com>
 <20140701201540.GA5953@node.dhcp.inet.fi>
 <20140702043057.GA19813@nhori.redhat.com>
 <20140707123923.5e42983d6123ebfd79c8cf4c@linux-foundation.org>
 <20140715164112.GA6055@nhori.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140715164112.GA6055@nhori.bos.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2014 at 12:41:12PM -0400, Naoya Horiguchi wrote:
> @@ -399,28 +399,24 @@ static inline struct page *read_mapping_page(struct address_space *mapping,
>  }
>  
>  /*
> - * Get the offset in PAGE_SIZE.
> + * Return the 4kB page offset of the given page.
>   * (TODO: hugepage should have ->index in PAGE_SIZE)
>   */
> -static inline pgoff_t page_to_pgoff(struct page *page)
> +static inline pgoff_t page_pgoff(struct page *page)
>  {
> -	if (unlikely(PageHeadHuge(page)))
> -		return page->index << compound_order(page);
> -	else
> -		return page->index << (PAGE_CACHE_SHIFT - PAGE_SHIFT);
> +	if (unlikely(PageHuge(page))) {
> +		VM_BUG_ON_PAGE(PageTail(page), page);
> +		return page_index(page) << compound_order(page);
> +	} else
> +		return page_index(page) << (PAGE_CACHE_SHIFT - PAGE_SHIFT);
>  }

I just bisected the VM refusing to swap and triggering OOM kills to
this patch, which is likely the same bug you reported a couple days
back when you had this patch in your private tree.

Changing page->index to page_index() makes this function return the
swap offset rather than the virtual PFN, but rmap uses this to index
into virtual address space.  Thus, swapcache pages can no longer be
found from try_to_unmap() and reclaim fails.

We can't simply change it back to page->index, however, because the
swapout path, which requires the swap offset, also uses this function
through page_offset().  Virtual address space functions and page cache
address space functions can't use the same helpers, and the helpers
should likely be named distinctly so that they are not confused and
it's clear what is being asked.  Plus, the patch forced every fs using
page_offset() to suddenly check PageHuge(), which is a function call.

How about

o page_offset() for use by filesystems, based on page->index

o page_virt_pgoff() for use on virtual memory math, based on
  page->index and respecting PageHuge()

o page_mapping_pgoff() for use by swapping and when working on
  mappings that could be swapper_space.

o page_mapping_offset() likewise, just in bytes

Hm?
