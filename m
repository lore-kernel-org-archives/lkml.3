Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751943AbaEVBLm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 21:11:42 -0400
Received: from mga11.intel.com ([192.55.52.93]:55346 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750796AbaEVBLl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 21:11:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,883,1392192000"; 
   d="scan'208";a="535756129"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrea Arcangeli <aarcange@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
In-Reply-To: <20140521123446.ae45fa676cae27fffbd96cfd@linux-foundation.org>
References: <1400699062-20123-1-git-send-email-kirill.shutemov@linux.intel.com>
 <20140521123446.ae45fa676cae27fffbd96cfd@linux-foundation.org>
Subject: Re: [PATCH] mm: /prom/pid/clear_refs: avoid split_huge_page()
Content-Transfer-Encoding: 7bit
Message-Id: <20140522011110.B0090E009B@blue.fi.intel.com>
Date: Thu, 22 May 2014 04:11:10 +0300 (EEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Wed, 21 May 2014 22:04:22 +0300 "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com> wrote:
> 
> > Currently we split all THP pages on any clear_refs request. It's not
> > necessary. We can handle this on PMD level.
> > 
> > One side effect is that soft dirty will potentially see more dirty
> > memory, since we will mark whole THP page dirty at once.
> 
> This clashes pretty badly with
> http://ozlabs.org/~akpm/mmots/broken-out/clear_refs-redefine-callback-functions-for-page-table-walker.patch

Hm.. For some reason CRIU memory-snapshotting test cases fail on current
linux-next. I didn't debug why. Mainline works. Folks?

Below is patch which applies on linux-next, but I wasn't able to test it.

> > Sanity checked with CRIU test suite. More testing is required.
> 
> Will you be doing that testing or was this a request for Cyrill & co to
> help?

Cyrill, Pavel, could you take care of this?

> Perhaps this is post-3.15 material.

Sure.

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Date: Thu, 22 May 2014 03:44:38 +0300
Subject: [PATCH] mm: /prom/pid/clear_refs: avoid split_huge_page()

Currently pagewalker splits all THP pages on any clear_refs request.
It's not necessary. We can handle this on PMD level.

One side effect is that soft dirty will potentially see more dirty
memory, since we will mark whole THP page dirty at once.

Sanity checked with CRIU test suite. More testing is required.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 fs/proc/task_mmu.c | 58 ++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 56 insertions(+), 2 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index fa6d6a4e85b3..0cc47a44d016 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -702,10 +702,10 @@ struct clear_refs_private {
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
@@ -724,9 +724,35 @@ static inline void clear_soft_dirty(struct vm_area_struct *vma,
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
 static int clear_refs_pte(pte_t *pte, unsigned long addr,
 				unsigned long end, struct mm_walk *walk)
 {
@@ -749,6 +775,33 @@ static int clear_refs_pte(pte_t *pte, unsigned long addr,
 	return 0;
 }
 
+static int clear_refs_pmd(pmd_t *pmd, unsigned long addr,
+				unsigned long end, struct mm_walk *walk)
+{
+	struct clear_refs_private *cp = walk->private;
+	struct vm_area_struct *vma = walk->vma;
+	struct page *page;
+	spinlock_t *ptl;
+
+	if (pmd_trans_huge_lock(pmd, vma, &ptl) != 1)
+		return 0;
+	if (cp->type == CLEAR_REFS_SOFT_DIRTY) {
+		clear_soft_dirty_pmd(vma, addr, pmd);
+		goto out;
+	}
+
+	page = pmd_page(*pmd);
+
+	/* Clear accessed and referenced bits. */
+	pmdp_test_and_clear_young(vma, addr, pmd);
+	ClearPageReferenced(page);
+out:
+	spin_unlock(ptl);
+	/* handled as pmd, no need to call clear_refs_pte() */
+	walk->skip = 1;
+	return 0;
+}
+
 static int clear_refs_test_walk(unsigned long start, unsigned long end,
 				struct mm_walk *walk)
 {
@@ -812,6 +865,7 @@ static ssize_t clear_refs_write(struct file *file, const char __user *buf,
 		};
 		struct mm_walk clear_refs_walk = {
 			.pte_entry = clear_refs_pte,
+			.pmd_entry = clear_refs_pmd,
 			.test_walk = clear_refs_test_walk,
 			.mm = mm,
 			.private = &cp,
-- 
 Kirill A. Shutemov
