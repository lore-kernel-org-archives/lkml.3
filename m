Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756894Ab3EGFwU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 01:52:20 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:62396 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754475Ab3EGFwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 01:52:18 -0400
From: giridhar.maruthy@linaro.org
To: kgene.kim@samsung.com, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, cdall@cs.columbia.edu,
        marc.zyngier@arm.com
Cc: Giridhar Maruthy <giridhar.maruthy@linaro.org>
Subject: [RFC PATCH V2] ARM: EXYNOS: Fix hotplug when CPUs boot in HYP mode
Date: Tue,  7 May 2013 11:21:50 +0530
Message-Id: <1367905910-30913-1-git-send-email-giridhar.m@samsung.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Giridhar Maruthy <giridhar.maruthy@linaro.org>

In intial boot-up, u-boot commit "3d28a181aab5e... arndale5250: Boot in Hyp
mode and enable architected timers" puts the CPUs in HYP mode.

Hence, the CPUs need to be put in HYP mode when they are hot plugged out and
plugged in back.

This patch is almost same as above u-boot patch, it additionally takes care
if the kernel is compiled with thumb-2 option.

Signed-off-by: Giridhar Maruthy <giridhar.m@samsung.com>
Signed-off-by: Inderpal Singh <inderpal.singh@linaro.org>
---
 arch/arm/mach-exynos/headsmp.S |  114 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 114 insertions(+)

diff --git a/arch/arm/mach-exynos/headsmp.S b/arch/arm/mach-exynos/headsmp.S
index 5364d4b..a837941 100644
--- a/arch/arm/mach-exynos/headsmp.S
+++ b/arch/arm/mach-exynos/headsmp.S
@@ -12,6 +12,7 @@
  */
 #include <linux/linkage.h>
 #include <linux/init.h>
+#include <asm/assembler.h>
 
 	__CPUINIT
 
@@ -20,6 +21,98 @@
  * a "holding pen" into which all secondary cores are held until we're
  * ready for them to initialise.
  */
+
+.arch_extension sec
+.arch_extension virt
+.text
+
+.align 5
+/* We use the same vector table for Hyp and Monitor mode, since
+ * we will only use each once and they don't overlap.
+ */
+mon_vectors:
+	W(b)	.	/* reset */
+	W(b)	.	/* undef */
+	W(b)	2f	/* smc */
+	W(b)	.	/* pabt */
+	W(b)	.	/* dabt */
+	W(b)	1f	/* hyp */
+	W(b)	.	/* irq */
+	W(b)	.	/* fiq */
+
+/* Return directly back to the caller without leaving Hyp mode: */
+1:	mrs	lr, elr_hyp
+	mov	pc, lr
+
+/* In monitor mode, set up HVBAR and SCR then return to caller in NS-SVC. */
+2:
+	mrc	p15, 0, r1, c1, c1, 0		@ SCR
+	/*
+	 * Set SCR.NS=1(needed for setting HVBAR and also returning to NS state)
+	 *        .IRQ,FIQ,EA=0 (don't take aborts/exceptions to Monitor mode)
+	 *        .FW,AW=1 (CPSR.A,F modifiable in NS state)
+	 *        .nET=0 (early termination OK)
+	 *        .SCD=0 (SMC in NS mode OK, so we can call secure firmware)
+	 *        .HCE=1 (HVC does Hyp call)
+	 */
+	bic	r1, r1, #0x07f
+	ldr	r2, =0x131
+	orr	r1, r1, r2
+	mcr	p15, 0, r2, c1, c1, 0		@ SCR
+	isb
+	ldr	r2, =mon_vectors
+
+
+	adr	r4, 1f
+	ldmia	r4, {r5}
+	sub	r4, r4, r5
+	add	r2, r2, r4
+
+	mcr	p15, 4, r2, c12, c0, 0		@ set HVBAR
+
+ THUMB(	mrc	p15, 4, r2, c1, c0, 0 )		@ ctrl register
+ THUMB(	orr	r2, r2, #1 << 30 )		@ HSCTLR.TE (Thumb exceptions)
+ THUMB(	mcr	p15, 4, r2, c1, c0, 0 )
+ THUMB(	isb)
+
+	/* ...and return to calling code in NS state */
+	movs	pc, lr
+
+
+	.globl monitor_init
+monitor_init:
+	ldr	ip, =mon_vectors
+
+	adr	r4, 1f
+	ldmia	r4, {r5}
+	sub	r4, r4, r5
+	add	ip, ip, r4
+	mcr	p15, 0, ip, c12, c0, 1
+
+ THUMB(	mrc     p15, 0, r1, c1, c0, 0 )		@ ctrl register
+ THUMB( orr     r1, r1, #1 << 30 )		@ SCTLR.TE (Thumb exceptions)
+ THUMB( mcr     p15, 0, r1, c1, c0, 0 )
+ THUMB( isb )
+
+	mov	pc, lr
+
+	/* Try to go into NS-SVC: void enter_ns(void); */
+	.globl enter_ns
+enter_ns:
+	smc	#0
+	mov	pc, lr
+
+	/* void enter_hyp(void); */
+	.globl enter_hyp
+enter_hyp:
+	/* Now we're in NS-SVC, make a Hyp call to get into Hyp mode */
+	mov	r0, lr
+	mov	r1, sp
+	hvc	#0
+	/* We will end up here in NS-Hyp. */
+	mov	sp, r1
+	mov	pc, r0
+
 ENTRY(exynos4_secondary_startup)
 	mrc	p15, 0, r0, c0, c0, 5
 	and	r0, r0, #15
@@ -31,6 +124,27 @@ pen:	ldr	r7, [r6]
 	cmp	r7, r0
 	bne	pen
 
+	ldr	r1, =__boot_cpu_mode
+	add	r1, r1, r4
+	ldr	r2, [r1]
+	mrs     r0, cpsr
+	ands	r0, r0, #MODE_MASK
+	subs	r1, r0, r2
+	beq	3f
+	subs	r2, r2, #HYP_MODE
+	bne	3f
+
+	/* Setting NSACR to allow coprocessor access from non-secure mode */
+	mrc	p15, 0, r0, c1, c1, 2
+	movw	r1, #0x3fff
+	orr	r0, r0, r1
+	mcr	p15, 0, r0, c1, c1, 2
+5:
+	bl	monitor_init
+	bl	enter_ns
+	bl	enter_hyp
+
+3:
 	/*
 	 * we've been released from the holding pen: secondary_stack
 	 * should now contain the SVC stack for this core
-- 
1.7.9.5

