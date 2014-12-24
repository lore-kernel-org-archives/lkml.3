Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752665AbaLXM00 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 07:26:26 -0500
Received: from mga09.intel.com ([134.134.136.24]:50935 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752121AbaLXMXO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 07:23:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,638,1413270000"; 
   d="scan'208";a="642376407"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: akpm@linux-foundation.org
Cc: peterz@infradead.org, mingo@kernel.org, davej@redhat.com,
        sasha.levin@oracle.com, hughd@google.com, linux-mm@kvack.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 33/38] sparc: drop pte_file()-related helpers
Date: Wed, 24 Dec 2014 14:22:41 +0200
Message-Id: <1419423766-114457-34-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1419423766-114457-1-git-send-email-kirill.shutemov@linux.intel.com>
References: <1419423766-114457-1-git-send-email-kirill.shutemov@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We've replaced remap_file_pages(2) implementation with emulation.
Nobody creates non-linear mapping anymore.

This patch also increase number of bits availble for swap offset.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: "David S. Miller" <davem@davemloft.net>
---
 arch/sparc/include/asm/pgtable_32.h | 24 ----------------------
 arch/sparc/include/asm/pgtable_64.h | 40 -------------------------------------
 arch/sparc/include/asm/pgtsrmmu.h   | 14 +++++--------
 3 files changed, 5 insertions(+), 73 deletions(-)

diff --git a/arch/sparc/include/asm/pgtable_32.h b/arch/sparc/include/asm/pgtable_32.h
index b9b91ae19fe1..b2f7dc46a7d1 100644
--- a/arch/sparc/include/asm/pgtable_32.h
+++ b/arch/sparc/include/asm/pgtable_32.h
@@ -221,14 +221,6 @@ static inline int pte_young(pte_t pte)
 	return pte_val(pte) & SRMMU_REF;
 }
 
