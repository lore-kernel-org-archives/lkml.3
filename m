Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752163AbaBLLZt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 06:25:49 -0500
Received: from mga14.intel.com ([143.182.124.37]:61194 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751790AbaBLLZW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 06:25:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,832,1384329600"; 
   d="scan'208";a="410307329"
From: Qiaowei Ren <qiaowei.ren@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Qiaowei Ren <qiaowei.ren@intel.com>
Subject: [PATCH v4 2/3] x86, mpx: hook #BR exception handler to allocate bound tables
Date: Thu, 13 Feb 2014 02:36:25 +0800
Message-Id: <1392230186-16130-3-git-send-email-qiaowei.ren@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1392230186-16130-1-git-send-email-qiaowei.ren@intel.com>
References: <1392230186-16130-1-git-send-email-qiaowei.ren@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

An access to an invalid bound directory entry will cause a #BR
exception. This patch hook #BR exception handler to allocate
one bound table and bind it with that buond directory entry.

This will avoid the need of forwarding the #BR exception
to the user space when bound directory has invalid entry.

Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
---
 arch/x86/include/asm/mpx.h |   35 ++++++++++++++++++++++++++++
 arch/x86/kernel/Makefile   |    1 +
 arch/x86/kernel/mpx.c      |   44 +++++++++++++++++++++++++++++++++++
 arch/x86/kernel/traps.c    |   55 +++++++++++++++++++++++++++++++++++++++++++-
 4 files changed, 134 insertions(+), 1 deletions(-)
 create mode 100644 arch/x86/include/asm/mpx.h
 create mode 100644 arch/x86/kernel/mpx.c

diff --git a/arch/x86/include/asm/mpx.h b/arch/x86/include/asm/mpx.h
new file mode 100644
index 0000000..d074153
--- /dev/null
+++ b/arch/x86/include/asm/mpx.h
@@ -0,0 +1,35 @@
+#ifndef _ASM_X86_MPX_H
+#define _ASM_X86_MPX_H
+
+#include <linux/types.h>
+#include <asm/ptrace.h>
+
+#ifdef CONFIG_X86_64
+
+#define MPX_L1_BITS	28
+#define MPX_L1_SHIFT	3
+#define MPX_L2_BITS	17
+#define MPX_L2_SHIFT	5
+#define MPX_IGN_BITS	3
+#define MPX_L2_NODE_ADDR_MASK	0xfffffffffffffff8UL
+
+#define MPX_BNDSTA_ADDR_MASK	0xfffffffffffffffcUL
+#define MPX_BNDCFG_ADDR_MASK	0xfffffffffffff000UL
+
+#else
+
+#define MPX_L1_BITS	20
+#define MPX_L1_SHIFT	2
+#define MPX_L2_BITS	10
+#define MPX_L2_SHIFT	4
+#define MPX_IGN_BITS	2
+#define MPX_L2_NODE_ADDR_MASK	0xfffffffcUL
+
+#define MPX_BNDSTA_ADDR_MASK	0xfffffffcUL
+#define MPX_BNDCFG_ADDR_MASK	0xfffff000UL
+
+#endif
+
+void do_mpx_bt_fault(struct xsave_struct *xsave_buf);
+
+#endif /* _ASM_X86_MPX_H */
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index cb648c8..becb970 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -41,6 +41,7 @@ obj-$(CONFIG_PREEMPT)	+= preempt.o
 
 obj-y				+= process.o
 obj-y				+= i387.o xsave.o
+obj-y				+= mpx.o
 obj-y				+= ptrace.o
 obj-$(CONFIG_X86_32)		+= tls.o
 obj-$(CONFIG_IA32_EMULATION)	+= tls.o
diff --git a/arch/x86/kernel/mpx.c b/arch/x86/kernel/mpx.c
new file mode 100644
index 0000000..e055e0e
--- /dev/null
+++ b/arch/x86/kernel/mpx.c
@@ -0,0 +1,44 @@
+#include <linux/kernel.h>
+#include <linux/syscalls.h>
+#include <asm/processor.h>
+#include <asm/mpx.h>
+#include <asm/mman.h>
+#include <asm/i387.h>
+#include <asm/fpu-internal.h>
+#include <asm/alternative.h>
+
+static bool allocate_bt(unsigned long bd_entry)
+{
+	unsigned long bt_size = 1UL << (MPX_L2_BITS+MPX_L2_SHIFT);
+	unsigned long bt_addr, old_val = 0;
+
+	bt_addr = sys_mmap_pgoff(0, bt_size, PROT_READ | PROT_WRITE,
+			MAP_ANONYMOUS | MAP_PRIVATE | MAP_POPULATE, -1, 0);
+	if (bt_addr == -1) {
+		pr_err("L2 Node Allocation Failed at L1 addr %lx\n",
+				bd_entry);
+		return false;
+	}
+	bt_addr = (bt_addr & MPX_L2_NODE_ADDR_MASK) | 0x01;
+
+	user_atomic_cmpxchg_inatomic(&old_val,
+			(long __user *)bd_entry, 0, bt_addr);
+	if (old_val)
+		vm_munmap(bt_addr & MPX_L2_NODE_ADDR_MASK, bt_size);
+
+	return true;
+}
+
+void do_mpx_bt_fault(struct xsave_struct *xsave_buf)
+{
+	unsigned long status;
+	unsigned long bd_entry, bd_base;
+	unsigned long bd_size = 1UL << (MPX_L1_BITS+MPX_L1_SHIFT);
+
+	bd_base = xsave_buf->bndcsr.cfg_reg_u & MPX_BNDCFG_ADDR_MASK;
+	status = xsave_buf->bndcsr.status_reg;
+
+	bd_entry = status & MPX_BNDSTA_ADDR_MASK;
+	if ((bd_entry >= bd_base) && (bd_entry < bd_base + bd_size))
+		allocate_bt(bd_entry);
+}
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 57409f6..fe09b3d 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -59,6 +59,7 @@
 #include <asm/fixmap.h>
 #include <asm/mach_traps.h>
 #include <asm/alternative.h>
+#include <asm/mpx.h>
 
 #ifdef CONFIG_X86_64
 #include <asm/x86_init.h>
@@ -213,7 +214,6 @@ dotraplinkage void do_##name(struct pt_regs *regs, long error_code)	\
 
 DO_ERROR_INFO(X86_TRAP_DE,     SIGFPE,  "divide error",			divide_error,		     FPE_INTDIV, regs->ip )
 DO_ERROR     (X86_TRAP_OF,     SIGSEGV, "overflow",			overflow					  )
-DO_ERROR     (X86_TRAP_BR,     SIGSEGV, "bounds",			bounds						  )
 DO_ERROR_INFO(X86_TRAP_UD,     SIGILL,  "invalid opcode",		invalid_op,		     ILL_ILLOPN, regs->ip )
 DO_ERROR     (X86_TRAP_OLD_MF, SIGFPE,  "coprocessor segment overrun",	coprocessor_segment_overrun			  )
 DO_ERROR     (X86_TRAP_TS,     SIGSEGV, "invalid TSS",			invalid_TSS					  )
@@ -263,6 +263,59 @@ dotraplinkage void do_double_fault(struct pt_regs *regs, long error_code)
 }
 #endif
 
