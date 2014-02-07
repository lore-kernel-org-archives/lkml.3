Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751870AbaBGJgT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 04:36:19 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33372 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751317AbaBGJgR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 04:36:17 -0500
Message-ID: <52F4A90D.20804@suse.cz>
Date: Fri, 07 Feb 2014 10:36:13 +0100
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: Mel Gorman <mgorman@suse.de>, Joonsoo Kim <js1304@gmail.com>,
        Rik van Riel <riel@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] mm/compaction: do not call suitable_migration_target()
 on every page
References: <1391749726-28910-1-git-send-email-iamjoonsoo.kim@lge.com> <1391749726-28910-3-git-send-email-iamjoonsoo.kim@lge.com>
In-Reply-To: <1391749726-28910-3-git-send-email-iamjoonsoo.kim@lge.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2014 06:08 AM, Joonsoo Kim wrote:
> suitable_migration_target() checks that pageblock is suitable for
> migration target. In isolate_freepages_block(), it is called on every
> page and this is inefficient. So make it called once per pageblock.

Hmm but in sync compaction, compact_checklock_irqsave() may drop the zone->lock,
reschedule and reacquire it and thus possibly invalidate your previous check. Async
compaction is ok as that will quit immediately. So you could probably communicate that
this happened and invalidate checked_pageblock in such case. Or maybe this would not
happen too enough to worry about rare suboptimal migrations?

Vlastimil

> suitable_migration_target() also checks if page is highorder or not,
> but it's criteria for highorder is pageblock order. So calling it once
> within pageblock range has no problem.
> 
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> 
> diff --git a/mm/compaction.c b/mm/compaction.c
> index bbe1260..0d821a2 100644
> --- a/mm/compaction.c
> +++ b/mm/compaction.c
> @@ -245,6 +245,7 @@ static unsigned long isolate_freepages_block(struct compact_control *cc,
>  	unsigned long nr_strict_required = end_pfn - blockpfn;
>  	unsigned long flags;
>  	bool locked = false;
> +	bool checked_pageblock = false;
>  
>  	cursor = pfn_to_page(blockpfn);
>  
> @@ -275,8 +276,16 @@ static unsigned long isolate_freepages_block(struct compact_control *cc,
>  			break;
>  
>  		/* Recheck this is a suitable migration target under lock */
> -		if (!strict && !suitable_migration_target(page))
> -			break;
> +		if (!strict && !checked_pageblock) {
> +			/*
> +			 * We need to check suitability of pageblock only once
> +			 * and this isolate_freepages_block() is called with
> +			 * pageblock range, so just check once is sufficient.
> +			 */
> +			checked_pageblock = true;
> +			if (!suitable_migration_target(page))
> +				break;
> +		}
>  
>  		/* Recheck this is a buddy page under lock */
>  		if (!PageBuddy(page))
> 

