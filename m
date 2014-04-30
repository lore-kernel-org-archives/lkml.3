Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946061AbaD3W4A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 18:56:00 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:60000 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752243AbaD3Wz7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 18:55:59 -0400
Date: Wed, 30 Apr 2014 18:55:50 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Greg Thelen <gthelen@google.com>,
        Michel Lespinasse <walken@google.com>, Tejun Heo <tj@kernel.org>,
        Hugh Dickins <hughd@google.com>, Roman Gushchin <klamm@yandex-team.ru>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH 1/4] memcg, mm: introduce lowlimit reclaim
Message-ID: <20140430225550.GD26041@cmpxchg.org>
References: <1398688005-26207-1-git-send-email-mhocko@suse.cz>
 <1398688005-26207-2-git-send-email-mhocko@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398688005-26207-2-git-send-email-mhocko@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2014 at 02:26:42PM +0200, Michal Hocko wrote:
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 19d620b3d69c..40e517630138 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2808,6 +2808,29 @@ static struct mem_cgroup *mem_cgroup_lookup(unsigned short id)
>  	return mem_cgroup_from_id(id);
>  }
>  
> +/**
> + * mem_cgroup_reclaim_eligible - checks whether given memcg is eligible for the
> + * reclaim
> + * @memcg: target memcg for the reclaim
> + * @root: root of the reclaim hierarchy (null for the global reclaim)
> + *
> + * The given group is reclaimable if it is above its low limit and the same
> + * applies for all parents up the hierarchy until root (including).
> + */
> +bool mem_cgroup_reclaim_eligible(struct mem_cgroup *memcg,
> +		struct mem_cgroup *root)

Could you please rename this to something that is more descriptive in
the reclaim callsite?  How about mem_cgroup_within_low_limit()?

> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index c1cd99a5074b..0f428158254e 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -2215,9 +2215,11 @@ static inline bool should_continue_reclaim(struct zone *zone,
>  	}
>  }
>  
> -static void shrink_zone(struct zone *zone, struct scan_control *sc)
> +static unsigned __shrink_zone(struct zone *zone, struct scan_control *sc,
> +		bool follow_low_limit)
>  {
>  	unsigned long nr_reclaimed, nr_scanned;
> +	unsigned nr_scanned_groups = 0;
>  
>  	do {
>  		struct mem_cgroup *root = sc->target_mem_cgroup;
> @@ -2234,7 +2236,23 @@ static void shrink_zone(struct zone *zone, struct scan_control *sc)
>  		do {
>  			struct lruvec *lruvec;
>  
> +			/*
> +			 * Memcg might be under its low limit so we have to
> +			 * skip it during the first reclaim round
> +			 */
> +			if (follow_low_limit &&
> +					!mem_cgroup_reclaim_eligible(memcg, root)) {
> +				/*
> +				 * It would be more optimal to skip the memcg
> +				 * subtree now but we do not have a memcg iter
> +				 * helper for that. Anyone?
> +				 */
> +				memcg = mem_cgroup_iter(root, memcg, &reclaim);
> +				continue;
> +			}
> +
>  			lruvec = mem_cgroup_zone_lruvec(zone, memcg);
> +			nr_scanned_groups++;
>  
>  			shrink_lruvec(lruvec, sc);
>  
> @@ -2262,6 +2280,20 @@ static void shrink_zone(struct zone *zone, struct scan_control *sc)
>  
>  	} while (should_continue_reclaim(zone, sc->nr_reclaimed - nr_reclaimed,
>  					 sc->nr_scanned - nr_scanned, sc));
> +
> +	return nr_scanned_groups;
> +}
> +
> +static void shrink_zone(struct zone *zone, struct scan_control *sc)
> +{
> +	if (!__shrink_zone(zone, sc, true)) {
> +		/*
> +		 * First round of reclaim didn't find anything to reclaim
> +		 * because of low limit protection so try again and ignore
> +		 * the low limit this time.
> +		 */
> +		__shrink_zone(zone, sc, false);
> +	}
>  }
>  
>  /* Returns true if compaction should go ahead for a high-order request */

I would actually prefer not having a second round here, and make the
low limit behave more like mlock memory.  If there is no reclaimable
memory, go OOM.
