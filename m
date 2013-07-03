Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932854Ab3GCMjn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 08:39:43 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:65413 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755924Ab3GCMfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 08:35:51 -0400
X-AuditID: 9c93017e-b7c04ae00000295f-ea-51d41aa49dbc
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Hyeoncheol Lee <cheol.lee@lge.com>, LKML <linux-kernel@vger.kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [PATCH 01/12] tracing/kprobes: Move fetch functions to trace_kprobe.c
Date: Wed,  3 Jul 2013 21:35:35 +0900
Message-Id: <1372854946-17074-2-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1372854946-17074-1-git-send-email-namhyung@kernel.org>
References: <1372854946-17074-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hyeoncheol Lee <cheol.lee@lge.com>

Move kprobes-specific fetch functions to the trace_kprobe.c file.
Also define kprobes_fetch_type_table in the .c file.  This table is
shared with uprobes for now, but the uprobes will get its own table
in the later patch.

This is a preparation for supporting more fetch functions to uprobes
and no functional changes are intended.

Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Signed-off-by: Hyeoncheol Lee <cheol.lee@lge.com>
[namhyung@kernel.org: Split original patch into pieces as requested]
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 kernel/trace/trace_kprobe.c | 110 ++++++++++++++++++++
 kernel/trace/trace_probe.c  | 242 +++++++-------------------------------------
 kernel/trace/trace_probe.h  | 127 +++++++++++++++++++++++
 3 files changed, 272 insertions(+), 207 deletions(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 9f46e98ba8f2..de13465902b0 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -796,6 +796,116 @@ static const struct file_operations kprobe_profile_ops = {
 	.release        = seq_release,
 };
 
+/*
+ * kprobes-specific fetch functions
+ */
+#define DEFINE_FETCH_stack(type)					\
+__kprobes void FETCH_FUNC_NAME(stack, type)(struct pt_regs *regs,	\
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
+#define DEFINE_FETCH_memory(type)					\
+__kprobes void FETCH_FUNC_NAME(memory, type)(struct pt_regs *regs,	\
+					  void *addr, void *dest)	\
+{									\
+	type retval;							\
+	if (probe_kernel_address(addr, retval))				\
+		*(type *)dest = 0;					\
+	else								\
+		*(type *)dest = retval;					\
+}
+DEFINE_BASIC_FETCH_FUNCS(memory)
+/*
+ * Fetch a null-terminated string. Caller MUST set *(u32 *)dest with max
+ * length and relative data location.
+ */
+__kprobes void FETCH_FUNC_NAME(memory, string)(struct pt_regs *regs,
+					       void *addr, void *dest)
+{
+	long ret;
+	int maxlen = get_rloc_len(*(u32 *)dest);
+	u8 *dst = get_rloc_data(dest);
+	u8 *src = addr;
+	mm_segment_t old_fs = get_fs();
+
+	if (!maxlen)
+		return;
+
+	/*
+	 * Try to get string again, since the string can be changed while
+	 * probing.
+	 */
+	set_fs(KERNEL_DS);
+	pagefault_disable();
+
+	do
+		ret = __copy_from_user_inatomic(dst++, src++, 1);
+	while (dst[-1] && ret == 0 && src - (u8 *)addr < maxlen);
+
+	dst[-1] = '\0';
+	pagefault_enable();
+	set_fs(old_fs);
+
+	if (ret < 0) {	/* Failed to fetch string */
+		((u8 *)get_rloc_data(dest))[0] = '\0';
+		*(u32 *)dest = make_data_rloc(0, get_rloc_offs(*(u32 *)dest));
+	} else {
+		*(u32 *)dest = make_data_rloc(src - (u8 *)addr,
+					      get_rloc_offs(*(u32 *)dest));
+	}
+}
+
+/* Return the length of string -- including null terminal byte */
+__kprobes void FETCH_FUNC_NAME(memory, string_size)(struct pt_regs *regs,
+						    void *addr, void *dest)
+{
+	mm_segment_t old_fs;
+	int ret, len = 0;
+	u8 c;
+
+	old_fs = get_fs();
+	set_fs(KERNEL_DS);
+	pagefault_disable();
+
+	do {
+		ret = __copy_from_user_inatomic(&c, (u8 *)addr + len, 1);
+		len++;
+	} while (c && ret == 0 && len < MAX_STRING_SIZE);
+
+	pagefault_enable();
+	set_fs(old_fs);
+
+	if (ret < 0)	/* Failed to check the length */
+		*(u32 *)dest = 0;
+	else
+		*(u32 *)dest = len;
+}
+
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
 /* Sum up total data length for dynamic arraies (strings) */
 static __kprobes int __get_data_size(struct trace_probe *tp,
 				     struct pt_regs *regs)
diff --git a/kernel/trace/trace_probe.c b/kernel/trace/trace_probe.c
index 412e959709b4..c58c25d81591 100644
--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -35,19 +35,15 @@ const char *reserved_field_names[] = {
 	FIELD_STRING_FUNC,
 };
 
-/* Printing function type */
-#define PRINT_TYPE_FUNC_NAME(type)	print_type_##type
-#define PRINT_TYPE_FMT_NAME(type)	print_type_format_##type
-
 /* Printing  in basic type function template */
 #define DEFINE_BASIC_PRINT_TYPE_FUNC(type, fmt, cast)			\
-static __kprobes int PRINT_TYPE_FUNC_NAME(type)(struct trace_seq *s,	\
+__kprobes int PRINT_TYPE_FUNC_NAME(type)(struct trace_seq *s,		\
 						const char *name,	\
-						void *data, void *ent)\
+						void *data, void *ent)	\
 {									\
 	return trace_seq_printf(s, " %s=" fmt, name, (cast)*(type *)data);\
 }									\
-static const char PRINT_TYPE_FMT_NAME(type)[] = fmt;
+const char PRINT_TYPE_FMT_NAME(type)[] = fmt;
 
 DEFINE_BASIC_PRINT_TYPE_FUNC(u8, "%x", unsigned int)
 DEFINE_BASIC_PRINT_TYPE_FUNC(u16, "%x", unsigned int)
@@ -58,25 +54,10 @@ DEFINE_BASIC_PRINT_TYPE_FUNC(s16, "%d", int)
 DEFINE_BASIC_PRINT_TYPE_FUNC(s32, "%ld", long)
 DEFINE_BASIC_PRINT_TYPE_FUNC(s64, "%lld", long long)
 
-static inline void *get_rloc_data(u32 *dl)
-{
-	return (u8 *)dl + get_rloc_offs(*dl);
-}
-
-/* For data_loc conversion */
-static inline void *get_loc_data(u32 *dl, void *ent)
-{
-	return (u8 *)ent + get_rloc_offs(*dl);
-}
-
-/* For defining macros, define string/string_size types */
-typedef u32 string;
-typedef u32 string_size;
-
 /* Print type function for string type */
-static __kprobes int PRINT_TYPE_FUNC_NAME(string)(struct trace_seq *s,
-						  const char *name,
-						  void *data, void *ent)
+__kprobes int PRINT_TYPE_FUNC_NAME(string)(struct trace_seq *s,
+					   const char *name,
+					   void *data, void *ent)
 {
 	int len = *(u32 *)data >> 16;
 
@@ -87,140 +68,25 @@ static __kprobes int PRINT_TYPE_FUNC_NAME(string)(struct trace_seq *s,
 					(const char *)get_loc_data(data, ent));
 }
 
-static const char PRINT_TYPE_FMT_NAME(string)[] = "\\\"%s\\\"";
-
-#define FETCH_FUNC_NAME(method, type)	fetch_##method##_##type
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
-#define CHECK_FETCH_FUNCS(method, fn)			\
-	(((FETCH_FUNC_NAME(method, u8) == fn) ||	\
-	  (FETCH_FUNC_NAME(method, u16) == fn) ||	\
-	  (FETCH_FUNC_NAME(method, u32) == fn) ||	\
-	  (FETCH_FUNC_NAME(method, u64) == fn) ||	\
-	  (FETCH_FUNC_NAME(method, string) == fn) ||	\
-	  (FETCH_FUNC_NAME(method, string_size) == fn)) \
-	 && (fn != NULL))
+const char PRINT_TYPE_FMT_NAME(string)[] = "\\\"%s\\\"";
 
 /* Data fetch function templates */
 #define DEFINE_FETCH_reg(type)						\
-static __kprobes void FETCH_FUNC_NAME(reg, type)(struct pt_regs *regs,	\
+__kprobes void FETCH_FUNC_NAME(reg, type)(struct pt_regs *regs,		\
 					void *offset, void *dest)	\
 {									\
 	*(type *)dest = (type)regs_get_register(regs,			\
 				(unsigned int)((unsigned long)offset));	\
 }
 DEFINE_BASIC_FETCH_FUNCS(reg)
-/* No string on the register */
-#define fetch_reg_string	NULL
-#define fetch_reg_string_size	NULL
-
-#define DEFINE_FETCH_stack(type)					\
-static __kprobes void FETCH_FUNC_NAME(stack, type)(struct pt_regs *regs,\
-					  void *offset, void *dest)	\
-{									\
-	*(type *)dest = (type)regs_get_kernel_stack_nth(regs,		\
-				(unsigned int)((unsigned long)offset));	\
-}
-DEFINE_BASIC_FETCH_FUNCS(stack)
-/* No string on the stack entry */
-#define fetch_stack_string	NULL
-#define fetch_stack_string_size	NULL
 
 #define DEFINE_FETCH_retval(type)					\
-static __kprobes void FETCH_FUNC_NAME(retval, type)(struct pt_regs *regs,\
+__kprobes void FETCH_FUNC_NAME(retval, type)(struct pt_regs *regs,	\
 					  void *dummy, void *dest)	\
 {									\
 	*(type *)dest = (type)regs_return_value(regs);			\
 }
 DEFINE_BASIC_FETCH_FUNCS(retval)
-/* No string on the retval */
-#define fetch_retval_string		NULL
-#define fetch_retval_string_size	NULL
-
-#define DEFINE_FETCH_memory(type)					\
-static __kprobes void FETCH_FUNC_NAME(memory, type)(struct pt_regs *regs,\
-					  void *addr, void *dest)	\
-{									\
-	type retval;							\
-	if (probe_kernel_address(addr, retval))				\
-		*(type *)dest = 0;					\
-	else								\
-		*(type *)dest = retval;					\
-}
-DEFINE_BASIC_FETCH_FUNCS(memory)
-/*
- * Fetch a null-terminated string. Caller MUST set *(u32 *)dest with max
- * length and relative data location.
- */
-static __kprobes void FETCH_FUNC_NAME(memory, string)(struct pt_regs *regs,
-						      void *addr, void *dest)
-{
-	long ret;
-	int maxlen = get_rloc_len(*(u32 *)dest);
-	u8 *dst = get_rloc_data(dest);
-	u8 *src = addr;
-	mm_segment_t old_fs = get_fs();
-
-	if (!maxlen)
-		return;
-
-	/*
-	 * Try to get string again, since the string can be changed while
-	 * probing.
-	 */
-	set_fs(KERNEL_DS);
-	pagefault_disable();
-
-	do
-		ret = __copy_from_user_inatomic(dst++, src++, 1);
-	while (dst[-1] && ret == 0 && src - (u8 *)addr < maxlen);
-
-	dst[-1] = '\0';
-	pagefault_enable();
-	set_fs(old_fs);
-
-	if (ret < 0) {	/* Failed to fetch string */
-		((u8 *)get_rloc_data(dest))[0] = '\0';
-		*(u32 *)dest = make_data_rloc(0, get_rloc_offs(*(u32 *)dest));
-	} else {
-		*(u32 *)dest = make_data_rloc(src - (u8 *)addr,
-					      get_rloc_offs(*(u32 *)dest));
-	}
-}
-
-/* Return the length of string -- including null terminal byte */
-static __kprobes void FETCH_FUNC_NAME(memory, string_size)(struct pt_regs *regs,
-							void *addr, void *dest)
-{
-	mm_segment_t old_fs;
-	int ret, len = 0;
-	u8 c;
-
-	old_fs = get_fs();
-	set_fs(KERNEL_DS);
-	pagefault_disable();
-
-	do {
-		ret = __copy_from_user_inatomic(&c, (u8 *)addr + len, 1);
-		len++;
-	} while (c && ret == 0 && len < MAX_STRING_SIZE);
-
-	pagefault_enable();
-	set_fs(old_fs);
-
-	if (ret < 0)	/* Failed to check the length */
-		*(u32 *)dest = 0;
-	else
-		*(u32 *)dest = len;
-}
 
 /* Memory fetching by symbol */
 struct symbol_cache {
@@ -268,7 +134,7 @@ static struct symbol_cache *alloc_symbol_cache(const char *sym, long offset)
 }
 
 #define DEFINE_FETCH_symbol(type)					\
-static __kprobes void FETCH_FUNC_NAME(symbol, type)(struct pt_regs *regs,\
+__kprobes void FETCH_FUNC_NAME(symbol, type)(struct pt_regs *regs,	\
 					  void *data, void *dest)	\
 {									\
 	struct symbol_cache *sc = data;					\
@@ -288,7 +154,7 @@ struct deref_fetch_param {
 };
 
 #define DEFINE_FETCH_deref(type)					\
-static __kprobes void FETCH_FUNC_NAME(deref, type)(struct pt_regs *regs,\
+__kprobes void FETCH_FUNC_NAME(deref, type)(struct pt_regs *regs,	\
 					    void *data, void *dest)	\
 {									\
 	struct deref_fetch_param *dprm = data;				\
@@ -329,7 +195,7 @@ struct bitfield_fetch_param {
 };
 
 #define DEFINE_FETCH_bitfield(type)					\
-static __kprobes void FETCH_FUNC_NAME(bitfield, type)(struct pt_regs *regs,\
+__kprobes void FETCH_FUNC_NAME(bitfield, type)(struct pt_regs *regs,\
 					    void *data, void *dest)	\
 {									\
 	struct bitfield_fetch_param *bprm = data;			\
@@ -343,8 +209,6 @@ static __kprobes void FETCH_FUNC_NAME(bitfield, type)(struct pt_regs *regs,\
 }
 
 DEFINE_BASIC_FETCH_FUNCS(bitfield)
-#define fetch_bitfield_string		NULL
-#define fetch_bitfield_string_size	NULL
 
 static __kprobes void
 update_bitfield_fetch_param(struct bitfield_fetch_param *data)
@@ -380,52 +244,8 @@ free_bitfield_fetch_param(struct bitfield_fetch_param *data)
 #define DEFAULT_FETCH_TYPE _DEFAULT_FETCH_TYPE(BITS_PER_LONG)
 #define DEFAULT_FETCH_TYPE_STR __stringify(DEFAULT_FETCH_TYPE)
 
-#define ASSIGN_FETCH_FUNC(method, type)	\
-	[FETCH_MTD_##method] = FETCH_FUNC_NAME(method, type)
-
-#define __ASSIGN_FETCH_TYPE(_name, ptype, ftype, _size, sign, _fmttype)	\
-	{.name = _name,				\
-	 .size = _size,					\
-	 .is_signed = sign,				\
-	 .print = PRINT_TYPE_FUNC_NAME(ptype),		\
-	 .fmt = PRINT_TYPE_FMT_NAME(ptype),		\
-	 .fmttype = _fmttype,				\
-	 .fetch = {					\
-ASSIGN_FETCH_FUNC(reg, ftype),				\
-ASSIGN_FETCH_FUNC(stack, ftype),			\
-ASSIGN_FETCH_FUNC(retval, ftype),			\
-ASSIGN_FETCH_FUNC(memory, ftype),			\
-ASSIGN_FETCH_FUNC(symbol, ftype),			\
-ASSIGN_FETCH_FUNC(deref, ftype),			\
-ASSIGN_FETCH_FUNC(bitfield, ftype),			\
-	  }						\
-	}
-
-#define ASSIGN_FETCH_TYPE(ptype, ftype, sign)			\
-	__ASSIGN_FETCH_TYPE(#ptype, ptype, ftype, sizeof(ftype), sign, #ptype)
-
-#define FETCH_TYPE_STRING	0
-#define FETCH_TYPE_STRSIZE	1
-
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
+						const struct fetch_type *ttbl)
 {
 	int i;
 
@@ -446,21 +266,21 @@ static const struct fetch_type *find_fetch_type(const char *type)
 
 		switch (bs) {
 		case 8:
-			return find_fetch_type("u8");
+			return find_fetch_type("u8", ttbl);
 		case 16:
-			return find_fetch_type("u16");
+			return find_fetch_type("u16", ttbl);
 		case 32:
-			return find_fetch_type("u32");
+			return find_fetch_type("u32", ttbl);
 		case 64:
-			return find_fetch_type("u64");
+			return find_fetch_type("u64", ttbl);
 		default:
 			goto fail;
 		}
 	}
 
-	for (i = 0; i < ARRAY_SIZE(fetch_type_table); i++)
-		if (strcmp(type, fetch_type_table[i].name) == 0)
-			return &fetch_type_table[i];
+	for (i = 0; i < NR_FETCH_TYPES; i++)
+		if (strcmp(type, ttbl[i].name) == 0)
+			return &ttbl[i];
 
 fail:
 	return NULL;
@@ -474,16 +294,17 @@ static __kprobes void fetch_stack_address(struct pt_regs *regs,
 }
 
 static fetch_func_t get_fetch_size_function(const struct fetch_type *type,
-					fetch_func_t orig_fn)
+					    fetch_func_t orig_fn,
+					    const struct fetch_type *ttbl)
 {
 	int i;
 
-	if (type != &fetch_type_table[FETCH_TYPE_STRING])
+	if (type != &ttbl[FETCH_TYPE_STRING])
 		return NULL;	/* Only string type needs size function */
 
 	for (i = 0; i < FETCH_MTD_END; i++)
 		if (type->fetch[i] == orig_fn)
-			return fetch_type_table[FETCH_TYPE_STRSIZE].fetch[i];
+			return ttbl[FETCH_TYPE_STRSIZE].fetch[i];
 
 	WARN_ON(1);	/* This should not happen */
 
@@ -556,6 +377,9 @@ static int parse_probe_arg(char *arg, const struct fetch_type *t,
 	long offset;
 	char *tmp;
 	int ret;
+	const struct fetch_type *ttbl;
+
+	ttbl = kprobes_fetch_type_table;
 
 	ret = 0;
 
@@ -616,7 +440,7 @@ static int parse_probe_arg(char *arg, const struct fetch_type *t,
 			struct deref_fetch_param	*dprm;
 			const struct fetch_type		*t2;
 
-			t2 = find_fetch_type(NULL);
+			t2 = find_fetch_type(NULL, ttbl);
 			*tmp = '\0';
 			dprm = kzalloc(sizeof(struct deref_fetch_param), GFP_KERNEL);
 
@@ -687,6 +511,9 @@ int traceprobe_parse_probe_arg(char *arg, ssize_t *size,
 {
 	const char *t;
 	int ret;
+	const struct fetch_type *ttbl;
+
+	ttbl = kprobes_fetch_type_table;
 
 	if (strlen(arg) > MAX_ARGSTR_LEN) {
 		pr_info("Argument is too long.: %s\n",  arg);
@@ -702,7 +529,7 @@ int traceprobe_parse_probe_arg(char *arg, ssize_t *size,
 		arg[t - parg->comm] = '\0';
 		t++;
 	}
-	parg->type = find_fetch_type(t);
+	parg->type = find_fetch_type(t, ttbl);
 	if (!parg->type) {
 		pr_info("Unsupported type: %s\n", t);
 		return -EINVAL;
@@ -716,7 +543,8 @@ int traceprobe_parse_probe_arg(char *arg, ssize_t *size,
 
 	if (ret >= 0) {
 		parg->fetch_size.fn = get_fetch_size_function(parg->type,
-							      parg->fetch.fn);
+							      parg->fetch.fn,
+							      ttbl);
 		parg->fetch_size.data = parg->fetch.data;
 	}
 
diff --git a/kernel/trace/trace_probe.h b/kernel/trace/trace_probe.h
index 5c7e09d10d74..1c37c813e5e5 100644
--- a/kernel/trace/trace_probe.h
+++ b/kernel/trace/trace_probe.h
@@ -81,11 +81,46 @@
  */
 #define convert_rloc_to_loc(dl, offs)	((u32)(dl) + (offs))
 
+static inline void *get_rloc_data(u32 *dl)
+{
+	return (u8 *)dl + get_rloc_offs(*dl);
+}
+
+/* For data_loc conversion */
+static inline void *get_loc_data(u32 *dl, void *ent)
+{
+	return (u8 *)ent + get_rloc_offs(*dl);
+}
+
+
+/* For defining macros, define string/string_size types */
+typedef u32 string;
+typedef u32 string_size;
+
 /* Data fetch function type */
 typedef	void (*fetch_func_t)(struct pt_regs *, void *, void *);
 /* Printing function type */
 typedef int (*print_type_func_t)(struct trace_seq *, const char *, void *, void *);
 
+/* Printing function type */
+#define PRINT_TYPE_FUNC_NAME(type)	print_type_##type
+#define PRINT_TYPE_FMT_NAME(type)	print_type_format_##type
+
+#define DECLARE_PRINT_TYPE_FUNC(type)					\
+extern int PRINT_TYPE_FUNC_NAME(type)(struct trace_seq *, const char *, \
+				     void *, void *);			\
+extern const char PRINT_TYPE_FMT_NAME(type)[]
+
+DECLARE_PRINT_TYPE_FUNC(u8);
+DECLARE_PRINT_TYPE_FUNC(u16);
+DECLARE_PRINT_TYPE_FUNC(u32);
+DECLARE_PRINT_TYPE_FUNC(u64);
+DECLARE_PRINT_TYPE_FUNC(s8);
+DECLARE_PRINT_TYPE_FUNC(s16);
+DECLARE_PRINT_TYPE_FUNC(s32);
+DECLARE_PRINT_TYPE_FUNC(s64);
+DECLARE_PRINT_TYPE_FUNC(string);
+
 /* Fetch types */
 enum {
 	FETCH_MTD_reg = 0,
@@ -124,6 +159,98 @@ struct probe_arg {
 	const struct fetch_type	*type;	/* Type of this argument */
 };
 
+#define FETCH_FUNC_NAME(method, type)	fetch_##method##_##type
+
+#define DECLARE_FETCH_FUNC(method, type)				\
+extern void FETCH_FUNC_NAME(method, type)(struct pt_regs *, void *, void *)
+
+#define DECLARE_BASIC_FETCH_FUNCS(method) 	\
+DECLARE_FETCH_FUNC(method, u8);	  		\
+DECLARE_FETCH_FUNC(method, u16);		\
+DECLARE_FETCH_FUNC(method, u32);		\
+DECLARE_FETCH_FUNC(method, u64)
+
+/*
+ * Declare fetch functions
+ */
+DECLARE_BASIC_FETCH_FUNCS(reg);
+#define fetch_reg_string		NULL
+#define fetch_reg_string_size		NULL
+
+DECLARE_BASIC_FETCH_FUNCS(stack);
+#define fetch_stack_string		NULL
+#define fetch_stack_string_size		NULL
+
+DECLARE_BASIC_FETCH_FUNCS(retval);
+#define fetch_retval_string		NULL
+#define fetch_retval_string_size	NULL
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
+#define fetch_bitfield_string		NULL
+#define fetch_bitfield_string_size	NULL
+
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
+#define CHECK_FETCH_FUNCS(method, fn)			\
+	(((FETCH_FUNC_NAME(method, u8) == fn) ||	\
+	  (FETCH_FUNC_NAME(method, u16) == fn) ||	\
+	  (FETCH_FUNC_NAME(method, u32) == fn) ||	\
+	  (FETCH_FUNC_NAME(method, u64) == fn) ||	\
+	  (FETCH_FUNC_NAME(method, string) == fn) ||	\
+	  (FETCH_FUNC_NAME(method, string_size) == fn)) \
+	 && (fn != NULL))
+
+#define ASSIGN_FETCH_FUNC(method, type)	\
+	[FETCH_MTD_##method] = FETCH_FUNC_NAME(method, type)
+
+#define __ASSIGN_FETCH_TYPE(_name, ptype, ftype, _size, sign, _fmttype)	\
+	{.name = _name,				\
+	 .size = _size,					\
+	 .is_signed = sign,				\
+	 .print = PRINT_TYPE_FUNC_NAME(ptype),		\
+	 .fmt = PRINT_TYPE_FMT_NAME(ptype),		\
+	 .fmttype = _fmttype,				\
+	 .fetch = {					\
+ASSIGN_FETCH_FUNC(reg, ftype),				\
+ASSIGN_FETCH_FUNC(stack, ftype),			\
+ASSIGN_FETCH_FUNC(retval, ftype),			\
+ASSIGN_FETCH_FUNC(memory, ftype),			\
+ASSIGN_FETCH_FUNC(symbol, ftype),			\
+ASSIGN_FETCH_FUNC(deref, ftype),			\
+ASSIGN_FETCH_FUNC(bitfield, ftype),			\
+	  }						\
+	}
+
+#define ASSIGN_FETCH_TYPE(ptype, ftype, sign)			\
+	__ASSIGN_FETCH_TYPE(#ptype, ptype, ftype, sizeof(ftype), sign, #ptype)
+
+#define FETCH_TYPE_STRING	0
+#define FETCH_TYPE_STRSIZE	1
+
+#define NR_FETCH_TYPES		10
+
+extern const struct fetch_type kprobes_fetch_type_table[];
+
 static inline __kprobes void call_fetch(struct fetch_param *fprm,
 				 struct pt_regs *regs, void *dest)
 {
-- 
1.7.11.7

