Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754208AbaCJP3R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 11:29:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35690 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752471AbaCJP3M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 11:29:12 -0400
Message-ID: <531DDA46.5050803@suse.cz>
Date: Mon, 10 Mar 2014 16:29:10 +0100
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [patch] mm, compaction: determine isolation mode only once
References: <alpine.DEB.2.02.1403070358120.13046@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1403070358120.13046@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/2014 01:01 PM, David Rientjes wrote:
> The conditions that control the isolation mode in
> isolate_migratepages_range() do not change during the iteration, so
> extract them out and only define the value once.
>
> This actually does have an effect, gcc doesn't optimize it itself because
> of cc->sync.
>
> Signed-off-by: David Rientjes <rientjes@google.com>

Acked-by: Vlastimil Babka <vbabka@suse.cz>

> ---
>   mm/compaction.c | 9 ++-------
>   1 file changed, 2 insertions(+), 7 deletions(-)
>
> diff --git a/mm/compaction.c b/mm/compaction.c
> --- a/mm/compaction.c
> +++ b/mm/compaction.c
> @@ -454,12 +454,13 @@ isolate_migratepages_range(struct zone *zone, struct compact_control *cc,
>   	unsigned long last_pageblock_nr = 0, pageblock_nr;
>   	unsigned long nr_scanned = 0, nr_isolated = 0;
>   	struct list_head *migratelist = &cc->migratepages;
> -	isolate_mode_t mode = 0;
>   	struct lruvec *lruvec;
>   	unsigned long flags;
>   	bool locked = false;
>   	struct page *page = NULL, *valid_page = NULL;
>   	bool skipped_async_unsuitable = false;
> +	const isolate_mode_t mode = (!cc->sync ? ISOLATE_ASYNC_MIGRATE : 0) |
> +				    (unevictable ? ISOLATE_UNEVICTABLE : 0);
>
>   	/*
>   	 * Ensure that there are not too many pages isolated from the LRU
> @@ -592,12 +593,6 @@ isolate_migratepages_range(struct zone *zone, struct compact_control *cc,
>   			continue;
>   		}
>
> -		if (!cc->sync)
> -			mode |= ISOLATE_ASYNC_MIGRATE;
> -
> -		if (unevictable)
> -			mode |= ISOLATE_UNEVICTABLE;
> -
>   		lruvec = mem_cgroup_page_lruvec(page, zone);
>
>   		/* Try isolate the page */
>

