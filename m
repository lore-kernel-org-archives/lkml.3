Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751793AbaLQJOi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 04:14:38 -0500
Received: from pegase1.c-s.fr ([93.17.236.30]:50904 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751329AbaLQJOe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 04:14:34 -0500
From: Christophe Leroy <christophe.leroy@c-s.fr>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>, scottwood@freescale.com
CC: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Joakim Tjernlund <joakim.tjernlund@transmode.se>
Subject: [v2 PATCH 2/2] powerpc/8xx: use _PAGE_RO instead of _PAGE_RW
Message-Id: <20141217091432.072901A5E12@localhost.localdomain>
Date: Wed, 17 Dec 2014 10:14:31 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On powerpc 8xx, in TLB entries, 0x400 bit is set to 1 for read-only pages
and is set to 0 for RW pages. So we should use _PAGE_RO instead of _PAGE_RW

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>

---
v2 is a complete rework compared to v1

 arch/powerpc/include/asm/pte-8xx.h | 7 +++----
 arch/powerpc/kernel/head_8xx.S     | 3 ---
 2 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/arch/powerpc/include/asm/pte-8xx.h b/arch/powerpc/include/asm/pte-8xx.h
index daa4616..4f5583e 100644
--- a/arch/powerpc/include/asm/pte-8xx.h
+++ b/arch/powerpc/include/asm/pte-8xx.h
@@ -46,7 +46,7 @@
  * require a TLB exception handler change.  It is assumed unused bits
  * are always zero.
  */
-#define _PAGE_RW	0x0400	/* lsb PP bits, inverted in HW */
+#define _PAGE_RO	0x0400	/* lsb PP bits */
 #define _PAGE_USER	0x0800	/* msb PP bits */
 /* set when neither _PAGE_USER nor _PAGE_RW are set */
 #define _PAGE_KNLRO	0x0200
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
index 3d4b8ee..807b0db 100644
--- a/arch/powerpc/kernel/head_8xx.S
+++ b/arch/powerpc/kernel/head_8xx.S
@@ -441,9 +441,6 @@ DataStoreTLBMiss:
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

