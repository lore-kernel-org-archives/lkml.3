Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753232AbaKQBak (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 20:30:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52622 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751897AbaKQBag (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 20:30:36 -0500
From: Seth Jennings <sjenning@redhat.com>
To: Josh Poimboeuf <jpoimboe@redhat.com>, Seth Jennings <sjenning@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Vojtech Pavlik <vojtech@suse.cz>,
        Steven Rostedt <rostedt@goodmis.org>, Petr Mladek <pmladek@suse.cz>,
        Miroslav Benes <mbenes@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        live-patching@vger.kernel.org, x86@kernel.org, kpatch@redhat.com,
        linux-kernel@vger.kernel.org
Subject: [PATCHv2 2/3] kernel: add support for live patching
Date: Sun, 16 Nov 2014 19:29:23 -0600
Message-Id: <1416187764-3341-3-git-send-email-sjenning@redhat.com>
In-Reply-To: <1416187764-3341-1-git-send-email-sjenning@redhat.com>
References: <1416187764-3341-1-git-send-email-sjenning@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit introduces code for the live patching core.  It implements
an ftrace-based mechanism and kernel interface for doing live patching
of kernel and kernel module functions.

It represents the greatest common functionality set between kpatch and
kgraft and can accept patches built using either method.

This first version does not implement any consistency mechanism that
ensures that old and new code do not run together.  In practice, ~90% of
CVEs are safe to apply in this way, since they simply add a conditional
check.  However, any function change that can not execute safely with
the old version of the function can _not_ be safely applied in this
version.

Signed-off-by: Seth Jennings <sjenning@redhat.com>
---
 MAINTAINERS                      |  12 +
 arch/x86/Kconfig                 |   2 +
 arch/x86/include/asm/livepatch.h |  38 ++
 arch/x86/kernel/Makefile         |   1 +
 arch/x86/kernel/livepatch.c      |  83 ++++
 include/linux/livepatch.h        |  68 +++
 kernel/Makefile                  |   1 +
 kernel/livepatch/Kconfig         |   9 +
 kernel/livepatch/Makefile        |   3 +
 kernel/livepatch/core.c          | 999 +++++++++++++++++++++++++++++++++++++++
 10 files changed, 1216 insertions(+)
 create mode 100644 arch/x86/include/asm/livepatch.h
 create mode 100644 arch/x86/kernel/livepatch.c
 create mode 100644 include/linux/livepatch.h
 create mode 100644 kernel/livepatch/Kconfig
 create mode 100644 kernel/livepatch/Makefile
 create mode 100644 kernel/livepatch/core.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 4861577..c7f49ae 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5715,6 +5715,18 @@ F:	Documentation/misc-devices/lis3lv02d
 F:	drivers/misc/lis3lv02d/
 F:	drivers/platform/x86/hp_accel.c
 
+LIVE PATCHING
+M:	Josh Poimboeuf <jpoimboe@redhat.com>
+M:	Seth Jennings <sjenning@redhat.com>
+M:	Jiri Kosina <jkosina@suse.cz>
+M:	Vojtech Pavlik <vojtech@suse.cz>
+S:	Maintained
+F:	kernel/livepatch/
+F:	include/linux/livepatch.h
+F:	arch/x86/include/asm/livepatch.h
+F:	arch/x86/kernel/livepatch.c
+L:	live-patching@vger.kernel.org
+
 LLC (802.2)
 M:	Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
 S:	Maintained
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index ec21dfd..0cf27e8 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1991,6 +1991,8 @@ config CMDLINE_OVERRIDE
 	  This is used to work around broken boot loaders.  This should
 	  be set to 'N' under normal conditions.
 
+source "kernel/livepatch/Kconfig"
+
 endmenu
 
 config ARCH_ENABLE_MEMORY_HOTPLUG
diff --git a/arch/x86/include/asm/livepatch.h b/arch/x86/include/asm/livepatch.h
new file mode 100644
index 0000000..c5fab45
--- /dev/null
+++ b/arch/x86/include/asm/livepatch.h
@@ -0,0 +1,38 @@
+/*
+ * livepatch.h - x86-specific Live Kernel Patching Core
+ *
+ * Copyright (C) 2014 Seth Jennings <sjenning@redhat.com>
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
+#ifndef _ASM_X86_LIVEPATCH_H
+#define _ASM_X86_LIVEPATCH_H
+
+#include <linux/module.h>
+
+#ifdef CONFIG_LIVE_PATCHING
+extern int lpc_write_module_reloc(struct module *mod, unsigned long type,
+				  unsigned long loc, unsigned long value);
+
+#else
+static int lpc_write_module_reloc(struct module *mod, unsigned long type,
+				  unsigned long loc, unsigned long value);
+{
+	pr_err("Kernel does not support live patching\n");
+	return -ENOSYS;
+}
+#endif
+
+#endif /* _ASM_X86_LIVEPATCH_H */
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 5d4502c..316b34e 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -63,6 +63,7 @@ obj-$(CONFIG_X86_MPPARSE)	+= mpparse.o
 obj-y				+= apic/
 obj-$(CONFIG_X86_REBOOTFIXUPS)	+= reboot_fixups_32.o
 obj-$(CONFIG_DYNAMIC_FTRACE)	+= ftrace.o
+obj-$(CONFIG_LIVE_PATCHING)	+= livepatch.o
 obj-$(CONFIG_FUNCTION_GRAPH_TRACER) += ftrace.o
 obj-$(CONFIG_FTRACE_SYSCALLS)	+= ftrace.o
 obj-$(CONFIG_X86_TSC)		+= trace_clock.o
diff --git a/arch/x86/kernel/livepatch.c b/arch/x86/kernel/livepatch.c
new file mode 100644
index 0000000..56813ae
--- /dev/null
+++ b/arch/x86/kernel/livepatch.c
@@ -0,0 +1,83 @@
+/*
+ * livepatch.c - x86-specific Live Kernel Patching Core
+ *
+ * Copyright (C) 2014 Seth Jennings <sjenning@redhat.com>
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
+#include <linux/module.h>
+#include <linux/uaccess.h>
+#include <asm/cacheflush.h>
+#include <asm/page_types.h>
+
+#ifdef CONFIG_X86_32
+int lpc_write_module_reloc(struct module *mod, unsigned long type,
+			   unsigned long loc, unsigned long value)
+{
+	pr_err("Live patching not supported on 32-bit x86\n");
+	return -ENOSYS;
+}
+#else
+int lpc_write_module_reloc(struct module *mod, unsigned long type,
+			   unsigned long loc, unsigned long value)
+{
+	int ret, readonly, numpages, size = 4;
+	unsigned long val;
+	unsigned long core = (unsigned long)mod->module_core;
+	unsigned long core_ro_size = mod->core_ro_size;
+	unsigned long core_size = mod->core_size;
+
+	switch (type) {
+	case R_X86_64_NONE:
+		return 0;
+	case R_X86_64_64:
+		val = value;
+		size = 8;
+		break;
+	case R_X86_64_32:
+		val = (u32)value;
+		break;
+	case R_X86_64_32S:
+		val = (s32)value;
+		break;
+	case R_X86_64_PC32:
+		val = (u32)(value - loc);
+		break;
+	default:
+		/* unsupported relocation type */
+		return -EINVAL;
+	}
+
+	if (loc >= core && loc < core + core_ro_size)
+		readonly = 1;
+	else if (loc >= core + core_ro_size && loc < core + core_size)
+		readonly = 0;
+	else
+		/* loc not in expected range */
+		return -EINVAL;
+
+	numpages = ((loc & PAGE_MASK) == ((loc + size) & PAGE_MASK)) ? 1 : 2;
+
+	if (readonly)
+		set_memory_rw(loc & PAGE_MASK, numpages);
+
+	ret = probe_kernel_write((void *)loc, &val, size);
+
+	if (readonly)
+		set_memory_ro(loc & PAGE_MASK, numpages);
+
+	return ret;
+}
+#endif
diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
new file mode 100644
index 0000000..8b68fef
--- /dev/null
+++ b/include/linux/livepatch.h
@@ -0,0 +1,68 @@
+/*
+ * livepatch.h - Live Kernel Patching Core
+ *
+ * Copyright (C) 2014 Seth Jennings <sjenning@redhat.com>
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
+#ifndef _LINUX_LIVEPATCH_H_
+#define _LINUX_LIVEPATCH_H_
+
+#include <linux/module.h>
+
+/* TODO: add kernel-doc for structures once agreed upon */
+
+struct lp_func {
+	const char *old_name; /* function to be patched */
+	void *new_func; /* replacement function in patch module */
+	/*
+	 * The old_addr field is optional and can be used to resolve
+	 * duplicate symbol names in the vmlinux object.  If this
+	 * information is not present, the symbol is located by name
+	 * with kallsyms. If the name is not unique and old_addr is
+	 * not provided, the patch application fails as there is no
+	 * way to resolve the ambiguity.
+	 */
+	unsigned long old_addr;
+};
+
+struct lp_reloc {
+	unsigned long dest;
+	unsigned long src;
+	unsigned long type;
+	const char *name;
+	int addend;
+	int external;
+};
+
+struct lp_object {
+	const char *name; /* "vmlinux" or module name */
+	struct lp_func *funcs;
+	struct lp_reloc *relocs;
+};
+
+struct lp_patch {
+	struct module *mod; /* module containing the patch */
+	struct lp_object *objs;
+};
+
+int lp_register_patch(struct lp_patch *);
+int lp_unregister_patch(struct lp_patch *);
+int lp_enable_patch(struct lp_patch *);
+int lp_disable_patch(struct lp_patch *);
+
+#include <asm/livepatch.h>
+
+#endif /* _LINUX_LIVEPATCH_H_ */
diff --git a/kernel/Makefile b/kernel/Makefile
index a59481a..616994f 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -26,6 +26,7 @@ obj-y += power/
 obj-y += printk/
 obj-y += irq/
 obj-y += rcu/
