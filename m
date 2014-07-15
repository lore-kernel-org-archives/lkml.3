Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758850AbaGOMTl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 08:19:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52146 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758376AbaGOMTj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 08:19:39 -0400
Date: Tue, 15 Jul 2014 14:19:35 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        Tejun Heo <tj@kernel.org>, Vladimir Davydov <vdavydov@parallels.com>,
        linux-mm@kvack.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 13/13] mm: memcontrol: rewrite uncharge API
Message-ID: <20140715121935.GB9366@dhcp22.suse.cz>
References: <1403124045-24361-1-git-send-email-hannes@cmpxchg.org>
 <1403124045-24361-14-git-send-email-hannes@cmpxchg.org>
 <20140715082545.GA9366@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140715082545.GA9366@dhcp22.suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[...]
> +/**
> + * mem_cgroup_migrate - migrate a charge to another page
> + * @oldpage: currently charged page
> + * @newpage: page to transfer the charge to
> + * @lrucare: page might be on LRU already

which one? I guess the newpage?

> + *
> + * Migrate the charge from @oldpage to @newpage.
> + *
> + * Both pages must be locked, @newpage->mapping must be set up.
> + */
> +void mem_cgroup_migrate(struct page *oldpage, struct page *newpage,
> +			bool lrucare)
> +{
> +	unsigned int nr_pages = 1;
> +	struct page_cgroup *pc;
> +
> +	VM_BUG_ON_PAGE(!PageLocked(oldpage), oldpage);
> +	VM_BUG_ON_PAGE(!PageLocked(newpage), newpage);
> +	VM_BUG_ON_PAGE(PageLRU(oldpage), oldpage);
> +	VM_BUG_ON_PAGE(PageLRU(newpage), newpage);

	VM_BUG_ON_PAGE(PageLRU(newpage) && !lruvec, newpage);

> +	VM_BUG_ON_PAGE(PageAnon(oldpage) != PageAnon(newpage), newpage);
> +
> +	if (mem_cgroup_disabled())
> +		return;
> +
> +	pc = lookup_page_cgroup(oldpage);
> +	if (!PageCgroupUsed(pc))
> +		return;
> +
> +	/* Already migrated */
> +	if (!(pc->flags & PCG_MEM))
> +		return;
> +
> +	VM_BUG_ON_PAGE(do_swap_account && !(pc->flags & PCG_MEMSW), oldpage);
> +	pc->flags &= ~(PCG_MEM | PCG_MEMSW);

What about PCG_USED?
Wouldn't we uncharge the currently transfered charge when oldpage does
its last put_page when the migration is done?

On a not directly related note. I was quite surprised to see that
__unmap_and_move calls putback_lru_page on oldpage even when migration
succeeded. So it goes through mem_cgroup_page_lruvec which checks
PCG_USED and resets pc->mem_cgroup to root for !PCG_USED.

> +
> +	if (PageTransHuge(oldpage)) {
> +		nr_pages <<= compound_order(oldpage);
> +		VM_BUG_ON_PAGE(!PageTransHuge(oldpage), oldpage);
> +		VM_BUG_ON_PAGE(!PageTransHuge(newpage), newpage);
> +	}
> +
> +	commit_charge(newpage, pc->mem_cgroup, nr_pages, lrucare);
> +}
-- 
Michal Hocko
SUSE Labs
