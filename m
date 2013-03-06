Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756846Ab3CFKut (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 05:50:49 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:1621 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751183Ab3CFKus (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 05:50:48 -0500
X-IronPort-AV: E=Sophos;i="4.84,794,1355068800"; 
   d="scan'208";a="6824035"
Message-ID: <5137201A.5090905@cn.fujitsu.com>
Date: Wed, 06 Mar 2013 18:53:14 +0800
From: Lin Feng <linfeng@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Marek Szyprowski <m.szyprowski@samsung.com>
CC: linux-mm@kvack.org, linaro-mm-sig@lists.linaro.org,
        linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Michal Nazarewicz <mina86@mina86.com>,
        Minchan Kim <minchan@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [RFC/PATCH 3/5] mm: get_user_pages: use NON-MOVABLE pages when
 FOLL_DURABLE flag is set
References: <1362466679-17111-1-git-send-email-m.szyprowski@samsung.com> <1362466679-17111-4-git-send-email-m.szyprowski@samsung.com>
In-Reply-To: <1362466679-17111-4-git-send-email-m.szyprowski@samsung.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/06 18:49:34,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/06 18:49:43,
	Serialize complete at 2013/03/06 18:49:43
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marek,

On 03/05/2013 02:57 PM, Marek Szyprowski wrote:
> Ensure that newly allocated pages, which are faulted in in FOLL_DURABLE
> mode comes from non-movalbe pageblocks, to workaround migration failures
> with Contiguous Memory Allocator.

snip
> @@ -2495,7 +2498,7 @@ static inline void cow_user_page(struct page *dst, struct page *src, unsigned lo
>   */
>  static int do_wp_page(struct mm_struct *mm, struct vm_area_struct *vma,
>  		unsigned long address, pte_t *page_table, pmd_t *pmd,
> -		spinlock_t *ptl, pte_t orig_pte)
> +		spinlock_t *ptl, pte_t orig_pte, unsigned int flags)
>  	__releases(ptl)
>  {
>  	struct page *old_page, *new_page = NULL;
> @@ -2505,6 +2508,10 @@ static int do_wp_page(struct mm_struct *mm, struct vm_area_struct *vma,
>  	struct page *dirty_page = NULL;
>  	unsigned long mmun_start = 0;	/* For mmu_notifiers */
>  	unsigned long mmun_end = 0;	/* For mmu_notifiers */
> +	gfp_t gfp = GFP_HIGHUSER_MOVABLE;
> +
> +	if (IS_ENABLED(CONFIG_CMA) && (flags & FAULT_FLAG_NO_CMA))
> +		gfp &= ~__GFP_MOVABLE;

snip
> @@ -3187,6 +3194,11 @@ static int __do_fault(struct mm_struct *mm, struct vm_area_struct *vma,
>  	struct vm_fault vmf;
>  	int ret;
>  	int page_mkwrite = 0;
> +	gfp_t gfp = GFP_HIGHUSER_MOVABLE;
> +
> +	if (IS_ENABLED(CONFIG_CMA) && (flags & FAULT_FLAG_NO_CMA))
> +		gfp &= ~__GFP_MOVABLE;
> +
>  
>  	/*

Since the GUP unmovable pages are only corner cases in all kinds of pagefaults, 
I'm afraid that adding special treatment codes in generic pagefault core interface
is not that necessary or worth to do.
But I'm not sure if the performance impact is as large as to be worried about.


thanks,
linfeng  
