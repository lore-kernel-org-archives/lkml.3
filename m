Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756233AbaE3Tek (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 15:34:40 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:62971 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756096AbaE3Tea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 15:34:30 -0400
From: Larry Bassel <larry.bassel@linaro.org>
To: catalin.marinas@arm.com, will.deacon@arm.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org, khilman@linaro.org,
        Larry Bassel <larry.bassel@linaro.org>
Subject: [PATCH v7 2/2] arm64: enable context tracking
Date: Fri, 30 May 2014 12:34:15 -0700
Message-Id: <1401478455-26391-3-git-send-email-larry.bassel@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1401478455-26391-1-git-send-email-larry.bassel@linaro.org>
References: <1401478455-26391-1-git-send-email-larry.bassel@linaro.org>
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
Acked-by: Will Deacon <will.deacon@arm.com>
---
 arch/arm64/Kconfig                   |  1 +
 arch/arm64/include/asm/thread_info.h |  4 ++++
 arch/arm64/kernel/entry.S            | 39 +++++++++++++++++++++++++++++++++++-
 3 files changed, 43 insertions(+), 1 deletion(-)

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
index 720e70b..8363f34 100644
--- a/arch/arm64/include/asm/thread_info.h
+++ b/arch/arm64/include/asm/thread_info.h
@@ -100,6 +100,7 @@ static inline struct thread_info *current_thread_info(void)
 #define TIF_SIGPENDING		0
 #define TIF_NEED_RESCHED	1
 #define TIF_NOTIFY_RESUME	2	/* callback before returning to user */
+#define TIF_NOHZ                7
 #define TIF_SYSCALL_TRACE	8
 #define TIF_POLLING_NRFLAG	16
 #define TIF_MEMDIE		18	/* is terminating due to OOM killer */
@@ -113,9 +114,12 @@ static inline struct thread_info *current_thread_info(void)
 #define _TIF_NEED_RESCHED	(1 << TIF_NEED_RESCHED)
 #define _TIF_NOTIFY_RESUME	(1 << TIF_NOTIFY_RESUME)
 #define _TIF_32BIT		(1 << TIF_32BIT)
+#define _TIF_SYSCALL_TRACE      (1 << TIF_SYSCALL_TRACE)
+#define _TIF_NOHZ               (1 << TIF_NOHZ)
 
 #define _TIF_WORK_MASK		(_TIF_NEED_RESCHED | _TIF_SIGPENDING | \
 				 _TIF_NOTIFY_RESUME)
+#define _TIF_SYSCALL_WORK       (_TIF_SYSCALL_TRACE | _TIF_NOHZ)
 
 #endif /* __KERNEL__ */
 #endif /* __ASM_THREAD_INFO_H */
diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index b0101b9..39d4dc9 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -30,6 +30,32 @@
 #include <asm/unistd32.h>
 
 /*
+ * Context tracking subsystem.  Used to instrument transitions
+ * between user and kernel mode.
+ */
+	.macro ct_user_exit, syscall = 0
+#ifdef CONFIG_CONTEXT_TRACKING
+	bl	context_tracking_user_exit
+	.if \syscall == 1
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
+	.macro ct_user_enter
+#ifdef CONFIG_CONTEXT_TRACKING
+	bl	context_tracking_user_enter
+#endif
+	.endm
+
+/*
  * Bad Abort numbers
  *-----------------
  */
@@ -91,6 +117,7 @@
 	.macro	kernel_exit, el, ret = 0
 	ldp	x21, x22, [sp, #S_PC]		// load ELR, SPSR
 	.if	\el == 0
+	ct_user_enter
 	ldr	x23, [sp, #S_SP]		// load return stack pointer
 	.endif
 	.if	\ret
@@ -318,6 +345,7 @@ el1_irq:
 	bl	trace_hardirqs_off
 #endif
 
+	ct_user_exit
 	irq_handler
 
 #ifdef CONFIG_PREEMPT
@@ -427,6 +455,7 @@ el0_da:
 	mrs	x26, far_el1
 	// enable interrupts before calling the main handler
 	enable_dbg_and_irq
+	ct_user_exit
 	bic	x0, x26, #(0xff << 56)
 	mov	x1, x25
 	mov	x2, sp
@@ -439,6 +468,7 @@ el0_ia:
 	mrs	x26, far_el1
 	// enable interrupts before calling the main handler
 	enable_dbg_and_irq
+	ct_user_exit
 	mov	x0, x26
 	orr	x1, x25, #1 << 24		// use reserved ISS bit for instruction aborts
 	mov	x2, sp
@@ -449,6 +479,7 @@ el0_fpsimd_acc:
 	 * Floating Point or Advanced SIMD access
 	 */
 	enable_dbg
+	ct_user_exit
 	mov	x0, x25
 	mov	x1, sp
 	adr	lr, ret_to_user
@@ -458,6 +489,7 @@ el0_fpsimd_exc:
 	 * Floating Point or Advanced SIMD exception
 	 */
 	enable_dbg
+	ct_user_exit
 	mov	x0, x25
 	mov	x1, sp
 	adr	lr, ret_to_user
@@ -480,6 +512,7 @@ el0_undef:
 	 */
 	// enable interrupts before calling the main handler
 	enable_dbg_and_irq
+	ct_user_exit
 	mov	x0, sp
 	adr	lr, ret_to_user
 	b	do_undefinstr
@@ -493,9 +526,11 @@ el0_dbg:
 	mov	x2, sp
 	bl	do_debug_exception
 	enable_dbg
+	ct_user_exit
 	b	ret_to_user
 el0_inv:
 	enable_dbg
+	ct_user_exit
 	mov	x0, sp
 	mov	x1, #BAD_SYNC
 	mrs	x2, esr_el1
@@ -616,9 +651,11 @@ el0_svc:
 el0_svc_naked:					// compat entry point
 	stp	x0, scno, [sp, #S_ORIG_X0]	// save the original x0 and syscall number
 	enable_dbg_and_irq
+	ct_user_exit 1
 
 	ldr	x16, [tsk, #TI_FLAGS]		// check for syscall tracing
-	tbnz	x16, #TIF_SYSCALL_TRACE, __sys_trace // are we tracing syscalls?
+	and	x16, x16, #_TIF_SYSCALL_WORK    // are we tracing syscalls?
+	cbnz	x16, __sys_trace
 	adr	lr, ret_fast_syscall		// return address
 	cmp     scno, sc_nr                     // check upper syscall limit
 	b.hs	ni_sys
-- 
1.8.3.2

