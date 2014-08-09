Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751187AbaHIFWU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2014 01:22:20 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:49481 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932AbaHIFWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2014 01:22:18 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>,
        Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>
Subject: [PATCH] powerpc: Fix "attempt to move .org backwards" error
Date: Fri,  8 Aug 2014 22:22:12 -0700
Message-Id: <1407561732-817-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Once again, we see

arch/powerpc/kernel/exceptions-64s.S: Assembler messages:
arch/powerpc/kernel/exceptions-64s.S:865: Error: attempt to move .org backwards
arch/powerpc/kernel/exceptions-64s.S:866: Error: attempt to move .org backwards
arch/powerpc/kernel/exceptions-64s.S:890: Error: attempt to move .org backwards

when compiling ppc:allmodconfig.

This time the problem has been caused by to commit 0869b6fd209bda
("powerpc/book3s: Add basic infrastructure to handle HMI in Linux"),
which adds functions hmi_exception_early and hmi_exception_after_realmode
into a critical (size-limited) code area, even though that does not appear
to be necessary.

Move those functions to a non-critical area of the file.

Cc: Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
Compile tested with all ppc configurations.
The reported checkpatch error appears to be a false positive.

 arch/powerpc/kernel/exceptions-64s.S | 110 +++++++++++++++++------------------
 1 file changed, 55 insertions(+), 55 deletions(-)

diff --git a/arch/powerpc/kernel/exceptions-64s.S b/arch/powerpc/kernel/exceptions-64s.S
index 6144d5a..050f79a 100644
--- a/arch/powerpc/kernel/exceptions-64s.S
+++ b/arch/powerpc/kernel/exceptions-64s.S
@@ -592,61 +592,6 @@ END_FTR_SECTION_IFSET(CPU_FTR_CFAR)
 	MASKABLE_EXCEPTION_HV_OOL(0xe62, hmi_exception)
 	KVM_HANDLER(PACA_EXGEN, EXC_HV, 0xe62)
 
-	.globl hmi_exception_early
-hmi_exception_early:
-	EXCEPTION_PROLOG_1(PACA_EXGEN, NOTEST, 0xe60)
-	mr	r10,r1			/* Save r1			*/
-	ld	r1,PACAEMERGSP(r13)	/* Use emergency stack		*/
-	subi	r1,r1,INT_FRAME_SIZE	/* alloc stack frame		*/
-	std	r9,_CCR(r1)		/* save CR in stackframe	*/
-	mfspr	r11,SPRN_HSRR0		/* Save HSRR0 */
-	std	r11,_NIP(r1)		/* save HSRR0 in stackframe	*/
-	mfspr	r12,SPRN_HSRR1		/* Save SRR1 */
-	std	r12,_MSR(r1)		/* save SRR1 in stackframe	*/
-	std	r10,0(r1)		/* make stack chain pointer	*/
-	std	r0,GPR0(r1)		/* save r0 in stackframe	*/
-	std	r10,GPR1(r1)		/* save r1 in stackframe	*/
-	EXCEPTION_PROLOG_COMMON_2(PACA_EXGEN)
-	EXCEPTION_PROLOG_COMMON_3(0xe60)
-	addi	r3,r1,STACK_FRAME_OVERHEAD
-	bl	hmi_exception_realmode
-	/* Windup the stack. */
-	/* Clear MSR_RI before setting SRR0 and SRR1. */
-	li	r0,MSR_RI
-	mfmsr	r9			/* get MSR value */
-	andc	r9,r9,r0
-	mtmsrd	r9,1			/* Clear MSR_RI */
-	/* Move original HSRR0 and HSRR1 into the respective regs */
-	ld	r9,_MSR(r1)
-	mtspr	SPRN_HSRR1,r9
-	ld	r3,_NIP(r1)
-	mtspr	SPRN_HSRR0,r3
-	ld	r9,_CTR(r1)
-	mtctr	r9
-	ld	r9,_XER(r1)
-	mtxer	r9
-	ld	r9,_LINK(r1)
-	mtlr	r9
-	REST_GPR(0, r1)
-	REST_8GPRS(2, r1)
-	REST_GPR(10, r1)
-	ld	r11,_CCR(r1)
-	mtcr	r11
-	REST_GPR(11, r1)
-	REST_2GPRS(12, r1)
-	/* restore original r1. */
-	ld	r1,GPR1(r1)
-
-	/*
-	 * Go to virtual mode and pull the HMI event information from
-	 * firmware.
-	 */
-	.globl hmi_exception_after_realmode
-hmi_exception_after_realmode:
-	SET_SCRATCH0(r13)
-	EXCEPTION_PROLOG_0(PACA_EXGEN)
-	b	hmi_exception_hv
-
 	MASKABLE_EXCEPTION_HV_OOL(0xe82, h_doorbell)
 	KVM_HANDLER(PACA_EXGEN, EXC_HV, 0xe82)
 
