Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752976Ab3EIFtW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 01:49:22 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:35238 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751840Ab3EIFq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 01:46:58 -0400
X-AuditID: 85900ec0-d24c6b900000151e-8b-518b384f67a4
Subject: [PATCH 02/11] [BUGFIX] ftrace,
 kprobes: Fix a deadlock on ftrace_regex_lock
To: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        yrl.pp-manager.tt@hitachi.com, Oleg Nesterov <oleg@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Tom Zanussi <tom.zanussi@intel.com>
Date: Thu, 09 May 2013 14:44:17 +0900
Message-ID: <20130509054417.30398.84254.stgit@mhiramat-M0-7522>
In-Reply-To: <20130509054405.30398.73831.stgit@mhiramat-M0-7522>
References: <20130509054405.30398.73831.stgit@mhiramat-M0-7522>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a deadlock on ftrace_regex_lock which happens when setting
an enable_event trigger on dynamic kprobe event as below.

----
sh-2.05b# echo p vfs_symlink > kprobe_events
sh-2.05b# echo vfs_symlink:enable_event:kprobes:p_vfs_symlink_0 > set_ftrace_filter

=============================================
[ INFO: possible recursive locking detected ]
3.9.0+ #35 Not tainted
---------------------------------------------
sh/72 is trying to acquire lock:
 (ftrace_regex_lock){+.+.+.}, at: [<ffffffff810ba6c1>] ftrace_set_hash+0x81/0x1f0

but task is already holding lock:
 (ftrace_regex_lock){+.+.+.}, at: [<ffffffff810b7cbd>] ftrace_regex_write.isra.29.part.30+0x3d/0x220

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(ftrace_regex_lock);
  lock(ftrace_regex_lock);

 *** DEADLOCK ***
----

To fix that, this introduces a finer regex_lock for each ftrace_ops.
ftrace_regex_lock seems that a big lock which protect all
filter/notrace_hash operation, but it doesn't need to be a global
lock after supporting multiple ftrace_ops because each ftrace_ops
has its own filter/notrace_hash.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Tom Zanussi <tom.zanussi@intel.com>
---
 include/linux/ftrace.h |    1 +
 kernel/kprobes.c       |    1 +
 kernel/trace/ftrace.c  |   43 +++++++++++++++++++++++++++----------------
 3 files changed, 29 insertions(+), 16 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index f83e17a..4ba3a6e 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -110,6 +110,7 @@ struct ftrace_ops {
 #ifdef CONFIG_DYNAMIC_FTRACE
 	struct ftrace_hash		*notrace_hash;
 	struct ftrace_hash		*filter_hash;
+	struct mutex			regex_lock;
 #endif
 };
 
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 3fed7f0..7f307e8 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -934,6 +934,7 @@ static __kprobes struct kprobe *alloc_aggr_kprobe(struct kprobe *p)
 static struct ftrace_ops kprobe_ftrace_ops __read_mostly = {
 	.func = kprobe_ftrace_handler,
 	.flags = FTRACE_OPS_FL_SAVE_REGS,
+	.regex_lock = __MUTEX_INITIALIZER(kprobe_ftrace_ops.regex_lock),
 };
 static int kprobe_ftrace_enabled;
 
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 8a5c017..3f29b3d 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -64,9 +64,17 @@
 
 #define FL_GLOBAL_CONTROL_MASK (FTRACE_OPS_FL_GLOBAL | FTRACE_OPS_FL_CONTROL)
 
+#ifdef CONFIG_DYNAMIC_FTRACE
+#define INIT_REGEX_LOCK(opsname)	\
+	.regex_lock	= __MUTEX_INITIALIZER(opsname.regex_lock),
+#else
+#define INIT_REGEX_LOCK(opsname)
+#endif
+
 static struct ftrace_ops ftrace_list_end __read_mostly = {
 	.func		= ftrace_stub,
 	.flags		= FTRACE_OPS_FL_RECURSION_SAFE | FTRACE_OPS_FL_STUB,
+	INIT_REGEX_LOCK(ftrace_list_end)
 };
 
 /* ftrace_enabled is a method to turn ftrace on or off */
@@ -908,6 +916,7 @@ static void unregister_ftrace_profiler(void)
 static struct ftrace_ops ftrace_profile_ops __read_mostly = {
 	.func		= function_profile_call,
 	.flags		= FTRACE_OPS_FL_RECURSION_SAFE,
+	INIT_REGEX_LOCK(ftrace_profile_ops)
 };
 
 static int register_ftrace_profiler(void)
@@ -1104,10 +1113,9 @@ static struct ftrace_ops global_ops = {
 	.notrace_hash		= EMPTY_HASH,
 	.filter_hash		= EMPTY_HASH,
 	.flags			= FTRACE_OPS_FL_RECURSION_SAFE,
+	INIT_REGEX_LOCK(global_ops)
 };
 
