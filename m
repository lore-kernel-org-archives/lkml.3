Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753282Ab3H0Itj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 04:49:39 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:54307 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753124Ab3H0ItI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 04:49:08 -0400
X-AuditID: 9c930197-b7b44ae00000347f-57-521c67fbd24b
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Namhyung Kim <namhyung.kim@lge.com>, Hyeoncheol Lee <cheol.lee@lge.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [PATCH 12/13] tracing/uprobes: Add more fetch functions
Date: Tue, 27 Aug 2013 17:48:55 +0900
Message-Id: <1377593336-16828-13-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1377593336-16828-1-git-send-email-namhyung@kernel.org>
References: <1377593336-16828-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Implement uprobe-specific stack and memory fetch functions and add
them to the uprobes_fetch_type_table.  Other fetch fucntions will be
shared with kprobes.

Original-patch-by: Hyeoncheol Lee <cheol.lee@lge.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 kernel/trace/trace_probe.c  |   9 ++-
 kernel/trace/trace_probe.h  |   1 +
 kernel/trace/trace_uprobe.c | 188 +++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 192 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/trace_probe.c b/kernel/trace/trace_probe.c
index eaee44d5d9d1..70cd3bfde5a6 100644
--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -101,6 +101,10 @@ struct deref_fetch_param {
 	fetch_func_t		fetch_size;
 };
 
+/*
+ * For uprobes, it'll get a vaddr from first call_fetch() so pass NULL
+ * as a priv on the second dprm->fetch() not to translate it to vaddr again.
+ */
 #define DEFINE_FETCH_deref(type)					\
 __kprobes void FETCH_FUNC_NAME(deref, type)(struct pt_regs *regs,	\
 				    void *data, void *dest, void *priv)	\
@@ -110,13 +114,14 @@ __kprobes void FETCH_FUNC_NAME(deref, type)(struct pt_regs *regs,	\
 	call_fetch(&dprm->orig, regs, &addr, priv);			\
 	if (addr) {							\
 		addr += dprm->offset;					\
-		dprm->fetch(regs, (void *)addr, dest, priv);		\
+		dprm->fetch(regs, (void *)addr, dest, NULL);		\
 	} else								\
 		*(type *)dest = 0;					\
 }
 DEFINE_BASIC_FETCH_FUNCS(deref)
 DEFINE_FETCH_deref(string)
 
