Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756448AbaGOBhw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 21:37:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52448 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755469AbaGOBhj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 21:37:39 -0400
From: Josh Poimboeuf <jpoimboe@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Seth Jennings <sjenning@redhat.com>,
        Jiri Slaby <jslaby@suse.cz>, Jiri Kosina <jkosina@suse.cz>,
        Vojtech Pavlik <vojtech@suse.cz>, kpatch@redhat.com
Subject: [PATCH v2 2/2] kpatch: add kpatch core module
Date: Mon, 14 Jul 2014 20:37:07 -0500
Message-Id: <0d4a54ac6e524f2b9fb4e4b43220c07a64f32ec6.1405374204.git.jpoimboe@redhat.com>
In-Reply-To: <cover.1405374204.git.jpoimboe@redhat.com>
References: <cover.1405374204.git.jpoimboe@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the kpatch core module.  It's a self-contained module with a kernel
patching infrastructure that enables patching a running kernel without
rebooting or restarting any processes.  Kernel modules ("patch modules")
can call kpatch_register() to replace old functions with new ones.

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

- safe unpatching
- module patching and deferred module patching
- dynamic relocations for accessing non-exported symbols
- atomic patch replacement
- supports atomic load/unload user hook functions
- support for multiple patch modules
- ability to force skip the activeness safety stack check for a given function
- kpatch_[register|unregister] are properly synchronized with
  kpatch_ftrace_handler() when it runs in NMI context (thanks to Masami
  for helping with this)

Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
---
 Documentation/kpatch.txt |  209 ++++++++++
 MAINTAINERS              |    9 +
 arch/Kconfig             |   16 +
 include/linux/kpatch.h   |   95 +++++
 kernel/Makefile          |    1 +
 kernel/kpatch/Makefile   |    1 +
 kernel/kpatch/kpatch.c   | 1041 ++++++++++++++++++++++++++++++++++++++++++++++
 7 files changed, 1372 insertions(+)
 create mode 100644 Documentation/kpatch.txt
 create mode 100644 include/linux/kpatch.h
 create mode 100644 kernel/kpatch/Makefile
 create mode 100644 kernel/kpatch/kpatch.c

