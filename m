Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756084AbaDHBSq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 21:18:46 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:21027 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754690AbaDHBSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 21:18:44 -0400
X-IronPort-AV: E=Sophos;i="4.97,814,1389715200"; 
   d="scan'208";a="28974175"
Message-ID: <53434E28.4040304@cn.fujitsu.com>
Date: Tue, 8 Apr 2014 09:17:28 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131030 Thunderbird/17.0.10
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Robert Haas <robertmhaas@gmail.com>, Josh Berkus <josh@agliodbs.com>,
        Andres Freund <andres@2ndquadrant.com>,
        Christoph Lameter <cl@linux.com>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] mm: Disable zone_reclaim_mode by default
References: <1396910068-11637-1-git-send-email-mgorman@suse.de> <1396910068-11637-2-git-send-email-mgorman@suse.de>
In-Reply-To: <1396910068-11637-2-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.197]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2014 06:34 AM, Mel Gorman wrote:
> zone_reclaim_mode causes processes to prefer reclaiming memory from local
> node instead of spilling over to other nodes. This made sense initially when
> NUMA machines were almost exclusively HPC and the workload was partitioned
> into nodes. The NUMA penalties were sufficiently high to justify reclaiming
> the memory. On current machines and workloads it is often the case that
> zone_reclaim_mode destroys performance but not all users know how to detect
> this. Favour the common case and disable it by default. Users that are
> sophisticated enough to know they need zone_reclaim_mode will detect it.
> 
> Signed-off-by: Mel Gorman <mgorman@suse.de>

Reviewed-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>

> ---
>  Documentation/sysctl/vm.txt | 17 +++++++++--------
>  mm/page_alloc.c             |  2 --
>  2 files changed, 9 insertions(+), 10 deletions(-)
> 
> diff --git a/Documentation/sysctl/vm.txt b/Documentation/sysctl/vm.txt
> index d614a9b..ff5da70 100644
> --- a/Documentation/sysctl/vm.txt
> +++ b/Documentation/sysctl/vm.txt
> @@ -751,16 +751,17 @@ This is value ORed together of
>  2	= Zone reclaim writes dirty pages out
>  4	= Zone reclaim swaps pages
>  
> -zone_reclaim_mode is set during bootup to 1 if it is determined that pages
> -from remote zones will cause a measurable performance reduction. The
> -page allocator will then reclaim easily reusable pages (those page
> -cache pages that are currently not used) before allocating off node pages.
> -
> -It may be beneficial to switch off zone reclaim if the system is
> -used for a file server and all of memory should be used for caching files
> -from disk. In that case the caching effect is more important than
> +zone_reclaim_mode is disabled by default.  For file servers or workloads
> +that benefit from having their data cached, zone_reclaim_mode should be
> +left disabled as the caching effect is likely to be more important than
>  data locality.
>  
> +zone_reclaim may be enabled if it's known that the workload is partitioned
> +such that each partition fits within a NUMA node and that accessing remote
> +memory would cause a measurable performance reduction.  The page allocator
> +will then reclaim easily reusable pages (those page cache pages that are
> +currently not used) before allocating off node pages.
> +
>  Allowing zone reclaim to write out pages stops processes that are
>  writing large amounts of data from dirtying pages on other nodes. Zone
>  reclaim will write out dirty pages if a zone fills up and so effectively
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 3bac76a..a256f85 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1873,8 +1873,6 @@ static void __paginginit init_zone_allows_reclaim(int nid)
>  	for_each_online_node(i)
>  		if (node_distance(nid, i) <= RECLAIM_DISTANCE)
>  			node_set(i, NODE_DATA(nid)->reclaim_nodes);
> -		else
> -			zone_reclaim_mode = 1;
>  }
>  
>  #else	/* CONFIG_NUMA */
> 


-- 
Thanks.
Zhang Yanfei
