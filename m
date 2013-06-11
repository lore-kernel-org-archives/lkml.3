Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755413Ab3FKQrj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 12:47:39 -0400
Received: from mail-bk0-f53.google.com ([209.85.214.53]:64027 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755226Ab3FKQm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 12:42:57 -0400
From: Robert Richter <rric@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Borislav Petkov <bp@suse.de>,
        Robert Richter <robert.richter@linaro.org>,
        Robert Richter <rric@kernel.org>
Subject: [PATCH v2 03/14] perf: Add persistent event facilities
Date: Tue, 11 Jun 2013 18:42:29 +0200
Message-Id: <1370968960-22527-4-git-send-email-rric@kernel.org>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1370968960-22527-1-git-send-email-rric@kernel.org>
References: <1370968960-22527-1-git-send-email-rric@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@alien8.de>

Add a barebones implementation for registering persistent events with
perf. For that, we don't destroy the buffers when they're unmapped;
also, we map them read-only so that multiple agents can access them.

Also, we allocate the event buffers at event init time and not at mmap
time so that we can log samples into them regardless of whether there
are readers in userspace or not.

Changes made by Robert Richter <robert.richter@linaro.org>:

* Fixing wrongly determined attribute size.

* The default buffer size used to setup event buffers with perf tools
  is 512k. Using the same buffer size for persistent events. This also
  avoids failed mmap calls due to different buffer sizes.

* Improve error reporting.

* Returning -ENODEV if no file descriptor is found. An error code of
  -1 (-EPERM) is misleading in this case.

* Adding cpu check to perf_get_persistent_event_fd()

[ make percpu variable static ]
Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
[ Fix attr size ]
[ Setting default buffer size to 512k as in perf tools ]
[ Print error code on failure when adding events ]
[ Return resonable error code ]
[ Adding cpu check to perf_get_persistent_event_fd() ]
Reported-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Robert Richter <robert.richter@linaro.org>
Signed-off-by: Robert Richter <rric@kernel.org>
---
 include/linux/perf_event.h |  16 +++-
 kernel/events/Makefile     |   2 +-
 kernel/events/core.c       |  13 ++--
 kernel/events/internal.h   |   4 +
 kernel/events/persistent.c | 181 +++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 207 insertions(+), 9 deletions(-)
 create mode 100644 kernel/events/persistent.c

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 6fddac1..d2a42b7 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -518,6 +518,13 @@ struct perf_output_handle {
 	int				page;
 };
 
+struct pers_event_desc {
+	struct perf_event_attr *attr;
+	struct perf_event *event;
+	struct list_head plist;
+	int fd;
+};
+
 #ifdef CONFIG_PERF_EVENTS
 
 extern int perf_pmu_register(struct pmu *pmu, char *name, int type);
@@ -750,7 +757,9 @@ extern void perf_event_enable(struct perf_event *event);
 extern void perf_event_disable(struct perf_event *event);
 extern int __perf_event_disable(void *info);
 extern void perf_event_task_tick(void);
-#else
+extern int perf_add_persistent_event(struct perf_event_attr *, unsigned);
+extern int perf_add_persistent_event_by_id(int id);
+#else /* !CONFIG_PERF_EVENTS */
 static inline void
 perf_event_task_sched_in(struct task_struct *prev,
 			 struct task_struct *task)			{ }
@@ -790,7 +799,10 @@ static inline void perf_event_enable(struct perf_event *event)		{ }
 static inline void perf_event_disable(struct perf_event *event)		{ }
 static inline int __perf_event_disable(void *info)			{ return -1; }
 static inline void perf_event_task_tick(void)				{ }
-#endif
+static inline int perf_add_persistent_event(struct perf_event_attr *attr,
+					    unsigned nr_pages)		{ return -EINVAL; }
+static inline int perf_add_persistent_event_by_id(int id)		{ return -EINVAL; }
+#endif /* !CONFIG_PERF_EVENTS */
 
 #if defined(CONFIG_PERF_EVENTS) && defined(CONFIG_NO_HZ_FULL)
 extern bool perf_event_can_stop_tick(void);
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
index a13e457..a9b6470 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3021,8 +3021,6 @@ static void free_event_rcu(struct rcu_head *head)
 	kfree(event);
 }
 
