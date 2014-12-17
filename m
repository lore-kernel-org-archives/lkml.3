Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752015AbaLQJPT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 04:15:19 -0500
Received: from pegase1.c-s.fr ([93.17.236.30]:50906 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751410AbaLQJOe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 04:14:34 -0500
From: Christophe Leroy <christophe.leroy@c-s.fr>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>, scottwood@freescale.com
CC: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Joakim Tjernlund <joakim.tjernlund@transmode.se>
Subject: [v2 PATCH 1/2] powerpc32: adds handling of _PAGE_RO
Message-Id: <20141217091431.D3F761A5E0D@localhost.localdomain>
Date: Wed, 17 Dec 2014 10:14:31 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some powerpc like the 8xx don't have a RW bit in PTE bits but a RO (Read Only) bit.
This patch implements the handling of a _PAGE_RO flag to be used in place of _PAGE_RW

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>

---
v2 is a complete rework compared to v1

 arch/powerpc/include/asm/pgtable-ppc32.h | 11 ++++++-----
 arch/powerpc/include/asm/pgtable.h       | 10 +++++++---
 arch/powerpc/include/asm/pte-common.h    | 27 ++++++++++++++++++---------
 arch/powerpc/mm/gup.c                    |  2 ++
 arch/powerpc/mm/mem.c                    |  2 +-
 arch/powerpc/mm/pgtable_32.c             | 24 ++++++++++++++++++++----
 6 files changed, 54 insertions(+), 22 deletions(-)

diff --git a/arch/powerpc/include/asm/pgtable-ppc32.h b/arch/powerpc/include/asm/pgtable-ppc32.h
index 543bb8e..64ed9e1 100644
--- a/arch/powerpc/include/asm/pgtable-ppc32.h
+++ b/arch/powerpc/include/asm/pgtable-ppc32.h
@@ -125,7 +125,7 @@ extern int icache_44x_need_flush;
 #ifndef __ASSEMBLY__
 
 #define pte_clear(mm, addr, ptep) \
-	do { pte_update(ptep, ~_PAGE_HASHPTE, 0); } while (0)
+	do { pte_update(ptep, ~_PAGE_HASHPTE, _PAGE_RO); } while (0)
 
 #define pmd_none(pmd)		(!pmd_val(pmd))
 #define	pmd_bad(pmd)		(pmd_val(pmd) & _PMD_BAD)
@@ -268,14 +268,14 @@ static inline int __ptep_test_and_clear_young(unsigned int context, unsigned lon
 static inline pte_t ptep_get_and_clear(struct mm_struct *mm, unsigned long addr,
 				       pte_t *ptep)
 {
-	return __pte(pte_update(ptep, ~_PAGE_HASHPTE, 0));
+	return __pte(pte_update(ptep, ~_PAGE_HASHPTE, _PAGE_RO));
 }
 
 #define __HAVE_ARCH_PTEP_SET_WRPROTECT
 static inline void ptep_set_wrprotect(struct mm_struct *mm, unsigned long addr,
 				      pte_t *ptep)
 {
-	pte_update(ptep, (_PAGE_RW | _PAGE_HWWRITE), 0);
+	pte_update(ptep, (_PAGE_RW | _PAGE_HWWRITE), _PAGE_RO);
 }
 static inline void huge_ptep_set_wrprotect(struct mm_struct *mm,
 					   unsigned long addr, pte_t *ptep)
@@ -287,8 +287,9 @@ static inline void huge_ptep_set_wrprotect(struct mm_struct *mm,
 static inline void __ptep_set_access_flags(pte_t *ptep, pte_t entry)
 {
 	unsigned long bits = pte_val(entry) &
-		(_PAGE_DIRTY | _PAGE_ACCESSED | _PAGE_RW | _PAGE_EXEC);
-	pte_update(ptep, 0, bits);
+		(_PAGE_DIRTY | _PAGE_ACCESSED | _PAGE_RW | _PAGE_RO |
+		 _PAGE_EXEC);
+	pte_update(ptep, _PAGE_RO, bits);
 }
 
 #define __HAVE_ARCH_PTE_SAME
diff --git a/arch/powerpc/include/asm/pgtable.h b/arch/powerpc/include/asm/pgtable.h
index 316f9a5..88f65fd 100644
--- a/arch/powerpc/include/asm/pgtable.h
+++ b/arch/powerpc/include/asm/pgtable.h
@@ -30,12 +30,14 @@ struct mm_struct;
 #include <asm/tlbflush.h>
 
 /* Generic accessors to PTE bits */
-static inline int pte_write(pte_t pte)		{ return pte_val(pte) & _PAGE_RW; }
+static inline int pte_write(pte_t pte)
+{	return (pte_val(pte) & (_PAGE_RW | _PAGE_RO)) != _PAGE_RO; }
 static inline int pte_dirty(pte_t pte)		{ return pte_val(pte) & _PAGE_DIRTY; }
 static inline int pte_young(pte_t pte)		{ return pte_val(pte) & _PAGE_ACCESSED; }
 static inline int pte_file(pte_t pte)		{ return pte_val(pte) & _PAGE_FILE; }
 static inline int pte_special(pte_t pte)	{ return pte_val(pte) & _PAGE_SPECIAL; }
-static inline int pte_none(pte_t pte)		{ return (pte_val(pte) & ~_PTE_NONE_MASK) == 0; }
+static inline int pte_none(pte_t pte)
+{	return (pte_val(pte) & ~_PTE_NONE_MASK) == _PAGE_RO; }
 static inline pgprot_t pte_pgprot(pte_t pte)	{ return __pgprot(pte_val(pte) & PAGE_PROT_BITS); }
 
 #ifdef CONFIG_NUMA_BALANCING
@@ -115,12 +117,14 @@ static inline unsigned long pte_pfn(pte_t pte)	{
 
 /* Generic modifiers for PTE bits */
 static inline pte_t pte_wrprotect(pte_t pte) {
-	pte_val(pte) &= ~(_PAGE_RW | _PAGE_HWWRITE); return pte; }
+	pte_val(pte) &= ~(_PAGE_RW | _PAGE_HWWRITE);
+	pte_val(pte) |= _PAGE_RO; return pte; }
 static inline pte_t pte_mkclean(pte_t pte) {
 	pte_val(pte) &= ~(_PAGE_DIRTY | _PAGE_HWWRITE); return pte; }
 static inline pte_t pte_mkold(pte_t pte) {
 	pte_val(pte) &= ~_PAGE_ACCESSED; return pte; }
 static inline pte_t pte_mkwrite(pte_t pte) {
+	pte_val(pte) &= ~_PAGE_RO;
 	pte_val(pte) |= _PAGE_RW; return pte; }
 static inline pte_t pte_mkdirty(pte_t pte) {
 	pte_val(pte) |= _PAGE_DIRTY; return pte; }
diff --git a/arch/powerpc/include/asm/pte-common.h b/arch/powerpc/include/asm/pte-common.h
index e040c35..7ed79b8 100644
--- a/arch/powerpc/include/asm/pte-common.h
+++ b/arch/powerpc/include/asm/pte-common.h
@@ -34,6 +34,12 @@
 #ifndef _PAGE_PSIZE
 #define _PAGE_PSIZE		0
 #endif
+/* _PAGE_RO and _PAGE_RW shall not be defined at the same time */
+#ifndef _PAGE_RO
+#define _PAGE_RO 0
+#else
+#define _PAGE_RW 0
+#endif
 #ifndef _PMD_PRESENT_MASK
 #define _PMD_PRESENT_MASK	_PMD_PRESENT
 #endif
@@ -42,10 +48,10 @@
 #define PMD_PAGE_SIZE(pmd)	bad_call_to_PMD_PAGE_SIZE()
 #endif
 #ifndef _PAGE_KERNEL_RO
-#define _PAGE_KERNEL_RO		0
+#define _PAGE_KERNEL_RO		(_PAGE_RO)
 #endif
 #ifndef _PAGE_KERNEL_ROX
-#define _PAGE_KERNEL_ROX	(_PAGE_EXEC)
+#define _PAGE_KERNEL_ROX	(_PAGE_EXEC | _PAGE_RO)
 #endif
 #ifndef _PAGE_KERNEL_RW
 #define _PAGE_KERNEL_RW		(_PAGE_DIRTY | _PAGE_RW | _PAGE_HWWRITE)
@@ -95,7 +101,7 @@ extern unsigned long bad_call_to_PMD_PAGE_SIZE(void);
 /* Mask of bits returned by pte_pgprot() */
 #define PAGE_PROT_BITS	(_PAGE_GUARDED | _PAGE_COHERENT | _PAGE_NO_CACHE | \
 			 _PAGE_WRITETHRU | _PAGE_ENDIAN | _PAGE_4K_PFN | \
-			 _PAGE_USER | _PAGE_ACCESSED | \
+			 _PAGE_USER | _PAGE_ACCESSED | _PAGE_RO | \
 			 _PAGE_RW | _PAGE_HWWRITE | _PAGE_DIRTY | _PAGE_EXEC)
 
 #ifdef CONFIG_NUMA_BALANCING
@@ -126,13 +132,16 @@ extern unsigned long bad_call_to_PMD_PAGE_SIZE(void);
  *
  * Note due to the way vm flags are laid out, the bits are XWR
  */
-#define PAGE_NONE	__pgprot(_PAGE_BASE)
+#define PAGE_NONE	__pgprot(_PAGE_BASE | _PAGE_RO)
 #define PAGE_SHARED	__pgprot(_PAGE_BASE | _PAGE_USER | _PAGE_RW)
-#define PAGE_SHARED_X	__pgprot(_PAGE_BASE | _PAGE_USER | _PAGE_RW | _PAGE_EXEC)
-#define PAGE_COPY	__pgprot(_PAGE_BASE | _PAGE_USER)
-#define PAGE_COPY_X	__pgprot(_PAGE_BASE | _PAGE_USER | _PAGE_EXEC)
-#define PAGE_READONLY	__pgprot(_PAGE_BASE | _PAGE_USER)
-#define PAGE_READONLY_X	__pgprot(_PAGE_BASE | _PAGE_USER | _PAGE_EXEC)
+#define PAGE_SHARED_X	__pgprot(_PAGE_BASE | _PAGE_USER | _PAGE_RW | \
+				 _PAGE_EXEC)
+#define PAGE_COPY	__pgprot(_PAGE_BASE | _PAGE_USER | _PAGE_RO)
+#define PAGE_COPY_X	__pgprot(_PAGE_BASE | _PAGE_USER | _PAGE_RO | \
+				 _PAGE_EXEC)
+#define PAGE_READONLY	__pgprot(_PAGE_BASE | _PAGE_USER | _PAGE_RO)
+#define PAGE_READONLY_X	__pgprot(_PAGE_BASE | _PAGE_USER | _PAGE_RO | \
+				 _PAGE_EXEC)
 
 #define __P000	PAGE_NONE
 #define __P001	PAGE_READONLY
