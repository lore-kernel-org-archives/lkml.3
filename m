Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753587AbbAORHh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 12:07:37 -0500
Received: from mx2.parallels.com ([199.115.105.18]:57994 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219AbbAORHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 12:07:36 -0500
Date: Thu, 15 Jan 2015 20:07:26 +0300
From: Vladimir Davydov <vdavydov@parallels.com>
To: Michal Hocko <mhocko@suse.cz>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Vlastimil Babka <vbabka@suse.cz>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -mm v2] vmscan: move reclaim_state handling to shrink_slab
Message-ID: <20150115170726.GH11264@esperanza>
References: <1421311073-28130-1-git-send-email-vdavydov@parallels.com>
 <20150115125820.GE7000@dhcp22.suse.cz>
 <20150115132516.GG11264@esperanza>
 <20150115144838.GI7000@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20150115144838.GI7000@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2015 at 03:48:38PM +0100, Michal Hocko wrote:
> On Thu 15-01-15 16:25:16, Vladimir Davydov wrote:
> > 		memcg = mem_cgroup_iter(root, NULL, &reclaim);
> > 		do {
> > 			[...]
> > 			if (memcg && is_classzone)
> > 				shrink_slab(sc->gfp_mask, zone_to_nid(zone),
> > 					    memcg, sc->nr_scanned - scanned,
> > 					    lru_pages);
> > 
> > 			/*
> > 			 * Direct reclaim and kswapd have to scan all memory
> > 			 * cgroups to fulfill the overall scan target for the
> > 			 * zone.
> > 			 *
> > 			 * Limit reclaim, on the other hand, only cares about
> > 			 * nr_to_reclaim pages to be reclaimed and it will
> > 			 * retry with decreasing priority if one round over the
> > 			 * whole hierarchy is not sufficient.
> > 			 */
> > 			if (!global_reclaim(sc) &&
> > 					sc->nr_reclaimed >= sc->nr_to_reclaim) {
> > 				mem_cgroup_iter_break(root, memcg);
> > 				break;
> > 			}
> > 			memcg = mem_cgroup_iter(root, memcg, &reclaim);
> > 		} while (memcg);
> > 
> > 
> > If we can ignore reclaimed slab pages here (?), let's drop this patch.
> 
> I see what you are trying to achieve but can this lead to a serious
> over-reclaim?

I think it can, but only if we shrink an inode with lots of pages
attached to its address space (they also count to reclaim_state). In
this case, we overreclaim anyway though.

I agree that this is a high risk for a vague benefit. Let's drop it
until we see this problem in real life.

Thanks,
Vladimir
