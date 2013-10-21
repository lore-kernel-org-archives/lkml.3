Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752574Ab3JUCrJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Oct 2013 22:47:09 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:56684 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752253Ab3JUCqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Oct 2013 22:46:35 -0400
Message-Id: <20131021024631.148777555@goodmis.org>
User-Agent: quilt/0.60-1
Date: Sun, 20 Oct 2013 22:44:35 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [for-next][PATCH 6/6] ftrace: Add set_graph_notrace filter
References: <20131021024429.189874455@goodmis.org>
Content-Disposition: inline; filename=0006-ftrace-Add-set_graph_notrace-filter.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The set_graph_notrace filter is analogous to set_ftrace_notrace and
can be used for eliminating uninteresting part of function graph trace
output.  It also works with set_graph_function nicely.

  # cd /sys/kernel/debug/tracing/
  # echo do_page_fault > set_graph_function
  # perf ftrace live true
   2)               |  do_page_fault() {
   2)               |    __do_page_fault() {
   2)   0.381 us    |      down_read_trylock();
   2)   0.055 us    |      __might_sleep();
   2)   0.696 us    |      find_vma();
   2)               |      handle_mm_fault() {
   2)               |        handle_pte_fault() {
   2)               |          __do_fault() {
   2)               |            filemap_fault() {
   2)               |              find_get_page() {
   2)   0.033 us    |                __rcu_read_lock();
   2)   0.035 us    |                __rcu_read_unlock();
   2)   1.696 us    |              }
   2)   0.031 us    |              __might_sleep();
   2)   2.831 us    |            }
   2)               |            _raw_spin_lock() {
   2)   0.046 us    |              add_preempt_count();
   2)   0.841 us    |            }
   2)   0.033 us    |            page_add_file_rmap();
   2)               |            _raw_spin_unlock() {
   2)   0.057 us    |              sub_preempt_count();
   2)   0.568 us    |            }
   2)               |            unlock_page() {
   2)   0.084 us    |              page_waitqueue();
   2)   0.126 us    |              __wake_up_bit();
   2)   1.117 us    |            }
   2)   7.729 us    |          }
   2)   8.397 us    |        }
   2)   8.956 us    |      }
   2)   0.085 us    |      up_read();
   2) + 12.745 us   |    }
   2) + 13.401 us   |  }
  ...

  # echo handle_mm_fault > set_graph_notrace
  # perf ftrace live true
   1)               |  do_page_fault() {
   1)               |    __do_page_fault() {
   1)   0.205 us    |      down_read_trylock();
   1)   0.041 us    |      __might_sleep();
   1)   0.344 us    |      find_vma();
   1)   0.069 us    |      up_read();
   1)   4.692 us    |    }
   1)   5.311 us    |  }
  ...

