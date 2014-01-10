Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254AbaAJJso (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 04:48:44 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41397 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751216AbaAJJsk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 04:48:40 -0500
Date: Fri, 10 Jan 2014 09:48:34 +0000
From: Mel Gorman <mgorman@suse.de>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Rik van Riel <riel@redhat.com>, Jiang Liu <jiang.liu@huawei.com>,
        Cody P Schafer <cody@linux.vnet.ibm.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Minchan Kim <minchan@kernel.org>,
        Michal Nazarewicz <mina86@mina86.com>, Andi Kleen <ak@linux.intel.com>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Tang Chen <tangchen@cn.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] improve robustness on handling migratetype
Message-ID: <20140110094834.GV27046@suse.de>
References: <1389251087-10224-1-git-send-email-iamjoonsoo.kim@lge.com>
 <20140109092720.GM27046@suse.de>
 <20140110084854.GA22058@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20140110084854.GA22058@lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 10, 2014 at 05:48:55PM +0900, Joonsoo Kim wrote:
> On Thu, Jan 09, 2014 at 09:27:20AM +0000, Mel Gorman wrote:
> > On Thu, Jan 09, 2014 at 04:04:40PM +0900, Joonsoo Kim wrote:
> > > Hello,
> > > 
> > > I found some weaknesses on handling migratetype during code review and
> > > testing CMA.
> > > 
> > > First, we don't have any synchronization method on get/set pageblock
> > > migratetype. When we change migratetype, we hold the zone lock. So
> > > writer-writer race doesn't exist. But while someone changes migratetype,
> > > others can get migratetype. This may introduce totally unintended value
> > > as migratetype. Although I haven't heard of any problem report about
> > > that, it is better to protect properly.
> > > 
> > 
> > This is deliberate. The migratetypes for the majority of users are advisory
> > and aimed for fragmentation avoidance. It was important that the cost of
> > that be kept as low as possible and the general case is that migration types
> > change very rarely. In many cases, the zone lock is held. In other cases,
> > such as splitting free pages, the cost is simply not justified.
> > 
> > I doubt there is any amount of data you could add in support that would
> > justify hammering the free fast paths (which call get_pageblock_type).
> 
> Hello, Mel.
> 
> There is a possibility that we can get unintended value such as 6 as migratetype
> if reader-writer (get/set pageblock_migratetype) race happends. It can be
> possible, because we read the value without any synchronization method. And
> this migratetype, 6, has no place in buddy freelist, so array index overrun can
> be possible and the system can break, although I haven't heard that it occurs.
> 
> I think that my solution is too expensive. However, I think that we need
> solution. aren't we? Do you have any better idea?
> 

It's not something I have ever heard or seen of occurring but
if you've identified that it's a real possibility then split
get_pageblock_migratetype into locked and unlocked versions. Ensure
that calls to set_pageblock_migratetype is always under zone->lock and
get_pageblock_migratetype is also under zone->lock which both should be
true in the majority of cases. Use the unlocked version otherwise but
instead of synchronoing, check if it's returning >= MIGRATE_TYPES and
return MIGRATE_MOVABLE in the unlikely event of a race. This will avoid
harming the fast paths for the majority of users and limit the damage if
a MIGRATE_CMA region is accidentally treated as MIGRATe_MOVABLE

-- 
Mel Gorman
SUSE Labs
