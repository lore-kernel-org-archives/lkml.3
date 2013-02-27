Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932497Ab3B0Ru1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 12:50:27 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4530 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760119Ab3B0RuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 12:50:04 -0500
X-Authority-Analysis: v=2.0 cv=H5hZMpki c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=SGbVKvNtADEA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=Jw0if3e8IwAA:10 a=20KFwNOVAAAA:8 a=drOt6m5kAAAA:8 a=lWr70UQL_JmQNKFjZCYA:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130227174958.847915498@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 27 Feb 2013 12:22:39 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>, hcochran@lexmark.com,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [for-next][PATCH 7/8] tracing: Add interface to allow multiple trace buffers
References: <20130227172232.707306533@goodmis.org>
Content-Disposition: inline; filename=0007-tracing-Add-interface-to-allow-multiple-trace-buffer.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Add the interface ("instances" directory) to add multiple buffers
to ftrace. To create a new instance, simply do a mkdir in the
instances directory:

This will create a directory with the following:

 # cd instances
 # mkdir foo
 # ls foo
buffer_size_kb        free_buffer  trace_clock    trace_pipe
buffer_total_size_kb  set_event    trace_marker   tracing_enabled
events/               trace        trace_options  tracing_on

Currently only events are able to be set, and there isn't a way
to delete a buffer when one is created (yet).

Note, the i_mutex lock is dropped from the parent "instances"
directory during the mkdir operation. As the "instances" directory
can not be renamed or deleted (created on boot), I do not see
any harm in dropping the lock. The creation of the sub directories
is protected by trace_types_lock mutex, which only lets one
instance get into the code path at a time. If two tasks try to
create or delete directories of the same name, only one will occur
and the other will fail with -EEXIST.

Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c        |  129 +++++++++++++++++++++++++++++++++++++++++++
 kernel/trace/trace.h        |    2 +
 kernel/trace/trace_events.c |   12 +++-
 3 files changed, 142 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 74bc123..079f909 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -5016,6 +5016,133 @@ static const struct file_operations rb_simple_fops = {
 	.llseek		= default_llseek,
 };
 
+struct dentry *trace_instance_dir;
+
+static void
+init_tracer_debugfs(struct trace_array *tr, struct dentry *d_tracer);
+
+static int new_instance_create(const char *name)
+{
+	enum ring_buffer_flags rb_flags;
+	struct trace_array *tr;
+	int ret;
+	int i;
+
+	mutex_lock(&trace_types_lock);
+
+	ret = -EEXIST;
+	list_for_each_entry(tr, &ftrace_trace_arrays, list) {
+		if (tr->name && strcmp(tr->name, name) == 0)
+			goto out_unlock;
+	}
+
+	ret = -ENOMEM;
+	tr = kzalloc(sizeof(*tr), GFP_KERNEL);
+	if (!tr)
+		goto out_unlock;
+
+	tr->name = kstrdup(name, GFP_KERNEL);
+	if (!tr->name)
+		goto out_free_tr;
+
+	raw_spin_lock_init(&tr->start_lock);
+
+	tr->current_trace = &nop_trace;
+
+	INIT_LIST_HEAD(&tr->systems);
+	INIT_LIST_HEAD(&tr->events);
+
+	rb_flags = trace_flags & TRACE_ITER_OVERWRITE ? RB_FL_OVERWRITE : 0;
+
+	tr->buffer = ring_buffer_alloc(trace_buf_size, rb_flags);
+	if (!tr->buffer)
+		goto out_free_tr;
+
+	tr->data = alloc_percpu(struct trace_array_cpu);
+	if (!tr->data)
+		goto out_free_tr;
+
+	for_each_tracing_cpu(i) {
+		memset(per_cpu_ptr(tr->data, i), 0, sizeof(struct trace_array_cpu));
+		per_cpu_ptr(tr->data, i)->trace_cpu.cpu = i;
+		per_cpu_ptr(tr->data, i)->trace_cpu.tr = tr;
+	}
+
+	/* Holder for file callbacks */
+	tr->trace_cpu.cpu = RING_BUFFER_ALL_CPUS;
+	tr->trace_cpu.tr = tr;
+
+	tr->dir = debugfs_create_dir(name, trace_instance_dir);
+	if (!tr->dir)
+		goto out_free_tr;
+
+	ret = event_trace_add_tracer(tr->dir, tr);
+	if (ret)
+		goto out_free_tr;
+
+	init_tracer_debugfs(tr, tr->dir);
+
+	list_add(&tr->list, &ftrace_trace_arrays);
+
+	mutex_unlock(&trace_types_lock);
+
+	return 0;
+
+ out_free_tr:
+	if (tr->buffer)
+		ring_buffer_free(tr->buffer);
+	kfree(tr->name);
+	kfree(tr);
+
+ out_unlock:
+	mutex_unlock(&trace_types_lock);
+
+	return ret;
+
+}
+
+static int instance_mkdir (struct inode *inode, struct dentry *dentry, umode_t mode)
+{
+	struct dentry *parent;
+	int ret;
+
+	/* Paranoid: Make sure the parent is the "instances" directory */
+	parent = hlist_entry(inode->i_dentry.first, struct dentry, d_alias);
+	if (WARN_ON_ONCE(parent != trace_instance_dir))
+		return -ENOENT;
+
+	/*
+	 * The inode mutex is locked, but debugfs_create_dir() will also
+	 * take the mutex. As the instances directory can not be destroyed
+	 * or changed in any other way, it is safe to unlock it, and
+	 * let the dentry try. If two users try to make the same dir at
+	 * the same time, then the new_instance_create() will determine the
+	 * winner.
+	 */
+	mutex_unlock(&inode->i_mutex);
+
+	ret = new_instance_create(dentry->d_iname);
+
+	mutex_lock(&inode->i_mutex);
+
+	return ret;
+}
+
+static const struct inode_operations instance_dir_inode_operations = {
+	.lookup		= simple_lookup,
+	.mkdir		= instance_mkdir,
+};
+
+static __init void create_trace_instances(struct dentry *d_tracer)
+{
+	trace_instance_dir = debugfs_create_dir("instances", d_tracer);
+	if (WARN_ON(!trace_instance_dir))
+		return;
+
+	/* Hijack the dir inode operations, to allow mkdir */
+	trace_instance_dir->d_inode->i_op = &instance_dir_inode_operations;
+}
+
 static void
 init_tracer_debugfs(struct trace_array *tr, struct dentry *d_tracer)
 {
@@ -5092,6 +5219,8 @@ static __init int tracer_init_debugfs(void)
 			  (void *) RING_BUFFER_ALL_CPUS, &snapshot_fops);
 #endif
 