+obj-y += livepatch/
 
 obj-$(CONFIG_CHECKPOINT_RESTORE) += kcmp.o
 obj-$(CONFIG_FREEZER) += freezer.o
diff --git a/kernel/livepatch/Kconfig b/kernel/livepatch/Kconfig
new file mode 100644
index 0000000..206bb63
--- /dev/null
+++ b/kernel/livepatch/Kconfig
@@ -0,0 +1,9 @@
+config LIVE_PATCHING
+	boolean "Live Kernel Patching"
+	depends on DYNAMIC_FTRACE_WITH_REGS && MODULES && SYSFS && KALLSYMS_ALL
+	help
+	  Say Y here if you want to support live kernel patching.
+	  This option has no runtime impact until a kernel "patch"
+	  module uses the interface provided by this option to register
+	  a patch, causing calls to patched functions to be redirected
+	  to new function code contained in the patch module.
diff --git a/kernel/livepatch/Makefile b/kernel/livepatch/Makefile
new file mode 100644
index 0000000..7c1f008
--- /dev/null
+++ b/kernel/livepatch/Makefile
@@ -0,0 +1,3 @@
+obj-$(CONFIG_LIVE_PATCHING) += livepatch.o
+
+livepatch-objs := core.o
diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
new file mode 100644
index 0000000..e67c176
--- /dev/null
+++ b/kernel/livepatch/core.c
@@ -0,0 +1,999 @@
+/*
+ * core.c - Live Kernel Patching Core
+ *
+ * Copyright (C) 2014 Seth Jennings <sjenning@redhat.com>
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
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/mutex.h>
+#include <linux/slab.h>
+#include <linux/ftrace.h>
+#include <linux/list.h>
+#include <linux/kallsyms.h>
+#include <linux/livepatch.h>
+
+/*************************************
+ * Core structures
+ ************************************/
+
+/*
+ * lp_ structs vs lpc_ structs
+ *
+ * For each element (patch, object, func) in the live-patching code,
+ * there are two types with two different prefixes: lp_ and lpc_.
+ *
+ * Structures used by the live-patch modules to register with this core module
+ * are prefixed with lp_ (live patching).  These structures are part of the
+ * registration API and are defined in livepatch.h.  The structures used
+ * internally by this core module are prefixed with lpc_ (live patching core).
+ */
+
+static DEFINE_MUTEX(lpc_mutex);
+static LIST_HEAD(lpc_patches);
+
+enum lpc_state {
+	LPC_DISABLED,
+	LPC_ENABLED
+};
+
+struct lpc_func {
+	struct list_head list;
+	struct kobject kobj;
+	struct ftrace_ops fops;
+	enum lpc_state state;
+
+	const char *old_name;
+	unsigned long new_addr;
+	unsigned long old_addr;
+};
+
+struct lpc_object {
+	struct list_head list;
+	struct kobject kobj;
+	struct module *mod; /* module associated with object */
+	enum lpc_state state;
+
+	const char *name;
+	struct list_head funcs;
+	struct lp_reloc *relocs;
+};
+
+struct lpc_patch {
+	struct list_head list;
+	struct kobject kobj;
+	struct lp_patch *userpatch; /* for correlation during unregister */
+	enum lpc_state state;
+
+	struct module *mod;
+	struct list_head objs;
+};
+
+/*******************************************
+ * Helpers
+ *******************************************/
+
+/* sets obj->mod if object is not vmlinux and module is found */
+static bool lpc_find_object_module(struct lpc_object *obj)
+{
+	if (!strcmp(obj->name, "vmlinux"))
+		return 1;
+
+	mutex_lock(&module_mutex);
+	/*
+	 * We don't need to take a reference on the module here because we have
+	 * the lpc_mutex, which is also taken by the module notifier.  This
+	 * prevents any module from unloading until we release the lpc_mutex.
+	 */
+	obj->mod = find_module(obj->name);
+	mutex_unlock(&module_mutex);
+
+	return !!obj->mod;
+}
+
+/************************************
+ * kallsyms
+ ***********************************/
+
+struct lpc_find_arg {
+	const char *objname;
+	const char *name;
+	unsigned long addr;
+	/*
+	 * If count == 0, the symbol was not found. If count == 1, a unique
+	 * match was found and addr is set.  If count > 1, there is
+	 * unresolvable ambiguity among "count" number of symbols with the same
+	 * name in the same object.
+	 */
+	unsigned long count;
+};
+
+static int lpc_find_callback(void *data, const char *name,
+			     struct module *mod, unsigned long addr)
+{
+	struct lpc_find_arg *args = data;
+
+	if ((mod && !args->objname) || (!mod && args->objname))
+		return 0;
+
+	if (strcmp(args->name, name))
+		return 0;
+
+	if (args->objname && strcmp(args->objname, mod->name))
+		return 0;
+
+	/*
+	 * args->addr might be overwritten if another match is found
+	 * but lpc_find_symbol() handles this and only returns the
+	 * addr if count == 1.
+	 */
+	args->addr = addr;
+	args->count++;
+
+	return 0;
+}
+
+static int lpc_find_symbol(const char *objname, const char *name,
+			   unsigned long *addr)
+{
+	struct lpc_find_arg args = {
+		.objname = objname,
+		.name = name,
+		.addr = 0,
+		.count = 0
+	};
+
+	if (objname && !strcmp(objname, "vmlinux"))
+		args.objname = NULL;
+
+	kallsyms_on_each_symbol(lpc_find_callback, &args);
+
+	if (args.count == 0)
+		pr_err("symbol '%s' not found in symbol table\n", name);
+	else if (args.count > 1)
+		pr_err("unresolvable ambiguity (%lu matches) on symbol '%s' in object '%s'\n",
+		       args.count, name, objname);
+	else {
+		*addr = args.addr;
+		return 0;
+	}
+
+	*addr = 0;
+	return -EINVAL;
+}
+
+struct lpc_verify_args {
+	const char *name;
+	const unsigned long addr;
+};
+
+static int lpc_verify_callback(void *data, const char *name,
+			       struct module *mod, unsigned long addr)
+{
+	struct lpc_verify_args *args = data;
+
+	if (!mod &&
+	    !strcmp(args->name, name) &&
+	    args->addr == addr)
+		return 1;
+	return 0;
+}
+
+static int lpc_verify_vmlinux_symbol(const char *name, unsigned long addr)
+{
+	struct lpc_verify_args args = {
+		.name = name,
+		.addr = addr,
+	};
+
+	if (kallsyms_on_each_symbol(lpc_verify_callback, &args))
+		return 0;
+	pr_err("symbol '%s' not found at specified address 0x%016lx, kernel mismatch?",
+		name, addr);
+	return -EINVAL;
+}
+
+static int lpc_find_verify_func_addr(struct lpc_func *func, const char *objname)
+{
+	int ret;
+
+#if defined(CONFIG_RANDOMIZE_BASE)
+	/* KASLR is enabled, disregard old_addr from user */
+	func->old_addr = 0;
+#endif
+
+	if (func->old_addr && strcmp(objname, "vmlinux")) {
+		pr_err("old address specified for module symbol\n");
+		return -EINVAL;
+	}
+
+	if (func->old_addr)
+		ret = lpc_verify_vmlinux_symbol(func->old_name,
+						func->old_addr);
+	else
+		ret = lpc_find_symbol(objname, func->old_name,
+				      &func->old_addr);
+
+	return ret;
+}
+
+/****************************************
+ * dynamic relocations (load-time linker)
+ ****************************************/
+
+/*
+ * external symbols are located outside the parent object (where the parent
+ * object is either vmlinux or the kmod being patched).
+ */
+static int lpc_find_external_symbol(struct module *pmod, const char *name,
+				    unsigned long *addr)
+{
+	const struct kernel_symbol *sym;
+
+	/* first, check if it's an exported symbol */
+	preempt_disable();
+	sym = find_symbol(name, NULL, NULL, true, true);
+	preempt_enable();
+	if (sym) {
+		*addr = sym->value;
+		return 0;
+	}
+
+	/* otherwise check if it's in another .o within the patch module */
+	return lpc_find_symbol(pmod->name, name, addr);
+}
+
+static int lpc_write_object_relocations(struct module *pmod,
+					struct lpc_object *obj)
+{
+	int ret;
+	struct lp_reloc *reloc;
+
+	for (reloc = obj->relocs; reloc->name; reloc++) {
+		if (!strcmp(obj->name, "vmlinux")) {
+			ret = lpc_verify_vmlinux_symbol(reloc->name,
+							reloc->src);
+			if (ret)
+				return ret;
+		} else {
+			/* module, reloc->src needs to be discovered */
+			if (reloc->external)
+				ret = lpc_find_external_symbol(pmod,
+							       reloc->name,
+							       &reloc->src);
+			else
+				ret = lpc_find_symbol(obj->mod->name,
+						      reloc->name,
+						      &reloc->src);
+			if (ret)
+				return ret;
+		}
+		ret = lpc_write_module_reloc(pmod, reloc->type, reloc->dest,
+					     reloc->src + reloc->addend);
+		if (ret) {
+			pr_err("relocation failed for symbol '%s' at 0x%016lx (%d)\n",
+			       reloc->name, reloc->src, ret);
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
+/***********************************
+ * ftrace registration
+ **********************************/
+
+static void lpc_ftrace_handler(unsigned long ip, unsigned long parent_ip,
+			       struct ftrace_ops *ops, struct pt_regs *regs)
+{
+	struct lpc_func *func = ops->private;
+
+	regs->ip = func->new_addr;
+}
+
+static int lpc_enable_func(struct lpc_func *func)
+{
+	int ret;
+
+	if (WARN_ON(!func->old_addr || func->state != LPC_DISABLED))
+		return -EINVAL;
+
+	ret = ftrace_set_filter_ip(&func->fops, func->old_addr, 0, 0);
+	if (ret) {
+		pr_err("failed to set ftrace filter for function '%s' (%d)\n",
+		       func->old_name, ret);
+		return ret;
+	}
+	ret = register_ftrace_function(&func->fops);
+	if (ret) {
+		pr_err("failed to register ftrace handler for function '%s' (%d)\n",
+		       func->old_name, ret);
+		ftrace_set_filter_ip(&func->fops, func->old_addr, 1, 0);
+	} else
+		func->state = LPC_ENABLED;
+
+	return ret;
+}
+
+static int lpc_disable_func(struct lpc_func *func)
+{
+	int ret;
+
+	if (WARN_ON(func->state != LPC_ENABLED))
+		return -EINVAL;
+
+	if (!func->old_addr)
+		/* parent object is not loaded */
+		return 0;
+	ret = unregister_ftrace_function(&func->fops);
+	if (ret) {
+		pr_err("failed to unregister ftrace handler for function '%s' (%d)\n",
+		       func->old_name, ret);
+		return ret;
+	}
+	ret = ftrace_set_filter_ip(&func->fops, func->old_addr, 1, 0);
+	if (ret)
+		pr_warn("function unregister succeeded but failed to clear the filter\n");
+	func->state = LPC_DISABLED;
+
+	return 0;
+}
+
+static int lpc_disable_object(struct lpc_object *obj)
+{
+	struct lpc_func *func;
+	int ret;
+
+	list_for_each_entry(func, &obj->funcs, list) {
+		if (func->state != LPC_ENABLED)
+			continue;
+		ret = lpc_disable_func(func);
+		if (ret)
+			return ret;
+		if (strcmp(obj->name, "vmlinux"))
+			func->old_addr = 0;
+	}
+	obj->state = LPC_DISABLED;
+
+	return 0;
+}
+
+static int lpc_enable_object(struct module *pmod, struct lpc_object *obj)
+{
+	struct lpc_func *func;
+	int ret;
+
+	if (WARN_ON(!obj->mod && strcmp(obj->name, "vmlinux")))
+		return -EINVAL;
+
+	if (obj->relocs) {
+		ret = lpc_write_object_relocations(pmod, obj);
+		if (ret)
+			goto unregister;
+	}
+	list_for_each_entry(func, &obj->funcs, list) {
+		ret = lpc_find_verify_func_addr(func, obj->name);
+		if (ret)
+			goto unregister;
+
+		ret = lpc_enable_func(func);
+		if (ret)
+			goto unregister;
+	}
+	obj->state = LPC_ENABLED;
+
+	return 0;
+unregister:
+	WARN_ON(lpc_disable_object(obj));
+	return ret;
+}
+
+/******************************
+ * enable/disable
+ ******************************/
+
+static struct lpc_patch *lpc_find_patch(struct lp_patch *userpatch)
+{
+	struct lpc_patch *patch;
+
+	list_for_each_entry(patch, &lpc_patches, list)
+		if (patch->userpatch == userpatch)
+			return patch;
+
+	return NULL;
+}
+
+static int lpc_disable_patch(struct lpc_patch *patch)
+{
+	struct lpc_object *obj;
+	int ret;
+
+	pr_notice("disabling patch '%s'\n", patch->mod->name);
+
+	list_for_each_entry(obj, &patch->objs, list) {
+		if (obj->state != LPC_ENABLED)
+			continue;
+		ret = lpc_disable_object(obj);
+		if (ret)
+			return ret;
+	}
+	patch->state = LPC_DISABLED;
+
+	return 0;
+}
+
+/**
+ * lp_disable_patch() - disables a registered patch
+ * @userpatch:	The registered, enabled patch to be disabled
+ *
+ * Unregisters the patched functions from ftrace.
+ *
+ * Return: 0 on success, otherwise error
+ */
+int lp_disable_patch(struct lp_patch *userpatch)
+{
+	struct lpc_patch *patch;
+	int ret;
+
+	mutex_lock(&lpc_mutex);
+	patch = lpc_find_patch(userpatch);
+	if (!patch) {
+		ret = -ENODEV;
+		goto out;
+	}
+	ret = lpc_disable_patch(patch);
+out:
+	mutex_unlock(&lpc_mutex);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(lp_disable_patch);
+
+static int lpc_enable_patch(struct lpc_patch *patch)
+{
+	struct lpc_object *obj;
+	int ret;
+
+	if (WARN_ON(patch->state != LPC_DISABLED))
+		return -EINVAL;
+
+	pr_notice_once("tainting kernel with TAINT_LIVEPATCH\n");
+	add_taint(TAINT_LIVEPATCH, LOCKDEP_STILL_OK);
+
+	pr_notice("enabling patch '%s'\n", patch->mod->name);
+
+	list_for_each_entry(obj, &patch->objs, list) {
+		if (!lpc_find_object_module(obj))
+			continue;
+		ret = lpc_enable_object(patch->mod, obj);
+		if (ret)
+			goto unregister;
+	}
+	patch->state = LPC_ENABLED;
+	return 0;
+
+unregister:
+	WARN_ON(lpc_disable_patch(patch));
+	return ret;
+}
+
+/**
+ * lp_enable_patch() - enables a registered patch
+ * @userpatch:	The registered, disabled patch to be enabled
+ *
+ * Performs the needed symbol lookups and code relocations,
+ * then registers the patched functions with ftrace.
+ *
+ * Return: 0 on success, otherwise error
+ */
+int lp_enable_patch(struct lp_patch *userpatch)
+{
+	struct lpc_patch *patch;
+	int ret;
+
+	mutex_lock(&lpc_mutex);
+	patch = lpc_find_patch(userpatch);
+	if (!patch) {
+		ret = -ENODEV;
+		goto out;
+	}
+	ret = lpc_enable_patch(patch);
+out:
+	mutex_unlock(&lpc_mutex);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(lp_enable_patch);
+
+/******************************
+ * module notifier
+ *****************************/
+
+static void lpc_module_notify_coming(struct module *pmod,
+				     struct lpc_object *obj)
+{
+	struct module *mod = obj->mod;
+	int ret;
+
+	pr_notice("applying patch '%s' to loading module '%s'\n",
+		  mod->name, pmod->name);
+	obj->mod = mod;
+	ret = lpc_enable_object(pmod, obj);
+	if (ret)
+		pr_warn("failed to apply patch '%s' to module '%s' (%d)\n",
+			pmod->name, mod->name, ret);
+}
+
+static void lpc_module_notify_going(struct module *pmod,
+				    struct lpc_object *obj)
+{
+	struct module *mod = obj->mod;
+	int ret;
+
+	pr_notice("reverting patch '%s' on unloading module '%s'\n",
+		  pmod->name, mod->name);
+	ret = lpc_disable_object(obj);
+	if (ret)
+		pr_warn("failed to revert patch '%s' on module '%s' (%d)\n",
+			pmod->name, mod->name, ret);
+	obj->mod = NULL;
+}
+
+static int lpc_module_notify(struct notifier_block *nb, unsigned long action,
+			    void *data)
+{
+	struct module *mod = data;
+	struct lpc_patch *patch;
+	struct lpc_object *obj;
+
+	mutex_lock(&lpc_mutex);
+
+	if (action != MODULE_STATE_COMING && action != MODULE_STATE_GOING)
+		goto out;
+
+	list_for_each_entry(patch, &lpc_patches, list) {
+		if (patch->state == LPC_DISABLED)
+			continue;
+		list_for_each_entry(obj, &patch->objs, list) {
+			if (strcmp(obj->name, mod->name))
+				continue;
+			if (action == MODULE_STATE_COMING) {
+				obj->mod = mod;
+				lpc_module_notify_coming(patch->mod, obj);
+			} else /* MODULE_STATE_GOING */
+				lpc_module_notify_going(patch->mod, obj);
+			break;
+		}
+	}
+out:
+	mutex_unlock(&lpc_mutex);
+	return 0;
+}
+
+static struct notifier_block lpc_module_nb = {
+	.notifier_call = lpc_module_notify,
+	.priority = INT_MIN+1, /* called late but before ftrace notifier */
+};
+
+/********************************************
+ * Sysfs Interface
+ *******************************************/
+/*
+ * /sys/kernel/livepatch
+ * /sys/kernel/livepatch/<patch>
+ * /sys/kernel/livepatch/<patch>/enabled
+ * /sys/kernel/livepatch/<patch>/<object>
+ * /sys/kernel/livepatch/<patch>/<object>/<func>
+ */
+
+static ssize_t enabled_store(struct kobject *kobj, struct kobj_attribute *attr,
+			     const char *buf, size_t count)
+{
+	struct lpc_patch *patch;
+	int ret;
+	unsigned long val;
+
+	ret = kstrtoul(buf, 10, &val);
+	if (ret)
+		return -EINVAL;
+
+	if (val != LPC_DISABLED && val != LPC_ENABLED)
+		return -EINVAL;
+
+	patch = container_of(kobj, struct lpc_patch, kobj);
+
+	mutex_lock(&lpc_mutex);
+	if (val == patch->state) {
+		/* already in requested state */
+		ret = -EINVAL;
+		goto err;
+	}
+
+	if (val == LPC_ENABLED) {
+		ret = lpc_enable_patch(patch);
+		if (ret)
+			goto err;
+	} else {
+		ret = lpc_disable_patch(patch);
+		if (ret)
+			goto err;
+	}
+	mutex_unlock(&lpc_mutex);
+	return count;
+err:
+	mutex_unlock(&lpc_mutex);
+	return ret;
+}
+
+static ssize_t enabled_show(struct kobject *kobj,
+			    struct kobj_attribute *attr, char *buf)
+{
+	struct lpc_patch *patch;
+
+	patch = container_of(kobj, struct lpc_patch, kobj);
+	return snprintf(buf, PAGE_SIZE-1, "%d\n", patch->state);
+}
+
+static struct kobj_attribute enabled_kobj_attr = __ATTR_RW(enabled);
+static struct attribute *lpc_patch_attrs[] = {
+	&enabled_kobj_attr.attr,
+	NULL
+};
+
+static struct kobject *lpc_root_kobj;
+
+static int lpc_create_root_kobj(void)
+{
+	lpc_root_kobj =
+		kobject_create_and_add("livepatch", kernel_kobj);
+	if (!lpc_root_kobj)
+		return -ENOMEM;
+	return 0;
+}
+
+static void lpc_remove_root_kobj(void)
+{
+	kobject_put(lpc_root_kobj);
+}
+
+static void lpc_kobj_release_patch(struct kobject *kobj)
+{
+	struct lpc_patch *patch;
+
+	patch = container_of(kobj, struct lpc_patch, kobj);
+	if (!list_empty(&patch->list))
+		list_del(&patch->list);
+	kfree(patch);
+}
+
+static struct kobj_type lpc_ktype_patch = {
+	.release = lpc_kobj_release_patch,
+	.sysfs_ops = &kobj_sysfs_ops,
+	.default_attrs = lpc_patch_attrs
+};
+
+static void lpc_kobj_release_object(struct kobject *kobj)
+{
+	struct lpc_object *obj;
+
+	obj = container_of(kobj, struct lpc_object, kobj);
+	if (!list_empty(&obj->list))
+		list_del(&obj->list);
+	kfree(obj);
+}
+
+static struct kobj_type lpc_ktype_object = {
+	.release	= lpc_kobj_release_object,
+	.sysfs_ops	= &kobj_sysfs_ops,
+};
+
+static void lpc_kobj_release_func(struct kobject *kobj)
+{
+	struct lpc_func *func;
+
+	func = container_of(kobj, struct lpc_func, kobj);
+	if (!list_empty(&func->list))
+		list_del(&func->list);
+	kfree(func);
+}
+
+static struct kobj_type lpc_ktype_func = {
+	.release	= lpc_kobj_release_func,
+	.sysfs_ops	= &kobj_sysfs_ops,
+};
+
+/*********************************
+ * structure allocation
+ ********************************/
+
+static void lpc_free_funcs(struct lpc_object *obj)
+{
+	struct lpc_func *func, *funcsafe;
+
+	list_for_each_entry_safe(func, funcsafe, &obj->funcs, list)
+		kobject_put(&func->kobj);
+}
+
+static void lpc_free_objects(struct lpc_patch *patch)
+{
+	struct lpc_object *obj, *objsafe;
+
+	list_for_each_entry_safe(obj, objsafe, &patch->objs, list) {
+		lpc_free_funcs(obj);
+		kobject_put(&obj->kobj);
+	}
+}
+
+static void lpc_free_patch(struct lpc_patch *patch)
+{
+	lpc_free_objects(patch);
+	kobject_put(&patch->kobj);
+}
+
+static struct lpc_func *lpc_create_func(struct kobject *root,
+					struct lp_func *userfunc)
+{
+	struct lpc_func *func;
+	struct ftrace_ops *ops;
+	int ret;
+
+	/* alloc */
+	func = kzalloc(sizeof(*func), GFP_KERNEL);
+	if (!func)
+		return NULL;
+
+	/* init */
+	INIT_LIST_HEAD(&func->list);
+	func->old_name = userfunc->old_name;
+	func->new_addr = (unsigned long)userfunc->new_func;
+	func->old_addr = userfunc->old_addr;
+	func->state = LPC_DISABLED;
+	ops = &func->fops;
+	ops->private = func;
+	ops->func = lpc_ftrace_handler;
+	ops->flags = FTRACE_OPS_FL_SAVE_REGS | FTRACE_OPS_FL_DYNAMIC;
+
+	/* sysfs */
+	ret = kobject_init_and_add(&func->kobj, &lpc_ktype_func,
+				   root, func->old_name);
+	if (ret) {
+		kfree(func);
+		return NULL;
+	}
+
+	return func;
+}
+
+static int lpc_create_funcs(struct lpc_object *obj,
+			    struct lp_func *userfuncs)
+{
+	struct lp_func *userfunc;
+	struct lpc_func *func;
+
+	if (!userfuncs)
+		return -EINVAL;
+
+	for (userfunc = userfuncs; userfunc->old_name; userfunc++) {
+		func = lpc_create_func(&obj->kobj, userfunc);
+		if (!func)
+			goto free;
+		list_add(&func->list, &obj->funcs);
+	}
+	return 0;
+free:
+	lpc_free_funcs(obj);
+	return -ENOMEM;
+}
+
+static struct lpc_object *lpc_create_object(struct kobject *root,
+					    struct lp_object *userobj)
+{
+	struct lpc_object *obj;
+	int ret;
+
+	/* alloc */
+	obj = kzalloc(sizeof(*obj), GFP_KERNEL);
+	if (!obj)
+		return NULL;
+
+	/* init */
+	INIT_LIST_HEAD(&obj->list);
+	obj->name = userobj->name;
+	obj->relocs = userobj->relocs;
+	obj->state = LPC_DISABLED;
+	/* obj->mod set by lpc_object_module_get() */
+	INIT_LIST_HEAD(&obj->funcs);
+
+	/* sysfs */
+	ret = kobject_init_and_add(&obj->kobj, &lpc_ktype_object,
+				   root, obj->name);
+	if (ret) {
+		kfree(obj);
+		return NULL;
+	}
+
+	/* create functions */
+	ret = lpc_create_funcs(obj, userobj->funcs);
+	if (ret) {
+		kobject_put(&obj->kobj);
+		return NULL;
+	}
+
+	return obj;
+}
+
+static int lpc_create_objects(struct lpc_patch *patch,
+			      struct lp_object *userobjs)
+{
+	struct lp_object *userobj;
+	struct lpc_object *obj;
+
+	if (!userobjs)
+		return -EINVAL;
+
+	for (userobj = userobjs; userobj->name; userobj++) {
+		obj = lpc_create_object(&patch->kobj, userobj);
+		if (!obj)
+			goto free;
+		list_add(&obj->list, &patch->objs);
+	}
+	return 0;
+free:
+	lpc_free_objects(patch);
+	return -ENOMEM;
+}
+
+static int lpc_create_patch(struct lp_patch *userpatch)
+{
+	struct lpc_patch *patch;
+	int ret;
+
+	/* alloc */
+	patch = kzalloc(sizeof(*patch), GFP_KERNEL);
+	if (!patch)
+		return -ENOMEM;
+
+	/* init */
+	INIT_LIST_HEAD(&patch->list);
+	patch->userpatch = userpatch;
+	patch->mod = userpatch->mod;
+	patch->state = LPC_DISABLED;
+	INIT_LIST_HEAD(&patch->objs);
+
+	/* sysfs */
+	ret = kobject_init_and_add(&patch->kobj, &lpc_ktype_patch,
+				   lpc_root_kobj, patch->mod->name);
+	if (ret) {
+		kfree(patch);
+		return ret;
+	}
+
+	/* create objects */
+	ret = lpc_create_objects(patch, userpatch->objs);
+	if (ret) {
+		kobject_put(&patch->kobj);
+		return ret;
+	}
+
+	/* add to global list of patches */
+	mutex_lock(&lpc_mutex);
+	list_add(&patch->list, &lpc_patches);
+	mutex_unlock(&lpc_mutex);
+
+	return 0;
+}
+
+/************************************
+ * register/unregister
+ ***********************************/
+
+/**
+ * lp_register_patch() - registers a patch
+ * @userpatch:	Patch to be registered
+ *
+ * Allocates the data structure associated with the patch and
+ * creates the sysfs interface.
+ *
+ * Return: 0 on success, otherwise error
+ */
+int lp_register_patch(struct lp_patch *userpatch)
+{
+	int ret;
+
+	if (!userpatch || !userpatch->mod || !userpatch->objs)
+		return -EINVAL;
+
+	/*
+	 * A reference is taken on the patch module to prevent it from being
+	 * unloaded.  Right now, we don't allow patch modules to unload since
+	 * there is currently no method to determine if a thread is still
+	 * running in the patched code contained in the patch module once
+	 * the ftrace registration is successful.
+	 */
+	if (!try_module_get(userpatch->mod))
+		return -ENODEV;
+
+	ret = lpc_create_patch(userpatch);
+	if (ret)
+		module_put(userpatch->mod);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(lp_register_patch);
+
+/**
+ * lp_unregister_patch() - unregisters a patch
+ * @userpatch:	Disabled patch to be unregistered
+ *
+ * Frees the data structures and removes the sysfs interface.
+ *
+ * Return: 0 on success, otherwise error
+ */
+int lp_unregister_patch(struct lp_patch *userpatch)
+{
+	struct lpc_patch *patch;
+	int ret = 0;
+
+	mutex_lock(&lpc_mutex);
+	patch = lpc_find_patch(userpatch);
+	if (!patch) {
+		ret = -ENODEV;
+		goto out;
+	}
+	if (patch->state == LPC_ENABLED) {
+		ret = -EINVAL;
+		goto out;
+	}
+	lpc_free_patch(patch);
+out:
+	mutex_unlock(&lpc_mutex);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(lp_unregister_patch);
+
+/************************************
+ * entry/exit
+ ************************************/
+
+static int lpc_init(void)
+{
+	int ret;
+
+	ret = register_module_notifier(&lpc_module_nb);
+	if (ret)
+		return ret;
+
+	ret = lpc_create_root_kobj();
+	if (ret)
+		goto unregister;
+
+	return 0;
+unregister:
+	unregister_module_notifier(&lpc_module_nb);
+	return ret;
+}
+
+static void lpc_exit(void)
+{
+	lpc_remove_root_kobj();
+	unregister_module_notifier(&lpc_module_nb);
+}
+
+module_init(lpc_init);
+module_exit(lpc_exit);
+MODULE_DESCRIPTION("Live Kernel Patching Core");
+MODULE_LICENSE("GPL");
-- 
1.9.3

