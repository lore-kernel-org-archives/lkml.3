Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951AbbATKlK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 05:41:10 -0500
Received: from pegase1.c-s.fr ([93.17.236.30]:41112 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752738AbbATKlI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 05:41:08 -0500
From: Christophe Leroy <christophe.leroy@c-s.fr>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>, scottwood@freescale.com
CC: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Joakim Tjernlund <joakim.tjernlund@transmode.se>
Subject: [PATCH v2 11/11] powerpc/8xx: Add support for TASK_SIZE greater than 0x80000000
Message-Id: <20150120095736.518681A5E86@localhost.localdomain>
Date: Tue, 20 Jan 2015 10:57:36 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By default, TASK_SIZE is set to 0x80000000 for PPC_8xx, which is most likely
sufficient for most cases. However, kernel configuration allows to set TASK_SIZE
to another value, so the 8xx shall handle it.

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>

---
v2: no change

 arch/powerpc/kernel/head_8xx.S | 25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/kernel/head_8xx.S b/arch/powerpc/kernel/head_8xx.S
index ead6448..92a6456 100644
--- a/arch/powerpc/kernel/head_8xx.S
+++ b/arch/powerpc/kernel/head_8xx.S
@@ -48,6 +48,19 @@
 	mtspr	spr, reg
 #endif
 
+/* Macro to test if an address is a kernel address */
+#if CONFIG_TASK_SIZE <= 0x80000000
+#define IS_KERNEL(tmp, addr)		\
+	andis.	tmp, addr, 0x8000	/* Address >= 0x80000000 */
+#define BRANCH_UNLESS_KERNEL(label)	beq	label
+#else
+#define IS_KERNEL(tmp, addr)		\
+	rlwinm	tmp, addr, 16, 16, 31;	\
+	cmpli	cr0, tmp, PAGE_OFFSET >> 16
+#define BRANCH_UNLESS_KERNEL(label)	blt	label
+#endif
+
+
 /*
  * Value for the bits that have fixed value in RPN entries.
  * Also used for tagging DAR for DTLBerror.
@@ -322,9 +335,9 @@ InstructionTLBMiss:
 	mfspr	r11, SPRN_SRR0	/* Get effective address of fault */
 	DO_8xx_CPU15(r10, r11)
 	mfcr	r10
-	andis.	r11, r11, 0x8000	/* Address >= 0x80000000 */
+	IS_KERNEL(r11, r11)
 	mfspr	r11, SPRN_M_TW	/* Get level 1 table */
-	beq	3f
+	BRANCH_UNLESS_KERNEL(3f)
 	lis	r11, (swapper_pg_dir-PAGE_OFFSET)@ha
 3:
 	mtcr	r10
@@ -379,9 +392,9 @@ DataStoreTLBMiss:
 	 * kernel page tables.
 	 */
 	mfspr	r11, SPRN_MD_EPN
-	andis.	r11, r11, 0x8000
+	IS_KERNEL(r11, r11)
 	mfspr	r11, SPRN_M_TW	/* Get level 1 table */
-	beq	3f
+	BRANCH_UNLESS_KERNEL(3f)
 	lis	r11, (swapper_pg_dir-PAGE_OFFSET)@ha
 3:
 	mtcr	r10
@@ -516,9 +529,9 @@ FixupDAR:/* Entry point for dcbx workaround. */
 	mtspr	SPRN_SPRG_SCRATCH2, r10
 	/* fetch instruction from memory. */
 	mfspr	r10, SPRN_SRR0
-	andis.	r11, r10, 0x8000	/* Address >= 0x80000000 */
+	IS_KERNEL(r11, r10)
 	mfspr	r11, SPRN_M_TW	/* Get level 1 table */
-	beq	3f
+	BRANCH_UNLESS_KERNEL(3f)
 	lis	r11, (swapper_pg_dir-PAGE_OFFSET)@ha
 	/* Insert level 1 index */
 3:	rlwimi	r11, r10, 32 - ((PAGE_SHIFT - 2) << 1), (PAGE_SHIFT - 2) << 1, 29
-- 
2.1.0

