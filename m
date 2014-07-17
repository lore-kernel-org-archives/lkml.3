Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519AbaGQGGD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 02:06:03 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:47580 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615AbaGQGGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 02:06:01 -0400
X-Original-SENDERIP: 10.177.220.145
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Thu, 17 Jul 2014 15:12:06 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Rik van Riel <riel@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Mel Gorman <mgorman@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan@kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Tang Chen <tangchen@cn.fujitsu.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Wen Congyang <wency@cn.fujitsu.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Laura Abbott <lauraa@codeaurora.org>,
        Heesub Shin <heesub.shin@samsung.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Ritesh Harjani <ritesh.list@gmail.com>, t.stanislaws@samsung.com,
        Gioh Kim <gioh.kim@lge.com>, linux-mm@kvack.org,
        Lisa Du <cldu@marvell.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/10] fix freepage count problems due to memory isolation
Message-ID: <20140717061205.GA22418@js1304-P5Q-DELUXE>
References: <1404460675-24456-1-git-send-email-iamjoonsoo.kim@lge.com>
 <53B6C947.1070603@suse.cz>
 <20140707044932.GA29236@js1304-P5Q-DELUXE>
 <53BAAFA5.9070403@suse.cz>
 <20140714062222.GA11317@js1304-P5Q-DELUXE>
 <53C3A7A5.9060005@suse.cz>
 <20140715082828.GM11317@js1304-P5Q-DELUXE>
 <53C4E813.7020108@suse.cz>
 <20140716084333.GA20359@js1304-P5Q-DELUXE>
 <53C65E92.2000606@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53C65E92.2000606@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2014 at 01:14:26PM +0200, Vlastimil Babka wrote:
> On 07/16/2014 10:43 AM, Joonsoo Kim wrote:
> >> I think your plan of multiple parallel CMA allocations (and thus
> >> multiple parallel isolations) is also possible. The isolate pcplists
> >> can be shared by pages coming from multiple parallel isolations. But
> >> the flush operation needs a pfn start/end parameters to only flush
> >> pages belonging to the given isolation. That might mean a bit of
> >> inefficient list traversing, but I don't think it's a problem.
> > 
> > I think that special pcplist would cause a problem if we should check
> > pfn range. If there are too many pages on this pcplist, move pages from
> > this pcplist to isolate freelist takes too long time in irq context and
> > system could be broken. This operation cannot be easily stopped because
> > it is initiated by IPI on other cpu and starter of this IPI expect that
> > all pages on other cpus' pcplist are moved properly when returning
> > from on_each_cpu().
> > 
> > And, if there are so many pages, serious lock contention would happen
> > in this case.
> 
> Hm I see. So what if it wasn't a special pcplist, but a special "free list"
> where the pages would be just linked together as on pcplist, regardless of
> order, and would not merge until the CPU that drives the memory isolation
> process decides it is safe to flush them away. That would remove the need for
> IPI's and provide the same guarantees I think.

Looks good. It would work. I think that your solution is better than mine.
I will implement it and test. 

> 
> > Anyway, my idea's key point is using PageIsolated() to distinguish
> > isolated page, instead of using PageBuddy(). If page is PageIsolated(),
> 
> Is PageIsolated a completely new page flag? Those are a limited resource so I
> would expect some resistance to such approach. Or a new special page->_mapcount
> value? That could maybe work.

Yes, it is new special page->_mapcount.

> > it isn't handled as freepage although it is in buddy allocator. During free,
> > page with MIGRATETYPE_ISOLATE will be marked as PageIsolated() and
> > won't be merged and counted for freepage.
> 
> OK. Preventing wrong merging is the key point and this should work.
> 
> > When we move pages from normal buddy list to isolate buddy
> > list, we check PageBuddy() and subtract number of PageBuddy() pages
> 
> Do we really need to check PageBuddy()? Could a page get marked as PageIsolate()
> but still go to normal list instead of isolate list?

Checking PageBuddy() is used for identifying page linked in normal
list.

Thanks.
