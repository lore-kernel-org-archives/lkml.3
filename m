Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933194AbaGQOUJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 10:20:09 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:65182 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755186AbaGQOUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 10:20:06 -0400
Date: Thu, 17 Jul 2014 16:20:03 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [patch v2] mm: memcontrol: rewrite uncharge API fix - double
 migration
Message-ID: <20140717142003.GD8011@dhcp22.suse.cz>
References: <1405527596-7267-1-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405527596-7267-1-git-send-email-hannes@cmpxchg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 16-07-14 12:19:56, Johannes Weiner wrote:
> Hugh reports:
> 
> VM_BUG_ON_PAGE(!(pc->flags & PCG_MEM))
> mm/memcontrol.c:6680!
> page had count 1 mapcount 0 mapping anon index 0x196
> flags locked uptodate reclaim swapbacked, pcflags 1, memcg not root
> mem_cgroup_migrate < move_to_new_page < migrate_pages < compact_zone <
> compact_zone_order < try_to_compact_pages < __alloc_pages_direct_compact <
> __alloc_pages_nodemask < alloc_pages_vma < do_huge_pmd_anonymous_page <
> handle_mm_fault < __do_page_fault
> 
> mem_cgroup_migrate() assumes that a page is only migrated once and
> then freed immediately after.
> 
> However, putting the page back on the LRU list and dropping the
> isolation refcount is not done atomically.  This allows a PFN-based
> migrator like compaction to isolate the page, see the expected
> anonymous page refcount of 1, and migrate the page once more.
> 
> Properly uncharge the page after it's been migrated, including the
> clearing of PCG_USED, so that a subsequent charge migration attempt
> will be able to detect it and bail out.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> Reported-by: Hugh Dickins <hughd@google.com>

Acked-by: Michal Hocko <mhocko@suse.cz>

> ---
>  mm/memcontrol.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> Andrew, this replaces the patch of the same name in -mm.  As Hugh
> points out, we really have to clear PCG_USED of migrated pages, as
> they are no longer pinning the memcg and so their pc->mem_cgroup can
> no longer be trusted.
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 1e3b27f8dc2f..1439537fe7c9 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -6655,7 +6655,6 @@ void mem_cgroup_migrate(struct page *oldpage, struct page *newpage,
>  
>  	VM_BUG_ON_PAGE(!(pc->flags & PCG_MEM), oldpage);
>  	VM_BUG_ON_PAGE(do_swap_account && !(pc->flags & PCG_MEMSW), oldpage);
> -	pc->flags &= ~(PCG_MEM | PCG_MEMSW);
>  
>  	if (PageTransHuge(oldpage)) {
>  		nr_pages <<= compound_order(oldpage);
> @@ -6663,6 +6662,13 @@ void mem_cgroup_migrate(struct page *oldpage, struct page *newpage,
>  		VM_BUG_ON_PAGE(!PageTransHuge(newpage), newpage);
>  	}
>  
> +	pc->flags = 0;
> +
> +	local_irq_disable();
> +	mem_cgroup_charge_statistics(pc->mem_cgroup, oldpage, -nr_pages);
> +	memcg_check_events(pc->mem_cgroup, oldpage);
> +	local_irq_enable();
> +
>  	commit_charge(newpage, pc->mem_cgroup, nr_pages, lrucare);
>  }
>  
> -- 
> 2.0.0
> 

-- 
Michal Hocko
SUSE Labs
