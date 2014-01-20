Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753938AbaATO6y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 09:58:54 -0500
Received: from mail-ee0-f50.google.com ([74.125.83.50]:51949 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740AbaATO6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 09:58:51 -0500
Date: Mon, 20 Jan 2014 15:58:47 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/mm changes for v3.14
Message-ID: <20140120145847.GA15317@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-mm-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-mm-for-linus

   # HEAD: f3d815cb854b2f6262ade56a4d91a1ed3f1e50c4 x86/mm/numa: Fix 32-bit kernel NUMA boot

A cleanup, a fix and ASLR support for hugetlb mappings.

 Thanks,

	Ingo

------------------>
Cyrill Gorcunov (1):
      x86/mm: Unify pte_to_pgoff() and pgoff_to_pte() helpers

Kirill A. Shutemov (1):
      x86/mm: Implement ASLR for hugetlb mappings

Lans Zhang (1):
      x86/mm/numa: Fix 32-bit kernel NUMA boot


 arch/x86/include/asm/page.h           |   1 +
 arch/x86/include/asm/page_32.h        |   4 --
 arch/x86/include/asm/pgtable-2level.h | 100 ++++++++++++++++++++--------------
 arch/x86/mm/hugetlbpage.c             |   9 +--
 arch/x86/mm/numa.c                    |  10 +++-
 5 files changed, 70 insertions(+), 54 deletions(-)

diff --git a/arch/x86/include/asm/page.h b/arch/x86/include/asm/page.h
index c878924..775873d 100644
--- a/arch/x86/include/asm/page.h
+++ b/arch/x86/include/asm/page.h
@@ -71,6 +71,7 @@ extern bool __virt_addr_valid(unsigned long kaddr);
 #include <asm-generic/getorder.h>
 
 #define __HAVE_ARCH_GATE_AREA 1
+#define HAVE_ARCH_HUGETLB_UNMAPPED_AREA
 
 #endif	/* __KERNEL__ */
 #endif /* _ASM_X86_PAGE_H */
diff --git a/arch/x86/include/asm/page_32.h b/arch/x86/include/asm/page_32.h
index 4d550d0..904f528 100644
--- a/arch/x86/include/asm/page_32.h
+++ b/arch/x86/include/asm/page_32.h
@@ -5,10 +5,6 @@
 
 #ifndef __ASSEMBLY__
 
-#ifdef CONFIG_HUGETLB_PAGE
-#define HAVE_ARCH_HUGETLB_UNMAPPED_AREA
-#endif
-
 #define __phys_addr_nodebug(x)	((x) - PAGE_OFFSET)
 #ifdef CONFIG_DEBUG_VIRTUAL
 extern unsigned long __phys_addr(unsigned long);
diff --git a/arch/x86/include/asm/pgtable-2level.h b/arch/x86/include/asm/pgtable-2level.h
index 3bf2dd0..0d193e2 100644
--- a/arch/x86/include/asm/pgtable-2level.h
+++ b/arch/x86/include/asm/pgtable-2level.h
@@ -55,6 +55,13 @@ static inline pmd_t native_pmdp_get_and_clear(pmd_t *xp)
 #define native_pmdp_get_and_clear(xp) native_local_pmdp_get_and_clear(xp)
 #endif
 
+/* Bit manipulation helper on pte/pgoff entry */
+static inline unsigned long pte_bitop(unsigned long value, unsigned int rightshift,
+				      unsigned long mask, unsigned int leftshift)
+{
+	return ((value >> rightshift) & mask) << leftshift;
+}
+
 #ifdef CONFIG_MEM_SOFT_DIRTY
 
 /*
@@ -71,31 +78,34 @@ static inline pmd_t native_pmdp_get_and_clear(pmd_t *xp)
 #define PTE_FILE_BITS2		(PTE_FILE_SHIFT3 - PTE_FILE_SHIFT2 - 1)
 #define PTE_FILE_BITS3		(PTE_FILE_SHIFT4 - PTE_FILE_SHIFT3 - 1)
 
-#define pte_to_pgoff(pte)						\
-	((((pte).pte_low >> (PTE_FILE_SHIFT1))				\
-	  & ((1U << PTE_FILE_BITS1) - 1)))				\
-	+ ((((pte).pte_low >> (PTE_FILE_SHIFT2))			\
-	    & ((1U << PTE_FILE_BITS2) - 1))				\
-	   << (PTE_FILE_BITS1))						\
-	+ ((((pte).pte_low >> (PTE_FILE_SHIFT3))			\
-	    & ((1U << PTE_FILE_BITS3) - 1))				\
-	   << (PTE_FILE_BITS1 + PTE_FILE_BITS2))			\
-	+ ((((pte).pte_low >> (PTE_FILE_SHIFT4)))			\
-	    << (PTE_FILE_BITS1 + PTE_FILE_BITS2 + PTE_FILE_BITS3))
-
-#define pgoff_to_pte(off)						\
-	((pte_t) { .pte_low =						\
-	 ((((off)) & ((1U << PTE_FILE_BITS1) - 1)) << PTE_FILE_SHIFT1)	\
-	 + ((((off) >> PTE_FILE_BITS1)					\
-	     & ((1U << PTE_FILE_BITS2) - 1))				\
-	    << PTE_FILE_SHIFT2)						\
-	 + ((((off) >> (PTE_FILE_BITS1 + PTE_FILE_BITS2))		\
-	     & ((1U << PTE_FILE_BITS3) - 1))				\
-	    << PTE_FILE_SHIFT3)						\
-	 + ((((off) >>							\
-	      (PTE_FILE_BITS1 + PTE_FILE_BITS2 + PTE_FILE_BITS3)))	\
-	    << PTE_FILE_SHIFT4)						\
-	 + _PAGE_FILE })
+#define PTE_FILE_MASK1		((1U << PTE_FILE_BITS1) - 1)
+#define PTE_FILE_MASK2		((1U << PTE_FILE_BITS2) - 1)
+#define PTE_FILE_MASK3		((1U << PTE_FILE_BITS3) - 1)
+
+#define PTE_FILE_LSHIFT2	(PTE_FILE_BITS1)
+#define PTE_FILE_LSHIFT3	(PTE_FILE_BITS1 + PTE_FILE_BITS2)
+#define PTE_FILE_LSHIFT4	(PTE_FILE_BITS1 + PTE_FILE_BITS2 + PTE_FILE_BITS3)
+
+static __always_inline pgoff_t pte_to_pgoff(pte_t pte)
+{
+	return (pgoff_t)
+		(pte_bitop(pte.pte_low, PTE_FILE_SHIFT1, PTE_FILE_MASK1,  0)		    +
+		 pte_bitop(pte.pte_low, PTE_FILE_SHIFT2, PTE_FILE_MASK2,  PTE_FILE_LSHIFT2) +
+		 pte_bitop(pte.pte_low, PTE_FILE_SHIFT3, PTE_FILE_MASK3,  PTE_FILE_LSHIFT3) +
+		 pte_bitop(pte.pte_low, PTE_FILE_SHIFT4,           -1UL,  PTE_FILE_LSHIFT4));
+}
+
+static __always_inline pte_t pgoff_to_pte(pgoff_t off)
+{
+	return (pte_t){
+		.pte_low =
+			pte_bitop(off,                0, PTE_FILE_MASK1,  PTE_FILE_SHIFT1) +
+			pte_bitop(off, PTE_FILE_LSHIFT2, PTE_FILE_MASK2,  PTE_FILE_SHIFT2) +
+			pte_bitop(off, PTE_FILE_LSHIFT3, PTE_FILE_MASK3,  PTE_FILE_SHIFT3) +
+			pte_bitop(off, PTE_FILE_LSHIFT4,           -1UL,  PTE_FILE_SHIFT4) +
+			_PAGE_FILE,
+	};
+}
 
 #else /* CONFIG_MEM_SOFT_DIRTY */
 
@@ -115,22 +125,30 @@ static inline pmd_t native_pmdp_get_and_clear(pmd_t *xp)
 #define PTE_FILE_BITS1		(PTE_FILE_SHIFT2 - PTE_FILE_SHIFT1 - 1)
 #define PTE_FILE_BITS2		(PTE_FILE_SHIFT3 - PTE_FILE_SHIFT2 - 1)
 
-#define pte_to_pgoff(pte)						\
-	((((pte).pte_low >> PTE_FILE_SHIFT1)				\
-	  & ((1U << PTE_FILE_BITS1) - 1))				\
-	 + ((((pte).pte_low >> PTE_FILE_SHIFT2)				\
-	     & ((1U << PTE_FILE_BITS2) - 1)) << PTE_FILE_BITS1)		\
-	 + (((pte).pte_low >> PTE_FILE_SHIFT3)				\
-	    << (PTE_FILE_BITS1 + PTE_FILE_BITS2)))
-
-#define pgoff_to_pte(off)						\
-	((pte_t) { .pte_low =						\
-	 (((off) & ((1U << PTE_FILE_BITS1) - 1)) << PTE_FILE_SHIFT1)	\
-	 + ((((off) >> PTE_FILE_BITS1) & ((1U << PTE_FILE_BITS2) - 1))	\
-	    << PTE_FILE_SHIFT2)						\
-	 + (((off) >> (PTE_FILE_BITS1 + PTE_FILE_BITS2))		\
-	    << PTE_FILE_SHIFT3)						\
-	 + _PAGE_FILE })
+#define PTE_FILE_MASK1		((1U << PTE_FILE_BITS1) - 1)
+#define PTE_FILE_MASK2		((1U << PTE_FILE_BITS2) - 1)
+
+#define PTE_FILE_LSHIFT2	(PTE_FILE_BITS1)
+#define PTE_FILE_LSHIFT3	(PTE_FILE_BITS1 + PTE_FILE_BITS2)
+
+static __always_inline pgoff_t pte_to_pgoff(pte_t pte)
+{
+	return (pgoff_t)
+		(pte_bitop(pte.pte_low, PTE_FILE_SHIFT1, PTE_FILE_MASK1,  0)		    +
+		 pte_bitop(pte.pte_low, PTE_FILE_SHIFT2, PTE_FILE_MASK2,  PTE_FILE_LSHIFT2) +
+		 pte_bitop(pte.pte_low, PTE_FILE_SHIFT3,           -1UL,  PTE_FILE_LSHIFT3));
+}
+
+static __always_inline pte_t pgoff_to_pte(pgoff_t off)
+{
+	return (pte_t){
+		.pte_low =
+			pte_bitop(off,                0, PTE_FILE_MASK1,  PTE_FILE_SHIFT1) +
+			pte_bitop(off, PTE_FILE_LSHIFT2, PTE_FILE_MASK2,  PTE_FILE_SHIFT2) +
+			pte_bitop(off, PTE_FILE_LSHIFT3,           -1UL,  PTE_FILE_SHIFT3) +
+			_PAGE_FILE,
+	};
+}
 
 #endif /* CONFIG_MEM_SOFT_DIRTY */
 
diff --git a/arch/x86/mm/hugetlbpage.c b/arch/x86/mm/hugetlbpage.c
index 9d980d8..8c9f647 100644
--- a/arch/x86/mm/hugetlbpage.c
+++ b/arch/x86/mm/hugetlbpage.c
@@ -87,9 +87,7 @@ int pmd_huge_support(void)
 }
 #endif
 
