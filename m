Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760292AbaGYM2I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 08:28:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39935 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751916AbaGYM2G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 08:28:06 -0400
Date: Fri, 25 Jul 2014 13:28:01 +0100
From: Mel Gorman <mgorman@suse.de>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
        Minchan Kim <minchan@kernel.org>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: Re: [PATCH V4 05/15] mm, compaction: move pageblock checks up from
 isolate_migratepages_range()
Message-ID: <20140725122801.GZ10819@suse.de>
References: <1405518503-27687-1-git-send-email-vbabka@suse.cz>
 <1405518503-27687-6-git-send-email-vbabka@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1405518503-27687-6-git-send-email-vbabka@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2014 at 03:48:13PM +0200, Vlastimil Babka wrote:
> isolate_migratepages_range() is the main function of the compaction scanner,
> called either on a single pageblock by isolate_migratepages() during regular
> compaction, or on an arbitrary range by CMA's __alloc_contig_migrate_range().
> It currently perfoms two pageblock-wide compaction suitability checks, and
> because of the CMA callpath, it tracks if it crossed a pageblock boundary in
> order to repeat those checks.
> 
> However, closer inspection shows that those checks are always true for CMA:
> - isolation_suitable() is true because CMA sets cc->ignore_skip_hint to true
> - migrate_async_suitable() check is skipped because CMA uses sync compaction
> 
> We can therefore move the compaction-specific checks to isolate_migratepages()
> and simplify isolate_migratepages_range(). Furthermore, we can mimic the
> freepage scanner family of functions, which has isolate_freepages_block()
> function called both by compaction from isolate_freepages() and by CMA from
> isolate_freepages_range(), where each use-case adds own specific glue code.
> This allows further code simplification.
> 
> Therefore, we rename isolate_migratepages_range() to isolate_freepages_block()
> and limit its functionality to a single pageblock (or its subset). For CMA,
> a new different isolate_migratepages_range() is created as a CMA-specific
> wrapper for the _block() function. The checks specific to compaction are moved
> to isolate_migratepages(). As part of the unification of these two families of
> functions, we remove the redundant zone parameter where applicable, since zone
> pointer is already passed in cc->zone.
> 
> Furthermore, going back to compact_zone() and compact_finished() when pageblock
> is found unsuitable (now by isolate_migratepages()) is wasteful - the checks
> are meant to skip pageblocks quickly. The patch therefore also introduces a
> simple loop into isolate_migratepages() so that it does not return immediately
> on failed pageblock checks, but keeps going until isolate_migratepages_range()
> gets called once. Similarily to isolate_freepages(), the function periodically
> checks if it needs to reschedule or abort async compaction.
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> Cc: Minchan Kim <minchan@kernel.org>
> Cc: Mel Gorman <mgorman@suse.de>
> Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> Cc: Michal Nazarewicz <mina86@mina86.com>
> Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> Cc: Christoph Lameter <cl@linux.com>
> Cc: Rik van Riel <riel@redhat.com>
> Cc: David Rientjes <rientjes@google.com>

Acked-by: Mel Gorman <mgorman@suse.de>

-- 
Mel Gorman
SUSE Labs
