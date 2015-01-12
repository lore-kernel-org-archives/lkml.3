Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753005AbbALLOs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 06:14:48 -0500
Received: from mx2.parallels.com ([199.115.105.18]:54558 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049AbbALLOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 06:14:46 -0500
Date: Mon, 12 Jan 2015 14:14:40 +0300
From: Vladimir Davydov <vdavydov@parallels.com>
To: Johannes Weiner <hannes@cmpxchg.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        <linux-mm@kvack.org>, <cgroups@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [patch 2/3] mm: memcontrol: consolidate memory controller
 initialization
Message-ID: <20150112111440.GC384@esperanza>
References: <1420856041-27647-1-git-send-email-hannes@cmpxchg.org>
 <1420856041-27647-2-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1420856041-27647-2-git-send-email-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 09, 2015 at 09:14:00PM -0500, Johannes Weiner wrote:
> The initialization code for the per-cpu charge stock and the soft
> limit tree is compact enough to inline it into mem_cgroup_init().
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> ---
>  mm/memcontrol.c | 57 ++++++++++++++++++++++++---------------------------------
>  1 file changed, 24 insertions(+), 33 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index aad254b30708..f66bb8f83ac9 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
[...]
> @@ -5927,10 +5896,32 @@ void mem_cgroup_migrate(struct page *oldpage, struct page *newpage,
>   */
>  static int __init mem_cgroup_init(void)
>  {
> +	int cpu, nid;
> +
>  	hotcpu_notifier(memcg_cpu_hotplug_callback, 0);
> +
> +	for_each_possible_cpu(cpu)
> +		INIT_WORK(&per_cpu_ptr(&memcg_stock, cpu)->work,
> +			  drain_local_stock);
> +
> +	for_each_node(nid) {
> +		struct mem_cgroup_tree_per_node *rtpn;
> +		int zone;
> +
> +		rtpn = kzalloc_node(sizeof(*rtpn), GFP_KERNEL, nid);

I'd like to see BUG_ON(!rtpn) here, just for clarity. Not critical
though.

Reviewed-by: Vladimir Davydov <vdavydov@parallels.com>

> +
> +		for (zone = 0; zone < MAX_NR_ZONES; zone++) {
> +			struct mem_cgroup_tree_per_zone *rtpz;
> +
> +			rtpz = &rtpn->rb_tree_per_zone[zone];
> +			rtpz->rb_root = RB_ROOT;
> +			spin_lock_init(&rtpz->lock);
> +		}
> +		soft_limit_tree.rb_tree_per_node[nid] = rtpn;
> +	}
> +
>  	enable_swap_cgroup();
> -	mem_cgroup_soft_limit_tree_init();
> -	memcg_stock_init();
> +
>  	return 0;
>  }
>  subsys_initcall(mem_cgroup_init);
> -- 
> 2.2.0
> 
