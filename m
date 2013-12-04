Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755226Ab3LDBeh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 20:34:37 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:55029 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754985Ab3LDBea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 20:34:30 -0500
Subject: [PATCH -tip v4 2/6] kprobes: Introduce NOKPROBE_SYMBOL() macro for
 blacklist
To: Ingo Molnar <mingo@kernel.org>
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Rob Landley <rob@landley.net>, Jeremy Fitzhardinge <jeremy@goop.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        Chris Wright <chrisw@sous-sol.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, systemtap@sourceware.org,
        "H. Peter Anvin" <hpa@zytor.com>, Alok Kataria <akataria@vmware.com>,
        "David S. Miller" <davem@davemloft.net>
Date: Wed, 04 Dec 2013 01:28:46 +0000
Message-ID: <20131204012846.22118.91926.stgit@kbuild-fedora.novalocal>
In-Reply-To: <20131204012841.22118.82992.stgit@kbuild-fedora.novalocal>
References: <20131204012841.22118.82992.stgit@kbuild-fedora.novalocal>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce NOKPROBE_SYMBOL() macro which builds a kprobe
blacklist in build time. The usage of this macro is similar
to the EXPORT_SYMBOL, put the NOKPROBE_SYMBOL(function); just
after the function definition.

When CONFIG_KPROBES=y, the macro stores the given function
address in the "_kprobe_blacklist" section.

Since the data structures are not fully initialized by the
macro (because there is no "size" information),  those
are re-initialized at boot time by using kallsyms.

Changes from previous version:
 - Rename kprobe_blackpoint to kprobe_blacklist_entry and
   simplify it.
 - Just stores the address of given function instead of
   defining a data structure in NOKPROBE_SYMBOL().
 - Add _ASM_NOKPROBE macro support for x86.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Rob Landley <rob@landley.net>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: Alok Kataria <akataria@vmware.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 Documentation/kprobes.txt         |   16 ++++++
 arch/x86/include/asm/asm.h        |    7 +++
 arch/x86/kernel/paravirt.c        |    4 +
 include/asm-generic/vmlinux.lds.h |    9 +++
 include/linux/kprobes.h           |   20 ++++++-
 kernel/kprobes.c                  |  100 +++++++++++++++++++------------------
 kernel/sched/core.c               |    1 
 7 files changed, 105 insertions(+), 52 deletions(-)

diff --git a/Documentation/kprobes.txt b/Documentation/kprobes.txt
index 0cfb00f..7062631 100644
--- a/Documentation/kprobes.txt
+++ b/Documentation/kprobes.txt
@@ -22,8 +22,9 @@ Appendix B: The kprobes sysctl interface
 
 Kprobes enables you to dynamically break into any kernel routine and
 collect debugging and performance information non-disruptively. You
-can trap at almost any kernel code address, specifying a handler
+can trap at almost any kernel code address(*), specifying a handler
 routine to be invoked when the breakpoint is hit.
+(*: at some part of kernel code can not be trapped, see 1.5 Blacklist)
 
 There are currently three types of probes: kprobes, jprobes, and
 kretprobes (also called return probes).  A kprobe can be inserted
@@ -273,6 +274,19 @@ using one of the following techniques:
  or
 - Execute 'sysctl -w debug.kprobes_optimization=n'
 
+1.5 Blacklist
+
+Kprobes can probe almost of the kernel except itself. This means
+that there are some functions where kprobes cannot probe. Probing
+(trapping) such functions can cause recursive trap (e.g. double
+fault) or at least the nested probe handler never be called.
+Kprobes manages such functions as a blacklist.
+If you want to add a function into the blacklist, you just need
+to (1) include linux/kprobes.h and (2) use NOKPROBE_SYMBOL() macro
+to specify a blacklisted function.
+Kprobes checks given probe address with the blacklist and reject
+registering if the given address is in the blacklist.
+
 2. Architectures Supported
 
 Kprobes, jprobes, and return probes are implemented on the following
