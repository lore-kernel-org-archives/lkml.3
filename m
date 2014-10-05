Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751652AbaJECsK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2014 22:48:10 -0400
Received: from mail-ig0-f174.google.com ([209.85.213.174]:37535 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454AbaJECsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2014 22:48:07 -0400
Date: Sat, 4 Oct 2014 19:48:04 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Suleiman Souhlal <suleiman@google.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [patch for-3.17] mm, thp: fix collapsing of hugepages on madvise
Message-ID: <alpine.DEB.2.02.1410041947080.7055@chino.kir.corp.google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If an anonymous mapping is not allowed to fault thp memory and then
madvise(MADV_HUGEPAGE) is used after fault, khugepaged will never
collapse this memory into thp memory.

This occurs because the madvise(2) handler for thp, hugepage_advise(),
clears VM_NOHUGEPAGE on the stack and it isn't stored in vma->vm_flags
until the final action of madvise_behavior().  This causes the
khugepaged_enter_vma_merge() to be a no-op in hugepage_advise() when the
vma had previously had VM_NOHUGEPAGE set.

Fix this by passing the correct vma flags to the khugepaged mm slot
handler.  There's no chance khugepaged can run on this vma until after
madvise_behavior() returns since we hold mm->mmap_sem.

It would be possible to clear VM_NOHUGEPAGE directly from vma->vm_flags
in hugepage_advise(), but I didn't want to introduce special case
behavior into madvise_behavior().  I think it's best to just let it
always set vma->vm_flags itself.

Cc: <stable@vger.kernel.org>
Reported-by: Suleiman Souhlal <suleiman@google.com>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 include/linux/khugepaged.h | 17 ++++++++++-------
 mm/huge_memory.c           | 11 ++++++-----
 mm/mmap.c                  |  8 ++++----
 3 files changed, 20 insertions(+), 16 deletions(-)

diff --git a/include/linux/khugepaged.h b/include/linux/khugepaged.h
--- a/include/linux/khugepaged.h
+++ b/include/linux/khugepaged.h
@@ -6,7 +6,8 @@
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 extern int __khugepaged_enter(struct mm_struct *mm);
 extern void __khugepaged_exit(struct mm_struct *mm);
-extern int khugepaged_enter_vma_merge(struct vm_area_struct *vma);
+extern int khugepaged_enter_vma_merge(struct vm_area_struct *vma,
+				      unsigned long vm_flags);
 
 #define khugepaged_enabled()					       \
 	(transparent_hugepage_flags &				       \
@@ -35,13 +36,13 @@ static inline void khugepaged_exit(struct mm_struct *mm)
 		__khugepaged_exit(mm);
 }
 
-static inline int khugepaged_enter(struct vm_area_struct *vma)
+static inline int khugepaged_enter(struct vm_area_struct *vma,
+				   unsigned long vm_flags)
 {
 	if (!test_bit(MMF_VM_HUGEPAGE, &vma->vm_mm->flags))
 		if ((khugepaged_always() ||
-		     (khugepaged_req_madv() &&
-		      vma->vm_flags & VM_HUGEPAGE)) &&
-		    !(vma->vm_flags & VM_NOHUGEPAGE))
+		     (khugepaged_req_madv() && (vm_flags & VM_HUGEPAGE))) &&
+		    !(vm_flags & VM_NOHUGEPAGE))
 			if (__khugepaged_enter(vma->vm_mm))
 				return -ENOMEM;
 	return 0;
@@ -54,11 +55,13 @@ static inline int khugepaged_fork(struct mm_struct *mm, struct mm_struct *oldmm)
 static inline void khugepaged_exit(struct mm_struct *mm)
 {
 }
-static inline int khugepaged_enter(struct vm_area_struct *vma)
+static inline int khugepaged_enter(struct vm_area_struct *vma,
+				   unsigned long vm_flags)
 {
 	return 0;
 }
