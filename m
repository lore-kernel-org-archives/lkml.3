Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715AbaGBVUO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 17:20:14 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:41548 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753363AbaGBVUL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 17:20:11 -0400
Date: Wed, 2 Jul 2014 17:20:04 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: mm: memcontrol: rewrite uncharge API: problems
Message-ID: <20140702212004.GF1369@cmpxchg.org>
References: <alpine.LSU.2.11.1406301558090.4572@eggly.anvils>
 <20140701174612.GC1369@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140701174612.GC1369@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 01, 2014 at 01:46:12PM -0400, Johannes Weiner wrote:
> Hi Hugh,
> 
> On Mon, Jun 30, 2014 at 04:55:10PM -0700, Hugh Dickins wrote:
> > Hi Hannes,
> > 
> > Your rewrite of the memcg charge/uncharge API is bold and attractive,
> > but I'm having some problems with the way release_pages() now does
> > uncharging in I/O completion context.
> 
> Yes, I need to make the uncharge path IRQ-safe.  This looks doable.
> 
> > At the bottom see the lockdep message I get when I start shmem swapping.
> > Which I have not begun to attempt to decipher (over to you!), but I do
> > see release_pages() mentioned in there (also i915, hope it's irrelevant).
> 
> This seems to be about uncharge acquiring the IRQ-unsafe soft limit
> tree lock while the outer release_pages() holds the IRQ-safe lru_lock.
> A separate issue, AFAICS, that would also be fixed by IRQ-proofing the
> uncharge path.
> 
> > Which was already worrying me on the PowerPC G5, when moving tasks from
> > one memcg to another and removing the old, while swapping and swappingoff
> > (I haven't tried much else actually, maybe it's much easier to reproduce).
> > 
> > I get "unable to handle kernel paging at 0x180" oops in __raw_spinlock <
> > res_counter_uncharge_until < mem_cgroup_uncharge_end < release_pages <
> > free_pages_and_swap_cache < tlb_flush_mmu_free < tlb_finish_mmu <
> > unmap_region < do_munmap (or from exit_mmap < mmput < do_exit).
> > 
> > I do have CONFIG_MEMCG_SWAP=y, and I think 0x180 corresponds to the
> > memsw res_counter spinlock, if memcg is NULL.  I don't understand why
> > usually the PowerPC: I did see something like it once on this x86 laptop,
> > maybe having lockdep in on this slows things down enough not to hit that.
> > 
> > I've stopped those crashes with patch below: the memcg_batch uncharging
> > was never designed for use from interrupts.  But I bet it needs more work:
> > to disable interrupts, or do something clever with atomics, or... over to
> > you again.
> 
> I was convinced I had tested these changes with lockdep enabled, but
> it must have been at an earlier stage while developing the series.
> Otherwise, I should have gotten the same splat as you report.

Turns out this was because the soft limit was not set in my tests, and
without soft limit excess that spinlock is never acquired.  I could
reproduce it now.

> Thanks for the report, I hope to have something useful ASAP.

Could you give the following patch a spin?  I put it in the mmots
stack on top of mm-memcontrol-rewrite-charge-api-fix-shmem_unuse-fix.

Thanks!

---
>From b13bbe7774296388ca28afc1ce5776d6d6b371fb Mon Sep 17 00:00:00 2001
From: Johannes Weiner <hannes@cmpxchg.org>
Date: Wed, 2 Jul 2014 08:50:23 -0400
Subject: [patch] mm: memcontrol: rewrite uncharge API fix

Hugh reports:

======================================================
[ INFO: SOFTIRQ-safe -> SOFTIRQ-unsafe lock order detected ]
3.16.0-rc2-mm1 #3 Not tainted
------------------------------------------------------
cc1/2771 [HC0[0]:SC0[0]:HE0:SE1] is trying to acquire:
 (&(&rtpz->lock)->rlock){+.+.-.}, at: [<ffffffff811518b5>] memcg_check_events+0x17e/0x206
dd
and this task is already holding:
 (&(&zone->lru_lock)->rlock){..-.-.}, at: [<ffffffff8110da3f>] release_pages+0xe7/0x239
which would create a new lock dependency:
 (&(&zone->lru_lock)->rlock){..-.-.} -> (&(&rtpz->lock)->rlock){+.+.-.}

but this new dependency connects a SOFTIRQ-irq-safe lock:
 (&(&zone->lru_lock)->rlock){..-.-.}
... which became SOFTIRQ-irq-safe at:
  [<ffffffff810c201e>] __lock_acquire+0x59f/0x17e8
  [<ffffffff810c38a6>] lock_acquire+0x61/0x78
  [<ffffffff815bdfbd>] _raw_spin_lock_irqsave+0x3f/0x51
  [<ffffffff8110dc0e>] pagevec_lru_move_fn+0x7d/0xf6
  [<ffffffff8110dca4>] pagevec_move_tail+0x1d/0x2c
  [<ffffffff8110e298>] rotate_reclaimable_page+0xb2/0xd4
  [<ffffffff811018bf>] end_page_writeback+0x1c/0x45
  [<ffffffff81134400>] end_swap_bio_write+0x5c/0x69
  [<ffffffff8123473e>] bio_endio+0x50/0x6e
  [<ffffffff81238dee>] blk_update_request+0x163/0x255
  [<ffffffff81238ef7>] blk_update_bidi_request+0x17/0x65
  [<ffffffff81239242>] blk_end_bidi_request+0x1a/0x56
  [<ffffffff81239289>] blk_end_request+0xb/0xd
  [<ffffffff813a075a>] scsi_io_completion+0x16d/0x553
  [<ffffffff81399c0f>] scsi_finish_command+0xb6/0xbf
  [<ffffffff813a0564>] scsi_softirq_done+0xe9/0xf0
  [<ffffffff8123e8e5>] blk_done_softirq+0x79/0x8b
  [<ffffffff81088675>] __do_softirq+0xfc/0x21f
  [<ffffffff8108898f>] irq_exit+0x3d/0x92
  [<ffffffff81032379>] do_IRQ+0xcc/0xe5
  [<ffffffff815bf5ac>] ret_from_intr+0x0/0x13
  [<ffffffff81443ac0>] cpuidle_enter+0x12/0x14
  [<ffffffff810bb4e4>] cpu_startup_entry+0x187/0x243
  [<ffffffff815a90ab>] rest_init+0x12f/0x133
  [<ffffffff81970e7c>] start_kernel+0x396/0x3a3
  [<ffffffff81970489>] x86_64_start_reservations+0x2a/0x2c
  [<ffffffff81970552>] x86_64_start_kernel+0xc7/0xca

to a SOFTIRQ-irq-unsafe lock:
 (&(&rtpz->lock)->rlock){+.+.-.}
... which became SOFTIRQ-irq-unsafe at:
...  [<ffffffff810c2095>] __lock_acquire+0x616/0x17e8
  [<ffffffff810c38a6>] lock_acquire+0x61/0x78
  [<ffffffff815bde9f>] _raw_spin_lock+0x34/0x41
  [<ffffffff811518b5>] memcg_check_events+0x17e/0x206
  [<ffffffff811535bb>] commit_charge+0x260/0x26f
  [<ffffffff81157004>] mem_cgroup_commit_charge+0xb1/0xdb
  [<ffffffff81115b51>] shmem_getpage_gfp+0x400/0x6c2
  [<ffffffff81115ecc>] shmem_write_begin+0x33/0x35
  [<ffffffff81102a24>] generic_perform_write+0xb7/0x1a4
  [<ffffffff8110391e>] __generic_file_write_iter+0x25b/0x29b
  [<ffffffff81103999>] generic_file_write_iter+0x3b/0xa5
  [<ffffffff8115a115>] new_sync_write+0x7b/0x9f
  [<ffffffff8115a56c>] vfs_write+0xb5/0x169
  [<ffffffff8115ae1f>] SyS_write+0x45/0x8c
  [<ffffffff815bead2>] system_call_fastpath+0x16/0x1b

The soft limit tree lock needs to be IRQ-safe as it's acquired while
holding the IRQ-safe zone->lru_lock.

But more importantly, with uncharge happening in release_pages() now,
this path is executed from interrupt context.

Make the soft limit tree lock, uncharge batching, and charge
statistics IRQ-safe.

Reported-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/memcontrol.c | 113 +++++++++++++++++++++++++++++++++-----------------------
 1 file changed, 67 insertions(+), 46 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 6c3ffb02651e..91b621846e10 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -754,9 +754,11 @@ static void __mem_cgroup_remove_exceeded(struct mem_cgroup_per_zone *mz,
 static void mem_cgroup_remove_exceeded(struct mem_cgroup_per_zone *mz,
 				       struct mem_cgroup_tree_per_zone *mctz)
 {
-	spin_lock(&mctz->lock);
+	unsigned long flags;
+
+	spin_lock_irqsave(&mctz->lock, flags);
 	__mem_cgroup_remove_exceeded(mz, mctz);
-	spin_unlock(&mctz->lock);
+	spin_unlock_irqrestore(&mctz->lock, flags);
 }
 
 
@@ -779,7 +781,9 @@ static void mem_cgroup_update_tree(struct mem_cgroup *memcg, struct page *page)
 		 * mem is over its softlimit.
 		 */
 		if (excess || mz->on_tree) {
-			spin_lock(&mctz->lock);
+			unsigned long flags;
+
+			spin_lock_irqsave(&mctz->lock, flags);
 			/* if on-tree, remove it */
 			if (mz->on_tree)
 				__mem_cgroup_remove_exceeded(mz, mctz);
@@ -788,7 +792,7 @@ static void mem_cgroup_update_tree(struct mem_cgroup *memcg, struct page *page)
 			 * If excess is 0, no tree ops.
 			 */
 			__mem_cgroup_insert_exceeded(mz, mctz, excess);
-			spin_unlock(&mctz->lock);
+			spin_unlock_irqrestore(&mctz->lock, flags);
 		}
 	}
 }
