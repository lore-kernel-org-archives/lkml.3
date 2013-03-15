Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755101Ab3CONPB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 09:15:01 -0400
Received: from mail.skyhub.de ([78.46.96.112]:52642 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754694Ab3CONGk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 09:06:40 -0400
From: Borislav Petkov <bp@alien8.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Borislav Petkov <bp@alien8.de>, Robert Richter <rric@kernel.org>,
        Borislav Petkov <bp@suse.de>
Subject: [RFC PATCH 2/3] perf: Add persistent event facilities
Date: Fri, 15 Mar 2013 14:06:28 +0100
Message-Id: <1363352789-17991-3-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.1.3.535.ga923c31
In-Reply-To: <1363352789-17991-1-git-send-email-bp@alien8.de>
References: <1363352789-17991-1-git-send-email-bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a barebones implementation for registering persistent events with
perf. For that, we don't destroy the buffers when they're unmapped;
also, we map them read-only so that multiple agents can access them.

Also, we allocate the event buffers at event init time and not at mmap
time so that we can log samples into them regardless of whether there
are readers in userspace or not.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 include/linux/perf_event.h |  14 ++++-
 kernel/events/Makefile     |   2 +-
 kernel/events/core.c       |  19 +++---
 kernel/events/internal.h   |   4 ++
 kernel/events/persistent.c | 148 +++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 175 insertions(+), 12 deletions(-)
 create mode 100644 kernel/events/persistent.c

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index e47ee462c2f2..e3e4b64c9286 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -531,6 +531,13 @@ struct perf_output_handle {
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
@@ -758,7 +765,8 @@ extern void perf_event_enable(struct perf_event *event);
 extern void perf_event_disable(struct perf_event *event);
 extern int __perf_event_disable(void *info);
 extern void perf_event_task_tick(void);
-#else
+extern int perf_add_persistent_event(struct perf_event_attr *, unsigned);
+#else /* !CONFIG_PERF_EVENTS */
 static inline void
 perf_event_task_sched_in(struct task_struct *prev,
 			 struct task_struct *task)			{ }
@@ -797,7 +805,9 @@ static inline void perf_event_enable(struct perf_event *event)		{ }
 static inline void perf_event_disable(struct perf_event *event)		{ }
 static inline int __perf_event_disable(void *info)			{ return -1; }
 static inline void perf_event_task_tick(void)				{ }
-#endif
+static inline int perf_add_persistent_event(struct perf_event_attr *attr,
+					    unsigned nr_pages)		{ return -EINVAL; }
+#endif /* !CONFIG_PERF_EVENTS */
 
 #define perf_output_put(handle, x) perf_output_copy((handle), &(x), sizeof(x))
 
diff --git a/kernel/events/Makefile b/kernel/events/Makefile
index 103f5d147b2f..70990d5a2037 100644
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
index 7c712b0c3b9a..dd8696959ca7 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -2866,8 +2866,6 @@ static void free_event_rcu(struct rcu_head *head)
 	kfree(event);
 }
 
-static void ring_buffer_put(struct ring_buffer *rb);
-
 static void free_event(struct perf_event *event)
 {
 	irq_work_sync(&event->pending);
@@ -2898,7 +2896,7 @@ static void free_event(struct perf_event *event)
 	}
 
 	if (event->rb) {
-		ring_buffer_put(event->rb);
+		perf_ring_buffer_put(event->rb);
 		event->rb = NULL;
 	}
 
@@ -3243,8 +3241,6 @@ unlock:
 	return ret;
 }
 
-static const struct file_operations perf_fops;
-
 static inline int perf_fget_light(int fd, struct fd *p)
 {
 	struct fd f = fdget(fd);
@@ -3531,7 +3527,7 @@ static struct ring_buffer *ring_buffer_get(struct perf_event *event)
 	return rb;
 }
 
-static void ring_buffer_put(struct ring_buffer *rb)
+void perf_ring_buffer_put(struct ring_buffer *rb)
 {
 	struct perf_event *event, *n;
 	unsigned long flags;
@@ -3574,7 +3570,7 @@ static void perf_mmap_close(struct vm_area_struct *vma)
 		ring_buffer_detach(event, rb);
 		mutex_unlock(&event->mmap_mutex);
 
-		ring_buffer_put(rb);
+		perf_ring_buffer_put(rb);
 		free_uid(user);
 	}
 }
@@ -3711,7 +3707,7 @@ static int perf_fasync(int fd, struct file *filp, int on)
 	return 0;
 }
 
