Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761228Ab3LIKzX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 05:55:23 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:36236 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933133Ab3LIKxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 05:53:31 -0500
Subject: [PATCH -tip v5 12/18] ftrace/kprobes: Use NOKPROBE_SYMBOL macro in
 ftrace
To: Ingo Molnar <mingo@kernel.org>
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-arch@vger.kernel.org, Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        systemtap@sourceware.org, "David S. Miller" <davem@davemloft.net>
Date: Mon, 09 Dec 2013 10:47:46 +0000
Message-ID: <20131209104746.13397.22146.stgit@kbuild-fedora.novalocal>
In-Reply-To: <20131209104717.13397.8864.stgit@kbuild-fedora.novalocal>
References: <20131209104717.13397.8864.stgit@kbuild-fedora.novalocal>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use NOKPROBE_SYMBOL macro to protect functions from
kprobes instead of __kprobes annotation in ftrace.
This applies __always_inline annotation for some cases,
because NOKPROBE_SYMBOL() will inhibit inlining by
referring the symbol address.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
---
 kernel/trace/trace_event_perf.c |    5 ++-
 kernel/trace/trace_kprobe.c     |   51 +++++++++++++++------------
 kernel/trace/trace_probe.c      |   74 +++++++++++++++++++++++----------------
 kernel/trace/trace_probe.h      |    4 +-
 4 files changed, 76 insertions(+), 58 deletions(-)

diff --git a/kernel/trace/trace_event_perf.c b/kernel/trace/trace_event_perf.c
index e854f42..c97a795 100644
--- a/kernel/trace/trace_event_perf.c
+++ b/kernel/trace/trace_event_perf.c
@@ -232,8 +232,8 @@ void perf_trace_del(struct perf_event *p_event, int flags)
 	tp_event->class->reg(tp_event, TRACE_REG_PERF_DEL, p_event);
 }
 
