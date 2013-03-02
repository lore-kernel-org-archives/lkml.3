Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752352Ab3CBDAz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 22:00:55 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13993 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751804Ab3CBDAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 22:00:53 -0500
X-Authority-Analysis: v=2.0 cv=It2cgcDg c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=naC9Yog-qZAA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=xMZpjeMgk4cA:10 a=20KFwNOVAAAA:8 a=gvpz_aV9BbdqmsWtcHgA:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130302030050.179253501@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 01 Mar 2013 21:48:34 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>, hcochran@lexmark.com
Subject: [for-next][PATCH 1/7] tracing: Get trace_events kernel command line working again
References: <20130302024833.624729274@goodmis.org>
Content-Disposition: inline; filename=0001-tracing-Get-trace_events-kernel-command-line-working.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

With the new descriptors used to allow multiple buffers in the
tracing directory added, the kernel command line parameter
trace_events=... no longer works. This is because the top level
(global) trace array now has a list of descriptors associated
with the events and the files in the debugfs directory. But in
early bootup, when the command line is processed and the events
enabled, the trace array list of events has not been set up yet.

Without the list of events in the trace array, the setting of
events to record will fail because it would not match any events.

The solution is to set up the top level array in two stages.
The first is to just add the ftrace file descriptors that just point
to the events. This will allow events to be enabled and start tracing.
The second stage is called after the filesystem is set up, and this
stage will create the debugfs event files and directories associated
with the trace array events.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_events.c |  143 ++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 136 insertions(+), 7 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 06d6bc2..21fe83b 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -1473,6 +1473,28 @@ __trace_add_new_event(struct ftrace_event_call *call,
 	return event_create_dir(tr->event_dir, file, id, enable, filter, format);
 }
 
+/*
+ * Just create a decriptor for early init. A descriptor is required
+ * for enabling events at boot. We want to enable events before
+ * the filesystem is initialized.
+ */
+static __init int
+__trace_early_add_new_event(struct ftrace_event_call *call,
+			    struct trace_array *tr)
+{
+	struct ftrace_event_file *file;
+
+	file = kzalloc(sizeof(*file), GFP_KERNEL);
+	if (!file)
+		return -ENOMEM;
+
+	file->event_call = call;
+	file->tr = tr;
+	list_add(&file->list, &tr->events);
+
+	return 0;
+}
+
 struct ftrace_module_file_ops;
 static void __add_event_to_tracers(struct ftrace_event_call *call,
 				   struct ftrace_module_file_ops *file_ops);
@@ -1709,6 +1731,56 @@ __trace_add_event_dirs(struct trace_array *tr)
 	}
 }
 
+/*
+ * The top level array has already had its ftrace_event_file
+ * descriptors created in order to allow for early events to
+ * be recorded. This function is called after the debugfs has been
+ * initialized, and we now have to create the files associated
+ * to the events.
+ */
+static __init void
+__trace_early_add_event_dirs(struct trace_array *tr)
+{
+	struct ftrace_event_file *file;
+	int ret;
+
+
+	list_for_each_entry(file, &tr->events, list) {
+		ret = event_create_dir(tr->event_dir, file,
+				       &ftrace_event_id_fops,
+				       &ftrace_enable_fops,
+				       &ftrace_event_filter_fops,
+				       &ftrace_event_format_fops);
+		if (ret < 0)
+			pr_warning("Could not create directory for event %s\n",
+				   file->event_call->name);
+	}
+}
+
+/*
+ * For early boot up, the top trace array requires to have
+ * a list of events that can be enabled. This must be done before
+ * the filesystem is set up in order to allow events to be traced
+ * early.
+ */
+static __init void
+__trace_early_add_events(struct trace_array *tr)
+{
+	struct ftrace_event_call *call;
+	int ret;
+
+	list_for_each_entry(call, &ftrace_events, list) {
+		/* Early boot up should not have any modules loaded */
+		if (WARN_ON_ONCE(call->mod))
+			continue;
+
+		ret = __trace_early_add_new_event(call, tr);
+		if (ret < 0)
+			pr_warning("Could not create early event %s\n",
+				   call->name);
+	}
+}
+
 /* Remove the event directory structure for a trace directory. */
 static void
 __trace_remove_event_dirs(struct trace_array *tr)
