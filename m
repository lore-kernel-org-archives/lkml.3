Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752215AbaIAANe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 20:13:34 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:52793 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995AbaIAANd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 20:13:33 -0400
X-Original-SENDERIP: 10.177.222.131
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Mon, 1 Sep 2014 09:14:01 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Rik van Riel <riel@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Mel Gorman <mgorman@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan@kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Tang Chen <tangchen@cn.fujitsu.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Wen Congyang <wency@cn.fujitsu.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Laura Abbott <lauraa@codeaurora.org>,
        Heesub Shin <heesub.shin@samsung.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Ritesh Harjani <ritesh.list@gmail.com>, t.stanislaws@samsung.com,
        Gioh Kim <gioh.kim@lge.com>, Vlastimil Babka <vbabka@suse.cz>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v3 1/4] mm/page_alloc: fix incorrect isolation
 behavior by rechecking migratetype
Message-ID: <20140901001401.GB25599@js1304-P5Q-DELUXE>
References: <1409040498-10148-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1409040498-10148-2-git-send-email-iamjoonsoo.kim@lge.com>
 <20140829174641.GB27127@nhori.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140829174641.GB27127@nhori.bos.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 29, 2014 at 01:46:41PM -0400, Naoya Horiguchi wrote:
> On Tue, Aug 26, 2014 at 05:08:15PM +0900, Joonsoo Kim wrote:
> > There are two paths to reach core free function of buddy allocator,
> > __free_one_page(), one is free_one_page()->__free_one_page() and the
> > other is free_hot_cold_page()->free_pcppages_bulk()->__free_one_page().
> > Each paths has race condition causing serious problems. At first, this
> > patch is focused on first type of freepath. And then, following patch
> > will solve the problem in second type of freepath.
> > 
> > In the first type of freepath, we got migratetype of freeing page without
> > holding the zone lock, so it could be racy. There are two cases of this
> > race.
> > 
> > 1. pages are added to isolate buddy list after restoring orignal
> > migratetype
> > 
> > CPU1                                   CPU2
> > 
> > get migratetype => return MIGRATE_ISOLATE
> > call free_one_page() with MIGRATE_ISOLATE
> > 
> > 				grab the zone lock
> > 				unisolate pageblock
> > 				release the zone lock
> > 
> > grab the zone lock
> > call __free_one_page() with MIGRATE_ISOLATE
> > freepage go into isolate buddy list,
> > although pageblock is already unisolated
> > 
> > This may cause two problems. One is that we can't use this page anymore
> > until next isolation attempt of this pageblock, because freepage is on
> > isolate pageblock. The other is that freepage accouting could be wrong
> > due to merging between different buddy list. Freepages on isolate buddy
> > list aren't counted as freepage, but ones on normal buddy list are counted
> > as freepage. If merge happens, buddy freepage on normal buddy list is
> > inevitably moved to isolate buddy list without any consideration of
> > freepage accouting so it could be incorrect.
> > 
> > 2. pages are added to normal buddy list while pageblock is isolated.
> > It is similar with above case.
> > 
> > This also may cause two problems. One is that we can't keep these
> > freepages from being allocated. Although this pageblock is isolated,
> > freepage would be added to normal buddy list so that it could be
> > allocated without any restriction. And the other problem is same as
> > case 1, that it, incorrect freepage accouting.
> > 
> > This race condition would be prevented by checking migratetype again
> > with holding the zone lock. Because it is somewhat heavy operation
> > and it isn't needed in common case, we want to avoid rechecking as much
> > as possible. So this patch introduce new variable, nr_isolate_pageblock
> > in struct zone to check if there is isolated pageblock.
> > With this, we can avoid to re-check migratetype in common case and do
> > it only if there is isolated pageblock. This solve above
> > mentioned problems.
> > 
> > Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> > ---
> >  include/linux/mmzone.h         |    4 ++++
> >  include/linux/page-isolation.h |    8 ++++++++
> >  mm/page_alloc.c                |   10 ++++++++--
> >  mm/page_isolation.c            |    2 ++
> >  4 files changed, 22 insertions(+), 2 deletions(-)
> > 
> > diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> > index 318df70..23e69f1 100644
> > --- a/include/linux/mmzone.h
> > +++ b/include/linux/mmzone.h
> > @@ -431,6 +431,10 @@ struct zone {
> >  	 */
> >  	int			nr_migrate_reserve_block;
> >  
> > +#ifdef CONFIG_MEMORY_ISOLATION
> 
> It's worth adding some comment, especially about locking?
> The patch itself looks good me.

Okay. Will do. :)

Thanks.
