Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753724AbbATKDl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 05:03:41 -0500
Received: from pegase1.c-s.fr ([93.17.236.30]:40485 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753289AbbATJ5i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 04:57:38 -0500
From: Christophe Leroy <christophe.leroy@c-s.fr>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>, scottwood@freescale.com
CC: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Joakim Tjernlund <joakim.tjernlund@transmode.se>
Subject: [PATCH v2 04/11] powerpc/8xx: Take benefit of aligned PGDIR
Message-Id: <20150120095734.7E9631A5E89@localhost.localdomain>
Date: Tue, 20 Jan 2015 10:57:34 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

L1 base address is now aligned so we can insert L1 index into r11 directly and
then preserve r10

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>

---
v2: no change

 arch/powerpc/kernel/head_8xx.S | 34 +++++++++++++++-------------------
 1 file changed, 15 insertions(+), 19 deletions(-)

diff --git a/arch/powerpc/kernel/head_8xx.S b/arch/powerpc/kernel/head_8xx.S
index 2c329f1..ae05f28 100644
--- a/arch/powerpc/kernel/head_8xx.S
+++ b/arch/powerpc/kernel/head_8xx.S
@@ -326,16 +326,15 @@ InstructionTLBMiss:
 	ori	r11, r11, (swapper_pg_dir-PAGE_OFFSET)@l
 3:
 #endif
-	/* Extract level 1 index */
-	rlwinm	r10, r10, 32 - ((PAGE_SHIFT - 2) << 1), (PAGE_SHIFT - 2) << 1, 29
-	lwzx	r11, r10, r11	/* Get the level 1 entry */
-	rlwinm	r10, r11,0,0,19	/* Extract page descriptor page address */
+	/* Insert level 1 index */
+	rlwimi	r11, r10, 32 - ((PAGE_SHIFT - 2) << 1), (PAGE_SHIFT - 2) << 1, 29
+	lwz	r11, 0(r11)	/* Get the level 1 entry */
 
 	/* Load the MI_TWC with the attributes for this "segment." */
 	MTSPR_CPU6(SPRN_MI_TWC, r11, r3)	/* Set segment attributes */
-	mfspr	r11, SPRN_SRR0	/* Get effective address of fault */
+	rlwinm	r11, r11,0,0,19	/* Extract page descriptor page address */
 	/* Extract level 2 index */
-	rlwinm	r11, r11, 32 - (PAGE_SHIFT - 2), 32 - PAGE_SHIFT, 29
+	rlwinm	r10, r10, 32 - (PAGE_SHIFT - 2), 32 - PAGE_SHIFT, 29
 	lwzx	r10, r10, r11	/* Get the pte */
 
 #ifdef CONFIG_SWAP
@@ -380,13 +379,12 @@ DataStoreTLBMiss:
 	lis	r11, (swapper_pg_dir-PAGE_OFFSET)@h
 	ori	r11, r11, (swapper_pg_dir-PAGE_OFFSET)@l
 3:
-	/* Extract level 1 index */
-	rlwinm	r10, r10, 32 - ((PAGE_SHIFT - 2) << 1), (PAGE_SHIFT - 2) << 1, 29
-	lwzx	r11, r10, r11	/* Get the level 1 entry */
+	/* Insert level 1 index */
+	rlwimi	r11, r10, 32 - ((PAGE_SHIFT - 2) << 1), (PAGE_SHIFT - 2) << 1, 29
+	lwz	r11, 0(r11)	/* Get the level 1 entry */
 
 	/* We have a pte table, so load fetch the pte from the table.
 	 */
-	mfspr	r10, SPRN_MD_EPN	/* Get address of fault */
 	/* Extract level 2 index */
 	rlwinm	r10, r10, 32 - (PAGE_SHIFT - 2), 32 - PAGE_SHIFT, 29
 	rlwimi	r10, r11, 0, 0, 32 - PAGE_SHIFT - 1	/* Add level 2 base */
@@ -515,16 +513,14 @@ FixupDAR:/* Entry point for dcbx workaround. */
 	beq-	3f		/* Branch if user space */
 	lis	r11, (swapper_pg_dir-PAGE_OFFSET)@h
 	ori	r11, r11, (swapper_pg_dir-PAGE_OFFSET)@l
-	/* Extract level 1 index */
-3:	rlwinm	r10, r10, 32 - ((PAGE_SHIFT - 2) << 1), (PAGE_SHIFT - 2) << 1, 29
-	lwzx	r11, r10, r11	/* Get the level 1 entry */
-	rlwinm	r10, r11,0,0,19	/* Extract page descriptor page address */
-	mfspr	r11, SPRN_SRR0	/* Get effective address of fault */
-	/* Extract level 2 index */
-	rlwinm	r11, r11, 32 - (PAGE_SHIFT - 2), 32 - PAGE_SHIFT, 29
-	lwzx	r11, r10, r11	/* Get the pte */
+	/* Insert level 1 index */
+3:	rlwimi	r11, r10, 32 - ((PAGE_SHIFT - 2) << 1), (PAGE_SHIFT - 2) << 1, 29
+	lwz	r11, 0(r11)	/* Get the level 1 entry */
+	rlwinm	r11, r11,0,0,19	/* Extract page descriptor page address */
+	/* Insert level 2 index */
+	rlwimi	r11, r10, 32 - (PAGE_SHIFT - 2), 32 - PAGE_SHIFT, 29
+	lwz	r11, 0(r11)	/* Get the pte */
 	/* concat physical page address(r11) and page offset(r10) */
-	mfspr	r10, SPRN_SRR0
 	rlwimi	r11, r10, 0, 32 - PAGE_SHIFT, 31
 	lwz	r11,0(r11)
 /* Check if it really is a dcbx instruction. */
-- 
2.1.0

