Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757050AbaGNT7a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 15:59:30 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:33988 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756997AbaGNT70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 15:59:26 -0400
Date: Mon, 14 Jul 2014 12:57:33 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Johannes Weiner <hannes@cmpxchg.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 2/3] mm: memcontrol: rewrite uncharge API fix - double
 migration
In-Reply-To: <1404759133-29218-3-git-send-email-hannes@cmpxchg.org>
Message-ID: <alpine.LSU.2.11.1407141246340.17669@eggly.anvils>
References: <1404759133-29218-1-git-send-email-hannes@cmpxchg.org> <1404759133-29218-3-git-send-email-hannes@cmpxchg.org>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Jul 2014, Johannes Weiner wrote:

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
> Catch pages that have already been migrated and abort migration
> gracefully.
> 
> Reported-by: Hugh Dickins <hughd@google.com>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> ---
>  mm/memcontrol.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 1e3b27f8dc2f..e4afdbdda0a7 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -6653,7 +6653,10 @@ void mem_cgroup_migrate(struct page *oldpage, struct page *newpage,
>  	if (!PageCgroupUsed(pc))
>  		return;
>  
> -	VM_BUG_ON_PAGE(!(pc->flags & PCG_MEM), oldpage);
> +	/* Already migrated */
> +	if (!(pc->flags & PCG_MEM))
> +		return;
> +

I am curious why you chose to fix the BUG in this way, instead of
-	pc->flags &= ~(PCG_MEM | PCG_MEMSW);
+	pc->flags = 0;
a few lines further down.

The page that gets left behind with just PCG_USED is anomalous (for an
LRU page, maybe not for a kmem page), isn'it it?  And liable to cause
other problems.

For example, won't it go the wrong way in the "Surreptitiously" test
in mem_cgroup_page_lruvec(): the page no longer has a hold on any
memcg, so is in a danger of being placed on a gone-memcg's LRU?

Hugh

>  	VM_BUG_ON_PAGE(do_swap_account && !(pc->flags & PCG_MEMSW), oldpage);
>  	pc->flags &= ~(PCG_MEM | PCG_MEMSW);
>  
> -- 
> 2.0.0
