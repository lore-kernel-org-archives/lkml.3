Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616AbbAIGe1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 01:34:27 -0500
Received: from out4133-34.mail.aliyun.com ([42.120.133.34]:18251 "EHLO
	out4133-34.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750928AbbAIGe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 01:34:26 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;FP=0|-1|-1|-1|0|-1|-1|-1;HT=r41g03016;MF=hillf.zj@alibaba-inc.com;PH=DS;RN=10;RT=10;SR=0;
Reply-To: "Hillf Danton" <hillf.zj@alibaba-inc.com>
From: "Hillf Danton" <hillf.zj@alibaba-inc.com>
To: "'Vladimir Davydov'" <vdavydov@parallels.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
        "'Johannes Weiner'" <hannes@cmpxchg.org>,
        "'Michal Hocko'" <mhocko@suse.cz>,
        "'Greg Thelen'" <gthelen@google.com>,
        "'Glauber Costa'" <glommer@gmail.com>,
        "'Dave Chinner'" <david@fromorbit.com>,
        "'Alexander Viro'" <viro@zeniv.linux.org.uk>,
        "linux-kernel" <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: Re: [PATCH -mm v3 3/9] vmscan: per memory cgroup slab shrinkers
Date: Fri, 09 Jan 2015 14:33:46 +0800
Message-ID: <063c01d02bd6$38c64ce0$aa52e6a0$@alibaba-inc.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AdAr1Q+flfVN5SFRTRi7mkF/91CLyg==
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  static bool shrink_zone(struct zone *zone, struct scan_control *sc,
>  			bool is_classzone)
>  {
> +	struct reclaim_state *reclaim_state = current->reclaim_state;
>  	unsigned long nr_reclaimed, nr_scanned;
>  	bool reclaimable = false;
> 
> @@ -2318,16 +2357,22 @@ static bool shrink_zone(struct zone *zone, struct scan_control *sc,
> 
>  		memcg = mem_cgroup_iter(root, NULL, &reclaim);
>  		do {
> -			unsigned long lru_pages;
> +			unsigned long lru_pages, scanned;
>  			struct lruvec *lruvec;
>  			int swappiness;
> 
>  			lruvec = mem_cgroup_zone_lruvec(zone, memcg);
>  			swappiness = mem_cgroup_swappiness(memcg);
> +			scanned = sc->nr_scanned;
> 
>  			shrink_lruvec(lruvec, swappiness, sc, &lru_pages);
>  			zone_lru_pages += lru_pages;
> 
> +			if (memcg && is_classzone)
> +				shrink_slab(sc->gfp_mask, zone_to_nid(zone),
> +					    memcg, sc->nr_scanned - scanned,
> +					    lru_pages);
> +
Looks sc->nr_reclaimed has to be updated for "limit reclaim".

Hillf
>  			/*
>  			 * Direct reclaim and kswapd have to scan all memory
>  			 * cgroups to fulfill the overall scan target for the
> @@ -2350,19 +2395,14 @@ static bool shrink_zone(struct zone *zone, struct scan_control *sc,
>  		 * Shrink the slab caches in the same proportion that
>  		 * the eligible LRU pages were scanned.
>  		 */
> -		if (global_reclaim(sc) && is_classzone) {
> -			struct reclaim_state *reclaim_state;
> -
> -			shrink_node_slabs(sc->gfp_mask, zone_to_nid(zone),
> -					  sc->nr_scanned - nr_scanned,
> -					  zone_lru_pages);
> -
> -			reclaim_state = current->reclaim_state;
> -			if (reclaim_state) {
> -				sc->nr_reclaimed +=
> -					reclaim_state->reclaimed_slab;
> -				reclaim_state->reclaimed_slab = 0;
> -			}
> +		if (global_reclaim(sc) && is_classzone)
> +			shrink_slab(sc->gfp_mask, zone_to_nid(zone), NULL,
> +				    sc->nr_scanned - nr_scanned,
> +				    zone_lru_pages);
> +
> +		if (reclaim_state) {
> +			sc->nr_reclaimed += reclaim_state->reclaimed_slab;
> +			reclaim_state->reclaimed_slab = 0;
>  		}
> 
>  		vmpressure(sc->gfp_mask, sc->target_mem_cgroup,
> --
> 1.7.10.4