-static void rb_put(struct ring_buffer *rb);
-
 static void free_event(struct perf_event *event)
 {
 	irq_work_sync(&event->pending);
@@ -3398,8 +3396,6 @@ unlock:
 	return ret;
 }
 
-static const struct file_operations perf_fops;
-
 static inline int perf_fget_light(int fd, struct fd *p)
 {
 	struct fd f = fdget(fd);
@@ -3684,7 +3680,7 @@ static struct ring_buffer *rb_get(struct perf_event *event)
 	return rb;
 }
 
-static void rb_put(struct ring_buffer *rb)
+void rb_put(struct ring_buffer *rb)
 {
 	struct perf_event *event, *n;
 	unsigned long flags;
@@ -3866,7 +3862,7 @@ static int perf_fasync(int fd, struct file *filp, int on)
 	return 0;
 }
 
-static const struct file_operations perf_fops = {
+const struct file_operations perf_fops = {
 	.llseek			= no_llseek,
 	.release		= perf_release,
 	.read			= perf_read,
@@ -6623,6 +6619,9 @@ SYSCALL_DEFINE5(perf_event_open,
 	if (err)
 		return err;
 
+	if (attr.persistent)
+		return perf_get_persistent_event_fd(cpu, &attr);
+
 	if (!attr.exclude_kernel) {
 		if (perf_paranoid_kernel() && !capable(CAP_SYS_ADMIN))
 			return -EACCES;
@@ -7579,6 +7578,8 @@ void __init perf_event_init(void)
 	 */
 	BUILD_BUG_ON((offsetof(struct perf_event_mmap_page, data_head))
 		     != 1024);
+
+	persistent_events_init();
 }
 
 static int __init perf_event_sysfs_init(void)
diff --git a/kernel/events/internal.h b/kernel/events/internal.h
index eb675c4..3b481be 100644
--- a/kernel/events/internal.h
+++ b/kernel/events/internal.h
@@ -38,6 +38,7 @@ struct ring_buffer {
 extern void rb_free(struct ring_buffer *rb);
 extern struct ring_buffer *
 rb_alloc(int nr_pages, long watermark, int cpu, int flags);
+extern void rb_put(struct ring_buffer *rb);
 extern void perf_event_wakeup(struct perf_event *event);
 
 extern void
@@ -174,4 +175,7 @@ static inline bool arch_perf_have_user_stack_dump(void)
 #define perf_user_stack_pointer(regs) 0
 #endif /* CONFIG_HAVE_PERF_USER_STACK_DUMP */
 
+extern const struct file_operations perf_fops;
+extern int perf_get_persistent_event_fd(unsigned cpu, struct perf_event_attr *attr);
+extern void __init persistent_events_init(void);
 #endif /* _KERNEL_EVENTS_INTERNAL_H */
diff --git a/kernel/events/persistent.c b/kernel/events/persistent.c
new file mode 100644
index 0000000..53411b4
--- /dev/null
+++ b/kernel/events/persistent.c
@@ -0,0 +1,181 @@
+#include <linux/slab.h>
+#include <linux/file.h>
+#include <linux/perf_event.h>
+#include <linux/anon_inodes.h>
+
+#include "internal.h"
+
+/* 512 kiB: default perf tools memory size, see perf_evlist__mmap() */
+#define CPU_BUFFER_NR_PAGES	((512 * 1024) / PAGE_SIZE)
+
+static DEFINE_PER_CPU(struct list_head, pers_events);
+
+static struct perf_event *
+add_persistent_event_on_cpu(unsigned int cpu, struct perf_event_attr *attr,
+			    unsigned nr_pages)
+{
+	struct perf_event *event = ERR_PTR(-ENOMEM);
+	struct pers_event_desc *desc;
+	struct ring_buffer *buf;
+
+	desc = kzalloc(sizeof(*desc), GFP_KERNEL);
+	if (!desc)
+		goto out;
+
+	buf = rb_alloc(nr_pages, 0, cpu, 0);
+	if (!buf)
+		goto err_rb;
+
+	event = perf_event_create_kernel_counter(attr, cpu, NULL, NULL, NULL);
+	if (IS_ERR(event))
+		goto err_event;
+
+	rcu_assign_pointer(event->rb, buf);
+
+	desc->event = event;
+	desc->attr  = attr;
+
+	INIT_LIST_HEAD(&desc->plist);
+	list_add_tail(&desc->plist, &per_cpu(pers_events, cpu));
+
+	/* All workie, enable event now */
+	perf_event_enable(event);
+
+	goto out;
+
+ err_event:
+	rb_put(buf);
+
+ err_rb:
+	kfree(desc);
+
+ out:
+	return event;
+}
+
+static void del_persistent_event(int cpu, struct perf_event_attr *attr)
+{
+	struct pers_event_desc *desc, *tmp;
+	struct perf_event *event = NULL;
+
+	list_for_each_entry_safe(desc, tmp, &per_cpu(pers_events, cpu), plist) {
+		if (desc->attr->config == attr->config) {
+			event = desc->event;
+			break;
+		}
+	}
+
+	if (!event)
+		return;
+
+	list_del(&desc->plist);
+
+	perf_event_disable(event);
+	if (event->rb) {
+		rb_put(event->rb);
+		rcu_assign_pointer(event->rb, NULL);
+	}
+
+	perf_event_release_kernel(event);
+	put_unused_fd(desc->fd);
+	kfree(desc->attr);
+	kfree(desc);
+}
+
+static int __alloc_persistent_event_fd(struct pers_event_desc *desc)
+{
+	struct file *event_file = NULL;
+	int event_fd = -1;
+
+	event_fd = get_unused_fd();
+	if (event_fd < 0)
+		goto out;
+
+	event_file = anon_inode_getfile("[pers_event]", &perf_fops,
+					desc->event, O_RDONLY);
+	if (IS_ERR(event_file))
+		goto err_event_file;
+
+	desc->fd = event_fd;
+	fd_install(event_fd, event_file);
+
+	goto out;
+
+
+ err_event_file:
+	put_unused_fd(event_fd);
+
+ out:
+	return event_fd;
+}
+
+/*
+ * Create and enable the persistent version of the perf event described by
+ * @attr.
+ *
+ * @attr: perf event descriptor
+ * @nr_pages: size in pages
+ */
+int perf_add_persistent_event(struct perf_event_attr *attr, unsigned nr_pages)
+{
+	struct perf_event *event;
+	int i;
+
+	for_each_possible_cpu(i) {
+		event = add_persistent_event_on_cpu(i, attr, nr_pages);
+		if (IS_ERR(event))
+			goto unwind;
+	}
+	return 0;
+
+unwind:
+	pr_err("%s: Error adding persistent event on cpu %d: %ld\n",
+		__func__, i, PTR_ERR(event));
+
+	while (--i >= 0)
+		del_persistent_event(i, attr);
+
+	return PTR_ERR(event);
+}
+
+int perf_add_persistent_event_by_id(int id)
+{
+	struct perf_event_attr *attr;
+
+	attr = kzalloc(sizeof(*attr), GFP_KERNEL);
+	if (!attr)
+		return -ENOMEM;
+
+	attr->sample_period	= 1;
+	attr->wakeup_events	= 1;
+	attr->sample_type	= PERF_SAMPLE_RAW;
+	attr->persistent	= 1;
+	attr->config		= id;
+	attr->type		= PERF_TYPE_TRACEPOINT;
+	attr->size		= sizeof(*attr);
+
+	return perf_add_persistent_event(attr, CPU_BUFFER_NR_PAGES);
+}
+
+int perf_get_persistent_event_fd(unsigned cpu, struct perf_event_attr *attr)
+{
+	struct pers_event_desc *desc;
+
+	if (cpu >= (unsigned)nr_cpu_ids)
+		return -EINVAL;
+
+	list_for_each_entry(desc, &per_cpu(pers_events, cpu), plist)
+		if (desc->attr->config == attr->config)
+			return __alloc_persistent_event_fd(desc);
+
+	return -ENODEV;
+}
+
+
+void __init persistent_events_init(void)
+{
+	int i;
+
+	for_each_possible_cpu(i)
+		INIT_LIST_HEAD(&per_cpu(pers_events, i));
+}
-- 
1.8.1.1

