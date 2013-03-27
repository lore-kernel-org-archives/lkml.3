Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068Ab3C0Jtk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 05:49:40 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:64298 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753769Ab3C0Jte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 05:49:34 -0400
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>
CC: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Subject: [PATCH 01/14] tracing: move trace_array definition into include/linux/trace_array.h
Date: Wed, 27 Mar 2013 17:48:43 +0800
Message-ID: <1364377737-10540-3-git-send-email-jovi.zhangwei@huawei.com>
X-Mailer: git-send-email 1.8.1.msysgit.1
In-Reply-To: <1364377737-10540-1-git-send-email-jovi.zhangwei@huawei.com>
References: <1364377737-10540-1-git-send-email-jovi.zhangwei@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.66.58.241]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>

Prepare for expose event tracing infrastructure.
(struct trace_array shall be use by external modules)

Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
---
 include/linux/trace_array.h |  117 +++++++++++++++++++++++++++++++++++++++++++
 kernel/trace/trace.h        |  116 +-----------------------------------------
 2 files changed, 118 insertions(+), 115 deletions(-)
 create mode 100644 include/linux/trace_array.h

diff --git a/include/linux/trace_array.h b/include/linux/trace_array.h
new file mode 100644
index 0000000..c5b7a13
--- /dev/null
+++ b/include/linux/trace_array.h
@@ -0,0 +1,117 @@
+#ifndef _LINUX_KERNEL_TRACE_ARRAY_H
+#define _LINUX_KERNEL_TRACE_ARRAY_H
+
+#ifdef CONFIG_FTRACE_SYSCALLS
+#include <asm/unistd.h>		/* For NR_SYSCALLS	     */
+#include <asm/syscall.h>	/* some archs define it here */
+#endif
+
+struct trace_cpu {
+	struct trace_array	*tr;
+	struct dentry		*dir;
+	int			cpu;
+};
+
+/*
+ * The CPU trace array - it consists of thousands of trace entries
+ * plus some other descriptor data: (for example which task started
+ * the trace, etc.)
+ */
+struct trace_array_cpu {
+	struct trace_cpu	trace_cpu;
+	atomic_t		disabled;
+	void			*buffer_page;	/* ring buffer spare */
+
+	unsigned long		entries;
+	unsigned long		saved_latency;
+	unsigned long		critical_start;
+	unsigned long		critical_end;
+	unsigned long		critical_sequence;
+	unsigned long		nice;
+	unsigned long		policy;
+	unsigned long		rt_priority;
+	unsigned long		skipped_entries;
+	cycle_t			preempt_timestamp;
+	pid_t			pid;
+	kuid_t			uid;
+	char			comm[TASK_COMM_LEN];
+};
+
+struct tracer;
+
+struct trace_buffer {
+	struct trace_array		*tr;
+	struct ring_buffer		*buffer;
+	struct trace_array_cpu __percpu	*data;
+	cycle_t				time_start;
+	int				cpu;
+};
+
+/*
+ * The trace array - an array of per-CPU trace arrays. This is the
+ * highest level data structure that individual tracers deal with.
+ * They have on/off state as well:
+ */
+struct trace_array {
+	struct list_head	list;
+	char			*name;
+	struct trace_buffer	trace_buffer;
+#ifdef CONFIG_TRACER_MAX_TRACE
+	/*
+	 * The max_buffer is used to snapshot the trace when a maximum
+	 * latency is reached, or when the user initiates a snapshot.
+	 * Some tracers will use this to store a maximum trace while
+	 * it continues examining live traces.
+	 *
+	 * The buffers for the max_buffer are set up the same as the trace_buffer
+	 * When a snapshot is taken, the buffer of the max_buffer is swapped
+	 * with the buffer of the trace_buffer and the buffers are reset for
+	 * the trace_buffer so the tracing can continue.
+	 */
+	struct trace_buffer	max_buffer;
+	bool			allocated_snapshot;
+#endif
+	int			buffer_disabled;
+	struct trace_cpu	trace_cpu;	/* place holder */
+#ifdef CONFIG_FTRACE_SYSCALLS
+	int			sys_refcount_enter;
+	int			sys_refcount_exit;
+	DECLARE_BITMAP(enabled_enter_syscalls, NR_syscalls);
+	DECLARE_BITMAP(enabled_exit_syscalls, NR_syscalls);
+#endif
+	int			stop_count;
+	int			clock_id;
+	struct tracer		*current_trace;
+	unsigned int		flags;
+	raw_spinlock_t		start_lock;
+	struct dentry		*dir;
+	struct dentry		*options;
+	struct dentry		*percpu_dir;
+	struct dentry		*event_dir;
+	struct list_head	systems;
+	struct list_head	events;
+	struct task_struct	*waiter;
+	int			ref;
+};
+
+enum {
+	TRACE_ARRAY_FL_GLOBAL	= (1 << 0)
+};
+
+extern struct list_head ftrace_trace_arrays;
+
+/*
+ * The global tracer (top) should be the first trace array added,
+ * but we check the flag anyway.
+ */
+static inline struct trace_array *top_trace_array(void)
+{
+	struct trace_array *tr;
+
+	tr = list_entry(ftrace_trace_arrays.prev,
+			typeof(*tr), list);
+	WARN_ON(!(tr->flags & TRACE_ARRAY_FL_GLOBAL));
+	return tr;
+}
+
+#endif /* _LINUX_KERNEL_TRACE_ARRAY_H */
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 9e01458..a8acfcd 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -12,11 +12,7 @@
 #include <linux/hw_breakpoint.h>
 #include <linux/trace_seq.h>
 #include <linux/ftrace_event.h>
