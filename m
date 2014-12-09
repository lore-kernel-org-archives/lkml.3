Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756482AbaLIDIw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 22:08:52 -0500
Received: from lgeamrelo04.lge.com ([156.147.1.127]:53700 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753148AbaLIDIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 22:08:51 -0500
X-Original-SENDERIP: 10.177.220.156
X-Original-MAILFROM: minchan@kernel.org
Date: Tue, 9 Dec 2014 12:09:40 +0900
From: Minchan Kim <minchan@kernel.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: linux-mm@kvack.org, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        linux-kernel@vger.kernel.org, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, David Rientjes <rientjes@google.com>
Subject: Re: [RFC PATCH 2/3] mm: more aggressive page stealing for UNMOVABLE
 allocations
Message-ID: <20141209030939.GD3358@bbox>
References: <1417713178-10256-1-git-send-email-vbabka@suse.cz>
 <1417713178-10256-3-git-send-email-vbabka@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1417713178-10256-3-git-send-email-vbabka@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 04, 2014 at 06:12:57PM +0100, Vlastimil Babka wrote:
> When allocation falls back to stealing free pages of another migratetype,
> it can decide to steal extra pages, or even the whole pageblock in order to
> reduce fragmentation, which could happen if further allocation fallbacks
> pick a different pageblock. In try_to_steal_freepages(), one of the situations
> where extra pages are stolen happens when we are trying to allocate a
> MIGRATE_RECLAIMABLE page.
> 
> However, MIGRATE_UNMOVABLE allocations are not treated the same way, although
> spreading such allocation over multiple fallback pageblocks is arguably even
> worse than it is for RECLAIMABLE allocations. To minimize fragmentation, we
> should minimize the number of such fallbacks, and thus steal as much as is
> possible from each fallback pageblock.

Fair enough.

> 
> This patch thus adds a check for MIGRATE_UNMOVABLE to the decision to steal
> extra free pages. When evaluating with stress-highalloc from mmtests, this has
> reduced the number of MIGRATE_UNMOVABLE fallbacks to roughly 1/6. The number
> of these fallbacks stealing from MIGRATE_MOVABLE block is reduced to 1/3.
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Minchan Kim <minchan@kernel.org>

Nit:

Please fix comment on try_to_steal_freepages.
We don't bias MIGRATE_RECLAIMABLE any more so remove it. Instead,
put some words about the policy and why.

Thanks.

> ---
>  mm/page_alloc.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 548b072..a14249c 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1098,6 +1098,7 @@ static int try_to_steal_freepages(struct zone *zone, struct page *page,
>  
>  	if (current_order >= pageblock_order / 2 ||
>  	    start_type == MIGRATE_RECLAIMABLE ||
> +	    start_type == MIGRATE_UNMOVABLE ||
>  	    page_group_by_mobility_disabled) {
>  		int pages;
>  
> -- 
> 2.1.2
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

-- 
Kind regards,
Minchan Kim
