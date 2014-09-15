Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756571AbaIOWfd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:35:33 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51183 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754592AbaIOWTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:19:30 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 182/187] powerpc/thp: Handle combo pages in invalidate
Date: Mon, 15 Sep 2014 15:09:52 -0700
Message-Id: <1410818997-9432-183-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410818997-9432-1-git-send-email-kamal@canonical.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>

commit fc0479557572375100ef16c71170b29a98e0d69a upstream.

If we changed base page size of the segment, either via sub_page_protect
or via remap_4k_pfn, we do a demote_segment which doesn't flush the hash
table entries. We do a lazy hash page table flush for all mapped pages
in the demoted segment. This happens when we handle hash page fault for
these pages.

We use _PAGE_COMBO bit along with _PAGE_HASHPTE to indicate whether a
pte is backed by 4K hash pte. If we find _PAGE_COMBO not set on the pte,
that implies that we could possibly have older 64K hash pte entries in
the hash page table and we need to invalidate those entries.

Use _PAGE_COMBO to determine the page size with which we should
invalidate the hash table entries on unmap.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/powerpc/include/asm/pgtable-ppc64.h |  2 +-
 arch/powerpc/mm/pgtable_64.c             | 14 +++++++++++---
 arch/powerpc/mm/tlb_hash64.c             |  2 +-
 3 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/include/asm/pgtable-ppc64.h b/arch/powerpc/include/asm/pgtable-ppc64.h
index bc141c9..b26cc32 100644
--- a/arch/powerpc/include/asm/pgtable-ppc64.h
+++ b/arch/powerpc/include/asm/pgtable-ppc64.h
@@ -411,7 +411,7 @@ static inline char *get_hpte_slot_array(pmd_t *pmdp)
 }
 
 extern void hpte_do_hugepage_flush(struct mm_struct *mm, unsigned long addr,
-				   pmd_t *pmdp);
+				   pmd_t *pmdp, unsigned long old_pmd);
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 extern pmd_t pfn_pmd(unsigned long pfn, pgprot_t pgprot);
 extern pmd_t mk_pmd(struct page *page, pgprot_t pgprot);
diff --git a/arch/powerpc/mm/pgtable_64.c b/arch/powerpc/mm/pgtable_64.c
index 5cd5182..3e575db 100644
--- a/arch/powerpc/mm/pgtable_64.c
+++ b/arch/powerpc/mm/pgtable_64.c
@@ -525,7 +525,7 @@ unsigned long pmd_hugepage_update(struct mm_struct *mm, unsigned long addr,
 	*pmdp = __pmd(old & ~clr);
 #endif
 	if (old & _PAGE_HASHPTE)
-		hpte_do_hugepage_flush(mm, addr, pmdp);
+		hpte_do_hugepage_flush(mm, addr, pmdp, old);
 	return old;
 }
 
@@ -632,7 +632,7 @@ void pmdp_splitting_flush(struct vm_area_struct *vma,
 	if (!(old & _PAGE_SPLITTING)) {
 		/* We need to flush the hpte */
 		if (old & _PAGE_HASHPTE)
-			hpte_do_hugepage_flush(vma->vm_mm, address, pmdp);
+			hpte_do_hugepage_flush(vma->vm_mm, address, pmdp, old);
 	}
 }
 
@@ -705,7 +705,7 @@ void pmdp_invalidate(struct vm_area_struct *vma, unsigned long address,
  * neesd to be flushed.
  */
 void hpte_do_hugepage_flush(struct mm_struct *mm, unsigned long addr,
-			    pmd_t *pmdp)
+			    pmd_t *pmdp, unsigned long old_pmd)
 {
 	int ssize, i;
 	unsigned long s_addr;
@@ -728,7 +728,15 @@ void hpte_do_hugepage_flush(struct mm_struct *mm, unsigned long addr,
 		return;
 
 	/* get the base page size,vsid and segment size */
+#ifdef CONFIG_DEBUG_VM
 	psize = get_slice_psize(mm, s_addr);
+	BUG_ON(psize == MMU_PAGE_16M);
+#endif
+	if (old_pmd & _PAGE_COMBO)
+		psize = MMU_PAGE_4K;
+	else
+		psize = MMU_PAGE_64K;
+
 	if (!is_kernel_addr(s_addr)) {
 		ssize = user_segment_size(s_addr);
 		vsid = get_vsid(mm->context.id, s_addr, ssize);
diff --git a/arch/powerpc/mm/tlb_hash64.c b/arch/powerpc/mm/tlb_hash64.c
index 36e44b4..c66e445 100644
--- a/arch/powerpc/mm/tlb_hash64.c
+++ b/arch/powerpc/mm/tlb_hash64.c
@@ -217,7 +217,7 @@ void __flush_hash_table_range(struct mm_struct *mm, unsigned long start,
 		if (!(pte & _PAGE_HASHPTE))
 			continue;
 		if (unlikely(hugepage_shift && pmd_trans_huge(*(pmd_t *)pte)))
-			hpte_do_hugepage_flush(mm, start, (pmd_t *)pte);
+			hpte_do_hugepage_flush(mm, start, (pmd_t *)ptep, pte);
 		else
 			hpte_need_flush(mm, start, ptep, pte, 0);
 	}
-- 
1.9.1

