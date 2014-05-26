Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751928AbaEZS4l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 14:56:41 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:59991 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751AbaEZS4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 14:56:32 -0400
From: Larry Bassel <larry.bassel@linaro.org>
To: catalin.marinas@arm.com, will.deacon@arm.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org, khilman@linaro.org,
        Larry Bassel <larry.bassel@linaro.org>
Subject: [PATCH v5 2/2] arm64: enable context tracking
Date: Mon, 26 May 2014 11:56:13 -0700
Message-Id: <1401130573-7443-3-git-send-email-larry.bassel@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1401130573-7443-1-git-send-email-larry.bassel@linaro.org>
References: <1401130573-7443-1-git-send-email-larry.bassel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make calls to ct_user_enter when the kernel is exited
and ct_user_exit when the kernel is entered (in el0_da,
el0_ia, el0_svc, el0_irq and all of the "error" paths).

These macros expand to function calls which will only work
properly if el0_sync and related code has been rearranged
(in a previous patch of this series).

The calls to ct_user_exit are made after hw debugging has been
enabled (enable_dbg_and_irq).

The call to ct_user_enter is made at the beginning of the
kernel_exit macro.

This patch is based on earlier work by Kevin Hilman.
Save/restore optimizations were also done by Kevin.

Signed-off-by: Kevin Hilman <khilman@linaro.org>
Signed-off-by: Larry Bassel <larry.bassel@linaro.org>
---
 arch/arm64/Kconfig                   |  1 +
 arch/arm64/include/asm/thread_info.h |  1 +
 arch/arm64/kernel/entry.S            | 46 ++++++++++++++++++++++++++++++++++++
 3 files changed, 48 insertions(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index e759af5..ef18ae5 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -55,6 +55,7 @@ config ARM64
 	select RTC_LIB
 	select SPARSE_IRQ
 	select SYSCTL_EXCEPTION_TRACE
+	select HAVE_CONTEXT_TRACKING
 	help
 	  ARM 64-bit (AArch64) Linux support.
 
diff --git a/arch/arm64/include/asm/thread_info.h b/arch/arm64/include/asm/thread_info.h
index 720e70b..301ea6a 100644
--- a/arch/arm64/include/asm/thread_info.h
+++ b/arch/arm64/include/asm/thread_info.h
@@ -108,6 +108,7 @@ static inline struct thread_info *current_thread_info(void)
 #define TIF_SINGLESTEP		21
 #define TIF_32BIT		22	/* 32bit process */
 #define TIF_SWITCH_MM		23	/* deferred switch_mm */
+#define TIF_NOHZ                24
 
 #define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
 #define _TIF_NEED_RESCHED	(1 << TIF_NEED_RESCHED)
diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index c6bc1a3..0605963 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -30,6 +30,42 @@
 #include <asm/unistd32.h>
 
 /*
+ * Context tracking subsystem.  Used to instrument transitions
+ * between user and kernel mode.
+ */
+	.macro ct_user_exit, restore = 0
+#ifdef CONFIG_CONTEXT_TRACKING
+	bl	context_tracking_user_exit
+	.if \restore == 1
+	/*
+	 * Save/restore needed during syscalls.  Restore syscall arguments from
+	 * the values already saved on stack during kernel_entry.
+	 */
+	ldp	x0, x1, [sp]
+	ldp	x2, x3, [sp, #S_X2]
+	ldp	x4, x5, [sp, #S_X4]
+	ldp	x6, x7, [sp, #S_X6]
+	.endif
+#endif
+	.endm
+
+	.macro ct_user_enter, save = 0
+#ifdef CONFIG_CONTEXT_TRACKING
+	.if \save == 1
+	/*
+	 * We only have to save/restore x0 on the fast syscall path where
+	 * x0 contains the syscall return.
+	 */
+	mov	x19, x0
+	.endif
+	bl	context_tracking_user_enter
+	.if \save == 1
+	mov	x0, x19
+	.endif
+#endif
+	.endm
+
+/*
  * Bad Abort numbers
  *-----------------
  */
@@ -91,6 +127,7 @@
 	.macro	kernel_exit, el, ret = 0
 	ldp	x21, x22, [sp, #S_PC]		// load ELR, SPSR
 	.if	\el == 0
+	ct_user_enter \ret
 	ldr	x23, [sp, #S_SP]		// load return stack pointer
 	.endif
 	.if	\ret
@@ -318,6 +355,7 @@ el1_irq:
 	bl	trace_hardirqs_off
 #endif
 
+	ct_user_exit
 	irq_handler
 
 #ifdef CONFIG_PREEMPT
@@ -427,6 +465,7 @@ el0_da:
 	mrs	x26, far_el1
 	// enable interrupts before calling the main handler
 	enable_dbg_and_irq
+	ct_user_exit
 	bic	x0, x26, #(0xff << 56)
 	mov	x1, x25
 	mov	x2, sp
@@ -439,6 +478,7 @@ el0_ia:
 	mrs	x26, far_el1
 	// enable interrupts before calling the main handler
 	enable_dbg_and_irq
+	ct_user_exit
 	mov	x0, x26
 	orr	x1, x25, #1 << 24		// use reserved ISS bit for instruction aborts
 	mov	x2, sp
@@ -449,6 +489,7 @@ el0_fpsimd_acc:
 	 * Floating Point or Advanced SIMD access
 	 */
 	enable_dbg
+	ct_user_exit
 	mov	x0, x25
 	mov	x1, sp
 	adr	lr, ret_to_user
@@ -458,6 +499,7 @@ el0_fpsimd_exc:
 	 * Floating Point or Advanced SIMD exception
 	 */
 	enable_dbg
+	ct_user_exit
 	mov	x0, x25
 	mov	x1, sp
 	adr	lr, ret_to_user
@@ -480,6 +522,7 @@ el0_undef:
 	 */
 	// enable interrupts before calling the main handler
 	enable_dbg_and_irq
+	ct_user_exit
 	mov	x0, sp
 	adr	lr, ret_to_user
 	b	do_undefinstr
@@ -494,10 +537,12 @@ el0_dbg:
 	mov	x2, sp
 	bl	do_debug_exception
 	enable_dbg
+	ct_user_exit
 	mov	x0, x26
 	b	ret_to_user
 el0_inv:
 	enable_dbg
+	ct_user_exit
 	mov	x0, sp
 	mov	x1, #BAD_SYNC
 	mrs	x2, esr_el1
@@ -618,6 +663,7 @@ el0_svc:
 el0_svc_naked:					// compat entry point
 	stp	x0, scno, [sp, #S_ORIG_X0]	// save the original x0 and syscall number
 	enable_dbg_and_irq
+	ct_user_exit 1
 
 	ldr	x16, [tsk, #TI_FLAGS]		// check for syscall tracing
 	tbnz	x16, #TIF_SYSCALL_TRACE, __sys_trace // are we tracing syscalls?
-- 
1.8.3.2

