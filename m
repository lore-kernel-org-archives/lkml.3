Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758441Ab3G2Rsa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 13:48:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59864 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753154Ab3G2Rs3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 13:48:29 -0400
Date: Mon, 29 Jul 2013 19:48:21 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 3/3] mm: page_alloc: fair zone allocator policy
Message-ID: <20130729174820.GF3476@redhat.com>
References: <1374267325-22865-1-git-send-email-hannes@cmpxchg.org>
 <1374267325-22865-4-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374267325-22865-4-git-send-email-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Johannes,

On Fri, Jul 19, 2013 at 04:55:25PM -0400, Johannes Weiner wrote:
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index af1d956b..d938b67 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1879,6 +1879,14 @@ zonelist_scan:
>  		if (alloc_flags & ALLOC_NO_WATERMARKS)
>  			goto try_this_zone;
>  		/*
> +		 * Distribute pages in proportion to the individual
> +		 * zone size to ensure fair page aging.  The zone a
> +		 * page was allocated in should have no effect on the
> +		 * time the page has in memory before being reclaimed.
> +		 */
> +		if (atomic_read(&zone->alloc_batch) <= 0)
> +			continue;
> +		/*
>  		 * When allocating a page cache page for writing, we
>  		 * want to get it from a zone that is within its dirty
>  		 * limit, such that no single zone holds more than its

I rebased the zone_reclaim_mode and compaction fixes on top of the
zone fair allocator (it applied without rejects, lucky) but the above
breaks zone_reclaim_mode (it regress for pagecache too, which
currently works), so then in turn my THP/compaction tests break too.

zone_reclaim_mode isn't LRU-fair, and cannot be... (even migrating
cache around nodes to try to keep LRU fariness would not be worth it,
especially with ssds). But we can still increase the fairness within
the zones of the current node (for those nodes that have more than 1
zone).

I think to fix it we need an additional first pass of the fast path,
and if alloc_batch is <= 0 for any zone in the current node, we then
forbid allocating from the zones not in the current node (even if
alloc_batch would allow it) during the first pass, only if
zone_reclaim_mode is enabled. If first pass fails, we need to reset
alloc_batch for all zones in the current node (and only in the current
zone), goto zonelist_scan and continue as we do now.
