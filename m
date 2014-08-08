Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756370AbaHHHEj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 03:04:39 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:45266 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756289AbaHHHEb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 03:04:31 -0400
From: Christophe Leroy <christophe.leroy@c-s.fr>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
CC: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Joakim Tjernlund <joakim.tjernlund@transmode.se>,
        scottwood@freescale.com
Subject: [PATCH 11/20] powerpc/8xx: Align swapper_pg_dir on 16 bits boundary
Message-Id: <20140808070343.2D84C1ABD47@localhost.localdomain>
Date: Fri,  8 Aug 2014 09:03:43 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lets save one cycle by aligning swapper_pg_dir on 16 bits boundary.

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>

---
 arch/powerpc/kernel/head_8xx.S |   13 +++++--------
 1 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/arch/powerpc/kernel/head_8xx.S b/arch/powerpc/kernel/head_8xx.S
index 4a49ff3..6c2aa33 100644
--- a/arch/powerpc/kernel/head_8xx.S
+++ b/arch/powerpc/kernel/head_8xx.S
@@ -310,7 +310,6 @@ InstructionTLBMiss:
 	andi.	r11, r10, 0x0800	/* Address >= 0x80000000 */
 	beq	3f
 	lis	r11, swapper_pg_dir@h
-	ori	r11, r11, swapper_pg_dir@l
 	rlwimi	r10, r11, 0, 2, 19
 3:
 #endif
@@ -383,7 +382,6 @@ DataStoreTLBMiss:
 	andi.	r11, r10, 0x0800
 	beq	3f
 	lis	r11, swapper_pg_dir@h
-	ori	r11, r11, swapper_pg_dir@l
 	rlwimi	r10, r11, 0, 2, 19
 3:
 	lwz	r11, 0(r10)	/* Get the level 1 entry */
@@ -526,7 +524,6 @@ FixupDAR:/* Entry point for dcbx workaround. */
 	mfspr	r11, SPRN_M_TWB	/* Get level 1 table entry address */
 	beq-	3f		/* Branch if user space */
 	lis	r11, (swapper_pg_dir-PAGE_OFFSET)@h
-	ori	r11, r11, (swapper_pg_dir-PAGE_OFFSET)@l
 	rlwimi	r11, r10, 32-20, 0xffc /* r11 = r11&~0xffc|(r10>>20)&0xffc */
 3:	lwz	r11, 0(r11)	/* Get the level 1 entry */
 	DO_8xx_CPU6(0x3b80, r3)
@@ -687,7 +684,6 @@ start_here:
 	 * easier......until someone changes init's static structures.
 	 */
 	lis	r6, swapper_pg_dir@h
-	ori	r6, r6, swapper_pg_dir@l
 	tophys(r6,r6)
 #ifdef CONFIG_8xx_CPU6
 	lis	r4, cpu6_errata_word@h
@@ -912,14 +908,15 @@ set_dec_cpu6:
 	.data
 	.globl	sdata
 sdata:
-	.globl	empty_zero_page
-empty_zero_page:
-	.space	4096
-
 	.globl	swapper_pg_dir
+	.align	16
 swapper_pg_dir:
 	.space	4096
 
+	.globl	empty_zero_page
+empty_zero_page:
+	.space	4096
+
 /* Room for two PTE table poiners, usually the kernel and current user
  * pointer to their respective root page table (pgdir).
  */
-- 
1.7.1

