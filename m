Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756655Ab3KHEWy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 23:22:54 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:53422 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756379Ab3KHEWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 23:22:36 -0500
X-AuditID: 85900ec0-d3b2cb9000001514-f4-527c670a5ed4
Subject: [PATCH -tip 2/2] ftrace: Introduce nr_saved_cmdlines I/F
To: linux-kernel@vger.kernel.org
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>
Date: Fri, 08 Nov 2013 13:26:57 +0900
Message-ID: <20131108042657.26950.92028.stgit@yunodevel>
In-Reply-To: <20131108042652.26950.32013.stgit@yunodevel>
References: <20131108042652.26950.32013.stgit@yunodevel>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce nr_saved_cmdlines I/F for changing the number of pid-comm list.
saved_cmdlines can store 128 command names using SAVED_CMDLINES now, but
'no-existing processes' names are often lost in saved_cmdlines when we
read trace data. So, by introducing nr_saved_cmdlines I/F, the rule storing
128 command names is changed to the command numbers defined users.

When we write a value to nr_saved_cmdlines, the number of the value will
be stored in pid-comm list:

	# echo 1024 > /sys/kernel/debug/tracing/nr_saved_cmdlines

Here, 1024 command names are stored. The default number is 128 and the maximum
number is PID_MAX_DEFAULT (=32768 if CONFIG_BASE_SMALL is not set). So, if we
want to avoid to lose command names, we need to set 32768 to nr_saved_cmdlines.

We can read the maximum number of the list:

	# cat /sys/kernel/debug/tracing/nr_saved_cmdlines
	128

Signed-off-by: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: linux-kernel@vger.kernel.org
---
 kernel/trace/trace.c |  211 +++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 189 insertions(+), 22 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 90cf668..afdcdfd 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1237,22 +1237,96 @@ void tracing_reset_all_online_cpus(void)
 	}
 }
 
-#define SAVED_CMDLINES 128
+#define SAVED_CMDLINES_DEFAULT 128
 #define NO_CMDLINE_MAP UINT_MAX
-static unsigned map_pid_to_cmdline[PID_MAX_DEFAULT+1];
-static unsigned map_cmdline_to_pid[SAVED_CMDLINES];
-static char saved_cmdlines[SAVED_CMDLINES][TASK_COMM_LEN];
-static int cmdline_idx;
 static arch_spinlock_t trace_cmdline_lock = __ARCH_SPIN_LOCK_UNLOCKED;
+struct saved_cmdlines_buffer {
+	unsigned map_pid_to_cmdline[PID_MAX_DEFAULT+1];
+	unsigned *map_cmdline_to_pid;
+	unsigned cmdline_num;
+	int cmdline_idx;
+	char *saved_cmdlines;
+};
+static struct saved_cmdlines_buffer *savedcmd;
 
 /* temporary disable recording */
 static atomic_t trace_record_cmdline_disabled __read_mostly;
 
-static void trace_init_cmdlines(void)
+static inline char *get_cmdline(int idx)
+{
+	return &savedcmd->saved_cmdlines[idx*TASK_COMM_LEN];
+}
+
+static inline void set_cmdline(int idx, char *cmdline)
+{
+	memcpy(get_cmdline(idx), cmdline, TASK_COMM_LEN);
+}
+
+static int allocate_cmdlines_buffer(unsigned int val,
+				    struct saved_cmdlines_buffer *s)
 {
-	memset(&map_pid_to_cmdline, NO_CMDLINE_MAP, sizeof(map_pid_to_cmdline));
-	memset(&map_cmdline_to_pid, NO_CMDLINE_MAP, sizeof(map_cmdline_to_pid));
-	cmdline_idx = 0;
+	s->map_cmdline_to_pid = kmalloc(val*sizeof(unsigned), GFP_KERNEL);
+	if (!s->map_cmdline_to_pid)
+		goto out;
+
+	s->saved_cmdlines = kmalloc(val*TASK_COMM_LEN, GFP_KERNEL);
+	if (!s->saved_cmdlines)
+		goto out_free_map_cmdline_to_pid;
+
+	return 0;
+
+out_free_map_cmdline_to_pid:
+	kfree(s->map_cmdline_to_pid);
+out:
+	return -ENOMEM;
+}
+
+static void trace_init_cmdlines_buffer(unsigned int val,
+				       struct saved_cmdlines_buffer *s)
+{
+	s->cmdline_idx = 0;
+	s->cmdline_num = val;
+	memset(&s->map_pid_to_cmdline, NO_CMDLINE_MAP,
+	       sizeof(s->map_pid_to_cmdline));
+	memset(s->map_cmdline_to_pid, NO_CMDLINE_MAP, val*sizeof(unsigned));
+}
+
+static int trace_create_savedcmd(void)
+{
+	int ret;
+
+	savedcmd = kmalloc(sizeof(struct saved_cmdlines_buffer), GFP_KERNEL);
+	if (!savedcmd)
+		goto out;
+
+	ret = allocate_cmdlines_buffer(SAVED_CMDLINES_DEFAULT, savedcmd);
+	if (ret < 0)
+		goto out_free;
+
+	return 0;
+
+out_free:
+	kfree(savedcmd);
+out:
+	return -ENOMEM;
+}
+
+static void trace_init_savedcmd(void)
+{
+	trace_init_cmdlines_buffer(SAVED_CMDLINES_DEFAULT, savedcmd);
+}
+
+static int trace_create_and_init_savedcmd(void)
+{
+	int ret;
+
+	ret = trace_create_savedcmd();
+	if (ret < 0)
+		return ret;
+
+	trace_init_savedcmd();
+
+	return 0;
 }
 
 int is_tracing_stopped(void)
