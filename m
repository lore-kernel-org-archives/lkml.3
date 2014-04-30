Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964809AbaD3J4f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 05:56:35 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:39710 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933527AbaD3J4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 05:56:31 -0400
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
To: rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com,
        catalin.marinas@arm.com, will.deacon@arm.com, tim.bird@sonymobile.com
Cc: gkulkarni@caviumnetworks.com, dsaxena@linaro.org, arndb@arndb.de,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        linux-kernel@vger.kernel.org,
        AKASHI Takahiro <takahiro.akashi@linaro.org>
Subject: [PATCH v8 6/8] arm64: ftrace: Add dynamic ftrace support
Date: Wed, 30 Apr 2014 18:54:34 +0900
Message-Id: <1398851676-16389-7-git-send-email-takahiro.akashi@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1398851676-16389-1-git-send-email-takahiro.akashi@linaro.org>
References: <1394862048-28758-1-git-send-email-takahiro.akashi@linaro.org>
 <1398851676-16389-1-git-send-email-takahiro.akashi@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch allows "dynamic ftrace" if CONFIG_DYNAMIC_FTRACE is enabled.
Here we can turn on and off tracing dynamically per-function base.

On arm64, this is done by patching single branch instruction to _mcount()
inserted by gcc -pg option. The branch is replaced to NOP initially at
kernel start up, and later on, NOP to branch to ftrace_caller() when
enabled or branch to NOP when disabled.
Please note that ftrace_caller() is a counterpart of _mcount() in case of
'static' ftrace.

More details on architecture specific requirements are described in
Documentation/trace/ftrace-design.txt.

