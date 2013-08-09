Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030832Ab3HITfa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 15:35:30 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:55376 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030224Ab3HITf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 15:35:28 -0400
Message-ID: <2c9c68a646dd67eb51d89d878966c08941efa055.1376076465.git.cmetcalf@tilera.com>
From: Tony Lu <zlu@tilera.com>
Date: Fri, 9 Aug 2013 13:26:09 -0400
Subject: [PATCH] tile: support ftrace on tilegx
To: <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit adds support for static ftrace, graph function support,
and dynamic tracer support.

Signed-off-by: Tony Lu <zlu@tilera.com>
Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
I assume it makes sense for this to be pushed via the tile tree;
it's currently queued in tile-next.

 arch/tile/Kconfig              |   7 +-
 arch/tile/include/asm/ftrace.h |  22 +++-
 arch/tile/kernel/Makefile      |   6 +
 arch/tile/kernel/ftrace.c      | 246 +++++++++++++++++++++++++++++++++++++++++
 arch/tile/kernel/mcount_64.S   | 224 +++++++++++++++++++++++++++++++++++++
 arch/tile/kernel/vmlinux.lds.S |   1 +
 arch/tile/lib/exports.c        |   6 +
 scripts/recordmcount.pl        |   4 +
 8 files changed, 514 insertions(+), 2 deletions(-)
 create mode 100644 arch/tile/kernel/ftrace.c
 create mode 100644 arch/tile/kernel/mcount_64.S

diff --git a/arch/tile/Kconfig b/arch/tile/Kconfig
index e76180e..e1600be 100644
--- a/arch/tile/Kconfig
+++ b/arch/tile/Kconfig
@@ -119,7 +119,12 @@ config HVC_TILE
 	def_bool y
 
 config TILEGX
-	bool "Building with TILE-Gx (64-bit) compiler and toolchain"
+	bool "Building for TILE-Gx (64-bit) processor"
+	select HAVE_FUNCTION_TRACER
+	select HAVE_FUNCTION_TRACE_MCOUNT_TEST
+	select HAVE_FUNCTION_GRAPH_TRACER
+	select HAVE_DYNAMIC_FTRACE
+	select HAVE_FTRACE_MCOUNT_RECORD
 
 config TILEPRO
 	def_bool !TILEGX
diff --git a/arch/tile/include/asm/ftrace.h b/arch/tile/include/asm/ftrace.h
index 461459b..13a9bb81 100644
--- a/arch/tile/include/asm/ftrace.h
+++ b/arch/tile/include/asm/ftrace.h
@@ -15,6 +15,26 @@
 #ifndef _ASM_TILE_FTRACE_H
 #define _ASM_TILE_FTRACE_H
 
-/* empty */
+#ifdef CONFIG_FUNCTION_TRACER
+
+#define MCOUNT_ADDR ((unsigned long)(__mcount))
+#define MCOUNT_INSN_SIZE 8		/* sizeof mcount call */
+
+#ifndef __ASSEMBLY__
+extern void __mcount(void);
+
+#ifdef CONFIG_DYNAMIC_FTRACE
+static inline unsigned long ftrace_call_adjust(unsigned long addr)
+{
+	return addr;
+}
+
+struct dyn_arch_ftrace {
+};
+#endif /*  CONFIG_DYNAMIC_FTRACE */
+
+#endif /* __ASSEMBLY__ */
+
+#endif /* CONFIG_FUNCTION_TRACER */
 
 #endif /* _ASM_TILE_FTRACE_H */
diff --git a/arch/tile/kernel/Makefile b/arch/tile/kernel/Makefile
index c4a957a..2e6eaa1 100644
--- a/arch/tile/kernel/Makefile
+++ b/arch/tile/kernel/Makefile
@@ -9,6 +9,11 @@ obj-y := backtrace.o entry.o hvglue.o irq.o messaging.o \
 	sysfs.o time.o traps.o unaligned.o vdso.o \
 	intvec_$(BITS).o regs_$(BITS).o tile-desc_$(BITS).o
 
