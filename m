Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463AbaIBWSh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 18:18:37 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:59918 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751326AbaIBWSf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 18:18:35 -0400
Date: Tue, 2 Sep 2014 18:18:14 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Dave Hansen <dave@sr71.net>
Cc: Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>,
        Tejun Heo <tj@kernel.org>, Vladimir Davydov <vdavydov@parallels.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>
Subject: Re: regression caused by cgroups optimization in 3.17-rc2
Message-ID: <20140902221814.GA18069@cmpxchg.org>
References: <54061505.8020500@sr71.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54061505.8020500@sr71.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

On Tue, Sep 02, 2014 at 12:05:41PM -0700, Dave Hansen wrote:
> I'm seeing a pretty large regression in 3.17-rc2 vs 3.16 coming from the
> memory cgroups code.  This is on a kernel with cgroups enabled at
> compile time, but not _used_ for anything.  See the green lines in the
> graph:
> 
> 	https://www.sr71.net/~dave/intel/regression-from-05b843012.png
> 
> The workload is a little parallel microbenchmark doing page faults:

Ouch.

> > https://github.com/antonblanchard/will-it-scale/blob/master/tests/page_fault2.c
> 
> The hardware is an 8-socket Westmere box with 160 hardware threads.  For
> some reason, this does not affect the version of the microbenchmark
> which is doing completely anonymous page faults.
> 
> I bisected it down to this commit:
> 
> > commit 05b8430123359886ef6a4146fba384e30d771b3f
> > Author: Johannes Weiner <hannes@cmpxchg.org>
> > Date:   Wed Aug 6 16:05:59 2014 -0700
> > 
> >     mm: memcontrol: use root_mem_cgroup res_counter
> >     
> >     Due to an old optimization to keep expensive res_counter changes at a
> >     minimum, the root_mem_cgroup res_counter is never charged; there is no
> >     limit at that level anyway, and any statistics can be generated on
> >     demand by summing up the counters of all other cgroups.
> >     
> >     However, with per-cpu charge caches, res_counter operations do not even
> >     show up in profiles anymore, so this optimization is no longer
> >     necessary.
> >     
> >     Remove it to simplify the code.

Accounting new pages is buffered through per-cpu caches, but taking
them off the counters on free is not, so I'm guessing that above a
certain allocation rate the cost of locking and changing the counters
takes over.  Is there a chance you could profile this to see if locks
and res_counter-related operations show up?

I can't reproduce this complete breakdown on my smaller test gear, but
I do see an improvement with the following patch:

---
>From 29a51326c24b7bb45d17e9c864c34506f10868f6 Mon Sep 17 00:00:00 2001
From: Johannes Weiner <hannes@cmpxchg.org>
Date: Tue, 2 Sep 2014 18:11:39 -0400
Subject: [patch] mm: memcontrol: use per-cpu caches for uncharging

---
 mm/memcontrol.c | 28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index ec4dcf1b9562..cb79ecff399d 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2365,6 +2365,7 @@ static void drain_stock(struct memcg_stock_pcp *stock)
 		res_counter_uncharge(&old->res, bytes);
 		if (do_swap_account)
 			res_counter_uncharge(&old->memsw, bytes);
+		memcg_oom_recover(old);
 		stock->nr_pages = 0;
 	}
 	stock->cached = NULL;
@@ -2405,6 +2406,13 @@ static void refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
 		stock->cached = memcg;
 	}
 	stock->nr_pages += nr_pages;
+	if (stock->nr_pages > CHARGE_BATCH * 4) {
+		res_counter_uncharge(&memcg->res, CHARGE_BATCH);
+		if (do_swap_account)
+			res_counter_uncharge(&memcg->memsw, CHARGE_BATCH);
+		memcg_oom_recover(memcg);
+		stock->nr_pages -= CHARGE_BATCH;
+	}
 	put_cpu_var(memcg_stock);
 }
 
@@ -6509,12 +6517,20 @@ static void uncharge_batch(struct mem_cgroup *memcg, unsigned long pgpgout,
 {
 	unsigned long flags;
 
-	if (nr_mem)
-		res_counter_uncharge(&memcg->res, nr_mem * PAGE_SIZE);
-	if (nr_memsw)
-		res_counter_uncharge(&memcg->memsw, nr_memsw * PAGE_SIZE);
-
-	memcg_oom_recover(memcg);
+	/*
+	 * The percpu caches count both memory and memsw charges in a
+	 * single conuter, but there might be less memsw charges when
+	 * some of the pages have been swapped out.
+	 */
+	if (nr_mem == nr_memsw)
+		refill_stock(memcg, nr_mem);
+	else {
+		if (nr_mem)
+			res_counter_uncharge(&memcg->res, nr_mem * PAGE_SIZE);
+		if (nr_memsw)
+			res_counter_uncharge(&memcg->memsw, nr_memsw * PAGE_SIZE);
+		memcg_oom_recover(memcg);
+	}
 
 	local_irq_save(flags);
 	__this_cpu_sub(memcg->stat->count[MEM_CGROUP_STAT_RSS], nr_anon);
-- 
2.0.4

