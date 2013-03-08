Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933718Ab3CHDHf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 22:07:35 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9297 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760299Ab3CHDG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 22:06:56 -0500
X-Authority-Analysis: v=2.0 cv=adbjbGUt c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=hd98IgIrO8oA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=tAl8DGZmHx4A:10 a=20KFwNOVAAAA:8 a=Agr4A8TZ1DVb-p-7BSEA:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130308030654.575531833@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 07 Mar 2013 22:00:15 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>, hcochran@lexmark.com,
        Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
Subject: [for-next][PATCH 17/17] tracing: Move the tracing selftest code into its own function
References: <20130308025958.501479677@goodmis.org>
Content-Disposition: inline; filename=0017-tracing-Move-the-tracing-selftest-code-into-its-own-.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <srostedt@redhat.com>

Move the tracing startup selftest code into its own function and
when not enabled, always have that function succeed.

This makes the register_tracer() function much more readable.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |  124 ++++++++++++++++++++++++++++----------------------
 1 file changed, 69 insertions(+), 55 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index c15ba8b..86a6d7a 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -817,6 +817,72 @@ static void default_wait_pipe(struct trace_iterator *iter)
 	ring_buffer_wait(iter->trace_buffer->buffer, iter->cpu_file);
 }
 
+#ifdef CONFIG_FTRACE_STARTUP_TEST
+static int run_tracer_selftest(struct tracer *type)
+{
+	struct trace_array *tr = &global_trace;
+	struct tracer *saved_tracer = tr->current_trace;
+	int ret;
+
+	if (!type->selftest || tracing_selftest_disabled)
+		return 0;
+
+	/*
+	 * Run a selftest on this tracer.
+	 * Here we reset the trace buffer, and set the current
+	 * tracer to be this tracer. The tracer can then run some
+	 * internal tracing to verify that everything is in order.
+	 * If we fail, we do not register this tracer.
+	 */
+	tracing_reset_online_cpus(&tr->trace_buffer);
+
+	tr->current_trace = type;
+
+#ifdef CONFIG_TRACER_MAX_TRACE
+	if (type->use_max_tr) {
+		/* If we expanded the buffers, make sure the max is expanded too */
+		if (ring_buffer_expanded)
+			ring_buffer_resize(tr->max_buffer.buffer, trace_buf_size,
+					   RING_BUFFER_ALL_CPUS);
+		tr->allocated_snapshot = true;
+	}
+#endif
+
+	/* the test is responsible for initializing and enabling */
+	pr_info("Testing tracer %s: ", type->name);
+	ret = type->selftest(type, tr);
+	/* the test is responsible for resetting too */
+	tr->current_trace = saved_tracer;
+	if (ret) {
+		printk(KERN_CONT "FAILED!\n");
+		/* Add the warning after printing 'FAILED' */
+		WARN_ON(1);
+		return -1;
+	}
+	/* Only reset on passing, to avoid touching corrupted buffers */
+	tracing_reset_online_cpus(&tr->trace_buffer);
+
+#ifdef CONFIG_TRACER_MAX_TRACE
+	if (type->use_max_tr) {
+		tr->allocated_snapshot = false;
+
+		/* Shrink the max buffer again */
+		if (ring_buffer_expanded)
+			ring_buffer_resize(tr->max_buffer.buffer, 1,
+					   RING_BUFFER_ALL_CPUS);
+	}
+#endif
+
+	printk(KERN_CONT "PASSED\n");
+	return 0;
+}
+#else
+static inline int run_tracer_selftest(struct tracer *type)
+{
+	return 0;
+}
+#endif /* CONFIG_FTRACE_STARTUP_TEST */
+
 /**
  * register_tracer - register a tracer with the ftrace system.
  * @type - the plugin for the tracer
@@ -862,61 +928,9 @@ int register_tracer(struct tracer *type)
 	if (!type->wait_pipe)
 		type->wait_pipe = default_wait_pipe;
 
-
-#ifdef CONFIG_FTRACE_STARTUP_TEST
-	if (type->selftest && !tracing_selftest_disabled) {
-		struct trace_array *tr = &global_trace;
-		struct tracer *saved_tracer = tr->current_trace;
-
-		/*
-		 * Run a selftest on this tracer.
-		 * Here we reset the trace buffer, and set the current
-		 * tracer to be this tracer. The tracer can then run some
-		 * internal tracing to verify that everything is in order.
-		 * If we fail, we do not register this tracer.
-		 */
-		tracing_reset_online_cpus(&tr->trace_buffer);
-
-		tr->current_trace = type;
-
-#ifdef CONFIG_TRACER_MAX_TRACE
-		if (type->use_max_tr) {
-			/* If we expanded the buffers, make sure the max is expanded too */
-			if (ring_buffer_expanded)
-				ring_buffer_resize(tr->max_buffer.buffer, trace_buf_size,
-						   RING_BUFFER_ALL_CPUS);
-			tr->allocated_snapshot = true;
-		}
-#endif
-
-		/* the test is responsible for initializing and enabling */
-		pr_info("Testing tracer %s: ", type->name);
-		ret = type->selftest(type, tr);
-		/* the test is responsible for resetting too */
-		tr->current_trace = saved_tracer;
-		if (ret) {
-			printk(KERN_CONT "FAILED!\n");
-			/* Add the warning after printing 'FAILED' */
-			WARN_ON(1);
-			goto out;
-		}
-		/* Only reset on passing, to avoid touching corrupted buffers */
-		tracing_reset_online_cpus(&tr->trace_buffer);
-
-#ifdef CONFIG_TRACER_MAX_TRACE
-		if (type->use_max_tr) {
-			tr->allocated_snapshot = false;
-
-			/* Shrink the max buffer again */
-			if (ring_buffer_expanded)
-				ring_buffer_resize(tr->max_buffer.buffer, 1,
-						   RING_BUFFER_ALL_CPUS);
-		}
-#endif
-
-		printk(KERN_CONT "PASSED\n");
-	}
-#endif
+	ret = run_tracer_selftest(type);
+	if (ret < 0)
+		goto out;
 
 	type->next = trace_types;
 	trace_types = type;
-- 
1.7.10.4


