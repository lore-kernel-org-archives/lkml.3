Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755877Ab3C2KA7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 06:00:59 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:47095 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755437Ab3C2KA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 06:00:57 -0400
From: Li Zhong <zhong@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org, paulmck@linux.vnet.ibm.com,
        fweisbec@gmail.com, benh@kernel.crashing.org, paulus@samba.org,
        Li Zhong <zhong@linux.vnet.ibm.com>
Subject: [RFC PATCH v2 2/6] powerpc: Exception hooks for context tracking subsystem
Date: Fri, 29 Mar 2013 18:00:17 +0800
Message-Id: <1364551221-23177-3-git-send-email-zhong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1364551221-23177-1-git-send-email-zhong@linux.vnet.ibm.com>
References: <1364551221-23177-1-git-send-email-zhong@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13032909-8256-0000-0000-000006DA628D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the exception hooks for context tracking subsystem, including
data access, program check, single step, instruction breakpoint, machine check,
alignment, fp unavailable, altivec assist, unknown exception, whose handlers
might use RCU.

This patch corresponds to
[PATCH] x86: Exception hooks for userspace RCU extended QS
  commit 6ba3c97a38803883c2eee489505796cb0a727122

Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
---
 arch/powerpc/include/asm/context_tracking.h |   28 +++++++++
 arch/powerpc/kernel/exceptions-64s.S        |    4 +-
 arch/powerpc/kernel/traps.c                 |   83 ++++++++++++++++++++-------
 arch/powerpc/mm/fault.c                     |   15 ++++-
 arch/powerpc/mm/hash_utils_64.c             |   17 ++++++
 5 files changed, 122 insertions(+), 25 deletions(-)
 create mode 100644 arch/powerpc/include/asm/context_tracking.h

diff --git a/arch/powerpc/include/asm/context_tracking.h b/arch/powerpc/include/asm/context_tracking.h
new file mode 100644
index 0000000..377146e
--- /dev/null
+++ b/arch/powerpc/include/asm/context_tracking.h
@@ -0,0 +1,28 @@
+#ifndef _ASM_POWERPC_CONTEXT_TRACKING_H
+#define _ASM_POWERPC_CONTEXT_TRACKING_H
+
+#include <linux/context_tracking.h>
+#include <asm/ptrace.h>
+
+/*
+ * temporarily defined to avoid potential conflicts with the common
+ * implementation, these will be removed by a later patch after the common
+ * code enters powerpc tree
+ */
+#define exception_enter __exception_enter
+#define exception_exit __exception_exit
+
+static inline void __exception_enter(struct pt_regs *regs)
+{
+	user_exit();
+}
+
+static inline void __exception_exit(struct pt_regs *regs)
+{
+#ifdef CONFIG_CONTEXT_TRACKING
+	if (user_mode(regs))
+		user_enter();
+#endif
+}
+
+#endif
diff --git a/arch/powerpc/kernel/exceptions-64s.S b/arch/powerpc/kernel/exceptions-64s.S
index a8a5361..6d82f4f 100644
--- a/arch/powerpc/kernel/exceptions-64s.S
+++ b/arch/powerpc/kernel/exceptions-64s.S
@@ -1368,15 +1368,17 @@ END_MMU_FTR_SECTION_IFCLR(MMU_FTR_SLB)
 	rlwimi	r4,r0,32-13,30,30	/* becomes _PAGE_USER access bit */
 	ori	r4,r4,1			/* add _PAGE_PRESENT */
 	rlwimi	r4,r5,22+2,31-2,31-2	/* Set _PAGE_EXEC if trap is 0x400 */
+	addi	r6,r1,STACK_FRAME_OVERHEAD
 
 	/*
 	 * r3 contains the faulting address
 	 * r4 contains the required access permissions
 	 * r5 contains the trap number
+	 * r6 contains the address of pt_regs
 	 *
 	 * at return r3 = 0 for success, 1 for page fault, negative for error
 	 */
-	bl	.hash_page		/* build HPTE if possible */
+	bl	.hash_page_ct		/* build HPTE if possible */
 	cmpdi	r3,0			/* see if hash_page succeeded */
 
 	/* Success */
