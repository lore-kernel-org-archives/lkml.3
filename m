Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447AbbATJ6Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 04:58:25 -0500
Received: from pegase1.c-s.fr ([93.17.236.30]:40493 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753346AbbATJ5j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 04:57:39 -0500
From: Christophe Leroy <christophe.leroy@c-s.fr>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>, scottwood@freescale.com
CC: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Joakim Tjernlund <joakim.tjernlund@transmode.se>
Subject: [PATCH v2 07/11] powerpc/8xx: macro for handling CPU15 errata
Message-Id: <20150120095735.A55671A5E86@localhost.localdomain>
Date: Tue, 20 Jan 2015 10:57:35 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Having a macro will help keep clear code.

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>

---
v2: no change

 arch/powerpc/kernel/head_8xx.S | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/kernel/head_8xx.S b/arch/powerpc/kernel/head_8xx.S
index a1571b3..065896f 100644
--- a/arch/powerpc/kernel/head_8xx.S
+++ b/arch/powerpc/kernel/head_8xx.S
@@ -297,6 +297,17 @@ SystemCall:
  * We have to use the MD_xxx registers for the tablewalk because the
  * equivalent MI_xxx registers only perform the attribute functions.
  */
+
+#ifdef CONFIG_8xx_CPU15
+#define DO_8xx_CPU15(tmp, addr)	\
+	addi	tmp, addr, PAGE_SIZE;	\
+	tlbie	tmp;			\
+	addi	tmp, addr, PAGE_SIZE;	\
+	tlbie	tmp
+#else
+#define DO_8xx_CPU15(tmp, addr)
+#endif
+
 InstructionTLBMiss:
 #ifdef CONFIG_8xx_CPU6
 	mtspr	SPRN_DAR, r3
@@ -304,12 +315,7 @@ InstructionTLBMiss:
 	EXCEPTION_PROLOG_0
 	mtspr	SPRN_SPRG_SCRATCH2, r10
 	mfspr	r10, SPRN_SRR0	/* Get effective address of fault */
-#ifdef CONFIG_8xx_CPU15
-	addi	r11, r10, PAGE_SIZE
-	tlbie	r11
-	addi	r11, r10, -PAGE_SIZE
-	tlbie	r11
-#endif
+	DO_8xx_CPU15(r11, r10)
 
 	/* If we are faulting a kernel address, we have to use the
 	 * kernel page tables.
-- 
2.1.0

