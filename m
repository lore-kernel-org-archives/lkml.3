Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752797Ab3LKM5E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 07:57:04 -0500
Received: from mga11.intel.com ([192.55.52.93]:11300 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751030Ab3LKMiE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 07:38:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,871,1378882800"; 
   d="scan'208";a="448279622"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Subject: [PATCH v0 04/71] itrace: Infrastructure for instruction flow tracing units
Date: Wed, 11 Dec 2013 14:36:16 +0200
Message-Id: <1386765443-26966-5-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc2
In-Reply-To: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
References: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instruction tracing PMUs are capable of recording a log of instruction
execution flow on a cpu core, which can be useful for profiling and crash
analysis. This patch adds itrace infrastructure for perf events and the
rest of the kernel to use.

Since such PMUs can produce copious amounts of trace data, it may be
impractical to process it inside the kernel in real time, but instead export
raw trace streams to userspace for subsequent analysis. Thus, itrace PMUs
may export their trace buffers, which can be mmap()ed to userspace from a
perf event fd with a PERF_EVENT_ITRACE_OFFSET offset. To that end, perf
is extended to work with multiple ring buffers per event, reusing the
ring_buffer code in an attempt to reduce complexity.

Also, trace data from such PMUs can be used to annotate other perf events
by including it in sample records when PERF_SAMPLE_ITRACE flag is set. In
this case, a PT kernel counter is created for each such event and trace data
is retrieved from it and stored in the perf data stream.

Finally, such per thread trace data can be included in process core dumps,
which is controlled via a new rlimit parameter RLIMIT_ITRACE. This again
is done by a per-thread kernel counter that is created when this RLIMIT_ITRACE
is set.

This infrastructure should also be useful for ARM ETM/PTM and other program
flow tracing units that can potentially generate a lot of trace data very
fast.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
---
 fs/binfmt_elf.c                     |   6 +
 fs/proc/base.c                      |   1 +
 include/asm-generic/resource.h      |   1 +
 include/linux/itrace.h              | 147 +++++++++
 include/linux/perf_event.h          |  33 +-
 include/uapi/asm-generic/resource.h |   3 +-
 include/uapi/linux/elf.h            |   1 +
 include/uapi/linux/perf_event.h     |  25 +-
 kernel/events/Makefile              |   2 +-
 kernel/events/core.c                | 299 ++++++++++++------
 kernel/events/internal.h            |   7 +
 kernel/events/itrace.c              | 589 ++++++++++++++++++++++++++++++++++++
 kernel/events/ring_buffer.c         |   2 +-
 kernel/exit.c                       |   3 +
 kernel/sys.c                        |   5 +
 15 files changed, 1020 insertions(+), 104 deletions(-)
 create mode 100644 include/linux/itrace.h
 create mode 100644 kernel/events/itrace.c

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 571a423..c7fcd49 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -34,6 +34,7 @@
 #include <linux/utsname.h>
 #include <linux/coredump.h>
 #include <linux/sched.h>
+#include <linux/itrace.h>
 #include <asm/uaccess.h>
 #include <asm/param.h>
 #include <asm/page.h>
@@ -1576,6 +1577,8 @@ static int fill_thread_core_info(struct elf_thread_core_info *t,
 		}
 	}
 
+	*total += itrace_elf_note_size(t->task);
+
 	return 1;
 }
 
@@ -1608,6 +1611,7 @@ static int fill_note_info(struct elfhdr *elf, int phdrs,
 	for (i = 0; i < view->n; ++i)
 		if (view->regsets[i].core_note_type != 0)
 			++info->thread_notes;
+	info->thread_notes++; /* ITRACE */
 
 	/*
 	 * Sanity check.  We rely on regset 0 being in NT_PRSTATUS,
@@ -1710,6 +1714,8 @@ static int write_note_info(struct elf_note_info *info,
 			    !writenote(&t->notes[i], cprm))
 				return 0;
 
+		itrace_elf_note_write(cprm, t->task);
+
 		first = 0;
 		t = t->next;
 	} while (t);
diff --git a/fs/proc/base.c b/fs/proc/base.c
index 1485e38..41785ec 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -471,6 +471,7 @@ static const struct limit_names lnames[RLIM_NLIMITS] = {
 	[RLIMIT_NICE] = {"Max nice priority", NULL},
 	[RLIMIT_RTPRIO] = {"Max realtime priority", NULL},
 	[RLIMIT_RTTIME] = {"Max realtime timeout", "us"},
+	[RLIMIT_ITRACE] = {"Max ITRACE buffer size", "bytes"},
 };
 
 /* Display limits for a process */
diff --git a/include/asm-generic/resource.h b/include/asm-generic/resource.h
index b4ea8f5..e6e5657 100644
--- a/include/asm-generic/resource.h
+++ b/include/asm-generic/resource.h
@@ -25,6 +25,7 @@
 	[RLIMIT_NICE]		= { 0, 0 },				\
 	[RLIMIT_RTPRIO]		= { 0, 0 },				\
 	[RLIMIT_RTTIME]		= {  RLIM_INFINITY,  RLIM_INFINITY },	\
+	[RLIMIT_ITRACE]		= {              0,  RLIM_INFINITY },	\
 }
 
 #endif
