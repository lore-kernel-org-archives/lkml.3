Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944Ab3GOSHB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 14:07:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60297 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752292Ab3GOSHA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 14:07:00 -0400
Date: Mon, 15 Jul 2013 20:01:49 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH 0/4] tracing/kprobes/uprobes: Fix race between
	opening probe event files and deleting probe
Message-ID: <20130715180149.GA15821@redhat.com>
References: <20130704033347.807661713@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130704033347.807661713@goodmis.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/03, Steven Rostedt wrote:
>
> Currently there exists a race with deleting a kprobe or uprobe and
> a user opening the probe event file or using perf events.
>
> The problem stems from not being able to take the probe_lock from the
> unregister code because we may have the event_mutex at the time, and
> the event mutex may be taken with the probe_lock held.
>
> To solve this, the events get a ref count (using the flags field), where
> when an event file is opened, the ftrace_event_call ref count increments.
> Then this is checked under event_mutex and if set, the unregistering
> of the probe will fail.

So. As Masami pointed out, this is not enough. Probably we can add more
hacks, but I'd like to discuss the alternative approach.

Note also that this ref count has the unfortunate property, if someone
keeps the file opened we can't remove an event.

Not sure you will like it, not sure this can actually work, but let me
try ;)

Note:
	- the "patch" below is only for illustration, it is intentionally
	  incomplete, it only "fixes" ftrace_enable_fops and ignores
	  id/format/filter. However I they could be fixed too. The most
	  problematic is ftrace_event_format_fops, it needs to update
	  trace_format_seq_ops.

	- we still need "trace_remove_event_call() should fail if call/file
	  is in use" which everyone seems to agree with

	- and we still need the discussed changes in trace_kpobes/uprobes

What this patch does:

	- add the new "topmost" rw_semaphore, file_sem.

	- trace_remove_event_call() takes this sem for writing and
	  cleares enable/id/format/filter->i_private

	- removes tracing_open_generic_file/tracing_release_generic_file,
	  we do not use file->f_private any longer

	- changes event_enable_read/event_enable_write to read
	  ftrace_event_file = i_private under read_lock(file_sem) and
	  abort if it is null.

Question: why event_enable_write() needs trace_array_get() ?

Steven, Masami, do you think this can make any sense?

Oleg.

--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -410,35 +410,6 @@ static void put_system(struct ftrace_subsystem_dir *dir)
 }
 
 /*
- * Open and update trace_array ref count.
- * Must have the current trace_array passed to it.
- */
-static int tracing_open_generic_file(struct inode *inode, struct file *filp)
-{
-	struct ftrace_event_file *file = inode->i_private;
-	struct trace_array *tr = file->tr;
-	int ret;
-
-	if (trace_array_get(tr) < 0)
-		return -ENODEV;
-
-	ret = tracing_open_generic(inode, filp);
-	if (ret < 0)
-		trace_array_put(tr);
-	return ret;
-}
-
-static int tracing_release_generic_file(struct inode *inode, struct file *filp)
-{
-	struct ftrace_event_file *file = inode->i_private;
-	struct trace_array *tr = file->tr;
-
-	trace_array_put(tr);
-
-	return 0;
-}
-
-/*
  * __ftrace_set_clr_event(NULL, NULL, NULL, set) will set/unset all events.
  */
 static int
@@ -675,19 +646,51 @@ static void t_stop(struct seq_file *m, void *p)
 	mutex_unlock(&event_mutex);
 }
 
