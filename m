Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753626AbbAURVe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 12:21:34 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:27755 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753044AbbAURVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 12:21:04 -0500
Message-Id: <20150121172101.652881523@goodmis.org>
User-Agent: quilt/0.61-1
Date: Wed, 21 Jan 2015 12:19:55 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [RFC][PATCH 2/5] tracing: Convert the tracing facility over to use tracefs
References: <20150121171953.823177070@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0002-tracing-Convert-the-tracing-facility-over-to-use-tra.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

debugfs was fine for the tracing facility as a quick way to get
an interface. Now that tracing has matured, it should separate itself
from debugfs such that it can be mounted separately without needing
to mount all of debugfs with it. That is, users resist using tracing
because it requires mounting debugfs. Having tracing have its own file
system lets users get the features of tracing without needing to bring
in the rest of the kernel's debug infrastructure.

Another reason for tracefs is that debubfs does not support mkdir.
Currently, to create instances, one does a mkdir in the tracing/instance
directory. This is implemented via a hack that forces debugfs to do something
it is not intended on doing. By converting over to tracefs, this hack can
be removed and mkdir can be properly implemented. This patch does not
address this yet, but it lays the ground work for that to be done.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c                | 22 ++++++-------
 kernel/trace/trace.c                 | 63 ++++++++++++++++++++++--------------
 kernel/trace/trace.h                 |  2 +-
 kernel/trace/trace_events.c          | 32 +++++++++---------
 kernel/trace/trace_functions_graph.c |  7 ++--
 kernel/trace/trace_kprobe.c          | 10 +++---
 kernel/trace/trace_probe.h           |  2 +-
 kernel/trace/trace_stat.c            | 10 +++---
 scripts/tags.sh                      |  2 +-
 9 files changed, 81 insertions(+), 69 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 80c9d34540dd..e3596de88fc1 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -18,7 +18,7 @@
 #include <linux/kallsyms.h>
 #include <linux/seq_file.h>
 #include <linux/suspend.h>
-#include <linux/debugfs.h>
+#include <linux/tracefs.h>
 #include <linux/hardirq.h>
 #include <linux/kthread.h>
 #include <linux/uaccess.h>
@@ -1008,7 +1008,7 @@ static struct tracer_stat function_stats __initdata = {
 	.stat_show	= function_stat_show
 };
 
-static __init void ftrace_profile_debugfs(struct dentry *d_tracer)
+static __init void ftrace_profile_tracefs(struct dentry *d_tracer)
 {
 	struct ftrace_profile_stat *stat;
 	struct dentry *entry;
@@ -1044,15 +1044,15 @@ static __init void ftrace_profile_debugfs(struct dentry *d_tracer)
 		}
 	}
 
-	entry = debugfs_create_file("function_profile_enabled", 0644,
+	entry = tracefs_create_file("function_profile_enabled", 0644,
 				    d_tracer, NULL, &ftrace_profile_fops);
 	if (!entry)
-		pr_warning("Could not create debugfs "
+		pr_warning("Could not create tracefs "
 			   "'function_profile_enabled' entry\n");
 }
 
 #else /* CONFIG_FUNCTION_PROFILER */
-static __init void ftrace_profile_debugfs(struct dentry *d_tracer)
+static __init void ftrace_profile_tracefs(struct dentry *d_tracer)
 {
 }
 #endif /* CONFIG_FUNCTION_PROFILER */
@@ -4653,7 +4653,7 @@ void ftrace_destroy_filter_files(struct ftrace_ops *ops)
 	mutex_unlock(&ftrace_lock);
 }
 