diff --git a/include/linux/itrace.h b/include/linux/itrace.h
new file mode 100644
index 0000000..c4175b3
--- /dev/null
+++ b/include/linux/itrace.h
@@ -0,0 +1,147 @@
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
+#include <linux/coredump.h>
+
+extern struct ring_buffer_ops itrace_rb_ops;
+
+#define PERF_EVENT_ITRACE_PGOFF (PERF_EVENT_ITRACE_OFFSET >> PAGE_SHIFT)
+
+static inline bool is_itrace_vma(struct vm_area_struct *vma)
+{
+	return vma->vm_pgoff == PERF_EVENT_ITRACE_PGOFF;
+}
+
+void *itrace_priv(struct perf_event *event);
+
+void *itrace_event_get_priv(struct perf_event *event);
+void itrace_event_put(struct perf_event *event);
+
+struct itrace_pmu {
+	struct pmu		pmu;
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
+	/*
+	 * Calculate the size of a sample to be written out
+	 */
+	unsigned long		(*sample_trace)(struct perf_event *event,
+						struct perf_sample_data *data);
+
+	/*
+	 * Write out a trace sample to the given output handle
+	 */
+	void			(*sample_output)(struct perf_event *event,
+						 struct perf_output_handle *handle,
+						 struct perf_sample_data *data);
+
+	/*
+	 * Get the PMU-specific part of a core dump note
+	 */
+	size_t			(*core_size)(struct perf_event *event);
+
+	/*
+	 * Write out the core dump note
+	 */
+	void			(*core_output)(struct coredump_params *cprm,
+					       struct perf_event *event,
+					       unsigned long len);
+	char			*name;
+};
+
+#define to_itrace_pmu(x) container_of((x), struct itrace_pmu, pmu)
+
+#ifdef CONFIG_PERF_EVENTS
+
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
+extern int itrace_sampler_init(struct perf_event *event,
+			       struct task_struct *task);
+extern void itrace_sampler_fini(struct perf_event *event);
+extern unsigned long itrace_sampler_trace(struct perf_event *event,
+					  struct perf_sample_data *data);
+extern void itrace_sampler_output(struct perf_event *event,
+				  struct perf_output_handle *handle,
+				  struct perf_sample_data *data);
+
+extern int update_itrace_rlimit(struct task_struct *, unsigned long);
+extern void exit_itrace(struct task_struct *);
+
+struct itrace_note {
+	u64	itrace_config;
+};
+
+extern size_t itrace_elf_note_size(struct task_struct *tsk);
+extern void itrace_elf_note_write(struct coredump_params *cprm,
+				  struct task_struct *task);
+#else
+static inline void
+itrace_lost_data(struct perf_event *event, u64 offset)		{}
+static inline int itrace_pmu_register(struct itrace_pmu *ipmu)	{ return -EINVAL; }
+
+static inline int
+itrace_event_installable(struct perf_event *event,
+			 struct perf_event_context *ctx)	{ return -EINVAL; }
+static inline void itrace_wake_up(struct perf_event *event)	{}
+static inline bool is_itrace_event(struct perf_event *event)	{ return false; }
+
+static inline int itrace_sampler_init(struct perf_event *event,
+				      struct task_struct *task)	{}
+static inline void
+itrace_sampler_fini(struct perf_event *event)			{}
+static inline unsigned long
+itrace_sampler_trace(struct perf_event *event,
+		     struct perf_sample_data *data)		{ return 0; }
+static inline void
+itrace_sampler_output(struct perf_event *event,
+		      struct perf_output_handle *handle,
+		      struct perf_sample_data *data)		{}
+
+static inline int
+update_itrace_rlimit(struct task_struct *, unsigned long)	{ return -EINVAL; }
+static inline void exit_itrace(struct task_struct *)		{}
+
+static inline size_t
+itrace_elf_note_size(struct task_struct *tsk)			{ return 0; }
+static inline void
+itrace_elf_note_write(struct coredump_params *cprm,
+		      struct task_struct *task)			{}
+
+#endif
+
+#endif /* _LINUX_PERF_EVENT_H */
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 8f4a70f..b27cfc7 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -83,6 +83,12 @@ struct perf_regs_user {
 	struct pt_regs	*regs;
 };
 
+struct perf_trace_record {
+	u64		size;
+	unsigned long	from;
+	unsigned long	to;
+};
+
 struct task_struct;
 
 /*
@@ -97,6 +103,14 @@ struct hw_perf_event_extra {
 
 struct event_constraint;
 
+enum perf_itrace_counter_type {
+	PERF_ITRACE_USER	= BIT(1),
+	PERF_ITRACE_SAMPLING	= BIT(2),
+	PERF_ITRACE_COREDUMP	= BIT(3),
+	PERF_ITRACE_KERNEL	= (PERF_ITRACE_SAMPLING | PERF_ITRACE_COREDUMP),
+	PERF_ITRACE_ANY		= (PERF_ITRACE_KERNEL | PERF_ITRACE_USER),
+};
+
 /**
  * struct hw_perf_event - performance event hardware details:
  */
@@ -126,6 +140,10 @@ struct hw_perf_event {
 			/* for tp_event->class */
 			struct list_head	tp_list;
 		};
