Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656AbaIDPJE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 11:09:04 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:60033 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750742AbaIDPJC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 11:09:02 -0400
Date: Thu, 4 Sep 2014 11:08:46 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Dave Hansen <dave@sr71.net>
Cc: Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>,
        Tejun Heo <tj@kernel.org>, Vladimir Davydov <vdavydov@parallels.com>,
        Linus Torvalds <torvalds@linuxfoundation.org>,
        Andrew Morton <akpm@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>
Subject: Re: regression caused by cgroups optimization in 3.17-rc2
Message-ID: <20140904150846.GA10794@cmpxchg.org>
References: <54061505.8020500@sr71.net>
 <20140902221814.GA18069@cmpxchg.org>
 <5406466D.1020000@sr71.net>
 <20140903001009.GA25970@cmpxchg.org>
 <5406612E.8040802@sr71.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5406612E.8040802@sr71.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 02, 2014 at 05:30:38PM -0700, Dave Hansen wrote:
> On 09/02/2014 05:10 PM, Johannes Weiner wrote:
> > On Tue, Sep 02, 2014 at 03:36:29PM -0700, Dave Hansen wrote:
> >> On 09/02/2014 03:18 PM, Johannes Weiner wrote:
> >>> Accounting new pages is buffered through per-cpu caches, but taking
> >>> them off the counters on free is not, so I'm guessing that above a
> >>> certain allocation rate the cost of locking and changing the counters
> >>> takes over.  Is there a chance you could profile this to see if locks
> >>> and res_counter-related operations show up?
> >>
> >> It looks pretty much the same, although it might have equalized the
> >> charge and uncharge sides a bit.  Full 'perf top' output attached.
> > 
> > That looks like a partial profile, where did the page allocator, page
> > zeroing etc. go?  Because the distribution among these listed symbols
> > doesn't seem all that crazy:
> 
> Perf was only outputting the top 20 functions.  Believe it or not, page
> zeroing and the rest of the allocator path wasn't even in the path of
> the top 20 functions because there is so much lock contention.
> 
> Here's a longer run of 'perf top' along with the top 100 functions:
> 
> 	http://www.sr71.net/~dave/intel/perf-top-1409702817.txt.gz
> 
> you can at least see copy_page_rep in there.

Thanks for the clarification, that is truly horrible.  Does the
following revert restore performance in your case?

---
>From 6fa7599054868cd0df940d7b0973dd64f8acb0b5 Mon Sep 17 00:00:00 2001
From: Johannes Weiner <hannes@cmpxchg.org>
Date: Thu, 4 Sep 2014 10:04:34 -0400
Subject: [patch] mm: memcontrol: revert use of root_mem_cgroup res_counter