diff --git a/arch/powerpc/kernel/traps.c b/arch/powerpc/kernel/traps.c
index 37cc40e..6228b6b 100644
--- a/arch/powerpc/kernel/traps.c
+++ b/arch/powerpc/kernel/traps.c
@@ -60,6 +60,7 @@
 #include <asm/switch_to.h>
 #include <asm/tm.h>
 #include <asm/debug.h>
+#include <asm/context_tracking.h>
 
 #if defined(CONFIG_DEBUGGER) || defined(CONFIG_KEXEC)
 int (*__debugger)(struct pt_regs *regs) __read_mostly;
@@ -669,6 +670,8 @@ void machine_check_exception(struct pt_regs *regs)
 {
 	int recover = 0;
 
+	exception_enter(regs);
+
 	__get_cpu_var(irq_stat).mce_exceptions++;
 
 	/* See if any machine dependent calls. In theory, we would want
@@ -683,7 +686,7 @@ void machine_check_exception(struct pt_regs *regs)
 		recover = cur_cpu_spec->machine_check(regs);
 
 	if (recover > 0)
-		return;
+		goto exit;
 
 #if defined(CONFIG_8xx) && defined(CONFIG_PCI)
 	/* the qspan pci read routines can cause machine checks -- Cort
@@ -693,20 +696,23 @@ void machine_check_exception(struct pt_regs *regs)
 	 * -- BenH
 	 */
 	bad_page_fault(regs, regs->dar, SIGBUS);
-	return;
+	goto exit;
 #endif
 
 	if (debugger_fault_handler(regs))
-		return;
+		goto exit;
 
 	if (check_io_access(regs))
-		return;
+		goto exit;
 
 	die("Machine check", regs, SIGBUS);
 
 	/* Must die if the interrupt is not recoverable */
 	if (!(regs->msr & MSR_RI))
 		panic("Unrecoverable Machine check");
+
+exit:
+	exception_exit(regs);
 }
 
 void SMIException(struct pt_regs *regs)
@@ -716,20 +722,29 @@ void SMIException(struct pt_regs *regs)
 
 void unknown_exception(struct pt_regs *regs)
 {
+	exception_enter(regs);
+
 	printk("Bad trap at PC: %lx, SR: %lx, vector=%lx\n",
 	       regs->nip, regs->msr, regs->trap);
 
 	_exception(SIGTRAP, regs, 0, 0);
+
+	exception_exit(regs);
 }
 
 void instruction_breakpoint_exception(struct pt_regs *regs)
 {
+	exception_enter(regs);
+
 	if (notify_die(DIE_IABR_MATCH, "iabr_match", regs, 5,
 					5, SIGTRAP) == NOTIFY_STOP)
-		return;
+		goto exit;
 	if (debugger_iabr_match(regs))
-		return;
+		goto exit;
 	_exception(SIGTRAP, regs, TRAP_BRKPT, regs->nip);
+
+exit:
+	exception_exit(regs);
 }
 
 void RunModeException(struct pt_regs *regs)
