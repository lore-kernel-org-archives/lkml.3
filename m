Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932842Ab3GCMgc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 08:36:32 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:50635 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932744Ab3GCMf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 08:35:56 -0400
X-AuditID: 9c93017e-b7c04ae00000295f-f5-51d41aa5a259
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Hyeoncheol Lee <cheol.lee@lge.com>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [PATCH 10/12] tracing/kprobes: Add priv argument to fetch functions
Date: Wed,  3 Jul 2013 21:35:44 +0900
Message-Id: <1372854946-17074-11-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1372854946-17074-1-git-send-email-namhyung@kernel.org>
References: <1372854946-17074-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

This argument is for passing private data structure to each fetch
function and will be used by uprobes.

Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 kernel/trace/trace_kprobe.c | 28 ++++++++++++++++------------
 kernel/trace/trace_probe.c  | 44 +++++++++++++++++++++++---------------------
 kernel/trace/trace_probe.h  | 15 +++++++++------
 kernel/trace/trace_uprobe.c |  8 ++++----
 4 files changed, 52 insertions(+), 43 deletions(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 52b02e50a600..308de4adeda8 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -787,7 +787,7 @@ static const struct file_operations kprobe_profile_ops = {
  */
 #define DEFINE_FETCH_stack(type)					\
 static __kprobes void FETCH_FUNC_NAME(stack, type)(struct pt_regs *regs,\
-					  void *offset, void *dest)	\
+				  void *offset, void *dest, void *priv) \
 {									\
 	*(type *)dest = (type)regs_get_kernel_stack_nth(regs,		\
 				(unsigned int)((unsigned long)offset));	\
@@ -799,7 +799,7 @@ DEFINE_BASIC_FETCH_FUNCS(stack)
 
 #define DEFINE_FETCH_memory(type)					\
 static __kprobes void FETCH_FUNC_NAME(memory, type)(struct pt_regs *regs,\
-					  void *addr, void *dest)	\
+				    void *addr, void *dest, void *priv) \
 {									\
 	type retval;							\
 	if (probe_kernel_address(addr, retval))				\
@@ -813,7 +813,7 @@ DEFINE_BASIC_FETCH_FUNCS(memory)
  * length and relative data location.
  */
 static __kprobes void FETCH_FUNC_NAME(memory, string)(struct pt_regs *regs,
-					       void *addr, void *dest)
+					void *addr, void *dest, void *priv)
 {
 	long ret;
 	int maxlen = get_rloc_len(*(u32 *)dest);
@@ -850,7 +850,7 @@ static __kprobes void FETCH_FUNC_NAME(memory, string)(struct pt_regs *regs,
 
 /* Return the length of string -- including null terminal byte */
 static __kprobes void FETCH_FUNC_NAME(memory, string_size)(struct pt_regs *regs,
-						    void *addr, void *dest)
+					   void *addr, void *dest, void *priv)
 {
 	mm_segment_t old_fs;
 	int ret, len = 0;
@@ -912,7 +912,7 @@ __kprobe_trace_func(struct trace_kprobe *tp, struct pt_regs *regs,
 	local_save_flags(irq_flags);
 	pc = preempt_count();
 
-	dsize = __get_data_size(&tp->p, regs);
+	dsize = __get_data_size(&tp->p, regs, NULL);
 	size = sizeof(*entry) + tp->p.size + dsize;
 
 	event = trace_event_buffer_lock_reserve(&buffer, ftrace_file,
@@ -923,7 +923,8 @@ __kprobe_trace_func(struct trace_kprobe *tp, struct pt_regs *regs,
 
 	entry = ring_buffer_event_data(event);
 	entry->ip = (unsigned long)tp->rp.kp.addr;
-	store_trace_args(sizeof(*entry), &tp->p, regs, (u8 *)&entry[1], dsize);
+	store_trace_args(sizeof(*entry), &tp->p, regs, (u8 *)&entry[1], dsize,
+			 NULL);
 
 	if (!filter_current_check_discard(buffer, call, entry, event))
 		trace_buffer_unlock_commit_regs(buffer, event,
@@ -970,7 +971,7 @@ __kretprobe_trace_func(struct trace_kprobe *tp, struct kretprobe_instance *ri,
 	local_save_flags(irq_flags);
 	pc = preempt_count();
 
-	dsize = __get_data_size(&tp->p, regs);
+	dsize = __get_data_size(&tp->p, regs, NULL);
 	size = sizeof(*entry) + tp->p.size + dsize;
 
 	event = trace_event_buffer_lock_reserve(&buffer, ftrace_file,
@@ -982,7 +983,8 @@ __kretprobe_trace_func(struct trace_kprobe *tp, struct kretprobe_instance *ri,
 	entry = ring_buffer_event_data(event);
 	entry->func = (unsigned long)tp->rp.kp.addr;
 	entry->ret_ip = (unsigned long)ri->ret_addr;
-	store_trace_args(sizeof(*entry), &tp->p, regs, (u8 *)&entry[1], dsize);
+	store_trace_args(sizeof(*entry), &tp->p, regs, (u8 *)&entry[1], dsize,
+			 NULL);
 
 	if (!filter_current_check_discard(buffer, call, entry, event))
 		trace_buffer_unlock_commit_regs(buffer, event,
@@ -1148,7 +1150,7 @@ kprobe_perf_func(struct trace_kprobe *tp, struct pt_regs *regs)
 	int size, __size, dsize;
 	int rctx;
 
-	dsize = __get_data_size(&tp->p, regs);
+	dsize = __get_data_size(&tp->p, regs, NULL);
 	__size = sizeof(*entry) + tp->p.size + dsize;
 	size = ALIGN(__size + sizeof(u32), sizeof(u64));
 	size -= sizeof(u32);
@@ -1162,7 +1164,8 @@ kprobe_perf_func(struct trace_kprobe *tp, struct pt_regs *regs)
 
 	entry->ip = (unsigned long)tp->rp.kp.addr;
 	memset(&entry[1], 0, dsize);
-	store_trace_args(sizeof(*entry), &tp->p, regs, (u8 *)&entry[1], dsize);
+	store_trace_args(sizeof(*entry), &tp->p, regs, (u8 *)&entry[1], dsize,
+			 NULL);
 
 	head = this_cpu_ptr(call->perf_events);
 	perf_trace_buf_submit(entry, size, rctx,
@@ -1180,7 +1183,7 @@ kretprobe_perf_func(struct trace_kprobe *tp, struct kretprobe_instance *ri,
 	int size, __size, dsize;
 	int rctx;
 
-	dsize = __get_data_size(&tp->p, regs);
+	dsize = __get_data_size(&tp->p, regs, NULL);
 	__size = sizeof(*entry) + tp->p.size + dsize;
 	size = ALIGN(__size + sizeof(u32), sizeof(u64));
 	size -= sizeof(u32);
@@ -1194,7 +1197,8 @@ kretprobe_perf_func(struct trace_kprobe *tp, struct kretprobe_instance *ri,
 
 	entry->func = (unsigned long)tp->rp.kp.addr;
 	entry->ret_ip = (unsigned long)ri->ret_addr;
-	store_trace_args(sizeof(*entry), &tp->p, regs, (u8 *)&entry[1], dsize);
+	store_trace_args(sizeof(*entry), &tp->p, regs, (u8 *)&entry[1], dsize,
+			 NULL);
 
 	head = this_cpu_ptr(call->perf_events);
 	perf_trace_buf_submit(entry, size, rctx,
diff --git a/kernel/trace/trace_probe.c b/kernel/trace/trace_probe.c
index 76ab02143b5a..029ffc401e39 100644
--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -73,7 +73,7 @@ const char PRINT_TYPE_FMT_NAME(string)[] = "\\\"%s\\\"";
 /* Data fetch function templates */
 #define DEFINE_FETCH_reg(type)						\
 __kprobes void FETCH_FUNC_NAME(reg, type)(struct pt_regs *regs,		\
-					void *offset, void *dest)	\
+				  void *offset, void *dest, void *priv)	\
 {									\
 	*(type *)dest = (type)regs_get_register(regs,			\
 				(unsigned int)((unsigned long)offset));	\
@@ -82,7 +82,7 @@ DEFINE_BASIC_FETCH_FUNCS(reg)
 
 #define DEFINE_FETCH_retval(type)					\
 __kprobes void FETCH_FUNC_NAME(retval, type)(struct pt_regs *regs,	\
-					  void *dummy, void *dest)	\
+				   void *dummy, void *dest, void *priv)	\
 {									\
 	*(type *)dest = (type)regs_return_value(regs);			\
 }
@@ -137,11 +137,11 @@ static struct symbol_cache *alloc_symbol_cache(const char *sym, long offset)
 
 #define DEFINE_FETCH_symbol(type)					\
 __kprobes void FETCH_FUNC_NAME(symbol, type)(struct pt_regs *regs,	\
-					  void *data, void *dest)	\
+				    void *data, void *dest, void *priv)	\
 {									\
 	struct symbol_cache *sc = data;					\
 	if (sc->addr)							\
-		sc->fetch(regs, (void *)sc->addr, dest);		\
+		sc->fetch(regs, (void *)sc->addr, dest, priv);		\
 	else								\
 		*(type *)dest = 0;					\
 }
@@ -149,11 +149,11 @@ DEFINE_BASIC_FETCH_FUNCS(symbol)
 DEFINE_FETCH_symbol(string)
 
 __kprobes void FETCH_FUNC_NAME(symbol, string_size)(struct pt_regs *regs,
-						    void *data, void *dest)
+					void *data, void *dest, void *priv)
 {
 	struct symbol_cache *sc = data;
 	if (sc->addr && sc->fetch_size)
-		sc->fetch_size(regs, (void *)sc->addr, dest);
+		sc->fetch_size(regs, (void *)sc->addr, dest, priv);
 	else
 		*(string_size *)dest = 0;
 }
@@ -168,14 +168,14 @@ struct deref_fetch_param {
 
 #define DEFINE_FETCH_deref(type)					\
 __kprobes void FETCH_FUNC_NAME(deref, type)(struct pt_regs *regs,	\
-					    void *data, void *dest)	\
+				    void *data, void *dest, void *priv)	\
 {									\
 	struct deref_fetch_param *dprm = data;				\
 	unsigned long addr;						\
-	call_fetch(&dprm->orig, regs, &addr);				\
+	call_fetch(&dprm->orig, regs, &addr, priv);			\
 	if (addr) {							\
 		addr += dprm->offset;					\
-		dprm->fetch(regs, (void *)addr, dest);			\
+		dprm->fetch(regs, (void *)addr, dest, priv);		\
 	} else								\
 		*(type *)dest = 0;					\
 }
@@ -183,15 +183,15 @@ DEFINE_BASIC_FETCH_FUNCS(deref)
 DEFINE_FETCH_deref(string)
 
 __kprobes void FETCH_FUNC_NAME(deref, string_size)(struct pt_regs *regs,
-						   void *data, void *dest)
+					void *data, void *dest, void *priv)
 {
 	struct deref_fetch_param *dprm = data;
 	unsigned long addr;
 
-	call_fetch(&dprm->orig, regs, &addr);
+	call_fetch(&dprm->orig, regs, &addr, priv);
 	if (addr && dprm->fetch_size) {
 		addr += dprm->offset;
-		dprm->fetch_size(regs, (void *)addr, dest);
+		dprm->fetch_size(regs, (void *)addr, dest, priv);
 	} else
 		*(string_size *)dest = 0;
 }
@@ -221,12 +221,12 @@ struct bitfield_fetch_param {
 };
 
 #define DEFINE_FETCH_bitfield(type)					\
-__kprobes void FETCH_FUNC_NAME(bitfield, type)(struct pt_regs *regs,\
-					    void *data, void *dest)	\
+__kprobes void FETCH_FUNC_NAME(bitfield, type)(struct pt_regs *regs,	\
+				    void *data, void *dest, void *priv)	\
 {									\
 	struct bitfield_fetch_param *bprm = data;			\
 	type buf = 0;							\
-	call_fetch(&bprm->orig, regs, &buf);				\
+	call_fetch(&bprm->orig, regs, &buf, priv);			\
 	if (buf) {							\
 		buf <<= bprm->hi_shift;					\
 		buf >>= bprm->low_shift;				\
@@ -314,7 +314,7 @@ fail:
 
 /* Special function : only accept unsigned long */
 static __kprobes void fetch_stack_address(struct pt_regs *regs,
-					void *dummy, void *dest)
+					  void *dummy, void *dest, void *priv)
 {
 	*(unsigned long *)dest = kernel_stack_pointer(regs);
 }
@@ -703,14 +703,15 @@ out:
 }
 
 /* Sum up total data length for dynamic arraies (strings) */
-__kprobes int __get_data_size(struct trace_probe *tp, struct pt_regs *regs)
+__kprobes int __get_data_size(struct trace_probe *tp, struct pt_regs *regs,
+			      void *priv)
 {
 	int i, ret = 0;
 	u32 len;
 
 	for (i = 0; i < tp->nr_args; i++)
 		if (unlikely(tp->args[i].fetch_size.fn)) {
-			call_fetch(&tp->args[i].fetch_size, regs, &len);
+			call_fetch(&tp->args[i].fetch_size, regs, &len, priv);
 			ret += len;
 		}
 
@@ -719,7 +720,8 @@ __kprobes int __get_data_size(struct trace_probe *tp, struct pt_regs *regs)
 
 /* Store the value of each argument */
 __kprobes void store_trace_args(int ent_size, struct trace_probe *tp,
-				struct pt_regs *regs, u8 *data, int maxlen)
+				struct pt_regs *regs, u8 *data, int maxlen,
+				void *priv)
 {
 	int i;
 	u32 end = tp->size;
@@ -734,7 +736,7 @@ __kprobes void store_trace_args(int ent_size, struct trace_probe *tp,
 			dl = (u32 *)(data + tp->args[i].offset);
 			*dl = make_data_rloc(maxlen, end - tp->args[i].offset);
 			/* Then try to fetch string or dynamic array data */
-			call_fetch(&tp->args[i].fetch, regs, dl);
+			call_fetch(&tp->args[i].fetch, regs, dl, priv);
 			/* Reduce maximum length */
 			end += get_rloc_len(*dl);
 			maxlen -= get_rloc_len(*dl);
@@ -744,7 +746,7 @@ __kprobes void store_trace_args(int ent_size, struct trace_probe *tp,
 		} else
 			/* Just fetching data normally */
 			call_fetch(&tp->args[i].fetch, regs,
-				   data + tp->args[i].offset);
+				   data + tp->args[i].offset, priv);
 	}
 }
 
diff --git a/kernel/trace/trace_probe.h b/kernel/trace/trace_probe.h
index 2112e50bd62a..a4f56015bfa3 100644
--- a/kernel/trace/trace_probe.h
+++ b/kernel/trace/trace_probe.h
@@ -98,7 +98,7 @@ typedef u32 string;
 typedef u32 string_size;
 
 /* Data fetch function type */
-typedef	void (*fetch_func_t)(struct pt_regs *, void *, void *);
+typedef	void (*fetch_func_t)(struct pt_regs *, void *, void *, void *);
 /* Printing function type */
 typedef int (*print_type_func_t)(struct trace_seq *, const char *, void *, void *);
 
@@ -182,7 +182,8 @@ static inline bool trace_probe_is_registered(struct trace_probe *tp)
 #define FETCH_FUNC_NAME(method, type)	fetch_##method##_##type
 
 #define DECLARE_FETCH_FUNC(method, type)				\
-extern void FETCH_FUNC_NAME(method, type)(struct pt_regs *, void *, void *)
+extern void FETCH_FUNC_NAME(method, type)(struct pt_regs *, void *,	\
+					  void *, void *)
 
 #define DECLARE_BASIC_FETCH_FUNCS(method) 	\
 DECLARE_FETCH_FUNC(method, u8);	  		\
@@ -264,9 +265,9 @@ ASSIGN_FETCH_FUNC(bitfield, ftype),			\
 extern const struct fetch_type kprobes_fetch_type_table[];
 
 static inline __kprobes void call_fetch(struct fetch_param *fprm,
-				 struct pt_regs *regs, void *dest)
+				 struct pt_regs *regs, void *dest, void *priv)
 {
-	return fprm->fn(regs, fprm->data, dest);
+	return fprm->fn(regs, fprm->data, dest, priv);
 }
 
 /* Check the name is good for event/group/fields */
@@ -298,7 +299,9 @@ extern ssize_t traceprobe_probes_write(struct file *file,
 
 extern int traceprobe_command(const char *buf, int (*createfn)(int, char**));
 
-extern int __get_data_size(struct trace_probe *tp, struct pt_regs *regs);
+extern int __get_data_size(struct trace_probe *tp, struct pt_regs *regs,
+			   void *priv);
 extern void store_trace_args(int ent_size, struct trace_probe *tp,
-			     struct pt_regs *regs, u8 *data, int maxlen);
+			     struct pt_regs *regs, u8 *data, int maxlen,
+			     void *priv);
 extern int set_print_fmt(struct trace_probe *tp, bool is_return);
diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index 8c1cf7cfa181..63e44b52192a 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -518,7 +518,7 @@ static void uprobe_trace_print(struct trace_uprobe *tu,
 	int size, dsize, esize;
 	struct ftrace_event_call *call = &tu->p.call;
 
-	dsize = __get_data_size(&tu->p, regs);
+	dsize = __get_data_size(&tu->p, regs, NULL);
 	esize = SIZEOF_TRACE_ENTRY(is_ret_probe(tu));
 
 	/*
@@ -530,7 +530,7 @@ static void uprobe_trace_print(struct trace_uprobe *tu,
 	if (tmp == NULL)
 		return;
 
-	store_trace_args(esize, &tu->p, regs, tmp, dsize);
+	store_trace_args(esize, &tu->p, regs, tmp, dsize, NULL);
 
 	size = esize + tu->p.size + dsize;
 	event = trace_current_buffer_lock_reserve(&buffer, call->event.type,
@@ -773,7 +773,7 @@ static void uprobe_perf_print(struct trace_uprobe *tu,
 	int size, dsize, esize;
 	int rctx;
 
-	dsize = __get_data_size(&tu->p, regs);
+	dsize = __get_data_size(&tu->p, regs, NULL);
 	esize = SIZEOF_TRACE_ENTRY(is_ret_probe(tu));
 
 	/*
@@ -785,7 +785,7 @@ static void uprobe_perf_print(struct trace_uprobe *tu,
 	if (tmp == NULL)
 		return;
 
-	store_trace_args(esize, &tu->p, regs, tmp, dsize);
+	store_trace_args(esize, &tu->p, regs, tmp, dsize, NULL);
 
 	size = esize + tu->p.size + dsize;
 	size = ALIGN(size + + sizeof(u32), sizeof(u64)) - sizeof(u32);
-- 
1.7.11.7

