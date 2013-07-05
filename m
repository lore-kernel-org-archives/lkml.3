Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757491Ab3GEPWv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 11:22:51 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:25855 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757408Ab3GEPWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 11:22:49 -0400
X-Authority-Analysis: v=2.0 cv=KtrPKBqN c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Rm5rpecUx9gA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=foPV6sPdes8A:10 a=VwQbUJbxAAAA:8 a=W2gwgzQSidGQXxci5qAA:9 a=QEXdDO2ut3YA:10 a=afgiiWhSGRFCXmaV:21 a=IgdeqG0KbSaExoh-:21 a=OWP8ZqBrXJ_WjQxs:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1373037766.22688.158.camel@gandalf.local.home>
Subject: [GIT PULL] tracing: updates, cleanups and fixes for 3.11
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 05 Jul 2013 11:22:46 -0400
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

The majority of the changes here are cleanups for the large changes that
were added to 3.10, which includes several bug fixes that have been
marked for stable.

As for new features, there were a few, but nothing to write to LWN about.
These include:

New function trigger called "dump" and "cpudump" that will cause
ftrace to dump its buffer to the console when the function is called.
The difference between "dump" and "cpudump" is that "dump" will dump
the entire contents of the ftrace buffer, where as "cpudump" will only
dump the contents of the ftrace buffer for the CPU that called the function.

Another small enhancement is a new sysctl switch called "traceoff_on_warning"
which, when enabled, will disable tracing if any WARN_ON() is triggered.
This is useful if you want to debug what caused a warning and do not
want to risk losing your trace data by the ring buffer overwriting the
data before you can disable it. There's also a kernel command line
option that will make this enabled at boot up called the same thing.

-- Steve

Please pull trace-3.11:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
trace-3.11

Head SHA1: 2ca24405f8d4a094acda282ddac009f1c0211c44


Alexander Z Lam (2):
      tracing: Make trace_marker use the correct per-instance buffer
      tracing: Protect ftrace_trace_arrays list in trace_events.c

Harsh Prateek Bora (1):
      tracing/trivial: Consolidate error return condition

Juri Lelli (1):
      ftrace: Fix stddev calculation in function profiler

Li Zefan (1):
      ftrace: Remove ftrace_regex_lseek()

Namhyung Kim (1):
      tracing: Do not call kmem_cache_free() on allocation failure

Oleg Nesterov (4):
      tracing/kprobes: Avoid perf_trace_buf_*() if ->perf_events is empty
      tracing/kprobes: Kill probe_enable_lock
      tracing/kprobes: Turn trace_probe->files into list_head
      tracing/kprobes: Don't pass addr=ip to perf_trace_buf_submit()

Steven Rostedt (3):
      ftrace: Use schedule_on_each_cpu() as a heavy synchronize_sched()
      tracing: Add binary '&' filter for events
      tracing: Failed to create system directory

Steven Rostedt (Red Hat) (12):
      tracing: Add function probe to trigger a ftrace dump to console
      tracing: Add function probe to trigger a ftrace dump of current CPU trace
      tracing: Update documentation on tracepoint glob matching
      tracing: Disable tracing on warning
      tracing: Use flag buffer_disabled for irqsoff tracer
      ftrace: Do not run selftest if command line parameter is set
      tracing: Add trace_array_get/put() to handle instance refs better
      tracing: Get trace_array ref counts when accessing trace files
      tracing: Add trace_array_get/put() to event handling
      tracing: Fix race between deleting buffer and setting events
      tracing: Make tracer_tracing_{off,on,is_on}() static
      tracing: Make tracing_open_generic_{tr,tc}() static

Tom Zanussi (3):
      tracing: Simplify code for showing of soft disabled flag
      tracing: Add missing syscall_metadata comment
      tracing: Fix disabling of soft disable

Wang YanQing (1):
      tracing: Fix file mode of free_buffer

zhangwei(Jovi) (5):
      tracing/kprobes: Remove unnecessary checking of trace_probe_is_enabled
      uprobes: Fix return value in error handling path
      tracing: Fix irqs-off tag display in syscall tracing
      tracing: Remove TRACE_EVENT_TYPE enum definition
      tracing: Remove ftrace() function

----
 Documentation/kernel-parameters.txt |   13 ++
 Documentation/trace/events.txt      |   15 +-
 Documentation/trace/ftrace.txt      |   13 ++
 include/linux/ftrace.h              |    9 +-
 include/trace/syscall.h             |    1 +
 kernel/panic.c                      |    3 +
 kernel/sysctl.c                     |    7 +
 kernel/trace/ftrace.c               |   38 +++-
 kernel/trace/trace.c                |  338 +++++++++++++++++++++++++++--------
 kernel/trace/trace.h                |   17 +-
 kernel/trace/trace_events.c         |  166 +++++++++++++----
 kernel/trace/trace_events_filter.c  |    6 +
 kernel/trace/trace_functions.c      |  103 ++++++++++-
 kernel/trace/trace_irqsoff.c        |    4 +-
 kernel/trace/trace_kprobe.c         |  190 +++++++-------------
 kernel/trace/trace_selftest.c       |   18 +-
 kernel/trace/trace_syscalls.c       |   21 ++-
 kernel/trace/trace_uprobe.c         |    4 +-
 18 files changed, 694 insertions(+), 272 deletions(-)
---------------------------
diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 6e3b18a..729d0b9 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -3069,6 +3069,19 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			See also Documentation/trace/ftrace.txt "trace options"
 			section.
 
+	traceoff_on_warning
+			[FTRACE] enable this option to disable tracing when a
+			warning is hit. This turns off "tracing_on". Tracing can
+			be enabled again by echoing '1' into the "tracing_on"
+			file located in /sys/kernel/debug/tracing/
+
+			This option is useful, as it disables the trace before
+			the WARNING dump is called, which prevents the trace to
+			be filled with content caused by the warning output.
+
+			This option can also be set at run time via the sysctl
+			option:  kernel/traceoff_on_warning
+
 	transparent_hugepage=
 			[KNL]
 			Format: [always|madvise|never]
diff --git a/Documentation/trace/events.txt b/Documentation/trace/events.txt
index bb24c2a..37732a2 100644
--- a/Documentation/trace/events.txt
+++ b/Documentation/trace/events.txt
@@ -183,13 +183,22 @@ The relational-operators depend on the type of the field being tested:
 
 The operators available for numeric fields are:
 
-==, !=, <, <=, >, >=
+==, !=, <, <=, >, >=, &
 
 And for string fields they are:
 
-==, !=
+==, !=, ~
 
-Currently, only exact string matches are supported.
+The glob (~) only accepts a wild card character (*) at the start and or
+end of the string. For example:
+
+  prev_comm ~ "*sh"
+  prev_comm ~ "sh*"
+  prev_comm ~ "*sh*"
+
+But does not allow for it to be within the string:
+
+  prev_comm ~ "ba*sh"   <-- is invalid
 
 5.2 Setting filters
 -------------------
diff --git a/Documentation/trace/ftrace.txt b/Documentation/trace/ftrace.txt
index bfe8c29..b937c6e 100644
--- a/Documentation/trace/ftrace.txt
+++ b/Documentation/trace/ftrace.txt
@@ -2430,6 +2430,19 @@ The following commands are supported:
    echo '!schedule:disable_event:sched:sched_switch' > \
    	 set_ftrace_filter
 
+- dump
+  When the function is hit, it will dump the contents of the ftrace
+  ring buffer to the console. This is useful if you need to debug
+  something, and want to dump the trace when a certain function
+  is hit. Perhaps its a function that is called before a tripple
+  fault happens and does not allow you to get a regular dump.
+
+- cpudump
+  When the function is hit, it will dump the contents of the ftrace
+  ring buffer for the current CPU to the console. Unlike the "dump"
+  command, it only prints out the contents of the ring buffer for the
+  CPU that executed the function that triggered the dump.
+
 trace_pipe
 ----------
 
diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 99d0fbc..9f15c00 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -566,10 +566,6 @@ static inline ssize_t ftrace_filter_write(struct file *file, const char __user *
 			    size_t cnt, loff_t *ppos) { return -ENODEV; }
 static inline ssize_t ftrace_notrace_write(struct file *file, const char __user *ubuf,
 			     size_t cnt, loff_t *ppos) { return -ENODEV; }
-static inline loff_t ftrace_regex_lseek(struct file *file, loff_t offset, int whence)
-{
-	return -ENODEV;
-}
 static inline int
 ftrace_regex_release(struct inode *inode, struct file *file) { return -ENODEV; }
 #endif /* CONFIG_DYNAMIC_FTRACE */
@@ -828,10 +824,15 @@ enum ftrace_dump_mode;
 
 extern enum ftrace_dump_mode ftrace_dump_on_oops;
 
+extern void disable_trace_on_warning(void);
+extern int __disable_trace_on_warning;
+
 #ifdef CONFIG_PREEMPT
 #define INIT_TRACE_RECURSION		.trace_recursion = 0,
 #endif
 
+#else /* CONFIG_TRACING */
+static inline void  disable_trace_on_warning(void) { }
 #endif /* CONFIG_TRACING */
 
 #ifndef INIT_TRACE_RECURSION
diff --git a/include/trace/syscall.h b/include/trace/syscall.h
index 84bc419..fed853f 100644
--- a/include/trace/syscall.h
+++ b/include/trace/syscall.h
@@ -16,6 +16,7 @@
  * @nb_args: number of parameters it takes
  * @types: list of types as strings
  * @args: list of args as strings (args[i] matches types[i])
+ * @enter_fields: list of fields for syscall_enter trace event
  * @enter_event: associated syscall_enter trace event
  * @exit_event: associated syscall_exit trace event
  */
