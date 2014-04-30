Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422716AbaD3OcJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 10:32:09 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:52349 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759080AbaD3Oav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 10:30:51 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: linux-kernel@vger.kernel.org
Cc: jirislaby@gmail.com, Vojtech Pavlik <vojtech@suse.cz>,
        Michael Matz <matz@suse.de>, Jiri Kosina <jkosina@suse.cz>,
        Jiri Slaby <jslaby@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: [RFC 03/16] kgr: initial code
Date: Wed, 30 Apr 2014 16:30:36 +0200
Message-Id: <1398868249-26169-4-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1398868249-26169-1-git-send-email-jslaby@suse.cz>
References: <1398868249-26169-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Kosina <jkosina@suse.cz>

Provide initial implementation. We are now able to do ftrace-based
runtime patching of the kernel code.

In addition to that, we will provide a kgr_patcher module in the next
patch to test the functionality.

Limitations/TODOs:

- rmmod of the module that provides the patch is not possible (it'd be nice
  if that'd cause reverse application of the patch -- would be necessary to
  keep a list of patched locations)
- x86_64 only

Additional squashes to this patch:
jk: add missing Kconfig.kgr
jk: fixup a header bug
jk: cleanup comments
js: port to new mcount infrastructure
js: order includes
js: fix for non-KGR (prototype and Kconfig fixes)
js: fix potential lock imbalance in kgr_patch_code
js: use insn helper for jmp generation
js: add \n to a printk
jk: externally_visible attribute warning fix
jk: symbol lookup failure handling
jk: fix race between patching and setting a flag (thanks to bpetkov)
js: add more sanity checking
js: handle missing kallsyms gracefully
js: use correct name, not alias
js: fix index in cleanup path
js: clear kgr_in_progress for all syscall paths
js: cleanup
js: do the checking in the process context
js: call kgr_mark_processes outside loop and locks
jk: convert from raw patching to ftrace API
jk: depend on regs-saving ftrace
js: make kgr_init an init_call
js: use correct offset for stub

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
---
 arch/x86/Kconfig                   |   2 +
 arch/x86/include/asm/kgr.h         |  39 +++++
 arch/x86/include/asm/thread_info.h |   1 +
 arch/x86/kernel/asm-offsets.c      |   1 +
 arch/x86/kernel/entry_64.S         |   3 +
 arch/x86/kernel/x8664_ksyms_64.c   |   1 +
 include/linux/kgr.h                |  71 +++++++++
 kernel/Kconfig.kgr                 |   7 +
 kernel/Makefile                    |   1 +
 kernel/kgr.c                       | 308 +++++++++++++++++++++++++++++++++++++
 10 files changed, 434 insertions(+)
 create mode 100644 arch/x86/include/asm/kgr.h
 create mode 100644 include/linux/kgr.h
 create mode 100644 kernel/Kconfig.kgr
 create mode 100644 kernel/kgr.c

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 25d2c6f7325e..789a4c870ab3 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -130,6 +130,7 @@ config X86
 	select HAVE_CC_STACKPROTECTOR
 	select GENERIC_CPU_AUTOPROBE
 	select HAVE_ARCH_AUDITSYSCALL
+	select HAVE_KGR
 
 config INSTRUCTION_DECODER
 	def_bool y
@@ -263,6 +264,7 @@ config ARCH_SUPPORTS_UPROBES
 
 source "init/Kconfig"
 source "kernel/Kconfig.freezer"
+source "kernel/Kconfig.kgr"
 
 menu "Processor type and features"
 
