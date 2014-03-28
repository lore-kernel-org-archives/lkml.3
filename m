Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752704AbaC1Nzi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 09:55:38 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:51214 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262AbaC1Nze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 09:55:34 -0400
From: Jovi Zhangwei <jovi.zhangwei@gmail.com>
To: Ingo Molnar <mingo@redhat.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jovi Zhangwei <jovi.zhangwei@gmail.com>
Subject: [PATCH 15/28] ktap: add built-in functions and library (runtime/lib_*.c)
Date: Fri, 28 Mar 2014 09:47:36 -0400
Message-Id: <1396014469-5937-16-git-send-email-jovi.zhangwei@gmail.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1396014469-5937-1-git-send-email-jovi.zhangwei@gmail.com>
References: <1396014469-5937-1-git-send-email-jovi.zhangwei@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ktap register built-in functions and library into table.

1). Built-in functions(lib_base,c):

print, printf, print_hist, pairs, len, delete, stack,
print_trace_clock, num_cpus, arch, kernel_v, kernel_string,
user_string, stringof, ipof, gettimeofday_ns, gettimeofday_us,
gettimeofday_ms, gettimeofday_s, curr_taskinfo, in_iowait,
in_interrupt, exit.

2). Ansi library(lib_ansi.c):

ansi.clear_screen
ansi.set_color
ansi.set_color2
ansi.set_color3
ansi.reset_color
ansi.new_line

3). kdebug library(lib_kdebug.c):

kdebug.trace_by_id
kdebug.trace_end
kdebug.tracepoint
kdebug.kprobe

4). net library(lib_net.c):

net.ip_sock_saddr
net.ip_sock_daddr
net.format_ip_addr

5). table library(lib_table.c):

table.new

6). timer library(lib_timer.c):

timer.profile
timer.tick

Signed-off-by: Jovi Zhangwei <jovi.zhangwei@gmail.com>
---
 tools/ktap/runtime/lib_ansi.c   | 142 ++++++++++++++
 tools/ktap/runtime/lib_base.c   | 409 ++++++++++++++++++++++++++++++++++++++++
 tools/ktap/runtime/lib_kdebug.c | 198 +++++++++++++++++++
 tools/ktap/runtime/lib_net.c    | 107 +++++++++++
 tools/ktap/runtime/lib_table.c  |  58 ++++++
 tools/ktap/runtime/lib_timer.c  | 210 +++++++++++++++++++++
 6 files changed, 1124 insertions(+)
 create mode 100644 tools/ktap/runtime/lib_ansi.c
 create mode 100644 tools/ktap/runtime/lib_base.c
 create mode 100644 tools/ktap/runtime/lib_kdebug.c
 create mode 100644 tools/ktap/runtime/lib_net.c
 create mode 100644 tools/ktap/runtime/lib_table.c
 create mode 100644 tools/ktap/runtime/lib_timer.c

