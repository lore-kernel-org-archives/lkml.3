Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933755Ab3GPTCe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 15:02:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55688 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933248Ab3GPTCd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 15:02:33 -0400
Date: Tue, 16 Jul 2013 20:57:26 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>, Jiri Olsa <jolsa@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH 3/4] tracing: Kill tracing_open/release_generic_file
Message-ID: <20130716185726.GA21200@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130716185658.GA21167@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kill tracing_open_generic_file() and tracing_release_generic_file(),
they are racy anyway.

Instead, change event_enable_read() and event_enable_write() to rely
on event_mutex and file_inode(filp)->i_private != NULL check.

trace_array_get() goes away. NOTE! this is actually wrong until we
change instance_delete() path to nullify ->i_private.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/trace/trace_events.c |   62 ++++++++++++++-----------------------------
 1 files changed, 20 insertions(+), 42 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index cefbe85..6401b51 100644
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
@@ -679,15 +650,25 @@ static ssize_t
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
+	file = file_inode(filp)->i_private;
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
@@ -699,13 +680,10 @@ static ssize_t
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
@@ -717,8 +695,11 @@ event_enable_write(struct file *filp, const char __user *ubuf, size_t cnt,
 	switch (val) {
 	case 0:
 	case 1:
+		ret = -ENODEV;
 		mutex_lock(&event_mutex);
-		ret = ftrace_event_enable_disable(file, val);
+		file = file_inode(filp)->i_private;
+		if (likely(file))
+			ret = ftrace_event_enable_disable(file, val);
 		mutex_unlock(&event_mutex);
 		break;
 
@@ -727,7 +708,6 @@ event_enable_write(struct file *filp, const char __user *ubuf, size_t cnt,
 	}
 
 	*ppos += cnt;
-
 	return ret ? ret : cnt;
 }
 
@@ -1242,10 +1222,8 @@ static const struct file_operations ftrace_set_event_fops = {
 };
 
 static const struct file_operations ftrace_enable_fops = {
-	.open = tracing_open_generic_file,
 	.read = event_enable_read,
 	.write = event_enable_write,
-	.release = tracing_release_generic_file,
 	.llseek = default_llseek,
 };
 
-- 
1.5.5.1

