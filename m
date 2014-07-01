Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758741AbaGARJe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 13:09:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51215 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932387AbaGARIG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 13:08:06 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>, Hugh Dickins <hughd@google.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Jerome Marchand <jmarchan@redhat.com>, linux-kernel@vger.kernel.org,
        Naoya Horiguchi <nao.horiguchi@gmail.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [PATCH v4 12/13] mm: /proc/pid/clear_refs: avoid split_huge_page()
Date: Tue,  1 Jul 2014 13:07:30 -0400
Message-Id: <1404234451-21695-13-git-send-email-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1404234451-21695-1-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <1404234451-21695-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>

Currently pagewalker splits all THP pages on any clear_refs request.  It's
not necessary.  We can handle this on PMD level.

One side effect is that soft dirty will potentially see more dirty memory,
since we will mark whole THP page dirty at once.

Sanity checked with CRIU test suite. More testing is required.

ChangeLog:
- move code for thp to clear_refs_pte_range()

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
 fs/proc/task_mmu.c | 47 ++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 44 insertions(+), 3 deletions(-)

diff --git v3.16-rc3.orig/fs/proc/task_mmu.c v3.16-rc3/fs/proc/task_mmu.c
index 4ca28f401bb1..50518282ca2e 100644
--- v3.16-rc3.orig/fs/proc/task_mmu.c
+++ v3.16-rc3/fs/proc/task_mmu.c
@@ -718,10 +718,10 @@ struct clear_refs_private {
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
@@ -740,9 +740,35 @@ static inline void clear_soft_dirty(struct vm_area_struct *vma,
 	}
 
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
+
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
@@ -752,7 +778,22 @@ static int clear_refs_pte_range(pmd_t *pmd, unsigned long addr,
 	spinlock_t *ptl;
 	struct page *page;
 
-	split_huge_page_pmd(vma, addr, pmd);
+	if (pmd_trans_huge_lock(pmd, vma, &ptl) == 1) {
+		if (cp->type == CLEAR_REFS_SOFT_DIRTY) {
+			clear_soft_dirty_pmd(vma, addr, pmd);
+			goto out;
+		}
+
+		page = pmd_page(*pmd);
+
+		/* Clear accessed and referenced bits. */
+		pmdp_test_and_clear_young(vma, addr, pmd);
+		ClearPageReferenced(page);
+out:
+		spin_unlock(ptl);
+		return 0;
+	}
+
 	if (pmd_trans_unstable(pmd))
 		return 0;
 
-- 
1.9.3

