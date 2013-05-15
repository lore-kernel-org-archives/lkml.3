Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932518Ab3EOMqk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 08:46:40 -0400
Received: from relay1.sgi.com ([192.48.179.29]:59003 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932416Ab3EOMqi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 08:46:38 -0400
To: linux-kernel@vger.kernel.org
Subject: [PATCH v3] mm/pagewalk.c: walk_page_range should avoid VM_PFNMAP areas
Cc: akpm@linux-foundation.org, mgorman@suse.de, aarcange@redhat.com,
        dave.hansen@intel.com, dsterba@suse.cz, hannes@cmpxchg.org,
        kosaki.motohiro@gmail.com, kirill.shutemov@linux.intel.com,
        mpm@selenic.com, n-horiguchi@ah.jp.nec.com, rdunlap@infradead.org
Message-Id: <E1Ucb6K-00047X-9I@eag09.americas.sgi.com>
From: Cliff Wickman <cpw@sgi.com>
Date: Wed, 15 May 2013 07:46:36 -0500
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


/proc/<pid>/smaps and similar walks through a user page table should not
be looking at VM_PFNMAP areas.

v2: 
- moves the VM_BUG_ON out of the loop
- adds the needed test for  vma->vm_start <= addr

v3 adds comments to make this clearer, as N. Horiguchi recommends:
  > I recommend that you check VM_PFNMAP in the possible callers' side.
  > But this patch seems to solve your problem, so with properly commenting
  > this somewhere, I do not oppose it.

Certain tests in walk_page_range() (specifically split_huge_page_pmd())
assume that all the mapped PFN's are backed with page structures. And this is
not usually true for VM_PFNMAP areas. This can result in panics on kernel
page faults when attempting to address those page structures.

There are a half dozen callers of walk_page_range() that walk through
a task's entire page table (as N. Horiguchi pointed out). So rather than
change all of them, this patch changes just walk_page_range() to ignore 
VM_PFNMAP areas.

The logic of hugetlb_vma() is moved back into walk_page_range(), as we
want to test any vma in the range.

VM_PFNMAP areas are used by:
- graphics memory manager   gpu/drm/drm_gem.c
- global reference unit     sgi-gru/grufile.c
- sgi special memory        char/mspec.c
- and probably several out-of-tree modules

I'm copying everyone who has changed this file recently, in case
there is some reason that I am not aware of to provide
/proc/<pid>/smaps|clear_refs|maps|numa_maps for these VM_PFNMAP areas.

Signed-off-by: Cliff Wickman <cpw@sgi.com>
---
 mm/pagewalk.c |   65 ++++++++++++++++++++++++++++++++--------------------------
 1 file changed, 36 insertions(+), 29 deletions(-)

Index: linux/mm/pagewalk.c
===================================================================
--- linux.orig/mm/pagewalk.c
+++ linux/mm/pagewalk.c
@@ -127,22 +127,6 @@ static int walk_hugetlb_range(struct vm_
 	return 0;
 }
 
-static struct vm_area_struct* hugetlb_vma(unsigned long addr, struct mm_walk *walk)
-{
-	struct vm_area_struct *vma;
-
-	/* We don't need vma lookup at all. */
-	if (!walk->hugetlb_entry)
-		return NULL;
-
-	VM_BUG_ON(!rwsem_is_locked(&walk->mm->mmap_sem));
-	vma = find_vma(walk->mm, addr);
-	if (vma && vma->vm_start <= addr && is_vm_hugetlb_page(vma))
-		return vma;
-
-	return NULL;
-}
-
 #else /* CONFIG_HUGETLB_PAGE */
 static struct vm_area_struct* hugetlb_vma(unsigned long addr, struct mm_walk *walk)
 {
@@ -198,30 +182,53 @@ int walk_page_range(unsigned long addr,
 	if (!walk->mm)
 		return -EINVAL;
 
+	VM_BUG_ON(!rwsem_is_locked(&walk->mm->mmap_sem));
+
 	pgd = pgd_offset(walk->mm, addr);
 	do {
-		struct vm_area_struct *vma;
+		struct vm_area_struct *vma = NULL;
 
 		next = pgd_addr_end(addr, end);
 
 		/*
-		 * handle hugetlb vma individually because pagetable walk for
-		 * the hugetlb page is dependent on the architecture and
-		 * we can't handled it in the same manner as non-huge pages.
+		 * This function was not intended to be vma based.
+		 * But there are vma special cases to be handled:
+		 * - hugetlb vma's
+		 * - VM_PFNMAP vma's
 		 */
-		vma = hugetlb_vma(addr, walk);
+		vma = find_vma(walk->mm, addr);
 		if (vma) {
-			if (vma->vm_end < next)
+			/*
+			 * There are no page structures backing a VM_PFNMAP
+			 * range, so do not allow split_huge_page_pmd().
+			 */
+			if ((vma->vm_start <= addr) &&
+			    (vma->vm_flags & VM_PFNMAP)) {
 				next = vma->vm_end;
+				pgd = pgd_offset(walk->mm, next);
+				continue;
+			}
 			/*
-			 * Hugepage is very tightly coupled with vma, so
-			 * walk through hugetlb entries within a given vma.
+			 * Handle hugetlb vma individually because pagetable
+			 * walk for the hugetlb page is dependent on the
+			 * architecture and we can't handled it in the same
+			 * manner as non-huge pages.
 			 */
-			err = walk_hugetlb_range(vma, addr, next, walk);
-			if (err)
-				break;
-			pgd = pgd_offset(walk->mm, next);
-			continue;
+			if (walk->hugetlb_entry && (vma->vm_start <= addr) &&
+			    is_vm_hugetlb_page(vma)) {
+				if (vma->vm_end < next)
+					next = vma->vm_end;
+				/*
+				 * Hugepage is very tightly coupled with vma,
+				 * so walk through hugetlb entries within a
+				 * given vma.
+				 */
+				err = walk_hugetlb_range(vma, addr, next, walk);
+				if (err)
+					break;
+				pgd = pgd_offset(walk->mm, next);
+				continue;
+			}
 		}
 
 		if (pgd_none_or_clear_bad(pgd)) {