diff --git a/kernel/panic.c b/kernel/panic.c
index 167ec09..4cea6cc 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -15,6 +15,7 @@
 #include <linux/notifier.h>
 #include <linux/module.h>
 #include <linux/random.h>
+#include <linux/ftrace.h>
 #include <linux/reboot.h>
 #include <linux/delay.h>
 #include <linux/kexec.h>
@@ -399,6 +400,8 @@ struct slowpath_args {
 static void warn_slowpath_common(const char *file, int line, void *caller,
 				 unsigned taint, struct slowpath_args *args)
 {
+	disable_trace_on_warning();
+
 	printk(KERN_WARNING "------------[ cut here ]------------\n");
 	printk(KERN_WARNING "WARNING: at %s:%d %pS()\n", file, line, caller);
 
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 9edcf45..5b0f18c 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -600,6 +600,13 @@ static struct ctl_table kern_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec,
 	},
+	{
+		.procname	= "traceoff_on_warning",
+		.data		= &__disable_trace_on_warning,
+		.maxlen		= sizeof(__disable_trace_on_warning),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
 #endif
 #ifdef CONFIG_MODULES
 	{
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 6c508ff..67708f4 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -413,6 +413,17 @@ static int __register_ftrace_function(struct ftrace_ops *ops)
 	return 0;
 }
 
+static void ftrace_sync(struct work_struct *work)
+{
+	/*
+	 * This function is just a stub to implement a hard force
+	 * of synchronize_sched(). This requires synchronizing
+	 * tasks even in userspace and idle.
+	 *
+	 * Yes, function tracing is rude.
+	 */
+}
+
 static int __unregister_ftrace_function(struct ftrace_ops *ops)
 {
 	int ret;
@@ -440,8 +451,12 @@ static int __unregister_ftrace_function(struct ftrace_ops *ops)
 			 * so there'll be no new users. We must ensure
 			 * all current users are done before we free
 			 * the control data.
+			 * Note synchronize_sched() is not enough, as we
+			 * use preempt_disable() to do RCU, but the function
+			 * tracer can be called where RCU is not active
+			 * (before user_exit()).
 			 */
-			synchronize_sched();
+			schedule_on_each_cpu(ftrace_sync);
 			control_ops_free(ops);
 		}
 	} else
@@ -456,9 +471,13 @@ static int __unregister_ftrace_function(struct ftrace_ops *ops)
 	/*
 	 * Dynamic ops may be freed, we must make sure that all
 	 * callers are done before leaving this function.
+	 *
+	 * Again, normal synchronize_sched() is not good enough.
+	 * We need to do a hard force of sched synchronization.
 	 */
 	if (ops->flags & FTRACE_OPS_FL_DYNAMIC)
-		synchronize_sched();
+		schedule_on_each_cpu(ftrace_sync);
+
 
 	return 0;
 }
@@ -622,12 +641,18 @@ static int function_stat_show(struct seq_file *m, void *v)
 	if (rec->counter <= 1)
 		stddev = 0;
 	else {
-		stddev = rec->time_squared - rec->counter * avg * avg;
+		/*
+		 * Apply Welford's method:
+		 * s^2 = 1 / (n * (n-1)) * (n * \Sum (x_i)^2 - (\Sum x_i)^2)
+		 */
+		stddev = rec->counter * rec->time_squared -
+			 rec->time * rec->time;
+
 		/*
 		 * Divide only 1000 for ns^2 -> us^2 conversion.
 		 * trace_print_graph_duration will divide 1000 again.
 		 */
-		do_div(stddev, (rec->counter - 1) * 1000);
+		do_div(stddev, rec->counter * (rec->counter - 1) * 1000);
 	}
 
 	trace_seq_init(&s);
@@ -3512,8 +3537,12 @@ EXPORT_SYMBOL_GPL(ftrace_set_global_notrace);
 static char ftrace_notrace_buf[FTRACE_FILTER_SIZE] __initdata;
 static char ftrace_filter_buf[FTRACE_FILTER_SIZE] __initdata;
 
+/* Used by function selftest to not test if filter is set */
+bool ftrace_filter_param __initdata;
+
 static int __init set_ftrace_notrace(char *str)
 {
+	ftrace_filter_param = true;
 	strlcpy(ftrace_notrace_buf, str, FTRACE_FILTER_SIZE);
 	return 1;
 }
@@ -3521,6 +3550,7 @@ __setup("ftrace_notrace=", set_ftrace_notrace);
 
 static int __init set_ftrace_filter(char *str)
 {
+	ftrace_filter_param = true;
 	strlcpy(ftrace_filter_buf, str, FTRACE_FILTER_SIZE);
 	return 1;
 }
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 1a41023..dc473b5 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -115,6 +115,9 @@ cpumask_var_t __read_mostly	tracing_buffer_mask;
 
 enum ftrace_dump_mode ftrace_dump_on_oops;
 
+/* When set, tracing will stop when a WARN*() is hit */
+int __disable_trace_on_warning;
+
 static int tracing_set_tracer(const char *buf);
 
 #define MAX_TRACER_SIZE		100
@@ -149,6 +152,13 @@ static int __init set_ftrace_dump_on_oops(char *str)
 }
 __setup("ftrace_dump_on_oops", set_ftrace_dump_on_oops);
 
+static int __init stop_trace_on_warning(char *str)
+{
+	__disable_trace_on_warning = 1;
+	return 1;
+}
+__setup("traceoff_on_warning=", stop_trace_on_warning);
+
 static int __init boot_alloc_snapshot(char *str)
 {
 	allocate_snapshot = true;
@@ -170,6 +180,7 @@ static int __init set_trace_boot_options(char *str)
 }
 __setup("trace_options=", set_trace_boot_options);
 
+
 unsigned long long ns2usecs(cycle_t nsec)
 {
 	nsec += 500;
@@ -193,6 +204,37 @@ static struct trace_array	global_trace;
 
 LIST_HEAD(ftrace_trace_arrays);
 
+int trace_array_get(struct trace_array *this_tr)
+{
+	struct trace_array *tr;
+	int ret = -ENODEV;
+
+	mutex_lock(&trace_types_lock);
+	list_for_each_entry(tr, &ftrace_trace_arrays, list) {
+		if (tr == this_tr) {
+			tr->ref++;
+			ret = 0;
+			break;
+		}
+	}
+	mutex_unlock(&trace_types_lock);
+
+	return ret;
+}
+
+static void __trace_array_put(struct trace_array *this_tr)
+{
+	WARN_ON(!this_tr->ref);
+	this_tr->ref--;
+}
+
+void trace_array_put(struct trace_array *this_tr)
+{
+	mutex_lock(&trace_types_lock);
+	__trace_array_put(this_tr);
+	mutex_unlock(&trace_types_lock);
+}
+
 int filter_current_check_discard(struct ring_buffer *buffer,
 				 struct ftrace_event_call *call, void *rec,
 				 struct ring_buffer_event *event)
@@ -215,9 +257,24 @@ cycle_t ftrace_now(int cpu)
 	return ts;
 }
 
+/**
+ * tracing_is_enabled - Show if global_trace has been disabled
+ *
+ * Shows if the global trace has been enabled or not. It uses the
+ * mirror flag "buffer_disabled" to be used in fast paths such as for
+ * the irqsoff tracer. But it may be inaccurate due to races. If you
+ * need to know the accurate state, use tracing_is_on() which is a little
+ * slower, but accurate.
+ */
 int tracing_is_enabled(void)
 {
-	return tracing_is_on();
+	/*
+	 * For quick access (irqsoff uses this in fast path), just
+	 * return the mirror variable of the state of the ring buffer.
+	 * It's a little racy, but we don't really care.
+	 */
+	smp_rmb();
+	return !global_trace.buffer_disabled;
 }
 
 /*
@@ -240,7 +297,7 @@ static struct tracer		*trace_types __read_mostly;
 /*
  * trace_types_lock is used to protect the trace_types list.
  */
-static DEFINE_MUTEX(trace_types_lock);
+DEFINE_MUTEX(trace_types_lock);
 
 /*
  * serialize the access of the ring buffer
@@ -330,6 +387,23 @@ unsigned long trace_flags = TRACE_ITER_PRINT_PARENT | TRACE_ITER_PRINTK |
 	TRACE_ITER_GRAPH_TIME | TRACE_ITER_RECORD_CMD | TRACE_ITER_OVERWRITE |
 	TRACE_ITER_IRQ_INFO | TRACE_ITER_MARKERS | TRACE_ITER_FUNCTION;
 
+static void tracer_tracing_on(struct trace_array *tr)
+{
+	if (tr->trace_buffer.buffer)
+		ring_buffer_record_on(tr->trace_buffer.buffer);
+	/*
+	 * This flag is looked at when buffers haven't been allocated
+	 * yet, or by some tracers (like irqsoff), that just want to
+	 * know if the ring buffer has been disabled, but it can handle
+	 * races of where it gets disabled but we still do a record.
+	 * As the check is in the fast path of the tracers, it is more
+	 * important to be fast than accurate.
+	 */
+	tr->buffer_disabled = 0;
+	/* Make the flag seen by readers */
+	smp_wmb();
+}
+
 /**
  * tracing_on - enable tracing buffers
  *
@@ -338,15 +412,7 @@ unsigned long trace_flags = TRACE_ITER_PRINT_PARENT | TRACE_ITER_PRINTK |
  */
 void tracing_on(void)
 {
-	if (global_trace.trace_buffer.buffer)
-		ring_buffer_record_on(global_trace.trace_buffer.buffer);
-	/*
-	 * This flag is only looked at when buffers haven't been
-	 * allocated yet. We don't really care about the race
-	 * between setting this flag and actually turning
-	 * on the buffer.
-	 */
-	global_trace.buffer_disabled = 0;
+	tracer_tracing_on(&global_trace);
 }
 EXPORT_SYMBOL_GPL(tracing_on);
 