-static __init int ftrace_init_dyn_debugfs(struct dentry *d_tracer)
+static __init int ftrace_init_dyn_tracefs(struct dentry *d_tracer)
 {
 
 	trace_create_file("available_filter_functions", 0444,
@@ -4961,7 +4961,7 @@ static int __init ftrace_nodyn_init(void)
 }
 core_initcall(ftrace_nodyn_init);
 
-static inline int ftrace_init_dyn_debugfs(struct dentry *d_tracer) { return 0; }
+static inline int ftrace_init_dyn_tracefs(struct dentry *d_tracer) { return 0; }
 static inline void ftrace_startup_enable(int command) { }
 static inline void ftrace_startup_all(int command) { }
 /* Keep as macros so we do not need to define the commands */
@@ -5414,7 +5414,7 @@ static const struct file_operations ftrace_pid_fops = {
 	.release	= ftrace_pid_release,
 };
 
-static __init int ftrace_init_debugfs(void)
+static __init int ftrace_init_tracefs(void)
 {
 	struct dentry *d_tracer;
 
@@ -5422,16 +5422,16 @@ static __init int ftrace_init_debugfs(void)
 	if (IS_ERR(d_tracer))
 		return 0;
 
-	ftrace_init_dyn_debugfs(d_tracer);
+	ftrace_init_dyn_tracefs(d_tracer);
 
 	trace_create_file("set_ftrace_pid", 0644, d_tracer,
 			    NULL, &ftrace_pid_fops);
 
-	ftrace_profile_debugfs(d_tracer);
+	ftrace_profile_tracefs(d_tracer);
 
 	return 0;
 }
-fs_initcall(ftrace_init_debugfs);
+fs_initcall(ftrace_init_tracefs);
 
 /**
  * ftrace_kill - kill ftrace
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index acd27555dc5b..a51a00317abe 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -20,6 +20,7 @@
 #include <linux/notifier.h>
 #include <linux/irqflags.h>
 #include <linux/debugfs.h>
+#include <linux/tracefs.h>
 #include <linux/pagemap.h>
 #include <linux/hardirq.h>
 #include <linux/linkage.h>
@@ -5814,19 +5815,31 @@ static __init int register_snapshot_cmd(void)
 static inline __init int register_snapshot_cmd(void) { return 0; }
 #endif /* defined(CONFIG_TRACER_SNAPSHOT) && defined(CONFIG_DYNAMIC_FTRACE) */
 
+#define TRACE_TOP_DIR_ENTRY		((struct dentry *)1)
+
 struct dentry *tracing_init_dentry_tr(struct trace_array *tr)
 {
+	/* Top entry does not have a descriptor */
+	if (tr->dir == TRACE_TOP_DIR_ENTRY)
+		return NULL;
+
+	/* All sub buffers do */
 	if (tr->dir)
 		return tr->dir;
 
 	if (!debugfs_initialized())
 		return ERR_PTR(-ENODEV);
 
-	if (tr->flags & TRACE_ARRAY_FL_GLOBAL)
+	if (tr->flags & TRACE_ARRAY_FL_GLOBAL) {
 		tr->dir = debugfs_create_dir("tracing", NULL);
+		tr->dir = TRACE_TOP_DIR_ENTRY;
+		return NULL;
+	}
 
-	if (!tr->dir)
+	if (!tr->dir) {
 		pr_warn_once("Could not create debugfs directory 'tracing'\n");
+		return ERR_PTR(-ENOMEM);
+	}
 
 	return tr->dir;
 }
@@ -5847,10 +5860,10 @@ static struct dentry *tracing_dentry_percpu(struct trace_array *tr, int cpu)
 	if (IS_ERR(d_tracer))
 		return NULL;
 
-	tr->percpu_dir = debugfs_create_dir("per_cpu", d_tracer);
+	tr->percpu_dir = tracefs_create_dir("per_cpu", d_tracer);
 
 	WARN_ONCE(!tr->percpu_dir,
-		  "Could not create debugfs directory 'per_cpu/%d'\n", cpu);
+		  "Could not create tracefs directory 'per_cpu/%d'\n", cpu);
 
 	return tr->percpu_dir;
 }
@@ -5867,7 +5880,7 @@ trace_create_cpu_file(const char *name, umode_t mode, struct dentry *parent,
 }
 
 static void
