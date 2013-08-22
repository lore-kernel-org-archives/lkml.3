Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335Ab3HVOOr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 10:14:47 -0400
Received: from mail-bk0-f45.google.com ([209.85.214.45]:44630 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331Ab3HVOOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 10:14:44 -0400
From: Robert Richter <rric@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Borislav Petkov <bp@alien8.de>, Jiri Olsa <jolsa@redhat.com>,
        linux-kernel@vger.kernel.org,
        Robert Richter <robert.richter@linaro.org>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Robert Richter <rric@kernel.org>
Subject: [PATCH v3 05/12] perf: Add persistent events
Date: Thu, 22 Aug 2013 16:13:20 +0200
Message-Id: <1377180807-12758-6-git-send-email-rric@kernel.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1377180807-12758-1-git-send-email-rric@kernel.org>
References: <1377180807-12758-1-git-send-email-rric@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Richter <robert.richter@linaro.org>

Add the needed pieces for persistent events which makes them
process-agnostic. Also, make their buffers read-only when mmaping them
from userspace.

Add a barebones implementation for registering persistent events with
perf. For that, we don't destroy the buffers when they're unmapped;
also, we map them read-only so that multiple agents can access them.

Also, we allocate the event buffers at event init time and not at mmap
time so that we can log samples into them regardless of whether there
are readers in userspace or not.

Multiple events from different cpus may map to a single persistent
event entry which has a unique identifier. The identifier allows to
access the persistent event with the perf_event_open() syscall. For
this the new event type PERF_TYPE_PERSISTENT must be set with its id
specified in attr.config. Currently there is only support for per-cpu
events. Also, root access is required.

Since the buffers are shared, the set_output ioctl may not be used in
conjunction with persistent events.

This patch only supports trace_points, support for all event types is
implemented in a later patch.

Based on patch set from Borislav Petkov <bp@alien8.de>.

Cc: Borislav Petkov <bp@alien8.de>
Cc: Fengguang Wu <fengguang.wu@intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Robert Richter <robert.richter@linaro.org>
Signed-off-by: Robert Richter <rric@kernel.org>
---
 include/linux/perf_event.h      |  12 ++-
 include/uapi/linux/perf_event.h |   4 +-
 kernel/events/Makefile          |   2 +-
 kernel/events/core.c            |  37 +++++--
 kernel/events/internal.h        |   2 +
 kernel/events/persistent.c      | 221 ++++++++++++++++++++++++++++++++++++++++
 6 files changed, 266 insertions(+), 12 deletions(-)
 create mode 100644 kernel/events/persistent.c

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index c43f6ea..1a62a25 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -436,6 +436,8 @@ struct perf_event {
 	struct perf_cgroup		*cgrp; /* cgroup event is attach to */
 	int				cgrp_defer_enabled;
 #endif
+	struct list_head		pevent_entry;	/* persistent event */
+	int				pevent_id;
 
 #endif /* CONFIG_PERF_EVENTS */
 };
@@ -765,7 +767,7 @@ extern void perf_event_enable(struct perf_event *event);
 extern void perf_event_disable(struct perf_event *event);
 extern int __perf_event_disable(void *info);
 extern void perf_event_task_tick(void);
-#else
+#else /* !CONFIG_PERF_EVENTS */
 static inline void
 perf_event_task_sched_in(struct task_struct *prev,
 			 struct task_struct *task)			{ }
@@ -805,7 +807,7 @@ static inline void perf_event_enable(struct perf_event *event)		{ }
 static inline void perf_event_disable(struct perf_event *event)		{ }
 static inline int __perf_event_disable(void *info)			{ return -1; }
 static inline void perf_event_task_tick(void)				{ }
-#endif
+#endif /* !CONFIG_PERF_EVENTS */
 
 #if defined(CONFIG_PERF_EVENTS) && defined(CONFIG_NO_HZ_FULL)
 extern bool perf_event_can_stop_tick(void);
@@ -819,6 +821,12 @@ extern void perf_restore_debug_store(void);
 static inline void perf_restore_debug_store(void)			{ }
 #endif
 
+#if defined(CONFIG_PERF_EVENTS) && defined(CONFIG_EVENT_TRACING)
+extern int perf_add_persistent_tp(struct ftrace_event_call *tp);
+#else
+static inline int perf_add_persistent_tp(void *tp)			{ return -ENOENT; }
+#endif
+
 #define perf_output_put(handle, x) perf_output_copy((handle), &(x), sizeof(x))
 
 /*
diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index 62c25a2..2b84b97 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -32,6 +32,7 @@ enum perf_type_id {
 	PERF_TYPE_HW_CACHE			= 3,
 	PERF_TYPE_RAW				= 4,
 	PERF_TYPE_BREAKPOINT			= 5,
+	PERF_TYPE_PERSISTENT			= 6,
 
 	PERF_TYPE_MAX,				/* non-ABI */
 };
