Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932730AbaLJSBT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 13:01:19 -0500
Received: from pegase1.c-s.fr ([93.17.236.30]:18025 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932452AbaLJSBP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 13:01:15 -0500
From: Christophe Leroy <christophe.leroy@c-s.fr>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>, scottwood@freescale.com
CC: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH 3/4] powerpc32: adds direct support to hardware inverted values in pte accessors
Message-Id: <20141210180041.7624D1A5D62@localhost.localdomain>
Date: Wed, 10 Dec 2014 19:00:41 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some powerpc like the 8xx do invert some PTE bits in HW. In order to avoid
having to invert the bits each time we set them into hardware, this patch adds
the invertion logic into the PTE accessors in order to get them already properly
inversed in the tables.

Inverted bits can be defined by _PTE_HW_INVERTED into the pte-XXX.h file

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>

---
 arch/powerpc/include/asm/page.h          |  8 +++----
 arch/powerpc/include/asm/pgtable-ppc32.h | 37 +++++++++++++++++++++-----------
 arch/powerpc/include/asm/pte-common.h    |  3 +++
 3 files changed, 32 insertions(+), 16 deletions(-)

diff --git a/arch/powerpc/include/asm/page.h b/arch/powerpc/include/asm/page.h
index 26fe1ae..2e7a3ff 100644
--- a/arch/powerpc/include/asm/page.h
+++ b/arch/powerpc/include/asm/page.h
@@ -285,8 +285,8 @@ extern long long virt_phys_offset;
 
 /* PTE level */
 typedef struct { pte_basic_t pte; } pte_t;
-#define pte_val(x)	((x).pte)
-#define __pte(x)	((pte_t) { (x) })
+#define pte_val(x)	((x).pte ^ _PTE_HW_INVERTED)
+#define __pte(x)	((pte_t) { ((x) ^ _PTE_HW_INVERTED) })
 
 /* 64k pages additionally define a bigger "real PTE" type that gathers
  * the "second half" part of the PTE for pseudo 64k pages
@@ -328,8 +328,8 @@ typedef struct { unsigned long pgprot; } pgprot_t;
  */
 
 typedef pte_basic_t pte_t;
-#define pte_val(x)	(x)
-#define __pte(x)	(x)
+#define pte_val(x)	((x) ^ _PTE_HW_INVERTED)
+#define __pte(x)	((x) ^ _PTE_HW_INVERTED)
 
 #if defined(CONFIG_PPC_64K_PAGES) && defined(CONFIG_PPC_STD_MMU_64)
 typedef struct { pte_t pte; unsigned long hidx; } real_pte_t;
