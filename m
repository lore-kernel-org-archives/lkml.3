Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426Ab3IZPmf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 11:42:35 -0400
Received: from mga09.intel.com ([134.134.136.24]:52902 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751068Ab3IZPme (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 11:42:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,986,1371106800"; 
   d="scan'208";a="383915238"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Alex Thorlton <athorlton@sgi.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>, Dave Jones <davej@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Kees Cook <keescook@chromium.org>, Mel Gorman <mgorman@suse.de>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Rik van Riel <riel@redhat.com>, Robin Holt <robinmholt@gmail.com>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
In-Reply-To: <20130926105052.0205AE0090@blue.fi.intel.com>
References: <1379330740-5602-1-git-send-email-kirill.shutemov@linux.intel.com>
 <20130919171727.GC6802@sgi.com>
 <20130920123137.BE2F7E0090@blue.fi.intel.com>
 <20130924164443.GB2940@sgi.com>
 <20130926105052.0205AE0090@blue.fi.intel.com>
Subject: Re: [PATCHv2 0/9] split page table lock for PMD tables
Content-Transfer-Encoding: 7bit
Message-Id: <20130926154224.D2CFFE0090@blue.fi.intel.com>
Date: Thu, 26 Sep 2013 18:42:24 +0300 (EEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kirill A. Shutemov wrote:
> Alex Thorlton wrote:
> > > THP off:
> > > --------
> ...
> > >       36.540185552 seconds time elapsed                                          ( +- 18.36% )
> > 
> > I'm assuming this was THP off, no patchset, correct?
> 
> Yes. But THP off patched is *very* close to this, so I didn't post it separately.
> 
> > Here are my results from this test on 3.12-rc1:
> ...
> >     1138.759708820 seconds time elapsed                                          ( +-  0.47% )
> > 
> > And the same test on 3.12-rc1 with your patchset:
> > 
> >  Performance counter stats for './runt -t -c 512 -b 512m' (5 runs):
> ...
> >     1115.214191126 seconds time elapsed                                          ( +-  0.18% )
> > 
> > Looks like we're getting a mild performance increase here, but we still
> > have a problem.
> 
> Let me guess: you have HUGETLBFS enabled in your config, right? ;)
> 
> HUGETLBFS hasn't converted to new locking and we disable split pmd lock if
> HUGETLBFS is enabled.
> 
> I'm going to convert HUGETLBFS too, but it might take some time.

Okay, here is a bit reworked patch from Naoya Horiguchi.
It might need more cleanup.

Please, test and review.

>From 47e400fc308e0054c2cadf7df48f632555c83572 Mon Sep 17 00:00:00 2001
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Date: Thu, 26 Sep 2013 17:51:33 +0300
Subject: [PATCH] mm/hugetlb: convert hugetlbfs to use split pmd lock

Hugetlb supports multiple page sizes. We use split lock only for PMD
level, but not for PUD.

I've run workload from Alex Thorlton[1], slightly modified to use
mmap(MAP_HUGETLB) for memory allocation.

hugetlbfs, v3.12-rc2:
---------------------

 Performance counter stats for './thp_memscale_hugetlbfs -c 80 -b 512M' (5 runs):

    2588052.787264 task-clock                #   54.400 CPUs utilized            ( +-  3.69% )
           246,831 context-switches          #    0.095 K/sec                    ( +-  4.15% )
               138 cpu-migrations            #    0.000 K/sec                    ( +-  5.30% )
            21,027 page-faults               #    0.008 K/sec                    ( +-  0.01% )
 6,166,666,307,263 cycles                    #    2.383 GHz                      ( +-  3.68% ) [83.33%]
 6,086,008,929,407 stalled-cycles-frontend   #   98.69% frontend cycles idle     ( +-  3.77% ) [83.33%]
 5,087,874,435,481 stalled-cycles-backend    #   82.51% backend  cycles idle     ( +-  4.41% ) [66.67%]
   133,782,831,249 instructions              #    0.02  insns per cycle
                                             #   45.49  stalled cycles per insn  ( +-  4.30% ) [83.34%]
    34,026,870,541 branches                  #   13.148 M/sec                    ( +-  4.24% ) [83.34%]
        68,670,942 branch-misses             #    0.20% of all branches          ( +-  3.26% ) [83.33%]

      47.574936948 seconds time elapsed                                          ( +-  2.09% )

hugetlbfs, patched:
-------------------

 Performance counter stats for './thp_memscale_hugetlbfs -c 80 -b 512M' (5 runs):

     395353.076837 task-clock                #   20.329 CPUs utilized            ( +-  8.16% )
            55,730 context-switches          #    0.141 K/sec                    ( +-  5.31% )
               138 cpu-migrations            #    0.000 K/sec                    ( +-  4.24% )
            21,027 page-faults               #    0.053 K/sec                    ( +-  0.00% )
   930,219,717,244 cycles                    #    2.353 GHz                      ( +-  8.21% ) [83.32%]
   914,295,694,103 stalled-cycles-frontend   #   98.29% frontend cycles idle     ( +-  8.35% ) [83.33%]
   704,137,950,187 stalled-cycles-backend    #   75.70% backend  cycles idle     ( +-  9.16% ) [66.69%]
    30,541,538,385 instructions              #    0.03  insns per cycle
                                             #   29.94  stalled cycles per insn  ( +-  3.98% ) [83.35%]
     8,415,376,631 branches                  #   21.286 M/sec                    ( +-  3.61% ) [83.36%]
        32,645,478 branch-misses             #    0.39% of all branches          ( +-  3.41% ) [83.32%]

      19.447481153 seconds time elapsed                                          ( +-  2.00% )

Split lock helps, but hugetlbs is still significantly slower the THP
(8.4 seconds).

[1] ftp://shell.sgi.com/collect/memscale/thp_memscale.tar.gz

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 fs/proc/meminfo.c        |   2 +-
 include/linux/hugetlb.h  |  19 +++++++++
 include/linux/mm_types.h |   4 +-
 include/linux/swapops.h  |   9 ++--
 mm/hugetlb.c             | 108 ++++++++++++++++++++++++++++-------------------
 mm/mempolicy.c           |   5 ++-
 mm/migrate.c             |   7 +--
 mm/rmap.c                |   2 +-
 8 files changed, 100 insertions(+), 56 deletions(-)

diff --git a/fs/proc/meminfo.c b/fs/proc/meminfo.c
index 59d85d6088..6d061f5359 100644
--- a/fs/proc/meminfo.c
+++ b/fs/proc/meminfo.c
@@ -1,8 +1,8 @@
 #include <linux/fs.h>
-#include <linux/hugetlb.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/mm.h>
+#include <linux/hugetlb.h>
 #include <linux/mman.h>
 #include <linux/mmzone.h>
 #include <linux/proc_fs.h>
diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 0393270466..4a4a73b1ec 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -401,6 +401,7 @@ struct hstate {};
 #define hstate_sizelog(s) NULL
 #define hstate_vma(v) NULL
 #define hstate_inode(i) NULL
+#define page_hstate(page) NULL
 #define huge_page_size(h) PAGE_SIZE
 #define huge_page_mask(h) PAGE_MASK
 #define vma_kernel_pagesize(v) PAGE_SIZE
@@ -423,4 +424,22 @@ static inline pgoff_t basepage_index(struct page *page)
 #define hugepage_migration_support(h)	0
 #endif	/* CONFIG_HUGETLB_PAGE */
 
+static inline spinlock_t *huge_pte_lockptr(struct hstate *h,
+               struct mm_struct *mm, pte_t *pte)
+{
+       if (huge_page_size(h) == PMD_SIZE)
+               return pmd_lockptr(mm, (pmd_t *) pte);
+       VM_BUG_ON(huge_page_size(h) == PAGE_SIZE);
+       return &mm->page_table_lock;
+}
+
+static inline spinlock_t *huge_pte_lock(struct hstate *h,
+               struct mm_struct *mm, pte_t *pte)
+{
+       spinlock_t *ptl;
+       ptl = huge_pte_lockptr(h, mm, pte);
+       spin_lock(ptl);
+       return ptl;
+}
+
 #endif /* _LINUX_HUGETLB_H */
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 8c2a3c3e28..90cc93b2cc 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -24,10 +24,8 @@
 struct address_space;
 
 #define USE_SPLIT_PTE_PTLOCKS	(NR_CPUS >= CONFIG_SPLIT_PTLOCK_CPUS)
-/* hugetlb hasn't converted to split locking yet */
 #define USE_SPLIT_PMD_PTLOCKS	(USE_SPLIT_PTE_PTLOCKS && \
-		IS_ENABLED(CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK) && \
-		!IS_ENABLED(CONFIG_HUGETLB_PAGE))
+		IS_ENABLED(CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK))
 
 /*
  * Each physical page in the system has a struct page associated with
diff --git a/include/linux/swapops.h b/include/linux/swapops.h
index 8d4fa82bfb..ad9f4b2964 100644
--- a/include/linux/swapops.h
+++ b/include/linux/swapops.h
@@ -102,6 +102,8 @@ static inline void *swp_to_radix_entry(swp_entry_t entry)
 	return (void *)(value | RADIX_TREE_EXCEPTIONAL_ENTRY);
 }
 
+struct hstate;
+
 #ifdef CONFIG_MIGRATION
 static inline swp_entry_t make_migration_entry(struct page *page, int write)
 {
@@ -139,7 +141,8 @@ static inline void make_migration_entry_read(swp_entry_t *entry)
 
 extern void migration_entry_wait(struct mm_struct *mm, pmd_t *pmd,
 					unsigned long address);
-extern void migration_entry_wait_huge(struct mm_struct *mm, pte_t *pte);
+extern void migration_entry_wait_huge(struct hstate *hstate,
+		struct mm_struct *mm, pte_t *pte);
 #else
 
 #define make_migration_entry(page, write) swp_entry(0, 0)
@@ -151,8 +154,8 @@ static inline int is_migration_entry(swp_entry_t swp)
 static inline void make_migration_entry_read(swp_entry_t *entryp) { }
 static inline void migration_entry_wait(struct mm_struct *mm, pmd_t *pmd,
 					 unsigned long address) { }
-static inline void migration_entry_wait_huge(struct mm_struct *mm,
-					pte_t *pte) { }
+static inline void migration_entry_wait_huge(struct hstate *hstate,
+		struct mm_struct *mm, pte_t *pte) { }
 static inline int is_write_migration_entry(swp_entry_t entry)
 {
 	return 0;
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index b49579c7f2..50cdeb6cb0 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2361,6 +2361,7 @@ int copy_hugetlb_page_range(struct mm_struct *dst, struct mm_struct *src,
 	cow = (vma->vm_flags & (VM_SHARED | VM_MAYWRITE)) == VM_MAYWRITE;
 
 	for (addr = vma->vm_start; addr < vma->vm_end; addr += sz) {
+		spinlock_t *src_ptl, *dst_ptl;
 		src_pte = huge_pte_offset(src, addr);
 		if (!src_pte)
 			continue;
@@ -2372,8 +2373,9 @@ int copy_hugetlb_page_range(struct mm_struct *dst, struct mm_struct *src,
 		if (dst_pte == src_pte)
 			continue;
 
-		spin_lock(&dst->page_table_lock);
-		spin_lock_nested(&src->page_table_lock, SINGLE_DEPTH_NESTING);
+		dst_ptl = huge_pte_lock(h, dst, dst_pte);
+		src_ptl = huge_pte_lockptr(h, src, src_pte);
+		spin_lock_nested(src_ptl, SINGLE_DEPTH_NESTING);
 		if (!huge_pte_none(huge_ptep_get(src_pte))) {
 			if (cow)
 				huge_ptep_set_wrprotect(src, addr, src_pte);
@@ -2383,8 +2385,8 @@ int copy_hugetlb_page_range(struct mm_struct *dst, struct mm_struct *src,
 			page_dup_rmap(ptepage);
 			set_huge_pte_at(dst, addr, dst_pte, entry);
 		}
-		spin_unlock(&src->page_table_lock);
-		spin_unlock(&dst->page_table_lock);
+		spin_unlock(src_ptl);
+		spin_unlock(dst_ptl);
 	}
 	return 0;
 
@@ -2427,6 +2429,7 @@ void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
 	unsigned long address;
 	pte_t *ptep;
 	pte_t pte;
+	spinlock_t *ptl;
 	struct page *page;
 	struct hstate *h = hstate_vma(vma);
 	unsigned long sz = huge_page_size(h);
@@ -2440,25 +2443,25 @@ void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
 	tlb_start_vma(tlb, vma);
 	mmu_notifier_invalidate_range_start(mm, mmun_start, mmun_end);
 again:
-	spin_lock(&mm->page_table_lock);
 	for (address = start; address < end; address += sz) {
 		ptep = huge_pte_offset(mm, address);
 		if (!ptep)
 			continue;
 
+		ptl = huge_pte_lock(h, mm, ptep);
 		if (huge_pmd_unshare(mm, &address, ptep))
-			continue;
+			goto unlock;
 
 		pte = huge_ptep_get(ptep);
 		if (huge_pte_none(pte))
-			continue;
+			goto unlock;
 
 		/*
 		 * HWPoisoned hugepage is already unmapped and dropped reference
 		 */
 		if (unlikely(is_hugetlb_entry_hwpoisoned(pte))) {
 			huge_pte_clear(mm, address, ptep);
-			continue;
+			goto unlock;
 		}
 
 		page = pte_page(pte);
