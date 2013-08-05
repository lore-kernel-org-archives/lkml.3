Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753692Ab3HEOTV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 10:19:21 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5853 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753648Ab3HEOTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 10:19:19 -0400
X-Authority-Analysis: v=2.0 cv=KJ7Y/S5o c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=RBRhBjuAhEYA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=rXe_6p3BrDAA:10 a=VwQbUJbxAAAA:8 a=1DPPrR7D9Pso4O63FcQA:9 a=QEXdDO2ut3YA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1375712355.22073.45.camel@gandalf.local.home>
Subject: [GIT PULL] tracing: final fixes for events and some
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dave Jones <davej@redhat.com>
Date: Mon, 05 Aug 2013 10:19:15 -0400
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

Oleg Nesterov has been working hard in closing all the holes that can
lead to race conditions between deleting an event and accessing an event
debugfs file. This included a fix to the debugfs system (acked by
Greg Kroah-Hartman). We think that all the holes have been patched and
hopefully we don't find more. I haven't marked all of them for stable
because I need to examine them more to figure out how far back some of
the changes need to go.

Along the way, some other fixes have been made. Alexander Z Lam fixed
some logic where the wrong buffer was being modifed.

Andrew Vagin found a possible corruption for machines that actually
allocate cpumask, as a reference to one was being zeroed out by mistake.

Dhaval Giani found a bad prototype when tracing is not configured.

And I not only had some changes to help Oleg, but also finally fixed
a long standing bug that Dave Jones and others have been hitting, where
a module unload and reload can cause the function tracing accounting
to get screwed up.

Please pull the latest trace-fixes-3.11-rc3 tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
trace-fixes-3.11-rc3

Tag SHA1: cd595fdd9ef3dd0b19f670047ba1f2a3486ebcfd
Head SHA1: 9457158bbc0ee04ecef76862d73eecd8076e9c7b


Alexander Z Lam (2):
      tracing: Make TRACE_ITER_STOP_ON_FREE stop the correct buffer
      tracing: Fix reset of time stamps during trace_clock changes

Andrew Vagin (1):
      tracing: Fix fields of struct trace_iterator that are zeroed by
mistake

Dhaval Giani (1):
      tracing: Fix trace_dump_stack() proto when CONFIG_TRACING is not
set

Oleg Nesterov (8):
      tracing: Turn event/id->i_private into call->event.type
      tracing: Change event_enable/disable_read() to verify i_private !=
NULL
      tracing: Change event_filter_read/write to verify i_private !=
NULL
      tracing: Change f_start() to take event_mutex and verify
i_private != NULL
      tracing: Introduce remove_event_file_dir()
      tracing: Change remove_event_file_dir() to clear
"d_subdirs"->i_private
      debugfs: debugfs_remove_recursive() must not rely on
list_empty(d_subdirs)
      tracing: trace_remove_event_call() should fail if call/file is in
use

Steven Rostedt (Red Hat) (5):
      ftrace: Consolidate some duplicate code for updating ftrace ops
      ftrace: Check module functions being traced on reload
      tracing: Add comment to describe special break case in
probe_remove_event_call()
      tracing/kprobes: Fail to unregister if probe event files are in
use
      tracing/uprobes: Fail to unregister if probe event files are in
use

----
 fs/debugfs/inode.c                 |   69 ++++---------
 include/linux/ftrace_event.h       |   12 ++-
 include/linux/kernel.h             |    2 +-
 kernel/trace/ftrace.c              |   87 +++++++++++++---
 kernel/trace/trace.c               |   27 ++---
 kernel/trace/trace_events.c        |  200
+++++++++++++++++++++++-------------
 kernel/trace/trace_events_filter.c |   17 ++-
 kernel/trace/trace_kprobe.c        |   21 ++--
 kernel/trace/trace_uprobe.c        |   51 ++++++---
 9 files changed, 302 insertions(+), 184 deletions(-)
