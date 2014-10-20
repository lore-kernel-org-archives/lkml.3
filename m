Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753076AbaJTTNB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 15:13:01 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:53237 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885AbaJTTM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 15:12:59 -0400
Date: Mon, 20 Oct 2014 21:12:56 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        linux-mm@kvack.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] mm: memcontrol: update mem_cgroup_page_lruvec()
 documentation
Message-ID: <20141020191256.GD505@dhcp22.suse.cz>
References: <1413732616-15962-1-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413732616-15962-1-git-send-email-hannes@cmpxchg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 19-10-14 11:30:16, Johannes Weiner wrote:
> 7512102cf64d ("memcg: fix GPF when cgroup removal races with last
> exit") added a pc->mem_cgroup reset into mem_cgroup_page_lruvec() to
> prevent a crash where an anon page gets uncharged on unmap, the memcg
> is released, and then the final LRU isolation on free dereferences the
> stale pc->mem_cgroup pointer.
> 
> But since 0a31bc97c80c ("mm: memcontrol: rewrite uncharge API"), pages
> are only uncharged AFTER that final LRU isolation, which guarantees
> the memcg's lifetime until then.  pc->mem_cgroup now only needs to be
> reset for swapcache readahead pages.

Do we want VM_BUG_ON_PAGE(!PageSwapCache, page) into the fixup path?

> Update the comment and callsite requirements accordingly.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: Michal Hocko <mhocko@suse.cz>

> ---
>  mm/memcontrol.c | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 3a203c7ec6c7..fc1d7ca96b9d 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1262,9 +1262,13 @@ struct lruvec *mem_cgroup_zone_lruvec(struct zone *zone,
>  }
>  
>  /**
> - * mem_cgroup_page_lruvec - return lruvec for adding an lru page
> + * mem_cgroup_page_lruvec - return lruvec for isolating/putting an LRU page
>   * @page: the page
>   * @zone: zone of the page
> + *
> + * This function is only safe when following the LRU page isolation
> + * and putback protocol: the LRU lock must be held, and the page must
> + * either be PageLRU() or the caller must have isolated/allocated it.
>   */
>  struct lruvec *mem_cgroup_page_lruvec(struct page *page, struct zone *zone)
>  {
> @@ -1282,13 +1286,9 @@ struct lruvec *mem_cgroup_page_lruvec(struct page *page, struct zone *zone)
>  	memcg = pc->mem_cgroup;
>  
>  	/*
> -	 * Surreptitiously switch any uncharged offlist page to root:
> -	 * an uncharged page off lru does nothing to secure
> -	 * its former mem_cgroup from sudden removal.
> -	 *
> -	 * Our caller holds lru_lock, and PageCgroupUsed is updated
> -	 * under page_cgroup lock: between them, they make all uses
> -	 * of pc->mem_cgroup safe.
> +	 * Swapcache readahead pages are added to the LRU - and
> +	 * possibly migrated - before they are charged.  Ensure
> +	 * pc->mem_cgroup is sane.
>  	 */
>  	if (!PageLRU(page) && !PageCgroupUsed(pc) && memcg != root_mem_cgroup)
>  		pc->mem_cgroup = memcg = root_mem_cgroup;
> -- 
> 2.1.2
> 

-- 
Michal Hocko
SUSE Labs
