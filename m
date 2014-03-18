Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757283AbaCRS0k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 14:26:40 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:57234 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754315AbaCRS0j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 14:26:39 -0400
Date: Tue, 18 Mar 2014 14:26:21 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Minchan Kim <minchan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Hugh Dickins <hughd@google.com>,
        Dave Hansen <dave.hansen@intel.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, John Stultz <john.stultz@linaro.org>,
        Jason Evans <je@fb.com>
Subject: Re: [RFC 3/6] mm: support madvise(MADV_FREE)
Message-ID: <20140318182621.GH14688@cmpxchg.org>
References: <1394779070-8545-1-git-send-email-minchan@kernel.org>
 <1394779070-8545-4-git-send-email-minchan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394779070-8545-4-git-send-email-minchan@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2014 at 03:37:47PM +0900, Minchan Kim wrote:
> Linux doesn't have an ability to free pages lazy while other OS
> already have been supported that named by madvise(MADV_FREE).
> 
> The gain is clear that kernel can evict freed pages rather than
> swapping out or OOM if memory pressure happens.
> 
> Without memory pressure, freed pages would be reused by userspace
> without another additional overhead(ex, page fault + + page allocation
> + page zeroing).
> 
> Firstly, heavy users would be general allocators(ex, jemalloc,
> I hope ptmalloc support it) and jemalloc already have supported
> the feature for other OS(ex, FreeBSD)
> 
> At the moment, this patch would break build other ARCHs which have
> own TLB flush scheme other than that x86 but if there is no objection
> in this direction, I will add patches for handling other ARCHs
> in next iteration.
> 
> Signed-off-by: Minchan Kim <minchan@kernel.org>

> @@ -284,8 +286,17 @@ static long madvise_dontneed(struct vm_area_struct *vma,
>  			.last_index = ULONG_MAX,
>  		};
>  		zap_page_range(vma, start, end - start, &details);
> +	} else if (behavior == MADV_FREE) {
> +		struct zap_details details = {
> +			.lazy_free = 1,
> +		};
> +
> +		if (vma->vm_file)
> +			return -EINVAL;
> +		zap_page_range(vma, start, end - start, &details);

Wouldn't a custom page table walker to clear dirty bits and move pages
be better?  It's awkward to hook this into the freeing code and then
special case the pages and not actually free them.

> @@ -817,6 +817,25 @@ static unsigned long shrink_page_list(struct list_head *page_list,
>  
>  		sc->nr_scanned++;
>  
> +		if (PageLazyFree(page)) {
> +			switch (try_to_unmap(page, ttu_flags)) {

I don't get why we need a page flag for this.  page_check_references()
could use the rmap walk to also check if any pte/pmd is dirty.  If so,
you have to swap the page.  If all are clean, it can be discarded.