diff --git a/arch/powerpc/mm/gup.c b/arch/powerpc/mm/gup.c
index d874668..fa287fc 100644
--- a/arch/powerpc/mm/gup.c
+++ b/arch/powerpc/mm/gup.c
@@ -30,6 +30,8 @@ static noinline int gup_pte_range(pmd_t pmd, unsigned long addr,
 	result = _PAGE_PRESENT|_PAGE_USER;
 	if (write)
 		result |= _PAGE_RW;
+	else
+		result |= _PAGE_RO;
 	mask = result | _PAGE_SPECIAL;
 
 	ptep = pte_offset_kernel(&pmd, addr);
diff --git a/arch/powerpc/mm/mem.c b/arch/powerpc/mm/mem.c
index 8ebaac7..3a74ee6 100644
--- a/arch/powerpc/mm/mem.c
+++ b/arch/powerpc/mm/mem.c
@@ -329,7 +329,7 @@ void __init paging_init(void)
 	unsigned long end = __fix_to_virt(FIX_HOLE);
 
 	for (; v < end; v += PAGE_SIZE)
-		map_page(v, 0, 0); /* XXX gross */
+		map_page(v, 0, _PAGE_RO); /* XXX gross */
 #endif
 
 #ifdef CONFIG_HIGHMEM
diff --git a/arch/powerpc/mm/pgtable_32.c b/arch/powerpc/mm/pgtable_32.c
index a349089..e1e30bb 100644
--- a/arch/powerpc/mm/pgtable_32.c
+++ b/arch/powerpc/mm/pgtable_32.c
@@ -96,6 +96,18 @@ void pgd_free(struct mm_struct *mm, pgd_t *pgd)
 #endif
 }
 
