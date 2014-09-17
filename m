Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756209AbaIQQhW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 12:37:22 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:44081 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755827AbaIQQhL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 12:37:11 -0400
From: Christophe Leroy <christophe.leroy@c-s.fr>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
CC: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Joakim Tjernlund <joakim.tjernlund@transmode.se>,
        scottwood@freescale.com
Subject: [PATCH v3 03/21] powerpc/8xx: exception InstructionAccess does not exist on MPC8xx
Message-Id: <20140917163657.7737D1AB032@localhost.localdomain>
Date: Wed, 17 Sep 2014 18:36:57 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Exception InstructionAccess does not exist on MPC8xx. No need to branch there from somewhere else. 
Handling can be done directly in InstructionTLBError Exception.

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>

---
Changes in v2:
- None

Changes in v3:
- arch/powerpc/mm/fault.c uses the vector number, so make sure it understand
the new ones.

 arch/powerpc/kernel/head_8xx.S | 17 +++++++----------
 arch/powerpc/mm/fault.c        |  1 +
 2 files changed, 8 insertions(+), 10 deletions(-)

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
diff --git a/arch/powerpc/mm/fault.c b/arch/powerpc/mm/fault.c
index 51ab9e7..4d63c96 100644
--- a/arch/powerpc/mm/fault.c
+++ b/arch/powerpc/mm/fault.c
@@ -526,6 +526,7 @@ void bad_page_fault(struct pt_regs *regs, unsigned long address, int sig)
 		break;
 	case 0x400:
 	case 0x480:
+	case 0x1300:
 		printk(KERN_ALERT "Unable to handle kernel paging request for "
 			"instruction fetch\n");
 		break;
-- 
2.1.0

