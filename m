Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755274AbaGCUXb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 16:23:31 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:23879 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750855AbaGCUX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 16:23:27 -0400
Message-Id: <20140703202325.031873166@goodmis.org>
User-Agent: quilt/0.63-1
Date: Thu, 03 Jul 2014 16:07:52 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Namhyung Kim <namhyung@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Oleg Nesterov <oleg@redhat.com>, Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Seth Jennings <sjenning@redhat.com>,
        Jiri Slaby <jslaby@suse.cz>, "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [RFC][PATCH 2/3] ftrace/x86: Show trampoline call function in enabled_functions
References: <20140703200750.648550267@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0002-ftrace-x86-Show-trampoline-call-function-in-enabled_.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

The file /sys/kernel/debug/tracing/eneabled_functions is used to debug
ftrace function hooks. Add to the output what function is being called
by the trampoline if the arch supports it.

Add support for this feature in x86_64.

Cc: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/ftrace.c | 97 ++++++++++++++++++++++++++++++++++++++++++------
 kernel/trace/ftrace.c    | 22 ++++++++++-
 2 files changed, 105 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index fcc256a33c1d..50de611d44b4 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -49,7 +49,7 @@ int ftrace_arch_code_modify_post_process(void)
 union ftrace_code_union {
 	char code[MCOUNT_INSN_SIZE];
 	struct {
-		char e8;
+		unsigned char e8;
 		int offset;
 	} __attribute__((packed));
 };
@@ -762,11 +762,25 @@ static unsigned long create_trampoline(struct ftrace_ops *ops)
 	return (unsigned long)trampoline;
 }
 
-void arch_ftrace_update_trampoline(struct ftrace_ops *ops)
+static unsigned long calc_trampoline_call_offset(bool save_regs)
 {
-	unsigned char *new;
 	unsigned long start_offset;
 	unsigned long call_offset;
+
+	if (save_regs) {
+		start_offset = (unsigned long)ftrace_regs_caller;
+		call_offset = (unsigned long)ftrace_regs_call;
+	} else {
+		start_offset = (unsigned long)ftrace_caller;
+		call_offset = (unsigned long)ftrace_call;
+	}
+
+	return call_offset - start_offset;
+}
+
+void arch_ftrace_update_trampoline(struct ftrace_ops *ops)
+{
+	unsigned char *new;
 	unsigned long offset;
 	unsigned long ip;
 	int ret;
@@ -784,15 +798,7 @@ void arch_ftrace_update_trampoline(struct ftrace_ops *ops)
 			return;
 	}
 
-	if (ops->flags & FTRACE_OPS_FL_SAVE_REGS) {
-		start_offset = (unsigned long)ftrace_regs_caller;
-		call_offset = (unsigned long)ftrace_regs_call;
-	} else {
-		start_offset = (unsigned long)ftrace_caller;
-		call_offset = (unsigned long)ftrace_call;
-	}
-
-	offset = call_offset - start_offset;
+	offset = calc_trampoline_call_offset(ops->flags & FTRACE_OPS_FL_SAVE_REGS);
 	ip = ops->trampoline + offset;
 
 	/* Do a safe modify in case the trampoline is executing */
@@ -802,6 +808,73 @@ void arch_ftrace_update_trampoline(struct ftrace_ops *ops)
 	/* The update should never fail */
 	WARN_ON(ret);
 }
+
+/* Return the address of the function the trampoline calls */
+static void *addr_from_call(void *ptr)
+{
+	union ftrace_code_union calc;
+	int ret;
+
+	ret = probe_kernel_read(&calc, ptr, MCOUNT_INSN_SIZE);
+	if (WARN_ON_ONCE(ret < 0))
+		return NULL;
+
+	/* Make sure this is a call */
+	if (WARN_ON_ONCE(calc.e8 != 0xe8)) {
+		pr_warn("Expected e8, got %lx\n", calc.e8);
+		return NULL;
+	}
+
+	return ptr + MCOUNT_INSN_SIZE + calc.offset;
+}
+
+void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr,
+			   unsigned long frame_pointer);
+
+/*
+ * If the ops->trampoline was not allocated, then it probably
+ * has a static trampoline func, or is the ftrace caller itself.
+ */
+static void *static_tramp_func(struct ftrace_ops *ops, struct dyn_ftrace *rec)
+{
+	unsigned long offset;
+	bool save_regs = rec->flags & FTRACE_FL_REGS_EN;
+	void *ptr;
+
+	if (ops && ops->trampoline) {
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+		/*
+		 * We only know about function graph tracer setting as static
+		 * trampoline.
+		 */
+		if (ops->trampoline == FTRACE_GRAPH_ADDR)
+			return (void *)prepare_ftrace_return;
+#endif
+		return NULL;
+	}
+
+	offset = calc_trampoline_call_offset(save_regs);
+
+	if (save_regs)
+		ptr = (void *)FTRACE_REGS_ADDR + offset;
+	else
+		ptr = (void *)FTRACE_ADDR + offset;
+
+	return addr_from_call(ptr);
+}
+
+void *arch_ftrace_trampoline_func(struct ftrace_ops *ops, struct dyn_ftrace *rec)
+{
+	unsigned long offset;
+
+	if (!ops || !(ops->flags & FTRACE_OPS_FL_ALLOC_TRAMP))
+		return static_tramp_func(ops, rec);
+
+	offset = calc_trampoline_call_offset(ops->flags & FTRACE_OPS_FL_SAVE_REGS);
+	return addr_from_call((void *)ops->trampoline + offset);
+}
+
+
 #endif /* CONFIG_X86_64 */
 #endif /* CONFIG_DYNAMIC_FTRACE */
 
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index c3683d06f0b2..66cbb3b7251d 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2868,6 +2868,22 @@ static void t_stop(struct seq_file *m, void *p)
 	mutex_unlock(&ftrace_lock);
 }
 
+void * __weak
+arch_ftrace_trampoline_func(struct ftrace_ops *ops, struct dyn_ftrace *rec)
+{
+	return NULL;
+}
+
+static void add_trampoline_func(struct seq_file *m, struct ftrace_ops *ops,
+				struct dyn_ftrace *rec)
+{
+	void *ptr;
+
+	ptr = arch_ftrace_trampoline_func(ops, rec);
+	if (ptr)
+		seq_printf(m, " ->%pS", ptr);
+}
+
 static int t_show(struct seq_file *m, void *v)
 {
 	struct ftrace_iterator *iter = m->private;
@@ -2891,19 +2907,21 @@ static int t_show(struct seq_file *m, void *v)
 
 	seq_printf(m, "%ps", (void *)rec->ip);
 	if (iter->flags & FTRACE_ITER_ENABLED) {
+		struct ftrace_ops *ops = NULL;
+
 		seq_printf(m, " (%ld)%s",
 			   ftrace_rec_count(rec),
 			   rec->flags & FTRACE_FL_REGS ? " R" : "  ");
 		if (rec->flags & FTRACE_FL_TRAMP_EN) {
-			struct ftrace_ops *ops;
-
 			ops = ftrace_find_tramp_ops_curr(rec);
 			if (ops && ops->trampoline)
 				seq_printf(m, "\ttramp: %pS",
 					   (void *)ops->trampoline);
 			else
 				seq_printf(m, "\ttramp: ERROR!");
+
 		}
+		add_trampoline_func(m, ops, rec);
 	}	
 
 	seq_printf(m, "\n");
-- 
2.0.0


