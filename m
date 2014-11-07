Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751454AbaKGIJn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 03:09:43 -0500
Received: from TYO200.gate.nec.co.jp ([210.143.35.50]:53990 "EHLO
	tyo200.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbaKGIJm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 03:09:42 -0500
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Dave Hansen <dave.hansen@intel.com>, Hugh Dickins <hughd@google.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Peter Feiner <pfeiner@google.com>,
        Jerome Marchand <jmarchan@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: [PATCH -mm v7 12/13] mm: /proc/pid/clear_refs: avoid
 split_huge_page()
Thread-Topic: [PATCH -mm v7 12/13] mm: /proc/pid/clear_refs: avoid
 split_huge_page()
Thread-Index: AQHP+li88MGFXt7/EE6v216VrmnROQ==
Date: Fri, 7 Nov 2014 07:02:05 +0000
Message-ID: <1415343692-6314-13-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <1415343692-6314-1-git-send-email-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1415343692-6314-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.128.101.22]
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>

Currently pagewalker splits all THP pages on any clear_refs request.  It's
not necessary.  We can handle this on PMD level.

One side effect is that soft dirty will potentially see more dirty memory,
since we will mark whole THP page dirty at once.

Sanity checked with CRIU test suite. More testing is required.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Reviewed-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
ChangeLog:
- move code for thp to clear_refs_pte_range()
---
 fs/proc/task_mmu.c | 47 ++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 44 insertions(+), 3 deletions(-)

diff --git mmotm-2014-11-05-16-01.orig/fs/proc/task_mmu.c mmotm-2014-11-05-16-01/fs/proc/task_mmu.c
index e7d86b97598b..a6c1b75ed3c2 100644
--- mmotm-2014-11-05-16-01.orig/fs/proc/task_mmu.c
+++ mmotm-2014-11-05-16-01/fs/proc/task_mmu.c
@@ -744,10 +744,10 @@ struct clear_refs_private {
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
@@ -766,9 +766,35 @@ static inline void clear_soft_dirty(struct vm_area_struct *vma,
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
@@ -778,7 +804,22 @@ static int clear_refs_pte_range(pmd_t *pmd, unsigned long addr,
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
2.2.0.rc0.2.gf745acb