@@ -2469,7 +2472,7 @@ again:
 		 */
 		if (ref_page) {
 			if (page != ref_page)
-				continue;
+				goto unlock;
 
 			/*
 			 * Mark the VMA as having unmapped its page so that
@@ -2486,13 +2489,18 @@ again:
 
 		page_remove_rmap(page);
 		force_flush = !__tlb_remove_page(tlb, page);
-		if (force_flush)
+		if (force_flush) {
+			spin_unlock(ptl);
 			break;
+		}
 		/* Bail out after unmapping reference page if supplied */
-		if (ref_page)
+		if (ref_page) {
+			spin_unlock(ptl);
 			break;
+		}
+unlock:
+		spin_unlock(ptl);
 	}
-	spin_unlock(&mm->page_table_lock);
 	/*
 	 * mmu_gather ran out of room to batch pages, we break out of
 	 * the PTE lock to avoid doing the potential expensive TLB invalidate
@@ -2598,7 +2606,7 @@ static int unmap_ref_private(struct mm_struct *mm, struct vm_area_struct *vma,
  */
 static int hugetlb_cow(struct mm_struct *mm, struct vm_area_struct *vma,
 			unsigned long address, pte_t *ptep, pte_t pte,
-			struct page *pagecache_page)
+			struct page *pagecache_page, spinlock_t *ptl)
 {
 	struct hstate *h = hstate_vma(vma);
 	struct page *old_page, *new_page;
@@ -2632,8 +2640,8 @@ retry_avoidcopy:
 
 	page_cache_get(old_page);
 
-	/* Drop page_table_lock as buddy allocator may be called */
-	spin_unlock(&mm->page_table_lock);
+	/* Drop page table lock as buddy allocator may be called */
+	spin_unlock(ptl);
 	new_page = alloc_huge_page(vma, address, outside_reserve);
 
 	if (IS_ERR(new_page)) {
@@ -2651,12 +2659,12 @@ retry_avoidcopy:
 			BUG_ON(huge_pte_none(pte));
 			if (unmap_ref_private(mm, vma, old_page, address)) {
 				BUG_ON(huge_pte_none(pte));
-				spin_lock(&mm->page_table_lock);
+				spin_lock(ptl);
 				ptep = huge_pte_offset(mm, address & huge_page_mask(h));
 				if (likely(pte_same(huge_ptep_get(ptep), pte)))
 					goto retry_avoidcopy;
 				/*
-				 * race occurs while re-acquiring page_table_lock, and
+				 * race occurs while re-acquiring page table lock, and
 				 * our job is done.
 				 */
 				return 0;
@@ -2665,7 +2673,7 @@ retry_avoidcopy:
 		}
 
 		/* Caller expects lock to be held */
-		spin_lock(&mm->page_table_lock);
+		spin_lock(ptl);
 		if (err == -ENOMEM)
 			return VM_FAULT_OOM;
 		else
@@ -2680,7 +2688,7 @@ retry_avoidcopy:
 		page_cache_release(new_page);
 		page_cache_release(old_page);
 		/* Caller expects lock to be held */
-		spin_lock(&mm->page_table_lock);
+		spin_lock(ptl);
 		return VM_FAULT_OOM;
 	}
 
@@ -2692,10 +2700,10 @@ retry_avoidcopy:
 	mmun_end = mmun_start + huge_page_size(h);
 	mmu_notifier_invalidate_range_start(mm, mmun_start, mmun_end);
 	/*
-	 * Retake the page_table_lock to check for racing updates
+	 * Retake the page table lock to check for racing updates
 	 * before the page tables are altered
 	 */
-	spin_lock(&mm->page_table_lock);
+	spin_lock(ptl);
 	ptep = huge_pte_offset(mm, address & huge_page_mask(h));
 	if (likely(pte_same(huge_ptep_get(ptep), pte))) {
 		ClearPagePrivate(new_page);
@@ -2709,13 +2717,13 @@ retry_avoidcopy:
 		/* Make the old page be freed below */
 		new_page = old_page;
 	}
-	spin_unlock(&mm->page_table_lock);
+	spin_unlock(ptl);
 	mmu_notifier_invalidate_range_end(mm, mmun_start, mmun_end);
 	page_cache_release(new_page);
 	page_cache_release(old_page);
 
 	/* Caller expects lock to be held */
-	spin_lock(&mm->page_table_lock);
+	spin_lock(ptl);
 	return 0;
 }
 
