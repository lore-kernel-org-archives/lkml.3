Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754271AbaACCQE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 21:16:04 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:36344 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751788AbaACCLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 21:11:46 -0500
Message-Id: <20140103021145.815573809@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 02 Jan 2014 21:10:30 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [for-next][PATCH 09/17] tracing/probes: Implement stack fetch method for uprobes
References: <20140103021021.238772653@goodmis.org>
Content-Disposition: inline; filename=0009-tracing-probes-Implement-stack-fetch-method-for-upro.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Use separate method to fetch from stack.  Move existing functions to
trace_kprobe.c and make them static.  Also add new stack fetch
implementation for uprobes.

Acked-by: Oleg Nesterov <oleg@redhat.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 kernel/trace/trace_kprobe.c | 15 +++++++++++++++
 kernel/trace/trace_probe.c  | 22 ----------------------
 kernel/trace/trace_probe.h  | 14 ++++++++++----
 kernel/trace/trace_uprobe.c | 41 +++++++++++++++++++++++++++++++++++++++++
 4 files changed, 66 insertions(+), 26 deletions(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index fe3f00c..389f9e4 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -88,6 +88,21 @@ static int kprobe_dispatcher(struct kprobe *kp, struct pt_regs *regs);
 static int kretprobe_dispatcher(struct kretprobe_instance *ri,
 				struct pt_regs *regs);
 
+/*
+ * Kprobes-specific fetch functions
+ */
+#define DEFINE_FETCH_stack(type)					\
+static __kprobes void FETCH_FUNC_NAME(stack, type)(struct pt_regs *regs,\
+					  void *offset, void *dest)	\
+{									\
+	*(type *)dest = (type)regs_get_kernel_stack_nth(regs,		\
+				(unsigned int)((unsigned long)offset));	\
+}
+DEFINE_BASIC_FETCH_FUNCS(stack)
+/* No string on the stack entry */
+#define fetch_stack_string	NULL
+#define fetch_stack_string_size	NULL
+
 /* Fetch type information table */
 const struct fetch_type kprobes_fetch_type_table[] = {
 	/* Special types */
diff --git a/kernel/trace/trace_probe.c b/kernel/trace/trace_probe.c
index 541036e..77aa7d1 100644
--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -70,16 +70,6 @@ __kprobes int PRINT_TYPE_FUNC_NAME(string)(struct trace_seq *s,
 
 const char PRINT_TYPE_FMT_NAME(string)[] = "\\\"%s\\\"";
 
-/*
- * Define macro for basic types - we don't need to define s* types, because
- * we have to care only about bitwidth at recording time.
- */
-#define DEFINE_BASIC_FETCH_FUNCS(method) \
-DEFINE_FETCH_##method(u8)		\
-DEFINE_FETCH_##method(u16)		\
-DEFINE_FETCH_##method(u32)		\
-DEFINE_FETCH_##method(u64)
-
 #define CHECK_FETCH_FUNCS(method, fn)			\
 	(((FETCH_FUNC_NAME(method, u8) == fn) ||	\
 	  (FETCH_FUNC_NAME(method, u16) == fn) ||	\
@@ -102,18 +92,6 @@ DEFINE_BASIC_FETCH_FUNCS(reg)
 #define fetch_reg_string	NULL
 #define fetch_reg_string_size	NULL
 
-#define DEFINE_FETCH_stack(type)					\
-__kprobes void FETCH_FUNC_NAME(stack, type)(struct pt_regs *regs,	\
-					  void *offset, void *dest)	\
-{									\
-	*(type *)dest = (type)regs_get_kernel_stack_nth(regs,		\
-				(unsigned int)((unsigned long)offset));	\
-}
-DEFINE_BASIC_FETCH_FUNCS(stack)
-/* No string on the stack entry */
-#define fetch_stack_string	NULL
-#define fetch_stack_string_size	NULL
-
 #define DEFINE_FETCH_retval(type)					\
 __kprobes void FETCH_FUNC_NAME(retval, type)(struct pt_regs *regs,	\
 					  void *dummy, void *dest)	\
diff --git a/kernel/trace/trace_probe.h b/kernel/trace/trace_probe.h
index 5b77798..8211dd6 100644
--- a/kernel/trace/trace_probe.h
+++ b/kernel/trace/trace_probe.h
@@ -167,10 +167,6 @@ DECLARE_BASIC_FETCH_FUNCS(reg);
 #define fetch_reg_string			NULL
 #define fetch_reg_string_size			NULL
 
-DECLARE_BASIC_FETCH_FUNCS(stack);
-#define fetch_stack_string			NULL
-#define fetch_stack_string_size			NULL
-
 DECLARE_BASIC_FETCH_FUNCS(retval);
 #define fetch_retval_string			NULL
 #define fetch_retval_string_size		NULL
@@ -191,6 +187,16 @@ DECLARE_BASIC_FETCH_FUNCS(bitfield);
 #define fetch_bitfield_string			NULL
 #define fetch_bitfield_string_size		NULL
 
+/*
+ * Define macro for basic types - we don't need to define s* types, because
+ * we have to care only about bitwidth at recording time.
+ */
+#define DEFINE_BASIC_FETCH_FUNCS(method) \
+DEFINE_FETCH_##method(u8)		\
+DEFINE_FETCH_##method(u16)		\
+DEFINE_FETCH_##method(u32)		\
+DEFINE_FETCH_##method(u64)
+
 /* Default (unsigned long) fetch type */
 #define __DEFAULT_FETCH_TYPE(t) u##t
 #define _DEFAULT_FETCH_TYPE(t) __DEFAULT_FETCH_TYPE(t)
diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index 2c60925..5395d37 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -74,6 +74,47 @@ static int uprobe_dispatcher(struct uprobe_consumer *con, struct pt_regs *regs);
 static int uretprobe_dispatcher(struct uprobe_consumer *con,
 				unsigned long func, struct pt_regs *regs);
 
+#ifdef CONFIG_STACK_GROWSUP
+static unsigned long adjust_stack_addr(unsigned long addr, unsigned int n)
+{
+	return addr - (n * sizeof(long));
+}
+#else
+static unsigned long adjust_stack_addr(unsigned long addr, unsigned int n)
+{
+	return addr + (n * sizeof(long));
+}
+#endif
+
+static unsigned long get_user_stack_nth(struct pt_regs *regs, unsigned int n)
+{
+	unsigned long ret;
+	unsigned long addr = user_stack_pointer(regs);
+
+	addr = adjust_stack_addr(addr, n);
+
+	if (copy_from_user(&ret, (void __force __user *) addr, sizeof(ret)))
+		return 0;
+
+	return ret;
+}
+
+/*
+ * Uprobes-specific fetch functions
+ */
+#define DEFINE_FETCH_stack(type)					\
+static __kprobes void FETCH_FUNC_NAME(stack, type)(struct pt_regs *regs,\
+					  void *offset, void *dest)	\
+{									\
+	*(type *)dest = (type)get_user_stack_nth(regs,			\
+					      ((unsigned long)offset)); \
+}
+DEFINE_BASIC_FETCH_FUNCS(stack)
+/* No string on the stack entry */
+#define fetch_stack_string	NULL
+#define fetch_stack_string_size	NULL
+
+
 /* Fetch type information table */
 const struct fetch_type uprobes_fetch_type_table[] = {
 	/* Special types */
-- 
1.8.4.3


