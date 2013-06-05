Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932827Ab3FEVfh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 17:35:37 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37829 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932582Ab3FEVfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 17:35:33 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Cliff Wickman <cpw@sgi.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Mel Gorman <mel@csn.ul.ie>, Andrea Arcangeli <aarcange@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>, David Sterba <dsterba@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 054/127] mm/pagewalk.c: walk_page_range should avoid VM_PFNMAP areas
Date: Wed,  5 Jun 2013 14:33:41 -0700
Message-Id: <20130605213224.176771238@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130605213217.966891866@linuxfoundation.org>
References: <20130605213217.966891866@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cliff Wickman <cpw@sgi.com>

commit a9ff785e4437c83d2179161e012f5bdfbd6381f0 upstream.

A panic can be caused by simply cat'ing /proc/<pid>/smaps while an
application has a VM_PFNMAP range.  It happened in-house when a
benchmarker was trying to decipher the memory layout of his program.

/proc/<pid>/smaps and similar walks through a user page table should not
be looking at VM_PFNMAP areas.

Certain tests in walk_page_range() (specifically split_huge_page_pmd())
assume that all the mapped PFN's are backed with page structures.  And
this is not usually true for VM_PFNMAP areas.  This can result in panics
on kernel page faults when attempting to address those page structures.

There are a half dozen callers of walk_page_range() that walk through a
task's entire page table (as N.  Horiguchi pointed out).  So rather than
change all of them, this patch changes just walk_page_range() to ignore
VM_PFNMAP areas.

The logic of hugetlb_vma() is moved back into walk_page_range(), as we
want to test any vma in the range.

VM_PFNMAP areas are used by:
- graphics memory manager   gpu/drm/drm_gem.c
- global reference unit     sgi-gru/grufile.c
- sgi special memory        char/mspec.c
- and probably several out-of-tree modules

[akpm@linux-foundation.org: remove now-unused hugetlb_vma() stub]
Signed-off-by: Cliff Wickman <cpw@sgi.com>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: David Sterba <dsterba@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/pagewalk.c |   70 +++++++++++++++++++++++++++++-----------------------------
 1 file changed, 36 insertions(+), 34 deletions(-)

--- a/mm/pagewalk.c
+++ b/mm/pagewalk.c
@@ -127,28 +127,7 @@ static int walk_hugetlb_range(struct vm_
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
-static struct vm_area_struct* hugetlb_vma(unsigned long addr, struct mm_walk *walk)
-{
-	return NULL;
-}
-
 static int walk_hugetlb_range(struct vm_area_struct *vma,
 			      unsigned long addr, unsigned long end,
 			      struct mm_walk *walk)
@@ -198,30 +177,53 @@ int walk_page_range(unsigned long addr,
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


