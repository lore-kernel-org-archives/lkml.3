Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752480AbaC2PZ7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 11:25:59 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:39605 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752442AbaC2PZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 11:25:57 -0400
From: Jovi Zhangwei <jovi.zhangwei@gmail.com>
To: Ingo Molnar <mingo@redhat.com>, Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andi Kleen <andi@firstfloor.org>,
        Jovi Zhangwei <jovi.zhangwei@gmail.com>
Subject: [PATCH v2 14/29] ktap: add events management(kernel/trace/ktap/kp_events.[c|h])
Date: Fri, 28 Mar 2014 10:45:09 -0400
Message-Id: <1396017924-7754-15-git-send-email-jovi.zhangwei@gmail.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1396017924-7754-1-git-send-email-jovi.zhangwei@gmail.com>
References: <1396017924-7754-1-git-send-email-jovi.zhangwei@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kp_events.c handle ktap events management(registry, destroy, event callback)

This file is core event management interface between ktap and kernel.

Exposed functions:
1). kp_events_init/kp_events_exit

2). kp_event_create_kprobe
        create kprobe event, for example:
                kdebug.kprobe("SyS_futex", function () {})

3). kp_event_create_tracepoint
        create tracepoint event, for example"
                kdebug.tracepoint("sys_futex_enter", function () {})

4). kp_event_create
        create perf backend event, for example:
                trace sched:sched_switch { print(argstr) }

        It call kernel function 'perf_event_create_kernel_counter' to
        register event(tracepoint/kprobe/uprobe)

5). kp_event_getarg
        get argument of event, from arg0 to arg9,
        only can be called in probe context.
                trace sched:sched_switch { print(arg0, arg1) }

6). kp_event_stringify/kp_event_tostr
        stringify argstr, sometimes if store argstr as key to table,
        then it need to stringify firstly, like below:
                var s={} trace sched:sched_switch { s[argstr] += 1 }
        (This is quite rare usage, but ktap support it)

Note:
Why ktap support 'kdebug.kprobe' and 'kdebug.tracepoint' when
it already support perf backend event(trace xxx {})?

Because benchmark shows raw kprobe and tracpoint interface is faster
than perf backed tracing, nearly 10+%, it's more fair to compare
with Systemtap by raw tracing syntax, not perf backend tracing.

perf backend tracing have a long code path before reach ktap callback,
and it need to copy event buffer firstly.

Signed-off-by: Jovi Zhangwei <jovi.zhangwei@gmail.com>
---
 kernel/trace/ktap/kp_events.c | 832 ++++++++++++++++++++++++++++++++++++++++++
 kernel/trace/ktap/kp_events.h |  71 ++++
 2 files changed, 903 insertions(+)
 create mode 100644 kernel/trace/ktap/kp_events.c
 create mode 100644 kernel/trace/ktap/kp_events.h