@@ -739,15 +754,20 @@ void RunModeException(struct pt_regs *regs)
 
 void __kprobes single_step_exception(struct pt_regs *regs)
 {
+	exception_enter(regs);
+
 	clear_single_step(regs);
 
 	if (notify_die(DIE_SSTEP, "single_step", regs, 5,
 					5, SIGTRAP) == NOTIFY_STOP)
-		return;
+		goto exit;
 	if (debugger_sstep(regs))
-		return;
+		goto exit;
 
 	_exception(SIGTRAP, regs, TRAP_TRACE, regs->nip);
+
+exit:
+	exception_exit(regs);
 }
 
 /*
@@ -1002,32 +1022,34 @@ void __kprobes program_check_exception(struct pt_regs *regs)
 	unsigned int reason = get_reason(regs);
 	extern int do_mathemu(struct pt_regs *regs);
 
+	exception_enter(regs);
+
 	/* We can now get here via a FP Unavailable exception if the core
 	 * has no FPU, in that case the reason flags will be 0 */
 
 	if (reason & REASON_FP) {
 		/* IEEE FP exception */
 		parse_fpe(regs);
-		return;
+		goto exit;
 	}
 	if (reason & REASON_TRAP) {
 		/* Debugger is first in line to stop recursive faults in
 		 * rcu_lock, notify_die, or atomic_notifier_call_chain */
 		if (debugger_bpt(regs))
-			return;
+			goto exit;
 
 		/* trap exception */
 		if (notify_die(DIE_BPT, "breakpoint", regs, 5, 5, SIGTRAP)
 				== NOTIFY_STOP)
-			return;
+			goto exit;
 
 		if (!(regs->msr & MSR_PR) &&  /* not user-mode */
 		    report_bug(regs->nip, regs) == BUG_TRAP_TYPE_WARN) {
 			regs->nip += 4;
-			return;
+			goto exit;
 		}
 		_exception(SIGTRAP, regs, TRAP_BRKPT, regs->nip);
-		return;
+		goto exit;
 	}
 #ifdef CONFIG_PPC_TRANSACTIONAL_MEM
 	if (reason & REASON_TM) {
@@ -1043,7 +1065,7 @@ void __kprobes program_check_exception(struct pt_regs *regs)
 		if (!user_mode(regs) &&
 		    report_bug(regs->nip, regs) == BUG_TRAP_TYPE_WARN) {
 			regs->nip += 4;
-			return;
+			goto exit;
 		}
 		/* If usermode caused this, it's done something illegal and
 		 * gets a SIGILL slap on the wrist.  We call it an illegal
@@ -1053,7 +1075,7 @@ void __kprobes program_check_exception(struct pt_regs *regs)
 		 */
 		if (user_mode(regs)) {
 			_exception(SIGILL, regs, ILL_ILLOPN, regs->nip);
-			return;
+			goto exit;
 		} else {
 			printk(KERN_EMERG "Unexpected TM Bad Thing exception "
 			       "at %lx (msr 0x%x)\n", regs->nip, reason);
@@ -1077,16 +1099,16 @@ void __kprobes program_check_exception(struct pt_regs *regs)
 	switch (do_mathemu(regs)) {
 	case 0:
 		emulate_single_step(regs);
-		return;
+		goto exit;
 	case 1: {
 			int code = 0;
 			code = __parse_fpscr(current->thread.fpscr.val);
 			_exception(SIGFPE, regs, code, regs->nip);
-			return;
+			goto exit;
 		}
 	case -EFAULT:
 		_exception(SIGSEGV, regs, SEGV_MAPERR, regs->nip);
-		return;
+		goto exit;
 	}
 	/* fall through on any other errors */
 #endif /* CONFIG_MATH_EMULATION */
@@ -1097,10 +1119,10 @@ void __kprobes program_check_exception(struct pt_regs *regs)
 		case 0:
 			regs->nip += 4;
 			emulate_single_step(regs);
-			return;
+			goto exit;
 		case -EFAULT:
 			_exception(SIGSEGV, regs, SEGV_MAPERR, regs->nip);
-			return;
+			goto exit;
 		}
 	}
 
@@ -1108,12 +1130,17 @@ void __kprobes program_check_exception(struct pt_regs *regs)
 		_exception(SIGILL, regs, ILL_PRVOPC, regs->nip);
 	else
 		_exception(SIGILL, regs, ILL_ILLOPC, regs->nip);
+
+exit:
+	exception_exit(regs);
 }
 
 void alignment_exception(struct pt_regs *regs)
 {
 	int sig, code, fixed = 0;
 
+	exception_enter(regs);
+
 	/* We restore the interrupt state now */
 	if (!arch_irq_disabled_regs(regs))
 		local_irq_enable();
@@ -1125,7 +1152,7 @@ void alignment_exception(struct pt_regs *regs)
 	if (fixed == 1) {
 		regs->nip += 4;	/* skip over emulated instruction */
 		emulate_single_step(regs);
-		return;
+		goto exit;
 	}
 
 	/* Operand address was bad */
@@ -1140,6 +1167,9 @@ void alignment_exception(struct pt_regs *regs)
 		_exception(sig, regs, code, regs->dar);
 	else
 		bad_page_fault(regs, regs->dar, sig);
+
+exit:
+	exception_exit(regs);
 }
 
 void StackOverflow(struct pt_regs *regs)