+		struct { /* itrace */
+			struct task_struct	*itrace_target;
+			unsigned int		counter_type;
+		};
 #ifdef CONFIG_HAVE_HW_BREAKPOINT
 		struct { /* breakpoint */
 			/*
@@ -289,6 +307,12 @@ struct swevent_hlist {
 struct perf_cgroup;
 struct ring_buffer;
 
+enum perf_event_rb {
+	PERF_RB_MAIN = 0,
+	PERF_RB_ITRACE,
+	PERF_NR_RB,
+};
+
 /**
  * struct perf_event - performance event kernel representation:
  */
@@ -400,10 +424,10 @@ struct perf_event {
 
 	/* mmap bits */
 	struct mutex			mmap_mutex;
-	atomic_t			mmap_count;
+	atomic_t			mmap_count[PERF_NR_RB];
 
-	struct ring_buffer		*rb;
-	struct list_head		rb_entry;
+	struct ring_buffer		*rb[PERF_NR_RB];
+	struct list_head		rb_entry[PERF_NR_RB];
 
 	/* poll related */
 	wait_queue_head_t		waitq;
@@ -426,6 +450,7 @@ struct perf_event {
 	perf_overflow_handler_t		overflow_handler;
 	void				*overflow_handler_context;
 
+	struct perf_event		*trace_event;
 #ifdef CONFIG_EVENT_TRACING
 	struct ftrace_event_call	*tp_event;
 	struct event_filter		*filter;
@@ -583,6 +608,7 @@ struct perf_sample_data {
 	union  perf_mem_data_src	data_src;
 	struct perf_callchain_entry	*callchain;
 	struct perf_raw_record		*raw;
+	struct perf_trace_record	trace;
 	struct perf_branch_stack	*br_stack;
 	struct perf_regs_user		regs_user;
 	u64				stack_user_size;
@@ -603,6 +629,7 @@ static inline void perf_sample_data_init(struct perf_sample_data *data,
 	data->period = period;
 	data->regs_user.abi = PERF_SAMPLE_REGS_ABI_NONE;
 	data->regs_user.regs = NULL;
+	data->trace.from = data->trace.to = data->trace.size = 0;
 	data->stack_user_size = 0;
 	data->weight = 0;
 	data->data_src.val = 0;
diff --git a/include/uapi/asm-generic/resource.h b/include/uapi/asm-generic/resource.h
index f863428..073f413 100644
--- a/include/uapi/asm-generic/resource.h
+++ b/include/uapi/asm-generic/resource.h
@@ -45,7 +45,8 @@
 					   0-39 for nice level 19 .. -20 */
 #define RLIMIT_RTPRIO		14	/* maximum realtime priority */
 #define RLIMIT_RTTIME		15	/* timeout for RT tasks in us */
-#define RLIM_NLIMITS		16
+#define RLIMIT_ITRACE		16	/* max itrace size */
+#define RLIM_NLIMITS		17
 
 /*
  * SuS says limits have to be unsigned.
diff --git a/include/uapi/linux/elf.h b/include/uapi/linux/elf.h
index ef6103b..4bfbf66 100644
--- a/include/uapi/linux/elf.h
+++ b/include/uapi/linux/elf.h
@@ -369,6 +369,7 @@ typedef struct elf64_shdr {
 #define NT_PRPSINFO	3
 #define NT_TASKSTRUCT	4
 #define NT_AUXV		6
+#define NT_ITRACE	7
 /*
  * Note to userspace developers: size of NT_SIGINFO note may increase
  * in the future to accomodate more fields, don't assume it is fixed!
diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index e1802d6..9e3a890 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -137,8 +137,9 @@ enum perf_event_sample_format {
 	PERF_SAMPLE_DATA_SRC			= 1U << 15,
 	PERF_SAMPLE_IDENTIFIER			= 1U << 16,
 	PERF_SAMPLE_TRANSACTION			= 1U << 17,
+	PERF_SAMPLE_ITRACE			= 1U << 18,
 
-	PERF_SAMPLE_MAX = 1U << 18,		/* non-ABI */
+	PERF_SAMPLE_MAX = 1U << 19,		/* non-ABI */
 };
 
 /*
@@ -237,6 +238,10 @@ enum perf_event_read_format {
 #define PERF_ATTR_SIZE_VER2	80	/* add: branch_sample_type */
 #define PERF_ATTR_SIZE_VER3	96	/* add: sample_regs_user */
 					/* add: sample_stack_user */
+#define PERF_ATTR_SIZE_VER4	120	/* add: itrace_config */
+					/* add: itrace_watermark */
+					/* add: itrace_sample_type */
+					/* add: itrace_sample_size */
 
 /*
  * Hardware event_id to monitor via a performance monitoring event:
@@ -333,6 +338,11 @@ struct perf_event_attr {
 
 	/* Align to u64. */
 	__u32	__reserved_2;
+
+	__u64	itrace_config;
+	__u32	itrace_watermark;	/* wakeup every n pages */
+	__u32	itrace_sample_type;	/* pmu->type of the itrace PMU */
+	__u64	itrace_sample_size;
 };
 
 #define perf_flags(attr)	(*(&(attr)->read_format + 1))
@@ -679,6 +689,8 @@ enum perf_event_type {
 	 *
 	 *	{ u64			weight;   } && PERF_SAMPLE_WEIGHT
 	 *	{ u64			data_src; } && PERF_SAMPLE_DATA_SRC
+	 *	{ u64			size;
+	 *	  char			data[size]; } && PERF_SAMPLE_ITRACE
 	 * };
 	 */
 	PERF_RECORD_SAMPLE			= 9,
@@ -704,9 +716,20 @@ enum perf_event_type {
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
 
+/* Architecture-specific data */
+
+#define PERF_EVENT_ITRACE_OFFSET	0x40000000
+
 #define PERF_MAX_STACK_DEPTH		127
 
 enum perf_callchain_context {
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
index 7c3faf1..ca8a130 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -39,6 +39,7 @@
 #include <linux/hw_breakpoint.h>
 #include <linux/mm_types.h>
 #include <linux/cgroup.h>
+#include <linux/itrace.h>
 
 #include "internal.h"
 
@@ -1575,6 +1576,9 @@ void perf_event_disable(struct perf_event *event)
 	struct perf_event_context *ctx = event->ctx;
 	struct task_struct *task = ctx->task;
 
+	if (event->trace_event)
+		perf_event_disable(event->trace_event);
+
 	if (!task) {
 		/*
 		 * Disable the event on the cpu that it's on
@@ -2071,6 +2075,8 @@ void perf_event_enable(struct perf_event *event)
 	struct perf_event_context *ctx = event->ctx;
 	struct task_struct *task = ctx->task;
 
+	if (event->trace_event)
+		perf_event_enable(event->trace_event);
 	if (!task) {
 		/*
 		 * Enable the event on the cpu that it's on
@@ -3180,9 +3186,6 @@ static void free_event_rcu(struct rcu_head *head)
 	kfree(event);
 }
 
-static void ring_buffer_put(struct ring_buffer *rb);
-static void ring_buffer_detach(struct perf_event *event, struct ring_buffer *rb);
-
 static void unaccount_event_cpu(struct perf_event *event, int cpu)
 {
 	if (event->parent)
@@ -3215,6 +3218,8 @@ static void unaccount_event(struct perf_event *event)
 		static_key_slow_dec_deferred(&perf_sched_events);
 	if (has_branch_stack(event))
 		static_key_slow_dec_deferred(&perf_sched_events);
+	if ((event->attr.sample_type & PERF_SAMPLE_ITRACE) && event->trace_event)
+		itrace_sampler_fini(event);
 
 	unaccount_event_cpu(event, event->cpu);
 }
@@ -3236,28 +3241,31 @@ static void __free_event(struct perf_event *event)
 }
 static void free_event(struct perf_event *event)
 {
+	int rbx;
+
 	irq_work_sync(&event->pending);
 
 	unaccount_event(event);
 
-	if (event->rb) {
-		struct ring_buffer *rb;
+	for (rbx = PERF_RB_MAIN; rbx < PERF_NR_RB; rbx++)
+		if (event->rb[rbx]) {
+			struct ring_buffer *rb;
 
-		/*
-		 * Can happen when we close an event with re-directed output.
-		 *
-		 * Since we have a 0 refcount, perf_mmap_close() will skip
-		 * over us; possibly making our ring_buffer_put() the last.
-		 */
-		mutex_lock(&event->mmap_mutex);
-		rb = event->rb;
-		if (rb) {
-			rcu_assign_pointer(event->rb, NULL);
-			ring_buffer_detach(event, rb);
-			ring_buffer_put(rb); /* could be last */
+			/*
+			 * Can happen when we close an event with re-directed output.
+			 *
+			 * Since we have a 0 refcount, perf_mmap_close() will skip
+			 * over us; possibly making our ring_buffer_put() the last.
+			 */
+			mutex_lock(&event->mmap_mutex);
+			rb = event->rb[rbx];
+			if (rb) {
+				rcu_assign_pointer(event->rb[rbx], NULL);
+				ring_buffer_detach(event, rb);
+				ring_buffer_put(rb); /* could be last */
+			}
+			mutex_unlock(&event->mmap_mutex);
 		}
-		mutex_unlock(&event->mmap_mutex);
-	}
 
 	if (is_cgroup_event(event))
 		perf_detach_cgroup(event);
@@ -3486,21 +3494,24 @@ static unsigned int perf_poll(struct file *file, poll_table *wait)
 {
 	struct perf_event *event = file->private_data;
 	struct ring_buffer *rb;
-	unsigned int events = POLL_HUP;
+	unsigned int events = 0;
+	int i;
 
 	/*
 	 * Pin the event->rb by taking event->mmap_mutex; otherwise
 	 * perf_event_set_output() can swizzle our rb and make us miss wakeups.
 	 */
 	mutex_lock(&event->mmap_mutex);
-	rb = event->rb;
-	if (rb)
-		events = atomic_xchg(&rb->poll, 0);
+	for (i = PERF_RB_MAIN; i < PERF_NR_RB; i++) {
+		rb = event->rb[i];
+		if (rb)
+			events |= atomic_xchg(&rb->poll, 0);
+	}
 	mutex_unlock(&event->mmap_mutex);
 
 	poll_wait(file, &event->waitq, wait);
 
-	return events;
+	return events ? events : POLL_HUP;
 }
 
 static void perf_event_reset(struct perf_event *event)
@@ -3717,7 +3728,7 @@ static void perf_event_init_userpage(struct perf_event *event)
 	struct ring_buffer *rb;
 
 	rcu_read_lock();
-	rb = rcu_dereference(event->rb);
+	rb = rcu_dereference(event->rb[PERF_RB_MAIN]);
 	if (!rb)
 		goto unlock;
 
@@ -3747,7 +3758,7 @@ void perf_event_update_userpage(struct perf_event *event)
 	u64 enabled, running, now;
 
 	rcu_read_lock();
-	rb = rcu_dereference(event->rb);
+	rb = rcu_dereference(event->rb[PERF_RB_MAIN]);
 	if (!rb)
 		goto unlock;
 
@@ -3794,23 +3805,29 @@ static int perf_mmap_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
 	struct perf_event *event = vma->vm_file->private_data;
 	struct ring_buffer *rb;
-	int ret = VM_FAULT_SIGBUS;
+	unsigned long pgoff = vmf->pgoff;
+	int ret = VM_FAULT_SIGBUS, rbx = PERF_RB_MAIN;
+
+	if (is_itrace_event(event) && is_itrace_vma(vma)) {
+		rbx = PERF_RB_ITRACE;
+		pgoff -= PERF_EVENT_ITRACE_PGOFF;
+	}
 
 	if (vmf->flags & FAULT_FLAG_MKWRITE) {
-		if (vmf->pgoff == 0)
+		if (pgoff == 0)
 			ret = 0;
 		return ret;
 	}
 
 	rcu_read_lock();
-	rb = rcu_dereference(event->rb);
+	rb = rcu_dereference(event->rb[rbx]);
 	if (!rb)
 		goto unlock;
 
-	if (vmf->pgoff && (vmf->flags & FAULT_FLAG_WRITE))
+	if (pgoff && (vmf->flags & FAULT_FLAG_WRITE))
 		goto unlock;
 
-	vmf->page = perf_mmap_to_page(rb, vmf->pgoff);
+	vmf->page = perf_mmap_to_page(rb, pgoff);
 	if (!vmf->page)
 		goto unlock;
 
@@ -3825,29 +3842,33 @@ unlock:
 	return ret;
 }
 
-static void ring_buffer_attach(struct perf_event *event,
-			       struct ring_buffer *rb)
+void ring_buffer_attach(struct perf_event *event,
+			struct ring_buffer *rb)
 {
+	int rbx = rb->priv ? PERF_RB_ITRACE : PERF_RB_MAIN;
+	struct list_head *head = &event->rb_entry[rbx];
 	unsigned long flags;
 
-	if (!list_empty(&event->rb_entry))
+	if (!list_empty(head))
 		return;
 
 	spin_lock_irqsave(&rb->event_lock, flags);
-	if (list_empty(&event->rb_entry))
-		list_add(&event->rb_entry, &rb->event_list);
+	if (list_empty(head))
+		list_add(head, &rb->event_list);
 	spin_unlock_irqrestore(&rb->event_lock, flags);
 }
 
-static void ring_buffer_detach(struct perf_event *event, struct ring_buffer *rb)
+void ring_buffer_detach(struct perf_event *event, struct ring_buffer *rb)
 {
+	int rbx = rb->priv ? PERF_RB_ITRACE : PERF_RB_MAIN;
+	struct list_head *head = &event->rb_entry[rbx];
 	unsigned long flags;
 
-	if (list_empty(&event->rb_entry))
+	if (list_empty(head))
 		return;
 
 	spin_lock_irqsave(&rb->event_lock, flags);
-	list_del_init(&event->rb_entry);
+	list_del_init(head);
 	wake_up_all(&event->waitq);
 	spin_unlock_irqrestore(&rb->event_lock, flags);
 }
@@ -3855,12 +3876,16 @@ static void ring_buffer_detach(struct perf_event *event, struct ring_buffer *rb)
 static void ring_buffer_wakeup(struct perf_event *event)
 {
 	struct ring_buffer *rb;
+	struct perf_event *iter;
+	int rbx;
 
 	rcu_read_lock();
-	rb = rcu_dereference(event->rb);
-	if (rb) {
-		list_for_each_entry_rcu(event, &rb->event_list, rb_entry)
-			wake_up_all(&event->waitq);
+	for (rbx = PERF_RB_MAIN; rbx < PERF_NR_RB; rbx++) {
+		rb = rcu_dereference(event->rb[rbx]);
+		if (rb) {
+			list_for_each_entry_rcu(iter, &rb->event_list, rb_entry[rbx])
+				wake_up_all(&iter->waitq);
+		}
 	}
 	rcu_read_unlock();
 }
@@ -3873,12 +3898,12 @@ static void rb_free_rcu(struct rcu_head *rcu_head)
 	rb_free(rb);
 }
 
-static struct ring_buffer *ring_buffer_get(struct perf_event *event)
+struct ring_buffer *ring_buffer_get(struct perf_event *event, int rbx)
 {
 	struct ring_buffer *rb;
 
 	rcu_read_lock();
-	rb = rcu_dereference(event->rb);
+	rb = rcu_dereference(event->rb[rbx]);
 	if (rb) {
 		if (!atomic_inc_not_zero(&rb->refcount))
 			rb = NULL;
@@ -3888,7 +3913,7 @@ static struct ring_buffer *ring_buffer_get(struct perf_event *event)
 	return rb;
 }
 
-static void ring_buffer_put(struct ring_buffer *rb)
+void ring_buffer_put(struct ring_buffer *rb)
 {
 	if (!atomic_dec_and_test(&rb->refcount))
 		return;
@@ -3901,9 +3926,10 @@ static void ring_buffer_put(struct ring_buffer *rb)
 static void perf_mmap_open(struct vm_area_struct *vma)
 {
 	struct perf_event *event = vma->vm_file->private_data;
+	int rbx = is_itrace_vma(vma) ? PERF_RB_ITRACE : PERF_RB_MAIN;
 
-	atomic_inc(&event->mmap_count);
-	atomic_inc(&event->rb->mmap_count);
+	atomic_inc(&event->mmap_count[rbx]);
+	atomic_inc(&event->rb[rbx]->mmap_count);
 }
 
 /*
@@ -3917,19 +3943,19 @@ static void perf_mmap_open(struct vm_area_struct *vma)
 static void perf_mmap_close(struct vm_area_struct *vma)
 {
 	struct perf_event *event = vma->vm_file->private_data;
-
-	struct ring_buffer *rb = event->rb;
+	int rbx = is_itrace_vma(vma) ? PERF_RB_ITRACE : PERF_RB_MAIN;
+	struct ring_buffer *rb = event->rb[rbx];
 	struct user_struct *mmap_user = rb->mmap_user;
 	int mmap_locked = rb->mmap_locked;
 	unsigned long size = perf_data_size(rb);
 
 	atomic_dec(&rb->mmap_count);
 
-	if (!atomic_dec_and_mutex_lock(&event->mmap_count, &event->mmap_mutex))
+	if (!atomic_dec_and_mutex_lock(&event->mmap_count[rbx], &event->mmap_mutex))
 		return;
 
 	/* Detach current event from the buffer. */
-	rcu_assign_pointer(event->rb, NULL);
+	rcu_assign_pointer(event->rb[rbx], NULL);
 	ring_buffer_detach(event, rb);
 	mutex_unlock(&event->mmap_mutex);
 
@@ -3946,7 +3972,7 @@ static void perf_mmap_close(struct vm_area_struct *vma)
 	 */
 again:
 	rcu_read_lock();
-	list_for_each_entry_rcu(event, &rb->event_list, rb_entry) {
+	list_for_each_entry_rcu(event, &rb->event_list, rb_entry[rbx]) {
 		if (!atomic_long_inc_not_zero(&event->refcount)) {
 			/*
 			 * This event is en-route to free_event() which will
@@ -3967,8 +3993,8 @@ again:
 		 * still restart the iteration to make sure we're not now
 		 * iterating the wrong list.
 		 */
-		if (event->rb == rb) {
-			rcu_assign_pointer(event->rb, NULL);
+		if (event->rb[rbx] == rb) {
+			rcu_assign_pointer(event->rb[rbx], NULL);
 			ring_buffer_detach(event, rb);
 			ring_buffer_put(rb); /* can't be last, we still have one */
 		}
@@ -4017,6 +4043,7 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 	unsigned long nr_pages;
 	long user_extra, extra;
 	int ret = 0, flags = 0;
+	int rbx = PERF_RB_MAIN;
 
 	/*
 	 * Don't allow mmap() of inherited per-task counters. This would
@@ -4030,31 +4057,39 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 		return -EINVAL;
 
 	vma_size = vma->vm_end - vma->vm_start;
+
+	if (is_itrace_event(event) && is_itrace_vma(vma))
+		rbx = PERF_RB_ITRACE;
+
 	nr_pages = (vma_size / PAGE_SIZE) - 1;
 
 	/*
 	 * If we have rb pages ensure they're a power-of-two number, so we
 	 * can do bitmasks instead of modulo.
 	 */
-	if (nr_pages != 0 && !is_power_of_2(nr_pages))
-		return -EINVAL;
+	if (!rbx) {
+		if (nr_pages != 0 && !is_power_of_2(nr_pages))
+			return -EINVAL;
+
+		if (vma->vm_pgoff != 0)
+			return -EINVAL;
+	}
 
 	if (vma_size != PAGE_SIZE * (1 + nr_pages))
 		return -EINVAL;
 
-	if (vma->vm_pgoff != 0)
-		return -EINVAL;
 
 	WARN_ON_ONCE(event->ctx->parent_ctx);
 again:
 	mutex_lock(&event->mmap_mutex);
-	if (event->rb) {
-		if (event->rb->nr_pages != nr_pages) {
+	rb = event->rb[rbx];
+	if (rb) {
+		if (rb->nr_pages != nr_pages) {
 			ret = -EINVAL;
 			goto unlock;
 		}
 
-		if (!atomic_inc_not_zero(&event->rb->mmap_count)) {
+		if (!atomic_inc_not_zero(&rb->mmap_count)) {
 			/*
 			 * Raced against perf_mmap_close() through
 			 * perf_event_set_output(). Try again, hope for better
@@ -4091,14 +4126,14 @@ again:
 		goto unlock;
 	}
 
-	WARN_ON(event->rb);
+	WARN_ON(event->rb[rbx]);
 
 	if (vma->vm_flags & VM_WRITE)
 		flags |= RING_BUFFER_WRITABLE;
 
 	rb = rb_alloc(nr_pages, 
 		event->attr.watermark ? event->attr.wakeup_watermark : 0,
-		event->cpu, flags, NULL);
+		event->cpu, flags, rbx ? &itrace_rb_ops : NULL);
 
 	if (!rb) {
 		ret = -ENOMEM;
@@ -4113,14 +4148,14 @@ again:
 	vma->vm_mm->pinned_vm += extra;
 
 	ring_buffer_attach(event, rb);
-	rcu_assign_pointer(event->rb, rb);
+	rcu_assign_pointer(event->rb[rbx], rb);
 
 	perf_event_init_userpage(event);
 	perf_event_update_userpage(event);
 
 unlock:
 	if (!ret)
-		atomic_inc(&event->mmap_count);
+		atomic_inc(&event->mmap_count[rbx]);
 	mutex_unlock(&event->mmap_mutex);
 
 	/*
@@ -4626,6 +4661,13 @@ void perf_output_sample(struct perf_output_handle *handle,
 	if (sample_type & PERF_SAMPLE_TRANSACTION)
 		perf_output_put(handle, data->txn);
 
+	if (sample_type & PERF_SAMPLE_ITRACE) {
+		perf_output_put(handle, data->trace.size);
+
+		if (data->trace.size)
+			itrace_sampler_output(event, handle, data);
+	}
+
 	if (!event->attr.watermark) {
 		int wakeup_events = event->attr.wakeup_events;
 
@@ -4733,6 +4775,14 @@ void perf_prepare_sample(struct perf_event_header *header,
 		data->stack_user_size = stack_size;
 		header->size += size;
 	}
+
+	if (sample_type & PERF_SAMPLE_ITRACE) {
+		u64 size = sizeof(u64);
+
+		size += itrace_sampler_trace(event, data);
+
+		header->size += size;
+	}
 }
 
 static void perf_event_output(struct perf_event *event,
@@ -6652,6 +6702,7 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
 	struct perf_event *event;
 	struct hw_perf_event *hwc;
 	long err = -EINVAL;
+	int rbx;
 
 	if ((unsigned)cpu >= nr_cpu_ids) {
 		if (!task || cpu != -1)
@@ -6675,7 +6726,8 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
 	INIT_LIST_HEAD(&event->group_entry);
 	INIT_LIST_HEAD(&event->event_entry);
 	INIT_LIST_HEAD(&event->sibling_list);
-	INIT_LIST_HEAD(&event->rb_entry);
+	for (rbx = PERF_RB_MAIN; rbx < PERF_NR_RB; rbx++)
+		INIT_LIST_HEAD(&event->rb_entry[rbx]);
 	INIT_LIST_HEAD(&event->active_entry);
 
 	init_waitqueue_head(&event->waitq);
@@ -6702,6 +6754,8 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
 
 		if (attr->type == PERF_TYPE_TRACEPOINT)
 			event->hw.tp_target = task;
+		else if (is_itrace_event(event))
+			event->hw.itrace_target = task;
 #ifdef CONFIG_HAVE_HW_BREAKPOINT
 		/*
 		 * hw_breakpoint is a bit difficult here..
@@ -6751,6 +6805,15 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
 			if (err)
 				goto err_pmu;
 		}
+
+		if (event->attr.sample_type & PERF_SAMPLE_ITRACE) {
+			err = itrace_sampler_init(event, task);
+			if (err) {
+				/* XXX: either clean up callchain buffers too
+				   or forbid them to go together */
+				goto err_pmu;
+			}
+		}
 	}
 
 	return event;
@@ -6901,8 +6964,7 @@ err_size:
 static int
 perf_event_set_output(struct perf_event *event, struct perf_event *output_event)
 {
-	struct ring_buffer *rb = NULL, *old_rb = NULL;
-	int ret = -EINVAL;
+	int ret = -EINVAL, rbx;
 
 	if (!output_event)
 		goto set;
@@ -6922,42 +6984,60 @@ perf_event_set_output(struct perf_event *event, struct perf_event *output_event)
 	 */
 	if (output_event->cpu == -1 && output_event->ctx != event->ctx)
 		goto out;
+	/*
+	 * XXX^2: that's all bollocks
+	 *   + for sampling events, both get to keep their ->trace_event
+	 *   + for normal itrace events, the rules:
+	 *      * no cross-cpu buffers (as any other event);
+	 *      * both must be itrace events
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
-	/* Can't redirect output if we've got an active mmap() */
-	if (atomic_read(&event->mmap_count))
-		goto unlock;
 
-	old_rb = event->rb;
+	for (rbx = PERF_RB_MAIN; rbx < PERF_NR_RB; rbx++) {
+		struct ring_buffer *rb = NULL, *old_rb = NULL;
 
-	if (output_event) {
-		/* get the rb we want to redirect to */
-		rb = ring_buffer_get(output_event);
-		if (!rb)
-			goto unlock;
-	}
+		/* Can't redirect output if we've got an active mmap() */
+		if (atomic_read(&event->mmap_count[rbx]))
+			continue;
 
-	if (old_rb)
-		ring_buffer_detach(event, old_rb);
+		old_rb = event->rb[rbx];
 
-	if (rb)
-		ring_buffer_attach(event, rb);
+		if (output_event) {
+			/* get the rb we want to redirect to */
+			rb = ring_buffer_get(output_event, rbx);
+			if (!rb)
+				continue;
+		}
 
-	rcu_assign_pointer(event->rb, rb);
+		if (old_rb)
+			ring_buffer_detach(event, old_rb);
 
-	if (old_rb) {
-		ring_buffer_put(old_rb);
-		/*
-		 * Since we detached before setting the new rb, so that we
-		 * could attach the new rb, we could have missed a wakeup.
-		 * Provide it now.
-		 */
-		wake_up_all(&event->waitq);
+		if (rb)
+			ring_buffer_attach(event, rb);
+
+		rcu_assign_pointer(event->rb[rbx], rb);
+
+		if (old_rb) {
+			ring_buffer_put(old_rb);
+			/*
+			 * Since we detached before setting the new rb, so that we
+			 * could attach the new rb, we could have missed a wakeup.
+			 * Provide it now.
+			 */
+			wake_up_all(&event->waitq);
+		}
 	}
 
 	ret = 0;
-unlock:
 	mutex_unlock(&event->mmap_mutex);
 
 out:
@@ -7095,6 +7175,10 @@ SYSCALL_DEFINE5(perf_event_open,
 		goto err_alloc;
 	}
 
+	err = itrace_event_installable(event, ctx);
+	if (err)
+		goto err_alloc;
+
 	if (task) {
 		put_task_struct(task);
 		task = NULL;
@@ -7223,6 +7307,9 @@ err_fd:
 	return err;
 }
 
+/* XXX */
+int itrace_kernel_event(struct perf_event *event, struct task_struct *task);
+
 /**
  * perf_event_create_kernel_counter
  *
@@ -7253,12 +7340,20 @@ perf_event_create_kernel_counter(struct perf_event_attr *attr, int cpu,
 
 	account_event(event);
 
+	err = itrace_kernel_event(event, task);
+	if (err)
+		goto err_free;
+
 	ctx = find_get_context(event->pmu, task, cpu);
 	if (IS_ERR(ctx)) {
 		err = PTR_ERR(ctx);
 		goto err_free;
 	}
 
+	err = itrace_event_installable(event, ctx);
+	if (err)
+		goto err_free;
+
 	WARN_ON_ONCE(ctx->parent_ctx);
 	mutex_lock(&ctx->mutex);
 	perf_install_in_context(ctx, event, cpu);
@@ -7536,6 +7631,8 @@ void perf_event_delayed_put(struct task_struct *task)
 		WARN_ON_ONCE(task->perf_event_ctxp[ctxn]);
 }
 
+int itrace_inherit_event(struct perf_event *event, struct task_struct *task);
+
 /*
  * inherit a event from parent task to child task:
  */
@@ -7549,6 +7646,7 @@ inherit_event(struct perf_event *parent_event,
 {
 	struct perf_event *child_event;
 	unsigned long flags;
+	int err;
 
 	/*
 	 * Instead of creating recursive hierarchies of events,
@@ -7567,10 +7665,12 @@ inherit_event(struct perf_event *parent_event,
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
 
@@ -7621,6 +7721,11 @@ inherit_event(struct perf_event *parent_event,
 	mutex_unlock(&parent_event->child_mutex);
 
 	return child_event;
+
+err_alloc:
+	free_event(child_event);
+
+	return NULL;
 }
 
 static int inherit_group(struct perf_event *parent_event,
diff --git a/kernel/events/internal.h b/kernel/events/internal.h
index 8835f00..f183efe 100644
--- a/kernel/events/internal.h
+++ b/kernel/events/internal.h
@@ -45,6 +45,7 @@ struct ring_buffer {
 	atomic_t			mmap_count;
 	unsigned long			mmap_locked;
 	struct user_struct		*mmap_user;
+	void				*priv;
 
 	struct perf_event_mmap_page	*user_page;
 	void				*data_pages[0];
@@ -55,6 +56,12 @@ extern struct ring_buffer *
 rb_alloc(int nr_pages, long watermark, int cpu, int flags,
 	 struct ring_buffer_ops *rb_ops);
 extern void perf_event_wakeup(struct perf_event *event);
+extern struct ring_buffer *ring_buffer_get(struct perf_event *event, int rbx);
+extern void ring_buffer_put(struct ring_buffer *rb);
+extern void ring_buffer_attach(struct perf_event *event,
+			       struct ring_buffer *rb);
+extern void ring_buffer_detach(struct perf_event *event,
+			       struct ring_buffer *rb);
 
 extern void
 perf_event_header__init_id(struct perf_event_header *header,
diff --git a/kernel/events/itrace.c b/kernel/events/itrace.c
new file mode 100644
index 0000000..3adba62
--- /dev/null
+++ b/kernel/events/itrace.c
@@ -0,0 +1,589 @@
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
+#include <linux/sched.h>
+#include <linux/perf_event.h>
+#include <linux/itrace.h>
+#include <linux/sizes.h>
+#include <linux/elf.h>
+#include <linux/coredump.h>
+#include <linux/slab.h>
+
+#include "internal.h"
+
+#define CORE_OWNER "ITRACE"
+
+/*
+ * for the sake of simplicity, we assume that for now we can
+ * only have one type of an itrace pmu in a system
+ */
+static struct itrace_pmu *itrace_pmu;
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
+	if (itrace_pmu && itrace_pmu->pmu.type == type)
+		return itrace_pmu;
+
+	return NULL;
+}
+
+bool is_itrace_event(struct perf_event *event)
+{
+	return !!itrace_pmu_find(event->attr.type);
+}
+
+static void itrace_event_destroy(struct perf_event *event)
+{
+	struct task_struct *task = event->hw.itrace_target;
+	struct ring_buffer *rb = event->rb[PERF_RB_ITRACE];
+
+	if (task && event->hw.counter_type == PERF_ITRACE_COREDUMP)
+		static_key_slow_dec_deferred(&itrace_core_events);
+
+	if (!rb)
+		return;
+
+	if (event->hw.counter_type != PERF_ITRACE_USER) {
+		atomic_dec(&rb->mmap_count);
+		atomic_dec(&event->mmap_count[PERF_RB_ITRACE]);
+		ring_buffer_detach(event, rb);
+		rcu_assign_pointer(event->rb[PERF_RB_ITRACE], NULL);
+		ring_buffer_put(rb); /* should be last */
+	}
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
+	int ret;
+
+	ret = ipmu->event_init(event);
+	if (ret)
+		return ret;
+
+	event->destroy = itrace_event_destroy;
+	event->hw.counter_type = PERF_ITRACE_USER;
+
+	return 0;
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
+	struct itrace_pmu *ipmu = itrace_pmu;
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
+	struct itrace_pmu *ipmu = itrace_pmu;
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
+static size_t roundup_buffer_size(u64 size)
+{
+	return 1ul << (__get_order(size) + PAGE_SHIFT);
+}
+
+int itrace_inherit_event(struct perf_event *event, struct task_struct *task)
+{
+	size_t size = event->attr.itrace_sample_size;
+	struct perf_event *parent = event->parent;
+	struct ring_buffer *rb;
+	struct itrace_pmu *ipmu;
+
+	if (!is_itrace_event(event))
+		return 0;
+
+	ipmu = to_itrace_pmu(event->pmu);
+
+	if (parent->hw.counter_type == PERF_ITRACE_USER) {
+		/*
+		 * inherited user's counters should inherit buffers IF
+		 * they aren't cpu==-1
+		 */
+		if (parent->cpu == -1)
+			return -EINVAL;
+
+		itrace_set_output(event, parent);
+		return 0;
+	}
+
+	event->hw.counter_type = parent->hw.counter_type;
+	if (event->hw.counter_type == PERF_ITRACE_COREDUMP) {
+		static_key_slow_inc(&itrace_core_events.key);
+		size = task_rlimit(task, RLIMIT_ITRACE);
+	}
+
+	size = roundup_buffer_size(size);
+	rb = rb_alloc(size >> PAGE_SHIFT, 0, event->cpu, 0, &itrace_rb_ops);
+	if (!rb)
+		return -ENOMEM;
+
+	ring_buffer_attach(event, rb);
+	rcu_assign_pointer(event->rb[PERF_RB_ITRACE], rb);
+	atomic_set(&rb->mmap_count, 1);
+	atomic_set(&event->mmap_count[PERF_RB_ITRACE], 1);
+
+	return 0;
+}
+
+int itrace_kernel_event(struct perf_event *event, struct task_struct *task)
+{
+	struct itrace_pmu *ipmu;
+	struct ring_buffer *rb;
+	size_t size;
+
+	if (!is_itrace_event(event))
+		return 0;
+
+	ipmu = to_itrace_pmu(event->pmu);
+
+	if (event->attr.itrace_sample_size)
+		size = roundup_buffer_size(event->attr.itrace_sample_size);
+	else
+		size = task_rlimit(task, RLIMIT_ITRACE);
+
+	rb = rb_alloc(size >> PAGE_SHIFT, 0, event->cpu, 0, &itrace_rb_ops);
+	if (!rb)
+		return -ENOMEM;
+
+	ring_buffer_attach(event, rb);
+	rcu_assign_pointer(event->rb[PERF_RB_ITRACE], rb);
+	atomic_set(&rb->mmap_count, 1);
+	atomic_set(&event->mmap_count[PERF_RB_ITRACE], 1);
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
+	if (itrace_pmu)
+		return -EBUSY;
+
+	if (!ipmu->sample_trace    ||
+	    !ipmu->sample_output   ||
+	    !ipmu->core_size       ||
+	    !ipmu->core_output)
+		return -EINVAL;
+
+	ipmu->event_init = ipmu->pmu.event_init;
+	ipmu->pmu.event_init = itrace_event_init;
+
+	ret = perf_pmu_register(&ipmu->pmu, ipmu->name, -1);
+	if (!ret)
+		itrace_pmu = ipmu;
+
+	return ret;
+}
+
+/*
+ * Trace sample annotation
+ * For events that have attr.sample_type & PERF_SAMPLE_ITRACE, perf calls here
+ * to configure and obtain itrace samples.
+ */
+
+int itrace_sampler_init(struct perf_event *event, struct task_struct *task)
+{
+	struct perf_event_attr attr;
+	struct perf_event *tevt;
+	struct itrace_pmu *ipmu;
+
+	ipmu = itrace_pmu_find(event->attr.itrace_sample_type);
+	if (!ipmu)
+		return -ENOTSUPP;
+
+	memset(&attr, 0, sizeof(attr));
+	attr.type = ipmu->pmu.type;
+	attr.config = 0;
+	attr.sample_type = 0;
+	attr.exclude_user = event->attr.exclude_user;
+	attr.exclude_kernel = event->attr.exclude_kernel;
+	attr.itrace_sample_size = event->attr.itrace_sample_size;
+	attr.itrace_config = event->attr.itrace_config;
+
+	tevt = perf_event_create_kernel_counter(&attr, event->cpu, task, NULL, NULL);
+	if (IS_ERR(tevt))
+		return PTR_ERR(tevt);
+
+	if (!itrace_priv(tevt)) {
+		perf_event_release_kernel(tevt);
+		return -EINVAL;
+	}
+
+	event->trace_event = tevt;
+	tevt->hw.counter_type = PERF_ITRACE_SAMPLING;
+	if (event->state != PERF_EVENT_STATE_OFF)
+		perf_event_enable(event->trace_event);
+
+	return 0;
+}
+
+void itrace_sampler_fini(struct perf_event *event)
+{
+	struct perf_event *tevt = event->trace_event;
+
+	perf_event_release_kernel(tevt);
+	event->trace_event = NULL;
+}
+
+unsigned long itrace_sampler_trace(struct perf_event *event,
+				   struct perf_sample_data *data)
+{
+	struct perf_event *tevt = event->trace_event;
+	struct itrace_pmu *ipmu;
+
+	if (!tevt)
+		return 0;
+
+	ipmu = to_itrace_pmu(tevt->pmu);
+	return ipmu->sample_trace(tevt, data);
+}
+
+void itrace_sampler_output(struct perf_event *event,
+			   struct perf_output_handle *handle,
+			   struct perf_sample_data *data)
+{
+	struct perf_event *tevt = event->trace_event;
+	struct itrace_pmu *ipmu;
+
+	if (!tevt || !data->trace.size)
+		return;
+
+	ipmu = to_itrace_pmu(tevt->pmu);
+	ipmu->sample_output(tevt, handle, data);
+}
+
+/*
+ * Core dump bits
+ *
+ * Various parts of the kernel will call here:
+ *   + do_prlimit(): to tell us that the user is trying to set RLIMIT_ITRACE
+ *   + various places in bitfmt_elf.c: to write out itrace notes
+ *   + do_exit(): to destroy the first core dump counter
+ *   + the rest (copy_process()/do_exit()) is taken care of by perf for us
+ */
+
+static struct perf_event *
+itrace_find_task_event(struct task_struct *task, unsigned type)
+{
+	struct perf_event_context *ctx;
+	struct perf_event *event = NULL;
+
+	rcu_read_lock();
+	ctx = rcu_dereference(task->perf_event_ctxp[perf_hw_context]);
+	if (!ctx)
+		goto out;
+
+	list_for_each_entry_rcu(event, &ctx->event_list, event_entry) {
+		if (is_itrace_event(event) &&
+		    event->cpu == -1 &&
+		    !!(event->hw.counter_type & type))
+			goto out;
+	}
+
+	event = NULL;
+out:
+	rcu_read_unlock();
+
+	return event;
+}
+
+int update_itrace_rlimit(struct task_struct *task, unsigned long rlim)
+{
+	struct itrace_pmu *ipmu = itrace_pmu;
+	struct perf_event_attr attr;
+	struct perf_event *event;
+
+	event = itrace_find_task_event(task, PERF_ITRACE_ANY);
+	if (event) {
+		if (event->hw.counter_type != PERF_ITRACE_COREDUMP)
+			return -EINVAL;
+
+		perf_event_release_kernel(event);
+		static_key_slow_dec_deferred(&itrace_core_events);
+	}
+
+	if (!rlim)
+		return 0;
+
+	memset(&attr, 0, sizeof(attr));
+	attr.type = ipmu->pmu.type;
+	attr.config = 0;
+	attr.sample_type = 0;
+	attr.exclude_kernel = 1;
+	attr.inherit = 1;
+
+	event = perf_event_create_kernel_counter(&attr, -1, task, NULL, NULL);
+	if (IS_ERR(event))
+		return PTR_ERR(event);
+
+	static_key_slow_inc(&itrace_core_events.key);
+
+	event->hw.counter_type = PERF_ITRACE_COREDUMP;
+	perf_event_enable(event);
+
+	return 0;
+}
+
+static void itrace_pmu_exit_task(struct task_struct *task)
+{
+	struct perf_event *event;
+
+	event = itrace_find_task_event(task, PERF_ITRACE_COREDUMP);
+
+	/*
+	 * here we are only interested in kernel counters created by
+	 * update_itrace_rlimit(), inherited ones should be taken care of by
+	 * perf_event_exit_task(), sampling ones are taken care of by
+	 * itrace_sampler_fini().
+	 */
+	if (!event)
+		return;
+
+	if (!event->parent)
+		perf_event_release_kernel(event);
+}
+
+void exit_itrace(struct task_struct *task)
+{
+	if (static_key_false(&itrace_core_events.key))
+		itrace_pmu_exit_task(task);
+}
+
+size_t itrace_elf_note_size(struct task_struct *task)
+{
+	struct itrace_pmu *ipmu;
+	struct perf_event *event = NULL;
+	size_t size = 0;
+
+	event = itrace_find_task_event(task, PERF_ITRACE_COREDUMP);
+	if (event) {
+		perf_event_disable(event);
+
+		ipmu = to_itrace_pmu(event->pmu);
+		size = ipmu->core_size(event);
+		size += task_rlimit(task, RLIMIT_ITRACE);
+		size = roundup(size + strlen(ipmu->name) + 1, 4);
+		size += sizeof(struct itrace_note) + sizeof(struct elf_note);
+		size += roundup(sizeof(CORE_OWNER), 4);
+	}
+
+	return size;
+}
+
+void itrace_elf_note_write(struct coredump_params *cprm,
+			   struct task_struct *task)
+{
+	struct perf_event *event;
+	struct itrace_note note;
+	struct itrace_pmu *ipmu;
+	struct elf_note en;
+	unsigned long rlim;
+	size_t pmu_len;
+
+	event = itrace_find_task_event(task, PERF_ITRACE_COREDUMP);
+	if (!event)
+		return;
+
+	ipmu = to_itrace_pmu(event->pmu);
+	pmu_len = strlen(ipmu->name) + 1;
+
+	rlim = task_rlimit(task, RLIMIT_ITRACE);
+
+	/* Elf note with name */
+	en.n_namesz = strlen(CORE_OWNER);
+	en.n_descsz = roundup(ipmu->core_size(event) + rlim + sizeof(note) +
+			      pmu_len, 4);
+	en.n_type = NT_ITRACE;
+	dump_emit(cprm, &en, sizeof(en));
+	dump_align(cprm, 4);
+	dump_emit(cprm, CORE_OWNER, sizeof(CORE_OWNER));
+	dump_align(cprm, 4);
+
+	/* ITRACE header */
+	note.itrace_config = event->attr.itrace_config;
+	dump_emit(cprm, &note, sizeof(note));
+	dump_emit(cprm, ipmu->name, pmu_len);
+
+	/* ITRACE PMU header + payload */
+	ipmu->core_output(cprm, event, rlim);
+	dump_align(cprm, 4);
+}
+
diff --git a/kernel/events/ring_buffer.c b/kernel/events/ring_buffer.c
index d7ec426..0bee352 100644
--- a/kernel/events/ring_buffer.c
+++ b/kernel/events/ring_buffer.c
@@ -119,7 +119,7 @@ int perf_output_begin(struct perf_output_handle *handle,
 	if (event->parent)
 		event = event->parent;
 
-	rb = rcu_dereference(event->rb);
+	rb = rcu_dereference(event->rb[PERF_RB_MAIN]);
 	if (unlikely(!rb))
 		goto out;
 
diff --git a/kernel/exit.c b/kernel/exit.c
index a949819..28138ef 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -48,6 +48,7 @@
 #include <linux/fs_struct.h>
 #include <linux/init_task.h>
 #include <linux/perf_event.h>
+#include <linux/itrace.h>
 #include <trace/events/sched.h>
 #include <linux/hw_breakpoint.h>
 #include <linux/oom.h>
@@ -788,6 +789,8 @@ void do_exit(long code)
 	check_stack_usage();
 	exit_thread();
 
+	exit_itrace(tsk);
+
 	/*
 	 * Flush inherited counters to the parent - before the parent
 	 * gets woken up by child-exit notifications.
diff --git a/kernel/sys.c b/kernel/sys.c
index c723113..7651d6f 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -14,6 +14,7 @@
 #include <linux/fs.h>
 #include <linux/kmod.h>
 #include <linux/perf_event.h>
+#include <linux/itrace.h>
 #include <linux/resource.h>
 #include <linux/kernel.h>
 #include <linux/workqueue.h>
@@ -1402,6 +1403,10 @@ int do_prlimit(struct task_struct *tsk, unsigned int resource,
 		update_rlimit_cpu(tsk, new_rlim->rlim_cur);
 out:
 	read_unlock(&tasklist_lock);
+
+	if (!retval && new_rlim && resource == RLIMIT_ITRACE)
+		retval = update_itrace_rlimit(tsk, new_rlim->rlim_cur);
+
 	return retval;
 }
 
-- 
1.8.5.1

