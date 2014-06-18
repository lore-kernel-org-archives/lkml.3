Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965669AbaFRJsN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 05:48:13 -0400
Received: from mga02.intel.com ([134.134.136.20]:24707 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965822AbaFRJsJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 05:48:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,499,1400050800"; 
   d="scan'208";a="530353801"
From: Qiaowei Ren <qiaowei.ren@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Dave Hansen <dave.hansen@intel.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Qiaowei Ren <qiaowei.ren@intel.com>
Subject: [PATCH v6 04/10] x86, mpx: hook #BR exception handler to allocate bound tables
Date: Wed, 18 Jun 2014 17:44:10 +0800
Message-Id: <1403084656-27284-5-git-send-email-qiaowei.ren@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1403084656-27284-1-git-send-email-qiaowei.ren@intel.com>
References: <1403084656-27284-1-git-send-email-qiaowei.ren@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch handles a #BR exception for non-existent tables by
carving the space out of the normal processes address space
(essentially calling mmap() from inside the kernel) and then
pointing the bounds-directory over to it.

The tables need to be accessed and controlled by userspace
because the compiler generates instructions for MPX-enabled
code which frequently store and retrieve entries from the bounds
tables. Any direct kernel involvement (like a syscall) to access
the tables would destroy performance since these are so frequent.

The tables are carved out of userspace because we have no better
spot to put them. For each pointer which is being tracked by MPX,
the bounds tables contain 4 longs worth of data, and the tables
are indexed virtually. If we were to preallocate the tables, we
would theoretically need to allocate 4x the virtual space that
we have available for userspace somewhere else. We don't have
that room in the kernel address space.

Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
---
 arch/x86/include/asm/mpx.h |   20 ++++++++++++++
 arch/x86/kernel/Makefile   |    1 +
 arch/x86/kernel/mpx.c      |   63 ++++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/traps.c    |   56 ++++++++++++++++++++++++++++++++++++++-
 4 files changed, 139 insertions(+), 1 deletions(-)
 create mode 100644 arch/x86/kernel/mpx.c

diff --git a/arch/x86/include/asm/mpx.h b/arch/x86/include/asm/mpx.h
index 5725ac4..b7598ac 100644
--- a/arch/x86/include/asm/mpx.h
+++ b/arch/x86/include/asm/mpx.h
@@ -18,6 +18,8 @@
 #define MPX_BT_ENTRY_SHIFT	5
 #define MPX_IGN_BITS		3
 
+#define MPX_BD_ENTRY_TAIL	3
+
 #else
 
 #define MPX_BD_ENTRY_OFFSET	20
@@ -26,13 +28,31 @@
 #define MPX_BT_ENTRY_SHIFT	4
 #define MPX_IGN_BITS		2
 
+#define MPX_BD_ENTRY_TAIL	2
+
 #endif
 
+#define MPX_BNDSTA_TAIL		2
+#define MPX_BNDCFG_TAIL		12
+#define MPX_BNDSTA_ADDR_MASK	(~((1UL<<MPX_BNDSTA_TAIL)-1))
+#define MPX_BNDCFG_ADDR_MASK	(~((1UL<<MPX_BNDCFG_TAIL)-1))
+#define MPX_BT_ADDR_MASK	(~((1UL<<MPX_BD_ENTRY_TAIL)-1))
+
 #define MPX_BD_SIZE_BYTES (1UL<<(MPX_BD_ENTRY_OFFSET+MPX_BD_ENTRY_SHIFT))
 #define MPX_BT_SIZE_BYTES (1UL<<(MPX_BT_ENTRY_OFFSET+MPX_BT_ENTRY_SHIFT))
 
 #define MPX_BNDSTA_ERROR_CODE	0x3
+#define MPX_BD_ENTRY_VALID_FLAG	0x1
 
 unsigned long mpx_mmap(unsigned long len);
 
+#ifdef CONFIG_X86_INTEL_MPX
+int do_mpx_bt_fault(struct xsave_struct *xsave_buf);
+#else
+static inline int do_mpx_bt_fault(struct xsave_struct *xsave_buf)
+{
+	return -EINVAL;
+}
+#endif /* CONFIG_X86_INTEL_MPX */
+
 #endif /* _ASM_X86_MPX_H */
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index f4d9600..3e81aed 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -41,6 +41,7 @@ obj-$(CONFIG_PREEMPT)	+= preempt.o
 
 obj-y				+= process.o
 obj-y				+= i387.o xsave.o
+obj-$(CONFIG_X86_INTEL_MPX)	+= mpx.o
 obj-y				+= ptrace.o
 obj-$(CONFIG_X86_32)		+= tls.o
 obj-$(CONFIG_IA32_EMULATION)	+= tls.o
diff --git a/arch/x86/kernel/mpx.c b/arch/x86/kernel/mpx.c
new file mode 100644
index 0000000..4230c7b
--- /dev/null
+++ b/arch/x86/kernel/mpx.c
@@ -0,0 +1,63 @@
+#include <linux/kernel.h>
+#include <linux/syscalls.h>
+#include <asm/mpx.h>
+
+static int allocate_bt(long __user *bd_entry)
+{
+	unsigned long bt_addr, old_val = 0;
+	int ret = 0;
+
+	bt_addr = mpx_mmap(MPX_BT_SIZE_BYTES);
+	if (IS_ERR((void *)bt_addr)) {
+		pr_err("Bounds table allocation failed at entry addr %p\n",
+				bd_entry);
+		return bt_addr;
+	}
+	bt_addr = (bt_addr & MPX_BT_ADDR_MASK) | MPX_BD_ENTRY_VALID_FLAG;
+
+	ret = user_atomic_cmpxchg_inatomic(&old_val, bd_entry, 0, bt_addr);
+	if (ret)
+		goto out;
+
+	/*
+	 * there is a existing bounds table pointed at this bounds
+	 * directory entry, and so we need to free the bounds table
+	 * allocated just now.
+	 */
+	if (old_val)
+		goto out;
+
+	pr_debug("Allocate bounds table %lx at entry %p\n",
+			bt_addr, bd_entry);
+	return 0;
+
+out:
+	vm_munmap(bt_addr & MPX_BT_ADDR_MASK, MPX_BT_SIZE_BYTES);
+	return ret;
+}
+
+/*
+ * When a BNDSTX instruction attempts to save bounds to a BD entry
+ * with the lack of the valid bit being set, a #BR is generated.
+ * This is an indication that no BT exists for this entry. In this
+ * case the fault handler will allocate a new BT.
+ *
+ * With 32-bit mode, the size of BD is 4MB, and the size of each
+ * bound table is 16KB. With 64-bit mode, the size of BD is 2GB,
+ * and the size of each bound table is 4MB.
+ */
+int do_mpx_bt_fault(struct xsave_struct *xsave_buf)
+{
+	unsigned long status;
+	unsigned long bd_entry, bd_base;
+
+	bd_base = xsave_buf->bndcsr.cfg_reg_u & MPX_BNDCFG_ADDR_MASK;
+	status = xsave_buf->bndcsr.status_reg;
+
+	bd_entry = status & MPX_BNDSTA_ADDR_MASK;
+	if ((bd_entry < bd_base) ||
+		(bd_entry >= bd_base + MPX_BD_SIZE_BYTES))
+		return -EINVAL;
+
+	return allocate_bt((long __user *)bd_entry);
+}
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index f73b5d4..35b9b29 100644
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
@@ -263,6 +263,60 @@ dotraplinkage void do_double_fault(struct pt_regs *regs, long error_code)
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
+	if (!cpu_has_mpx) {
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
+	switch (status & MPX_BNDSTA_ERROR_CODE) {
+	case 2:
+		/*
+		 * Bound directory has invalid entry.
+		 * No signal will be sent to the user space.
+		 */
+		if (do_mpx_bt_fault(xsave_buf))
+			force_sig(SIGBUS, tsk);
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

