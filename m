Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467Ab3CROvI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 10:51:08 -0400
Received: from smtp4-g21.free.fr ([212.27.42.4]:53125 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753409Ab3CROvE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 10:51:04 -0400
From: Nicolas Schichan <nschichan@freebox.fr>
To: Will Drewry <wad@chromium.org>, Mircea Gherzan <mgherzan@gmail.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Nicolas Schichan <nschichan@freebox.fr>, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Paris <eparis@redhat.com>,
        James Morris <james.l.morris@oracle.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH V2 1/3] seccomp: add generic code for jitted seccomp filters.
Date: Mon, 18 Mar 2013 15:50:30 +0100
Message-Id: <1363618233-6375-2-git-send-email-nschichan@freebox.fr>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363618233-6375-1-git-send-email-nschichan@freebox.fr>
References: <1363618233-6375-1-git-send-email-nschichan@freebox.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Architecture must select HAVE_SECCOMP_FILTER_JIT and implement
seccomp_jit_compile() and seccomp_jit_free() if they intend to support
jitted seccomp filters.

struct seccomp_filter has been moved to <linux/seccomp.h> to make its
content available to the jit compilation code.

In a way similar to the net BPF, the jit compilation code is expected
to updates struct seccomp_filter.bpf_func pointer to the generated
code.

Signed-off-by: Nicolas Schichan <nschichan@freebox.fr>
---
 arch/Kconfig            |   14 ++++++++++++++
 include/linux/seccomp.h |   41 +++++++++++++++++++++++++++++++++++++++++
 kernel/seccomp.c        |   34 +++++-----------------------------
 3 files changed, 60 insertions(+), 29 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index 5a1779c..1284367 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -339,6 +339,10 @@ config HAVE_ARCH_SECCOMP_FILTER
 	  - secure_computing return value is checked and a return value of -1
 	    results in the system call being skipped immediately.
 
+# Used by archs to tell that they support SECCOMP_FILTER_JIT
+config HAVE_SECCOMP_FILTER_JIT
+	bool
+
 config SECCOMP_FILTER
 	def_bool y
 	depends on HAVE_ARCH_SECCOMP_FILTER && SECCOMP && NET
@@ -349,6 +353,16 @@ config SECCOMP_FILTER
 
 	  See Documentation/prctl/seccomp_filter.txt for details.
 
+config SECCOMP_FILTER_JIT
+	bool "enable Seccomp filter Just In Time compiler"
+	depends on HAVE_SECCOMP_FILTER_JIT && BPF_JIT && SECCOMP_FILTER
+	help
+	  Seccomp syscall filtering capabilities are normally handled
+	  by an interpreter. This option allows kernel to generate a native
+	  code when filter is loaded in memory. This should speedup
+	  syscall filtering. Note : Admin should enable this feature
+	  changing /proc/sys/net/core/bpf_jit_enable
+
 config HAVE_CONTEXT_TRACKING
 	bool
 	help
diff --git a/include/linux/seccomp.h b/include/linux/seccomp.h
index 6f19cfd..a216ab7 100644
--- a/include/linux/seccomp.h
+++ b/include/linux/seccomp.h
@@ -6,6 +6,7 @@
 #ifdef CONFIG_SECCOMP
 
 #include <linux/thread_info.h>
+#include <linux/filter.h>
 #include <asm/seccomp.h>
 
 struct seccomp_filter;
@@ -47,6 +48,46 @@ static inline int seccomp_mode(struct seccomp *s)
 	return s->mode;
 }
 
