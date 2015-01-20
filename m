Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753788AbbATKEv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 05:04:51 -0500
Received: from pegase1.c-s.fr ([93.17.236.30]:40471 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753070AbbATJ5h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 04:57:37 -0500
From: Christophe Leroy <christophe.leroy@c-s.fr>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>, scottwood@freescale.com
CC: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Joakim Tjernlund <joakim.tjernlund@transmode.se>
Subject: [PATCH v2 05/11] powerpc/8xx: Optimise access to swapper_pg_dir
Message-Id: <20150120095734.AE7751A5E8A@localhost.localdomain>
Date: Tue, 20 Jan 2015 10:57:34 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All accessed to PGD entries are done via 0(r11).
By using lower part of swapper_pg_dir as load index to r11, we can remove the
ori instruction.

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>

---
v2: fixed/added comments to explain what is the real content of M_TW

 arch/powerpc/kernel/head_8xx.S | 35 +++++++++++++++++++----------------
 1 file changed, 19 insertions(+), 16 deletions(-)

diff --git a/arch/powerpc/kernel/head_8xx.S b/arch/powerpc/kernel/head_8xx.S
index ae05f28..a485ad7 100644
--- a/arch/powerpc/kernel/head_8xx.S
+++ b/arch/powerpc/kernel/head_8xx.S
@@ -319,16 +319,15 @@ InstructionTLBMiss:
 	 * pin the first 8MB of kernel memory */
 	andis.	r11, r10, 0x8000	/* Address >= 0x80000000 */
 #endif
-	mfspr	r11, SPRN_M_TW	/* Get level 1 table base address */
+	mfspr	r11, SPRN_M_TW	/* Get level 1 table */
 #ifdef CONFIG_MODULES
 	beq	3f
-	lis	r11, (swapper_pg_dir-PAGE_OFFSET)@h
-	ori	r11, r11, (swapper_pg_dir-PAGE_OFFSET)@l
+	lis	r11, (swapper_pg_dir-PAGE_OFFSET)@ha
 3:
 #endif
 	/* Insert level 1 index */
 	rlwimi	r11, r10, 32 - ((PAGE_SHIFT - 2) << 1), (PAGE_SHIFT - 2) << 1, 29
-	lwz	r11, 0(r11)	/* Get the level 1 entry */
+	lwz	r11, (swapper_pg_dir-PAGE_OFFSET)@l(r11)	/* Get the level 1 entry */
 
 	/* Load the MI_TWC with the attributes for this "segment." */
 	MTSPR_CPU6(SPRN_MI_TWC, r11, r3)	/* Set segment attributes */
@@ -374,14 +373,13 @@ DataStoreTLBMiss:
 	 * kernel page tables.
 	 */
 	andis.	r11, r10, 0x8000
-	mfspr	r11, SPRN_M_TW	/* Get level 1 table base address */
+	mfspr	r11, SPRN_M_TW	/* Get level 1 table */
 	beq	3f
-	lis	r11, (swapper_pg_dir-PAGE_OFFSET)@h
-	ori	r11, r11, (swapper_pg_dir-PAGE_OFFSET)@l
+	lis	r11, (swapper_pg_dir-PAGE_OFFSET)@ha
 3:
 	/* Insert level 1 index */
 	rlwimi	r11, r10, 32 - ((PAGE_SHIFT - 2) << 1), (PAGE_SHIFT - 2) << 1, 29
-	lwz	r11, 0(r11)	/* Get the level 1 entry */
+	lwz	r11, (swapper_pg_dir-PAGE_OFFSET)@l(r11)	/* Get the level 1 entry */
 
 	/* We have a pte table, so load fetch the pte from the table.
 	 */
@@ -509,13 +507,12 @@ FixupDAR:/* Entry point for dcbx workaround. */
 	/* fetch instruction from memory. */
 	mfspr	r10, SPRN_SRR0
 	andis.	r11, r10, 0x8000	/* Address >= 0x80000000 */
-	mfspr	r11, SPRN_M_TW	/* Get level 1 table base address */
-	beq-	3f		/* Branch if user space */
-	lis	r11, (swapper_pg_dir-PAGE_OFFSET)@h
-	ori	r11, r11, (swapper_pg_dir-PAGE_OFFSET)@l
+	mfspr	r11, SPRN_M_TW	/* Get level 1 table */
+	beq	3f
+	lis	r11, (swapper_pg_dir-PAGE_OFFSET)@ha
 	/* Insert level 1 index */
 3:	rlwimi	r11, r10, 32 - ((PAGE_SHIFT - 2) << 1), (PAGE_SHIFT - 2) << 1, 29
-	lwz	r11, 0(r11)	/* Get the level 1 entry */
+	lwz	r11, (swapper_pg_dir-PAGE_OFFSET)@l(r11)	/* Get the level 1 entry */
 	rlwinm	r11, r11,0,0,19	/* Extract page descriptor page address */
 	/* Insert level 2 index */
 	rlwimi	r11, r10, 32 - (PAGE_SHIFT - 2), 32 - PAGE_SHIFT, 29
@@ -670,8 +667,7 @@ start_here:
 	 * init's THREAD like the context switch code does, but this is
 	 * easier......until someone changes init's static structures.
 	 */
-	lis	r6, swapper_pg_dir@h
-	ori	r6, r6, swapper_pg_dir@l
+	lis	r6, swapper_pg_dir@ha
 	tophys(r6,r6)
 #ifdef CONFIG_8xx_CPU6
 	lis	r4, cpu6_errata_word@h
@@ -850,6 +846,13 @@ _GLOBAL(set_context)
 	stw	r4, 0x4(r5)
 #endif
 
+	/* Register M_TW will contain base address of level 1 table minus the
+	 * lower part of the kernel PGDIR base address, so that all accesses to
+	 * level 1 table are done relative to lower part of kernel PGDIR base
+	 * address.
+	 */
+	li	r5, (swapper_pg_dir-PAGE_OFFSET)@l
+	sub	r4, r4, r5
 #ifdef CONFIG_8xx_CPU6
 	lis	r6, cpu6_errata_word@h
 	ori	r6, r6, cpu6_errata_word@l
@@ -857,7 +860,7 @@ _GLOBAL(set_context)
 	li	r7, 0x3f80
 	stw	r7, 12(r6)
 	lwz	r7, 12(r6)
-        mtspr   SPRN_M_TW, r4               /* Update MMU base address */
+	mtspr	SPRN_M_TW, r4		/* Update pointeur to level 1 table */
 	li	r7, 0x3380
 	stw	r7, 12(r6)
 	lwz	r7, 12(r6)
-- 
2.1.0