diff --git a/arch/powerpc/include/asm/pgtable-ppc32.h b/arch/powerpc/include/asm/pgtable-ppc32.h
index 543bb8e..0e4a2a7 100644
--- a/arch/powerpc/include/asm/pgtable-ppc32.h
+++ b/arch/powerpc/include/asm/pgtable-ppc32.h
@@ -162,6 +162,12 @@ extern void flush_hash_entry(struct mm_struct *mm, pte_t *ptep,
  * to properly flush the virtually tagged instruction cache of
  * those implementations.
  */
+#if _PTE_HW_INVERTED == 0
+#define PTE_INVERT(val,flags)
+#else
+#define PTE_INVERT(val,flags) "xori	"#val","#val","#flags"\n"
+#endif
+
 #ifndef CONFIG_PTE_64BIT
 static inline unsigned long pte_update(pte_t *p,
 				       unsigned long clr,
@@ -174,30 +180,34 @@ static inline unsigned long pte_update(pte_t *p,
 	unsigned long tmp2;
 
 	__asm__ __volatile__("\
-1:	lwarx	%0,0,%4\n\
-	andc	%1,%0,%5\n\
+1:	lwarx	%0,0,%4\n"
+	PTE_INVERT(%0,%8)
+"	andc	%1,%0,%5\n\
 	or	%1,%1,%6\n\
 	/* 0x200 == Extended encoding, bit 22 */ \
 	/* Bit 22 has to be 1 if neither _PAGE_USER nor _PAGE_RW are set */ \
 	rlwimi	%1,%1,32-2,0x200\n /* get _PAGE_USER */ \
 	rlwinm	%3,%1,32-1,0x200\n /* get _PAGE_RW */ \
-	or	%1,%3,%1\n\
-	xori	%1,%1,0x200\n"
-"	stwcx.	%1,0,%4\n\
+	or	%1,%3,%1\n \
+	xori	%1,%1,%9\n\
+	stwcx.	%1,0,%4\n\
 	bne-	1b"
 	: "=&r" (old), "=&r" (tmp), "=m" (*p), "=&r" (tmp2)
-	: "r" (p), "r" (clr), "r" (set), "m" (*p)
+	: "r" (p), "r" (clr), "r" (set), "m" (*p), "i"(_PTE_HW_INVERTED),
+	  "i"(_PTE_HW_INVERTED|0x200)
 	: "cc" );
 #else /* CONFIG_PPC_8xx */
 	__asm__ __volatile__("\
-1:	lwarx	%0,0,%3\n\
-	andc	%1,%0,%4\n\
+1:	lwarx	%0,0,%3\n"
+	PTE_INVERT(%0,%7)
+"	andc	%1,%0,%4\n\
 	or	%1,%1,%5\n"
+	PTE_INVERT(%1,%7)
 	PPC405_ERR77(0,%3)
 "	stwcx.	%1,0,%3\n\
 	bne-	1b"
 	: "=&r" (old), "=&r" (tmp), "=m" (*p)
-	: "r" (p), "r" (clr), "r" (set), "m" (*p)
+	: "r" (p), "r" (clr), "r" (set), "m" (*p), "i"(_PTE_HW_INVERTED)
 	: "cc" );
 #endif /* CONFIG_PPC_8xx */
 #else /* PTE_ATOMIC_UPDATES */
@@ -222,14 +232,17 @@ static inline unsigned long long pte_update(pte_t *p,
 
 	__asm__ __volatile__("\
 1:	lwarx	%L0,0,%4\n\
-	lwzx	%0,0,%3\n\
-	andc	%1,%L0,%5\n\
+	lwzx	%0,0,%3\n"
+	PTE_INVERT(%L0,%8)
+"	andc	%1,%L0,%5\n\
 	or	%1,%1,%6\n"
+	PTE_INVERT(%1,%8)
 	PPC405_ERR77(0,%3)
 "	stwcx.	%1,0,%4\n\
 	bne-	1b"
 	: "=&r" (old), "=&r" (tmp), "=m" (*p)
-	: "r" (p), "r" ((unsigned long)(p) + 4), "r" (clr), "r" (set), "m" (*p)
+	: "r" (p), "r" ((unsigned long)(p) + 4), "r" (clr), "r" (set), "m" (*p),
+	  "i"(_PTE_HW_INVERTED)
 	: "cc" );
 #else /* PTE_ATOMIC_UPDATES */
 	unsigned long long old = pte_val(*p);
diff --git a/arch/powerpc/include/asm/pte-common.h b/arch/powerpc/include/asm/pte-common.h
index e040c35..3d635fb 100644
--- a/arch/powerpc/include/asm/pte-common.h
+++ b/arch/powerpc/include/asm/pte-common.h
@@ -59,6 +59,9 @@
 #ifndef _PTE_NONE_MASK
 #define _PTE_NONE_MASK	_PAGE_HPTEFLAGS
 #endif
+#ifndef _PTE_HW_INVERTED
+#define _PTE_HW_INVERTED	0
+#endif
 
 /* Make sure we get a link error if PMD_PAGE_SIZE is ever called on a
  * kernel without large page PMD support
-- 
2.1.0

