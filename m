Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753065Ab3EJNiF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 09:38:05 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:29956 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271Ab3EJNiC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 09:38:02 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=DN1rENdJRV0A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=CpQRuSp1N3wA:10 a=3nbZYyFuAAAA:8 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=20KFwNOVAAAA:8 a=pGLkceISAAAA:8 a=QyXUC8HyAAAA:8 a=qEtdMUstmey77ZuDG70A:9 a=QEXdDO2ut3YA:10 a=EvKJbDF4Ut8A:10 a=jEp0ucaQiEUA:10 a=MSl-tDqOz04A:10 a=dGJ0OcVc7YAA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1368193081.7373.155.camel@gandalf.local.home>
Subject: Re: [PATCH 02/11] [BUGFIX] ftrace, kprobes: Fix a deadlock on
 ftrace_regex_lock
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        yrl.pp-manager.tt@hitachi.com, Oleg Nesterov <oleg@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Tom Zanussi <tom.zanussi@intel.com>
Date: Fri, 10 May 2013 09:38:01 -0400
In-Reply-To: <518C4FFD.1090404@hitachi.com>
References: <20130509054405.30398.73831.stgit@mhiramat-M0-7522>
	  <20130509054417.30398.84254.stgit@mhiramat-M0-7522>
	  <1368116860.7373.118.camel@gandalf.local.home>
	  <1368117277.7373.119.camel@gandalf.local.home>
	 <1368119312.7373.123.camel@gandalf.local.home>
	 <518C4FFD.1090404@hitachi.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-05-10 at 10:40 +0900, Masami Hiramatsu wrote:

> Hmm, would we really need to have the additional flag?
> I mean, do we better force ftrace user to use ftrace_ops_init before
> calling such functions as mutex itself does?

It will be hard to get right, and I don't like the macro to initialize
it all over the place. Having the check before its used contained just
in ftrace.c seems to work. None of the functions are hot paths so it's
not like its slowing anything down.

Here's what I did:

>From f04f24fb7e48d446bd89a01c6056571f25972511 Mon Sep 17 00:00:00 2001
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Date: Thu, 9 May 2013 14:44:17 +0900
Subject: [PATCH] ftrace, kprobes: Fix a deadlock on ftrace_regex_lock

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
ftrace_regex_lock is too big of a lock which protects all
filter/notrace_hash operations, but it doesn't need to be a global
lock after supporting multiple ftrace_ops because each ftrace_ops
has its own filter/notrace_hash.

