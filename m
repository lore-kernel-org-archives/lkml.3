Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756970AbaHHP1U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 11:27:20 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56128 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756008AbaHHP1S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 11:27:18 -0400
Message-ID: <53E4EC53.1050904@suse.cz>
Date: Fri, 08 Aug 2014 17:27:15 +0200
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>, Andrew Morton <akpm@linux-foundation.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>,
        Linux-FSDevel <linux-fsdevel@vger.kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 6/6] mm: page_alloc: Reduce cost of the fair zone allocation
 policy
References: <1404893588-21371-1-git-send-email-mgorman@suse.de> <1404893588-21371-7-git-send-email-mgorman@suse.de>
In-Reply-To: <1404893588-21371-7-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/09/2014 10:13 AM, Mel Gorman wrote:
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1604,6 +1604,9 @@ again:
>  	}
>  
>  	__mod_zone_page_state(zone, NR_ALLOC_BATCH, -(1 << order));

This can underflow zero, right?

> +	if (zone_page_state(zone, NR_ALLOC_BATCH) == 0 &&

AFAICS, zone_page_state will correct negative values to zero only for
CONFIG_SMP. Won't this check be broken on !CONFIG_SMP?

I just stumbled upon this when trying to optimize the function. I didn't check
how rest of the design copes with negative NR_ALLOC_BATCH values.

> +	    !zone_is_fair_depleted(zone))
> +		zone_set_flag(zone, ZONE_FAIR_DEPLETED);
>  
>  	__count_zone_vm_events(PGALLOC, zone, 1 << order);
>  	zone_statistics(preferred_zone, zone, gfp_flags);
> @@ -1915,6 +1918,18 @@ static bool zone_allows_reclaim(struct zone *local_zone, struct zone *zone)
>  
>  #endif	/* CONFIG_NUMA */
>  

