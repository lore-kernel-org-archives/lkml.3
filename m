Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760299Ab3CHDHj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 22:07:39 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3964 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760248Ab3CHDGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 22:06:55 -0500
X-Authority-Analysis: v=2.0 cv=UN5f7Vjy c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=SaSIVplWfVwA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=K7jld6d34YwA:10 a=20KFwNOVAAAA:8 a=VxNaj05gS5OQRKib-CoA:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130308030653.412366133@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 07 Mar 2013 22:00:08 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>, hcochran@lexmark.com,
        Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
Subject: [for-next][PATCH 10/17] tracing: Have trace_array keep track if snapshot buffer is allocated
References: <20130308025958.501479677@goodmis.org>
Content-Disposition: inline; filename=0010-tracing-Have-trace_array-keep-track-if-snapshot-buff.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <srostedt@redhat.com>

The snapshot buffer belongs to the trace array not the tracer that is
running. The trace array should be the data structure that keeps track
of whether or not the snapshot buffer is allocated, not the tracer
desciptor. Having the trace array keep track of it makes modifications
so much easier.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |   32 +++++++++++++++-----------------
 kernel/trace/trace.h |    2 +-
 2 files changed, 16 insertions(+), 18 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index e5ce4dd..3213f1e 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -667,7 +667,7 @@ update_max_tr(struct trace_array *tr, struct task_struct *tsk, int cpu)
 
 	WARN_ON_ONCE(!irqs_disabled());
 
-	if (!tr->current_trace->allocated_snapshot) {
+	if (!tr->allocated_snapshot) {
 		/* Only the nop tracer should hit this when disabling */
 		WARN_ON_ONCE(tr->current_trace != &nop_trace);
 		return;
@@ -699,7 +699,7 @@ update_max_tr_single(struct trace_array *tr, struct task_struct *tsk, int cpu)
 		return;
 
 	WARN_ON_ONCE(!irqs_disabled());
-	if (WARN_ON_ONCE(!tr->current_trace->allocated_snapshot))
+	if (WARN_ON_ONCE(!tr->allocated_snapshot))
 		return;
 
 	arch_spin_lock(&ftrace_max_lock);
@@ -801,7 +801,7 @@ int register_tracer(struct tracer *type)
 			if (ring_buffer_expanded)
 				ring_buffer_resize(tr->max_buffer.buffer, trace_buf_size,
 						   RING_BUFFER_ALL_CPUS);
-			type->allocated_snapshot = true;
+			tr->allocated_snapshot = true;
 		}
 #endif
 
@@ -821,7 +821,7 @@ int register_tracer(struct tracer *type)
 
 #ifdef CONFIG_TRACER_MAX_TRACE
 		if (type->use_max_tr) {
-			type->allocated_snapshot = false;
+			tr->allocated_snapshot = false;
 
 			/* Shrink the max buffer again */
 			if (ring_buffer_expanded)
@@ -2462,7 +2462,7 @@ static void show_snapshot_percpu_help(struct seq_file *m)
 
 static void print_snapshot_help(struct seq_file *m, struct trace_iterator *iter)
 {
-	if (iter->trace->allocated_snapshot)
+	if (iter->tr->allocated_snapshot)
 		seq_printf(m, "#\n# * Snapshot is allocated *\n#\n");
 	else
 		seq_printf(m, "#\n# * Snapshot is freed *\n#\n");
@@ -3336,12 +3336,12 @@ static int tracing_set_tracer(const char *buf)
 	if (tr->current_trace->reset)
 		tr->current_trace->reset(tr);
 
-#ifdef CONFIG_TRACER_MAX_TRACE
-	had_max_tr = tr->current_trace->allocated_snapshot;
-
 	/* Current trace needs to be nop_trace before synchronize_sched */
 	tr->current_trace = &nop_trace;
 
+#ifdef CONFIG_TRACER_MAX_TRACE
+	had_max_tr = tr->allocated_snapshot;
+
 	if (had_max_tr && !t->use_max_tr) {
 		/*
 		 * We need to make sure that the update_max_tr sees that
@@ -3359,10 +3359,8 @@ static int tracing_set_tracer(const char *buf)
 		ring_buffer_resize(tr->max_buffer.buffer, 1, RING_BUFFER_ALL_CPUS);
 		set_buffer_entries(&tr->max_buffer, 1);
 		tracing_reset_online_cpus(&tr->max_buffer);
-		tr->current_trace->allocated_snapshot = false;
+		tr->allocated_snapshot = false;
 	}
-#else
-	tr->current_trace = &nop_trace;
 #endif
 	destroy_trace_option_files(topts);
 
@@ -3375,7 +3373,7 @@ static int tracing_set_tracer(const char *buf)
 						   RING_BUFFER_ALL_CPUS);
 		if (ret < 0)
 			goto out;
-		t->allocated_snapshot = true;
+		tr->allocated_snapshot = true;
 	}
 #endif
 
@@ -4246,13 +4244,13 @@ tracing_snapshot_write(struct file *filp, const char __user *ubuf, size_t cnt,
 			ret = -EINVAL;
 			break;
 		}
-		if (tr->current_trace->allocated_snapshot) {
+		if (tr->allocated_snapshot) {
 			/* free spare buffer */
 			ring_buffer_resize(tr->max_buffer.buffer, 1,
 					   RING_BUFFER_ALL_CPUS);
 			set_buffer_entries(&tr->max_buffer, 1);
 			tracing_reset_online_cpus(&tr->max_buffer);
-			tr->current_trace->allocated_snapshot = false;
+			tr->allocated_snapshot = false;
 		}
 		break;
 	case 1:
@@ -4263,13 +4261,13 @@ tracing_snapshot_write(struct file *filp, const char __user *ubuf, size_t cnt,
 			break;
 		}
 #endif
-		if (!tr->current_trace->allocated_snapshot) {
+		if (!tr->allocated_snapshot) {
 			/* allocate spare buffer */
 			ret = resize_buffer_duplicate_size(&tr->max_buffer,
 					&tr->trace_buffer, RING_BUFFER_ALL_CPUS);
 			if (ret < 0)
 				break;
-			tr->current_trace->allocated_snapshot = true;
+			tr->allocated_snapshot = true;
 		}
 		local_irq_disable();
 		/* Now, we're going to swap */
@@ -4280,7 +4278,7 @@ tracing_snapshot_write(struct file *filp, const char __user *ubuf, size_t cnt,
 		local_irq_enable();
 		break;
 	default:
-		if (tr->current_trace->allocated_snapshot) {
+		if (tr->allocated_snapshot) {
 			if (iter->cpu_file == RING_BUFFER_ALL_CPUS)
 				tracing_reset_online_cpus(&tr->max_buffer);
 			else
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 18f7403..6111933 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -197,6 +197,7 @@ struct trace_array {
 	 * the trace_buffer so the tracing can continue.
 	 */
 	struct trace_buffer	max_buffer;
+	bool			allocated_snapshot;
 #endif
 	int			buffer_disabled;
 	struct trace_cpu	trace_cpu;	/* place holder */
@@ -363,7 +364,6 @@ struct tracer {
 	bool			print_max;
 #ifdef CONFIG_TRACER_MAX_TRACE
 	bool			use_max_tr;
-	bool			allocated_snapshot;
 #endif
 };
 
-- 
1.7.10.4


