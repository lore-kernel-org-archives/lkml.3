Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756705AbaCEAhN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 19:37:13 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:63606 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756055AbaCEAhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 19:37:11 -0500
X-AuditID: 9c93017e-b7cf9ae000004b4b-aa-531671b51ee6
Date: Wed, 5 Mar 2014 09:37:10 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan@kernel.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: [PATCH 2/6] mm: add get_pageblock_migratetype_nolock() for cases
 where locking is undesirable
Message-ID: <20140305003709.GB2340@lge.com>
References: <1393596904-16537-1-git-send-email-vbabka@suse.cz>
 <1393596904-16537-3-git-send-email-vbabka@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393596904-16537-3-git-send-email-vbabka@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 28, 2014 at 03:15:00PM +0100, Vlastimil Babka wrote:
> In order to prevent race with set_pageblock_migratetype, most of calls to
> get_pageblock_migratetype have been moved under zone->lock. For the remaining
> call sites, the extra locking is undesirable, notably in free_hot_cold_page().
> 
> This patch introduces a _nolock version to be used on these call sites, where
> a wrong value does not affect correctness. The function makes sure that the
> value does not exceed valid migratetype numbers. Such too-high values are
> assumed to be a result of race and caller-supplied fallback value is returned
> instead.
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---
>  include/linux/mmzone.h | 24 ++++++++++++++++++++++++
>  mm/compaction.c        | 14 +++++++++++---
>  mm/memory-failure.c    |  3 ++-
>  mm/page_alloc.c        | 22 +++++++++++++++++-----
>  mm/vmstat.c            |  2 +-
>  5 files changed, 55 insertions(+), 10 deletions(-)
> 
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index fac5509..7c3f678 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -75,6 +75,30 @@ enum {
>  
>  extern int page_group_by_mobility_disabled;
>  
> +/*
> + * When called without zone->lock held, a race with set_pageblock_migratetype
> + * may result in bogus values. Use this variant only when this does not affect
> + * correctness, and taking zone->lock would be costly. Values >= MIGRATE_TYPES
> + * are considered to be a result of this race and the value of race_fallback
> + * argument is returned instead.
> + */
> +static inline int get_pageblock_migratetype_nolock(struct page *page,
> +	int race_fallback)
> +{
> +	int ret = get_pageblock_flags_group(page, PB_migrate, PB_migrate_end);
> +
> +	if (unlikely(ret >= MIGRATE_TYPES))
> +		ret = race_fallback;
> +
> +	return ret;
> +}

How about below forms?

get_pageblock_migratetype_locked(struct page *page)
get_pageblock_migratetype(struct page *page, int race_fallback)

get_pageblock_migratetype() and _nolock looks error-prone because developer
who try to use get_pageblock_migratetype() may not know that it needs lock.

Thanks.