-/*
- * The following only work if pte_present() is not true.
- */
-static inline int pte_file(pte_t pte)
-{
-	return pte_val(pte) & SRMMU_FILE;
-}
-
 static inline int pte_special(pte_t pte)
 {
 	return 0;
@@ -375,22 +367,6 @@ static inline swp_entry_t __swp_entry(unsigned long type, unsigned long offset)
 #define __pte_to_swp_entry(pte)		((swp_entry_t) { pte_val(pte) })
 #define __swp_entry_to_pte(x)		((pte_t) { (x).val })
 
-/* file-offset-in-pte helpers */
-static inline unsigned long pte_to_pgoff(pte_t pte)
-{
-	return pte_val(pte) >> SRMMU_PTE_FILE_SHIFT;
-}
-
-static inline pte_t pgoff_to_pte(unsigned long pgoff)
-{
-	return __pte((pgoff << SRMMU_PTE_FILE_SHIFT) | SRMMU_FILE);
-}
-
-/*
- * This is made a constant because mm/fremap.c required a constant.
- */
-#define PTE_FILE_MAX_BITS 24
-
 static inline unsigned long
 __get_phys (unsigned long addr)
 {
diff --git a/arch/sparc/include/asm/pgtable_64.h b/arch/sparc/include/asm/pgtable_64.h
index e890921d5a7a..ecd207f7eef3 100644
--- a/arch/sparc/include/asm/pgtable_64.h
+++ b/arch/sparc/include/asm/pgtable_64.h
@@ -137,7 +137,6 @@ bool kern_addr_valid(unsigned long addr);
 #define _PAGE_SOFT_4U	  _AC(0x0000000000001F80,UL) /* Software bits:       */
 #define _PAGE_EXEC_4U	  _AC(0x0000000000001000,UL) /* Executable SW bit    */
 #define _PAGE_MODIFIED_4U _AC(0x0000000000000800,UL) /* Modified (dirty)     */
-#define _PAGE_FILE_4U	  _AC(0x0000000000000800,UL) /* Pagecache page       */
 #define _PAGE_ACCESSED_4U _AC(0x0000000000000400,UL) /* Accessed (ref'd)     */
 #define _PAGE_READ_4U	  _AC(0x0000000000000200,UL) /* Readable SW Bit      */
 #define _PAGE_WRITE_4U	  _AC(0x0000000000000100,UL) /* Writable SW Bit      */
@@ -167,7 +166,6 @@ bool kern_addr_valid(unsigned long addr);
 #define _PAGE_EXEC_4V	  _AC(0x0000000000000080,UL) /* Executable Page      */
 #define _PAGE_W_4V	  _AC(0x0000000000000040,UL) /* Writable             */
 #define _PAGE_SOFT_4V	  _AC(0x0000000000000030,UL) /* Software bits        */
-#define _PAGE_FILE_4V	  _AC(0x0000000000000020,UL) /* Pagecache page       */
 #define _PAGE_PRESENT_4V  _AC(0x0000000000000010,UL) /* Present              */
 #define _PAGE_RESV_4V	  _AC(0x0000000000000008,UL) /* Reserved             */
 #define _PAGE_SZ16GB_4V	  _AC(0x0000000000000007,UL) /* 16GB Page            */
@@ -332,22 +330,6 @@ static inline pmd_t pmd_modify(pmd_t pmd, pgprot_t newprot)
 }
 #endif
 
-static inline pte_t pgoff_to_pte(unsigned long off)
-{
-	off <<= PAGE_SHIFT;
-
-	__asm__ __volatile__(
-	"\n661:	or		%0, %2, %0\n"
-	"	.section	.sun4v_1insn_patch, \"ax\"\n"
-	"	.word		661b\n"
-	"	or		%0, %3, %0\n"
-	"	.previous\n"
-	: "=r" (off)
-	: "0" (off), "i" (_PAGE_FILE_4U), "i" (_PAGE_FILE_4V));
-
-	return __pte(off);
-}
-
 static inline pgprot_t pgprot_noncached(pgprot_t prot)
 {
 	unsigned long val = pgprot_val(prot);
@@ -609,22 +591,6 @@ static inline unsigned long pte_exec(pte_t pte)
 	return (pte_val(pte) & mask);
 }
 
-static inline unsigned long pte_file(pte_t pte)
-{
-	unsigned long val = pte_val(pte);
-
-	__asm__ __volatile__(
-	"\n661:	and		%0, %2, %0\n"
-	"	.section	.sun4v_1insn_patch, \"ax\"\n"
-	"	.word		661b\n"
-	"	and		%0, %3, %0\n"
-	"	.previous\n"
-	: "=r" (val)
-	: "0" (val), "i" (_PAGE_FILE_4U), "i" (_PAGE_FILE_4V));
-
-	return val;
-}
-
 static inline unsigned long pte_present(pte_t pte)
 {
 	unsigned long val = pte_val(pte);
@@ -980,12 +946,6 @@ pgtable_t pgtable_trans_huge_withdraw(struct mm_struct *mm, pmd_t *pmdp);
 #define __pte_to_swp_entry(pte)		((swp_entry_t) { pte_val(pte) })
 #define __swp_entry_to_pte(x)		((pte_t) { (x).val })
 
-/* File offset in PTE support. */
-unsigned long pte_file(pte_t);
-#define pte_to_pgoff(pte)	(pte_val(pte) >> PAGE_SHIFT)
-pte_t pgoff_to_pte(unsigned long);
-#define PTE_FILE_MAX_BITS	(64UL - PAGE_SHIFT - 1UL)
-
 int page_in_phys_avail(unsigned long paddr);
 
 /*
diff --git a/arch/sparc/include/asm/pgtsrmmu.h b/arch/sparc/include/asm/pgtsrmmu.h
index 79da17866fa8..ae51a111a8c7 100644
--- a/arch/sparc/include/asm/pgtsrmmu.h
+++ b/arch/sparc/include/asm/pgtsrmmu.h
@@ -80,10 +80,6 @@
 #define SRMMU_PRIV         0x1c
 #define SRMMU_PRIV_RDONLY  0x18
 
-#define SRMMU_FILE         0x40	/* Implemented in software */
-
-#define SRMMU_PTE_FILE_SHIFT     8	/* == 32-PTE_FILE_MAX_BITS */
-
 #define SRMMU_CHG_MASK    (0xffffff00 | SRMMU_REF | SRMMU_DIRTY)
 
 /* SRMMU swap entry encoding
@@ -94,13 +90,13 @@
  * oooooooooooooooooootttttRRRRRRRR
  * fedcba9876543210fedcba9876543210
  *
- * The bottom 8 bits are reserved for protection and status bits, especially
- * FILE and PRESENT.
+ * The bottom 7 bits are reserved for protection and status bits, especially
+ * PRESENT.
  */
 #define SRMMU_SWP_TYPE_MASK	0x1f
-#define SRMMU_SWP_TYPE_SHIFT	SRMMU_PTE_FILE_SHIFT
-#define SRMMU_SWP_OFF_MASK	0x7ffff
-#define SRMMU_SWP_OFF_SHIFT	(SRMMU_PTE_FILE_SHIFT + 5)
+#define SRMMU_SWP_TYPE_SHIFT	7
+#define SRMMU_SWP_OFF_MASK	0xfffff
+#define SRMMU_SWP_OFF_SHIFT	(SRMMU_SWP_TYPE_SHIFT + 5)
 
 /* Some day I will implement true fine grained access bits for
  * user pages because the SRMMU gives us the capabilities to
-- 
2.1.3

