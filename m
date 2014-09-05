Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756581AbaIEJZo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 05:25:44 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:34769 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756045AbaIEJZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 05:25:41 -0400
Date: Fri, 5 Sep 2014 11:25:37 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Dave Hansen <dave@sr71.net>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>,
        Dave Hansen <dave.hansen@intel.com>, Tejun Heo <tj@kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Vladimir Davydov <vdavydov@parallels.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: regression caused by cgroups optimization in 3.17-rc2
Message-ID: <20140905092537.GC26243@dhcp22.suse.cz>
References: <54061505.8020500@sr71.net>
 <5406262F.4050705@intel.com>
 <54062F32.5070504@sr71.net>
 <20140904142721.GB14548@dhcp22.suse.cz>
 <5408CB2E.3080101@sr71.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5408CB2E.3080101@sr71.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 04-09-14 13:27:26, Dave Hansen wrote:
> On 09/04/2014 07:27 AM, Michal Hocko wrote:
> > Ouch. free_pages_and_swap_cache completely kills the uncharge batching
> > because it reduces it to PAGEVEC_SIZE batches.
> > 
> > I think we really do not need PAGEVEC_SIZE batching anymore. We are
> > already batching on tlb_gather layer. That one is limited so I think
> > the below should be safe but I have to think about this some more. There
> > is a risk of prolonged lru_lock wait times but the number of pages is
> > limited to 10k and the heavy work is done outside of the lock. If this
> > is really a problem then we can tear LRU part and the actual
> > freeing/uncharging into a separate functions in this path.
> > 
> > Could you test with this half baked patch, please? I didn't get to test
> > it myself unfortunately.
> 
> 3.16 settled out at about 11.5M faults/sec before the regression.  This
> patch gets it back up to about 10.5M, which is good.

Dave, would you be willing to test the following patch as well? I do not
have a huge machine at hand right now. It would be great if you could
run the same load within a !root memcg. We have basically the same
sub-optimality there as well. The root bypass will be re-introduced for
now but I think we can make the regular memcg load better regardless and
this would be also preparation for later root bypass removal again.
---
>From 17c4c8710f3ec37fe04866bd18dbc68a0f47b560 Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.cz>
Date: Fri, 5 Sep 2014 11:16:17 +0200
Subject: [PATCH] mm, memcg: Do not kill release batching in
 free_pages_and_swap_cache

free_pages_and_swap_cache limits release_pages to PAGEVEC_SIZE chunks.
This is not a big deal for the normal release path but it completely
kills memcg uncharge batching which reduces res_counter spin_lock
contention. Dave has noticed this with his page fault scalability test
case on a large machine when the lock was basically dominating on all
CPUs:
    80.18%    80.18%  [kernel]               [k] _raw_spin_lock
                  |
                  --- _raw_spin_lock
                     |
                     |--66.59%-- res_counter_uncharge_until
                     |          res_counter_uncharge
                     |          uncharge_batch
                     |          uncharge_list
                     |          mem_cgroup_uncharge_list
                     |          release_pages
                     |          free_pages_and_swap_cache
                     |          tlb_flush_mmu_free
                     |          |
                     |          |--90.12%-- unmap_single_vma
                     |          |          unmap_vmas
                     |          |          unmap_region
                     |          |          do_munmap
                     |          |          vm_munmap
                     |          |          sys_munmap
                     |          |          system_call_fastpath
                     |          |          __GI___munmap
                     |          |
                     |           --9.88%-- tlb_flush_mmu
                     |                     tlb_finish_mmu
                     |                     unmap_region
                     |                     do_munmap
                     |                     vm_munmap
                     |                     sys_munmap
                     |                     system_call_fastpath
                     |                     __GI___munmap

In his case the load was running in the root memcg and that part
has been handled by reverting 05b843012335 ("mm: memcontrol: use
root_mem_cgroup res_counter") because this is a clear regression.
But it makes sense to help loads which are running within a memcg
as well. So this is basically a performance optimization.

There is no reason to limit release_pages to PAGEVEC_SIZE batches other
than lru_lock held times. This logic, however, can be moved inside the
function. mem_cgroup_uncharge_list and free_hot_cold_page_list do not
hold any lock for the whole pages_to_free list so it is safe to call
them in a single run.

Page reference count and LRU handling is moved to release_lru_pages and
that is run in PAGEVEC_SIZE batches.

Reported-by: Dave Hansen <dave@sr71.net>
Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 mm/swap.c       | 27 +++++++++++++++++++++------
 mm/swap_state.c | 14 ++++----------
 2 files changed, 25 insertions(+), 16 deletions(-)

diff --git a/mm/swap.c b/mm/swap.c
index 6b2dc3897cd5..8af99dd68dd2 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -888,9 +888,9 @@ void lru_add_drain_all(void)
 }
 
 /*
- * Batched page_cache_release().  Decrement the reference count on all the
- * passed pages.  If it fell to zero then remove the page from the LRU and
- * free it.
+ * Batched lru release. Decrement the reference count on all the passed pages.
+ * If it fell to zero then remove the page from the LRU and add it to the given
+ * list to be freed by the caller.
  *
  * Avoid taking zone->lru_lock if possible, but if it is taken, retain it
  * for the remainder of the operation.
@@ -900,10 +900,10 @@ void lru_add_drain_all(void)
  * grabbed the page via the LRU.  If it did, give up: shrink_inactive_list()
  * will free it.
  */
-void release_pages(struct page **pages, int nr, bool cold)
+static void release_lru_pages(struct page **pages, int nr,
+			      struct list_head *pages_to_free)
 {
 	int i;
-	LIST_HEAD(pages_to_free);
 	struct zone *zone = NULL;
 	struct lruvec *lruvec;
 	unsigned long uninitialized_var(flags);
@@ -943,11 +943,26 @@ void release_pages(struct page **pages, int nr, bool cold)
 		/* Clear Active bit in case of parallel mark_page_accessed */
 		__ClearPageActive(page);
 
-		list_add(&page->lru, &pages_to_free);
+		list_add(&page->lru, pages_to_free);
 	}
 	if (zone)
 		spin_unlock_irqrestore(&zone->lru_lock, flags);
+}
+/*
+ * Batched page_cache_release(). Frees and uncharges all given pages
+ * for which the reference count drops to 0.
+ */
+void release_pages(struct page **pages, int nr, bool cold)
+{
+	LIST_HEAD(pages_to_free);
 
+	while (nr) {
+		int batch = min(nr, PAGEVEC_SIZE);
+
+		release_lru_pages(pages, batch, &pages_to_free);
+		pages += batch;
+		nr -= batch;
+	}
 	mem_cgroup_uncharge_list(&pages_to_free);
 	free_hot_cold_page_list(&pages_to_free, cold);
 }
diff --git a/mm/swap_state.c b/mm/swap_state.c
index ef1f39139b71..154444918685 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -265,18 +265,12 @@ void free_page_and_swap_cache(struct page *page)
 void free_pages_and_swap_cache(struct page **pages, int nr)
 {
 	struct page **pagep = pages;
+	int i;
 
 	lru_add_drain();
-	while (nr) {
-		int todo = min(nr, PAGEVEC_SIZE);
-		int i;
-
-		for (i = 0; i < todo; i++)
-			free_swap_cache(pagep[i]);
-		release_pages(pagep, todo, false);
-		pagep += todo;
-		nr -= todo;
-	}
+	for (i = 0; i < nr; i++)
+		free_swap_cache(pagep[i]);
+	release_pages(pagep, nr, false);
 }
 
 /*
-- 
2.1.0

-- 
Michal Hocko
SUSE Labs
