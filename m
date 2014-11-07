Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751952AbaKGPCD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 10:02:03 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:57554 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209AbaKGPBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 10:01:49 -0500
From: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
To: jslaby@suse.cz, linux@arm.linux.org.uk, rostedt@goodmis.org,
        mingo@redhat.com, nsekhar@ti.com, stefano.stabellini@eu.citrix.com,
        christoffer.dall@linaro.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>
Subject: [PATCH 01/01] arm: ftrace: Adds support for ftrace operations
Date: Fri,  7 Nov 2014 15:59:12 +0100
Message-Id: <1415372352-15664-2-git-send-email-jjhiblot@traphandler.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1415372352-15664-1-git-send-email-jjhiblot@traphandler.com>
References: <1415372352-15664-1-git-send-email-jjhiblot@traphandler.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ftrace operations require that DYNAMIC_FTRACE_WITH_REGS is enabled.
This patch introduces a new ftrace handler that store the registers on the
stack before calling the next stage. The registers are also restored from the
stack before going back to the instrumented function.

Signed-off-by: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
---
 arch/arm/Kconfig               |  2 ++
 arch/arm/include/asm/ftrace.h  |  3 ++
 arch/arm/kernel/entry-common.S | 68 +++++++++++++++++++++++++++++++++++++++++-
 arch/arm/kernel/ftrace.c       | 34 +++++++++++++++++++++
 4 files changed, 106 insertions(+), 1 deletion(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 32cbbd5..6f928ee 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -39,6 +39,7 @@ config ARM
 	select HAVE_DMA_ATTRS
 	select HAVE_DMA_CONTIGUOUS if MMU
 	select HAVE_DYNAMIC_FTRACE if (!XIP_KERNEL)
+	select HAVE_DYNAMIC_FTRACE_WITH_REGS if HAVE_DYNAMIC_FTRACE
 	select HAVE_EFFICIENT_UNALIGNED_ACCESS if (CPU_V6 || CPU_V6K || CPU_V7) && MMU
 	select HAVE_FTRACE_MCOUNT_RECORD if (!XIP_KERNEL)
 	select HAVE_FUNCTION_GRAPH_TRACER if (!THUMB2_KERNEL)
@@ -72,6 +73,7 @@ config ARM
 	select PERF_USE_VMALLOC
 	select RTC_LIB
 	select SYS_SUPPORTS_APM_EMULATION
+	select FRAME_POINTER if DYNAMIC_FTRACE_WITH_REGS && FUNCTION_GRAPH_TRACER
 	# Above selects are sorted alphabetically; please add new ones
 	# according to that.  Thanks.
 	help
diff --git a/arch/arm/include/asm/ftrace.h b/arch/arm/include/asm/ftrace.h
index 39eb16b..d8e9bea 100644
--- a/arch/arm/include/asm/ftrace.h
+++ b/arch/arm/include/asm/ftrace.h
@@ -10,6 +10,9 @@ extern void mcount(void);
 extern void __gnu_mcount_nc(void);
 
 #ifdef CONFIG_DYNAMIC_FTRACE
+
+#define ARCH_SUPPORTS_FTRACE_OPS 1
+
 struct dyn_arch_ftrace {
 #ifdef CONFIG_OLD_MCOUNT
 	bool	old_mcount;
diff --git a/arch/arm/kernel/entry-common.S b/arch/arm/kernel/entry-common.S
index e52fe5a..9594fe2 100644
--- a/arch/arm/kernel/entry-common.S
+++ b/arch/arm/kernel/entry-common.S
@@ -197,7 +197,10 @@ ENDPROC(ret_from_fork)
 
 	mcount_get_lr	r1			@ lr of instrumented func
 	mcount_adjust_addr	r0, lr		@ instrumented function
-
+	ldr r2, =function_trace_op
+	ldr r2, [r2]				@ pointer to the current
+						@ function tracing op
+	mov r3, #0				@ regs is NULL
 	.globl ftrace_call\suffix
 ftrace_call\suffix:
 	bl	ftrace_stub
@@ -211,6 +214,38 @@ ftrace_graph_call\suffix:
 	mcount_exit
 .endm
 
+.macro __ftrace_regs_caller
+
+	add 	ip, sp, #4	@ move in IP the value of SP as it was
+				@ before the push {lr} of the mcount mechanism
+	stmdb	sp!, {ip,lr,pc}
+	stmdb	sp!, {r0-r11,lr}
+	@ stack content  at this point:
+	@ 0  4         44    48   52       56   60   64
+	@ RO | R1 | ... | R11 | LR | SP + 4 | LR | PC | previous LR |
+
+	mov r3, sp				@ struct pt_regs*
+	ldr r2, =function_trace_op
+	ldr r2, [r2]				@ pointer to the current
+						@ function tracing op
+	ldr	r1, [sp, #64]			@ lr of instrumented func
+	mcount_adjust_addr	r0, lr		@ instrumented function
+
+	.globl ftrace_regs_call
+ftrace_regs_call:
+	bl	ftrace_stub
+
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+	.globl ftrace_graph_regs_call
+ftrace_graph_regs_call:
+	mov	r0, r0
+#endif
+	ldr	lr, [sp, #64]		@ get the previous LR value from stack
+	ldmia	sp, {r0-r11, ip, sp}	@ pop the saved registers INCLUDING
+					@ the stack pointer
+	ret	ip
+.endm
+
 .macro __ftrace_graph_caller
 	sub	r0, fp, #4		@ &lr of instrumented routine (&parent)
 #ifdef CONFIG_DYNAMIC_FTRACE
@@ -226,6 +261,24 @@ ftrace_graph_call\suffix:
 	mcount_exit
 .endm
 
+
+.macro __ftrace_graph_regs_caller
+
+	sub	r0, fp, #4		@ &lr of instrumented routine (&parent)
+
+	@ called from __ftrace_regs_caller
+	ldr	r1, [sp, #56]		@ instrumented routine (func)
+	mcount_adjust_addr	r1, r1
+
+	mov	r2, fp			@ frame pointer
+	bl	prepare_ftrace_return
+
+	ldr	lr, [fp, #-4]		@ restore LR from the stack
+	ldmia	sp, {r0-r11, ip, sp}	@ pop the saved registers INCLUDING
+					@ the stack pointer
+	ret	ip
+.endm
+
 #ifdef CONFIG_OLD_MCOUNT
 /*
  * mcount
@@ -312,14 +365,27 @@ UNWIND(.fnstart)
 	__ftrace_caller
 UNWIND(.fnend)
 ENDPROC(ftrace_caller)
+
+ENTRY(ftrace_regs_caller)
+UNWIND(.fnstart)
+	__ftrace_regs_caller
+UNWIND(.fnend)
+ENDPROC(ftrace_regs_caller)
 #endif
 
+
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 ENTRY(ftrace_graph_caller)
 UNWIND(.fnstart)
 	__ftrace_graph_caller
 UNWIND(.fnend)
 ENDPROC(ftrace_graph_caller)
+
+ENTRY(ftrace_graph_regs_caller)
+UNWIND(.fnstart)
+	__ftrace_graph_regs_caller
+UNWIND(.fnend)
+ENDPROC(ftrace_graph_regs_caller)
 #endif
 
 .purgem mcount_enter
diff --git a/arch/arm/kernel/ftrace.c b/arch/arm/kernel/ftrace.c
index af9a8a9..35c5743 100644
--- a/arch/arm/kernel/ftrace.c
+++ b/arch/arm/kernel/ftrace.c
@@ -130,6 +130,16 @@ int ftrace_update_ftrace_func(ftrace_func_t func)
 	}
 #endif
 
+
+#ifdef CONFIG_DYNAMIC_FTRACE_WITH_REGS
+	if (!ret) {
+		pc = (unsigned long)&ftrace_regs_call;
+		new = ftrace_call_replace(pc, (unsigned long)func);
+
+		ret = ftrace_modify_code(pc, 0, new, false);
+	}
+#endif
+
 	return ret;
 }
 
@@ -139,6 +149,20 @@ int ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
 	unsigned long ip = rec->ip;
 
 	old = ftrace_nop_replace(rec);
+
+	new = ftrace_call_replace(ip, adjust_address(rec, addr));
+
+	return ftrace_modify_code(rec->ip, old, new, true);
+}
+
+int ftrace_modify_call(struct dyn_ftrace *rec, unsigned long old_addr,
+				unsigned long addr)
+{
+	unsigned long new, old;
+	unsigned long ip = rec->ip;
+
+	old = ftrace_call_replace(ip, adjust_address(rec, old_addr));
+
 	new = ftrace_call_replace(ip, adjust_address(rec, addr));
 
 	return ftrace_modify_code(rec->ip, old, new, true);
@@ -211,6 +235,9 @@ void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr,
 extern unsigned long ftrace_graph_call;
 extern unsigned long ftrace_graph_call_old;
 extern void ftrace_graph_caller_old(void);
+extern unsigned long ftrace_graph_regs_call;
+extern void ftrace_graph_regs_caller(void);
+
 
 static int __ftrace_modify_caller(unsigned long *callsite,
 				  void (*func) (void), bool enable)
@@ -240,6 +267,13 @@ static int ftrace_modify_graph_caller(bool enable)
 					     enable);
 #endif
 
+#ifdef CONFIG_DYNAMIC_FTRACE_WITH_REGS
+	if (!ret)
+		ret = __ftrace_modify_caller(&ftrace_graph_regs_call,
+				     ftrace_graph_regs_caller,
+				     enable);
+#endif
+
 	return ret;
 }
 
-- 
2.1.3

