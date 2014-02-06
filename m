Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756244AbaBFKxX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 05:53:23 -0500
Received: from mga09.intel.com ([134.134.136.24]:4417 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756103AbaBFKvW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 05:51:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,793,1384329600"; 
   d="scan'208";a="450662666"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Subject: [PATCH v1 04/11] itrace: Infrastructure for instruction flow tracing units
Date: Thu,  6 Feb 2014 12:50:27 +0200
Message-Id: <1391683834-29868-5-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc2
In-Reply-To: <1391683834-29868-1-git-send-email-alexander.shishkin@linux.intel.com>
References: <1391683834-29868-1-git-send-email-alexander.shishkin@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instruction tracing PMUs are capable of recording a log of instruction
execution flow on a cpu core, which can be useful for profiling and crash
analysis. This patch adds itrace infrastructure for perf events and the
rest of the kernel to use.

Since such PMUs can produce copious amounts of trace data at the rate for
hundreds of megabytes per second per core, it may be impractical to process
it inside the kernel in real time, but instead export raw trace streams to
userspace for subsequent analysis. Thus, itrace PMUs may export their trace
buffers, which can be mmap()ed to userspace from a special file descriptor,
which can be obtained from the perf_event_open() syscall by using a
PERF_FLAG_FD_ITRACE flag and the original perf event descriptor.

This infrastructure should also be useful for ARM ETM/PTM and other program
flow tracing units that can potentially generate a lot of trace data very
fast.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
---
 include/linux/itrace.h          |  89 +++++++++++++
 include/linux/perf_event.h      |   5 +
 include/uapi/linux/perf_event.h |  17 +++
 kernel/events/Makefile          |   2 +-
 kernel/events/core.c            | 130 ++++++++++++++++---
 kernel/events/itrace.c          | 271 ++++++++++++++++++++++++++++++++++++++++
 6 files changed, 495 insertions(+), 19 deletions(-)
 create mode 100644 include/linux/itrace.h
 create mode 100644 kernel/events/itrace.c

diff --git a/include/linux/itrace.h b/include/linux/itrace.h
new file mode 100644
index 0000000..735baaf4
--- /dev/null
+++ b/include/linux/itrace.h
@@ -0,0 +1,89 @@
+/*
+ * Instruction flow trace unit infrastructure
+ * Copyright (c) 2013, Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ */
+
+#ifndef _LINUX_ITRACE_H
+#define _LINUX_ITRACE_H
+
+#include <linux/perf_event.h>
+#include <linux/file.h>
+
+extern struct ring_buffer_ops itrace_rb_ops;
+
+static inline bool is_itrace_vma(struct vm_area_struct *vma)
+{
+	if (vma->vm_file) {
+		struct perf_event *event = vma->vm_file->private_data;
+		if (event->hw.itrace_file == vma->vm_file)
+			return true;
+	}
+
+	return false;
+}
+
+void *itrace_priv(struct perf_event *event);
+
+void *itrace_event_get_priv(struct perf_event *event);
+void itrace_event_put(struct perf_event *event);
+
+struct itrace_pmu {
+	struct pmu		pmu;
+	struct list_head	entry;
+	/*
+	 * Allocate/free ring_buffer backing store
+	 */
+	void			*(*alloc_buffer)(int cpu, int nr_pages, bool overwrite,
+						 void **pages,
+						 struct perf_event_mmap_page **user_page);
+	void			(*free_buffer)(void *buffer);
+
+	int			(*event_init)(struct perf_event *event);
+
+	char			*name;
+};
+
+#define to_itrace_pmu(x) container_of((x), struct itrace_pmu, pmu)
+
+#ifdef CONFIG_PERF_EVENTS
+extern int itrace_inherit_event(struct perf_event *event,
+				struct task_struct *task);
+extern void itrace_lost_data(struct perf_event *event, u64 offset);
+extern int itrace_pmu_register(struct itrace_pmu *ipmu);
+
+extern int itrace_event_installable(struct perf_event *event,
+				    struct perf_event_context *ctx);
+
+extern void itrace_wake_up(struct perf_event *event);
+
+extern bool is_itrace_event(struct perf_event *event);
+
+#else
+static int itrace_inherit_event(struct perf_event *event,
+				struct task_struct *task)	{ return 0; }
+static inline void
+itrace_lost_data(struct perf_event *event, u64 offset)		{}
+static inline int itrace_pmu_register(struct itrace_pmu *ipmu)	{ return -EINVAL; }
+
+static inline int
+itrace_event_installable(struct perf_event *event,
+			 struct perf_event_context *ctx)	{ return -EINVAL; }
+static inline void itrace_wake_up(struct perf_event *event)	{}
+static inline bool is_itrace_event(struct perf_event *event)	{ return false; }
+#endif
+
+#endif /* _LINUX_PERF_EVENT_H */
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 93cefb6..b0147e0 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -126,6 +126,10 @@ struct hw_perf_event {
 			/* for tp_event->class */
 			struct list_head	tp_list;
 		};
+		struct { /* itrace */
+			struct file		*itrace_file;
+			struct task_struct	*itrace_target;
+		};
 #ifdef CONFIG_HAVE_HW_BREAKPOINT
 		struct { /* breakpoint */
 			/*
@@ -291,6 +295,7 @@ struct ring_buffer;
 
 enum perf_event_rb {
 	PERF_RB_MAIN = 0,
+	PERF_RB_ITRACE,
 	PERF_NR_RB,
 };
 
diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index e244ed4..2dd57db 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -237,6 +237,10 @@ enum perf_event_read_format {
 #define PERF_ATTR_SIZE_VER2	80	/* add: branch_sample_type */
 #define PERF_ATTR_SIZE_VER3	96	/* add: sample_regs_user */
 					/* add: sample_stack_user */
+#define PERF_ATTR_SIZE_VER4	120	/* add: itrace_config */
+					/* add: itrace_watermark */
+					/* add: itrace_sample_type */
+					/* add: itrace_sample_size */
 
 /*
  * Hardware event_id to monitor via a performance monitoring event:
@@ -333,6 +337,11 @@ struct perf_event_attr {
 
 	/* Align to u64. */
 	__u32	__reserved_2;
+
+	__u64	itrace_config;
+	__u32	itrace_watermark;	/* wakeup every n pages */
+	__u32	itrace_sample_type;	/* pmu->type of the itrace PMU */
+	__u64	itrace_sample_size;
 };
 
 #define perf_flags(attr)	(*(&(attr)->read_format + 1))
@@ -705,6 +714,13 @@ enum perf_event_type {
 	 */
 	PERF_RECORD_MMAP2			= 10,
 
+	/*
+	 * struct {
+	 *   u64 offset;
+	 * }
+	 */
+	PERF_RECORD_ITRACE_LOST			= 11,
+
 	PERF_RECORD_MAX,			/* non-ABI */
 };
 
@@ -726,6 +742,7 @@ enum perf_callchain_context {
 #define PERF_FLAG_FD_OUTPUT		(1U << 1)
 #define PERF_FLAG_PID_CGROUP		(1U << 2) /* pid=cgroup id, per-cpu mode only */
 #define PERF_FLAG_FD_CLOEXEC		(1U << 3) /* O_CLOEXEC */
+#define PERF_FLAG_FD_ITRACE		(1U << 4) /* request itrace fd */
 
 union perf_mem_data_src {
 	__u64 val;
diff --git a/kernel/events/Makefile b/kernel/events/Makefile
index 103f5d1..46a3770 100644
--- a/kernel/events/Makefile
+++ b/kernel/events/Makefile
@@ -2,7 +2,7 @@ ifdef CONFIG_FUNCTION_TRACER
 CFLAGS_REMOVE_core.o = -pg
 endif
 
-obj-y := core.o ring_buffer.o callchain.o
+obj-y := core.o ring_buffer.o callchain.o itrace.o
 
 obj-$(CONFIG_HAVE_HW_BREAKPOINT) += hw_breakpoint.o
 obj-$(CONFIG_UPROBES) += uprobes.o
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 533230c..ff6e286 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -39,6 +39,7 @@
 #include <linux/hw_breakpoint.h>
 #include <linux/mm_types.h>
 #include <linux/cgroup.h>
+#include <linux/itrace.h>
 
 #include "internal.h"
 
@@ -120,7 +121,8 @@ static int cpu_function_call(int cpu, int (*func) (void *info), void *info)
 #define PERF_FLAG_ALL (PERF_FLAG_FD_NO_GROUP |\
 		       PERF_FLAG_FD_OUTPUT  |\
 		       PERF_FLAG_PID_CGROUP |\
-		       PERF_FLAG_FD_CLOEXEC)
+		       PERF_FLAG_FD_CLOEXEC |\
+		       PERF_FLAG_FD_ITRACE)
 
 /*
  * branch priv levels that need permission checks
@@ -3339,7 +3341,12 @@ static void put_event(struct perf_event *event)
 
 static int perf_release(struct inode *inode, struct file *file)
 {
-	put_event(file->private_data);
+	struct perf_event *event = file->private_data;
+
+	if (is_itrace_event(event) && event->hw.itrace_file == file)
+		event->hw.itrace_file = NULL;
+
+	put_event(event);
 	return 0;
 }
 
@@ -3806,7 +3813,10 @@ static int perf_mmap_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
 	struct perf_event *event = vma->vm_file->private_data;
 	struct ring_buffer *rb;
-	int ret = VM_FAULT_SIGBUS;
+	int ret = VM_FAULT_SIGBUS, rbx = PERF_RB_MAIN;
+
+	if (is_itrace_event(event) && is_itrace_vma(vma))
+		rbx = PERF_RB_ITRACE;
 
 	if (vmf->flags & FAULT_FLAG_MKWRITE) {
 		if (vmf->pgoff == 0)
@@ -3815,7 +3825,7 @@ static int perf_mmap_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 	}
 
 	rcu_read_lock();
-	rb = rcu_dereference(event->rb[PERF_RB_MAIN]);
+	rb = rcu_dereference(event->rb[rbx]);
 	if (!rb)
 		goto unlock;
 
@@ -3840,7 +3850,8 @@ unlock:
 void ring_buffer_attach(struct perf_event *event,
 			struct ring_buffer *rb)
 {
-	struct list_head *head = &event->rb_entry[PERF_RB_MAIN];
+	int rbx = rb->priv ? PERF_RB_ITRACE : PERF_RB_MAIN;
+	struct list_head *head = &event->rb_entry[rbx];
 	unsigned long flags;
 
 	if (!list_empty(head))
@@ -3854,7 +3865,8 @@ void ring_buffer_attach(struct perf_event *event,
 
 void ring_buffer_detach(struct perf_event *event, struct ring_buffer *rb)
 {
-	struct list_head *head = &event->rb_entry[PERF_RB_MAIN];
+	int rbx = rb->priv ? PERF_RB_ITRACE : PERF_RB_MAIN;
+	struct list_head *head = &event->rb_entry[rbx];
 	unsigned long flags;
 
 	if (list_empty(head))
@@ -3919,9 +3931,10 @@ void ring_buffer_put(struct ring_buffer *rb)
 static void perf_mmap_open(struct vm_area_struct *vma)
 {
 	struct perf_event *event = vma->vm_file->private_data;
+	int rbx = is_itrace_vma(vma) ? PERF_RB_ITRACE : PERF_RB_MAIN;
 
-	atomic_inc(&event->mmap_count[PERF_RB_MAIN]);
-	atomic_inc(&event->rb[PERF_RB_MAIN]->mmap_count);
+	atomic_inc(&event->mmap_count[rbx]);
+	atomic_inc(&event->rb[rbx]->mmap_count);
 }
 
 /*
@@ -3935,7 +3948,7 @@ static void perf_mmap_open(struct vm_area_struct *vma)
 static void perf_mmap_close(struct vm_area_struct *vma)
 {
 	struct perf_event *event = vma->vm_file->private_data;
-	int rbx = PERF_RB_MAIN;
+	int rbx = is_itrace_vma(vma) ? PERF_RB_ITRACE : PERF_RB_MAIN;
 	struct ring_buffer *rb = event->rb[rbx];
 	struct user_struct *mmap_user = rb->mmap_user;
 	int mmap_locked = rb->mmap_locked;
@@ -4051,13 +4064,16 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 
 	vma_size = vma->vm_end - vma->vm_start;
 
+	if (is_itrace_event(event) && is_itrace_vma(vma))
+		rbx = PERF_RB_ITRACE;
+
 	nr_pages = (vma_size / PAGE_SIZE) - 1;
 
 	/*
 	 * If we have rb pages ensure they're a power-of-two number, so we
 	 * can do bitmasks instead of modulo.
 	 */
-	if (nr_pages != 0 && !is_power_of_2(nr_pages))
+	if (!rbx && nr_pages != 0 && !is_power_of_2(nr_pages))
 		return -EINVAL;
 
 	if (vma_size != PAGE_SIZE * (1 + nr_pages))
@@ -4120,7 +4136,7 @@ again:
 
 	rb = rb_alloc(event, nr_pages,
 		event->attr.watermark ? event->attr.wakeup_watermark : 0,
-		event->cpu, flags, NULL);
+		event->cpu, flags, rbx ? &itrace_rb_ops : NULL);
 
 	if (!rb) {
 		ret = -ENOMEM;
@@ -6728,6 +6744,8 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
 
 		if (attr->type == PERF_TYPE_TRACEPOINT)
 			event->hw.tp_target = task;
+		else if (is_itrace_event(event))
+			event->hw.itrace_target = task;
 #ifdef CONFIG_HAVE_HW_BREAKPOINT
 		/*
 		 * hw_breakpoint is a bit difficult here..
@@ -6947,6 +6965,17 @@ perf_event_set_output(struct perf_event *event, struct perf_event *output_event)
 	 */
 	if (output_event->cpu == -1 && output_event->ctx != event->ctx)
 		goto out;
+	/*
+	 * Both itrace events must be on a same PMU; itrace events can
+	 * be only redirected to other itrace events.
+	 */
+	if (is_itrace_event(event)) {
+		if (!is_itrace_event(output_event))
+			goto out;
+
+		if (event->attr.type != output_event->attr.type)
+			goto out;
+	}
 
 set:
 	mutex_lock(&event->mmap_mutex);
@@ -6993,6 +7022,46 @@ out:
 	return ret;
 }
 
