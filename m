Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751924Ab3F0DBO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 23:01:14 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:33626 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467Ab3F0DBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 23:01:13 -0400
X-Authority-Analysis: v=2.0 cv=Du3UCRD+ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=XqNnylozy48A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=pkicDPhlfI0A:10 a=uXePns0wZaDmEZkvozoA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1372302069.18733.295.camel@gandalf.local.home>
Subject: Re: frequent softlockups with 3.10rc6.
From: Steven Rostedt <rostedt@goodmis.org>
To: Dave Jones <davej@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrey Vagin <avagin@openvz.org>
Date: Wed, 26 Jun 2013 23:01:09 -0400
In-Reply-To: <20130626200003.GB2833@redhat.com>
References: <20130622215905.GA28238@redhat.com>
	 <20130623143634.GA2000@redhat.com> <20130623150603.GA32313@redhat.com>
	 <20130623160452.GA11740@redhat.com> <20130624155758.GA5993@redhat.com>
	 <20130624173510.GA1321@redhat.com> <20130625153520.GA7784@redhat.com>
	 <1372177414.18733.211.camel@gandalf.local.home>
	 <20130626052352.GB31416@redhat.com>
	 <1372276335.18733.271.camel@gandalf.local.home>
	 <20130626200003.GB2833@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-06-26 at 16:00 -0400, Dave Jones wrote:
> On Wed, Jun 26, 2013 at 03:52:15PM -0400, Steven Rostedt wrote:

> Yeah, that's what I meant by "this patch".
> To reduce ambiguity, I mean the one below.. There wasn't another patch
> that I missed right ?
> 

On other patch, but I've found issues with the patch I sent you. This
seems to pass my initial tests, and I'm working to get this into 3.11.
This is still a beta patch.

-- Steve

Index: linux-trace.git/kernel/trace/trace.c
===================================================================
--- linux-trace.git.orig/kernel/trace/trace.c
+++ linux-trace.git/kernel/trace/trace.c
@@ -217,7 +217,13 @@ cycle_t ftrace_now(int cpu)
 
 int tracing_is_enabled(void)
 {
-	return tracing_is_on();
+	/*
+	 * For quick access (irqsoff uses this in fast path), just
+	 * return the mirror variable of the state of the ring buffer.
+	 * It's a little racy, but we don't really care.
+	 */
+	smp_rmb();
+	return !global_trace.buffer_disabled;
 }
 
 /*
@@ -330,6 +336,23 @@ unsigned long trace_flags = TRACE_ITER_P
 	TRACE_ITER_GRAPH_TIME | TRACE_ITER_RECORD_CMD | TRACE_ITER_OVERWRITE |
 	TRACE_ITER_IRQ_INFO | TRACE_ITER_MARKERS | TRACE_ITER_FUNCTION;
 
+void tracer_tracing_on(struct trace_array *tr)
+{
+	if (tr->trace_buffer.buffer)
+		ring_buffer_record_on(tr->trace_buffer.buffer);
+	/*
+	 * This flag is looked at when buffers haven't been allocated
+	 * yet, or by some tracers (like irqsoff), that just want to
+	 * know if the ring buffer has been disabled, but it can handle
+	 * races of where it gets disabled but we still do a record.
+	 * As the check is in the fast path of the tracers, it is more
+	 * important to be fast than accurate.
+	 */
+	tr->buffer_disabled = 0;
+	/* Make the flag seen by readers */
+	smp_wmb();
+}
+
 /**
  * tracing_on - enable tracing buffers
  *
@@ -338,15 +361,7 @@ unsigned long trace_flags = TRACE_ITER_P
  */
 void tracing_on(void)
 {
-	if (global_trace.trace_buffer.buffer)
-		ring_buffer_record_on(global_trace.trace_buffer.buffer);
-	/*
-	 * This flag is only looked at when buffers haven't been
-	 * allocated yet. We don't really care about the race
-	 * between setting this flag and actually turning
-	 * on the buffer.
-	 */
-	global_trace.buffer_disabled = 0;
+	tracer_tracing_on(&global_trace);
 }
 EXPORT_SYMBOL_GPL(tracing_on);
 
@@ -540,6 +555,23 @@ void tracing_snapshot_alloc(void)
 EXPORT_SYMBOL_GPL(tracing_snapshot_alloc);
 #endif /* CONFIG_TRACER_SNAPSHOT */
 
