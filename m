Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934207AbaGYTpV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 15:45:21 -0400
Received: from mga11.intel.com ([192.55.52.93]:57140 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761147AbaGYTpS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 15:45:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,732,1400050800"; 
   d="c'?scan'208,223";a="575531957"
Date: Fri, 25 Jul 2014 15:44:50 -0400
From: Matthew Wilcox <willy@linux.intel.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 05/22] Add vm_replace_mixed()
Message-ID: <20140725194450.GJ6754@linux.intel.com>
References: <cover.1406058387.git.matthew.r.wilcox@intel.com>
 <b1052af08b49965fd0e6b87b6733b89294c8cc1e.1406058387.git.matthew.r.wilcox@intel.com>
 <20140723114540.GD10317@node.dhcp.inet.fi>
 <20140723135221.GA6754@linux.intel.com>
 <20140723142048.GA11963@node.dhcp.inet.fi>
 <20140723142745.GD6754@linux.intel.com>
 <20140723155500.GA12790@node.dhcp.inet.fi>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="NU0Ex4SbNnrxsi6C"
Content-Disposition: inline
In-Reply-To: <20140723155500.GA12790@node.dhcp.inet.fi>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NU0Ex4SbNnrxsi6C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 23, 2014 at 06:55:00PM +0300, Kirill A. Shutemov wrote:
> >         update_hiwater_rss(mm);
> 
> No: you cannot end up with lower rss after replace, iiuc.

Actually, you can ... when we replace a real page with a PFN, our rss
decreases.

> Do you mean you pointed to new file all the time? O_CREAT doesn't truncate
> file if it exists, iirc.

It was pointing to a new file.  Still not sure why that one failed to trigger
the problem.  The slightly modified version attached triggered the problem
*just fine* :-)

I've attached all the patches in my tree so far.  For the v9 patch kit,
I'll keep patch 3 as a separate patch, but roll patches 1, 2 and 4 into
other patches.

I am seeing something odd though.  When I run double-map with debugging
printks inserted in strategic spots in the kernel, I see four calls to
do_dax_fault().  The first two, as expected, are the loads from the two
mapped addresses.  The third is via mkwrite, but then the fourth time
I get a regular page fault for write, and I don't understand why I get it.

Any ideas?


[  880.966632] do_dax_fault: fault a8 page =           (null) bh state 0 written
 0 addr 7ff598835000
