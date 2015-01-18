Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752621AbbARKT7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 05:19:59 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33705 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751441AbbARKT6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 05:19:58 -0500
Message-ID: <54BB88CB.7080107@suse.cz>
Date: Sun, 18 Jan 2015 11:19:55 +0100
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Hui Zhu <teawater@gmail.com>, akpm@linux-foundation.org, mgorman@suse.de,
        hannes@cmpxchg.org, rientjes@google.com, iamjoonsoo.kim@lge.com,
        sasha.levin@oracle.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
CC: Hui Zhu <zhuhui@xiaomi.com>
Subject: Re: [PATCH] mm/page_alloc: Fix race conditions on getting migratetype
 in buffered_rmqueue
References: <1421572634-3399-1-git-send-email-teawater@gmail.com>
In-Reply-To: <1421572634-3399-1-git-send-email-teawater@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18.1.2015 10:17, Hui Zhu wrote:
> From: Hui Zhu <zhuhui@xiaomi.com>
>
> To test the patch [1], I use KGTP and a script [2] to show NR_FREE_CMA_PAGES
> and gross of cma_nr_free.  The values are always not same.
> I check the code of pages alloc and free and found that race conditions
> on getting migratetype in buffered_rmqueue.

Can you elaborate? What does this races with, are you dynamically changing
the size of CMA area, or what? The migratetype here is based on which free
list the page was found on. Was it misplaced then? Wasn't Joonsoo's recent
series supposed to eliminate this?

> Then I add move the code of getting migratetype inside the zone->lock
> protection part.

Not just that, you are also reading migratetype from pageblock bitmap
instead of the one embedded in the free page. Which is more expensive
and we already do that more often than we would like to because of CMA.
And it appears to be a wrong fix for a possible misplacement bug. If there's
such misplacement, the wrong stats are not the only problem.

>
> Because this issue will affect system even if the Linux kernel does't
> have [1].  So I post this patch separately.

But we can't test that without [1], right? Maybe the issue is introduced 
by [1]?

>
> This patchset is based on fc7f0dd381720ea5ee5818645f7d0e9dece41cb0.
>
> [1] https://lkml.org/lkml/2015/1/18/28
> [2] https://github.com/teawater/kgtp/blob/dev/add-ons/cma_free.py
>
> Signed-off-by: Hui Zhu <zhuhui@xiaomi.com>
> ---
>   mm/page_alloc.c | 11 +++++++----
>   1 file changed, 7 insertions(+), 4 deletions(-)
>
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 7633c50..f3d6922 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1694,11 +1694,12 @@ again:
>   		}
>   		spin_lock_irqsave(&zone->lock, flags);
>   		page = __rmqueue(zone, order, migratetype);
> +		if (page)
> +			migratetype = get_pageblock_migratetype(page);
> +		else
> +			goto failed_unlock;
>   		spin_unlock(&zone->lock);
> -		if (!page)
> -			goto failed;
> -		__mod_zone_freepage_state(zone, -(1 << order),
> -					  get_freepage_migratetype(page));
> +		__mod_zone_freepage_state(zone, -(1 << order), migratetype);
>   	}
>   
>   	__mod_zone_page_state(zone, NR_ALLOC_BATCH, -(1 << order));
> @@ -1715,6 +1716,8 @@ again:
>   		goto again;
>   	return page;
>   
> +failed_unlock:
> +	spin_unlock(&zone->lock);
>   failed:
>   	local_irq_restore(flags);
>   	return NULL;

