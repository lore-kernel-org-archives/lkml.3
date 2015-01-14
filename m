Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751896AbbANLQg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 06:16:36 -0500
Received: from service87.mimecast.com ([91.220.42.44]:50593 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139AbbANLQe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 06:16:34 -0500
Message-ID: <54B6500D.6080206@arm.com>
Date: Wed, 14 Jan 2015 11:16:29 +0000
From: "Suzuki K. Poulose" <Suzuki.Poulose@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>
CC: Vladimir Davydov <vdavydov@parallels.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>
Subject: Re: [PATCH cgroup/for-3.19-fixes] cgroup: implement cgroup_subsys->unbind()
 callback
References: <54B01335.4060901@arm.com> <20150110085525.GD2110@esperanza> <20150110214316.GF25319@htj.dyndns.org> <20150111205543.GA5480@phnom.home.cmpxchg.org>
In-Reply-To: <20150111205543.GA5480@phnom.home.cmpxchg.org>
X-OriginalArrivalTime: 14 Jan 2015 11:16:30.0089 (UTC) FILETIME=[8BAC4F90:01D02FEB]
X-MC-Unique: 115011411163207401
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/01/15 20:55, Johannes Weiner wrote:
> On Sat, Jan 10, 2015 at 04:43:16PM -0500, Tejun Heo wrote:
>> Currently, if a hierarchy doesn't have any live children when it's
>> unmounted, the hierarchy starts dying by killing its refcnt.  The
>> expectation is that even if there are lingering dead children which
>> are lingering due to remaining references, they'll be put in a finite
>> amount of time.  When the children are finally released, the hierarchy
>> is destroyed and all controllers bound to it also are released.
>>
>> However, for memcg, the premise that the lingering refs will be put in
>> a finite amount time is not true.  In the absense of memory pressure,
>> dead memcg's may hang around indefinitely pinned by its pages.  This
>> unfortunately may lead to indefinite hang on the next mount attempt
>> involving memcg as the mount logic waits for it to get released.
>>
>> While we can change hierarchy destruction logic such that a hierarchy
>> is only destroyed when it's not mounted anywhere and all its children,
>> live or dead, are gone, this makes whether the hierarchy gets
>> destroyed or not to be determined by factors opaque to userland.
>> Userland may or may not get a new hierarchy on the next mount attempt.
>> Worse, if it explicitly wants to create a new hierarchy with different
>> options or controller compositions involving memcg, it will fail in an
>> essentially arbitrary manner.
>>
>> We want to guarantee that a hierarchy is destroyed once the
>> conditions, unmounted and no visible children, are met.  To aid it,
>> this patch introduces a new callback cgroup_subsys->unbind() which is
>> invoked right before the hierarchy a subsystem is bound to starts
>> dying.  memcg can implement this callback and initiate draining of
>> remaining refs so that the hierarchy can eventually be released in a
>> finite amount of time.
>>
>> Signed-off-by: Tejun Heo <tj@kernel.org>
>> Cc: Li Zefan <lizefan@huawei.com>
>> Cc: Johannes Weiner <hannes@cmpxchg.org>
>> Cc: Michal Hocko <mhocko@suse.cz>
>> Cc: Vladimir Davydov <vdavydov@parallels.com>
>> ---
>> Hello,
>>
>>> May be, we should kill the ref counter to the memory controller root in
>>> cgroup_kill_sb only if there is no children at all, neither online nor
>>> offline.
>>
>> Ah, thanks for the analysis, but I really wanna avoid making hierarchy
>> destruction conditions opaque to userland.  This is userland visible
>> behavior.  It shouldn't be determined by kernel internals invisible
>> outside.  This patch adds ss->unbind() which memcg can hook into to
>> kick off draining of residual refs.  If this would work, I'll add this
>> patch to cgroup/for-3.19-fixes, possibly with stable cc'd.
>
> How about this ->unbind() for memcg?
>
>  From d527ba1dbfdb58e1f7c7c4ee12b32ef2e5461990 Mon Sep 17 00:00:00 2001
> From: Johannes Weiner <hannes@cmpxchg.org>
> Date: Sun, 11 Jan 2015 10:29:05 -0500
> Subject: [patch] mm: memcontrol: zap outstanding cache/swap references during
>   unbind
>
This patch doesn't cleanly apply on 3.19-rc4 for me (hunks in 
mm/memcontrol.c). I have manually applied it.

With these two patches in, I am still getting the failure. Also, the 
kworker thread is taking up 100% time (unbind_work) and continues to do 
so even after 6minutes.

Is there something I missed ?

Thanks
Suzuki




