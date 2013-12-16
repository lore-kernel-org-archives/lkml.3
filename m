Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752140Ab3LPUmW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 15:42:22 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:50193 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751465Ab3LPUmV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 15:42:21 -0500
Date: Mon, 16 Dec 2013 15:42:15 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>, Rik van Riel <riel@redhat.com>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/7] mm: page_alloc: Make zone distribution page aging
 policy configurable
Message-ID: <20131216204215.GA21724@cmpxchg.org>
References: <1386943807-29601-1-git-send-email-mgorman@suse.de>
 <1386943807-29601-6-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386943807-29601-6-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 13, 2013 at 02:10:05PM +0000, Mel Gorman wrote:
> Commit 81c0a2bb ("mm: page_alloc: fair zone allocator policy") solved a
> bug whereby new pages could be reclaimed before old pages because of
> how the page allocator and kswapd interacted on the per-zone LRU lists.
> Unfortunately it was missed during review that a consequence is that
> we also round-robin between NUMA nodes. This is bad for two reasons
> 
> 1. It alters the semantics of MPOL_LOCAL without telling anyone
> 2. It incurs an immediate remote memory performance hit in exchange
>    for a potential performance gain when memory needs to be reclaimed
>    later
> 
> No cookies for the reviewers on this one.
> 
> This patch makes the behaviour of the fair zone allocator policy
> configurable.  By default it will only distribute pages that are going
> to exist on the LRU between zones local to the allocating process. This
> preserves the historical semantics of MPOL_LOCAL.
> 
> By default, slab pages are not distributed between zones after this patch is
> applied. It can be argued that they should get similar treatment but they
> have different lifecycles to LRU pages, the shrinkers are not zone-aware
> and the interaction between the page allocator and kswapd is different
> for slabs. If it turns out to be an almost universal win, we can change
> the default.
> 
> Signed-off-by: Mel Gorman <mgorman@suse.de>
> ---
>  Documentation/sysctl/vm.txt |  32 ++++++++++++++
>  include/linux/mmzone.h      |   2 +
>  include/linux/swap.h        |   2 +
>  kernel/sysctl.c             |   8 ++++
>  mm/page_alloc.c             | 102 ++++++++++++++++++++++++++++++++++++++------
>  5 files changed, 134 insertions(+), 12 deletions(-)
> 
> diff --git a/Documentation/sysctl/vm.txt b/Documentation/sysctl/vm.txt
> index 1fbd4eb..8eaa562 100644
> --- a/Documentation/sysctl/vm.txt
> +++ b/Documentation/sysctl/vm.txt
> @@ -56,6 +56,7 @@ Currently, these files are in /proc/sys/vm:
>  - swappiness
>  - user_reserve_kbytes
>  - vfs_cache_pressure
> +- zone_distribute_mode
>  - zone_reclaim_mode
>  
>  ==============================================================
> @@ -724,6 +725,37 @@ causes the kernel to prefer to reclaim dentries and inodes.
>  
>  ==============================================================
>  
> +zone_distribute_mode
> +
> +Pages allocation and reclaim are managed on a per-zone basis. When the
> +system needs to reclaim memory, candidate pages are selected from these
> +per-zone lists.  Historically, a potential consequence was that recently
> +allocated pages were considered reclaim candidates. From a zone-local
> +perspective, page aging was preserved but from a system-wide perspective
> +there was an age inversion problem.
> +
> +A similar problem occurs on a node level where young pages may be reclaimed
> +from the local node instead of allocating remote memory. Unforuntately, the
> +cost of accessing remote nodes is higher so the system must choose by default
> +between favouring page aging or node locality. zone_distribute_mode controls
> +how the system will distribute page ages between zones.
> +
> +0	= Never round-robin based on age

I think we should be very conservative with the userspace interface we
export on a mechanism we are obviously just figuring out.

> +Otherwise the values are ORed together
> +
> +1	= Distribute anon pages between zones local to the allocating node
> +2	= Distribute file pages between zones local to the allocating node
> +4	= Distribute slab pages between zones local to the allocating node

Zone fairness within a node does not affect mempolicy or remote
reference costs.  Is there a reason to have this configurable?

> +The following three flags effectively alter MPOL_DEFAULT, be careful.
> +
> +8	= Distribute anon pages between zones remote to the allocating node
> +16	= Distribute file pages between zones remote to the allocating node
> +32	= Distribute slab pages between zones remote to the allocating node

Yes, it's conceivable that somebody might want to disable remote
distribution because of the extra references.

But at this point, I'd much rather back out anon and slab distribution
entirely, it was a mistake to include them.

That would leave us with a single knob to disable remote page cache
placement.
