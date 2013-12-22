Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755560Ab3LVDMF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Dec 2013 22:12:05 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:11111 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751910Ab3LVDLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Dec 2013 22:11:49 -0500
Message-Id: <20131222031147.821808314@goodmis.org>
User-Agent: quilt/0.60-1
Date: Sat, 21 Dec 2013 22:08:00 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Tom Zanussi <tom.zanussi@linux.intel.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        kbuild test robot <fengguang.wu@intel.com>
Subject: [PATCH 1/2] tracing: Add generic tracing_lseek() function
References: <20131222030759.339128630@goodmis.org>
Content-Disposition: inline; filename=0001-tracing-Add-generic-tracing_lseek-function.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Trace event triggers added a lseek that uses the ftrace_filter_lseek()
function. Unfortunately, when function tracing is not configured in
that function is not defined and the kernel fails to build.

This is the second time that function was added to a file ops and
it broke the build due to requiring special config dependencies.

Make a generic tracing_lseek() that all the tracing utilities may
use.

Also, modify the old ftrace_filter_lseek() to return 0 instead of
1 on WRONLY. Not sure why it was a 1 as that does not make sense.

This also changes the old tracing_seek() to modify the file pos
pointer on WRONLY as well.

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace.h              |  2 --
 kernel/trace/ftrace.c               | 25 ++++++-------------------
 kernel/trace/trace.c                | 14 +++++++++-----
 kernel/trace/trace.h                |  2 ++
 kernel/trace/trace_events_trigger.c |  2 +-
 kernel/trace/trace_stack.c          |  2 +-
 6 files changed, 19 insertions(+), 28 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 31ea4b4..f4233b1 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -570,8 +570,6 @@ static inline int
 ftrace_regex_release(struct inode *inode, struct file *file) { return -ENODEV; }
 #endif /* CONFIG_DYNAMIC_FTRACE */
 
-loff_t ftrace_filter_lseek(struct file *file, loff_t offset, int whence);
-
 /* totally disable ftrace - can not re-enable after this */
 void ftrace_kill(void);
 
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 0e9f9ea..531ffa6 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1082,19 +1082,6 @@ static __init void ftrace_profile_debugfs(struct dentry *d_tracer)
 
 static struct pid * const ftrace_swapper_pid = &init_struct_pid;
 
-loff_t
-ftrace_filter_lseek(struct file *file, loff_t offset, int whence)
-{
-	loff_t ret;
-
-	if (file->f_mode & FMODE_READ)
-		ret = seq_lseek(file, offset, whence);
-	else
-		file->f_pos = ret = 1;
-
-	return ret;
-}
-
 #ifdef CONFIG_DYNAMIC_FTRACE
 
 #ifndef CONFIG_FTRACE_MCOUNT_RECORD
@@ -2739,7 +2726,7 @@ static void ftrace_filter_reset(struct ftrace_hash *hash)
  * routine, you can use ftrace_filter_write() for the write
  * routine if @flag has FTRACE_ITER_FILTER set, or
  * ftrace_notrace_write() if @flag has FTRACE_ITER_NOTRACE set.
- * ftrace_filter_lseek() should be used as the lseek routine, and
+ * tracing_lseek() should be used as the lseek routine, and
  * release must call ftrace_regex_release().
  */
 int
@@ -3767,7 +3754,7 @@ static const struct file_operations ftrace_filter_fops = {
 	.open = ftrace_filter_open,
 	.read = seq_read,
 	.write = ftrace_filter_write,
-	.llseek = ftrace_filter_lseek,
+	.llseek = tracing_lseek,
 	.release = ftrace_regex_release,
 };
 
@@ -3775,7 +3762,7 @@ static const struct file_operations ftrace_notrace_fops = {
 	.open = ftrace_notrace_open,
 	.read = seq_read,
 	.write = ftrace_notrace_write,
-	.llseek = ftrace_filter_lseek,
+	.llseek = tracing_lseek,
 	.release = ftrace_regex_release,
 };
 
