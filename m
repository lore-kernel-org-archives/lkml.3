Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754253AbaJUIbA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 04:31:00 -0400
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:53536 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497AbaJUIah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 04:30:37 -0400
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@redhat.com>
Cc: Vojtech Pavlik <vojtech@suse.cz>, Jiri Kosina <jkosina@suse.cz>,
        Jiri Slaby <jslaby@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH v3 2/2] s390/ftrace,kprobes: allow to patch first instruction
Date: Tue, 21 Oct 2014 10:30:29 +0200
Message-Id: <1413880229-4796-3-git-send-email-heiko.carstens@de.ibm.com>
X-Mailer: git-send-email 1.8.5.5
In-Reply-To: <1413880229-4796-1-git-send-email-heiko.carstens@de.ibm.com>
References: <1413880229-4796-1-git-send-email-heiko.carstens@de.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102108-0005-0000-0000-000001BD770C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the function tracer is enabled, allow to set kprobes on the first
instruction of a function (which is the function trace caller):

If no kprobe is set handling of enabling and disabling function tracing
of a function simply patches the first instruction. Either it is a nop
(right now it's an unconditional branch, which skips the mcount block),
or it's a branch to the ftrace_caller() function.

If a kprobe is being placed on a function tracer calling instruction
we encode if we actually have a nop or branch in the remaining bytes
after the breakpoint instruction (illegal opcode).
This is possible, since the size of the instruction used for the nop
and branch is six bytes, while the size of the breakpoint is only
two bytes.
Therefore the first two bytes contain the illegal opcode and the last
four bytes contain either "0" for nop or "1" for branch. The kprobes
code will then execute/simulate the correct instruction.

Instruction patching for kprobes and function tracer is always done
with stop_machine(). Therefore we don't have any races where an
instruction is patches concurrently on a different cpu.
Besides that also the program check handler which executes the function
trace caller instruction won't be executed concurrently to any
stop_machine() execution.

This allows to keep full fault based kprobes handling which generates
correct correct pt_regs contents automatically.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 arch/s390/include/asm/ftrace.h  |  52 ++++++++++++++--
 arch/s390/include/asm/kprobes.h |   1 +
 arch/s390/include/asm/lowcore.h |   4 +-
 arch/s390/include/asm/pgtable.h |  12 ++++
 arch/s390/kernel/asm-offsets.c  |   1 -
 arch/s390/kernel/early.c        |   4 --
 arch/s390/kernel/ftrace.c       | 132 +++++++++++++++++++++++++---------------
 arch/s390/kernel/kprobes.c      |  92 ++++++++++++++++++++--------
 arch/s390/kernel/mcount.S       |   1 +
 arch/s390/kernel/setup.c        |   2 -
 arch/s390/kernel/smp.c          |   1 -
 scripts/recordmcount.c          |   2 +-
 scripts/recordmcount.pl         |   2 +-
 13 files changed, 214 insertions(+), 92 deletions(-)

diff --git a/arch/s390/include/asm/ftrace.h b/arch/s390/include/asm/ftrace.h
index 3aef8afec336..785041f1dc77 100644
--- a/arch/s390/include/asm/ftrace.h
+++ b/arch/s390/include/asm/ftrace.h
@@ -1,25 +1,67 @@
 #ifndef _ASM_S390_FTRACE_H
 #define _ASM_S390_FTRACE_H
 
+#define ARCH_SUPPORTS_FTRACE_OPS 1
+
+#define MCOUNT_INSN_SIZE	24
+#define MCOUNT_RETURN_FIXUP	18
+
 #ifndef __ASSEMBLY__
 
-extern void _mcount(void);
+void _mcount(void);
+void ftrace_caller(void);
+
 extern char ftrace_graph_caller_end;
+extern unsigned long ftrace_plt;
 
 struct dyn_arch_ftrace { };
 
-#define MCOUNT_ADDR ((long)_mcount)
+#define MCOUNT_ADDR ((unsigned long)_mcount)
+#define FTRACE_ADDR ((unsigned long)ftrace_caller)
 
+#define KPROBE_ON_FTRACE_NOP	0
+#define KPROBE_ON_FTRACE_CALL	1
 
 static inline unsigned long ftrace_call_adjust(unsigned long addr)
 {
 	return addr;
 }
 
-#endif /* __ASSEMBLY__ */
+struct ftrace_insn {
+	u16 opc;
+	s32 disp;
+} __packed;
 
-#define MCOUNT_INSN_SIZE  18
+static inline void ftrace_generate_nop_insn(struct ftrace_insn *insn)
+{
+#ifdef CONFIG_FUNCTION_TRACER
+	/* jg .+24 */
+	insn->opc = 0xc0f4;
+	insn->disp = MCOUNT_INSN_SIZE / 2;
+#endif
+}
 
-#define ARCH_SUPPORTS_FTRACE_OPS 1
+static inline int is_ftrace_nop(struct ftrace_insn *insn)
+{
+#ifdef CONFIG_FUNCTION_TRACER
+	if (insn->disp == MCOUNT_INSN_SIZE / 2)
+		return 1;
+#endif
+	return 0;
+}
+
+static inline void ftrace_generate_call_insn(struct ftrace_insn *insn,
+					     unsigned long ip)
+{
+#ifdef CONFIG_FUNCTION_TRACER
+	unsigned long target;
 
+	/* brasl r0,ftrace_caller */
+	target = is_module_addr((void *) ip) ? ftrace_plt : FTRACE_ADDR;
+	insn->opc = 0xc005;
+	insn->disp = (target - ip) / 2;
+#endif
+}
+
+#endif /* __ASSEMBLY__ */
 #endif /* _ASM_S390_FTRACE_H */
diff --git a/arch/s390/include/asm/kprobes.h b/arch/s390/include/asm/kprobes.h
index 98629173ce3b..b47ad3b642cc 100644
--- a/arch/s390/include/asm/kprobes.h
+++ b/arch/s390/include/asm/kprobes.h
@@ -60,6 +60,7 @@ typedef u16 kprobe_opcode_t;
 struct arch_specific_insn {
 	/* copy of original instruction */
 	kprobe_opcode_t *insn;
+	unsigned int is_ftrace_insn : 1;
 };
 
 struct prev_kprobe {
diff --git a/arch/s390/include/asm/lowcore.h b/arch/s390/include/asm/lowcore.h
index 6cc51fe84410..34fbcac61133 100644
--- a/arch/s390/include/asm/lowcore.h
+++ b/arch/s390/include/asm/lowcore.h
@@ -147,7 +147,7 @@ struct _lowcore {
 	__u32	softirq_pending;		/* 0x02ec */
 	__u32	percpu_offset;			/* 0x02f0 */
 	__u32	machine_flags;			/* 0x02f4 */
-	__u32	ftrace_func;			/* 0x02f8 */
+	__u8	pad_0x02f8[0x02fc-0x02f8];	/* 0x02f8 */
 	__u32	spinlock_lockval;		/* 0x02fc */
 
 	__u8	pad_0x0300[0x0e00-0x0300];	/* 0x0300 */
@@ -297,7 +297,7 @@ struct _lowcore {
 	__u64	percpu_offset;			/* 0x0378 */
 	__u64	vdso_per_cpu_data;		/* 0x0380 */
 	__u64	machine_flags;			/* 0x0388 */
-	__u64	ftrace_func;			/* 0x0390 */
+	__u8	pad_0x0390[0x0398-0x0390];	/* 0x0390 */
 	__u64	gmap;				/* 0x0398 */
 	__u32	spinlock_lockval;		/* 0x03a0 */
 	__u8	pad_0x03a0[0x0400-0x03a4];	/* 0x03a4 */
diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index 57c882761dea..e7c7f85a9160 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -133,6 +133,18 @@ extern unsigned long MODULES_END;
 #define MODULES_LEN	(1UL << 31)
 #endif
 
+static inline int is_module_addr(void *addr)
+{
+#ifdef CONFIG_64BIT
+	BUILD_BUG_ON(MODULES_LEN > (1UL << 31));
+	if (addr < (void *)MODULES_VADDR)
+		return 0;
+	if (addr > (void *)MODULES_END)
+		return 0;
+#endif
+	return 1;
+}
+
 /*
  * A 31 bit pagetable entry of S390 has following format:
  *  |   PFRA          |    |  OS  |
diff --git a/arch/s390/kernel/asm-offsets.c b/arch/s390/kernel/asm-offsets.c
index ef279a136801..f3a78337ca86 100644
--- a/arch/s390/kernel/asm-offsets.c
+++ b/arch/s390/kernel/asm-offsets.c
@@ -156,7 +156,6 @@ int main(void)
 	DEFINE(__LC_INT_CLOCK, offsetof(struct _lowcore, int_clock));
 	DEFINE(__LC_MCCK_CLOCK, offsetof(struct _lowcore, mcck_clock));
 	DEFINE(__LC_MACHINE_FLAGS, offsetof(struct _lowcore, machine_flags));
-	DEFINE(__LC_FTRACE_FUNC, offsetof(struct _lowcore, ftrace_func));
 	DEFINE(__LC_DUMP_REIPL, offsetof(struct _lowcore, ipib));
 	BLANK();
 	DEFINE(__LC_CPU_TIMER_SAVE_AREA, offsetof(struct _lowcore, cpu_timer_save_area));
diff --git a/arch/s390/kernel/early.c b/arch/s390/kernel/early.c
index cef2879edff3..302ac1f7f8e7 100644
--- a/arch/s390/kernel/early.c
+++ b/arch/s390/kernel/early.c
@@ -12,7 +12,6 @@
 #include <linux/errno.h>
 #include <linux/string.h>
 #include <linux/ctype.h>
-#include <linux/ftrace.h>
 #include <linux/lockdep.h>
 #include <linux/module.h>
 #include <linux/pfn.h>
@@ -490,8 +489,5 @@ void __init startup_init(void)
 	detect_machine_facilities();
 	setup_topology();
 	sclp_early_detect();
-#ifdef CONFIG_DYNAMIC_FTRACE
-	S390_lowcore.ftrace_func = (unsigned long)ftrace_caller;
-#endif
 	lockdep_on();
 }
diff --git a/arch/s390/kernel/ftrace.c b/arch/s390/kernel/ftrace.c
index 51d14fe5eb9a..5744d25c1d33 100644
--- a/arch/s390/kernel/ftrace.c
+++ b/arch/s390/kernel/ftrace.c
@@ -7,6 +7,7 @@
  *		Martin Schwidefsky <schwidefsky@de.ibm.com>
  */
 
+#include <linux/moduleloader.h>
 #include <linux/hardirq.h>
 #include <linux/uaccess.h>
 #include <linux/ftrace.h>
@@ -15,60 +16,39 @@
 #include <linux/kprobes.h>
 #include <trace/syscall.h>
 #include <asm/asm-offsets.h>
+#include <asm/cacheflush.h>
 #include "entry.h"
 
-void mcount_replace_code(void);
-void ftrace_disable_code(void);
-void ftrace_enable_insn(void);
-
 /*
  * The mcount code looks like this:
  *	stg	%r14,8(%r15)		# offset 0
  *	larl	%r1,<&counter>		# offset 6
  *	brasl	%r14,_mcount		# offset 12
  *	lg	%r14,8(%r15)		# offset 18
- * Total length is 24 bytes. The complete mcount block initially gets replaced
- * by ftrace_make_nop. Subsequent calls to ftrace_make_call / ftrace_make_nop
- * only patch the jg/lg instruction within the block.
- * Note: we do not patch the first instruction to an unconditional branch,
- * since that would break kprobes/jprobes. It is easier to leave the larl
- * instruction in and only modify the second instruction.
+ * Total length is 24 bytes. Only the first instruction will be patched
+ * by ftrace_make_call / ftrace_make_nop.
  * The enabled ftrace code block looks like this:
- *	larl	%r0,.+24		# offset 0
- * >	lg	%r1,__LC_FTRACE_FUNC	# offset 6
- *	br	%r1			# offset 12
- *	brcl	0,0			# offset 14
- *	brc	0,0			# offset 20
+ * >	brasl	%r0,ftrace_caller	# offset 0
+ *	larl	%r1,<&counter>		# offset 6
+ *	brasl	%r14,_mcount		# offset 12
+ *	lg	%r14,8(%r15)		# offset 18
  * The ftrace function gets called with a non-standard C function call ABI
  * where r0 contains the return address. It is also expected that the called
  * function only clobbers r0 and r1, but restores r2-r15.
+ * For module code we can't directly jump to ftrace caller, but need a
+ * trampoline (ftrace_plt), which clobbers also r1.
  * The return point of the ftrace function has offset 24, so execution
  * continues behind the mcount block.
- *	larl	%r0,.+24		# offset 0
- * >	jg	.+18			# offset 6
- *	br	%r1			# offset 12
- *	brcl	0,0			# offset 14
- *	brc	0,0			# offset 20
+ * The disabled ftrace code block looks like this:
+ * >	jg	.+24			# offset 0
+ *	larl	%r1,<&counter>		# offset 6
+ *	brasl	%r14,_mcount		# offset 12
+ *	lg	%r14,8(%r15)		# offset 18
  * The jg instruction branches to offset 24 to skip as many instructions
  * as possible.
  */
-asm(
-	"	.align	4\n"
-	"mcount_replace_code:\n"
-	"	larl	%r0,0f\n"
-	"ftrace_disable_code:\n"
-	"	jg	0f\n"
-	"	br	%r1\n"
-	"	brcl	0,0\n"
-	"	brc	0,0\n"
-	"0:\n"
-	"	.align	4\n"
-	"ftrace_enable_insn:\n"
-	"	lg	%r1,"__stringify(__LC_FTRACE_FUNC)"\n");
-
-#define MCOUNT_BLOCK_SIZE	24
-#define MCOUNT_INSN_OFFSET	6
-#define FTRACE_INSN_SIZE	6
+
+unsigned long ftrace_plt;
 
 int ftrace_modify_call(struct dyn_ftrace *rec, unsigned long old_addr,
 		       unsigned long addr)
@@ -79,24 +59,62 @@ int ftrace_modify_call(struct dyn_ftrace *rec, unsigned long old_addr,
 int ftrace_make_nop(struct module *mod, struct dyn_ftrace *rec,
 		    unsigned long addr)
 {
-	/* Initial replacement of the whole mcount block */
-	if (addr == MCOUNT_ADDR) {
-		if (probe_kernel_write((void *) rec->ip - MCOUNT_INSN_OFFSET,
-				       mcount_replace_code,
-				       MCOUNT_BLOCK_SIZE))
-			return -EPERM;
-		return 0;
+	struct ftrace_insn insn;
+	unsigned short op;
+	void *from, *to;
+	size_t size;
+
+	ftrace_generate_nop_insn(&insn);
+	size = sizeof(insn);
+	from = &insn;
+	to = (void *) rec->ip;
+	if (probe_kernel_read(&op, (void *) rec->ip, sizeof(op)))
+		return -EFAULT;
+	/*
+	 * If we find a breakpoint instruction, a kprobe has been placed
+	 * at the beginning of the function. We write the constant
+	 * KPROBE_ON_FTRACE_NOP into the remaining four bytes of the original
+	 * instruction so that the kprobes handler can execute a nop, if it
+	 * reaches this breakpoint.
+	 */
+	if (op == BREAKPOINT_INSTRUCTION) {
+		size -= 2;
+		from += 2;
+		to += 2;
+		insn.disp = KPROBE_ON_FTRACE_NOP;
 	}
-	if (probe_kernel_write((void *) rec->ip, ftrace_disable_code,
-			       MCOUNT_INSN_SIZE))
+	if (probe_kernel_write(to, from, size))
 		return -EPERM;
 	return 0;
 }
 
 int ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
 {
-	if (probe_kernel_write((void *) rec->ip, ftrace_enable_insn,
-			       FTRACE_INSN_SIZE))
+	struct ftrace_insn insn;
+	unsigned short op;
+	void *from, *to;
+	size_t size;
+
+	ftrace_generate_call_insn(&insn, rec->ip);
+	size = sizeof(insn);
+	from = &insn;
+	to = (void *) rec->ip;
+	if (probe_kernel_read(&op, (void *) rec->ip, sizeof(op)))
+		return -EFAULT;
+	/*
+	 * If we find a breakpoint instruction, a kprobe has been placed
+	 * at the beginning of the function. We write the constant
+	 * KPROBE_ON_FTRACE_CALL into the remaining four bytes of the original
+	 * instruction so that the kprobes handler can execute a brasl if it
+	 * reaches this breakpoint.
+	 */
+	if (op == BREAKPOINT_INSTRUCTION) {
+		size -= 2;
+		from += 2;
+		to += 2;
+		insn.disp = KPROBE_ON_FTRACE_CALL;
+	}
+	if (probe_kernel_write(to, from, size))
 		return -EPERM;
 	return 0;
 }
@@ -111,6 +129,24 @@ int __init ftrace_dyn_arch_init(void)
 	return 0;
 }
 
+static int __init ftrace_plt_init(void)
+{
+	unsigned int *ip;
+
+	ftrace_plt = (unsigned long) module_alloc(PAGE_SIZE);
+	if (!ftrace_plt)
+		panic("cannot allocate ftrace plt\n");
+	ip = (unsigned int *) ftrace_plt;
+	ip[0] = 0x0d10e310; /* basr 1,0; lg 1,10(1); br 1 */
+	ip[1] = 0x100a0004;
+	ip[2] = 0x07f10000;
+	ip[3] = FTRACE_ADDR >> 32;
+	ip[4] = FTRACE_ADDR & 0xffffffff;
+	set_memory_ro(ftrace_plt, 1);
+	return 0;
+}
+device_initcall(ftrace_plt_init);
+
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 /*
  * Hook the return address and push it in the stack of return addresses
diff --git a/arch/s390/kernel/kprobes.c b/arch/s390/kernel/kprobes.c
index 014d4729b134..d6716c29b7f8 100644
--- a/arch/s390/kernel/kprobes.c
+++ b/arch/s390/kernel/kprobes.c
@@ -29,6 +29,7 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/hardirq.h>
+#include <linux/ftrace.h>
 #include <asm/cacheflush.h>
 #include <asm/sections.h>
 #include <asm/dis.h>
@@ -60,10 +61,21 @@ struct kprobe_insn_cache kprobe_dmainsn_slots = {
 
 static void __kprobes copy_instruction(struct kprobe *p)
 {
+	unsigned long ip = (unsigned long) p->addr;
 	s64 disp, new_disp;
 	u64 addr, new_addr;
 
-	memcpy(p->ainsn.insn, p->addr, insn_length(p->opcode >> 8));
+	if (ftrace_location(ip) == ip) {
+		/*
+		 * If kprobes patches the instruction that is morphed by
+		 * ftrace make sure that kprobes always sees the branch
+		 * "jg .+24" that skips the mcount block
+		 */
+		ftrace_generate_nop_insn((struct ftrace_insn *)p->ainsn.insn);
+		p->ainsn.is_ftrace_insn = 1;
+	} else
+		memcpy(p->ainsn.insn, p->addr, insn_length(p->opcode >> 8));
+	p->opcode = p->ainsn.insn[0];
 	if (!probe_is_insn_relative_long(p->ainsn.insn))
 		return;
 	/*
@@ -85,18 +97,6 @@ static inline int is_kernel_addr(void *addr)
 	return addr < (void *)_end;
 }
 
-static inline int is_module_addr(void *addr)
-{
-#ifdef CONFIG_64BIT
-	BUILD_BUG_ON(MODULES_LEN > (1UL << 31));
-	if (addr < (void *)MODULES_VADDR)
-		return 0;
-	if (addr > (void *)MODULES_END)
-		return 0;
-#endif
-	return 1;
-}
-
 static int __kprobes s390_get_insn_slot(struct kprobe *p)
 {
 	/*
@@ -132,43 +132,63 @@ int __kprobes arch_prepare_kprobe(struct kprobe *p)
 		return -EINVAL;
 	if (s390_get_insn_slot(p))
 		return -ENOMEM;
-	p->opcode = *p->addr;
 	copy_instruction(p);
 	return 0;
 }
 
-struct ins_replace_args {
-	kprobe_opcode_t *ptr;
-	kprobe_opcode_t opcode;
+int arch_check_ftrace_location(struct kprobe *p)
+{
+	return 0;
+}
+
+struct swap_insn_args {
+	struct kprobe *p;
+	unsigned int arm_kprobe : 1;
 };
 
-static int __kprobes swap_instruction(void *aref)
+static int __kprobes swap_instruction(void *data)
 {
 	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
 	unsigned long status = kcb->kprobe_status;
-	struct ins_replace_args *args = aref;
-
+	struct swap_insn_args *args = data;
+	struct ftrace_insn new_insn, *insn;
+	struct kprobe *p = args->p;
+	size_t len;
+
+	new_insn.opc = args->arm_kprobe ? BREAKPOINT_INSTRUCTION : p->opcode;
+	len = sizeof(new_insn.opc);
+	if (!p->ainsn.is_ftrace_insn)
+		goto skip_ftrace;
+	len = sizeof(new_insn);
+	insn = (struct ftrace_insn *) p->addr;
+	if (args->arm_kprobe) {
+		if (is_ftrace_nop(insn))
+			new_insn.disp = KPROBE_ON_FTRACE_NOP;
+		else
+			new_insn.disp = KPROBE_ON_FTRACE_CALL;
+	} else {
+		ftrace_generate_call_insn(&new_insn, (unsigned long)p->addr);
+		if (insn->disp == KPROBE_ON_FTRACE_NOP)
+			ftrace_generate_nop_insn(&new_insn);
+	}
+skip_ftrace:
 	kcb->kprobe_status = KPROBE_SWAP_INST;
-	probe_kernel_write(args->ptr, &args->opcode, sizeof(args->opcode));
+	probe_kernel_write(p->addr, &new_insn, len);
 	kcb->kprobe_status = status;
 	return 0;
 }
 
 void __kprobes arch_arm_kprobe(struct kprobe *p)
 {
-	struct ins_replace_args args;
+	struct swap_insn_args args = {.p = p, .arm_kprobe = 1};
 
-	args.ptr = p->addr;
-	args.opcode = BREAKPOINT_INSTRUCTION;
 	stop_machine(swap_instruction, &args, NULL);
 }
 
 void __kprobes arch_disarm_kprobe(struct kprobe *p)
 {
-	struct ins_replace_args args;
+	struct swap_insn_args args = {.p = p, .arm_kprobe = 0};
 
-	args.ptr = p->addr;
-	args.opcode = p->opcode;
 	stop_machine(swap_instruction, &args, NULL);
 }
 
@@ -459,6 +479,24 @@ static void __kprobes resume_execution(struct kprobe *p, struct pt_regs *regs)
 	unsigned long ip = regs->psw.addr & PSW_ADDR_INSN;
 	int fixup = probe_get_fixup_type(p->ainsn.insn);
 
+	/* Check if the kprobes location is an enabled ftrace caller */
+	if (p->ainsn.is_ftrace_insn) {
+		struct ftrace_insn *insn = (struct ftrace_insn *) p->addr;
+		struct ftrace_insn call_insn;
+
+		ftrace_generate_call_insn(&call_insn, (unsigned long) p->addr);
+		/*
+		 * A kprobe on an enabled ftrace call site actually single
+		 * stepped an unconditional branch (ftrace nop equivalent).
+		 * Now we need to fixup things and pretend that a brasl r0,...
+		 * was executed instead.
+		 */
+		if (insn->disp == KPROBE_ON_FTRACE_CALL) {
+			ip += call_insn.disp * 2 - MCOUNT_INSN_SIZE;
+			regs->gprs[0] = (unsigned long)p->addr + sizeof(*insn);
+		}
+	}
+
 	if (fixup & FIXUP_PSW_NORMAL)
 		ip += (unsigned long) p->addr - (unsigned long) p->ainsn.insn;
 
diff --git a/arch/s390/kernel/mcount.S b/arch/s390/kernel/mcount.S
index 4300ea374826..b6dfc5bfcb89 100644
--- a/arch/s390/kernel/mcount.S
+++ b/arch/s390/kernel/mcount.S
@@ -27,6 +27,7 @@ ENTRY(ftrace_caller)
 	.globl	ftrace_regs_caller
 	.set	ftrace_regs_caller,ftrace_caller
 	lgr	%r1,%r15
+	aghi	%r0,MCOUNT_RETURN_FIXUP
 	aghi	%r15,-STACK_FRAME_SIZE
 	stg	%r1,__SF_BACKCHAIN(%r15)
 	stg	%r1,(STACK_PTREGS_GPRS+15*8)(%r15)
diff --git a/arch/s390/kernel/setup.c b/arch/s390/kernel/setup.c
index e80d9ff9a56d..4e532c67832f 100644
--- a/arch/s390/kernel/setup.c
+++ b/arch/s390/kernel/setup.c
@@ -41,7 +41,6 @@
 #include <linux/ctype.h>
 #include <linux/reboot.h>
 #include <linux/topology.h>
-#include <linux/ftrace.h>
 #include <linux/kexec.h>
 #include <linux/crash_dump.h>
 #include <linux/memory.h>
@@ -356,7 +355,6 @@ static void __init setup_lowcore(void)
 	lc->steal_timer = S390_lowcore.steal_timer;
 	lc->last_update_timer = S390_lowcore.last_update_timer;
 	lc->last_update_clock = S390_lowcore.last_update_clock;
-	lc->ftrace_func = S390_lowcore.ftrace_func;
 
 	restart_stack = __alloc_bootmem(ASYNC_SIZE, ASYNC_SIZE, 0);
 	restart_stack += ASYNC_SIZE;
diff --git a/arch/s390/kernel/smp.c b/arch/s390/kernel/smp.c
index 6fd9e60101f1..0b499f5cbe19 100644
--- a/arch/s390/kernel/smp.c
+++ b/arch/s390/kernel/smp.c
@@ -236,7 +236,6 @@ static void pcpu_prepare_secondary(struct pcpu *pcpu, int cpu)
 	lc->percpu_offset = __per_cpu_offset[cpu];
 	lc->kernel_asce = S390_lowcore.kernel_asce;
 	lc->machine_flags = S390_lowcore.machine_flags;
-	lc->ftrace_func = S390_lowcore.ftrace_func;
 	lc->user_timer = lc->system_timer = lc->steal_timer = 0;
 	__ctl_store(lc->cregs_save_area, 0, 15);
 	save_access_regs((unsigned int *) lc->access_regs_save_area);
diff --git a/scripts/recordmcount.c b/scripts/recordmcount.c
index 001facfa5b74..3d1984e59a30 100644
--- a/scripts/recordmcount.c
+++ b/scripts/recordmcount.c
@@ -404,7 +404,7 @@ do_file(char const *const fname)
 		}
 		if (w2(ghdr->e_machine) == EM_S390) {
 			reltype = R_390_64;
-			mcount_adjust_64 = -8;
+			mcount_adjust_64 = -14;
 		}
 		if (w2(ghdr->e_machine) == EM_MIPS) {
 			reltype = R_MIPS_64;
diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index d4b665610d67..56ea99a12ab7 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -243,7 +243,7 @@ if ($arch eq "x86_64") {
 
 } elsif ($arch eq "s390" && $bits == 64) {
     $mcount_regex = "^\\s*([0-9a-fA-F]+):\\s*R_390_(PC|PLT)32DBL\\s+_mcount\\+0x2\$";
-    $mcount_adjust = -8;
+    $mcount_adjust = -14;
     $alignment = 8;
     $type = ".quad";
     $ld .= " -m elf64_s390";
-- 
1.8.5.5

