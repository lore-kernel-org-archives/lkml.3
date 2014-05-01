Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755821AbaEAPwk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 11:52:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6624 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754164AbaEAPwf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 11:52:35 -0400
From: Josh Poimboeuf <jpoimboe@redhat.com>
To: Josh Poimboeuf <jpoimboe@redhat.com>, Seth Jennings <sjenning@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Slaby <jslaby@suse.cz>
Cc: linux-kernel@vger.kernel.org
Subject: [RFC PATCH 2/2] kpatch: add kpatch core module
Date: Thu,  1 May 2014 10:52:06 -0500
Message-Id: <2c128e3a379298b2832980903c164e615ee76283.1398958771.git.jpoimboe@redhat.com>
In-Reply-To: <cover.1398958771.git.jpoimboe@redhat.com>
References: <cover.1398958771.git.jpoimboe@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the kpatch core module.  It's a self-contained module with a kernel
patching infrastructure that enables patching a running kernel without
rebooting or restarting any processes.  Kernel modules ("patch modules")
can call kpatch_register() to replace new functions with old ones.

Before applying a patch, kpatch checks the stacks of all tasks in
stop_machine() to ensure that the patch is applied atomically, to
prevent any weird effects from function interface changes or data
semantic changes that might occur between old and new versions of the
functions running simultaneously.  If any of the to-be-patched functions
are on the stack, it fails with -EBUSY.

ftrace is used to do the code modification.  For each function to be
patched, kpatch registers an ftrace ops handler.  When called, the
handler modifies regs->ip on the stack and returns back to ftrace, which
restores the RIP and "returns" to the beginning of the new function.

Other features:

* Safe unpatching

* Atomic repatching (replacing one patch module with another)

* Support for multiple patch modules

* kpatch_[register|unregister] are properly synchronized with
  kpatch_ftrace_handler() when it runs in NMI context (thanks to Masami
  for helping with this)

Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
---
 Documentation/kpatch.txt | 193 +++++++++++++++
 MAINTAINERS              |   9 +
 arch/Kconfig             |  14 ++
 include/linux/kpatch.h   |  61 +++++
 kernel/Makefile          |   1 +
 kernel/kpatch/Makefile   |   1 +
 kernel/kpatch/kpatch.c   | 615 +++++++++++++++++++++++++++++++++++++++++++++++
 7 files changed, 894 insertions(+)
 create mode 100644 Documentation/kpatch.txt
 create mode 100644 include/linux/kpatch.h
 create mode 100644 kernel/kpatch/Makefile
 create mode 100644 kernel/kpatch/kpatch.c

