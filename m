Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947Ab3LCE3X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 23:29:23 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:51838 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753223Ab3LCE3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 23:29:04 -0500
From: Alexei Starovoitov <ast@plumgrid.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Jovi Zhangwei <jovi.zhangwei@gmail.com>,
        Eric Dumazet <edumazet@google.com>, linux-kernel@vger.kernel.org
Subject: [RFC PATCH tip 4/5] use BPF in tracing filters
Date: Mon,  2 Dec 2013 20:28:49 -0800
Message-Id: <1386044930-15149-5-git-send-email-ast@plumgrid.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1386044930-15149-1-git-send-email-ast@plumgrid.com>
References: <1386044930-15149-1-git-send-email-ast@plumgrid.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Such filters can be written in C and allow safe read-only access to
any kernel data structure.
Like systemtap but with safety guaranteed by kernel.

The user can do:
cat bpf_program > /sys/kernel/debug/tracing/.../filter
if tracing event is either static or dynamic via kprobe_events.

The program can be anything as long as bpf_check() can verify its safety.
For example, the user can create kprobe_event on dst_discard()
and use logically following code inside BPF filter:
      skb = (struct sk_buff *)ctx->regs.di;
      dev = bpf_load_pointer(&skb->dev);
to access 'struct net_device'
Since its prototype is 'int dst_discard(struct sk_buff *skb);'
'skb' pointer is in 'rdi' register on x86_64
bpf_load_pointer() will try to fetch 'dev' field of 'sk_buff'
structure and will suppress page-fault if pointer is incorrect.

Signed-off-by: Alexei Starovoitov <ast@plumgrid.com>
---
 include/linux/ftrace_event.h       |    3 +
 include/trace/bpf_trace.h          |   27 +++++
 include/trace/ftrace.h             |   14 +++
 kernel/trace/Kconfig               |    1 +
 kernel/trace/Makefile              |    1 +
 kernel/trace/bpf_trace_callbacks.c |  191 ++++++++++++++++++++++++++++++++++++
 kernel/trace/trace.c               |    7 ++
 kernel/trace/trace.h               |   11 ++-
 kernel/trace/trace_events.c        |    9 +-
 kernel/trace/trace_events_filter.c |   61 +++++++++++-
 kernel/trace/trace_kprobe.c        |    6 ++
 11 files changed, 327 insertions(+), 4 deletions(-)
 create mode 100644 include/trace/bpf_trace.h
 create mode 100644 kernel/trace/bpf_trace_callbacks.c

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 8c9b7a1..8d4a7a3 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -203,6 +203,7 @@ enum {
 	TRACE_EVENT_FL_IGNORE_ENABLE_BIT,
 	TRACE_EVENT_FL_WAS_ENABLED_BIT,
 	TRACE_EVENT_FL_USE_CALL_FILTER_BIT,
+	TRACE_EVENT_FL_BPF_BIT,
 };
 
 /*
@@ -223,6 +224,7 @@ enum {
 	TRACE_EVENT_FL_IGNORE_ENABLE	= (1 << TRACE_EVENT_FL_IGNORE_ENABLE_BIT),
 	TRACE_EVENT_FL_WAS_ENABLED	= (1 << TRACE_EVENT_FL_WAS_ENABLED_BIT),
 	TRACE_EVENT_FL_USE_CALL_FILTER	= (1 << TRACE_EVENT_FL_USE_CALL_FILTER_BIT),
+	TRACE_EVENT_FL_BPF		= (1 << TRACE_EVENT_FL_BPF_BIT),
 };
 
 struct ftrace_event_call {
@@ -347,6 +349,7 @@ extern int filter_check_discard(struct ftrace_event_file *file, void *rec,
 extern int call_filter_check_discard(struct ftrace_event_call *call, void *rec,
 				     struct ring_buffer *buffer,
 				     struct ring_buffer_event *event);
+extern void filter_call_bpf(struct event_filter *filter, struct pt_regs *regs);
 
 enum {
 	FILTER_OTHER = 0,
diff --git a/include/trace/bpf_trace.h b/include/trace/bpf_trace.h
new file mode 100644
index 0000000..99d1e4b
--- /dev/null
+++ b/include/trace/bpf_trace.h
@@ -0,0 +1,27 @@
+/* Copyright (c) 2011-2013 PLUMgrid, http://plumgrid.com
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of version 2 of the GNU General Public
+ * License as published by the Free Software Foundation.
+ */
+#ifndef _LINUX_KERNEL_BPF_TRACE_H
+#define _LINUX_KERNEL_BPF_TRACE_H
+
+#include <linux/ptrace.h>
+
+struct bpf_context {
+	struct pt_regs regs;
+};
+
+void *bpf_load_pointer(void *unsafe_ptr);
+long bpf_memcmp(void *unsafe_ptr, void *safe_ptr, long size);
+void bpf_dump_stack(struct bpf_context *ctx);
+void bpf_trace_printk(char *fmt, long fmt_size,
+		      long arg1, long arg2, long arg3);
+void *bpf_table_lookup(struct bpf_context *ctx, long table_id, const void *key);
+long bpf_table_update(struct bpf_context *ctx, long table_id, const void *key,
+		      const void *leaf);
+
+extern struct bpf_callbacks bpf_trace_cb;
+
+#endif /* _LINUX_KERNEL_BPF_TRACE_H */
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 5c38606..4054393 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -17,6 +17,7 @@
  */
 
 #include <linux/ftrace_event.h>
