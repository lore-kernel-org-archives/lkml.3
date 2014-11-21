Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932728AbaKUREw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 12:04:52 -0500
Received: from mga14.intel.com ([192.55.52.115]:8202 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932501AbaKUREu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 12:04:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="419873639"
From: Emmanuel Berthier <emmanuel.berthier@intel.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org
Cc: robert.jarzmik@intel.com, emmanuel.berthier@intel.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] [LBR] Dump LBRs on Oops
Date: Fri, 21 Nov 2014 18:03:39 +0100
Message-Id: <1416589419-9952-1-git-send-email-emmanuel.berthier@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The purpose of this patch is to stop LBR at the early stage of
Exception Handling, and dump its content later in the dumpstack
process.
Only for X86_64 yet.

Signed-off-by: Emmanuel Berthier <emmanuel.berthier@intel.com>
---
 arch/x86/Kconfig.debug                     |    9 ++++++
 arch/x86/include/asm/processor.h           |    1 +
 arch/x86/kernel/cpu/common.c               |    4 +++
 arch/x86/kernel/cpu/perf_event.h           |    2 ++
 arch/x86/kernel/cpu/perf_event_intel_lbr.c |   12 +++++--
 arch/x86/kernel/dumpstack_64.c             |   47 ++++++++++++++++++++++++++--
 arch/x86/kernel/entry_64.S                 |   40 +++++++++++++++++++++++
 7 files changed, 111 insertions(+), 4 deletions(-)

diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index 61bd2ad..7a998b2 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -323,4 +323,13 @@ config X86_DEBUG_STATIC_CPU_HAS
 
 	  If unsure, say N.
 
+config LBR_DUMP_ON_EXCEPTION
+	bool "Dump Last Branch Records on Oops"
+	depends on DEBUG_KERNEL && X86_64
+	---help---
+	  Enabling this option turns on LBR recording and dump during Oops.
+
+	  This might help diagnose exceptions where faulting code
+	  is not easy to determine from the call stack.
+
 endmenu
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index eb71ec7..0c3ed67 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -462,6 +462,7 @@ DECLARE_PER_CPU(struct irq_stack *, softirq_stack);
 extern unsigned int xstate_size;
 extern void free_thread_xstate(struct task_struct *);
 extern struct kmem_cache *task_xstate_cachep;
+extern unsigned int lbr_dump_on_exception;
 
 struct perf_event;
 
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 4b4f78c..f49a26c 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1238,6 +1238,10 @@ DEFINE_PER_CPU_ALIGNED(struct stack_canary, stack_canary);
 
 #endif	/* CONFIG_X86_64 */
 
+#ifdef CONFIG_LBR_DUMP_ON_EXCEPTION
+unsigned int lbr_dump_on_exception = 1;
+#endif
+
 /*
  * Clear all 6 debug registers:
  */
diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index fc5eb39..ed9de7f 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -731,6 +731,8 @@ void intel_pmu_lbr_enable_all(void);
 
 void intel_pmu_lbr_disable_all(void);
 
+void intel_pmu_lbr_read_64(struct cpu_hw_events *cpuc);
+
 void intel_pmu_lbr_read(void);
 
 void intel_pmu_lbr_init_core(void);
diff --git a/arch/x86/kernel/cpu/perf_event_intel_lbr.c b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
index 45fa730..baa840c 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
@@ -4,7 +4,9 @@
 #include <asm/perf_event.h>
 #include <asm/msr.h>
 #include <asm/insn.h>