-/* x86_64 also uses this file */
-
-#ifdef HAVE_ARCH_HUGETLB_UNMAPPED_AREA
+#ifdef CONFIG_HUGETLB_PAGE
 static unsigned long hugetlb_get_unmapped_area_bottomup(struct file *file,
 		unsigned long addr, unsigned long len,
 		unsigned long pgoff, unsigned long flags)
@@ -99,7 +97,7 @@ static unsigned long hugetlb_get_unmapped_area_bottomup(struct file *file,
 
 	info.flags = 0;
 	info.length = len;
-	info.low_limit = TASK_UNMAPPED_BASE;
+	info.low_limit = current->mm->mmap_legacy_base;
 	info.high_limit = TASK_SIZE;
 	info.align_mask = PAGE_MASK & ~huge_page_mask(h);
 	info.align_offset = 0;
@@ -172,8 +170,7 @@ hugetlb_get_unmapped_area(struct file *file, unsigned long addr,
 		return hugetlb_get_unmapped_area_topdown(file, addr, len,
 				pgoff, flags);
 }
-
-#endif /*HAVE_ARCH_HUGETLB_UNMAPPED_AREA*/
+#endif /* CONFIG_HUGETLB_PAGE */
 
 #ifdef CONFIG_X86_64
 static __init int setup_hugepagesz(char *opt)
diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index 24aec58..c85da7b 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -211,9 +211,13 @@ static void __init setup_node_data(int nid, u64 start, u64 end)
 	 */
 	nd_pa = memblock_alloc_nid(nd_size, SMP_CACHE_BYTES, nid);
 	if (!nd_pa) {
-		pr_err("Cannot find %zu bytes in node %d\n",
-		       nd_size, nid);
-		return;
+		nd_pa = __memblock_alloc_base(nd_size, SMP_CACHE_BYTES,
+					      MEMBLOCK_ALLOC_ACCESSIBLE);
+		if (!nd_pa) {
+			pr_err("Cannot find %zu bytes in node %d\n",
+			       nd_size, nid);
+			return;
+		}
 	}
 	nd = __va(nd_pa);
 
