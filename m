Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758119AbaEIVwd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 17:52:33 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:34977 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757881AbaEIVwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 17:52:09 -0400
From: Larry Bassel <larry.bassel@linaro.org>
To: catalin.marinas@arm.com, will.deacon@arm.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org, khilman@linaro.org,
        Larry Bassel <larry.bassel@linaro.org>
Subject: [PATCH v3 2/2] arm64: enable context tracking
Date: Fri,  9 May 2014 14:51:50 -0700
Message-Id: <1399672310-9061-3-git-send-email-larry.bassel@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1399672310-9061-1-git-send-email-larry.bassel@linaro.org>
References: <1399672310-9061-1-git-send-email-larry.bassel@linaro.org>
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
enabled (enable_dbg).

The call to ct_user_enter is made at the beginning of the
kernel_exit macro.

This patch is based on earlier work by Kevin Hilman.

Signed-off-by: Kevin Hilman <khilman@linaro.org>
Signed-off-by: Larry Bassel <larry.bassel@linaro.org>
---
 arch/arm64/Kconfig                   |  1 +
 arch/arm64/include/asm/thread_info.h |  1 +
 arch/arm64/kernel/entry.S            | 49 ++++++++++++++++++++++++++++++++++++
 3 files changed, 51 insertions(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index e6e4d37..152d92b 100644
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
index 136bb7d..c839bab 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -30,6 +30,44 @@
 #include <asm/unistd32.h>
 
 /*
+ * Context tracking subsystem.  Used to instrument transitions
+ * between user and kernel mode.
+ */
+	.macro ct_user_exit, save = 0
+#ifdef CONFIG_CONTEXT_TRACKING
+	bl	context_tracking_user_exit
+	.if \save == 1
+	/*
+	 * save/restore needed during syscalls.  Restore syscall arguments from
+	 * the values already saved on stack during kernel_entry
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
+	 * save/restore only needed on syscall fastpath, which uses
+	 * x0-x2
+	 */
+	push    x2, x3
+	push    x0, x1
+	.endif
+	bl	context_tracking_user_enter
+	.if \save == 1
+	pop     x0, x1
+	pop     x2, x3
+	.endif
+#endif
+	.endm
+
+/*
  * Bad Abort numbers
  *-----------------
  */
@@ -88,6 +126,7 @@
 	.macro	kernel_exit, el, ret = 0
 	ldp	x21, x22, [sp, #S_PC]		// load ELR, SPSR
 	.if	\el == 0
+	ct_user_enter \ret
 	ldr	x23, [sp, #S_SP]		// load return stack pointer
 	.endif
 	.if	\ret
@@ -425,6 +464,7 @@ el0_da:
 	enable_dbg
 	// enable interrupts before calling the main handler
 	enable_irq
+	ct_user_exit
 	mov	x0, x26
 	bic	x0, x0, #(0xff << 56)
 	mov	x1, x25
@@ -441,6 +481,7 @@ el0_ia:
 	enable_dbg
 	// enable interrupts before calling the main handler
 	enable_irq
+	ct_user_exit
 	mov	x0, x26
 	orr	x1, x25, #1 << 24		// use reserved ISS bit for instruction aborts
 	mov	x2, sp
@@ -450,6 +491,7 @@ el0_fpsimd_acc:
 	/*
 	 * Floating Point or Advanced SIMD access
 	 */
+	ct_user_exit
 	mov	x0, x25
 	mov	x1, sp
 	adr	lr, ret_from_exception
@@ -458,6 +500,7 @@ el0_fpsimd_exc:
 	/*
 	 * Floating Point or Advanced SIMD exception
 	 */
+	ct_user_exit
 	mov	x0, x25
 	mov	x1, sp
 	adr	lr, ret_from_exception
@@ -472,6 +515,7 @@ el0_sp_pc:
 	enable_dbg
 	// enable interrupts before calling the main handler
 	enable_irq
+	ct_user_exit
 	mov	x0, x26
 	mov	x1, x25
 	mov	x2, sp
@@ -484,6 +528,7 @@ el0_undef:
 	mov	x26, sp
 	// enable interrupts before calling the main handler
 	enable_irq
+	ct_user_exit
 	mov	x0, x26
 	adr	lr, ret_from_exception
 	b	do_undefinstr
@@ -494,12 +539,14 @@ el0_dbg:
 	tbnz	x24, #0, el0_inv		// EL0 only
 	mrs	x26, far_el1
 	disable_step x1
+	ct_user_exit
 	mov	x0, x26
 	mov	x1, x25
 	mov	x2, sp
 	adr	lr, ret_from_exception
 	b	do_debug_exception
 el0_inv:
+	ct_user_exit
 	mov	x0, sp
 	mov	x1, #BAD_SYNC
 	mrs	x2, esr_el1
@@ -518,6 +565,7 @@ el0_irq_naked:
 	bl	trace_hardirqs_off
 #endif
 
+	ct_user_exit
 	irq_handler
 	get_thread_info tsk
 
@@ -640,6 +688,7 @@ el0_svc_naked:					// compat entry point
 	isb
 	enable_dbg
 	enable_irq
+	ct_user_exit 1
 
 	get_thread_info tsk
 	ldr	x16, [tsk, #TI_FLAGS]		// check for syscall tracing
-- 
1.8.3.2