-static inline int khugepaged_enter_vma_merge(struct vm_area_struct *vma)
+static inline int khugepaged_enter_vma_merge(struct vm_area_struct *vma,
+					     unsigned long vm_flags)
 {
 	return 0;
 }
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -803,7 +803,7 @@ int do_huge_pmd_anonymous_page(struct mm_struct *mm, struct vm_area_struct *vma,
 		return VM_FAULT_FALLBACK;
 	if (unlikely(anon_vma_prepare(vma)))
 		return VM_FAULT_OOM;
-	if (unlikely(khugepaged_enter(vma)))
+	if (unlikely(khugepaged_enter(vma, vma->vm_flags)))
 		return VM_FAULT_OOM;
 	if (!(flags & FAULT_FLAG_WRITE) &&
 			transparent_hugepage_use_zero_page()) {
@@ -1970,7 +1970,7 @@ int hugepage_madvise(struct vm_area_struct *vma,
 		 * register it here without waiting a page fault that
 		 * may not happen any time soon.
 		 */
-		if (unlikely(khugepaged_enter_vma_merge(vma)))
+		if (unlikely(khugepaged_enter_vma_merge(vma, *vm_flags)))
 			return -ENOMEM;
 		break;
 	case MADV_NOHUGEPAGE:
@@ -2071,7 +2071,8 @@ int __khugepaged_enter(struct mm_struct *mm)
 	return 0;
 }
 
-int khugepaged_enter_vma_merge(struct vm_area_struct *vma)
+int khugepaged_enter_vma_merge(struct vm_area_struct *vma,
+			       unsigned long vm_flags)
 {
 	unsigned long hstart, hend;
 	if (!vma->anon_vma)
@@ -2083,11 +2084,11 @@ int khugepaged_enter_vma_merge(struct vm_area_struct *vma)
 	if (vma->vm_ops)
 		/* khugepaged not yet working on file or special mappings */
 		return 0;
-	VM_BUG_ON(vma->vm_flags & VM_NO_THP);
+	VM_BUG_ON(vm_flags & VM_NO_THP);
 	hstart = (vma->vm_start + ~HPAGE_PMD_MASK) & HPAGE_PMD_MASK;
 	hend = vma->vm_end & HPAGE_PMD_MASK;
 	if (hstart < hend)
-		return khugepaged_enter(vma);
+		return khugepaged_enter(vma, vm_flags);
 	return 0;
 }
 
diff --git a/mm/mmap.c b/mm/mmap.c
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1056,7 +1056,7 @@ struct vm_area_struct *vma_merge(struct mm_struct *mm,
 				end, prev->vm_pgoff, NULL);
 		if (err)
 			return NULL;
-		khugepaged_enter_vma_merge(prev);
+		khugepaged_enter_vma_merge(prev, vm_flags);
 		return prev;
 	}
 
@@ -1075,7 +1075,7 @@ struct vm_area_struct *vma_merge(struct mm_struct *mm,
 				next->vm_pgoff - pglen, NULL);
 		if (err)
 			return NULL;
-		khugepaged_enter_vma_merge(area);
+		khugepaged_enter_vma_merge(area, vm_flags);
 		return area;
 	}
 
@@ -2192,7 +2192,7 @@ int expand_upwards(struct vm_area_struct *vma, unsigned long address)
 		}
 	}
 	vma_unlock_anon_vma(vma);
-	khugepaged_enter_vma_merge(vma);
+	khugepaged_enter_vma_merge(vma, vma->vm_flags);
 	validate_mm(vma->vm_mm);
 	return error;
 }
@@ -2261,7 +2261,7 @@ int expand_downwards(struct vm_area_struct *vma,
 		}
 	}
 	vma_unlock_anon_vma(vma);
-	khugepaged_enter_vma_merge(vma);
+	khugepaged_enter_vma_merge(vma, vma->vm_flags);
 	validate_mm(vma->vm_mm);
 	return error;
 }
