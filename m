Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754295AbaEFXcy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 19:32:54 -0400
Received: from mail-qc0-f169.google.com ([209.85.216.169]:61803 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753701AbaEFXcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 19:32:46 -0400
From: Larry Bassel <larry.bassel@linaro.org>
To: catalin.marinas@arm.com, will.deacon@arm.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org, khilman@linaro.org,
        Larry Bassel <larry.bassel@linaro.org>
Subject: [PATCH v2 2/2] arm64: enable context tracking
Date: Tue,  6 May 2014 16:32:29 -0700
Message-Id: <1399419149-26685-3-git-send-email-larry.bassel@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1399419149-26685-1-git-send-email-larry.bassel@linaro.org>
References: <1399419149-26685-1-git-send-email-larry.bassel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make calls to ct_user_enter when the kernel is exited
and ct_user_exit when the kernel is entered (in el0_da,
el0_ia, el0_svc, el0_irq).

These macros expand to function calls which will only work
properly if el0_sync and related code has been rearranged
(in a previous patch of this series).

In order to avoid saving registers, the slow syscall path
is forced (as x86 does).

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
 arch/arm64/kernel/entry.S            | 22 ++++++++++++++++++++++
 3 files changed, 24 insertions(+)

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
index d920d7f..5fe447c 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -30,6 +30,22 @@
 #include <asm/unistd32.h>
 
 /*
+ * Context tracking subsystem.  Used to instrument transitions
+ * between user and kernel mode.
+ */
+	.macro ct_user_exit
+#ifdef CONFIG_CONTEXT_TRACKING
+	bl	context_tracking_user_exit
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
@@ -88,6 +104,7 @@
 	.macro	kernel_exit, el, ret = 0
 	ldp	x21, x22, [sp, #S_PC]		// load ELR, SPSR
 	.if	\el == 0
+	ct_user_enter
 	ldr	x23, [sp, #S_SP]		// load return stack pointer
 	.endif
 	.if	\ret
@@ -427,6 +444,7 @@ el0_da:
 	enable_dbg
 	// enable interrupts before calling the main handler
 	enable_irq
+	ct_user_exit
 	mov	x0, x26
 	bic	x0, x0, #(0xff << 56)
 	mov	x1, x25
@@ -443,6 +461,7 @@ el0_ia:
 	enable_dbg
 	// enable interrupts before calling the main handler
 	enable_irq
+	ct_user_exit
 	mov	x0, x26
 	orr	x1, x25, #1 << 24		// use reserved ISS bit for instruction aborts
 	mov	x2, sp
@@ -511,6 +530,7 @@ el0_irq_naked:
 	bl	trace_hardirqs_off
 #endif
 
+	ct_user_exit
 	irq_handler
 	get_thread_info tsk
 
@@ -633,10 +653,12 @@ el0_svc_naked:					// compat entry point
 	isb
 	enable_dbg
 	enable_irq
+	ct_user_exit
 
 	get_thread_info tsk
 	ldr	x16, [tsk, #TI_FLAGS]		// check for syscall tracing
 	tbnz	x16, #TIF_SYSCALL_TRACE, __sys_trace // are we tracing syscalls?
+	tbnz	x16, #TIF_NOHZ, __sys_trace
 	adr	lr, ret_fast_syscall		// return address
 	cmp     scno, sc_nr                     // check upper syscall limit
 	b.hs	ni_sys
-- 
1.8.3.2

