Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933768Ab3CHDHn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 22:07:43 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22287 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760250Ab3CHDGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 22:06:55 -0500
X-Authority-Analysis: v=2.0 cv=UN5f7Vjy c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=NA7ii2Zv4CEA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=TGKlOWVMYwMA:10 a=20KFwNOVAAAA:8 a=SdB8PDy4KnFN4LtCCFsA:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130308030653.239625974@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 07 Mar 2013 22:00:07 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>, hcochran@lexmark.com,
        Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
Subject: [for-next][PATCH 09/17] tracing: Add snapshot_raw to extract the raw data from snapshot
References: <20130308025958.501479677@goodmis.org>
Content-Disposition: inline; filename=0009-tracing-Add-snapshot_raw-to-extract-the-raw-data-fro.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <srostedt@redhat.com>

Add a 'snapshot_raw' per_cpu file that allows tools to read the raw
binary data of the snapshot buffer.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |  113 ++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 95 insertions(+), 18 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 96cd165..e5ce4dd 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -4177,6 +4177,12 @@ static int tracing_clock_open(struct inode *inode, struct file *file)
 	return single_open(file, tracing_clock_show, inode->i_private);
 }
 
+struct ftrace_buffer_info {
+	struct trace_iterator	iter;
+	void			*spare;
+	unsigned int		read;
+};
+
 #ifdef CONFIG_TRACER_SNAPSHOT
 static int tracing_snapshot_open(struct inode *inode, struct file *file)
 {
@@ -4307,6 +4313,35 @@ static int tracing_snapshot_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
+static int tracing_buffers_open(struct inode *inode, struct file *filp);
+static ssize_t tracing_buffers_read(struct file *filp, char __user *ubuf,
+				    size_t count, loff_t *ppos);
+static int tracing_buffers_release(struct inode *inode, struct file *file);
+static ssize_t tracing_buffers_splice_read(struct file *file, loff_t *ppos,
+		   struct pipe_inode_info *pipe, size_t len, unsigned int flags);
+
+static int snapshot_raw_open(struct inode *inode, struct file *filp)
+{
+	struct ftrace_buffer_info *info;
+	int ret;
+
+	ret = tracing_buffers_open(inode, filp);
+	if (ret < 0)
+		return ret;
+
+	info = filp->private_data;
+
+	if (info->iter.trace->use_max_tr) {
+		tracing_buffers_release(inode, filp);
+		return -EBUSY;
+	}
+
+	info->iter.snapshot = true;
+	info->iter.trace_buffer = &info->iter.tr->max_buffer;
+
+	return ret;
+}
+
 #endif /* CONFIG_TRACER_SNAPSHOT */
 
 
@@ -4373,14 +4408,17 @@ static const struct file_operations snapshot_fops = {
 	.llseek		= tracing_seek,
 	.release	= tracing_snapshot_release,
 };
-#endif /* CONFIG_TRACER_SNAPSHOT */
 
-struct ftrace_buffer_info {
-	struct trace_iterator	iter;
-	void			*spare;
-	unsigned int		read;
+static const struct file_operations snapshot_raw_fops = {
+	.open		= snapshot_raw_open,
+	.read		= tracing_buffers_read,
+	.release	= tracing_buffers_release,
+	.splice_read	= tracing_buffers_splice_read,
+	.llseek		= no_llseek,
 };
 
+#endif /* CONFIG_TRACER_SNAPSHOT */
+
 static int tracing_buffers_open(struct inode *inode, struct file *filp)
 {
 	struct trace_cpu *tc = inode->i_private;
@@ -4423,16 +4461,26 @@ tracing_buffers_read(struct file *filp, char __user *ubuf,
 	struct ftrace_buffer_info *info = filp->private_data;
 	struct trace_iterator *iter = &info->iter;
 	ssize_t ret;
-	size_t size;
+	ssize_t size;
 
 	if (!count)
 		return 0;
 
+	mutex_lock(&trace_types_lock);
+
+#ifdef CONFIG_TRACER_MAX_TRACE
+	if (iter->snapshot && iter->tr->current_trace->use_max_tr) {
+		size = -EBUSY;
+		goto out_unlock;
+	}
+#endif
+
 	if (!info->spare)
 		info->spare = ring_buffer_alloc_read_page(iter->trace_buffer->buffer,
 							  iter->cpu_file);
+	size = -ENOMEM;
 	if (!info->spare)
-		return -ENOMEM;
+		goto out_unlock;
 
 	/* Do we have previous read data to read? */
 	if (info->read < PAGE_SIZE)
@@ -4448,31 +4496,42 @@ tracing_buffers_read(struct file *filp, char __user *ubuf,
 
 	if (ret < 0) {
 		if (trace_empty(iter)) {
-			if ((filp->f_flags & O_NONBLOCK))
-				return -EAGAIN;
+			if ((filp->f_flags & O_NONBLOCK)) {
+				size = -EAGAIN;
+				goto out_unlock;
+			}
+			mutex_unlock(&trace_types_lock);
 			iter->trace->wait_pipe(iter);
-			if (signal_pending(current))
-				return -EINTR;
+			mutex_lock(&trace_types_lock);
+			if (signal_pending(current)) {
+				size = -EINTR;
+				goto out_unlock;
+			}
 			goto again;
 		}
-		return 0;
+		size = 0;
+		goto out_unlock;
 	}
 
 	info->read = 0;
-
  read:
 	size = PAGE_SIZE - info->read;
 	if (size > count)
 		size = count;
 
 	ret = copy_to_user(ubuf, info->spare + info->read, size);
-	if (ret == size)
-		return -EFAULT;
+	if (ret == size) {
+		size = -EFAULT;
+		goto out_unlock;
+	}
 	size -= ret;
 
 	*ppos += size;
 	info->read += size;
 
+ out_unlock:
+	mutex_unlock(&trace_types_lock);
+
 	return size;
 }
 
@@ -4562,10 +4621,21 @@ tracing_buffers_splice_read(struct file *file, loff_t *ppos,
 	};
 	struct buffer_ref *ref;
 	int entries, size, i;
-	size_t ret;
+	ssize_t ret;
 
-	if (splice_grow_spd(pipe, &spd))
-		return -ENOMEM;
+	mutex_lock(&trace_types_lock);
+
+#ifdef CONFIG_TRACER_MAX_TRACE
+	if (iter->snapshot && iter->tr->current_trace->use_max_tr) {
+		ret = -EBUSY;
+		goto out;
+	}
+#endif
+
+	if (splice_grow_spd(pipe, &spd)) {
+		ret = -ENOMEM;
+		goto out;
+	}
 
 	if (*ppos & (PAGE_SIZE - 1)) {
 		ret = -EINVAL;
@@ -4637,7 +4707,9 @@ tracing_buffers_splice_read(struct file *file, loff_t *ppos,
 			ret = -EAGAIN;
 			goto out;
 		}
+		mutex_unlock(&trace_types_lock);
 		iter->trace->wait_pipe(iter);
+		mutex_lock(&trace_types_lock);
 		if (signal_pending(current)) {
 			ret = -EINTR;
 			goto out;
@@ -4648,6 +4720,8 @@ tracing_buffers_splice_read(struct file *file, loff_t *ppos,
 	ret = splice_to_pipe(pipe, &spd);
 	splice_shrink_spd(&spd);
 out:
+	mutex_unlock(&trace_types_lock);
+
 	return ret;
 }
 
@@ -4851,6 +4925,9 @@ tracing_init_debugfs_percpu(struct trace_array *tr, long cpu)
 #ifdef CONFIG_TRACER_SNAPSHOT
 	trace_create_file("snapshot", 0644, d_cpu,
 			  (void *)&data->trace_cpu, &snapshot_fops);
+
+	trace_create_file("snapshot_raw", 0444, d_cpu,
+			(void *)&data->trace_cpu, &snapshot_raw_fops);
 #endif
 }
 
-- 
1.7.10.4