@@ -2763,6 +2771,7 @@ static int hugetlb_no_page(struct mm_struct *mm, struct vm_area_struct *vma,
 	struct page *page;
 	struct address_space *mapping;
 	pte_t new_pte;
+	spinlock_t *ptl;
 
 	/*
 	 * Currently, we are forced to kill the process in the event the
@@ -2849,7 +2858,8 @@ retry:
 			goto backout_unlocked;
 		}
 
-	spin_lock(&mm->page_table_lock);
+	ptl = huge_pte_lockptr(h, mm, ptep);
+	spin_lock(ptl);
 	size = i_size_read(mapping->host) >> huge_page_shift(h);
 	if (idx >= size)
 		goto backout;
@@ -2870,16 +2880,16 @@ retry:
 
 	if ((flags & FAULT_FLAG_WRITE) && !(vma->vm_flags & VM_SHARED)) {
 		/* Optimization, do the COW without a second fault */
-		ret = hugetlb_cow(mm, vma, address, ptep, new_pte, page);
+		ret = hugetlb_cow(mm, vma, address, ptep, new_pte, page, ptl);
 	}
 
-	spin_unlock(&mm->page_table_lock);
+	spin_unlock(ptl);
 	unlock_page(page);
 out:
 	return ret;
 
 backout:
