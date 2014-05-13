Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933014AbaEMKAh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 06:00:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50417 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932952AbaEMKAd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 06:00:33 -0400
Message-ID: <5371ED3F.6070505@suse.cz>
Date: Tue, 13 May 2014 12:00:31 +0200
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, Greg Thelen <gthelen@google.com>,
        Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [patch -mm] mm, thp: avoid excessive compaction latency during
 fault fix
References: <alpine.DEB.2.02.1404301744110.8415@chino.kir.corp.google.com> <alpine.DEB.2.02.1405011434140.23898@chino.kir.corp.google.com> <alpine.DEB.2.02.1405061920470.18635@chino.kir.corp.google.com> <alpine.DEB.2.02.1405061922010.18635@chino.kir.corp.google.com> <alpine.DEB.2.02.1405072229390.19108@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1405072229390.19108@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/2014 07:30 AM, David Rientjes wrote:
> mm-thp-avoid-excessive-compaction-latency-during-fault.patch excludes sync
> compaction for all high order allocations other than thp.  What we really
> want to do is suppress sync compaction for thp, but only during the page
> fault path.
>
> Orders greater than PAGE_ALLOC_COSTLY_ORDER aren't necessarily going to
> loop again so this is the only way to exhaust our capabilities before
> declaring that we can't allocate.
>
> Reported-by: Hugh Dickins <hughd@google.com>
> Signed-off-by: David Rientjes <rientjes@google.com>
> ---
>   mm/page_alloc.c | 17 +++++++----------
>   1 file changed, 7 insertions(+), 10 deletions(-)
>
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -2585,16 +2585,13 @@ rebalance:
>   	if (page)
>   		goto got_pg;
>
> -	if (gfp_mask & __GFP_NO_KSWAPD) {
> -		/*
> -		 * Khugepaged is allowed to try MIGRATE_SYNC_LIGHT, the latency
> -		 * of this allocation isn't critical.  Everything else, however,
> -		 * should only be allowed to do MIGRATE_ASYNC to avoid excessive
> -		 * stalls during fault.
> -		 */
> -		if ((current->flags & (PF_KTHREAD | PF_KSWAPD)) == PF_KTHREAD)
> -			migration_mode = MIGRATE_SYNC_LIGHT;
> -	}
> +	/*
> +	 * It can become very expensive to allocate transparent hugepages at
> +	 * fault, so use asynchronous memory compaction for THP unless it is
> +	 * khugepaged trying to collapse.
> +	 */
> +	if (!(gfp_mask & __GFP_NO_KSWAPD) || (current->flags & PF_KTHREAD))
> +		migration_mode = MIGRATE_SYNC_LIGHT;

I wonder what about a process doing e.g. mmap() with MAP_POPULATE. It 
seems to me that it would get only MIGRATE_ASYNC here, right? Since 
gfp_mask would include __GFP_NO_KSWAPD and it won't have PF_KTHREAD.
I think that goes against the idea that with MAP_POPULATE you say you 
are willing to wait to have everything in place before you actually use 
the memory. So I guess you are also willing to wait for hugepages in 
that situation?

>
>   	/*
>   	 * If compaction is deferred for high-order allocations, it is because
>

