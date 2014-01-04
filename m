Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755214AbaADSXU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jan 2014 13:23:20 -0500
Received: from 221-186-24-89.in-addr.arpa ([89.24.186.221]:18140 "EHLO
	dhcp-26-207.brq.redhat.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755164AbaADSXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jan 2014 13:23:08 -0500
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andi Kleen <ak@linux.jf.intel.com>
Subject: [PATCH RFC v2 1/4] perf/core: IRQ-bound performance events
Date: Sat,  4 Jan 2014 19:22:33 +0100
Message-Id: <e4ec06b150b645818f00743e32d3ec320de1b803.1388858996.git.agordeev@redhat.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <cover.1388858996.git.agordeev@redhat.com>
References: <cover.1388858996.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 include/linux/irq.h             |   10 +
 include/linux/irqdesc.h         |    4 +
 include/linux/perf_event.h      |   24 +++
 include/uapi/linux/perf_event.h |   15 ++-
 kernel/events/Makefile          |    2 +-
 kernel/events/core.c            |  176 +++++++++++++++++--
 kernel/events/hardirq.c         |  370 +++++++++++++++++++++++++++++++++++++++
 kernel/irq/handle.c             |    7 +-
 kernel/irq/irqdesc.c            |   15 ++
 9 files changed, 609 insertions(+), 14 deletions(-)
 create mode 100644 kernel/events/hardirq.c

diff --git a/include/linux/irq.h b/include/linux/irq.h
index 7dc1003..c79bbbd 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -632,6 +632,16 @@ static inline int irq_reserve_irq(unsigned int irq)
 # define irq_reg_readl(addr)		readl(addr)
 #endif
 
+#ifdef CONFIG_PERF_EVENTS
+extern void perf_start_hardirq_events(struct irq_desc *desc, int action_nr);
+extern void perf_stop_hardirq_events(struct irq_desc *desc, int action_nr);
+#else
+static inline void
+perf_start_hardirq_events(struct irq_desc *desc, int action_nr)	{ }
+static inline void
+perf_stop_hardirq_events(struct irq_desc *desc, int action_nr)	{ }
+#endif
+
 /**
  * struct irq_chip_regs - register offsets for struct irq_gci
  * @enable:	Enable register offset to reg_base
diff --git a/include/linux/irqdesc.h b/include/linux/irqdesc.h
index 56fb646..00a2759 100644
--- a/include/linux/irqdesc.h
+++ b/include/linux/irqdesc.h
@@ -12,6 +12,7 @@ struct irq_affinity_notify;
 struct proc_dir_entry;
 struct module;
 struct irq_desc;
+struct hardirq_events;
 
 /**
  * struct irq_desc - interrupt descriptor
@@ -68,6 +69,9 @@ struct irq_desc {
 	struct proc_dir_entry	*dir;
 #endif
 	int			parent_irq;
+#ifdef CONFIG_PERF_EVENTS
+	struct hardirq_events __percpu **events;
+#endif
 	struct module		*owner;
 	const char		*name;
 } ____cacheline_internodealigned_in_smp;
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 8f4a70f..8bd7860 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -215,6 +215,12 @@ struct pmu {
 	void (*stop)			(struct perf_event *event, int flags);
 
 	/*
+	 * Start/Stop hardware interrupt context counters present on the PMU.
+	 */
+	void (*start_hardirq)		(struct perf_event *events[], int count); /* optional */
+	void (*stop_hardirq)		(struct perf_event *events[], int count); /* optional */
+
+	/*
 	 * Updates the counter value of the event.
 	 */
 	void (*read)			(struct perf_event *event);
@@ -313,6 +319,11 @@ struct perf_event {
 	struct list_head		sibling_list;
 
 	/*
+	 * List of hardware interrupt context numbers and actions
+	 */
+	struct list_head		hardirq_list;
+
+	/*
 	 * We need storage to track the entries in perf_pmu_migrate_context; we
 	 * cannot use the event_entry because of RCU and we want to keep the
 	 * group in tact which avoids us using the other two entries.
@@ -528,6 +539,12 @@ struct perf_output_handle {
 	int				page;
 };
 
+struct perf_hardirq_param {
+	struct list_head	list;
+	int			irq;
+	unsigned long		mask;
+};
+
 #ifdef CONFIG_PERF_EVENTS
 
 extern int perf_pmu_register(struct pmu *pmu, const char *name, int type);
@@ -635,6 +652,11 @@ static inline int is_software_event(struct perf_event *event)
 	return event->pmu->task_ctx_nr == perf_sw_context;
 }
 
+static inline bool is_hardirq_event(struct perf_event *event)
+{
+	return event->attr.hardirq != 0;
+}
+
 extern struct static_key perf_swevent_enabled[PERF_COUNT_SW_MAX];
 
 extern void __perf_sw_event(u32, u64, struct pt_regs *, u64);
@@ -772,6 +794,8 @@ extern void perf_event_enable(struct perf_event *event);
 extern void perf_event_disable(struct perf_event *event);
 extern int __perf_event_disable(void *info);
 extern void perf_event_task_tick(void);
+extern int perf_event_init_hardirq(void *info);
+extern int perf_event_term_hardirq(void *info);
 #else
 static inline void
 perf_event_task_sched_in(struct task_struct *prev,
diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index e1802d6..a033014 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -301,8 +301,9 @@ struct perf_event_attr {
 				exclude_callchain_kernel : 1, /* exclude kernel callchains */
 				exclude_callchain_user   : 1, /* exclude user callchains */
 				mmap2          :  1, /* include mmap with inode data     */
+				hardirq        :  1,
 
-				__reserved_1   : 40;
+				__reserved_1   : 39;
 
 	union {
 		__u32		wakeup_events;	  /* wakeup every n events */
@@ -348,6 +349,7 @@ struct perf_event_attr {
 #define PERF_EVENT_IOC_SET_OUTPUT	_IO ('$', 5)
 #define PERF_EVENT_IOC_SET_FILTER	_IOW('$', 6, char *)
 #define PERF_EVENT_IOC_ID		_IOR('$', 7, __u64 *)
+#define PERF_EVENT_IOC_SET_HARDIRQ	_IOR('$', 8, __u64 *)
 
 enum perf_event_ioc_flags {
 	PERF_IOC_FLAG_GROUP		= 1U << 0,
@@ -724,6 +726,7 @@ enum perf_callchain_context {
 #define PERF_FLAG_FD_NO_GROUP		(1U << 0)
 #define PERF_FLAG_FD_OUTPUT		(1U << 1)
 #define PERF_FLAG_PID_CGROUP		(1U << 2) /* pid=cgroup id, per-cpu mode only */
+#define PERF_FLAG_PID_HARDIRQ		(1U << 3) /* pid=irq number */
 
 union perf_mem_data_src {
 	__u64 val;
@@ -812,4 +815,14 @@ struct perf_branch_entry {
 		reserved:60;
 };
 
+struct perf_hardirq_disp {
+	__s32				irq_nr;
+	__u64				actions;
+};
+
+struct perf_hardirq_event_disp {
+	__s32				nr_disp;	/* everything if <0 */
+	struct perf_hardirq_disp	disp[0];
+};
+
 #endif /* _UAPI_LINUX_PERF_EVENT_H */
diff --git a/kernel/events/Makefile b/kernel/events/Makefile
index 103f5d1..8b94980 100644
--- a/kernel/events/Makefile
+++ b/kernel/events/Makefile
@@ -2,7 +2,7 @@ ifdef CONFIG_FUNCTION_TRACER
 CFLAGS_REMOVE_core.o = -pg
 endif
 
-obj-y := core.o ring_buffer.o callchain.o
+obj-y := core.o ring_buffer.o callchain.o hardirq.o
 
 obj-$(CONFIG_HAVE_HW_BREAKPOINT) += hw_breakpoint.o
 obj-$(CONFIG_UPROBES) += uprobes.o
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 89d34f9..465ce681 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -118,8 +118,9 @@ static int cpu_function_call(int cpu, int (*func) (void *info), void *info)
 }
 
 #define PERF_FLAG_ALL (PERF_FLAG_FD_NO_GROUP |\
-		       PERF_FLAG_FD_OUTPUT  |\
-		       PERF_FLAG_PID_CGROUP)
+		       PERF_FLAG_FD_OUTPUT |\
+		       PERF_FLAG_PID_CGROUP |\
+		       PERF_FLAG_PID_HARDIRQ)
 
 /*
  * branch priv levels that need permission checks
@@ -3213,10 +3214,46 @@ static void __free_event(struct perf_event *event)
 
 	call_rcu(&event->rcu_head, free_event_rcu);
 }
+
+static int __perf_hardirq_add_disp(struct perf_event *event,
+				   struct perf_hardirq_disp *disp)
+{
+	struct perf_hardirq_param *param = kmalloc_node(sizeof(*param),
+		GFP_KERNEL, cpu_to_node(event->cpu));
+	if (!param)
+		return -ENOMEM;
+
+	param->irq = disp->irq_nr;
+
+	if (disp->actions == (typeof(disp->actions))-1)
+		param->mask = -1;
+	else
+		param->mask = disp->actions;
+
+	list_add(&param->list, &event->hardirq_list);
+
+	return 0;
+}
+
+static void __perf_hardirq_del_disps(struct perf_event *event)
+{
+	struct perf_hardirq_param *param;
+	struct list_head *pos, *next;
+
+	list_for_each_safe(pos, next, &event->hardirq_list) {
+		param = list_entry(pos, typeof(*param), list);
+		list_del(pos);
+		kfree(param);
+	}
+}
+
 static void free_event(struct perf_event *event)
 {
 	irq_work_sync(&event->pending);
 
+	cpu_function_call(event->cpu, perf_event_term_hardirq, event);
+	__perf_hardirq_del_disps(event);
+
 	unaccount_event(event);
 
 	if (event->rb) {
@@ -3590,6 +3627,7 @@ static inline int perf_fget_light(int fd, struct fd *p)
 static int perf_event_set_output(struct perf_event *event,
 				 struct perf_event *output_event);
 static int perf_event_set_filter(struct perf_event *event, void __user *arg);
+static int perf_event_set_hardirq(struct perf_event *event, void __user *arg);
 
 static long perf_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
@@ -3644,6 +3682,9 @@ static long perf_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	case PERF_EVENT_IOC_SET_FILTER:
 		return perf_event_set_filter(event, (void __user *)arg);
 
+	case PERF_EVENT_IOC_SET_HARDIRQ:
+		return perf_event_set_hardirq(event, (void __user *)arg);
+
 	default:
 		return -ENOTTY;
 	}
@@ -6248,6 +6289,10 @@ static void perf_pmu_nop_void(struct pmu *pmu)
 {
 }
 
+static void perf_pmu_nop_void_arg1_arg2(struct perf_event *events[], int count)
+{
+}
+
 static int perf_pmu_nop_int(struct pmu *pmu)
 {
 	return 0;
@@ -6511,6 +6556,11 @@ got_cpu_context:
 		pmu->pmu_disable = perf_pmu_nop_void;
 	}
 
+	if (!pmu->start_hardirq) {
+		pmu->start_hardirq = perf_pmu_nop_void_arg1_arg2;
+		pmu->stop_hardirq = perf_pmu_nop_void_arg1_arg2;
+	}
+
 	if (!pmu->event_idx)
 		pmu->event_idx = perf_event_idx_default;
 
@@ -6668,6 +6718,7 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
 	INIT_LIST_HEAD(&event->group_entry);
 	INIT_LIST_HEAD(&event->event_entry);
 	INIT_LIST_HEAD(&event->sibling_list);
+	INIT_LIST_HEAD(&event->hardirq_list);
 	INIT_LIST_HEAD(&event->rb_entry);
 	INIT_LIST_HEAD(&event->active_entry);
 
@@ -6977,6 +7028,7 @@ SYSCALL_DEFINE5(perf_event_open,
 	struct fd group = {NULL, 0};
 	struct task_struct *task = NULL;
 	struct pmu *pmu;
+	int hardirq = -1;
 	int event_fd;
 	int move_group = 0;
 	int err;
@@ -6985,6 +7037,27 @@ SYSCALL_DEFINE5(perf_event_open,
 	if (flags & ~PERF_FLAG_ALL)
 		return -EINVAL;
 
+	if ((flags & (PERF_FLAG_PID_CGROUP | PERF_FLAG_PID_HARDIRQ)) ==
+	    (PERF_FLAG_PID_CGROUP | PERF_FLAG_PID_HARDIRQ))
+		return -EINVAL;
+
+	/*
+	 * In irq mode, the pid argument is used to pass irq number.
+	 */
+	if (flags & PERF_FLAG_PID_HARDIRQ) {
+		hardirq = pid;
+		pid = -1;
+	}
+
+	/*
+	 * In cgroup mode, the pid argument is used to pass the fd
+	 * opened to the cgroup directory in cgroupfs. The cpu argument
+	 * designates the cpu on which to monitor threads from that
+	 * cgroup.
+	 */
+	if ((flags & PERF_FLAG_PID_CGROUP) && (pid == -1 || cpu == -1))
+		return -EINVAL;
+
 	err = perf_copy_attr(attr_uptr, &attr);
 	if (err)
 		return err;
@@ -6999,15 +7072,6 @@ SYSCALL_DEFINE5(perf_event_open,
 			return -EINVAL;
 	}
 
-	/*
-	 * In cgroup mode, the pid argument is used to pass the fd
-	 * opened to the cgroup directory in cgroupfs. The cpu argument
-	 * designates the cpu on which to monitor threads from that
-	 * cgroup.
-	 */
-	if ((flags & PERF_FLAG_PID_CGROUP) && (pid == -1 || cpu == -1))
-		return -EINVAL;
-
 	event_fd = get_unused_fd();
 	if (event_fd < 0)
 		return event_fd;
@@ -7874,6 +7938,96 @@ static void perf_event_exit_cpu(int cpu)
 static inline void perf_event_exit_cpu(int cpu) { }
 #endif
 
+static int __perf_hardirq_check_disp(struct perf_hardirq_disp *disp)
+{
+	struct irq_desc *desc = irq_to_desc(disp->irq_nr);
+	struct irqaction *action;
+	int nr_actions = 0;
+	unsigned long flags;
+
+	if (!desc)
+		return -ENOENT;
+
+	if (!disp->actions)
+		return -EINVAL;
+
+	/*
+	 * -1 means all actions
+	 */
+	if (disp->actions == (typeof(disp->actions))-1)
+		return 0;
+
+	/*
+	 * Check actions existence
+	 */
+	raw_spin_lock_irqsave(&desc->lock, flags);
+	for (action = desc->action; action; action = action->next)
+		nr_actions++;
+	raw_spin_unlock_irqrestore(&desc->lock, flags);
+
+	if (!nr_actions)
+		return -ENOENT;
+
+	if (__fls(disp->actions) + 1 > nr_actions)
+		return -EINVAL;
+
+	return 0;
+}
+
+static int perf_event_set_hardirq(struct perf_event *event, void __user *arg)
+{
+	struct perf_hardirq_event_disp edisp;
+	struct perf_hardirq_disp idisp;
+	struct perf_hardirq_disp __user *user;
+	struct perf_hardirq_param *param;
+	int ret = 0;
+	int i;
+
+	if (copy_from_user(&edisp, arg, sizeof(edisp.nr_disp)))
+		return -EFAULT;
+
+	/*
+	 * TODO Run counters for all actions on all IRQs
+	 */
+	if (edisp.nr_disp == (typeof(edisp.nr_disp))-1)
+		return -EINVAL;
+
+	user = arg + offsetof(typeof(edisp), disp);
+	for (i = 0; i < edisp.nr_disp; i++) {
+		if (copy_from_user(&idisp, &user[i], sizeof(idisp))) {
+			ret = -EFAULT;
+			goto err;
+		}
+
+		/*
+		 * Multiple entries against one IRQ are not allowed
+		 */
+		list_for_each_entry(param, &event->hardirq_list, list) {
+			if (param->irq == idisp.irq_nr)
+				return -EINVAL;
+		}
+
+		ret = __perf_hardirq_check_disp(&idisp);
+		if (ret)
+			goto err;
+
+		ret = __perf_hardirq_add_disp(event, &idisp);
+		if (ret)
+			goto err;
+	}
+
+	ret = cpu_function_call(event->cpu, perf_event_init_hardirq, event);
+	if (ret)
+		goto err;
+
+	return 0;
+
+err:
+	__perf_hardirq_del_disps(event);
+
+	return ret;
+}
+
 static int
 perf_reboot(struct notifier_block *notifier, unsigned long val, void *v)
 {
diff --git a/kernel/events/hardirq.c b/kernel/events/hardirq.c
new file mode 100644
index 0000000..f857be3
--- /dev/null
+++ b/kernel/events/hardirq.c
@@ -0,0 +1,370 @@
+/*
+ * linux/kernel/events/hardirq.c
+ *
+ * Copyright (C) 2012-2014 Red Hat, Inc., Alexander Gordeev
+ *
+ * This file contains the code for h/w interrupt context performance counters
+ */
+
+#include <linux/perf_event.h>
+#include <linux/irq.h>
+#include <linux/percpu.h>
+#include <linux/bitops.h>
+#include <linux/slab.h>
+#include <linux/sort.h>
+
+struct hardirq_event {
+	unsigned long		mask;		/* action numbers to count on */
+	struct perf_event	*event;		/* event to count */
+};
+
+struct hardirq_events {
+	int			nr_events;	/* number of events in array */
+	struct hardirq_event	events[0];	/* array of events to count */
+};
+
+struct active_events {
+	int			nr_events;	/* number of allocated events */
+	int			nr_active;	/* number of events to count */
+	struct perf_event	*events[0];	/* array of events to count */
+};
+
+DEFINE_PER_CPU(struct active_events *, active_events);
+DEFINE_PER_CPU(int, total_events);
+
+static struct hardirq_events *alloc_desc_events(int cpu, int count)
+{
+	struct hardirq_events *events;
+	size_t size;
+
+	size = offsetof(typeof(*events), events) +
+	       count * sizeof(events->events[0]);
+	events = kmalloc_node(size, GFP_KERNEL, cpu_to_node(cpu));
+	if (unlikely(!events))
+		return NULL;
+
+	events->nr_events = count;
+
+	return events;
+}
+
+static void free_desc_events(struct hardirq_events *events)
+{
+	kfree(events);
+}
+
+static struct active_events *alloc_active_events(int cpu, int count)
+{
+	struct active_events *active;
+	size_t size;
+
+	size = offsetof(typeof(*active), events) +
+	       count * sizeof(active->events[0]);
+	active = kmalloc_node(size, GFP_KERNEL, cpu_to_node(cpu));
+	if (unlikely(!active))
+		return NULL;
+
+	active->nr_events = count;
+
+	return active;
+}
+
+static void free_active_events(struct active_events *active)
+{
+	kfree(active);
+}
+
+static int compare_pmus(const void *event1, const void *event2)
+{
+	return strcmp(((const struct hardirq_event *)event1)->event->pmu->name,
+		      ((const struct hardirq_event *)event2)->event->pmu->name);
+}
+
+static int max_active_events(struct hardirq_events *events)
+{
+	/*
+	 * TODO Count number of events per action and return the maximum
+	 */
+	return events->nr_events;
+}
+
+static int add_event(struct perf_event *event, int irq, unsigned long mask)
+{
+	struct irq_desc *desc = irq_to_desc(irq);
+	struct hardirq_events __percpu **events_ptr;
+	struct hardirq_events *events, *events_tmp = NULL;
+	struct active_events __percpu *active;
+	struct active_events *active_tmp = NULL;
+	int cpu, max_active, nr_events;
+	unsigned long flags;
+	int ret = 0;
+
+	if (!desc)
+		return -ENOENT;
+
+	cpu = get_cpu();
+	BUG_ON(cpu != event->cpu);
+
+	events_ptr = this_cpu_ptr(desc->events);
+	events = *events_ptr;
+
+	nr_events = events ? events->nr_events : 0;
+	events_tmp = alloc_desc_events(cpu, nr_events + 1);
+	if (!events_tmp) {
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	memmove(events_tmp->events, events->events,
+		nr_events * sizeof(events_tmp->events[0]));
+
+	events_tmp->events[nr_events].event = event;
+	events_tmp->events[nr_events].mask = mask;
+
+	/*
+	 * Group events that belong to same PMUs in contiguous sub-arrays
+	 */
+	sort(events_tmp->events, events_tmp->nr_events,
+	     sizeof(events_tmp->events[0]), compare_pmus, NULL);
+
+	max_active = max_active_events(events_tmp);
+	active = this_cpu_read(active_events);
+
+	if (!active || max_active > active->nr_active) {
+		active_tmp = alloc_active_events(cpu, max_active);
+		if (!active_tmp) {
+			ret = -ENOMEM;
+			goto err;
+		}
+	}
+
+	raw_spin_lock_irqsave(&desc->lock, flags);
+
+	swap(events, events_tmp);
+	*events_ptr = events;
+
+	if (active_tmp) {
+		swap(active, active_tmp);
+		this_cpu_write(active_events, active);
+	}
+
+	__this_cpu_inc(total_events);
+
+	raw_spin_unlock_irqrestore(&desc->lock, flags);
+
+err:
+	put_cpu();
+
+	free_active_events(active_tmp);
+	free_desc_events(events_tmp);
+
+	return ret;
+}
+
+static int del_event(struct perf_event *event, int irq)
+{
+	struct irq_desc *desc = irq_to_desc(irq);
+	struct hardirq_events __percpu **events_ptr;
+	struct hardirq_events *events, *events_tmp = NULL;
+	struct active_events __percpu *active;
+	struct active_events *active_tmp = NULL;
+	int cpu, i, nr_events;
+	unsigned long flags;
+	int ret = 0;
+
+	if (!desc)
+		return -ENOENT;
+
+	cpu = get_cpu();
+	BUG_ON(cpu != event->cpu);
+
+	events_ptr = this_cpu_ptr(desc->events);
+	events = *events_ptr;
+
+	nr_events = events->nr_events;
+	for (i = 0; i < nr_events; i++) {
+		if (events->events[i].event == event)
+			break;
+	}
+
+	if (i >= nr_events) {
+		ret = -ENOENT;
+		goto err;
+	}
+
+	if (nr_events > 1) {
+		events_tmp = alloc_desc_events(cpu, nr_events - 1);
+		if (!events_tmp) {
+			ret = -ENOMEM;
+			goto err;
+		}
+
+		memmove(&events_tmp->events[0], &events->events[0],
+			i * sizeof(events->events[0]));
+		memmove(&events_tmp->events[i], &events->events[i + 1],
+			(nr_events - i - 1) * sizeof(events->events[0]));
+	}
+
+	active = this_cpu_read(active_events);
+
+	raw_spin_lock_irqsave(&desc->lock, flags);
+
+	if (!__this_cpu_dec_return(total_events)) {
+		swap(active, active_tmp);
+		this_cpu_write(active_events, active);
+	}
+
+	swap(events, events_tmp);
+	*events_ptr = events;
+
+	raw_spin_unlock_irqrestore(&desc->lock, flags);
+
+err:
+	put_cpu();
+
+	free_active_events(active_tmp);
+	free_desc_events(events_tmp);
+
+	return ret;
+}
+
+int perf_event_init_hardirq(void *info)
+{
+	struct perf_event *event = info;
+	struct perf_hardirq_param *param, *param_tmp;
+	int ret = 0;
+
+	list_for_each_entry(param, &event->hardirq_list, list) {
+		ret = add_event(event, param->irq, param->mask);
+		if (ret)
+			break;
+	}
+
+	if (ret) {
+		list_for_each_entry(param_tmp, &event->hardirq_list, list) {
+			if (param == param_tmp)
+				break;
+			del_event(event, param_tmp->irq);
+		}
+	}
+
+	WARN_ON(ret);
+	return ret;
+}
+
+int perf_event_term_hardirq(void *info)
+{
+	struct perf_event *event = info;
+	struct perf_hardirq_param *param;
+	int ret_tmp, ret = 0;
+
+	list_for_each_entry(param, &event->hardirq_list, list) {
+		ret_tmp = del_event(event, param->irq);
+		if (!ret)
+			ret = ret_tmp;
+	}
+
+	WARN_ON(ret);
+	return ret;
+}
+
+static void update_active_events(struct active_events *active,
+				 struct hardirq_events *events,
+				 int action_nr)
+{
+	int i, nr_active = 0;
+
+	for (i = 0; i < events->nr_events; i++) {
+		struct hardirq_event *event = &events->events[i];
+
+		if (test_bit(action_nr, &event->mask)) {
+			active->events[nr_active] = event->event;
+			nr_active++;
+		}
+	}
+
+	active->nr_active = nr_active;
+}
+
+int perf_alloc_hardirq_events(struct irq_desc *desc)
+{
+	desc->events = alloc_percpu(struct hardirq_events*);
+	if (!desc->events)
+		return -ENOMEM;
+	return 0;
+}
+
+void perf_free_hardirq_events(struct irq_desc *desc)
+{
+	int cpu;
+
+	for_each_possible_cpu(cpu)
+		BUG_ON(*per_cpu_ptr(desc->events, cpu));
+
+	free_percpu(desc->events);
+}
+
+static void start_stop_events(struct perf_event *events[], int count, bool start)
+{
+	/*
+	 * All events in the list must belong to the same PMU
+	 */
+	struct pmu *pmu = events[0]->pmu;
+
+	if (start)
+		pmu->start_hardirq(events, count);
+	else
+		pmu->stop_hardirq(events, count);
+}
+
+static void start_stop_active(struct active_events *active, bool start)
+{
+	struct perf_event **first, **last;
+	int i;
+
+	first = last = active->events;
+
+	for (i = 0; i < active->nr_active; i++) {
+		if ((*last)->pmu != (*first)->pmu) {
+			start_stop_events(first, last - first, start);
+			first = last;
+		}
+		last++;
+	}
+
+	start_stop_events(first, last - first, start);
+}
+
+static void start_stop_desc(struct irq_desc *desc, int action_nr, bool start)
+{
+	struct hardirq_events __percpu *events;
+	struct active_events __percpu *active;
+
+	events = *__this_cpu_ptr(desc->events);
+	if (likely(!events))
+		return;
+
+	active = __this_cpu_read(active_events);
+
+	/*
+	 * Assume events to run do not change between start and stop,
+	 * thus no reason to update active events when stopping.
+	 */
+	if (start)
+		update_active_events(active, events, action_nr);
+
+	if (!active->nr_active)
+		return;
+
+	start_stop_active(active, start);
+}
+
+void perf_start_hardirq_events(struct irq_desc *desc, int action_nr)
+{
+	start_stop_desc(desc, action_nr, true);
+}
+
+void perf_stop_hardirq_events(struct irq_desc *desc, int action_nr)
+{
+	start_stop_desc(desc, action_nr, false);
+}
diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index 131ca17..7feab55 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -133,13 +133,17 @@ irqreturn_t
 handle_irq_event_percpu(struct irq_desc *desc, struct irqaction *action)
 {
 	irqreturn_t retval = IRQ_NONE;
-	unsigned int flags = 0, irq = desc->irq_data.irq;
+	unsigned int flags = 0, irq = desc->irq_data.irq, action_nr = 0;
 
 	do {
 		irqreturn_t res;
 
 		trace_irq_handler_entry(irq, action);
+		perf_start_hardirq_events(desc, action_nr);
+
 		res = action->handler(irq, action->dev_id);
+
+		perf_stop_hardirq_events(desc, action_nr);
 		trace_irq_handler_exit(irq, action, res);
 
 		if (WARN_ONCE(!irqs_disabled(),"irq %u handler %pF enabled interrupts\n",
@@ -170,6 +174,7 @@ handle_irq_event_percpu(struct irq_desc *desc, struct irqaction *action)
 
 		retval |= res;
 		action = action->next;
+		action_nr++;
 	} while (action);
 
 	add_interrupt_randomness(irq, flags);
diff --git a/kernel/irq/irqdesc.c b/kernel/irq/irqdesc.c
index 192a302..cd02b29 100644
--- a/kernel/irq/irqdesc.c
+++ b/kernel/irq/irqdesc.c
@@ -131,6 +131,14 @@ static void free_masks(struct irq_desc *desc)
 static inline void free_masks(struct irq_desc *desc) { }
 #endif
 
+#ifdef CONFIG_PERF_EVENTS
+extern int perf_alloc_hardirq_events(struct irq_desc *desc);
+extern void perf_free_hardirq_events(struct irq_desc *desc);
+#else
+static inline int perf_alloc_hardirq_events(struct irq_desc *desc) { return 0; }
+static inline void perf_free_hardirq_events(struct irq_desc *desc) { }
+#endif
+
 static struct irq_desc *alloc_desc(int irq, int node, struct module *owner)
 {
 	struct irq_desc *desc;
@@ -147,6 +155,10 @@ static struct irq_desc *alloc_desc(int irq, int node, struct module *owner)
 	if (alloc_masks(desc, gfp, node))
 		goto err_kstat;
 
+	if (perf_alloc_hardirq_events(desc))
+		goto err_masks;
+
+
 	raw_spin_lock_init(&desc->lock);
 	lockdep_set_class(&desc->lock, &irq_desc_lock_class);
 
@@ -154,6 +166,8 @@ static struct irq_desc *alloc_desc(int irq, int node, struct module *owner)
 
 	return desc;
 
+err_masks:
+	free_masks(desc);
 err_kstat:
 	free_percpu(desc->kstat_irqs);
 err_desc:
@@ -171,6 +185,7 @@ static void free_desc(unsigned int irq)
 	delete_irq_desc(irq);
 	mutex_unlock(&sparse_irq_lock);
 
+	perf_free_hardirq_events(desc);
 	free_masks(desc);
 	free_percpu(desc->kstat_irqs);
 	kfree(desc);
-- 
1.7.7.6