[  880.966637] dax_load_hole: page = ffffea0002784730
[  882.114387] do_dax_fault: fault a8 page = ffffea0002784730 bh state 0 written 0 addr 7ff598834000
[  882.114389] dax_load_hole: page = ffffea0002784730
[  882.780013] do_dax_fault: fault 5 page = ffffea0002784730 bh state 0 written 0 addr 7ff598835000
[  882.780095] insert_pfn: pte = 8000000108200225
[  882.780096] do_dax_fault: page = ffffea0002784730 pfn = 108200 error = 0
[  882.780098] CPU: 1 PID: 1511 Comm: double-map Not tainted 3.16.0-rc6+ #89
[  882.780099] Hardware name: Gigabyte Technology Co., Ltd. To be filled by O.E.M./Q87M-D2H, BIOS F6 08/03/2013
[  882.780100]  0000000000000000 ffff8800b41e3ba0 ffffffff815c6e73 ffffea0002784730
[  882.780102]  ffff8800b41e3c88 ffffffff8124c319 00007ff598835000 ffff8800b2436ac0
[  882.780104]  0000000000000005 ffffffffa01e3020 0000000000000004 ffff880000000005
[  882.780106] Call Trace:
[  882.780110]  [<ffffffff815c6e73>] dump_stack+0x4d/0x66
[  882.780114]  [<ffffffff8124c319>] do_dax_fault+0x569/0x6f0
[  882.780133]  [<ffffffff8124c4df>] dax_fault+0x3f/0x90
[  882.780136]  [<ffffffff81023b2e>] ? native_sched_clock+0x2e/0xb0
[  882.780137]  [<ffffffff8124c53e>] dax_mkwrite+0xe/0x10
[  882.780143]  [<ffffffffa01db955>] ext4_dax_mkwrite+0x15/0x20 [ext4]
[  882.780146]  [<ffffffff811ab627>] do_page_mkwrite+0x47/0xb0
[  882.780148]  [<ffffffff811ad7f2>] do_wp_page+0x6e2/0x990
[  882.780150]  [<ffffffff811aff1b>] handle_mm_fault+0x6ab/0xf70
[  882.780154]  [<ffffffff81062d2c>] __do_page_fault+0x1ec/0x5b0
[  882.780163]  [<ffffffff81063112>] do_page_fault+0x22/0x30
[  882.780165]  [<ffffffff815d1b78>] page_fault+0x28/0x30
[  882.780204] do_dax_fault: fault a9 page =           (null) bh state 20 written 1 addr 7ff598835000
[  882.780206] insert_pfn: pte = 8000000108200225
[  882.780207] do_dax_fault: page =           (null) pfn = 108200 error = 0
[  882.780208] CPU: 1 PID: 1511 Comm: double-map Not tainted 3.16.0-rc6+ #89
[  882.780208] Hardware name: Gigabyte Technology Co., Ltd. To be filled by O.E.M./Q87M-D2H, BIOS F6 08/03/2013
[  882.780209]  0000000000000000 ffff8800b41e3bc0 ffffffff815c6e73 0000000000000000
[  882.780211]  ffff8800b41e3ca8 ffffffff8124c319 00007ff598835000 ffff8800b41e3c08
[  882.780213]  ffff8800a2a60608 ffffffffa01e3020 0000000000000000 ffff8800000000a9
[  882.780214] Call Trace:
[  882.780216]  [<ffffffff815c6e73>] dump_stack+0x4d/0x66
[  882.780218]  [<ffffffff8124c319>] do_dax_fault+0x569/0x6f0
[  882.780232]  [<ffffffff8124c4df>] dax_fault+0x3f/0x90
[  882.780238]  [<ffffffffa01db975>] ext4_dax_fault+0x15/0x20 [ext4]
[  882.780240]  [<ffffffff811ab6d1>] __do_fault+0x41/0xd0
[  882.780241]  [<ffffffff811ae8a5>] do_shared_fault.isra.56+0x35/0x220
[  882.780243]  [<ffffffff811afb73>] handle_mm_fault+0x303/0xf70
[  882.780246]  [<ffffffff81062d2c>] __do_page_fault+0x1ec/0x5b0
[  882.780254]  [<ffffffff81063112>] do_page_fault+0x22/0x30
[  882.780255]  [<ffffffff815d1b78>] page_fault+0x28/0x30


