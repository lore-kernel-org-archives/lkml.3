Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756863Ab3K0GXF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 01:23:05 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:53837 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752196Ab3K0GUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 01:20:10 -0500
X-AuditID: 9c930197-b7caaae000001cef-ad-52958f163cc1
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
Subject: [PATCH 07/17] tracing/probes: Move fetch function helpers to trace_probe.h
Date: Wed, 27 Nov 2013 15:19:53 +0900
Message-Id: <1385533203-10014-8-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1385533203-10014-1-git-send-email-namhyung@kernel.org>
References: <1385533203-10014-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Move fetch function helper macros/functions to the header file and
make them external.  This is preparation of supporting uprobe fetch
table in next patch.

Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 kernel/trace/trace_probe.c | 74 ++++++++--------------------------------------
 kernel/trace/trace_probe.h | 64 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 77 insertions(+), 61 deletions(-)

diff --git a/kernel/trace/trace_probe.c b/kernel/trace/trace_probe.c
index 7de2f58d2acb..a34e3fca4071 100644
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
 #define DEFINE_BASIC_PRINT_TYPE_FUNC(type, fmt)				\
-static __kprobes int PRINT_TYPE_FUNC_NAME(type)(struct trace_seq *s,	\
+__kprobes int PRINT_TYPE_FUNC_NAME(type)(struct trace_seq *s,	\
 						const char *name,	\
 						void *data, void *ent)	\
 {									\
 	return trace_seq_printf(s, " %s=" fmt, name, *(type *)data);	\
 }									\
-static const char PRINT_TYPE_FMT_NAME(type)[] = fmt;
+const char PRINT_TYPE_FMT_NAME(type)[] = fmt;
 
 DEFINE_BASIC_PRINT_TYPE_FUNC(u8 , "%#x")
 DEFINE_BASIC_PRINT_TYPE_FUNC(u16, "%#x")
@@ -58,23 +54,12 @@ DEFINE_BASIC_PRINT_TYPE_FUNC(s16, "%d")
 DEFINE_BASIC_PRINT_TYPE_FUNC(s32, "%d")
 DEFINE_BASIC_PRINT_TYPE_FUNC(s64, "%Ld")
 
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
 /* For defining macros, define string/string_size types */
 typedef u32 string;
 typedef u32 string_size;
 
 /* Print type function for string type */
-static __kprobes int PRINT_TYPE_FUNC_NAME(string)(struct trace_seq *s,
+__kprobes int PRINT_TYPE_FUNC_NAME(string)(struct trace_seq *s,
 						  const char *name,
 						  void *data, void *ent)
 {
@@ -87,7 +72,7 @@ static __kprobes int PRINT_TYPE_FUNC_NAME(string)(struct trace_seq *s,
 					(const char *)get_loc_data(data, ent));
 }
 
-static const char PRINT_TYPE_FMT_NAME(string)[] = "\\\"%s\\\"";
+const char PRINT_TYPE_FMT_NAME(string)[] = "\\\"%s\\\"";
 
 #define FETCH_FUNC_NAME(method, type)	fetch_##method##_##type
 /*
@@ -111,7 +96,7 @@ DEFINE_FETCH_##method(u64)
 
 /* Data fetch function templates */
 #define DEFINE_FETCH_reg(type)						\
-static __kprobes void FETCH_FUNC_NAME(reg, type)(struct pt_regs *regs,	\
+__kprobes void FETCH_FUNC_NAME(reg, type)(struct pt_regs *regs,		\
 					void *offset, void *dest)	\
 {									\
 	*(type *)dest = (type)regs_get_register(regs,			\
@@ -123,7 +108,7 @@ DEFINE_BASIC_FETCH_FUNCS(reg)
 #define fetch_reg_string_size	NULL
 
 #define DEFINE_FETCH_stack(type)					\
-static __kprobes void FETCH_FUNC_NAME(stack, type)(struct pt_regs *regs,\
+__kprobes void FETCH_FUNC_NAME(stack, type)(struct pt_regs *regs,	\
 					  void *offset, void *dest)	\
 {									\
 	*(type *)dest = (type)regs_get_kernel_stack_nth(regs,		\
@@ -135,7 +120,7 @@ DEFINE_BASIC_FETCH_FUNCS(stack)
 #define fetch_stack_string_size	NULL
 
 #define DEFINE_FETCH_retval(type)					\
-static __kprobes void FETCH_FUNC_NAME(retval, type)(struct pt_regs *regs,\
+__kprobes void FETCH_FUNC_NAME(retval, type)(struct pt_regs *regs,	\
 					  void *dummy, void *dest)	\
 {									\
 	*(type *)dest = (type)regs_return_value(regs);			\
@@ -146,7 +131,7 @@ DEFINE_BASIC_FETCH_FUNCS(retval)
 #define fetch_retval_string_size	NULL
 
 #define DEFINE_FETCH_memory(type)					\
-static __kprobes void FETCH_FUNC_NAME(memory, type)(struct pt_regs *regs,\
+__kprobes void FETCH_FUNC_NAME(memory, type)(struct pt_regs *regs,	\
 					  void *addr, void *dest)	\
 {									\
 	type retval;							\
@@ -160,7 +145,7 @@ DEFINE_BASIC_FETCH_FUNCS(memory)
  * Fetch a null-terminated string. Caller MUST set *(u32 *)dest with max
  * length and relative data location.
  */
-static __kprobes void FETCH_FUNC_NAME(memory, string)(struct pt_regs *regs,
+__kprobes void FETCH_FUNC_NAME(memory, string)(struct pt_regs *regs,
 						      void *addr, void *dest)
 {
 	long ret;
@@ -197,7 +182,7 @@ static __kprobes void FETCH_FUNC_NAME(memory, string)(struct pt_regs *regs,
 }
 
 /* Return the length of string -- including null terminal byte */
-static __kprobes void FETCH_FUNC_NAME(memory, string_size)(struct pt_regs *regs,
+__kprobes void FETCH_FUNC_NAME(memory, string_size)(struct pt_regs *regs,
 							void *addr, void *dest)
 {
 	mm_segment_t old_fs;
@@ -268,7 +253,7 @@ static struct symbol_cache *alloc_symbol_cache(const char *sym, long offset)
 }
 
 #define DEFINE_FETCH_symbol(type)					\
-static __kprobes void FETCH_FUNC_NAME(symbol, type)(struct pt_regs *regs,\
+__kprobes void FETCH_FUNC_NAME(symbol, type)(struct pt_regs *regs,	\
 					  void *data, void *dest)	\
 {									\
 	struct symbol_cache *sc = data;					\
@@ -288,7 +273,7 @@ struct deref_fetch_param {
 };
 
 #define DEFINE_FETCH_deref(type)					\
-static __kprobes void FETCH_FUNC_NAME(deref, type)(struct pt_regs *regs,\
+__kprobes void FETCH_FUNC_NAME(deref, type)(struct pt_regs *regs,	\
 					    void *data, void *dest)	\
 {									\
 	struct deref_fetch_param *dprm = data;				\
@@ -329,7 +314,7 @@ struct bitfield_fetch_param {
 };
 
 #define DEFINE_FETCH_bitfield(type)					\
-static __kprobes void FETCH_FUNC_NAME(bitfield, type)(struct pt_regs *regs,\
+__kprobes void FETCH_FUNC_NAME(bitfield, type)(struct pt_regs *regs,	\
 					    void *data, void *dest)	\
 {									\
 	struct bitfield_fetch_param *bprm = data;			\
@@ -374,39 +359,6 @@ free_bitfield_fetch_param(struct bitfield_fetch_param *data)
 	kfree(data);
 }
 
-/* Default (unsigned long) fetch type */
-#define __DEFAULT_FETCH_TYPE(t) u##t
-#define _DEFAULT_FETCH_TYPE(t) __DEFAULT_FETCH_TYPE(t)
-#define DEFAULT_FETCH_TYPE _DEFAULT_FETCH_TYPE(BITS_PER_LONG)
-#define DEFAULT_FETCH_TYPE_STR __stringify(DEFAULT_FETCH_TYPE)
-
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
 /* Fetch type information table */
 static const struct fetch_type fetch_type_table[] = {
 	/* Special types */
diff --git a/kernel/trace/trace_probe.h b/kernel/trace/trace_probe.h
index 2c979cb66367..7c6be146f444 100644
--- a/kernel/trace/trace_probe.h
+++ b/kernel/trace/trace_probe.h
@@ -81,6 +81,17 @@
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
 /* Data fetch function type */
 typedef	void (*fetch_func_t)(struct pt_regs *, void *, void *);
 /* Printing function type */
@@ -115,6 +126,59 @@ struct fetch_param {
 	void 			*data;
 };
 
+#define PRINT_TYPE_FUNC_NAME(type)	print_type_##type
+#define PRINT_TYPE_FMT_NAME(type)	print_type_format_##type
+
+/* Printing  in basic type function template */
+#define DECLARE_BASIC_PRINT_TYPE_FUNC(type, fmt)			\
+__kprobes int PRINT_TYPE_FUNC_NAME(type)(struct trace_seq *s,		\
+					 const char *name,		\
+					 void *data, void *ent);	\
+extern const char PRINT_TYPE_FMT_NAME(type)[];
+
+DECLARE_BASIC_PRINT_TYPE_FUNC(u8 , "%x")
+DECLARE_BASIC_PRINT_TYPE_FUNC(u16, "%x")
+DECLARE_BASIC_PRINT_TYPE_FUNC(u32, "%x")
+DECLARE_BASIC_PRINT_TYPE_FUNC(u64, "%Lx")
+DECLARE_BASIC_PRINT_TYPE_FUNC(s8,  "%d")
+DECLARE_BASIC_PRINT_TYPE_FUNC(s16, "%d")
+DECLARE_BASIC_PRINT_TYPE_FUNC(s32, "%d")
+DECLARE_BASIC_PRINT_TYPE_FUNC(s64, "%Ld")
+
+/* Default (unsigned long) fetch type */
+#define __DEFAULT_FETCH_TYPE(t) u##t
+#define _DEFAULT_FETCH_TYPE(t) __DEFAULT_FETCH_TYPE(t)
+#define DEFAULT_FETCH_TYPE _DEFAULT_FETCH_TYPE(BITS_PER_LONG)
+#define DEFAULT_FETCH_TYPE_STR __stringify(DEFAULT_FETCH_TYPE)
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
+
 struct probe_arg {
 	struct fetch_param	fetch;
 	struct fetch_param	fetch_size;
-- 
1.7.11.7