Acked-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
---
 arch/arm64/Kconfig               |    1 +
 arch/arm64/include/asm/ftrace.h  |   15 +++++
 arch/arm64/kernel/entry-ftrace.S |   43 +++++++++++++++
 arch/arm64/kernel/ftrace.c       |  112 ++++++++++++++++++++++++++++++++++++++
 4 files changed, 171 insertions(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 856007e..438a4ea 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -36,6 +36,7 @@ config ARM64
 	select HAVE_DMA_API_DEBUG
 	select HAVE_DMA_ATTRS
 	select HAVE_DMA_CONTIGUOUS
+	select HAVE_DYNAMIC_FTRACE
 	select HAVE_EFFICIENT_UNALIGNED_ACCESS
 	select HAVE_FTRACE_MCOUNT_RECORD
 	select HAVE_FUNCTION_TRACER
diff --git a/arch/arm64/include/asm/ftrace.h b/arch/arm64/include/asm/ftrace.h
index 58ea595..ed5c448 100644
--- a/arch/arm64/include/asm/ftrace.h
+++ b/arch/arm64/include/asm/ftrace.h
@@ -18,6 +18,21 @@
 
 #ifndef __ASSEMBLY__
 extern void _mcount(unsigned long);
+
+struct dyn_arch_ftrace {
+	/* No extra data needed for arm64 */
+};
+
+extern unsigned long ftrace_graph_call;
+
+static inline unsigned long ftrace_call_adjust(unsigned long addr)
+{
+	/*
+	 * addr is the address of the mcount call instruction.
+	 * recordmcount does the necessary offset calculation.
+	 */
+	return addr;
+}
 #endif /* __ASSEMBLY__ */
 
 #endif /* __ASM_FTRACE_H */
diff --git a/arch/arm64/kernel/entry-ftrace.S b/arch/arm64/kernel/entry-ftrace.S
index b2d8c45..b051871 100644
--- a/arch/arm64/kernel/entry-ftrace.S
+++ b/arch/arm64/kernel/entry-ftrace.S
@@ -86,6 +86,7 @@
 	add	\reg, \reg, #8
 	.endm
 
+#ifndef CONFIG_DYNAMIC_FTRACE
 /*
  * void _mcount(unsigned long return_address)
  * @return_address: return address to instrumented function
@@ -134,6 +135,48 @@ skip_ftrace_call:
 #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
 ENDPROC(_mcount)
 
+#else /* CONFIG_DYNAMIC_FTRACE */
+/*
+ * _mcount() is used to build the kernel with -pg option, but all the branch
+ * instructions to _mcount() are replaced to NOP initially at kernel start up,
+ * and later on, NOP to branch to ftrace_caller() when enabled or branch to
+ * NOP when disabled per-function base.
+ */
+ENTRY(_mcount)
+	ret
+ENDPROC(_mcount)
+
+/*
+ * void ftrace_caller(unsigned long return_address)
+ * @return_address: return address to instrumented function
+ *
+ * This function is a counterpart of _mcount() in 'static' ftrace, and
+ * makes calls to:
+ *     - tracer function to probe instrumented function's entry,
+ *     - ftrace_graph_caller to set up an exit hook
+ */
+ENTRY(ftrace_caller)
+	mcount_enter
+
+	mcount_get_pc0	x0		//     function's pc
+	mcount_get_lr	x1		//     function's lr
+
+	.global ftrace_call
+ftrace_call:				// tracer(pc, lr);
+	nop				// This will be replaced with "bl xxx"
+					// where xxx can be any kind of tracer.
+
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+	.global ftrace_graph_call
+ftrace_graph_call:			// ftrace_graph_caller();
+	nop				// If enabled, this will be replaced
+					// "b ftrace_graph_caller"
+#endif
+
+	mcount_exit
+ENDPROC(ftrace_caller)
+#endif /* CONFIG_DYNAMIC_FTRACE */
+
 ENTRY(ftrace_stub)
 	ret
 ENDPROC(ftrace_stub)
diff --git a/arch/arm64/kernel/ftrace.c b/arch/arm64/kernel/ftrace.c
index a559ab8..7924d73 100644
--- a/arch/arm64/kernel/ftrace.c
+++ b/arch/arm64/kernel/ftrace.c
@@ -17,6 +17,87 @@
 #include <asm/ftrace.h>
 #include <asm/insn.h>
 
+#ifdef CONFIG_DYNAMIC_FTRACE
+/*
+ * Replace a single instruction, which may be a branch or NOP.
+ * If @validate == true, a replaced instruction is checked against 'old'.
+ */
+static int ftrace_modify_code(unsigned long pc, u32 old, u32 new,
+			      bool validate)
+{
+	u32 replaced;
+
+	/*
+	 * Note:
+	 * Due to modules and __init, code can disappear and change,
+	 * we need to protect against faulting as well as code changing.
+	 * We do this by aarch64_insn_*() which use the probe_kernel_*().
+	 *
+	 * No lock is held here because all the modifications are run
+	 * through stop_machine().
+	 */
+	if (validate) {
+		if (aarch64_insn_read((void *)pc, &replaced))
+			return -EFAULT;
+
+		if (replaced != old)
+			return -EINVAL;
+	}
+	if (aarch64_insn_patch_text_nosync((void *)pc, new))
+		return -EPERM;
+
+	return 0;
+}
+
+/*
+ * Replace tracer function in ftrace_caller()
+ */
+int ftrace_update_ftrace_func(ftrace_func_t func)
+{
+	unsigned long pc;
+	u32 new;
+
+	pc = (unsigned long)&ftrace_call;
+	new = aarch64_insn_gen_branch_imm(pc, (unsigned long)func, true);
+
+	return ftrace_modify_code(pc, 0, new, false);
+}
+
+/*
+ * Turn on the call to ftrace_caller() in instrumented function
+ */
+int ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
+{
+	unsigned long pc = rec->ip;
+	u32 old, new;
+
+	old = aarch64_insn_gen_nop();
+	new = aarch64_insn_gen_branch_imm(pc, addr, true);
+
+	return ftrace_modify_code(pc, old, new, true);
+}
+
+/*
+ * Turn off the call to ftrace_caller() in instrumented function
+ */
+int ftrace_make_nop(struct module *mod, struct dyn_ftrace *rec,
+		    unsigned long addr)
+{
+	unsigned long pc = rec->ip;
+	u32 old, new;
+
+	old = aarch64_insn_gen_branch_imm(pc, addr, true);
+	new = aarch64_insn_gen_nop();
+
+	return ftrace_modify_code(pc, old, new, true);
+}
+
+int __init ftrace_dyn_arch_init(void)
+{
+	return 0;
+}
+#endif /* CONFIG_DYNAMIC_FTRACE */
+
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 /*
  * function_graph tracer expects ftrace_return_to_handler() to be called
@@ -61,4 +142,35 @@ void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr,
 		return;
 	}
 }
+
+#ifdef CONFIG_DYNAMIC_FTRACE
+/*
+ * Turn on/off the call to ftrace_graph_caller() in ftrace_caller()
+ * depending on @enable.
+ */
+static int ftrace_modify_graph_caller(bool enable)
+{
+	unsigned long pc = (unsigned long)&ftrace_graph_call;
+	u32 branch, nop;
+
+	branch = aarch64_insn_gen_branch_imm(pc,
+			(unsigned long)ftrace_graph_caller, false);
+	nop = aarch64_insn_gen_nop();
+
+	if (enable)
+		return ftrace_modify_code(pc, nop, branch, true);
+	else
+		return ftrace_modify_code(pc, branch, nop, true);
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
 #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
-- 
1.7.9.5