+ifdef CONFIG_FUNCTION_TRACER
+CFLAGS_REMOVE_ftrace.o = -pg
+CFLAGS_REMOVE_early_printk.o = -pg
+endif
+
 obj-$(CONFIG_HARDWALL)		+= hardwall.o
 obj-$(CONFIG_COMPAT)		+= compat.o compat_signal.o
 obj-$(CONFIG_SMP)		+= smpboot.o smp.o tlb.o
@@ -22,5 +27,6 @@ obj-$(CONFIG_PCI)		+= pci.o
 endif
 obj-$(CONFIG_TILE_USB)		+= usb.o
 obj-$(CONFIG_TILE_HVGLUE_TRACE)	+= hvglue_trace.o
+obj-$(CONFIG_FUNCTION_TRACER)	+= ftrace.o mcount_64.o
 
 obj-y				+= vdso/
diff --git a/arch/tile/kernel/ftrace.c b/arch/tile/kernel/ftrace.c
new file mode 100644
index 0000000..f1c4520
--- /dev/null
+++ b/arch/tile/kernel/ftrace.c
@@ -0,0 +1,246 @@
+/*
+ * Copyright 2012 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ *
+ * TILE-Gx specific ftrace support
+ */
+
+#include <linux/ftrace.h>
+#include <linux/uaccess.h>
+
+#include <asm/cacheflush.h>
+#include <asm/ftrace.h>
+#include <asm/sections.h>
+
+#include <arch/opcode.h>
+
+#ifdef CONFIG_DYNAMIC_FTRACE
+
+static inline tilegx_bundle_bits NOP(void)
+{
+	return create_UnaryOpcodeExtension_X0(FNOP_UNARY_OPCODE_X0) |
+		create_RRROpcodeExtension_X0(UNARY_RRR_0_OPCODE_X0) |
+		create_Opcode_X0(RRR_0_OPCODE_X0) |
+		create_UnaryOpcodeExtension_X1(NOP_UNARY_OPCODE_X1) |
+		create_RRROpcodeExtension_X1(UNARY_RRR_0_OPCODE_X1) |
+		create_Opcode_X1(RRR_0_OPCODE_X1);
+}
+
+static int machine_stopped __read_mostly;
+
+int ftrace_arch_code_modify_prepare(void)
+{
+	machine_stopped = 1;
+	return 0;
+}
+
+int ftrace_arch_code_modify_post_process(void)
+{
+	flush_icache_range(0, CHIP_L1I_CACHE_SIZE());
+	machine_stopped = 0;
+	return 0;
+}
+
+/*
+ * Put { move r10, lr; jal ftrace_caller } in a bundle, this lets dynamic
+ * tracer just add one cycle overhead to every kernel function when disabled.
+ */
+static unsigned long ftrace_gen_branch(unsigned long pc, unsigned long addr,
+				       bool link)
+{
+	tilegx_bundle_bits opcode_x0, opcode_x1;
+	long pcrel_by_instr = (addr - pc) >> TILEGX_LOG2_BUNDLE_SIZE_IN_BYTES;
+
+	if (link) {
+		/* opcode: jal addr */
+		opcode_x1 =
+			create_Opcode_X1(JUMP_OPCODE_X1) |
+			create_JumpOpcodeExtension_X1(JAL_JUMP_OPCODE_X1) |
+			create_JumpOff_X1(pcrel_by_instr);
+	} else {
+		/* opcode: j addr */
+		opcode_x1 =
+			create_Opcode_X1(JUMP_OPCODE_X1) |
+			create_JumpOpcodeExtension_X1(J_JUMP_OPCODE_X1) |
+			create_JumpOff_X1(pcrel_by_instr);
+	}
+
+	if (addr == FTRACE_ADDR) {
+		/* opcode: or r10, lr, zero */
+		opcode_x0 =
+			create_Dest_X0(10) |
+			create_SrcA_X0(TREG_LR) |
+			create_SrcB_X0(TREG_ZERO) |
+			create_RRROpcodeExtension_X0(OR_RRR_0_OPCODE_X0) |
+			create_Opcode_X0(RRR_0_OPCODE_X0);
+	} else {
+		/* opcode: fnop */
+		opcode_x0 =
+			create_UnaryOpcodeExtension_X0(FNOP_UNARY_OPCODE_X0) |
+			create_RRROpcodeExtension_X0(UNARY_RRR_0_OPCODE_X0) |
+			create_Opcode_X0(RRR_0_OPCODE_X0);
+	}
+
+	return opcode_x1 | opcode_x0;
+}
+
+static unsigned long ftrace_nop_replace(struct dyn_ftrace *rec)
+{
+	return NOP();
+}
+
+static unsigned long ftrace_call_replace(unsigned long pc, unsigned long addr)
+{
+	return ftrace_gen_branch(pc, addr, true);
+}
+
+static int ftrace_modify_code(unsigned long pc, unsigned long old,
+			      unsigned long new)
+{
+	unsigned long pc_wr;
+
+	/* Check if the address is in kernel text space and module space. */
+	if (!kernel_text_address(pc))
+		return -EINVAL;
+
+	/* Operate on writable kernel text mapping. */
+	pc_wr = pc - MEM_SV_START + PAGE_OFFSET;
+
+	if (probe_kernel_write((void *)pc_wr, &new, MCOUNT_INSN_SIZE))
+		return -EPERM;
+
+	smp_wmb();
+
+	if (!machine_stopped && num_online_cpus() > 1)
+		flush_icache_range(pc, pc + MCOUNT_INSN_SIZE);
+
+	return 0;
+}
+
+int ftrace_update_ftrace_func(ftrace_func_t func)
+{
+	unsigned long pc, old;
+	unsigned long new;
+	int ret;
+
+	pc = (unsigned long)&ftrace_call;
+	memcpy(&old, &ftrace_call, MCOUNT_INSN_SIZE);
+	new = ftrace_call_replace(pc, (unsigned long)func);
+
+	ret = ftrace_modify_code(pc, old, new);
+
+	return ret;
+}
+
+int ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
+{
+	unsigned long new, old;
+	unsigned long ip = rec->ip;
+
+	old = ftrace_nop_replace(rec);
+	new = ftrace_call_replace(ip, addr);
+
+	return ftrace_modify_code(rec->ip, old, new);
+}
+
+int ftrace_make_nop(struct module *mod,
+		    struct dyn_ftrace *rec, unsigned long addr)
+{
+	unsigned long ip = rec->ip;
+	unsigned long old;
+	unsigned long new;
+	int ret;
+
+	old = ftrace_call_replace(ip, addr);
+	new = ftrace_nop_replace(rec);
+	ret = ftrace_modify_code(ip, old, new);
+
+	return ret;
+}
+
+int __init ftrace_dyn_arch_init(void *data)
+{
+	*(unsigned long *)data = 0;
+
+	return 0;
+}
+#endif /* CONFIG_DYNAMIC_FTRACE */
+
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr,
+			   unsigned long frame_pointer)
+{
+	unsigned long return_hooker = (unsigned long) &return_to_handler;
+	struct ftrace_graph_ent trace;
+	unsigned long old;
+	int err;
+
+	if (unlikely(atomic_read(&current->tracing_graph_pause)))
+		return;
+
+	old = *parent;
+	*parent = return_hooker;
+
+	err = ftrace_push_return_trace(old, self_addr, &trace.depth,
+				       frame_pointer);
+	if (err == -EBUSY) {
+		*parent = old;
+		return;
+	}
+
+	trace.func = self_addr;
+
+	/* Only trace if the calling function expects to */
+	if (!ftrace_graph_entry(&trace)) {
+		current->curr_ret_stack--;
+		*parent = old;
+	}
+}
+
+#ifdef CONFIG_DYNAMIC_FTRACE
+extern unsigned long ftrace_graph_call;
+
+static int __ftrace_modify_caller(unsigned long *callsite,
+				  void (*func) (void), bool enable)
+{
+	unsigned long caller_fn = (unsigned long) func;
+	unsigned long pc = (unsigned long) callsite;
+	unsigned long branch = ftrace_gen_branch(pc, caller_fn, false);
+	unsigned long nop = NOP();
+	unsigned long old = enable ? nop : branch;
+	unsigned long new = enable ? branch : nop;
+
+	return ftrace_modify_code(pc, old, new);
+}
+
+static int ftrace_modify_graph_caller(bool enable)
+{
+	int ret;
+
+	ret = __ftrace_modify_caller(&ftrace_graph_call,
+				     ftrace_graph_caller,
+				     enable);
+
+	return ret;
+}
+
+int ftrace_enable_ftrace_graph_caller(void)
+{
+	return ftrace_modify_graph_caller(true);
+}
+
+int ftrace_disable_ftrace_graph_caller(void)
+{
+	return ftrace_modify_graph_caller(false);
+}
+#endif /* CONFIG_DYNAMIC_FTRACE */
+#endif /* CONFIG_FUNCTION_GRAPH_TRACER */
diff --git a/arch/tile/kernel/mcount_64.S b/arch/tile/kernel/mcount_64.S
new file mode 100644
index 0000000..70d7bb0
--- /dev/null
+++ b/arch/tile/kernel/mcount_64.S
@@ -0,0 +1,224 @@
+/*
+ * Copyright 2012 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ *
+ * TILE-Gx specific __mcount support
+ */
+
+#include <linux/linkage.h>
+#include <asm/ftrace.h>
+
+#define REGSIZE 8
+
+	.text
+	.global __mcount
+
+	.macro	MCOUNT_SAVE_REGS
+	addli	sp, sp, -REGSIZE
+	{
+	 st     sp, lr
+	 addli	r29, sp, - (12 * REGSIZE)
+	}
+	{
+	 addli	sp, sp, - (13 * REGSIZE)
+	 st     r29, sp
+	}
+	addli	r29, r29, REGSIZE
+	{ st	r29, r0; addli	r29, r29, REGSIZE }
+	{ st	r29, r1; addli	r29, r29, REGSIZE }
+	{ st	r29, r2; addli	r29, r29, REGSIZE }
+	{ st	r29, r3; addli	r29, r29, REGSIZE }
+	{ st	r29, r4; addli	r29, r29, REGSIZE }
+	{ st	r29, r5; addli	r29, r29, REGSIZE }
+	{ st	r29, r6; addli	r29, r29, REGSIZE }
+	{ st	r29, r7; addli	r29, r29, REGSIZE }
+	{ st	r29, r8; addli	r29, r29, REGSIZE }
+	{ st	r29, r9; addli	r29, r29, REGSIZE }
+	{ st	r29, r10; addli	r29, r29, REGSIZE }
+	.endm
+
+	.macro	MCOUNT_RESTORE_REGS
+	addli	r29, sp, (2 * REGSIZE)
+	{ ld	r0, r29; addli	r29, r29, REGSIZE }
+	{ ld	r1, r29; addli	r29, r29, REGSIZE }
+	{ ld	r2, r29; addli	r29, r29, REGSIZE }
+	{ ld	r3, r29; addli	r29, r29, REGSIZE }
+	{ ld	r4, r29; addli	r29, r29, REGSIZE }
+	{ ld	r5, r29; addli	r29, r29, REGSIZE }
+	{ ld	r6, r29; addli	r29, r29, REGSIZE }
+	{ ld	r7, r29; addli	r29, r29, REGSIZE }
+	{ ld	r8, r29; addli	r29, r29, REGSIZE }
+	{ ld	r9, r29; addli	r29, r29, REGSIZE }
+	{ ld	r10, r29; addli	lr, sp, (13 * REGSIZE) }
+	{ ld	lr, lr;  addli	sp, sp, (14 * REGSIZE) }
+	.endm
+
+	.macro  RETURN_BACK
+	{ move	r12, lr; move	lr, r10 }
+	jrp	r12
+	.endm
+
+#ifdef CONFIG_DYNAMIC_FTRACE
+
+	.align	64
+STD_ENTRY(__mcount)
+__mcount:
+	j	ftrace_stub
+STD_ENDPROC(__mcount)
+
+	.align	64
+STD_ENTRY(ftrace_caller)
+	moveli	r11, hw2_last(function_trace_stop)
+	{ shl16insli	r11, r11, hw1(function_trace_stop); move r12, lr }
+	{ shl16insli	r11, r11, hw0(function_trace_stop); move lr, r10 }
+	ld	r11, r11
+	beqz	r11, 1f
+	jrp	r12
+
+1:
+	{ move	r10, lr; move	lr, r12 }
+	MCOUNT_SAVE_REGS
+
+	/* arg1: self return address */
+	/* arg2: parent's return address */
+	{ move	r0, lr; move	r1, r10 }
+
+	.global	ftrace_call
+ftrace_call:
+	/*
+	 * a placeholder for the call to a real tracing function, i.e.
+	 * ftrace_trace_function()
+	 */
+	nop
+
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+	.global	ftrace_graph_call
+ftrace_graph_call:
+	/*
+	 * a placeholder for the call to a real tracing function, i.e.
+	 * ftrace_graph_caller()
+	 */
+	nop
+#endif
+	MCOUNT_RESTORE_REGS
+	.global	ftrace_stub
+ftrace_stub:
+	RETURN_BACK
+STD_ENDPROC(ftrace_caller)
+
+#else /* ! CONFIG_DYNAMIC_FTRACE */
+
+	.align	64
+STD_ENTRY(__mcount)
+	moveli	r11, hw2_last(function_trace_stop)
+	{ shl16insli	r11, r11, hw1(function_trace_stop); move r12, lr }
+	{ shl16insli	r11, r11, hw0(function_trace_stop); move lr, r10 }
+	ld	r11, r11
+	beqz	r11, 1f
+	jrp	r12
+
+1:
+	{ move	r10, lr; move	lr, r12 }
+	{
+	 moveli	r11, hw2_last(ftrace_trace_function)
+	 moveli	r13, hw2_last(ftrace_stub)
+	}
+	{
+	 shl16insli	r11, r11, hw1(ftrace_trace_function)
+	 shl16insli	r13, r13, hw1(ftrace_stub)
+	}
+	{
+	 shl16insli	r11, r11, hw0(ftrace_trace_function)
+	 shl16insli	r13, r13, hw0(ftrace_stub)
+	}
+
+	ld	r11, r11
+	sub	r14, r13, r11
+	bnez	r14, static_trace
+
+#ifdef	CONFIG_FUNCTION_GRAPH_TRACER
+	moveli	r15, hw2_last(ftrace_graph_return)
+	shl16insli	r15, r15, hw1(ftrace_graph_return)
+	shl16insli	r15, r15, hw0(ftrace_graph_return)
+	ld	r15, r15
+	sub	r15, r15, r13
+	bnez	r15, ftrace_graph_caller
+
+	{
+	 moveli	r16, hw2_last(ftrace_graph_entry)
+	 moveli	r17, hw2_last(ftrace_graph_entry_stub)
+	}
+	{
+	 shl16insli	r16, r16, hw1(ftrace_graph_entry)
+	 shl16insli	r17, r17, hw1(ftrace_graph_entry_stub)
+	}
+	{
+	 shl16insli	r16, r16, hw0(ftrace_graph_entry)
+	 shl16insli	r17, r17, hw0(ftrace_graph_entry_stub)
+	}
+	ld	r16, r16
+	sub	r17, r16, r17
+	bnez	r17, ftrace_graph_caller
+
+#endif
+	RETURN_BACK
+
+static_trace:
+	MCOUNT_SAVE_REGS
+
+	/* arg1: self return address */
+	/* arg2: parent's return address */
+	{ move	r0, lr; move	r1, r10 }
+
+	/* call ftrace_trace_function() */
+	jalr	r11
+
+	MCOUNT_RESTORE_REGS
+
+	.global ftrace_stub
+ftrace_stub:
+	RETURN_BACK
+STD_ENDPROC(__mcount)
+
+#endif	/* ! CONFIG_DYNAMIC_FTRACE */
+
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+
+STD_ENTRY(ftrace_graph_caller)
+ftrace_graph_caller:
+#ifndef CONFIG_DYNAMIC_FTRACE
+	MCOUNT_SAVE_REGS
+#endif
+
+	/* arg1: Get the location of the parent's return address */
+	addi	r0, sp, 12 * REGSIZE
+	/* arg2: Get self return address */
+	move	r1, lr
+
+	jal prepare_ftrace_return
+
+	MCOUNT_RESTORE_REGS
+	RETURN_BACK
+STD_ENDPROC(ftrace_graph_caller)
+
+	.global return_to_handler
+return_to_handler:
+	MCOUNT_SAVE_REGS
+
+	jal	ftrace_return_to_handler
+	/* restore the real parent address */
+	move	r11, r0
+
+	MCOUNT_RESTORE_REGS
+	jr	r11
+
+#endif /* CONFIG_FUNCTION_GRAPH_TRACER */
diff --git a/arch/tile/kernel/vmlinux.lds.S b/arch/tile/kernel/vmlinux.lds.S
index 0f0edaf..673d00a 100644
--- a/arch/tile/kernel/vmlinux.lds.S
+++ b/arch/tile/kernel/vmlinux.lds.S
@@ -43,6 +43,7 @@ SECTIONS
     HEAD_TEXT
     SCHED_TEXT
     LOCK_TEXT
