Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425AbaH2JRq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 05:17:46 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:36046 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751840AbaH2JOj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 05:14:39 -0400
From: Christophe Leroy <christophe.leroy@c-s.fr>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
CC: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Joakim Tjernlund <joakim.tjernlund@transmode.se>,
        scottwood@freescale.com
Subject: [PATCH v2 03/19] powerpc/8xx: exception InstructionAccess does not exist on MPC8xx
Message-Id: <20140829091437.B3FE71ABD63@localhost.localdomain>
Date: Fri, 29 Aug 2014 11:14:37 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Exception InstructionAccess does not exist on MPC8xx. No need to branch there from somewhere else. 
Handling can be done directly in InstructionTLBError Exception.

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>

---
 arch/powerpc/kernel/head_8xx.S |   17 +++++++----------
 1 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/arch/powerpc/kernel/head_8xx.S b/arch/powerpc/kernel/head_8xx.S
index 3af6db1..fbe5d10 100644
--- a/arch/powerpc/kernel/head_8xx.S
+++ b/arch/powerpc/kernel/head_8xx.S
@@ -234,15 +234,9 @@ DataAccess:
 	EXC_XFER_LITE(0x300, handle_page_fault)
 
 /* Instruction access exception.
- * This is "never generated" by the MPC8xx.  We jump to it for other
- * translation errors.
+ * This is "never generated" by the MPC8xx.
  */
-	. = 0x400
-InstructionAccess:
-	EXCEPTION_PROLOG
-	mr	r4,r12
-	mr	r5,r9
-	EXC_XFER_LITE(0x400, handle_page_fault)
+	EXCEPTION(0x400, InstructionAccess, unknown_exception, EXC_XFER_STD)
 
 /* External interrupt */
 	EXCEPTION(0x500, HardwareInterrupt, do_IRQ, EXC_XFER_LITE)
@@ -382,7 +376,7 @@ InstructionTLBMiss:
 #endif
 	mfspr	r10, SPRN_SPRG_SCRATCH2
 	EXCEPTION_EPILOG_0
-	b	InstructionAccess
+	b	InstructionTLBError
 
 	. = 0x1200
 DataStoreTLBMiss:
@@ -477,7 +471,10 @@ DataStoreTLBMiss:
  */
 	. = 0x1300
 InstructionTLBError:
-	b	InstructionAccess
+	EXCEPTION_PROLOG
+	mr	r4,r12
+	mr	r5,r9
+	EXC_XFER_LITE(0x1300, handle_page_fault)
 
 /* This is the data TLB error on the MPC8xx.  This could be due to
  * many reasons, including a dirty update to a pte.  We can catch that
-- 
1.7.1

