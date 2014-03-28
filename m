Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752108AbaC2PY1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 11:24:27 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:44125 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663AbaC2PYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 11:24:20 -0400
From: Jovi Zhangwei <jovi.zhangwei@gmail.com>
To: Ingo Molnar <mingo@redhat.com>, Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andi Kleen <andi@firstfloor.org>,
        Jovi Zhangwei <jovi.zhangwei@gmail.com>
Subject: [PATCH v2 07/29] ktap: add kernel module main entry(kernel/trace/ktap/ktap.[c|h])
Date: Fri, 28 Mar 2014 10:45:02 -0400
Message-Id: <1396017924-7754-8-git-send-email-jovi.zhangwei@gmail.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1396017924-7754-1-git-send-email-jovi.zhangwei@gmail.com>
References: <1396017924-7754-1-git-send-email-jovi.zhangwei@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ktap.c is ktapvm kernel module main entry,
it init ktap kernel module, create 'ktap' debugfs directory.

Userspace tool send ioctl command to '/sys/kernel/debug/ktap/ktapvm' file,
to control ktap runtime.

It will read bytecode trunk, validate and execute bytecode.

kp_vm_new_state
    kp_bcread
        kp_vm_validate_code
            kp_vm_call_proto

Signed-off-by: Jovi Zhangwei <jovi.zhangwei@gmail.com>
---
 kernel/trace/ktap/ktap.c | 255 +++++++++++++++++++++++++++++++++++++++++++++++
 kernel/trace/ktap/ktap.h | 176 ++++++++++++++++++++++++++++++++
 2 files changed, 431 insertions(+)
 create mode 100644 kernel/trace/ktap/ktap.c
 create mode 100644 kernel/trace/ktap/ktap.h

