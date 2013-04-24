Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756448Ab3DXR2e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 13:28:34 -0400
Received: from smtpfb1-g21.free.fr ([212.27.42.9]:35679 "EHLO
	smtpfb1-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754919Ab3DXR2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 13:28:33 -0400
From: Nicolas Schichan <nschichan@freebox.fr>
To: Will Drewry <wad@chromium.org>, Mircea Gherzan <mgherzan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Nicolas Schichan <nschichan@freebox.fr>, Al Viro <viro@zeniv.linux.org.uk>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>, Dave Jones <davej@redhat.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>,
        Andy Lutomirski <luto@amacapital.net>,
        James Morris <james.l.morris@oracle.com>
Subject: [PATCH V3 1/3] seccomp: add generic code for jitted seccomp filters.
Date: Wed, 24 Apr 2013 19:27:07 +0200
Message-Id: <1366824429-26652-2-git-send-email-nschichan@freebox.fr>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1366824429-26652-1-git-send-email-nschichan@freebox.fr>
References: <1366824429-26652-1-git-send-email-nschichan@freebox.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Architecture must select HAVE_SECCOMP_FILTER_JIT and implement
seccomp_jit_compile() and seccomp_jit_free() if they intend to support
jitted seccomp filters.

Accessors to struct seccomp_filter fields are provided in
<linux/seccomp.h> to be used by the JIT code. With this, the 'struct
seccomp_filter' structure can stay opaque when outside
kernel/seccomp.c.

In a way similar to the net BPF, the jit compilation code is expected
to updates struct seccomp_filter.bpf_func pointer (using the correct
accessor) to the generated code.

Signed-off-by: Nicolas Schichan <nschichan@freebox.fr>
---
 arch/Kconfig            |   14 ++++++++++++++
 include/linux/seccomp.h |   18 ++++++++++++++++++
 kernel/seccomp.c        |   33 ++++++++++++++++++++++++++++++++-
 3 files changed, 64 insertions(+), 1 deletion(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index 1455579..370bc52 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -332,6 +332,10 @@ config HAVE_ARCH_SECCOMP_FILTER
 	  - secure_computing return value is checked and a return value of -1
 	    results in the system call being skipped immediately.
 
+# Used by archs to tell that they support SECCOMP_FILTER_JIT
+config HAVE_SECCOMP_FILTER_JIT
+	bool
+
 config SECCOMP_FILTER
 	def_bool y
 	depends on HAVE_ARCH_SECCOMP_FILTER && SECCOMP && NET
@@ -342,6 +346,16 @@ config SECCOMP_FILTER
 
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
index 6f19cfd..2793607 100644
--- a/include/linux/seccomp.h
+++ b/include/linux/seccomp.h
@@ -47,6 +47,24 @@ static inline int seccomp_mode(struct seccomp *s)
 	return s->mode;
 }
 
+#ifdef CONFIG_SECCOMP_FILTER_JIT
+extern void seccomp_jit_compile(struct seccomp_filter *fp);
+extern void seccomp_jit_free(struct seccomp_filter *fp);
+
+/*
+ * accessors used by seccomp JIT code to avoid having to declare the
+ * seccomp_filter struct here.
+ */
+unsigned short seccomp_filter_get_len(struct seccomp_filter *fp);
+struct sock_filter *seccomp_filter_get_insns(struct seccomp_filter *fp);
+void seccomp_filter_set_bpf_func(struct seccomp_filter *fp, void *func);
+void *seccomp_filter_get_bpf_func(struct seccomp_filter *fp);
+
+#else
+static inline void seccomp_jit_compile(struct seccomp_filter *fp) { }
+static inline void seccomp_jit_free(struct seccomp_filter *fp) { }
+#endif
+
 #else /* CONFIG_SECCOMP */
 
 #include <linux/errno.h>
diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index b7a1004..2377414 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -39,6 +39,8 @@
  *         is only needed for handling filters shared across tasks.
  * @prev: points to a previously installed, or inherited, filter
  * @len: the number of instructions in the program
+ * @bpf_func: points to either sk_run_filter or the code generated
+ *         by the BPF JIT.
  * @insns: the BPF program instructions to evaluate
  *
  * seccomp_filter objects are organized in a tree linked via the @prev
@@ -55,6 +57,8 @@ struct seccomp_filter {
 	atomic_t usage;
 	struct seccomp_filter *prev;
 	unsigned short len;  /* Instruction count */
+	unsigned int (*bpf_func)(const struct sk_buff *skb,
+				 const struct sock_filter *filter);
 	struct sock_filter insns[];
 };
 
@@ -213,7 +217,7 @@ static u32 seccomp_run_filters(int syscall)
 	 * value always takes priority (ignoring the DATA).
 	 */
 	for (f = current->seccomp.filter; f; f = f->prev) {
-		u32 cur_ret = sk_run_filter(NULL, f->insns);
+		u32 cur_ret = f->bpf_func(NULL, f->insns);
 		if ((cur_ret & SECCOMP_RET_ACTION) < (ret & SECCOMP_RET_ACTION))
 			ret = cur_ret;
 	}
@@ -275,6 +279,9 @@ static long seccomp_attach_filter(struct sock_fprog *fprog)
 	if (ret)
 		goto fail;
 
+	filter->bpf_func = sk_run_filter;
+	seccomp_jit_compile(filter);
+
 	/*
 	 * If there is an existing filter, make it the prev and don't drop its
 	 * task reference.
@@ -332,10 +339,34 @@ void put_seccomp_filter(struct task_struct *tsk)
 	while (orig && atomic_dec_and_test(&orig->usage)) {
 		struct seccomp_filter *freeme = orig;
 		orig = orig->prev;
+		seccomp_jit_free(freeme);
 		kfree(freeme);
 	}
 }
 
+/*
+ * seccomp filter accessors for JIT code.
+ */
+unsigned short seccomp_filter_get_len(struct seccomp_filter *fp)
+{
+	return fp->len;
+}
+
+struct sock_filter *seccomp_filter_get_insns(struct seccomp_filter *fp)
+{
+	return fp->insns;
+}
+
+void seccomp_filter_set_bpf_func(struct seccomp_filter *fp, void *func)
+{
+	fp->bpf_func = func;
+}
+
+void *seccomp_filter_get_bpf_func(struct seccomp_filter *fp)
+{
+	return fp->bpf_func;
+}
+
 /**
  * seccomp_send_sigsys - signals the task to allow in-process syscall emulation
  * @syscall: syscall number to send to userland
-- 
1.7.10.4