+	create_trace_instances(d_tracer);
+
 	create_trace_options_dir(&global_trace);
 
 	for_each_tracing_cpu(cpu)
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 5b45688..8aeac9b 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -175,6 +175,7 @@ struct tracer;
 struct trace_array {
 	struct ring_buffer	*buffer;
 	struct list_head	list;
+	char			*name;
 	int			cpu;
 	int			buffer_disabled;
 	struct trace_cpu	trace_cpu;	/* place holder */
@@ -995,6 +996,7 @@ filter_check_discard(struct ftrace_event_call *call, void *rec,
 }
 
 extern void trace_event_enable_cmd_record(bool enable);
+extern int event_trace_add_tracer(struct dentry *parent, struct trace_array *tr);
 
 extern struct mutex event_mutex;
 extern struct list_head ftrace_events;
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 4399552..58a6130 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -1754,16 +1754,22 @@ int event_trace_add_tracer(struct dentry *parent, struct trace_array *tr)
 	struct dentry *d_events;
 	struct dentry *entry;
 
+	mutex_lock(&event_mutex);
+
 	entry = debugfs_create_file("set_event", 0644, parent,
 				    tr, &ftrace_set_event_fops);
 	if (!entry) {
 		pr_warning("Could not create debugfs 'set_event' entry\n");
+		mutex_unlock(&event_mutex);
 		return -ENOMEM;
 	}
 
 	d_events = debugfs_create_dir("events", parent);
-	if (!d_events)
+	if (!d_events) {
 		pr_warning("Could not create debugfs 'events' directory\n");
+		mutex_unlock(&event_mutex);
+		return -ENOMEM;
+	}
 
 	/* ring buffer internal formats */
 	trace_create_file("header_page", 0444, d_events,
@@ -1778,7 +1784,11 @@ int event_trace_add_tracer(struct dentry *parent, struct trace_array *tr)
 			  tr, &ftrace_tr_enable_fops);
 
 	tr->event_dir = d_events;
+	down_write(&trace_event_mutex);
 	__trace_add_event_dirs(tr);
+	up_write(&trace_event_mutex);
+
+	mutex_unlock(&event_mutex);
 
 	return 0;
 }
-- 
1.7.10.4