-	spin_unlock(&mm->page_table_lock);
+	spin_unlock(ptl);
 backout_unlocked:
 	unlock_page(page);
 	put_page(page);
@@ -2891,6 +2901,7 @@ int hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 {
 	pte_t *ptep;
 	pte_t entry;
+	spinlock_t *ptl;
 	int ret;
 	struct page *page = NULL;
 	struct page *pagecache_page = NULL;
@@ -2903,7 +2914,7 @@ int hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 	if (ptep) {
 		entry = huge_ptep_get(ptep);
 		if (unlikely(is_hugetlb_entry_migration(entry))) {
-			migration_entry_wait_huge(mm, ptep);
+			migration_entry_wait_huge(h, mm, ptep);
 			return 0;
 		} else if (unlikely(is_hugetlb_entry_hwpoisoned(entry)))
 			return VM_FAULT_HWPOISON_LARGE |
@@ -2959,17 +2970,18 @@ int hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 	if (page != pagecache_page)
 		lock_page(page);
 
-	spin_lock(&mm->page_table_lock);
+	ptl = huge_pte_lockptr(h, mm, ptep);
+	spin_lock(ptl);
 	/* Check for a racing update before calling hugetlb_cow */
 	if (unlikely(!pte_same(entry, huge_ptep_get(ptep))))
-		goto out_page_table_lock;
+		goto out_ptl;
 
 
 	if (flags & FAULT_FLAG_WRITE) {
 		if (!huge_pte_write(entry)) {
 			ret = hugetlb_cow(mm, vma, address, ptep, entry,
-							pagecache_page);
-			goto out_page_table_lock;
+					pagecache_page, ptl);
+			goto out_ptl;
 		}
 		entry = huge_pte_mkdirty(entry);
 	}
@@ -2978,8 +2990,8 @@ int hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 						flags & FAULT_FLAG_WRITE))
 		update_mmu_cache(vma, address, ptep);
 
