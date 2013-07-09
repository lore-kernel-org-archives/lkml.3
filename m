Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753632Ab3GIH6Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 03:58:16 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:54490 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858Ab3GIH6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 03:58:14 -0400
X-AuditID: 85900ec0-d42c9b900000151e-0e-51dbc28e6c89
Subject: [RFC PATCH V2] tracing: Check f_dentry before accessing
 event_file/call in inode->i_private
To: Steven Rostedt <rostedt@goodmis.org>
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Andrew Morton <akpm@linux-foundation.org>, jovi.zhangwei@huawei.com,
        Jiri Olsa <jolsa@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Date: Tue, 09 Jul 2013 16:55:19 +0900
Message-ID: <20130709075519.2583.96462.stgit@mhiramat-M0-7522>
In-Reply-To: <20130705003223.GA4981@redhat.com>
References: <20130705003223.GA4981@redhat.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently ftrace_open_generic_file gets an event_file from
inode->i_private, and then locks event_mutex and gets refcount.
However, this can cause a race as below scenario;

CPU0                              CPU1
open(kprobe_events)
  trace_remove_event_call()    open(enable)
    lock event_mutex             get event_file from inode->i_private
      event_remove()             wait for unlock event_mutex
        ...
        free event_file
    unlock event_mutex
                                 lock event_mutex
                                 add refcount of event_file->call (*)

So, at (*) point, the event_file is already freed and we
may access the corrupted object.
The same thing could happen on event_call because it is also
directly accessed from i_private on some points.

To avoid this, when opening events/*/*/enable, we have to ensure
the dentry of the file is not unlinked yet, under event_mutex
is locked.

CPU0                              CPU1
open(kprobe_events)
  trace_remove_event_call()    open(enable)
    lock event_mutex             get event_file from inode->i_private
      event_remove()             wait for unlock event_mutex
        ...
        dput(dentry)
        free event_file
    unlock event_mutex
                                 lock event_mutex
                                 check !d_unhashed(dentry) and failed
                                 unlock event_mutex
                                 return -ENODEV

Note: trace_array_get(tr) always ensures existance of tr in
trace_arrays, so above check is not needed in the case that
i_private directly points the tr.

Changes from V1:
 - Use d_unhashed(f_dentry) to ensure the event exists according
   to Oleg's comment.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Suggested-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/trace/trace_events.c |   70 ++++++++++++++++++++++++++++++++++---------
 1 file changed, 55 insertions(+), 15 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 1a5547e..06fdac0 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -391,15 +391,32 @@ static void __get_system_dir(struct ftrace_subsystem_dir *dir)
 	__get_system(dir->subsystem);
 }
 
-static int ftrace_event_call_get(struct ftrace_event_call *call)
+static int __ftrace_event_call_get(struct ftrace_event_call *call)
 {
 	int ret = 0;
 
-	mutex_lock(&event_mutex);
 	if ((call->flags & TRACE_EVENT_FL_REF_MASK) == TRACE_EVENT_FL_REF_MAX - 1)
 		ret = -EBUSY;
 	else
 		call->flags++;
+
+	return ret;
+}
+
+static int ftrace_event_call_get(struct ftrace_event_call *call,
+				 struct dentry *dentry)
+{
+	int ret = -ENODEV;
+
+	mutex_lock(&event_mutex);
+	spin_lock(&dentry->d_lock);
+	if (d_unhashed(dentry)) /* This file is already unlinked */
+		goto out_unlock;
+
+	ret = __ftrace_event_call_get(call);
+
+ out_unlock:
+	spin_unlock(&dentry->d_lock);
 	mutex_unlock(&event_mutex);
 
 	return ret;
@@ -413,6 +430,35 @@ static void ftrace_event_call_put(struct ftrace_event_call *call)
 	mutex_unlock(&event_mutex);
 }
 
+static int ftrace_event_file_get(struct ftrace_event_file *file,
+				 struct dentry *dentry)
+{
+	int ret = -ENODEV;
+
+	mutex_lock(&event_mutex);
+	spin_lock(&dentry->d_lock);
+	if (d_unhashed(dentry)) /* This file is already unlinked */
+		goto out_unlock;
+
+	ret = __ftrace_event_call_get(file->event_call);
+	if (!ret)
+		file->tr->ref++;
+
+ out_unlock:
+	spin_unlock(&dentry->d_lock);
+	mutex_unlock(&event_mutex);
+
+	return ret;
+}
+
+static void ftrace_event_file_put(struct ftrace_event_file *file)
+{
+	struct trace_array *tr = file->tr;
+
+	ftrace_event_call_put(file->event_call);
+	trace_array_put(tr);
+}
+
 static void __put_system_dir(struct ftrace_subsystem_dir *dir)
 {
 	WARN_ON_ONCE(dir->ref_count == 0);
@@ -438,33 +484,27 @@ static void put_system(struct ftrace_subsystem_dir *dir)
 static int tracing_open_generic_file(struct inode *inode, struct file *filp)
 {
 	struct ftrace_event_file *file = inode->i_private;
-	struct trace_array *tr = file->tr;
 	int ret;
 
-	if (trace_array_get(tr) < 0)
-		return -ENODEV;
-
-	ret = tracing_open_generic(inode, filp);
+	ret = ftrace_event_file_get(file, filp->f_dentry);
 	if (ret < 0)
-		goto fail;
+		return ret;
 
-	ret = ftrace_event_call_get(file->event_call);
+	ret = tracing_open_generic(inode, filp);
 	if (ret < 0)
 		goto fail;
 
 	return 0;
  fail:
-	trace_array_put(tr);
+	ftrace_event_file_put(file);
 	return ret;
 }
 
 static int tracing_release_generic_file(struct inode *inode, struct file *filp)
 {
 	struct ftrace_event_file *file = inode->i_private;
-	struct trace_array *tr = file->tr;
 
-	ftrace_event_call_put(file->event_call);
-	trace_array_put(tr);
+	ftrace_event_file_put(file);
 
 	return 0;
 }
@@ -477,7 +517,7 @@ static int tracing_open_generic_call(struct inode *inode, struct file *filp)
 {
 	struct ftrace_event_call *call = inode->i_private;
 
-	return ftrace_event_call_get(call);
+	return ftrace_event_call_get(call, filp->f_dentry);
 }
 
 static int tracing_release_generic_call(struct inode *inode, struct file *filp)
@@ -1007,7 +1047,7 @@ static int trace_format_open(struct inode *inode, struct file *file)
 	struct seq_file *m;
 	int ret;
 
-	ret = ftrace_event_call_get(call);
+	ret = ftrace_event_call_get(call, file->f_dentry);
 	if (ret < 0)
 		return ret;
 

