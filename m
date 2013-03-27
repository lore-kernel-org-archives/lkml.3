Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754823Ab3C0Xtc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 19:49:32 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:43273 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754521Ab3C0Xtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 19:49:31 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Russell King <rmk+kernel@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org,
        Mats Liljegren <mats.liljegren@enea.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH v2] ARM: add support for context tracking subsystem
Date: Wed, 27 Mar 2013 16:49:27 -0700
Message-Id: <1364428167-20411-1-git-send-email-khilman@linaro.org>
X-Mailer: git-send-email 1.8.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 91d1aa43 (context_tracking: New context tracking susbsystem)
generalized parts of the RCU userspace extended quiescent state into
the context tracking subsystem.  Context tracking is then used
to implement adaptive tickless (a.k.a extended nohz)

To support the new context tracking subsystem on ARM, the user/kernel
boundary transtions need to be instrumented.

For exceptions and IRQs in usermode, the existing usr_entry macro is
used to instrument the user->kernel transition.  For the return to
usermode path, the ret_to_user* path is instrumented.  Using the
usr_entry macro, this covers interrupts in userspace, data abort and
prefetch abort exceptions in userspace as well as undefined exceptions
in userspace (which is where FP emulation and VFP are handled.)

For syscalls, the slow return path is covered by instrumenting the
ret_to_user path.  In addition, the syscall entry point is
instrumented which covers the user->kernel transition for both fast
and slow syscalls, and an additional instrumentation point is added
for the fast syscall return path (ret_fast_syscall).

Cc: Mats Liljegren <mats.liljegren@enea.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Kevin Hilman <khilman@linaro.org>
---
Updates from v1:
- instrument entry/exit points directly in assembly, instead of C code
- combined exceptions and syscalls into a single patch
- covers VFP and FP emulation now (v1 limitation pointed out by Russell)

Depends on the previously posted prerequistes series: 
  [PATCH 0/3] ARM: context tracking support prerequisites
  http://marc.info/?l=linux-kernel&m=136382248131438&w=2

Both of which are combined on top of Frederic's 3.9-rc1-nohz1 branch
and available here:
git://git.kernel.org/pub/scm/linux/kernel/git/khilman/linux.git arm-nohz-v2/context-tracking

 arch/arm/Kconfig                   |  1 +
 arch/arm/include/asm/thread_info.h |  1 +
 arch/arm/kernel/entry-armv.S       |  1 +
 arch/arm/kernel/entry-common.S     |  3 +++
 arch/arm/kernel/entry-header.S     | 20 ++++++++++++++++++++
 5 files changed, 26 insertions(+)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index ba8bf89..0b13689 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -59,6 +59,7 @@ config ARM
 	select OLD_SIGSUSPEND3
 	select OLD_SIGACTION
 	select HAVE_VIRT_CPU_ACCOUNTING
+	select HAVE_CONTEXT_TRACKING
 	help
 	  The ARM series is a line of low-power-consumption RISC chip designs
 	  licensed by ARM Ltd and targeted at embedded applications and
diff --git a/arch/arm/include/asm/thread_info.h b/arch/arm/include/asm/thread_info.h
index cddda1f..1995d1a 100644
--- a/arch/arm/include/asm/thread_info.h
+++ b/arch/arm/include/asm/thread_info.h
@@ -152,6 +152,7 @@ extern int vfp_restore_user_hwstate(struct user_vfp __user *,
 #define TIF_SYSCALL_AUDIT	9
 #define TIF_SYSCALL_TRACEPOINT	10
 #define TIF_SECCOMP		11	/* seccomp syscall filtering active */
+#define TIF_NOHZ		12	/* in adaptive nohz mode */
 #define TIF_USING_IWMMXT	17
 #define TIF_MEMDIE		18	/* is terminating due to OOM killer */
 #define TIF_RESTORE_SIGMASK	20
diff --git a/arch/arm/kernel/entry-armv.S b/arch/arm/kernel/entry-armv.S
index 0f82098..1034d40 100644
--- a/arch/arm/kernel/entry-armv.S
+++ b/arch/arm/kernel/entry-armv.S
@@ -396,6 +396,7 @@ ENDPROC(__pabt_svc)
 #ifdef CONFIG_IRQSOFF_TRACER
 	bl	trace_hardirqs_off
 #endif
+	ct_user_exit
 	.endm
 
 	.macro	kuser_cmpxchg_check
diff --git a/arch/arm/kernel/entry-common.S b/arch/arm/kernel/entry-common.S
index 3248cde..5c2b27a 100644
--- a/arch/arm/kernel/entry-common.S
+++ b/arch/arm/kernel/entry-common.S
@@ -38,6 +38,7 @@ ret_fast_syscall:
 #if defined(CONFIG_IRQSOFF_TRACER)
 	asm_trace_hardirqs_on
 #endif
+	ct_user_enter
 
 	/* perform architecture specific actions before user return */
 	arch_ret_to_user r1, lr
@@ -74,6 +75,7 @@ no_work_pending:
 #if defined(CONFIG_IRQSOFF_TRACER)
 	asm_trace_hardirqs_on
 #endif
+	ct_user_enter
 	/* perform architecture specific actions before user return */
 	arch_ret_to_user r1, lr
 
@@ -394,6 +396,7 @@ ENTRY(vector_swi)
 	mcr	p15, 0, ip, c1, c0		@ update control register
 #endif
 	enable_irq
+	ct_user_exit
 
 	get_thread_info tsk
 	adr	tbl, sys_call_table		@ load syscall table pointer
diff --git a/arch/arm/kernel/entry-header.S b/arch/arm/kernel/entry-header.S
index 9a8531e..d65b86c 100644
--- a/arch/arm/kernel/entry-header.S
+++ b/arch/arm/kernel/entry-header.S
@@ -164,6 +164,26 @@
 #endif	/* !CONFIG_THUMB2_KERNEL */
 
 /*
+ * Context tracking subsystem.  Used to instrument transitions
+ * between user and kernel mode.
+ */
+	.macro ct_user_exit
+#ifdef CONFIG_CONTEXT_TRACKING
+	stmdb   sp!, {r0-r3, ip, lr}
+	bl	user_exit
+	ldmia	sp!, {r0-r3, ip, lr}
+#endif
+	.endm
+
+	.macro ct_user_enter
+#ifdef CONFIG_CONTEXT_TRACKING
+	stmdb   sp!, {r0-r3, ip, lr}
+	bl	user_enter
+	ldmia	sp!, {r0-r3, ip, lr}
+#endif
+	.endm
+
+/*
  * These are the registers used in the syscall handler, and allow us to
  * have in theory up to 7 arguments to a function - r0 to r6.
  *
-- 
1.8.2

