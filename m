Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753649Ab3AWEoM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 23:44:12 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27612 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753454Ab3AWEoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 23:44:10 -0500
X-Authority-Analysis: v=2.0 cv=C91rOHz+ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=1lp5RE5RrrwA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=CpGQe48J6BUA:10 a=t5przTZDzlzkzD_J__UA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1358916249.21576.105.camel@gandalf.local.home>
Subject: Re: [RFC] Hack to use mkdir/rmdir in debugfs
From: Steven Rostedt <rostedt@goodmis.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 22 Jan 2013 23:44:09 -0500
In-Reply-To: <1358915495.21576.102.camel@gandalf.local.home>
References: <1358910114.21576.86.camel@gandalf.local.home>
	 <20130123040846.GA2638@kroah.com>
	 <1358915495.21576.102.camel@gandalf.local.home>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-01-22 at 23:31 -0500, Steven Rostedt wrote:

> > 
> > But again, I'd really not want to do this in debugfs, how about your own
> > filesystem?
> 
> I will note that this never modifies the debugfs code. But it does
> circumvent it. That is, all this code lives in kernel/trace/trace.c. I
> don't modify any of the debugfs code. I just replace the debugfs
> dentry->d_inode->i_op with my own ops.

Again, I want to stress that this doesn't touch the debugfs code. Here's
the real change that I've been testing. It includes the code for the
"new" and "free" files but those are not created because of an early
'return' I added. Notice that it's all contained in
kernel/trace/trace.c.

-- Steve

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 253cb51..851eb4a 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -4912,6 +4912,331 @@ static const struct file_operations rb_simple_fops = {
 	.llseek		= default_llseek,
 };
 
+struct dentry *trace_instance_dir;
+
+static void
+init_tracer_debugfs(struct trace_array *tr, struct dentry *d_tracer);
+
+static ssize_t
+trace_new_instance_read(struct file *filp, char __user *ubuf,
+			size_t cnt, loff_t *ppos)
+{
+	static char text[] =
+		"\nWrite into this file to create a new instance\n\n";
+
+	return simple_read_from_buffer(ubuf, cnt, ppos, text, sizeof(text));
+}
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
+	mutex_unlock(&trace_types_lock);
+
+	list_add(&tr->list, &ftrace_trace_arrays);
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
+static ssize_t
+trace_new_instance_write(struct file *filp, const char __user *ubuf,
+			 size_t cnt, loff_t *ppos)
+{
+	char *buf;
+	char *name;
+	int ret;
+
+	/* Don't let names be bigger than 1024 */
+	if (cnt > 1024)
+		return -EINVAL;
+
+	ret = -ENOMEM;
+	name = kmalloc(cnt+1, GFP_KERNEL);
+	if (!name)
+		return -ENOMEM;
+
+	ret = -EFAULT;
+	if (strncpy_from_user(name, ubuf, cnt) < 0)
+		goto out_free_name;
+
+	name[cnt] = '\0';
+
+	/* remove leading and trailing whitespace */
+	ret = -ENOMEM;
+	buf = strstrip(name);
+	buf = kstrdup(buf, GFP_KERNEL);
+	if (!buf)
+		goto out_free_name;
+	kfree(name);
+	name = buf;
+
+	ret = new_instance_create(name);
+
+	kfree(name);
+
+	if (ret)
+		return ret;
+
+	(*ppos) += cnt;
+
+	return cnt;
+
+ out_free_name:
+	kfree(name);
+	return ret;
+}
+
+static ssize_t
+trace_del_instance_read(struct file *filp, char __user *ubuf,
+			size_t cnt, loff_t *ppos)
+{
+	static char text[] =
+		"\nWrite into this file to remove an instance\n\n";
+
+	return simple_read_from_buffer(ubuf, cnt, ppos, text, sizeof(text));
+}
+
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
+static ssize_t
+trace_del_instance_write(struct file *filp, const char __user *ubuf,
+			 size_t cnt, loff_t *ppos)
+{
+	char *buf;
+	char *name;
+	int ret;
+
+	/* Don't let names be bigger than 1024 */
+	if (cnt > 1024)
+		return -EINVAL;
+
+	name = kmalloc(cnt+1, GFP_KERNEL);
+	if (!name)
+		return -ENOMEM;
+
+	ret = -EFAULT;
+	if (strncpy_from_user(name, ubuf, cnt) < 0)
+		goto out_free_name;
+
+	name[cnt] = '\0';
+
+	/* remove leading and trailing whitespace */
+	buf = strstrip(name);
+	buf = kstrdup(buf, GFP_KERNEL);
+	if (!buf)
+		goto out_free_name;
+	kfree(name);
+	name = buf;
+
+	ret = instance_delete(name);
+
+	(*ppos) += cnt;
+
+	return cnt;
+
+ out_free_name:
+	kfree(name);
+	return ret;
+}
+
+static const struct file_operations trace_new_instance_fops = {
+	.open		= tracing_open_generic,
+	.read		= trace_new_instance_read,
+	.write		= trace_new_instance_write,
+	.llseek		= default_llseek,
+};
+
+static const struct file_operations trace_del_instance_fops = {
+	.open		= tracing_open_generic,
+	.read		= trace_del_instance_read,
+	.write		= trace_del_instance_write,
+	.llseek		= default_llseek,
+};
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
+static const struct inode_operations instance_dir_inode_operations = {
+	.lookup		= simple_lookup,
+	.mkdir		= instance_mkdir,
+	.rmdir		= instance_rmdir,
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
+
+	return;
+	trace_create_file("new", 0644, trace_instance_dir, NULL,
+			  &trace_new_instance_fops);
+
+	trace_create_file("free", 0644, trace_instance_dir, NULL,
+			  &trace_del_instance_fops);
+}
+
 static void
 init_tracer_debugfs(struct trace_array *tr, struct dentry *d_tracer)
 {
@@ -4983,6 +5308,8 @@ static __init int tracer_init_debugfs(void)
 			&ftrace_update_tot_cnt, &tracing_dyn_info_fops);
 #endif
 
+	create_trace_instances(d_tracer);
+
 	create_trace_options_dir(&global_trace);
 
 	for_each_tracing_cpu(cpu)