diff --git a/kernel/trace/ktap/kp_events.c b/kernel/trace/ktap/kp_events.c
new file mode 100644
index 0000000..1aabe80
--- /dev/null
+++ b/kernel/trace/ktap/kp_events.c
@@ -0,0 +1,832 @@
+/*
+ * kp_events.c - ktap events management (registry, destroy, event callback)
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
+#include <asm/syscall.h>
+#include <uapi/ktap/ktap_types.h>
+#include "ktap.h"
+#include "kp_obj.h"
+#include "kp_str.h"
+#include "kp_transport.h"
+#include "kp_vm.h"
+#include "kp_events.h"
+
+const char *kp_event_tostr(ktap_state_t *ks)
+{
+	struct ktap_event_data *e = ks->current_event;
+	struct ftrace_event_call *call;
+	struct trace_iterator *iter;
+	struct trace_event *ev;
+	enum print_line_t ret = TRACE_TYPE_NO_CONSUME;
+	static const char *dummy_msg = "argstr_not_available";
+
+	/* need to check current context is vaild tracing context */
+	if (!ks->current_event) {
+		kp_error(ks, "cannot stringify event str in invalid context\n");
+		return NULL;
+	}
+
+	/*check if stringified before */
+	if (ks->current_event->argstr)
+		return getstr(ks->current_event->argstr);
+
+	/* timer event and raw tracepoint don't have associated argstr */
+	if (e->event->type == KTAP_EVENT_TYPE_PERF && e->event->perf->tp_event)
+		call = e->event->perf->tp_event;
+	else
+		return dummy_msg;
+
+	/* Simulate the iterator */
+
+	/*
+	 * use temp percpu buffer as trace_iterator
+	 * we cannot use same print_buffer because we may called from printf.
+	 */
+	iter = kp_this_cpu_temp_buffer(ks);
+
+	trace_seq_init(&iter->seq);
+	iter->ent = e->data->raw->data;
+
+	ev = &(call->event);
+	if (ev)
+		ret = ev->funcs->trace(iter, 0, ev);
+
+	if (ret != TRACE_TYPE_NO_CONSUME) {
+		struct trace_seq *s = &iter->seq;
+		int len = s->len >= PAGE_SIZE ? PAGE_SIZE - 1 : s->len;
+
+		s->buffer[len] = '\0';
+		return &s->buffer[0];
+	}
+
+	return dummy_msg;
+}
+
+/* return string repr of 'argstr' */
+const ktap_str_t *kp_event_stringify(ktap_state_t *ks)
+{
+	const char *str;
+	ktap_str_t *ts;
+
+	/*check if stringified before */
+	if (ks->current_event->argstr)
+		return ks->current_event->argstr;
+
+	str = kp_event_tostr(ks);
+	if (!str)
+		return NULL;
+
+	ts = kp_str_newz(ks, str);
+	ks->current_event->argstr = ts;
+	return ts;
+}
+
+/*
+ * This definition should keep update with kernel/trace/trace.h
+ * TODO: export this struct in kernel 
+ */
+struct ftrace_event_field {
+	struct list_head        link;
+	const char              *name;
+	const char              *type;
+	int                     filter_type;
+	int                     offset;
+	int                     size;
+	int                     is_signed;
+};
+
+static struct list_head *get_fields(struct ftrace_event_call *event_call)
+{
+	if (!event_call->class->get_fields)
+		return &event_call->class->fields;
+	return event_call->class->get_fields(event_call);
+}
+
+void kp_event_getarg(ktap_state_t *ks, ktap_val_t *ra, int idx)
+{
+	struct ktap_event_data *e = ks->current_event;
+	struct ktap_event *event = e->event;
+	struct ktap_event_field *event_fields = &event->fields[idx];
+
+	switch (event_fields->type)  {
+	case KTAP_EVENT_FIELD_TYPE_INT: {
+		struct trace_entry *entry = e->data->raw->data;
+		void *value = (unsigned char *)entry + event_fields->offset;
+		int n = *(int *)value;
+		set_number(ra, n);
+		return;
+		}
+	case KTAP_EVENT_FIELD_TYPE_LONG: {
+		struct trace_entry *entry = e->data->raw->data;
+		void *value = (unsigned char *)entry + event_fields->offset;
+		long n = *(long *)value;
+		set_number(ra, n);
+		return;
+		}
+	case KTAP_EVENT_FIELD_TYPE_STRING: {
+		struct trace_entry *entry = e->data->raw->data;
+		ktap_str_t *ts;
+		void *value = (unsigned char *)entry + event_fields->offset;
+		ts = kp_str_newz(ks, (char *)value);
+		if (ts)
+			set_string(ra, ts);
+		else
+			set_nil(ra);
+		return;
+		}
+	case KTAP_EVENT_FIELD_TYPE_CONST: {
+		set_number(ra, (ktap_number)event_fields->offset);
+		return;
+		}
+	case KTAP_EVENT_FIELD_TYPE_REGESTER: {
+		unsigned long *reg = (unsigned long *)((u8 *)e->regs +
+					event_fields->offset);
+		set_number(ra, *reg);
+		return;
+		}
+	case KTAP_EVENT_FIELD_TYPE_NIL:
+		set_nil(ra);
+		return;
+	case KTAP_EVENT_FIELD_TYPE_INVALID:
+		kp_error(ks, "the field type is not supported yet\n");
+		set_nil(ra);
+		return;
+	}
+}
+
+/* init all fields of event, for quick arg1..arg9 access */
+static int init_event_fields(ktap_state_t *ks, struct ktap_event *event)
+{
+	struct ftrace_event_call *event_call = event->perf->tp_event; 
+	struct ktap_event_field *event_fields = &event->fields[0];
+	struct ftrace_event_field *field;
+	struct list_head *head;
+	int idx = 0, n = 0;
+
+	/* only init fields for tracepoint, not timer event */
+	if (!event_call)
+		return 0;
+
+	/* intern probename */
+	event->name = kp_str_newz(ks, event_call->name);
+	if (unlikely(!event->name))
+		return -ENOMEM;
+
+	head = get_fields(event_call);
+	list_for_each_entry_reverse(field, head, link) {
+		if (n++ == 9) {
+			/*
+			 * For some events have fields more than 9, just ignore
+			 * those rest fields at present.
+			 *
+			 * TODO: support access all fields in tracepoint event
+			 *
+			 * Examples: mce:mce_record, ext4:ext4_writepages, ...
+			 */
+			return 0;
+		}
+
+		event_fields[idx].offset = field->offset;
+
+		if (field->size == 4) {
+			event_fields[idx].type = KTAP_EVENT_FIELD_TYPE_INT;
+			idx++;
+			continue;
+		} else if (field->size == 8) {
+			event_fields[idx].type = KTAP_EVENT_FIELD_TYPE_LONG;
+			idx++;
+			continue;
+		}
+		if (!strncmp(field->type, "char", 4)) {
+			event_fields[idx].type = KTAP_EVENT_FIELD_TYPE_STRING;
+			idx++;
+			continue;
+		}
+
+		/* TODO: add more type check */
+		event_fields[idx++].type = KTAP_EVENT_FIELD_TYPE_INVALID;
+	}
+
+	/* init all rest fields as NIL */
+	while (idx < 9)
+		event_fields[idx++].type = KTAP_EVENT_FIELD_TYPE_NIL;
+
+	return 0;
+}
+
+static inline void call_probe_closure(ktap_state_t *mainthread,
+				      ktap_func_t *fn,
+				      struct ktap_event_data *e, int rctx)
+{
+	ktap_state_t *ks;
+	ktap_val_t *func;
+
+	ks = kp_vm_new_thread(mainthread, rctx);
+	set_func(ks->top, fn);
+	func = ks->top;
+	incr_top(ks);
+
+	ks->current_event = e;
+
+	kp_vm_call(ks, func, 0);
+
+	ks->current_event = NULL;
+	kp_vm_exit_thread(ks);
+}
+
+/*
+ * Callback tracing function for perf event subsystem.
+ *
+ * make ktap reentrant, don't disable irq in callback function,
+ * same as perf and ftrace. to make reentrant, we need some
+ * percpu data to be context isolation(irq/sirq/nmi/process)
+ *
+ * The recursion checking in here is mainly purpose for avoiding
+ * corrupt ktap_state_t with timer closure callback. For tracepoint
+ * recusion, perf core already handle it.
+ *
+ * Note tracepoint handler is calling with rcu_read_lock.
+ */
+static void perf_callback(struct perf_event *perf_event,
+			   struct perf_sample_data *data,
+			   struct pt_regs *regs)
+{
+	struct ktap_event *event;
+	struct ktap_event_data e;
+	ktap_state_t *ks;
+	int rctx;
+
+	event = perf_event->overflow_handler_context;
+	ks = event->ks;
+
+	if (unlikely(ks->stop))
+		return;
+
+	rctx = get_recursion_context(ks);
+	if (unlikely(rctx < 0))
+		return;
+
+	e.event = event;
+	e.data = data;
+	e.regs = regs;
+	e.argstr = NULL;
+
+	call_probe_closure(ks, event->fn, &e, rctx);
+
+	put_recursion_context(ks, rctx);
+}
+
+/*
+ * Generic ktap event creation function (based on perf callback)
+ * purpose for tracepoints/kprobe/uprobe/profile-timer/hw_breakpoint/pmu.
+ */
+int kp_event_create(ktap_state_t *ks, struct perf_event_attr *attr,
+		    struct task_struct *task, const char *filter,
+		    ktap_func_t *fn)
+{
+	struct ktap_event *event;
+	struct perf_event *perf_event;
+	void *callback = perf_callback;
+	int cpu, ret;
+
+	if (G(ks)->parm->dry_run)
+		callback = NULL;
+
+	/*
+	 * don't tracing until ktap_wait, the reason is:
+	 * 1). some event may hit before apply filter
+	 * 2). more simple to manage tracing thread
+	 * 3). avoid race with mainthread.
+	 *
+	 * Another way to do this is make attr.disabled as 1, then use
+	 * perf_event_enable after filter apply, however, perf_event_enable
+	 * was not exported in kernel older than 3.3, so we drop this method.
+	 */
+	ks->stop = 1;
+
+	for_each_cpu(cpu, G(ks)->cpumask) {
+		event = kzalloc(sizeof(struct ktap_event), GFP_KERNEL);
+		if (!event)
+			return -ENOMEM;
+
+		event->type = KTAP_EVENT_TYPE_PERF;
+		event->ks = ks;
+		event->fn = fn;
+		perf_event = perf_event_create_kernel_counter(attr, cpu, task,
+							      callback, event);
+		if (IS_ERR(perf_event)) {
+			int err = PTR_ERR(perf_event);
+			kp_error(ks, "unable register perf event: "
+				     "[cpu: %d; id: %d; err: %d]\n",
+				     cpu, attr->config, err);
+			kfree(event);
+			return err;
+		}
+
+		if (attr->type == PERF_TYPE_TRACEPOINT) {
+			const char *name = perf_event->tp_event->name;
+			kp_verbose_printf(ks, "enable perf event: "
+					      "[cpu: %d; id: %d; name: %s; "
+					      "filter: %s; pid: %d]\n",
+					      cpu, attr->config, name, filter,
+					      task ? task_tgid_vnr(task) : -1);
+		} else if (attr->type == PERF_TYPE_SOFTWARE &&
+			 attr->config == PERF_COUNT_SW_CPU_CLOCK) {
+			kp_verbose_printf(ks, "enable profile event: "
+					      "[cpu: %d; sample_period: %d]\n",
+					      cpu, attr->sample_period);
+		} else {
+			kp_verbose_printf(ks, "unknown perf event type\n");
+		}
+
+		event->perf = perf_event;
+		INIT_LIST_HEAD(&event->list);
+		list_add_tail(&event->list, &G(ks)->events_head);
+
+		if (init_event_fields(ks, event)) {
+			kp_error(ks, "unable init event fields id %d\n",
+					attr->config);
+			perf_event_release_kernel(event->perf);
+			list_del(&event->list);
+			kfree(event);
+			return ret;
+		}
+
+		if (!filter)
+			continue;
+
+		ret = kp_ftrace_profile_set_filter(perf_event, attr->config,
+						   filter);
+		if (ret) {
+			kp_error(ks, "unable set event filter: "
+				     "[id: %d; filter: %s; ret: %d]\n",
+				     attr->config, filter, ret);
+			perf_event_release_kernel(event->perf);
+			list_del(&event->list);
+			kfree(event);
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
+/*
+ * Ignore function proto in here, just use first argument.
+ */
+static void probe_callback(void *__data)
+{
+	struct ktap_event *event = __data;
+	ktap_state_t *ks = event->ks;
+	struct ktap_event_data e;
+	struct pt_regs regs; /* pt_regs maybe is large for stack */
+	int rctx;
+
+	if (unlikely(ks->stop))
+		return;
+
+	rctx = get_recursion_context(ks);
+	if (unlikely(rctx < 0))
+		return;
+
+	perf_fetch_caller_regs(&regs);
+
+	e.event = event;
+	e.regs = &regs;
+	e.argstr = NULL;
+
+	call_probe_closure(ks, event->fn, &e, rctx);
+
+	put_recursion_context(ks, rctx);
+}
+
+/*
+ * syscall events handling
+ */
+
+static DEFINE_MUTEX(syscall_trace_lock);
+static DECLARE_BITMAP(enabled_enter_syscalls, NR_syscalls);
+static DECLARE_BITMAP(enabled_exit_syscalls, NR_syscalls);
+static int sys_refcount_enter;
+static int sys_refcount_exit;
+
+static int get_syscall_num(const char *name)
+{
+	int i;
+
+	for (i = 0; i < NR_syscalls; i++) {
+		if (syscalls_metadata[i] &&
+		    !strcmp(name, syscalls_metadata[i]->name + 4))
+			return i;
+	}
+	return -1;
+}
+
+static void trace_syscall_enter(void *data, struct pt_regs *regs, long id)
+{
+	struct ktap_event *event = data;
+	ktap_state_t *ks = event->ks;
+	struct ktap_event_data e;
+	int syscall_nr;
+	int rctx;
+
+	if (unlikely(ks->stop))
+		return;
+
+	syscall_nr = syscall_get_nr(current, regs);
+	if (unlikely(syscall_nr < 0))
+		return;
+	if (!test_bit(syscall_nr, enabled_enter_syscalls))
+		return;
+
+	rctx = get_recursion_context(ks);
+	if (unlikely(rctx < 0))
+		return;
+
+	e.event = event;
+	e.regs = regs;
+	e.argstr = NULL;
+
+	call_probe_closure(ks, event->fn, &e, rctx);
+
+	put_recursion_context(ks, rctx);
+}
+
+static void trace_syscall_exit(void *data, struct pt_regs *regs, long id)
+{
+	struct ktap_event *event = data;
+	ktap_state_t *ks = event->ks;
+	struct ktap_event_data e;
+	int syscall_nr;
+	int rctx;
+
+	syscall_nr = syscall_get_nr(current, regs);
+	if (unlikely(syscall_nr < 0))
+		return;
+	if (!test_bit(syscall_nr, enabled_exit_syscalls))
+		return;
+
+	if (unlikely(ks->stop))
+		return;
+
+	rctx = get_recursion_context(ks);
+	if (unlikely(rctx < 0))
+		return;
+
+	e.event = event;
+	e.regs = regs;
+	e.argstr = NULL;
+
+	call_probe_closure(ks, event->fn, &e, rctx);
+
+	put_recursion_context(ks, rctx);
+}
+
+/* called in dry-run mode, purpose for compare overhead with normal vm call */
+static void dry_run_callback(void *data, struct pt_regs *regs, long id)
+{
+
+}
+
+static void init_syscall_event_fields(struct ktap_event *event, int is_enter)
+{
+	struct ftrace_event_call *event_call;
+	struct ktap_event_field *event_fields = &event->fields[0];
+	struct syscall_metadata *meta = syscalls_metadata[event->syscall_nr];
+	int idx = 0;
+
+	event_call = is_enter ? meta->enter_event : meta->exit_event;
+
+	event_fields[0].type = KTAP_EVENT_FIELD_TYPE_CONST;
+	event_fields[0].offset = event->syscall_nr;
+
+	if (!is_enter) {
+#ifdef CONFIG_X86_64
+		event_fields[1].type = KTAP_EVENT_FIELD_TYPE_REGESTER;
+		event_fields[1].offset = offsetof(struct pt_regs, ax);
+#endif
+		return;
+	}
+
+	while (idx++ < meta->nb_args) {
+		event_fields[idx].type = KTAP_EVENT_FIELD_TYPE_REGESTER;
+#ifdef CONFIG_X86_64
+		switch (idx) {
+		case 1:
+			event_fields[idx].offset = offsetof(struct pt_regs, di);
+			break;
+		case 2:
+			event_fields[idx].offset = offsetof(struct pt_regs, si);
+			break;
+		case 3:
+			event_fields[idx].offset = offsetof(struct pt_regs, dx);
+			break;
+		case 4:
+			event_fields[idx].offset =
+						offsetof(struct pt_regs, r10);
+			break;
+		case 5:
+			event_fields[idx].offset = offsetof(struct pt_regs, r8);
+			break;
+		case 6:
+			event_fields[idx].offset = offsetof(struct pt_regs, r9);
+			break;
+		}
+#else
+#error "don't support syscall tracepoint event register access in this arch, "
+	"use 'trace syscalls:* {}' instead"
+#endif
+	}
+
+	/* init all rest fields as NIL */
+	while (idx < 9)
+		event_fields[idx++].type = KTAP_EVENT_FIELD_TYPE_NIL;
+}
+
+static int syscall_event_register(ktap_state_t *ks, const char *event_name,
+				  struct ktap_event *event)
+{
+	int syscall_nr = 0, is_enter = 0;
+	void *callback = NULL;
+	int ret = 0;
+
+	if (!strncmp(event_name, "sys_enter_", 10)) {
+		is_enter = 1;
+		event->type = KTAP_EVENT_TYPE_SYSCALL_ENTER;
+		syscall_nr = get_syscall_num(event_name + 10);
+		callback = trace_syscall_enter;
+	} else if (!strncmp(event_name, "sys_exit_", 9)) {
+		is_enter = 0;
+		event->type = KTAP_EVENT_TYPE_SYSCALL_EXIT;
+		syscall_nr = get_syscall_num(event_name + 9);
+		callback = trace_syscall_exit;
+	}
+	
+	if (G(ks)->parm->dry_run)
+		callback = dry_run_callback;
+
+	if (syscall_nr < 0)
+		return -1;
+
+	event->syscall_nr = syscall_nr;
+
+	init_syscall_event_fields(event, is_enter);
+
+	mutex_lock(&syscall_trace_lock);
+	if (is_enter) {
+		if (!sys_refcount_enter)
+			ret = register_trace_sys_enter(callback, event);
+		if (!ret) {
+			set_bit(syscall_nr, enabled_enter_syscalls);
+			sys_refcount_enter++;
+		}
+	} else {
+		if (!sys_refcount_exit)
+			ret = register_trace_sys_exit(callback, event);
+		if (!ret) {
+			set_bit(syscall_nr, enabled_exit_syscalls);
+			sys_refcount_exit++;
+		}
+	}
+	mutex_unlock(&syscall_trace_lock);
+
+	return ret;
+}
+
+static int syscall_event_unregister(ktap_state_t *ks, struct ktap_event *event)
+{
+	int ret = 0;
+	void *callback;
+	
+	if (event->type == KTAP_EVENT_TYPE_SYSCALL_ENTER)
+		callback = trace_syscall_enter;
+	else
+		callback = trace_syscall_exit;
+
+	if (G(ks)->parm->dry_run)
+		callback = dry_run_callback;
+
+	mutex_lock(&syscall_trace_lock);
+	if (event->type == KTAP_EVENT_TYPE_SYSCALL_ENTER) {
+		sys_refcount_enter--;
+        	clear_bit(event->syscall_nr, enabled_enter_syscalls);
+        	if (!sys_refcount_enter)
+                	unregister_trace_sys_enter(callback, event);
+	} else {
+		sys_refcount_exit--;
+        	clear_bit(event->syscall_nr, enabled_exit_syscalls);
+        	if (!sys_refcount_exit)
+                	unregister_trace_sys_exit(callback, event);
+	}
+	mutex_unlock(&syscall_trace_lock);
+
+	return ret;
+}
+
+/*
+ * Register tracepoint event directly, not based on perf callback
+ *
+ * This tracing method would be more faster than perf callback,
+ * because it won't need to write trace data into any temp buffer,
+ * and code path is much shorter than perf callback.
+ */
+int kp_event_create_tracepoint(ktap_state_t *ks, const char *event_name,
+			       ktap_func_t *fn)
+{
+	struct ktap_event *event;
+	void *callback = probe_callback;
+	int is_syscall = 0;
+	int ret;
+
+	if (G(ks)->parm->dry_run)
+		callback = NULL;
+
+	if (!strncmp(event_name, "sys_enter_", 10) ||
+	    !strncmp(event_name, "sys_exit_", 9))
+		is_syscall = 1;
+
+	event = kzalloc(sizeof(struct ktap_event), GFP_KERNEL);
+	if (!event)
+		return -ENOMEM;
+
+	event->ks = ks;
+	event->fn = fn;
+	event->name = kp_str_newz(ks, event_name);
+	if (unlikely(!event->name)) {
+		kfree(event);
+		return -ENOMEM;
+	}
+
+	INIT_LIST_HEAD(&event->list);
+	list_add_tail(&event->list, &G(ks)->events_head);
+
+	if (is_syscall) {
+		ret = syscall_event_register(ks, event_name, event);
+	} else {
+		event->type = KTAP_EVENT_TYPE_TRACEPOINT;
+		ret = tracepoint_probe_register(event_name, callback, event);
+	}
+
+	if (ret) {
+		kp_error(ks, "register tracepoint %s failed, ret: %d\n",
+				event_name, ret);
+		list_del(&event->list);
+		kfree(event);
+		return ret;
+	}
+	return 0;
+}
+
+/* kprobe handler */
+static int __kprobes pre_handler_kprobe(struct kprobe *p, struct pt_regs *regs)
+{
+	struct ktap_event *event = container_of(p, struct ktap_event, kp);
+	ktap_state_t *ks = event->ks;
+	struct ktap_event_data e;
+	int rctx;
+
+	if (unlikely(ks->stop))
+		return 0;
+
+	rctx = get_recursion_context(ks);
+	if (unlikely(rctx < 0))
+		return 0;
+
+	e.event = event;
+	e.regs = regs;
+	e.argstr = NULL;
+
+	call_probe_closure(ks, event->fn, &e, rctx);
+
+	put_recursion_context(ks, rctx);
+	return 0;
+}
+
+/*
+ * Register kprobe event directly, not based on perf callback
+ *
+ * This tracing method would be more faster than perf callback,
+ * because it won't need to write trace data into any temp buffer,
+ * and code path is much shorter than perf callback.
+ */
+int kp_event_create_kprobe(ktap_state_t *ks, const char *event_name,
+			   ktap_func_t *fn)
+{
+	struct ktap_event *event;
+	void *callback = pre_handler_kprobe;
+	int ret;
+
+	if (G(ks)->parm->dry_run)
+		callback = NULL;
+
+	event = kzalloc(sizeof(struct ktap_event), GFP_KERNEL);
+	if (!event)
+		return -ENOMEM;
+
+	event->ks = ks;
+	event->fn = fn;
+	event->name = kp_str_newz(ks, event_name);
+	if (unlikely(!event->name)) {
+		kfree(event);
+		return -ENOMEM;
+	}
+
+	INIT_LIST_HEAD(&event->list);
+	list_add_tail(&event->list, &G(ks)->events_head);
+
+	event->type = KTAP_EVENT_TYPE_KPROBE;
+
+	event->kp.symbol_name = event_name;
+	event->kp.pre_handler = callback;
+	ret = register_kprobe(&event->kp);
+	if (ret) {
+		kp_error(ks, "register kprobe event %s failed, ret: %d\n",
+				event_name, ret);
+		list_del(&event->list);
+		kfree(event);
+		return ret;
+	}
+	return 0;
+}
+
+
+static void events_destroy(ktap_state_t *ks)
+{
+	struct ktap_event *event;
+	struct list_head *tmp, *pos;
+	struct list_head *head = &G(ks)->events_head;
+
+	list_for_each(pos, head) {
+		event = container_of(pos, struct ktap_event,
+					   list);
+		if (event->type == KTAP_EVENT_TYPE_PERF)
+			perf_event_release_kernel(event->perf);
+		else if (event->type == KTAP_EVENT_TYPE_TRACEPOINT)
+			tracepoint_probe_unregister(getstr(event->name),
+						    probe_callback, event);
+		else if (event->type == KTAP_EVENT_TYPE_SYSCALL_ENTER ||
+			 event->type == KTAP_EVENT_TYPE_SYSCALL_EXIT )
+			syscall_event_unregister(ks, event);
+		else if (event->type == KTAP_EVENT_TYPE_KPROBE)
+			unregister_kprobe(&event->kp);
+        }
+       	/*
+	 * Ensure our callback won't be called anymore. The buffers
+	 * will be freed after that.
+	 */
+	tracepoint_synchronize_unregister();
+
+	list_for_each_safe(pos, tmp, head) {
+		event = container_of(pos, struct ktap_event,
+					   list);
+		list_del(&event->list);
+		kfree(event);
+	}
+}
+
+void kp_events_exit(ktap_state_t *ks)
+{
+	if (!G(ks)->trace_enabled)
+		return;
+
+	events_destroy(ks);
+
+	/* call trace_end_closure after all event unregistered */
+	if ((G(ks)->state != KTAP_ERROR) && G(ks)->trace_end_closure) {
+		G(ks)->state = KTAP_TRACE_END;
+		set_func(ks->top, G(ks)->trace_end_closure);
+		incr_top(ks);
+		kp_vm_call(ks, ks->top - 1, 0);
+		G(ks)->trace_end_closure = NULL;
+	}
+
+	G(ks)->trace_enabled = 0;
+}
+
+int kp_events_init(ktap_state_t *ks)
+{
+	G(ks)->trace_enabled = 1;
+	return 0;
+}
+
diff --git a/kernel/trace/ktap/kp_events.h b/kernel/trace/ktap/kp_events.h
new file mode 100644
index 0000000..b24f723
--- /dev/null
+++ b/kernel/trace/ktap/kp_events.h
@@ -0,0 +1,71 @@
+#ifndef __KTAP_EVENTS_H__
+#define __KTAP_EVENTS_H__
+
+#include <linux/ftrace_event.h>
+#include <trace/syscall.h>
+#include <trace/events/syscalls.h>
+#include <linux/syscalls.h>
+#include <linux/kprobes.h>
+
+enum KTAP_EVENT_FIELD_TYPE {
+	KTAP_EVENT_FIELD_TYPE_INVALID = 0, /* arg type not support yet */
+
+	KTAP_EVENT_FIELD_TYPE_INT,
+	KTAP_EVENT_FIELD_TYPE_LONG,
+	KTAP_EVENT_FIELD_TYPE_STRING,
+
+	KTAP_EVENT_FIELD_TYPE_REGESTER,
+	KTAP_EVENT_FIELD_TYPE_CONST,
+	KTAP_EVENT_FIELD_TYPE_NIL /* arg not exist */
+};
+
+struct ktap_event_field {
+	enum KTAP_EVENT_FIELD_TYPE type;
+	int offset;
+};
+
+enum KTAP_EVENT_TYPE {
+	KTAP_EVENT_TYPE_PERF,
+	KTAP_EVENT_TYPE_TRACEPOINT,
+	KTAP_EVENT_TYPE_SYSCALL_ENTER,
+	KTAP_EVENT_TYPE_SYSCALL_EXIT,
+	KTAP_EVENT_TYPE_KPROBE,
+};
+
+struct ktap_event {
+	struct list_head list;
+	int type;
+	ktap_state_t *ks;
+	ktap_func_t *fn;
+	struct perf_event *perf;
+	int syscall_nr; /* for syscall event */
+	struct ktap_event_field fields[9]; /* arg1..arg9 */
+	ktap_str_t *name; /* intern probename string */
+
+	struct kprobe kp; /* kprobe event */
+};
+
+/* this structure allocate on stack */
+struct ktap_event_data {
+	struct ktap_event *event;
+	struct perf_sample_data *data;
+	struct pt_regs *regs;
+	ktap_str_t *argstr; /* for cache argstr intern string */
+};
+
+int kp_events_init(ktap_state_t *ks);
+void kp_events_exit(ktap_state_t *ks);
+
+int kp_event_create(ktap_state_t *ks, struct perf_event_attr *attr,
+		    struct task_struct *task, const char *filter,
+		    ktap_func_t *fn);
+int kp_event_create_tracepoint(ktap_state_t *ks, const char *event_name,
+			       ktap_func_t *fn);
+
+int kp_event_create_kprobe(ktap_state_t *ks, const char *event_name,
+			   ktap_func_t *fn);
+void kp_event_getarg(ktap_state_t *ks, ktap_val_t *ra, int idx);
+const char *kp_event_tostr(ktap_state_t *ks);
+const ktap_str_t *kp_event_stringify(ktap_state_t *ks);
+
+#endif /* __KTAP_EVENTS_H__ */
-- 
1.8.1.4

