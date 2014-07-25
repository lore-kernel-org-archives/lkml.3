Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760018AbaGYMgw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 08:36:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40184 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751348AbaGYMgu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 08:36:50 -0400
Date: Fri, 25 Jul 2014 13:36:46 +0100
From: Mel Gorman <mgorman@suse.de>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        Minchan Kim <minchan@kernel.org>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: Re: [PATCH V4 11/15] mm, compaction: skip buddy pages by their order
 in the migrate scanner
Message-ID: <20140725123646.GF10819@suse.de>
References: <1405518503-27687-1-git-send-email-vbabka@suse.cz>
 <1405518503-27687-12-git-send-email-vbabka@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1405518503-27687-12-git-send-email-vbabka@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2014 at 03:48:19PM +0200, Vlastimil Babka wrote:
> The migration scanner skips PageBuddy pages, but does not consider their order
> as checking page_order() is generally unsafe without holding the zone->lock,
> and acquiring the lock just for the check wouldn't be a good tradeoff.
> 
> Still, this could avoid some iterations over the rest of the buddy page, and
> if we are careful, the race window between PageBuddy() check and page_order()
> is small, and the worst thing that can happen is that we skip too much and miss
> some isolation candidates. This is not that bad, as compaction can already fail
> for many other reasons like parallel allocations, and those have much larger
> race window.
> 
> This patch therefore makes the migration scanner obtain the buddy page order
> and use it to skip the whole buddy page, if the order appears to be in the
> valid range.
> 
> It's important that the page_order() is read only once, so that the value used
> in the checks and in the pfn calculation is the same. But in theory the
> compiler can replace the local variable by multiple inlines of page_order().
> Therefore, the patch introduces page_order_unsafe() that uses ACCESS_ONCE to
> prevent this.
> 
> Testing with stress-highalloc from mmtests shows a 15% reduction in number of
> pages scanned by migration scanner. The reduction is >60% with __GFP_NO_KSWAPD
> allocations, along with success rates better by few percent.
> This change is also a prerequisite for a later patch which is detecting when
> a cc->order block of pages contains non-buddy pages that cannot be isolated,
> and the scanner should thus skip to the next block immediately.
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> Reviewed-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
> Acked-by: Minchan Kim <minchan@kernel.org>

Acked-by: Mel Gorman <mgorman@suse.de>

-- 
Mel Gorman
SUSE Labs
