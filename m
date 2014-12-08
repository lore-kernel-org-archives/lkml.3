Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755354AbaLHL0P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 06:26:15 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53836 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755232AbaLHL0O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 06:26:14 -0500
Date: Mon, 8 Dec 2014 11:26:06 +0000
From: Mel Gorman <mgorman@suse.de>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: linux-mm@kvack.org, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        linux-kernel@vger.kernel.org, Minchan Kim <minchan@kernel.org>,
        Rik van Riel <riel@redhat.com>, David Rientjes <rientjes@google.com>
Subject: Re: [RFC PATCH 3/3] mm: always steal split buddies in fallback
 allocations
Message-ID: <20141208112606.GP6043@suse.de>
References: <1417713178-10256-1-git-send-email-vbabka@suse.cz>
 <1417713178-10256-4-git-send-email-vbabka@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1417713178-10256-4-git-send-email-vbabka@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 04, 2014 at 06:12:58PM +0100, Vlastimil Babka wrote:
> When allocation falls back to another migratetype, it will steal a page with
> highest available order, and (depending on this order and desired migratetype),
> it might also steal the rest of free pages from the same pageblock.
> 
> Given the preference of highest available order, it is likely that it will be
> higher than the desired order, and result in the stolen buddy page being split.
> The remaining pages after split are currently stolen only when the rest of the
> free pages are stolen.

The original intent was that the stolen fallback buddy page would be
added to the requested migratetype freelists. This was independent of
whether all other free pages in the pageblock were moved or whether the
pageblock migratetype was updated.

> This can however lead to situations where for MOVABLE
> allocations we split e.g. order-4 fallback UNMOVABLE page, but steal only
> order-0 page. Then on the next MOVABLE allocation (which may be batched to
> fill the pcplists) we split another order-3 or higher page, etc. By stealing
> all pages that we have split, we can avoid further stealing.
> 
> This patch therefore adjust the page stealing so that buddy pages created by
> split are always stolen. This has effect only on MOVABLE allocations, as
> RECLAIMABLE and UNMOVABLE allocations already always do that in addition to
> stealing the rest of free pages from the pageblock.
> 

This restores the intended behaviour.

> Note that commit 7118af076f6 ("mm: mmzone: MIGRATE_CMA migration type added")
> has already performed this change (unintentinally), but was reverted by commit
> 0cbef29a7821 ("mm: __rmqueue_fallback() should respect pageblock type").
> Neither included evaluation. My evaluation with stress-highalloc from mmtests
> shows about 2.5x reduction of page stealing events for MOVABLE allocations,
> without affecting the page stealing events for other allocation migratetypes.
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>

Acked-by: Mel Gorman <mgorman@suse.de>

-- 
Mel Gorman
SUSE Labs