@@ -540,6 +606,23 @@ void tracing_snapshot_alloc(void)
 EXPORT_SYMBOL_GPL(tracing_snapshot_alloc);
 #endif /* CONFIG_TRACER_SNAPSHOT */
 
+static void tracer_tracing_off(struct trace_array *tr)
+{
+	if (tr->trace_buffer.buffer)
+		ring_buffer_record_off(tr->trace_buffer.buffer);
+	/*
+	 * This flag is looked at when buffers haven't been allocated
+	 * yet, or by some tracers (like irqsoff), that just want to
+	 * know if the ring buffer has been disabled, but it can handle
+	 * races of where it gets disabled but we still do a record.
+	 * As the check is in the fast path of the tracers, it is more
+	 * important to be fast than accurate.
+	 */
+	tr->buffer_disabled = 1;
+	/* Make the flag seen by readers */
+	smp_wmb();
+}
+
 /**
  * tracing_off - turn off tracing buffers
  *
@@ -550,26 +633,35 @@ EXPORT_SYMBOL_GPL(tracing_snapshot_alloc);
  */
 void tracing_off(void)
 {
-	if (global_trace.trace_buffer.buffer)
-		ring_buffer_record_off(global_trace.trace_buffer.buffer);
-	/*
-	 * This flag is only looked at when buffers haven't been
-	 * allocated yet. We don't really care about the race
-	 * between setting this flag and actually turning
-	 * on the buffer.
-	 */
-	global_trace.buffer_disabled = 1;
+	tracer_tracing_off(&global_trace);
 }
 EXPORT_SYMBOL_GPL(tracing_off);
 
+void disable_trace_on_warning(void)
+{
+	if (__disable_trace_on_warning)
+		tracing_off();
+}
+
+/**
+ * tracer_tracing_is_on - show real state of ring buffer enabled
+ * @tr : the trace array to know if ring buffer is enabled
+ *
+ * Shows real state of the ring buffer if it is enabled or not.
+ */
+static int tracer_tracing_is_on(struct trace_array *tr)
+{
+	if (tr->trace_buffer.buffer)
+		return ring_buffer_record_is_on(tr->trace_buffer.buffer);
+	return !tr->buffer_disabled;
+}
+
 /**
  * tracing_is_on - show state of ring buffers enabled
  */
 int tracing_is_on(void)
 {
-	if (global_trace.trace_buffer.buffer)
-		return ring_buffer_record_is_on(global_trace.trace_buffer.buffer);
-	return !global_trace.buffer_disabled;
+	return tracer_tracing_is_on(&global_trace);
 }
 EXPORT_SYMBOL_GPL(tracing_is_on);
 
@@ -1545,15 +1637,6 @@ trace_function(struct trace_array *tr,
 		__buffer_unlock_commit(buffer, event);
 }
 
-void
-ftrace(struct trace_array *tr, struct trace_array_cpu *data,
-       unsigned long ip, unsigned long parent_ip, unsigned long flags,
-       int pc)
-{
-	if (likely(!atomic_read(&data->disabled)))
-		trace_function(tr, ip, parent_ip, flags, pc);
-}
-
 #ifdef CONFIG_STACKTRACE
 
 #define FTRACE_STACK_MAX_ENTRIES (PAGE_SIZE / sizeof(unsigned long))
@@ -2770,10 +2853,9 @@ static const struct seq_operations tracer_seq_ops = {
 };
 
 static struct trace_iterator *
-__tracing_open(struct inode *inode, struct file *file, bool snapshot)
+__tracing_open(struct trace_array *tr, struct trace_cpu *tc,
+	       struct inode *inode, struct file *file, bool snapshot)
 {
-	struct trace_cpu *tc = inode->i_private;
-	struct trace_array *tr = tc->tr;
 	struct trace_iterator *iter;
 	int cpu;
 
@@ -2852,8 +2934,6 @@ __tracing_open(struct inode *inode, struct file *file, bool snapshot)
 		tracing_iter_reset(iter, cpu);
 	}
 
-	tr->ref++;
-
 	mutex_unlock(&trace_types_lock);
 
 	return iter;
@@ -2876,6 +2956,43 @@ int tracing_open_generic(struct inode *inode, struct file *filp)
 	return 0;
 }
 
+/*
+ * Open and update trace_array ref count.
+ * Must have the current trace_array passed to it.
+ */
+static int tracing_open_generic_tr(struct inode *inode, struct file *filp)
+{
+	struct trace_array *tr = inode->i_private;
+
+	if (tracing_disabled)
+		return -ENODEV;
+
+	if (trace_array_get(tr) < 0)
+		return -ENODEV;
+
+	filp->private_data = inode->i_private;
+
+	return 0;
+	
+}
+
+static int tracing_open_generic_tc(struct inode *inode, struct file *filp)
+{
+	struct trace_cpu *tc = inode->i_private;
+	struct trace_array *tr = tc->tr;
+
+	if (tracing_disabled)
+		return -ENODEV;
+
+	if (trace_array_get(tr) < 0)
+		return -ENODEV;
+
+	filp->private_data = inode->i_private;
+
+	return 0;
+	
+}
+
 static int tracing_release(struct inode *inode, struct file *file)
 {
 	struct seq_file *m = file->private_data;
@@ -2883,17 +3000,20 @@ static int tracing_release(struct inode *inode, struct file *file)
 	struct trace_array *tr;
 	int cpu;
 
-	if (!(file->f_mode & FMODE_READ))
+	/* Writes do not use seq_file, need to grab tr from inode */
+	if (!(file->f_mode & FMODE_READ)) {
+		struct trace_cpu *tc = inode->i_private;
+
+		trace_array_put(tc->tr);
 		return 0;
+	}
 
 	iter = m->private;
 	tr = iter->tr;
+	trace_array_put(tr);
 
 	mutex_lock(&trace_types_lock);
 
-	WARN_ON(!tr->ref);
-	tr->ref--;
-
 	for_each_tracing_cpu(cpu) {
 		if (iter->buffer_iter[cpu])
 			ring_buffer_read_finish(iter->buffer_iter[cpu]);
@@ -2912,20 +3032,49 @@ static int tracing_release(struct inode *inode, struct file *file)
 	kfree(iter->trace);
 	kfree(iter->buffer_iter);
 	seq_release_private(inode, file);
+
+	return 0;
+}
+
+static int tracing_release_generic_tr(struct inode *inode, struct file *file)
+{
+	struct trace_array *tr = inode->i_private;
+
+	trace_array_put(tr);
 	return 0;
 }
 
+static int tracing_release_generic_tc(struct inode *inode, struct file *file)
+{
+	struct trace_cpu *tc = inode->i_private;
+	struct trace_array *tr = tc->tr;
+
+	trace_array_put(tr);
+	return 0;
+}
+
+static int tracing_single_release_tr(struct inode *inode, struct file *file)
+{
+	struct trace_array *tr = inode->i_private;
+
+	trace_array_put(tr);
+
+	return single_release(inode, file);
+}
+
 static int tracing_open(struct inode *inode, struct file *file)
 {
+	struct trace_cpu *tc = inode->i_private;
+	struct trace_array *tr = tc->tr;
 	struct trace_iterator *iter;
 	int ret = 0;
 
+	if (trace_array_get(tr) < 0)
+		return -ENODEV;
+
 	/* If this file was open for write, then erase contents */
 	if ((file->f_mode & FMODE_WRITE) &&
 	    (file->f_flags & O_TRUNC)) {
-		struct trace_cpu *tc = inode->i_private;
-		struct trace_array *tr = tc->tr;
-
 		if (tc->cpu == RING_BUFFER_ALL_CPUS)
 			tracing_reset_online_cpus(&tr->trace_buffer);
 		else
@@ -2933,12 +3082,16 @@ static int tracing_open(struct inode *inode, struct file *file)
 	}
 
 	if (file->f_mode & FMODE_READ) {
-		iter = __tracing_open(inode, file, false);
+		iter = __tracing_open(tr, tc, inode, file, false);
 		if (IS_ERR(iter))
 			ret = PTR_ERR(iter);
 		else if (trace_flags & TRACE_ITER_LATENCY_FMT)
 			iter->iter_flags |= TRACE_FILE_LAT_FMT;
 	}
+
+	if (ret < 0)
+		trace_array_put(tr);
+
 	return ret;
 }
 
@@ -3295,9 +3448,14 @@ tracing_trace_options_write(struct file *filp, const char __user *ubuf,
 
 static int tracing_trace_options_open(struct inode *inode, struct file *file)
 {
+	struct trace_array *tr = inode->i_private;
+
 	if (tracing_disabled)
 		return -ENODEV;
 
+	if (trace_array_get(tr) < 0)
+		return -ENODEV;
+
 	return single_open(file, tracing_trace_options_show, inode->i_private);
 }
 
@@ -3305,7 +3463,7 @@ static const struct file_operations tracing_iter_fops = {
 	.open		= tracing_trace_options_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
-	.release	= single_release,
+	.release	= tracing_single_release_tr,
 	.write		= tracing_trace_options_write,
 };
 
@@ -3793,6 +3951,9 @@ static int tracing_open_pipe(struct inode *inode, struct file *filp)
 	if (tracing_disabled)
 		return -ENODEV;
 
+	if (trace_array_get(tr) < 0)
+		return -ENODEV;
+
 	mutex_lock(&trace_types_lock);
 
 	/* create a buffer to store the information to pass to userspace */
@@ -3845,6 +4006,7 @@ out:
 fail:
 	kfree(iter->trace);
 	kfree(iter);
+	__trace_array_put(tr);
 	mutex_unlock(&trace_types_lock);
 	return ret;
 }
@@ -3852,6 +4014,8 @@ fail:
 static int tracing_release_pipe(struct inode *inode, struct file *file)
 {
 	struct trace_iterator *iter = file->private_data;
+	struct trace_cpu *tc = inode->i_private;
+	struct trace_array *tr = tc->tr;
 
 	mutex_lock(&trace_types_lock);
 
@@ -3865,6 +4029,8 @@ static int tracing_release_pipe(struct inode *inode, struct file *file)
 	kfree(iter->trace);
 	kfree(iter);
 
+	trace_array_put(tr);
+
 	return 0;
 }
 
@@ -3941,7 +4107,7 @@ static int tracing_wait_pipe(struct file *filp)
 		 *
 		 * iter->pos will be 0 if we haven't read anything.
 		 */
-		if (!tracing_is_enabled() && iter->pos)
+		if (!tracing_is_on() && iter->pos)
 			break;
 	}
 