diff --git a/arch/x86/include/asm/kgr.h b/arch/x86/include/asm/kgr.h
new file mode 100644
index 000000000000..172f7b966bb5
--- /dev/null
+++ b/arch/x86/include/asm/kgr.h
@@ -0,0 +1,39 @@
+#ifndef ASM_KGR_H
+#define ASM_KGR_H
+
+#include <linux/linkage.h>
+
+/*
+ * The stub needs to modify the RIP value stored in struct pt_regs
+ * so that ftrace redirects the execution properly.
+ */
+#define KGR_STUB_ARCH_SLOW(_name, _new_function)			\
+static void _new_function ##_stub_slow (unsigned long ip, unsigned long parent_ip,	\
+		struct ftrace_ops *ops, struct pt_regs *regs)		\
+{									\
+	struct kgr_loc_caches *c = ops->private;			\
+									\
+	if (task_thread_info(current)->kgr_in_progress && current->mm) {\
+		pr_info("kgr: slow stub: calling old code at %lx\n",	\
+				c->old);				\
+		regs->ip = c->old + MCOUNT_INSN_SIZE;			\
+	} else {							\
+		pr_info("kgr: slow stub: calling new code at %lx\n",	\
+				c->new);				\
+		regs->ip = c->new;					\
+	}								\
+}
+
+#define KGR_STUB_ARCH_FAST(_name, _new_function)			\
+static void _new_function ##_stub_fast (unsigned long ip,		\
+		unsigned long parent_ip, struct ftrace_ops *ops,	\
+		struct pt_regs *regs)					\
+{									\
+	struct kgr_loc_caches *c = ops->private;			\
+									\
+	BUG_ON(!c->new);				\
+	pr_info("kgr: fast stub: calling new code at %lx\n", c->new); \
+	regs->ip = c->new;				\
+}
+
+#endif
diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index 47e5de25ba79..1fdc144dcc9c 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -35,6 +35,7 @@ struct thread_info {
 	void __user		*sysenter_return;
 	unsigned int		sig_on_uaccess_error:1;
 	unsigned int		uaccess_err:1;	/* uaccess failed */
+	unsigned short		kgr_in_progress;
 };
 
 #define INIT_THREAD_INFO(tsk)			\
diff --git a/arch/x86/kernel/asm-offsets.c b/arch/x86/kernel/asm-offsets.c
index 9f6b9341950f..0db0437967a2 100644
--- a/arch/x86/kernel/asm-offsets.c
+++ b/arch/x86/kernel/asm-offsets.c
@@ -32,6 +32,7 @@ void common(void) {
 	OFFSET(TI_flags, thread_info, flags);
 	OFFSET(TI_status, thread_info, status);
 	OFFSET(TI_addr_limit, thread_info, addr_limit);
+	OFFSET(TI_kgr_in_progress, thread_info, kgr_in_progress);
 
 	BLANK();
 	OFFSET(crypto_tfm_ctx_offset, crypto_tfm, __crt_ctx);
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 1e96c3628bf2..a03b1e9d2de3 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -615,6 +615,7 @@ GLOBAL(system_call_after_swapgs)
 	movq  %rax,ORIG_RAX-ARGOFFSET(%rsp)
 	movq  %rcx,RIP-ARGOFFSET(%rsp)
 	CFI_REL_OFFSET rip,RIP-ARGOFFSET
+	movw $0, TI_kgr_in_progress+THREAD_INFO(%rsp,RIP-ARGOFFSET)
 	testl $_TIF_WORK_SYSCALL_ENTRY,TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET)
 	jnz tracesys
 system_call_fastpath:
@@ -639,6 +640,7 @@ sysret_check:
 	LOCKDEP_SYS_EXIT
 	DISABLE_INTERRUPTS(CLBR_NONE)
 	TRACE_IRQS_OFF
+	movw $0, TI_kgr_in_progress+THREAD_INFO(%rsp,RIP-ARGOFFSET)
 	movl TI_flags+THREAD_INFO(%rsp,RIP-ARGOFFSET),%edx
 	andl %edi,%edx
 	jnz  sysret_careful
@@ -761,6 +763,7 @@ GLOBAL(int_ret_from_sys_call)
 GLOBAL(int_with_check)
 	LOCKDEP_SYS_EXIT_IRQ
 	GET_THREAD_INFO(%rcx)
+	movw $0, TI_kgr_in_progress(%rcx)
 	movl TI_flags(%rcx),%edx
 	andl %edi,%edx
 	jnz   int_careful
diff --git a/arch/x86/kernel/x8664_ksyms_64.c b/arch/x86/kernel/x8664_ksyms_64.c
index 040681928e9d..df6425d44fa0 100644
--- a/arch/x86/kernel/x8664_ksyms_64.c
+++ b/arch/x86/kernel/x8664_ksyms_64.c
@@ -3,6 +3,7 @@
 
 #include <linux/module.h>
 #include <linux/smp.h>
+#include <linux/kgr.h>
 
 #include <net/checksum.h>
 
