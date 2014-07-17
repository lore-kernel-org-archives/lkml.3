Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757130AbaGQOa1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 10:30:27 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:48922 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756821AbaGQOa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 10:30:26 -0400
Date: Thu, 17 Jul 2014 16:30:21 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Hugh Dickins <hughd@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] mm: memcontrol: rewrite charge API fix - hugetlb charging
Message-ID: <20140717143021.GE8011@dhcp22.suse.cz>
References: <1405528080-2975-1-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405528080-2975-1-git-send-email-hannes@cmpxchg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 16-07-14 12:28:00, Johannes Weiner wrote:
> Naoya-san reports that hugetlb pages now get charged as file cache,
> which wreaks all kinds of havoc during migration, uncharge etc.
> 
> The file-specific charge path used to filter PageCompound(), but it
> wasn't commented and so it got lost when unifying the charge paths.
> 
> We can't add PageCompound() back into a unified charge path because of
> THP, so filter huge pages directly in add_to_page_cache().

This looks a bit fragile to me but I understand your motivation to not
punish all the code paths with PageHuge check.

> Reported-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: Michal Hocko <mhocko@suse.cz>

> ---
>  mm/filemap.c | 20 ++++++++++++++------
>  1 file changed, 14 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 114cd89c1cc2..c088ac01e856 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -31,6 +31,7 @@
>  #include <linux/security.h>
>  #include <linux/cpuset.h>
>  #include <linux/hardirq.h> /* for BUG_ON(!in_atomic()) only */
> +#include <linux/hugetlb.h>
>  #include <linux/memcontrol.h>
>  #include <linux/cleancache.h>
>  #include <linux/rmap.h>
> @@ -560,19 +561,24 @@ static int __add_to_page_cache_locked(struct page *page,
>  				      pgoff_t offset, gfp_t gfp_mask,
>  				      void **shadowp)
>  {
> +	int huge = PageHuge(page);
>  	struct mem_cgroup *memcg;
>  	int error;
>  
>  	VM_BUG_ON_PAGE(!PageLocked(page), page);
>  	VM_BUG_ON_PAGE(PageSwapBacked(page), page);
>  
> -	error = mem_cgroup_try_charge(page, current->mm, gfp_mask, &memcg);
> -	if (error)
> -		return error;
> +	if (!huge) {
> +		error = mem_cgroup_try_charge(page, current->mm,
> +					      gfp_mask, &memcg);
> +		if (error)
> +			return error;
> +	}
>  
>  	error = radix_tree_maybe_preload(gfp_mask & ~__GFP_HIGHMEM);
>  	if (error) {
> -		mem_cgroup_cancel_charge(page, memcg);
> +		if (!huge)
> +			mem_cgroup_cancel_charge(page, memcg);
>  		return error;
>  	}
>  
> @@ -587,14 +593,16 @@ static int __add_to_page_cache_locked(struct page *page,
>  		goto err_insert;
>  	__inc_zone_page_state(page, NR_FILE_PAGES);
>  	spin_unlock_irq(&mapping->tree_lock);
> -	mem_cgroup_commit_charge(page, memcg, false);
> +	if (!huge)
> +		mem_cgroup_commit_charge(page, memcg, false);
>  	trace_mm_filemap_add_to_page_cache(page);
>  	return 0;
>  err_insert:
>  	page->mapping = NULL;
>  	/* Leave page->index set: truncation relies upon it */
>  	spin_unlock_irq(&mapping->tree_lock);
> -	mem_cgroup_cancel_charge(page, memcg);
> +	if (!huge)
> +		mem_cgroup_cancel_charge(page, memcg);
>  	page_cache_release(page);
>  	return error;
>  }
> -- 
> 2.0.0
> 

-- 
Michal Hocko
SUSE Labs
