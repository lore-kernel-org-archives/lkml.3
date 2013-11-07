Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752968Ab3KGAn4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 19:43:56 -0500
Received: from mail-ie0-f201.google.com ([209.85.223.201]:57595 "EHLO
	mail-ie0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752731Ab3KGAny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 19:43:54 -0500
From: Bharath Ravi <rbharath@google.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Vaibhav Nagarnaik <vnagarnaik@google.com>,
        David Sharp <dhsharp@google.com>, Laurent Chavey <chavey@google.com>,
        Bharath Ravi <rbharath@google.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] tracing: Allow changing default ring buffer size for ftrace instances.
Date: Wed,  6 Nov 2013 16:43:02 -0800
Message-Id: <1383784982-27482-1-git-send-email-rbharath@google.com>
X-Mailer: git-send-email 1.8.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is often memory efficient to start instances off with a smaller ring
buffer size than the current default. This is particularly true on
systems with many cores, or when multiple ftrace instances are created,
where the current (higher) default value results in allocation failures.

To allow instances to start off with custom ring buffer sizes, a new
debugfs file named "instance_default_buffer_size_kb" is added in the
root ftrace directory. A size in kilobytes may be written to this. Any
ftrace instances created will be initialized with ring buffers of the
size specified in this file.

This change also modifies allocate_trace_buffer() to use the "size"
parameter while setting set_buffer_entries(), instead of the actual ring
ring buffer size (which is "size" rounded up to the nearest page size).
This makes it consistent with the way writing to the buffer_size_kb
files works (using ring_buffer_resize()), and ensures that the
buffer_size_kb value of a newly created instance matches that written
to the instance_default_buffer_size file, instead of the rounded up
value.

Tested: Booted into a kernel with these changes, verified reading and
writing to the new file. Ensured that new ftrace instances created
used the size specified in instance_default_buffer_size_kb as their
initial ring buffer size.

Signed-off-by: Bharath Ravi <rbharath@google.com>
---
 kernel/trace/trace.c | 57 +++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 54 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 7974ba2..d10afea 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -296,6 +296,14 @@ int tracing_is_enabled(void)
 
 static unsigned long		trace_buf_size = TRACE_BUF_SIZE_DEFAULT;
 
+/*
+ * instance_default_buf_size is the size in bytes that is allocated for an
+ * instance's buffer when it is first created. This is initially set to
+ * TRACE_BUF_SIZE_DEFAULT but may be modified by writing to the
+ * "instance_default_buffer_size_kb" file.
+ */
+static unsigned long instance_default_buf_size = TRACE_BUF_SIZE_DEFAULT;
+
 /* trace_types holds a link list of available tracers. */
 static struct tracer		*trace_types __read_mostly;
 
@@ -3165,6 +3173,48 @@ static const struct file_operations show_traces_fops = {
 	.llseek		= seq_lseek,
 };
 
+static ssize_t
+instance_default_buffer_size_read(struct file *filp, char __user *ubuf,
+				  size_t cnt, loff_t *ppos)
+{
+	int r = 0;
+	char buf[64];
+	ssize_t ret;
+
+	r = sprintf(buf, "%lu\n", instance_default_buf_size >> 10);
+	ret = simple_read_from_buffer(ubuf, cnt, ppos, buf, r);
+
+	return ret;
+}
+
+static ssize_t
+instance_default_buffer_size_write(struct file *filp, const char __user *ubuf,
+				   size_t cnt, loff_t *ppos)
+{
+	unsigned long val;
+	int ret;
+
+	ret = kstrtoul_from_user(ubuf, cnt, 10, &val);
+	if (ret)
+		return ret;
+
+	/* ubuf must have at least 1 entry */
+	if (!val)
+		return -EINVAL;
+
+	/* val is in KB */
+	instance_default_buf_size = val << 10;
+
+	return cnt;
+}
+
+static const struct file_operations instance_default_buffer_size_fops = {
+	.open		= tracing_open_generic,
+	.read		= instance_default_buffer_size_read,
+	.write		= instance_default_buffer_size_write,
+	.llseek		= generic_file_llseek,
+};
+
 /*
  * The tracer itself will not take this lock, but still we want
  * to provide a consistent cpumask to user-space:
@@ -5880,8 +5930,7 @@ allocate_trace_buffer(struct trace_array *tr, struct trace_buffer *buf, int size
 	}
 
 	/* Allocate the first page for all buffers */
-	set_buffer_entries(&tr->trace_buffer,
-			   ring_buffer_size(tr->trace_buffer.buffer, 0));
+	set_buffer_entries(&tr->trace_buffer, size);
 
 	return 0;
 }
@@ -5947,7 +5996,7 @@ static int new_instance_create(const char *name)
 	INIT_LIST_HEAD(&tr->systems);
 	INIT_LIST_HEAD(&tr->events);
 
-	if (allocate_trace_buffers(tr, trace_buf_size) < 0)
+	if (allocate_trace_buffers(tr, instance_default_buf_size) < 0)
 		goto out_free_tr;
 
 	tr->dir = debugfs_create_dir(name, trace_instance_dir);
@@ -6177,6 +6226,8 @@ static __init int tracer_init_debugfs(void)
 	trace_create_file("dyn_ftrace_total_info", 0444, d_tracer,
 			&ftrace_update_tot_cnt, &tracing_dyn_info_fops);
 #endif
+	trace_create_file("instance_default_buffer_size_kb", 0444, d_tracer,
+			NULL, &instance_default_buffer_size_fops);
 
 	create_trace_instances(d_tracer);
 
-- 
1.8.4.1

