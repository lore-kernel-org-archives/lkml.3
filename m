Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866AbaFFRXc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 13:23:32 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:54278 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752654AbaFFRVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 13:21:06 -0400
Message-Id: <20140606172104.215575267@goodmis.org>
User-Agent: quilt/0.63-1
Date: Fri, 06 Jun 2014 12:30:35 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Subject: [for-next][PATCH 1/6] tracing: Introduce saved_cmdlines_size file
References: <20140606163034.516780857@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0000-tracing-Introduce-saved_cmdlines_size-file.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>

Introduce saved_cmdlines_size file for changing the number of saved pid-comms.
saved_cmdlines currently stores 128 command names using SAVED_CMDLINES, but
'no-existing processes' names are often lost in saved_cmdlines when we
read the trace data. So, by introducing saved_cmdlines_size file, we can
now change the 128 command names saved to something much larger if needed.

When we write a value to saved_cmdlines_size, the number of the value will
be stored in pid-comm list:

	# echo 1024 > /sys/kernel/debug/tracing/saved_cmdlines_size

Here, 1024 command names can be stored. The default number is 128 and the maximum
number is PID_MAX_DEFAULT (=32768 if CONFIG_BASE_SMALL is not set). So, if we
want to avoid losing any command names, we need to set 32768 to
saved_cmdlines_size.

We can read the maximum number of the list:

	# cat /sys/kernel/debug/tracing/saved_cmdlines_size
	128

Link: http://lkml.kernel.org/p/20140605012427.22115.16173.stgit@yunodevel

Signed-off-by: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c | 178 ++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 154 insertions(+), 24 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 135af323608b..e29edee1542a 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1285,22 +1285,71 @@ void tracing_reset_all_online_cpus(void)
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
+static inline char *get_saved_cmdlines(int idx)
+{
+	return &savedcmd->saved_cmdlines[idx * TASK_COMM_LEN];
+}
+
+static inline void set_cmdline(int idx, const char *cmdline)
 {
-	memset(&map_pid_to_cmdline, NO_CMDLINE_MAP, sizeof(map_pid_to_cmdline));
-	memset(&map_cmdline_to_pid, NO_CMDLINE_MAP, sizeof(map_cmdline_to_pid));
-	cmdline_idx = 0;
+	memcpy(get_saved_cmdlines(idx), cmdline, TASK_COMM_LEN);
+}
+
+static int allocate_cmdlines_buffer(unsigned int val,
+				    struct saved_cmdlines_buffer *s)
+{
+	s->map_cmdline_to_pid = kmalloc(val * sizeof(*s->map_cmdline_to_pid),
+					GFP_KERNEL);
+	if (!s->map_cmdline_to_pid)
+		return -ENOMEM;
+
+	s->saved_cmdlines = kmalloc(val * TASK_COMM_LEN, GFP_KERNEL);
+	if (!s->saved_cmdlines) {
+		kfree(s->map_cmdline_to_pid);
+		return -ENOMEM;
+	}
+
+	s->cmdline_idx = 0;
+	s->cmdline_num = val;
+	memset(&s->map_pid_to_cmdline, NO_CMDLINE_MAP,
+	       sizeof(s->map_pid_to_cmdline));
+	memset(s->map_cmdline_to_pid, NO_CMDLINE_MAP,
+	       val * sizeof(*s->map_cmdline_to_pid));
+
+	return 0;
+}
+
+static int trace_create_savedcmd(void)
+{
+	int ret;
+
+	savedcmd = kmalloc(sizeof(struct saved_cmdlines_buffer), GFP_KERNEL);
+	if (!savedcmd)
+		return -ENOMEM;
+
+	ret = allocate_cmdlines_buffer(SAVED_CMDLINES_DEFAULT, savedcmd);
+	if (ret < 0) {
+		kfree(savedcmd);
+		savedcmd = NULL;
+		return -ENOMEM;
+	}
+
+	return 0;
 }
 
 int is_tracing_stopped(void)
@@ -1457,9 +1506,9 @@ static int trace_save_cmdline(struct task_struct *tsk)
 	if (!arch_spin_trylock(&trace_cmdline_lock))
 		return 0;
 