+/* Same as above */
 __kprobes void FETCH_FUNC_NAME(deref, string_size)(struct pt_regs *regs,
 					void *data, void *dest, void *priv)
 {
@@ -126,7 +131,7 @@ __kprobes void FETCH_FUNC_NAME(deref, string_size)(struct pt_regs *regs,
 	call_fetch(&dprm->orig, regs, &addr, priv);
 	if (addr && dprm->fetch_size) {
 		addr += dprm->offset;
-		dprm->fetch_size(regs, (void *)addr, dest, priv);
+		dprm->fetch_size(regs, (void *)addr, dest, NULL);
 	} else
 		*(string_size *)dest = 0;
 }
diff --git a/kernel/trace/trace_probe.h b/kernel/trace/trace_probe.h
index fc7edf3749ef..b1e7d722c354 100644
--- a/kernel/trace/trace_probe.h
+++ b/kernel/trace/trace_probe.h
@@ -263,6 +263,7 @@ ASSIGN_FETCH_FUNC(bitfield, ftype),			\
 #define NR_FETCH_TYPES		10
 
 extern const struct fetch_type kprobes_fetch_type_table[];
+extern const struct fetch_type uprobes_fetch_type_table[];
 
 static inline __kprobes void call_fetch(struct fetch_param *fprm,
 				 struct pt_regs *regs, void *dest, void *priv)
diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index fc5f8aa62156..89d4b86abbe1 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -530,6 +530,186 @@ static const struct file_operations uprobe_profile_ops = {
 	.release	= seq_release,
 };
 
+#ifdef CONFIG_STACK_GROWSUP
+static unsigned long adjust_stack_addr(unsigned long addr, unsigned n)
+{
+	return addr - (n * sizeof(long));
+}
+
+static bool within_user_stack(struct vm_area_struct *vma, unsigned long addr,
+			      unsigned int n)
+{
+	return vma->vm_start <= adjust_stack_addr(addr, n);
+}
+#else
+static unsigned long adjust_stack_addr(unsigned long addr, unsigned n)
+{
+	return addr + (n * sizeof(long));
+}
+
+static bool within_user_stack(struct vm_area_struct *vma, unsigned long addr,
+			      unsigned int n)
+{
+	return vma->vm_end >= adjust_stack_addr(addr, n);
+}
+#endif
+
+static unsigned long get_user_stack_nth(struct pt_regs *regs, unsigned int n)
+{
+	struct vm_area_struct *vma;
+	unsigned long addr = GET_USP(regs);
+	bool valid = false;
+	unsigned long ret = 0;
+
+	down_read(&current->mm->mmap_sem);
+	vma = find_vma(current->mm, addr);
+	if (vma && vma->vm_start <= addr) {
+		if (within_user_stack(vma, addr, n))
+			valid = true;
+	}
+	up_read(&current->mm->mmap_sem);
+
+	addr = adjust_stack_addr(addr, n);
+
+	if (valid && copy_from_user(&ret, (void __force __user *)addr,
+				    sizeof(ret)) == 0)
+		return ret;
+	return 0;
+}
+
+static unsigned long offset_to_vaddr(struct vm_area_struct *vma,
+				     unsigned long offset)
+{
+	return vma->vm_start + offset - ((loff_t)vma->vm_pgoff << PAGE_SHIFT);
+}
+
+static void __user *get_user_vaddr(unsigned long addr, struct trace_uprobe *tu)
+{
+	unsigned long pgoff = addr >> PAGE_SHIFT;
+	struct vm_area_struct *vma;
+	struct address_space *mapping;
+	unsigned long vaddr = 0;
+
+	if (tu == NULL) {
+		/* A NULL tu means that we already got the vaddr */
+		return (void __force __user *) addr;
+	}
+
+	mapping = tu->inode->i_mapping;
+
+	mutex_lock(&mapping->i_mmap_mutex);
+	vma_interval_tree_foreach(vma, &mapping->i_mmap, pgoff, pgoff) {
+		if (vma->vm_mm != current->mm)
+			continue;
+		if (!(vma->vm_flags & VM_READ))
+			continue;
+
+		vaddr = offset_to_vaddr(vma, addr);
+		break;
+	}
+	mutex_unlock(&mapping->i_mmap_mutex);
+
+	WARN_ON_ONCE(vaddr == 0);
+	return (void __force __user *) vaddr;
+}
+
+/*
+ * uprobes-specific fetch functions
+ */
+#define DEFINE_FETCH_stack(type)					\
+static __kprobes void FETCH_FUNC_NAME(stack, type)(struct pt_regs *regs,\
+				  void *offset, void *dest, void *priv) \
+{									\
+	*(type *)dest = (type)get_user_stack_nth(regs, 			\
+				(unsigned int)((unsigned long)offset)); \
+}
+DEFINE_BASIC_FETCH_FUNCS(stack)
+/* No string on the stack entry */
+#define fetch_stack_string		NULL
+#define fetch_stack_string_size		NULL
+
+#define DEFINE_FETCH_memory(type)					\
+static __kprobes void FETCH_FUNC_NAME(memory, type)(struct pt_regs *regs,\
+				    void *addr, void *dest, void *priv) \
+{									\
+	type retval;							\
+	void __user *uaddr = get_user_vaddr((unsigned long)addr, priv);	\
+									\
+	if (copy_from_user(&retval, uaddr, sizeof(type)))		\
+		*(type *)dest = 0;					\
+	else								\
+		*(type *)dest = retval;					\
+}
+DEFINE_BASIC_FETCH_FUNCS(memory)
+/*
+ * Fetch a null-terminated string. Caller MUST set *(u32 *)dest with max
+ * length and relative data location.
+ */
+static __kprobes void FETCH_FUNC_NAME(memory, string)(struct pt_regs *regs,
+					void *addr, void *dest, void *priv)
+{
+	long ret;
+	u32 rloc = *(u32 *)dest;
+	int maxlen = get_rloc_len(rloc);
+	u8 *dst = get_rloc_data(dest);
+	void __user *vaddr = get_user_vaddr((unsigned long)addr, priv);
+	void __user *src = vaddr;
+
+	if (!maxlen)
+		return;
+
+	do {
+		ret = copy_from_user(dst, src, sizeof(*dst));
+		dst++;
+		src++;
+	} while (dst[-1] && ret == 0 && (src - vaddr) < maxlen);
+
+	if (ret < 0) {  /* Failed to fetch string */
+		((u8 *)get_rloc_data(dest))[0] = '\0';
+		*(u32 *)dest = make_data_rloc(0, get_rloc_offs(rloc));
+	} else {
+		*(u32 *)dest = make_data_rloc(src - vaddr,
+					      get_rloc_offs(rloc));
+	}
+}
+
+/* Return the length of string -- including null terminal byte */
+static __kprobes void FETCH_FUNC_NAME(memory, string_size)(struct pt_regs *regs,
+					   void *addr, void *dest, void *priv)
+{
+	int ret, len = 0;
+	u8 c;
+	void __user *vaddr = get_user_vaddr((unsigned long)addr, priv);
+
+	do {
+		ret = __copy_from_user_inatomic(&c, vaddr + len, 1);
+		len++;
+	} while (c && ret == 0 && len < MAX_STRING_SIZE);
+
+	if (ret < 0)	/* Failed to check the length */
+		*(u32 *)dest = 0;
+	else
+		*(u32 *)dest = len;
+}
+
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
 static atomic_t uprobe_buffer_ref = ATOMIC_INIT(0);
 static void __percpu *uprobe_cpu_buffer;
 static DEFINE_PER_CPU(struct mutex, uprobe_cpu_mutex);
@@ -546,7 +726,7 @@ static void uprobe_trace_print(struct trace_uprobe *tu,
 	int cpu;
 	struct ftrace_event_call *call = &tu->p.call;
 
-	dsize = __get_data_size(&tu->p, regs, NULL);
+	dsize = __get_data_size(&tu->p, regs, tu);
 	esize = SIZEOF_TRACE_ENTRY(is_ret_probe(tu));
 
 	if (WARN_ON_ONCE(!uprobe_cpu_buffer || tu->p.size + dsize > PAGE_SIZE))
@@ -561,7 +741,7 @@ static void uprobe_trace_print(struct trace_uprobe *tu,
 	 * so the mutex makes sure we have sole access to it.
 	 */
 	mutex_lock(mutex);
-	store_trace_args(esize, &tu->p, regs, arg_buf, dsize, NULL);
+	store_trace_args(esize, &tu->p, regs, arg_buf, dsize, tu);
 
 	size = esize + tu->p.size + dsize;
 	event = trace_current_buffer_lock_reserve(&buffer, call->event.type,
@@ -822,7 +1002,7 @@ static void uprobe_perf_print(struct trace_uprobe *tu,
 	int cpu;
 	int rctx;
 
-	dsize = __get_data_size(&tu->p, regs, NULL);
+	dsize = __get_data_size(&tu->p, regs, tu);
 	esize = SIZEOF_TRACE_ENTRY(is_ret_probe(tu));
 
 	if (WARN_ON_ONCE(!uprobe_cpu_buffer))
@@ -842,7 +1022,7 @@ static void uprobe_perf_print(struct trace_uprobe *tu,
 	 * so the mutex makes sure we have sole access to it.
 	 */
 	mutex_lock(mutex);
-	store_trace_args(esize, &tu->p, regs, arg_buf, dsize, NULL);
+	store_trace_args(esize, &tu->p, regs, arg_buf, dsize, tu);
 
 	preempt_disable();
 	head = this_cpu_ptr(call->perf_events);
-- 
1.7.11.7