+#include <linux/kexec.h>
 
 /*
  * DECLARE_EVENT_CLASS can be used to add a generic function
@@ -526,6 +527,11 @@ static inline notrace int ftrace_get_offsets_##call(			\
 #undef DECLARE_EVENT_CLASS
 #define DECLARE_EVENT_CLASS(call, proto, args, tstruct, assign, print)	\
 									\
+static noinline __noclone notrace void					\
+ftrace_raw_event_save_regs_##call(struct pt_regs *__regs, proto)	\
+{									\
+	crash_setup_regs(__regs, NULL);					\
+}									\
 static notrace void							\
 ftrace_raw_event_##call(void *__data, proto)				\
 {									\
@@ -543,6 +549,14 @@ ftrace_raw_event_##call(void *__data, proto)				\
 		     &ftrace_file->flags))				\
 		return;							\
 									\
+	if (unlikely(ftrace_file->flags & FTRACE_EVENT_FL_FILTERED) &&	\
+	    unlikely(ftrace_file->event_call->flags & TRACE_EVENT_FL_BPF)) { \
+		struct pt_regs __regs;					\
+		ftrace_raw_event_save_regs_##call(&__regs, args);	\
+		filter_call_bpf(ftrace_file->filter, &__regs);		\
+		return;							\
+	}								\
+									\
 	local_save_flags(irq_flags);					\
 	pc = preempt_count();						\
 									\
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 015f85a..2809cd1 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -80,6 +80,7 @@ config FTRACE_NMI_ENTER
 
 config EVENT_TRACING
 	select CONTEXT_SWITCH_TRACER
+	select BPF64
 	bool
 
 config CONTEXT_SWITCH_TRACER
diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index d7e2068..fe90d85 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -50,6 +50,7 @@ ifeq ($(CONFIG_PERF_EVENTS),y)
 obj-$(CONFIG_EVENT_TRACING) += trace_event_perf.o
 endif
 obj-$(CONFIG_EVENT_TRACING) += trace_events_filter.o
+obj-$(CONFIG_EVENT_TRACING) += bpf_trace_callbacks.o
 obj-$(CONFIG_KPROBE_EVENT) += trace_kprobe.o
 obj-$(CONFIG_TRACEPOINTS) += power-traces.o
 ifeq ($(CONFIG_PM_RUNTIME),y)
diff --git a/kernel/trace/bpf_trace_callbacks.c b/kernel/trace/bpf_trace_callbacks.c
new file mode 100644
index 0000000..c2afd43
--- /dev/null
+++ b/kernel/trace/bpf_trace_callbacks.c
@@ -0,0 +1,191 @@
+/* Copyright (c) 2011-2013 PLUMgrid, http://plumgrid.com
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of version 2 of the GNU General Public
+ * License as published by the Free Software Foundation.
+ */
+#include <linux/kernel.h>
+#include <linux/types.h>
+#include <linux/slab.h>
+#include <linux/bpf_jit.h>
+#include <linux/uaccess.h>
+#include <trace/bpf_trace.h>
+#include "trace.h"
+
+#define MAX_CTX_OFF sizeof(struct bpf_context)
+
+static const struct bpf_context_access ctx_access[MAX_CTX_OFF] = {
+#ifdef CONFIG_X86_64
+	[offsetof(struct bpf_context, regs.di)] = {
+		FIELD_SIZEOF(struct bpf_context, regs.di),
+		BPF_READ
+	},
+	[offsetof(struct bpf_context, regs.si)] = {
+		FIELD_SIZEOF(struct bpf_context, regs.si),
+		BPF_READ
+	},
+	[offsetof(struct bpf_context, regs.dx)] = {
+		FIELD_SIZEOF(struct bpf_context, regs.dx),
+		BPF_READ
+	},
+	[offsetof(struct bpf_context, regs.cx)] = {
+		FIELD_SIZEOF(struct bpf_context, regs.cx),
+		BPF_READ
+	},
+#endif
+};
+
+static const struct bpf_context_access *get_context_access(int off)
+{
+	if (off >= MAX_CTX_OFF)
+		return NULL;
+	return &ctx_access[off];
+}
+
+void *bpf_load_pointer(void *unsafe_ptr)
+{
+	void *ptr = NULL;
+
+	probe_kernel_read(&ptr, unsafe_ptr, sizeof(void *));
+	return ptr;
+}
+
+long bpf_memcmp(void *unsafe_ptr, void *safe_ptr, long size)
+{
+	char buf[64];
+	int err;
+
+	if (size < 64) {
+		err = probe_kernel_read(buf, unsafe_ptr, size);
+		if (err)
+			return err;
+		return memcmp(buf, safe_ptr, size);
+	}
+	return -1;
+}
+
+void bpf_dump_stack(struct bpf_context *ctx)
+{
+	unsigned long flags;
+
+	local_save_flags(flags);
+
+	__trace_stack_regs(flags, 0, preempt_count(), (struct pt_regs *)ctx);
+}
+
+/*
+ * limited trace_printk()
+ * only %d %u %p %x conversion specifiers allowed
+ */
+void bpf_trace_printk(char *fmt, long fmt_size, long arg1, long arg2, long arg3)
+{
+	int fmt_cnt = 0;
+	int i;
+
+	/*
+	 * bpf_check() guarantees that fmt points to bpf program stack and
+	 * fmt_size bytes of it were initialized by bpf program
+	 */
+	if (fmt[fmt_size - 1] != 0)
+		return;
+
+	for (i = 0; i < fmt_size; i++)
+		if (fmt[i] == '%') {
+			if (i + 1 >= fmt_size)
+				return;
+			if (fmt[i + 1] != 'p' && fmt[i + 1] != 'd' &&
+			    fmt[i + 1] != 'u' && fmt[i + 1] != 'x')
+				return;
+			fmt_cnt++;
+		}
+	if (fmt_cnt > 3)
+		return;
+	__trace_printk((unsigned long)__builtin_return_address(3), fmt,
+		       arg1, arg2, arg3);
+}
+
+
+static const struct bpf_func_proto *get_func_proto(char *strtab, int id)
+{
+	if (!strcmp(strtab + id, "bpf_load_pointer")) {
+		static const struct bpf_func_proto proto = {RET_INTEGER};
+		return &proto;
+	}
+	if (!strcmp(strtab + id, "bpf_memcmp")) {
+		static const struct bpf_func_proto proto = {RET_INTEGER,
+			INVALID_PTR, PTR_TO_STACK_IMM,
+			CONST_ARG_STACK_IMM_SIZE};
+		return &proto;
+	}
+	if (!strcmp(strtab + id, "bpf_dump_stack")) {
+		static const struct bpf_func_proto proto = {RET_VOID,
+			PTR_TO_CTX};
+		return &proto;
+	}
+	if (!strcmp(strtab + id, "bpf_trace_printk")) {
+		static const struct bpf_func_proto proto = {RET_VOID,
+			PTR_TO_STACK_IMM, CONST_ARG_STACK_IMM_SIZE};
+		return &proto;
+	}
+	if (!strcmp(strtab + id, "bpf_table_lookup")) {
+		static const struct bpf_func_proto proto = {
+			PTR_TO_TABLE_CONDITIONAL, PTR_TO_CTX,
+			CONST_ARG_TABLE_ID, PTR_TO_STACK_IMM_TABLE_KEY};
+		return &proto;
+	}
+	if (!strcmp(strtab + id, "bpf_table_update")) {
+		static const struct bpf_func_proto proto = {RET_INTEGER,
+			PTR_TO_CTX, CONST_ARG_TABLE_ID,
+			PTR_TO_STACK_IMM_TABLE_KEY,
+			PTR_TO_STACK_IMM_TABLE_ELEM};
+		return &proto;
+	}
+	return NULL;
+}
+
+static void execute_func(char *strtab, int id, u64 *regs)
+{
+	regs[R0] = 0;
+
+	/*
+	 * strcmp-approach is not efficient.
+	 * TODO: optimize it for poor archs that don't have JIT yet
+	 */
+	if (!strcmp(strtab + id, "bpf_load_pointer")) {
+		regs[R0] = (u64)bpf_load_pointer((void *)regs[R1]);
+	} else if (!strcmp(strtab + id, "bpf_memcmp")) {
+		regs[R0] = (u64)bpf_memcmp((void *)regs[R1], (void *)regs[R2],
+					   (long)regs[R3]);
+	} else if (!strcmp(strtab + id, "bpf_dump_stack")) {
+		bpf_dump_stack((struct bpf_context *)regs[R1]);
+	} else if (!strcmp(strtab + id, "bpf_trace_printk")) {
+		bpf_trace_printk((char *)regs[R1], (long)regs[R2],
+				 (long)regs[R3], (long)regs[R4],
+				 (long)regs[R5]);
+	} else {
+		pr_err_once("trace cannot execute unknown bpf function %d '%s'\n",
+			    id, strtab + id);
+	}
+}
+
+static void *jit_select_func(char *strtab, int id)
+{
+	if (!strcmp(strtab + id, "bpf_load_pointer"))
+		return bpf_load_pointer;
+
+	if (!strcmp(strtab + id, "bpf_memcmp"))
+		return bpf_memcmp;
+
+	if (!strcmp(strtab + id, "bpf_dump_stack"))
+		return bpf_dump_stack;
+
+	if (!strcmp(strtab + id, "bpf_trace_printk"))
+		return bpf_trace_printk;
+
+	return NULL;
+}
+
+struct bpf_callbacks bpf_trace_cb = {
+	execute_func, jit_select_func, get_func_proto, get_context_access
+};
+
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 9d20cd9..c052936 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1758,6 +1758,13 @@ void __trace_stack(struct trace_array *tr, unsigned long flags, int skip,
 	__ftrace_trace_stack(tr->trace_buffer.buffer, flags, skip, pc, NULL);
 }
 
