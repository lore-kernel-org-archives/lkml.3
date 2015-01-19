Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752350AbbASQEr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 11:04:47 -0500
Received: from pegase1.c-s.fr ([93.17.236.30]:35471 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752283AbbASQEp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 11:04:45 -0500
From: Christophe Leroy <christophe.leroy@c-s.fr>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>, scottwood@freescale.com
CC: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Joakim Tjernlund <joakim.tjernlund@transmode.se>
Subject: [PATCH v4 2/2] powerpc/8xx: use _PAGE_RO instead of _PAGE_RW
Message-Id: <20150119160444.52D391A5E85@localhost.localdomain>
Date: Mon, 19 Jan 2015 17:04:44 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On powerpc 8xx, in TLB entries, 0x400 bit is set to 1 for read-only pages
and is set to 0 for RW pages. So we should use _PAGE_RO instead of _PAGE_RW

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>

---
v2 is a complete rework compared to v1
v3: fixing pte_update() and comments
v4: simplified pte_update() (andc instead of xori/or/xori)

 arch/powerpc/include/asm/pgtable-ppc32.h | 11 +++++------
 arch/powerpc/include/asm/pte-8xx.h       |  9 ++++-----
 arch/powerpc/kernel/head_8xx.S           |  3 ---
 3 files changed, 9 insertions(+), 14 deletions(-)

diff --git a/arch/powerpc/include/asm/pgtable-ppc32.h b/arch/powerpc/include/asm/pgtable-ppc32.h
index e455536..b3e9a3e 100644
--- a/arch/powerpc/include/asm/pgtable-ppc32.h
+++ b/arch/powerpc/include/asm/pgtable-ppc32.h
@@ -178,12 +178,11 @@ static inline unsigned long pte_update(pte_t *p,
 	andc	%1,%0,%5\n\
 	or	%1,%1,%6\n\
 	/* 0x200 == Extended encoding, bit 22 */ \
-	/* Bit 22 has to be 1 if neither _PAGE_USER nor _PAGE_RW are set */ \
-	rlwimi	%1,%1,32-2,0x200\n /* get _PAGE_USER */ \
-	rlwinm	%3,%1,32-1,0x200\n /* get _PAGE_RW */ \
-	or	%1,%3,%1\n\
-	xori	%1,%1,0x200\n"
-"	stwcx.	%1,0,%4\n\
+	/* Bit 22 has to be 1 when _PAGE_USER is unset and _PAGE_RO is set */ \
+	rlwimi	%1,%1,32-1,0x200\n /* get _PAGE_RO */ \
+	rlwinm	%3,%1,32-2,0x200\n /* get _PAGE_USER */ \
+	andc	%1,%1,%3\n\
+	stwcx.	%1,0,%4\n\
 	bne-	1b"
 	: "=&r" (old), "=&r" (tmp), "=m" (*p), "=&r" (tmp2)
 	: "r" (p), "r" (clr), "r" (set), "m" (*p)
diff --git a/arch/powerpc/include/asm/pte-8xx.h b/arch/powerpc/include/asm/pte-8xx.h
index daa4616..eb6edb4 100644
--- a/arch/powerpc/include/asm/pte-8xx.h
+++ b/arch/powerpc/include/asm/pte-8xx.h
@@ -46,9 +46,9 @@
  * require a TLB exception handler change.  It is assumed unused bits
  * are always zero.
  */
-#define _PAGE_RW	0x0400	/* lsb PP bits, inverted in HW */
+#define _PAGE_RO	0x0400	/* lsb PP bits */
 #define _PAGE_USER	0x0800	/* msb PP bits */
-/* set when neither _PAGE_USER nor _PAGE_RW are set */
+/* set when _PAGE_USER is unset and _PAGE_RO is set */
 #define _PAGE_KNLRO	0x0200
 
 #define _PMD_PRESENT	0x0001
@@ -62,9 +62,8 @@
 #define PTE_ATOMIC_UPDATES	1
 
 /* We need to add _PAGE_SHARED to kernel pages */
-#define _PAGE_KERNEL_RO	(_PAGE_SHARED | _PAGE_KNLRO)
-#define _PAGE_KERNEL_ROX	(_PAGE_EXEC | _PAGE_KNLRO)
-#define _PAGE_KERNEL_RW	(_PAGE_DIRTY | _PAGE_RW | _PAGE_HWWRITE)
+#define _PAGE_KERNEL_RO	(_PAGE_SHARED | _PAGE_RO | _PAGE_KNLRO)
+#define _PAGE_KERNEL_ROX	(_PAGE_EXEC | _PAGE_RO | _PAGE_KNLRO)
 
 #endif /* __KERNEL__ */
 #endif /*  _ASM_POWERPC_PTE_8xx_H */
diff --git a/arch/powerpc/kernel/head_8xx.S b/arch/powerpc/kernel/head_8xx.S
index d380658..61ef78d 100644
--- a/arch/powerpc/kernel/head_8xx.S
+++ b/arch/powerpc/kernel/head_8xx.S
@@ -458,9 +458,6 @@ DataStoreTLBMiss:
 	and	r11, r11, r10
 	rlwimi	r10, r11, 0, _PAGE_PRESENT
 #endif
-	/* invert RW */
-	xori	r10, r10, _PAGE_RW
-
 	/* The Linux PTE won't go exactly into the MMU TLB.
 	 * Software indicator bits 22 and 28 must be clear.
 	 * Software indicator bits 24, 25, 26, and 27 must be
-- 
2.1.0

