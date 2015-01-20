Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263AbbATJ6X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 04:58:23 -0500
Received: from pegase1.c-s.fr ([93.17.236.30]:40494 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753347AbbATJ5j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 04:57:39 -0500
From: Christophe Leroy <christophe.leroy@c-s.fr>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>, scottwood@freescale.com
CC: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Joakim Tjernlund <joakim.tjernlund@transmode.se>
Subject: [PATCH v2 08/11] powerpc/8xx: Handle CR out of exception PROLOG/EPILOG
Message-Id: <20150120095735.D40731A5E87@localhost.localdomain>
Date: Tue, 20 Jan 2015 10:57:35 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to be able to reduce scope during which CR is saved, we take
CR saving/restoring out of exception PROLOG and EPILOG

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>

---
v2: no change

 arch/powerpc/kernel/head_8xx.S | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/kernel/head_8xx.S b/arch/powerpc/kernel/head_8xx.S
index 065896f..27a9997 100644
--- a/arch/powerpc/kernel/head_8xx.S
+++ b/arch/powerpc/kernel/head_8xx.S
@@ -116,13 +116,13 @@ turn_on_mmu:
  */
 #define EXCEPTION_PROLOG	\
 	EXCEPTION_PROLOG_0;	\
+	mfcr	r10;		\
 	EXCEPTION_PROLOG_1;	\
 	EXCEPTION_PROLOG_2
 
 #define EXCEPTION_PROLOG_0	\
 	mtspr	SPRN_SPRG_SCRATCH0,r10;	\
-	mtspr	SPRN_SPRG_SCRATCH1,r11;	\
-	mfcr	r10
+	mtspr	SPRN_SPRG_SCRATCH1,r11
 
 #define EXCEPTION_PROLOG_1	\
 	mfspr	r11,SPRN_SRR1;		/* check whether user or kernel */ \
@@ -162,7 +162,6 @@ turn_on_mmu:
  * Exception exit code.
  */
 #define EXCEPTION_EPILOG_0	\
-	mtcr	r10;		\
 	mfspr	r10,SPRN_SPRG_SCRATCH0;	\
 	mfspr	r11,SPRN_SPRG_SCRATCH1
 
@@ -313,6 +312,7 @@ InstructionTLBMiss:
 	mtspr	SPRN_DAR, r3
 #endif
 	EXCEPTION_PROLOG_0
+	mfcr	r10
 	mtspr	SPRN_SPRG_SCRATCH2, r10
 	mfspr	r10, SPRN_SRR0	/* Get effective address of fault */
 	DO_8xx_CPU15(r11, r10)
@@ -363,6 +363,7 @@ InstructionTLBMiss:
 	mtspr	SPRN_DAR, r11	/* Tag DAR */
 #endif
 	mfspr	r10, SPRN_SPRG_SCRATCH2
+	mtcr	r10
 	EXCEPTION_EPILOG_0
 	rfi
 
@@ -372,6 +373,7 @@ DataStoreTLBMiss:
 	mtspr	SPRN_DAR, r3
 #endif
 	EXCEPTION_PROLOG_0
+	mfcr	r10
 	mtspr	SPRN_SPRG_SCRATCH2, r10
 	mfspr	r10, SPRN_MD_EPN
 
@@ -440,6 +442,7 @@ DataStoreTLBMiss:
 #endif
 	mtspr	SPRN_DAR, r11	/* Tag DAR */
 	mfspr	r10, SPRN_SPRG_SCRATCH2
+	mtcr	r10
 	EXCEPTION_EPILOG_0
 	rfi
 
@@ -465,6 +468,7 @@ InstructionTLBError:
 	. = 0x1400
 DataTLBError:
 	EXCEPTION_PROLOG_0
+	mfcr	r10
 
 	mfspr	r11, SPRN_DAR
 	cmpwi	cr0, r11, RPN_PATTERN
-- 
2.1.0