@@ -275,8 +276,9 @@ struct perf_event_attr {
 
 				exclude_callchain_kernel : 1, /* exclude kernel callchains */
 				exclude_callchain_user   : 1, /* exclude user callchains */
+				persistent     :  1, /* always-on event */
 
-				__reserved_1   : 41;
+				__reserved_1   : 40;
 
 	union {
 		__u32		wakeup_events;	  /* wakeup every n events */
diff --git a/kernel/events/Makefile b/kernel/events/Makefile
index 103f5d1..70990d5 100644
--- a/kernel/events/Makefile
+++ b/kernel/events/Makefile
@@ -2,7 +2,7 @@ ifdef CONFIG_FUNCTION_TRACER
 CFLAGS_REMOVE_core.o = -pg
 endif
 
-obj-y := core.o ring_buffer.o callchain.o
+obj-y := core.o ring_buffer.o callchain.o persistent.o
 
 obj-$(CONFIG_HAVE_HW_BREAKPOINT) += hw_breakpoint.o
 obj-$(CONFIG_UPROBES) += uprobes.o
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 932acc6..d9d6e67 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3982,6 +3982,9 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 	if (!(vma->vm_flags & VM_SHARED))
 		return -EINVAL;
 
+	if (event->attr.persistent && (vma->vm_flags & VM_WRITE))
+		return -EACCES;
+
 	vma_size = vma->vm_end - vma->vm_start;
 	nr_pages = (vma_size / PAGE_SIZE) - 1;
 
@@ -4007,6 +4010,11 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 			goto unlock;
 		}
 
+		if (!event->rb->overwrite && vma->vm_flags & VM_WRITE) {
+			ret = -EACCES;
+			goto unlock;
+		}
+
 		if (!atomic_inc_not_zero(&event->rb->mmap_count)) {
 			/*
 			 * Raced against perf_mmap_close() through
@@ -5845,7 +5853,7 @@ static struct pmu perf_tracepoint = {
 	.event_idx	= perf_swevent_event_idx,
 };
 
-static inline void perf_tp_register(void)
+static inline void perf_register_tp(void)
 {
 	perf_pmu_register(&perf_tracepoint, "tracepoint", PERF_TYPE_TRACEPOINT);
 }
@@ -5875,18 +5883,14 @@ static void perf_event_free_filter(struct perf_event *event)
 
 #else
 
-static inline void perf_tp_register(void)
-{
-}
+static inline void perf_register_tp(void) { }
 
 static int perf_event_set_filter(struct perf_event *event, void __user *arg)
 {
 	return -ENOENT;
 }
 
-static void perf_event_free_filter(struct perf_event *event)
-{
-}
+static void perf_event_free_filter(struct perf_event *event) { }
 
 #endif /* CONFIG_EVENT_TRACING */
 
@@ -6574,6 +6578,7 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
 	INIT_LIST_HEAD(&event->event_entry);
 	INIT_LIST_HEAD(&event->sibling_list);
 	INIT_LIST_HEAD(&event->rb_entry);
+	INIT_LIST_HEAD(&event->pevent_entry);
 
 	init_waitqueue_head(&event->waitq);
 	init_irq_work(&event->pending, perf_pending_event);
@@ -6831,6 +6836,13 @@ perf_event_set_output(struct perf_event *event, struct perf_event *output_event)
 			goto unlock;
 	}
 
+	/* Don't redirect read-only (persistent) events. */
+	ret = -EACCES;
+	if (old_rb && !old_rb->overwrite)
+		goto unlock;
+	if (rb && !rb->overwrite)
+		goto unlock;
+
 	if (old_rb)
 		ring_buffer_detach(event, old_rb);
 
@@ -6888,6 +6900,14 @@ SYSCALL_DEFINE5(perf_event_open,
 	if (err)
 		return err;
 
+	/* return fd for an existing persistent event */
+	if (attr.type == PERF_TYPE_PERSISTENT)
+		return perf_get_persistent_event_fd(cpu, attr.config);
+
+	/* put event into persistent state (not yet supported) */
+	if (attr.persistent)
+		return -EOPNOTSUPP;
+
 	if (!attr.exclude_kernel) {
 		if (perf_paranoid_kernel() && !capable(CAP_SYS_ADMIN))
 			return -EACCES;
@@ -7828,7 +7848,8 @@ void __init perf_event_init(void)
 	perf_pmu_register(&perf_swevent, "software", PERF_TYPE_SOFTWARE);
 	perf_pmu_register(&perf_cpu_clock, NULL, -1);
 	perf_pmu_register(&perf_task_clock, NULL, -1);
-	perf_tp_register();
+	perf_register_tp();
+	perf_register_persistent();
 	perf_cpu_notifier(perf_cpu_notify);
 	register_reboot_notifier(&perf_reboot_notifier);
 
diff --git a/kernel/events/internal.h b/kernel/events/internal.h
index d8708aa..94c3f73 100644
--- a/kernel/events/internal.h
+++ b/kernel/events/internal.h
@@ -193,5 +193,7 @@ static inline void put_event(struct perf_event *event)
 extern int perf_alloc_rb(struct perf_event *event, int nr_pages, int flags);
 extern void perf_free_rb(struct perf_event *event);
 extern int perf_get_fd(struct perf_event *event);
+extern int perf_get_persistent_event_fd(int cpu, int id);
+extern void __init perf_register_persistent(void);
 
 #endif /* _KERNEL_EVENTS_INTERNAL_H */
diff --git a/kernel/events/persistent.c b/kernel/events/persistent.c
new file mode 100644
index 0000000..926654f
--- /dev/null
+++ b/kernel/events/persistent.c
@@ -0,0 +1,221 @@
+#include <linux/slab.h>
+#include <linux/perf_event.h>
+#include <linux/ftrace_event.h>
+
+#include "internal.h"
+
+/* 512 kiB: default perf tools memory size, see perf_evlist__mmap() */
+#define CPU_BUFFER_NR_PAGES	((512 * 1024) / PAGE_SIZE)
+
+struct pevent {
+	char		*name;
+	int		id;
+};
+
+static DEFINE_PER_CPU(struct list_head, pevents);
+static DEFINE_PER_CPU(struct mutex, pevents_lock);
+
+/* Must be protected with pevents_lock. */
+static struct perf_event *__pevent_find(int cpu, int id)
+{
+	struct perf_event *event;
+
+	list_for_each_entry(event, &per_cpu(pevents, cpu), pevent_entry) {
+		if (event->pevent_id == id)
+			return event;
+	}
+
+	return NULL;
+}
+
+static int pevent_add(struct pevent *pevent, struct perf_event *event)
+{
+	int ret = -EEXIST;
+	int cpu = event->cpu;
+
+	mutex_lock(&per_cpu(pevents_lock, cpu));
+
+	if (__pevent_find(cpu, pevent->id))
+		goto unlock;
+
+	if (event->pevent_id)
+		goto unlock;
+
+	ret = 0;
+	event->pevent_id = pevent->id;
+	list_add_tail(&event->pevent_entry, &per_cpu(pevents, cpu));
+unlock:
+	mutex_unlock(&per_cpu(pevents_lock, cpu));
+
+	return ret;
+}
+
+static struct perf_event *pevent_del(struct pevent *pevent, int cpu)
+{
+	struct perf_event *event;
+
+	mutex_lock(&per_cpu(pevents_lock, cpu));
+
+	event = __pevent_find(cpu, pevent->id);
+	if (event) {
+		list_del(&event->pevent_entry);
+		event->pevent_id = 0;
+	}
+
+	mutex_unlock(&per_cpu(pevents_lock, cpu));
+
+	return event;
+}
+
+static void persistent_event_release(struct perf_event *event)
+{
+	/*
+	 * Safe since we hold &event->mmap_count. The ringbuffer is
+	 * released with put_event() if there are no other references.
+	 * In this case there are also no other mmaps.
+	 */
+	atomic_dec(&event->rb->mmap_count);
+	atomic_dec(&event->mmap_count);
+	put_event(event);
+}
+
+static int persistent_event_open(int cpu, struct pevent *pevent,
+				struct perf_event_attr *attr, int nr_pages)
+{
+	struct perf_event *event;
+	int ret;
+
+	event = perf_event_create_kernel_counter(attr, cpu, NULL, NULL, NULL);
+	if (IS_ERR(event))
+		return PTR_ERR(event);
+
+	if (nr_pages < 0)
+		nr_pages = CPU_BUFFER_NR_PAGES;
+
+	ret = perf_alloc_rb(event, nr_pages, 0);
+	if (ret)
+		goto fail;
+
+	ret = pevent_add(pevent, event);
+	if (ret)
+		goto fail;
+
+	atomic_inc(&event->mmap_count);
+
+	/* All workie, enable event now */
+	perf_event_enable(event);
+
+	return ret;
+fail:
+	perf_event_release_kernel(event);
+	return ret;
+}
+
+static void persistent_event_close(int cpu, struct pevent *pevent)
+{
+	struct perf_event *event = pevent_del(pevent, cpu);
+	if (event)
+		persistent_event_release(event);
+}
+
+static int __maybe_unused
+persistent_open(char *name, struct perf_event_attr *attr, int nr_pages)
+{
+	struct pevent *pevent;
+	char id_buf[32];
+	int cpu;
+	int ret = 0;
+
+	pevent = kzalloc(sizeof(*pevent), GFP_KERNEL);
+	if (!pevent)
+		return -ENOMEM;
+
+	pevent->id = attr->config;
+
+	if (!name) {
+		snprintf(id_buf, sizeof(id_buf), "%d", pevent->id);
+		name = id_buf;
+	}
+
+	pevent->name = kstrdup(name, GFP_KERNEL);
+	if (!pevent->name) {
+		ret = -ENOMEM;
+		goto fail;
+	}
+
+	for_each_possible_cpu(cpu) {
+		ret = persistent_event_open(cpu, pevent, attr, nr_pages);
+		if (ret)
+			goto fail;
+	}
+
+	return 0;
+fail:
+	for_each_possible_cpu(cpu)
+		persistent_event_close(cpu, pevent);
+	kfree(pevent->name);
+	kfree(pevent);
+
+	pr_err("%s: Error adding persistent event: %d\n",
+		__func__, ret);
+
+	return ret;
+}
+
+#ifdef CONFIG_EVENT_TRACING
+
+int perf_add_persistent_tp(struct ftrace_event_call *tp)
+{
+	struct perf_event_attr attr;
+
+	memset(&attr, 0, sizeof(attr));
+	attr.sample_period	= 1;
+	attr.wakeup_events	= 1;
+	attr.sample_type	= PERF_SAMPLE_RAW;
+	attr.persistent		= 1;
+	attr.config		= tp->event.type;
+	attr.type		= PERF_TYPE_TRACEPOINT;
+	attr.size		= sizeof(attr);
+
+	return persistent_open(tp->name, &attr, -1);
+}
+
+#endif /* CONFIG_EVENT_TRACING */
+
+int perf_get_persistent_event_fd(int cpu, int id)
+{
+	struct perf_event *event;
+	int event_fd = 0;
+
+	if ((unsigned)cpu >= nr_cpu_ids)
+		return -EINVAL;
+
+	/* Must be root for persistent events */
+	if (perf_paranoid_cpu() && !capable(CAP_SYS_ADMIN))
+		return -EACCES;
+
+	mutex_lock(&per_cpu(pevents_lock, cpu));
+	event = __pevent_find(cpu, id);
+	if (!event || !try_get_event(event))
+		event_fd = -ENOENT;
+	mutex_unlock(&per_cpu(pevents_lock, cpu));
+
+	if (event_fd)
+		return event_fd;
+
+	event_fd = perf_get_fd(event);
+	if (event_fd < 0)
+		put_event(event);
+
+	return event_fd;
+}
+
+void __init perf_register_persistent(void)
+{
+	int cpu;
+
+	for_each_possible_cpu(cpu) {
+		INIT_LIST_HEAD(&per_cpu(pevents, cpu));
+		mutex_init(&per_cpu(pevents_lock, cpu));
+	}
+}
-- 
1.8.3.2

