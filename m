Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516AbbANPeb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 10:34:31 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:62830 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280AbbANPe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 10:34:29 -0500
Date: Wed, 14 Jan 2015 16:34:25 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Vladimir Davydov <vdavydov@parallels.com>,
        Greg Thelen <gthelen@google.com>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] mm: memcontrol: default hierarchy interface for
 memory
Message-ID: <20150114153425.GF4706@dhcp22.suse.cz>
References: <1420776904-8559-1-git-send-email-hannes@cmpxchg.org>
 <1420776904-8559-2-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420776904-8559-2-git-send-email-hannes@cmpxchg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 08-01-15 23:15:04, Johannes Weiner wrote:
[...]
> @@ -2353,6 +2353,22 @@ done_restock:
>  	css_get_many(&memcg->css, batch);
>  	if (batch > nr_pages)
>  		refill_stock(memcg, batch - nr_pages);
> +	/*
> +	 * If the hierarchy is above the normal consumption range,
> +	 * make the charging task trim the excess.
> +	 */
> +	do {
> +		unsigned long nr_pages = page_counter_read(&memcg->memory);
> +		unsigned long high = ACCESS_ONCE(memcg->high);
> +
> +		if (nr_pages > high) {
> +			mem_cgroup_events(memcg, MEMCG_HIGH, 1);
> +
> +			try_to_free_mem_cgroup_pages(memcg, nr_pages - high,
> +						     gfp_mask, true);
> +		}

As I've said before I am not happy about this. Heavy parallel load
hitting on the limit can generate really high reclaim targets causing
over reclaim and long stalls. Moreover portions of the excess would be
reclaimed multiple times which is not necessary.

I am not entirely happy about reclaiming nr_pages for THP_PAGES already
and this might be much worse, more probable and less predictable.

I believe the target should be capped somehow. nr_pages sounds like a
compromise. It would still throttle the charger and scale much better.

> +
> +	} while ((memcg = parent_mem_cgroup(memcg)));
>  done:
>  	return ret;
>  }
[...]
> +static int memory_events_show(struct seq_file *m, void *v)
> +{
> +	struct mem_cgroup *memcg = mem_cgroup_from_css(seq_css(m));
> +
> +	seq_printf(m, "low %lu\n", mem_cgroup_read_events(memcg, MEMCG_LOW));
> +	seq_printf(m, "high %lu\n", mem_cgroup_read_events(memcg, MEMCG_HIGH));
> +	seq_printf(m, "max %lu\n", mem_cgroup_read_events(memcg, MEMCG_MAX));
> +	seq_printf(m, "oom %lu\n", mem_cgroup_read_events(memcg, MEMCG_OOM));
> +
> +	return 0;
> +}

OK, but I really think we need a way of OOM notification for user space
OOM handling as well - including blocking the OOM killer as we have
now.  This is not directly related to this patch so it doesn't have to
happen right now, we should just think about the proper interface if
oom_control is consider not suitable.

[...]
> @@ -2322,6 +2325,12 @@ static bool shrink_zone(struct zone *zone, struct scan_control *sc,
>  			struct lruvec *lruvec;
>  			int swappiness;
>  
> +			if (mem_cgroup_low(root, memcg)) {
> +				if (!sc->may_thrash)
> +					continue;
> +				mem_cgroup_events(memcg, MEMCG_LOW, 1);
> +			}
> +
>  			lruvec = mem_cgroup_zone_lruvec(zone, memcg);
>  			swappiness = mem_cgroup_swappiness(memcg);
>  
> @@ -2343,8 +2352,7 @@ static bool shrink_zone(struct zone *zone, struct scan_control *sc,
>  				mem_cgroup_iter_break(root, memcg);
>  				break;
>  			}
> -			memcg = mem_cgroup_iter(root, memcg, &reclaim);
> -		} while (memcg);
> +		} while ((memcg = mem_cgroup_iter(root, memcg, &reclaim)));

I had a similar code but then I could trigger quick priority drop downs
during parallel reclaim with multiple low limited groups. I've tried to
address that by retrying shrink_zone if it hasn't called shrink_lruvec
at all. Still not ideal because it can livelock theoretically, but I
haven't seen that in my testing.

The following is a quick rebase (not tested yet). I can send it as a
separate patch with a full changelog if you prefer that over merging it
into yours but I think we need it in some form:

diff --git a/mm/vmscan.c b/mm/vmscan.c
index cd4cbc045b79..6cf7d4293976 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2306,6 +2306,7 @@ static bool shrink_zone(struct zone *zone, struct scan_control *sc,
 {
 	unsigned long nr_reclaimed, nr_scanned;
 	bool reclaimable = false;
+	int scanned_memcgs = 0;
 
 	do {
 		struct mem_cgroup *root = sc->target_mem_cgroup;
@@ -2331,6 +2332,7 @@ static bool shrink_zone(struct zone *zone, struct scan_control *sc,
 				mem_cgroup_events(memcg, MEMCG_LOW, 1);
 			}
 
+			scanned_memcgs++;
 			lruvec = mem_cgroup_zone_lruvec(zone, memcg);
 			swappiness = mem_cgroup_swappiness(memcg);
 
@@ -2355,6 +2357,14 @@ static bool shrink_zone(struct zone *zone, struct scan_control *sc,
 		} while ((memcg = mem_cgroup_iter(root, memcg, &reclaim)));
 
 		/*
+		 * reclaimers are racing and only saw low limited memcgs
+		 * so we have to retry the memcg walk.
+		 */
+		if (!scanned_memcgs && (global_reclaim(sc) ||
+					!mem_cgroup_low(root, root)))
+			continue;
+
+		/*
 		 * Shrink the slab caches in the same proportion that
 		 * the eligible LRU pages were scanned.
 		 */
@@ -2380,8 +2390,11 @@ static bool shrink_zone(struct zone *zone, struct scan_control *sc,
 		if (sc->nr_reclaimed - nr_reclaimed)
 			reclaimable = true;
 
-	} while (should_continue_reclaim(zone, sc->nr_reclaimed - nr_reclaimed,
-					 sc->nr_scanned - nr_scanned, sc));
+		if (!should_continue_reclaim(zone,
+					sc->nr_reclaimed - nr_reclaimed,
+					sc->nr_scanned - nr_scanned, sc))
+			break;
+	} while (true);
 
 	return reclaimable;
 }

[...]

Other than that the patch looks OK and I am happy this has moved
forward finally.
-- 
Michal Hocko
SUSE Labs
