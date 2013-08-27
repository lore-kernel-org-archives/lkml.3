Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753342Ab3H0Itn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 04:49:43 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:52972 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753110Ab3H0ItH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 04:49:07 -0400
X-AuditID: 9c930197-b7b44ae00000347f-56-521c67fb49f7
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Namhyung Kim <namhyung.kim@lge.com>, Hyeoncheol Lee <cheol.lee@lge.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [PATCH 11/13] tracing/kprobes: Add priv argument to fetch functions
Date: Tue, 27 Aug 2013 17:48:54 +0900
Message-Id: <1377593336-16828-12-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1377593336-16828-1-git-send-email-namhyung@kernel.org>
References: <1377593336-16828-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

This argument is for passing private data structure to each fetch
function and will be used by uprobes.

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 kernel/trace/trace_kprobe.c | 32 ++++++++++++++++++--------------
 kernel/trace/trace_probe.c  | 24 ++++++++++++------------
 kernel/trace/trace_probe.h  | 19 ++++++++++---------
 kernel/trace/trace_uprobe.c |  8 ++++----
 4 files changed, 44 insertions(+), 39 deletions(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 3159b114f215..c0f4c2dbdbb1 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -745,7 +745,7 @@ static const struct file_operations kprobe_profile_ops = {
  */
 #define DEFINE_FETCH_stack(type)					\
 static __kprobes void FETCH_FUNC_NAME(stack, type)(struct pt_regs *regs,\
-					  void *offset, void *dest)	\
+				  void *offset, void *dest, void *priv) \
 {									\
 	*(type *)dest = (type)regs_get_kernel_stack_nth(regs,		\
 				(unsigned int)((unsigned long)offset));	\
@@ -757,7 +757,7 @@ DEFINE_BASIC_FETCH_FUNCS(stack)
 
 #define DEFINE_FETCH_memory(type)					\
 static __kprobes void FETCH_FUNC_NAME(memory, type)(struct pt_regs *regs,\
-					  void *addr, void *dest)	\
+				    void *addr, void *dest, void *priv) \
 {									\
 	type retval;							\
 	if (probe_kernel_address(addr, retval))				\
@@ -771,7 +771,7 @@ DEFINE_BASIC_FETCH_FUNCS(memory)
  * length and relative data location.
  */
 static __kprobes void FETCH_FUNC_NAME(memory, string)(struct pt_regs *regs,
-					       void *addr, void *dest)
+					void *addr, void *dest, void *priv)
 {
 	long ret;
 	int maxlen = get_rloc_len(*(u32 *)dest);
@@ -808,7 +808,7 @@ static __kprobes void FETCH_FUNC_NAME(memory, string)(struct pt_regs *regs,
 
 /* Return the length of string -- including null terminal byte */
 static __kprobes void FETCH_FUNC_NAME(memory, string_size)(struct pt_regs *regs,
-						    void *addr, void *dest)
+					   void *addr, void *dest, void *priv)
 {
 	mm_segment_t old_fs;
 	int ret, len = 0;
@@ -879,11 +879,11 @@ struct symbol_cache *alloc_symbol_cache(const char *sym, long offset)
 
 #define DEFINE_FETCH_symbol(type)					\
 __kprobes void FETCH_FUNC_NAME(symbol, type)(struct pt_regs *regs,	\
-					  void *data, void *dest)	\
+				    void *data, void *dest, void *priv)	\
 {									\
 	struct symbol_cache *sc = data;					\
 	if (sc->addr)							\
-		fetch_memory_##type(regs, (void *)sc->addr, dest);	\
+		fetch_memory_##type(regs, (void *)sc->addr, dest, priv);\
 	else								\
 		*(type *)dest = 0;					\
 }
@@ -929,7 +929,7 @@ __kprobe_trace_func(struct trace_kprobe *tp, struct pt_regs *regs,
 	local_save_flags(irq_flags);
 	pc = preempt_count();
 
-	dsize = __get_data_size(&tp->p, regs);
+	dsize = __get_data_size(&tp->p, regs, NULL);
 	size = sizeof(*entry) + tp->p.size + dsize;
 
 	event = trace_event_buffer_lock_reserve(&buffer, ftrace_file,
@@ -940,7 +940,8 @@ __kprobe_trace_func(struct trace_kprobe *tp, struct pt_regs *regs,
 
 	entry = ring_buffer_event_data(event);
 	entry->ip = (unsigned long)tp->rp.kp.addr;
-	store_trace_args(sizeof(*entry), &tp->p, regs, (u8 *)&entry[1], dsize);
+	store_trace_args(sizeof(*entry), &tp->p, regs, (u8 *)&entry[1], dsize,
+			 NULL);
 
 	if (!filter_current_check_discard(buffer, call, entry, event))
 		trace_buffer_unlock_commit_regs(buffer, event,
@@ -977,7 +978,7 @@ __kretprobe_trace_func(struct trace_kprobe *tp, struct kretprobe_instance *ri,
 	local_save_flags(irq_flags);
 	pc = preempt_count();
 
-	dsize = __get_data_size(&tp->p, regs);
+	dsize = __get_data_size(&tp->p, regs, NULL);
 	size = sizeof(*entry) + tp->p.size + dsize;
 
 	event = trace_event_buffer_lock_reserve(&buffer, ftrace_file,
@@ -989,7 +990,8 @@ __kretprobe_trace_func(struct trace_kprobe *tp, struct kretprobe_instance *ri,
 	entry = ring_buffer_event_data(event);
 	entry->func = (unsigned long)tp->rp.kp.addr;
 	entry->ret_ip = (unsigned long)ri->ret_addr;
-	store_trace_args(sizeof(*entry), &tp->p, regs, (u8 *)&entry[1], dsize);
+	store_trace_args(sizeof(*entry), &tp->p, regs, (u8 *)&entry[1], dsize,
+			 NULL);
 
 	if (!filter_current_check_discard(buffer, call, entry, event))
 		trace_buffer_unlock_commit_regs(buffer, event,
@@ -1149,7 +1151,7 @@ kprobe_perf_func(struct trace_kprobe *tp, struct pt_regs *regs)
 	if (hlist_empty(head))
 		return;
 
-	dsize = __get_data_size(&tp->p, regs);
+	dsize = __get_data_size(&tp->p, regs, NULL);
 	__size = sizeof(*entry) + tp->p.size + dsize;
 	size = ALIGN(__size + sizeof(u32), sizeof(u64));
 	size -= sizeof(u32);
@@ -1160,7 +1162,8 @@ kprobe_perf_func(struct trace_kprobe *tp, struct pt_regs *regs)
 
 	entry->ip = (unsigned long)tp->rp.kp.addr;
 	memset(&entry[1], 0, dsize);
-	store_trace_args(sizeof(*entry), &tp->p, regs, (u8 *)&entry[1], dsize);
+	store_trace_args(sizeof(*entry), &tp->p, regs, (u8 *)&entry[1], dsize,
+			 NULL);
 	perf_trace_buf_submit(entry, size, rctx, 0, 1, regs, head, NULL);
 }
 
@@ -1179,7 +1182,7 @@ kretprobe_perf_func(struct trace_kprobe *tp, struct kretprobe_instance *ri,
 	if (hlist_empty(head))
 		return;
 
-	dsize = __get_data_size(&tp->p, regs);
+	dsize = __get_data_size(&tp->p, regs, NULL);
 	__size = sizeof(*entry) + tp->p.size + dsize;
 	size = ALIGN(__size + sizeof(u32), sizeof(u64));
 	size -= sizeof(u32);
@@ -1190,7 +1193,8 @@ kretprobe_perf_func(struct trace_kprobe *tp, struct kretprobe_instance *ri,
 
 	entry->func = (unsigned long)tp->rp.kp.addr;
 	entry->ret_ip = (unsigned long)ri->ret_addr;
-	store_trace_args(sizeof(*entry), &tp->p, regs, (u8 *)&entry[1], dsize);
+	store_trace_args(sizeof(*entry), &tp->p, regs, (u8 *)&entry[1], dsize,
+			 NULL);
 	perf_trace_buf_submit(entry, size, rctx, 0, 1, regs, head, NULL);
 }
 #endif	/* CONFIG_PERF_EVENTS */
diff --git a/kernel/trace/trace_probe.c b/kernel/trace/trace_probe.c
index 1ab83d4c7775..eaee44d5d9d1 100644
--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -78,7 +78,7 @@ const char PRINT_TYPE_FMT_NAME(string)[] = "\\\"%s\\\"";
 /* Data fetch function templates */
 #define DEFINE_FETCH_reg(type)						\
 __kprobes void FETCH_FUNC_NAME(reg, type)(struct pt_regs *regs,		\
-					void *offset, void *dest)	\
+				  void *offset, void *dest, void *priv)	\
 {									\
 	*(type *)dest = (type)regs_get_register(regs,			\
 				(unsigned int)((unsigned long)offset));	\
@@ -87,7 +87,7 @@ DEFINE_BASIC_FETCH_FUNCS(reg)
 
 #define DEFINE_FETCH_retval(type)					\
 __kprobes void FETCH_FUNC_NAME(retval, type)(struct pt_regs *regs,	\
-					  void *dummy, void *dest)	\
+				   void *dummy, void *dest, void *priv)	\
 {									\
 	*(type *)dest = (type)regs_return_value(regs);			\
 }
@@ -103,14 +103,14 @@ struct deref_fetch_param {
 
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
@@ -118,15 +118,15 @@ DEFINE_BASIC_FETCH_FUNCS(deref)
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
@@ -156,12 +156,12 @@ struct bitfield_fetch_param {
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
@@ -249,7 +249,7 @@ fail:
 
 /* Special function : only accept unsigned long */
 static __kprobes void fetch_stack_address(struct pt_regs *regs,
-					void *dummy, void *dest)
+					  void *dummy, void *dest, void *priv)
 {
 	*(unsigned long *)dest = kernel_stack_pointer(regs);
 }
diff --git a/kernel/trace/trace_probe.h b/kernel/trace/trace_probe.h
index 325989f24dbf..fc7edf3749ef 100644
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
 
 struct symbol_cache;
@@ -305,14 +306,14 @@ extern int traceprobe_command(const char *buf, int (*createfn)(int, char**));
 
 /* Sum up total data length for dynamic arraies (strings) */
 static inline __kprobes int
-__get_data_size(struct trace_probe *tp, struct pt_regs *regs)
+__get_data_size(struct trace_probe *tp, struct pt_regs *regs, void *priv)
 {
 	int i, ret = 0;
 	u32 len;
 
 	for (i = 0; i < tp->nr_args; i++)
 		if (unlikely(tp->args[i].fetch_size.fn)) {
-			call_fetch(&tp->args[i].fetch_size, regs, &len);
+			call_fetch(&tp->args[i].fetch_size, regs, &len, priv);
 			ret += len;
 		}
 
@@ -322,7 +323,7 @@ __get_data_size(struct trace_probe *tp, struct pt_regs *regs)
 /* Store the value of each argument */
 static inline __kprobes void
 store_trace_args(int ent_size, struct trace_probe *tp, struct pt_regs *regs,
-		 u8 *data, int maxlen)
+		 u8 *data, int maxlen, void *priv)
 {
 	int i;
 	u32 end = tp->size;
@@ -337,7 +338,7 @@ store_trace_args(int ent_size, struct trace_probe *tp, struct pt_regs *regs,
 			dl = (u32 *)(data + tp->args[i].offset);
 			*dl = make_data_rloc(maxlen, end - tp->args[i].offset);
 			/* Then try to fetch string or dynamic array data */
-			call_fetch(&tp->args[i].fetch, regs, dl);
+			call_fetch(&tp->args[i].fetch, regs, dl, priv);
 			/* Reduce maximum length */
 			end += get_rloc_len(*dl);
 			maxlen -= get_rloc_len(*dl);
@@ -347,7 +348,7 @@ store_trace_args(int ent_size, struct trace_probe *tp, struct pt_regs *regs,
 		} else
 			/* Just fetching data normally */
 			call_fetch(&tp->args[i].fetch, regs,
-				   data + tp->args[i].offset);
+				   data + tp->args[i].offset, priv);
 	}
 }
 
diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index 9ede401759ab..fc5f8aa62156 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -546,7 +546,7 @@ static void uprobe_trace_print(struct trace_uprobe *tu,
 	int cpu;
 	struct ftrace_event_call *call = &tu->p.call;
 
-	dsize = __get_data_size(&tu->p, regs);
+	dsize = __get_data_size(&tu->p, regs, NULL);
 	esize = SIZEOF_TRACE_ENTRY(is_ret_probe(tu));
 
 	if (WARN_ON_ONCE(!uprobe_cpu_buffer || tu->p.size + dsize > PAGE_SIZE))
@@ -561,7 +561,7 @@ static void uprobe_trace_print(struct trace_uprobe *tu,
 	 * so the mutex makes sure we have sole access to it.
 	 */
 	mutex_lock(mutex);
-	store_trace_args(esize, &tu->p, regs, arg_buf, dsize);
+	store_trace_args(esize, &tu->p, regs, arg_buf, dsize, NULL);
 
 	size = esize + tu->p.size + dsize;
 	event = trace_current_buffer_lock_reserve(&buffer, call->event.type,
@@ -822,7 +822,7 @@ static void uprobe_perf_print(struct trace_uprobe *tu,
 	int cpu;
 	int rctx;
 
-	dsize = __get_data_size(&tu->p, regs);
+	dsize = __get_data_size(&tu->p, regs, NULL);
 	esize = SIZEOF_TRACE_ENTRY(is_ret_probe(tu));
 
 	if (WARN_ON_ONCE(!uprobe_cpu_buffer))
@@ -842,7 +842,7 @@ static void uprobe_perf_print(struct trace_uprobe *tu,
 	 * so the mutex makes sure we have sole access to it.
 	 */
 	mutex_lock(mutex);
-	store_trace_args(esize, &tu->p, regs, arg_buf, dsize);
+	store_trace_args(esize, &tu->p, regs, arg_buf, dsize, NULL);
 
 	preempt_disable();
 	head = this_cpu_ptr(call->perf_events);
-- 
1.7.11.7

