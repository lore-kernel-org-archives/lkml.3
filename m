Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753207AbaEUTE4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 15:04:56 -0400
Received: from mga11.intel.com ([192.55.52.93]:23458 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752891AbaEUTEz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 15:04:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,881,1392192000"; 
   d="scan'208";a="542907480"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Dave Hansen <dave.hansen@intel.com>
Subject: [PATCH] mm: /prom/pid/clear_refs: avoid split_huge_page()
Date: Wed, 21 May 2014 22:04:22 +0300
Message-Id: <1400699062-20123-1-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.0.0.rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently we split all THP pages on any clear_refs request. It's not
necessary. We can handle this on PMD level.

One side effect is that soft dirty will potentially see more dirty
memory, since we will mark whole THP page dirty at once.

Sanity checked with CRIU test suite. More testing is required.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Dave Hansen <dave.hansen@intel.com>
---
 fs/proc/task_mmu.c | 46 +++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 43 insertions(+), 3 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 442177b1119a..9f5ae29f3037 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -716,10 +716,10 @@ struct clear_refs_private {
 	enum clear_refs_types type;
 };
 
+#ifdef CONFIG_MEM_SOFT_DIRTY
 static inline void clear_soft_dirty(struct vm_area_struct *vma,
 		unsigned long addr, pte_t *pte)
 {
-#ifdef CONFIG_MEM_SOFT_DIRTY
 	/*
 	 * The soft-dirty tracker uses #PF-s to catch writes
 	 * to pages, so write-protect the pte as well. See the
@@ -741,9 +741,34 @@ static inline void clear_soft_dirty(struct vm_area_struct *vma,
 		vma->vm_flags &= ~VM_SOFTDIRTY;
 
 	set_pte_at(vma->vm_mm, addr, pte, ptent);
-#endif
 }
 
+static inline void clear_soft_dirty_pmd(struct vm_area_struct *vma,
+		unsigned long addr, pmd_t *pmdp)
+{
+	pmd_t pmd = *pmdp;
+
+	pmd = pmd_wrprotect(pmd);
+	pmd = pmd_clear_flags(pmd, _PAGE_SOFT_DIRTY);
+
+	if (vma->vm_flags & VM_SOFTDIRTY)
+		vma->vm_flags &= ~VM_SOFTDIRTY;
+
+	set_pmd_at(vma->vm_mm, addr, pmdp, pmd);
+}
+
+#else
+static inline void clear_soft_dirty(struct vm_area_struct *vma,
+		unsigned long addr, pte_t *pte)
+{
+}
+
+static inline void clear_soft_dirty_pmd(struct vm_area_struct *vma,
+		unsigned long addr, pmd_t *pmdp)
+{
+}
+#endif
+
 static int clear_refs_pte_range(pmd_t *pmd, unsigned long addr,
 				unsigned long end, struct mm_walk *walk)
 {
@@ -753,7 +778,22 @@ static int clear_refs_pte_range(pmd_t *pmd, unsigned long addr,
 	spinlock_t *ptl;
 	struct page *page;
 
-	split_huge_page_pmd(vma, addr, pmd);
+	if (pmd_trans_huge_lock(pmd, vma, &ptl) == 1) {
+		if (cp->type == CLEAR_REFS_SOFT_DIRTY) {
+			clear_soft_dirty_pmd(vma, addr, pmd);
+			spin_unlock(ptl);
+			return 0;
+		}
+
+		page = pmd_page(*pmd);
+
+		/* Clear accessed and referenced bits. */
+		pmdp_test_and_clear_young(vma, addr, pmd);
+		ClearPageReferenced(page);
+		spin_unlock(ptl);
+		return 0;
+	}
+
 	if (pmd_trans_unstable(pmd))
 		return 0;
 
-- 
2.0.0.rc2

