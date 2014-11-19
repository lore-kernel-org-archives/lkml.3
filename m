Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932847AbaKSXbi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 18:31:38 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:38185 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756319AbaKSX1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 18:27:12 -0500
Message-Id: <20141119232709.753684893@goodmis.org>
User-Agent: quilt/0.61-1
Date: Wed, 19 Nov 2014 18:26:35 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [for-next][PATCH 03/18] ftrace/x86/extable: Add is_ftrace_trampoline() function
References: <20141119232632.737569526@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0003-ftrace-x86-extable-Add-is_ftrace_trampoline-function.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Stack traces that happen from function tracing check if the address
on the stack is a __kernel_text_address(). That is, is the address
kernel code. This calls core_kernel_text() which returns true
if the address is part of the builtin kernel code. It also calls
is_module_text_address() which returns true if the address belongs
to module code.

But what is missing is ftrace dynamically allocated trampolines.
These trampolines are allocated for individual ftrace_ops that
call the ftrace_ops callback functions directly. But if they do a
stack trace, the code checking the stack wont detect them as they
are neither core kernel code nor module address space.

Adding another field to ftrace_ops that also stores the size of
the trampoline assigned to it we can create a new function called
is_ftrace_trampoline() that returns true if the address is a
dynamically allocate ftrace trampoline. Note, it ignores trampolines
that are not dynamically allocated as they will return true with
the core_kernel_text() function.

Link: http://lkml.kernel.org/r/20141119034829.497125839@goodmis.org

Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/ftrace.c |  9 +++++++--
 include/linux/ftrace.h   |  8 ++++++++
 kernel/extable.c         |  7 ++++++-
 kernel/trace/ftrace.c    | 38 ++++++++++++++++++++++++++++++++++++++
 4 files changed, 59 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 1aea94d336c7..60881d919432 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -712,7 +712,8 @@ union ftrace_op_code_union {
 	} __attribute__((packed));
 };
 
-static unsigned long create_trampoline(struct ftrace_ops *ops)
+static unsigned long
+create_trampoline(struct ftrace_ops *ops, unsigned int *tramp_size)
 {
 	unsigned const char *jmp;
 	unsigned long start_offset;
@@ -749,6 +750,8 @@ static unsigned long create_trampoline(struct ftrace_ops *ops)
 	if (!trampoline)
 		return 0;
 
+	*tramp_size = size + MCOUNT_INSN_SIZE + sizeof(void *);
+
 	/* Copy ftrace_caller onto the trampoline memory */
 	ret = probe_kernel_read(trampoline, (void *)start_offset, size);
 	if (WARN_ON(ret < 0)) {
@@ -819,6 +822,7 @@ void arch_ftrace_update_trampoline(struct ftrace_ops *ops)
 	unsigned char *new;
 	unsigned long offset;
 	unsigned long ip;
+	unsigned int size;
 	int ret;
 
 	if (ops->trampoline) {
@@ -829,9 +833,10 @@ void arch_ftrace_update_trampoline(struct ftrace_ops *ops)
 		if (!(ops->flags & FTRACE_OPS_FL_ALLOC_TRAMP))
 			return;
 	} else {
-		ops->trampoline = create_trampoline(ops);
+		ops->trampoline = create_trampoline(ops, &size);
 		if (!ops->trampoline)
 			return;
+		ops->trampoline_size = size;
 	}
 
 	offset = calc_trampoline_call_offset(ops->flags & FTRACE_OPS_FL_SAVE_REGS);
diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 619e37cc17fd..7b2616fa2472 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -150,6 +150,7 @@ struct ftrace_ops {
 	struct ftrace_ops_hash		*func_hash;
 	struct ftrace_ops_hash		old_hash;
 	unsigned long			trampoline;
+	unsigned long			trampoline_size;
 #endif
 };
 
@@ -297,6 +298,8 @@ extern int ftrace_text_reserved(const void *start, const void *end);
 
 extern int ftrace_nr_registered_ops(void);
 
+bool is_ftrace_trampoline(unsigned long addr);
+
 /*
  * The dyn_ftrace record's flags field is split into two parts.
  * the first part which is '0-FTRACE_REF_MAX' is a counter of
@@ -596,6 +599,11 @@ static inline ssize_t ftrace_notrace_write(struct file *file, const char __user
 			     size_t cnt, loff_t *ppos) { return -ENODEV; }
 static inline int
 ftrace_regex_release(struct inode *inode, struct file *file) { return -ENODEV; }
+
+static inline bool is_ftrace_trampoline(unsigned long addr)
+{
+	return false;
+}
 #endif /* CONFIG_DYNAMIC_FTRACE */
 
 /* totally disable ftrace - can not re-enable after this */
diff --git a/kernel/extable.c b/kernel/extable.c
index d8a6446adbcb..c98f926277a8 100644
--- a/kernel/extable.c
+++ b/kernel/extable.c
@@ -18,6 +18,7 @@
 #include <linux/ftrace.h>
 #include <linux/memory.h>
 #include <linux/module.h>
+#include <linux/ftrace.h>
 #include <linux/mutex.h>
 #include <linux/init.h>
 
@@ -102,6 +103,8 @@ int __kernel_text_address(unsigned long addr)
 		return 1;
 	if (is_module_text_address(addr))
 		return 1;
+	if (is_ftrace_trampoline(addr))
+		return 1;
 	/*
 	 * There might be init symbols in saved stacktraces.
 	 * Give those symbols a chance to be printed in
@@ -119,7 +122,9 @@ int kernel_text_address(unsigned long addr)
 {
 	if (core_kernel_text(addr))
 		return 1;
-	return is_module_text_address(addr);
+	if (is_module_text_address(addr))
+		return 1;
+	return is_ftrace_trampoline(addr);
 }
 
 /*
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 6233f9102179..fa0f36bb32e9 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1117,6 +1117,43 @@ static struct ftrace_ops global_ops = {
 					  FTRACE_OPS_FL_INITIALIZED,
 };
 
+/*
+ * This is used by __kernel_text_address() to return true if the
+ * the address is on a dynamically allocated trampoline that would
+ * not return true for either core_kernel_text() or
+ * is_module_text_address().
+ */
+bool is_ftrace_trampoline(unsigned long addr)
+{
+	struct ftrace_ops *op;
+	bool ret = false;
+
+	/*
+	 * Some of the ops may be dynamically allocated,
+	 * they are freed after a synchronize_sched().
+	 */
+	preempt_disable_notrace();
+
+	do_for_each_ftrace_op(op, ftrace_ops_list) {
+		/*
+		 * This is to check for dynamically allocated trampolines.
+		 * Trampolines that are in kernel text will have
+		 * core_kernel_text() return true.
+		 */
+		if (op->trampoline && op->trampoline_size)
+			if (addr >= op->trampoline &&
+			    addr < op->trampoline + op->trampoline_size) {
+				ret = true;
+				goto out;
+			}
+	} while_for_each_ftrace_op(op);
+
+ out:
+	preempt_enable_notrace();
+
+	return ret;
+}
+
 struct ftrace_page {
 	struct ftrace_page	*next;
 	struct dyn_ftrace	*records;
@@ -5373,6 +5410,7 @@ static struct ftrace_ops graph_ops = {
 				   FTRACE_OPS_FL_STUB,
 #ifdef FTRACE_GRAPH_TRAMP_ADDR
 	.trampoline		= FTRACE_GRAPH_TRAMP_ADDR,
+	/* trampoline_size is only needed for dynamically allocated tramps */
 #endif
 	ASSIGN_OPS_HASH(graph_ops, &global_ops.local_hash)
 };
-- 
2.1.1


