Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751789AbaBGJVH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 04:21:07 -0500
Received: from cantor2.suse.de ([195.135.220.15]:32855 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750868AbaBGJVC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 04:21:02 -0500
Message-ID: <52F4A579.7040009@suse.cz>
Date: Fri, 07 Feb 2014 10:20:57 +0100
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: Mel Gorman <mgorman@suse.de>, Joonsoo Kim <js1304@gmail.com>,
        Rik van Riel <riel@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] mm/compaction: disallow high-order page for migration
 target
References: <1391749726-28910-1-git-send-email-iamjoonsoo.kim@lge.com> <1391749726-28910-2-git-send-email-iamjoonsoo.kim@lge.com>
In-Reply-To: <1391749726-28910-2-git-send-email-iamjoonsoo.kim@lge.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2014 06:08 AM, Joonsoo Kim wrote:
> Purpose of compaction is to get a high order page. Currently, if we find
> high-order page while searching migration target page, we break it to
> order-0 pages and use them as migration target. It is contrary to purpose
> of compaction, so disallow high-order page to be used for
> migration target.

I guess this actually didn't trigger often because with large free blocks available,
compaction shouldn't even be running (unless started manually). But the change makes sense.

> Additionally, clean-up logic in suitable_migration_target() to simply.

simply -> simplify the code.

> There is no functional changes from this clean-up.
> 
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

Acked-by: Vlastimil Babka <vbabka@suse.cz>

> diff --git a/mm/compaction.c b/mm/compaction.c
> index 3a91a2e..bbe1260 100644
> --- a/mm/compaction.c
> +++ b/mm/compaction.c
> @@ -217,21 +217,12 @@ static inline bool compact_trylock_irqsave(spinlock_t *lock,
>  /* Returns true if the page is within a block suitable for migration to */
>  static bool suitable_migration_target(struct page *page)
>  {
> -	int migratetype = get_pageblock_migratetype(page);
> -
> -	/* Don't interfere with memory hot-remove or the min_free_kbytes blocks */
> -	if (migratetype == MIGRATE_RESERVE)
> -		return false;
> -
> -	if (is_migrate_isolate(migratetype))
> -		return false;
> -
> -	/* If the page is a large free page, then allow migration */
> +	/* If the page is a large free page, then disallow migration */
>  	if (PageBuddy(page) && page_order(page) >= pageblock_order)
> -		return true;
> +		return false;
>  
>  	/* If the block is MIGRATE_MOVABLE or MIGRATE_CMA, allow migration */
> -	if (migrate_async_suitable(migratetype))
> +	if (migrate_async_suitable(get_pageblock_migratetype(page)))
>  		return true;
>  
>  	/* Otherwise skip the block */
> 

