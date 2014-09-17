Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756402AbaIQQit (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 12:38:49 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:44190 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756223AbaIQQh3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 12:37:29 -0400
From: Christophe Leroy <christophe.leroy@c-s.fr>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
CC: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Joakim Tjernlund <joakim.tjernlund@transmode.se>,
        scottwood@freescale.com
Subject: [PATCH v3 21/21] powerpc/8xx: Invalidate non present TLB as early as possible
Message-Id: <20140917163701.2CD071AB04A@localhost.localdomain>
Date: Wed, 17 Sep 2014 18:37:01 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

8xx sometimes need to load a invalid/non-present TLBs in
it DTLB asm handler.

These must be invalidated separaly as linux mm doesn't.
    
Commit 5efab4a02c89c252fb4cce097aafde5f8208dbfe was invalidating them in
arch/powerpc/mm/fault.c. 
This patch does the invalidation earlier in order to free the TLB as soon as
possible. This also has the advantage of removing some 8xx specific code from
fault.c

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>

---
Changes in v3:
- New

 linux/arch/powerpc/kernel/head_8xx.S | 15 ++++++++++-----
 linux/arch/powerpc/mm/fault.c        |  7 -------
 2 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/linux/arch/powerpc/kernel/head_8xx.S b/linux/arch/powerpc/kernel/head_8xx.S
index 3e8e341..3b96862 100644
--- a/linux/arch/powerpc/kernel/head_8xx.S
+++ b/linux/arch/powerpc/kernel/head_8xx.S
@@ -473,7 +473,10 @@ InstructionTLBError1:
 	EXCEPTION_PROLOG_2
 	mr	r4,r12
 	mr	r5,r9
-	EXC_XFER_LITE(0x1300, handle_page_fault)
+	andis.	r10,r5,0x4000
+	beq+	1f
+	tlbie	r4
+1:	EXC_XFER_LITE(0x1300, handle_page_fault)
 
 /* This is the data TLB error on the MPC8xx.  This could be due to
  * many reasons, including a dirty update to a pte.  We bail out to
@@ -489,11 +492,13 @@ DataTLBError:
 DARFixed:/* Return from dcbx instruction bug workaround */
 	EXCEPTION_PROLOG_1
 	EXCEPTION_PROLOG_2
-	mfspr	r10,SPRN_DSISR
-	stw	r10,_DSISR(r11)
-	mr	r5,r10
+	mfspr	r5,SPRN_DSISR
+	stw	r5,_DSISR(r11)
 	mfspr	r4,SPRN_DAR
-	li	r10,RPN_PATTERN
+	andis.	r10,r5,0x4000
+	beq+	1f
+	tlbie	r4
+1:	li	r10,RPN_PATTERN
 	mtspr	SPRN_DAR,r10	/* Tag DAR, to be used in DTLB Error */
 	EXC_XFER_LITE(0x1400, handle_page_fault)
 
diff --git a/linux/arch/powerpc/mm/fault.c b/linux/arch/powerpc/mm/fault.c
index adc084b..6f4f731 100644
--- a/linux/arch/powerpc/mm/fault.c
+++ b/linux/arch/powerpc/mm/fault.c
@@ -43,7 +43,6 @@
 #include <asm/tlbflush.h>
 #include <asm/siginfo.h>
 #include <asm/debug.h>
-#include <mm/mmu_decl.h>
 
 #include "icswx.h"
 
@@ -368,12 +367,6 @@ good_area:
 		goto bad_area;
 #endif /* CONFIG_6xx */
 #if defined(CONFIG_8xx)
-	/* 8xx sometimes need to load a invalid/non-present TLBs.
-	 * These must be invalidated separately as linux mm don't.
-	 */
-	if (error_code & 0x40000000) /* no translation? */
-		_tlbil_va(address, 0, 0, 0);
-
         /* The MPC8xx seems to always set 0x80000000, which is
          * "undefined".  Of those that can be set, this is the only
          * one which seems bad.
-- 
2.1.0

