Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754958AbaF3JB5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 05:01:57 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:34427 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932174AbaF3JBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 05:01:53 -0400
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: Anton Vorontsov <anton.vorontsov@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        kgdb-bugreport@lists.sourceforge.net, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Colin Cross <ccross@android.com>, kernel-team@android.com,
        Rob Herring <robherring2@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Dave Martin <Dave.Martin@arm.com>, Fabio Estevam <festevam@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Nicolas Pitre <nico@linaro.org>,
        Daniel Thompson <daniel.thompson@linaro.org>
Subject: [PATCH v7 4/4] ARM: Add KGDB/KDB FIQ debugger generic code
Date: Mon, 30 Jun 2014 09:53:11 +0100
Message-Id: <1404118391-3850-5-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1404118391-3850-1-git-send-email-daniel.thompson@linaro.org>
References: <1403623097-1153-1-git-send-email-daniel.thompson@linaro.org>
 <1404118391-3850-1-git-send-email-daniel.thompson@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anton Vorontsov <anton.vorontsov@linaro.org>

The FIQ debugger may be used to debug situations when the kernel stuck
in uninterruptable sections, e.g. the kernel infinitely loops or
deadlocked in an interrupt or with interrupts disabled.

By default KGDB FIQ is disabled in runtime, but can be enabled with
kgdb_fiq.enable=1 kernel command line option.

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
Signed-off-by: John Stultz <john.stultz@linaro.org>
[daniel.thompson@linaro.org: Added __fiq_abt, rewrote stack init]
Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
Acked-by: Nicolas Pitre <nico@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Ben Dooks <ben.dooks@codethink.co.uk>
Cc: Dave Martin <Dave.Martin@arm.com>
---
 arch/arm/Kconfig                 |   2 +
 arch/arm/Kconfig.debug           |  18 ++++++
 arch/arm/include/asm/kgdb.h      |   7 +++
 arch/arm/kernel/Makefile         |   1 +
 arch/arm/kernel/kgdb_fiq.c       | 127 ++++++++++++++++++++++++++++++++++++++
 arch/arm/kernel/kgdb_fiq_entry.S | 130 +++++++++++++++++++++++++++++++++++++++
 6 files changed, 285 insertions(+)
 create mode 100644 arch/arm/kernel/kgdb_fiq.c
 create mode 100644 arch/arm/kernel/kgdb_fiq_entry.S

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 245058b..f385b27 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -297,6 +297,7 @@ choice
 config ARCH_MULTIPLATFORM
 	bool "Allow multiple platforms to be selected"
 	depends on MMU
+	select ARCH_MIGHT_HAVE_KGDB_FIQ
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select ARM_HAS_SG_CHAIN
 	select ARM_PATCH_PHYS_VIRT
@@ -346,6 +347,7 @@ config ARCH_REALVIEW
 
 config ARCH_VERSATILE
 	bool "ARM Ltd. Versatile family"
+	select ARCH_MIGHT_HAVE_KGDB_FIQ
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select ARM_AMBA
 	select ARM_TIMER_SP804
diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
index 26536f7..c7342b6 100644
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -2,6 +2,24 @@ menu "Kernel hacking"
 
 source "lib/Kconfig.debug"
 
+config ARCH_MIGHT_HAVE_KGDB_FIQ
+	bool
+
+config KGDB_FIQ
+	bool "KGDB FIQ support"
+	depends on KGDB_KDB && ARCH_MIGHT_HAVE_KGDB_FIQ && !THUMB2_KERNEL
+	select FIQ
+	help
+	  The FIQ debugger may be used to debug situations when the
+	  kernel stuck in uninterruptable sections, e.g. the kernel
+	  infinitely loops or deadlocked in an interrupt or with
+	  interrupts disabled.
+
+	  By default KGDB FIQ is disabled at runtime, but can be
+	  enabled with kgdb_fiq.enable=1 kernel command line option.
+
+	  If unsure, say N.
+
 config ARM_PTDUMP
 	bool "Export kernel pagetable layout to userspace via debugfs"
 	depends on DEBUG_KERNEL
diff --git a/arch/arm/include/asm/kgdb.h b/arch/arm/include/asm/kgdb.h
index 0a9d5dd..5de21f01 100644
--- a/arch/arm/include/asm/kgdb.h
+++ b/arch/arm/include/asm/kgdb.h
@@ -11,7 +11,9 @@
 #define __ARM_KGDB_H__
 
 #include <linux/ptrace.h>
+#include <linux/linkage.h>
 #include <asm/opcodes.h>