+/**
+ * struct seccomp_filter - container for seccomp BPF programs
+ *
+ * @usage: reference count to manage the object lifetime.
+ *         get/put helpers should be used when accessing an instance
+ *         outside of a lifetime-guarded section.  In general, this
+ *         is only needed for handling filters shared across tasks.
+ * @prev: points to a previously installed, or inherited, filter
+ * @len: the number of instructions in the program
+ * @bpc_func: points to either sk_run_filter or the code generated
+ *         by the BPF JIT.
+ * @insns: the BPF program instructions to evaluate
+ *
+ * seccomp_filter objects are organized in a tree linked via the @prev
+ * pointer.  For any task, it appears to be a singly-linked list starting
+ * with current->seccomp.filter, the most recently attached or inherited filter.
+ * However, multiple filters may share a @prev node, by way of fork(), which
+ * results in a unidirectional tree existing in memory.  This is similar to
+ * how namespaces work.
+ *
+ * seccomp_filter objects should never be modified after being attached
+ * to a task_struct (other than @usage).
+ */
+struct seccomp_filter {
+	atomic_t usage;
+	struct seccomp_filter *prev;
+	unsigned short len;  /* Instruction count */
+	unsigned int (*bpf_func)(const struct sk_buff *skb,
+				 const struct sock_filter *filter);
+	struct sock_filter insns[];
+};
+
+#ifdef CONFIG_SECCOMP_FILTER_JIT
+extern void seccomp_jit_compile(struct seccomp_filter *fp);
+extern void seccomp_jit_free(struct seccomp_filter *fp);
+#else
+static inline void seccomp_jit_compile(struct seccomp_filter *fp) { }
+static inline void seccomp_jit_free(struct seccomp_filter *fp) { }
+#endif
+
 #else /* CONFIG_SECCOMP */
 
 #include <linux/errno.h>
diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index b7a1004..a1aadaa 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -30,34 +30,6 @@
 #include <linux/tracehook.h>
 #include <linux/uaccess.h>
 
-/**
- * struct seccomp_filter - container for seccomp BPF programs
- *
- * @usage: reference count to manage the object lifetime.
- *         get/put helpers should be used when accessing an instance
- *         outside of a lifetime-guarded section.  In general, this
- *         is only needed for handling filters shared across tasks.
- * @prev: points to a previously installed, or inherited, filter
- * @len: the number of instructions in the program
- * @insns: the BPF program instructions to evaluate
- *
- * seccomp_filter objects are organized in a tree linked via the @prev
- * pointer.  For any task, it appears to be a singly-linked list starting
- * with current->seccomp.filter, the most recently attached or inherited filter.
- * However, multiple filters may share a @prev node, by way of fork(), which
- * results in a unidirectional tree existing in memory.  This is similar to
- * how namespaces work.
- *
- * seccomp_filter objects should never be modified after being attached
- * to a task_struct (other than @usage).
- */
-struct seccomp_filter {
-	atomic_t usage;
-	struct seccomp_filter *prev;
-	unsigned short len;  /* Instruction count */
-	struct sock_filter insns[];
-};
-
 /* Limit any path through the tree to 256KB worth of instructions. */
 #define MAX_INSNS_PER_PATH ((1 << 18) / sizeof(struct sock_filter))
 
@@ -213,7 +185,7 @@ static u32 seccomp_run_filters(int syscall)
 	 * value always takes priority (ignoring the DATA).
 	 */
 	for (f = current->seccomp.filter; f; f = f->prev) {
-		u32 cur_ret = sk_run_filter(NULL, f->insns);
+		u32 cur_ret = f->bpf_func(NULL, f->insns);
 		if ((cur_ret & SECCOMP_RET_ACTION) < (ret & SECCOMP_RET_ACTION))
 			ret = cur_ret;
 	}
@@ -275,6 +247,9 @@ static long seccomp_attach_filter(struct sock_fprog *fprog)
 	if (ret)
 		goto fail;
 
+	filter->bpf_func = sk_run_filter;
+	seccomp_jit_compile(filter);
+
 	/*
 	 * If there is an existing filter, make it the prev and don't drop its
 	 * task reference.
@@ -332,6 +307,7 @@ void put_seccomp_filter(struct task_struct *tsk)
 	while (orig && atomic_dec_and_test(&orig->usage)) {
 		struct seccomp_filter *freeme = orig;
 		orig = orig->prev;
+		seccomp_jit_free(freeme);
 		kfree(freeme);
 	}
 }
-- 
1.7.10.4

