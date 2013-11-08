Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757379Ab3KHMwl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 07:52:41 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:42251 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757245Ab3KHMwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 07:52:30 -0500
X-AuditID: 85900ec0-cff26b9000001514-85-527cde8b14b2
Subject: [PATCH -tip RFC 2/2] kprobes: Introduce NOKPROBE_SYMBOL() macro for
 blacklist
To: Ingo Molnar <mingo@kernel.org>
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: x86@kernel.org, Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        lkml <linux-kernel@vger.kernel.org>,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        virtualization@lists.linux-foundation.org,
        "David S. Miller" <davem@davemloft.net>
Date: Fri, 08 Nov 2013 12:52:26 +0000
Message-ID: <20131108125226.19972.65286.stgit@kbuild-fedora.novalocal>
In-Reply-To: <20131108125213.19972.49271.stgit@kbuild-fedora.novalocal>
References: <20131108125213.19972.49271.stgit@kbuild-fedora.novalocal>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce NOKPROBE_SYMBOL() macro which builds a kprobe
blacklist in build time. The usage of this macro is similar
to the EXPORT_SYMBOL, put the NOKPROBE_SYMBOL(function); just
after the function definition.

If CONFIG_KPROBES=y, the macro is expanded to the definition
of a static data structure of kprobe_blackpoint which is
initialized for the function and put the address of the data
structure in the "_kprobe_blacklist" section.

Since the data structures are not fully initialized by the
macro (because there is no "size" information),  those
are re-initialized at boot time by using kallsyms.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
---
 arch/x86/kernel/paravirt.c        |    4 ++
 include/asm-generic/vmlinux.lds.h |    9 ++++
 include/linux/kprobes.h           |   19 ++++++++
 kernel/kprobes.c                  |   88 ++++++++++++++++++-------------------
 kernel/sched/core.c               |    1 
 5 files changed, 75 insertions(+), 46 deletions(-)

diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index 1b10af8..4c785fd 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -23,6 +23,7 @@
 #include <linux/efi.h>
 #include <linux/bcd.h>
 #include <linux/highmem.h>
+#include <linux/kprobes.h>
 
 #include <asm/bug.h>
 #include <asm/paravirt.h>
@@ -389,6 +390,9 @@ __visible struct pv_cpu_ops pv_cpu_ops = {
 	.end_context_switch = paravirt_nop,
 };
 
+/* At this point, native_get_debugreg has real function entry */
+NOKPROBE_SYMBOL(native_get_debugreg);
+
 struct pv_apic_ops pv_apic_ops = {
 #ifdef CONFIG_X86_LOCAL_APIC
 	.startup_ipi_hook = paravirt_nop,
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 83e2c31..294ea96 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -109,6 +109,14 @@
 #define BRANCH_PROFILE()
 #endif
 
+#ifdef CONFIG_KPROBES
+#define KPROBE_BLACKLIST()	VMLINUX_SYMBOL(__start_kprobe_blacklist) = .; \
+				*(_kprobe_blacklist)			      \
+				VMLINUX_SYMBOL(__stop_kprobe_blacklist) = .;
+#else
+#define KPROBE_BLACKLIST()
+#endif
+
 #ifdef CONFIG_EVENT_TRACING
 #define FTRACE_EVENTS()	. = ALIGN(8);					\
 			VMLINUX_SYMBOL(__start_ftrace_events) = .;	\
@@ -487,6 +495,7 @@
 	*(.init.rodata)							\
 	FTRACE_EVENTS()							\
 	TRACE_SYSCALLS()						\
+	KPROBE_BLACKLIST()						\
 	MEM_DISCARD(init.rodata)					\
 	CLK_OF_TABLES()							\
 	CLKSRC_OF_TABLES()						\
diff --git a/include/linux/kprobes.h b/include/linux/kprobes.h
index 925eaf2..a403038 100644
--- a/include/linux/kprobes.h
+++ b/include/linux/kprobes.h
@@ -206,6 +206,7 @@ struct kretprobe_blackpoint {
 };
 
 struct kprobe_blackpoint {
+	struct list_head list;
 	const char *name;
 	unsigned long start_addr;
 	unsigned long range;
@@ -476,4 +477,22 @@ static inline int enable_jprobe(struct jprobe *jp)
 	return enable_kprobe(&jp->kp);
 }
 
+#ifdef CONFIG_KPROBES
+/*
+ * Blacklist ganerating macro. Specify functions which is not probed
+ * by using this macro.
+ */
+#define NOKPROBE_SYMBOL(fname)			\
+static struct kprobe_blackpoint __used		\
+  _kprobe_bp_##fname = {			\
+	.name = #fname,				\
+	.start_addr = (unsigned long)fname,	\
+};						\
+static struct kprobe_blackpoint __used		\
+  __attribute__((section("_kprobe_blacklist"))) \
+ *_p_kprobe_bp_##fname = &_kprobe_bp_##fname;
+#else
+#define NOKPROBE_SYMBOL(fname)
+#endif
+
 #endif /* _LINUX_KPROBES_H */
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index ec0dbc7..1fab712 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -86,18 +86,8 @@ static raw_spinlock_t *kretprobe_table_lock_ptr(unsigned long hash)
 	return &(kretprobe_table_locks[hash].lock);
 }
 