+#include <asm/exception.h>
 
 /*
  * GDB assumes that we're a user process being debugged, so
@@ -48,6 +50,11 @@ static inline void arch_kgdb_breakpoint(void)
 extern void kgdb_handle_bus_error(void);
 extern int kgdb_fault_expected;
 
+extern char kgdb_fiq_handler;
+extern char kgdb_fiq_handler_end;
+asmlinkage void __exception_irq_entry kgdb_fiq_do_handle(struct pt_regs *regs);
+extern int kgdb_register_fiq(unsigned int fiq);
+
 #endif /* !__ASSEMBLY__ */
 
 /*
diff --git a/arch/arm/kernel/Makefile b/arch/arm/kernel/Makefile
index 38ddd9f..30ee8f3 100644
--- a/arch/arm/kernel/Makefile
+++ b/arch/arm/kernel/Makefile
@@ -68,6 +68,7 @@ endif
 obj-$(CONFIG_OABI_COMPAT)	+= sys_oabi-compat.o
 obj-$(CONFIG_ARM_THUMBEE)	+= thumbee.o
 obj-$(CONFIG_KGDB)		+= kgdb.o
+obj-$(CONFIG_KGDB_FIQ)		+= kgdb_fiq_entry.o kgdb_fiq.o
 obj-$(CONFIG_ARM_UNWIND)	+= unwind.o
 obj-$(CONFIG_HAVE_TCM)		+= tcm.o
 obj-$(CONFIG_OF)		+= devtree.o
diff --git a/arch/arm/kernel/kgdb_fiq.c b/arch/arm/kernel/kgdb_fiq.c
new file mode 100644
index 0000000..99d23cc
--- /dev/null
+++ b/arch/arm/kernel/kgdb_fiq.c
@@ -0,0 +1,127 @@
+/*
+ * KGDB FIQ
+ *
+ * Copyright 2010 Google, Inc.
+ *		  Arve Hjønnevåg <arve@android.com>
+ *		  Colin Cross <ccross@android.com>
+ * Copyright 2012 Linaro Ltd.
+ *		  Anton Vorontsov <anton.vorontsov@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/errno.h>
+#include <linux/hardirq.h>
+#include <linux/atomic.h>
+#include <linux/kdb.h>
+#include <linux/kgdb.h>
+#include <asm/fiq.h>
+#include <asm/exception.h>
+
+static int kgdb_fiq_enabled;
+module_param_named(enable, kgdb_fiq_enabled, int, 0600);
+MODULE_PARM_DESC(enable, "set to 1 to enable FIQ KGDB");
+
+static unsigned int kgdb_fiq;
+
+struct fiq_stack {
+	u32 fiq[3];
+} ____cacheline_aligned;
+
+static struct fiq_stack stacks[NR_CPUS];
+
+asmlinkage void __exception_irq_entry kgdb_fiq_do_handle(struct pt_regs *regs)
+{
+	if (kgdb_nmi_poll_knock()) {
+		nmi_enter();
+		kgdb_handle_exception(1, 0, 0, regs);
+		nmi_exit();
+	}
+
+	eoi_fiq(kgdb_fiq);
+}
+
+static struct fiq_handler kgdb_fiq_desc = {
+	.name = "kgdb",
+};
+
+static long kgdb_fiq_setup_stack(void *info)
+{
+	struct pt_regs regs;
+
+	regs.ARM_sp = (unsigned long) stacks[smp_processor_id()].fiq;
+	set_fiq_regs(&regs);
+
+	return 0;
+}
+
+/**
+ * kgdb_fiq_enable_nmi - Manage NMI-triggered entry to KGDB
+ * @on: Flag to either enable or disable an NMI
+ *
+ * This function manages NMIs that usually cause KGDB to enter. That is, not
+ * all NMIs should be enabled or disabled, but only those that issue
+ * kgdb_handle_exception().
+ *
+ * The call counts disable requests, and thus allows to nest disables. But
+ * trying to enable already enabled NMI is an error.
+ */
+static void kgdb_fiq_enable_nmi(bool on)
+{
+	static atomic_t cnt;
+	int ret;
+
+	ret = atomic_add_return(on ? 1 : -1, &cnt);
+
+	/*
+	 * There should be only one instance that calls this function
+	 * in "enable, disable" order. All other users must call
+	 * disable first, then enable. If not, something is wrong.
+	 */
+	if (WARN_ON(ret > 1 && on))
+		return;
+
+	if (ret > 0)
+		enable_fiq(kgdb_fiq);
+	else
+		disable_fiq(kgdb_fiq);
+}
+
+int kgdb_register_fiq(unsigned int fiq)
+{
+	int err;
+	int cpu;
+
+	if (!kgdb_fiq_enabled)
+		return -ENODEV;
+
+	if (!has_fiq(fiq)) {
+		pr_warn(
+		    "%s: Cannot register %u (no FIQ with this number)\n",
+		    __func__, fiq);
+		return -ENODEV;
+	}
+
+	kgdb_fiq = fiq;
+
+	err = claim_fiq(&kgdb_fiq_desc);
+	if (err) {
+		pr_warn("%s: unable to claim fiq", __func__);
+		return err;
+	}
+
+	for_each_possible_cpu(cpu)
+		work_on_cpu(cpu, kgdb_fiq_setup_stack, NULL);
+
+	set_fiq_handler(&kgdb_fiq_handler,
+			&kgdb_fiq_handler_end - &kgdb_fiq_handler);
+
+	arch_kgdb_ops.enable_nmi = kgdb_fiq_enable_nmi;
+	return 0;
+}
diff --git a/arch/arm/kernel/kgdb_fiq_entry.S b/arch/arm/kernel/kgdb_fiq_entry.S
new file mode 100644
index 0000000..50499c0
--- /dev/null
+++ b/arch/arm/kernel/kgdb_fiq_entry.S
@@ -0,0 +1,130 @@
+/*
+ * KGDB FIQ entry
+ *
+ * Copyright 1996,1997,1998 Russell King.
+ * Copyright 2012 Linaro Ltd.
+ *		  Anton Vorontsov <anton.vorontsov@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation.
+ */
+
+#include <linux/linkage.h>
+#include <asm/assembler.h>
+#include <asm/memory.h>
+#include <asm/unwind.h>
+#include "entry-header.S"
+
+	.text
+
+@ This is needed for usr_entry/alignment_trap
+.LCcralign:
+	.long	cr_alignment
+.LCdohandle:
+	.long	kgdb_fiq_do_handle
+
+	.macro	fiq_handler
+	ldr	r1, =.LCdohandle
+	mov	r0, sp
+	adr	lr, BSYM(9997f)
+	ldr	pc, [r1]
+9997:
+	.endm
+
+/*
+ * svc_exit_via_fiq
+ *
+ * This macro acts in a similar manner to svc_exit but switches to FIQ
+ * mode to restore the final part of the register state.
+ *
+ * We cannot use the normal svc_exit procedure because that would
+ * clobber spsr_svc (FIQ could be delivered during the first few instructions
+ * of vector_swi meaning its contents have not been saved anywhere).
+ */
+	.macro  svc_exit_via_fiq, rpsr
+
+#ifdef CONFIG_TRACE_IRQFLAGS
+	tst	\rpsr, #PSR_I_BIT
+	bleq	trace_hardirqs_on
+#endif
+
+	mov	r0, sp
+	ldmib	r0, {r1 - r14}	@ abort is deadly from here onward (it will
+				@ clobber state restored below)
+	msr	cpsr_c, #FIQ_MODE | PSR_I_BIT | PSR_F_BIT
+	add	r8, r0, #S_PC
+	ldr	r9, [r0, #S_PSR]
+	msr	spsr_cxsf, r9
+	ldr	r0, [r0, #S_R0]
+	ldmia	r8, {pc}^
+	.endm
+
+	.align	5
+__fiq_svc:
+	svc_entry
+	fiq_handler
+	svc_exit_via_fiq r5
+ UNWIND(.fnend		)
+ENDPROC(__fiq_svc)
+	.ltorg
+
+	.align 5
+__fiq_abt:
+	svc_entry
+
+	msr	cpsr_c, #ABT_MODE | PSR_I_BIT | PSR_F_BIT
+	mov	r0, lr		@ Save lr_abt
+	mrs	r1, spsr	@ Save spsr_abt, abort is now safe
+	msr	cpsr_c, #SVC_MODE | PSR_I_BIT | PSR_F_BIT
+	push	{r0 - r1}
+
+	fiq_handler
+
+	pop	{r0 - r1}
+	msr	cpsr_c, #ABT_MODE | PSR_I_BIT | PSR_F_BIT
+	mov	lr, r0		@ Restore lr_abt, abort is unsafe
+	msr	spsr_cxsf, r1	@ Restore spsr_abt
+	msr	cpsr_c, #SVC_MODE | PSR_I_BIT | PSR_F_BIT
+
+	svc_exit_via_fiq r5
+ UNWIND(.fnend		)
+ENDPROC(__fiq_svc)
+	.ltorg
+
+	.align	5
+__fiq_usr:
+	usr_entry
+	kuser_cmpxchg_check
+	fiq_handler
+	get_thread_info tsk
+	mov	why, #0
+	b	ret_to_user_from_irq
+ UNWIND(.fnend		)
+ENDPROC(__fiq_usr)
+	.ltorg
+
+	.global kgdb_fiq_handler
+kgdb_fiq_handler:
+
+	vector_stub	fiq, FIQ_MODE, 4
+
+	.long	__fiq_usr			@  0  (USR_26 / USR_32)
+	.long	__fiq_svc			@  1  (FIQ_26 / FIQ_32)
+	.long	__fiq_svc			@  2  (IRQ_26 / IRQ_32)
+	.long	__fiq_svc			@  3  (SVC_26 / SVC_32)
+	.long	__fiq_svc			@  4
+	.long	__fiq_svc			@  5
+	.long	__fiq_svc			@  6
+	.long	__fiq_abt			@  7
+	.long	__fiq_svc			@  8
+	.long	__fiq_svc			@  9
+	.long	__fiq_svc			@  a
+	.long	__fiq_svc			@  b
+	.long	__fiq_svc			@  c
+	.long	__fiq_svc			@  d
+	.long	__fiq_svc			@  e
+	.long	__fiq_svc			@  f
+
+	.global kgdb_fiq_handler_end
+kgdb_fiq_handler_end:
-- 
1.9.3