@@ -4038,7 +4025,7 @@ static const struct file_operations ftrace_graph_fops = {
 	.open		= ftrace_graph_open,
 	.read		= seq_read,
 	.write		= ftrace_graph_write,
-	.llseek		= ftrace_filter_lseek,
+	.llseek		= tracing_lseek,
 	.release	= ftrace_graph_release,
 };
 
@@ -4046,7 +4033,7 @@ static const struct file_operations ftrace_graph_notrace_fops = {
 	.open		= ftrace_graph_notrace_open,
 	.read		= seq_read,
 	.write		= ftrace_graph_write,
-	.llseek		= ftrace_filter_lseek,
+	.llseek		= tracing_lseek,
 	.release	= ftrace_graph_release,
 };
 #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
@@ -4719,7 +4706,7 @@ static const struct file_operations ftrace_pid_fops = {
 	.open		= ftrace_pid_open,
 	.write		= ftrace_pid_write,
 	.read		= seq_read,
-	.llseek		= ftrace_filter_lseek,
+	.llseek		= tracing_lseek,
 	.release	= ftrace_pid_release,
 };
 
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 59bf5b5..e32a2f4 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3183,19 +3183,23 @@ tracing_write_stub(struct file *filp, const char __user *ubuf,
 	return count;
 }
 
-static loff_t tracing_seek(struct file *file, loff_t offset, int origin)
+loff_t tracing_lseek(struct file *file, loff_t offset, int whence)
 {
+	int ret;
+
 	if (file->f_mode & FMODE_READ)
-		return seq_lseek(file, offset, origin);
+		ret = seq_lseek(file, offset, whence);
 	else
-		return 0;
+		file->f_pos = ret = 0;
+
+	return ret;
 }
 
 static const struct file_operations tracing_fops = {
 	.open		= tracing_open,
 	.read		= seq_read,
 	.write		= tracing_write_stub,
-	.llseek		= tracing_seek,
+	.llseek		= tracing_lseek,
 	.release	= tracing_release,
 };
 
@@ -4940,7 +4944,7 @@ static const struct file_operations snapshot_fops = {
 	.open		= tracing_snapshot_open,
 	.read		= seq_read,
 	.write		= tracing_snapshot_write,
-	.llseek		= tracing_seek,
+	.llseek		= tracing_lseek,
 	.release	= tracing_snapshot_release,
 };
 
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 433bfc5..0380cab 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -588,6 +588,8 @@ void tracing_start_sched_switch_record(void);
 int register_tracer(struct tracer *type);
 int is_tracing_stopped(void);
 
+loff_t tracing_lseek(struct file *file, loff_t offset, int whence);
+
 extern cpumask_var_t __read_mostly tracing_buffer_mask;
 
 #define for_each_tracing_cpu(cpu)	\
diff --git a/kernel/trace/trace_events_trigger.c b/kernel/trace/trace_events_trigger.c
index f5b3f78..12ac8a5 100644
--- a/kernel/trace/trace_events_trigger.c
+++ b/kernel/trace/trace_events_trigger.c
@@ -281,7 +281,7 @@ const struct file_operations event_trigger_fops = {
 	.open = event_trigger_open,
 	.read = seq_read,
 	.write = event_trigger_write,
-	.llseek = ftrace_filter_lseek,
+	.llseek = tracing_lseek,
 	.release = event_trigger_release,
 };
 
diff --git a/kernel/trace/trace_stack.c b/kernel/trace/trace_stack.c
index b20428c..e6be585 100644
--- a/kernel/trace/trace_stack.c
+++ b/kernel/trace/trace_stack.c
@@ -382,7 +382,7 @@ static const struct file_operations stack_trace_filter_fops = {
 	.open = stack_trace_filter_open,
 	.read = seq_read,
 	.write = ftrace_filter_write,
-	.llseek = ftrace_filter_lseek,
+	.llseek = tracing_lseek,
 	.release = ftrace_regex_release,
 };
 
-- 
1.8.4.3


