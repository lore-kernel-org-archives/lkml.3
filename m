Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869AbaFWJQ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 05:16:27 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:8993 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753295AbaFWJQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 05:16:24 -0400
X-IronPort-AV: E=Sophos;i="5.00,759,1396972800"; 
   d="scan'208";a="32279715"
Message-ID: <53A7F05F.5060508@cn.fujitsu.com>
Date: Mon, 23 Jun 2014 17:16:15 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131030 Thunderbird/17.0.10
MIME-Version: 1.0
To: Vlastimil Babka <vbabka@suse.cz>
CC: <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, Minchan Kim <minchan@kernel.org>,
        Mel Gorman <mgorman@suse.de>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 07/13] mm, compaction: skip rechecks when lock was
 already held
References: <1403279383-5862-1-git-send-email-vbabka@suse.cz> <1403279383-5862-8-git-send-email-vbabka@suse.cz>
In-Reply-To: <1403279383-5862-8-git-send-email-vbabka@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.225.89]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2014 11:49 PM, Vlastimil Babka wrote:
> Compaction scanners try to lock zone locks as late as possible by checking
> many page or pageblock properties opportunistically without lock and skipping
> them if not unsuitable. For pages that pass the initial checks, some properties
> have to be checked again safely under lock. However, if the lock was already
> held from a previous iteration in the initial checks, the rechecks are
> unnecessary.
> 
> This patch therefore skips the rechecks when the lock was already held. This is
> now possible to do, since we don't (potentially) drop and reacquire the lock
> between the initial checks and the safe rechecks anymore.
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> Acked-by: Minchan Kim <minchan@kernel.org>
> Cc: Mel Gorman <mgorman@suse.de>
> Cc: Michal Nazarewicz <mina86@mina86.com>
> Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> Cc: Christoph Lameter <cl@linux.com>
> Cc: Rik van Riel <riel@redhat.com>
> Acked-by: David Rientjes <rientjes@google.com>

Reviewed-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>

> ---
>  mm/compaction.c | 53 +++++++++++++++++++++++++++++++----------------------
>  1 file changed, 31 insertions(+), 22 deletions(-)
> 
> diff --git a/mm/compaction.c b/mm/compaction.c
> index 40da812..9f6e857 100644
> --- a/mm/compaction.c
> +++ b/mm/compaction.c
> @@ -324,22 +324,30 @@ static unsigned long isolate_freepages_block(struct compact_control *cc,
>  			goto isolate_fail;
>  
>  		/*
> -		 * The zone lock must be held to isolate freepages.
> -		 * Unfortunately this is a very coarse lock and can be
> -		 * heavily contended if there are parallel allocations
> -		 * or parallel compactions. For async compaction do not
> -		 * spin on the lock and we acquire the lock as late as
> -		 * possible.
> +		 * If we already hold the lock, we can skip some rechecking.
> +		 * Note that if we hold the lock now, checked_pageblock was
> +		 * already set in some previous iteration (or strict is true),
> +		 * so it is correct to skip the suitable migration target
> +		 * recheck as well.
>  		 */
> -		if (!locked)
> +		if (!locked) {
> +			/*
> +			 * The zone lock must be held to isolate freepages.
> +			 * Unfortunately this is a very coarse lock and can be
> +			 * heavily contended if there are parallel allocations
> +			 * or parallel compactions. For async compaction do not
> +			 * spin on the lock and we acquire the lock as late as
> +			 * possible.
> +			 */
>  			locked = compact_trylock_irqsave(&cc->zone->lock,
>  								&flags, cc);
> -		if (!locked)
> -			break;
> +			if (!locked)
> +				break;
>  
> -		/* Recheck this is a buddy page under lock */
> -		if (!PageBuddy(page))
> -			goto isolate_fail;
> +			/* Recheck this is a buddy page under lock */
> +			if (!PageBuddy(page))
> +				goto isolate_fail;
> +		}
>  
>  		/* Found a free page, break it into order-0 pages */
>  		isolated = split_free_page(page);
> @@ -623,19 +631,20 @@ isolate_migratepages_range(struct zone *zone, struct compact_control *cc,
>  		    page_count(page) > page_mapcount(page))
>  			continue;
>  
> -		/* If the lock is not held, try to take it */
> -		if (!locked)
> +		/* If we already hold the lock, we can skip some rechecking */
> +		if (!locked) {
>  			locked = compact_trylock_irqsave(&zone->lru_lock,
>  								&flags, cc);
> -		if (!locked)
> -			break;
> +			if (!locked)
> +				break;
>  
> -		/* Recheck PageLRU and PageTransHuge under lock */
> -		if (!PageLRU(page))
> -			continue;
> -		if (PageTransHuge(page)) {
> -			low_pfn += (1 << compound_order(page)) - 1;
> -			continue;
> +			/* Recheck PageLRU and PageTransHuge under lock */
> +			if (!PageLRU(page))
> +				continue;
> +			if (PageTransHuge(page)) {
> +				low_pfn += (1 << compound_order(page)) - 1;
> +				continue;
> +			}
>  		}
>  
>  		lruvec = mem_cgroup_page_lruvec(page, zone);
> 


-- 
Thanks.
Zhang Yanfei