@@ -1168,23 +1198,32 @@ void trace_syscall(struct pt_regs *regs)
 
 void kernel_fp_unavailable_exception(struct pt_regs *regs)
 {
+	exception_enter(regs);
+
 	printk(KERN_EMERG "Unrecoverable FP Unavailable Exception "
 			  "%lx at %lx\n", regs->trap, regs->nip);
 	die("Unrecoverable FP Unavailable Exception", regs, SIGABRT);
+
+	exception_exit(regs);
 }
 
 void altivec_unavailable_exception(struct pt_regs *regs)
 {
+	exception_enter(regs);
+
 	if (user_mode(regs)) {
 		/* A user program has executed an altivec instruction,
 		   but this kernel doesn't support altivec. */
 		_exception(SIGILL, regs, ILL_ILLOPC, regs->nip);
-		return;
+		goto exit;
 	}
 
 	printk(KERN_EMERG "Unrecoverable VMX/Altivec Unavailable Exception "
 			"%lx at %lx\n", regs->trap, regs->nip);
 	die("Unrecoverable VMX/Altivec Unavailable Exception", regs, SIGABRT);
+
+exit:
+	exception_exit(regs);
 }
 
 void vsx_unavailable_exception(struct pt_regs *regs)
diff --git a/arch/powerpc/mm/fault.c b/arch/powerpc/mm/fault.c
index 229951f..108ab17 100644
--- a/arch/powerpc/mm/fault.c
+++ b/arch/powerpc/mm/fault.c
@@ -42,6 +42,7 @@
 #include <asm/tlbflush.h>
 #include <asm/siginfo.h>
 #include <asm/debug.h>
+#include <asm/context_tracking.h>
 #include <mm/mmu_decl.h>
 
 #include "icswx.h"
@@ -193,8 +194,8 @@ static int mm_fault_error(struct pt_regs *regs, unsigned long addr, int fault)
  * The return value is 0 if the fault was handled, or the signal
  * number if this is a kernel fault that can't be handled here.
  */
-int __kprobes do_page_fault(struct pt_regs *regs, unsigned long address,
-			    unsigned long error_code)
+static int __kprobes __do_page_fault(struct pt_regs *regs,
+				unsigned long address, unsigned long error_code)
 {
 	struct vm_area_struct * vma;
 	struct mm_struct *mm = current->mm;
@@ -475,6 +476,16 @@ bad_area_nosemaphore:
 
 }
 
+int __kprobes do_page_fault(struct pt_regs *regs, unsigned long address,
+			    unsigned long error_code)
+{
+	int ret;
+	exception_enter(regs);
+	ret = __do_page_fault(regs, address, error_code);
+	exception_exit(regs);
+	return ret;
+}
+
 /*
  * bad_page_fault is called when we have a bad access from the kernel.
  * It is called from the DSI and ISI handlers in head.S and from some
diff --git a/arch/powerpc/mm/hash_utils_64.c b/arch/powerpc/mm/hash_utils_64.c
index 1b6e127..360fba8 100644
--- a/arch/powerpc/mm/hash_utils_64.c
+++ b/arch/powerpc/mm/hash_utils_64.c
@@ -56,6 +56,7 @@
 #include <asm/fadump.h>
 #include <asm/firmware.h>
 #include <asm/tm.h>
+#include <asm/context_tracking.h>
 
 #ifdef DEBUG
 #define DBG(fmt...) udbg_printf(fmt)
@@ -1084,6 +1085,18 @@ int hash_page(unsigned long ea, unsigned long access, unsigned long trap)
 }
 EXPORT_SYMBOL_GPL(hash_page);
 
+int hash_page_ct(unsigned long ea, unsigned long access,
+		 unsigned long trap, struct pt_regs *regs)
+{
+	int ret;
+
+	exception_enter(regs);
+	ret = hash_page(ea, access, trap);
+	exception_exit(regs);
+
+	return ret;
+}
+
 void hash_preload(struct mm_struct *mm, unsigned long ea,
 		  unsigned long access, unsigned long trap)
 {
@@ -1210,6 +1223,8 @@ void flush_hash_range(unsigned long number, int local)
  */
 void low_hash_fault(struct pt_regs *regs, unsigned long address, int rc)
 {
+	exception_enter(regs);
+
 	if (user_mode(regs)) {
 #ifdef CONFIG_PPC_SUBPAGE_PROT
 		if (rc == -2)
@@ -1219,6 +1234,8 @@ void low_hash_fault(struct pt_regs *regs, unsigned long address, int rc)
 			_exception(SIGBUS, regs, BUS_ADRERR, address);
 	} else
 		bad_page_fault(regs, address, SIGBUS);
+
+	exception_exit(regs);
 }
 
 #ifdef CONFIG_DEBUG_PAGEALLOC
-- 
1.7.9.5

