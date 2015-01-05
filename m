Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021AbbAEPNm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 10:13:42 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:65356 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753375AbbAEPNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 10:13:40 -0500
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: Daniel Thompson <daniel.thompson@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        patches@linaro.org, linaro-kernel@lists.linaro.org,
        John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>
Subject: [PATCH] arm: Remove early stack deallocation from restore_user_regs
Date: Mon,  5 Jan 2015 15:12:38 +0000
Message-Id: <1420470758-5874-1-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1418382718-16323-1-git-send-email-daniel.thompson@linaro.org>
References: <1418382718-16323-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently restore_user_regs deallocates the SVC stack early in
its execution and relies on no exception being taken between
the deallocation and the registers being restored. The introduction
of a default FIQ handler that also uses the SVC stack breaks this
assumption and can result in corrupted register state.

This patch works around the problem by removing the early
stack deallocation and using r2 as a temporary instead. I have
not found a way to do this without introducing an extra mov
instruction to the macro.

Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
---

Notes:
    [This patch has not been modified since its original posting as an RFC].
    
    I have recently started to hook up the PMU via FIQ (although
    it's slightly hacky at present) and was seeing random userspace
    SEGVs when perf was running (after ~100,000 or so FIQs).
    
    Instrumenting the code eventually revealed that in almost all
    cases the last FIQ handler to run prior the SEGV had interrupted
    ret_to_user_from_irq or ret_fast_syscall. Very occasionally it was
    in the fault handling code (because that code runs as part of SEGV
    handling and the PMU is instrumenting that too).
    
    No SEGV problems have been observed since fixing the issue. This
    version of the patch has seen >7M FIQs and an older version (based
    on cpsid f) ran overnight.
    

 arch/arm/kernel/entry-header.S | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/arm/kernel/entry-header.S b/arch/arm/kernel/entry-header.S
index 4176df721bf0..1a0045abead7 100644
--- a/arch/arm/kernel/entry-header.S
+++ b/arch/arm/kernel/entry-header.S
@@ -253,21 +253,22 @@
 	.endm

 	.macro	restore_user_regs, fast = 0, offset = 0
-	ldr	r1, [sp, #\offset + S_PSR]	@ get calling cpsr
-	ldr	lr, [sp, #\offset + S_PC]!	@ get pc
+	mov	r2, sp
+	ldr	r1, [r2, #\offset + S_PSR]	@ get calling cpsr
+	ldr	lr, [r2, #\offset + S_PC]!	@ get pc
 	msr	spsr_cxsf, r1			@ save in spsr_svc
 #if defined(CONFIG_CPU_V6) || defined(CONFIG_CPU_32v6K)
 	@ We must avoid clrex due to Cortex-A15 erratum #830321
-	strex	r1, r2, [sp]			@ clear the exclusive monitor
+	strex	r1, r2, [r2]			@ clear the exclusive monitor
 #endif
 	.if	\fast
-	ldmdb	sp, {r1 - lr}^			@ get calling r1 - lr
+	ldmdb	r2, {r1 - lr}^			@ get calling r1 - lr
 	.else
-	ldmdb	sp, {r0 - lr}^			@ get calling r0 - lr
+	ldmdb	r2, {r0 - lr}^			@ get calling r0 - lr
 	.endif
 	mov	r0, r0				@ ARMv5T and earlier require a nop
 						@ after ldm {}^
-	add	sp, sp, #S_FRAME_SIZE - S_PC
+	add	sp, sp, #\offset + S_FRAME_SIZE
 	movs	pc, lr				@ return & move spsr_svc into cpsr
 	.endm

--
1.9.3