Link: http://lkml.kernel.org/r/20130509054417.30398.84254.stgit@mhiramat-M0-7522

Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Tom Zanussi <tom.zanussi@intel.com>
Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
[ Added initialization flag and automate mutex initialization for
  non ftrace.c ftrace_probes. ]
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace.h |    4 ++
 kernel/trace/ftrace.c  |   73 ++++++++++++++++++++++++++++++++++--------------
 2 files changed, 56 insertions(+), 21 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index f83e17a..99d0fbc 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -90,6 +90,8 @@ typedef void (*ftrace_func_t)(unsigned long ip, unsigned long parent_ip,
  *            not set this, then the ftrace infrastructure will add recursion
  *            protection for the caller.
  * STUB   - The ftrace_ops is just a place holder.
+ * INITIALIZED - The ftrace_ops has already been initialized (first use time
+ *            register_ftrace_function() is called, it will initialized the ops)
  */
 enum {
 	FTRACE_OPS_FL_ENABLED			= 1 << 0,
@@ -100,6 +102,7 @@ enum {
 	FTRACE_OPS_FL_SAVE_REGS_IF_SUPPORTED	= 1 << 5,
 	FTRACE_OPS_FL_RECURSION_SAFE		= 1 << 6,
 	FTRACE_OPS_FL_STUB			= 1 << 7,
+	FTRACE_OPS_FL_INITIALIZED		= 1 << 8,
 };
 
 struct ftrace_ops {
@@ -110,6 +113,7 @@ struct ftrace_ops {
 #ifdef CONFIG_DYNAMIC_FTRACE
 	struct ftrace_hash		*notrace_hash;
 	struct ftrace_hash		*filter_hash;
+	struct mutex			regex_lock;
 #endif
 };
 
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index d85a0ad..827f2fe 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -64,6 +64,13 @@
 
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
@@ -131,6 +138,16 @@ static void ftrace_ops_no_ops(unsigned long ip, unsigned long parent_ip);
 	while (likely(op = rcu_dereference_raw((op)->next)) &&	\
 	       unlikely((op) != &ftrace_list_end))
 
+static inline void ftrace_ops_init(struct ftrace_ops *ops)
+{
+#ifdef CONFIG_DYNAMIC_FTRACE
+	if (!(ops->flags & FTRACE_OPS_FL_INITIALIZED)) {
+		mutex_init(&ops->regex_lock);
+		ops->flags |= FTRACE_OPS_FL_INITIALIZED;
+	}
+#endif
+}
+
 /**
  * ftrace_nr_registered_ops - return number of ops registered
  *
@@ -907,7 +924,8 @@ static void unregister_ftrace_profiler(void)
 #else
 static struct ftrace_ops ftrace_profile_ops __read_mostly = {
 	.func		= function_profile_call,
-	.flags		= FTRACE_OPS_FL_RECURSION_SAFE,
+	.flags		= FTRACE_OPS_FL_RECURSION_SAFE | FTRACE_OPS_FL_INITIALIZED,
+	INIT_REGEX_LOCK(ftrace_profile_ops)
 };
 
 static int register_ftrace_profiler(void)
@@ -1103,11 +1121,10 @@ static struct ftrace_ops global_ops = {
 	.func			= ftrace_stub,
 	.notrace_hash		= EMPTY_HASH,
 	.filter_hash		= EMPTY_HASH,
-	.flags			= FTRACE_OPS_FL_RECURSION_SAFE,
+	.flags			= FTRACE_OPS_FL_RECURSION_SAFE | FTRACE_OPS_FL_INITIALIZED,
+	INIT_REGEX_LOCK(global_ops)
 };
 
-static DEFINE_MUTEX(ftrace_regex_lock);
-
 struct ftrace_page {
 	struct ftrace_page	*next;
 	struct dyn_ftrace	*records;
@@ -1247,6 +1264,7 @@ static void free_ftrace_hash_rcu(struct ftrace_hash *hash)
 
 void ftrace_free_filter(struct ftrace_ops *ops)
 {
+	ftrace_ops_init(ops);
 	free_ftrace_hash(ops->filter_hash);
 	free_ftrace_hash(ops->notrace_hash);
 }
@@ -2624,6 +2642,8 @@ ftrace_regex_open(struct ftrace_ops *ops, int flag,
 	struct ftrace_hash *hash;
 	int ret = 0;
 
+	ftrace_ops_init(ops);
+
 	if (unlikely(ftrace_disabled))
 		return -ENODEV;
 
@@ -2656,7 +2676,7 @@ ftrace_regex_open(struct ftrace_ops *ops, int flag,
 		}
 	}
 
-	mutex_lock(&ftrace_regex_lock);
+	mutex_lock(&ops->regex_lock);
 
 	if ((file->f_mode & FMODE_WRITE) &&
 	    (file->f_flags & O_TRUNC))
@@ -2677,7 +2697,7 @@ ftrace_regex_open(struct ftrace_ops *ops, int flag,
 		}
 	} else
 		file->private_data = iter;
-	mutex_unlock(&ftrace_regex_lock);
+	mutex_unlock(&ops->regex_lock);
 
 	return ret;
 }
@@ -2910,6 +2930,8 @@ static void function_trace_probe_call(unsigned long ip, unsigned long parent_ip,
 static struct ftrace_ops trace_probe_ops __read_mostly =
 {
 	.func		= function_trace_probe_call,
+	.flags		= FTRACE_OPS_FL_INITIALIZED,
+	INIT_REGEX_LOCK(trace_probe_ops)
 };
 
 static int ftrace_probe_registered;
@@ -3256,18 +3278,18 @@ ftrace_regex_write(struct file *file, const char __user *ubuf,
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
 
@@ -3282,7 +3304,7 @@ ftrace_regex_write(struct file *file, const char __user *ubuf,
 
 	ret = read;
 out_unlock:
-	mutex_unlock(&ftrace_regex_lock);
+	mutex_unlock(&iter->ops->regex_lock);
 
 	return ret;
 }
@@ -3344,7 +3366,7 @@ ftrace_set_hash(struct ftrace_ops *ops, unsigned char *buf, int len,
 	if (!hash)
 		return -ENOMEM;
 
-	mutex_lock(&ftrace_regex_lock);
+	mutex_lock(&ops->regex_lock);
 	if (reset)
 		ftrace_filter_reset(hash);
 	if (buf && !ftrace_match_records(hash, buf, len)) {
@@ -3366,7 +3388,7 @@ ftrace_set_hash(struct ftrace_ops *ops, unsigned char *buf, int len,
 	mutex_unlock(&ftrace_lock);
 
  out_regex_unlock:
-	mutex_unlock(&ftrace_regex_lock);
+	mutex_unlock(&ops->regex_lock);
 
 	free_ftrace_hash(hash);
 	return ret;
@@ -3392,6 +3414,7 @@ ftrace_set_addr(struct ftrace_ops *ops, unsigned long ip, int remove,
 int ftrace_set_filter_ip(struct ftrace_ops *ops, unsigned long ip,
 			 int remove, int reset)
 {
+	ftrace_ops_init(ops);
 	return ftrace_set_addr(ops, ip, remove, reset, 1);
 }
 EXPORT_SYMBOL_GPL(ftrace_set_filter_ip);
@@ -3416,6 +3439,7 @@ ftrace_set_regex(struct ftrace_ops *ops, unsigned char *buf, int len,
 int ftrace_set_filter(struct ftrace_ops *ops, unsigned char *buf,
 		       int len, int reset)
 {
+	ftrace_ops_init(ops);
 	return ftrace_set_regex(ops, buf, len, reset, 1);
 }
 EXPORT_SYMBOL_GPL(ftrace_set_filter);
@@ -3434,6 +3458,7 @@ EXPORT_SYMBOL_GPL(ftrace_set_filter);
 int ftrace_set_notrace(struct ftrace_ops *ops, unsigned char *buf,
 			int len, int reset)
 {
+	ftrace_ops_init(ops);
 	return ftrace_set_regex(ops, buf, len, reset, 0);
 }
 EXPORT_SYMBOL_GPL(ftrace_set_notrace);
@@ -3524,6 +3549,8 @@ ftrace_set_early_filter(struct ftrace_ops *ops, char *buf, int enable)
 {
 	char *func;
 
+	ftrace_ops_init(ops);
+
 	while (buf) {
 		func = strsep(&buf, ",");
 		ftrace_set_regex(ops, func, strlen(func), 0, enable);
@@ -3551,14 +3578,14 @@ int ftrace_regex_release(struct inode *inode, struct file *file)
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
@@ -3587,7 +3614,7 @@ int ftrace_regex_release(struct inode *inode, struct file *file)
 	free_ftrace_hash(iter->hash);
 	kfree(iter);
 
-	mutex_unlock(&ftrace_regex_lock);
+	mutex_unlock(&iter->ops->regex_lock);
 	return 0;
 }
 
@@ -4126,7 +4153,8 @@ void __init ftrace_init(void)
 
 static struct ftrace_ops global_ops = {
 	.func			= ftrace_stub,
-	.flags			= FTRACE_OPS_FL_RECURSION_SAFE,
+	.flags			= FTRACE_OPS_FL_RECURSION_SAFE | FTRACE_OPS_FL_INITIALIZED,
+	INIT_REGEX_LOCK(global_ops)
 };
 
 static int __init ftrace_nodyn_init(void)
@@ -4180,8 +4208,9 @@ ftrace_ops_control_func(unsigned long ip, unsigned long parent_ip,
 }
 
 static struct ftrace_ops control_ops = {
-	.func = ftrace_ops_control_func,
-	.flags = FTRACE_OPS_FL_RECURSION_SAFE,
+	.func	= ftrace_ops_control_func,
+	.flags	= FTRACE_OPS_FL_RECURSION_SAFE | FTRACE_OPS_FL_INITIALIZED,
+	INIT_REGEX_LOCK(control_ops)
 };
 
 static inline void
@@ -4539,6 +4568,8 @@ int register_ftrace_function(struct ftrace_ops *ops)
 {
 	int ret = -1;
 
+	ftrace_ops_init(ops);
+
 	mutex_lock(&ftrace_lock);
 
 	ret = __register_ftrace_function(ops);
-- 
1.7.3.4