+static inline void pte_alloc_clear(pte_t *pte)
+{
+#if _PAGE_RO == 0
+	clear_page(pte);
+#else
+	int i;
+
+	for (i = 0; i < PTRS_PER_PTE; i++)
+		pte[i] = __pte(_PAGE_RO);
+#endif
+}
+
 __init_refok pte_t *pte_alloc_one_kernel(struct mm_struct *mm, unsigned long address)
 {
 	pte_t *pte;
@@ -103,11 +115,12 @@ __init_refok pte_t *pte_alloc_one_kernel(struct mm_struct *mm, unsigned long add
 	extern void *early_get_page(void);
 
 	if (mem_init_done) {
-		pte = (pte_t *)__get_free_page(GFP_KERNEL|__GFP_REPEAT|__GFP_ZERO);
+		pte = (pte_t *)__get_free_page(GFP_KERNEL|__GFP_REPEAT);
+		pte_alloc_clear(pte);
 	} else {
 		pte = (pte_t *)early_get_page();
 		if (pte)
-			clear_page(pte);
+			pte_alloc_clear(pte);
 	}
 	return pte;
 }
@@ -115,12 +128,15 @@ __init_refok pte_t *pte_alloc_one_kernel(struct mm_struct *mm, unsigned long add
 pgtable_t pte_alloc_one(struct mm_struct *mm, unsigned long address)
 {
 	struct page *ptepage;
+	pte_t *pte;
 
-	gfp_t flags = GFP_KERNEL | __GFP_REPEAT | __GFP_ZERO;
+	gfp_t flags = GFP_KERNEL | __GFP_REPEAT;
 
 	ptepage = alloc_pages(flags, 0);
 	if (!ptepage)
 		return NULL;
+	pte = (pte_t *)pfn_to_kaddr(page_to_pfn(ptepage));
+	pte_alloc_clear(pte);
 	if (!pgtable_page_ctor(ptepage)) {
 		__free_page(ptepage);
 		return NULL;
@@ -148,7 +164,7 @@ void __iomem *
 ioremap_prot(phys_addr_t addr, unsigned long size, unsigned long flags)
 {
 	/* writeable implies dirty for kernel addresses */
-	if (flags & _PAGE_RW)
+	if ((flags & (_PAGE_RW | _PAGE_RO)) != _PAGE_RO)
 		flags |= _PAGE_DIRTY | _PAGE_HWWRITE;
 
 	/* we don't want to let _PAGE_USER and _PAGE_EXEC leak out */
-- 
2.1.0