diff --git a/tools/ktap/runtime/lib_ansi.c b/tools/ktap/runtime/lib_ansi.c
new file mode 100644
index 0000000..e690b2b
--- /dev/null
+++ b/tools/ktap/runtime/lib_ansi.c
@@ -0,0 +1,142 @@
+/*
+ * lib_ansi.c - ANSI escape sequences library
+ *
+ * http://en.wikipedia.org/wiki/ANSI_escape_code
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
+#include "../include/ktap_types.h"
+#include "ktap.h"
+#include "kp_vm.h"
+
+/**
+ * function ansi.clear_screen - Move cursor to top left and clear screen.
+ *
+ * Description: Sends ansi code for moving cursor to top left and then the
+ * ansi code for clearing the screen from the cursor position to the end.
+ */
+
+static int kplib_ansi_clear_screen(ktap_state_t *ks)
+{
+	kp_printf(ks, "\033[1;1H\033[J");
+	return 0;
+}
+
+/**
+ * function ansi.set_color - Set the ansi Select Graphic Rendition mode.
+ * @fg: Foreground color to set.
+ *
+ * Description: Sends ansi code for Select Graphic Rendition mode for the
+ * given forground color. Black (30), Blue (34), Green (32), Cyan (36),
+ * Red (31), Purple (35), Brown (33), Light Gray (37).
+ */
+
+static int kplib_ansi_set_color(ktap_state_t *ks)
+{
+	int fg = kp_arg_checknumber(ks, 1);
+
+	kp_printf(ks, "\033[%dm", fg);
+	return 0;
+}
+
+/**
+ * function ansi.set_color2 - Set the ansi Select Graphic Rendition mode.
+ * @fg: Foreground color to set.
+ * @bg: Background color to set.
+ *
+ * Description: Sends ansi code for Select Graphic Rendition mode for the
+ * given forground color, Black (30), Blue (34), Green (32), Cyan (36),
+ * Red (31), Purple (35), Brown (33), Light Gray (37) and the given
+ * background color, Black (40), Red (41), Green (42), Yellow (43),
+ * Blue (44), Magenta (45), Cyan (46), White (47).
+ */
+static int kplib_ansi_set_color2(ktap_state_t *ks)
+{
+	int fg = kp_arg_checknumber(ks, 1);
+	int bg = kp_arg_checknumber(ks, 2);
+	
+	kp_printf(ks, "\033[%d;%dm", fg, bg);
+	return 0;
+}
+
+/**
+ * function ansi.set_color3 - Set the ansi Select Graphic Rendition mode.
+ * @fg: Foreground color to set.
+ * @bg: Background color to set.
+ * @attr: Color attribute to set.
+ *
+ * Description: Sends ansi code for Select Graphic Rendition mode for the
+ * given forground color, Black (30), Blue (34), Green (32), Cyan (36),
+ * Red (31), Purple (35), Brown (33), Light Gray (37), the given
+ * background color, Black (40), Red (41), Green (42), Yellow (43),
+ * Blue (44), Magenta (45), Cyan (46), White (47) and the color attribute
+ * All attributes off (0), Intensity Bold (1), Underline Single (4),
+ * Blink Slow (5), Blink Rapid (6), Image Negative (7).
+ */
+static int kplib_ansi_set_color3(ktap_state_t *ks)
+{
+	int fg = kp_arg_checknumber(ks, 1);
+	int bg = kp_arg_checknumber(ks, 2);
+	int attr = kp_arg_checknumber(ks, 3);
+
+	if (attr)
+		kp_printf(ks, "\033[%d;%d;%dm", fg, bg, attr);
+	else
+		kp_printf(ks, "\033[%d;%dm", fg, bg);
+	
+	return 0;
+}
+
+/**
+ * function ansi.reset_color - Resets Select Graphic Rendition mode.
+ *
+ * Description: Sends ansi code to reset foreground, background and color
+ * attribute to default values.
+ */
+static int kplib_ansi_reset_color(ktap_state_t *ks)
+{
+	kp_printf(ks, "\033[0;0m");
+	return 0;
+}
+
+/**
+ * function ansi.new_line - Move cursor to new line.
+ *
+ * Description: Sends ansi code new line.
+ */
+static int kplib_ansi_new_line (ktap_state_t *ks)
+{
+	kp_printf(ks, "\12");
+	return 0;
+}
+
+static const ktap_libfunc_t ansi_lib_funcs[] = {
+	{"clear_screen", kplib_ansi_clear_screen},
+	{"set_color", kplib_ansi_set_color},
+	{"set_color2", kplib_ansi_set_color2},
+	{"set_color3", kplib_ansi_set_color3},
+	{"reset_color", kplib_ansi_reset_color},
+	{"new_line", kplib_ansi_new_line},
+	{NULL}
+};
+
+int kp_lib_init_ansi(ktap_state_t *ks)
+{
+	return kp_vm_register_lib(ks, "ansi", ansi_lib_funcs); 
+}
diff --git a/tools/ktap/runtime/lib_base.c b/tools/ktap/runtime/lib_base.c
new file mode 100644
index 0000000..0294134
--- /dev/null
+++ b/tools/ktap/runtime/lib_base.c
@@ -0,0 +1,409 @@
+/*
+ * lib_base.c - base library
+ *
+ * Caveat: all kernel funtion called by ktap library have to be lock free,
+ * otherwise system will deadlock.
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
+#include <linux/version.h>
+#include <linux/hardirq.h>
+#include <linux/module.h>
+#include <linux/kallsyms.h>
+#include <linux/sched.h>
+#include <linux/uaccess.h>
+#include <linux/utsname.h>
+#include <linux/time.h>
+#include <linux/clocksource.h>
+#include <linux/ring_buffer.h>
+#include <linux/stacktrace.h>
+#include <linux/cred.h>
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(3, 5, 0)
+#include <linux/uidgid.h>
+#endif
+#include "../include/ktap_types.h"
+#include "ktap.h"
+#include "kp_obj.h"
+#include "kp_str.h"
+#include "kp_tab.h"
+#include "kp_transport.h"
+#include "kp_events.h"
+#include "kp_vm.h"
+
+static int kplib_print(ktap_state_t *ks)
+{
+	int i;
+	int n = kp_arg_nr(ks);
+
+	for (i = 1; i <= n; i++) {
+		ktap_val_t *arg = kp_arg(ks, i);
+		if (i > 1)
+			kp_puts(ks, "\t");
+		kp_obj_show(ks, arg);
+	}
+
+	kp_puts(ks, "\n");
+	return 0;
+}
+
+/* don't engage with intern string in printf, use buffer directly */
+static int kplib_printf(ktap_state_t *ks)
+{
+	struct trace_seq *seq;
+
+	preempt_disable_notrace();
+
+	seq = kp_this_cpu_print_buffer(ks);
+	trace_seq_init(seq);
+
+	if (kp_str_fmt(ks, seq))
+		goto out;
+
+	seq->buffer[seq->len] = '\0';
+	kp_transport_write(ks, seq->buffer, seq->len + 1);
+
+ out:
+	preempt_enable_notrace();
+	return 0;
+}
+
+#define HISTOGRAM_DEFAULT_TOP_NUM	20
+
+static int kplib_print_hist(ktap_state_t *ks)
+{
+	int n ;
+
+	kp_arg_check(ks, 1, KTAP_TTAB);
+	n = kp_arg_checkoptnumber(ks, 2, HISTOGRAM_DEFAULT_TOP_NUM);
+
+	n = min(n, 1000);
+	n = max(n, HISTOGRAM_DEFAULT_TOP_NUM);
+
+	kp_tab_print_hist(ks, hvalue(kp_arg(ks, 1)), n);
+
+	return 0;
+}
+
+static int kplib_pairs(ktap_state_t *ks)
+{
+	kp_arg_check(ks, 1, KTAP_TTAB);
+
+	set_cfunc(ks->top++, (ktap_cfunction)kp_tab_next);
+	set_table(ks->top++, hvalue(kp_arg(ks, 1)));
+	set_nil(ks->top++);
+	return 3;
+}
+
+static int kplib_len(ktap_state_t *ks)
+{
+	int len = kp_obj_len(ks, kp_arg(ks, 1));
+
+	if (len < 0)
+		return -1;
+
+	set_number(ks->top, len);
+	incr_top(ks);
+	return 1;
+}
+
+static int kplib_delete(ktap_state_t *ks)
+{
+	kp_arg_check(ks, 1, KTAP_TTAB);
+	kp_tab_clear(hvalue(kp_arg(ks, 1)));
+	return 0;
+}
+
+#ifdef CONFIG_STACKTRACE
+static int kplib_stack(ktap_state_t *ks)
+{
+	uint16_t skip, depth = 10;
+
+	depth = kp_arg_checkoptnumber(ks, 1, 10); /* default as 10 */
+	depth = min_t(uint16_t, depth, KP_MAX_STACK_DEPTH);
+	skip = kp_arg_checkoptnumber(ks, 2, 10); /* default as 10 */
+
+	set_kstack(ks->top, depth, skip);
+	incr_top(ks);
+	return 1;
+}
+#else
+static int kplib_stack(ktap_state_t *ks)
+{
+	kp_error(ks, "Please enable CONFIG_STACKTRACE before call stack()\n");
+	return -1;
+}
+#endif
+
+
+extern unsigned long long ns2usecs(cycle_t nsec);
+static int kplib_print_trace_clock(ktap_state_t *ks)
+{
+	unsigned long long t;
+	unsigned long secs, usec_rem;
+	u64 timestamp;
+
+	/* use ring buffer's timestamp */
+	timestamp = ring_buffer_time_stamp(G(ks)->buffer, smp_processor_id());
+
+	t = ns2usecs(timestamp);
+	usec_rem = do_div(t, USEC_PER_SEC);
+	secs = (unsigned long)t;
+
+	kp_printf(ks, "%5lu.%06lu\n", secs, usec_rem);
+	return 0;
+}
+
+static int kplib_num_cpus(ktap_state_t *ks)
+{
+	set_number(ks->top, num_online_cpus());
+	incr_top(ks);
+	return 1;
+}
+
+/* TODO: intern string firstly */
+static int kplib_arch(ktap_state_t *ks)
+{
+	ktap_str_t *ts = kp_str_newz(ks, utsname()->machine);
+	if (unlikely(!ts))
+		return -1;
+
+	set_string(ks->top, ts);
+	incr_top(ks);
+	return 1;
+}
+
+/* TODO: intern string firstly */
+static int kplib_kernel_v(ktap_state_t *ks)
+{
+	ktap_str_t *ts = kp_str_newz(ks, utsname()->release);
+	if (unlikely(!ts))
+		return -1;
+
+	set_string(ks->top, ts);
+	incr_top(ks);
+	return 1;
+}
+
+static int kplib_kernel_string(ktap_state_t *ks)
+{
+	unsigned long addr = kp_arg_checknumber(ks, 1);
+	char str[256] = {0};
+	ktap_str_t *ts;
+	char *ret;
+
+	ret = strncpy((void *)str, (const void *)addr, 256);
+	(void) &ret;  /* Silence compiler warning. */
+	str[255] = '\0';
+
+	ts = kp_str_newz(ks, str);
+	if (unlikely(!ts))
+		return -1;
+
+	set_string(ks->top, ts);
+	incr_top(ks);
+	return 1;
+}
+
+static int kplib_user_string(ktap_state_t *ks)
+{
+	unsigned long addr = kp_arg_checknumber(ks, 1);
+	char str[256] = {0};
+	ktap_str_t *ts;
+	int ret;
+
+	pagefault_disable();
+	ret = __copy_from_user_inatomic((void *)str, (const void *)addr, 256);
+	(void) &ret;  /* Silence compiler warning. */
+	pagefault_enable();
+	str[255] = '\0';
+
+	ts = kp_str_newz(ks, str);
+	if (unlikely(!ts))
+		return -1;
+
+	set_string(ks->top, ts);
+	incr_top(ks);
+	return 1;
+}
+
+static int kplib_stringof(ktap_state_t *ks)
+{
+	ktap_val_t *v = kp_arg(ks, 1);
+	const ktap_str_t *ts = NULL;
+
+	if (itype(v) == KTAP_TEVENTSTR) {
+		ts = kp_event_stringify(ks);
+	} else if (itype(v) == KTAP_TKIP) {
+		char str[KSYM_SYMBOL_LEN];
+
+		SPRINT_SYMBOL(str, nvalue(v));
+		ts = kp_str_newz(ks, str);
+	}
+
+	if (unlikely(!ts))
+		return -1;
+
+	set_string(ks->top++, ts);
+	return 1;
+}
+
+static int kplib_ipof(ktap_state_t *ks)
+{
+	unsigned long addr = kp_arg_checknumber(ks, 1);
+
+	set_ip(ks->top++, addr);
+	return 1;
+}
+
+static int kplib_gettimeofday_ns(ktap_state_t *ks)
+{
+	set_number(ks->top, gettimeofday_ns());
+	incr_top(ks);
+
+	return 1;
+}
+
+static int kplib_gettimeofday_us(ktap_state_t *ks)
+{
+	set_number(ks->top, gettimeofday_ns() / NSEC_PER_USEC);
+	incr_top(ks);
+
+	return 1;
+}
+
+static int kplib_gettimeofday_ms(ktap_state_t *ks)
+{
+	set_number(ks->top, gettimeofday_ns() / NSEC_PER_MSEC);
+	incr_top(ks);
+
+	return 1;
+}
+
+static int kplib_gettimeofday_s(ktap_state_t *ks)
+{
+	set_number(ks->top, gettimeofday_ns() / NSEC_PER_SEC);
+	incr_top(ks);
+
+	return 1;
+}
+
+/*
+ * use gdb to get field offset of struct task_struct, for example:
+ *
+ * gdb vmlinux
+ * (gdb)p &(((struct task_struct *)0).prio)
+ */
+static int kplib_curr_taskinfo(ktap_state_t *ks)
+{
+	int offset = kp_arg_checknumber(ks, 1);
+	int fetch_bytes  = kp_arg_checkoptnumber(ks, 2, 4); /* fetch 4 bytes */
+
+	if (offset >= sizeof(struct task_struct)) {
+		set_nil(ks->top++);
+		kp_error(ks, "access out of bound value of task_struct\n");
+		return 1;
+	}
+
+#define RET_VALUE ((unsigned long)current + offset)
+
+	switch (fetch_bytes) {
+	case 4:
+		set_number(ks->top, *(unsigned int *)RET_VALUE);
+		break;
+	case 8:
+		set_number(ks->top, *(unsigned long *)RET_VALUE);
+		break;
+	default:
+		kp_error(ks, "unsupported fetch bytes in curr_task_info\n");
+		set_nil(ks->top);
+		break;
+	}
+
+#undef RET_VALUE
+
+	incr_top(ks);
+	return 1;
+}
+
+/*
+ * This built-in function mainly purpose scripts/schedule/schedtimes.kp
+ */
+static int kplib_in_iowait(ktap_state_t *ks)
+{
+	set_number(ks->top, current->in_iowait);
+	incr_top(ks);
+
+	return 1;
+}
+
+static int kplib_in_interrupt(ktap_state_t *ks)
+{
+	int ret = in_interrupt();
+
+	set_number(ks->top, ret);
+	incr_top(ks);
+	return 1;
+}
+
+static int kplib_exit(ktap_state_t *ks)
+{
+	kp_vm_try_to_exit(ks);
+
+	/* do not execute bytecode any more in this thread */
+	return -1;
+}
+
+static const ktap_libfunc_t base_lib_funcs[] = {
+	{"print", kplib_print},
+	{"printf", kplib_printf},
+	{"print_hist", kplib_print_hist},
+
+	{"pairs", kplib_pairs},
+	{"len", kplib_len},
+	{"delete", kplib_delete},
+
+	{"stack", kplib_stack},
+	{"print_trace_clock", kplib_print_trace_clock},
+
+	{"num_cpus", kplib_num_cpus},
+	{"arch", kplib_arch},
+	{"kernel_v", kplib_kernel_v},
+	{"kernel_string", kplib_kernel_string},
+	{"user_string", kplib_user_string},
+	{"stringof", kplib_stringof},
+	{"ipof", kplib_ipof},
+
+	{"gettimeofday_ns", kplib_gettimeofday_ns},
+	{"gettimeofday_us", kplib_gettimeofday_us},
+	{"gettimeofday_ms", kplib_gettimeofday_ms},
+	{"gettimeofday_s", kplib_gettimeofday_s},
+
+	{"curr_taskinfo", kplib_curr_taskinfo},
+
+	{"in_iowait", kplib_in_iowait},
+	{"in_interrupt", kplib_in_interrupt},
+
+	{"exit", kplib_exit},
+	{NULL}
+};
+
+int kp_lib_init_base(ktap_state_t *ks)
+{
+	return kp_vm_register_lib(ks, NULL, base_lib_funcs); 
+}
diff --git a/tools/ktap/runtime/lib_kdebug.c b/tools/ktap/runtime/lib_kdebug.c
new file mode 100644
index 0000000..430537e
--- /dev/null
+++ b/tools/ktap/runtime/lib_kdebug.c
@@ -0,0 +1,198 @@
+/*
+ * lib_kdebug.c - kdebug library support for ktap
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
+#include <linux/module.h>
+#include <linux/ctype.h>
+#include <linux/slab.h>
+#include <linux/version.h>
+#include <linux/ftrace_event.h>
+#include "../include/ktap_types.h"
+#include "ktap.h"
+#include "kp_obj.h"
+#include "kp_str.h"
+#include "kp_transport.h"
+#include "kp_vm.h"
+#include "kp_events.h"
+
+/**
+ * function kdebug.trace_by_id
+ *
+ * @uaddr: userspace address refer to ktap_eventdesc_t
+ * @closure
+ */
+static int kplib_kdebug_trace_by_id(ktap_state_t *ks)
+{
+	unsigned long uaddr = kp_arg_checknumber(ks, 1);
+	ktap_func_t *fn = kp_arg_checkfunction(ks, 2);
+	struct task_struct *task = G(ks)->trace_task;
+	ktap_eventdesc_t eventsdesc;
+	char *filter = NULL;
+	int *id_arr;
+	int ret, i;
+
+	if (G(ks)->mainthread != ks) {
+		kp_error(ks,
+		    "kdebug.trace_by_id only can be called in mainthread\n");
+		return -1;
+	}
+
+	/* kdebug.trace_by_id cannot be called in trace_end state */
+	if (G(ks)->state != KTAP_RUNNING) {
+		kp_error(ks,
+		    "kdebug.trace_by_id only can be called in RUNNING state\n");
+		return -1;
+	}
+
+	/* copy ktap_eventdesc_t from userspace */
+	ret = copy_from_user(&eventsdesc, (void *)uaddr,
+			     sizeof(ktap_eventdesc_t));
+	if (ret < 0)
+		return -1;
+
+	if (eventsdesc.filter) {
+		int len;
+
+		len = strlen_user(eventsdesc.filter);
+		if (len > 0x1000)
+			return -1;
+
+		filter = kmalloc(len + 1, GFP_KERNEL);
+		if (!filter)
+			return -1;
+
+		/* copy filter string from userspace */
+		if (strncpy_from_user(filter, eventsdesc.filter, len) < 0) {
+			kfree(filter);
+			return -1;
+		}
+	}
+
+	id_arr = kmalloc(eventsdesc.nr * sizeof(int), GFP_KERNEL);
+	if (!id_arr) {
+		kfree(filter);
+		return -1;
+	}
+
+	/* copy all event id from userspace */
+	ret = copy_from_user(id_arr, eventsdesc.id_arr,
+			     eventsdesc.nr * sizeof(int));
+	if (ret < 0) {
+		kfree(filter);
+		kfree(id_arr);
+		return -1;
+	}
+
+	fn = clvalue(kp_arg(ks, 2));
+
+	for (i = 0; i < eventsdesc.nr; i++) {
+		struct perf_event_attr attr;
+
+		cond_resched();
+
+		if (signal_pending(current)) {
+			flush_signals(current);
+			kfree(filter);
+			kfree(id_arr);
+			return -1;
+		}
+
+		memset(&attr, 0, sizeof(attr));
+		attr.type = PERF_TYPE_TRACEPOINT;	
+		attr.config = id_arr[i];
+		attr.sample_type = PERF_SAMPLE_RAW | PERF_SAMPLE_TIME |
+				   PERF_SAMPLE_CPU | PERF_SAMPLE_PERIOD;
+		attr.sample_period = 1;
+		attr.size = sizeof(attr);
+		attr.disabled = 0;
+
+		/* register event one by one */
+		ret = kp_event_create(ks, &attr, task, filter, fn);
+		if (ret < 0)
+			break;
+	}
+
+	kfree(filter);
+	kfree(id_arr);
+	return 0;
+}
+
+static int kplib_kdebug_trace_end(ktap_state_t *ks)
+{
+	/* trace_end_closure will be called when ktap main thread exit */
+	G(ks)->trace_end_closure = kp_arg_checkfunction(ks, 1);
+	return 0;
+}
+
+static int kplib_kdebug_tracepoint(ktap_state_t *ks)
+{
+	const char *event_name = kp_arg_checkstring(ks, 1);
+	ktap_func_t *fn = kp_arg_checkfunction(ks, 2);
+
+	if (G(ks)->mainthread != ks) {
+		kp_error(ks,
+		    "kdebug.tracepoint only can be called in mainthread\n");
+		return -1;
+	}
+
+	/* kdebug.tracepoint cannot be called in trace_end state */
+	if (G(ks)->state != KTAP_RUNNING) {
+		kp_error(ks,
+		    "kdebug.tracepoint only can be called in RUNNING state\n");
+		return -1;
+	}
+
+	return kp_event_create_tracepoint(ks, event_name, fn);
+}
+
+static int kplib_kdebug_kprobe(ktap_state_t *ks)
+{
+	const char *event_name = kp_arg_checkstring(ks, 1);
+	ktap_func_t *fn = kp_arg_checkfunction(ks, 2);
+
+	if (G(ks)->mainthread != ks) {
+		kp_error(ks,
+		    "kdebug.kprobe only can be called in mainthread\n");
+		return -1;
+	}
+
+	/* kdebug.kprobe cannot be called in trace_end state */
+	if (G(ks)->state != KTAP_RUNNING) {
+		kp_error(ks,
+		    "kdebug.kprobe only can be called in RUNNING state\n");
+		return -1;
+	}
+
+	return kp_event_create_kprobe(ks, event_name, fn);
+}
+static const ktap_libfunc_t kdebug_lib_funcs[] = {
+	{"trace_by_id", kplib_kdebug_trace_by_id},
+	{"trace_end", kplib_kdebug_trace_end},
+
+	{"tracepoint", kplib_kdebug_tracepoint},
+	{"kprobe", kplib_kdebug_kprobe},
+	{NULL}
+};
+
+int kp_lib_init_kdebug(ktap_state_t *ks)
+{
+	return kp_vm_register_lib(ks, "kdebug", kdebug_lib_funcs);
+}
+
diff --git a/tools/ktap/runtime/lib_net.c b/tools/ktap/runtime/lib_net.c
new file mode 100644
index 0000000..0103d14
--- /dev/null
+++ b/tools/ktap/runtime/lib_net.c
@@ -0,0 +1,107 @@
+/*
+ * lib_base.c - base library
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
+#include <net/inet_sock.h>
+#include "../include/ktap_types.h"
+#include "ktap.h"
+#include "kp_obj.h"
+#include "kp_str.h"
+#include "kp_vm.h"
+
+/**
+ * Return the source IP address for a given sock
+ */
+static int kplib_net_ip_sock_saddr(ktap_state_t *ks)
+{
+	struct inet_sock *isk;
+	int family;
+
+	/* TODO: need to validate the address firstly */	
+
+	isk = (struct inet_sock *)kp_arg_checknumber(ks, 1);
+	family = isk->sk.__sk_common.skc_family;
+
+	if (family == AF_INET) {
+		set_number(ks->top, isk->inet_rcv_saddr);
+	} else {
+		kp_error(ks, "ip_sock_saddr only support ipv4 now\n");
+		set_nil(ks->top);
+	}
+
+	incr_top(ks);
+	return 1;
+}
+
+/**
+ * Return the destination IP address for a given sock
+ */
+static int kplib_net_ip_sock_daddr(ktap_state_t *ks)
+{
+	struct inet_sock *isk;
+	int family;
+
+	/* TODO: need to validate the address firstly */	
+
+	isk = (struct inet_sock *)kp_arg_checknumber(ks, 1);
+	family = isk->sk.__sk_common.skc_family;
+
+	if (family == AF_INET) {
+		set_number(ks->top, isk->inet_daddr);
+	} else {
+		kp_error(ks, "ip_sock_daddr only support ipv4 now\n");
+		set_nil(ks->top);
+	}
+
+	incr_top(ks);
+	return 1;
+
+}
+
+/**
+ * Returns a string representation for an IP address
+ */
+static int kplib_net_format_ip_addr(ktap_state_t *ks)
+{
+	__be32 ip = (__be32)kp_arg_checknumber(ks, 1);
+	ktap_str_t *ts;
+	char ipstr[32];
+
+	snprintf(ipstr, 32, "%pI4", &ip);
+	ts = kp_str_newz(ks, ipstr);
+	if (ts) {
+		set_string(ks->top, kp_str_newz(ks, ipstr));
+		incr_top(ks);
+		return 1;
+	} else
+		return -1;
+}
+
+static const ktap_libfunc_t net_lib_funcs[] = {
+	{"ip_sock_saddr", kplib_net_ip_sock_saddr},
+	{"ip_sock_daddr", kplib_net_ip_sock_daddr},
+	{"format_ip_addr", kplib_net_format_ip_addr},
+	{NULL}
+};
+
+int kp_lib_init_net(ktap_state_t *ks)
+{
+	return kp_vm_register_lib(ks, "net", net_lib_funcs); 
+}
diff --git a/tools/ktap/runtime/lib_table.c b/tools/ktap/runtime/lib_table.c
new file mode 100644
index 0000000..5c00f83
--- /dev/null
+++ b/tools/ktap/runtime/lib_table.c
@@ -0,0 +1,58 @@
+/*
+ * lib_table.c - Table library
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
+#include <linux/ctype.h>
+#include <linux/slab.h>
+#include <linux/delay.h>
+#include <linux/sched.h>
+#include "../include/ktap_types.h"
+#include "ktap.h"
+#include "kp_obj.h"
+#include "kp_vm.h"
+#include "kp_tab.h"
+
+static int kplib_table_new(ktap_state_t *ks)
+{
+	int narr = kp_arg_checkoptnumber(ks, 1, 0);
+	int nrec = kp_arg_checkoptnumber(ks, 2, 0);
+	ktap_tab_t *h;
+
+	h = kp_tab_new_ah(ks, narr, nrec);
+	if (!h) {
+		set_nil(ks->top);
+	} else {
+		set_table(ks->top, h);
+	}
+
+	incr_top(ks);
+	return 1;
+}
+
+static const ktap_libfunc_t table_lib_funcs[] = {
+	{"new",	kplib_table_new},
+	{NULL}
+};
+
+int kp_lib_init_table(ktap_state_t *ks)
+{
+	return kp_vm_register_lib(ks, "table", table_lib_funcs);
+}
+
diff --git a/tools/ktap/runtime/lib_timer.c b/tools/ktap/runtime/lib_timer.c
new file mode 100644
index 0000000..3f160ef
--- /dev/null
+++ b/tools/ktap/runtime/lib_timer.c
@@ -0,0 +1,210 @@
+/*
+ * lib_timer.c - timer library support for ktap
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
+#include <linux/ctype.h>
+#include <linux/slab.h>
+#include <linux/delay.h>
+#include <linux/sched.h>
+#include "../include/ktap_types.h"
+#include "ktap.h"
+#include "kp_obj.h"
+#include "kp_vm.h"
+#include "kp_events.h"
+
+struct ktap_hrtimer {
+	struct hrtimer timer;
+	ktap_state_t *ks;
+	ktap_func_t *fn;
+	u64 ns;
+	struct list_head list;
+};
+
+/*
+ * Currently ktap disallow tracing event in timer callback closure,
+ * that will corrupt ktap_state_t and ktap stack, because timer closure
+ * and event closure use same irq percpu ktap_state_t and stack.
+ * We can use a different percpu ktap_state_t and stack for timer purpuse,
+ * but that's don't bring any big value with cost on memory consuming.
+ *
+ * So just simply disable tracing in timer closure,
+ * get_recursion_context()/put_recursion_context() is used for this purpose.
+ */
+static enum hrtimer_restart hrtimer_ktap_fn(struct hrtimer *timer)
+{
+	struct ktap_hrtimer *t;
+	ktap_state_t *ks;
+	int rctx;
+
+	rcu_read_lock_sched_notrace();
+
+	t = container_of(timer, struct ktap_hrtimer, timer);
+	rctx = get_recursion_context(t->ks);
+
+	ks = kp_vm_new_thread(t->ks, rctx);
+	set_func(ks->top, t->fn);
+	incr_top(ks);
+	kp_vm_call(ks, ks->top - 1, 0);
+	kp_vm_exit_thread(ks);
+
+	hrtimer_add_expires_ns(timer, t->ns);
+
+	put_recursion_context(ks, rctx);
+	rcu_read_unlock_sched_notrace();
+
+	return HRTIMER_RESTART;
+}
+
+static int set_tick_timer(ktap_state_t *ks, u64 period, ktap_func_t *fn)
+{
+	struct ktap_hrtimer *t;
+
+	t = kp_malloc(ks, sizeof(*t));
+	if (unlikely(!t))
+		return -ENOMEM;
+	t->ks = ks;
+	t->fn = fn;
+	t->ns = period;
+
+	INIT_LIST_HEAD(&t->list);
+	list_add(&t->list, &(G(ks)->timers));
+
+	hrtimer_init(&t->timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	t->timer.function = hrtimer_ktap_fn;
+	hrtimer_start(&t->timer, ns_to_ktime(period), HRTIMER_MODE_REL);
+
+	return 0;
+}
+
+static int set_profile_timer(ktap_state_t *ks, u64 period, ktap_func_t *fn)
+{
+	struct perf_event_attr attr;
+
+	memset(&attr, 0, sizeof(attr));
+	attr.type = PERF_TYPE_SOFTWARE;
+	attr.config = PERF_COUNT_SW_CPU_CLOCK;
+	attr.sample_type = PERF_SAMPLE_RAW | PERF_SAMPLE_TIME |
+			   PERF_SAMPLE_CPU | PERF_SAMPLE_PERIOD;
+	attr.sample_period = period;
+	attr.size = sizeof(attr);
+	attr.disabled = 0;
+
+	return kp_event_create(ks, &attr, NULL, NULL, fn);
+}
+
+static int do_tick_profile(ktap_state_t *ks, int is_tick)
+{
+	const char *str = kp_arg_checkstring(ks, 1);
+	ktap_func_t *fn = kp_arg_checkfunction(ks, 2);
+	const char *tmp;
+	char interval_str[32] = {0};
+	char suffix[10] = {0};
+	int i = 0, ret, n;
+	int factor;
+
+	tmp = str;
+	while (isdigit(*tmp))
+		tmp++;
+
+	strncpy(interval_str, str, tmp - str);
+	if (kstrtoint(interval_str, 10, &n))
+		goto error;
+
+	strncpy(suffix, tmp, 9);
+	while (suffix[i] != ' ' && suffix[i] != '\0')
+		i++;
+
+	suffix[i] = '\0';
+
+	if (!strcmp(suffix, "s") || !strcmp(suffix, "sec"))
+		factor = NSEC_PER_SEC;
+	else if (!strcmp(suffix, "ms") || !strcmp(suffix, "msec"))
+		factor = NSEC_PER_MSEC;
+	else if (!strcmp(suffix, "us") || !strcmp(suffix, "usec"))
+		factor = NSEC_PER_USEC;
+	else
+		goto error;
+
+	if (is_tick)
+		ret = set_tick_timer(ks, (u64)factor * n, fn);
+	else
+		ret = set_profile_timer(ks, (u64)factor * n, fn);
+
+	return ret;
+
+ error:
+	kp_error(ks, "cannot parse timer interval: %s\n", str);
+	return -1;
+}
+
+/*
+ * tick-n probes fire on only one CPU per interval.
+ * valid time suffixes: sec/s, msec/ms, usec/us
+ */
+static int kplib_timer_tick(ktap_state_t *ks)
+{
+	/* timer.tick cannot be called in trace_end state */
+	if (G(ks)->state != KTAP_RUNNING) {
+		kp_error(ks,
+			 "timer.tick only can be called in RUNNING state\n");
+		return -1;
+	}
+
+	return do_tick_profile(ks, 1);
+}
+
+/*
+ * A profile-n probe fires every fixed interval on every CPU
+ * valid time suffixes: sec/s, msec/ms, usec/us
+ */
+static int kplib_timer_profile(ktap_state_t *ks)
+{
+	/* timer.profile cannot be called in trace_end state */
+	if (G(ks)->state != KTAP_RUNNING) {
+		kp_error(ks,
+			 "timer.profile only can be called in RUNNING state\n");
+		return -1;
+	}
+
+	return do_tick_profile(ks, 0);
+}
+
+void kp_exit_timers(ktap_state_t *ks)
+{
+	struct ktap_hrtimer *t, *tmp;
+	struct list_head *timers_list = &(G(ks)->timers);
+
+	list_for_each_entry_safe(t, tmp, timers_list, list) {
+		hrtimer_cancel(&t->timer);
+		kp_free(ks, t);
+	}
+}
+
+static const ktap_libfunc_t timer_lib_funcs[] = {
+	{"profile",	kplib_timer_profile},
+	{"tick",	kplib_timer_tick},
+	{NULL}
+};
+
+int kp_lib_init_timer(ktap_state_t *ks)
+{
+	return kp_vm_register_lib(ks, "timer", timer_lib_funcs);
+}
+
-- 
1.8.1.4