@@ -4322,6 +4488,8 @@ tracing_free_buffer_release(struct inode *inode, struct file *filp)
 	/* resize the ring buffer to 0 */
 	tracing_resize_ring_buffer(tr, 0, RING_BUFFER_ALL_CPUS);
 
+	trace_array_put(tr);
+
 	return 0;
 }
 
@@ -4330,6 +4498,7 @@ tracing_mark_write(struct file *filp, const char __user *ubuf,
 					size_t cnt, loff_t *fpos)
 {
 	unsigned long addr = (unsigned long)ubuf;
+	struct trace_array *tr = filp->private_data;
 	struct ring_buffer_event *event;
 	struct ring_buffer *buffer;
 	struct print_entry *entry;
@@ -4389,7 +4558,7 @@ tracing_mark_write(struct file *filp, const char __user *ubuf,
 
 	local_save_flags(irq_flags);
 	size = sizeof(*entry) + cnt + 2; /* possible \n added */
-	buffer = global_trace.trace_buffer.buffer;
+	buffer = tr->trace_buffer.buffer;
 	event = trace_buffer_lock_reserve(buffer, TRACE_PRINT, size,
 					  irq_flags, preempt_count());
 	if (!event) {
@@ -4497,10 +4666,20 @@ static ssize_t tracing_clock_write(struct file *filp, const char __user *ubuf,
 
 static int tracing_clock_open(struct inode *inode, struct file *file)
 {
+	struct trace_array *tr = inode->i_private;
+	int ret;
+
 	if (tracing_disabled)
 		return -ENODEV;
 
-	return single_open(file, tracing_clock_show, inode->i_private);
+	if (trace_array_get(tr))
+		return -ENODEV;
+
+	ret = single_open(file, tracing_clock_show, inode->i_private);
+	if (ret < 0)
+		trace_array_put(tr);
+
+	return ret;
 }
 
 struct ftrace_buffer_info {
@@ -4513,12 +4692,16 @@ struct ftrace_buffer_info {
 static int tracing_snapshot_open(struct inode *inode, struct file *file)
 {
 	struct trace_cpu *tc = inode->i_private;
+	struct trace_array *tr = tc->tr;
 	struct trace_iterator *iter;
 	struct seq_file *m;
 	int ret = 0;
 
+	if (trace_array_get(tr) < 0)
+		return -ENODEV;
+
 	if (file->f_mode & FMODE_READ) {
-		iter = __tracing_open(inode, file, true);
+		iter = __tracing_open(tr, tc, inode, file, true);
 		if (IS_ERR(iter))
 			ret = PTR_ERR(iter);
 	} else {
@@ -4531,13 +4714,16 @@ static int tracing_snapshot_open(struct inode *inode, struct file *file)
 			kfree(m);
 			return -ENOMEM;
 		}
-		iter->tr = tc->tr;
+		iter->tr = tr;
 		iter->trace_buffer = &tc->tr->max_buffer;
 		iter->cpu_file = tc->cpu;
 		m->private = iter;
 		file->private_data = m;
 	}
 
+	if (ret < 0)
+		trace_array_put(tr);
+
 	return ret;
 }
 
@@ -4618,9 +4804,12 @@ out:
 static int tracing_snapshot_release(struct inode *inode, struct file *file)
 {
 	struct seq_file *m = file->private_data;
+	int ret;
+
+	ret = tracing_release(inode, file);
 
 	if (file->f_mode & FMODE_READ)
-		return tracing_release(inode, file);
+		return ret;
 
 	/* If write only, the seq_file is just a stub */
 	if (m)
@@ -4686,34 +4875,38 @@ static const struct file_operations tracing_pipe_fops = {
 };
 
 static const struct file_operations tracing_entries_fops = {
-	.open		= tracing_open_generic,
+	.open		= tracing_open_generic_tc,
 	.read		= tracing_entries_read,
 	.write		= tracing_entries_write,
 	.llseek		= generic_file_llseek,
+	.release	= tracing_release_generic_tc,
 };
 
 static const struct file_operations tracing_total_entries_fops = {
-	.open		= tracing_open_generic,
+	.open		= tracing_open_generic_tr,
 	.read		= tracing_total_entries_read,
 	.llseek		= generic_file_llseek,
+	.release	= tracing_release_generic_tr,
 };
 
 static const struct file_operations tracing_free_buffer_fops = {
+	.open		= tracing_open_generic_tr,
 	.write		= tracing_free_buffer_write,
 	.release	= tracing_free_buffer_release,
 };
 
 static const struct file_operations tracing_mark_fops = {
-	.open		= tracing_open_generic,
+	.open		= tracing_open_generic_tr,
 	.write		= tracing_mark_write,
 	.llseek		= generic_file_llseek,
+	.release	= tracing_release_generic_tr,
 };
 
 static const struct file_operations trace_clock_fops = {
 	.open		= tracing_clock_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
-	.release	= single_release,
+	.release	= tracing_single_release_tr,
 	.write		= tracing_clock_write,
 };
 
@@ -4741,13 +4934,19 @@ static int tracing_buffers_open(struct inode *inode, struct file *filp)
 	struct trace_cpu *tc = inode->i_private;
 	struct trace_array *tr = tc->tr;
 	struct ftrace_buffer_info *info;
+	int ret;
 
 	if (tracing_disabled)
 		return -ENODEV;
 
+	if (trace_array_get(tr) < 0)
+		return -ENODEV;
+
 	info = kzalloc(sizeof(*info), GFP_KERNEL);
-	if (!info)
+	if (!info) {
+		trace_array_put(tr);
 		return -ENOMEM;
+	}
 
 	mutex_lock(&trace_types_lock);
 
@@ -4765,7 +4964,11 @@ static int tracing_buffers_open(struct inode *inode, struct file *filp)
 
 	mutex_unlock(&trace_types_lock);
 
-	return nonseekable_open(inode, filp);
+	ret = nonseekable_open(inode, filp);
+	if (ret < 0)
+		trace_array_put(tr);
+
+	return ret;
 }
 
 static unsigned int
@@ -4865,8 +5068,7 @@ static int tracing_buffers_release(struct inode *inode, struct file *file)
 
 	mutex_lock(&trace_types_lock);
 
-	WARN_ON(!iter->tr->ref);
-	iter->tr->ref--;
+	__trace_array_put(iter->tr);
 
 	if (info->spare)
 		ring_buffer_free_read_page(iter->trace_buffer->buffer, info->spare);
@@ -5614,15 +5816,10 @@ rb_simple_read(struct file *filp, char __user *ubuf,
 	       size_t cnt, loff_t *ppos)
 {
 	struct trace_array *tr = filp->private_data;
-	struct ring_buffer *buffer = tr->trace_buffer.buffer;
 	char buf[64];
 	int r;
 
-	if (buffer)
-		r = ring_buffer_record_is_on(buffer);
-	else
-		r = 0;
-
+	r = tracer_tracing_is_on(tr);
 	r = sprintf(buf, "%d\n", r);
 
 	return simple_read_from_buffer(ubuf, cnt, ppos, buf, r);
@@ -5644,11 +5841,11 @@ rb_simple_write(struct file *filp, const char __user *ubuf,
 	if (buffer) {
 		mutex_lock(&trace_types_lock);
 		if (val) {
-			ring_buffer_record_on(buffer);
+			tracer_tracing_on(tr);
 			if (tr->current_trace->start)
 				tr->current_trace->start(tr);
 		} else {
-			ring_buffer_record_off(buffer);
+			tracer_tracing_off(tr);
 			if (tr->current_trace->stop)
 				tr->current_trace->stop(tr);
 		}
@@ -5661,9 +5858,10 @@ rb_simple_write(struct file *filp, const char __user *ubuf,
 }
 
 static const struct file_operations rb_simple_fops = {
-	.open		= tracing_open_generic,
+	.open		= tracing_open_generic_tr,
 	.read		= rb_simple_read,
 	.write		= rb_simple_write,
+	.release	= tracing_release_generic_tr,
 	.llseek		= default_llseek,
 };
 
@@ -5935,7 +6133,7 @@ init_tracer_debugfs(struct trace_array *tr, struct dentry *d_tracer)
 	trace_create_file("buffer_total_size_kb", 0444, d_tracer,
 			  tr, &tracing_total_entries_fops);
 
-	trace_create_file("free_buffer", 0644, d_tracer,
+	trace_create_file("free_buffer", 0200, d_tracer,
 			  tr, &tracing_free_buffer_fops);
 
 	trace_create_file("trace_marker", 0220, d_tracer,
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 711ca7d..a4ed382 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -224,6 +224,11 @@ enum {
 
 extern struct list_head ftrace_trace_arrays;
 
+extern struct mutex trace_types_lock;
+
+extern int trace_array_get(struct trace_array *tr);
+extern void trace_array_put(struct trace_array *tr);
+
 /*
  * The global tracer (top) should be the first trace array added,
  * but we check the flag anyway.
@@ -554,11 +559,6 @@ void tracing_iter_reset(struct trace_iterator *iter, int cpu);
 
 void poll_wait_pipe(struct trace_iterator *iter);
 
-void ftrace(struct trace_array *tr,
-			    struct trace_array_cpu *data,
-			    unsigned long ip,
-			    unsigned long parent_ip,
-			    unsigned long flags, int pc);
 void tracing_sched_switch_trace(struct trace_array *tr,
 				struct task_struct *prev,
 				struct task_struct *next,
@@ -776,6 +776,7 @@ print_graph_function_flags(struct trace_iterator *iter, u32 flags)
 extern struct list_head ftrace_pids;
 
 #ifdef CONFIG_FUNCTION_TRACER
+extern bool ftrace_filter_param __initdata;
 static inline int ftrace_trace_task(struct task_struct *task)
 {
 	if (list_empty(&ftrace_pids))
@@ -901,12 +902,6 @@ static inline void trace_branch_disable(void)
 /* set ring buffers to default size if not already done so */
 int tracing_update_buffers(void);
 
-/* trace event type bit fields, not numeric */
-enum {
-	TRACE_EVENT_TYPE_PRINTF		= 1,
-	TRACE_EVENT_TYPE_RAW		= 2,
-};
-
 struct ftrace_event_field {
 	struct list_head	link;
 	const char		*name;
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 27963e2..7d85429 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -41,6 +41,23 @@ static LIST_HEAD(ftrace_common_fields);
 static struct kmem_cache *field_cachep;
 static struct kmem_cache *file_cachep;
 
+#define SYSTEM_FL_FREE_NAME		(1 << 31)
+
+static inline int system_refcount(struct event_subsystem *system)
+{
+	return system->ref_count & ~SYSTEM_FL_FREE_NAME;
+}
+
+static int system_refcount_inc(struct event_subsystem *system)
+{
+	return (system->ref_count++) & ~SYSTEM_FL_FREE_NAME;
+}
+
+static int system_refcount_dec(struct event_subsystem *system)
+{
+	return (--system->ref_count) & ~SYSTEM_FL_FREE_NAME;
+}
+
 /* Double loops, do not use break, only goto's work */
 #define do_for_each_event_file(tr, file)			\
 	list_for_each_entry(tr, &ftrace_trace_arrays, list) {	\
@@ -97,7 +114,7 @@ static int __trace_define_field(struct list_head *head, const char *type,
 
 	field = kmem_cache_alloc(field_cachep, GFP_TRACE);
 	if (!field)
-		goto err;
+		return -ENOMEM;
 
 	field->name = name;
 	field->type = type;
@@ -114,11 +131,6 @@ static int __trace_define_field(struct list_head *head, const char *type,
 	list_add(&field->link, head);
 
 	return 0;
-
-err:
-	kmem_cache_free(field_cachep, field);
-
-	return -ENOMEM;
 }
 
 int trace_define_field(struct ftrace_event_call *call, const char *type,
@@ -279,9 +291,11 @@ static int __ftrace_event_enable_disable(struct ftrace_event_file *file,
 			}
 			call->class->reg(call, TRACE_REG_UNREGISTER, file);
 		}
-		/* If in SOFT_MODE, just set the SOFT_DISABLE_BIT */
+		/* If in SOFT_MODE, just set the SOFT_DISABLE_BIT, else clear it */
 		if (file->flags & FTRACE_EVENT_FL_SOFT_MODE)
 			set_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT, &file->flags);
+		else
+			clear_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT, &file->flags);
 		break;
 	case 1:
 		/*
@@ -349,8 +363,8 @@ static void __put_system(struct event_subsystem *system)
 {
 	struct event_filter *filter = system->filter;
 
-	WARN_ON_ONCE(system->ref_count == 0);
-	if (--system->ref_count)
+	WARN_ON_ONCE(system_refcount(system) == 0);
+	if (system_refcount_dec(system))
 		return;
 
 	list_del(&system->list);
@@ -359,13 +373,15 @@ static void __put_system(struct event_subsystem *system)
 		kfree(filter->filter_string);
 		kfree(filter);
 	}
+	if (system->ref_count & SYSTEM_FL_FREE_NAME)
+		kfree(system->name);
 	kfree(system);
 }
 
 static void __get_system(struct event_subsystem *system)
 {
-	WARN_ON_ONCE(system->ref_count == 0);
-	system->ref_count++;
+	WARN_ON_ONCE(system_refcount(system) == 0);
+	system_refcount_inc(system);
 }
 
 static void __get_system_dir(struct ftrace_subsystem_dir *dir)
@@ -379,7 +395,7 @@ static void __put_system_dir(struct ftrace_subsystem_dir *dir)
 {
 	WARN_ON_ONCE(dir->ref_count == 0);
 	/* If the subsystem is about to be freed, the dir must be too */
-	WARN_ON_ONCE(dir->subsystem->ref_count == 1 && dir->ref_count != 1);
+	WARN_ON_ONCE(system_refcount(dir->subsystem) == 1 && dir->ref_count != 1);
 
 	__put_system(dir->subsystem);
 	if (!--dir->ref_count)
@@ -394,16 +410,45 @@ static void put_system(struct ftrace_subsystem_dir *dir)
 }
 
 /*
+ * Open and update trace_array ref count.
+ * Must have the current trace_array passed to it.
+ */
+static int tracing_open_generic_file(struct inode *inode, struct file *filp)
+{
+	struct ftrace_event_file *file = inode->i_private;
+	struct trace_array *tr = file->tr;
+	int ret;
+
+	if (trace_array_get(tr) < 0)
+		return -ENODEV;
+
+	ret = tracing_open_generic(inode, filp);
+	if (ret < 0)
+		trace_array_put(tr);
+	return ret;
+}
+
+static int tracing_release_generic_file(struct inode *inode, struct file *filp)
+{
+	struct ftrace_event_file *file = inode->i_private;
+	struct trace_array *tr = file->tr;
+
+	trace_array_put(tr);
+
+	return 0;
+}
+
+/*
  * __ftrace_set_clr_event(NULL, NULL, NULL, set) will set/unset all events.
  */
-static int __ftrace_set_clr_event(struct trace_array *tr, const char *match,
-				  const char *sub, const char *event, int set)
+static int
+__ftrace_set_clr_event_nolock(struct trace_array *tr, const char *match,
+			      const char *sub, const char *event, int set)
 {
 	struct ftrace_event_file *file;
 	struct ftrace_event_call *call;
 	int ret = -EINVAL;
 
-	mutex_lock(&event_mutex);
 	list_for_each_entry(file, &tr->events, list) {
 
 		call = file->event_call;
@@ -429,6 +474,17 @@ static int __ftrace_set_clr_event(struct trace_array *tr, const char *match,
 
 		ret = 0;
 	}
+
+	return ret;
+}
+
+static int __ftrace_set_clr_event(struct trace_array *tr, const char *match,
+				  const char *sub, const char *event, int set)
+{
+	int ret;
+
+	mutex_lock(&event_mutex);
+	ret = __ftrace_set_clr_event_nolock(tr, match, sub, event, set);
 	mutex_unlock(&event_mutex);
 
 	return ret;
@@ -624,17 +680,17 @@ event_enable_read(struct file *filp, char __user *ubuf, size_t cnt,
 		  loff_t *ppos)
 {
 	struct ftrace_event_file *file = filp->private_data;
-	char *buf;
+	char buf[4] = "0";
 
-	if (file->flags & FTRACE_EVENT_FL_ENABLED) {
-		if (file->flags & FTRACE_EVENT_FL_SOFT_DISABLED)
-			buf = "0*\n";
-		else if (file->flags & FTRACE_EVENT_FL_SOFT_MODE)
-			buf = "1*\n";
-		else
-			buf = "1\n";
-	} else
-		buf = "0\n";
+	if (file->flags & FTRACE_EVENT_FL_ENABLED &&
+	    !(file->flags & FTRACE_EVENT_FL_SOFT_DISABLED))
+		strcpy(buf, "1");
+
+	if (file->flags & FTRACE_EVENT_FL_SOFT_DISABLED ||
+	    file->flags & FTRACE_EVENT_FL_SOFT_MODE)
+		strcat(buf, "*");
+
+	strcat(buf, "\n");
 
 	return simple_read_from_buffer(ubuf, cnt, ppos, buf, strlen(buf));
 }
@@ -992,6 +1048,7 @@ static int subsystem_open(struct inode *inode, struct file *filp)
 	int ret;
 
 	/* Make sure the system still exists */
+	mutex_lock(&trace_types_lock);
 	mutex_lock(&event_mutex);
 	list_for_each_entry(tr, &ftrace_trace_arrays, list) {
 		list_for_each_entry(dir, &tr->systems, list) {
@@ -1007,6 +1064,7 @@ static int subsystem_open(struct inode *inode, struct file *filp)
 	}
  exit_loop:
 	mutex_unlock(&event_mutex);
+	mutex_unlock(&trace_types_lock);
 
 	if (!system)
 		return -ENODEV;
@@ -1014,9 +1072,17 @@ static int subsystem_open(struct inode *inode, struct file *filp)
 	/* Some versions of gcc think dir can be uninitialized here */
 	WARN_ON(!dir);
 
+	/* Still need to increment the ref count of the system */
+	if (trace_array_get(tr) < 0) {
+		put_system(dir);
+		return -ENODEV;
+	}
+
 	ret = tracing_open_generic(inode, filp);
-	if (ret < 0)
+	if (ret < 0) {
+		trace_array_put(tr);
 		put_system(dir);
+	}
 
 	return ret;
 }
@@ -1027,16 +1093,23 @@ static int system_tr_open(struct inode *inode, struct file *filp)
 	struct trace_array *tr = inode->i_private;
 	int ret;
 
+	if (trace_array_get(tr) < 0)
+		return -ENODEV;
+
 	/* Make a temporary dir that has no system but points to tr */
 	dir = kzalloc(sizeof(*dir), GFP_KERNEL);
-	if (!dir)
+	if (!dir) {
+		trace_array_put(tr);
 		return -ENOMEM;
+	}
 
 	dir->tr = tr;
 
 	ret = tracing_open_generic(inode, filp);
-	if (ret < 0)
+	if (ret < 0) {
+		trace_array_put(tr);
 		kfree(dir);
+	}
 
 	filp->private_data = dir;
 
@@ -1047,6 +1120,8 @@ static int subsystem_release(struct inode *inode, struct file *file)
 {
 	struct ftrace_subsystem_dir *dir = file->private_data;
 
+	trace_array_put(dir->tr);
+
 	/*
 	 * If dir->subsystem is NULL, then this is a temporary
 	 * descriptor that was made for a trace_array to enable
@@ -1174,9 +1249,10 @@ static const struct file_operations ftrace_set_event_fops = {
 };
 
 static const struct file_operations ftrace_enable_fops = {
-	.open = tracing_open_generic,
+	.open = tracing_open_generic_file,
 	.read = event_enable_read,
 	.write = event_enable_write,
+	.release = tracing_release_generic_file,
 	.llseek = default_llseek,
 };
 
@@ -1279,7 +1355,15 @@ create_new_subsystem(const char *name)
 		return NULL;
 
 	system->ref_count = 1;
-	system->name = name;
+
+	/* Only allocate if dynamic (kprobes and modules) */
+	if (!core_kernel_data((unsigned long)name)) {
+		system->ref_count |= SYSTEM_FL_FREE_NAME;
+		system->name = kstrdup(name, GFP_KERNEL);
+		if (!system->name)
+			goto out_free;
+	} else
+		system->name = name;
 
 	system->filter = NULL;
 
@@ -1292,6 +1376,8 @@ create_new_subsystem(const char *name)
 	return system;
 
  out_free:
+	if (system->ref_count & SYSTEM_FL_FREE_NAME)
+		kfree(system->name);
 	kfree(system);
 	return NULL;
 }
@@ -1591,6 +1677,7 @@ static void __add_event_to_tracers(struct ftrace_event_call *call,
 int trace_add_event_call(struct ftrace_event_call *call)
 {
 	int ret;
+	mutex_lock(&trace_types_lock);
 	mutex_lock(&event_mutex);
 
 	ret = __register_event(call, NULL);
@@ -1598,11 +1685,13 @@ int trace_add_event_call(struct ftrace_event_call *call)
 		__add_event_to_tracers(call, NULL);
 
 	mutex_unlock(&event_mutex);
+	mutex_unlock(&trace_types_lock);
 	return ret;
 }
 
 /*
- * Must be called under locking both of event_mutex and trace_event_sem.
+ * Must be called under locking of trace_types_lock, event_mutex and
+ * trace_event_sem.
  */
 static void __trace_remove_event_call(struct ftrace_event_call *call)
 {
@@ -1614,11 +1703,13 @@ static void __trace_remove_event_call(struct ftrace_event_call *call)
 /* Remove an event_call */
 void trace_remove_event_call(struct ftrace_event_call *call)
 {
+	mutex_lock(&trace_types_lock);
 	mutex_lock(&event_mutex);
 	down_write(&trace_event_sem);
 	__trace_remove_event_call(call);
 	up_write(&trace_event_sem);
 	mutex_unlock(&event_mutex);
+	mutex_unlock(&trace_types_lock);
 }
 
 #define for_each_event(event, start, end)			\
@@ -1762,6 +1853,7 @@ static int trace_module_notify(struct notifier_block *self,
 {
 	struct module *mod = data;
 
+	mutex_lock(&trace_types_lock);
 	mutex_lock(&event_mutex);
 	switch (val) {
 	case MODULE_STATE_COMING:
@@ -1772,6 +1864,7 @@ static int trace_module_notify(struct notifier_block *self,
 		break;
 	}
 	mutex_unlock(&event_mutex);
+	mutex_unlock(&trace_types_lock);
 
 	return 0;
 }
@@ -2011,10 +2104,7 @@ event_enable_func(struct ftrace_hash *hash,
 	int ret;
 
 	/* hash funcs only work with set_ftrace_filter */
-	if (!enabled)
-		return -EINVAL;
-
-	if (!param)
+	if (!enabled || !param)
 		return -EINVAL;
 
 	system = strsep(&param, ":");
@@ -2329,11 +2419,11 @@ early_event_add_tracer(struct dentry *parent, struct trace_array *tr)
 
 int event_trace_del_tracer(struct trace_array *tr)
 {
-	/* Disable any running events */
-	__ftrace_set_clr_event(tr, NULL, NULL, NULL, 0);
-
 	mutex_lock(&event_mutex);
 
+	/* Disable any running events */
+	__ftrace_set_clr_event_nolock(tr, NULL, NULL, NULL, 0);
+
 	down_write(&trace_event_sem);
 	__trace_remove_event_dirs(tr);
 	debugfs_remove_recursive(tr->event_dir);
diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index e1b653f..0d883dc 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -44,6 +44,7 @@ enum filter_op_ids
 	OP_LE,
 	OP_GT,
 	OP_GE,
+	OP_BAND,
 	OP_NONE,
 	OP_OPEN_PAREN,
 };
@@ -54,6 +55,7 @@ struct filter_op {
 	int precedence;
 };
 
+/* Order must be the same as enum filter_op_ids above */
 static struct filter_op filter_ops[] = {
 	{ OP_OR,	"||",		1 },
 	{ OP_AND,	"&&",		2 },
@@ -64,6 +66,7 @@ static struct filter_op filter_ops[] = {
 	{ OP_LE,	"<=",		5 },
 	{ OP_GT,	">",		5 },
 	{ OP_GE,	">=",		5 },
+	{ OP_BAND,	"&",		6 },
 	{ OP_NONE,	"OP_NONE",	0 },
 	{ OP_OPEN_PAREN, "(",		0 },
 };
@@ -156,6 +159,9 @@ static int filter_pred_##type(struct filter_pred *pred, void *event)	\
 	case OP_GE:							\
 		match = (*addr >= val);					\
 		break;							\
+	case OP_BAND:							\
+		match = (*addr & val);					\
+		break;							\
 	default:							\
 		break;							\
 	}								\
diff --git a/kernel/trace/trace_functions.c b/kernel/trace/trace_functions.c
index c4d6d71..b863f93 100644
--- a/kernel/trace/trace_functions.c
+++ b/kernel/trace/trace_functions.c
@@ -290,6 +290,21 @@ ftrace_stacktrace_count(unsigned long ip, unsigned long parent_ip, void **data)
 		trace_dump_stack(STACK_SKIP);
 }
 
+static void
+ftrace_dump_probe(unsigned long ip, unsigned long parent_ip, void **data)
+{
+	if (update_count(data))
+		ftrace_dump(DUMP_ALL);
+}
+
+/* Only dump the current CPU buffer. */
+static void
+ftrace_cpudump_probe(unsigned long ip, unsigned long parent_ip, void **data)
+{
+	if (update_count(data))
+		ftrace_dump(DUMP_ORIG);
+}
+
 static int
 ftrace_probe_print(const char *name, struct seq_file *m,
 		   unsigned long ip, void *data)
@@ -327,6 +342,20 @@ ftrace_stacktrace_print(struct seq_file *m, unsigned long ip,
 	return ftrace_probe_print("stacktrace", m, ip, data);
 }
 
+static int
+ftrace_dump_print(struct seq_file *m, unsigned long ip,
+			struct ftrace_probe_ops *ops, void *data)
+{
+	return ftrace_probe_print("dump", m, ip, data);
+}
+
+static int
+ftrace_cpudump_print(struct seq_file *m, unsigned long ip,
+			struct ftrace_probe_ops *ops, void *data)
+{
+	return ftrace_probe_print("cpudump", m, ip, data);
+}
+
 static struct ftrace_probe_ops traceon_count_probe_ops = {
 	.func			= ftrace_traceon_count,
 	.print			= ftrace_traceon_print,
@@ -342,6 +371,16 @@ static struct ftrace_probe_ops stacktrace_count_probe_ops = {
 	.print			= ftrace_stacktrace_print,
 };
 
+static struct ftrace_probe_ops dump_probe_ops = {
+	.func			= ftrace_dump_probe,
+	.print			= ftrace_dump_print,
+};
+
+static struct ftrace_probe_ops cpudump_probe_ops = {
+	.func			= ftrace_cpudump_probe,
+	.print			= ftrace_cpudump_print,
+};
+
 static struct ftrace_probe_ops traceon_probe_ops = {
 	.func			= ftrace_traceon,
 	.print			= ftrace_traceon_print,
@@ -425,6 +464,32 @@ ftrace_stacktrace_callback(struct ftrace_hash *hash,
 					   param, enable);
 }
 
+static int
+ftrace_dump_callback(struct ftrace_hash *hash,
+			   char *glob, char *cmd, char *param, int enable)
+{
+	struct ftrace_probe_ops *ops;
+
+	ops = &dump_probe_ops;
+
+	/* Only dump once. */
+	return ftrace_trace_probe_callback(ops, hash, glob, cmd,
+					   "1", enable);
+}
+
+static int
+ftrace_cpudump_callback(struct ftrace_hash *hash,
+			   char *glob, char *cmd, char *param, int enable)
+{
+	struct ftrace_probe_ops *ops;
+
+	ops = &cpudump_probe_ops;
+
+	/* Only dump once. */
+	return ftrace_trace_probe_callback(ops, hash, glob, cmd,
+					   "1", enable);
+}
+
 static struct ftrace_func_command ftrace_traceon_cmd = {
 	.name			= "traceon",
 	.func			= ftrace_trace_onoff_callback,
@@ -440,6 +505,16 @@ static struct ftrace_func_command ftrace_stacktrace_cmd = {
 	.func			= ftrace_stacktrace_callback,
 };
 
+static struct ftrace_func_command ftrace_dump_cmd = {
+	.name			= "dump",
+	.func			= ftrace_dump_callback,
+};
+
+static struct ftrace_func_command ftrace_cpudump_cmd = {
+	.name			= "cpudump",
+	.func			= ftrace_cpudump_callback,
+};
+
 static int __init init_func_cmd_traceon(void)
 {
 	int ret;
@@ -450,13 +525,31 @@ static int __init init_func_cmd_traceon(void)
 
 	ret = register_ftrace_command(&ftrace_traceon_cmd);
 	if (ret)
-		unregister_ftrace_command(&ftrace_traceoff_cmd);
+		goto out_free_traceoff;
 
 	ret = register_ftrace_command(&ftrace_stacktrace_cmd);
-	if (ret) {
-		unregister_ftrace_command(&ftrace_traceoff_cmd);
-		unregister_ftrace_command(&ftrace_traceon_cmd);
-	}
+	if (ret)
+		goto out_free_traceon;
+
+	ret = register_ftrace_command(&ftrace_dump_cmd);
+	if (ret)
+		goto out_free_stacktrace;
+
+	ret = register_ftrace_command(&ftrace_cpudump_cmd);
+	if (ret)
+		goto out_free_dump;
+
+	return 0;
+
+ out_free_dump:
+	unregister_ftrace_command(&ftrace_dump_cmd);
+ out_free_stacktrace:
+	unregister_ftrace_command(&ftrace_stacktrace_cmd);
+ out_free_traceon:
+	unregister_ftrace_command(&ftrace_traceon_cmd);
+ out_free_traceoff:
+	unregister_ftrace_command(&ftrace_traceoff_cmd);
+
 	return ret;
 }
 #else
diff --git a/kernel/trace/trace_irqsoff.c b/kernel/trace/trace_irqsoff.c
index b19d065..2aefbee 100644
--- a/kernel/trace/trace_irqsoff.c
+++ b/kernel/trace/trace_irqsoff.c
@@ -373,7 +373,7 @@ start_critical_timing(unsigned long ip, unsigned long parent_ip)
 	struct trace_array_cpu *data;
 	unsigned long flags;
 
-	if (likely(!tracer_enabled))
+	if (!tracer_enabled || !tracing_is_enabled())
 		return;
 
 	cpu = raw_smp_processor_id();
@@ -416,7 +416,7 @@ stop_critical_timing(unsigned long ip, unsigned long parent_ip)
 	else
 		return;
 
-	if (!tracer_enabled)
+	if (!tracer_enabled || !tracing_is_enabled())
 		return;
 
 	data = per_cpu_ptr(tr->trace_buffer.data, cpu);
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 9f46e98..7ed6976 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -35,12 +35,17 @@ struct trace_probe {
 	const char		*symbol;	/* symbol name */
 	struct ftrace_event_class	class;
 	struct ftrace_event_call	call;
-	struct ftrace_event_file * __rcu *files;
+	struct list_head	files;
 	ssize_t			size;		/* trace entry size */
 	unsigned int		nr_args;
 	struct probe_arg	args[];
 };
 
+struct event_file_link {
+	struct ftrace_event_file	*file;
+	struct list_head		list;
+};
+
 #define SIZEOF_TRACE_PROBE(n)			\
 	(offsetof(struct trace_probe, args) +	\
 	(sizeof(struct probe_arg) * (n)))
@@ -150,6 +155,7 @@ static struct trace_probe *alloc_trace_probe(const char *group,
 		goto error;
 
 	INIT_LIST_HEAD(&tp->list);
+	INIT_LIST_HEAD(&tp->files);
 	return tp;
 error:
 	kfree(tp->call.name);
@@ -183,25 +189,6 @@ static struct trace_probe *find_trace_probe(const char *event,
 	return NULL;
 }
 
-static int trace_probe_nr_files(struct trace_probe *tp)
-{
-	struct ftrace_event_file **file;
-	int ret = 0;
-
-	/*
-	 * Since all tp->files updater is protected by probe_enable_lock,
-	 * we don't need to lock an rcu_read_lock.
-	 */
-	file = rcu_dereference_raw(tp->files);
-	if (file)
-		while (*(file++))
-			ret++;
-
-	return ret;
-}
-
-static DEFINE_MUTEX(probe_enable_lock);
-
 /*
  * Enable trace_probe
  * if the file is NULL, enable "perf" handler, or enable "trace" handler.
@@ -211,67 +198,42 @@ enable_trace_probe(struct trace_probe *tp, struct ftrace_event_file *file)
 {
 	int ret = 0;
 
-	mutex_lock(&probe_enable_lock);
-
 	if (file) {
-		struct ftrace_event_file **new, **old;
-		int n = trace_probe_nr_files(tp);
-
-		old = rcu_dereference_raw(tp->files);
-		/* 1 is for new one and 1 is for stopper */
-		new = kzalloc((n + 2) * sizeof(struct ftrace_event_file *),
-			      GFP_KERNEL);
-		if (!new) {
+		struct event_file_link *link;
+
+		link = kmalloc(sizeof(*link), GFP_KERNEL);
+		if (!link) {
 			ret = -ENOMEM;
-			goto out_unlock;
+			goto out;
 		}
-		memcpy(new, old, n * sizeof(struct ftrace_event_file *));
-		new[n] = file;
-		/* The last one keeps a NULL */
 
-		rcu_assign_pointer(tp->files, new);
-		tp->flags |= TP_FLAG_TRACE;
+		link->file = file;
+		list_add_tail_rcu(&link->list, &tp->files);
 
-		if (old) {
-			/* Make sure the probe is done with old files */
-			synchronize_sched();
-			kfree(old);
-		}
+		tp->flags |= TP_FLAG_TRACE;
 	} else
 		tp->flags |= TP_FLAG_PROFILE;
 
-	if (trace_probe_is_enabled(tp) && trace_probe_is_registered(tp) &&
-	    !trace_probe_has_gone(tp)) {
+	if (trace_probe_is_registered(tp) && !trace_probe_has_gone(tp)) {
 		if (trace_probe_is_return(tp))
 			ret = enable_kretprobe(&tp->rp);
 		else
 			ret = enable_kprobe(&tp->rp.kp);
 	}
-
- out_unlock:
-	mutex_unlock(&probe_enable_lock);
-
+ out:
 	return ret;
 }
 
-static int
-trace_probe_file_index(struct trace_probe *tp, struct ftrace_event_file *file)
+static struct event_file_link *
+find_event_file_link(struct trace_probe *tp, struct ftrace_event_file *file)
 {
-	struct ftrace_event_file **files;
-	int i;
+	struct event_file_link *link;
 
-	/*
-	 * Since all tp->files updater is protected by probe_enable_lock,
-	 * we don't need to lock an rcu_read_lock.
-	 */
-	files = rcu_dereference_raw(tp->files);
-	if (files) {
-		for (i = 0; files[i]; i++)
-			if (files[i] == file)
-				return i;
-	}
+	list_for_each_entry(link, &tp->files, list)
+		if (link->file == file)
+			return link;
 
-	return -1;
+	return NULL;
 }
 
 /*
@@ -283,41 +245,24 @@ disable_trace_probe(struct trace_probe *tp, struct ftrace_event_file *file)
 {
 	int ret = 0;
 
-	mutex_lock(&probe_enable_lock);
-
 	if (file) {
-		struct ftrace_event_file **new, **old;
-		int n = trace_probe_nr_files(tp);
-		int i, j;
+		struct event_file_link *link;
 
-		old = rcu_dereference_raw(tp->files);
-		if (n == 0 || trace_probe_file_index(tp, file) < 0) {
+		link = find_event_file_link(tp, file);
+		if (!link) {
 			ret = -EINVAL;
-			goto out_unlock;
+			goto out;
 		}
 
-		if (n == 1) {	/* Remove the last file */
-			tp->flags &= ~TP_FLAG_TRACE;
-			new = NULL;
-		} else {
-			new = kzalloc(n * sizeof(struct ftrace_event_file *),
-				      GFP_KERNEL);
-			if (!new) {
-				ret = -ENOMEM;
-				goto out_unlock;
-			}
-
-			/* This copy & check loop copies the NULL stopper too */
-			for (i = 0, j = 0; j < n && i < n + 1; i++)
-				if (old[i] != file)
-					new[j++] = old[i];
-		}
+		list_del_rcu(&link->list);
+		/* synchronize with kprobe_trace_func/kretprobe_trace_func */
+		synchronize_sched();
+		kfree(link);
 
-		rcu_assign_pointer(tp->files, new);
+		if (!list_empty(&tp->files))
+			goto out;
 
-		/* Make sure the probe is done with old files */
-		synchronize_sched();
-		kfree(old);
+		tp->flags &= ~TP_FLAG_TRACE;
 	} else
 		tp->flags &= ~TP_FLAG_PROFILE;
 
@@ -327,10 +272,7 @@ disable_trace_probe(struct trace_probe *tp, struct ftrace_event_file *file)
 		else
 			disable_kprobe(&tp->rp.kp);
 	}
-
- out_unlock:
-	mutex_unlock(&probe_enable_lock);
-
+ out:
 	return ret;
 }
 
@@ -885,20 +827,10 @@ __kprobe_trace_func(struct trace_probe *tp, struct pt_regs *regs,
 static __kprobes void
 kprobe_trace_func(struct trace_probe *tp, struct pt_regs *regs)
 {
-	/*
-	 * Note: preempt is already disabled around the kprobe handler.
-	 * However, we still need an smp_read_barrier_depends() corresponding
-	 * to smp_wmb() in rcu_assign_pointer() to access the pointer.
-	 */
-	struct ftrace_event_file **file = rcu_dereference_raw(tp->files);
-
-	if (unlikely(!file))
-		return;
+	struct event_file_link *link;
 
-	while (*file) {
-		__kprobe_trace_func(tp, regs, *file);
-		file++;
-	}
+	list_for_each_entry_rcu(link, &tp->files, list)
+		__kprobe_trace_func(tp, regs, link->file);
 }
 
 /* Kretprobe handler */
@@ -945,20 +877,10 @@ static __kprobes void
 kretprobe_trace_func(struct trace_probe *tp, struct kretprobe_instance *ri,
 		     struct pt_regs *regs)
 {
-	/*
-	 * Note: preempt is already disabled around the kprobe handler.
-	 * However, we still need an smp_read_barrier_depends() corresponding
-	 * to smp_wmb() in rcu_assign_pointer() to access the pointer.
-	 */
-	struct ftrace_event_file **file = rcu_dereference_raw(tp->files);
+	struct event_file_link *link;
 
-	if (unlikely(!file))
-		return;
-
-	while (*file) {
-		__kretprobe_trace_func(tp, ri, regs, *file);
-		file++;
-	}
+	list_for_each_entry_rcu(link, &tp->files, list)
+		__kretprobe_trace_func(tp, ri, regs, link->file);
 }
 
 /* Event entry printers */
@@ -1157,6 +1079,10 @@ kprobe_perf_func(struct trace_probe *tp, struct pt_regs *regs)
 	int size, __size, dsize;
 	int rctx;
 
+	head = this_cpu_ptr(call->perf_events);
+	if (hlist_empty(head))
+		return;
+
 	dsize = __get_data_size(tp, regs);
 	__size = sizeof(*entry) + tp->size + dsize;
 	size = ALIGN(__size + sizeof(u32), sizeof(u64));
@@ -1172,10 +1098,7 @@ kprobe_perf_func(struct trace_probe *tp, struct pt_regs *regs)
 	entry->ip = (unsigned long)tp->rp.kp.addr;
 	memset(&entry[1], 0, dsize);
 	store_trace_args(sizeof(*entry), tp, regs, (u8 *)&entry[1], dsize);
-
-	head = this_cpu_ptr(call->perf_events);
-	perf_trace_buf_submit(entry, size, rctx,
-					entry->ip, 1, regs, head, NULL);
+	perf_trace_buf_submit(entry, size, rctx, 0, 1, regs, head, NULL);
 }
 
 /* Kretprobe profile handler */
@@ -1189,6 +1112,10 @@ kretprobe_perf_func(struct trace_probe *tp, struct kretprobe_instance *ri,
 	int size, __size, dsize;
 	int rctx;
 
+	head = this_cpu_ptr(call->perf_events);
+	if (hlist_empty(head))
+		return;
+
 	dsize = __get_data_size(tp, regs);
 	__size = sizeof(*entry) + tp->size + dsize;
 	size = ALIGN(__size + sizeof(u32), sizeof(u64));
@@ -1204,13 +1131,16 @@ kretprobe_perf_func(struct trace_probe *tp, struct kretprobe_instance *ri,
 	entry->func = (unsigned long)tp->rp.kp.addr;
 	entry->ret_ip = (unsigned long)ri->ret_addr;
 	store_trace_args(sizeof(*entry), tp, regs, (u8 *)&entry[1], dsize);
-
-	head = this_cpu_ptr(call->perf_events);
-	perf_trace_buf_submit(entry, size, rctx,
-					entry->ret_ip, 1, regs, head, NULL);
+	perf_trace_buf_submit(entry, size, rctx, 0, 1, regs, head, NULL);
 }
 #endif	/* CONFIG_PERF_EVENTS */
 
+/*
+ * called by perf_trace_init() or __ftrace_set_clr_event() under event_mutex.
+ *
+ * kprobe_trace_self_tests_init() does enable_trace_probe/disable_trace_probe
+ * lockless, but we can't race with this __init function.
+ */
 static __kprobes
 int kprobe_register(struct ftrace_event_call *event,
 		    enum trace_reg type, void *data)
@@ -1376,6 +1306,10 @@ find_trace_probe_file(struct trace_probe *tp, struct trace_array *tr)
 	return NULL;
 }
 
+/*
+ * Nobody but us can call enable_trace_probe/disable_trace_probe at this
+ * stage, we can do this lockless.
+ */
 static __init int kprobe_trace_self_tests_init(void)
 {
 	int ret, warn = 0;
diff --git a/kernel/trace/trace_selftest.c b/kernel/trace/trace_selftest.c
index 2901e3b..a7329b7 100644
--- a/kernel/trace/trace_selftest.c
+++ b/kernel/trace/trace_selftest.c
@@ -640,13 +640,20 @@ out:
  * Enable ftrace, sleep 1/10 second, and then read the trace
  * buffer to see if all is in order.
  */
-int
+__init int
 trace_selftest_startup_function(struct tracer *trace, struct trace_array *tr)
 {
 	int save_ftrace_enabled = ftrace_enabled;
 	unsigned long count;
 	int ret;
 
+#ifdef CONFIG_DYNAMIC_FTRACE
+	if (ftrace_filter_param) {
+		printk(KERN_CONT " ... kernel command line filter set: force PASS ... ");
+		return 0;
+	}
+#endif
+
 	/* make sure msleep has been recorded */
 	msleep(1);
 
@@ -727,13 +734,20 @@ static int trace_graph_entry_watchdog(struct ftrace_graph_ent *trace)
  * Pretty much the same than for the function tracer from which the selftest
  * has been borrowed.
  */
-int
+__init int
 trace_selftest_startup_function_graph(struct tracer *trace,
 					struct trace_array *tr)
 {
 	int ret;
 	unsigned long count;
 
+#ifdef CONFIG_DYNAMIC_FTRACE
+	if (ftrace_filter_param) {
+		printk(KERN_CONT " ... kernel command line filter set: force PASS ... ");
+		return 0;
+	}
+#endif
+
 	/*
 	 * Simulate the init() callback but we attach a watchdog callback
 	 * to detect and recover from possible hangs
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 8f2ac73..322e164 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -306,6 +306,8 @@ static void ftrace_syscall_enter(void *data, struct pt_regs *regs, long id)
 	struct syscall_metadata *sys_data;
 	struct ring_buffer_event *event;
 	struct ring_buffer *buffer;
+	unsigned long irq_flags;
+	int pc;
 	int syscall_nr;
 	int size;
 
@@ -321,9 +323,12 @@ static void ftrace_syscall_enter(void *data, struct pt_regs *regs, long id)
 
 	size = sizeof(*entry) + sizeof(unsigned long) * sys_data->nb_args;
 
+	local_save_flags(irq_flags);
+	pc = preempt_count();
+
 	buffer = tr->trace_buffer.buffer;
 	event = trace_buffer_lock_reserve(buffer,
-			sys_data->enter_event->event.type, size, 0, 0);
+			sys_data->enter_event->event.type, size, irq_flags, pc);
 	if (!event)
 		return;
 
@@ -333,7 +338,8 @@ static void ftrace_syscall_enter(void *data, struct pt_regs *regs, long id)
 
 	if (!filter_current_check_discard(buffer, sys_data->enter_event,
 					  entry, event))
-		trace_current_buffer_unlock_commit(buffer, event, 0, 0);
+		trace_current_buffer_unlock_commit(buffer, event,
+						   irq_flags, pc);
 }
 
 static void ftrace_syscall_exit(void *data, struct pt_regs *regs, long ret)
@@ -343,6 +349,8 @@ static void ftrace_syscall_exit(void *data, struct pt_regs *regs, long ret)
 	struct syscall_metadata *sys_data;
 	struct ring_buffer_event *event;
 	struct ring_buffer *buffer;
+	unsigned long irq_flags;
+	int pc;
 	int syscall_nr;
 
 	syscall_nr = trace_get_syscall_nr(current, regs);
@@ -355,9 +363,13 @@ static void ftrace_syscall_exit(void *data, struct pt_regs *regs, long ret)
 	if (!sys_data)
 		return;
 
+	local_save_flags(irq_flags);
+	pc = preempt_count();
+
 	buffer = tr->trace_buffer.buffer;
 	event = trace_buffer_lock_reserve(buffer,
-			sys_data->exit_event->event.type, sizeof(*entry), 0, 0);
+			sys_data->exit_event->event.type, sizeof(*entry),
+			irq_flags, pc);
 	if (!event)
 		return;
 
@@ -367,7 +379,8 @@ static void ftrace_syscall_exit(void *data, struct pt_regs *regs, long ret)
 
 	if (!filter_current_check_discard(buffer, sys_data->exit_event,
 					  entry, event))
-		trace_current_buffer_unlock_commit(buffer, event, 0, 0);
+		trace_current_buffer_unlock_commit(buffer, event,
+						   irq_flags, pc);
 }
 
 static int reg_event_syscall_enter(struct ftrace_event_file *file,
diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index 32494fb0..d5d0cd3 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -283,8 +283,10 @@ static int create_trace_uprobe(int argc, char **argv)
 		return -EINVAL;
 	}
 	arg = strchr(argv[1], ':');
-	if (!arg)
+	if (!arg) {
+		ret = -EINVAL;
 		goto fail_address_parse;
+	}
 
 	*arg++ = '\0';
 	filename = argv[1];


