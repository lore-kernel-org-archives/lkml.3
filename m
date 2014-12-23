Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932300AbaLWQRM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 11:17:12 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:42927 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756387AbaLWQQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 11:16:52 -0500
Message-Id: <20141223161635.720540288@goodmis.org>
User-Agent: quilt/0.61-1
Date: Tue, 23 Dec 2014 11:13:42 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Subject: [for-next][PATCH 2/2] tracing: Remove taking of trace_types_lock in pipe files
References: <20141223161340.297942985@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0002-tracing-Remove-taking-of-trace_types_lock-in-pipe-fi.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Taking the global mutex "trace_types_lock" in the trace_pipe files
causes a bottle neck as most the pipe files can be read per cpu
and there's no reason to serialize them.

The current_trace variable was given a ref count and it can not
change when the ref count is not zero. Opening the trace_pipe
files will up the ref count (and decremented on close), so that
the lock no longer needs to be taken when accessing the
current_trace variable.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c | 110 +++++++++++++--------------------------------------
 1 file changed, 28 insertions(+), 82 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index ed3fba1d6570..7669b1f3234e 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -4332,17 +4332,7 @@ static int tracing_open_pipe(struct inode *inode, struct file *filp)
 	}
 
 	trace_seq_init(&iter->seq);
-
-	/*
-	 * We make a copy of the current tracer to avoid concurrent
-	 * changes on it while we are reading.
-	 */
-	iter->trace = kmalloc(sizeof(*iter->trace), GFP_KERNEL);
-	if (!iter->trace) {
-		ret = -ENOMEM;
-		goto fail;
-	}
-	*iter->trace = *tr->current_trace;
+	iter->trace = tr->current_trace;
 
 	if (!alloc_cpumask_var(&iter->started, GFP_KERNEL)) {
 		ret = -ENOMEM;
@@ -4399,7 +4389,6 @@ static int tracing_release_pipe(struct inode *inode, struct file *file)
 
 	free_cpumask_var(iter->started);
 	mutex_destroy(&iter->mutex);
-	kfree(iter->trace);
 	kfree(iter);
 
 	trace_array_put(tr);
@@ -4432,7 +4421,7 @@ tracing_poll_pipe(struct file *filp, poll_table *poll_table)
 	return trace_poll(iter, filp, poll_table);
 }
 