@@ -1306,6 +1251,61 @@ fwnmi_data_area:
 	. = 0x8000
 #endif /* defined(CONFIG_PPC_PSERIES) || defined(CONFIG_PPC_POWERNV) */
 
+	.globl hmi_exception_early
+hmi_exception_early:
+	EXCEPTION_PROLOG_1(PACA_EXGEN, NOTEST, 0xe60)
+	mr	r10,r1			/* Save r1			*/
+	ld	r1,PACAEMERGSP(r13)	/* Use emergency stack		*/
+	subi	r1,r1,INT_FRAME_SIZE	/* alloc stack frame		*/
+	std	r9,_CCR(r1)		/* save CR in stackframe	*/
+	mfspr	r11,SPRN_HSRR0		/* Save HSRR0 */
+	std	r11,_NIP(r1)		/* save HSRR0 in stackframe	*/
+	mfspr	r12,SPRN_HSRR1		/* Save SRR1 */
+	std	r12,_MSR(r1)		/* save SRR1 in stackframe	*/
+	std	r10,0(r1)		/* make stack chain pointer	*/
+	std	r0,GPR0(r1)		/* save r0 in stackframe	*/
+	std	r10,GPR1(r1)		/* save r1 in stackframe	*/
+	EXCEPTION_PROLOG_COMMON_2(PACA_EXGEN)
+	EXCEPTION_PROLOG_COMMON_3(0xe60)
+	addi	r3,r1,STACK_FRAME_OVERHEAD
+	bl	hmi_exception_realmode
+	/* Windup the stack. */
+	/* Clear MSR_RI before setting SRR0 and SRR1. */
+	li	r0,MSR_RI
+	mfmsr	r9			/* get MSR value */
+	andc	r9,r9,r0
+	mtmsrd	r9,1			/* Clear MSR_RI */
+	/* Move original HSRR0 and HSRR1 into the respective regs */
+	ld	r9,_MSR(r1)
+	mtspr	SPRN_HSRR1,r9
+	ld	r3,_NIP(r1)
+	mtspr	SPRN_HSRR0,r3
+	ld	r9,_CTR(r1)
+	mtctr	r9
+	ld	r9,_XER(r1)
+	mtxer	r9
+	ld	r9,_LINK(r1)
+	mtlr	r9
+	REST_GPR(0, r1)
+	REST_8GPRS(2, r1)
+	REST_GPR(10, r1)
+	ld	r11,_CCR(r1)
+	mtcr	r11
+	REST_GPR(11, r1)
+	REST_2GPRS(12, r1)
+	/* restore original r1. */
+	ld	r1,GPR1(r1)
+
+	/*
+	 * Go to virtual mode and pull the HMI event information from
+	 * firmware.
+	 */
+	.globl hmi_exception_after_realmode
+hmi_exception_after_realmode:
+	SET_SCRATCH0(r13)
+	EXCEPTION_PROLOG_0(PACA_EXGEN)
+	b	hmi_exception_hv
+
 #ifdef CONFIG_PPC_POWERNV
 _GLOBAL(opal_mc_secondary_handler)
 	HMT_MEDIUM_PPR_DISCARD
-- 
1.9.1

