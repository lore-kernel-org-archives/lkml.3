Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753085AbbAOOso (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 09:48:44 -0500
Received: from mail-we0-f170.google.com ([74.125.82.170]:52863 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219AbbAOOsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 09:48:42 -0500
Date: Thu, 15 Jan 2015 15:48:38 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Vlastimil Babka <vbabka@suse.cz>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm v2] vmscan: move reclaim_state handling to shrink_slab
Message-ID: <20150115144838.GI7000@dhcp22.suse.cz>
References: <1421311073-28130-1-git-send-email-vdavydov@parallels.com>
 <20150115125820.GE7000@dhcp22.suse.cz>
 <20150115132516.GG11264@esperanza>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150115132516.GG11264@esperanza>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 15-01-15 16:25:16, Vladimir Davydov wrote:
> On Thu, Jan 15, 2015 at 01:58:20PM +0100, Michal Hocko wrote:
> > On Thu 15-01-15 11:37:53, Vladimir Davydov wrote:
> > > current->reclaim_state is only used to count the number of slab pages
> > > reclaimed by shrink_slab(). So instead of initializing it before we are
> > > 
> > > Note that after this patch try_to_free_mem_cgroup_pages() will count not
> > > only reclaimed user pages, but also slab pages, which is expected,
> > > because it can reclaim kmem from kmem-active sub cgroups.
> > 
> > Except that reclaim_state counts all freed slab objects that have
> > current->reclaim_state != NULL AFAIR. This includes also kfreed pages
> > from interrupt context and who knows what else and those pages might be
> > from a different memcgs, no?
> 
> Hmm, true, good point. Can an interrupt handler free a lot of memory
> though?

it is drivers so who knows...

> Does RCU free objects from irq or soft irq context?

and this is another part which I didn't consider at all. RCU callbacks
are normally processed from kthread context but rcu_init also does
open_softirq(RCU_SOFTIRQ, rcu_process_callbacks)
so something is clearly processed from softirq as well. I am not
familiar with RCU details enough to tell how many callbacks are
processed this way. Tiny RCU, on the other hand, seem to be processing
all callbacks via __rcu_process_callbacks and that seems to be processed
from softirq only.

> > Besides that I am not sure this makes any difference in the end. No
> > try_to_free_mem_cgroup_pages caller really cares about the exact
> > number of reclaimed pages. We care only about whether there was any
> > progress done - and even that not exactly (e.g. try_charge checks
> > mem_cgroup_margin before retry/oom so if sufficient kmem pages were
> > uncharged then we will notice that).
> 
> Frankly, I thought exactly the same initially, that's why I dropped
> reclaim_state handling from the initial memcg shrinkers patch set.
> However, then Hillf noticed that nr_reclaimed is checked right after
> calling shrink_slab() in the memcg iteration loop in shrink_zone():
> 
> 
> 		memcg = mem_cgroup_iter(root, NULL, &reclaim);
> 		do {
> 			[...]
> 			if (memcg && is_classzone)
> 				shrink_slab(sc->gfp_mask, zone_to_nid(zone),
> 					    memcg, sc->nr_scanned - scanned,
> 					    lru_pages);
> 
> 			/*
> 			 * Direct reclaim and kswapd have to scan all memory
> 			 * cgroups to fulfill the overall scan target for the
> 			 * zone.
> 			 *
> 			 * Limit reclaim, on the other hand, only cares about
> 			 * nr_to_reclaim pages to be reclaimed and it will
> 			 * retry with decreasing priority if one round over the
> 			 * whole hierarchy is not sufficient.
> 			 */
> 			if (!global_reclaim(sc) &&
> 					sc->nr_reclaimed >= sc->nr_to_reclaim) {
> 				mem_cgroup_iter_break(root, memcg);
> 				break;
> 			}
> 			memcg = mem_cgroup_iter(root, memcg, &reclaim);
> 		} while (memcg);
> 
> 
> If we can ignore reclaimed slab pages here (?), let's drop this patch.

I see what you are trying to achieve but can this lead to a serious
over-reclaim? We should be reclaiming mostly user pages and kmem should
be only a small portion I would expect.
-- 
Michal Hocko
SUSE Labs