+void __trace_stack_regs(unsigned long flags, int skip, int pc,
+			struct pt_regs *regs)
+{
+	__ftrace_trace_stack(global_trace.trace_buffer.buffer, flags, skip,
+			     pc, regs);
+}
+
 /**
  * trace_dump_stack - record a stack back trace in the trace buffer
  * @skip: Number of functions to skip (helper handlers)
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index ea189e0..33d26aff 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -616,6 +616,8 @@ void ftrace_trace_userstack(struct ring_buffer *buffer, unsigned long flags,
 
 void __trace_stack(struct trace_array *tr, unsigned long flags, int skip,
 		   int pc);
+void __trace_stack_regs(unsigned long flags, int skip, int pc,
+			struct pt_regs *regs);
 #else
 static inline void ftrace_trace_stack(struct ring_buffer *buffer,
 				      unsigned long flags, int skip, int pc)
@@ -637,6 +639,10 @@ static inline void __trace_stack(struct trace_array *tr, unsigned long flags,
 				 int skip, int pc)
 {
 }
+static inline void __trace_stack_regs(unsigned long flags, int skip, int pc,
+				      struct pt_regs *regs)
+{
+}
 #endif /* CONFIG_STACKTRACE */
 
 extern cycle_t ftrace_now(int cpu);
