Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756118Ab3GCLhY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 07:37:24 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27155 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503Ab3GCLhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 07:37:20 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=nWlT-PHtl3EA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=04mwm_OPflsA:10 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8 a=vmtLw--12G9VO95vbO0A:9 a=jeBq3FmKZ4MA:10 a=UTB_XpHje0EA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130703113718.511590804@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 03 Jul 2013 07:36:36 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, <stable@vger.kernel.org>,
        Alexander Lam <azl@google.com>
Subject: [for-next][PATCH 1/8] tracing: Add trace_array_get/put() to event handling
References: <20130703113635.696310819@goodmis.org>
Content-Disposition: inline; filename=0001-tracing-Add-trace_array_get-put-to-event-handling.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Commit a695cb58162 "tracing: Prevent deleting instances when they are being read"
tried to fix a race between deleting a trace instance and reading contents
of a trace file. But it wasn't good enough. The following could crash the kernel:

 # cd /sys/kernel/debug/tracing/instances
 # ( while :; do mkdir foo; rmdir foo; done ) &
 # ( while :; do echo 1 > foo/events/sched/sched_switch 2> /dev/null; done ) &

Luckily this can only be done by root user, but it should be fixed regardless.

The problem is that a delete of the file can happen after the write to the event
is opened, but before the enabling happens.

The solution is to make sure the trace_array is available before succeeding in
opening for write, and incerment the ref counter while opened.

Now the instance can be deleted when the events are writing to the buffer,
but the deletion of the instance will disable all events before the instance
is actually deleted.

Cc: stable@vger.kernel.org # 3.10
Reported-by: Alexander Lam <azl@google.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.h        |    3 +++
 kernel/trace/trace_events.c |   55 +++++++++++++++++++++++++++++++++++++++----
 2 files changed, 54 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 2c3cba59..c7fbf93 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -226,6 +226,9 @@ extern struct list_head ftrace_trace_arrays;
 
 extern struct mutex trace_types_lock;
 
+extern int trace_array_get(struct trace_array *tr);
+extern void trace_array_put(struct trace_array *tr);
+
 /*
  * The global tracer (top) should be the first trace array added,
  * but we check the flag anyway.
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 35c6f23..920e08f 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -410,6 +410,35 @@ static void put_system(struct ftrace_subsystem_dir *dir)
 }
 
 /*
+ * Open and update trace_array ref count.
+ * Must have the current trace_array passed to it.
+ */
+static int tracing_open_generic_file(struct inode *inode, struct file *filp)
+{
+	struct ftrace_event_file *file = inode->i_private;
+	struct trace_array *tr = file->tr;
+	int ret;
+
+	if (trace_array_get(tr) < 0)
+		return -ENODEV;
+
+	ret = tracing_open_generic(inode, filp);
+	if (ret < 0)
+		trace_array_put(tr);
+	return ret;
+}
+
+static int tracing_release_generic_file(struct inode *inode, struct file *filp)
+{
+	struct ftrace_event_file *file = inode->i_private;
+	struct trace_array *tr = file->tr;
+
+	trace_array_put(tr);
+
+	return 0;
+}
+
+/*
  * __ftrace_set_clr_event(NULL, NULL, NULL, set) will set/unset all events.
  */
 static int __ftrace_set_clr_event(struct trace_array *tr, const char *match,
@@ -1032,9 +1061,17 @@ static int subsystem_open(struct inode *inode, struct file *filp)
 	/* Some versions of gcc think dir can be uninitialized here */
 	WARN_ON(!dir);
 
+	/* Still need to increment the ref count of the system */
+	if (trace_array_get(tr) < 0) {
+		put_system(dir);
+		return -ENODEV;
+	}
+
 	ret = tracing_open_generic(inode, filp);
-	if (ret < 0)
+	if (ret < 0) {
+		trace_array_put(tr);
 		put_system(dir);
+	}
 
 	return ret;
 }
@@ -1045,16 +1082,23 @@ static int system_tr_open(struct inode *inode, struct file *filp)
 	struct trace_array *tr = inode->i_private;
 	int ret;
 
+	if (trace_array_get(tr) < 0)
+		return -ENODEV;
+
 	/* Make a temporary dir that has no system but points to tr */
 	dir = kzalloc(sizeof(*dir), GFP_KERNEL);
-	if (!dir)
+	if (!dir) {
+		trace_array_put(tr);
 		return -ENOMEM;
+	}
 
 	dir->tr = tr;
 
 	ret = tracing_open_generic(inode, filp);
-	if (ret < 0)
+	if (ret < 0) {
+		trace_array_put(tr);
 		kfree(dir);
+	}
 
 	filp->private_data = dir;
 
@@ -1065,6 +1109,8 @@ static int subsystem_release(struct inode *inode, struct file *file)
 {
 	struct ftrace_subsystem_dir *dir = file->private_data;
 
+	trace_array_put(dir->tr);
+
 	/*
 	 * If dir->subsystem is NULL, then this is a temporary
 	 * descriptor that was made for a trace_array to enable
@@ -1192,9 +1238,10 @@ static const struct file_operations ftrace_set_event_fops = {
 };
 
 static const struct file_operations ftrace_enable_fops = {
-	.open = tracing_open_generic,
+	.open = tracing_open_generic_file,
 	.read = event_enable_read,
 	.write = event_enable_write,
+	.release = tracing_release_generic_file,
 	.llseek = default_llseek,
 };
 
-- 
1.7.10.4


