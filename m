Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123Ab3KHBUi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 20:20:38 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:59045 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752511Ab3KHBUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 20:20:37 -0500
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-arm-kernel@lists.infradead.org
Cc: Mahesh Sivasubramanian <msivasub@codeaurora.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: Save/Restore 64-bit TTBR registers on LPAE suspend/resume
Date: Thu,  7 Nov 2013 17:20:33 -0800
Message-Id: <1383873633-2499-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.5.rc0.44.gf26f72d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mahesh Sivasubramanian <msivasub@codeaurora.org>

LPAE enabled kernels use the 64-bit version of TTBR0 and TTBR1
registers. If we're running an LPAE kernel, fill the upper half
of TTBR0 with 0 because we're setting it to the idmap here (the
idmap is guaranteed to be < 4Gb) and fully restore TTBR1 instead
of just restoring the lower 32 bits. Failure to do so can cause
failures on resume from suspend when these registers are only
half restored.

Signed-off-by: Mahesh Sivasubramanian <msivasub@codeaurora.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/mm/proc-v7.S | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/arch/arm/mm/proc-v7.S b/arch/arm/mm/proc-v7.S
index c63d9bd..fb8b5e0 100644
--- a/arch/arm/mm/proc-v7.S
+++ b/arch/arm/mm/proc-v7.S
@@ -92,7 +92,7 @@ ENDPROC(cpu_v7_dcache_clean_area)
 
 /* Suspend/resume support: derived from arch/arm/mach-s5pv210/sleep.S */
 .globl	cpu_v7_suspend_size
-.equ	cpu_v7_suspend_size, 4 * 8
+.equ	cpu_v7_suspend_size, 4 * 9
 #ifdef CONFIG_ARM_CPU_SUSPEND
 ENTRY(cpu_v7_do_suspend)
 	stmfd	sp!, {r4 - r10, lr}
@@ -101,13 +101,17 @@ ENTRY(cpu_v7_do_suspend)
 	stmia	r0!, {r4 - r5}
 #ifdef CONFIG_MMU
 	mrc	p15, 0, r6, c3, c0, 0	@ Domain ID
+#ifdef CONFIG_ARM_LPAE
+	mrrc	p15, 1, r5, r7, c2	@ TTB 1
+#else
 	mrc	p15, 0, r7, c2, c0, 1	@ TTB 1
+#endif
 	mrc	p15, 0, r11, c2, c0, 2	@ TTB control register
 #endif
 	mrc	p15, 0, r8, c1, c0, 0	@ Control register
 	mrc	p15, 0, r9, c1, c0, 1	@ Auxiliary control register
 	mrc	p15, 0, r10, c1, c0, 2	@ Co-processor access control
-	stmia	r0, {r6 - r11}
+	stmia	r0, {r5 - r11}
 	ldmfd	sp!, {r4 - r10, pc}
 ENDPROC(cpu_v7_do_suspend)
 
@@ -118,16 +122,19 @@ ENTRY(cpu_v7_do_resume)
 	ldmia	r0!, {r4 - r5}
 	mcr	p15, 0, r4, c13, c0, 0	@ FCSE/PID
 	mcr	p15, 0, r5, c13, c0, 3	@ User r/o thread ID
-	ldmia	r0, {r6 - r11}
+	ldmia	r0, {r5 - r11}
 #ifdef CONFIG_MMU
 	mcr	p15, 0, ip, c8, c7, 0	@ invalidate TLBs
 	mcr	p15, 0, r6, c3, c0, 0	@ Domain ID
-#ifndef CONFIG_ARM_LPAE
+#ifdef CONFIG_ARM_LPAE
+	mcrr	p15, 0, r1, ip, c2	@ TTB 0
+	mcrr	p15, 1, r5, r7, c2	@ TTB 1
+#else
 	ALT_SMP(orr	r1, r1, #TTB_FLAGS_SMP)
 	ALT_UP(orr	r1, r1, #TTB_FLAGS_UP)
-#endif
 	mcr	p15, 0, r1, c2, c0, 0	@ TTB 0
 	mcr	p15, 0, r7, c2, c0, 1	@ TTB 1
+#endif
 	mcr	p15, 0, r11, c2, c0, 2	@ TTB control register
 	ldr	r4, =PRRR		@ PRRR
 	ldr	r5, =NMRR		@ NMRR
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