@@ -936,12 +942,15 @@ struct ftrace_event_field {
 	int			is_signed;
 };
 
+struct bpf_program;
+
 struct event_filter {
 	int			n_preds;	/* Number assigned */
 	int			a_preds;	/* allocated */
 	struct filter_pred	*preds;
 	struct filter_pred	*root;
 	char			*filter_string;
+	struct bpf_program	*prog;
 };
 
 struct event_subsystem {
@@ -1014,7 +1023,7 @@ filter_parse_regex(char *buff, int len, char **search, int *not);
 extern void print_event_filter(struct ftrace_event_file *file,
 			       struct trace_seq *s);
 extern int apply_event_filter(struct ftrace_event_file *file,
-			      char *filter_string);
+			      char *filter_string, int filter_len);
 extern int apply_subsystem_event_filter(struct ftrace_subsystem_dir *dir,
 					char *filter_string);
 extern void print_subsystem_event_filter(struct event_subsystem *system,
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index f919a2e..deed25f 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -1041,9 +1041,16 @@ event_filter_write(struct file *filp, const char __user *ubuf, size_t cnt,
 	mutex_lock(&event_mutex);
 	file = event_file_data(filp);
 	if (file)
-		err = apply_event_filter(file, buf);
+		err = apply_event_filter(file, buf, cnt);
 	mutex_unlock(&event_mutex);
 
+	if (file->event_call->flags & TRACE_EVENT_FL_BPF)
+		/*
+		 * allocate per-cpu printk buffers, since BPF program
+		 * might be calling bpf_trace_printk
+		 */
+		trace_printk_init_buffers();
+
 	free_page((unsigned long) buf);
 	if (err < 0)
 		return err;
diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 2468f56..36c7bd6 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -23,6 +23,8 @@
 #include <linux/mutex.h>
 #include <linux/perf_event.h>
 #include <linux/slab.h>
+#include <linux/bpf_jit.h>
+#include <trace/bpf_trace.h>
 
 #include "trace.h"
 #include "trace_output.h"
@@ -535,6 +537,20 @@ static int filter_match_preds_cb(enum move_type move, struct filter_pred *pred,
 	return WALK_PRED_DEFAULT;
 }
 
+void filter_call_bpf(struct event_filter *filter, struct pt_regs *regs)
+{
+	BUG_ON(!filter || !filter->prog);
+
+	if (!filter->prog->jit_image) {
+		pr_warn_once("BPF jit image is not available. Fallback to emulation\n");
+		bpf_run(filter->prog, (struct bpf_context *)regs);
+		return;
+	}
+
+	filter->prog->jit_image((struct bpf_context *)regs);
+}
+EXPORT_SYMBOL_GPL(filter_call_bpf);
+
 /* return 1 if event matches, 0 otherwise (discard) */
 int filter_match_preds(struct event_filter *filter, void *rec)
 {
@@ -794,6 +810,7 @@ static void __free_filter(struct event_filter *filter)
 	if (!filter)
 		return;
 
+	bpf_free(filter->prog);
 	__free_preds(filter);
 	kfree(filter->filter_string);
 	kfree(filter);
@@ -1893,6 +1910,37 @@ static int create_filter_start(char *filter_str, bool set_str,
 	return err;
 }
 
+static int create_filter_bpf(char *filter_str, int filter_len,
+			     struct event_filter **filterp)
+{
+	struct event_filter *filter;
+	int err = 0;
+
+	*filterp = NULL;
+
+	filter = __alloc_filter();
+	if (filter)
+		err = replace_filter_string(filter, "bpf");
+
+	if (!filter || err) {
+		__free_filter(filter);
+		return -ENOMEM;
+	}
+
+	err = bpf_load_image(filter_str, filter_len, &bpf_trace_cb,
+			     &filter->prog);
+
+	if (err) {
+		pr_err("failed to load bpf %d\n", err);
+		__free_filter(filter);
+		return -EACCES;
+	}
+
+	*filterp = filter;
+
+	return err;
+}
+
 static void create_filter_finish(struct filter_parse_state *ps)
 {
 	if (ps) {
@@ -1973,7 +2021,8 @@ static int create_system_filter(struct event_subsystem *system,
 }
 
 /* caller must hold event_mutex */
-int apply_event_filter(struct ftrace_event_file *file, char *filter_string)
+int apply_event_filter(struct ftrace_event_file *file, char *filter_string,
+		       int filter_len)
 {
 	struct ftrace_event_call *call = file->event_call;
 	struct event_filter *filter;
@@ -1995,7 +2044,15 @@ int apply_event_filter(struct ftrace_event_file *file, char *filter_string)
 		return 0;
 	}
 
-	err = create_filter(call, filter_string, true, &filter);
+	if (!strcmp(filter_string, "bpf")) {
+		err = create_filter_bpf(filter_string, filter_len, &filter);
+		if (!err)
+			call->flags |= TRACE_EVENT_FL_BPF;
+	} else {
+		err = create_filter(call, filter_string, true, &filter);
+		if (!err)
+			call->flags &= ~TRACE_EVENT_FL_BPF;
+	}
 
 	/*
 	 * Always swap the call filter with the new filter
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index dae9541..e1a2187 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -819,6 +819,12 @@ __kprobe_trace_func(struct trace_probe *tp, struct pt_regs *regs,
 	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT, &ftrace_file->flags))
 		return;
 
+	if (unlikely(ftrace_file->flags & FTRACE_EVENT_FL_FILTERED) &&
+	    unlikely(ftrace_file->event_call->flags & TRACE_EVENT_FL_BPF)) {
+		filter_call_bpf(ftrace_file->filter, regs);
+		return;
+	}
+
 	local_save_flags(irq_flags);
 	pc = preempt_count();
 
-- 
1.7.9.5

