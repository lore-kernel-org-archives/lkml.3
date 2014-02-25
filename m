Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196AbaBYJYP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 04:24:15 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:33908 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753179AbaBYJYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 04:24:12 -0500
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
To: rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com,
        catalin.marinas@arm.com, will.deacon@arm.com, tim.bird@sonymobile.com
Cc: gkulkarni@caviumnetworks.com, dsaxena@linaro.org, arndb@arndb.de,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        linux-kernel@vger.kernel.org,
        AKASHI Takahiro <takahiro.akashi@linaro.org>
Subject: [PATCH v4 2/7] arm64: ftrace: Add dynamic ftrace support
Date: Tue, 25 Feb 2014 18:23:11 +0900
Message-Id: <1393320196-2942-3-git-send-email-takahiro.akashi@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1393320196-2942-1-git-send-email-takahiro.akashi@linaro.org>
References: <1391768336-5642-1-git-send-email-takahiro.akashi@linaro.org>
 <1393320196-2942-1-git-send-email-takahiro.akashi@linaro.org>
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

Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
---
 arch/arm64/Kconfig               |    1 +
 arch/arm64/include/asm/ftrace.h  |   15 +++++
 arch/arm64/kernel/entry-ftrace.S |   43 +++++++++++++++
 arch/arm64/kernel/ftrace.c       |  113 ++++++++++++++++++++++++++++++++++++++
 4 files changed, 172 insertions(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 5783641..b176bc0 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -32,6 +32,7 @@ config ARM64
 	select HAVE_DMA_API_DEBUG
 	select HAVE_DMA_ATTRS
 	select HAVE_DMA_CONTIGUOUS
+	select HAVE_DYNAMIC_FTRACE
 	select HAVE_EFFICIENT_UNALIGNED_ACCESS
 	select HAVE_FUNCTION_TRACER
 	select HAVE_FUNCTION_GRAPH_TRACER
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
index 2e8162e..b948878 100644
--- a/arch/arm64/kernel/entry-ftrace.S
+++ b/arch/arm64/kernel/entry-ftrace.S
@@ -84,6 +84,7 @@
 	add	\reg, \reg, #8
 	.endm
 
+#ifndef CONFIG_DYNAMIC_FTRACE
 /*
  * void _mcount(unsigned long return_address)
  * @return_address: return address to instrumented function
@@ -132,6 +133,48 @@ skip_ftrace_call:
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
index a559ab8..8c26476 100644
--- a/arch/arm64/kernel/ftrace.c
+++ b/arch/arm64/kernel/ftrace.c
@@ -17,6 +17,89 @@
 #include <asm/ftrace.h>
 #include <asm/insn.h>
 
+#ifdef CONFIG_DYNAMIC_FTRACE
+/*
+ * Replace a single instruction, which may be a branch or NOP.
+ * If @validate == true, a replaced instruction is checked against 'old'.
+ */
+static int ftrace_modify_code(unsigned long pc, unsigned int old,
+			      unsigned int new, bool validate)
+{
+	unsigned int replaced;
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
+	unsigned int new;
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
+	unsigned int old, new;
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
+int ftrace_make_nop(struct module *mod,
+		    struct dyn_ftrace *rec, unsigned long addr)
+{
+	unsigned long pc = rec->ip;
+	unsigned int old, new;
+
+	old = aarch64_insn_gen_branch_imm(pc, addr, true);
+	new = aarch64_insn_gen_nop();
+
+	return ftrace_modify_code(pc, old, new, true);
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
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 /*
  * function_graph tracer expects ftrace_return_to_handler() to be called
@@ -61,4 +144,34 @@ void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr,
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
+	unsigned int branch, nop, old, new;
+
+	branch = aarch64_insn_gen_branch_imm(pc,
+			(unsigned long)ftrace_graph_caller, false);
+	nop = aarch64_insn_gen_nop();
+	old = enable ? nop : branch;
+	new = enable ? branch : nop;
+
+	return ftrace_modify_code(pc, old, new, true);
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