@@ -1424,9 +1498,9 @@ static void trace_save_cmdline(struct task_struct *tsk)
 	if (!arch_spin_trylock(&trace_cmdline_lock))
 		return;
 
-	idx = map_pid_to_cmdline[tsk->pid];
+	idx = savedcmd->map_pid_to_cmdline[tsk->pid];
 	if (idx == NO_CMDLINE_MAP) {
-		idx = (cmdline_idx + 1) % SAVED_CMDLINES;
+		idx = (savedcmd->cmdline_idx + 1) % savedcmd->cmdline_num;
 
 		/*
 		 * Check whether the cmdline buffer at idx has a pid
@@ -1434,17 +1508,17 @@ static void trace_save_cmdline(struct task_struct *tsk)
 		 * need to clear the map_pid_to_cmdline. Otherwise we
 		 * would read the new comm for the old pid.
 		 */
-		pid = map_cmdline_to_pid[idx];
+		pid = savedcmd->map_cmdline_to_pid[idx];
 		if (pid != NO_CMDLINE_MAP)
-			map_pid_to_cmdline[pid] = NO_CMDLINE_MAP;
+			savedcmd->map_pid_to_cmdline[pid] = NO_CMDLINE_MAP;
 
-		map_cmdline_to_pid[idx] = tsk->pid;
-		map_pid_to_cmdline[tsk->pid] = idx;
+		savedcmd->map_cmdline_to_pid[idx] = tsk->pid;
+		savedcmd->map_pid_to_cmdline[tsk->pid] = idx;
 
-		cmdline_idx = idx;
+		savedcmd->cmdline_idx = idx;
 	}
 
-	memcpy(&saved_cmdlines[idx], tsk->comm, TASK_COMM_LEN);
+	set_cmdline(idx, tsk->comm);
 
 	arch_spin_unlock(&trace_cmdline_lock);
 }
@@ -1470,9 +1544,9 @@ void trace_find_cmdline(int pid, char comm[])
 
 	preempt_disable();
 	arch_spin_lock(&trace_cmdline_lock);
-	map = map_pid_to_cmdline[pid];
+	map = savedcmd->map_pid_to_cmdline[pid];
 	if (map != NO_CMDLINE_MAP)
-		strcpy(comm, saved_cmdlines[map]);
+		strcpy(comm, get_cmdline(map));
 	else
 		strcpy(comm, "<...>");
 
@@ -3475,6 +3549,7 @@ static const char readme_msg[] =
 	"\t\t\t  Remove sub-buffer with rmdir\n"
 	"  trace_options\t\t- Set format or modify how tracing happens\n"
 	"\t\t\t  Disable an option by adding a suffix 'no' to the option name\n"
+	"  nr_saved_cmdlines\t- echo command number in here to store comm-pid list\n"
 #ifdef CONFIG_DYNAMIC_FTRACE
 	"\n  available_filter_functions - list of functions that can be filtered on\n"
 	"  set_ftrace_filter\t- echo function name in here to only trace these functions\n"
@@ -3553,7 +3628,8 @@ static void *saved_cmdlines_next(struct seq_file *m, void *v, loff_t *pos)
 
 	(*pos)++;
 
