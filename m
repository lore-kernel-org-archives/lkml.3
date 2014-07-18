Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761497AbaGRLRg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 07:17:36 -0400
Received: from forward-corp1e.mail.yandex.net ([77.88.60.199]:51721 "EHLO
	forward-corp1e.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755971AbaGRLRe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 07:17:34 -0400
X-Yandex-Uniq: e11e4595-6a91-4faf-b23b-ef3b97325e3b
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Date: Fri, 18 Jul 2014 15:17:27 +0400
From: Stanislav Fomichev <stfomichev@yandex-team.ru>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: fweisbec@gmail.com, mingo@redhat.com, jovi.zhangwei@huawei.com,
        namhyung.kim@lge.com, tom.zanussi@linux.intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv4] tracing: let user specify tracing_thresh after
 selecting function_graph
Message-ID: <20140718111727.GA3206@stfomichev-desktop.yandex.net>
References: <1401815569-10513-1-git-send-email-stfomichev@yandex-team.ru>
 <20140603185720.79552fb8@gandalf.local.home>
 <20140604133350.GC26511@stfomichev-desktop.yandex.net>
 <20140604154149.3c2857dc@gandalf.local.home>
 <20140605073839.GG26511@stfomichev-desktop.yandex.net>
 <20140715092719.GB5127@stfomichev-desktop.yandex.net>
 <20140715090436.1d660119@gandalf.local.home>
 <20140715153157.GC5127@stfomichev-desktop.yandex.net>
 <20140717140851.3aa616f0@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140717140851.3aa616f0@gandalf.local.home>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, tracing_thresh works only if we specify it before selecting
function_graph tracer. If we do the opposite, tracing_thresh will change
it's value, but it will not be applied.
To fix it, we add update_thresh callback which is called whenever
tracing_thresh is updated and for function_graph tracer we register
handler which reinitializes tracer depending on tracing_thresh.

Signed-off-by: Stanislav Fomichev <stfomichev@yandex-team.ru>
---
 kernel/trace/trace.c                 | 65 ++++++++++++++++++++++++++++++++----
 kernel/trace/trace.h                 |  2 ++
 kernel/trace/trace_functions_graph.c |  7 ++++
 3 files changed, 67 insertions(+), 7 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index f243444a3772..986e6cad27d7 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -4224,10 +4224,9 @@ tracing_set_trace_write(struct file *filp, const char __user *ubuf,
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
 
@@ -4239,10 +4238,9 @@ tracing_max_lat_read(struct file *filp, char __user *ubuf,
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
 
@@ -4255,6 +4253,52 @@ tracing_max_lat_write(struct file *filp, const char __user *ubuf,
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
@@ -5156,6 +5200,13 @@ static int snapshot_raw_open(struct inode *inode, struct file *filp)
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
@@ -6519,7 +6570,7 @@ static __init int tracer_init_debugfs(void)
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
index 4de3e57f723c..898e4d6db213 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -445,6 +445,12 @@ static void graph_trace_reset(struct trace_array *tr)
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
@@ -1495,6 +1501,7 @@ static struct trace_event graph_trace_ret_event = {
 
 static struct tracer graph_trace __tracer_data = {
 	.name		= "function_graph",
+	.update_thresh	= graph_trace_update_thresh,
 	.open		= graph_trace_open,
 	.pipe_open	= graph_trace_open,
 	.close		= graph_trace_close,
-- 
1.9.1