-	idx = map_pid_to_cmdline[tsk->pid];
+	idx = savedcmd->map_pid_to_cmdline[tsk->pid];
 	if (idx == NO_CMDLINE_MAP) {
-		idx = (cmdline_idx + 1) % SAVED_CMDLINES;
+		idx = (savedcmd->cmdline_idx + 1) % savedcmd->cmdline_num;
 
 		/*
 		 * Check whether the cmdline buffer at idx has a pid
@@ -1467,17 +1516,17 @@ static int trace_save_cmdline(struct task_struct *tsk)
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
 
@@ -1503,9 +1552,9 @@ static void __trace_find_cmdline(int pid, char comm[])
 		return;
 	}
 
-	map = map_pid_to_cmdline[pid];
+	map = savedcmd->map_pid_to_cmdline[pid];
 	if (map != NO_CMDLINE_MAP)
-		strcpy(comm, saved_cmdlines[map]);
+		strcpy(comm, get_saved_cmdlines(map));
 	else
 		strcpy(comm, "<...>");
 }
@@ -3593,6 +3642,7 @@ static const char readme_msg[] =
 	"  trace_options\t\t- Set format or modify how tracing happens\n"
 	"\t\t\t  Disable an option by adding a suffix 'no' to the\n"
 	"\t\t\t  option name\n"
+	"  saved_cmdlines_size\t- echo command number in here to store comm-pid list\n"
 #ifdef CONFIG_DYNAMIC_FTRACE
 	"\n  available_filter_functions - list of functions that can be filtered on\n"
 	"  set_ftrace_filter\t- echo function name in here to only trace these\n"
@@ -3715,7 +3765,8 @@ static void *saved_cmdlines_next(struct seq_file *m, void *v, loff_t *pos)
 
 	(*pos)++;
 
-	for (; ptr < &map_cmdline_to_pid[SAVED_CMDLINES]; ptr++) {
+	for (; ptr < &savedcmd->map_cmdline_to_pid[savedcmd->cmdline_num];
+	     ptr++) {
 		if (*ptr == -1 || *ptr == NO_CMDLINE_MAP)
 			continue;
 
@@ -3733,7 +3784,7 @@ static void *saved_cmdlines_start(struct seq_file *m, loff_t *pos)
 	preempt_disable();
 	arch_spin_lock(&trace_cmdline_lock);
 
-	v = &map_cmdline_to_pid[0];
+	v = &savedcmd->map_cmdline_to_pid[0];
 	while (l <= *pos) {
 		v = saved_cmdlines_next(m, v, &l);
 		if (!v)
@@ -3782,6 +3833,79 @@ static const struct file_operations tracing_saved_cmdlines_fops = {
 };
 
 static ssize_t
+tracing_saved_cmdlines_size_read(struct file *filp, char __user *ubuf,
+				 size_t cnt, loff_t *ppos)
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
+
+	s = kmalloc(sizeof(struct saved_cmdlines_buffer), GFP_KERNEL);
+	if (!s)
+		return -ENOMEM;
+
+	if (allocate_cmdlines_buffer(val, s) < 0) {
+		kfree(s);
+		return -ENOMEM;
+	}
+
+	arch_spin_lock(&trace_cmdline_lock);
+	savedcmd_temp = savedcmd;
+	savedcmd = s;
+	arch_spin_unlock(&trace_cmdline_lock);
+	free_saved_cmdlines_buffer(savedcmd_temp);
+
+	return 0;
+}
+
+static ssize_t
+tracing_saved_cmdlines_size_write(struct file *filp, const char __user *ubuf,
+				  size_t cnt, loff_t *ppos)
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
+static const struct file_operations tracing_saved_cmdlines_size_fops = {
+	.open		= tracing_open_generic,
+	.read		= tracing_saved_cmdlines_size_read,
+	.write		= tracing_saved_cmdlines_size_write,
+};
+
+static ssize_t
 tracing_set_trace_read(struct file *filp, char __user *ubuf,
 		       size_t cnt, loff_t *ppos)
 {
@@ -6375,6 +6499,9 @@ static __init int tracer_init_debugfs(void)
 	trace_create_file("saved_cmdlines", 0444, d_tracer,
 			NULL, &tracing_saved_cmdlines_fops);
 
+	trace_create_file("saved_cmdlines_size", 0644, d_tracer,
+			  NULL, &tracing_saved_cmdlines_size_fops);
+
 #ifdef CONFIG_DYNAMIC_FTRACE
 	trace_create_file("dyn_ftrace_total_info", 0444, d_tracer,
 			&ftrace_update_tot_cnt, &tracing_dyn_info_fops);
@@ -6611,18 +6738,19 @@ __init static int tracer_alloc_buffers(void)
 	if (!temp_buffer)
 		goto out_free_cpumask;
 
+	if (trace_create_savedcmd() < 0)
+		goto out_free_temp_buffer;
+
 	/* TODO: make the number of buffers hot pluggable with CPUS */
 	if (allocate_trace_buffers(&global_trace, ring_buf_size) < 0) {
 		printk(KERN_ERR "tracer: failed to allocate ring buffer!\n");
 		WARN_ON(1);
-		goto out_free_temp_buffer;
+		goto out_free_savedcmd;
 	}
 
 	if (global_trace.buffer_disabled)
 		tracing_off();
 
-	trace_init_cmdlines();
-
 	if (trace_boot_clock) {
 		ret = tracing_set_clock(&global_trace, trace_boot_clock);
 		if (ret < 0)
@@ -6668,6 +6796,8 @@ __init static int tracer_alloc_buffers(void)
 
 	return 0;
 
+out_free_savedcmd:
+	free_saved_cmdlines_buffer(savedcmd);
 out_free_temp_buffer:
 	ring_buffer_free(temp_buffer);
 out_free_cpumask:
-- 
2.0.0.rc2