diff --git a/include/linux/kgr.h b/include/linux/kgr.h
new file mode 100644
index 000000000000..d72add7f3d5d
--- /dev/null
+++ b/include/linux/kgr.h
@@ -0,0 +1,71 @@
+#ifndef LINUX_KGR_H
+#define LINUX_KGR_H
+
+#include <linux/init.h>
+#include <linux/ftrace.h>
+
+#include <asm/kgr.h>
+
+#ifdef CONFIG_KGR
+
+#define KGR_TIMEOUT 30
+#define KGR_DEBUG 1
+
+#ifdef KGR_DEBUG
+#define kgr_debug(args...)	\
+	pr_info(args);
+#else
+#define kgr_debug(args...) { }
+#endif
+
+struct kgr_patch {
+	char reserved;
+	const struct kgr_patch_fun {
+		const char *name;
+		const char *new_name;
+		void *new_function;
+		struct ftrace_ops *ftrace_ops_slow;
+		struct ftrace_ops *ftrace_ops_fast;
+
+	} *patches[];
+};
+
+/*
+ * data structure holding locations of the source and target function
+ * fentry sites to avoid repeated lookups
+ */
+struct kgr_loc_caches {
+	unsigned long old;
+	unsigned long new;
+};
+
+#define KGR_PATCHED_FUNCTION(patch, _name, _new_function)			\
+	KGR_STUB_ARCH_SLOW(_name, _new_function);				\
+	KGR_STUB_ARCH_FAST(_name, _new_function);				\
+	extern void _new_function ## _stub_slow (unsigned long, unsigned long,	\
+		                       struct ftrace_ops *, struct pt_regs *);	\
+	extern void _new_function ## _stub_fast (unsigned long, unsigned long,	\
+		                       struct ftrace_ops *, struct pt_regs *);	\
+	static struct ftrace_ops __kgr_patch_ftrace_ops_slow_ ## _name = {	\
+		.func = _new_function ## _stub_slow,				\
+		.flags = FTRACE_OPS_FL_SAVE_REGS,				\
+	};									\
+	static struct ftrace_ops __kgr_patch_ftrace_ops_fast_ ## _name = {	\
+		.func = _new_function ## _stub_fast,				\
+		.flags = FTRACE_OPS_FL_SAVE_REGS,				\
+	};									\
+	static const struct kgr_patch_fun __kgr_patch_ ## _name = {		\
+		.name = #_name,							\
+		.new_name = #_new_function,					\
+		.new_function = _new_function,					\
+		.ftrace_ops_slow = &__kgr_patch_ftrace_ops_slow_ ## _name,	\
+		.ftrace_ops_fast = &__kgr_patch_ftrace_ops_fast_ ## _name,	\
+	};									\
+
+#define KGR_PATCH(name)		&__kgr_patch_ ## name
+#define KGR_PATCH_END		NULL
+
+extern int kgr_start_patching(const struct kgr_patch *);
+#endif /* CONFIG_KGR */
+
+#endif /* LINUX_KGR_H */
diff --git a/kernel/Kconfig.kgr b/kernel/Kconfig.kgr
new file mode 100644
index 000000000000..af9125f27b6d
--- /dev/null
+++ b/kernel/Kconfig.kgr
@@ -0,0 +1,7 @@
+config HAVE_KGR
+	bool
+
+config KGR
+	tristate "Kgr infrastructure"
+	depends on DYNAMIC_FTRACE_WITH_REGS
+	depends on HAVE_KGR
diff --git a/kernel/Makefile b/kernel/Makefile
index f2a8b6246ce9..86ac7a2e5fe0 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -28,6 +28,7 @@ obj-y += printk/
 obj-y += irq/
 obj-y += rcu/
 
+obj-$(CONFIG_KGR) += kgr.o
 obj-$(CONFIG_CHECKPOINT_RESTORE) += kcmp.o
 obj-$(CONFIG_FREEZER) += freezer.o
 obj-$(CONFIG_PROFILING) += profile.o
