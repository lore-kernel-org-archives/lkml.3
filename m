Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760657Ab3B0Rv5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 12:51:57 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4530 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760339Ab3B0RuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 12:50:00 -0500
X-Authority-Analysis: v=2.0 cv=H5hZMpki c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=BU_oeggMZuoA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=D9Lwq51q8WcA:10 a=20KFwNOVAAAA:8 a=drOt6m5kAAAA:8 a=zUdeqxu4MjOn_SzF1s8A:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130227174959.015393062@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 27 Feb 2013 12:22:40 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>, hcochran@lexmark.com,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [for-next][PATCH 8/8] tracing: Add rmdir to remove multibuffer instances
References: <20130227172232.707306533@goodmis.org>
Content-Disposition: inline; filename=0008-tracing-Add-rmdir-to-remove-multibuffer-instances.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Add a method to the hijacked dentry descriptor of the
"instances" directory to allow for rmdir to remove an
instance of a multibuffer.

Example:

  cd /debug/tracing/instances
  mkdir hello
  ls
hello/
  rmdir hello
  ls

Like the mkdir method, the i_mutex is dropped for the instances
directory. The instances directory is created at boot up and can
not be renamed or removed. The trace_types_lock mutex is used to
synchronize adding and removing of instances.

I've run several stress tests with different threads trying to
create and delete directories of the same name, and it has stood
up fine.

Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c        |   68 +++++++++++++++++++++++++++++++++++++++++++
 kernel/trace/trace.h        |    1 +
 kernel/trace/trace_events.c |   33 +++++++++++++++++++++
 3 files changed, 102 insertions(+)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 079f909..af7be82 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -5101,6 +5101,42 @@ static int new_instance_create(const char *name)
 
 }
 
+static int instance_delete(const char *name)
+{
+	struct trace_array *tr;
+	int found = 0;
+	int ret;
+
+	mutex_lock(&trace_types_lock);
+
+	ret = -ENODEV;
+	list_for_each_entry(tr, &ftrace_trace_arrays, list) {
+		if (tr->name && strcmp(tr->name, name) == 0) {
+			found = 1;
+			break;
+		}
+	}
+	if (!found)
+		goto out_unlock;
+
+	list_del(&tr->list);
+
+	event_trace_del_tracer(tr);
+	debugfs_remove_recursive(tr->dir);
+	free_percpu(tr->data);
+	ring_buffer_free(tr->buffer);
+
+	kfree(tr->name);
+	kfree(tr);
+
+	ret = 0;
+
+ out_unlock:
+	mutex_unlock(&trace_types_lock);
+
+	return ret;
+}
+
 static int instance_mkdir (struct inode *inode, struct dentry *dentry, umode_t mode)
 {
 	struct dentry *parent;
@@ -5128,9 +5164,41 @@ static int instance_mkdir (struct inode *inode, struct dentry *dentry, umode_t m
 	return ret;
 }
 
+static int instance_rmdir(struct inode *inode, struct dentry *dentry)
+{
+	struct dentry *parent;
+	int ret;
+
+	/* Paranoid: Make sure the parent is the "instances" directory */
+	parent = hlist_entry(inode->i_dentry.first, struct dentry, d_alias);
+	if (WARN_ON_ONCE(parent != trace_instance_dir))
+		return -ENOENT;
+
+	/* The caller did a dget() on dentry */
+	mutex_unlock(&dentry->d_inode->i_mutex);
+
+	/*
+	 * The inode mutex is locked, but debugfs_create_dir() will also
+	 * take the mutex. As the instances directory can not be destroyed
+	 * or changed in any other way, it is safe to unlock it, and
+	 * let the dentry try. If two users try to make the same dir at
+	 * the same time, then the instance_delete() will determine the
+	 * winner.
+	 */
+	mutex_unlock(&inode->i_mutex);
+
+	ret = instance_delete(dentry->d_iname);
+
+	mutex_lock_nested(&inode->i_mutex, I_MUTEX_PARENT);
+	mutex_lock(&dentry->d_inode->i_mutex);
+
+	return ret;
+}
+
 static const struct inode_operations instance_dir_inode_operations = {
 	.lookup		= simple_lookup,
 	.mkdir		= instance_mkdir,
+	.rmdir		= instance_rmdir,
 };
 
 static __init void create_trace_instances(struct dentry *d_tracer)
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 8aeac9b..592e8f2 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -997,6 +997,7 @@ filter_check_discard(struct ftrace_event_call *call, void *rec,
 
 extern void trace_event_enable_cmd_record(bool enable);
 extern int event_trace_add_tracer(struct dentry *parent, struct trace_array *tr);
+extern int event_trace_del_tracer(struct trace_array *tr);
 
 extern struct mutex event_mutex;
 extern struct list_head ftrace_events;
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 58a6130..06d6bc2 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -1709,6 +1709,20 @@ __trace_add_event_dirs(struct trace_array *tr)
 	}
 }
 
+/* Remove the event directory structure for a trace directory. */
+static void
+__trace_remove_event_dirs(struct trace_array *tr)
+{
+	struct ftrace_event_file *file, *next;
+
+	list_for_each_entry_safe(file, next, &tr->events, list) {
+		list_del(&file->list);
+		debugfs_remove_recursive(file->dir);
+		remove_subsystem(file->system);
+		kfree(file);
+	}
+}
+
 static void
 __add_event_to_tracers(struct ftrace_event_call *call,
 		       struct ftrace_module_file_ops *file_ops)
@@ -1793,6 +1807,25 @@ int event_trace_add_tracer(struct dentry *parent, struct trace_array *tr)
 	return 0;
 }
 
+int event_trace_del_tracer(struct trace_array *tr)
+{
+	/* Disable any running events */
+	__ftrace_set_clr_event(tr, NULL, NULL, NULL, 0);
+
+	mutex_lock(&event_mutex);
+
+	down_write(&trace_event_mutex);
+	__trace_remove_event_dirs(tr);
+	debugfs_remove_recursive(tr->event_dir);
+	up_write(&trace_event_mutex);
+
+	tr->event_dir = NULL;
+
+	mutex_unlock(&event_mutex);
+
+	return 0;
+}
+
 static __init int event_trace_enable(void)
 {
 	struct trace_array *tr = top_trace_array();
-- 
1.7.10.4