-	for (; ptr < &map_cmdline_to_pid[SAVED_CMDLINES]; ptr++) {
+	for (; ptr < &savedcmd->map_cmdline_to_pid[savedcmd->cmdline_num];
+	     ptr++) {
 		if (*ptr == -1 || *ptr == NO_CMDLINE_MAP)
 			continue;
 
@@ -3568,7 +3644,7 @@ static void *saved_cmdlines_start(struct seq_file *m, loff_t *pos)
 	void *v;
 	loff_t l = 0;
 
-	v = &map_cmdline_to_pid[0];
+	v = &savedcmd->map_cmdline_to_pid[0];
 	while (l <= *pos) {
 		v = saved_cmdlines_next(m, v, &l);
 		if (!v)
@@ -3615,6 +3691,88 @@ static const struct file_operations tracing_saved_cmdlines_fops = {
 };
 
 static ssize_t
+tracing_nr_saved_cmdlines_read(struct file *filp, char __user *ubuf,
+			       size_t cnt, loff_t *ppos)
+{
+	char buf[64];
+	int r;
+
+	arch_spin_lock(&trace_cmdline_lock);
+	r = sprintf(buf, "%u\n", savedcmd->cmdline_num);
+	arch_spin_unlock(&trace_cmdline_lock);
+
+	return simple_read_from_buffer(ubuf, cnt, ppos, buf, r);
+}
+
+static void free_saved_cmdlines_buffer(struct saved_cmdlines_buffer *s)
+{
+	kfree(s->saved_cmdlines);
+	kfree(s->map_cmdline_to_pid);
+	kfree(s);
+}
+
+static int tracing_resize_saved_cmdlines(unsigned int val)
+{
+	struct saved_cmdlines_buffer *s, *savedcmd_temp;
+	int ret;
+
+	s = kmalloc(sizeof(struct saved_cmdlines_buffer), GFP_KERNEL);
+	if (!s)
+		goto out;
+
+	ret = allocate_cmdlines_buffer(val, s);
+	if (ret < 0)
+		goto out_free;
+
+	trace_init_cmdlines_buffer(val, s);
+
+	savedcmd_temp = savedcmd;
+
+	arch_spin_lock(&trace_cmdline_lock);
+	savedcmd = s;
+	arch_spin_unlock(&trace_cmdline_lock);
+
+	free_saved_cmdlines_buffer(savedcmd_temp);
+
+	return 0;
+
+out_free:
+	kfree(s);
+out:
+	return -ENOMEM;
+}
+
+static ssize_t
+tracing_nr_saved_cmdlines_write(struct file *filp, const char __user *ubuf,
+				size_t cnt, loff_t *ppos)
+{
+	unsigned long val;
+	int ret;
+
+	ret = kstrtoul_from_user(ubuf, cnt, 10, &val);
+	if (ret)
+		return ret;
+
+	/* must have at least 1 entry or less than PID_MAX_DEFAULT */
+	if (!val || val > PID_MAX_DEFAULT)
+		return -EINVAL;
+
+	ret = tracing_resize_saved_cmdlines((unsigned int)val);
+	if (ret < 0)
+		return ret;
+
+	*ppos += cnt;
+
+	return cnt;
+}
+
+static const struct file_operations tracing_nr_saved_cmdlines_fops = {
+	.open		= tracing_open_generic,
+	.read		= tracing_nr_saved_cmdlines_read,
+	.write		= tracing_nr_saved_cmdlines_write,
+};
+
+static ssize_t
 tracing_set_trace_read(struct file *filp, char __user *ubuf,
 		       size_t cnt, loff_t *ppos)
 {
@@ -6192,6 +6350,9 @@ static __init int tracer_init_debugfs(void)
 	trace_create_file("saved_cmdlines", 0444, d_tracer,
 			NULL, &tracing_saved_cmdlines_fops);
 
+	trace_create_file("nr_saved_cmdlines", 0644, d_tracer,
+			  NULL, &tracing_nr_saved_cmdlines_fops);
+
 #ifdef CONFIG_DYNAMIC_FTRACE
 	trace_create_file("dyn_ftrace_total_info", 0444, d_tracer,
 			&ftrace_update_tot_cnt, &tracing_dyn_info_fops);
@@ -6422,7 +6583,8 @@ __init static int tracer_alloc_buffers(void)
 	if (global_trace.buffer_disabled)
 		tracing_off();
 
-	trace_init_cmdlines();
+	if (trace_create_and_init_savedcmd() < 0)
+		goto out_free_trace_buffers;
 
 	/*
 	 * register_tracer() might reference current_trace, so it
@@ -6458,6 +6620,11 @@ __init static int tracer_alloc_buffers(void)
 
 	return 0;
 
+out_free_trace_buffers:
+	ring_buffer_free(global_trace.trace_buffer.buffer);
+#ifdef CONFIG_TRACER_MAX_TRACE
+	ring_buffer_free(global_trace.max_buffer.buffer);
+#endif
 out_free_cpumask:
 	free_percpu(global_trace.trace_buffer.data);
 #ifdef CONFIG_TRACER_MAX_TRACE