-static DEFINE_MUTEX(ftrace_regex_lock);
-
 struct ftrace_page {
 	struct ftrace_page	*next;
 	struct dyn_ftrace	*records;
@@ -2656,7 +2664,7 @@ ftrace_regex_open(struct ftrace_ops *ops, int flag,
 		}
 	}
 
-	mutex_lock(&ftrace_regex_lock);
+	mutex_lock(&ops->regex_lock);
 
 	if ((file->f_mode & FMODE_WRITE) &&
 	    (file->f_flags & O_TRUNC))
@@ -2677,7 +2685,7 @@ ftrace_regex_open(struct ftrace_ops *ops, int flag,
 		}
 	} else
 		file->private_data = iter;
-	mutex_unlock(&ftrace_regex_lock);
+	mutex_unlock(&ops->regex_lock);
 
 	return ret;
 }
@@ -2910,6 +2918,7 @@ static void function_trace_probe_call(unsigned long ip, unsigned long parent_ip,
 static struct ftrace_ops trace_probe_ops __read_mostly =
 {
 	.func		= function_trace_probe_call,
+	INIT_REGEX_LOCK(trace_probe_ops)
 };
 
 static int ftrace_probe_registered;
@@ -3256,18 +3265,18 @@ ftrace_regex_write(struct file *file, const char __user *ubuf,
 	if (!cnt)
 		return 0;
 
-	mutex_lock(&ftrace_regex_lock);
-
-	ret = -ENODEV;
-	if (unlikely(ftrace_disabled))
-		goto out_unlock;
-
 	if (file->f_mode & FMODE_READ) {
 		struct seq_file *m = file->private_data;
 		iter = m->private;
 	} else
 		iter = file->private_data;
 
+	mutex_lock(&iter->ops->regex_lock);
+
+	ret = -ENODEV;
+	if (unlikely(ftrace_disabled))
+		goto out_unlock;
+
 	parser = &iter->parser;
 	read = trace_get_user(parser, ubuf, cnt, ppos);
 
@@ -3282,7 +3291,7 @@ ftrace_regex_write(struct file *file, const char __user *ubuf,
 
 	ret = read;
 out_unlock:
-	mutex_unlock(&ftrace_regex_lock);
+	mutex_unlock(&iter->ops->regex_lock);
 
 	return ret;
 }
@@ -3344,7 +3353,7 @@ ftrace_set_hash(struct ftrace_ops *ops, unsigned char *buf, int len,
 	if (!hash)
 		return -ENOMEM;
 
-	mutex_lock(&ftrace_regex_lock);
+	mutex_lock(&ops->regex_lock);
 	if (reset)
 		ftrace_filter_reset(hash);
 	if (buf && !ftrace_match_records(hash, buf, len)) {
@@ -3366,7 +3375,7 @@ ftrace_set_hash(struct ftrace_ops *ops, unsigned char *buf, int len,
 	mutex_unlock(&ftrace_lock);
 
  out_regex_unlock:
-	mutex_unlock(&ftrace_regex_lock);
+	mutex_unlock(&ops->regex_lock);
 
 	free_ftrace_hash(hash);
 	return ret;
@@ -3551,14 +3560,14 @@ int ftrace_regex_release(struct inode *inode, struct file *file)
 	int filter_hash;
 	int ret;
 
-	mutex_lock(&ftrace_regex_lock);
 	if (file->f_mode & FMODE_READ) {
 		iter = m->private;
-
 		seq_release(inode, file);
 	} else
 		iter = file->private_data;
 
+	mutex_lock(&iter->ops->regex_lock);
+
 	parser = &iter->parser;
 	if (trace_parser_loaded(parser)) {
 		parser->buffer[parser->idx] = 0;
@@ -3587,7 +3596,7 @@ int ftrace_regex_release(struct inode *inode, struct file *file)
 	free_ftrace_hash(iter->hash);
 	kfree(iter);
 
-	mutex_unlock(&ftrace_regex_lock);
+	mutex_unlock(&iter->ops->regex_lock);
 	return 0;
 }
 
@@ -4127,6 +4136,7 @@ void __init ftrace_init(void)
 static struct ftrace_ops global_ops = {
 	.func			= ftrace_stub,
 	.flags			= FTRACE_OPS_FL_RECURSION_SAFE,
+	INIT_REGEX_LOCK(global_ops)
 };
 
 static int __init ftrace_nodyn_init(void)
@@ -4182,6 +4192,7 @@ ftrace_ops_control_func(unsigned long ip, unsigned long parent_ip,
 static struct ftrace_ops control_ops = {
 	.func = ftrace_ops_control_func,
 	.flags = FTRACE_OPS_FL_RECURSION_SAFE,
+	INIT_REGEX_LOCK(control_ops)
 };
 
 static inline void