@@ -1763,25 +1835,23 @@ static __init int setup_trace_event(char *str)
 }
 __setup("trace_event=", setup_trace_event);
 
-int event_trace_add_tracer(struct dentry *parent, struct trace_array *tr)
+/* Expects to have event_mutex held when called */
+static int
+create_event_toplevel_files(struct dentry *parent, struct trace_array *tr)
 {
 	struct dentry *d_events;
 	struct dentry *entry;
 
-	mutex_lock(&event_mutex);
-
 	entry = debugfs_create_file("set_event", 0644, parent,
 				    tr, &ftrace_set_event_fops);
 	if (!entry) {
 		pr_warning("Could not create debugfs 'set_event' entry\n");
-		mutex_unlock(&event_mutex);
 		return -ENOMEM;
 	}
 
 	d_events = debugfs_create_dir("events", parent);
 	if (!d_events) {
 		pr_warning("Could not create debugfs 'events' directory\n");
-		mutex_unlock(&event_mutex);
 		return -ENOMEM;
 	}
 
@@ -1798,13 +1868,64 @@ int event_trace_add_tracer(struct dentry *parent, struct trace_array *tr)
 			  tr, &ftrace_tr_enable_fops);
 
 	tr->event_dir = d_events;
+
+	return 0;
+}
+
+/**
+ * event_trace_add_tracer - add a instance of a trace_array to events
+ * @parent: The parent dentry to place the files/directories for events in
+ * @tr: The trace array associated with these events
+ *
+ * When a new instance is created, it needs to set up its events
+ * directory, as well as other files associated with events. It also
+ * creates the event hierachry in the @parent/events directory.
+ *
+ * Returns 0 on success.
+ */
+int event_trace_add_tracer(struct dentry *parent, struct trace_array *tr)
+{
+	int ret;
+
+	mutex_lock(&event_mutex);
+
+	ret = create_event_toplevel_files(parent, tr);
+	if (ret)
+		goto out_unlock;
+
 	down_write(&trace_event_mutex);
 	__trace_add_event_dirs(tr);
 	up_write(&trace_event_mutex);
 
+ out_unlock:
 	mutex_unlock(&event_mutex);
 
-	return 0;
+	return ret;
+}
+
+/*
+ * The top trace array already had its file descriptors created.
+ * Now the files themselves need to be created.
+ */
+static __init int
+early_event_add_tracer(struct dentry *parent, struct trace_array *tr)
+{
+	int ret;
+
+	mutex_lock(&event_mutex);
+
+	ret = create_event_toplevel_files(parent, tr);
+	if (ret)
+		goto out_unlock;
+
+	down_write(&trace_event_mutex);
+	__trace_early_add_event_dirs(tr);
+	up_write(&trace_event_mutex);
+
+ out_unlock:
+	mutex_unlock(&event_mutex);
+
+	return ret;
 }
 
 int event_trace_del_tracer(struct trace_array *tr)
@@ -1842,6 +1963,14 @@ static __init int event_trace_enable(void)
 			list_add(&call->list, &ftrace_events);
 	}
 
+	/*
+	 * We need the top trace array to have a working set of trace
+	 * points at early init, before the debug files and directories
+	 * are created. Create the file entries now, and attach them
+	 * to the actual file dentries later.
+	 */
+	__trace_early_add_events(tr);
+
 	while (true) {
 		token = strsep(&buf, ",");
 
@@ -1882,7 +2011,7 @@ static __init int event_trace_init(void)
 	if (trace_define_common_fields())
 		pr_warning("tracing: Failed to allocate common fields");
 
-	ret = event_trace_add_tracer(d_tracer, tr);
+	ret = early_event_add_tracer(d_tracer, tr);
 	if (ret)
 		return ret;
 
-- 
1.7.10.4


