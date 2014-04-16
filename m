Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751149AbaDPA4X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 20:56:23 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:41158 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbaDPA4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 20:56:21 -0400
X-Original-SENDERIP: 10.177.220.145
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Wed, 16 Apr 2014 09:56:47 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Mel Gorman <mgorman@suse.de>, Yong-Taek Lee <ytk.lee@samsung.com>,
        Minchan Kim <minchan@kernel.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        Michal Nazarewicz <mina86@mina86.com>
Subject: Re: [PATCH 1/2] mm/page_alloc: prevent MIGRATE_RESERVE pages from
 being misplaced
Message-ID: <20140416005647.GC17350@js1304-P5Q-DELUXE>
References: <533D8015.1000106@suse.cz>
 <1396539618-31362-1-git-send-email-vbabka@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396539618-31362-1-git-send-email-vbabka@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 03, 2014 at 05:40:17PM +0200, Vlastimil Babka wrote:
> For the MIGRATE_RESERVE pages, it is important they do not get misplaced
> on free_list of other migratetype, otherwise the whole MIGRATE_RESERVE
> pageblock might be changed to other migratetype in try_to_steal_freepages().
> 
> Currently, it is however possible for this to happen when MIGRATE_RESERVE
> page is allocated on pcplist through rmqueue_bulk() as a fallback for other
> desired migratetype, and then later freed back through free_pcppages_bulk()
> without being actually used. This happens because free_pcppages_bulk() uses
> get_freepage_migratetype() to choose the free_list, and rmqueue_bulk() calls
> set_freepage_migratetype() with the *desired* migratetype and not the page's
> original MIGRATE_RESERVE migratetype.
> 
> This patch fixes the problem by moving the call to set_freepage_migratetype()
> from rmqueue_bulk() down to __rmqueue_smallest() and __rmqueue_fallback() where
> the actual page's migratetype (e.g. from which free_list the page is taken
> from) is used. Note that this migratetype might be different from the
> pageblock's migratetype due to freepage stealing decisions. This is OK, as page
> stealing never uses MIGRATE_RESERVE as a fallback, and also takes care to leave
> all MIGRATE_CMA pages on the correct freelist.
> 
> Therefore, as an additional benefit, the call to get_pageblock_migratetype()
> from rmqueue_bulk() when CMA is enabled, can be removed completely. This relies
> on the fact that MIGRATE_CMA pageblocks are created only during system init,
> and the above. The related is_migrate_isolate() check is also unnecessary, as
> memory isolation has other ways to move pages between freelists, and drain
> pcp lists containing pages that should be isolated.
> The buffered_rmqueue() can also benefit from calling get_freepage_migratetype()
> instead of get_pageblock_migratetype().
> 
> A separate patch will add VM_BUG_ON checks for the invariant that for
> MIGRATE_RESERVE and MIGRATE_CMA pageblocks, freepage_migratetype must equal to
> pageblock_migratetype so that these pages always go to the correct free_list.
> 
> Reported-by: Yong-Taek Lee <ytk.lee@samsung.com>
> Reported-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> Suggested-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> Suggested-by: Mel Gorman <mgorman@suse.de>
> Cc: Minchan Kim <minchan@kernel.org>
> Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Cc: Marek Szyprowski <m.szyprowski@samsung.com>
> Cc: Hugh Dickins <hughd@google.com>
> Cc: Rik van Riel <riel@redhat.com>
> Cc: Michal Nazarewicz <mina86@mina86.com>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>

Looks good to me.

Acked-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