+dotraplinkage void do_bounds(struct pt_regs *regs, long error_code)
+{
+	enum ctx_state prev_state;
+	unsigned long status;
+	struct xsave_struct *xsave_buf;
+	struct task_struct *tsk = current;
+
+	prev_state = exception_enter();
+	if (notify_die(DIE_TRAP, "bounds", regs, error_code,
+			X86_TRAP_BR, SIGSEGV) == NOTIFY_STOP)
+		goto exit;
+	conditional_sti(regs);
+
+	if (!user_mode(regs))
+		die("bounds", regs, error_code);
+
+	if (!boot_cpu_has(X86_FEATURE_MPX)) {
+		/* The exception is not from Intel MPX */
+		do_trap(X86_TRAP_BR, SIGSEGV, "bounds", regs, error_code, NULL);
+		goto exit;
+	}
+
+	fpu_xsave(&tsk->thread.fpu);
+	xsave_buf = &(tsk->thread.fpu.state->xsave);
+	status = xsave_buf->bndcsr.status_reg;
+
+	/*
+	 * The error code field of the BNDSTATUS register communicates status
+	 * information of a bound range exception #BR or operation involving
+	 * bound directory.
+	 */
+	switch (status & 0x3) {
+	case 2:
+		/*
+		 * Bound directory has invalid entry.
+		 * No signal will be sent to the user space.
+		 */
+		do_mpx_bt_fault(xsave_buf);
+		break;
+
+	case 1: /* Bound violation. */
+	case 0: /* No exception caused by Intel MPX operations. */
+		do_trap(X86_TRAP_BR, SIGSEGV, "bounds", regs, error_code, NULL);
+		break;
+
+	default:
+		die("bounds", regs, error_code);
+	}
+
+exit:
+	exception_exit(prev_state);
+}
+
 dotraplinkage void __kprobes
 do_general_protection(struct pt_regs *regs, long error_code)
 {
-- 
1.7.1