+static int do_perf_get_itrace_fd(int group_fd, int f_flags)
+{
+	struct fd group = {NULL, 0};
+	struct perf_event *event;
+	struct file *file = NULL;
+	int fd, err;
+
+	fd = get_unused_fd_flags(f_flags);
+	if (fd < 0)
+		return fd;
+
+	err = perf_fget_light(group_fd, &group);
+	if (err)
+		goto err_fd;
+
+	event = group.file->private_data;
+	if (!is_itrace_event(event)) {
+		err = -EINVAL;
+		goto err_group_fd;
+	}
+
+	file = anon_inode_getfile("[itrace]", &perf_fops, event, f_flags);
+	if (IS_ERR(file)) {
+		err = PTR_ERR(file);
+		goto err_group_fd;
+	}
+
+	event->hw.itrace_file = file;
+
+	fdput(group);
+	fd_install(fd, file);
+	return fd;
+
+err_group_fd:
+	fdput(group);
+err_fd:
+	put_unused_fd(fd);
+	return err;
+}
+
 /**
  * sys_perf_event_open - open a performance event, associate it to a task/cpu
  *
@@ -7022,6 +7091,18 @@ SYSCALL_DEFINE5(perf_event_open,
 	if (flags & ~PERF_FLAG_ALL)
 		return -EINVAL;
 
+	if (flags & PERF_FLAG_FD_CLOEXEC)
+		f_flags |= O_CLOEXEC;
+
+	if (flags & PERF_FLAG_FD_ITRACE) {
+		/* only allowed to specify group_fd with this flag */
+		if (group_fd == -1 || attr_uptr || cpu != -1 || pid != -1 ||
+		    (flags & ~(PERF_FLAG_FD_ITRACE | PERF_FLAG_FD_CLOEXEC)))
+			return -EINVAL;
+
+		return do_perf_get_itrace_fd(group_fd, f_flags);
+	}
+
 	err = perf_copy_attr(attr_uptr, &attr);
 	if (err)
 		return err;
