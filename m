Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565AbaGOPSa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 11:18:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55231 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750990AbaGOPSV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 11:18:21 -0400
Date: Tue, 15 Jul 2014 17:18:18 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        Tejun Heo <tj@kernel.org>, Vladimir Davydov <vdavydov@parallels.com>,
        linux-mm@kvack.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 13/13] mm: memcontrol: rewrite uncharge API
Message-ID: <20140715151818.GE9366@dhcp22.suse.cz>
References: <1403124045-24361-1-git-send-email-hannes@cmpxchg.org>
 <1403124045-24361-14-git-send-email-hannes@cmpxchg.org>
 <20140715082545.GA9366@dhcp22.suse.cz>
 <20140715142350.GD9366@dhcp22.suse.cz>
 <20140715150937.GS29639@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140715150937.GS29639@cmpxchg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 15-07-14 11:09:37, Johannes Weiner wrote:
> On Tue, Jul 15, 2014 at 04:23:50PM +0200, Michal Hocko wrote:
> > On Tue 15-07-14 10:25:45, Michal Hocko wrote:
[...]
> > > @@ -2760,15 +2752,15 @@ static void commit_charge(struct page *page, struct mem_cgroup *memcg,
> > >  		spin_unlock_irq(&zone->lru_lock);
> > >  	}
> > >  
> > > -	mem_cgroup_charge_statistics(memcg, page, anon, nr_pages);
> > > -	unlock_page_cgroup(pc);
> > > -
> > > +	local_irq_disable();
> > > +	mem_cgroup_charge_statistics(memcg, page, nr_pages);
> > >  	/*
> > >  	 * "charge_statistics" updated event counter. Then, check it.
> > >  	 * Insert ancestor (and ancestor's ancestors), to softlimit RB-tree.
> > >  	 * if they exceeds softlimit.
> > >  	 */
> > >  	memcg_check_events(memcg, page);
> > > +	local_irq_enable();
> > 
> > preempt_{enable,disbale} should be sufficient for
> > mem_cgroup_charge_statistics and memcg_check_events no?
> > The first one is about per-cpu accounting (and that should be atomic
> > wrt. IRQ on the same CPU) and the later one uses IRQ safe locks down in
> > mem_cgroup_update_tree.
> 
> How could it be atomic wrt. IRQ on the local CPU when IRQs that modify
> the counters can fire on the local CPU?

I meant that __this_atomic_add and __this_cpu_inc should be atomic wrt. IRQ.
We do not care that an IRQ might jump in between two per-cpu operations.
This is racy from other CPUs anyway.

> 
> > > @@ -780,11 +780,14 @@ static int move_to_new_page(struct page *newpage, struct page *page,
> > >  		rc = fallback_migrate_page(mapping, newpage, page, mode);
> > >  
> > >  	if (rc != MIGRATEPAGE_SUCCESS) {
> > > -		newpage->mapping = NULL;
> > > +		if (!PageAnon(newpage))
> > > +			newpage->mapping = NULL;
> > 
> > OK, I am probably washed out from looking into this for too long but I
> > cannot figure why have you done this...
> 
> mem_cgroup_uncharge() relies on PageAnon() working.  Usually, anon
> pages retain their page->mapping until they hit the page allocator,
> the exception was old migration pages.

OK, got it now. I was suprised by a change in !memcg path. Maybe this is
worth a comment?

-- 
Michal Hocko
SUSE Labs
