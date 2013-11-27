Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756747Ab3K0GW5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 01:22:57 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:56223 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752813Ab3K0GUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 01:20:11 -0500
X-AuditID: 9c930197-b7caaae000001cef-b0-52958f17fa34
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>, Oleg Nesterov <oleg@redhat.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Hyeoncheol Lee <cheol.lee@lge.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Hemant Kumar <hkshaw@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 09/17] tracing/probes: Implement 'stack' fetch method for uprobes
Date: Wed, 27 Nov 2013 15:19:55 +0900
Message-Id: <1385533203-10014-10-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1385533203-10014-1-git-send-email-namhyung@kernel.org>
References: <1385533203-10014-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Use separate method to fetch from stack.  Move existing functions to
trace_kprobe.c and make them static.  Also add new stack fetch
implementation for uprobes.

Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
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
index 0b3fccb910b4..03a79db63a3f 100644
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
index c76f4a38d50d..6d2d1c0b9a26 100644
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
index 0ad019bb3df5..a2dfa7e048dc 100644
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
index 8c9b1a1c4c0b..7829bcdb020c 100644
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
1.7.11.7