diff --git a/Documentation/kpatch.txt b/Documentation/kpatch.txt
new file mode 100644
index 0000000..697c054
--- /dev/null
+++ b/Documentation/kpatch.txt
@@ -0,0 +1,193 @@
+kpatch: dynamic kernel patching
+===============================
+
+kpatch is a Linux dynamic kernel patching infrastructure which allows you to
+patch a running kernel without rebooting or restarting any processes.  It
+enables sysadmins to apply critical security patches to the kernel immediately,
+without having to wait for long-running tasks to complete, users to log off, or
+for scheduled reboot windows.  It gives more control over uptime without
+sacrificing security or stability.
+
+How it works
+------------
+
+kpatch works at a function granularity: old functions are replaced with new
+ones.  It has four main components:
+
+- **kpatch-build**: a collection of tools which convert a source diff patch to
+  a patch module.  They work by compiling the kernel both with and without
+  the source patch, comparing the binaries, and generating a patch module
+  which includes new binary versions of the functions to be replaced.
+
+- **patch module**: a kernel module (.ko file) which includes the
+  replacement functions and metadata about the original functions.
+
+- **kpatch core module**: the kernel infrastructure which provides an interface
+  for the patch modules to register new functions for replacement.  It uses the
+  kernel ftrace subsystem to hook into the original function's mcount call
+  instruction, so that a call to the original function is redirected to the
+  replacement function.
+
+- **kpatch utility:** a command-line tool which allows a user to manage a
+  collection of patch modules.  One or more patch modules may be
+  configured to load at boot time, so that a system can remain patched
+  even after a reboot into the same version of the kernel.
+
+
+How to use it
+-------------
+
+Currently, only the core module is in the kernel tree.  The supporting
+kpatch-build and kpatch utility tools can be found at:
+
+  https://github.com/dynup/kpatch
+
+You can also find directions there for how to create binary patch modules and
+load them into your kernel.
+
+
+Limitations
+-----------
+
+- Patches which modify kernel modules are not supported (yet).  Only
+  functions in the vmlinux file (listed in System.map) can be patched.
+
+- Patches to functions which are always on the stack of at least one
+  process in the system are not supported.  Examples: schedule(),
+  sys_poll(), sys_select(), sys_read(), sys_nanosleep().  Attempting to
+  apply such a patch will cause the insmod of the patch module to return
+  an error.
+
+- Patches which modify init functions (annotated with `__init`) are not
+  supported.  kpatch-build will return an error if the patch attempts
+  to do so.
+
+- Patches which modify statically allocated data are not supported.
+  kpatch-build will detect that and return an error.  (In the future
+  we will add a facility to support it.  It will probably require the
+  user to write code which runs at patch module loading time which manually
+  updates the data.)
+
+- Patches which change the way a function interacts with dynamically
+  allocated data might be safe, or might not.  It isn't possible for
+  kpatch-build to verify the safety of this kind of patch.  It's up to
+  the user to understand what the patch does, whether the new functions
+  interact with dynamically allocated data in a different way than the
+  old functions did, and whether it would be safe to atomically apply
+  such a patch to a running kernel.
+
+
+Frequently Asked Questions
+--------------------------
+
+**Q. Isn't this just a virus/rootkit injection framework?**
+
+kpatch uses kernel modules to replace code.  It requires the `CAP_SYS_MODULE`
+capability.  If you already have that capability, then you already have the
+ability to arbitrarily modify the kernel, with or without kpatch.
+
+**Q. How can I detect if somebody has patched the kernel?**
+
+When a patch module is loaded, the TAINT_KPATCH flag is set.  To test for the
+taint flag, run:
+
+    [ `cat /proc/sys/kernel/tainted` -ge 16384 ] && echo tainted
+
+If TAINT_KPATCH is set, you'll see "tainted".
+
+**Q. Will it destabilize my system?**
+
+No, as long as the patch is chosen carefully.  See the Limitations section
+above.
+
+**Q. Why does kpatch use ftrace to jump to the replacement function instead of
+adding the jump directly?**
+
+ftrace owns the first "call mcount" instruction of every kernel function.  In
+order to keep compatibility with ftrace, we go through ftrace rather than
+updating the instruction directly.
+
+**Q Is kpatch compatible with \<insert kernel debugging subsystem here\>?**
+
+We aim to be good kernel citizens and maintain compatibility.  A hot patch
+replacement function is no different than a function loaded by any other kernel
+module.  Each replacement function has its own symbol name and kallsyms entry,
+so it looks like a normal function to the kernel.
+
+- **oops stack traces**: Yes.  If the replacement function is involved in an
+  oops, the stack trace will show the function and kernel module name of the
+  replacement function, just like any other kernel module function.  The oops
+  message will also show the taint flag (currently `TAINT_USER`).
+- **kdump/crash**: Yes.  Replacement functions are normal functions, so crash
+  will have no issues. [TODO: create patch module debuginfo symbols and crash
+  warning message]
+- **ftrace**: Yes, see previous question.
+- **systemtap/kprobes**: Some incompatibilities exist.
+  - If you setup a kprobe module at the beginning of a function before loading
+    a kpatch module, and they both affect the same function, kprobes "wins"
+    until the kprobe has been unregistered.  This is tracked in issue
+    [#47](https://github.com/dynup/kpatch/issues/47).
+  - Setting a kretprobe before loading a kpatch module could be unsafe.  See
+    issue [#67](https://github.com/dynup/kpatch/issues/67).
+- **perf**: TODO: try it out
+
+**Q. Why not use something like kexec instead?**
+
+If you want to avoid a hardware reboot, but are ok with restarting processes,
+kexec is a good alternative.
+
+**Q. If an application can't handle a reboot, it's designed wrong.**
+
+That's a good poi... [system reboots]
+
+**Q. What changes are needed in other upstream projects?**
+
+We hope to make the following changes to other projects:
+
+- kernel:
+	- ftrace improvements to close any windows that would allow a patch to
+	  be inadvertently disabled
+	- hot patch taint flag
+	- possibly the kpatch core module itself
+
+- crash:
+	- make it glaringly obvious that you're debugging a patched kernel
+	- point it to where the patch modules and corresponding debug symbols
+	  live on the file system
+
+**Q: Is it possible to register a function that gets called atomically with
+`stop_machine` when the patch module loads and unloads?**
+
+We do have plans to implement something like that.
+
+**Q. What kernels are supported?**
+
+kpatch needs gcc >= 4.6 and Linux >= 3.7 for use of the -mfentry flag.
+
+**Q. Is it possible to remove a patch?**
+
+Yes.  Just run `kpatch unload` which will disable and unload the patch module
+and restore the function to its original state.
+
+**Q. Can you apply multiple patches?**
+
+Yes.  Also, a single function can even be patched multiple times if needed.
+
+**Q. Why did kpatch-build detect a changed function that wasn't touched by the
+source patch?**
+
+There could be a variety of reasons for this, such as:
+
+- The patch changed an inline function.
+- The compiler decided to inline a changed function, resulting in the outer
+  function getting recompiled.  This is common in the case where the inner
+  function is static and is only called once.
+- The function uses a WARN() or WARN_ON() macro.  These macros embed the source
+  code line number (`__LINE__`) into an instruction.  If a function was changed
+  higher up in the file, it will affect the line numbers for all subsequent
+  WARN calls in the file, resulting in recompilation of their functions.  If
+  this happens to you, you can usually just ignore it, as patching a few extra
+  functions isn't typically a problem.  If it becomes a problem for whatever
+  reason, you can change the source patch to redefine the WARN macro for the
+  affected files, such that it hard codes the old line number instead of using
+  `__LINE__`, for example.
diff --git a/MAINTAINERS b/MAINTAINERS
index ea44a57..711dc3b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5200,6 +5200,15 @@ F:	include/linux/kmemleak.h
 F:	mm/kmemleak.c
 F:	mm/kmemleak-test.c
 
+KPATCH
+M:	Josh Poimboeuf <jpoimboe@redhat.com>
+M:	Seth Jennings <sjenning@redhat.com>
+W:	https://github.com/dynup/kpatch
+S:	Maintained
+F:	Documentation/kpatch.txt
+F:	include/linux/kpatch.h
+F:	kernel/kpatch/*
+
 KPROBES
 M:	Ananth N Mavinakayanahalli <ananth@in.ibm.com>
 M:	Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
diff --git a/arch/Kconfig b/arch/Kconfig
index 97ff872..8693aae 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -472,6 +472,20 @@ config HAVE_IRQ_EXIT_ON_IRQ_STACK
 	  This spares a stack switch and improves cache usage on softirq
 	  processing.
 
+config KPATCH
+	tristate "kpatch dynamic kernel updating support"
+	default n
+	depends on MODULES
+	depends on FTRACE
+	depends on HAVE_FENTRY
+	depends on SYSFS
+	help
+	  kpatch is a dynamic kernel patching infrastructure which allows you
+	  to dynamically update the code of a running kernel without rebooting
+	  or restarting any processes.
+
+	  If in doubt, say "N".
+
 #
 # ABI hall of shame
 #
diff --git a/include/linux/kpatch.h b/include/linux/kpatch.h
new file mode 100644
index 0000000..121e383
--- /dev/null
+++ b/include/linux/kpatch.h
@@ -0,0 +1,61 @@
+/*
+ * kpatch.h
+ *
+ * Copyright (C) 2014 Seth Jennings <sjenning@redhat.com>
+ * Copyright (C) 2013-2014 Josh Poimboeuf <jpoimboe@redhat.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see <https://www.gnu.org/licenses/>.
+ *
+ * Contains the API for the core kpatch module used by the patch modules
+ */
+
+#ifndef _KPATCH_H_
+#define _KPATCH_H_
+
+#include <linux/types.h>
+#include <linux/module.h>
+
+enum kpatch_op {
+	KPATCH_OP_NONE,
+	KPATCH_OP_PATCH,
+	KPATCH_OP_UNPATCH,
+};
+
+struct kpatch_func {
+	/* public */
+	unsigned long new_addr;
+	unsigned long new_size;
+	unsigned long old_addr;
+	unsigned long old_size;
+
+	/* private */
+	struct hlist_node node;
+	struct kpatch_module *kpmod;
+	enum kpatch_op op;
+};
+
+struct kpatch_module {
+	struct module *mod;
+	struct kpatch_func *funcs;
+	int num_funcs;
+
+	bool enabled;
+};
+
+extern struct kobject *kpatch_patches_kobj;
+
+extern int kpatch_register(struct kpatch_module *kpmod, bool replace);
+extern int kpatch_unregister(struct kpatch_module *kpmod);
+
+#endif /* _KPATCH_H_ */
diff --git a/kernel/Makefile b/kernel/Makefile
index f2a8b62..2e56269 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -87,6 +87,7 @@ obj-$(CONFIG_RING_BUFFER) += trace/
 obj-$(CONFIG_TRACEPOINTS) += trace/
 obj-$(CONFIG_IRQ_WORK) += irq_work.o
 obj-$(CONFIG_CPU_PM) += cpu_pm.o
+obj-$(CONFIG_KPATCH) += kpatch/
 
 obj-$(CONFIG_PERF_EVENTS) += events/
 
diff --git a/kernel/kpatch/Makefile b/kernel/kpatch/Makefile
new file mode 100644
index 0000000..800241a
--- /dev/null
+++ b/kernel/kpatch/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_KPATCH) := kpatch.o
diff --git a/kernel/kpatch/kpatch.c b/kernel/kpatch/kpatch.c
new file mode 100644
index 0000000..390e926
--- /dev/null
+++ b/kernel/kpatch/kpatch.c
@@ -0,0 +1,615 @@
+/*
+ * Copyright (C) 2014 Seth Jennings <sjenning@redhat.com>
+ * Copyright (C) 2013-2014 Josh Poimboeuf <jpoimboe@redhat.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see <http://www.gnu.org/licenses/>.
+ */
+
+/* Contains the code for the core kpatch module.  Each patch module registers
+ * with this module to redirect old functions to new functions.
+ *
+ * Each patch module can contain one or more new functions.  This information
+ * is contained in the .patches section of the patch module.  For each function
+ * patched by the module we must:
+ * - Call stop_machine
+ * - Ensure that no execution thread is currently in the old function (or has
+ *   it in the call stack)
+ * - Add the new function address to the kpatch_funcs table
+ *
+ * After that, each call to the old function calls into kpatch_ftrace_handler()
+ * which finds the new function in the kpatch_funcs table and updates the
+ * return instruction pointer so that ftrace will return to the new function.
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/kpatch.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/stop_machine.h>
+#include <linux/ftrace.h>
+#include <linux/hashtable.h>
+#include <linux/preempt_mask.h>
+#include <asm/stacktrace.h>
+#include <asm/cacheflush.h>
+
+#define KPATCH_HASH_BITS 8
+static DEFINE_HASHTABLE(kpatch_func_hash, KPATCH_HASH_BITS);
+
+static DEFINE_SEMAPHORE(kpatch_mutex);
+
+static int kpatch_num_registered;
+
+static struct kobject *kpatch_root_kobj;
+struct kobject *kpatch_patches_kobj;
+EXPORT_SYMBOL_GPL(kpatch_patches_kobj);
+
+struct kpatch_backtrace_args {
+	struct kpatch_module *kpmod;
+	int ret;
+};
+
+/*
+ * The kpatch core module has a state machine which allows for proper
+ * synchronization with kpatch_ftrace_handler() when it runs in NMI context.
+ *
+ *         +-----------------------------------------------------+
+ *         |                                                     |
+ *         |                                                     +
+ *         v                                     +---> KPATCH_STATE_SUCCESS
+ * KPATCH_STATE_IDLE +---> KPATCH_STATE_UPDATING |
+ *         ^                                     +---> KPATCH_STATE_FAILURE
+ *         |                                                     +
+ *         |                                                     |
+ *         +-----------------------------------------------------+
+ *
+ * KPATCH_STATE_IDLE: No updates are pending.  The func hash is valid, and the
+ * reader doesn't need to check func->op.
+ *
+ * KPATCH_STATE_UPDATING: An update is in progress.  The reader must call
+ * kpatch_state_finish(KPATCH_STATE_FAILURE) before accessing the func hash.
+ *
+ * KPATCH_STATE_FAILURE: An update failed, and the func hash might be
+ * inconsistent (pending patched funcs might not have been removed yet).  If
+ * func->op is KPATCH_OP_PATCH, then rollback to the previous version of the
+ * func.
+ *
+ * KPATCH_STATE_SUCCESS: An update succeeded, but the func hash might be
+ * inconsistent (pending unpatched funcs might not have been removed yet).  If
+ * func->op is KPATCH_OP_UNPATCH, then rollback to the previous version of the
+ * func.
+ */
+enum {
+	KPATCH_STATE_IDLE,
+	KPATCH_STATE_UPDATING,
+	KPATCH_STATE_SUCCESS,
+	KPATCH_STATE_FAILURE,
+};
+static atomic_t kpatch_state;
+
+
+static inline void kpatch_state_idle(void)
+{
+	int state = atomic_read(&kpatch_state);
+	WARN_ON(state != KPATCH_STATE_SUCCESS && state != KPATCH_STATE_FAILURE);
+	atomic_set(&kpatch_state, KPATCH_STATE_IDLE);
+}
+
+static inline void kpatch_state_updating(void)
+{
+	WARN_ON(atomic_read(&kpatch_state) != KPATCH_STATE_IDLE);
+	atomic_set(&kpatch_state, KPATCH_STATE_UPDATING);
+}
+
+/* If state is updating, change it to success or failure and return new state */
+static inline int kpatch_state_finish(int state)
+{
+	int result;
+	WARN_ON(state != KPATCH_STATE_SUCCESS && state != KPATCH_STATE_FAILURE);
+	result = atomic_cmpxchg(&kpatch_state, KPATCH_STATE_UPDATING, state);
+	return result == KPATCH_STATE_UPDATING ? state : result;
+}
+
+static struct kpatch_func *kpatch_get_func(unsigned long ip)
+{
+	struct kpatch_func *f;
+
+	/* Here, we have to use rcu safe hlist because of NMI concurrency */
+	hash_for_each_possible_rcu(kpatch_func_hash, f, node, ip)
+		if (f->old_addr == ip)
+			return f;
+	return NULL;
+}
+
+static struct kpatch_func *kpatch_get_prev_func(struct kpatch_func *f,
+						unsigned long ip)
+{
+	hlist_for_each_entry_continue_rcu(f, node)
+		if (f->old_addr == ip)
+			return f;
+	return NULL;
+}
+
+static inline int kpatch_compare_addresses(unsigned long stack_addr,
+					   unsigned long func_addr,
+					   unsigned long func_size)
+{
+	if (stack_addr >= func_addr && stack_addr < func_addr + func_size) {
+		/* TODO: use kallsyms to print symbol name */
+		pr_err("activeness safety check failed for function at address 0x%lx\n",
+		       stack_addr);
+		return -EBUSY;
+	}
+	return 0;
+}
+
+static void kpatch_backtrace_address_verify(void *data, unsigned long address,
+				     int reliable)
+{
+	struct kpatch_backtrace_args *args = data;
+	struct kpatch_module *kpmod = args->kpmod;
+	struct kpatch_func *func;
+	int i;
+
+	if (args->ret)
+		return;
+
+	/* check kpmod funcs */
+	for (i = 0; i < kpmod->num_funcs; i++) {
+		unsigned long func_addr, func_size;
+		struct kpatch_func *active_func;
+
+		func = &kpmod->funcs[i];
+		active_func = kpatch_get_func(func->old_addr);
+		if (!active_func) {
+			/* patching an unpatched func */
+			func_addr = func->old_addr;
+			func_size = func->old_size;
+		} else {
+			/* repatching or unpatching */
+			func_addr = active_func->new_addr;
+			func_size = active_func->new_size;
+		}
+
+		args->ret = kpatch_compare_addresses(address, func_addr,
+						     func_size);
+		if (args->ret)
+			return;
+	}
+
+	/* in the replace case, need to check the func hash as well */
+	hash_for_each_rcu(kpatch_func_hash, i, func, node) {
+		if (func->op == KPATCH_OP_UNPATCH) {
+			args->ret = kpatch_compare_addresses(address,
+							     func->new_addr,
+							     func->new_size);
+			if (args->ret)
+				return;
+		}
+	}
+}
+
+static int kpatch_backtrace_stack(void *data, char *name)
+{
+	return 0;
+}
+
+static const struct stacktrace_ops kpatch_backtrace_ops = {
+	.address	= kpatch_backtrace_address_verify,
+	.stack		= kpatch_backtrace_stack,
+	.walk_stack	= print_context_stack_bp,
+};
+
+/*
+ * Verify activeness safety, i.e. that none of the to-be-patched functions are
+ * on the stack of any task.
+ *
+ * This function is called from stop_machine() context.
+ */
+static int kpatch_verify_activeness_safety(struct kpatch_module *kpmod)
+{
+	struct task_struct *g, *t;
+	int ret = 0;
+
+	struct kpatch_backtrace_args args = {
+		.kpmod = kpmod,
+		.ret = 0
+	};
+
+	/* Check the stacks of all tasks. */
+	do_each_thread(g, t) {
+		dump_trace(t, NULL, NULL, 0, &kpatch_backtrace_ops, &args);
+		if (args.ret) {
+			ret = args.ret;
+			goto out;
+		}
+	} while_each_thread(g, t);
+
+out:
+	return ret;
+}
+
+/* Called from stop_machine */
+static int kpatch_apply_patch(void *data)
+{
+	struct kpatch_module *kpmod = data;
+	struct kpatch_func *funcs = kpmod->funcs;
+	int num_funcs = kpmod->num_funcs;
+	int i, ret;
+
+	ret = kpatch_verify_activeness_safety(kpmod);
+	if (ret) {
+		kpatch_state_finish(KPATCH_STATE_FAILURE);
+		return ret;
+	}
+
+	/* tentatively add the new funcs to the global func hash */
+	for (i = 0; i < num_funcs; i++)
+		hash_add_rcu(kpatch_func_hash, &funcs[i].node,
+			     funcs[i].old_addr);
+
+	/* memory barrier between func hash add and state change */
+	smp_wmb();
+
+	/*
+	 * Check if any inconsistent NMI has happened while updating.  If not,
+	 * move to success state.
+	 */
+	ret = kpatch_state_finish(KPATCH_STATE_SUCCESS);
+	if (ret == KPATCH_STATE_FAILURE) {
+		pr_err("NMI activeness safety check failed\n");
+
+		/* Failed, we have to rollback patching process */
+		for (i = 0; i < num_funcs; i++)
+			hash_del_rcu(&funcs[i].node);
+
+		return -EBUSY;
+	}
+
+	return 0;
+}
+
+/* Called from stop_machine */
+static int kpatch_remove_patch(void *data)
+{
+	struct kpatch_module *kpmod = data;
+	struct kpatch_func *funcs = kpmod->funcs;
+	int num_funcs = kpmod->num_funcs;
+	int ret, i;
+
+	ret = kpatch_verify_activeness_safety(kpmod);
+	if (ret) {
+		kpatch_state_finish(KPATCH_STATE_FAILURE);
+		return ret;
+	}
+
+	/* Check if any inconsistent NMI has happened while updating */
+	ret = kpatch_state_finish(KPATCH_STATE_SUCCESS);
+	if (ret == KPATCH_STATE_FAILURE)
+		return -EBUSY;
+
+	/* Succeeded, remove all updating funcs from hash table */
+	for (i = 0; i < num_funcs; i++)
+		hash_del_rcu(&funcs[i].node);
+
+	return 0;
+}
+
+/*
+ * This is where the magic happens.  Update regs->ip to tell ftrace to return
+ * to the new function.
+ *
+ * If there are multiple patch modules that have registered to patch the same
+ * function, the last one to register wins, as it'll be first in the hash
+ * bucket.
+ */
+static void notrace kpatch_ftrace_handler(unsigned long ip, unsigned long parent_ip,
+				   struct ftrace_ops *fops,
+				   struct pt_regs *regs)
+{
+	struct kpatch_func *func;
+	int state;
+
+	preempt_disable_notrace();
+
+	if (likely(!in_nmi()))
+		func = kpatch_get_func(ip);
+	else {
+		/* Checking for NMI inconsistency */
+		state = kpatch_state_finish(KPATCH_STATE_FAILURE);
+
+		/* no memory reordering between state and func hash read */
+		smp_rmb();
+
+		func = kpatch_get_func(ip);
+
+		if (likely(state == KPATCH_STATE_IDLE))
+			goto done;
+
+		if (state == KPATCH_STATE_SUCCESS) {
+			/*
+			 * Patching succeeded.  If the function was being
+			 * unpatched, roll back to the previous version.
+			 */
+			if (func && func->op == KPATCH_OP_UNPATCH)
+				func = kpatch_get_prev_func(func, ip);
+		} else {
+			/*
+			 * Patching failed.  If the function was being patched,
+			 * roll back to the previous version.
+			 */
+			if (func && func->op == KPATCH_OP_PATCH)
+				func = kpatch_get_prev_func(func, ip);
+		}
+	}
+done:
+	if (func)
+		regs->ip = func->new_addr;
+
+	preempt_enable_notrace();
+}
+
+static struct ftrace_ops kpatch_ftrace_ops __read_mostly = {
+	.func = kpatch_ftrace_handler,
+	.flags = FTRACE_OPS_FL_SAVE_REGS,
+};
+
+/* Remove kpatch_funcs from ftrace filter */
+static void kpatch_remove_funcs_from_filter(struct kpatch_func *funcs,
+					    int num_funcs)
+{
+	int i, ret = 0;
+
+	for (i = 0; i < num_funcs; i++) {
+		struct kpatch_func *func = &funcs[i];
+
+		/*
+		 * If any other modules have also patched this function, don't
+		 * remove its ftrace handler.
+		 */
+		if (kpatch_get_func(func->old_addr))
+			continue;
+
+		/* Remove the ftrace handler for this function. */
+		ret = ftrace_set_filter_ip(&kpatch_ftrace_ops, func->old_addr,
+					   1, 0);
+
+		WARN(ret, "can't remove ftrace filter at address 0x%lx (rc=%d)",
+		     func->old_addr, ret);
+	}
+}
+
+int kpatch_register(struct kpatch_module *kpmod, bool replace)
+{
+	int ret, i;
+	struct kpatch_func *funcs = kpmod->funcs;
+	struct kpatch_func *func;
+	int num_funcs = kpmod->num_funcs;
+
+	if (!kpmod->mod || !funcs || !num_funcs)
+		return -EINVAL;
+
+	kpmod->enabled = false;
+
+	down(&kpatch_mutex);
+
+	if (!try_module_get(kpmod->mod)) {
+		ret = -ENODEV;
+		goto err_up;
+	}
+
+	for (i = 0; i < num_funcs; i++) {
+		func = &funcs[i];
+
+		func->op = KPATCH_OP_PATCH;
+		func->kpmod = kpmod;
+
+		/*
+		 * If any other modules have also patched this function, it
+		 * already has an ftrace handler.
+		 */
+		if (kpatch_get_func(func->old_addr))
+			continue;
+
+		/* Add an ftrace handler for this function. */
+		ret = ftrace_set_filter_ip(&kpatch_ftrace_ops, func->old_addr,
+					   0, 0);
+		if (ret) {
+			pr_err("can't set ftrace filter at address 0x%lx\n",
+			       func->old_addr);
+			num_funcs = i;
+			goto err_rollback;
+		}
+	}
+
+	/* Register the ftrace trampoline if it hasn't been done already. */
+	if (!kpatch_num_registered) {
+		ret = register_ftrace_function(&kpatch_ftrace_ops);
+		if (ret) {
+			pr_err("can't register ftrace handler\n");
+			goto err_rollback;
+		}
+	}
+	kpatch_num_registered++;
+
+	if (replace)
+		hash_for_each_rcu(kpatch_func_hash, i, func, node)
+			func->op = KPATCH_OP_UNPATCH;
+
+	/* memory barrier between func hash and state write */
+	smp_wmb();
+
+	kpatch_state_updating();
+
+	/*
+	 * Idle the CPUs, verify activeness safety, and atomically make the new
+	 * functions visible to the trampoline.
+	 */
+	ret = stop_machine(kpatch_apply_patch, kpmod, NULL);
+
+	/*
+	 * For the replace case, remove any obsolete funcs from the hash and
+	 * the ftrace filter, and disable the owning patch module so that it
+	 * can be removed.
+	 */
+	if (!ret && replace)
+		hash_for_each_rcu(kpatch_func_hash, i, func, node) {
+			if (func->op != KPATCH_OP_UNPATCH)
+				continue;
+			hash_del_rcu(&func->node);
+			kpatch_remove_funcs_from_filter(func, 1);
+			if (func->kpmod->enabled) {
+				kpatch_num_registered--;
+				func->kpmod->enabled = false;
+				pr_notice("unloaded patch module \"%s\"\n",
+					  func->kpmod->mod->name);
+				module_put(func->kpmod->mod);
+			}
+		}
+
+	/* memory barrier between func hash and state write */
+	smp_wmb();
+
+	/* NMI handlers can return to normal now */
+	kpatch_state_idle();
+
+	/*
+	 * Wait for all existing NMI handlers to complete so that they don't
+	 * see any changes to funcs or funcs->op that might occur after this
+	 * point.
+	 *
+	 * Any NMI handlers starting after this point will see the IDLE state.
+	 */
+	synchronize_rcu();
+
+	if (ret)
+		goto err_unregister;
+
+	for (i = 0; i < num_funcs; i++)
+		funcs[i].op = KPATCH_OP_NONE;
+
+	pr_notice_once("tainting kernel with TAINT_KPATCH\n");
+	add_taint(TAINT_KPATCH, LOCKDEP_STILL_OK);
+
+	pr_notice("loaded patch module \"%s\"\n", kpmod->mod->name);
+
+	kpmod->enabled = true;
+
+	up(&kpatch_mutex);
+	return 0;
+
+err_unregister:
+	if (replace)
+		hash_for_each_rcu(kpatch_func_hash, i, func, node)
+			func->op = KPATCH_OP_NONE;
+	if (kpatch_num_registered == 1) {
+		int ret2 = unregister_ftrace_function(&kpatch_ftrace_ops);
+		if (ret2) {
+			pr_err("ftrace unregister failed (%d)\n", ret2);
+			goto err_rollback;
+		}
+	}
+	kpatch_num_registered--;
+err_rollback:
+	kpatch_remove_funcs_from_filter(funcs, num_funcs);
+	module_put(kpmod->mod);
+err_up:
+	up(&kpatch_mutex);
+	return ret;
+}
+EXPORT_SYMBOL(kpatch_register);
+
+int kpatch_unregister(struct kpatch_module *kpmod)
+{
+	struct kpatch_func *funcs = kpmod->funcs;
+	int num_funcs = kpmod->num_funcs;
+	int i, ret;
+
+	WARN_ON(!kpmod->enabled);
+
+	down(&kpatch_mutex);
+
+	for (i = 0; i < num_funcs; i++)
+		funcs[i].op = KPATCH_OP_UNPATCH;
+
+	/* memory barrier between func hash and state write */
+	smp_wmb();
+
+	kpatch_state_updating();
+
+	ret = stop_machine(kpatch_remove_patch, kpmod, NULL);
+
+	/* NMI handlers can return to normal now */
+	kpatch_state_idle();
+
+	/*
+	 * Wait for all existing NMI handlers to complete so that they don't
+	 * see any changes to funcs or funcs->op that might occur after this
+	 * point.
+	 *
+	 * Any NMI handlers starting after this point will see the IDLE state.
+	 */
+	synchronize_rcu();
+
+	if (ret) {
+		for (i = 0; i < num_funcs; i++)
+			funcs[i].op = KPATCH_OP_NONE;
+		goto out;
+	}
+
+	if (kpatch_num_registered == 1) {
+		ret = unregister_ftrace_function(&kpatch_ftrace_ops);
+		if (ret)
+			WARN(1, "can't unregister ftrace handler");
+		else
+			kpatch_num_registered--;
+	}
+
+	kpatch_remove_funcs_from_filter(funcs, num_funcs);
+
+	pr_notice("unloaded patch module \"%s\"\n", kpmod->mod->name);
+
+	kpmod->enabled = false;
+	module_put(kpmod->mod);
+
+out:
+	up(&kpatch_mutex);
+	return ret;
+}
+EXPORT_SYMBOL(kpatch_unregister);
+
+static int kpatch_init(void)
+{
+	kpatch_root_kobj = kobject_create_and_add("kpatch", kernel_kobj);
+	if (!kpatch_root_kobj)
+		return -ENOMEM;
+
+	kpatch_patches_kobj = kobject_create_and_add("patches",
+						     kpatch_root_kobj);
+	if (!kpatch_patches_kobj)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static void kpatch_exit(void)
+{
+	WARN_ON(kpatch_num_registered != 0);
+	kobject_put(kpatch_patches_kobj);
+	kobject_put(kpatch_root_kobj);
+}
+
+module_init(kpatch_init);
+module_exit(kpatch_exit);
+MODULE_LICENSE("GPL");
-- 
1.9.0