diff --git a/Documentation/kpatch.txt b/Documentation/kpatch.txt
new file mode 100644
index 0000000..f807bea
--- /dev/null
+++ b/Documentation/kpatch.txt
@@ -0,0 +1,209 @@
+kpatch: dynamic kernel patching
+===============================
+
+kpatch is a Linux dynamic kernel patching infrastructure which allows you to
+patch a running kernel without rebooting or restarting any processes.  It
+enables sysadmins to apply critical security patches to the kernel immediately,
+without having to wait for long-running tasks to complete, for users to log
+off, or for scheduled reboot windows.  It gives more control over uptime
+without sacrificing security or stability.
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
+The kpatch-build and kpatch utility tools can be found at:
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
+- Patches which modify functions in vdso are not supported.  These run in
+  user-space and ftrace can't hook them.
+
+- Some incompatibilities currently exist between kpatch and usage of ftrace and
+  kprobes.  See the Frequently Asked Questions section for more details.
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
+When a patch module is loaded, the `TAINT_KPATCH` flag is set.  To test for it,
+`cat /proc/sys/kernel/tainted` and check to see if the value of 16384 has been
+OR'ed in.
+
+Note that the `TAINT_OOT_MODULE` flag (4096) will also be set, since the patch
+module is built outside the Linux kernel source tree.
+
+If your patch module is unsigned, the `TAINT_UNSIGNED_MODULE` flag (8192) will
+also be set.
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
+updating the instruction directly.  This approach also ensures that the code
+modification path is reliable, since ftrace has been doing it successfully for
+years.
+
+**Q Is kpatch compatible with \<insert kernel debugging subsystem here\>?**
+
+We aim to be good kernel citizens and maintain compatibility.  A kpatch
+replacement function is no different than a function loaded by any other kernel
+module.  Each replacement function has its own symbol name and kallsyms entry,
+so it looks like a normal function to the kernel.
+
+- **oops stack traces**: Yes.  If the replacement function is involved in an
+  oops, the stack trace will show the function and kernel module name of the
+  replacement function, just like any other kernel module function.  The oops
+  message will also show the taint flag (currently `TAINT_USER`).
+- **kdump/crash**: Yes.  Replacement functions are normal functions, so crash
+  will have no issues.
+- **ftrace**: Yes, but certain uses of ftrace which involve opening the
+  `/sys/kernel/debug/tracing/trace` file or using `trace-cmd record` can result
+  in a tiny window of time where a patch gets temporarily disabled.  Therefore
+  it's a good idea to avoid using ftrace on a patched system until this issue
+  is resolved.
+- **systemtap/kprobes**: Some incompatibilities exist.
+  - If you setup a kprobe module at the beginning of a function before loading
+    a kpatch module, and they both affect the same function, kprobes "wins"
+    until the kprobe has been unregistered.  This is tracked in issue
+    [#47](https://github.com/dynup/kpatch/issues/47).
+  - Setting a kretprobe before loading a kpatch module could be unsafe.  See
+    issue [#67](https://github.com/dynup/kpatch/issues/67).
+- **perf**: Yes.
+- **tracepoints**: Patches to a function which uses tracepoints will result in
+  the tracepoints being effectively disabled as long as the patch is applied.
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
+kpatch needs gcc >= 4.8 and Linux >= 3.7 for use of the -mfentry flag.
+
+**Q. Is it possible to remove a patch?**
+
+Yes.  Just run `kpatch unload` which will disable and unload the patch module
+and restore the function to its original state.
+
+**Q. Can you apply multiple patches?**
+
+Yes, but to prevent any unexpected interactions between multiple patch modules,
+it's recommended that you only have a single patch loaded at any given time.
+This can be achieved by combining the new patch with the previous patch using
+`combinediff` before running `kpatch-build`.  You can then the `kpatch replace`
+command to atomically replace the old patch module with the new cumulative one.
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
index e31c874..c04a99c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5284,6 +5284,15 @@ F:	include/linux/kmemleak.h
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
index 97ff872..3726780 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -472,6 +472,22 @@ config HAVE_IRQ_EXIT_ON_IRQ_STACK
 	  This spares a stack switch and improves cache usage on softirq
 	  processing.
 
+config KPATCH
+	tristate "kpatch dynamic kernel updating support"
+	default n
+	depends on MODULES
+	depends on FTRACE
+	depends on HAVE_FENTRY
+	depends on SYSFS
+	depends on FUNCTION_TRACER
+	depends on KALLSYMS_ALL
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
index 0000000..be73593
--- /dev/null
+++ b/include/linux/kpatch.h
@@ -0,0 +1,95 @@
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
+	unsigned long old_offset;
+	unsigned long old_size;
+	const char *name;
+	struct list_head list;
+	int force;
+
+	/* private */
+	struct hlist_node node;
+	unsigned long old_addr;
+	enum kpatch_op op;
+};
+
+struct kpatch_dynrela {
+	unsigned long dest;
+	unsigned long src;
+	unsigned long type;
+	const char *name;
+	int addend;
+	int exported;
+	struct list_head list;
+};
+
+struct kpatch_hook {
+	struct list_head list;
+	void (*hook)(void);
+};
+
+struct kpatch_object {
+	struct list_head list;
+	const char *name;
+	struct list_head funcs;
+	struct list_head dynrelas;
+	struct list_head hooks_load;
+	struct list_head hooks_unload;
+
+	/* private */
+	struct module *mod;
+};
+
+struct kpatch_module {
+	/* public */
+	struct module *mod;
+	struct list_head objects;
+
+	/* public read-only */
+	bool enabled;
+
+	/* private */
+	struct list_head list;
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
index 0000000..921532b
--- /dev/null
+++ b/kernel/kpatch/kpatch.c
@@ -0,0 +1,1041 @@
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
+/*
+ * kpatch core module
+ *
+ * Patch modules register with this module to redirect old functions to new
+ * functions.
+ *
+ * For each function patched by the module we must:
+ * - Call stop_machine
+ * - Ensure that no task has the old function in its call stack
+ * - Add the new function address to kpatch_func_hash
+ *
+ * After that, each call to the old function calls into kpatch_ftrace_handler()
+ * which finds the new function in kpatch_func_hash table and updates the
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
+#include <linux/hardirq.h>
+#include <linux/uaccess.h>
+#include <linux/kallsyms.h>
+#include <asm/stacktrace.h>
+#include <asm/cacheflush.h>
+
+#define KPATCH_HASH_BITS 8
+static DEFINE_HASHTABLE(kpatch_func_hash, KPATCH_HASH_BITS);
+
+static DEFINE_SEMAPHORE(kpatch_mutex);
+
+LIST_HEAD(kpmod_list);
+
+static int kpatch_num_patched;
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
+struct kpatch_kallsyms_args {
+	const char *name;
+	unsigned long addr;
+};
+
+/* this is a double loop, use goto instead of break */
+#define do_for_each_linked_func(kpmod, func) {				\
+	struct kpatch_object *_object;					\
+	list_for_each_entry(_object, &kpmod->objects, list) {		\
+		if (!kpatch_object_linked(_object))			\
+			continue;					\
+		list_for_each_entry(func, &_object->funcs, list) {
+
+#define while_for_each_linked_func()					\
+		}							\
+	}								\
+}
+
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
+static inline void kpatch_state_idle(void)
+{
+	int state = atomic_read(&kpatch_state);
+
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
+
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
+static inline bool kpatch_object_linked(struct kpatch_object *object)
+{
+	return object->mod || !strcmp(object->name, "vmlinux");
+}
+
+static inline int kpatch_compare_addresses(unsigned long stack_addr,
+					   unsigned long func_addr,
+					   unsigned long func_size,
+					   const char *func_name)
+{
+	if (stack_addr >= func_addr && stack_addr < func_addr + func_size) {
+		pr_err("activeness safety check failed for %s\n", func_name);
+		return -EBUSY;
+	}
+	return 0;
+}
+
+static void kpatch_backtrace_address_verify(void *data, unsigned long address,
+					    int reliable)
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
+	do_for_each_linked_func(kpmod, func) {
+		unsigned long func_addr, func_size;
+		const char *func_name;
+		struct kpatch_func *active_func;
+
+		if (func->force)
+			continue;
+
+		active_func = kpatch_get_func(func->old_addr);
+		if (!active_func) {
+			/* patching an unpatched func */
+			func_addr = func->old_addr;
+			func_size = func->old_size;
+			func_name = func->name;
+		} else {
+			/* repatching or unpatching */
+			func_addr = active_func->new_addr;
+			func_size = active_func->new_size;
+			func_name = active_func->name;
+		}
+
+		args->ret = kpatch_compare_addresses(address, func_addr,
+						     func_size, func_name);
+		if (args->ret)
+			return;
+	} while_for_each_linked_func();
+
+	/* in the replace case, need to check the func hash as well */
+	hash_for_each_rcu(kpatch_func_hash, i, func, node) {
+		if (func->op == KPATCH_OP_UNPATCH && !func->force) {
+			args->ret = kpatch_compare_addresses(address,
+							     func->new_addr,
+							     func->new_size,
+							     func->name);
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
+static int kpatch_print_trace_stack(void *data, char *name)
+{
+	pr_cont(" <%s> ", name);
+	return 0;
+}
+
+static void kpatch_print_trace_address(void *data, unsigned long addr,
+				       int reliable)
+{
+	if (reliable)
+		pr_info("[<%p>] %pB\n", (void *)addr, (void *)addr);
+}
+
+static const struct stacktrace_ops kpatch_print_trace_ops = {
+	.stack		= kpatch_print_trace_stack,
+	.address	= kpatch_print_trace_address,
+	.walk_stack	= print_context_stack,
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
+			pr_info("PID: %d Comm: %.20s\n", t->pid, t->comm);
+			dump_trace(t, NULL, (unsigned long *)t->thread.sp,
+				   0, &kpatch_print_trace_ops, NULL);
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
+	struct kpatch_func *func;
+	struct kpatch_hook *hook;
+	struct kpatch_object *object;
+	int ret;
+
+	ret = kpatch_verify_activeness_safety(kpmod);
+	if (ret) {
+		kpatch_state_finish(KPATCH_STATE_FAILURE);
+		return ret;
+	}
+
+	/* tentatively add the new funcs to the global func hash */
+	do_for_each_linked_func(kpmod, func) {
+		hash_add_rcu(kpatch_func_hash, &func->node, func->old_addr);
+	} while_for_each_linked_func();
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
+		do_for_each_linked_func(kpmod, func) {
+			hash_del_rcu(&func->node);
+		} while_for_each_linked_func();
+
+		return -EBUSY;
+	}
+
+	/* run any user-defined load hooks */
+	list_for_each_entry(object, &kpmod->objects, list) {
+		if (!kpatch_object_linked(object))
+			continue;
+		list_for_each_entry(hook, &object->hooks_load, list)
+			(*hook->hook)();
+	}
+
+
+	return 0;
+}
+
+/* Called from stop_machine */
+static int kpatch_remove_patch(void *data)
+{
+	struct kpatch_module *kpmod = data;
+	struct kpatch_func *func;
+	struct kpatch_hook *hook;
+	struct kpatch_object *object;
+	int ret;
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
+	do_for_each_linked_func(kpmod, func) {
+		hash_del_rcu(&func->node);
+	} while_for_each_linked_func();
+
+	/* run any user-defined unload hooks */
+	list_for_each_entry(object, &kpmod->objects, list) {
+		if (!kpatch_object_linked(object))
+			continue;
+		list_for_each_entry(hook, &object->hooks_unload, list)
+			(*hook->hook)();
+	}
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
+static void notrace
+kpatch_ftrace_handler(unsigned long ip, unsigned long parent_ip,
+		      struct ftrace_ops *fops, struct pt_regs *regs)
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
+		regs->ip = func->new_addr + MCOUNT_INSN_SIZE;
+
+	preempt_enable_notrace();
+}
+
+static struct ftrace_ops kpatch_ftrace_ops __read_mostly = {
+	.func = kpatch_ftrace_handler,
+	.flags = FTRACE_OPS_FL_SAVE_REGS,
+};
+
+static int kpatch_ftrace_add_func(unsigned long ip)
+{
+	int ret;
+
+	/* check if any other patch modules have also patched this func */
+	if (kpatch_get_func(ip))
+		return 0;
+
+	ret = ftrace_set_filter_ip(&kpatch_ftrace_ops, ip, 0, 0);
+	if (ret) {
+		pr_err("can't set ftrace filter at address 0x%lx\n", ip);
+		return ret;
+	}
+
+	if (!kpatch_num_patched) {
+		ret = register_ftrace_function(&kpatch_ftrace_ops);
+		if (ret) {
+			pr_err("can't register ftrace handler\n");
+			ftrace_set_filter_ip(&kpatch_ftrace_ops, ip, 1, 0);
+			return ret;
+		}
+	}
+	kpatch_num_patched++;
+
+	return 0;
+}
+
+static int kpatch_ftrace_remove_func(unsigned long ip)
+{
+	int ret;
+
+	/* check if any other patch modules have also patched this func */
+	if (kpatch_get_func(ip))
+		return 0;
+
+	if (kpatch_num_patched == 1) {
+		ret = unregister_ftrace_function(&kpatch_ftrace_ops);
+		if (ret) {
+			pr_err("can't unregister ftrace handler\n");
+			return ret;
+		}
+	}
+	kpatch_num_patched--;
+
+	ret = ftrace_set_filter_ip(&kpatch_ftrace_ops, ip, 1, 0);
+	if (ret) {
+		pr_err("can't remove ftrace filter at address 0x%lx\n", ip);
+		return ret;
+	}
+
+	return 0;
+}
+
+static int kpatch_kallsyms_callback(void *data, const char *name,
+					 struct module *mod,
+					 unsigned long addr)
+{
+	struct kpatch_kallsyms_args *args = data;
+
+	if (args->addr == addr && !strcmp(args->name, name))
+		return 1;
+
+	return 0;
+}
+
+static int kpatch_verify_symbol_match(const char *name, unsigned long addr)
+{
+	int ret;
+
+	struct kpatch_kallsyms_args args = {
+		.name = name,
+		.addr = addr,
+	};
+
+	ret = kallsyms_on_each_symbol(kpatch_kallsyms_callback, &args);
+	if (!ret) {
+		pr_err("base kernel mismatch for symbol '%s'\n", name);
+		pr_err("expected address was 0x%016lx\n", addr);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static unsigned long kpatch_find_module_symbol(struct module *mod,
+					       const char *name)
+{
+	char buf[KSYM_SYMBOL_LEN];
+
+	/* check total string length for overrun */
+	if (strlen(mod->name) + strlen(name) + 1 >= KSYM_SYMBOL_LEN) {
+		pr_err("buffer overrun finding symbol '%s' in module '%s'\n",
+		       name, mod->name);
+		return 0;
+	}
+
+	/* encode symbol name as "mod->name:name" */
+	strcpy(buf, mod->name);
+	strcat(buf, ":");
+	strcat(buf, name);
+
+	return kallsyms_lookup_name(buf);
+}
+
+static int kpatch_write_relocations(struct kpatch_module *kpmod,
+				    struct kpatch_object *object)
+{
+	int ret, size, readonly = 0, numpages;
+	struct kpatch_dynrela *dynrela;
+	u64 loc, val;
+	unsigned long core = (unsigned long)kpmod->mod->module_core;
+	unsigned long core_ro_size = kpmod->mod->core_ro_size;
+	unsigned long core_size = kpmod->mod->core_size;
+	unsigned long src;
+
+	list_for_each_entry(dynrela, &object->dynrelas, list) {
+		if (!strcmp(object->name, "vmlinux")) {
+			ret = kpatch_verify_symbol_match(dynrela->name,
+							 dynrela->src);
+			if (ret)
+				return ret;
+		} else {
+			/* module, dynrela->src needs to be discovered */
+
+			if (dynrela->exported)
+				src = (ulong)__symbol_get(dynrela->name);
+			else
+				src = kpatch_find_module_symbol(object->mod,
+								dynrela->name);
+
+			if (!src) {
+				pr_err("unable to find symbol '%s'\n",
+				       dynrela->name);
+				return -EINVAL;
+			}
+
+			dynrela->src = src;
+		}
+
+		switch (dynrela->type) {
+		case R_X86_64_NONE:
+			continue;
+		case R_X86_64_PC32:
+			loc = dynrela->dest;
+			val = (u32)(dynrela->src + dynrela->addend -
+				    dynrela->dest);
+			size = 4;
+			break;
+		case R_X86_64_32S:
+			loc = dynrela->dest;
+			val = (s32)dynrela->src + dynrela->addend;
+			size = 4;
+			break;
+		case R_X86_64_64:
+			loc = dynrela->dest;
+			val = dynrela->src;
+			size = 8;
+			break;
+		default:
+			pr_err("unsupported rela type %ld for source %s (0x%lx <- 0x%lx)\n",
+			       dynrela->type, dynrela->name, dynrela->dest,
+			       dynrela->src);
+			return -EINVAL;
+		}
+
+		if (loc >= core && loc < core + core_ro_size)
+			readonly = 1;
+		else if (loc >= core + core_ro_size && loc < core + core_size)
+			readonly = 0;
+		else {
+			pr_err("bad dynrela location 0x%llx for symbol %s\n",
+			       loc, dynrela->name);
+			return -EINVAL;
+		}
+
+		numpages = (PAGE_SIZE - (loc & ~PAGE_MASK) >= size) ? 1 : 2;
+
+		if (readonly)
+			set_memory_rw(loc & PAGE_MASK, numpages);
+
+		ret = probe_kernel_write((void *)loc, &val, size);
+
+		if (readonly)
+			set_memory_ro(loc & PAGE_MASK, numpages);
+
+		if (ret) {
+			pr_err("write to 0x%llx failed for symbol %s\n",
+			       loc, dynrela->name);
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
+static int kpatch_unlink_object(struct kpatch_object *object)
+{
+	struct kpatch_func *func;
+	struct kpatch_dynrela *dynrela;
+	int ret;
+
+	list_for_each_entry(func, &object->funcs, list) {
+		if (!func->old_addr)
+			continue;
+		ret = kpatch_ftrace_remove_func(func->old_addr);
+		if (ret) {
+			WARN(1, "can't unregister ftrace for address 0x%lx\n",
+			     func->old_addr);
+			return ret;
+		}
+	}
+
+	list_for_each_entry(dynrela, &object->dynrelas, list)
+		if (dynrela->src && dynrela->exported)
+			__symbol_put(dynrela->name);
+
+	if (object->mod)
+		module_put(object->mod);
+
+	return 0;
+}
+
+/*
+ * Link to a to-be-patched object in preparation for patching it.
+ *
+ * - Find the object module
+ * - Write patch module relocations which reference the object
+ * - Calculate the patched functions' addresses
+ * - Register them with ftrace
+ */
+static int kpatch_link_object(struct kpatch_module *kpmod,
+			      struct kpatch_object *object)
+{
+	struct module *mod = NULL;
+	struct kpatch_func *func;
+	int ret;
+	bool vmlinux = !strcmp(object->name, "vmlinux");
+
+	if (!vmlinux) {
+		mutex_lock(&module_mutex);
+		mod = find_module(object->name);
+		if (!mod) {
+			/*
+			 * The module hasn't been loaded yet.  We can patch it
+			 * later in kpatch_module_notify().
+			 */
+			mutex_unlock(&module_mutex);
+			return 0;
+		}
+
+		/* should never fail because we have the mutex */
+		WARN_ON(!try_module_get(mod));
+		mutex_unlock(&module_mutex);
+		object->mod = mod;
+	}
+
+	ret = kpatch_write_relocations(kpmod, object);
+	if (ret)
+		goto err_unlink;
+
+	list_for_each_entry(func, &object->funcs, list) {
+		unsigned long old_addr;
+
+		/* calculate actual old location */
+		if (vmlinux) {
+			old_addr = func->old_offset;
+			ret = kpatch_verify_symbol_match(func->name,
+							 old_addr);
+			if (ret)
+				goto err_unlink;
+		} else
+			old_addr = (unsigned long)mod->module_core +
+				   func->old_offset;
+
+		/* add to ftrace filter and register handler if needed */
+		ret = kpatch_ftrace_add_func(old_addr);
+		if (ret)
+			goto err_unlink;
+
+		func->old_addr = old_addr;
+	}
+
+	return 0;
+
+err_unlink:
+	kpatch_unlink_object(object);
+	return ret;
+}
+
+static int kpatch_module_notify(struct notifier_block *nb, unsigned long action,
+				void *data)
+{
+	struct module *mod = data;
+	struct kpatch_module *kpmod;
+	struct kpatch_object *object;
+	struct kpatch_func *func;
+	struct kpatch_hook *hook;
+	int ret = 0;
+	bool found = false;
+
+	if (action != MODULE_STATE_COMING)
+		return 0;
+
+	down(&kpatch_mutex);
+
+	list_for_each_entry(kpmod, &kpmod_list, list) {
+		list_for_each_entry(object, &kpmod->objects, list) {
+			if (kpatch_object_linked(object))
+				continue;
+			if (!strcmp(object->name, mod->name)) {
+				found = true;
+				goto done;
+			}
+		}
+	}
+done:
+	if (!found)
+		goto out;
+
+	ret = kpatch_link_object(kpmod, object);
+	if (ret)
+		goto out;
+
+	BUG_ON(!object->mod);
+
+	pr_notice("patching newly loaded module '%s'\n", object->name);
+
+	/* run any user-defined load hooks */
+	list_for_each_entry(hook, &object->hooks_load, list)
+		(*hook->hook)();
+
+	/* add to the global func hash */
+	list_for_each_entry(func, &object->funcs, list)
+		hash_add_rcu(kpatch_func_hash, &func->node, func->old_addr);
+
+out:
+	up(&kpatch_mutex);
+
+	/* no way to stop the module load on error */
+	WARN(ret, "error (%d) patching newly loaded module '%s'\n", ret,
+	     object->name);
+	return 0;
+}
+
+int kpatch_register(struct kpatch_module *kpmod, bool replace)
+{
+	int ret, i, force = 0;
+	struct kpatch_object *object;
+	struct kpatch_func *func;
+
+	if (!kpmod->mod || list_empty(&kpmod->objects))
+		return -EINVAL;
+
+	down(&kpatch_mutex);
+
+	kpmod->enabled = false;
+	list_add_tail(&kpmod->list, &kpmod_list);
+
+	if (!try_module_get(kpmod->mod)) {
+		ret = -ENODEV;
+		goto err_up;
+	}
+
+	list_for_each_entry(object, &kpmod->objects, list) {
+
+		ret = kpatch_link_object(kpmod, object);
+		if (ret)
+			goto err_unlink;
+
+		if (!kpatch_object_linked(object)) {
+			pr_notice("delaying patch of unloaded module '%s'\n",
+				  object->name);
+			continue;
+		}
+
+		if (strcmp(object->name, "vmlinux"))
+			pr_notice("patching module '%s'\n", object->name);
+
+		list_for_each_entry(func, &object->funcs, list)
+			func->op = KPATCH_OP_PATCH;
+	}
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
+	 * functions visible to the ftrace handler.
+	 */
+	ret = stop_machine(kpatch_apply_patch, kpmod, NULL);
+
+	/*
+	 * For the replace case, remove any obsolete funcs from the hash and
+	 * the ftrace filter, and disable the owning patch module so that it
+	 * can be removed.
+	 */
+	if (!ret && replace) {
+		struct kpatch_module *kpmod2, *safe;
+
+		hash_for_each_rcu(kpatch_func_hash, i, func, node) {
+			if (func->op != KPATCH_OP_UNPATCH)
+				continue;
+			if (func->force)
+				force = 1;
+			hash_del_rcu(&func->node);
+			WARN_ON(kpatch_ftrace_remove_func(func->old_addr));
+		}
+
+		list_for_each_entry_safe(kpmod2, safe, &kpmod_list, list) {
+			if (kpmod == kpmod2)
+				continue;
+
+			kpmod2->enabled = false;
+			pr_notice("unloaded patch module '%s'\n",
+				  kpmod2->mod->name);
+
+			/*
+			 * Don't allow modules with forced functions to be
+			 * removed because they might still be in use.
+			 */
+			if (!force)
+				module_put(kpmod2->mod);
+
+			list_del(&kpmod2->list);
+		}
+	}
+
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
+		goto err_ops;
+
+	do_for_each_linked_func(kpmod, func) {
+		func->op = KPATCH_OP_NONE;
+	} while_for_each_linked_func();
+
+	pr_notice_once("tainting kernel with TAINT_KPATCH\n");
+	add_taint(TAINT_KPATCH, LOCKDEP_STILL_OK);
+
+	pr_notice("loaded patch module '%s'\n", kpmod->mod->name);
+
+	kpmod->enabled = true;
+
+	up(&kpatch_mutex);
+	return 0;
+
+err_ops:
+	if (replace)
+		hash_for_each_rcu(kpatch_func_hash, i, func, node)
+			func->op = KPATCH_OP_NONE;
+err_unlink:
+	list_for_each_entry(object, &kpmod->objects, list)
+		if (kpatch_object_linked(object))
+			kpatch_unlink_object(object);
+	module_put(kpmod->mod);
+err_up:
+	list_del(&kpmod->list);
+	up(&kpatch_mutex);
+	return ret;
+}
+EXPORT_SYMBOL(kpatch_register);
+
+int kpatch_unregister(struct kpatch_module *kpmod)
+{
+	struct kpatch_object *object;
+	struct kpatch_func *func;
+	int ret, force = 0;
+
+	if (!kpmod->enabled)
+		return -EINVAL;
+
+	down(&kpatch_mutex);
+
+	do_for_each_linked_func(kpmod, func) {
+		func->op = KPATCH_OP_UNPATCH;
+		if (func->force)
+			force = 1;
+	} while_for_each_linked_func();
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
+		do_for_each_linked_func(kpmod, func) {
+			func->op = KPATCH_OP_NONE;
+		} while_for_each_linked_func();
+		goto out;
+	}
+
+	list_for_each_entry(object, &kpmod->objects, list) {
+		if (!kpatch_object_linked(object))
+			continue;
+		ret = kpatch_unlink_object(object);
+		if (ret)
+			goto out;
+	}
+
+	pr_notice("unloaded patch module '%s'\n", kpmod->mod->name);
+
+	kpmod->enabled = false;
+
+	/*
+	 * Don't allow modules with forced functions to be removed because they
+	 * might still be in use.
+	 */
+	if (!force)
+		module_put(kpmod->mod);
+
+	list_del(&kpmod->list);
+
+out:
+	up(&kpatch_mutex);
+	return ret;
+}
+EXPORT_SYMBOL(kpatch_unregister);
+
+
+static struct notifier_block kpatch_module_nb = {
+	.notifier_call = kpatch_module_notify,
+	.priority = INT_MIN, /* called last */
+};
+
+static int kpatch_init(void)
+{
+	int ret;
+
+	kpatch_root_kobj = kobject_create_and_add("kpatch", kernel_kobj);
+	if (!kpatch_root_kobj)
+		return -ENOMEM;
+
+	kpatch_patches_kobj = kobject_create_and_add("patches",
+						     kpatch_root_kobj);
+	if (!kpatch_patches_kobj) {
+		ret = -ENOMEM;
+		goto err_root_kobj;
+	}
+
+	ret = register_module_notifier(&kpatch_module_nb);
+	if (ret)
+		goto err_patches_kobj;
+
+	return 0;
+
+err_patches_kobj:
+	kobject_put(kpatch_patches_kobj);
+err_root_kobj:
+	kobject_put(kpatch_root_kobj);
+	return ret;
+}
+
+static void kpatch_exit(void)
+{
+	WARN_ON(kpatch_num_patched != 0);
+	WARN_ON(unregister_module_notifier(&kpatch_module_nb));
+	kobject_put(kpatch_patches_kobj);
+	kobject_put(kpatch_root_kobj);
+}
+
+module_init(kpatch_init);
+module_exit(kpatch_exit);
+MODULE_LICENSE("GPL");
-- 
1.9.3

