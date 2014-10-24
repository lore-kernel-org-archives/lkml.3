Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933251AbaJXWhN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 18:37:13 -0400
Received: from smtp2.provo.novell.com ([137.65.250.81]:57363 "EHLO
	smtp2.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932332AbaJXWhK (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Fri, 24 Oct 2014 18:37:10 -0400
X-Greylist: delayed 1218 seconds by postgrey-1.27 at vger.kernel.org; Fri, 24 Oct 2014 18:37:10 EDT
Message-ID: <1414188985.17641.2.camel@linux-t7sj.site>
Subject: [PATCH 10/10] mm/hugetlb: share the i_mmap_rwsem
From: Davidlohr Bueso <dbueso@suse.com>
To: akpm@linux-foundation.org
Cc: hughd@google.com, riel@redhat.com, mgorman@suse.de, peterz@infradead.org,
        mingo@kernel.org, dbueso@suse.de, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Davidlohr Bueso <dave@stgolabs.net>
Date: Fri, 24 Oct 2014 15:16:25 -0700
In-Reply-To: <1414188380-17376-1-git-send-email-dave@stgolabs.net>
References: <1414188380-17376-1-git-send-email-dave@stgolabs.net>
Organization: SUSE Labs
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davidlohr Bueso <dave@stgolabs.net>

The i_mmap_rwsem protects shared pages against races
when doing the sharing and unsharing, ultimately
calling huge_pmd_share/unshare() for PMD pages --
it also needs it to avoid races when populating the pud
for pmd allocation when looking for a shareable pmd page
for hugetlb. Ultimately the interval tree remains intact.

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
---
Resending this patch due to stupid email quota rules, *sigh*

 fs/hugetlbfs/inode.c |  4 ++--
 mm/hugetlb.c         | 12 ++++++------
 mm/memory.c          |  4 ++--
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 5eba47f..0dca54d 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -412,10 +412,10 @@ static int hugetlb_vmtruncate(struct inode *inode, loff_t offset)
 	pgoff = offset >> PAGE_SHIFT;
 
 	i_size_write(inode, offset);
-	i_mmap_lock_write(mapping);
+	i_mmap_lock_read(mapping);
 	if (!RB_EMPTY_ROOT(&mapping->i_mmap))
 		hugetlb_vmtruncate_list(&mapping->i_mmap, pgoff);
-	i_mmap_unlock_write(mapping);
+	i_mmap_unlock_read(mapping);
 	truncate_hugepages(inode, offset);
 	return 0;
 }
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 7eeab54..f68dd21 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2772,7 +2772,7 @@ static void unmap_ref_private(struct mm_struct *mm, struct vm_area_struct *vma,
 	 * this mapping should be shared between all the VMAs,
 	 * __unmap_hugepage_range() is called as the lock is already held
 	 */
-	i_mmap_lock_write(mapping);
+	i_mmap_lock_read(mapping);
 	vma_interval_tree_foreach(iter_vma, &mapping->i_mmap, pgoff, pgoff) {
 		/* Do not unmap the current VMA */
 		if (iter_vma == vma)
@@ -2789,7 +2789,7 @@ static void unmap_ref_private(struct mm_struct *mm, struct vm_area_struct *vma,
 			unmap_hugepage_range(iter_vma, address,
 					     address + huge_page_size(h), page);
 	}
-	i_mmap_unlock_write(mapping);
+	i_mmap_unlock_read(mapping);
 }
 
 /*
@@ -3346,7 +3346,7 @@ unsigned long hugetlb_change_protection(struct vm_area_struct *vma,
 	flush_cache_range(vma, address, end);
 
 	mmu_notifier_invalidate_range_start(mm, start, end);
-	i_mmap_lock_write(vma->vm_file->f_mapping);
+	i_mmap_lock_read(vma->vm_file->f_mapping);
 	for (; address < end; address += huge_page_size(h)) {
 		spinlock_t *ptl;
 		ptep = huge_pte_offset(mm, address);
@@ -3374,7 +3374,7 @@ unsigned long hugetlb_change_protection(struct vm_area_struct *vma,
 	 * and that page table be reused and filled with junk.
 	 */
 	flush_tlb_range(vma, start, end);
-	i_mmap_unlock_write(vma->vm_file->f_mapping);
+	i_mmap_unlock_read(vma->vm_file->f_mapping);
 	mmu_notifier_invalidate_range_end(mm, start, end);
 
 	return pages << h->order;
@@ -3542,7 +3542,7 @@ pte_t *huge_pmd_share(struct mm_struct *mm, unsigned long addr, pud_t *pud)
 	if (!vma_shareable(vma, addr))
 		return (pte_t *)pmd_alloc(mm, pud, addr);
 
-	i_mmap_lock_write(mapping);
+	i_mmap_lock_read(mapping);
 	vma_interval_tree_foreach(svma, &mapping->i_mmap, idx, idx) {
 		if (svma == vma)
 			continue;
@@ -3570,7 +3570,7 @@ pte_t *huge_pmd_share(struct mm_struct *mm, unsigned long addr, pud_t *pud)
 	spin_unlock(ptl);
 out:
 	pte = (pte_t *)pmd_alloc(mm, pud, addr);
-	i_mmap_unlock_write(mapping);
+	i_mmap_unlock_read(mapping);
 	return pte;
 }
 
diff --git a/mm/memory.c b/mm/memory.c
index d16c662..b1931c1 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1339,9 +1339,9 @@ static void unmap_single_vma(struct mmu_gather *tlb,
 			 * safe to do nothing in this case.
 			 */
 			if (vma->vm_file) {
-				i_mmap_lock_write(vma->vm_file->f_mapping);
+				i_mmap_lock_read(vma->vm_file->f_mapping);
 				__unmap_hugepage_range_final(tlb, vma, start, end, NULL);
-				i_mmap_unlock_write(vma->vm_file->f_mapping);
+				i_mmap_unlock_read(vma->vm_file->f_mapping);
 			}
 		} else
 			unmap_page_range(tlb, vma, start, end, details);
-- 
1.8.4.5