diff --git a/fs/dax.c b/fs/dax.c
index b4fdfd9..4b0f928 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -257,6 +257,7 @@ static int dax_load_hole(struct address_space *mapping, struct page *page,
 	if (!page)
 		page = find_or_create_page(mapping, vmf->pgoff,
 						GFP_KERNEL | __GFP_ZERO);
+printk("%s: page = %p\n", __func__, page);
 	if (!page)
 		return VM_FAULT_OOM;
 	/* Recheck i_size under page lock to avoid truncate race */
@@ -332,6 +333,7 @@ static int do_dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
 	if (error || bh.b_size < PAGE_SIZE)
 		goto sigbus;
 
+printk("%s: fault %x page = %p bh state %lx written %d addr %lx\n", __func__, vmf->flags, page, bh.b_state, buffer_written(&bh), vaddr);
 	if (!buffer_written(&bh) && !vmf->cow_page) {
 		if (vmf->flags & FAULT_FLAG_WRITE) {
 			error = get_block(inode, block, &bh, 1);
@@ -372,6 +374,8 @@ static int do_dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
 	error = dax_get_pfn(&bh, &pfn, blkbits);
 	if (error > 0)
 		error = vm_replace_mixed(vma, vaddr, pfn);
+printk("%s: page = %p pfn = %lx error = %d\n", __func__, page, pfn, error);
+if ((vmf->flags & FAULT_FLAG_WRITE) || !(vmf->flags & FAULT_FLAG_USER)) dump_stack();
 
 	if (!page) {
 		mutex_unlock(&mapping->i_mmap_mutex);
diff --git a/mm/memory.c b/mm/memory.c
index a8e17ce..189716c 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1614,6 +1614,7 @@ static int insert_pfn(struct vm_area_struct *vma, unsigned long addr,
 	/* Ok, finally just insert the thing.. */
 	entry = pte_mkspecial(pfn_pte(pfn, prot));
 	set_pte_at(mm, addr, pte, entry);
+printk("%s: pte = %llx\n", __func__, pte_val(entry));
 	update_mmu_cache(vma, addr, pte); /* XXX: why not for insert_page? */
 
 	retval = 0;

--NU0Ex4SbNnrxsi6C
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-dax-Only-unlock-the-i_mmap_mutex-if-we-locked-it.patch"

>From 9f68c0a856b86dbd109be3b95427cd69bec8330d Mon Sep 17 00:00:00 2001
From: Matthew Wilcox <willy@linux.intel.com>
Date: Fri, 25 Jul 2014 09:43:15 -0400
Subject: [PATCH 1/4] dax: Only unlock the i_mmap_mutex if we locked it

The second time we faulted on a hole, we would try to unlock the
i_mmap_mutex, even though we weren't holding it.  Oops.
---
 fs/dax.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/dax.c b/fs/dax.c
index 39b95b1..a65a0f9 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -341,7 +341,8 @@ static int do_dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
 			if (error || bh.b_size < PAGE_SIZE)
 				goto sigbus;
 		} else {
-			mutex_unlock(&mapping->i_mmap_mutex);
+			if (!page)
+				mutex_unlock(&mapping->i_mmap_mutex);
 			return dax_load_hole(mapping, page, vmf);
 		}
 	}
-- 
2.0.1


--NU0Ex4SbNnrxsi6C
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0002-dax-Call-delete_from_page_cache-after-unmap_mapping_.patch"

>From 4c68125c7557a2a61ba83167ee6a9ff44fdeee89 Mon Sep 17 00:00:00 2001
From: Matthew Wilcox <willy@linux.intel.com>
Date: Fri, 25 Jul 2014 09:44:32 -0400
Subject: [PATCH 2/4] dax: Call delete_from_page_cache() after
 unmap_mapping_range()

delete_from_page_cache() checks that the page is already unmapped
from everywhere, so we should unmap it from everywhere before we
delete it.  This matches the call sequence in mm/truncate.c.
---
 fs/dax.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/dax.c b/fs/dax.c
index a65a0f9..b4fdfd9 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -383,9 +383,9 @@ static int do_dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
 	}
 
 	if (page) {
-		delete_from_page_cache(page);
 		unmap_mapping_range(mapping, vmf->pgoff << PAGE_SHIFT,
 							PAGE_CACHE_SIZE, 0);
+		delete_from_page_cache(page);
 		unlock_page(page);
 		page_cache_release(page);
 	}
-- 
2.0.1


--NU0Ex4SbNnrxsi6C
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0003-Factor-zap_pte-out-of-zap_pte_range.patch"

>From 60a90d68474bca2afc7e93517169769f4e028962 Mon Sep 17 00:00:00 2001
From: Matthew Wilcox <willy@linux.intel.com>
Date: Fri, 25 Jul 2014 09:46:01 -0400
Subject: [PATCH 3/4] Factor zap_pte() out of zap_pte_range()

zap_pte() can be called while holding the PTE lock, which is important for
a follow-on patch.  This patch should *only* move code into a separate
function; other changes to make zap_pte() usable are in subsequent
patches.
---
 mm/memory.c | 190 ++++++++++++++++++++++++++++++++----------------------------
 1 file changed, 101 insertions(+), 89 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index cf06c97..6a35f98 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1071,6 +1071,105 @@ int copy_page_range(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 	return ret;
 }
 
+/* Returns true to break out of the loop */
+static bool zap_pte(struct mmu_gather *tlb, struct vm_area_struct *vma,
+				pte_t *pte, unsigned long addr,
+				struct zap_details *details, int *rss,
+				int *force_flush)
+{
+	struct mm_struct *mm = tlb->mm;
+	pte_t ptent = *pte;
+
+	if (pte_none(ptent))
+		return false;
+
+	if (pte_present(ptent)) {
+		struct page *page;
+
+		page = vm_normal_page(vma, addr, ptent);
+		if (unlikely(details) && page) {
+			/*
+			 * unmap_shared_mapping_pages() wants to
+			 * invalidate cache without truncating:
+			 * unmap shared but keep private pages.
+			 */
+			if (details->check_mapping &&
+			    details->check_mapping != page->mapping)
+				return false;
+			/*
+			 * Each page->index must be checked when
+			 * invalidating or truncating nonlinear.
+			 */
+			if (details->nonlinear_vma &&
+			    (page->index < details->first_index ||
+			     page->index > details->last_index))
+				return false;
+		}
+		ptent = ptep_get_and_clear_full(mm, addr, pte,
+						tlb->fullmm);
+		tlb_remove_tlb_entry(tlb, pte, addr);
+		if (unlikely(!page))
+			return false;
+		if (unlikely(details) && details->nonlinear_vma
+		    && linear_page_index(details->nonlinear_vma,
+					addr) != page->index) {
+			pte_t ptfile = pgoff_to_pte(page->index);
+			if (pte_soft_dirty(ptent))
+				pte_file_mksoft_dirty(ptfile);
+			set_pte_at(mm, addr, pte, ptfile);
+		}
+		if (PageAnon(page))
+			rss[MM_ANONPAGES]--;
+		else {
+			if (pte_dirty(ptent)) {
+				*force_flush = 1;
+				set_page_dirty(page);
+			}
+			if (pte_young(ptent) &&
+			    likely(!(vma->vm_flags & VM_SEQ_READ)))
+				mark_page_accessed(page);
+			rss[MM_FILEPAGES]--;
+		}
+		page_remove_rmap(page);
+		if (unlikely(page_mapcount(page) < 0))
+			print_bad_pte(vma, addr, ptent, page);
+		if (unlikely(!__tlb_remove_page(tlb, page))) {
+			*force_flush = 1;
+			return true;
+		}
+		return false;
+	}
+	/*
+	 * If details->check_mapping, we leave swap entries;
+	 * if details->nonlinear_vma, we leave file entries.
+	 */
+	if (unlikely(details))
+		return false;
+	if (pte_file(ptent)) {
+		if (unlikely(!(vma->vm_flags & VM_NONLINEAR)))
+			print_bad_pte(vma, addr, ptent, NULL);
+	} else {
+		swp_entry_t entry = pte_to_swp_entry(ptent);
+
+		if (!non_swap_entry(entry))
+			rss[MM_SWAPENTS]--;
+		else if (is_migration_entry(entry)) {
+			struct page *page;
+
+			page = migration_entry_to_page(entry);
+
+			if (PageAnon(page))
+				rss[MM_ANONPAGES]--;
+			else
+				rss[MM_FILEPAGES]--;
+		}
+		if (unlikely(!free_swap_and_cache(entry)))
+			print_bad_pte(vma, addr, ptent, NULL);
+	}
+	pte_clear_not_present_full(mm, addr, pte, tlb->fullmm);
+	return false;
+}
+
 static unsigned long zap_pte_range(struct mmu_gather *tlb,
 				struct vm_area_struct *vma, pmd_t *pmd,
 				unsigned long addr, unsigned long end,
@@ -1089,95 +1188,8 @@ again:
 	pte = start_pte;
 	arch_enter_lazy_mmu_mode();
 	do {
-		pte_t ptent = *pte;
-		if (pte_none(ptent)) {
-			continue;
-		}
-
-		if (pte_present(ptent)) {
-			struct page *page;
-
-			page = vm_normal_page(vma, addr, ptent);
-			if (unlikely(details) && page) {
-				/*
-				 * unmap_shared_mapping_pages() wants to
-				 * invalidate cache without truncating:
-				 * unmap shared but keep private pages.
-				 */
-				if (details->check_mapping &&
-				    details->check_mapping != page->mapping)
-					continue;
-				/*
-				 * Each page->index must be checked when
-				 * invalidating or truncating nonlinear.
-				 */
-				if (details->nonlinear_vma &&
-				    (page->index < details->first_index ||
-				     page->index > details->last_index))
-					continue;
-			}
-			ptent = ptep_get_and_clear_full(mm, addr, pte,
-							tlb->fullmm);
-			tlb_remove_tlb_entry(tlb, pte, addr);
-			if (unlikely(!page))
-				continue;
-			if (unlikely(details) && details->nonlinear_vma
-			    && linear_page_index(details->nonlinear_vma,
-						addr) != page->index) {
-				pte_t ptfile = pgoff_to_pte(page->index);
-				if (pte_soft_dirty(ptent))
-					pte_file_mksoft_dirty(ptfile);
-				set_pte_at(mm, addr, pte, ptfile);
-			}
-			if (PageAnon(page))
-				rss[MM_ANONPAGES]--;
-			else {
-				if (pte_dirty(ptent)) {
-					force_flush = 1;
-					set_page_dirty(page);
-				}
-				if (pte_young(ptent) &&
-				    likely(!(vma->vm_flags & VM_SEQ_READ)))
-					mark_page_accessed(page);
-				rss[MM_FILEPAGES]--;
-			}
-			page_remove_rmap(page);
-			if (unlikely(page_mapcount(page) < 0))
-				print_bad_pte(vma, addr, ptent, page);
-			if (unlikely(!__tlb_remove_page(tlb, page))) {
-				force_flush = 1;
-				break;
-			}
-			continue;
-		}
-		/*
-		 * If details->check_mapping, we leave swap entries;
-		 * if details->nonlinear_vma, we leave file entries.
-		 */
-		if (unlikely(details))
-			continue;
-		if (pte_file(ptent)) {
-			if (unlikely(!(vma->vm_flags & VM_NONLINEAR)))
-				print_bad_pte(vma, addr, ptent, NULL);
-		} else {
-			swp_entry_t entry = pte_to_swp_entry(ptent);
-
-			if (!non_swap_entry(entry))
-				rss[MM_SWAPENTS]--;
-			else if (is_migration_entry(entry)) {
-				struct page *page;
-
-				page = migration_entry_to_page(entry);
-
-				if (PageAnon(page))
-					rss[MM_ANONPAGES]--;
-				else
-					rss[MM_FILEPAGES]--;
-			}
-			if (unlikely(!free_swap_and_cache(entry)))
-				print_bad_pte(vma, addr, ptent, NULL);
-		}
-		pte_clear_not_present_full(mm, addr, pte, tlb->fullmm);
+		if (zap_pte(tlb, vma, pte, addr, details, rss, &force_flush))
+			break;
 	} while (pte++, addr += PAGE_SIZE, addr != end);
 
 	add_mm_rss_vec(mm, rss);
-- 
2.0.1


--NU0Ex4SbNnrxsi6C
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0004-mm-Introduce-zap_pte_single.patch"

>From 50c81e697f68aba7362dbf77b9017f8bba666e17 Mon Sep 17 00:00:00 2001
From: Matthew Wilcox <willy@linux.intel.com>
Date: Fri, 25 Jul 2014 15:10:12 -0400
Subject: [PATCH 4/4] mm: Introduce zap_pte_single()

zap_pte_single() is a new wrapper around zap_pte() that does all the
necessary setup for insert_pte() and insert_page().
---
 mm/memory.c | 44 ++++++++++++++++++++++++++++++++++----------
 1 file changed, 34 insertions(+), 10 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 6a35f98..a8e17ce 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1077,7 +1077,8 @@ static bool zap_pte(struct mmu_gather *tlb, struct vm_area_struct *vma,
 				struct zap_details *details, int *rss,
 				int *force_flush)
 {
-	struct mm_struct *mm = tlb->mm;
+	struct mm_struct *mm = tlb ? tlb->mm : vma->vm_mm;
+	bool fullmm = tlb ? tlb->fullmm : false;
 	pte_t ptent = *pte;
 
 	if (pte_none(ptent))
@@ -1105,9 +1106,9 @@ static bool zap_pte(struct mmu_gather *tlb, struct vm_area_struct *vma,
 			     page->index > details->last_index))
 				return false;
 		}
-		ptent = ptep_get_and_clear_full(mm, addr, pte,
-						tlb->fullmm);
-		tlb_remove_tlb_entry(tlb, pte, addr);
+		ptent = ptep_get_and_clear_full(mm, addr, pte, fullmm);
+		if (tlb)
+			tlb_remove_tlb_entry(tlb, pte, addr);
 		if (unlikely(!page))
 			return false;
 		if (unlikely(details) && details->nonlinear_vma
@@ -1133,7 +1134,7 @@ static bool zap_pte(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		page_remove_rmap(page);
 		if (unlikely(page_mapcount(page) < 0))
 			print_bad_pte(vma, addr, ptent, page);
-		if (unlikely(!__tlb_remove_page(tlb, page))) {
+		if (unlikely(tlb && !__tlb_remove_page(tlb, page))) {
 			*force_flush = 1;
 			return true;
 		}
@@ -1166,10 +1167,27 @@ static bool zap_pte(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		if (unlikely(!free_swap_and_cache(entry)))
 			print_bad_pte(vma, addr, ptent, NULL);
 	}
-	pte_clear_not_present_full(mm, addr, pte, tlb->fullmm);
+	pte_clear_not_present_full(mm, addr, pte, fullmm);
 	return false;
 }
 
+static void zap_pte_single(struct vm_area_struct *vma, pte_t *pte,
+				unsigned long addr)
+{
+	struct mm_struct *mm = vma->vm_mm;
+	int force_flush = 0;
+	int rss[NR_MM_COUNTERS];
+
+	VM_BUG_ON(!mutex_is_locked(&vma->vm_file->f_mapping->i_mmap_mutex));
+
+	init_rss_vec(rss);
+	update_hiwater_rss(mm);
+	flush_cache_page(vma, addr, pte_pfn(*pte));
+	zap_pte(NULL, vma, pte, addr, NULL, rss, &force_flush);
+	flush_tlb_page(vma, addr);
+	add_mm_rss_vec(mm, rss);
+}
+
 static unsigned long zap_pte_range(struct mmu_gather *tlb,
 				struct vm_area_struct *vma, pmd_t *pmd,
 				unsigned long addr, unsigned long end,
@@ -1494,6 +1512,7 @@ static int insert_page(struct vm_area_struct *vma, unsigned long addr,
 	int retval;
 	pte_t *pte;
 	spinlock_t *ptl;
+	bool replaced = false;
 
 	retval = -EINVAL;
 	if (PageAnon(page))
@@ -1507,8 +1526,8 @@ static int insert_page(struct vm_area_struct *vma, unsigned long addr,
 	if (!pte_none(*pte)) {
 		if (!replace)
 			goto out_unlock;
-		VM_BUG_ON(!mutex_is_locked(&vma->vm_file->f_mapping->i_mmap_mutex));
-		zap_page_range_single(vma, addr, PAGE_SIZE, NULL);
+		zap_pte_single(vma, pte, addr);
+		replaced = true;
 	}
 
 	/* Ok, finally just insert the thing.. */
@@ -1519,6 +1538,8 @@ static int insert_page(struct vm_area_struct *vma, unsigned long addr,
 
 	retval = 0;
 	pte_unmap_unlock(pte, ptl);
+	if (replaced)
+		mmu_notifier_invalidate_page(mm, addr);
 	return retval;
 out_unlock:
 	pte_unmap_unlock(pte, ptl);
@@ -1576,6 +1597,7 @@ static int insert_pfn(struct vm_area_struct *vma, unsigned long addr,
 	int retval;
 	pte_t *pte, entry;
 	spinlock_t *ptl;
+	bool replaced = false;
 
 	retval = -ENOMEM;
 	pte = get_locked_pte(mm, addr, &ptl);
@@ -1585,8 +1607,8 @@ static int insert_pfn(struct vm_area_struct *vma, unsigned long addr,
 	if (!pte_none(*pte)) {
 		if (!replace)
 			goto out_unlock;
-		VM_BUG_ON(!mutex_is_locked(&vma->vm_file->f_mapping->i_mmap_mutex));
-		zap_page_range_single(vma, addr, PAGE_SIZE, NULL);
+		zap_pte_single(vma, pte, addr);
+		replaced = true;
 	}
 
 	/* Ok, finally just insert the thing.. */
@@ -1597,6 +1619,8 @@ static int insert_pfn(struct vm_area_struct *vma, unsigned long addr,
 	retval = 0;
 out_unlock:
 	pte_unmap_unlock(pte, ptl);
+	if (replaced)
+		mmu_notifier_invalidate_page(mm, addr);
 out:
 	return retval;
 }
-- 
2.0.1


--NU0Ex4SbNnrxsi6C
Content-Type: text/x-csrc; charset=us-ascii
Content-Disposition: attachment; filename="double-map.c"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <unistd.h>
#include <errno.h>

int
main(int argc, char *argv[])
{
	int fd;
	void *addr, *addr2;
	char buf[4096];

	if (argc != 2) {
		fprintf(stderr, "usage: %s filename\n", argv[0]);
		exit(1);
	}

	if ((fd = open(argv[1], O_CREAT|O_RDWR, 0666)) < 0) {
		perror(argv[1]);
		exit(1);
	}

	if (ftruncate(fd, 4096) < 0) {
		perror("ftruncate");
		exit(1);
	}

	if ((addr = mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_SHARED,
					fd, 0)) == MAP_FAILED) {
		perror("mmap");
		exit(1);
	}

	if ((addr2 = mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_SHARED,
					fd, 0)) == MAP_FAILED) {
		perror("mmap");
		exit(1);
	}

printf("addr = %p addr2 = %p\n", addr, addr2);

	close(fd);

	/* first read */
	memcpy(buf, addr, 2048);

getc(stdin);

	/* second read */
	memcpy(buf + 2048, addr2, 2048);

getc(stdin);

	/* now write a bit */
	memcpy(addr, buf, 8);

	printf("%s: test passed.\n", argv[0]);
	exit(0);
}

--NU0Ex4SbNnrxsi6C--
