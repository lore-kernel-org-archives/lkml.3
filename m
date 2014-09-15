Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752830AbaIOGhq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 02:37:46 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:46621 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541AbaIOGho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 02:37:44 -0400
X-Original-SENDERIP: 10.177.220.156
X-Original-MAILFROM: minchan@kernel.org
Date: Mon, 15 Sep 2014 15:37:54 +0900
From: Minchan Kim <minchan@kernel.org>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Gioh Kim <gioh.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>, jack@suse.cz,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
        paulmck@linux.vnet.ibm.com, peterz@infradead.org,
        adilger.kernel@dilger.ca, gunho.lee@lge.com,
        Mel Gorman <mgorman@suse.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>
Subject: Re: [PATCHv4 0/3] new APIs to allocate buffer-cache with user
 specific flag
Message-ID: <20140915063754.GK2160@bbox>
References: <1409815781-28011-1-git-send-email-gioh.kim@lge.com>
 <20140904151612.7bf5b813069ff78973e01571@linux-foundation.org>
 <540905B1.1050200@lge.com>
 <20140905011419.GE4364@thunk.org>
 <20140905014808.GA26070@js1304-P5Q-DELUXE>
 <20140905031735.GD1971@thunk.org>
 <20140905073247.GA31827@js1304-P5Q-DELUXE>
 <20140905141416.GA1510@thunk.org>
 <20140915011018.GA2676@js1304-P5Q-DELUXE>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140915011018.GA2676@js1304-P5Q-DELUXE>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 15, 2014 at 10:10:18AM +0900, Joonsoo Kim wrote:
> On Fri, Sep 05, 2014 at 10:14:16AM -0400, Theodore Ts'o wrote:
> > On Fri, Sep 05, 2014 at 04:32:48PM +0900, Joonsoo Kim wrote:
> > > I also test another approach, such as allocate freepage in CMA
> > > reserved region as late as possible, which is also similar to your
> > > suggestion and this doesn't works well. When reclaim is started,
> > > too many pages reclaim at once, because lru list has successive pages
> > > in CMA region and these doesn't help kswapd's reclaim. kswapd stop
> > > reclaiming when freepage count is recovered. But, CMA pages isn't
> > > counted for freepage for kswapd because they can't be usable for
> > > unmovable, reclaimable allocation. So kswap reclaim too many pages
> > > at once unnecessarilly.
> > 
> > Have you considered putting the pages in a CMA region in a separate
> > zone?  After all, that's what we originally did with brain-damaged
> > hardware that could only DMA into the low 16M of memory.  We just
> > reserved a separate zone for that?  That way, we could do
> > zone-directed reclaim and free pages in that zone, if that was what
> > was actually needed.
> 
> Sorry for long delay. It was long holidays.
> 
> No, I haven't consider it. It sounds good idea to place the pages in a
> CMA region into a separate zone. Perhaps we can remove one of
> migratetype, MIGRATE_CMA, with this way and it would be a good long-term
> architecture for CMA.

IIRC, Mel suggested two options, ZONE_MOVABLE zone and MIGRATE_ISOLATE.
Absolutely, movable zone option is better solution if we consider
interacting with reclaim but one problem was CMA had a specific
requirement for memory in the middle of an existing zone.
And his concern comes true.
Look at https://lkml.org/lkml/2014/5/28/64.
It starts to add more stuff in allocator's fast path to overcome the
problem. :(

Let's rethink. We already have a logic to handle overlapping nodes/zones
in compaction.c so isn't it possible to have discrete address ranges
in a movable zone? If so, movable zone can include specific ranges horrible
devices want and it could make allocation/reclaim logic simple than now and
add overheads to slow path(ie, linear pfn scanning logic of zone like
compaction).

> 
> I don't know exact history and reason why CMA is implemented in current
> form. Ccing some experts in this area.
> 
> Thanks.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Kind regards,
Minchan Kim
