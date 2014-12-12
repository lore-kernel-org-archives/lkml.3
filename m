Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760520AbaLLG0s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 01:26:48 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51974 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759337AbaLLGQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 01:16:59 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Andrea Arcangeli" <aarcange@redhat.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        "David Rientjes" <rientjes@google.com>,
        "Suleiman Souhlal" <suleiman@google.com>
Date: Fri, 12 Dec 2014 06:14:25 +0000
Message-ID: <lsq.1418364865.269309418@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 094/164] mm, thp: fix collapsing of hugepages on madvise
In-Reply-To: <lsq.1418364865.554543691@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:c97:8151:cc89:c28d
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.65-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: David Rientjes <rientjes@google.com>

commit 6d50e60cd2edb5a57154db5a6f64eef5aa59b751 upstream.

If an anonymous mapping is not allowed to fault thp memory and then
madvise(MADV_HUGEPAGE) is used after fault, khugepaged will never
collapse this memory into thp memory.

This occurs because the madvise(2) handler for thp, hugepage_madvise(),
clears VM_NOHUGEPAGE on the stack and it isn't stored in vma->vm_flags
until the final action of madvise_behavior().  This causes the
khugepaged_enter_vma_merge() to be a no-op in hugepage_madvise() when
the vma had previously had VM_NOHUGEPAGE set.

Fix this by passing the correct vma flags to the khugepaged mm slot
handler.  There's no chance khugepaged can run on this vma until after
madvise_behavior() returns since we hold mm->mmap_sem.

It would be possible to clear VM_NOHUGEPAGE directly from vma->vm_flags
in hugepage_advise(), but I didn't want to introduce special case
behavior into madvise_behavior().  I think it's best to just let it
always set vma->vm_flags itself.

Signed-off-by: David Rientjes <rientjes@google.com>
Reported-by: Suleiman Souhlal <suleiman@google.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[bwh: Backported to 3.2: adjust context, indentation]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/linux/khugepaged.h | 17 ++++++++++-------
 mm/huge_memory.c           | 11 ++++++-----
 mm/mmap.c                  |  8 ++++----
 3 files changed, 20 insertions(+), 16 deletions(-)

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
@@ -35,13 +36,13 @@ static inline void khugepaged_exit(struc
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
@@ -54,11 +55,13 @@ static inline int khugepaged_fork(struct
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
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -682,7 +682,7 @@ int do_huge_pmd_anonymous_page(struct mm
 	if (haddr >= vma->vm_start && haddr + HPAGE_PMD_SIZE <= vma->vm_end) {
 		if (unlikely(anon_vma_prepare(vma)))
 			return VM_FAULT_OOM;
-		if (unlikely(khugepaged_enter(vma)))
+		if (unlikely(khugepaged_enter(vma, vma->vm_flags)))
 			return VM_FAULT_OOM;
 		page = alloc_hugepage_vma(transparent_hugepage_defrag(vma),
 					  vma, haddr, numa_node_id(), 0);
@@ -1493,7 +1493,7 @@ int hugepage_madvise(struct vm_area_stru
 		 * register it here without waiting a page fault that
 		 * may not happen any time soon.
 		 */
-		if (unlikely(khugepaged_enter_vma_merge(vma)))
+		if (unlikely(khugepaged_enter_vma_merge(vma, *vm_flags)))
 			return -ENOMEM;
 		break;
 	case MADV_NOHUGEPAGE:
@@ -1625,7 +1625,8 @@ int __khugepaged_enter(struct mm_struct
 	return 0;
 }
 
-int khugepaged_enter_vma_merge(struct vm_area_struct *vma)
+int khugepaged_enter_vma_merge(struct vm_area_struct *vma,
+			       unsigned long vm_flags)
 {
 	unsigned long hstart, hend;
 	if (!vma->anon_vma)
@@ -1641,11 +1642,11 @@ int khugepaged_enter_vma_merge(struct vm
 	 * If is_pfn_mapping() is true is_learn_pfn_mapping() must be
 	 * true too, verify it here.
 	 */
-	VM_BUG_ON(is_linear_pfn_mapping(vma) || vma->vm_flags & VM_NO_THP);
+	VM_BUG_ON(is_linear_pfn_mapping(vma) || vm_flags & VM_NO_THP);
 	hstart = (vma->vm_start + ~HPAGE_PMD_MASK) & HPAGE_PMD_MASK;
 	hend = vma->vm_end & HPAGE_PMD_MASK;
 	if (hstart < hend)
-		return khugepaged_enter(vma);
+		return khugepaged_enter(vma, vm_flags);
 	return 0;
 }
 
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -796,7 +796,7 @@ struct vm_area_struct *vma_merge(struct
 				end, prev->vm_pgoff, NULL);
 		if (err)
 			return NULL;
-		khugepaged_enter_vma_merge(prev);
+		khugepaged_enter_vma_merge(prev, vm_flags);
 		return prev;
 	}
 
@@ -815,7 +815,7 @@ struct vm_area_struct *vma_merge(struct
 				next->vm_pgoff - pglen, NULL);
 		if (err)
 			return NULL;
-		khugepaged_enter_vma_merge(area);
+		khugepaged_enter_vma_merge(area, vm_flags);
 		return area;
 	}
 
@@ -1741,7 +1741,7 @@ int expand_upwards(struct vm_area_struct
 		}
 	}
 	vma_unlock_anon_vma(vma);
-	khugepaged_enter_vma_merge(vma);
+	khugepaged_enter_vma_merge(vma, vma->vm_flags);
 	return error;
 }
 #endif /* CONFIG_STACK_GROWSUP || CONFIG_IA64 */
@@ -1792,7 +1792,7 @@ int expand_downwards(struct vm_area_stru
 		}
 	}
 	vma_unlock_anon_vma(vma);
-	khugepaged_enter_vma_merge(vma);
+	khugepaged_enter_vma_merge(vma, vma->vm_flags);
 	return error;
 }
 

