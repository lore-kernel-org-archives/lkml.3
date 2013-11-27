Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756793Ab3K0GXD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 01:23:03 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:50663 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545Ab3K0GUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 01:20:11 -0500
X-AuditID: 9c930197-b7caaae000001cef-ae-52958f172958
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
Subject: [PATCH 08/17] tracing/probes: Split [ku]probes_fetch_type_table
Date: Wed, 27 Nov 2013 15:19:54 +0900
Message-Id: <1385533203-10014-9-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1385533203-10014-1-git-send-email-namhyung@kernel.org>
References: <1385533203-10014-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Use separate fetch_type_table for kprobes and uprobes.  It currently
shares all fetch methods but some of them will be implemented
differently later.

Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 kernel/trace/trace_kprobe.c | 18 +++++++++++
 kernel/trace/trace_probe.c  | 64 ++++++++++++++++-----------------------
 kernel/trace/trace_probe.h  | 73 ++++++++++++++++++++++++++++++++++++++-------
 kernel/trace/trace_uprobe.c | 18 +++++++++++
 4 files changed, 123 insertions(+), 50 deletions(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index a8129dfa36bb..0b3fccb910b4 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -88,6 +88,24 @@ static int kprobe_dispatcher(struct kprobe *kp, struct pt_regs *regs);
 static int kretprobe_dispatcher(struct kretprobe_instance *ri,
 				struct pt_regs *regs);
 
+/* Fetch type information table */
+const struct fetch_type kprobes_fetch_type_table[] = {
+	/* Special types */
+	[FETCH_TYPE_STRING] = __ASSIGN_FETCH_TYPE("string", string, string,
+					sizeof(u32), 1, "__data_loc char[]"),
+	[FETCH_TYPE_STRSIZE] = __ASSIGN_FETCH_TYPE("string_size", u32,
+					string_size, sizeof(u32), 0, "u32"),
+	/* Basic types */
+	ASSIGN_FETCH_TYPE(u8,  u8,  0),
+	ASSIGN_FETCH_TYPE(u16, u16, 0),
+	ASSIGN_FETCH_TYPE(u32, u32, 0),
+	ASSIGN_FETCH_TYPE(u64, u64, 0),
+	ASSIGN_FETCH_TYPE(s8,  u8,  1),
+	ASSIGN_FETCH_TYPE(s16, u16, 1),
+	ASSIGN_FETCH_TYPE(s32, u32, 1),
+	ASSIGN_FETCH_TYPE(s64, u64, 1),
+};
+
 /*
  * Allocate new trace_probe and initialize it (including kprobes).
  */
diff --git a/kernel/trace/trace_probe.c b/kernel/trace/trace_probe.c
index a34e3fca4071..c76f4a38d50d 100644
--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -54,10 +54,6 @@ DEFINE_BASIC_PRINT_TYPE_FUNC(s16, "%d")
 DEFINE_BASIC_PRINT_TYPE_FUNC(s32, "%d")
 DEFINE_BASIC_PRINT_TYPE_FUNC(s64, "%Ld")
 
-/* For defining macros, define string/string_size types */
-typedef u32 string;
-typedef u32 string_size;
-
 /* Print type function for string type */
 __kprobes int PRINT_TYPE_FUNC_NAME(string)(struct trace_seq *s,
 						  const char *name,
@@ -74,7 +70,6 @@ __kprobes int PRINT_TYPE_FUNC_NAME(string)(struct trace_seq *s,
 
 const char PRINT_TYPE_FMT_NAME(string)[] = "\\\"%s\\\"";
 
-#define FETCH_FUNC_NAME(method, type)	fetch_##method##_##type
 /*
  * Define macro for basic types - we don't need to define s* types, because
  * we have to care only about bitwidth at recording time.
@@ -359,25 +354,8 @@ free_bitfield_fetch_param(struct bitfield_fetch_param *data)
 	kfree(data);
 }
 
-/* Fetch type information table */
-static const struct fetch_type fetch_type_table[] = {
-	/* Special types */
-	[FETCH_TYPE_STRING] = __ASSIGN_FETCH_TYPE("string", string, string,
-					sizeof(u32), 1, "__data_loc char[]"),
-	[FETCH_TYPE_STRSIZE] = __ASSIGN_FETCH_TYPE("string_size", u32,
-					string_size, sizeof(u32), 0, "u32"),
-	/* Basic types */
-	ASSIGN_FETCH_TYPE(u8,  u8,  0),
-	ASSIGN_FETCH_TYPE(u16, u16, 0),
-	ASSIGN_FETCH_TYPE(u32, u32, 0),
-	ASSIGN_FETCH_TYPE(u64, u64, 0),
-	ASSIGN_FETCH_TYPE(s8,  u8,  1),
-	ASSIGN_FETCH_TYPE(s16, u16, 1),
-	ASSIGN_FETCH_TYPE(s32, u32, 1),
-	ASSIGN_FETCH_TYPE(s64, u64, 1),
-};
-
-static const struct fetch_type *find_fetch_type(const char *type)
+static const struct fetch_type *find_fetch_type(const char *type,
+						const struct fetch_type *ftbl)
 {
 	int i;
 
@@ -398,21 +376,21 @@ static const struct fetch_type *find_fetch_type(const char *type)
 
 		switch (bs) {
 		case 8:
-			return find_fetch_type("u8");
+			return find_fetch_type("u8", ftbl);
 		case 16:
-			return find_fetch_type("u16");
+			return find_fetch_type("u16", ftbl);
 		case 32:
-			return find_fetch_type("u32");
+			return find_fetch_type("u32", ftbl);
 		case 64:
-			return find_fetch_type("u64");
+			return find_fetch_type("u64", ftbl);
 		default:
 			goto fail;
 		}
 	}
 
-	for (i = 0; i < ARRAY_SIZE(fetch_type_table); i++)
-		if (strcmp(type, fetch_type_table[i].name) == 0)
-			return &fetch_type_table[i];
+	for (i = 0; i < NR_FETCH_TYPES; i++)
+		if (strcmp(type, ftbl[i].name) == 0)
+			return &ftbl[i];
 
 fail:
 	return NULL;
@@ -426,16 +404,17 @@ static __kprobes void fetch_stack_address(struct pt_regs *regs,
 }
 
 static fetch_func_t get_fetch_size_function(const struct fetch_type *type,
-					fetch_func_t orig_fn)
+					    fetch_func_t orig_fn,
+					    const struct fetch_type *ftbl)
 {
 	int i;
 
-	if (type != &fetch_type_table[FETCH_TYPE_STRING])
+	if (type != &ftbl[FETCH_TYPE_STRING])
 		return NULL;	/* Only string type needs size function */
 
 	for (i = 0; i < FETCH_MTD_END; i++)
 		if (type->fetch[i] == orig_fn)
-			return fetch_type_table[FETCH_TYPE_STRSIZE].fetch[i];
+			return ftbl[FETCH_TYPE_STRSIZE].fetch[i];
 
 	WARN_ON(1);	/* This should not happen */
 
@@ -504,12 +483,14 @@ static int parse_probe_vars(char *arg, const struct fetch_type *t,
 static int parse_probe_arg(char *arg, const struct fetch_type *t,
 		     struct fetch_param *f, bool is_return, bool is_kprobe)
 {
+	const struct fetch_type *ftbl;
 	unsigned long param;
 	long offset;
 	char *tmp;
-	int ret;
+	int ret = 0;
 
-	ret = 0;
+	ftbl = is_kprobe ? kprobes_fetch_type_table : uprobes_fetch_type_table;
+	BUG_ON(ftbl == NULL);
 
 	/* Until uprobe_events supports only reg arguments */
 	if (!is_kprobe && arg[0] != '%')
@@ -568,7 +549,7 @@ static int parse_probe_arg(char *arg, const struct fetch_type *t,
 			struct deref_fetch_param	*dprm;
 			const struct fetch_type		*t2;
 
-			t2 = find_fetch_type(NULL);
+			t2 = find_fetch_type(NULL, ftbl);
 			*tmp = '\0';
 			dprm = kzalloc(sizeof(struct deref_fetch_param), GFP_KERNEL);
 
@@ -637,9 +618,13 @@ static int __parse_bitfield_probe_arg(const char *bf,
 int traceprobe_parse_probe_arg(char *arg, ssize_t *size,
 		struct probe_arg *parg, bool is_return, bool is_kprobe)
 {
+	const struct fetch_type *ftbl;
 	const char *t;
 	int ret;
 
+	ftbl = is_kprobe ? kprobes_fetch_type_table : uprobes_fetch_type_table;
+	BUG_ON(ftbl == NULL);
+
 	if (strlen(arg) > MAX_ARGSTR_LEN) {
 		pr_info("Argument is too long.: %s\n",  arg);
 		return -ENOSPC;
@@ -654,7 +639,7 @@ int traceprobe_parse_probe_arg(char *arg, ssize_t *size,
 		arg[t - parg->comm] = '\0';
 		t++;
 	}
-	parg->type = find_fetch_type(t);
+	parg->type = find_fetch_type(t, ftbl);
 	if (!parg->type) {
 		pr_info("Unsupported type: %s\n", t);
 		return -EINVAL;
@@ -668,7 +653,8 @@ int traceprobe_parse_probe_arg(char *arg, ssize_t *size,
 
 	if (ret >= 0) {
 		parg->fetch_size.fn = get_fetch_size_function(parg->type,
-							      parg->fetch.fn);
+							      parg->fetch.fn,
+							      ftbl);
 		parg->fetch_size.data = parg->fetch.data;
 	}
 
diff --git a/kernel/trace/trace_probe.h b/kernel/trace/trace_probe.h
index 7c6be146f444..0ad019bb3df5 100644
--- a/kernel/trace/trace_probe.h
+++ b/kernel/trace/trace_probe.h
@@ -126,24 +126,70 @@ struct fetch_param {
 	void 			*data;
 };
 
+/* For defining macros, define string/string_size types */
+typedef u32 string;
+typedef u32 string_size;
+
 #define PRINT_TYPE_FUNC_NAME(type)	print_type_##type
 #define PRINT_TYPE_FMT_NAME(type)	print_type_format_##type
 
 /* Printing  in basic type function template */
-#define DECLARE_BASIC_PRINT_TYPE_FUNC(type, fmt)			\
+#define DECLARE_BASIC_PRINT_TYPE_FUNC(type)				\
 __kprobes int PRINT_TYPE_FUNC_NAME(type)(struct trace_seq *s,		\
 					 const char *name,		\
 					 void *data, void *ent);	\
-extern const char PRINT_TYPE_FMT_NAME(type)[];
-
-DECLARE_BASIC_PRINT_TYPE_FUNC(u8 , "%x")
-DECLARE_BASIC_PRINT_TYPE_FUNC(u16, "%x")
-DECLARE_BASIC_PRINT_TYPE_FUNC(u32, "%x")
-DECLARE_BASIC_PRINT_TYPE_FUNC(u64, "%Lx")
-DECLARE_BASIC_PRINT_TYPE_FUNC(s8,  "%d")
-DECLARE_BASIC_PRINT_TYPE_FUNC(s16, "%d")
-DECLARE_BASIC_PRINT_TYPE_FUNC(s32, "%d")
-DECLARE_BASIC_PRINT_TYPE_FUNC(s64, "%Ld")
+extern const char PRINT_TYPE_FMT_NAME(type)[]
+
+DECLARE_BASIC_PRINT_TYPE_FUNC(u8);
+DECLARE_BASIC_PRINT_TYPE_FUNC(u16);
+DECLARE_BASIC_PRINT_TYPE_FUNC(u32);
+DECLARE_BASIC_PRINT_TYPE_FUNC(u64);
+DECLARE_BASIC_PRINT_TYPE_FUNC(s8);
+DECLARE_BASIC_PRINT_TYPE_FUNC(s16);
+DECLARE_BASIC_PRINT_TYPE_FUNC(s32);
+DECLARE_BASIC_PRINT_TYPE_FUNC(s64);
+DECLARE_BASIC_PRINT_TYPE_FUNC(string);
+
+#define FETCH_FUNC_NAME(method, type)	fetch_##method##_##type
+
+/* Declare macro for basic types */
+#define DECLARE_FETCH_FUNC(method, type)				\
+extern void FETCH_FUNC_NAME(method, type)(struct pt_regs *regs, 	\
+					  void *data, void *dest)
+
+#define DECLARE_BASIC_FETCH_FUNCS(method) 	\
+DECLARE_FETCH_FUNC(method, u8);			\
+DECLARE_FETCH_FUNC(method, u16);		\
+DECLARE_FETCH_FUNC(method, u32);		\
+DECLARE_FETCH_FUNC(method, u64)
+
+DECLARE_BASIC_FETCH_FUNCS(reg);
+#define fetch_reg_string			NULL
+#define fetch_reg_string_size			NULL
+
+DECLARE_BASIC_FETCH_FUNCS(stack);
+#define fetch_stack_string			NULL
+#define fetch_stack_string_size			NULL
+
+DECLARE_BASIC_FETCH_FUNCS(retval);
+#define fetch_retval_string			NULL
+#define fetch_retval_string_size		NULL
+
+DECLARE_BASIC_FETCH_FUNCS(memory);
+DECLARE_FETCH_FUNC(memory, string);
+DECLARE_FETCH_FUNC(memory, string_size);
+
+DECLARE_BASIC_FETCH_FUNCS(symbol);
+DECLARE_FETCH_FUNC(symbol, string);
+DECLARE_FETCH_FUNC(symbol, string_size);
+
+DECLARE_BASIC_FETCH_FUNCS(deref);
+DECLARE_FETCH_FUNC(deref, string);
+DECLARE_FETCH_FUNC(deref, string_size);
+
+DECLARE_BASIC_FETCH_FUNCS(bitfield);
+#define fetch_bitfield_string			NULL
+#define fetch_bitfield_string_size		NULL
 
 /* Default (unsigned long) fetch type */
 #define __DEFAULT_FETCH_TYPE(t) u##t
@@ -178,6 +224,11 @@ ASSIGN_FETCH_FUNC(bitfield, ftype),			\
 #define FETCH_TYPE_STRING	0
 #define FETCH_TYPE_STRSIZE	1
 
+#define NR_FETCH_TYPES		10
+
+/* Fetch type information table */
+extern __weak const struct fetch_type kprobes_fetch_type_table[];
+extern __weak const struct fetch_type uprobes_fetch_type_table[];
 
 struct probe_arg {
 	struct fetch_param	fetch;
diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index 0711f7b2dae5..8c9b1a1c4c0b 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -74,6 +74,24 @@ static int uprobe_dispatcher(struct uprobe_consumer *con, struct pt_regs *regs);
 static int uretprobe_dispatcher(struct uprobe_consumer *con,
 				unsigned long func, struct pt_regs *regs);
 
+/* Fetch type information table */
+const struct fetch_type uprobes_fetch_type_table[] = {
+	/* Special types */
+	[FETCH_TYPE_STRING] = __ASSIGN_FETCH_TYPE("string", string, string,
+					sizeof(u32), 1, "__data_loc char[]"),
+	[FETCH_TYPE_STRSIZE] = __ASSIGN_FETCH_TYPE("string_size", u32,
+					string_size, sizeof(u32), 0, "u32"),
+	/* Basic types */
+	ASSIGN_FETCH_TYPE(u8,  u8,  0),
+	ASSIGN_FETCH_TYPE(u16, u16, 0),
+	ASSIGN_FETCH_TYPE(u32, u32, 0),
+	ASSIGN_FETCH_TYPE(u64, u64, 0),
+	ASSIGN_FETCH_TYPE(s8,  u8,  1),
+	ASSIGN_FETCH_TYPE(s16, u16, 1),
+	ASSIGN_FETCH_TYPE(s32, u32, 1),
+	ASSIGN_FETCH_TYPE(s64, u64, 1),
+};
+
 static inline void init_trace_uprobe_filter(struct trace_uprobe_filter *filter)
 {
 	rwlock_init(&filter->rwlock);
-- 
1.7.11.7

