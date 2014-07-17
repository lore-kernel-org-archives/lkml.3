Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933901AbaGQP3m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 11:29:42 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:41837 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933145AbaGQP3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 11:29:41 -0400
Date: Thu, 17 Jul 2014 17:29:36 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] mm: memcontrol: use page lists for uncharge batching
Message-ID: <20140717152936.GF8011@dhcp22.suse.cz>
References: <1404759358-29331-1-git-send-email-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404759358-29331-1-git-send-email-hannes@cmpxchg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 07-07-14 14:55:58, Johannes Weiner wrote:
> Pages are now uncharged at release time, and all sources of batched
> uncharges operate on lists of pages.  Directly use those lists, and
> get rid of the per-task batching state.
> 
> This also batches statistics accounting, in addition to the res
> counter charges, to reduce IRQ-disabling and re-enabling.

It is probably worth noticing that there is a higher chance of missing
threshold events now when we can accumulate huge number of uncharges
during munmaps. I do not think this is earth shattering and the overall
improvement is worth it but changelog should mention it.

> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

With the follow up fix from
http://marc.info/?l=linux-mm&m=140552814228135&w=2

Acked-by: Michal Hocko <mhocko@suse.cz>

one nit below.

[...]
> +static void uncharge_list(struct list_head *page_list)
> +{
> +	struct mem_cgroup *memcg = NULL;
> +	unsigned long nr_memsw = 0;
> +	unsigned long nr_anon = 0;
> +	unsigned long nr_file = 0;
> +	unsigned long nr_huge = 0;
> +	unsigned long pgpgout = 0;
> +	unsigned long nr_mem = 0;
> +	struct list_head *next;
> +	struct page *page;
> +
> +	next = page_list->next;
> +	do {

I would use list_for_each_entry here which would also save list_empty
check in mem_cgroup_uncharge_list

> +		unsigned int nr_pages = 1;
> +		struct page_cgroup *pc;
> +
> +		page = list_entry(next, struct page, lru);
> +		next = page->lru.next;
> +
> +		VM_BUG_ON_PAGE(PageLRU(page), page);
> +		VM_BUG_ON_PAGE(page_count(page), page);
> +
> +		pc = lookup_page_cgroup(page);
> +		if (!PageCgroupUsed(pc))
> +			continue;
> +
> +		/*
> +		 * Nobody should be changing or seriously looking at
> +		 * pc->mem_cgroup and pc->flags at this point, we have
> +		 * fully exclusive access to the page.
> +		 */
> +
> +		if (memcg != pc->mem_cgroup) {
> +			if (memcg) {
> +				uncharge_batch(memcg, pgpgout, nr_mem, nr_memsw,
> +					       nr_anon, nr_file, nr_huge, page);
> +				pgpgout = nr_mem = nr_memsw = 0;
> +				nr_anon = nr_file = nr_huge = 0;
> +			}
> +			memcg = pc->mem_cgroup;
> +		}
> +
> +		if (PageTransHuge(page)) {
> +			nr_pages <<= compound_order(page);
> +			VM_BUG_ON_PAGE(!PageTransHuge(page), page);
> +			nr_huge += nr_pages;
> +		}
> +
> +		if (PageAnon(page))
> +			nr_anon += nr_pages;
> +		else
> +			nr_file += nr_pages;
> +
> +		if (pc->flags & PCG_MEM)
> +			nr_mem += nr_pages;
> +		if (pc->flags & PCG_MEMSW)
> +			nr_memsw += nr_pages;
> +		pc->flags = 0;
> +
> +		pgpgout++;
> +	} while (next != page_list);
> +
> +	if (memcg)
> +		uncharge_batch(memcg, pgpgout, nr_mem, nr_memsw,
> +			       nr_anon, nr_file, nr_huge, page);
> +}
-- 
Michal Hocko
SUSE Labs
