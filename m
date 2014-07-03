Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754104AbaGCUXa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 16:23:30 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:48678 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750736AbaGCUX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 16:23:27 -0400
Message-Id: <20140703202324.832135644@goodmis.org>
User-Agent: quilt/0.63-1
Date: Thu, 03 Jul 2014 16:07:51 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Namhyung Kim <namhyung@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Oleg Nesterov <oleg@redhat.com>, Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Seth Jennings <sjenning@redhat.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [RFC][PATCH 1/3] ftrace/x86: Add dynamic allocated trampoline for ftrace_ops
References: <20140703200750.648550267@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0001-ftrace-x86-Add-dynamic-allocated-trampoline-for-ftra.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

The current method of handling multiple function callbacks is to register
a list function callback that calls all the other callbacks based on
their hash tables and compare it to the function that the callback was
called on. But this is very inefficient.

For example, if you are tracing all functions in the kernel and then
add a kprobe to a function such that the kprobe uses ftrace, the
mcount trampoline will switch from calling the function trace callback
to calling the list callback that will iterate over all registered
ftrace_ops (in this case, the function tracer and the kprobes callback).
That means for every function being traced it checks the hash of the
ftrace_ops for function tracing and kprobes, even though the kprobes
is only set at a single function. The kprobes ftrace_ops is checked
for every function being traced!

Instead of calling the list function for functions that are only being
traced by a single callback, we can call a dynamically allocated
trampoline that calls the callback directly. The function graph tracer
already uses a direct call trampoline when it is being traced by itself
but it is not dynamically allocated. It's trampoline is static in the
kernel core. The infrastructure that called the function graph trampoline
can also be used to call a dynamically allocated one.

For now, only ftrace_ops that are not dynamically allocated can have
a trampoline. That is, users such as function tracer or stack tracer.
kprobes and perf allocate their ftrace_ops, and until there's a safe
way to free the trampoline, it can not be used. The dynamically allocated
ftrace_ops may, although, use the trampoline if the kernel is not
compiled with CONFIG_PREEMPT. But that will come later.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/ftrace.c    | 157 ++++++++++++++++++++++++++++++++++++++++++--
 arch/x86/kernel/mcount_64.S |  26 ++++++--
 include/linux/ftrace.h      |   8 +++
 kernel/trace/ftrace.c       |  46 ++++++++++++-
 4 files changed, 224 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 3386dc9aa333..fcc256a33c1d 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -17,9 +17,11 @@
 #include <linux/ftrace.h>
 #include <linux/percpu.h>
 #include <linux/sched.h>
+#include <linux/slab.h>
 #include <linux/init.h>
 #include <linux/list.h>
 #include <linux/module.h>
+#include <linux/moduleloader.h>
 
 #include <trace/syscall.h>
 
@@ -644,12 +646,6 @@ int __init ftrace_dyn_arch_init(void)
 {
 	return 0;
 }
-#endif
-
-#ifdef CONFIG_FUNCTION_GRAPH_TRACER
-
-#ifdef CONFIG_DYNAMIC_FTRACE
-extern void ftrace_graph_call(void);
 
 static unsigned char *ftrace_jmp_replace(unsigned long ip, unsigned long addr)
 {
@@ -665,6 +661,155 @@ static unsigned char *ftrace_jmp_replace(unsigned long ip, unsigned long addr)
 	return calc.code;
 }
 