diff --git a/arch/x86/include/asm/asm.h b/arch/x86/include/asm/asm.h
index 4582e8e..7730c1c 100644
--- a/arch/x86/include/asm/asm.h
+++ b/arch/x86/include/asm/asm.h
@@ -57,6 +57,12 @@
 	.long (from) - . ;					\
 	.long (to) - . + 0x7ffffff0 ;				\
 	.popsection
+
+# define _ASM_NOKPROBE(entry)					\
+	.pushsection "_kprobe_blacklist","aw" ;			\
+	_ASM_ALIGN ;						\
+	_ASM_PTR (entry);					\
+	.popsection
 #else
 # define _ASM_EXTABLE(from,to)					\
 	" .pushsection \"__ex_table\",\"a\"\n"			\
@@ -71,6 +77,7 @@
 	" .long (" #from ") - .\n"				\
 	" .long (" #to ") - . + 0x7ffffff0\n"			\
 	" .popsection\n"
+/* For C file, we already have NOKPROBE_SYMBOL macro */
 #endif
 
 #endif /* _ASM_X86_ASM_H */
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
index bc2121f..81d07d5 100644
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
@@ -488,6 +496,7 @@
 	*(.init.rodata)							\
 	FTRACE_EVENTS()							\
 	TRACE_SYSCALLS()						\
+	KPROBE_BLACKLIST()						\
 	MEM_DISCARD(init.rodata)					\
 	CLK_OF_TABLES()							\
 	CLKSRC_OF_TABLES()						\
diff --git a/include/linux/kprobes.h b/include/linux/kprobes.h
index cdf9251..e059507 100644
--- a/include/linux/kprobes.h
+++ b/include/linux/kprobes.h
@@ -205,10 +205,10 @@ struct kretprobe_blackpoint {
 	void *addr;
 };
 
-struct kprobe_blackpoint {
-	const char *name;
+struct kprobe_blacklist_entry {
+	struct list_head list;
 	unsigned long start_addr;
-	unsigned long range;
+	unsigned long end_addr;
 };
 
 #ifdef CONFIG_KPROBES
@@ -477,4 +477,18 @@ static inline int enable_jprobe(struct jprobe *jp)
 	return enable_kprobe(&jp->kp);
 }
 
+#ifdef CONFIG_KPROBES
+/*
+ * Blacklist ganerating macro. Specify functions which is not probed
+ * by using this macro.
+ */
+#define __NOKPROBE_SYMBOL(fname)			\
+static unsigned long __used				\
+	__attribute__((section("_kprobe_blacklist")))	\
+	_kbl_addr_##fname = (unsigned long)fname;
+#define NOKPROBE_SYMBOL(fname)	__NOKPROBE_SYMBOL(fname)
+#else
+#define NOKPROBE_SYMBOL(fname)
+#endif
+
 #endif /* _LINUX_KPROBES_H */
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index c6772b9..43ef40b 100644
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
+/* Blacklist -- list of struct kprobe_blacklist_entry */
+static LIST_HEAD(kprobe_blacklist);
 
 #ifdef __ARCH_WANT_KPROBES_INSN_SLOT
 /*
@@ -1328,24 +1318,22 @@ bool __weak arch_within_kprobe_blacklist(unsigned long addr)
 		addr < (unsigned long)__kprobes_text_end);
 }
 
-static int __kprobes in_kprobes_functions(unsigned long addr)
+static bool __kprobes within_kprobe_blacklist(unsigned long addr)
 {
-	struct kprobe_blackpoint *kb;
+	struct kprobe_blacklist_entry *ent;
 
 	if (arch_within_kprobe_blacklist(addr))
-		return -EINVAL;
+		return true;
 	/*
 	 * If there exists a kprobe_blacklist, verify and
 	 * fail any probe registration in the prohibited area
 	 */