---------------------------
diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
index 4888cb3..c7c83ff 100644
--- a/fs/debugfs/inode.c
+++ b/fs/debugfs/inode.c
@@ -533,8 +533,7 @@ EXPORT_SYMBOL_GPL(debugfs_remove);
  */
 void debugfs_remove_recursive(struct dentry *dentry)
 {
-	struct dentry *child;
-	struct dentry *parent;
+	struct dentry *child, *next, *parent;
 
 	if (IS_ERR_OR_NULL(dentry))
 		return;
@@ -544,61 +543,37 @@ void debugfs_remove_recursive(struct dentry
*dentry)
 		return;
 
 	parent = dentry;
+ down:
 	mutex_lock(&parent->d_inode->i_mutex);
+	list_for_each_entry_safe(child, next, &parent->d_subdirs, d_u.d_child)
{
+		if (!debugfs_positive(child))
+			continue;
 
-	while (1) {
-		/*
-		 * When all dentries under "parent" has been removed,
-		 * walk up the tree until we reach our starting point.
-		 */
-		if (list_empty(&parent->d_subdirs)) {
-			mutex_unlock(&parent->d_inode->i_mutex);
-			if (parent == dentry)
-				break;
-			parent = parent->d_parent;
-			mutex_lock(&parent->d_inode->i_mutex);
-		}
-		child = list_entry(parent->d_subdirs.next, struct dentry,
-				d_u.d_child);
- next_sibling:
-
-		/*
-		 * If "child" isn't empty, walk down the tree and
-		 * remove all its descendants first.
-		 */
+		/* perhaps simple_empty(child) makes more sense */
 		if (!list_empty(&child->d_subdirs)) {
 			mutex_unlock(&parent->d_inode->i_mutex);
 			parent = child;
-			mutex_lock(&parent->d_inode->i_mutex);
-			continue;
+			goto down;
 		}
-		__debugfs_remove(child, parent);
-		if (parent->d_subdirs.next == &child->d_u.d_child) {
-			/*
-			 * Try the next sibling.
-			 */
-			if (child->d_u.d_child.next != &parent->d_subdirs) {
-				child = list_entry(child->d_u.d_child.next,
-						   struct dentry,
-						   d_u.d_child);
-				goto next_sibling;
-			}
-
-			/*
-			 * Avoid infinite loop if we fail to remove
-			 * one dentry.
-			 */
-			mutex_unlock(&parent->d_inode->i_mutex);
-			break;
-		}
-		simple_release_fs(&debugfs_mount, &debugfs_mount_count);
+ up:
+		if (!__debugfs_remove(child, parent))
+			simple_release_fs(&debugfs_mount, &debugfs_mount_count);
 	}
 
-	parent = dentry->d_parent;
+	mutex_unlock(&parent->d_inode->i_mutex);
+	child = parent;
+	parent = parent->d_parent;
 	mutex_lock(&parent->d_inode->i_mutex);
-	__debugfs_remove(dentry, parent);
+
+	if (child != dentry) {
+		next = list_entry(child->d_u.d_child.next, struct dentry,
+					d_u.d_child);
+		goto up;
+	}
+
+	if (!__debugfs_remove(child, parent))
+		simple_release_fs(&debugfs_mount, &debugfs_mount_count);
 	mutex_unlock(&parent->d_inode->i_mutex);
-	simple_release_fs(&debugfs_mount, &debugfs_mount_count);
 }
 EXPORT_SYMBOL_GPL(debugfs_remove_recursive);
 
diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 4372658..120d57a 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -78,6 +78,11 @@ struct trace_iterator {
 	/* trace_seq for __print_flags() and __print_symbolic() etc. */
 	struct trace_seq	tmp_seq;
 
+	cpumask_var_t		started;
+
+	/* it's true when current open file is snapshot */
+	bool			snapshot;
+
 	/* The below is zeroed out in pipe_read */
 	struct trace_seq	seq;
 	struct trace_entry	*ent;
@@ -90,10 +95,7 @@ struct trace_iterator {
 	loff_t			pos;
 	long			idx;
 
-	cpumask_var_t		started;
-
-	/* it's true when current open file is snapshot */
-	bool			snapshot;
+	/* All new field here will be zeroed out in pipe_read */
 };
 
 enum trace_iter_flags {
@@ -332,7 +334,7 @@ extern int trace_define_field(struct
ftrace_event_call *call, const char *type,
 			      const char *name, int offset, int size,
 			      int is_signed, int filter_type);
 extern int trace_add_event_call(struct ftrace_event_call *call);
-extern void trace_remove_event_call(struct ftrace_event_call *call);
+extern int trace_remove_event_call(struct ftrace_event_call *call);
 
 #define is_signed_type(type)	(((type)(-1)) < (type)1)
 
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 3bef14c..482ad2d 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -629,7 +629,7 @@ extern void ftrace_dump(enum ftrace_dump_mode
oops_dump_mode);
 static inline void tracing_start(void) { }
 static inline void tracing_stop(void) { }
 static inline void ftrace_off_permanent(void) { }
-static inline void trace_dump_stack(void) { }
+static inline void trace_dump_stack(int skip) { }
 
 static inline void tracing_on(void) { }
 static inline void tracing_off(void) { }
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 8ce9eef..a6d098c 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2169,12 +2169,57 @@ static cycle_t		ftrace_update_time;
 static unsigned long	ftrace_update_cnt;
 unsigned long		ftrace_update_tot_cnt;
 
-static int ops_traces_mod(struct ftrace_ops *ops)
+static inline int ops_traces_mod(struct ftrace_ops *ops)
 {
-	struct ftrace_hash *hash;
+	/*
+	 * Filter_hash being empty will default to trace module.
+	 * But notrace hash requires a test of individual module functions.
+	 */
+	return ftrace_hash_empty(ops->filter_hash) &&
+		ftrace_hash_empty(ops->notrace_hash);
+}
+
+/*
+ * Check if the current ops references the record.
+ *
+ * If the ops traces all functions, then it was already accounted for.
+ * If the ops does not trace the current record function, skip it.
+ * If the ops ignores the function via notrace filter, skip it.
+ */
+static inline bool
+ops_references_rec(struct ftrace_ops *ops, struct dyn_ftrace *rec)
+{
+	/* If ops isn't enabled, ignore it */
+	if (!(ops->flags & FTRACE_OPS_FL_ENABLED))
+		return 0;
+
+	/* If ops traces all mods, we already accounted for it */
+	if (ops_traces_mod(ops))
+		return 0;
+
+	/* The function must be in the filter */
+	if (!ftrace_hash_empty(ops->filter_hash) &&
+	    !ftrace_lookup_ip(ops->filter_hash, rec->ip))
+		return 0;
+
+	/* If in notrace hash, we ignore it too */
+	if (ftrace_lookup_ip(ops->notrace_hash, rec->ip))
+		return 0;
+
+	return 1;
+}
+
+static int referenced_filters(struct dyn_ftrace *rec)
+{
+	struct ftrace_ops *ops;
+	int cnt = 0;
 
-	hash = ops->filter_hash;
-	return ftrace_hash_empty(hash);
+	for (ops = ftrace_ops_list; ops != &ftrace_list_end; ops = ops->next)
{
+		if (ops_references_rec(ops, rec))
+		    cnt++;
+	}
+
+	return cnt;
 }
 
 static int ftrace_update_code(struct module *mod)
@@ -2183,6 +2228,7 @@ static int ftrace_update_code(struct module *mod)
 	struct dyn_ftrace *p;
 	cycle_t start, stop;
 	unsigned long ref = 0;
+	bool test = false;
 	int i;
 
 	/*
@@ -2196,9 +2242,12 @@ static int ftrace_update_code(struct module *mod)
 
 		for (ops = ftrace_ops_list;
 		     ops != &ftrace_list_end; ops = ops->next) {
-			if (ops->flags & FTRACE_OPS_FL_ENABLED &&
-			    ops_traces_mod(ops))
-				ref++;
+			if (ops->flags & FTRACE_OPS_FL_ENABLED) {
+				if (ops_traces_mod(ops))
+					ref++;
+				else
+					test = true;
+			}
 		}
 	}
 
@@ -2208,12 +2257,16 @@ static int ftrace_update_code(struct module
*mod)
 	for (pg = ftrace_new_pgs; pg; pg = pg->next) {
 
 		for (i = 0; i < pg->index; i++) {
+			int cnt = ref;
+
 			/* If something went wrong, bail without enabling anything */
 			if (unlikely(ftrace_disabled))
 				return -1;
 
 			p = &pg->records[i];
-			p->flags = ref;
+			if (test)
+				cnt += referenced_filters(p);
+			p->flags = cnt;
 
 			/*
 			 * Do the initial record conversion from mcount jump
@@ -2233,7 +2286,7 @@ static int ftrace_update_code(struct module *mod)
 			 * conversion puts the module to the correct state, thus
 			 * passing the ftrace_make_call check.
 			 */
-			if (ftrace_start_up && ref) {
+			if (ftrace_start_up && cnt) {
 				int failed = __ftrace_replace_code(p, 1);
 				if (failed)
 					ftrace_bug(failed, p->ip);
@@ -3384,6 +3437,12 @@ ftrace_match_addr(struct ftrace_hash *hash,
unsigned long ip, int remove)
 	return add_hash_entry(hash, ip);
 }
 
+static void ftrace_ops_update_code(struct ftrace_ops *ops)
+{
+	if (ops->flags & FTRACE_OPS_FL_ENABLED && ftrace_enabled)
+		ftrace_run_update_code(FTRACE_UPDATE_CALLS);
+}
+
 static int
 ftrace_set_hash(struct ftrace_ops *ops, unsigned char *buf, int len,
 		unsigned long ip, int remove, int reset, int enable)
@@ -3426,9 +3485,8 @@ ftrace_set_hash(struct ftrace_ops *ops, unsigned
char *buf, int len,
 
 	mutex_lock(&ftrace_lock);
 	ret = ftrace_hash_move(ops, enable, orig_hash, hash);
-	if (!ret && ops->flags & FTRACE_OPS_FL_ENABLED
-	    && ftrace_enabled)
-		ftrace_run_update_code(FTRACE_UPDATE_CALLS);
+	if (!ret)
+		ftrace_ops_update_code(ops);
 
 	mutex_unlock(&ftrace_lock);
 
@@ -3655,9 +3713,8 @@ int ftrace_regex_release(struct inode *inode,
struct file *file)
 		mutex_lock(&ftrace_lock);
 		ret = ftrace_hash_move(iter->ops, filter_hash,
 				       orig_hash, iter->hash);
-		if (!ret && (iter->ops->flags & FTRACE_OPS_FL_ENABLED)
-		    && ftrace_enabled)
-			ftrace_run_update_code(FTRACE_UPDATE_CALLS);
+		if (!ret)
+			ftrace_ops_update_code(iter->ops);
 
 		mutex_unlock(&ftrace_lock);
 	}
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 882ec1d..496f94d 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -243,20 +243,25 @@ int filter_current_check_discard(struct
ring_buffer *buffer,
 }
 EXPORT_SYMBOL_GPL(filter_current_check_discard);
 
-cycle_t ftrace_now(int cpu)
+cycle_t buffer_ftrace_now(struct trace_buffer *buf, int cpu)
 {
 	u64 ts;
 
 	/* Early boot up does not have a buffer yet */
-	if (!global_trace.trace_buffer.buffer)
+	if (!buf->buffer)
 		return trace_clock_local();
 
-	ts = ring_buffer_time_stamp(global_trace.trace_buffer.buffer, cpu);
-	ring_buffer_normalize_time_stamp(global_trace.trace_buffer.buffer,
cpu, &ts);
+	ts = ring_buffer_time_stamp(buf->buffer, cpu);
+	ring_buffer_normalize_time_stamp(buf->buffer, cpu, &ts);
 
 	return ts;
 }
 
+cycle_t ftrace_now(int cpu)
+{
+	return buffer_ftrace_now(&global_trace.trace_buffer, cpu);
+}
+
 /**
  * tracing_is_enabled - Show if global_trace has been disabled
  *
@@ -1211,7 +1216,7 @@ void tracing_reset_online_cpus(struct trace_buffer
*buf)
 	/* Make sure all commits have finished */
 	synchronize_sched();
 
-	buf->time_start = ftrace_now(buf->cpu);
+	buf->time_start = buffer_ftrace_now(buf, buf->cpu);
 
 	for_each_online_cpu(cpu)
 		ring_buffer_reset_cpu(buffer, cpu);
@@ -1219,11 +1224,6 @@ void tracing_reset_online_cpus(struct
trace_buffer *buf)
 	ring_buffer_record_enable(buffer);
 }
 
-void tracing_reset_current(int cpu)
-{
-	tracing_reset(&global_trace.trace_buffer, cpu);
-}
-
 /* Must have trace_types_lock held */
 void tracing_reset_all_online_cpus(void)
 {
@@ -4151,6 +4151,7 @@ waitagain:
 	memset(&iter->seq, 0,
 	       sizeof(struct trace_iterator) -
 	       offsetof(struct trace_iterator, seq));
+	cpumask_clear(iter->started);
 	iter->pos = -1;
 
 	trace_event_read_lock();
@@ -4468,7 +4469,7 @@ tracing_free_buffer_release(struct inode *inode,
struct file *filp)
 
 	/* disable tracing ? */
 	if (trace_flags & TRACE_ITER_STOP_ON_FREE)
-		tracing_off();
+		tracer_tracing_off(tr);
 	/* resize the ring buffer to 0 */
 	tracing_resize_ring_buffer(tr, 0, RING_BUFFER_ALL_CPUS);
 
@@ -4633,12 +4634,12 @@ static ssize_t tracing_clock_write(struct file
*filp, const char __user *ubuf,
 	 * New clock may not be consistent with the previous clock.
 	 * Reset the buffer so that it doesn't have incomparable timestamps.
 	 */
-	tracing_reset_online_cpus(&global_trace.trace_buffer);
+	tracing_reset_online_cpus(&tr->trace_buffer);
 
 #ifdef CONFIG_TRACER_MAX_TRACE
 	if (tr->flags & TRACE_ARRAY_FL_GLOBAL && tr->max_buffer.buffer)
 		ring_buffer_set_clock(tr->max_buffer.buffer, trace_clocks[i].func);
-	tracing_reset_online_cpus(&global_trace.max_buffer);
+	tracing_reset_online_cpus(&tr->max_buffer);
 #endif
 
 	mutex_unlock(&trace_types_lock);
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 898f868..29a7ebc 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -409,33 +409,42 @@ static void put_system(struct ftrace_subsystem_dir
*dir)
 	mutex_unlock(&event_mutex);
 }
 
-/*
- * Open and update trace_array ref count.
- * Must have the current trace_array passed to it.
- */
-static int tracing_open_generic_file(struct inode *inode, struct file
*filp)
+static void remove_subsystem(struct ftrace_subsystem_dir *dir)
 {
-	struct ftrace_event_file *file = inode->i_private;
-	struct trace_array *tr = file->tr;
-	int ret;
+	if (!dir)
+		return;
 
-	if (trace_array_get(tr) < 0)
-		return -ENODEV;
+	if (!--dir->nr_events) {
+		debugfs_remove_recursive(dir->entry);
+		list_del(&dir->list);
+		__put_system_dir(dir);
+	}
+}
 
-	ret = tracing_open_generic(inode, filp);
-	if (ret < 0)
-		trace_array_put(tr);
-	return ret;
+static void *event_file_data(struct file *filp)
+{
+	return ACCESS_ONCE(file_inode(filp)->i_private);
 }
 
-static int tracing_release_generic_file(struct inode *inode, struct
file *filp)
+static void remove_event_file_dir(struct ftrace_event_file *file)
 {
-	struct ftrace_event_file *file = inode->i_private;
-	struct trace_array *tr = file->tr;
+	struct dentry *dir = file->dir;
+	struct dentry *child;
 
-	trace_array_put(tr);
+	if (dir) {
+		spin_lock(&dir->d_lock);	/* probably unneeded */
+		list_for_each_entry(child, &dir->d_subdirs, d_u.d_child) {
+			if (child->d_inode)	/* probably unneeded */
+				child->d_inode->i_private = NULL;
+		}
+		spin_unlock(&dir->d_lock);
 
-	return 0;
+		debugfs_remove_recursive(dir);
+	}
+
+	list_del(&file->list);
+	remove_subsystem(file->system);
+	kmem_cache_free(file_cachep, file);
 }
 
 /*
@@ -679,15 +688,25 @@ static ssize_t
 event_enable_read(struct file *filp, char __user *ubuf, size_t cnt,
 		  loff_t *ppos)
 {
-	struct ftrace_event_file *file = filp->private_data;
+	struct ftrace_event_file *file;
+	unsigned long flags;
 	char buf[4] = "0";
 
-	if (file->flags & FTRACE_EVENT_FL_ENABLED &&
-	    !(file->flags & FTRACE_EVENT_FL_SOFT_DISABLED))
+	mutex_lock(&event_mutex);
+	file = event_file_data(filp);
+	if (likely(file))
+		flags = file->flags;
+	mutex_unlock(&event_mutex);
+
+	if (!file)
+		return -ENODEV;
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
@@ -699,13 +718,10 @@ static ssize_t
 event_enable_write(struct file *filp, const char __user *ubuf, size_t
cnt,
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
@@ -717,8 +733,11 @@ event_enable_write(struct file *filp, const char
__user *ubuf, size_t cnt,
 	switch (val) {
 	case 0:
 	case 1:
+		ret = -ENODEV;
 		mutex_lock(&event_mutex);
-		ret = ftrace_event_enable_disable(file, val);
+		file = event_file_data(filp);
+		if (likely(file))
+			ret = ftrace_event_enable_disable(file, val);
 		mutex_unlock(&event_mutex);
 		break;
 
@@ -825,7 +844,7 @@ enum {
 
 static void *f_next(struct seq_file *m, void *v, loff_t *pos)
 {
-	struct ftrace_event_call *call = m->private;
+	struct ftrace_event_call *call = event_file_data(m->private);
 	struct list_head *common_head = &ftrace_common_fields;
 	struct list_head *head = trace_get_fields(call);
 	struct list_head *node = v;
@@ -857,7 +876,7 @@ static void *f_next(struct seq_file *m, void *v,
loff_t *pos)
 
 static int f_show(struct seq_file *m, void *v)
 {
-	struct ftrace_event_call *call = m->private;
+	struct ftrace_event_call *call = event_file_data(m->private);
 	struct ftrace_event_field *field;
 	const char *array_descriptor;
 
@@ -910,6 +929,11 @@ static void *f_start(struct seq_file *m, loff_t
*pos)
 	void *p = (void *)FORMAT_HEADER;
 	loff_t l = 0;
 
+	/* ->stop() is called even if ->start() fails */
+	mutex_lock(&event_mutex);
+	if (!event_file_data(m->private))
+		return ERR_PTR(-ENODEV);
+
 	while (l < *pos && p)
 		p = f_next(m, p, &l);
 
@@ -918,6 +942,7 @@ static void *f_start(struct seq_file *m, loff_t
*pos)
 
 static void f_stop(struct seq_file *m, void *p)
 {
+	mutex_unlock(&event_mutex);
 }
 
 static const struct seq_operations trace_format_seq_ops = {
@@ -929,7 +954,6 @@ static const struct seq_operations
trace_format_seq_ops = {
 
 static int trace_format_open(struct inode *inode, struct file *file)
 {
-	struct ftrace_event_call *call = inode->i_private;
 	struct seq_file *m;
 	int ret;
 
@@ -938,7 +962,7 @@ static int trace_format_open(struct inode *inode,
struct file *file)
 		return ret;
 
 	m = file->private_data;
-	m->private = call;
+	m->private = file;
 
 	return 0;
 }
@@ -946,14 +970,18 @@ static int trace_format_open(struct inode *inode,
struct file *file)
 static ssize_t
 event_id_read(struct file *filp, char __user *ubuf, size_t cnt, loff_t
*ppos)
 {
-	struct ftrace_event_call *call = filp->private_data;
+	int id = (long)event_file_data(filp);
 	char buf[32];
 	int len;
 
 	if (*ppos)
 		return 0;
 
-	len = sprintf(buf, "%d\n", call->event.type);
+	if (unlikely(!id))
+		return -ENODEV;
+
+	len = sprintf(buf, "%d\n", id);
+
 	return simple_read_from_buffer(ubuf, cnt, ppos, buf, len);
 }
 
@@ -961,21 +989,28 @@ static ssize_t
 event_filter_read(struct file *filp, char __user *ubuf, size_t cnt,
 		  loff_t *ppos)
 {
-	struct ftrace_event_call *call = filp->private_data;
+	struct ftrace_event_call *call;
 	struct trace_seq *s;
-	int r;
+	int r = -ENODEV;
 
 	if (*ppos)
 		return 0;
 
 	s = kmalloc(sizeof(*s), GFP_KERNEL);
+
 	if (!s)
 		return -ENOMEM;
 
 	trace_seq_init(s);
 
-	print_event_filter(call, s);
-	r = simple_read_from_buffer(ubuf, cnt, ppos, s->buffer, s->len);
+	mutex_lock(&event_mutex);
+	call = event_file_data(filp);
+	if (call)
+		print_event_filter(call, s);
+	mutex_unlock(&event_mutex);
+
+	if (call)
+		r = simple_read_from_buffer(ubuf, cnt, ppos, s->buffer, s->len);
 
 	kfree(s);
 
@@ -986,9 +1021,9 @@ static ssize_t
 event_filter_write(struct file *filp, const char __user *ubuf, size_t
cnt,
 		   loff_t *ppos)
 {
-	struct ftrace_event_call *call = filp->private_data;
+	struct ftrace_event_call *call;
 	char *buf;
-	int err;
+	int err = -ENODEV;
 
 	if (cnt >= PAGE_SIZE)
 		return -EINVAL;
@@ -1003,7 +1038,12 @@ event_filter_write(struct file *filp, const char
__user *ubuf, size_t cnt,
 	}
 	buf[cnt] = '\0';
 
-	err = apply_event_filter(call, buf);
+	mutex_lock(&event_mutex);
+	call = event_file_data(filp);
+	if (call)
+		err = apply_event_filter(call, buf);
+	mutex_unlock(&event_mutex);
+
 	free_page((unsigned long) buf);
 	if (err < 0)
 		return err;
@@ -1225,10 +1265,9 @@ static const struct file_operations
ftrace_set_event_fops = {
 };
 
 static const struct file_operations ftrace_enable_fops = {
-	.open = tracing_open_generic_file,
+	.open = tracing_open_generic,
 	.read = event_enable_read,
 	.write = event_enable_write,
-	.release = tracing_release_generic_file,
 	.llseek = default_llseek,
 };
 
@@ -1240,7 +1279,6 @@ static const struct file_operations
ftrace_event_format_fops = {
 };
 
 static const struct file_operations ftrace_event_id_fops = {
-	.open = tracing_open_generic,
 	.read = event_id_read,
 	.llseek = default_llseek,
 };
@@ -1488,8 +1526,8 @@ event_create_dir(struct dentry *parent,
 
 #ifdef CONFIG_PERF_EVENTS
 	if (call->event.type && call->class->reg)
-		trace_create_file("id", 0444, file->dir, call,
-		 		  id);
+		trace_create_file("id", 0444, file->dir,
+				  (void *)(long)call->event.type, id);
 #endif
 
 	/*
@@ -1514,33 +1552,16 @@ event_create_dir(struct dentry *parent,
 	return 0;
 }
 
-static void remove_subsystem(struct ftrace_subsystem_dir *dir)
-{
-	if (!dir)
-		return;
-
-	if (!--dir->nr_events) {
-		debugfs_remove_recursive(dir->entry);
-		list_del(&dir->list);
-		__put_system_dir(dir);
-	}
-}
-
 static void remove_event_from_tracers(struct ftrace_event_call *call)
 {
 	struct ftrace_event_file *file;
 	struct trace_array *tr;
 
 	do_for_each_event_file_safe(tr, file) {
-
 		if (file->event_call != call)
 			continue;
 
-		list_del(&file->list);
-		debugfs_remove_recursive(file->dir);
-		remove_subsystem(file->system);
-		kmem_cache_free(file_cachep, file);
-
+		remove_event_file_dir(file);
 		/*
 		 * The do_for_each_event_file_safe() is
 		 * a double loop. After finding the call for this
@@ -1692,16 +1713,53 @@ static void __trace_remove_event_call(struct
ftrace_event_call *call)
 	destroy_preds(call);
 }
 
+static int probe_remove_event_call(struct ftrace_event_call *call)
+{
+	struct trace_array *tr;
+	struct ftrace_event_file *file;
+
+#ifdef CONFIG_PERF_EVENTS
+	if (call->perf_refcount)
+		return -EBUSY;
+#endif
+	do_for_each_event_file(tr, file) {
+		if (file->event_call != call)
+			continue;
+		/*
+		 * We can't rely on ftrace_event_enable_disable(enable => 0)
+		 * we are going to do, FTRACE_EVENT_FL_SOFT_MODE can suppress
+		 * TRACE_REG_UNREGISTER.
+		 */
+		if (file->flags & FTRACE_EVENT_FL_ENABLED)
+			return -EBUSY;
+		/*
+		 * The do_for_each_event_file_safe() is
+		 * a double loop. After finding the call for this
+		 * trace_array, we use break to jump to the next
+		 * trace_array.
+		 */
+		break;
+	} while_for_each_event_file();
+
+	__trace_remove_event_call(call);
+
+	return 0;
+}
+
 /* Remove an event_call */
-void trace_remove_event_call(struct ftrace_event_call *call)
+int trace_remove_event_call(struct ftrace_event_call *call)
 {
+	int ret;
+
 	mutex_lock(&trace_types_lock);
 	mutex_lock(&event_mutex);
 	down_write(&trace_event_sem);
-	__trace_remove_event_call(call);
+	ret = probe_remove_event_call(call);
 	up_write(&trace_event_sem);
 	mutex_unlock(&event_mutex);
 	mutex_unlock(&trace_types_lock);
+
+	return ret;
 }
 
 #define for_each_event(event, start, end)			\
@@ -2270,12 +2328,8 @@ __trace_remove_event_dirs(struct trace_array *tr)
 {
 	struct ftrace_event_file *file, *next;
 
-	list_for_each_entry_safe(file, next, &tr->events, list) {
-		list_del(&file->list);
-		debugfs_remove_recursive(file->dir);
-		remove_subsystem(file->system);
-		kmem_cache_free(file_cachep, file);
-	}
+	list_for_each_entry_safe(file, next, &tr->events, list)
+		remove_event_file_dir(file);
 }
 
 static void
diff --git a/kernel/trace/trace_events_filter.c
b/kernel/trace/trace_events_filter.c
index 0c7b75a..97daa8c 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -637,17 +637,15 @@ static void append_filter_err(struct
filter_parse_state *ps,
 	free_page((unsigned long) buf);
 }
 
+/* caller must hold event_mutex */
 void print_event_filter(struct ftrace_event_call *call, struct
trace_seq *s)
 {
-	struct event_filter *filter;
+	struct event_filter *filter = call->filter;
 
-	mutex_lock(&event_mutex);
-	filter = call->filter;
 	if (filter && filter->filter_string)
 		trace_seq_printf(s, "%s\n", filter->filter_string);
 	else
 		trace_seq_puts(s, "none\n");
-	mutex_unlock(&event_mutex);
 }
 
 void print_subsystem_event_filter(struct event_subsystem *system,
@@ -1841,23 +1839,22 @@ static int create_system_filter(struct
event_subsystem *system,
 	return err;
 }
 
+/* caller must hold event_mutex */
 int apply_event_filter(struct ftrace_event_call *call, char
*filter_string)
 {
 	struct event_filter *filter;
-	int err = 0;
-
-	mutex_lock(&event_mutex);
+	int err;
 
 	if (!strcmp(strstrip(filter_string), "0")) {
 		filter_disable(call);
 		filter = call->filter;
 		if (!filter)
-			goto out_unlock;
+			return 0;
 		RCU_INIT_POINTER(call->filter, NULL);
 		/* Make sure the filter is not being used */
 		synchronize_sched();
 		__free_filter(filter);
-		goto out_unlock;
+		return 0;
 	}
 
 	err = create_filter(call, filter_string, true, &filter);
@@ -1884,8 +1881,6 @@ int apply_event_filter(struct ftrace_event_call
*call, char *filter_string)
 			__free_filter(tmp);
 		}
 	}
-out_unlock:
-	mutex_unlock(&event_mutex);
 
 	return err;
 }
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 3811487..243f683 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -95,7 +95,7 @@ static __kprobes bool trace_probe_is_on_module(struct
trace_probe *tp)
 }
 
 static int register_probe_event(struct trace_probe *tp);
-static void unregister_probe_event(struct trace_probe *tp);
+static int unregister_probe_event(struct trace_probe *tp);
 
 static DEFINE_MUTEX(probe_lock);
 static LIST_HEAD(probe_list);
@@ -351,9 +351,12 @@ static int unregister_trace_probe(struct
trace_probe *tp)
 	if (trace_probe_is_enabled(tp))
 		return -EBUSY;
 
+	/* Will fail if probe is being used by ftrace or perf */
+	if (unregister_probe_event(tp))
+		return -EBUSY;
+
 	__unregister_trace_probe(tp);
 	list_del(&tp->list);
-	unregister_probe_event(tp);
 
 	return 0;
 }
@@ -632,7 +635,9 @@ static int release_all_trace_probes(void)
 	/* TODO: Use batch unregistration */
 	while (!list_empty(&probe_list)) {
 		tp = list_entry(probe_list.next, struct trace_probe, list);
-		unregister_trace_probe(tp);
+		ret = unregister_trace_probe(tp);
+		if (ret)
+			goto end;
 		free_trace_probe(tp);
 	}
 
@@ -1247,11 +1252,15 @@ static int register_probe_event(struct
trace_probe *tp)
 	return ret;
 }
 
-static void unregister_probe_event(struct trace_probe *tp)
+static int unregister_probe_event(struct trace_probe *tp)
 {
+	int ret;
+
 	/* tp->event is unregistered in trace_remove_event_call() */
-	trace_remove_event_call(&tp->call);
-	kfree(tp->call.print_fmt);
+	ret = trace_remove_event_call(&tp->call);
+	if (!ret)
+		kfree(tp->call.print_fmt);
+	return ret;
 }
 
 /* Make a debugfs interface for controlling probe points */
diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index a23d2d7..272261b 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -70,7 +70,7 @@ struct trace_uprobe {
 	(sizeof(struct probe_arg) * (n)))
 
 static int register_uprobe_event(struct trace_uprobe *tu);
-static void unregister_uprobe_event(struct trace_uprobe *tu);
+static int unregister_uprobe_event(struct trace_uprobe *tu);
 
 static DEFINE_MUTEX(uprobe_lock);
 static LIST_HEAD(uprobe_list);
@@ -164,11 +164,17 @@ static struct trace_uprobe *find_probe_event(const
char *event, const char *grou
 }
 
 /* Unregister a trace_uprobe and probe_event: call with locking
uprobe_lock */
-static void unregister_trace_uprobe(struct trace_uprobe *tu)
+static int unregister_trace_uprobe(struct trace_uprobe *tu)
 {
+	int ret;
+
+	ret = unregister_uprobe_event(tu);
+	if (ret)
+		return ret;
+
 	list_del(&tu->list);
-	unregister_uprobe_event(tu);
 	free_trace_uprobe(tu);
+	return 0;
 }
 
 /* Register a trace_uprobe and probe_event */
@@ -181,9 +187,12 @@ static int register_trace_uprobe(struct
trace_uprobe *tu)
 
 	/* register as an event */
 	old_tp = find_probe_event(tu->call.name, tu->call.class->system);
-	if (old_tp)
+	if (old_tp) {
 		/* delete old event */
-		unregister_trace_uprobe(old_tp);
+		ret = unregister_trace_uprobe(old_tp);
+		if (ret)
+			goto end;
+	}
 
 	ret = register_uprobe_event(tu);
 	if (ret) {
@@ -256,6 +265,8 @@ static int create_trace_uprobe(int argc, char
**argv)
 		group = UPROBE_EVENT_SYSTEM;
 
 	if (is_delete) {
+		int ret;
+
 		if (!event) {
 			pr_info("Delete command needs an event name.\n");
 			return -EINVAL;
@@ -269,9 +280,9 @@ static int create_trace_uprobe(int argc, char
**argv)
 			return -ENOENT;
 		}
 		/* delete an event */
-		unregister_trace_uprobe(tu);
+		ret = unregister_trace_uprobe(tu);
 		mutex_unlock(&uprobe_lock);
-		return 0;
+		return ret;
 	}
 
 	if (argc < 2) {
@@ -408,16 +419,20 @@ fail_address_parse:
 	return ret;
 }
 
-static void cleanup_all_probes(void)
+static int cleanup_all_probes(void)
 {
 	struct trace_uprobe *tu;
+	int ret = 0;
 
 	mutex_lock(&uprobe_lock);
 	while (!list_empty(&uprobe_list)) {
 		tu = list_entry(uprobe_list.next, struct trace_uprobe, list);
-		unregister_trace_uprobe(tu);
+		ret = unregister_trace_uprobe(tu);
+		if (ret)
+			break;
 	}
 	mutex_unlock(&uprobe_lock);
+	return ret;
 }
 
 /* Probes listing interfaces */
@@ -462,8 +477,13 @@ static const struct seq_operations probes_seq_op =
{
 
 static int probes_open(struct inode *inode, struct file *file)
 {
-	if ((file->f_mode & FMODE_WRITE) && (file->f_flags & O_TRUNC))
-		cleanup_all_probes();
+	int ret;
+
+	if ((file->f_mode & FMODE_WRITE) && (file->f_flags & O_TRUNC)) {
+		ret = cleanup_all_probes();
+		if (ret)
+			return ret;
+	}
 
 	return seq_open(file, &probes_seq_op);
 }
@@ -968,12 +988,17 @@ static int register_uprobe_event(struct
trace_uprobe *tu)
 	return ret;
 }
 
-static void unregister_uprobe_event(struct trace_uprobe *tu)
+static int unregister_uprobe_event(struct trace_uprobe *tu)
 {
+	int ret;
+
 	/* tu->event is unregistered in trace_remove_event_call() */
-	trace_remove_event_call(&tu->call);
+	ret = trace_remove_event_call(&tu->call);
+	if (ret)
+		return ret;
 	kfree(tu->call.print_fmt);
 	tu->call.print_fmt = NULL;
+	return 0;
 }
 
 /* Make a trace interface for controling probe points */