@@ -839,9 +843,9 @@ mem_cgroup_largest_soft_limit_node(struct mem_cgroup_tree_per_zone *mctz)
 {
 	struct mem_cgroup_per_zone *mz;
 
-	spin_lock(&mctz->lock);
+	spin_lock_irq(&mctz->lock);
 	mz = __mem_cgroup_largest_soft_limit_node(mctz);
-	spin_unlock(&mctz->lock);
+	spin_unlock_irq(&mctz->lock);
 	return mz;
 }
 
@@ -904,8 +908,9 @@ static void mem_cgroup_charge_statistics(struct mem_cgroup *memcg,
 					 struct page *page,
 					 int nr_pages)
 {
-	preempt_disable();
+	unsigned long flags;
 
+	local_irq_save(flags);
 	/*
 	 * Here, RSS means 'mapped anon' and anon's SwapCache. Shmem/tmpfs is
 	 * counted as CACHE even if it's on ANON LRU.
@@ -930,7 +935,7 @@ static void mem_cgroup_charge_statistics(struct mem_cgroup *memcg,
 	}
 
 	__this_cpu_add(memcg->stat->nr_page_events, nr_pages);
-	preempt_enable();
+	local_irq_restore(flags);
 }
 
 unsigned long mem_cgroup_get_lru_size(struct lruvec *lruvec, enum lru_list lru)
@@ -1009,7 +1014,9 @@ static bool mem_cgroup_event_ratelimit(struct mem_cgroup *memcg,
  */
 static void memcg_check_events(struct mem_cgroup *memcg, struct page *page)
 {
-	preempt_disable();
+	unsigned long flags;
+
+	local_irq_save(flags);
 	/* threshold event is triggered in finer grain than soft limit */
 	if (unlikely(mem_cgroup_event_ratelimit(memcg,
 						MEM_CGROUP_TARGET_THRESH))) {
@@ -1022,7 +1029,7 @@ static void memcg_check_events(struct mem_cgroup *memcg, struct page *page)
 		do_numainfo = mem_cgroup_event_ratelimit(memcg,
 						MEM_CGROUP_TARGET_NUMAINFO);
 #endif
-		preempt_enable();
+		local_irq_restore(flags);
 
 		mem_cgroup_threshold(memcg);
 		if (unlikely(do_softlimit))
@@ -1032,7 +1039,7 @@ static void memcg_check_events(struct mem_cgroup *memcg, struct page *page)
 			atomic_inc(&memcg->numainfo_events);
 #endif
 	} else
-		preempt_enable();
+		local_irq_restore(flags);
 }
 
 struct mem_cgroup *mem_cgroup_from_task(struct task_struct *p)
@@ -3620,6 +3627,9 @@ out:
 
 void mem_cgroup_uncharge_start(void)
 {
+	unsigned long flags;
+
+	local_irq_save(flags);
 	current->memcg_batch.do_batch++;
 	/* We can do nest. */
 	if (current->memcg_batch.do_batch == 1) {
@@ -3627,21 +3637,18 @@ void mem_cgroup_uncharge_start(void)
 		current->memcg_batch.nr_pages = 0;
 		current->memcg_batch.memsw_nr_pages = 0;
 	}
+	local_irq_restore(flags);
 }
 
 void mem_cgroup_uncharge_end(void)
 {
 	struct memcg_batch_info *batch = &current->memcg_batch;
+	unsigned long flags;
 
-	if (!batch->do_batch)
-		return;
-
-	batch->do_batch--;
-	if (batch->do_batch) /* If stacked, do nothing. */
-		return;
-
-	if (!batch->memcg)
-		return;
+	local_irq_save(flags);
+	VM_BUG_ON(!batch->do_batch);
+	if (--batch->do_batch) /* If stacked, do nothing */
+		goto out;
 	/*
 	 * This "batch->memcg" is valid without any css_get/put etc...
 	 * bacause we hide charges behind us.
@@ -3653,8 +3660,8 @@ void mem_cgroup_uncharge_end(void)
 		res_counter_uncharge(&batch->memcg->memsw,
 				     batch->memsw_nr_pages * PAGE_SIZE);
 	memcg_oom_recover(batch->memcg);
-	/* forget this pointer (for sanity check) */
-	batch->memcg = NULL;
+out:
+	local_irq_restore(flags);
 }
 
 #ifdef CONFIG_MEMCG_SWAP
@@ -6554,6 +6561,36 @@ void mem_cgroup_cancel_charge(struct page *page, struct mem_cgroup *memcg)
 	cancel_charge(memcg, nr_pages);
 }
 