diff --git a/kernel/trace/ktap/ktap.c b/kernel/trace/ktap/ktap.c
new file mode 100644
index 0000000..855af09
--- /dev/null
+++ b/kernel/trace/ktap/ktap.c
@@ -0,0 +1,255 @@
+/*
+ * ktap.c - ktapvm kernel module main entry
+ *
+ * This file is part of ktap by Jovi Zhangwei.
+ *
+ * Copyright (C) 2012-2014 Jovi Zhangwei <jovi.zhangwei@gmail.com>.
+ *
+ * ktap is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * ktap is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ */
+
+/*
+ * this file is the first file to be compile, add CONFIG_ checking in here.
+ * See Requirements in doc/tutorial.md
+ */
+
+#include <linux/version.h>
+#include <linux/module.h>
+#include <linux/errno.h>
+#include <linux/file.h>
+#include <linux/slab.h>
+#include <linux/fcntl.h>
+#include <linux/sched.h>
+#include <linux/poll.h>
+#include <linux/anon_inodes.h>
+#include <linux/debugfs.h>
+#include <linux/vmalloc.h>
+#include <uapi/ktap/ktap_types.h>
+#include "ktap.h"
+#include "kp_bcread.h"
+#include "kp_vm.h"
+
+/* 
+ * gettimeofday_ns: common helper function
+ * TODO: make getnstimeofday safe called in probe context, there have
+ * seq lock in getnstimeofday.
+ * (Systemtap fix this by introduce its own timekeeping code)
+ */
+long gettimeofday_ns(void)
+{
+	struct timespec now;
+
+	getnstimeofday(&now);
+	return now.tv_sec * NSEC_PER_SEC + now.tv_nsec;
+}
+
+static int load_trunk(ktap_option_t *parm, unsigned long **buff)
+{
+	unsigned long *vmstart;
+
+	if (parm->trunk_len > 4096)
+		return -EINVAL;
+
+	vmstart = vmalloc(parm->trunk_len);
+	if (!vmstart)
+		return -ENOMEM;
+
+	if (copy_from_user(vmstart, (void __user *)parm->trunk,
+			   parm->trunk_len)) {
+		vfree(vmstart);
+		return -EFAULT;
+	}
+
+	*buff = vmstart;
+	return 0;
+}
+
+static struct dentry *kp_dir_dentry;
+
+/* Ktap Main Entry */
+static int ktap_main(struct file *file, ktap_option_t *parm)
+{
+	unsigned long *buff = NULL;
+	ktap_state_t *ks;
+	ktap_proto_t *pt;
+	long start_time, delta_time;
+	int ret;
+
+	start_time = gettimeofday_ns();
+
+	ks = kp_vm_new_state(parm, kp_dir_dentry);
+	if (unlikely(!ks))
+		return -ENOEXEC;
+
+	file->private_data = ks;
+
+	ret = load_trunk(parm, &buff);
+	if (ret) {
+		kp_error(ks, "cannot load file\n");
+		goto out;
+	}
+
+	pt = kp_bcread(ks, (unsigned char *)buff, parm->trunk_len);
+
+	vfree(buff);
+
+	if (pt) {
+		/* validate byte code */
+		if (kp_vm_validate_code(ks, pt, ks->stack))
+			goto out;
+
+		delta_time = (gettimeofday_ns() - start_time) / NSEC_PER_USEC;
+		kp_verbose_printf(ks, "booting time: %d (us)\n", delta_time);
+
+		/* enter vm */
+		kp_vm_call_proto(ks, pt);
+	}
+
+ out:
+	kp_vm_exit(ks);
+	return ret;
+}
+
+static long ktap_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	ktap_option_t parm;
+
+	switch (cmd) {
+	case KTAP_CMD_IOC_RUN:
+		/* must be root to run ktap script (at least for now) */
+		if (!capable(CAP_SYS_ADMIN))
+			return -EACCES;
+
+		if (copy_from_user(&parm, (void __user *)arg,
+				   sizeof(ktap_option_t)))
+			return -EFAULT;
+
+		return ktap_main(file, &parm);
+	default:
+		return -EINVAL;
+	};
+
+        return 0;
+}
+
+static const struct file_operations ktap_fops = {
+	.llseek                 = no_llseek,
+	.unlocked_ioctl         = ktap_ioctl,
+};
+
+static long ktapvm_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	int new_fd, err;
+	struct file *new_file;
+
+	new_fd = get_unused_fd();
+	if (new_fd < 0)
+		return new_fd;
+
+	new_file = anon_inode_getfile("[ktap]", &ktap_fops, NULL, O_RDWR);
+	if (IS_ERR(new_file)) {
+		err = PTR_ERR(new_file);
+		put_unused_fd(new_fd);
+		return err;
+	}
+
+	file->private_data = NULL;
+	fd_install(new_fd, new_file);
+	return new_fd;
+}
+
+static const struct file_operations ktapvm_fops = {
+	.owner  = THIS_MODULE,
+	.unlocked_ioctl         = ktapvm_ioctl,
+};
+
+int (*kp_ftrace_profile_set_filter)(struct perf_event *event, int event_id,
+				    const char *filter_str);
+
+struct syscall_metadata **syscalls_metadata;
+
+/*TODO: kill this function in future */
+static int __init init_dummy_kernel_functions(void)
+{
+	unsigned long *addr;
+
+	/*
+	 * ktap need symbol ftrace_profile_set_filter to set event filter, 
+	 * export it in future. 
+	 */
+#ifdef CONFIG_PPC64
+	kp_ftrace_profile_set_filter =
+		(void *)kallsyms_lookup_name(".ftrace_profile_set_filter");
+#else
+	kp_ftrace_profile_set_filter =
+		(void *)kallsyms_lookup_name("ftrace_profile_set_filter");
+#endif
+	if (!kp_ftrace_profile_set_filter) {
+		pr_err("ktap: cannot lookup ftrace_profile_set_filter "
+			"in kallsyms\n");
+		return -1;
+	}
+
+	/* use syscalls_metadata for syscall event handling */
+	addr = (void *)kallsyms_lookup_name("syscalls_metadata");
+	if (!addr) {
+		pr_err("ktap: cannot lookup syscalls_metadata in kallsyms\n");
+		return -1;
+	}
+
+	syscalls_metadata = (struct syscall_metadata **)*addr;
+	return 0;
+}
+
+static int __init init_ktap(void)
+{
+	struct dentry *ktapvm_dentry;
+
+	if (init_dummy_kernel_functions())
+		return -1;
+
+	kp_dir_dentry = debugfs_create_dir("ktap", NULL);
+	if (!kp_dir_dentry) {
+		pr_err("ktap: debugfs_create_dir failed\n");
+		return -1;
+	}
+
+	ktapvm_dentry = debugfs_create_file("ktapvm", 0444, kp_dir_dentry, NULL,
+					    &ktapvm_fops);
+
+	if (!ktapvm_dentry) {
+		pr_err("ktapvm: cannot create ktapvm file\n");
+		debugfs_remove_recursive(kp_dir_dentry);
+		return -1;
+	}
+
+	return 0;
+}
+
+static void __exit exit_ktap(void)
+{
+	debugfs_remove_recursive(kp_dir_dentry);
+}
+
+module_init(init_ktap);
+module_exit(exit_ktap);
+
+MODULE_AUTHOR("Jovi Zhangwei <jovi.zhangwei@gmail.com>");
+MODULE_DESCRIPTION("ktap");
+MODULE_LICENSE("GPL");
+
+int kp_max_loop_count = 100000;
+module_param_named(max_loop_count, kp_max_loop_count, int, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(max_loop_count, "max loop execution count");
+
diff --git a/kernel/trace/ktap/ktap.h b/kernel/trace/ktap/ktap.h
new file mode 100644
index 0000000..90d1468
--- /dev/null
+++ b/kernel/trace/ktap/ktap.h
@@ -0,0 +1,176 @@
+#ifndef __KTAP_H__
+#define __KTAP_H__
+
+#include <linux/version.h>
+#include <linux/hardirq.h>
+#include <linux/trace_seq.h>
+
+/* for built-in library C function register */
+typedef struct ktap_libfunc {
+        const char *name; /* function name */
+        ktap_cfunction func; /* function pointer */
+} ktap_libfunc_t;
+
+long gettimeofday_ns(void); /* common helper function */
+int kp_lib_init_base(ktap_state_t *ks);
+int kp_lib_init_kdebug(ktap_state_t *ks);
+int kp_lib_init_timer(ktap_state_t *ks);
+int kp_lib_init_table(ktap_state_t *ks);
+int kp_lib_init_ansi(ktap_state_t *ks);
+int kp_lib_init_net(ktap_state_t *ks);
+
+void kp_exit_timers(ktap_state_t *ks);
+void kp_freeupval(ktap_state_t *ks, ktap_upval_t *uv);
+
+extern int (*kp_ftrace_profile_set_filter)(struct perf_event *event,
+					   int event_id,
+					   const char *filter_str);
+
+extern struct syscall_metadata **syscalls_metadata;
+
+/* get from kernel/trace/trace.h */
+static __always_inline int trace_get_context_bit(void)
+{
+	int bit;
+
+	if (in_interrupt()) {
+		if (in_nmi())
+			bit = 0;
+		else if (in_irq())
+			bit = 1;
+		else
+			bit = 2;
+	} else
+		bit = 3;
+
+	return bit;
+}
+
+static __always_inline int get_recursion_context(ktap_state_t *ks)
+{
+	int rctx = trace_get_context_bit();
+	int *val = __this_cpu_ptr(G(ks)->recursion_context[rctx]);
+
+	if (*val)
+		return -1;
+
+	*val = true;
+	return rctx;
+}
+
+static inline void put_recursion_context(ktap_state_t *ks, int rctx)
+{
+	int *val = __this_cpu_ptr(G(ks)->recursion_context[rctx]);
+	*val = false;
+}
+
+static inline void *kp_this_cpu_state(ktap_state_t *ks, int rctx)
+{
+	return this_cpu_ptr(G(ks)->percpu_state[rctx]);
+}
+
+static inline void *kp_this_cpu_print_buffer(ktap_state_t *ks)
+{
+	return this_cpu_ptr(G(ks)->percpu_print_buffer[trace_get_context_bit()]);
+}
+
+static inline void *kp_this_cpu_temp_buffer(ktap_state_t *ks)
+{
+	return this_cpu_ptr(G(ks)->percpu_temp_buffer[trace_get_context_bit()]);
+}
+
+#define kp_verbose_printf(ks, ...) \
+	if (G(ks)->parm->verbose)	\
+		kp_printf(ks, "[verbose] "__VA_ARGS__);
+
+/* argument operation macro */
+#define kp_arg(ks, idx)	((ks)->func + (idx))
+#define kp_arg_nr(ks)	((int)(ks->top - (ks->func + 1)))
+
+#define kp_arg_check(ks, idx, type)				\
+	do {							\
+		if (unlikely(itype(kp_arg(ks, idx)) != type)) {	\
+			kp_error(ks, "wrong type of argument %d\n", idx);\
+			return -1;				\
+		}						\
+	} while (0)
+
+#define kp_arg_checkstring(ks, idx)				\
+	({							\
+		ktap_val_t *o = kp_arg(ks, idx);		\
+		if (unlikely(!is_string(o))) {			\
+			kp_error(ks, "wrong type of argument %d\n", idx); \
+			return -1;				\
+		}						\
+		svalue(o);					\
+	})
+
+#define kp_arg_checkfunction(ks, idx)				\
+	({							\
+		ktap_val_t *o = kp_arg(ks, idx);		\
+		if (unlikely(!is_function(o))) {			\
+			kp_error(ks, "wrong type of argument %d\n", idx); \
+			return -1;				\
+		}						\
+		clvalue(o);					\
+	})
+
+#define kp_arg_checknumber(ks, idx)				\
+	({							\
+		ktap_val_t *o = kp_arg(ks, idx);		\
+		if (unlikely(!is_number(o))) {			\
+			kp_error(ks, "wrong type of argument %d\n", idx); \
+			return -1;				\
+		}						\
+		nvalue(o);					\
+	})
+
+#define kp_arg_checkoptnumber(ks, idx, def)			\
+	({							\
+		ktap_number n;					\
+		if (idx > kp_arg_nr(ks)) {				\
+			n = def;				\
+		} else {					\
+			ktap_val_t *o = kp_arg(ks, idx);	\
+			if (unlikely(!is_number(o))) {		\
+				kp_error(ks, "wrong type of argument %d\n", \
+					     idx);		\
+				return -1;			\
+			}					\
+			n = nvalue(o);				\
+		}						\
+		n;						\
+	})
+
+#define kp_error(ks, args...)			\
+	do {					\
+		kp_printf(ks, "error: "args);	\
+		kp_vm_try_to_exit(ks);		\
+		G(ks)->state = KTAP_ERROR;	\
+	} while(0)
+
+
+#define SPRINT_SYMBOL	sprint_symbol_no_offset
+
+extern int kp_max_loop_count;
+
+void kp_printf(ktap_state_t *ks, const char *fmt, ...);
+void __kp_puts(ktap_state_t *ks, const char *str);
+void __kp_bputs(ktap_state_t *ks, const char *str);
+
+#define kp_puts(ks, str) ({						\
+	static const char *trace_printk_fmt				\
+		__attribute__((section("__trace_printk_fmt"))) =	\
+		__builtin_constant_p(str) ? str : NULL;			\
+									\
+	if (__builtin_constant_p(str))					\
+		__kp_bputs(ks, trace_printk_fmt);		\
+	else								\
+		__kp_puts(ks, str);		\
+})
+
+#define err2msg(em)     (kp_err_allmsg+(int)(em))
+extern const char *kp_err_allmsg;
+
+#endif /* __KTAP_H__ */
+
-- 
1.8.1.4