Link: http://lkml.kernel.org/r/1381739066-7531-5-git-send-email-namhyung@kernel.org

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace.h               |  1 +
 kernel/trace/ftrace.c                | 33 +++++++++++++++++++++
 kernel/trace/trace.h                 | 22 ++++++++++++++
 kernel/trace/trace_functions_graph.c | 56 ++++++++++++++++++++++++++++++++++--
 4 files changed, 109 insertions(+), 3 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 9f15c00..ec85d48 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -721,6 +721,7 @@ ftrace_push_return_trace(unsigned long ret, unsigned long func, int *depth,
 extern char __irqentry_text_start[];
 extern char __irqentry_text_end[];
 
+#define FTRACE_NOTRACE_DEPTH 65536
 #define FTRACE_RETFUNC_DEPTH 50
 #define FTRACE_RETSTACK_ALLOC_SIZE 32
 extern int register_ftrace_graph(trace_func_graph_ret_t retfunc,
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 26a229a..44e826a 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -3776,7 +3776,9 @@ static const struct file_operations ftrace_notrace_fops = {
 static DEFINE_MUTEX(graph_lock);
 
 int ftrace_graph_count;
+int ftrace_graph_notrace_count;
 unsigned long ftrace_graph_funcs[FTRACE_GRAPH_MAX_FUNCS] __read_mostly;
+unsigned long ftrace_graph_notrace_funcs[FTRACE_GRAPH_MAX_FUNCS] __read_mostly;
 
 struct ftrace_graph_data {
 	unsigned long *table;
@@ -3891,6 +3893,26 @@ ftrace_graph_open(struct inode *inode, struct file *file)
 }
 
 static int
+ftrace_graph_notrace_open(struct inode *inode, struct file *file)
+{
+	struct ftrace_graph_data *fgd;
+
+	if (unlikely(ftrace_disabled))
+		return -ENODEV;
+
+	fgd = kmalloc(sizeof(*fgd), GFP_KERNEL);
+	if (fgd == NULL)
+		return -ENOMEM;
+
+	fgd->table = ftrace_graph_notrace_funcs;
+	fgd->size = FTRACE_GRAPH_MAX_FUNCS;
+	fgd->count = &ftrace_graph_notrace_count;
+	fgd->seq_ops = &ftrace_graph_seq_ops;
+
+	return __ftrace_graph_open(inode, file, fgd);
+}
+
+static int
 ftrace_graph_release(struct inode *inode, struct file *file)
 {
 	if (file->f_mode & FMODE_READ) {
@@ -4011,6 +4033,14 @@ static const struct file_operations ftrace_graph_fops = {
 	.llseek		= ftrace_filter_lseek,
 	.release	= ftrace_graph_release,
 };
+
+static const struct file_operations ftrace_graph_notrace_fops = {
+	.open		= ftrace_graph_notrace_open,
+	.read		= seq_read,
+	.write		= ftrace_graph_write,
+	.llseek		= ftrace_filter_lseek,
+	.release	= ftrace_graph_release,
+};
 #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
 
 static __init int ftrace_init_dyn_debugfs(struct dentry *d_tracer)
@@ -4032,6 +4062,9 @@ static __init int ftrace_init_dyn_debugfs(struct dentry *d_tracer)
 	trace_create_file("set_graph_function", 0444, d_tracer,
 				    NULL,
 				    &ftrace_graph_fops);
+	trace_create_file("set_graph_notrace", 0444, d_tracer,
+				    NULL,
+				    &ftrace_graph_notrace_fops);
 #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
 
 	return 0;
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 40211ce..d1cf515 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -732,6 +732,8 @@ extern void __trace_graph_return(struct trace_array *tr,
 #define FTRACE_GRAPH_MAX_FUNCS		32
 extern int ftrace_graph_count;
 extern unsigned long ftrace_graph_funcs[FTRACE_GRAPH_MAX_FUNCS];
+extern int ftrace_graph_notrace_count;
+extern unsigned long ftrace_graph_notrace_funcs[FTRACE_GRAPH_MAX_FUNCS];
 
 static inline int ftrace_graph_addr(unsigned long addr)
 {
@@ -757,11 +759,31 @@ static inline int ftrace_graph_addr(unsigned long addr)
 
 	return 0;
 }
+
+static inline int ftrace_graph_notrace_addr(unsigned long addr)
+{
+	int i;
+
+	if (!ftrace_graph_notrace_count)
+		return 0;
+
+	for (i = 0; i < ftrace_graph_notrace_count; i++) {
+		if (addr == ftrace_graph_notrace_funcs[i])
+			return 1;
+	}
+
+	return 0;
+}
 #else
 static inline int ftrace_graph_addr(unsigned long addr)
 {
 	return 1;
 }
+
+static inline int ftrace_graph_notrace_addr(unsigned long addr)
+{
+	return 0;
+}
 #endif /* CONFIG_DYNAMIC_FTRACE */
 #else /* CONFIG_FUNCTION_GRAPH_TRACER */
 static inline enum print_line_t
diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index b5c0924..e08c030 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -114,16 +114,37 @@ ftrace_push_return_trace(unsigned long ret, unsigned long func, int *depth,
 		return -EBUSY;
 	}
 
+	/*
+	 * The curr_ret_stack is an index to ftrace return stack of
+	 * current task.  Its value should be in [0, FTRACE_RETFUNC_
+	 * DEPTH) when the function graph tracer is used.  To support
+	 * filtering out specific functions, it makes the index
+	 * negative by subtracting huge value (FTRACE_NOTRACE_DEPTH)
+	 * so when it sees a negative index the ftrace will ignore
+	 * the record.  And the index gets recovered when returning
+	 * from the filtered function by adding the FTRACE_NOTRACE_
+	 * DEPTH and then it'll continue to record functions normally.
+	 *
+	 * The curr_ret_stack is initialized to -1 and get increased
+	 * in this function.  So it can be less than -1 only if it was
+	 * filtered out via ftrace_graph_notrace_addr() which can be
+	 * set from set_graph_notrace file in debugfs by user.
+	 */
+	if (current->curr_ret_stack < -1)
+		return -EBUSY;
+
 	calltime = trace_clock_local();
 
 	index = ++current->curr_ret_stack;
+	if (ftrace_graph_notrace_addr(func))
+		current->curr_ret_stack -= FTRACE_NOTRACE_DEPTH;
 	barrier();
 	current->ret_stack[index].ret = ret;
 	current->ret_stack[index].func = func;
 	current->ret_stack[index].calltime = calltime;
 	current->ret_stack[index].subtime = 0;
 	current->ret_stack[index].fp = frame_pointer;
-	*depth = index;
+	*depth = current->curr_ret_stack;
 
 	return 0;
 }
@@ -137,7 +158,17 @@ ftrace_pop_return_trace(struct ftrace_graph_ret *trace, unsigned long *ret,
 
 	index = current->curr_ret_stack;
 
-	if (unlikely(index < 0)) {
+	/*
+	 * A negative index here means that it's just returned from a
+	 * notrace'd function.  Recover index to get an original
+	 * return address.  See ftrace_push_return_trace().
+	 *
+	 * TODO: Need to check whether the stack gets corrupted.
+	 */
+	if (index < 0)
+		index += FTRACE_NOTRACE_DEPTH;
+
+	if (unlikely(index < 0 || index >= FTRACE_RETFUNC_DEPTH)) {
 		ftrace_graph_stop();
 		WARN_ON(1);
 		/* Might as well panic, otherwise we have no where to go */
@@ -193,6 +224,15 @@ unsigned long ftrace_return_to_handler(unsigned long frame_pointer)
 	trace.rettime = trace_clock_local();
 	barrier();
 	current->curr_ret_stack--;
+	/*
+	 * The curr_ret_stack can be less than -1 only if it was
+	 * filtered out and it's about to return from the function.
+	 * Recover the index and continue to trace normal functions.
+	 */
+	if (current->curr_ret_stack < -1) {
+		current->curr_ret_stack += FTRACE_NOTRACE_DEPTH;
+		return ret;
+	}
 
 	/*
 	 * The trace should run after decrementing the ret counter
@@ -259,10 +299,20 @@ int trace_graph_entry(struct ftrace_graph_ent *trace)
 
 	/* trace it when it is-nested-in or is a function enabled. */
 	if ((!(trace->depth || ftrace_graph_addr(trace->func)) ||
-	     ftrace_graph_ignore_irqs()) ||
+	     ftrace_graph_ignore_irqs()) || (trace->depth < 0) ||
 	    (max_depth && trace->depth >= max_depth))
 		return 0;
 
+	/*
+	 * Do not trace a function if it's filtered by set_graph_notrace.
+	 * Make the index of ret stack negative to indicate that it should
+	 * ignore further functions.  But it needs its own ret stack entry
+	 * to recover the original index in order to continue tracing after
+	 * returning from the function.
+	 */
+	if (ftrace_graph_notrace_addr(trace->func))
+		return 1;
+
 	local_irq_save(flags);
 	cpu = raw_smp_processor_id();
 	data = per_cpu_ptr(tr->trace_buffer.data, cpu);
-- 
1.8.4.rc3


