Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753329AbaH2JcO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 05:32:14 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:36372 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752085AbaH2JcH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 05:32:07 -0400
From: Christophe Leroy <christophe.leroy@c-s.fr>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
CC: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Joakim Tjernlund <joakim.tjernlund@transmode.se>,
        scottwood@freescale.com
Subject: [PATCH v2 17/19] powerpc/8xx: set PTE bit 22 off TLBmiss
Message-Id: <20140829091440.6DAD91ABD66@localhost.localdomain>
Date: Fri, 29 Aug 2014 11:14:40 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No need to re-set this bit at each TLB miss. Let's set it in the PTE.

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>

---
 arch/powerpc/include/asm/pgtable-ppc32.h |   21 +++++++++++++++++++++
 arch/powerpc/include/asm/pte-8xx.h       |    7 +++++--
 arch/powerpc/kernel/head_8xx.S           |   10 ++--------
 3 files changed, 28 insertions(+), 10 deletions(-)

diff --git a/arch/powerpc/include/asm/pgtable-ppc32.h b/arch/powerpc/include/asm/pgtable-ppc32.h
index 47edde8..c261792 100644
--- a/arch/powerpc/include/asm/pgtable-ppc32.h
+++ b/arch/powerpc/include/asm/pgtable-ppc32.h
@@ -172,6 +172,26 @@ static inline unsigned long pte_update(pte_t *p,
 #ifdef PTE_ATOMIC_UPDATES
 	unsigned long old, tmp;
 
+#ifdef CONFIG_PPC_8xx
+	unsigned long tmp2;
+
+	__asm__ __volatile__("\
+1:	lwarx	%0,0,%4\n\
+	andc	%1,%0,%5\n\
+	or	%1,%1,%6\n\
+	/* 0x200 == Extended encoding, bit 22 */ \
+	/* Bit 22 has to be 1 if neither _PAGE_USER nor _PAGE_RW are set */ \
+	rlwimi	%1,%1,32-2,0x200\n /* get _PAGE_USER */ \
+	rlwinm	%3,%1,32-1,0x200\n /* get _PAGE_RW */ \
+	or	%1,%3,%1\n\
+	xori	%1,%1,0x200\n"
+	PPC405_ERR77(0,%4)
+"	stwcx.	%1,0,%4\n\
+	bne-	1b"
+	: "=&r" (old), "=&r" (tmp), "=m" (*p), "=&r" (tmp2)
+	: "r" (p), "r" (clr), "r" (set), "m" (*p)
+	: "cc" );
+#else /* CONFIG_PPC_8xx */
 	__asm__ __volatile__("\
 1:	lwarx	%0,0,%3\n\
 	andc	%1,%0,%4\n\
@@ -182,6 +202,7 @@ static inline unsigned long pte_update(pte_t *p,
 	: "=&r" (old), "=&r" (tmp), "=m" (*p)
 	: "r" (p), "r" (clr), "r" (set), "m" (*p)
 	: "cc" );
+#endif /* CONFIG_PPC_8xx */
 #else /* PTE_ATOMIC_UPDATES */
 	unsigned long old = pte_val(*p);
 	*p = __pte((old & ~clr) | set);
diff --git a/arch/powerpc/include/asm/pte-8xx.h b/arch/powerpc/include/asm/pte-8xx.h
index d44826e..dede1e7 100644
--- a/arch/powerpc/include/asm/pte-8xx.h
+++ b/arch/powerpc/include/asm/pte-8xx.h
@@ -48,19 +48,22 @@
  */
 #define _PAGE_RW	0x0400	/* lsb PP bits, inverted in HW */
 #define _PAGE_USER	0x0800	/* msb PP bits */
+/* set when neither _PAGE_USER nor _PAGE_RW are set */
+#define _PAGE_KNLRO	0x0200
 
 #define _PMD_PRESENT	0x0001
 #define _PMD_BAD	0x0ff0
 #define _PMD_PAGE_MASK	0x000c
 #define _PMD_PAGE_8M	0x000c
 
-#define _PTE_NONE_MASK _PAGE_ACCESSED
+#define _PTE_NONE_MASK (_PAGE_ACCESSED | _PAGE_KNLRO)
 
 /* Until my rework is finished, 8xx still needs atomic PTE updates */
 #define PTE_ATOMIC_UPDATES	1
 
 /* We need to add _PAGE_SHARED to kernel pages */
-#define _PAGE_KERNEL_RO	(_PAGE_SHARED)
+#define _PAGE_KERNEL_RO	(_PAGE_SHARED | _PAGE_KNLRO)
+#define _PAGE_KERNEL_ROX	(_PAGE_EXEC | _PAGE_KNLRO)
 #define _PAGE_KERNEL_RW	(_PAGE_DIRTY | _PAGE_RW | _PAGE_HWWRITE)
 
 #endif /* __KERNEL__ */
diff --git a/arch/powerpc/kernel/head_8xx.S b/arch/powerpc/kernel/head_8xx.S
index a7af26e..48d3de8 100644
--- a/arch/powerpc/kernel/head_8xx.S
+++ b/arch/powerpc/kernel/head_8xx.S
@@ -445,14 +445,8 @@ DataStoreTLBMiss:
 	and	r11, r11, r10
 	rlwimi	r10, r11, 0, _PAGE_PRESENT
 #endif
-	/* Honour kernel RO, User NA */
-	/* 0x200 == Extended encoding, bit 22 */
-	rlwimi	r10, r10, 32-2, 0x200 /* Copy USER to bit 22, 0x200 */
-	/* r11 =  (r10 & _PAGE_RW) >> 1 */
-	rlwinm	r11, r10, 32-1, 0x200
-	or	r10, r11, r10
-	/* invert RW and 0x200 bits */
-	xori	r10, r10, _PAGE_RW | 0x200
+	/* invert RW */
+	xori	r10, r10, _PAGE_RW
 
 	/* The Linux PTE won't go exactly into the MMU TLB.
 	 * Software indicator bits 22 and 28 must be clear.
-- 
1.7.1