-tracing_init_debugfs_percpu(struct trace_array *tr, long cpu)
+tracing_init_tracefs_percpu(struct trace_array *tr, long cpu)
 {
 	struct dentry *d_percpu = tracing_dentry_percpu(tr, cpu);
 	struct dentry *d_cpu;
@@ -5877,9 +5890,9 @@ tracing_init_debugfs_percpu(struct trace_array *tr, long cpu)
 		return;
 
 	snprintf(cpu_dir, 30, "cpu%ld", cpu);
-	d_cpu = debugfs_create_dir(cpu_dir, d_percpu);
+	d_cpu = tracefs_create_dir(cpu_dir, d_percpu);
 	if (!d_cpu) {
-		pr_warning("Could not create debugfs '%s' entry\n", cpu_dir);
+		pr_warning("Could not create tracefs '%s' entry\n", cpu_dir);
 		return;
 	}
 
@@ -6031,9 +6044,9 @@ struct dentry *trace_create_file(const char *name,
 {
 	struct dentry *ret;
 
-	ret = debugfs_create_file(name, mode, parent, data, fops);
+	ret = tracefs_create_file(name, mode, parent, data, fops);
 	if (!ret)
-		pr_warning("Could not create debugfs '%s' entry\n", name);
+		pr_warning("Could not create tracefs '%s' entry\n", name);
 
 	return ret;
 }
@@ -6050,9 +6063,9 @@ static struct dentry *trace_options_init_dentry(struct trace_array *tr)
 	if (IS_ERR(d_tracer))
 		return NULL;
 
-	tr->options = debugfs_create_dir("options", d_tracer);
+	tr->options = tracefs_create_dir("options", d_tracer);
 	if (!tr->options) {
-		pr_warning("Could not create debugfs directory 'options'\n");
+		pr_warning("Could not create tracefs directory 'options'\n");
 		return NULL;
 	}
 
@@ -6121,7 +6134,7 @@ destroy_trace_option_files(struct trace_option_dentry *topts)
 		return;
 
 	for (cnt = 0; topts[cnt].opt; cnt++)
-		debugfs_remove(topts[cnt].entry);
+		tracefs_remove(topts[cnt].entry);
 
 	kfree(topts);
 }
@@ -6210,7 +6223,7 @@ static const struct file_operations rb_simple_fops = {
 struct dentry *trace_instance_dir;
 
 static void
-init_tracer_debugfs(struct trace_array *tr, struct dentry *d_tracer);
+init_tracer_tracefs(struct trace_array *tr, struct dentry *d_tracer);
 
 static int
 allocate_trace_buffer(struct trace_array *tr, struct trace_buffer *buf, int size)
@@ -6326,17 +6339,17 @@ static int new_instance_create(const char *name)
 	if (allocate_trace_buffers(tr, trace_buf_size) < 0)
 		goto out_free_tr;
 
-	tr->dir = debugfs_create_dir(name, trace_instance_dir);
+	tr->dir = tracefs_create_dir(name, trace_instance_dir);
 	if (!tr->dir)
 		goto out_free_tr;
 
 	ret = event_trace_add_tracer(tr->dir, tr);
 	if (ret) {
-		debugfs_remove_recursive(tr->dir);
+		tracefs_remove_recursive(tr->dir);
 		goto out_free_tr;
 	}
 
-	init_tracer_debugfs(tr, tr->dir);
+	init_tracer_tracefs(tr, tr->dir);
 
 	list_add(&tr->list, &ftrace_trace_arrays);
 
@@ -6384,7 +6397,7 @@ static int instance_delete(const char *name)
 	tracing_set_nop(tr);
 	event_trace_del_tracer(tr);
 	ftrace_destroy_function_files(tr);
-	debugfs_remove_recursive(tr->dir);
+	tracefs_remove_recursive(tr->dir);
 	free_trace_buffers(tr);
 
 	kfree(tr->name);
@@ -6409,7 +6422,7 @@ static int instance_mkdir (struct inode *inode, struct dentry *dentry, umode_t m
 		return -ENOENT;
 
 	/*
-	 * The inode mutex is locked, but debugfs_create_dir() will also
+	 * The inode mutex is locked, but tracefs_create_dir() will also
 	 * take the mutex. As the instances directory can not be destroyed
 	 * or changed in any other way, it is safe to unlock it, and
 	 * let the dentry try. If two users try to make the same dir at
@@ -6439,7 +6452,7 @@ static int instance_rmdir(struct inode *inode, struct dentry *dentry)
 	mutex_unlock(&dentry->d_inode->i_mutex);
 
 	/*
-	 * The inode mutex is locked, but debugfs_create_dir() will also
+	 * The inode mutex is locked, but tracefs_create_dir() will also
 	 * take the mutex. As the instances directory can not be destroyed
 	 * or changed in any other way, it is safe to unlock it, and
 	 * let the dentry try. If two users try to make the same dir at
@@ -6464,7 +6477,7 @@ static const struct inode_operations instance_dir_inode_operations = {
 
 static __init void create_trace_instances(struct dentry *d_tracer)
 {
-	trace_instance_dir = debugfs_create_dir("instances", d_tracer);
+	trace_instance_dir = tracefs_create_dir("instances", d_tracer);
 	if (WARN_ON(!trace_instance_dir))
 		return;
 
@@ -6473,7 +6486,7 @@ static __init void create_trace_instances(struct dentry *d_tracer)
 }
 
 static void
-init_tracer_debugfs(struct trace_array *tr, struct dentry *d_tracer)
+init_tracer_tracefs(struct trace_array *tr, struct dentry *d_tracer)
 {
 	int cpu;
 
@@ -6527,11 +6540,11 @@ init_tracer_debugfs(struct trace_array *tr, struct dentry *d_tracer)
 #endif
 
 	for_each_tracing_cpu(cpu)
-		tracing_init_debugfs_percpu(tr, cpu);
+		tracing_init_tracefs_percpu(tr, cpu);
 
 }
 
-static __init int tracer_init_debugfs(void)
+static __init int tracer_init_tracefs(void)
 {
 	struct dentry *d_tracer;
 
@@ -6541,7 +6554,7 @@ static __init int tracer_init_debugfs(void)
 	if (IS_ERR(d_tracer))
 		return 0;
 
-	init_tracer_debugfs(&global_trace, d_tracer);
+	init_tracer_tracefs(&global_trace, d_tracer);
 
 	trace_create_file("tracing_thresh", 0644, d_tracer,
 			&global_trace, &tracing_thresh_fops);
@@ -6901,5 +6914,5 @@ __init static int clear_boot_tracer(void)
 	return 0;
 }
 
-fs_initcall(tracer_init_debugfs);
+fs_initcall(tracer_init_tracefs);
 late_initcall(clear_boot_tracer);
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 0eddfeb05fee..ba1170cb4880 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -334,7 +334,7 @@ struct tracer_flags {
 
 
 /**
- * struct tracer - a specific tracer and its callbacks to interact with debugfs
+ * struct tracer - a specific tracer and its callbacks to interact with tracefs
  * @name: the name chosen to select it on the available_tracers file
  * @init: called when one switches to this tracer (echo name > current_tracer)
  * @reset: called when one switches to another tracer
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 4ff8c1394017..e3b7782f904f 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -13,7 +13,7 @@
 #include <linux/workqueue.h>
 #include <linux/spinlock.h>
 #include <linux/kthread.h>
-#include <linux/debugfs.h>
+#include <linux/tracefs.h>
 #include <linux/uaccess.h>
 #include <linux/module.h>
 #include <linux/ctype.h>
@@ -480,7 +480,7 @@ static void remove_subsystem(struct ftrace_subsystem_dir *dir)
 		return;
 
 	if (!--dir->nr_events) {
-		debugfs_remove_recursive(dir->entry);
+		tracefs_remove_recursive(dir->entry);
 		list_del(&dir->list);
 		__put_system_dir(dir);
 	}
@@ -499,7 +499,7 @@ static void remove_event_file_dir(struct ftrace_event_file *file)
 		}
 		spin_unlock(&dir->d_lock);
 
-		debugfs_remove_recursive(dir);
+		tracefs_remove_recursive(dir);
 	}
 
 	list_del(&file->list);
@@ -1526,7 +1526,7 @@ event_subsystem_dir(struct trace_array *tr, const char *name,
 	} else
 		__get_system(system);
 
-	dir->entry = debugfs_create_dir(name, parent);
+	dir->entry = tracefs_create_dir(name, parent);
 	if (!dir->entry) {
 		pr_warn("Failed to create system directory %s\n", name);
 		__put_system(system);
@@ -1539,12 +1539,12 @@ event_subsystem_dir(struct trace_array *tr, const char *name,
 	dir->subsystem = system;
 	file->system = dir;
 
-	entry = debugfs_create_file("filter", 0644, dir->entry, dir,
+	entry = tracefs_create_file("filter", 0644, dir->entry, dir,
 				    &ftrace_subsystem_filter_fops);
 	if (!entry) {
 		kfree(system->filter);
 		system->filter = NULL;
-		pr_warn("Could not create debugfs '%s/filter' entry\n", name);
+		pr_warn("Could not create tracefs '%s/filter' entry\n", name);
 	}
 
 	trace_create_file("enable", 0644, dir->entry, dir,
@@ -1585,9 +1585,9 @@ event_create_dir(struct dentry *parent, struct ftrace_event_file *file)
 		d_events = parent;
 
 	name = ftrace_event_name(call);
-	file->dir = debugfs_create_dir(name, d_events);
+	file->dir = tracefs_create_dir(name, d_events);
 	if (!file->dir) {
-		pr_warn("Could not create debugfs '%s' directory\n", name);
+		pr_warn("Could not create tracefs '%s' directory\n", name);
 		return -1;
 	}
 
@@ -2228,7 +2228,7 @@ static inline int register_event_cmds(void) { return 0; }
 /*
  * The top level array has already had its ftrace_event_file
  * descriptors created in order to allow for early events to
- * be recorded. This function is called after the debugfs has been
+ * be recorded. This function is called after the tracefs has been
  * initialized, and we now have to create the files associated
  * to the events.
  */
@@ -2311,16 +2311,16 @@ create_event_toplevel_files(struct dentry *parent, struct trace_array *tr)
 	struct dentry *d_events;
 	struct dentry *entry;
 
-	entry = debugfs_create_file("set_event", 0644, parent,
+	entry = tracefs_create_file("set_event", 0644, parent,
 				    tr, &ftrace_set_event_fops);
 	if (!entry) {
-		pr_warn("Could not create debugfs 'set_event' entry\n");
+		pr_warn("Could not create tracefs 'set_event' entry\n");
 		return -ENOMEM;
 	}
 
-	d_events = debugfs_create_dir("events", parent);
+	d_events = tracefs_create_dir("events", parent);
 	if (!d_events) {
-		pr_warn("Could not create debugfs 'events' directory\n");
+		pr_warn("Could not create tracefs 'events' directory\n");
 		return -ENOMEM;
 	}
 
@@ -2412,7 +2412,7 @@ int event_trace_del_tracer(struct trace_array *tr)
 
 	down_write(&trace_event_sem);
 	__trace_remove_event_dirs(tr);
-	debugfs_remove_recursive(tr->event_dir);
+	tracefs_remove_recursive(tr->event_dir);
 	up_write(&trace_event_sem);
 
 	tr->event_dir = NULL;
@@ -2493,10 +2493,10 @@ static __init int event_trace_init(void)
 	if (IS_ERR(d_tracer))
 		return 0;
 
-	entry = debugfs_create_file("available_events", 0444, d_tracer,
+	entry = tracefs_create_file("available_events", 0444, d_tracer,
 				    tr, &ftrace_avail_fops);
 	if (!entry)
-		pr_warn("Could not create debugfs 'available_events' entry\n");
+		pr_warn("Could not create tracefs 'available_events' entry\n");
 
 	if (trace_define_common_fields())
 		pr_warn("tracing: Failed to allocate common fields");
diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index 2d25ad1526bb..9cfea4c6d314 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -6,7 +6,6 @@
  * is Copyright (c) Steven Rostedt <srostedt@redhat.com>
  *
  */
-#include <linux/debugfs.h>
 #include <linux/uaccess.h>
 #include <linux/ftrace.h>
 #include <linux/slab.h>
@@ -151,7 +150,7 @@ ftrace_push_return_trace(unsigned long ret, unsigned long func, int *depth,
 	 * The curr_ret_stack is initialized to -1 and get increased
 	 * in this function.  So it can be less than -1 only if it was
 	 * filtered out via ftrace_graph_notrace_addr() which can be
-	 * set from set_graph_notrace file in debugfs by user.
+	 * set from set_graph_notrace file in tracefs by user.
 	 */
 	if (current->curr_ret_stack < -1)
 		return -EBUSY;
@@ -1432,7 +1431,7 @@ static const struct file_operations graph_depth_fops = {
 	.llseek		= generic_file_llseek,
 };
 
-static __init int init_graph_debugfs(void)
+static __init int init_graph_tracefs(void)
 {
 	struct dentry *d_tracer;
 
@@ -1445,7 +1444,7 @@ static __init int init_graph_debugfs(void)
 
 	return 0;
 }
-fs_initcall(init_graph_debugfs);
+fs_initcall(init_graph_tracefs);
 
 static __init int init_graph_trace(void)
 {
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index b4a00def88f5..c1c6655847c8 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -1310,7 +1310,7 @@ static int unregister_kprobe_event(struct trace_kprobe *tk)
 	return ret;
 }
 
-/* Make a debugfs interface for controlling probe points */
+/* Make a tracefs interface for controlling probe points */
 static __init int init_kprobe_trace(void)
 {
 	struct dentry *d_tracer;
@@ -1323,20 +1323,20 @@ static __init int init_kprobe_trace(void)
 	if (IS_ERR(d_tracer))
 		return 0;
 
-	entry = debugfs_create_file("kprobe_events", 0644, d_tracer,
+	entry = tracefs_create_file("kprobe_events", 0644, d_tracer,
 				    NULL, &kprobe_events_ops);
 
 	/* Event list interface */
 	if (!entry)
-		pr_warning("Could not create debugfs "
+		pr_warning("Could not create tracefs "
 			   "'kprobe_events' entry\n");
 
 	/* Profile interface */
-	entry = debugfs_create_file("kprobe_profile", 0444, d_tracer,
+	entry = tracefs_create_file("kprobe_profile", 0444, d_tracer,
 				    NULL, &kprobe_profile_ops);
 
 	if (!entry)
-		pr_warning("Could not create debugfs "
+		pr_warning("Could not create tracefs "
 			   "'kprobe_profile' entry\n");
 	return 0;
 }
diff --git a/kernel/trace/trace_probe.h b/kernel/trace/trace_probe.h
index 4f815fbce16d..19aff635841a 100644
--- a/kernel/trace/trace_probe.h
+++ b/kernel/trace/trace_probe.h
@@ -25,7 +25,7 @@
 #include <linux/seq_file.h>
 #include <linux/slab.h>
 #include <linux/smp.h>
-#include <linux/debugfs.h>
+#include <linux/tracefs.h>
 #include <linux/types.h>
 #include <linux/string.h>
 #include <linux/ctype.h>
diff --git a/kernel/trace/trace_stat.c b/kernel/trace/trace_stat.c
index 75e19e86c954..6cf935316769 100644
--- a/kernel/trace/trace_stat.c
+++ b/kernel/trace/trace_stat.c
@@ -12,7 +12,7 @@
 #include <linux/list.h>
 #include <linux/slab.h>
 #include <linux/rbtree.h>
-#include <linux/debugfs.h>
+#include <linux/tracefs.h>
 #include "trace_stat.h"
 #include "trace.h"
 
@@ -65,7 +65,7 @@ static void reset_stat_session(struct stat_session *session)
 
 static void destroy_session(struct stat_session *session)
 {
-	debugfs_remove(session->file);
+	tracefs_remove(session->file);
 	__reset_stat_session(session);
 	mutex_destroy(&session->stat_mutex);
 	kfree(session);
@@ -279,9 +279,9 @@ static int tracing_stat_init(void)
 	if (IS_ERR(d_tracing))
 		return 0;
 
-	stat_dir = debugfs_create_dir("trace_stat", d_tracing);
+	stat_dir = tracefs_create_dir("trace_stat", d_tracing);
 	if (!stat_dir)
-		pr_warning("Could not create debugfs "
+		pr_warning("Could not create tracefs "
 			   "'trace_stat' entry\n");
 	return 0;
 }
@@ -291,7 +291,7 @@ static int init_stat_file(struct stat_session *session)
 	if (!stat_dir && tracing_stat_init())
 		return -ENODEV;
 
-	session->file = debugfs_create_file(session->ts->name, 0644,
+	session->file = tracefs_create_file(session->ts->name, 0644,
 					    stat_dir,
 					    session, &tracing_stat_fops);
 	if (!session->file)
diff --git a/scripts/tags.sh b/scripts/tags.sh
index cdb491d84503..505231a09b07 100755
--- a/scripts/tags.sh
+++ b/scripts/tags.sh
@@ -228,7 +228,7 @@ exuberant()
 
 emacs()
 {
-	all_target_sources | xargs $1 -a                        \
+	all_target_sources | xargs $1 -a --no-members           \
 	--regex='/^\(ENTRY\|_GLOBAL\)(\([^)]*\)).*/\2/'         \
 	--regex='/^SYSCALL_DEFINE[0-9]?(\([^,)]*\).*/sys_\1/'   \
 	--regex='/^COMPAT_SYSCALL_DEFINE[0-9]?(\([^,)]*\).*/compat_sys_\1/' \
-- 
2.1.4