+static DECLARE_RWSEM(file_sem);
+
+static void *get_i_private(struct file *filp)
+{
+	void *data;
+	down_read(&file_sem);
+	data = file_inode(filp)->i_private;
+	if (!data)
+		up_read(&file_sem);
+	return data;
+}
+
+static void put_i_private(struct file *filp)
+{
+	WARN_ON(!file_inode(filp)->i_private);
+	up_read(&file_sem);
+}
+
+static void clear_i_private(struct dentry *dir)
+{
+	struct dentry *child;
+	list_for_each_entry(child, &dir->d_subdirs, d_u.d_child)
+		child->d_inode->i_private = NULL;
+}
+
 static ssize_t
 event_enable_read(struct file *filp, char __user *ubuf, size_t cnt,
 		  loff_t *ppos)
 {
-	struct ftrace_event_file *file = filp->private_data;
+	struct ftrace_event_file *file;
+	unsigned long flags;
 	char buf[4] = "0";
 
-	if (file->flags & FTRACE_EVENT_FL_ENABLED &&
-	    !(file->flags & FTRACE_EVENT_FL_SOFT_DISABLED))
+	file = get_i_private(filp);
+	if (!file)
+		return -ENODEV;
+	flags = file->flags;
+	put_i_private(filp);
+
+	if (flags & FTRACE_EVENT_FL_ENABLED &&
+	    !(flags & FTRACE_EVENT_FL_SOFT_DISABLED))
 		strcpy(buf, "1");
 
-	if (file->flags & FTRACE_EVENT_FL_SOFT_DISABLED ||
-	    file->flags & FTRACE_EVENT_FL_SOFT_MODE)
+	if (flags & FTRACE_EVENT_FL_SOFT_DISABLED ||
+	    flags & FTRACE_EVENT_FL_SOFT_MODE)
 		strcat(buf, "*");
 
 	strcat(buf, "\n");
@@ -699,13 +702,10 @@ static ssize_t
 event_enable_write(struct file *filp, const char __user *ubuf, size_t cnt,
 		   loff_t *ppos)
 {
-	struct ftrace_event_file *file = filp->private_data;
+	struct ftrace_event_file *file;
 	unsigned long val;
 	int ret;
 
-	if (!file)
-		return -EINVAL;
-
 	ret = kstrtoul_from_user(ubuf, cnt, 10, &val);
 	if (ret)
 		return ret;
@@ -717,9 +717,18 @@ event_enable_write(struct file *filp, const char __user *ubuf, size_t cnt,
 	switch (val) {
 	case 0:
 	case 1:
-		mutex_lock(&event_mutex);
-		ret = ftrace_event_enable_disable(file, val);
-		mutex_unlock(&event_mutex);
+		file = get_i_private(filp);
+		if (!file)
+			return -ENODEV;
+
+		ret = trace_array_get(file->tr);
+		if (!ret) {
+			mutex_lock(&event_mutex);
+			ret = ftrace_event_enable_disable(file, val);
+			mutex_unlock(&event_mutex);
+			trace_array_put(file->tr);
+		}
+		put_i_private(filp);
 		break;
 
 	default:
@@ -1249,10 +1258,8 @@ static const struct file_operations ftrace_set_event_fops = {
 };
 
 static const struct file_operations ftrace_enable_fops = {
-	.open = tracing_open_generic_file,
 	.read = event_enable_read,
 	.write = event_enable_write,
-	.release = tracing_release_generic_file,
 	.llseek = default_llseek,
 };
 
@@ -1545,6 +1552,7 @@ static void remove_event_from_tracers(struct ftrace_event_call *call)
 			continue;
 
 		list_del(&file->list);
+		clear_i_private(file->dir);
 		debugfs_remove_recursive(file->dir);
 		remove_subsystem(file->system);
 		kmem_cache_free(file_cachep, file);
@@ -1703,6 +1711,7 @@ static void __trace_remove_event_call(struct ftrace_event_call *call)
 /* Remove an event_call */
 void trace_remove_event_call(struct ftrace_event_call *call)
 {
+	down_write(&file_sem);
 	mutex_lock(&trace_types_lock);
 	mutex_lock(&event_mutex);
 	down_write(&trace_event_sem);
@@ -1710,6 +1719,7 @@ void trace_remove_event_call(struct ftrace_event_call *call)
 	up_write(&trace_event_sem);
 	mutex_unlock(&event_mutex);
 	mutex_unlock(&trace_types_lock);
+	up_write(&file_sem);
 }
 
 #define for_each_event(event, start, end)			\

