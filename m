Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755648Ab3GBChh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 22:37:37 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:18257 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419Ab3GBChg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 22:37:36 -0400
X-Authority-Analysis: v=2.0 cv=Du3UCRD+ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=mAbLp22spWkA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=4rANEwmd3YMA:10 a=Gs8F_qNZ6yvamwXcxGgA:9 a=QEXdDO2ut3YA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1372732653.22688.39.camel@gandalf.local.home>
Subject: Re: Fwd: [draft] Tracing multibuffer support concurrency issues
From: Steven Rostedt <rostedt@goodmis.org>
To: Alexander Lam <azl@google.com>
Cc: linux-kernel@vger.kernel.org, David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Alexander Lam <lambchop468@gmail.com>
Date: Mon, 01 Jul 2013 22:37:33 -0400
In-Reply-To: <1372728935.22688.36.camel@gandalf.local.home>
References: <CANiYik6PbwRkH1vK4B4cFhY0MEJAoF=MBggkvgBYGfyCw2ny-w@mail.gmail.com>
	 <CANiYik6h0_xnUYqCRHZU75az9YS=ySUHaqgMayW-Ffj5Jey6_g@mail.gmail.com>
	 <1372728935.22688.36.camel@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-07-01 at 21:35 -0400, Steven Rostedt wrote:

> > 
> > Is there a better way to fix this problem?
> > 
> > Also unaddressed are all of the other files which use a trace_array,
> > trace_cpu, or ftrace_event_file in their operation - these would need
> > the same fix.
> 
> Hmm, really? Just the initiator. That is, when an event is enabled or
> anything gets opened, we block deletion from happening. That way we
> don't need to care about the rest. Only open and enabling events.

I added two helper functions to handle this. trace_array_get() and
trace_array_put(). This patch prevents your example from crashing.

This probably needs to be added to opening of other files if not already
done.

-- Steve

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index e36da7f..89a3930 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -204,6 +204,37 @@ static struct trace_array	global_trace;
 
 LIST_HEAD(ftrace_trace_arrays);
 
+int trace_array_get(struct trace_array *this_tr)
+{
+	struct trace_array *tr;
+	int ret = -ENODEV;
+
+	mutex_lock(&trace_types_lock);
+	list_for_each_entry(tr, &ftrace_trace_arrays, list) {
+		if (tr == this_tr) {
+			tr->ref++;
+			ret = 0;
+			break;
+		}
+	}
+	mutex_unlock(&trace_types_lock);
+
+	return ret;
+}
+
+static void __trace_array_put(struct trace_array *this_tr)
+{
+	WARN_ON(!this_tr->ref);
+	this_tr->ref--;
+}
+
+void trace_array_put(struct trace_array *this_tr)
+{
+	mutex_lock(&trace_types_lock);
+	__trace_array_put(this_tr);
+	mutex_unlock(&trace_types_lock);
+}
+
 int filter_current_check_discard(struct ring_buffer *buffer,
 				 struct ftrace_event_call *call, void *rec,
 				 struct ring_buffer_event *event)
@@ -2831,10 +2862,9 @@ static const struct seq_operations tracer_seq_ops = {
 };
 
 static struct trace_iterator *
-__tracing_open(struct inode *inode, struct file *file, bool snapshot)
+__tracing_open(struct trace_array *tr, struct trace_cpu *tc,
+	       struct inode *inode, struct file *file, bool snapshot)
 {
-	struct trace_cpu *tc = inode->i_private;
-	struct trace_array *tr = tc->tr;
 	struct trace_iterator *iter;
 	int cpu;
 
@@ -2913,8 +2943,6 @@ __tracing_open(struct inode *inode, struct file *file, bool snapshot)
 		tracing_iter_reset(iter, cpu);
 	}
 
-	tr->ref++;
-
 	mutex_unlock(&trace_types_lock);
 
 	return iter;
@@ -2944,17 +2972,20 @@ static int tracing_release(struct inode *inode, struct file *file)
 	struct trace_array *tr;
 	int cpu;
 
-	if (!(file->f_mode & FMODE_READ))
+	/* Writes do not use seq_file, need to grab tr from inode */
+	if (!(file->f_mode & FMODE_READ)) {
+		struct trace_cpu *tc = inode->i_private;
+
+		trace_array_put(tc->tr);
 		return 0;
+	}
 
 	iter = m->private;
 	tr = iter->tr;