-static const struct file_operations perf_fops = {
+const struct file_operations perf_fops = {
 	.llseek			= no_llseek,
 	.release		= perf_release,
 	.read			= perf_read,
@@ -6428,7 +6424,7 @@ unlock:
 	mutex_unlock(&event->mmap_mutex);
 
 	if (old_rb)
-		ring_buffer_put(old_rb);
+		perf_ring_buffer_put(old_rb);
 out:
 	return ret;
 }
@@ -6465,6 +6461,9 @@ SYSCALL_DEFINE5(perf_event_open,
 	if (err)
 		return err;
 
+	if (attr.persistent)
+		return perf_get_persistent_event_fd(cpu, &attr);
+
 	if (!attr.exclude_kernel) {
 		if (perf_paranoid_kernel() && !capable(CAP_SYS_ADMIN))
 			return -EACCES;
@@ -7422,6 +7421,8 @@ void __init perf_event_init(void)
 	 */
 	BUILD_BUG_ON((offsetof(struct perf_event_mmap_page, data_head))
 		     != 1024);
+
+	persistent_events_init();
 }
 
 static int __init perf_event_sysfs_init(void)
diff --git a/kernel/events/internal.h b/kernel/events/internal.h
index d56a64c99a8b..85594b2f00e3 100644
--- a/kernel/events/internal.h
+++ b/kernel/events/internal.h
@@ -38,6 +38,7 @@ struct ring_buffer {
 extern void rb_free(struct ring_buffer *rb);
 extern struct ring_buffer *
 rb_alloc(int nr_pages, long watermark, int cpu, int flags);
+extern void perf_ring_buffer_put(struct ring_buffer *rb);
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
index 000000000000..bda2dde6862b
--- /dev/null
+++ b/kernel/events/persistent.c
@@ -0,0 +1,148 @@
+#include <linux/slab.h>
+#include <linux/file.h>
+#include <linux/perf_event.h>
+#include <linux/anon_inodes.h>
+
+#include "internal.h"
+
+DEFINE_PER_CPU(struct list_head, pers_events);
+
+static struct perf_event *
+add_persistent_event_on_cpu(unsigned int cpu, struct perf_event_attr *attr,
+			    unsigned nr_pages)
+{
+	struct perf_event *event = ERR_PTR(-EINVAL);
+	struct pers_event_desc *desc;
+	struct ring_buffer *buf;
+
+	desc = kzalloc(sizeof(*desc), GFP_KERNEL);
+	if (!desc)
+		goto out;
+
+	event = perf_event_create_kernel_counter(attr, cpu, NULL, NULL, NULL);
+	if (IS_ERR(event))
+		goto err_event;
+
+	buf = rb_alloc(nr_pages, 0, cpu, 0);
+	if (!buf)
+		goto err_event_file;
+
+	rcu_assign_pointer(event->rb, buf);
+
+	desc->event = event;
+	desc->attr  = attr;
+
+	INIT_LIST_HEAD(&desc->plist);
+	list_add_tail(&desc->plist, &per_cpu(pers_events, cpu));
+
+	perf_event_enable(event);
+
+	goto out;
+
+ err_event_file:
+	perf_event_release_kernel(event);
+
+ err_event:
+	kfree(desc);
+
+ out:
+	return event;
+}
+
+static void rm_persistent_event(int cpu, struct perf_event_attr *attr)
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
+	__list_del(desc->plist.prev, desc->plist.next);
+
+	perf_event_disable(event);
+	if (event->rb) {
+		perf_ring_buffer_put(event->rb);
+		rcu_assign_pointer(event->rb, NULL);
+	}
+
+	perf_event_release_kernel(event);
+	put_unused_fd(desc->fd);
+	kfree(desc);
+}
+
+int perf_get_persistent_event_fd(unsigned cpu, struct perf_event_attr *attr)
+{
+	struct pers_event_desc *desc;
+	struct file *event_file = NULL;
+	int event_fd = -1;
+
+	list_for_each_entry(desc, &per_cpu(pers_events, cpu), plist) {
+
+		if (desc->attr->config != attr->config)
+			continue;
+
+		event_fd = get_unused_fd();
+		if (event_fd < 0)
+			goto out;
+
+		event_file = anon_inode_getfile("[pers_event]", &perf_fops,
+						desc->event, O_RDONLY);
+		if (IS_ERR(event_file))
+			goto err_event_file;
+
+		desc->fd = event_fd;
+		fd_install(event_fd, event_file);
+
+		return event_fd;
+	}
+
+ err_event_file:
+	put_unused_fd(event_fd);
+
+out:
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
+		if (IS_ERR(event)) {
+			pr_err("%s: Error adding persistent event on cpu %d\n",
+				__func__, i);
+			goto unwind;
+		}
+	}
+	return 0;
+
+unwind:
+	while (--i >= 0)
+		rm_persistent_event(i, attr);
+
+	return -EINVAL;
+}
+
+void __init persistent_events_init(void)
+{
+	int i;
+
+	for_each_possible_cpu(i)
+		INIT_LIST_HEAD(&per_cpu(pers_events, i));
+}
-- 
1.8.1.3.535.ga923c31