diff --git a/kernel/kgr.c b/kernel/kgr.c
new file mode 100644
index 000000000000..6f55c7654618
--- /dev/null
+++ b/kernel/kgr.c
@@ -0,0 +1,308 @@
+/*
+ * kGraft Online Kernel Patching
+ *
+ *  Copyright (c) 2013-2014 SUSE
+ *   Authors: Jiri Kosina
+ *	      Vojtech Pavlik
+ *	      Jiri Slaby
+ */
+
+/*
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ */
+
+#include <linux/ftrace.h>
+#include <linux/kallsyms.h>
+#include <linux/kgr.h>
+#include <linux/module.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/sort.h>
+#include <linux/spinlock.h>
+#include <linux/types.h>
+#include <linux/workqueue.h>
+
+static int kgr_patch_code(const struct kgr_patch_fun *patch_fun, bool final);
+static void kgr_work_fn(struct work_struct *work);
+
+static struct workqueue_struct *kgr_wq;
+static DECLARE_DELAYED_WORK(kgr_work, kgr_work_fn);
+static DEFINE_MUTEX(kgr_in_progress_lock);
+static bool kgr_in_progress;
+static bool kgr_initialized;
+static const struct kgr_patch *kgr_patch;
+
+static bool kgr_still_patching(void)
+{
+	struct task_struct *p;
+	bool failed = false;
+
+	read_lock(&tasklist_lock);
+	for_each_process(p) {
+		/*
+		 * TODO
+		 *   kernel thread codepaths not supported and silently ignored
+		 */
+		if (task_thread_info(p)->kgr_in_progress && p->mm) {
+			pr_info("pid %d (%s) still in kernel after timeout\n",
+					p->pid, p->comm);
+			failed = true;
+		}
+	}
+	read_unlock(&tasklist_lock);
+	return failed;
+}
+
+static void kgr_finalize(void)
+{
+	const struct kgr_patch_fun *const *patch_fun;
+
+	for (patch_fun = kgr_patch->patches; *patch_fun; patch_fun++) {
+		int ret = kgr_patch_code(*patch_fun, true);
+		/*
+		 * In case any of the symbol resolutions in the set
+		 * has failed, patch all the previously replaced fentry
+		 * callsites back to nops and fail with grace
+		 */
+		if (ret < 0)
+			pr_err("kgr: finalize for %s failed, trying to continue\n",
+					(*patch_fun)->name);
+	}
+}
+
+static void kgr_work_fn(struct work_struct *work)
+{
+	if (kgr_still_patching()) {
+		pr_info("kgr failed after timeout (%d), still in degraded mode\n",
+			KGR_TIMEOUT);
+		/* recheck again later */
+		queue_delayed_work(kgr_wq, &kgr_work, KGR_TIMEOUT * HZ);
+		return;
+	}
+
+	/*
+	 * victory, patching finished, put everything back in shape
+	 * with as less performance impact as possible again
+	 */
+	pr_info("kgr succeeded\n");
+	kgr_finalize();
+	mutex_lock(&kgr_in_progress_lock);
+	kgr_in_progress = false;
+	mutex_unlock(&kgr_in_progress_lock);
+}
+
+static void kgr_mark_processes(void)
+{
+	struct task_struct *p;
+
+	read_lock(&tasklist_lock);
+	for_each_process(p)
+		task_thread_info(p)->kgr_in_progress = true;
+	read_unlock(&tasklist_lock);
+}
+
+static unsigned long kgr_get_fentry_loc(const char *f_name)
+{
+	unsigned long orig_addr, fentry_loc;
+	const char *check_name;
+	char check_buf[KSYM_SYMBOL_LEN];
+
+	orig_addr = kallsyms_lookup_name(f_name);
+	if (!orig_addr) {
+		WARN(1, "kgr: function %s not resolved ... kernel in inconsistent state\n",
+				f_name);
+		return -EINVAL;
+	}
+
+	fentry_loc = ftrace_function_to_fentry(orig_addr);
+	if (!fentry_loc) {
+		pr_err("kgr: fentry_loc not properly resolved\n");
+		return -EINVAL;
+	}
+
+	check_name = kallsyms_lookup(fentry_loc, NULL, NULL, NULL, check_buf);
+	if (strcmp(check_name, f_name)) {
+		pr_err("kgr: we got out of bounds the intended function (%s -> %s)\n",
+				f_name, check_name);
+		return -EINVAL;
+	}
+
+	return fentry_loc;
+}
+
+static int kgr_init_ftrace_ops(const struct kgr_patch_fun *patch_fun)
+{
+	struct kgr_loc_caches *caches;
+	unsigned long fentry_loc;
+
+	/*
+	 * Initialize the ftrace_ops->private with pointers to the fentry
+	 * sites of both old and new functions. This is used as a
+	 * redirection target in the per-arch stubs.
+	 *
+	 * Beware! -- freeing (once unloading will be implemented)
+	 * will require synchronize_sched() etc.
+	 */
+
+	caches = kmalloc(sizeof(*caches), GFP_KERNEL);
+	if (!caches) {
+		kgr_debug("kgr: unable to allocate fentry caches\n");
+		return -ENOMEM;
+	}
+
+	fentry_loc = kgr_get_fentry_loc(patch_fun->new_name);
+	if (IS_ERR_VALUE(fentry_loc)) {
+		kgr_debug("kgr: fentry location lookup failed\n");
+		return fentry_loc;
+	}
+	kgr_debug("kgr: storing %lx to caches->new for %s\n",
+			fentry_loc, patch_fun->new_name);
+	caches->new = fentry_loc;
+
+	fentry_loc = kgr_get_fentry_loc(patch_fun->name);
+	if (IS_ERR_VALUE(fentry_loc)) {
+		kgr_debug("kgr: fentry location lookup failed\n");
+		return fentry_loc;
+	}
+
+	kgr_debug("kgr: storing %lx to caches->old for %s\n",
+			fentry_loc, patch_fun->name);
+	caches->old = fentry_loc;
+
+	patch_fun->ftrace_ops_fast->private = caches;
+	patch_fun->ftrace_ops_slow->private = caches;
+
+	return 0;
+}
+
+static int kgr_patch_code(const struct kgr_patch_fun *patch_fun, bool final)
+{
+	struct ftrace_ops *new_ops;
+	struct kgr_loc_caches *caches;
+	unsigned long fentry_loc;
+	int err;
+
+	/* Choose between slow and fast stub */
+	if (!final) {
+		err = kgr_init_ftrace_ops(patch_fun);
+		if (err)
+			return err;
+		kgr_debug("kgr: patching %s to slow stub\n", patch_fun->name);
+		new_ops = patch_fun->ftrace_ops_slow;
+	} else {
+		kgr_debug("kgr: patching %s to fast stub\n", patch_fun->name);
+		new_ops = patch_fun->ftrace_ops_fast;
+	}
+
+	/* Flip the switch */
+	caches = new_ops->private;
+	fentry_loc = caches->old;
+	err = ftrace_set_filter_ip(new_ops, fentry_loc, 0, 0);
+	if (err) {
+		kgr_debug("kgr: setting filter for %lx (%s) failed\n",
+				caches->old, patch_fun->name);
+		return err;
+	}
+
+	err = register_ftrace_function(new_ops);
+	if (err) {
+		kgr_debug("kgr: registering ftrace function for %lx (%s) failed\n",
+				caches->old, patch_fun->name);
+		return err;
+	}
+
+	/*
+	 * Get rid of the slow stub. Having two stubs in the interim is fine,
+	 * the last one always "wins", as it'll be dragged earlier from the
+	 * ftrace hashtable
+	 */
+	if (final) {
+		err = unregister_ftrace_function(patch_fun->ftrace_ops_slow);
+		if (err) {
+			kgr_debug("kgr: unregistering ftrace function for %lx (%s) failed\n",
+					fentry_loc, patch_fun->name);
+			return err;
+		}
+	}
+	kgr_debug("kgr: redirection for %lx (%s) done\n", fentry_loc,
+			patch_fun->name);
+
+	return 0;
+}
+
+/**
+ * kgr_start_patching -- the entry for a kgraft patch
+ * @patch: patch to be applied
+ *
+ * Start patching of code that is neither running in IRQ context nor
+ * kernel thread.
+ */
+int kgr_start_patching(const struct kgr_patch *patch)
+{
+	const struct kgr_patch_fun *const *patch_fun;
+
+	if (!kgr_initialized) {
+		pr_err("kgr: can't patch, not initialized\n");
+		return -EINVAL;
+	}
+
+	mutex_lock(&kgr_in_progress_lock);
+	if (kgr_in_progress) {
+		pr_err("kgr: can't patch, another patching not yet finalized\n");
+		mutex_unlock(&kgr_in_progress_lock);
+		return -EAGAIN;
+	}
+
+	for (patch_fun = patch->patches; *patch_fun; patch_fun++) {
+		int ret;
+
+		ret = kgr_patch_code(*patch_fun, false);
+		/*
+		 * In case any of the symbol resolutions in the set
+		 * has failed, patch all the previously replaced fentry
+		 * callsites back to nops and fail with grace
+		 */
+		if (ret < 0) {
+			for (; patch_fun >= patch->patches; patch_fun--)
+				unregister_ftrace_function((*patch_fun)->ftrace_ops_slow);
+			mutex_unlock(&kgr_in_progress_lock);
+			return ret;
+		}
+	}
+	kgr_in_progress = true;
+	kgr_patch = patch;
+	mutex_unlock(&kgr_in_progress_lock);
+
+	kgr_mark_processes();
+
+	/*
+	 * give everyone time to exit kernel, and check after a while
+	 */
+	queue_delayed_work(kgr_wq, &kgr_work, KGR_TIMEOUT * HZ);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(kgr_start_patching);
+
+static int __init kgr_init(void)
+{
+	if (ftrace_is_dead()) {
+		pr_warning("kgr: enabled, but no fentry locations found ... aborting\n");
+		return -ENODEV;
+	}
+
+	kgr_wq = create_singlethread_workqueue("kgr");
+	if (!kgr_wq) {
+		pr_err("kgr: cannot allocate a work queue, aborting!\n");
+		return -ENOMEM;
+	}
+
+	kgr_initialized = true;
+	pr_info("kgr: successfully initialized\n");
+
+	return 0;
+}
+module_init(kgr_init);
-- 
1.9.2

