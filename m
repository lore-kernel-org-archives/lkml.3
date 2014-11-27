Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751413AbaK0Okr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 09:40:47 -0500
Received: from mga01.intel.com ([192.55.52.88]:2166 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751120AbaK0Okp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 09:40:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="422303750"
From: Emmanuel Berthier <emmanuel.berthier@intel.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org
Cc: robert.jarzmik@intel.com, emmanuel.berthier@intel.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] [LBR] Dump LBRs on Exception
Date: Thu, 27 Nov 2014 15:40:05 +0100
Message-Id: <1417099205-13309-1-git-send-email-emmanuel.berthier@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <65CD3FC07F3BF942ABE211646D72D770356EACA5@IRSMSX110.ger.corp.intel.com>
References: <65CD3FC07F3BF942ABE211646D72D770356EACA5@IRSMSX110.ger.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are some cases where call stack and register dump are not enough to debug
a Panic.
Let's take the case of a stack corruption:

 static int corrupt_stack(void *data, u64 val)
 {
 long long ptr[1];

	asm ("");
	ptr[0]=0;
	ptr[1]=0;
	ptr[2]=0;
	ptr[3]=0;

	return -1;
 }

The standard Panic will report:

 BUG: unable to handle kernel NULL pointer dereference at           (null)
 IP: [<          (null)>]           (null)
 PGD 48605067 PUD 0
 Oops: 0010 [#1] PREEMPT SMP
 task: ffff8800384f6300 ti: ffff880035c70000 task.ti: ffff880035c70000
 RIP: 0010:[<0000000000000000>]  [<          (null)>]           (null)
 RSP: 0018:ffff880035c71ec8  EFLAGS: 00010246
 RAX: 00000000ffffffff RBX: fffffffffffffff2 RCX: 000000000000002a
 RDX: ffff880035c71e90 RSI: 0000000000000001 RDI: 0000000000000000
 RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000000000001
 R10: 000000000000000a R11: f000000000000000 R12: ffff880033be0e50
 R13: 0000000000000002 R14: 0000000000000002 R15: ffff880033be0e00
 FS:  0000000000000000(0000) GS:ffff88007ea80000(0063) knlGS:00000000f76cd280
 CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
 CR2: 0000000000000000 CR3: 000000003871b000 CR4: 00000000001007e0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
 Stack:
  0000000000000000 00000000f802bb54 ffff880075e85680 0000000000000002
  00000000f802bb54 ffff880035c71f50 0000000000000000 ffff880035c71f38
  ffffffff821b8266 ffff880075e85680 00000000f802bb54 0000000000000002
 Call Trace:
  [<ffffffff821b8266>] ? vfs_write+0xb6/0x1c0
  [<ffffffff821b86fd>] ? SyS_write+0x4d/0x90
  [<ffffffff82817c65>] ? sysenter_dispatch+0x7/0x23
 Code:  Bad RIP value.
 RIP  [<          (null)>]           (null)
  RSP <ffff880035c71ec8>
 CR2: 0000000000000000

The purpose of this patch is to use the LBR as a small instruction trace.
The result will be:

 Last Branch Records:
  _to: [<ffffffff82810980>] page_fault+0x0/0x70
 from: [<0000000000000000>] 0x0
  _to: [<0000000000000000>] 0x0
 from: [<ffffffff8263693c>] corrupt_stack+0x3c/0x40
  _to: [<ffffffff82636900>] corrupt_stack+0x0/0x40
 from: [<ffffffff821dde6a>] simple_attr_write+0xca/0xf0
  _to: [<ffffffff821dde63>] simple_attr_write+0xc3/0xf0
 from: [<ffffffff8235387f>] simple_strtoll+0xf/0x20
  _to: [<ffffffff8235387e>] simple_strtoll+0xe/0x20
 from: [<ffffffff82351d5b>] simple_strtoull+0x4b/0x50
  _to: [<ffffffff82351d4e>] simple_strtoull+0x3e/0x50
 from: [<ffffffff82351d48>] simple_strtoull+0x38/0x50
  _to: [<ffffffff82351d3d>] simple_strtoull+0x2d/0x50
 from: [<ffffffff8235b4cb>] _parse_integer+0x9b/0xc0
  _to: [<ffffffff8235b4b0>] _parse_integer+0x80/0xc0
 from: [<ffffffff8235b497>] _parse_integer+0x67/0xc0

Signed-off-by: Emmanuel Berthier <emmanuel.berthier@intel.com>
---
since v1: took into account Thomas's comments.
          for next round for review.
---
 arch/x86/Kconfig.debug                     |   11 ++++++
 arch/x86/include/asm/processor.h           |    1 +
 arch/x86/kernel/cpu/perf_event.h           |    2 ++
 arch/x86/kernel/cpu/perf_event_intel_lbr.c |   41 ++++++++++++++++++++--
 arch/x86/kernel/dumpstack_64.c             |   52 ++++++++++++++++++++++++++--
 arch/x86/kernel/entry_64.S                 |   44 +++++++++++++++++++++++
 6 files changed, 147 insertions(+), 4 deletions(-)

diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index 61bd2ad..a571d40 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -323,4 +323,15 @@ config X86_DEBUG_STATIC_CPU_HAS
 
 	  If unsure, say N.
 
+config LBR_DUMP_ON_EXCEPTION
+	bool "Dump Last Branch Records on Exception"
+	depends on DEBUG_KERNEL && X86_64
+	---help---
+	  Enabling this option turns on LBR dump during exception.
+	  This provides a small "last instructions before exception" trace.
+
+	  Add 'lbr_dump_on_exception' option in cmdline to really enable it.
+
+	  This might help diagnose exceptions generated by stack corruption.
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
index 45fa730..0a69365 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
@@ -4,7 +4,7 @@
 #include <asm/perf_event.h>
 #include <asm/msr.h>
 #include <asm/insn.h>
-
+#include <asm/processor.h>
 #include "perf_event.h"
 
 enum {
@@ -130,11 +130,46 @@ static void intel_pmu_lbr_filter(struct cpu_hw_events *cpuc);
  * otherwise it becomes near impossible to get a reliable stack.
  */
 
+#ifdef CONFIG_LBR_DUMP_ON_EXCEPTION
+/*
+ * LBR usage is exclusive, so need to disable "LBR Dump on exception" feature
+ * when Perf is using it
+ */
+unsigned int lbr_dump_on_exception;
+static bool lbr_used_by_perf;
+static bool lbr_dump_enabled_by_cmdline;
+
+static inline void lbr_update_dump_on_exception(void)
+{
+	lbr_dump_on_exception = !lbr_used_by_perf &&
+				lbr_dump_enabled_by_cmdline;
+}
+
+static int __init lbr_dump_on_exception_setup(char *str)
+{
+	lbr_dump_enabled_by_cmdline = true;
+	lbr_update_dump_on_exception();
+
+	return 0;
+}
+early_param("lbr_dump_on_exception", lbr_dump_on_exception_setup);
+#endif
+
+static inline void lbr_set_used_by_perf(bool used)
+{
+#ifdef CONFIG_LBR_DUMP_ON_EXCEPTION
+	lbr_used_by_perf = used;
+	lbr_update_dump_on_exception();
+#endif
+}
+
 static void __intel_pmu_lbr_enable(void)
 {
 	u64 debugctl;
 	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 
+	lbr_set_used_by_perf(true);
+
 	if (cpuc->lbr_sel)
 		wrmsrl(MSR_LBR_SELECT, cpuc->lbr_sel->config);
 
@@ -147,6 +182,8 @@ static void __intel_pmu_lbr_disable(void)
 {
 	u64 debugctl;
 
+	lbr_set_used_by_perf(false);
+
 	rdmsrl(MSR_IA32_DEBUGCTLMSR, debugctl);
 	debugctl &= ~(DEBUGCTLMSR_LBR | DEBUGCTLMSR_FREEZE_LBRS_ON_PMI);
 	wrmsrl(MSR_IA32_DEBUGCTLMSR, debugctl);
@@ -278,7 +315,7 @@ static void intel_pmu_lbr_read_32(struct cpu_hw_events *cpuc)
  * is the same as the linear address, allowing us to merge the LIP and EIP
  * LBR formats.
  */
-static void intel_pmu_lbr_read_64(struct cpu_hw_events *cpuc)
+void intel_pmu_lbr_read_64(struct cpu_hw_events *cpuc)
 {
 	unsigned long mask = x86_pmu.lbr_nr - 1;
 	int lbr_format = x86_pmu.intel_cap.lbr_format;
diff --git a/arch/x86/kernel/dumpstack_64.c b/arch/x86/kernel/dumpstack_64.c
index 1abcb50..9ff358b 100644
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
@@ -295,6 +298,46 @@ show_stack_log_lvl(struct task_struct *task, struct pt_regs *regs,
 	show_trace_log_lvl(task, regs, sp, bp, log_lvl);
 }
 
+void show_lbrs(void)
+{
+#ifdef CONFIG_LBR_DUMP_ON_EXCEPTION
+	u64 debugctl;
+	int i, lbr_on;
+
+	rdmsrl(MSR_IA32_DEBUGCTLMSR, debugctl);
+	lbr_on = debugctl & DEBUGCTLMSR_LBR;
+
+	pr_info("Last Branch Records:");
+	if (!lbr_dump_on_exception) {
+		/*
+		 * Not enabled in cmdline
+		 * or used by Perf (Usage is exclusive)
+		 */
+		pr_cont(" (disabled)\n");
+	} else if (x86_pmu.lbr_nr == 0) {
+		/* new core: need to declare it in intel_pmu_init() */
+		pr_cont(" (x86_model unknown)\n");
+	} else if (lbr_on) {
+		/* LBR is irrelevant in case of simple Panic */
+		pr_cont(" (no exception)\n");
+	} else {
+		struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
+
+		intel_pmu_lbr_read_64(cpuc);
+
+		pr_cont("\n");
+		for (i = 0; i < cpuc->lbr_stack.nr; i++) {
+			pr_info("   to: [<%016llx>] ",
+				cpuc->lbr_entries[i].to);
+			print_symbol("%s\n", cpuc->lbr_entries[i].to);
+			pr_info(" from: [<%016llx>] ",
+				cpuc->lbr_entries[i].from);
+			print_symbol("%s\n", cpuc->lbr_entries[i].from);
+		}
+	}
+#endif
+}
+
 void show_regs(struct pt_regs *regs)
 {
 	int i;
@@ -314,10 +357,15 @@ void show_regs(struct pt_regs *regs)
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
index df088bb..f39cded 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1035,6 +1035,46 @@ apicinterrupt IRQ_WORK_VECTOR \
 	irq_work_interrupt smp_irq_work_interrupt
 #endif
 
+.macro STOP_LBR
+#ifdef CONFIG_LBR_DUMP_ON_EXCEPTION
+	testl $3,CS+8(%rsp)		/* Kernel Space? */
+	jz 1f
+	testl $1, lbr_dump_on_exception
+	jz 1f
+	push %rax
+	push %rcx
+	push %rdx
+	movl $MSR_IA32_DEBUGCTLMSR, %ecx
+	rdmsr
+	and $~1, %eax			/* Disable LBR recording */
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
+	testl $3,CS+8(%rsp)		/* Kernel Space? */
+	jz 1f
+	testl $1, lbr_dump_on_exception
+	jz 1f
+	push %rax
+	push %rcx
+	push %rdx
+	movl $MSR_IA32_DEBUGCTLMSR, %ecx
+	rdmsr
+	or $1, %eax			/* Enable LBR recording */
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
@@ -1063,6 +1103,8 @@ ENTRY(\sym)
 	subq $ORIG_RAX-R15, %rsp
 	CFI_ADJUST_CFA_OFFSET ORIG_RAX-R15
 
+	STOP_LBR
+
 	.if \paranoid
 	call save_paranoid
 	.else
@@ -1094,6 +1136,8 @@ ENTRY(\sym)
 
 	call \do_sym
 
+	START_LBR
+
 	.if \shift_ist != -1
 	addq $EXCEPTION_STKSZ, INIT_TSS_IST(\shift_ist)
 	.endif
-- 
1.7.9.5

