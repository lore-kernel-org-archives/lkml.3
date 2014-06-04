Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755136AbaFDXqm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 19:46:42 -0400
Received: from mail-ig0-f173.google.com ([209.85.213.173]:53682 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754190AbaFDXqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:46:22 -0400
Date: Wed, 4 Jun 2014 16:46:19 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Vlastimil Babka <vbabka@suse.cz>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Thelen <gthelen@google.com>, Minchan Kim <minchan@kernel.org>,
        Mel Gorman <mgorman@suse.de>, Michal Nazarewicz <mina86@mina86.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>
Subject: Re: [RFC PATCH 2/6] mm, compaction: skip rechecks when lock was
 already held
In-Reply-To: <1401898310-14525-2-git-send-email-vbabka@suse.cz>
Message-ID: <alpine.DEB.2.02.1406041641330.18899@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1405211954410.13243@chino.kir.corp.google.com> <1401898310-14525-1-git-send-email-vbabka@suse.cz> <1401898310-14525-2-git-send-email-vbabka@suse.cz>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Jun 2014, Vlastimil Babka wrote:

> diff --git a/mm/compaction.c b/mm/compaction.c
> index f0fd4b5..27c73d7 100644
> --- a/mm/compaction.c
> +++ b/mm/compaction.c
> @@ -332,6 +332,16 @@ static unsigned long isolate_freepages_block(struct compact_control *cc,
>  			goto isolate_fail;
>  
>  		/*
> +		 * If we already hold the lock, we can skip some rechecking.
> +		 * Note that if we hold the lock now, checked_pageblock was
> +		 * already set in some previous iteration (or strict is true),
> +		 * so it is correct to skip the suitable migration target
> +		 * recheck as well.
> +		 */
> +		if (locked)
> +			goto skip_recheck;
> +
> +		/*
>  		 * The zone lock must be held to isolate freepages.
>  		 * Unfortunately this is a very coarse lock and can be
>  		 * heavily contended if there are parallel allocations
> @@ -339,9 +349,7 @@ static unsigned long isolate_freepages_block(struct compact_control *cc,
>  		 * spin on the lock and we acquire the lock as late as
>  		 * possible.
>  		 */
> -		if (!locked)
> -			locked = compact_trylock_irqsave(&cc->zone->lock,
> -								&flags, cc);
> +		locked = compact_trylock_irqsave(&cc->zone->lock, &flags, cc);
>  		if (!locked)
>  			break;
>  
> @@ -361,6 +369,7 @@ static unsigned long isolate_freepages_block(struct compact_control *cc,
>  		if (!PageBuddy(page))
>  			goto isolate_fail;
>  
> +skip_recheck:
>  		/* Found a free page, break it into order-0 pages */
>  		isolated = split_free_page(page);
>  		total_isolated += isolated;

This doesn't apply cleanly, you probably need Andrew's 
"mm/compaction.c:isolate_freepages_block(): small tuneup"?  Rebasing the 
series on -mm would probably be best.

> @@ -671,10 +680,11 @@ isolate_migratepages_range(struct zone *zone, struct compact_control *cc,
>  		    page_count(page) > page_mapcount(page))
>  			continue;
>  
> -		/* If the lock is not held, try to take it */
> -		if (!locked)
> -			locked = compact_trylock_irqsave(&zone->lru_lock,
> -								&flags, cc);
> +		/* If we already hold the lock, we can skip some rechecking */
> +		if (locked)
> +			goto skip_recheck;
> +
> +		locked = compact_trylock_irqsave(&zone->lru_lock, &flags, cc);
>  		if (!locked)
>  			break;
>  
> @@ -686,6 +696,7 @@ isolate_migratepages_range(struct zone *zone, struct compact_control *cc,
>  			continue;
>  		}
>  
> +skip_recheck:
>  		lruvec = mem_cgroup_page_lruvec(page, zone);
>  
>  		/* Try isolate the page */

Looks good.  I wonder how the lock-taking and the rechecks would look 
nested in a "if (!locked)" clause and whether that would be cleaner (and 
avoid the gotos), but I assume you already looked at that.
