Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756479AbaIQQkQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 12:40:16 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:44153 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756082AbaIQQhV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 12:37:21 -0400
From: Christophe Leroy <christophe.leroy@c-s.fr>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
CC: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Joakim Tjernlund <joakim.tjernlund@transmode.se>,
        scottwood@freescale.com
Subject: [PATCH v3 14/21] powerpc/8xx: Const for TLB RPN forced value
Message-Id: <20140917163659.D720F1AB03F@localhost.localdomain>
Date: Wed, 17 Sep 2014 18:36:59 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Value 0x00f0 is used to force bits in TLB level 2 entry. This value is linked
to the page size and will vary when we change the page size. Lets define a const
for it in order to have it at only one place.

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>

---
Changes in v2:
- None

Changes in v3:
- None

 arch/powerpc/kernel/head_8xx.S |   19 +++++++++++++------
 1 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/kernel/head_8xx.S b/arch/powerpc/kernel/head_8xx.S
index dcaee9f..8966262 100644
--- a/arch/powerpc/kernel/head_8xx.S
+++ b/arch/powerpc/kernel/head_8xx.S
@@ -40,6 +40,13 @@
 #else
 #define DO_8xx_CPU6(val, reg)
 #endif
+
+/*
+ * Value for the bits that have fixed value in RPN entries.
+ * Also used for tagging DAR for DTLBerror.
+ */
+#define RPN_PATTERN	0x00f0
+
 	__HEAD
 _ENTRY(_stext);
 _ENTRY(_start);
@@ -211,7 +218,7 @@ MachineCheck:
 	EXCEPTION_PROLOG
 	mfspr r4,SPRN_DAR
 	stw r4,_DAR(r11)
-	li r5,0x00f0
+	li r5,RPN_PATTERN
 	mtspr SPRN_DAR,r5	/* Tag DAR, to be used in DTLB Error */
 	mfspr r5,SPRN_DSISR
 	stw r5,_DSISR(r11)
@@ -237,7 +244,7 @@ Alignment:
 	EXCEPTION_PROLOG
 	mfspr	r4,SPRN_DAR
 	stw	r4,_DAR(r11)
-	li	r5,0x00f0
+	li	r5,RPN_PATTERN
 	mtspr	SPRN_DAR,r5	/* Tag DAR, to be used in DTLB Error */
 	mfspr	r5,SPRN_DSISR
 	stw	r5,_DSISR(r11)
@@ -341,7 +348,7 @@ InstructionTLBMiss:
 	 * set.  All other Linux PTE bits control the behavior
 	 * of the MMU.
 	 */
-	li	r11, 0x00f0
+	li	r11, RPN_PATTERN
 	rlwimi	r10, r11, 0, 0x07f8	/* Set 24-27, clear 21-23,28 */
 	DO_8xx_CPU6(0x2d80, r3)
 	mtspr	SPRN_MI_RPN, r10	/* Update TLB entry */
@@ -445,7 +452,7 @@ DataStoreTLBMiss:
 	 * set.  All other Linux PTE bits control the behavior
 	 * of the MMU.
 	 */
-2:	li	r11, 0x00f0
+2:	li	r11, RPN_PATTERN
 	rlwimi	r10, r11, 0, 24, 28	/* Set 24-27, clear 28 */
 	DO_8xx_CPU6(0x3d80, r3)
 	mtspr	SPRN_MD_RPN, r10	/* Update TLB entry */
@@ -479,7 +486,7 @@ DataTLBError:
 	EXCEPTION_PROLOG_0
 
 	mfspr	r11, SPRN_DAR
-	cmpwi	cr0, r11, 0x00f0
+	cmpwi	cr0, r11, RPN_PATTERN
 	beq-	FixupDAR	/* must be a buggy dcbX, icbi insn. */
 DARFixed:/* Return from dcbx instruction bug workaround */
 	EXCEPTION_PROLOG_1
@@ -488,7 +495,7 @@ DARFixed:/* Return from dcbx instruction bug workaround */
 	stw	r10,_DSISR(r11)
 	mr	r5,r10
 	mfspr	r4,SPRN_DAR
-	li	r10,0x00f0
+	li	r10,RPN_PATTERN
 	mtspr	SPRN_DAR,r10	/* Tag DAR, to be used in DTLB Error */
 	EXC_XFER_LITE(0x1400, handle_page_fault)
 
-- 
1.7.1