@@ -7045,9 +7126,6 @@ SYSCALL_DEFINE5(perf_event_open,
 	if ((flags & PERF_FLAG_PID_CGROUP) && (pid == -1 || cpu == -1))
 		return -EINVAL;
 
-	if (flags & PERF_FLAG_FD_CLOEXEC)
-		f_flags |= O_CLOEXEC;
-
 	event_fd = get_unused_fd_flags(f_flags);
 	if (event_fd < 0)
 		return event_fd;
@@ -7128,6 +7206,10 @@ SYSCALL_DEFINE5(perf_event_open,
 		goto err_alloc;
 	}
 
+	err = itrace_event_installable(event, ctx);
+	if (err)
+		goto err_alloc;
+
 	if (task) {
 		put_task_struct(task);
 		task = NULL;
@@ -7293,6 +7375,10 @@ perf_event_create_kernel_counter(struct perf_event_attr *attr, int cpu,
 		goto err_free;
 	}
 
+	err = itrace_event_installable(event, ctx);
+	if (err)
+		goto err_free;
+
 	WARN_ON_ONCE(ctx->parent_ctx);
 	mutex_lock(&ctx->mutex);
 	perf_install_in_context(ctx, event, cpu);
@@ -7583,6 +7669,7 @@ inherit_event(struct perf_event *parent_event,
 {
 	struct perf_event *child_event;
 	unsigned long flags;
+	int err;
 
 	/*
 	 * Instead of creating recursive hierarchies of events,
@@ -7601,10 +7688,12 @@ inherit_event(struct perf_event *parent_event,
 	if (IS_ERR(child_event))
 		return child_event;
 
-	if (!atomic_long_inc_not_zero(&parent_event->refcount)) {
-		free_event(child_event);
-		return NULL;
-	}
+	err = itrace_inherit_event(child_event, child);
+	if (err)
+		goto err_alloc;
+
+	if (!atomic_long_inc_not_zero(&parent_event->refcount))
+		goto err_alloc;
 
 	get_ctx(child_ctx);
 
@@ -7655,6 +7744,11 @@ inherit_event(struct perf_event *parent_event,
 	mutex_unlock(&parent_event->child_mutex);
 
 	return child_event;
+
+err_alloc:
+	free_event(child_event);
+
+	return NULL;
 }
 
 static int inherit_group(struct perf_event *parent_event,
diff --git a/kernel/events/itrace.c b/kernel/events/itrace.c
new file mode 100644
index 0000000..ec26373
--- /dev/null
+++ b/kernel/events/itrace.c
@@ -0,0 +1,271 @@
+/*
+ * Instruction flow trace unit infrastructure
+ * Copyright (c) 2013, Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ */
+
+#undef DEBUG
+
+#include <linux/kernel.h>
+#include <linux/perf_event.h>
+#include <linux/itrace.h>
+#include <linux/sizes.h>
+#include <linux/slab.h>
+
+#include "internal.h"
+
+static LIST_HEAD(itrace_pmus);
+static DEFINE_MUTEX(itrace_pmus_mutex);
+
+struct static_key_deferred itrace_core_events __read_mostly;
+
+struct itrace_lost_record {
+	struct perf_event_header	header;
+	u64				offset;
+};
+
+/*
+ * In the worst case, perf buffer might be full and we're not able to output
+ * this record, so the decoder won't know that the data was lost. However,
+ * it will still see inconsistency in the trace IP.
+ */
+void itrace_lost_data(struct perf_event *event, u64 offset)
+{
+	struct perf_output_handle handle;
+	struct perf_sample_data sample;
+	struct itrace_lost_record rec = {
+		.header = {
+			.type = PERF_RECORD_ITRACE_LOST,
+			.misc = 0,
+			.size = sizeof(rec),
+		},
+		.offset = offset
+	};
+	int ret;
+
+	perf_event_header__init_id(&rec.header, &sample, event);
+	ret = perf_output_begin(&handle, event, rec.header.size);
+
+	if (ret)
+		return;
+
+	perf_output_put(&handle, rec);
+	perf_event__output_id_sample(event, &handle, &sample);
+	perf_output_end(&handle);
+}
+
+static struct itrace_pmu *itrace_pmu_find(int type)
+{
+	struct itrace_pmu *ipmu;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(ipmu, &itrace_pmus, entry) {
+		if (ipmu->pmu.type == type)
+			goto out;
+	}
+
+	ipmu = NULL;
+out:
+	rcu_read_unlock();
+
+	return ipmu;
+}
+
+bool is_itrace_event(struct perf_event *event)
+{
+	return !!itrace_pmu_find(event->attr.type);
+}
+
+int itrace_event_installable(struct perf_event *event,
+			     struct perf_event_context *ctx)
+{
+	struct perf_event *iter_event;
+
+	if (!is_itrace_event(event))
+		return 0;
+
+	/*
+	 * the context is locked and pinned and won't change under us,
+	 * also we don't care if it's a cpu or task context at this point
+	 */
+	list_for_each_entry(iter_event, &ctx->event_list, event_entry) {
+		if (is_itrace_event(iter_event) &&
+		    (iter_event->cpu == event->cpu ||
+		     iter_event->cpu == -1 ||
+		     event->cpu == -1))
+			return -EEXIST;
+	}
+
+	return 0;
+}
+
+static int itrace_event_init(struct perf_event *event)
+{
+	struct itrace_pmu *ipmu = to_itrace_pmu(event->pmu);
+
+	return ipmu->event_init(event);
+}
+
+static unsigned long itrace_rb_get_size(int nr_pages)
+{
+	return sizeof(struct ring_buffer) + sizeof(void *) * nr_pages;
+}
+
+static int itrace_alloc_data_pages(struct ring_buffer *rb, int cpu,
+				   int nr_pages, int flags)
+{
+	struct itrace_pmu *ipmu = to_itrace_pmu(rb->event->pmu);
+	bool overwrite = !(flags & RING_BUFFER_WRITABLE);
+
+	rb->priv = ipmu->alloc_buffer(cpu, nr_pages, overwrite,
+				      rb->data_pages, &rb->user_page);
+	if (!rb->priv)
+		return -ENOMEM;
+	rb->nr_pages = nr_pages;
+
+	return 0;
+}
+
+static void itrace_free(struct ring_buffer *rb)
+{
+	struct itrace_pmu *ipmu = to_itrace_pmu(rb->event->pmu);
+
+	if (rb->priv)
+		ipmu->free_buffer(rb->priv);
+}
+
+struct page *
+itrace_mmap_to_page(struct ring_buffer *rb, unsigned long pgoff)
+{
+	if (pgoff > rb->nr_pages)
+		return NULL;
+
+	if (pgoff == 0)
+		return virt_to_page(rb->user_page);
+
+	return virt_to_page(rb->data_pages[pgoff - 1]);
+}
+
+struct ring_buffer_ops itrace_rb_ops = {
+	.get_size		= itrace_rb_get_size,
+	.alloc_data_page	= itrace_alloc_data_pages,
+	.free_buffer		= itrace_free,
+	.mmap_to_page		= itrace_mmap_to_page,
+};
+
+void *itrace_priv(struct perf_event *event)
+{
+	if (!event->rb[PERF_RB_ITRACE])
+		return NULL;
+
+	return event->rb[PERF_RB_ITRACE]->priv;
+}
+
+void *itrace_event_get_priv(struct perf_event *event)
+{
+	struct ring_buffer *rb = ring_buffer_get(event, PERF_RB_ITRACE);
+
+	return rb ? rb->priv : NULL;
+}
+
+void itrace_event_put(struct perf_event *event)
+{
+	struct ring_buffer *rb;
+
+	rcu_read_lock();
+	rb = rcu_dereference(event->rb[PERF_RB_ITRACE]);
+	if (rb)
+		ring_buffer_put(rb);
+	rcu_read_unlock();
+}
+
+static void itrace_set_output(struct perf_event *event,
+			      struct perf_event *output_event)
+{
+	struct ring_buffer *rb;
+
+	mutex_lock(&event->mmap_mutex);
+
+	if (atomic_read(&event->mmap_count[PERF_RB_ITRACE]) ||
+	    event->rb[PERF_RB_ITRACE])
+		goto out;
+
+	rb = ring_buffer_get(output_event, PERF_RB_ITRACE);
+	if (!rb)
+		goto out;
+
+	ring_buffer_attach(event, rb);
+	rcu_assign_pointer(event->rb[PERF_RB_ITRACE], rb);
+
+out:
+	mutex_unlock(&event->mmap_mutex);
+}
+
+int itrace_inherit_event(struct perf_event *event, struct task_struct *task)
+{
+	struct perf_event *parent = event->parent;
+	struct itrace_pmu *ipmu;
+
+	if (!is_itrace_event(event))
+		return 0;
+
+	ipmu = to_itrace_pmu(event->pmu);
+
+	/*
+	 * inherited user's counters should inherit buffers IF
+	 * they aren't cpu==-1
+	 */
+	if (parent->cpu == -1)
+		return -EINVAL;
+
+	itrace_set_output(event, parent);
+
+	return 0;
+}
+
+void itrace_wake_up(struct perf_event *event)
+{
+	struct ring_buffer *rb;
+
+	rcu_read_lock();
+	rb = rcu_dereference(event->rb[PERF_RB_ITRACE]);
+	if (rb) {
+		atomic_set(&rb->poll, POLL_IN);
+		irq_work_queue(&event->pending);
+	}
+	rcu_read_unlock();
+}
+
+int itrace_pmu_register(struct itrace_pmu *ipmu)
+{
+	int ret;
+
+	if (!ipmu->alloc_buffer || !ipmu->free_buffer)
+		return -EINVAL;
+
+	ipmu->event_init = ipmu->pmu.event_init;
+	ipmu->pmu.event_init = itrace_event_init;
+
+	ret = perf_pmu_register(&ipmu->pmu, ipmu->name, -1);
+	if (ret)
+		return ret;
+
+	mutex_lock(&itrace_pmus_mutex);
+	list_add_tail_rcu(&ipmu->entry, &itrace_pmus);
+	mutex_unlock(&itrace_pmus_mutex);
+
+	return ret;
+}
-- 
1.8.5.2