-__kprobes void *perf_trace_buf_prepare(int size, unsigned short type,
-				       struct pt_regs *regs, int *rctxp)
+void *perf_trace_buf_prepare(int size, unsigned short type,
+			     struct pt_regs *regs, int *rctxp)
 {
 	struct trace_entry *entry;
 	unsigned long flags;
@@ -265,6 +265,7 @@ __kprobes void *perf_trace_buf_prepare(int size, unsigned short type,
 	return raw_data;
 }
 EXPORT_SYMBOL_GPL(perf_trace_buf_prepare);
+NOKPROBE_SYMBOL(perf_trace_buf_prepare);
 
 #ifdef CONFIG_FUNCTION_TRACER
 static void
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index f8fa5bc..96f5912 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -51,45 +51,45 @@ struct event_file_link {
 	(sizeof(struct probe_arg) * (n)))
 
 
-static __kprobes bool trace_probe_is_return(struct trace_probe *tp)
+static __always_inline bool trace_probe_is_return(struct trace_probe *tp)
 {
 	return tp->rp.handler != NULL;
 }
 
-static __kprobes const char *trace_probe_symbol(struct trace_probe *tp)
+static __always_inline const char *trace_probe_symbol(struct trace_probe *tp)
 {
 	return tp->symbol ? tp->symbol : "unknown";
 }
 
-static __kprobes unsigned long trace_probe_offset(struct trace_probe *tp)
+static __always_inline unsigned long trace_probe_offset(struct trace_probe *tp)
 {
 	return tp->rp.kp.offset;
 }
 
-static __kprobes bool trace_probe_is_enabled(struct trace_probe *tp)
+static __always_inline bool trace_probe_is_enabled(struct trace_probe *tp)
 {
 	return !!(tp->flags & (TP_FLAG_TRACE | TP_FLAG_PROFILE));
 }
 
-static __kprobes bool trace_probe_is_registered(struct trace_probe *tp)
+static __always_inline bool trace_probe_is_registered(struct trace_probe *tp)
 {
 	return !!(tp->flags & TP_FLAG_REGISTERED);
 }
 
-static __kprobes bool trace_probe_has_gone(struct trace_probe *tp)
+static __always_inline bool trace_probe_has_gone(struct trace_probe *tp)
 {
 	return !!(kprobe_gone(&tp->rp.kp));
 }
 
-static __kprobes bool trace_probe_within_module(struct trace_probe *tp,
-						struct module *mod)
+static __always_inline bool trace_probe_within_module(struct trace_probe *tp,
+						      struct module *mod)
 {
 	int len = strlen(mod->name);
 	const char *name = trace_probe_symbol(tp);
 	return strncmp(mod->name, name, len) == 0 && name[len] == ':';
 }
 
-static __kprobes bool trace_probe_is_on_module(struct trace_probe *tp)
+static __always_inline bool trace_probe_is_on_module(struct trace_probe *tp)
 {
 	return !!strchr(trace_probe_symbol(tp), ':');
 }
@@ -755,8 +755,8 @@ static const struct file_operations kprobe_profile_ops = {
 };
 
 /* Sum up total data length for dynamic arraies (strings) */
-static __kprobes int __get_data_size(struct trace_probe *tp,
-				     struct pt_regs *regs)
+static __always_inline
+int __get_data_size(struct trace_probe *tp, struct pt_regs *regs)
 {
 	int i, ret = 0;
 	u32 len;
@@ -771,9 +771,9 @@ static __kprobes int __get_data_size(struct trace_probe *tp,
 }
 
 /* Store the value of each argument */
-static __kprobes void store_trace_args(int ent_size, struct trace_probe *tp,
-				       struct pt_regs *regs,
-				       u8 *data, int maxlen)
+static __always_inline
+void store_trace_args(int ent_size, struct trace_probe *tp,
+		      struct pt_regs *regs, u8 *data, int maxlen)
 {
 	int i;
 	u32 end = tp->size;
@@ -803,7 +803,7 @@ static __kprobes void store_trace_args(int ent_size, struct trace_probe *tp,
 }
 
 /* Kprobe handler */
-static __kprobes void
+static __always_inline void
 __kprobe_trace_func(struct trace_probe *tp, struct pt_regs *regs,
 		    struct ftrace_event_file *ftrace_file)
 {
@@ -840,7 +840,7 @@ __kprobe_trace_func(struct trace_probe *tp, struct pt_regs *regs,
 						irq_flags, pc, regs);
 }
 
-static __kprobes void
+static void
 kprobe_trace_func(struct trace_probe *tp, struct pt_regs *regs)
 {
 	struct event_file_link *link;
@@ -848,9 +848,10 @@ kprobe_trace_func(struct trace_probe *tp, struct pt_regs *regs)
 	list_for_each_entry_rcu(link, &tp->files, list)
 		__kprobe_trace_func(tp, regs, link->file);
 }
+NOKPROBE_SYMBOL(kprobe_trace_func);
 
 /* Kretprobe handler */
-static __kprobes void
+static __always_inline void
 __kretprobe_trace_func(struct trace_probe *tp, struct kretprobe_instance *ri,
 		       struct pt_regs *regs,
 		       struct ftrace_event_file *ftrace_file)
@@ -889,7 +890,7 @@ __kretprobe_trace_func(struct trace_probe *tp, struct kretprobe_instance *ri,
 						irq_flags, pc, regs);
 }
 
-static __kprobes void
+static void
 kretprobe_trace_func(struct trace_probe *tp, struct kretprobe_instance *ri,
 		     struct pt_regs *regs)
 {
@@ -898,6 +899,7 @@ kretprobe_trace_func(struct trace_probe *tp, struct kretprobe_instance *ri,
 	list_for_each_entry_rcu(link, &tp->files, list)
 		__kretprobe_trace_func(tp, ri, regs, link->file);
 }
+NOKPROBE_SYMBOL(kretprobe_trace_func);
 
 /* Event entry printers */
 static enum print_line_t
@@ -1086,7 +1088,7 @@ static int set_print_fmt(struct trace_probe *tp)
 #ifdef CONFIG_PERF_EVENTS
 
 /* Kprobe profile handler */
-static __kprobes void
+static void
 kprobe_perf_func(struct trace_probe *tp, struct pt_regs *regs)
 {
 	struct ftrace_event_call *call = &tp->call;
@@ -1113,9 +1115,10 @@ kprobe_perf_func(struct trace_probe *tp, struct pt_regs *regs)
 	store_trace_args(sizeof(*entry), tp, regs, (u8 *)&entry[1], dsize);
 	perf_trace_buf_submit(entry, size, rctx, 0, 1, regs, head, NULL);
 }
+NOKPROBE_SYMBOL(kprobe_perf_func);
 
 /* Kretprobe profile handler */
-static __kprobes void
+static void
 kretprobe_perf_func(struct trace_probe *tp, struct kretprobe_instance *ri,
 		    struct pt_regs *regs)
 {
@@ -1143,6 +1146,7 @@ kretprobe_perf_func(struct trace_probe *tp, struct kretprobe_instance *ri,
 	store_trace_args(sizeof(*entry), tp, regs, (u8 *)&entry[1], dsize);
 	perf_trace_buf_submit(entry, size, rctx, 0, 1, regs, head, NULL);
 }
+NOKPROBE_SYMBOL(kretprobe_perf_func);
 #endif	/* CONFIG_PERF_EVENTS */
 
 /*
@@ -1179,8 +1183,7 @@ int kprobe_register(struct ftrace_event_call *event,
 	return 0;
 }
 
-static __kprobes
-int kprobe_dispatcher(struct kprobe *kp, struct pt_regs *regs)
+static int kprobe_dispatcher(struct kprobe *kp, struct pt_regs *regs)
 {
 	struct trace_probe *tp = container_of(kp, struct trace_probe, rp.kp);
 
@@ -1194,8 +1197,9 @@ int kprobe_dispatcher(struct kprobe *kp, struct pt_regs *regs)
 #endif
 	return 0;	/* We don't tweek kernel, so just return 0 */
 }
+NOKPROBE_SYMBOL(kprobe_dispatcher);
 
-static __kprobes
+static
 int kretprobe_dispatcher(struct kretprobe_instance *ri, struct pt_regs *regs)
 {
 	struct trace_probe *tp = container_of(ri->rp, struct trace_probe, rp);
@@ -1210,6 +1214,7 @@ int kretprobe_dispatcher(struct kretprobe_instance *ri, struct pt_regs *regs)
 #endif
 	return 0;	/* We don't tweek kernel, so just return 0 */
 }
+NOKPROBE_SYMBOL(kretprobe_dispatcher);
 
 static struct trace_event_functions kretprobe_funcs = {
 	.trace		= print_kretprobe_event
diff --git a/kernel/trace/trace_probe.c b/kernel/trace/trace_probe.c
index 43638a2..314bdc6 100644
--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -41,13 +41,14 @@ const char *reserved_field_names[] = {
 
 /* Printing  in basic type function template */
 #define DEFINE_BASIC_PRINT_TYPE_FUNC(type, fmt, cast)			\
-static __kprobes int PRINT_TYPE_FUNC_NAME(type)(struct trace_seq *s,	\
-						const char *name,	\
-						void *data, void *ent)\
+static int PRINT_TYPE_FUNC_NAME(type)(struct trace_seq *s,		\
+				      const char *name,			\
+				      void *data, void *ent)		\
 {									\
 	return trace_seq_printf(s, " %s=" fmt, name, (cast)*(type *)data);\
 }									\
-static const char PRINT_TYPE_FMT_NAME(type)[] = fmt;
+static const char PRINT_TYPE_FMT_NAME(type)[] = fmt;			\
+NOKPROBE_SYMBOL(PRINT_TYPE_FUNC_NAME(type));
 
 DEFINE_BASIC_PRINT_TYPE_FUNC(u8, "%x", unsigned int)
 DEFINE_BASIC_PRINT_TYPE_FUNC(u16, "%x", unsigned int)
@@ -74,9 +75,9 @@ typedef u32 string;
 typedef u32 string_size;
 
 /* Print type function for string type */
-static __kprobes int PRINT_TYPE_FUNC_NAME(string)(struct trace_seq *s,
-						  const char *name,
-						  void *data, void *ent)
+static int PRINT_TYPE_FUNC_NAME(string)(struct trace_seq *s,
+					  const char *name,
+					  void *data, void *ent)
 {
 	int len = *(u32 *)data >> 16;
 
@@ -86,6 +87,7 @@ static __kprobes int PRINT_TYPE_FUNC_NAME(string)(struct trace_seq *s,
 		return trace_seq_printf(s, " %s=\"%s\"", name,
 					(const char *)get_loc_data(data, ent));
 }
+NOKPROBE_SYMBOL(PRINT_TYPE_FUNC_NAME(string));
 
 static const char PRINT_TYPE_FMT_NAME(string)[] = "\\\"%s\\\"";
 
@@ -111,42 +113,45 @@ DEFINE_FETCH_##method(u64)
 
 /* Data fetch function templates */
 #define DEFINE_FETCH_reg(type)						\
-static __kprobes void FETCH_FUNC_NAME(reg, type)(struct pt_regs *regs,	\
+static void FETCH_FUNC_NAME(reg, type)(struct pt_regs *regs,		\
 					void *offset, void *dest)	\
 {									\
 	*(type *)dest = (type)regs_get_register(regs,			\
 				(unsigned int)((unsigned long)offset));	\
-}
+}									\
+NOKPROBE_SYMBOL(FETCH_FUNC_NAME(reg, type));
 DEFINE_BASIC_FETCH_FUNCS(reg)
 /* No string on the register */
 #define fetch_reg_string	NULL
 #define fetch_reg_string_size	NULL
 
 #define DEFINE_FETCH_stack(type)					\
-static __kprobes void FETCH_FUNC_NAME(stack, type)(struct pt_regs *regs,\
-					  void *offset, void *dest)	\
+static void FETCH_FUNC_NAME(stack, type)(struct pt_regs *regs,		\
+					 void *offset, void *dest)	\
 {									\
 	*(type *)dest = (type)regs_get_kernel_stack_nth(regs,		\
 				(unsigned int)((unsigned long)offset));	\
-}
+}									\
+NOKPROBE_SYMBOL(FETCH_FUNC_NAME(stack, type));
 DEFINE_BASIC_FETCH_FUNCS(stack)
 /* No string on the stack entry */
 #define fetch_stack_string	NULL
 #define fetch_stack_string_size	NULL
 
 #define DEFINE_FETCH_retval(type)					\
-static __kprobes void FETCH_FUNC_NAME(retval, type)(struct pt_regs *regs,\
+static void FETCH_FUNC_NAME(retval, type)(struct pt_regs *regs,		\
 					  void *dummy, void *dest)	\
 {									\
 	*(type *)dest = (type)regs_return_value(regs);			\
-}
+}									\
+NOKPROBE_SYMBOL(FETCH_FUNC_NAME(retval, type));
 DEFINE_BASIC_FETCH_FUNCS(retval)
 /* No string on the retval */
 #define fetch_retval_string		NULL
 #define fetch_retval_string_size	NULL
 
 #define DEFINE_FETCH_memory(type)					\
-static __kprobes void FETCH_FUNC_NAME(memory, type)(struct pt_regs *regs,\
+static void FETCH_FUNC_NAME(memory, type)(struct pt_regs *regs,		\
 					  void *addr, void *dest)	\
 {									\
 	type retval;							\
@@ -154,14 +159,15 @@ static __kprobes void FETCH_FUNC_NAME(memory, type)(struct pt_regs *regs,\
 		*(type *)dest = 0;					\
 	else								\
 		*(type *)dest = retval;					\
-}
+}									\
+NOKPROBE_SYMBOL(FETCH_FUNC_NAME(memory, type));
 DEFINE_BASIC_FETCH_FUNCS(memory)
 /*
  * Fetch a null-terminated string. Caller MUST set *(u32 *)dest with max
  * length and relative data location.
  */
-static __kprobes void FETCH_FUNC_NAME(memory, string)(struct pt_regs *regs,
-						      void *addr, void *dest)
+static void FETCH_FUNC_NAME(memory, string)(struct pt_regs *regs,
+					    void *addr, void *dest)
 {
 	long ret;
 	int maxlen = get_rloc_len(*(u32 *)dest);
@@ -195,10 +201,11 @@ static __kprobes void FETCH_FUNC_NAME(memory, string)(struct pt_regs *regs,
 					      get_rloc_offs(*(u32 *)dest));
 	}
 }
+NOKPROBE_SYMBOL(FETCH_FUNC_NAME(memory, string));
 
 /* Return the length of string -- including null terminal byte */
-static __kprobes void FETCH_FUNC_NAME(memory, string_size)(struct pt_regs *regs,
-							void *addr, void *dest)
+static void FETCH_FUNC_NAME(memory, string_size)(struct pt_regs *regs,
+						 void *addr, void *dest)
 {
 	mm_segment_t old_fs;
 	int ret, len = 0;
@@ -221,6 +228,7 @@ static __kprobes void FETCH_FUNC_NAME(memory, string_size)(struct pt_regs *regs,
 	else
 		*(u32 *)dest = len;
 }
+NOKPROBE_SYMBOL(FETCH_FUNC_NAME(memory, string_size));
 
 /* Memory fetching by symbol */
 struct symbol_cache {
@@ -268,7 +276,7 @@ static struct symbol_cache *alloc_symbol_cache(const char *sym, long offset)
 }
 
 #define DEFINE_FETCH_symbol(type)					\
-static __kprobes void FETCH_FUNC_NAME(symbol, type)(struct pt_regs *regs,\
+static void FETCH_FUNC_NAME(symbol, type)(struct pt_regs *regs,		\
 					  void *data, void *dest)	\
 {									\
 	struct symbol_cache *sc = data;					\
@@ -276,7 +284,8 @@ static __kprobes void FETCH_FUNC_NAME(symbol, type)(struct pt_regs *regs,\
 		fetch_memory_##type(regs, (void *)sc->addr, dest);	\
 	else								\
 		*(type *)dest = 0;					\
-}
+}									\
+NOKPROBE_SYMBOL(FETCH_FUNC_NAME(symbol, type));
 DEFINE_BASIC_FETCH_FUNCS(symbol)
 DEFINE_FETCH_symbol(string)
 DEFINE_FETCH_symbol(string_size)
@@ -288,7 +297,7 @@ struct deref_fetch_param {
 };
 
 #define DEFINE_FETCH_deref(type)					\
-static __kprobes void FETCH_FUNC_NAME(deref, type)(struct pt_regs *regs,\
+static void FETCH_FUNC_NAME(deref, type)(struct pt_regs *regs,		\
 					    void *data, void *dest)	\
 {									\
 	struct deref_fetch_param *dprm = data;				\
@@ -299,20 +308,22 @@ static __kprobes void FETCH_FUNC_NAME(deref, type)(struct pt_regs *regs,\
 		fetch_memory_##type(regs, (void *)addr, dest);		\
 	} else								\
 		*(type *)dest = 0;					\
-}
+}									\
+NOKPROBE_SYMBOL(FETCH_FUNC_NAME(deref, type));
 DEFINE_BASIC_FETCH_FUNCS(deref)
 DEFINE_FETCH_deref(string)
 DEFINE_FETCH_deref(string_size)
 
-static __kprobes void update_deref_fetch_param(struct deref_fetch_param *data)
+static void update_deref_fetch_param(struct deref_fetch_param *data)
 {
 	if (CHECK_FETCH_FUNCS(deref, data->orig.fn))
 		update_deref_fetch_param(data->orig.data);
 	else if (CHECK_FETCH_FUNCS(symbol, data->orig.fn))
 		update_symbol_cache(data->orig.data);
 }
+NOKPROBE_SYMBOL(update_deref_fetch_param);
 
-static __kprobes void free_deref_fetch_param(struct deref_fetch_param *data)
+static void free_deref_fetch_param(struct deref_fetch_param *data)
 {
 	if (CHECK_FETCH_FUNCS(deref, data->orig.fn))
 		free_deref_fetch_param(data->orig.data);
@@ -320,6 +331,7 @@ static __kprobes void free_deref_fetch_param(struct deref_fetch_param *data)
 		free_symbol_cache(data->orig.data);
 	kfree(data);
 }
+NOKPROBE_SYMBOL(free_deref_fetch_param);
 
 /* Bitfield fetch function */
 struct bitfield_fetch_param {
@@ -329,7 +341,7 @@ struct bitfield_fetch_param {
 };
 
 #define DEFINE_FETCH_bitfield(type)					\
-static __kprobes void FETCH_FUNC_NAME(bitfield, type)(struct pt_regs *regs,\
+static void FETCH_FUNC_NAME(bitfield, type)(struct pt_regs *regs,	\
 					    void *data, void *dest)	\
 {									\
 	struct bitfield_fetch_param *bprm = data;			\
@@ -340,8 +352,8 @@ static __kprobes void FETCH_FUNC_NAME(bitfield, type)(struct pt_regs *regs,\
 		buf >>= bprm->low_shift;				\
 	}								\
 	*(type *)dest = buf;						\
-}
-
+}									\
+NOKPROBE_SYMBOL(FETCH_FUNC_NAME(bitfield, type));
 DEFINE_BASIC_FETCH_FUNCS(bitfield)
 #define fetch_bitfield_string		NULL
 #define fetch_bitfield_string_size	NULL
@@ -467,11 +479,11 @@ fail:
 }
 
 /* Special function : only accept unsigned long */
-static __kprobes void fetch_stack_address(struct pt_regs *regs,
-					void *dummy, void *dest)
+static void fetch_stack_address(struct pt_regs *regs, void *dummy, void *dest)
 {
 	*(unsigned long *)dest = kernel_stack_pointer(regs);
 }
+NOKPROBE_SYMBOL(fetch_stack_address);
 
 static fetch_func_t get_fetch_size_function(const struct fetch_type *type,
 					fetch_func_t orig_fn)
diff --git a/kernel/trace/trace_probe.h b/kernel/trace/trace_probe.h
index 5c7e09d..829dd5e 100644
--- a/kernel/trace/trace_probe.h
+++ b/kernel/trace/trace_probe.h
@@ -124,8 +124,8 @@ struct probe_arg {
 	const struct fetch_type	*type;	/* Type of this argument */
 };
 
-static inline __kprobes void call_fetch(struct fetch_param *fprm,
-				 struct pt_regs *regs, void *dest)
+static inline void call_fetch(struct fetch_param *fprm,
+			      struct pt_regs *regs, void *dest)
 {
 	return fprm->fn(regs, fprm->data, dest);
 }