-
+#ifdef CONFIG_LBR_DUMP_ON_EXCEPTION
+#include <asm/processor.h>
+#endif
 #include "perf_event.h"
 
 enum {
@@ -135,6 +137,9 @@ static void __intel_pmu_lbr_enable(void)
 	u64 debugctl;
 	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 
+	if (IS_ENABLED(CONFIG_LBR_DUMP_ON_EXCEPTION))
+		lbr_dump_on_exception = 0;
+
 	if (cpuc->lbr_sel)
 		wrmsrl(MSR_LBR_SELECT, cpuc->lbr_sel->config);
 
@@ -147,6 +152,9 @@ static void __intel_pmu_lbr_disable(void)
 {
 	u64 debugctl;
 
+	if (IS_ENABLED(CONFIG_LBR_DUMP_ON_EXCEPTION))
+		lbr_dump_on_exception = 1;
+
 	rdmsrl(MSR_IA32_DEBUGCTLMSR, debugctl);
 	debugctl &= ~(DEBUGCTLMSR_LBR | DEBUGCTLMSR_FREEZE_LBRS_ON_PMI);
 	wrmsrl(MSR_IA32_DEBUGCTLMSR, debugctl);
@@ -278,7 +286,7 @@ static void intel_pmu_lbr_read_32(struct cpu_hw_events *cpuc)
  * is the same as the linear address, allowing us to merge the LIP and EIP
  * LBR formats.
  */
-static void intel_pmu_lbr_read_64(struct cpu_hw_events *cpuc)
+void intel_pmu_lbr_read_64(struct cpu_hw_events *cpuc)
 {
 	unsigned long mask = x86_pmu.lbr_nr - 1;
 	int lbr_format = x86_pmu.intel_cap.lbr_format;
diff --git a/arch/x86/kernel/dumpstack_64.c b/arch/x86/kernel/dumpstack_64.c
index 1abcb50..fd78477 100644
--- a/arch/x86/kernel/dumpstack_64.c
+++ b/arch/x86/kernel/dumpstack_64.c
@@ -15,7 +15,10 @@
 #include <linux/nmi.h>
 
 #include <asm/stacktrace.h>
-
+#ifdef CONFIG_LBR_DUMP_ON_EXCEPTION
+#include <asm/processor.h>
+#include "cpu/perf_event.h"
+#endif
 
 #define N_EXCEPTION_STACKS_END \
 		(N_EXCEPTION_STACKS + DEBUG_STKSZ/EXCEPTION_STKSZ - 2)
@@ -295,6 +298,41 @@ show_stack_log_lvl(struct task_struct *task, struct pt_regs *regs,
 	show_trace_log_lvl(task, regs, sp, bp, log_lvl);
 }
 
+void show_lbrs(void)
+{
+	if (IS_ENABLED(CONFIG_LBR_DUMP_ON_EXCEPTION)) {
+		u64 debugctl;
+		int i, lbr_on;
+
+		rdmsrl(MSR_IA32_DEBUGCTLMSR, debugctl);
+		lbr_on = debugctl & DEBUGCTLMSR_LBR;
+
+		pr_info("Last Branch Records:");
+		if (!lbr_dump_on_exception) {
+			pr_cont(" (Disabled by perf_event)\n");
+		} else if (x86_pmu.lbr_nr == 0) {
+			pr_cont(" (x86_model unknown, check intel_pmu_init())\n");
+		} else if (lbr_on) {
+			pr_cont(" (not halted)\n");
+		} else {
+			struct cpu_hw_events *cpuc =
+						this_cpu_ptr(&cpu_hw_events);
+
+			intel_pmu_lbr_read_64(cpuc);
+
+			pr_cont("\n");
+			for (i = 0; i < cpuc->lbr_stack.nr; i++) {
+				pr_info("   to: [<%016llx>] ",
+						cpuc->lbr_entries[i].to);
+				print_symbol("%s\n", cpuc->lbr_entries[i].to);
+				pr_info(" from: [<%016llx>] ",
+						cpuc->lbr_entries[i].from);
+				print_symbol("%s\n", cpuc->lbr_entries[i].from);
+			}
+		}
+	}
+}
+
 void show_regs(struct pt_regs *regs)
 {
 	int i;
@@ -314,10 +352,15 @@ void show_regs(struct pt_regs *regs)
 		unsigned char c;
 		u8 *ip;
 
+		/*
+		 * Called before show_stack_log_lvl() as it could trig
+		 * page_fault and reenable LBR
+		 */
+		show_lbrs();
+
 		printk(KERN_DEFAULT "Stack:\n");
 		show_stack_log_lvl(NULL, regs, (unsigned long *)sp,
 				   0, KERN_DEFAULT);
-
 		printk(KERN_DEFAULT "Code: ");
 
 		ip = (u8 *)regs->ip - code_prologue;
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index df088bb..120e989 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1035,6 +1035,42 @@ apicinterrupt IRQ_WORK_VECTOR \
 	irq_work_interrupt smp_irq_work_interrupt
 #endif
 
+.macro STOP_LBR
+#ifdef CONFIG_LBR_DUMP_ON_EXCEPTION
+	testl $1, lbr_dump_on_exception
+	jz 1f
+	push %rax
+	push %rcx
+	push %rdx
+	movl $MSR_IA32_DEBUGCTLMSR, %ecx
+	rdmsr
+	and $~1, %eax	/* Disable LBR recording */
+	wrmsr
+	pop %rdx
+	pop %rcx
+	pop %rax
+1:
+#endif
+.endm
+
+.macro START_LBR
+#ifdef CONFIG_LBR_DUMP_ON_EXCEPTION
+	testl $1, lbr_dump_on_exception
+	jz 1f
+	push %rax
+	push %rcx
+	push %rdx
+	movl $MSR_IA32_DEBUGCTLMSR, %ecx
+	rdmsr
+	or $1, %eax		/* Enable LBR recording */
+	wrmsr
+	pop %rdx
+	pop %rcx
+	pop %rax
+1:
+#endif
+.endm
+
 /*
  * Exception entry points.
  */
@@ -1063,6 +1099,8 @@ ENTRY(\sym)
 	subq $ORIG_RAX-R15, %rsp
 	CFI_ADJUST_CFA_OFFSET ORIG_RAX-R15
 
+	STOP_LBR
+
 	.if \paranoid
 	call save_paranoid
 	.else
@@ -1094,6 +1132,8 @@ ENTRY(\sym)
 
 	call \do_sym
 
+	START_LBR
+
 	.if \shift_ist != -1
 	addq $EXCEPTION_STKSZ, INIT_TSS_IST(\shift_ist)
 	.endif
-- 
1.7.9.5