> Cgroup core assumes that any outstanding css references after
> offlining are temporary in nature, and e.g. mount waits for them to
> disappear and release the root cgroup.  But leftover page cache and
> swapout records in an offlined memcg are only dropped when the pages
> get reclaimed under pressure or the swapped out pages get faulted in
> from other cgroups, and so those cgroup operations can hang forever.
>
> Implement the ->unbind() callback to actively get rid of outstanding
> references when cgroup core wants them gone.  Swap out records are
> deleted, such that the swap-in path will charge those pages to the
> faulting task.  Page cache pages are moved to the root memory cgroup.
>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> ---
>   include/linux/swap_cgroup.h |   6 +++
>   mm/memcontrol.c             | 126 ++++++++++++++++++++++++++++++++++++++++++++
>   mm/swap_cgroup.c            |  38 +++++++++++++
>   3 files changed, 170 insertions(+)
>
> diff --git a/include/linux/swap_cgroup.h b/include/linux/swap_cgroup.h
> index 145306bdc92f..ffe0866d2997 100644
> --- a/include/linux/swap_cgroup.h
> +++ b/include/linux/swap_cgroup.h
> @@ -9,6 +9,7 @@ extern unsigned short swap_cgroup_cmpxchg(swp_entry_t ent,
>   					unsigned short old, unsigned short new);
>   extern unsigned short swap_cgroup_record(swp_entry_t ent, unsigned short id);
>   extern unsigned short lookup_swap_cgroup_id(swp_entry_t ent);
> +extern unsigned long swap_cgroup_zap_records(unsigned short id);
>   extern int swap_cgroup_swapon(int type, unsigned long max_pages);
>   extern void swap_cgroup_swapoff(int type);
>
> @@ -26,6 +27,11 @@ unsigned short lookup_swap_cgroup_id(swp_entry_t ent)
>   	return 0;
>   }
>
> +static inline unsigned long swap_cgroup_zap_records(unsigned short id)
> +{
> +	return 0;
> +}
> +
>   static inline int
>   swap_cgroup_swapon(int type, unsigned long max_pages)
>   {
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 692e96407627..40c426add613 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -5197,6 +5197,131 @@ static void mem_cgroup_bind(struct cgroup_subsys_state *root_css)
>   		mem_cgroup_from_css(root_css)->use_hierarchy = true;
>   }
>
> +static void unbind_lru_list(struct mem_cgroup *memcg,
> +			    struct zone *zone, enum lru_list lru)
> +{
> +	struct lruvec *lruvec = mem_cgroup_zone_lruvec(zone, memcg);
> +	struct list_head *list = &lruvec->lists[lru];
> +
> +	while (!list_empty(list)) {
> +		unsigned int nr_pages;
> +		unsigned long flags;
> +		struct page *page;
> +
> +		spin_lock_irqsave(&zone->lru_lock, flags);
> +		if (list_empty(list)) {
> +			spin_unlock_irqrestore(&zone->lru_lock, flags);
> +			break;
> +		}
> +		page = list_last_entry(list, struct page, lru);
> +		if (!get_page_unless_zero(page)) {
> +			list_move(&page->lru, list);
> +			spin_unlock_irqrestore(&zone->lru_lock, flags);
> +			continue;
> +		}
> +		BUG_ON(!PageLRU(page));
> +		ClearPageLRU(page);
> +		del_page_from_lru_list(page, lruvec, lru);
> +		spin_unlock_irqrestore(&zone->lru_lock, flags);
> +
> +		compound_lock(page);
> +		nr_pages = hpage_nr_pages(page);
> +
> +		if (!mem_cgroup_move_account(page, nr_pages,
> +					     memcg, root_mem_cgroup)) {
> +			/*
> +			 * root_mem_cgroup page counters are not used,
> +			 * otherwise we'd have to charge them here.
> +			 */
> +			page_counter_uncharge(&memcg->memory, nr_pages);
> +			if (do_swap_account)
> +				page_counter_uncharge(&memcg->memsw, nr_pages);
> +			css_put_many(&memcg->css, nr_pages);
> +		}
> +
> +		compound_unlock(page);
> +
> +		putback_lru_page(page);
> +	}
> +}
> +
> +static void unbind_work_fn(struct work_struct *work)
> +{
> +	struct cgroup_subsys_state *css;
> +retry:
> +	drain_all_stock(root_mem_cgroup);
> +
> +	rcu_read_lock();
> +	css_for_each_child(css, &root_mem_cgroup->css) {
> +		struct mem_cgroup *memcg = mem_cgroup_from_css(css);
> +
> +		/* Drop references from swap-out records */
> +		if (do_swap_account) {
> +			long zapped;
> +
> +			zapped = swap_cgroup_zap_records(memcg->css.id);
> +			page_counter_uncharge(&memcg->memsw, zapped);
> +			css_put_many(&memcg->css, zapped);
> +		}
> +
> +		/* Drop references from leftover LRU pages */
> +		css_get(css);
> +		rcu_read_unlock();
> +		atomic_inc(&memcg->moving_account);
> +		synchronize_rcu();
> +		while (page_counter_read(&memcg->memory) -
> +		       page_counter_read(&memcg->kmem) > 0) {
> +			struct zone *zone;
> +			enum lru_list lru;
> +
> +			lru_add_drain_all();
> +
> +			for_each_zone(zone)
> +				for_each_lru(lru)
> +					unbind_lru_list(memcg, zone, lru);
> +
> +			cond_resched();
> +		}
> +		atomic_dec(&memcg->moving_account);
> +		rcu_read_lock();
> +		css_put(css);
> +	}
> +	rcu_read_unlock();
> +	/*
> +	 * Swap-in is racy:
> +	 *
> +	 * #0                        #1
> +	 *                           lookup_swap_cgroup_id()
> +	 *                           rcu_read_lock()
> +	 *                           mem_cgroup_lookup()
> +	 *                           css_tryget_online()
> +	 *                           rcu_read_unlock()
> +	 * cgroup_kill_sb()
> +	 *   !css_has_online_children()
> +	 *     ->unbind()
> +	 *                           page_counter_try_charge()
> +	 *                           css_put()
> +	 *                             css_free()
> +	 *                           pc->mem_cgroup = dead memcg
> +	 *                           add page to lru
> +	 *
> +	 * Loop until until all references established from previously
> +	 * existing swap-out records have been transferred to pages on
> +	 * the LRU and then uncharged from there.
> +	 */
> +	if (!list_empty(&root_mem_cgroup->css.children)) {
> +		msleep(10);
> +		goto retry;
> +	}
> +}
> +
> +static DECLARE_WORK(unbind_work, unbind_work_fn);
> +
> +static void mem_cgroup_unbind(struct cgroup_subsys_state *root_css)
> +{
> +	schedule_work(&unbind_work);
> +}
> +
>   static u64 memory_current_read(struct cgroup_subsys_state *css,
>   			       struct cftype *cft)
>   {
> @@ -5360,6 +5485,7 @@ struct cgroup_subsys memory_cgrp_subsys = {
>   	.cancel_attach = mem_cgroup_cancel_attach,
>   	.attach = mem_cgroup_move_task,
>   	.bind = mem_cgroup_bind,
> +	.unbind = mem_cgroup_unbind,
>   	.dfl_cftypes = memory_files,
>   	.legacy_cftypes = mem_cgroup_legacy_files,
>   	.early_init = 0,
> diff --git a/mm/swap_cgroup.c b/mm/swap_cgroup.c
> index b5f7f24b8dd1..665923a558c4 100644
> --- a/mm/swap_cgroup.c
> +++ b/mm/swap_cgroup.c
> @@ -140,6 +140,44 @@ unsigned short lookup_swap_cgroup_id(swp_entry_t ent)
>   	return lookup_swap_cgroup(ent, NULL)->id;
>   }
>
> +/**
> + * swap_cgroup_zap_records - delete all swapout records of one cgroup
> + * @id: memcg id
> + *
> + * Returns the number of deleted records.
> + */
> +unsigned long swap_cgroup_zap_records(unsigned short id)
> +{
> +	unsigned long zapped = 0;
> +	unsigned int type;
> +
> +	for (type = 0; type < MAX_SWAPFILES; type++) {
> +		struct swap_cgroup_ctrl *ctrl;
> +		unsigned long flags;
> +		unsigned int page;
> +
> +		ctrl = &swap_cgroup_ctrl[type];
> +		spin_lock_irqsave(&ctrl->lock, flags);
> +		for (page = 0; page < ctrl->length; page++) {
> +			struct swap_cgroup *base;
> +			pgoff_t offset;
> +
> +			base = page_address(ctrl->map[page]);
> +			for (offset = 0; offset < SC_PER_PAGE; offset++) {
> +				struct swap_cgroup *sc;
> +
> +				sc = base + offset;
> +				if (sc->id == id) {
> +					sc->id = 0;
> +					zapped++;
> +				}
> +			}
> +		}
> +		spin_unlock_irqrestore(&ctrl->lock, flags);
> +	}
> +	return zapped;
> +}
> +
>   int swap_cgroup_swapon(int type, unsigned long max_pages)
>   {
>   	void *array;
>


