Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751703AbbASQEm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 11:04:42 -0500
Received: from pegase1.c-s.fr ([93.17.236.30]:35462 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752135AbbASQEk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 11:04:40 -0500
From: Christophe Leroy <christophe.leroy@c-s.fr>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>, scottwood@freescale.com
CC: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Joakim Tjernlund <joakim.tjernlund@transmode.se>
Subject: [PATCH v4 1/2] powerpc32: adds handling of _PAGE_RO
Message-Id: <20150119160438.D3D6F1A5E85@localhost.localdomain>
Date: Mon, 19 Jan 2015 17:04:38 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some powerpc like the 8xx don't have a RW bit in PTE bits but a RO (Read Only) bit.
This patch implements the handling of a _PAGE_RO flag to be used in place of _PAGE_RW

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>

---
v2 is a complete rework of v1
v3:
 - cleared PTE can remain 0, no need of _PAGE_RO on PAGE_NONE
 - fix __ptep_set_access_flags() to be independant of clear/set order in pte_update()
v4: no change

 arch/powerpc/include/asm/pgtable-ppc32.h |  7 ++++---
 arch/powerpc/include/asm/pgtable.h       |  7 +++++--
 arch/powerpc/include/asm/pte-common.h    | 25 +++++++++++++++++--------
 arch/powerpc/mm/gup.c                    |  2 ++
 arch/powerpc/mm/pgtable_32.c             |  2 +-
 5 files changed, 29 insertions(+), 14 deletions(-)

diff --git a/arch/powerpc/include/asm/pgtable-ppc32.h b/arch/powerpc/include/asm/pgtable-ppc32.h
index 543bb8e..caf094a 100644
--- a/arch/powerpc/include/asm/pgtable-ppc32.h
+++ b/arch/powerpc/include/asm/pgtable-ppc32.h
@@ -275,7 +275,7 @@ static inline pte_t ptep_get_and_clear(struct mm_struct *mm, unsigned long addr,
 static inline void ptep_set_wrprotect(struct mm_struct *mm, unsigned long addr,
 				      pte_t *ptep)
 {
-	pte_update(ptep, (_PAGE_RW | _PAGE_HWWRITE), 0);
+	pte_update(ptep, (_PAGE_RW | _PAGE_HWWRITE), _PAGE_RO);
 }
 static inline void huge_ptep_set_wrprotect(struct mm_struct *mm,
 					   unsigned long addr, pte_t *ptep)
@@ -286,9 +286,10 @@ static inline void huge_ptep_set_wrprotect(struct mm_struct *mm,
 
 static inline void __ptep_set_access_flags(pte_t *ptep, pte_t entry)
 {
-	unsigned long bits = pte_val(entry) &
+	unsigned long set = pte_val(entry) &
 		(_PAGE_DIRTY | _PAGE_ACCESSED | _PAGE_RW | _PAGE_EXEC);
-	pte_update(ptep, 0, bits);
+	unsigned long clr = ~pte_val(entry) & _PAGE_RO;
+	pte_update(ptep, clr, set);
 }
 
 #define __HAVE_ARCH_PTE_SAME
diff --git a/arch/powerpc/include/asm/pgtable.h b/arch/powerpc/include/asm/pgtable.h
index 316f9a5..0f713fa 100644
--- a/arch/powerpc/include/asm/pgtable.h
+++ b/arch/powerpc/include/asm/pgtable.h
@@ -30,7 +30,8 @@ struct mm_struct;
 #include <asm/tlbflush.h>
 
 /* Generic accessors to PTE bits */
-static inline int pte_write(pte_t pte)		{ return pte_val(pte) & _PAGE_RW; }
+static inline int pte_write(pte_t pte)
+{	return (pte_val(pte) & (_PAGE_RW | _PAGE_RO)) != _PAGE_RO; }
 static inline int pte_dirty(pte_t pte)		{ return pte_val(pte) & _PAGE_DIRTY; }
 static inline int pte_young(pte_t pte)		{ return pte_val(pte) & _PAGE_ACCESSED; }
 static inline int pte_file(pte_t pte)		{ return pte_val(pte) & _PAGE_FILE; }
@@ -115,12 +116,14 @@ static inline unsigned long pte_pfn(pte_t pte)	{
 
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
index e040c35..2aef9b7 100644
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
@@ -128,11 +134,14 @@ extern unsigned long bad_call_to_PMD_PAGE_SIZE(void);
  */
 #define PAGE_NONE	__pgprot(_PAGE_BASE)
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
diff --git a/arch/powerpc/mm/pgtable_32.c b/arch/powerpc/mm/pgtable_32.c
index a349089..5519168 100644
--- a/arch/powerpc/mm/pgtable_32.c
+++ b/arch/powerpc/mm/pgtable_32.c
@@ -148,7 +148,7 @@ void __iomem *
 ioremap_prot(phys_addr_t addr, unsigned long size, unsigned long flags)
 {
 	/* writeable implies dirty for kernel addresses */
-	if (flags & _PAGE_RW)
+	if ((flags & (_PAGE_RW | _PAGE_RO)) != _PAGE_RO)
 		flags |= _PAGE_DIRTY | _PAGE_HWWRITE;
 
 	/* we don't want to let _PAGE_USER and _PAGE_EXEC leak out */
-- 
2.1.0