-out_page_table_lock:
-	spin_unlock(&mm->page_table_lock);
+out_ptl:
+	spin_unlock(ptl);
 
 	if (pagecache_page) {
 		unlock_page(pagecache_page);
@@ -3005,9 +3017,9 @@ long follow_hugetlb_page(struct mm_struct *mm, struct vm_area_struct *vma,
 	unsigned long remainder = *nr_pages;
 	struct hstate *h = hstate_vma(vma);
 
-	spin_lock(&mm->page_table_lock);
 	while (vaddr < vma->vm_end && remainder) {
 		pte_t *pte;
+		spinlock_t *ptl = NULL;
 		int absent;
 		struct page *page;
 
@@ -3015,8 +3027,12 @@ long follow_hugetlb_page(struct mm_struct *mm, struct vm_area_struct *vma,
 		 * Some archs (sparc64, sh*) have multiple pte_ts to
 		 * each hugepage.  We have to make sure we get the
 		 * first, for the page indexing below to work.
+		 *
+		 * Note that page table lock is not held when pte is null.
 		 */
 		pte = huge_pte_offset(mm, vaddr & huge_page_mask(h));
+		if (pte)
+			ptl = huge_pte_lock(h, mm, pte);
 		absent = !pte || huge_pte_none(huge_ptep_get(pte));
 
 		/*
@@ -3028,6 +3044,8 @@ long follow_hugetlb_page(struct mm_struct *mm, struct vm_area_struct *vma,
 		 */
 		if (absent && (flags & FOLL_DUMP) &&
 		    !hugetlbfs_pagecache_present(h, vma, vaddr)) {
+			if (pte)
+				spin_unlock(ptl);
 			remainder = 0;
 			break;
 		}
@@ -3047,10 +3065,10 @@ long follow_hugetlb_page(struct mm_struct *mm, struct vm_area_struct *vma,
 		      !huge_pte_write(huge_ptep_get(pte)))) {
 			int ret;
 
-			spin_unlock(&mm->page_table_lock);
+			if (pte)
+				spin_unlock(ptl);
 			ret = hugetlb_fault(mm, vma, vaddr,
 				(flags & FOLL_WRITE) ? FAULT_FLAG_WRITE : 0);
-			spin_lock(&mm->page_table_lock);
 			if (!(ret & VM_FAULT_ERROR))
 				continue;
 
@@ -3081,8 +3099,8 @@ same_page:
 			 */
 			goto same_page;
 		}
+		spin_unlock(ptl);
 	}
-	spin_unlock(&mm->page_table_lock);
 	*nr_pages = remainder;
 	*position = vaddr;
 
@@ -3103,13 +3121,15 @@ unsigned long hugetlb_change_protection(struct vm_area_struct *vma,
 	flush_cache_range(vma, address, end);
 
 	mutex_lock(&vma->vm_file->f_mapping->i_mmap_mutex);
-	spin_lock(&mm->page_table_lock);
 	for (; address < end; address += huge_page_size(h)) {
+		spinlock_t *ptl;
 		ptep = huge_pte_offset(mm, address);
 		if (!ptep)
 			continue;
+		ptl = huge_pte_lock(h, mm, ptep);
 		if (huge_pmd_unshare(mm, &address, ptep)) {
 			pages++;
+			spin_unlock(ptl);
 			continue;
 		}
 		if (!huge_pte_none(huge_ptep_get(ptep))) {
@@ -3119,8 +3139,8 @@ unsigned long hugetlb_change_protection(struct vm_area_struct *vma,
 			set_huge_pte_at(mm, address, ptep, pte);
 			pages++;
 		}
+		spin_unlock(ptl);
 	}
-	spin_unlock(&mm->page_table_lock);
 	/*
 	 * Must flush TLB before releasing i_mmap_mutex: x86's huge_pmd_unshare
 	 * may have cleared our pud entry and done put_page on the page table:
@@ -3283,6 +3303,7 @@ pte_t *huge_pmd_share(struct mm_struct *mm, unsigned long addr, pud_t *pud)
 	unsigned long saddr;
 	pte_t *spte = NULL;
 	pte_t *pte;
+	spinlock_t *ptl;
 
 	if (!vma_shareable(vma, addr))
 		return (pte_t *)pmd_alloc(mm, pud, addr);
@@ -3305,13 +3326,14 @@ pte_t *huge_pmd_share(struct mm_struct *mm, unsigned long addr, pud_t *pud)
 	if (!spte)
 		goto out;
 
-	spin_lock(&mm->page_table_lock);
+	ptl = huge_pte_lockptr(hstate_vma(vma), mm, spte);
+	spin_lock(ptl);
 	if (pud_none(*pud))
 		pud_populate(mm, pud,
 				(pmd_t *)((unsigned long)spte & PAGE_MASK));
 	else
 		put_page(virt_to_page(spte));
-	spin_unlock(&mm->page_table_lock);
+	spin_unlock(ptl);
 out:
 	pte = (pte_t *)pmd_alloc(mm, pud, addr);
 	mutex_unlock(&mapping->i_mmap_mutex);
@@ -3325,7 +3347,7 @@ out:
  * indicated by page_count > 1, unmap is achieved by clearing pud and
  * decrementing the ref count. If count == 1, the pte page is not shared.
  *
- * called with vma->vm_mm->page_table_lock held.
+ * called with page table lock held.
  *
  * returns: 1 successfully unmapped a shared pte page
  *	    0 the underlying pte page is not shared, or it is the last user
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 04729647f3..930a3e64bd 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -525,8 +525,9 @@ static void queue_pages_hugetlb_pmd_range(struct vm_area_struct *vma,
 #ifdef CONFIG_HUGETLB_PAGE
 	int nid;
 	struct page *page;
+	spinlock_t *ptl;
 
-	spin_lock(&vma->vm_mm->page_table_lock);
+	ptl = huge_pte_lock(hstate_vma(vma), vma->vm_mm, (pte_t *)pmd);
 	page = pte_page(huge_ptep_get((pte_t *)pmd));
 	nid = page_to_nid(page);
 	if (node_isset(nid, *nodes) == !!(flags & MPOL_MF_INVERT))
@@ -536,7 +537,7 @@ static void queue_pages_hugetlb_pmd_range(struct vm_area_struct *vma,
 	    (flags & MPOL_MF_MOVE && page_mapcount(page) == 1))
 		isolate_huge_page(page, private);
 unlock:
-	spin_unlock(&vma->vm_mm->page_table_lock);
+	spin_unlock(ptl);
 #else
 	BUG();
 #endif
diff --git a/mm/migrate.c b/mm/migrate.c
index af71f53246..12bf3b8216 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -130,7 +130,7 @@ static int remove_migration_pte(struct page *new, struct vm_area_struct *vma,
 		ptep = huge_pte_offset(mm, addr);
 		if (!ptep)
 			goto out;
-		ptl = &mm->page_table_lock;
+		ptl = huge_pte_lockptr(hstate_vma(vma), mm, ptep);
 	} else {
 		pmd = mm_find_pmd(mm, addr);
 		if (!pmd)
@@ -247,9 +247,10 @@ void migration_entry_wait(struct mm_struct *mm, pmd_t *pmd,
 	__migration_entry_wait(mm, ptep, ptl);
 }
 
-void migration_entry_wait_huge(struct mm_struct *mm, pte_t *pte)
+void migration_entry_wait_huge(struct hstate *h,
+		struct mm_struct *mm, pte_t *pte)
 {
-	spinlock_t *ptl = &(mm)->page_table_lock;
+	spinlock_t *ptl = huge_pte_lockptr(h, mm, pte);
 	__migration_entry_wait(mm, pte, ptl);
 }
 
diff --git a/mm/rmap.c b/mm/rmap.c
index b59d741dcf..55c8b8dc9f 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -601,7 +601,7 @@ pte_t *__page_check_address(struct page *page, struct mm_struct *mm,
 
 	if (unlikely(PageHuge(page))) {
 		pte = huge_pte_offset(mm, address);
-		ptl = &mm->page_table_lock;
+		ptl = huge_pte_lockptr(page_hstate(page), mm, pte);
 		goto check;
 	}
 
-- 
 Kirill A. Shutemov