Dave Hansen reports a massive scalability regression in an uncontained
page fault benchmark with more than 30 concurrent threads, which he
bisected down to 05b843012335 ("mm: memcontrol: use root_mem_cgroup
res_counter") and pin-pointed on res_counter spinlock contention.

That change relied on the per-cpu charge caches to mostly swallow the
res_counter costs, but it's apparent that the caches don't scale yet.

Revert memcg back to bypassing res_counters on the root level in order
to restore performance for uncontained workloads.

Reported-by: Dave Hansen <dave@sr71.net>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/memcontrol.c | 103 ++++++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 78 insertions(+), 25 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index ec4dcf1b9562..085dc6d2f876 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2534,6 +2534,8 @@ static int try_charge(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	unsigned long long size;
 	int ret = 0;
 
+	if (mem_cgroup_is_root(memcg))
+		goto done;
 retry:
 	if (consume_stock(memcg, nr_pages))
 		goto done;
@@ -2611,9 +2613,7 @@ nomem:
 	if (!(gfp_mask & __GFP_NOFAIL))
 		return -ENOMEM;
 bypass:
-	memcg = root_mem_cgroup;
-	ret = -EINTR;
-	goto retry;
+	return -EINTR;
 
 done_restock:
 	if (batch > nr_pages)
@@ -2626,6 +2626,9 @@ static void cancel_charge(struct mem_cgroup *memcg, unsigned int nr_pages)
 {
 	unsigned long bytes = nr_pages * PAGE_SIZE;
 
+	if (mem_cgroup_is_root(memcg))
+		return;
+
 	res_counter_uncharge(&memcg->res, bytes);
 	if (do_swap_account)
 		res_counter_uncharge(&memcg->memsw, bytes);
@@ -2640,6 +2643,9 @@ static void __mem_cgroup_cancel_local_charge(struct mem_cgroup *memcg,
 {
 	unsigned long bytes = nr_pages * PAGE_SIZE;
 
+	if (mem_cgroup_is_root(memcg))
+		return;
+
 	res_counter_uncharge_until(&memcg->res, memcg->res.parent, bytes);
 	if (do_swap_account)
 		res_counter_uncharge_until(&memcg->memsw,
@@ -4093,6 +4099,46 @@ out:
 	return retval;
 }
 
+static unsigned long mem_cgroup_recursive_stat(struct mem_cgroup *memcg,
+					       enum mem_cgroup_stat_index idx)
+{
+	struct mem_cgroup *iter;
+	long val = 0;
+
+	/* Per-cpu values can be negative, use a signed accumulator */
+	for_each_mem_cgroup_tree(iter, memcg)
+		val += mem_cgroup_read_stat(iter, idx);
+
+	if (val < 0) /* race ? */
+		val = 0;
+	return val;
+}
+
+static inline u64 mem_cgroup_usage(struct mem_cgroup *memcg, bool swap)
+{
+	u64 val;
+
+	if (!mem_cgroup_is_root(memcg)) {
+		if (!swap)
+			return res_counter_read_u64(&memcg->res, RES_USAGE);
+		else
+			return res_counter_read_u64(&memcg->memsw, RES_USAGE);
+	}
+
+	/*
+	 * Transparent hugepages are still accounted for in MEM_CGROUP_STAT_RSS
+	 * as well as in MEM_CGROUP_STAT_RSS_HUGE.
+	 */
+	val = mem_cgroup_recursive_stat(memcg, MEM_CGROUP_STAT_CACHE);
+	val += mem_cgroup_recursive_stat(memcg, MEM_CGROUP_STAT_RSS);
+
+	if (swap)
+		val += mem_cgroup_recursive_stat(memcg, MEM_CGROUP_STAT_SWAP);
+
+	return val << PAGE_SHIFT;
+}
+
+
 static u64 mem_cgroup_read_u64(struct cgroup_subsys_state *css,
 			       struct cftype *cft)
 {
@@ -4102,8 +4148,12 @@ static u64 mem_cgroup_read_u64(struct cgroup_subsys_state *css,
 
 	switch (type) {
 	case _MEM:
+		if (name == RES_USAGE)
+			return mem_cgroup_usage(memcg, false);
 		return res_counter_read_u64(&memcg->res, name);
 	case _MEMSWAP:
+		if (name == RES_USAGE)
+			return mem_cgroup_usage(memcg, true);
 		return res_counter_read_u64(&memcg->memsw, name);
 	case _KMEM:
 		return res_counter_read_u64(&memcg->kmem, name);
@@ -4572,10 +4622,7 @@ static void __mem_cgroup_threshold(struct mem_cgroup *memcg, bool swap)
 	if (!t)
 		goto unlock;
 
-	if (!swap)
-		usage = res_counter_read_u64(&memcg->res, RES_USAGE);
-	else
-		usage = res_counter_read_u64(&memcg->memsw, RES_USAGE);
+	usage = mem_cgroup_usage(memcg, swap);
 
 	/*
 	 * current_threshold points to threshold just below or equal to usage.
@@ -4673,10 +4720,10 @@ static int __mem_cgroup_usage_register_event(struct mem_cgroup *memcg,
 
 	if (type == _MEM) {
 		thresholds = &memcg->thresholds;
-		usage = res_counter_read_u64(&memcg->res, RES_USAGE);
+		usage = mem_cgroup_usage(memcg, false);
 	} else if (type == _MEMSWAP) {
 		thresholds = &memcg->memsw_thresholds;
-		usage = res_counter_read_u64(&memcg->memsw, RES_USAGE);
+		usage = mem_cgroup_usage(memcg, true);
 	} else
 		BUG();
 
@@ -4762,10 +4809,10 @@ static void __mem_cgroup_usage_unregister_event(struct mem_cgroup *memcg,
 
 	if (type == _MEM) {
 		thresholds = &memcg->thresholds;
-		usage = res_counter_read_u64(&memcg->res, RES_USAGE);
+		usage = mem_cgroup_usage(memcg, false);
 	} else if (type == _MEMSWAP) {
 		thresholds = &memcg->memsw_thresholds;
-		usage = res_counter_read_u64(&memcg->memsw, RES_USAGE);
+		usage = mem_cgroup_usage(memcg, true);
 	} else
 		BUG();
 
@@ -5525,9 +5572,9 @@ mem_cgroup_css_online(struct cgroup_subsys_state *css)
 		 * core guarantees its existence.
 		 */
 	} else {
-		res_counter_init(&memcg->res, &root_mem_cgroup->res);
-		res_counter_init(&memcg->memsw, &root_mem_cgroup->memsw);
-		res_counter_init(&memcg->kmem, &root_mem_cgroup->kmem);
+		res_counter_init(&memcg->res, NULL);
+		res_counter_init(&memcg->memsw, NULL);
+		res_counter_init(&memcg->kmem, NULL);
 		/*
 		 * Deeper hierachy with use_hierarchy == false doesn't make
 		 * much sense so let cgroup subsystem know about this
@@ -5969,8 +6016,9 @@ static void __mem_cgroup_clear_mc(void)
 	/* we must fixup refcnts and charges */
 	if (mc.moved_swap) {
 		/* uncharge swap account from the old cgroup */
-		res_counter_uncharge(&mc.from->memsw,
-				     PAGE_SIZE * mc.moved_swap);
+		if (!mem_cgroup_is_root(mc.from))
+			res_counter_uncharge(&mc.from->memsw,
+					     PAGE_SIZE * mc.moved_swap);
 
 		for (i = 0; i < mc.moved_swap; i++)
 			css_put(&mc.from->css);
@@ -5979,8 +6027,9 @@ static void __mem_cgroup_clear_mc(void)
 		 * we charged both to->res and to->memsw, so we should
 		 * uncharge to->res.
 		 */
-		res_counter_uncharge(&mc.to->res,
-				     PAGE_SIZE * mc.moved_swap);
+		if (!mem_cgroup_is_root(mc.to))
+			res_counter_uncharge(&mc.to->res,
+					     PAGE_SIZE * mc.moved_swap);
 		/* we've already done css_get(mc.to) */
 		mc.moved_swap = 0;
 	}
@@ -6345,7 +6394,8 @@ void mem_cgroup_uncharge_swap(swp_entry_t entry)
 	rcu_read_lock();
 	memcg = mem_cgroup_lookup(id);
 	if (memcg) {
-		res_counter_uncharge(&memcg->memsw, PAGE_SIZE);
+		if (!mem_cgroup_is_root(memcg))
+			res_counter_uncharge(&memcg->memsw, PAGE_SIZE);
 		mem_cgroup_swap_statistics(memcg, false);
 		css_put(&memcg->css);
 	}
@@ -6509,12 +6559,15 @@ static void uncharge_batch(struct mem_cgroup *memcg, unsigned long pgpgout,
 {
 	unsigned long flags;
 
-	if (nr_mem)
-		res_counter_uncharge(&memcg->res, nr_mem * PAGE_SIZE);
-	if (nr_memsw)
-		res_counter_uncharge(&memcg->memsw, nr_memsw * PAGE_SIZE);
-
-	memcg_oom_recover(memcg);
+	if (!mem_cgroup_is_root(memcg)) {
+		if (nr_mem)
+			res_counter_uncharge(&memcg->res,
+					     nr_mem * PAGE_SIZE);
+		if (nr_memsw)
+			res_counter_uncharge(&memcg->memsw,
+					     nr_memsw * PAGE_SIZE);
+		memcg_oom_recover(memcg);
+	}
 
 	local_irq_save(flags);
 	__this_cpu_sub(memcg->stat->count[MEM_CGROUP_STAT_RSS], nr_anon);
-- 
2.0.4

