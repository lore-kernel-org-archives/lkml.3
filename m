Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752710Ab3AWUgm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 15:36:42 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:2630 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752385Ab3AWUef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 15:34:35 -0500
X-Authority-Analysis: v=2.0 cv=C91rOHz+ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=KtPEdWiZLOUA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=bdNd1Uk4a1kA:10 a=20KFwNOVAAAA:8 a=QxEWDUaOJZZrx0UaQdUA:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130123203433.577180026@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 23 Jan 2013 15:30:04 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 02/12 -next] tracing: Fix race with max_tr and changing tracers
References: <20130123203002.957226869@goodmis.org>
Content-Disposition: inline; filename=0002-tracing-Fix-race-with-max_tr-and-changing-tracers.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

There's a race condition between the setting of a new tracer and
the update of the max trace buffers (the swap). When a new tracer
is added, it sets current_trace to nop_trace before disabling
the old tracer. At this moment, if the old tracer uses update_max_tr(),
the update may trigger the warning against !current_trace->use_max-tr,
as nop_trace doesn't have that set.

As update_max_tr() requires that interrupts be disabled, we can
add a check to see if current_trace == nop_trace and bail if it
does. Then when disabling the current_trace, set it to nop_trace
and run synchronize_sched(). This will make sure all calls to
update_max_tr() have completed (it was called with interrupts disabled).

As a clean up, this commit also removes shrinking and recreating
the max_tr buffer if the old and new tracers both have use_max_tr set.
The old way use to always shrink the buffer, and then expand it
for the next tracer. This is a waste of time.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |   29 ++++++++++++++++++++++-------
 1 file changed, 22 insertions(+), 7 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index a387bd2..d2a6583 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -709,10 +709,14 @@ update_max_tr(struct trace_array *tr, struct task_struct *tsk, int cpu)
 		return;
 
 	WARN_ON_ONCE(!irqs_disabled());
-	if (!current_trace->use_max_tr) {
-		WARN_ON_ONCE(1);
+
+	/* If we disabled the tracer, stop now */
+	if (current_trace == &nop_trace)
 		return;
-	}
+
+	if (WARN_ON_ONCE(!current_trace->use_max_tr))
+		return;
+
 	arch_spin_lock(&ftrace_max_lock);
 
 	tr->buffer = max_tr.buffer;
@@ -3185,6 +3189,7 @@ static int tracing_set_tracer(const char *buf)
 	static struct trace_option_dentry *topts;
 	struct trace_array *tr = &global_trace;
 	struct tracer *t;
+	bool had_max_tr;
 	int ret = 0;
 
 	mutex_lock(&trace_types_lock);
@@ -3211,7 +3216,19 @@ static int tracing_set_tracer(const char *buf)
 	trace_branch_disable();
 	if (current_trace && current_trace->reset)
 		current_trace->reset(tr);
-	if (current_trace && current_trace->use_max_tr) {
+
+	had_max_tr = current_trace && current_trace->use_max_tr;
+	current_trace = &nop_trace;
+
+	if (had_max_tr && !t->use_max_tr) {
+		/*
+		 * We need to make sure that the update_max_tr sees that
+		 * current_trace changed to nop_trace to keep it from
+		 * swapping the buffers after we resize it.
+		 * The update_max_tr is called from interrupts disabled
+		 * so a synchronized_sched() is sufficient.
+		 */
+		synchronize_sched();
 		/*
 		 * We don't free the ring buffer. instead, resize it because
 		 * The max_tr ring buffer has some state (e.g. ring->clock) and
@@ -3222,10 +3239,8 @@ static int tracing_set_tracer(const char *buf)
 	}
 	destroy_trace_option_files(topts);
 
-	current_trace = &nop_trace;
-
 	topts = create_trace_option_files(t);
-	if (t->use_max_tr) {
+	if (t->use_max_tr && !had_max_tr) {
 		/* we need to make per cpu buffer sizes equivalent */
 		ret = resize_buffer_duplicate_size(&max_tr, &global_trace,
 						   RING_BUFFER_ALL_CPUS);
-- 
1.7.10.4


