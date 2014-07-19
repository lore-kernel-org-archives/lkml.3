Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966046AbaGSNRQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 09:17:16 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:39169 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755464AbaGSNQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 09:16:15 -0400
Message-Id: <20140719131614.690605242@goodmis.org>
User-Agent: quilt/0.63-1
Date: Sat, 19 Jul 2014 09:15:54 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Stanislav Fomichev <stfomichev@yandex-team.ru>
Subject: [for-next][PATCH 30/32] tracing: let user specify tracing_thresh after selecting
 function_graph
References: <20140719131524.009152325@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0030-tracing-let-user-specify-tracing_thresh-after-select.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stanislav Fomichev <stfomichev@yandex-team.ru>

Currently, tracing_thresh works only if we specify it before selecting
function_graph tracer. If we do the opposite, tracing_thresh will change
it's value, but it will not be applied.
To fix it, we add update_thresh callback which is called whenever
tracing_thresh is updated and for function_graph tracer we register
handler which reinitializes tracer depending on tracing_thresh.

Link: http://lkml.kernel.org/p/20140718111727.GA3206@stfomichev-desktop.yandex.net

Signed-off-by: Stanislav Fomichev <stfomichev@yandex-team.ru>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c                 | 65 ++++++++++++++++++++++++++++++++----
 kernel/trace/trace.h                 |  2 ++
 kernel/trace/trace_functions_graph.c |  7 ++++
 3 files changed, 67 insertions(+), 7 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 4a343db45d4e..2752147ed317 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -4201,10 +4201,9 @@ tracing_set_trace_write(struct file *filp, const char __user *ubuf,
 }
 
 static ssize_t
-tracing_max_lat_read(struct file *filp, char __user *ubuf,
-		     size_t cnt, loff_t *ppos)
+tracing_nsecs_read(unsigned long *ptr, char __user *ubuf,
+		   size_t cnt, loff_t *ppos)
 {
-	unsigned long *ptr = filp->private_data;
 	char buf[64];
 	int r;
 
@@ -4216,10 +4215,9 @@ tracing_max_lat_read(struct file *filp, char __user *ubuf,
 }
 
 static ssize_t
-tracing_max_lat_write(struct file *filp, const char __user *ubuf,
-		      size_t cnt, loff_t *ppos)
+tracing_nsecs_write(unsigned long *ptr, const char __user *ubuf,
+		    size_t cnt, loff_t *ppos)
 {
-	unsigned long *ptr = filp->private_data;
 	unsigned long val;
 	int ret;
 
@@ -4232,6 +4230,52 @@ tracing_max_lat_write(struct file *filp, const char __user *ubuf,
 	return cnt;
 }
 
+static ssize_t
+tracing_thresh_read(struct file *filp, char __user *ubuf,
+		    size_t cnt, loff_t *ppos)
+{
+	return tracing_nsecs_read(&tracing_thresh, ubuf, cnt, ppos);
+}
+
+static ssize_t
+tracing_thresh_write(struct file *filp, const char __user *ubuf,
+		     size_t cnt, loff_t *ppos)
+{
+	struct trace_array *tr = filp->private_data;
+	int ret;
+
+	mutex_lock(&trace_types_lock);
+	ret = tracing_nsecs_write(&tracing_thresh, ubuf, cnt, ppos);
+	if (ret < 0)
+		goto out;
+
+	if (tr->current_trace->update_thresh) {
+		ret = tr->current_trace->update_thresh(tr);
+		if (ret < 0)
+			goto out;
+	}
+
+	ret = cnt;
+out:
+	mutex_unlock(&trace_types_lock);
+
+	return ret;
+}
+
+static ssize_t
+tracing_max_lat_read(struct file *filp, char __user *ubuf,
+		     size_t cnt, loff_t *ppos)
+{
+	return tracing_nsecs_read(filp->private_data, ubuf, cnt, ppos);
+}
+
+static ssize_t
+tracing_max_lat_write(struct file *filp, const char __user *ubuf,
+		      size_t cnt, loff_t *ppos)
+{
+	return tracing_nsecs_write(filp->private_data, ubuf, cnt, ppos);
+}
+
 static int tracing_open_pipe(struct inode *inode, struct file *filp)
 {
 	struct trace_array *tr = inode->i_private;
@@ -5133,6 +5177,13 @@ static int snapshot_raw_open(struct inode *inode, struct file *filp)
 #endif /* CONFIG_TRACER_SNAPSHOT */
 
 
+static const struct file_operations tracing_thresh_fops = {
+	.open		= tracing_open_generic,
+	.read		= tracing_thresh_read,
+	.write		= tracing_thresh_write,
+	.llseek		= generic_file_llseek,
+};
+
 static const struct file_operations tracing_max_lat_fops = {
 	.open		= tracing_open_generic,
 	.read		= tracing_max_lat_read,
@@ -6494,7 +6545,7 @@ static __init int tracer_init_debugfs(void)
 	init_tracer_debugfs(&global_trace, d_tracer);
 
 	trace_create_file("tracing_thresh", 0644, d_tracer,
-			&tracing_thresh, &tracing_max_lat_fops);
+			&global_trace, &tracing_thresh_fops);
 
 	trace_create_file("README", 0444, d_tracer,
 			NULL, &tracing_readme_fops);
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 9258f5a815db..385391fb1d3b 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -339,6 +339,7 @@ struct tracer_flags {
  * @reset: called when one switches to another tracer
  * @start: called when tracing is unpaused (echo 1 > tracing_enabled)
  * @stop: called when tracing is paused (echo 0 > tracing_enabled)
+ * @update_thresh: called when tracing_thresh is updated
  * @open: called when the trace file is opened
  * @pipe_open: called when the trace_pipe file is opened
  * @close: called when the trace file is released
@@ -357,6 +358,7 @@ struct tracer {
 	void			(*reset)(struct trace_array *tr);
 	void			(*start)(struct trace_array *tr);
 	void			(*stop)(struct trace_array *tr);
+	int			(*update_thresh)(struct trace_array *tr);
 	void			(*open)(struct trace_iterator *iter);
 	void			(*pipe_open)(struct trace_iterator *iter);
 	void			(*close)(struct trace_iterator *iter);
diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index 2c944e6c4a9d..74d98820497c 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -475,6 +475,12 @@ static void graph_trace_reset(struct trace_array *tr)
 	unregister_ftrace_graph();
 }
 
+int graph_trace_update_thresh(struct trace_array *tr)
+{
+	graph_trace_reset(tr);
+	return graph_trace_init(tr);
+}
+
 static int max_bytes_for_cpu;
 
 static enum print_line_t
@@ -1525,6 +1531,7 @@ static struct trace_event graph_trace_ret_event = {
 
 static struct tracer graph_trace __tracer_data = {
 	.name		= "function_graph",
+	.update_thresh	= graph_trace_update_thresh,
 	.open		= graph_trace_open,
 	.pipe_open	= graph_trace_open,
 	.close		= graph_trace_close,
-- 
2.0.1


