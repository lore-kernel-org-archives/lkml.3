Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752948Ab3AUVSh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 16:18:37 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:10763 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541Ab3AUVRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 16:17:31 -0500
X-Authority-Analysis: v=2.0 cv=W/m6pGqk c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=VJK1zBOSSqwA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=OeHjR92M1CMA:10 a=20KFwNOVAAAA:8 a=pGLkceISAAAA:8 a=KWid02gi5TERqzEJ4R0A:9 a=jEp0ucaQiEUA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130121211728.725030853@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 21 Jan 2013 16:14:12 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 09/13 -next] tracing/fgraph: Add max_graph_depth to limit function_graph depth
References: <20130121211403.337052956@goodmis.org>
Content-Disposition: inline; filename=0009-tracing-fgraph-Add-max_graph_depth-to-limit-function.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Add the file max_graph_depth to the debug tracing directory that lets
the user define the depth of the function graph.

A very useful operation is to set the depth to 1. Then it traces only
the first function that is called when entering the kernel. This can
be used to determine what system operations interrupt a process.

For example, to work on NOHZ processes (single tasks running without
a timer tick), if any interrupt goes off and preempts that task, this
code will show it happening.

  # cd /sys/kernel/debug/tracing
  # echo 1 > max_graph_depth
  # echo function_graph > current_tracer
  # cat per_cpu/cpu/<cpu-of-process>/trace

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_functions_graph.c |   60 ++++++++++++++++++++++++++++++++--
 1 file changed, 58 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index 4edb4b7..7008d2e 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -47,6 +47,8 @@ struct fgraph_data {
 #define TRACE_GRAPH_PRINT_ABS_TIME	0x20
 #define TRACE_GRAPH_PRINT_IRQS		0x40
 
+static unsigned int max_depth;
+
 static struct tracer_opt trace_opts[] = {
 	/* Display overruns? (for self-debug purpose) */
 	{ TRACER_OPT(funcgraph-overrun, TRACE_GRAPH_PRINT_OVERRUN) },
@@ -250,8 +252,9 @@ int trace_graph_entry(struct ftrace_graph_ent *trace)
 		return 0;
 
 	/* trace it when it is-nested-in or is a function enabled. */
-	if (!(trace->depth || ftrace_graph_addr(trace->func)) ||
-	      ftrace_graph_ignore_irqs())
+	if ((!(trace->depth || ftrace_graph_addr(trace->func)) ||
+	     ftrace_graph_ignore_irqs()) ||
+	    (max_depth && trace->depth >= max_depth))
 		return 0;
 
 	local_irq_save(flags);
@@ -1457,6 +1460,59 @@ static struct tracer graph_trace __read_mostly = {
 #endif
 };
 
+
+static ssize_t
+graph_depth_write(struct file *filp, const char __user *ubuf, size_t cnt,
+		  loff_t *ppos)
+{
+	unsigned long val;
+	int ret;
+
+	ret = kstrtoul_from_user(ubuf, cnt, 10, &val);
+	if (ret)
+		return ret;
+
+	max_depth = val;
+
+	*ppos += cnt;
+
+	return cnt;
+}
+
+static ssize_t
+graph_depth_read(struct file *filp, char __user *ubuf, size_t cnt,
+		 loff_t *ppos)
+{
+	char buf[15]; /* More than enough to hold UINT_MAX + "\n"*/
+	int n;
+
+	n = sprintf(buf, "%d\n", max_depth);
+
+	return simple_read_from_buffer(ubuf, cnt, ppos, buf, n);
+}
+
+static const struct file_operations graph_depth_fops = {
+	.open		= tracing_open_generic,
+	.write		= graph_depth_write,
+	.read		= graph_depth_read,
+	.llseek		= generic_file_llseek,
+};
+
+static __init int init_graph_debugfs(void)
+{
+	struct dentry *d_tracer;
+
+	d_tracer = tracing_init_dentry();
+	if (!d_tracer)
+		return 0;
+
+	trace_create_file("max_graph_depth", 0644, d_tracer,
+			  NULL, &graph_depth_fops);
+
+	return 0;
+}
+fs_initcall(init_graph_debugfs);
+
 static __init int init_graph_trace(void)
 {
 	max_bytes_for_cpu = snprintf(NULL, 0, "%d", nr_cpu_ids - 1);
-- 
1.7.10.4