+void tracer_tracing_off(struct trace_array *tr)
+{
+	if (tr->trace_buffer.buffer)
+		ring_buffer_record_off(tr->trace_buffer.buffer);
+	/*
+	 * This flag is looked at when buffers haven't been allocated
+	 * yet, or by some tracers (like irqsoff), that just want to
+	 * know if the ring buffer has been disabled, but it can handle
+	 * races of where it gets disabled but we still do a record.
+	 * As the check is in the fast path of the tracers, it is more
+	 * important to be fast than accurate.
+	 */
+	tr->buffer_disabled = 1;
+	/* Make the flag seen by readers */
+	smp_wmb();
+}
+
 /**
  * tracing_off - turn off tracing buffers
  *
@@ -550,26 +582,23 @@ EXPORT_SYMBOL_GPL(tracing_snapshot_alloc
  */
 void tracing_off(void)
 {
-	if (global_trace.trace_buffer.buffer)
-		ring_buffer_record_off(global_trace.trace_buffer.buffer);
-	/*
-	 * This flag is only looked at when buffers haven't been
-	 * allocated yet. We don't really care about the race
-	 * between setting this flag and actually turning
-	 * on the buffer.
-	 */
-	global_trace.buffer_disabled = 1;
+	tracer_tracing_off(&global_trace);
 }
 EXPORT_SYMBOL_GPL(tracing_off);
 
+int tracer_tracing_is_on(struct trace_array *tr)
+{
+	if (tr->trace_buffer.buffer)
+		return ring_buffer_record_is_on(tr->trace_buffer.buffer);
+	return !tr->buffer_disabled;
+}
+
 /**
  * tracing_is_on - show state of ring buffers enabled
  */
 int tracing_is_on(void)
 {
-	if (global_trace.trace_buffer.buffer)
-		return ring_buffer_record_is_on(global_trace.trace_buffer.buffer);
-	return !global_trace.buffer_disabled;
+	return tracer_tracing_is_on(&global_trace);
 }
 EXPORT_SYMBOL_GPL(tracing_is_on);
 
@@ -3939,7 +3968,7 @@ static int tracing_wait_pipe(struct file
 		 *
 		 * iter->pos will be 0 if we haven't read anything.
 		 */
-		if (!tracing_is_enabled() && iter->pos)
+		if (!tracing_is_on() && iter->pos)
 			break;
 	}
 
@@ -5612,15 +5641,10 @@ rb_simple_read(struct file *filp, char _
 	       size_t cnt, loff_t *ppos)
 {
 	struct trace_array *tr = filp->private_data;
-	struct ring_buffer *buffer = tr->trace_buffer.buffer;
 	char buf[64];
 	int r;
 
-	if (buffer)
-		r = ring_buffer_record_is_on(buffer);
-	else
-		r = 0;
-
+	r = tracer_tracing_is_on(tr);
 	r = sprintf(buf, "%d\n", r);
 
 	return simple_read_from_buffer(ubuf, cnt, ppos, buf, r);
@@ -5642,11 +5666,11 @@ rb_simple_write(struct file *filp, const
 	if (buffer) {
 		mutex_lock(&trace_types_lock);
 		if (val) {
-			ring_buffer_record_on(buffer);
+			tracer_tracing_on(tr);
 			if (tr->current_trace->start)
 				tr->current_trace->start(tr);
 		} else {
-			ring_buffer_record_off(buffer);
+			tracer_tracing_off(tr);
 			if (tr->current_trace->stop)
 				tr->current_trace->stop(tr);
 		}
Index: linux-trace.git/kernel/trace/trace_irqsoff.c
===================================================================
--- linux-trace.git.orig/kernel/trace/trace_irqsoff.c
+++ linux-trace.git/kernel/trace/trace_irqsoff.c
@@ -373,7 +373,7 @@ start_critical_timing(unsigned long ip, 
 	struct trace_array_cpu *data;
 	unsigned long flags;
 
-	if (likely(!tracer_enabled))
+	if (!tracer_enabled || !tracing_is_enabled())
 		return;
 
 	cpu = raw_smp_processor_id();
@@ -416,7 +416,7 @@ stop_critical_timing(unsigned long ip, u
 	else
 		return;
 
-	if (!tracer_enabled)
+	if (!tracer_enabled || !tracing_is_enabled())
 		return;
 
 	data = per_cpu_ptr(tr->trace_buffer.data, cpu);