-	for (kb = kprobe_blacklist; kb->name != NULL; kb++) {
-		if (kb->start_addr) {
-			if (addr >= kb->start_addr &&
-			    addr < (kb->start_addr + kb->range))
-				return -EINVAL;
-		}
+	list_for_each_entry(ent, &kprobe_blacklist, list) {
+		if (addr >= ent->start_addr && addr < ent->end_addr)
+			return true;
 	}
-	return 0;
+
+	return false;
 }
 
 /*
@@ -1436,7 +1424,7 @@ static __kprobes int check_kprobe_address_safe(struct kprobe *p,
 
 	/* Ensure it is not in reserved area nor out of text */
 	if (!kernel_text_address((unsigned long) p->addr) ||
-	    in_kprobes_functions((unsigned long) p->addr) ||
+	    within_kprobe_blacklist((unsigned long) p->addr) ||
 	    jump_label_text_reserved(p->addr, p->addr)) {
 		ret = -EINVAL;
 		goto out;
@@ -2022,6 +2010,38 @@ void __kprobes dump_kprobe(struct kprobe *kp)
 	       kp->symbol_name, kp->addr, kp->offset);
 }
 
+/*
+ * Lookup and populate the kprobe_blacklist.
+ *
+ * Unlike the kretprobe blacklist, we'll need to determine
+ * the range of addresses that belong to the said functions,
+ * since a kprobe need not necessarily be at the beginning
+ * of a function.
+ */
+static int __init populate_kprobe_blacklist(unsigned long *start,
+					     unsigned long *end)
+{
+	unsigned long *iter;
+	struct kprobe_blacklist_entry *ent;
+	unsigned long offset = 0, size = 0;
+
+	for (iter = start; iter < end; iter++) {
+		if (!kallsyms_lookup_size_offset(*iter, &size, &offset)) {
+			pr_err("Failed to find blacklist %p\n", (void *)*iter);
+			continue;
+		}
+
+		ent = kmalloc(sizeof(*ent), GFP_KERNEL);
+		if (!ent)
+			return -ENOMEM;
+		ent->start_addr = *iter;
+		ent->end_addr = *iter + size;
+		INIT_LIST_HEAD(&ent->list);
+		list_add_tail(&ent->list, &kprobe_blacklist);
+	}
+	return 0;
+}
+
 /* Module notifier call back, checking kprobes on the module */
 static int __kprobes kprobes_module_callback(struct notifier_block *nb,
 					     unsigned long val, void *data)
@@ -2065,14 +2085,13 @@ static struct notifier_block kprobe_module_nb = {
 	.priority = 0
 };
 
+/* Markers of _kprobe_blacklist section */
+extern unsigned long __start_kprobe_blacklist[];
+extern unsigned long __stop_kprobe_blacklist[];
+
 static int __init init_kprobes(void)
 {
 	int i, err = 0;
-	unsigned long offset = 0, size = 0;
-	char *modname, namebuf[KSYM_NAME_LEN];
-	const char *symbol_name;
-	void *addr;
-	struct kprobe_blackpoint *kb;
 
 	/* FIXME allocate the probe table, currently defined statically */
 	/* initialize all list heads */
@@ -2082,26 +2101,11 @@ static int __init init_kprobes(void)
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
+	err = populate_kprobe_blacklist(__start_kprobe_blacklist,
+					__stop_kprobe_blacklist);
+	if (err) {
+		pr_err("kprobes: failed to populate blacklist: %d\n", err);
+		pr_err("Please take care of using kprobes.\n");
 	}
 
 	if (kretprobe_blacklist_size) {
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 87c3bc4..05e7595 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2662,6 +2662,7 @@ asmlinkage void __sched notrace preempt_schedule(void)
 		barrier();
 	} while (need_resched());
 }
+NOKPROBE_SYMBOL(preempt_schedule);
 EXPORT_SYMBOL(preempt_schedule);
 #endif /* CONFIG_PREEMPT */
 