-/* Must be called with trace_types_lock mutex held. */
+/* Must be called with iter->mutex held. */
 static int tracing_wait_pipe(struct file *filp)
 {
 	struct trace_iterator *iter = filp->private_data;
@@ -4477,7 +4466,6 @@ tracing_read_pipe(struct file *filp, char __user *ubuf,
 		  size_t cnt, loff_t *ppos)
 {
 	struct trace_iterator *iter = filp->private_data;
-	struct trace_array *tr = iter->tr;
 	ssize_t sret;
 
 	/* return any leftover data */
@@ -4487,12 +4475,6 @@ tracing_read_pipe(struct file *filp, char __user *ubuf,
 
 	trace_seq_init(&iter->seq);
 
-	/* copy the tracer to avoid using a global lock all around */
-	mutex_lock(&trace_types_lock);
-	if (unlikely(iter->trace->name != tr->current_trace->name))
-		*iter->trace = *tr->current_trace;
-	mutex_unlock(&trace_types_lock);
-
 	/*
 	 * Avoid more than one consumer on a single file descriptor
 	 * This is just a matter of traces coherency, the ring buffer itself
@@ -4652,7 +4634,6 @@ static ssize_t tracing_splice_read_pipe(struct file *filp,
 		.ops		= &tracing_pipe_buf_ops,
 		.spd_release	= tracing_spd_release_pipe,
 	};
-	struct trace_array *tr = iter->tr;
 	ssize_t ret;
 	size_t rem;
 	unsigned int i;
@@ -4660,12 +4641,6 @@ static ssize_t tracing_splice_read_pipe(struct file *filp,
 	if (splice_grow_spd(pipe, &spd))
 		return -ENOMEM;
 
-	/* copy the tracer to avoid using a global lock all around */
-	mutex_lock(&trace_types_lock);
-	if (unlikely(iter->trace->name != tr->current_trace->name))
-		*iter->trace = *tr->current_trace;
-	mutex_unlock(&trace_types_lock);
-
 	mutex_lock(&iter->mutex);
 
 	if (iter->trace->splice_read) {
@@ -5373,21 +5348,16 @@ tracing_buffers_read(struct file *filp, char __user *ubuf,
 	if (!count)
 		return 0;
 
-	mutex_lock(&trace_types_lock);
-
 #ifdef CONFIG_TRACER_MAX_TRACE
-	if (iter->snapshot && iter->tr->current_trace->use_max_tr) {
-		size = -EBUSY;
-		goto out_unlock;
-	}
+	if (iter->snapshot && iter->tr->current_trace->use_max_tr)
+		return -EBUSY;
 #endif
 
 	if (!info->spare)
 		info->spare = ring_buffer_alloc_read_page(iter->trace_buffer->buffer,
 							  iter->cpu_file);
-	size = -ENOMEM;
 	if (!info->spare)
-		goto out_unlock;
+		return -ENOMEM;
 
 	/* Do we have previous read data to read? */
 	if (info->read < PAGE_SIZE)
@@ -5403,21 +5373,16 @@ tracing_buffers_read(struct file *filp, char __user *ubuf,
 
 	if (ret < 0) {
 		if (trace_empty(iter)) {
-			if ((filp->f_flags & O_NONBLOCK)) {
-				size = -EAGAIN;
-				goto out_unlock;
-			}
-			mutex_unlock(&trace_types_lock);
+			if ((filp->f_flags & O_NONBLOCK))
+				return -EAGAIN;
+
 			ret = wait_on_pipe(iter, false);
-			mutex_lock(&trace_types_lock);
-			if (ret) {
-				size = ret;
-				goto out_unlock;
-			}
+			if (ret)
+				return ret;
+
 			goto again;
 		}
-		size = 0;
-		goto out_unlock;
+		return 0;
 	}
 
 	info->read = 0;
@@ -5427,18 +5392,14 @@ tracing_buffers_read(struct file *filp, char __user *ubuf,
 		size = count;
 
 	ret = copy_to_user(ubuf, info->spare + info->read, size);
-	if (ret == size) {
-		size = -EFAULT;
-		goto out_unlock;
-	}
+	if (ret == size)
+		return -EFAULT;
+
 	size -= ret;
 
 	*ppos += size;
 	info->read += size;
 
- out_unlock:
-	mutex_unlock(&trace_types_lock);
-
 	return size;
 }
 
@@ -5536,30 +5497,20 @@ tracing_buffers_splice_read(struct file *file, loff_t *ppos,
 	int entries, size, i;
 	ssize_t ret = 0;
 
-	mutex_lock(&trace_types_lock);
-
 #ifdef CONFIG_TRACER_MAX_TRACE
-	if (iter->snapshot && iter->tr->current_trace->use_max_tr) {
-		ret = -EBUSY;
-		goto out;
-	}
+	if (iter->snapshot && iter->tr->current_trace->use_max_tr)
+		return -EBUSY;
 #endif
 
-	if (splice_grow_spd(pipe, &spd)) {
-		ret = -ENOMEM;
-		goto out;
-	}
+	if (splice_grow_spd(pipe, &spd))
+		return -ENOMEM;
 
-	if (*ppos & (PAGE_SIZE - 1)) {
-		ret = -EINVAL;
-		goto out;
-	}
+	if (*ppos & (PAGE_SIZE - 1))
+		return -EINVAL;
 
 	if (len & (PAGE_SIZE - 1)) {
-		if (len < PAGE_SIZE) {
-			ret = -EINVAL;
-			goto out;
-		}
+		if (len < PAGE_SIZE)
+			return -EINVAL;
 		len &= PAGE_MASK;
 	}
 
@@ -5620,25 +5571,20 @@ tracing_buffers_splice_read(struct file *file, loff_t *ppos,
 	/* did we read anything? */
 	if (!spd.nr_pages) {
 		if (ret)
-			goto out;
+			return ret;
+
+		if ((file->f_flags & O_NONBLOCK) || (flags & SPLICE_F_NONBLOCK))
+			return -EAGAIN;
 
-		if ((file->f_flags & O_NONBLOCK) || (flags & SPLICE_F_NONBLOCK)) {
-			ret = -EAGAIN;
-			goto out;
-		}
-		mutex_unlock(&trace_types_lock);
 		ret = wait_on_pipe(iter, true);
-		mutex_lock(&trace_types_lock);
 		if (ret)
-			goto out;
+			return ret;
 
 		goto again;
 	}
 
 	ret = splice_to_pipe(pipe, &spd);
 	splice_shrink_spd(&spd);
-out:
-	mutex_unlock(&trace_types_lock);
 
 	return ret;
 }
-- 
2.1.3


