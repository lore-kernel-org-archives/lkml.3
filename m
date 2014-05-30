Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755590AbaE3Kk4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 06:40:56 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:40656 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186AbaE3Kkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 06:40:55 -0400
MIME-Version: 1.0
X-Google-Sender-Delegation: ritesh.harjani@gmail.com
In-Reply-To: <1401260672-28339-4-git-send-email-iamjoonsoo.kim@lge.com>
References: <1401260672-28339-1-git-send-email-iamjoonsoo.kim@lge.com>
	<1401260672-28339-4-git-send-email-iamjoonsoo.kim@lge.com>
Date: Fri, 30 May 2014 16:10:54 +0530
X-Google-Sender-Auth: 9KJFaHCMhMl-RuprNkvnnySg-4w
Message-ID: <CALk7dXr4c53boGMaM160ssoomToZvq8q5pUKkTxLtTVVpXGc1A@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] CMA: always treat free cma pages as non-free on
 watermark checking
From: Ritesh Harjani <ritesh.list@gmail.com>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Mel Gorman <mgorman@suse.de>,
        Laura Abbott <lauraa@codeaurora.org>, Minchan Kim <minchan@kernel.org>,
        Heesub Shin <heesub.shin@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Ritesh Harjani <ritesh.harjani@gmail.com>,
        Nagachandra P <nagachandra@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joonsoo,

I think you will be loosing the benefit of below patch with your changes.
I am no expert here so please bear with me. I tried explaining in the
inline comments, let me know if I am wrong.

commit 026b08147923142e925a7d0aaa39038055ae0156
Author: Tomasz Stanislawski <t.stanislaws@samsung.com>
Date:   Wed Jun 12 14:05:02 2013 -0700


On Wed, May 28, 2014 at 12:34 PM, Joonsoo Kim <iamjoonsoo.kim@lge.com> wrote:
> commit d95ea5d1('cma: fix watermark checking') introduces ALLOC_CMA flag
> for alloc flag and treats free cma pages as free pages if this flag is
> passed to watermark checking. Intention of that patch is that movable page
> allocation can be be handled from cma reserved region without starting
> kswapd. Now, previous patch changes the behaviour of allocator that
> movable allocation uses the page on cma reserved region aggressively,
> so this watermark hack isn't needed anymore. Therefore remove it.
>
> Acked-by: Michal Nazarewicz <mina86@mina86.com>
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
>
> diff --git a/mm/compaction.c b/mm/compaction.c
> index 627dc2e..36e2fcd 100644
> --- a/mm/compaction.c
> +++ b/mm/compaction.c
> @@ -1117,10 +1117,6 @@ unsigned long try_to_compact_pages(struct zonelist *zonelist,
>
>         count_compact_event(COMPACTSTALL);
>
> -#ifdef CONFIG_CMA
> -       if (allocflags_to_migratetype(gfp_mask) == MIGRATE_MOVABLE)
> -               alloc_flags |= ALLOC_CMA;
> -#endif
>         /* Compact each zone in the list */
>         for_each_zone_zonelist_nodemask(zone, z, zonelist, high_zoneidx,
>                                                                 nodemask) {
> diff --git a/mm/internal.h b/mm/internal.h
> index 07b6736..a121762 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -384,7 +384,6 @@ unsigned long reclaim_clean_pages_from_list(struct zone *zone,
>  #define ALLOC_HARDER           0x10 /* try to alloc harder */
>  #define ALLOC_HIGH             0x20 /* __GFP_HIGH set */
>  #define ALLOC_CPUSET           0x40 /* check for correct cpuset */
> -#define ALLOC_CMA              0x80 /* allow allocations from CMA areas */
> -#define ALLOC_FAIR             0x100 /* fair zone allocation */
> +#define ALLOC_FAIR             0x80 /* fair zone allocation */
>
>  #endif /* __MM_INTERNAL_H */
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index ca678b6..83a8021 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1764,20 +1764,22 @@ static bool __zone_watermark_ok(struct zone *z, int order, unsigned long mark,
>         long min = mark;
>         long lowmem_reserve = z->lowmem_reserve[classzone_idx];
>         int o;
> -       long free_cma = 0;
>
>         free_pages -= (1 << order) - 1;
>         if (alloc_flags & ALLOC_HIGH)
>                 min -= min / 2;
>         if (alloc_flags & ALLOC_HARDER)
>                 min -= min / 4;
> -#ifdef CONFIG_CMA
> -       /* If allocation can't use CMA areas don't use free CMA pages */
> -       if (!(alloc_flags & ALLOC_CMA))
> -               free_cma = zone_page_state(z, NR_FREE_CMA_PAGES);
> -#endif
> +       /*
> +        * We don't want to regard the pages on CMA region as free
> +        * on watermark checking, since they cannot be used for
> +        * unmovable/reclaimable allocation and they can suddenly
> +        * vanish through CMA allocation
> +        */
> +       if (IS_ENABLED(CONFIG_CMA) && z->managed_cma_pages)
> +               free_pages -= zone_page_state(z, NR_FREE_CMA_PAGES);

make this free_cma instead of free_pages.

>
> -       if (free_pages - free_cma <= min + lowmem_reserve)
> +       if (free_pages <= min + lowmem_reserve)
free_pages - free_cma <= min + lowmem_reserve

Because in for loop you subtract nr_free which includes the CMA pages.
So if you have subtracted NR_FREE_CMA_PAGES
from free_pages above then you will be subtracting cma pages again in
nr_free (below in for loop).

>                 return false;
>         for (o = 0; o < order; o++) {
>                 /* At the next order, this order's pages become unavailable */
> @@ -2545,10 +2547,6 @@ gfp_to_alloc_flags(gfp_t gfp_mask)
>                                  unlikely(test_thread_flag(TIF_MEMDIE))))
>                         alloc_flags |= ALLOC_NO_WATERMARKS;
>         }
> -#ifdef CONFIG_CMA
> -       if (allocflags_to_migratetype(gfp_mask) == MIGRATE_MOVABLE)
> -               alloc_flags |= ALLOC_CMA;
> -#endif
>         return alloc_flags;
>  }
>
> @@ -2818,10 +2816,6 @@ retry_cpuset:
>         if (!preferred_zone)
>                 goto out;
>
> -#ifdef CONFIG_CMA
> -       if (allocflags_to_migratetype(gfp_mask) == MIGRATE_MOVABLE)
> -               alloc_flags |= ALLOC_CMA;
> -#endif
>  retry:
>         /* First allocation attempt */
>         page = get_page_from_freelist(gfp_mask|__GFP_HARDWALL, nodemask, order,
> --
> 1.7.9.5
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>


Thanks
Ritesh