+	trace_array_put(tr);
 
 	mutex_lock(&trace_types_lock);
 
-	WARN_ON(!tr->ref);
-	tr->ref--;
-
 	for_each_tracing_cpu(cpu) {
 		if (iter->buffer_iter[cpu])
 			ring_buffer_read_finish(iter->buffer_iter[cpu]);
@@ -2973,20 +3004,23 @@ static int tracing_release(struct inode *inode, struct file *file)
 	kfree(iter->trace);
 	kfree(iter->buffer_iter);
 	seq_release_private(inode, file);
+
 	return 0;
 }
 
 static int tracing_open(struct inode *inode, struct file *file)
 {
+	struct trace_cpu *tc = inode->i_private;
+	struct trace_array *tr = tc->tr;
 	struct trace_iterator *iter;
 	int ret = 0;
 
+	if (trace_array_get(tr) < 0)
+		return -ENODEV;
+
 	/* If this file was open for write, then erase contents */
 	if ((file->f_mode & FMODE_WRITE) &&
 	    (file->f_flags & O_TRUNC)) {
-		struct trace_cpu *tc = inode->i_private;
-		struct trace_array *tr = tc->tr;
-
 		if (tc->cpu == RING_BUFFER_ALL_CPUS)
 			tracing_reset_online_cpus(&tr->trace_buffer);
 		else
@@ -2994,12 +3028,16 @@ static int tracing_open(struct inode *inode, struct file *file)
 	}
 
 	if (file->f_mode & FMODE_READ) {
-		iter = __tracing_open(inode, file, false);
+		iter = __tracing_open(tr, tc, inode, file, false);
 		if (IS_ERR(iter))
 			ret = PTR_ERR(iter);
 		else if (trace_flags & TRACE_ITER_LATENCY_FMT)
 			iter->iter_flags |= TRACE_FILE_LAT_FMT;
 	}
+
+	if (ret < 0)
+		trace_array_put(tr);
+
 	return ret;
 }
 
@@ -4575,12 +4613,16 @@ struct ftrace_buffer_info {
 static int tracing_snapshot_open(struct inode *inode, struct file *file)
 {
 	struct trace_cpu *tc = inode->i_private;
+	struct trace_array *tr = tc->tr;
 	struct trace_iterator *iter;
 	struct seq_file *m;
 	int ret = 0;
 
+	if (trace_array_get(tr) < 0)
+		return -ENODEV;
+
 	if (file->f_mode & FMODE_READ) {
-		iter = __tracing_open(inode, file, true);
+		iter = __tracing_open(tr, tc, inode, file, true);
 		if (IS_ERR(iter))
 			ret = PTR_ERR(iter);
 	} else {
@@ -4593,13 +4635,16 @@ static int tracing_snapshot_open(struct inode *inode, struct file *file)
 			kfree(m);
 			return -ENOMEM;
 		}
-		iter->tr = tc->tr;
+		iter->tr = tr;
 		iter->trace_buffer = &tc->tr->max_buffer;
 		iter->cpu_file = tc->cpu;
 		m->private = iter;
 		file->private_data = m;
 	}
 
+	if (ret < 0)
+		trace_array_put(tr);
+
 	return ret;
 }
 
@@ -4680,9 +4725,12 @@ out:
 static int tracing_snapshot_release(struct inode *inode, struct file *file)
 {
 	struct seq_file *m = file->private_data;
+	int ret;
+
+	ret = tracing_release(inode, file);
 
 	if (file->f_mode & FMODE_READ)
-		return tracing_release(inode, file);
+		return ret;
 
 	/* If write only, the seq_file is just a stub */
 	if (m)
@@ -4927,8 +4975,7 @@ static int tracing_buffers_release(struct inode *inode, struct file *file)
 
 	mutex_lock(&trace_types_lock);
 
-	WARN_ON(!iter->tr->ref);
-	iter->tr->ref--;
+	trace_array_put(iter->tr);
 
 	if (info->spare)
 		ring_buffer_free_read_page(iter->trace_buffer->buffer, info->spare);