+/* Currently only x86_64 supports dynamic trampolines */
+#ifdef CONFIG_X86_64
+
+/* Defined as markers to the end of the ftrace default trampolines */
+extern void ftrace_caller_end(void);
+extern void ftrace_regs_caller_end(void);
+extern void ftrace_return(void);
+extern void ftrace_caller_op_ptr(void);
+extern void ftrace_regs_caller_op_ptr(void);
+
+/* movq function_trace_op(%rip), %rdx */
+/* 0x48 0x8b 0x15 <offset-to-ftrace_trace_op (4 bytes)> */
+#define OP_REF_SIZE	7
+
+/*
+ * The ftrace_ops is passed to the function, we can pass
+ * in the ops directly as this trampoline will only call
+ * a function for a single ops.
+ */
+union ftrace_op_code_union {
+	char code[OP_REF_SIZE];
+	struct {
+		char op[3];
+		int offset;
+	} __attribute__((packed));
+};
+
+static unsigned long create_trampoline(struct ftrace_ops *ops)
+{
+	unsigned const char *jmp;
+	unsigned long start_offset;
+	unsigned long end_offset;
+	unsigned long op_offset;
+	unsigned long offset;
+	unsigned long size;
+	unsigned long ip;
+	unsigned long *ptr;
+	void *trampoline;
+	unsigned const char op_ref[] = { 0x48, 0x8b, 0x15 };
+	union ftrace_op_code_union op_ptr;
+	int ret;
+
+	if (ops->flags & FTRACE_OPS_FL_SAVE_REGS) {
+		start_offset = (unsigned long)ftrace_regs_caller;
+		end_offset = (unsigned long)ftrace_regs_caller_end;
+		op_offset = (unsigned long)ftrace_regs_caller_op_ptr;
+	} else {
+		start_offset = (unsigned long)ftrace_caller;
+		end_offset = (unsigned long)ftrace_caller_end;
+		op_offset = (unsigned long)ftrace_caller_op_ptr;
+	}
+
+	size = end_offset - start_offset;
+
+	trampoline = module_alloc(size + MCOUNT_INSN_SIZE + sizeof(void *));
+	if (!trampoline)
+		return 0;
+
+	ret = probe_kernel_read(trampoline, (void *)start_offset, size);
+	if (WARN_ON(ret < 0)) {
+		module_free(NULL, trampoline);
+		return 0;
+	}
+
+	ip = (unsigned long)trampoline + size;
+
+	jmp = ftrace_jmp_replace(ip, (unsigned long)ftrace_return);
+	memcpy(trampoline + size, jmp, MCOUNT_INSN_SIZE);
+
+	/*
+	 * Make the op pointer point directly to this ops.
+	 * Copy the ops address to the end of the trampoline.
+	 */
+
+	ptr = (unsigned long *)(trampoline + size + MCOUNT_INSN_SIZE);
+	*ptr = (unsigned long)ops;
+
+	op_offset -= start_offset;
+	memcpy(&op_ptr, trampoline + op_offset, OP_REF_SIZE);
+
+	/* Are we pointing to the reference? */
+	if (WARN_ON(memcmp(op_ptr.op, op_ref, 3) != 0)) {
+		module_free(NULL, trampoline);
+		return 0;
+	}
+
+	/* Load the contents of ptr into the callback parameter */
+	offset = (unsigned long)ptr;
+	offset -= (unsigned long)trampoline + op_offset + OP_REF_SIZE;
+
+	op_ptr.offset = offset;
+
+	/* put in the new offset to the ftrace_ops */
+	memcpy(trampoline + op_offset, &op_ptr, OP_REF_SIZE);
+
+	/* ALLOC_TRAMP flags lets us know we created it */
+	ops->flags |= FTRACE_OPS_FL_ALLOC_TRAMP;
+
+	return (unsigned long)trampoline;
+}
+
+void arch_ftrace_update_trampoline(struct ftrace_ops *ops)
+{
+	unsigned char *new;
+	unsigned long start_offset;
+	unsigned long call_offset;
+	unsigned long offset;
+	unsigned long ip;
+	int ret;
+
+	if (ops->trampoline) {
+		/*
+		 * The ftrace_ops caller may set up its own trampoline.
+		 * In such a case, this code must not modify it.
+		 */
+		if (!(ops->flags & FTRACE_OPS_FL_ALLOC_TRAMP))
+			return;
+	} else {
+		ops->trampoline = create_trampoline(ops);
+		if (!ops->trampoline)
+			return;
+	}
+
+	if (ops->flags & FTRACE_OPS_FL_SAVE_REGS) {
+		start_offset = (unsigned long)ftrace_regs_caller;
+		call_offset = (unsigned long)ftrace_regs_call;
+	} else {
+		start_offset = (unsigned long)ftrace_caller;
+		call_offset = (unsigned long)ftrace_call;
+	}
+
+	offset = call_offset - start_offset;
+	ip = ops->trampoline + offset;
+
+	/* Do a safe modify in case the trampoline is executing */
+	new = ftrace_call_replace(ip, (unsigned long)ops->func);
+	ret = update_ftrace_func(ip, new);
+
+	/* The update should never fail */
+	WARN_ON(ret);
+}
+#endif /* CONFIG_X86_64 */
+#endif /* CONFIG_DYNAMIC_FTRACE */
+
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+
+#ifdef CONFIG_DYNAMIC_FTRACE
+extern void ftrace_graph_call(void);
+
 static int ftrace_mod_jmp(unsigned long ip, void *func)
 {
 	unsigned char *new;
diff --git a/arch/x86/kernel/mcount_64.S b/arch/x86/kernel/mcount_64.S
index c73aecf10d34..39121b594a91 100644
--- a/arch/x86/kernel/mcount_64.S
+++ b/arch/x86/kernel/mcount_64.S
@@ -28,9 +28,11 @@ ENTRY(function_hook)
 END(function_hook)
 
 /* skip is set if stack has been adjusted */
-.macro ftrace_caller_setup skip=0
+.macro ftrace_caller_setup trace_label skip=0
 	MCOUNT_SAVE_FRAME \skip
 
+	/* Save this location */
+GLOBAL(\trace_label)
 	/* Load the ftrace_ops into the 3rd parameter */
 	movq function_trace_op(%rip), %rdx
 
@@ -45,8 +47,9 @@ END(function_hook)
 #endif
 .endm
 
+
 ENTRY(ftrace_caller)
-	ftrace_caller_setup
+	ftrace_caller_setup ftrace_caller_op_ptr
 	/* regs go into 4th parameter (but make it NULL) */
 	movq $0, %rcx
 
@@ -54,7 +57,14 @@ GLOBAL(ftrace_call)
 	call ftrace_stub
 
 	MCOUNT_RESTORE_FRAME
-ftrace_return:
+
+	/*
+	 * The copied trampoline must call ftrace_return as it
+	 * still may need to call the function graph tracer.
+	 */
+GLOBAL(ftrace_caller_end)
+
+GLOBAL(ftrace_return)
 
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 GLOBAL(ftrace_graph_call)
@@ -70,7 +80,7 @@ ENTRY(ftrace_regs_caller)
 	pushfq
 
 	/* skip=8 to skip flags saved in SS */
-	ftrace_caller_setup 8
+	ftrace_caller_setup ftrace_regs_caller_op_ptr 8
 
 	/* Save the rest of pt_regs */
 	movq %r15, R15(%rsp)
@@ -122,6 +132,14 @@ GLOBAL(ftrace_regs_call)
 	/* Restore flags */
 	popfq
 
+	/*
+	 * As the jmp to return can be a short jump we
+	 * it must not be copied into the trampoline.
+	 * The trampoline will add the code to jump
+	 * to the return.
+	 */
+GLOBAL(ftrace_regs_caller_end)
+
 	jmp ftrace_return
 
 	popfq
diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index ff860dbff75a..4e1a87a3341d 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -89,6 +89,13 @@ typedef void (*ftrace_func_t)(unsigned long ip, unsigned long parent_ip,
  * INITIALIZED - The ftrace_ops has already been initialized (first use time
  *            register_ftrace_function() is called, it will initialized the ops)
  * DELETED - The ops are being deleted, do not let them be registered again.
+ * ALLOC_TRAMP - A dynamic trampoline was allocated by the core code.
+ *            The arch specific code sets this flag when it allocated a
+ *            trampoline. This lets the arch know that it can update the
+ *            trampoline in case the callback function changes.
+ *            The ftrace_ops trampoline can be set by the ftrace users, and
+ *            in such cases the arch must not modify it. Only the arch ftrace
+ *            core code should set this flag.
  */
 enum {
 	FTRACE_OPS_FL_ENABLED			= 1 << 0,
@@ -100,6 +107,7 @@ enum {
 	FTRACE_OPS_FL_STUB			= 1 << 6,
 	FTRACE_OPS_FL_INITIALIZED		= 1 << 7,
 	FTRACE_OPS_FL_DELETED			= 1 << 8,
+	FTRACE_OPS_FL_ALLOC_TRAMP		= 1 << 9,
 };
 
 /*
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index e9f831f4e929..c3683d06f0b2 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -371,6 +371,8 @@ static int remove_ftrace_list_ops(struct ftrace_ops **list,
 	return ret;
 }
 
+static void ftrace_update_trampoline(struct ftrace_ops *ops);
+
 static int __register_ftrace_function(struct ftrace_ops *ops)
 {
 	if (ops->flags & FTRACE_OPS_FL_DELETED)
@@ -403,6 +405,8 @@ static int __register_ftrace_function(struct ftrace_ops *ops)
 	} else
 		add_ftrace_ops(&ftrace_ops_list, ops);
 
+	ftrace_update_trampoline(ops);
+
 	if (ftrace_enabled)
 		update_ftrace_function();
 
@@ -3882,6 +3886,9 @@ static char ftrace_graph_buf[FTRACE_FILTER_SIZE] __initdata;
 static char ftrace_graph_notrace_buf[FTRACE_FILTER_SIZE] __initdata;
 static int ftrace_set_func(unsigned long *array, int *idx, int size, char *buffer);
 
+static unsigned long save_global_trampoline;
+static unsigned long save_global_flags;
+
 static int __init set_graph_function(char *str)
 {
 	strlcpy(ftrace_graph_buf, str, FTRACE_FILTER_SIZE);
@@ -4600,6 +4607,20 @@ void __init ftrace_init(void)
 	ftrace_disabled = 1;
 }
 
+/* Do nothing if arch does not support this */
+void __weak arch_ftrace_update_trampoline(struct ftrace_ops *ops)
+{
+}
+
+static void ftrace_update_trampoline(struct ftrace_ops *ops)
+{
+	/* Currently, only non dynamic ops can have a trampoline */
+	if (ops->flags & FTRACE_OPS_FL_DYNAMIC)
+		return;
+
+	arch_ftrace_update_trampoline(ops);
+}
+
 #else
 
 static struct ftrace_ops global_ops = {
@@ -4642,6 +4663,10 @@ ftrace_ops_test(struct ftrace_ops *ops, unsigned long ip, void *regs)
 	return 1;
 }
 
+static void ftrace_update_trampoline(struct ftrace_ops *ops)
+{
+}
+
 #endif /* CONFIG_DYNAMIC_FTRACE */
 
 __init void ftrace_init_global_array_ops(struct trace_array *tr)
@@ -5351,6 +5376,13 @@ int register_ftrace_graph(trace_func_graph_ret_t retfunc,
 	global_ops.flags |= FTRACE_OPS_FL_STUB;
 
 #ifdef CONFIG_DYNAMIC_FTRACE
+	/* Save off the trampoline if there was one. */
+	save_global_trampoline = global_ops.trampoline;
+	save_global_flags = global_ops.flags;
+
+	/* Function graph does not allocate the trampoline */
+	global_ops.flags &= ~FTRACE_OPS_FL_ALLOC_TRAMP;
+
 	/* Optimize function graph calling (if implemented by arch) */
 	global_ops.trampoline = FTRACE_GRAPH_ADDR;
 #endif
@@ -5375,12 +5407,20 @@ void unregister_ftrace_graph(void)
 	__ftrace_graph_entry = ftrace_graph_entry_stub;
 	ftrace_shutdown(&global_ops, FTRACE_STOP_FUNC_RET);
 	global_ops.flags &= ~FTRACE_OPS_FL_STUB;
-#ifdef CONFIG_DYNAMIC_FTRACE
-	global_ops.trampoline = 0;
-#endif
 	unregister_pm_notifier(&ftrace_suspend_notifier);
 	unregister_trace_sched_switch(ftrace_graph_probe_sched_switch, NULL);
 
+#ifdef CONFIG_DYNAMIC_FTRACE
+	/*
+	 * Function graph does not allocate the trampoline, but
+	 * other global_ops do. We need to reset the ALLOC_TRAMP flag
+	 * if one was used.
+	 */
+	global_ops.trampoline = save_global_trampoline;
+	if (save_global_flags & FTRACE_OPS_FL_ALLOC_TRAMP)
+		global_ops.flags |= FTRACE_OPS_FL_ALLOC_TRAMP;
+#endif
+
  out:
 	mutex_unlock(&ftrace_lock);
 }
-- 
2.0.0


