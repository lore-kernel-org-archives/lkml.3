Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932806Ab3GCMg3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 08:36:29 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:52553 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932747Ab3GCMf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 08:35:56 -0400
X-AuditID: 9c93017e-b7c04ae00000295f-f7-51d41aa5adb6
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Hyeoncheol Lee <cheol.lee@lge.com>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [PATCH 11/12] tracing/uprobes: Add more fetch functions
Date: Wed,  3 Jul 2013 21:35:45 +0900
Message-Id: <1372854946-17074-12-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1372854946-17074-1-git-send-email-namhyung@kernel.org>
References: <1372854946-17074-1-git-send-email-namhyung@kernel.org>
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
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 kernel/trace/trace_probe.c  |   9 ++-
 kernel/trace/trace_probe.h  |   1 +
 kernel/trace/trace_uprobe.c | 188 +++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 192 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/trace_probe.c b/kernel/trace/trace_probe.c
index 029ffc401e39..a46c9fd494ff 100644
--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -166,6 +166,10 @@ struct deref_fetch_param {
 	fetch_func_t		fetch_size;
 };
 
+/*
+ * For uprobes, it'll get a vaddr from first call_fetch() so pass NULL
+ * as a priv on the second dprm->fetch() not to translate it to vaddr again.
+ */
 #define DEFINE_FETCH_deref(type)					\
 __kprobes void FETCH_FUNC_NAME(deref, type)(struct pt_regs *regs,	\
 				    void *data, void *dest, void *priv)	\
@@ -175,13 +179,14 @@ __kprobes void FETCH_FUNC_NAME(deref, type)(struct pt_regs *regs,	\
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
@@ -191,7 +196,7 @@ __kprobes void FETCH_FUNC_NAME(deref, string_size)(struct pt_regs *regs,
 	call_fetch(&dprm->orig, regs, &addr, priv);
 	if (addr && dprm->fetch_size) {
 		addr += dprm->offset;
-		dprm->fetch_size(regs, (void *)addr, dest, priv);
+		dprm->fetch_size(regs, (void *)addr, dest, NULL);
 	} else
 		*(string_size *)dest = 0;
 }
diff --git a/kernel/trace/trace_probe.h b/kernel/trace/trace_probe.h
index a4f56015bfa3..1034f2794c32 100644
--- a/kernel/trace/trace_probe.h
+++ b/kernel/trace/trace_probe.h
@@ -263,6 +263,7 @@ ASSIGN_FETCH_FUNC(bitfield, ftype),			\
 #define NR_FETCH_TYPES		10
 
 extern const struct fetch_type kprobes_fetch_type_table[];
+extern const struct fetch_type uprobes_fetch_type_table[];
 
 static inline __kprobes void call_fetch(struct fetch_param *fprm,
 				 struct pt_regs *regs, void *dest, void *priv)
diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index 63e44b52192a..c548f21be799 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -508,6 +508,186 @@ static const struct file_operations uprobe_profile_ops = {
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
 static void uprobe_trace_print(struct trace_uprobe *tu,
 				unsigned long func, struct pt_regs *regs)
 {
@@ -518,7 +698,7 @@ static void uprobe_trace_print(struct trace_uprobe *tu,
 	int size, dsize, esize;
 	struct ftrace_event_call *call = &tu->p.call;
 
-	dsize = __get_data_size(&tu->p, regs, NULL);
+	dsize = __get_data_size(&tu->p, regs, tu);
 	esize = SIZEOF_TRACE_ENTRY(is_ret_probe(tu));
 
 	/*
@@ -530,7 +710,7 @@ static void uprobe_trace_print(struct trace_uprobe *tu,
 	if (tmp == NULL)
 		return;
 
-	store_trace_args(esize, &tu->p, regs, tmp, dsize, NULL);
+	store_trace_args(esize, &tu->p, regs, tmp, dsize, tu);
 
 	size = esize + tu->p.size + dsize;
 	event = trace_current_buffer_lock_reserve(&buffer, call->event.type,
@@ -773,7 +953,7 @@ static void uprobe_perf_print(struct trace_uprobe *tu,
 	int size, dsize, esize;
 	int rctx;
 
-	dsize = __get_data_size(&tu->p, regs, NULL);
+	dsize = __get_data_size(&tu->p, regs, tu);
 	esize = SIZEOF_TRACE_ENTRY(is_ret_probe(tu));
 
 	/*
@@ -785,7 +965,7 @@ static void uprobe_perf_print(struct trace_uprobe *tu,
 	if (tmp == NULL)
 		return;
 
-	store_trace_args(esize, &tu->p, regs, tmp, dsize, NULL);
+	store_trace_args(esize, &tu->p, regs, tmp, dsize, tu);
 
 	size = esize + tu->p.size + dsize;
 	size = ALIGN(size + + sizeof(u32), sizeof(u64)) - sizeof(u32);
-- 
1.7.11.7

