Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753808AbbATKEx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 05:04:53 -0500
Received: from pegase1.c-s.fr ([93.17.236.30]:40458 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752974AbbATJ5g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 04:57:36 -0500
From: Christophe Leroy <christophe.leroy@c-s.fr>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>, scottwood@freescale.com
CC: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Joakim Tjernlund <joakim.tjernlund@transmode.se>
Subject: [PATCH v2 02/11] powerpc/8xx: remove tests on PGDIR entry validity
Message-Id: <20150120095733.E60091A5E85@localhost.localdomain>
Date: Tue, 20 Jan 2015 10:57:33 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kernel MMU handling code handles validity of entries via _PMD_PRESENT which
corresponds to V bit in MD_TWC and MI_TWC. When the V bit is not set, MPC8xx
triggers TLBError exception. So we don't have to check that and branch ourself
to TLBError. We can set TLB entries with non present entries, remove all those
tests and let the 8xx handle it. This reduce the number of cycle when the
entries are valid which is the case most of the time, and doesn't significantly
increase the time for handling invalid entries.

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>

---
v2: no change

 arch/powerpc/kernel/head_8xx.S | 41 ++++++++---------------------------------
 1 file changed, 8 insertions(+), 33 deletions(-)

diff --git a/arch/powerpc/kernel/head_8xx.S b/arch/powerpc/kernel/head_8xx.S
index 79b8a23..2c329f1 100644
--- a/arch/powerpc/kernel/head_8xx.S
+++ b/arch/powerpc/kernel/head_8xx.S
@@ -329,12 +329,9 @@ InstructionTLBMiss:
 	/* Extract level 1 index */
 	rlwinm	r10, r10, 32 - ((PAGE_SHIFT - 2) << 1), (PAGE_SHIFT - 2) << 1, 29
 	lwzx	r11, r10, r11	/* Get the level 1 entry */
-	rlwinm.	r10, r11,0,0,19	/* Extract page descriptor page address */
-	beq	2f		/* If zero, don't try to find a pte */
+	rlwinm	r10, r11,0,0,19	/* Extract page descriptor page address */
 
-	/* We have a pte table, so load the MI_TWC with the attributes
-	 * for this "segment."
-	 */
+	/* Load the MI_TWC with the attributes for this "segment." */
 	MTSPR_CPU6(SPRN_MI_TWC, r11, r3)	/* Set segment attributes */
 	mfspr	r11, SPRN_SRR0	/* Get effective address of fault */
 	/* Extract level 2 index */
@@ -342,13 +339,11 @@ InstructionTLBMiss:
 	lwzx	r10, r10, r11	/* Get the pte */
 
 #ifdef CONFIG_SWAP
-	andi.	r11, r10, _PAGE_ACCESSED | _PAGE_PRESENT
-	cmpwi	cr0, r11, _PAGE_ACCESSED | _PAGE_PRESENT
-	li	r11, RPN_PATTERN
-	bne-	cr0, 2f
-#else
-	li	r11, RPN_PATTERN
+	rlwinm	r11, r10, 32-5, _PAGE_PRESENT
+	and	r11, r11, r10
+	rlwimi	r10, r11, 0, _PAGE_PRESENT
 #endif
+	li	r11, RPN_PATTERN
 	/* The Linux PTE won't go exactly into the MMU TLB.
 	 * Software indicator bits 21 and 28 must be clear.
 	 * Software indicator bits 24, 25, 26, and 27 must be
@@ -366,21 +361,6 @@ InstructionTLBMiss:
 	mfspr	r10, SPRN_SPRG_SCRATCH2
 	EXCEPTION_EPILOG_0
 	rfi
-2:
-	mfspr	r10, SPRN_SRR1
-	/* clear all error bits as TLB Miss
-	 * sets a few unconditionally
-	*/
-	rlwinm	r10, r10, 0, 0xffff
-	mtspr	SPRN_SRR1, r10
-
-	/* Restore registers */
-#ifdef CONFIG_8xx_CPU6
-	mfspr	r3, SPRN_DAR
-	mtspr	SPRN_DAR, r11	/* Tag DAR */
-#endif
-	mfspr	r10, SPRN_SPRG_SCRATCH2
-	b	InstructionTLBError1
 
 	. = 0x1200
 DataStoreTLBMiss:
@@ -403,8 +383,6 @@ DataStoreTLBMiss:
 	/* Extract level 1 index */
 	rlwinm	r10, r10, 32 - ((PAGE_SHIFT - 2) << 1), (PAGE_SHIFT - 2) << 1, 29
 	lwzx	r11, r10, r11	/* Get the level 1 entry */
-	rlwinm.	r10, r11,0,0,19	/* Extract page descriptor page address */
-	beq	2f		/* If zero, don't try to find a pte */
 
 	/* We have a pte table, so load fetch the pte from the table.
 	 */
@@ -450,7 +428,7 @@ DataStoreTLBMiss:
 	 * set.  All other Linux PTE bits control the behavior
 	 * of the MMU.
 	 */
-2:	li	r11, RPN_PATTERN
+	li	r11, RPN_PATTERN
 	rlwimi	r10, r11, 0, 24, 28	/* Set 24-27, clear 28 */
 	MTSPR_CPU6(SPRN_MD_RPN, r10, r3)	/* Update TLB entry */
 
@@ -469,10 +447,7 @@ DataStoreTLBMiss:
  */
 	. = 0x1300
 InstructionTLBError:
-	EXCEPTION_PROLOG_0
-InstructionTLBError1:
-	EXCEPTION_PROLOG_1
-	EXCEPTION_PROLOG_2
+	EXCEPTION_PROLOG
 	mr	r4,r12
 	mr	r5,r9
 	andis.	r10,r5,0x4000
-- 
2.1.0

