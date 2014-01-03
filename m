Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021AbaACCN4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 21:13:56 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:36344 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753152AbaACCLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 21:11:49 -0500
Message-Id: <20140103021146.260469849@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 02 Jan 2014 21:10:33 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [for-next][PATCH 12/17] tracing/probes: Implement memory fetch method for uprobes
References: <20140103021021.238772653@goodmis.org>
Content-Disposition: inline; filename=0012-tracing-probes-Implement-memory-fetch-method-for-upr.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Use separate method to fetch from memory.  Move existing functions to
trace_kprobe.c and make them static.  Also add new memory fetch
implementation for uprobes.

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 kernel/trace/trace_kprobe.c | 77 +++++++++++++++++++++++++++++++++++++++++++++
 kernel/trace/trace_probe.c  | 77 ---------------------------------------------
 kernel/trace/trace_probe.h  |  4 ---
 kernel/trace/trace_uprobe.c | 52 ++++++++++++++++++++++++++++++
 4 files changed, 129 insertions(+), 81 deletions(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index d2a4fd2..f94a569 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -148,6 +148,83 @@ DEFINE_BASIC_FETCH_FUNCS(stack)
 #define fetch_stack_string	NULL
 #define fetch_stack_string_size	NULL
 
+#define DEFINE_FETCH_memory(type)					\
+static __kprobes void FETCH_FUNC_NAME(memory, type)(struct pt_regs *regs,\
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
+static __kprobes void FETCH_FUNC_NAME(memory, string)(struct pt_regs *regs,
+						      void *addr, void *dest)
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
+static __kprobes void FETCH_FUNC_NAME(memory, string_size)(struct pt_regs *regs,
+							void *addr, void *dest)
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
 #define DEFINE_FETCH_symbol(type)					\
 __kprobes void FETCH_FUNC_NAME(symbol, type)(struct pt_regs *regs,	\
 					  void *data, void *dest)	\
diff --git a/kernel/trace/trace_probe.c b/kernel/trace/trace_probe.c
index 8d7231d..8f7a2b6d 100644
--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -103,83 +103,6 @@ DEFINE_BASIC_FETCH_FUNCS(retval)
 #define fetch_retval_string		NULL
 #define fetch_retval_string_size	NULL
 
-#define DEFINE_FETCH_memory(type)					\
-__kprobes void FETCH_FUNC_NAME(memory, type)(struct pt_regs *regs,	\
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
-__kprobes void FETCH_FUNC_NAME(memory, string)(struct pt_regs *regs,
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
-__kprobes void FETCH_FUNC_NAME(memory, string_size)(struct pt_regs *regs,
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
-
 /* Dereference memory access function */
 struct deref_fetch_param {
 	struct fetch_param	orig;
diff --git a/kernel/trace/trace_probe.h b/kernel/trace/trace_probe.h
index 8be8455..2d5b8f5 100644
--- a/kernel/trace/trace_probe.h
+++ b/kernel/trace/trace_probe.h
@@ -171,10 +171,6 @@ DECLARE_BASIC_FETCH_FUNCS(retval);
 #define fetch_retval_string			NULL
 #define fetch_retval_string_size		NULL
 
-DECLARE_BASIC_FETCH_FUNCS(memory);
-DECLARE_FETCH_FUNC(memory, string);
-DECLARE_FETCH_FUNC(memory, string_size);
-
 DECLARE_BASIC_FETCH_FUNCS(symbol);
 DECLARE_FETCH_FUNC(symbol, string);
 DECLARE_FETCH_FUNC(symbol, string_size);
diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index 24ef6a3..bebd2f5 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -114,6 +114,58 @@ DEFINE_BASIC_FETCH_FUNCS(stack)
 #define fetch_stack_string	NULL
 #define fetch_stack_string_size	NULL
 
+#define DEFINE_FETCH_memory(type)					\
+static __kprobes void FETCH_FUNC_NAME(memory, type)(struct pt_regs *regs,\
+						void *addr, void *dest) \
+{									\
+	type retval;							\
+	void __user *vaddr = (void __force __user *) addr;		\
+									\
+	if (copy_from_user(&retval, vaddr, sizeof(type)))		\
+		*(type *)dest = 0;					\
+	else								\
+		*(type *) dest = retval;				\
+}
+DEFINE_BASIC_FETCH_FUNCS(memory)
+/*
+ * Fetch a null-terminated string. Caller MUST set *(u32 *)dest with max
+ * length and relative data location.
+ */
+static __kprobes void FETCH_FUNC_NAME(memory, string)(struct pt_regs *regs,
+						      void *addr, void *dest)
+{
+	long ret;
+	u32 rloc = *(u32 *)dest;
+	int maxlen  = get_rloc_len(rloc);
+	u8 *dst = get_rloc_data(dest);
+	void __user *src = (void __force __user *) addr;
+
+	if (!maxlen)
+		return;
+
+	ret = strncpy_from_user(dst, src, maxlen);
+
+	if (ret < 0) {	/* Failed to fetch string */
+		((u8 *)get_rloc_data(dest))[0] = '\0';
+		*(u32 *)dest = make_data_rloc(0, get_rloc_offs(rloc));
+	} else {
+		*(u32 *)dest = make_data_rloc(ret, get_rloc_offs(rloc));
+	}
+}
+
+static __kprobes void FETCH_FUNC_NAME(memory, string_size)(struct pt_regs *regs,
+						      void *addr, void *dest)
+{
+	int len;
+	void __user *vaddr = (void __force __user *) addr;
+
+	len = strnlen_user(vaddr, MAX_STRING_SIZE);
+
+	if (len == 0 || len > MAX_STRING_SIZE)  /* Failed to check length */
+		*(u32 *)dest = 0;
+	else
+		*(u32 *)dest = len;
+}
 
 /* uprobes do not support symbol fetch methods */
 #define fetch_symbol_u8			NULL
-- 
1.8.4.3


