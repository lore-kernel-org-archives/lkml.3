Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932419AbaBFKv3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 05:51:29 -0500
Received: from mga03.intel.com ([143.182.124.21]:32686 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932299AbaBFKvZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 05:51:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,793,1384329600"; 
   d="scan'208";a="470754037"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Subject: [PATCH v1 06/11] itrace: Add functionality to include traces in process core dumps
Date: Thu,  6 Feb 2014 12:50:29 +0200
Message-Id: <1391683834-29868-7-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc2
In-Reply-To: <1391683834-29868-1-git-send-email-alexander.shishkin@linux.intel.com>
References: <1391683834-29868-1-git-send-email-alexander.shishkin@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Per thread trace data that is provided by itrace PMUs can be included in
process core dumps, which is controlled via a new rlimit parameter
RLIMIT_ITRACE. This is done by a per-thread kernel counter that is
created when this RLIMIT_ITRACE is set.

The value of RLIMIT_ITRACE indicates the size of the per-thread elf note
in a core dump and the buffer size used to collect corresponding trace.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
---
 fs/binfmt_elf.c                     |   6 +
 fs/proc/base.c                      |   1 +
 include/asm-generic/resource.h      |   1 +
 include/linux/itrace.h              |  36 +++++
 include/linux/perf_event.h          |   3 +
 include/uapi/asm-generic/resource.h |   3 +-
 include/uapi/linux/elf.h            |   1 +
 kernel/events/itrace.c              | 289 +++++++++++++++++++++++++++++++++++-
 kernel/exit.c                       |   3 +
 kernel/sys.c                        |   5 +
 10 files changed, 343 insertions(+), 5 deletions(-)

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
index 03c8d74..69935a9 100644
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
index 6adbb32..c1eb6d3 100644
--- a/include/linux/itrace.h
+++ b/include/linux/itrace.h
@@ -22,6 +22,7 @@
 
 #include <linux/perf_event.h>
 #include <linux/file.h>
+#include <linux/coredump.h>
 
 extern struct ring_buffer_ops itrace_rb_ops;
 
@@ -66,6 +67,19 @@ struct itrace_pmu {
 	void			(*sample_output)(struct perf_event *event,
 						 struct perf_output_handle *handle,
 						 struct perf_sample_data *data);
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
+	u64			coredump_config;
 	char			*name;
 };
 
@@ -95,6 +109,17 @@ extern unsigned long itrace_sampler_trace(struct perf_event *event,
 extern void itrace_sampler_output(struct perf_event *event,
 				  struct perf_output_handle *handle,
 				  struct perf_sample_data *data);
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
 #else
 static int itrace_kernel_event(struct perf_event *event,
 			       struct task_struct *task)	{ return 0; }
@@ -121,6 +146,17 @@ static inline void
 itrace_sampler_output(struct perf_event *event,
 		      struct perf_output_handle *handle,
 		      struct perf_sample_data *data)		{}
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
 #endif
 
 #endif /* _LINUX_PERF_EVENT_H */
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 11eb133..8353d7f 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -106,6 +106,9 @@ struct event_constraint;
 enum perf_itrace_counter_type {
 	PERF_ITRACE_USER	= BIT(1),
 	PERF_ITRACE_SAMPLING	= BIT(2),
+	PERF_ITRACE_COREDUMP	= BIT(3),
+	PERF_ITRACE_KERNEL	= (PERF_ITRACE_SAMPLING | PERF_ITRACE_COREDUMP),
+	PERF_ITRACE_ANY		= (PERF_ITRACE_KERNEL | PERF_ITRACE_USER),
 };
 
 /**
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
diff --git a/kernel/events/itrace.c b/kernel/events/itrace.c
index f003530..1cc9a36 100644
--- a/kernel/events/itrace.c
+++ b/kernel/events/itrace.c
@@ -20,15 +20,21 @@
 #undef DEBUG
 
 #include <linux/kernel.h>
+#include <linux/sched.h>
 #include <linux/perf_event.h>
 #include <linux/itrace.h>
 #include <linux/sizes.h>
+#include <linux/elf.h>
+#include <linux/coredump.h>
 #include <linux/slab.h>
 
 #include "internal.h"
 
 static LIST_HEAD(itrace_pmus);
 static DEFINE_MUTEX(itrace_pmus_mutex);
+static struct itrace_pmu *itrace_pmu_coredump;
+
+#define CORE_OWNER "ITRACE"
 
 struct static_key_deferred itrace_core_events __read_mostly;
 
@@ -91,8 +97,12 @@ bool is_itrace_event(struct perf_event *event)
 
 static void itrace_event_destroy(struct perf_event *event)
 {
+	struct task_struct *task = event->hw.itrace_target;
 	struct ring_buffer *rb = event->rb[PERF_RB_ITRACE];
 
+	if (task && event->hw.counter_type == PERF_ITRACE_COREDUMP)
+		static_key_slow_dec_deferred(&itrace_core_events);
+
 	if (!rb)
 		return;
 
@@ -268,6 +278,10 @@ int itrace_inherit_event(struct perf_event *event, struct task_struct *task)
 	}
 
 	event->hw.counter_type = parent->hw.counter_type;
+	if (event->hw.counter_type == PERF_ITRACE_COREDUMP) {
+		static_key_slow_inc(&itrace_core_events.key);
+		size = task_rlimit(task, RLIMIT_ITRACE);
+	}
 
 	size = roundup_buffer_size(size);
 	rb = rb_alloc(event, size >> PAGE_SHIFT, 0, event->cpu, 0,
@@ -294,10 +308,10 @@ int itrace_kernel_event(struct perf_event *event, struct task_struct *task)
 
 	ipmu = to_itrace_pmu(event->pmu);
 
-	if (!event->attr.itrace_sample_size)
-		return 0;
-
-	size = roundup_buffer_size(event->attr.itrace_sample_size);
+	if (event->attr.itrace_sample_size)
+		size = roundup_buffer_size(event->attr.itrace_sample_size);
+	else
+		size = task_rlimit(task, RLIMIT_ITRACE);
 
 	rb = rb_alloc(event, size >> PAGE_SHIFT, 0, event->cpu, 0,
 		      &itrace_rb_ops);
@@ -325,6 +339,104 @@ void itrace_wake_up(struct perf_event *event)
 	rcu_read_unlock();
 }
 
+static ssize_t
+coredump_show(struct device *dev,
+	      struct device_attribute *attr,
+	      char *page)
+{
+	struct pmu *pmu = dev_get_drvdata(dev);
+	struct itrace_pmu *ipmu = to_itrace_pmu(pmu);
+	int ret;
+
+	mutex_lock(&itrace_pmus_mutex);
+	ret = itrace_pmu_coredump == ipmu;
+	mutex_unlock(&itrace_pmus_mutex);
+
+	return snprintf(page, PAGE_SIZE-1, "%d\n", ret);
+}
+
+static ssize_t
+coredump_store(struct device *dev,
+	       struct device_attribute *attr,
+	       const char *buf, size_t count)
+{
+	struct pmu *pmu = dev_get_drvdata(dev);
+	struct itrace_pmu *ipmu = to_itrace_pmu(pmu);
+
+	mutex_lock(&itrace_pmus_mutex);
+	if (ipmu->core_size && ipmu->core_output)
+		itrace_pmu_coredump = ipmu;
+	mutex_unlock(&itrace_pmus_mutex);
+
+	return count;
+}
+static DEVICE_ATTR_RW(coredump);
+
+static ssize_t
+coredump_config_show(struct device *dev,
+		     struct device_attribute *attr,
+		     char *page)
+{
+	struct pmu *pmu = dev_get_drvdata(dev);
+	struct itrace_pmu *ipmu = to_itrace_pmu(pmu);
+
+	return snprintf(page, PAGE_SIZE-1, "%016llx\n", ipmu->coredump_config);
+}
+
+static ssize_t
+coredump_config_store(struct device *dev,
+		      struct device_attribute *attr,
+		      const char *buf, size_t count)
+{
+	struct pmu *pmu = dev_get_drvdata(dev);
+	struct itrace_pmu *ipmu = to_itrace_pmu(pmu);
+	u64 config;
+	int ret;
+
+	ret = kstrtou64(buf, 0, &config);
+	if (ret)
+		return ret;
+
+	ipmu->coredump_config = config;
+
+	return count;
+}
+static DEVICE_ATTR_RW(coredump_config);
+
+static struct attribute *itrace_attrs[] = {
+	&dev_attr_coredump.attr,
+	&dev_attr_coredump_config.attr,
+	NULL,
+};
+
+struct attribute_group itrace_group = {
+	.attrs	= itrace_attrs,
+};
+
+static const struct attribute_group **
+itrace_get_attr_groups(const struct attribute_group **pgroups)
+{
+	const struct attribute_group **groups;
+	int i, ngroups;
+	size_t size;
+
+	for (i = 0, ngroups = 2; pgroups[i]; i++, ngroups++)
+		;
+
+	size = sizeof(struct attribute_group *) * ngroups;
+	groups = kzalloc(size, GFP_KERNEL);
+	if (!groups)
+		goto out;
+
+	for (i = 0; pgroups[i]; i++)
+		groups[i] = pgroups[i];
+
+	groups[i] = &itrace_group;
+
+out:
+	return groups;
+}
+
 int itrace_pmu_register(struct itrace_pmu *ipmu)
 {
 	int ret;
@@ -334,6 +446,7 @@ int itrace_pmu_register(struct itrace_pmu *ipmu)
 
 	ipmu->event_init = ipmu->pmu.event_init;
 	ipmu->pmu.event_init = itrace_event_init;
+	ipmu->pmu.attr_groups = itrace_get_attr_groups(ipmu->pmu.attr_groups);
 
 	ret = perf_pmu_register(&ipmu->pmu, ipmu->name, -1);
 	if (ret)
@@ -341,6 +454,8 @@ int itrace_pmu_register(struct itrace_pmu *ipmu)
 
 	mutex_lock(&itrace_pmus_mutex);
 	list_add_tail_rcu(&ipmu->entry, &itrace_pmus);
+	if (ipmu->core_size && ipmu->core_output)
+		itrace_pmu_coredump = ipmu;
 	mutex_unlock(&itrace_pmus_mutex);
 
 	return ret;
@@ -422,3 +537,169 @@ void itrace_sampler_output(struct perf_event *event,
 	ipmu = to_itrace_pmu(tevt->pmu);
 	ipmu->sample_output(tevt, handle, data);
 }
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
+
+	mutex_lock(&itrace_pmus_mutex);
+	if (!itrace_pmu_coredump) {
+		mutex_unlock(&itrace_pmus_mutex);
+		return -ENOTSUPP;
+	}
+
+	attr.type = itrace_pmu_coredump->pmu.type;
+	attr.config = 0;
+	attr.sample_type = 0;
+	attr.exclude_kernel = 1;
+	attr.inherit = 1;
+	attr.itrace_config = itrace_pmu_coredump->coredump_config;
+
+	event = perf_event_create_kernel_counter(&attr, -1, task, NULL, NULL);
+	mutex_unlock(&itrace_pmus_mutex);
+
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
1.8.5.2