+static bool uncharge_batched(struct mem_cgroup *memcg,
+			     unsigned long pc_flags,
+			     unsigned int nr_pages)
+{
+	struct memcg_batch_info *batch = &current->memcg_batch;
+	bool uncharged = false;
+	unsigned long flags;
+
+	if (nr_pages > 1)
+		return false;
+	if (test_thread_flag(TIF_MEMDIE))
+		return false;
+
+	local_irq_save(flags);
+	if (!batch->do_batch)
+		goto out;
+	if (batch->memcg && batch->memcg != memcg)
+		goto out;
+	if (!batch->memcg)
+		batch->memcg = memcg;
+	if (pc_flags & PCG_MEM)
+		batch->nr_pages++;
+	if (pc_flags & PCG_MEMSW)
+		batch->memsw_nr_pages++;
+	uncharged = true;
+out:
+	local_irq_restore(flags);
+	return uncharged;
+}
+
 /**
  * mem_cgroup_uncharge - uncharge a page
  * @page: page to uncharge
@@ -6563,11 +6600,10 @@ void mem_cgroup_cancel_charge(struct page *page, struct mem_cgroup *memcg)
  */
 void mem_cgroup_uncharge(struct page *page)
 {
-	struct memcg_batch_info *batch;
 	unsigned int nr_pages = 1;
 	struct mem_cgroup *memcg;
 	struct page_cgroup *pc;
-	unsigned long flags;
+	unsigned long pc_flags;
 
 	VM_BUG_ON_PAGE(PageLRU(page), page);
 	VM_BUG_ON_PAGE(page_count(page), page);
@@ -6591,35 +6627,20 @@ void mem_cgroup_uncharge(struct page *page)
 	 * exclusive access to the page.
 	 */
 	memcg = pc->mem_cgroup;
-	flags = pc->flags;
+	pc_flags = pc->flags;
 	pc->flags = 0;
 
 	mem_cgroup_charge_statistics(memcg, page, -nr_pages);
 	memcg_check_events(memcg, page);
 
-	batch = &current->memcg_batch;
-	if (!batch->memcg)
-		batch->memcg = memcg;
-	else if (batch->memcg != memcg)
-		goto uncharge;
-	if (nr_pages > 1)
-		goto uncharge;
-	if (!batch->do_batch)
-		goto uncharge;
-	if (test_thread_flag(TIF_MEMDIE))
-		goto uncharge;
-	if (flags & PCG_MEM)
-		batch->nr_pages++;
-	if (flags & PCG_MEMSW)
-		batch->memsw_nr_pages++;
-	return;
-uncharge:
-	if (flags & PCG_MEM)
+	if (uncharge_batched(memcg, pc_flags, nr_pages))
+		return;
+
+	if (pc_flags & PCG_MEM)
 		res_counter_uncharge(&memcg->res, nr_pages * PAGE_SIZE);
-	if (flags & PCG_MEMSW)
+	if (pc_flags & PCG_MEMSW)
 		res_counter_uncharge(&memcg->memsw, nr_pages * PAGE_SIZE);
-	if (batch->memcg != memcg)
-		memcg_oom_recover(memcg);
+	memcg_oom_recover(memcg);
 }
 
 /**
-- 
2.0.0