-/*
- * Normally, functions that we'd want to prohibit kprobes in, are marked
- * __kprobes. But, there are cases where such functions already belong to
- * a different section (__sched for preempt_schedule)
- *
- * For such cases, we now have a blacklist
- */
-static struct kprobe_blackpoint kprobe_blacklist[] = {
-	{"preempt_schedule",},
-	{"native_get_debugreg",},
-	{NULL}    /* Terminator */
-};
+/* Blacklist -- list of struct kprobe_blackpoint */
+static LIST_HEAD(kprobe_blacklist);
 
 #ifdef __ARCH_WANT_KPROBES_INSN_SLOT
 /*
@@ -1321,9 +1311,9 @@ out:
 	return ret;
 }
 
-static int __kprobes in_kprobes_functions(unsigned long addr)
+static int __kprobes in_nokprobe_functions(unsigned long addr)
 {
-	struct kprobe_blackpoint *kb;
+	struct kprobe_blackpoint *bp;
 
 	/* The __kprobes marked functions and entry code must not be probed */
 	if ((addr >= (unsigned long)__kprobes_text_start &&
@@ -1335,12 +1325,10 @@ static int __kprobes in_kprobes_functions(unsigned long addr)
 	 * If there exists a kprobe_blacklist, verify and
 	 * fail any probe registration in the prohibited area
 	 */
-	for (kb = kprobe_blacklist; kb->name != NULL; kb++) {
-		if (kb->start_addr) {
-			if (addr >= kb->start_addr &&
-			    addr < (kb->start_addr + kb->range))
-				return -EINVAL;
-		}
+	list_for_each_entry(bp, &kprobe_blacklist, list) {
+		if (addr >= bp->start_addr &&
+		    addr < (bp->start_addr + bp->range))
+			return -EINVAL;
 	}
 	return 0;
 }
@@ -1433,7 +1421,7 @@ static __kprobes int check_kprobe_address_safe(struct kprobe *p,
 
 	/* Ensure it is not in reserved area nor out of text */
 	if (!kernel_text_address((unsigned long) p->addr) ||
-	    in_kprobes_functions((unsigned long) p->addr) ||
+	    in_nokprobe_functions((unsigned long) p->addr) ||
 	    jump_label_text_reserved(p->addr, p->addr)) {
 		ret = -EINVAL;
 		goto out;
@@ -2062,14 +2050,41 @@ static struct notifier_block kprobe_module_nb = {
 	.priority = 0
 };
 
-static int __init init_kprobes(void)
+/*
+ * Lookup and populate the kprobe_blacklist.
+ *
+ * Unlike the kretprobe blacklist, we'll need to determine
+ * the range of addresses that belong to the said functions,
+ * since a kprobe need not necessarily be at the beginning
+ * of a function.
+ */
+static void populate_kprobe_blacklist(struct kprobe_blackpoint **start,
+				      struct kprobe_blackpoint **end)
 {
-	int i, err = 0;
+	struct kprobe_blackpoint **iter, *bp;
 	unsigned long offset = 0, size = 0;
 	char *modname, namebuf[128];
 	const char *symbol_name;
-	void *addr;
-	struct kprobe_blackpoint *kb;
+
+	for (iter = start; (unsigned long)iter < (unsigned long)end; iter++) {
+		bp = *iter;
+		symbol_name = kallsyms_lookup(bp->start_addr,
+				&size, &offset, &modname, namebuf);
+		if (!symbol_name)
+			continue;
+
+		bp->range = size;
+		INIT_LIST_HEAD(&bp->list);
+		list_add_tail(&bp->list, &kprobe_blacklist);
+	}
+}
+
+extern struct kprobe_blackpoint *__start_kprobe_blacklist[];
+extern struct kprobe_blackpoint *__stop_kprobe_blacklist[];
+
+static int __init init_kprobes(void)
+{
+	int i, err = 0;
 
 	/* FIXME allocate the probe table, currently defined statically */
 	/* initialize all list heads */
@@ -2079,27 +2094,8 @@ static int __init init_kprobes(void)
 		raw_spin_lock_init(&(kretprobe_table_locks[i].lock));
 	}
 
-	/*
-	 * Lookup and populate the kprobe_blacklist.
-	 *
-	 * Unlike the kretprobe blacklist, we'll need to determine
-	 * the range of addresses that belong to the said functions,
-	 * since a kprobe need not necessarily be at the beginning
-	 * of a function.
-	 */
-	for (kb = kprobe_blacklist; kb->name != NULL; kb++) {
-		kprobe_lookup_name(kb->name, addr);
-		if (!addr)
-			continue;
-
-		kb->start_addr = (unsigned long)addr;
-		symbol_name = kallsyms_lookup(kb->start_addr,
-				&size, &offset, &modname, namebuf);
-		if (!symbol_name)
-			kb->range = 0;
-		else
-			kb->range = size;
-	}
+	populate_kprobe_blacklist(__start_kprobe_blacklist,
+				  __stop_kprobe_blacklist);
 
 	if (kretprobe_blacklist_size) {
 		/* lookup the function address from its name */
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 1deccd7..527fd78 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2645,6 +2645,7 @@ asmlinkage void __sched notrace preempt_schedule(void)
 		barrier();
 	} while (need_resched());
 }
+NOKPROBE_SYMBOL(preempt_schedule);
 EXPORT_SYMBOL(preempt_schedule);
 
 /*

