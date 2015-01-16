Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756751AbbAPSx6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 13:53:58 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47254 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751896AbbAPSx5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 13:53:57 -0500
Message-ID: <54B95E41.5010305@suse.cz>
Date: Fri, 16 Jan 2015 19:53:53 +0100
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>,
        Vladimir Davydov <vdavydov@parallels.com>,
        Rik van Riel <riel@redhat.com>, Michal Hocko <mhocko@suse.cz>,
        Mel Gorman <mgorman@suse.de>, Suleiman Souhlal <suleiman@google.com>,
        linux-mm@kvack.org
Subject: Re: [PATCH] mm/vmscan: fix highidx argument type
References: <1421360175-18899-1-git-send-email-mst@redhat.com> <20150115144920.33c446af388ed74c11dc573e@linux-foundation.org> <20150116070744.GA12190@redhat.com>
In-Reply-To: <20150116070744.GA12190@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2015 08:07 AM, Michael S. Tsirkin wrote:
> On Thu, Jan 15, 2015 at 02:49:20PM -0800, Andrew Morton wrote:
>> On Fri, 16 Jan 2015 00:18:12 +0200 "Michael S. Tsirkin" <mst@redhat.com> wrote:
>> 
>> > for_each_zone_zonelist_nodemask wants an enum zone_type
>> > argument, but is passed gfp_t:
>> > 
>> > mm/vmscan.c:2658:9:    expected int enum zone_type [signed] highest_zoneidx
>> > mm/vmscan.c:2658:9:    got restricted gfp_t [usertype] gfp_mask
>> > mm/vmscan.c:2658:9: warning: incorrect type in argument 2 (different base types)
>> > mm/vmscan.c:2658:9:    expected int enum zone_type [signed] highest_zoneidx
>> > mm/vmscan.c:2658:9:    got restricted gfp_t [usertype] gfp_mask
>> 
>> Which tool emitted these warnings?
> 
> Oh, sorry.
> It's sparce.
> 
>> > convert argument to the correct type.
>> > 
>> > ...
>> >
>> > --- a/mm/vmscan.c
>> > +++ b/mm/vmscan.c
>> > @@ -2656,7 +2656,7 @@ static bool throttle_direct_reclaim(gfp_t gfp_mask, struct zonelist *zonelist,
>> >  	 * should make reasonable progress.
>> >  	 */
>> >  	for_each_zone_zonelist_nodemask(zone, z, zonelist,
>> > -					gfp_mask, nodemask) {
>> > +					gfp_zone(gfp_mask), nodemask) {
>> >  		if (zone_idx(zone) > ZONE_NORMAL)
>> >  			continue;
>> 
>> hm, I wonder what the runtime effects are.

So this was introduced by 675becce15f "mm: vmscan: do not throttle based on
pfmemalloc reserves if node has no ZONE_NORMAL" in 3.15. AFAICS gfp_mask >=
gfp_zone(gfp_mask), so the high_zoneidx will be higher than it should, and
next_zones_zonelist() won't filter the higher-than-wanted zones as it should.

I guess the runtime effects is that allocations for zone_type < NORMAL, i.e.
DMA32 or DMA, can now wrongly choose a numa node without such zones, for
checking pfmemalloc reserves and throttling. Which means the throttling can be
ineffective, or it could also throttle without actually needing to, if the wrong
zone has lower reserves? Mel?

>> The throttle_direct_reclaim() comment isn't really accurate, is it? 
>> "Throttle direct reclaimers if backing storage is backed by the
>> network".  The code is applicable to all types of backing, but was
>> added to address problems which are mainly observed with network
>> backing?

I guess. I also don't see any code restricting this just for network.

> 
> 
> As far as I can tell, yes. It would seem that it can cause
> deadlocks in theory.  Cc stable on the grounds that it's obvious?

I don't think this mistake can introduce deadlocks on its own, but it also won't
prevent any problems that the throttling was suppsoed to prevent.
I agree it should go stable.

BTW, I wonder if the whole code couldn't be much simpler by capping high_zoneidx
by ZONE_NORMAL before traversing the zonelist, like this:

int high_zoneidx = min(gfp_zone(gfp_mask), ZONE_NORMAL);

first_zones_zonelist(zonelist, high_zoneidx, NULL, &zone);
pgdat = zone->zone_pgdat;

if (!pgdat || pfmemalloc_watermark_ok(pgdat))
	goto out;