+    IRQENTRY_TEXT
     __fix_text_end = .;   /* tile-cpack won't rearrange before this */
     TEXT_TEXT
     *(.text.*)
diff --git a/arch/tile/lib/exports.c b/arch/tile/lib/exports.c
index 359b1bc..82733c8 100644
--- a/arch/tile/lib/exports.c
+++ b/arch/tile/lib/exports.c
@@ -33,6 +33,12 @@ EXPORT_SYMBOL(dump_stack);
 /* arch/tile/kernel/head.S */
 EXPORT_SYMBOL(empty_zero_page);
 
+#ifdef CONFIG_FUNCTION_TRACER
+/* arch/tile/kernel/mcount_64.S */
+#include <asm/ftrace.h>
+EXPORT_SYMBOL(__mcount);
+#endif /* CONFIG_FUNCTION_TRACER */
+
 /* arch/tile/lib/, various memcpy files */
 EXPORT_SYMBOL(memcpy);
 EXPORT_SYMBOL(__copy_to_user_inatomic);
diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index 858966a..a674fd5 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -364,6 +364,10 @@ if ($arch eq "x86_64") {
 } elsif ($arch eq "blackfin") {
     $mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\s__mcount\$";
     $mcount_adjust = -4;
+} elsif ($arch eq "tilegx") {
+    $mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\s__mcount\$";
+    $type = ".quad";
+    $alignment = 8;
 } else {
     die "Arch $arch is not supported with CONFIG_FTRACE_MCOUNT_RECORD";
 }
-- 
1.8.3.1