-
-#ifdef CONFIG_FTRACE_SYSCALLS
-#include <asm/unistd.h>		/* For NR_SYSCALLS	     */
-#include <asm/syscall.h>	/* some archs define it here */
-#endif
+#include <linux/trace_array.h>
 
 enum trace_type {
 	__TRACE_FIRST_TYPE = 0,
@@ -133,116 +129,6 @@ enum trace_flag_type {
 
 #define TRACE_BUF_SIZE		1024
 
-struct trace_array;
-
-struct trace_cpu {
-	struct trace_array	*tr;
-	struct dentry		*dir;
-	int			cpu;
-};
-
-/*
- * The CPU trace array - it consists of thousands of trace entries
- * plus some other descriptor data: (for example which task started
- * the trace, etc.)
- */
-struct trace_array_cpu {
-	struct trace_cpu	trace_cpu;
-	atomic_t		disabled;
-	void			*buffer_page;	/* ring buffer spare */
-
-	unsigned long		entries;
-	unsigned long		saved_latency;
-	unsigned long		critical_start;
-	unsigned long		critical_end;
-	unsigned long		critical_sequence;
-	unsigned long		nice;
-	unsigned long		policy;
-	unsigned long		rt_priority;
-	unsigned long		skipped_entries;
-	cycle_t			preempt_timestamp;
-	pid_t			pid;
-	kuid_t			uid;
-	char			comm[TASK_COMM_LEN];
-};
-
-struct tracer;
-
-struct trace_buffer {
-	struct trace_array		*tr;
-	struct ring_buffer		*buffer;
-	struct trace_array_cpu __percpu	*data;
-	cycle_t				time_start;
-	int				cpu;
-};
-
-/*
- * The trace array - an array of per-CPU trace arrays. This is the
- * highest level data structure that individual tracers deal with.
- * They have on/off state as well:
- */
-struct trace_array {
-	struct list_head	list;
-	char			*name;
-	struct trace_buffer	trace_buffer;
-#ifdef CONFIG_TRACER_MAX_TRACE
-	/*
-	 * The max_buffer is used to snapshot the trace when a maximum
-	 * latency is reached, or when the user initiates a snapshot.
-	 * Some tracers will use this to store a maximum trace while
-	 * it continues examining live traces.
-	 *
-	 * The buffers for the max_buffer are set up the same as the trace_buffer
-	 * When a snapshot is taken, the buffer of the max_buffer is swapped
-	 * with the buffer of the trace_buffer and the buffers are reset for
-	 * the trace_buffer so the tracing can continue.
-	 */
-	struct trace_buffer	max_buffer;
-	bool			allocated_snapshot;
-#endif
-	int			buffer_disabled;
-	struct trace_cpu	trace_cpu;	/* place holder */
-#ifdef CONFIG_FTRACE_SYSCALLS
-	int			sys_refcount_enter;
-	int			sys_refcount_exit;
-	DECLARE_BITMAP(enabled_enter_syscalls, NR_syscalls);
-	DECLARE_BITMAP(enabled_exit_syscalls, NR_syscalls);
-#endif
-	int			stop_count;
-	int			clock_id;
-	struct tracer		*current_trace;
-	unsigned int		flags;
-	raw_spinlock_t		start_lock;
-	struct dentry		*dir;
-	struct dentry		*options;
-	struct dentry		*percpu_dir;
-	struct dentry		*event_dir;
-	struct list_head	systems;
-	struct list_head	events;
-	struct task_struct	*waiter;
-	int			ref;
-};
-
-enum {
-	TRACE_ARRAY_FL_GLOBAL	= (1 << 0)
-};
-
-extern struct list_head ftrace_trace_arrays;
-
-/*
- * The global tracer (top) should be the first trace array added,
- * but we check the flag anyway.
- */
-static inline struct trace_array *top_trace_array(void)
-{
-	struct trace_array *tr;
-
-	tr = list_entry(ftrace_trace_arrays.prev,
-			typeof(*tr), list);
-	WARN_ON(!(tr->flags & TRACE_ARRAY_FL_GLOBAL));
-	return tr;
-}
-
 #define FTRACE_CMP_TYPE(var, type) \
 	__builtin_types_compatible_p(typeof(var), type *)
 
-- 
1.7.9.7


