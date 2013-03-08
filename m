Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934486Ab3CHSC3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 13:02:29 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11078 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934544Ab3CHSBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 13:01:54 -0500
X-Authority-Analysis: v=2.0 cv=adbjbGUt c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=YkIT88Mh-jEA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=gWVn2Nhwd2QA:10 a=20KFwNOVAAAA:8 a=cPfijV6Vw2AWu7gl63sA:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130308180151.686030613@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 08 Mar 2013 12:59:32 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>, hcochran@lexmark.com,
        Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
Subject: [for-next][PATCH 1/2] tracing: Add alloc_snapshot kernel command line parameter
References: <20130308175931.135352630@goodmis.org>
Content-Disposition: inline; filename=0001-tracing-Add-alloc_snapshot-kernel-command-line-param.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <srostedt@redhat.com>

If debugging the kernel, and the developer wants to use
tracing_snapshot() in places where tracing_snapshot_alloc() may
be difficult (or more likely, the developer is lazy and doesn't
want to bother with tracing_snapshot_alloc() at all), then adding

  alloc_snapshot

to the kernel command line parameter will tell ftrace to allocate
the snapshot buffer (if configured) when it allocates the main
tracing buffer.

I also noticed that ring_buffer_expanded and tracing_selftest_disabled
had inconsistent use of boolean "true" and "false" with "0" and "1".
I cleaned that up too.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 Documentation/kernel-parameters.txt |    7 +++
 kernel/trace/trace.c                |   81 +++++++++++++++++++++--------------
 kernel/trace/trace.h                |    2 +-
 kernel/trace/trace_events.c         |    4 +-
 4 files changed, 58 insertions(+), 36 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 6c72381..0edc409 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -320,6 +320,13 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			on: enable for both 32- and 64-bit processes
 			off: disable for both 32- and 64-bit processes
 
+	alloc_snapshot	[FTRACE]
+			Allocate the ftrace snapshot buffer on boot up when the
+			main buffer is allocated. This is handy if debugging
+			and you need to use tracing_snapshot() on boot up, and
+			do not want to use tracing_snapshot_alloc() as it needs
+			to be done where GFP_KERNEL allocations are allowed.
+
 	amd_iommu=	[HW,X86-64]
 			Pass parameters to the AMD IOMMU driver in the system.
 			Possible values are:
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 86a6d7a..02064f8 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -47,7 +47,7 @@
  * On boot up, the ring buffer is set to the minimum size, so that
  * we do not waste memory on systems that are not using tracing.
  */
-int ring_buffer_expanded;
+bool ring_buffer_expanded;
 
 /*
  * We need to change this state when a selftest is running.
@@ -121,12 +121,14 @@ static int tracing_set_tracer(const char *buf);
 static char bootup_tracer_buf[MAX_TRACER_SIZE] __initdata;
 static char *default_bootup_tracer;
 
+static bool allocate_snapshot;
+
 static int __init set_cmdline_ftrace(char *str)
 {
 	strncpy(bootup_tracer_buf, str, MAX_TRACER_SIZE);
 	default_bootup_tracer = bootup_tracer_buf;
 	/* We are using ftrace early, expand it */
-	ring_buffer_expanded = 1;
+	ring_buffer_expanded = true;
 	return 1;
 }
 __setup("ftrace=", set_cmdline_ftrace);
@@ -147,6 +149,15 @@ static int __init set_ftrace_dump_on_oops(char *str)
 }
 __setup("ftrace_dump_on_oops", set_ftrace_dump_on_oops);
 
+static int __init alloc_snapshot(char *str)
+{
+	allocate_snapshot = true;
+	/* We also need the main ring buffer expanded */
+	ring_buffer_expanded = true;
+	return 1;
+}
+__setup("alloc_snapshot", alloc_snapshot);
+
 
 static char trace_boot_options_buf[MAX_TRACER_SIZE] __initdata;
 static char *trace_boot_options __initdata;
@@ -950,7 +961,7 @@ int register_tracer(struct tracer *type)
 	tracing_set_tracer(type->name);
 	default_bootup_tracer = NULL;
 	/* disable other selftests, since this will break it. */
-	tracing_selftest_disabled = 1;
+	tracing_selftest_disabled = true;
 #ifdef CONFIG_FTRACE_STARTUP_TEST
 	printk(KERN_INFO "Disabling FTRACE selftests due to running tracer '%s'\n",
 	       type->name);
@@ -3293,7 +3304,7 @@ static int __tracing_resize_ring_buffer(struct trace_array *tr,
 	 * we use the size that was given, and we can forget about
 	 * expanding it later.
 	 */
-	ring_buffer_expanded = 1;
+	ring_buffer_expanded = true;
 
 	/* May be called before buffers are initialized */
 	if (!tr->trace_buffer.buffer)
@@ -5360,53 +5371,57 @@ static void init_trace_buffers(struct trace_array *tr, struct trace_buffer *buf)
 	}
 }
 
-static int allocate_trace_buffers(struct trace_array *tr, int size)
+static int
+allocate_trace_buffer(struct trace_array *tr, struct trace_buffer *buf, int size)
 {
 	enum ring_buffer_flags rb_flags;
 
 	rb_flags = trace_flags & TRACE_ITER_OVERWRITE ? RB_FL_OVERWRITE : 0;
 
-	tr->trace_buffer.buffer = ring_buffer_alloc(size, rb_flags);
-	if (!tr->trace_buffer.buffer)
-		goto out_free;
+	buf->buffer = ring_buffer_alloc(size, rb_flags);
+	if (!buf->buffer)
+		return -ENOMEM;
 
-	tr->trace_buffer.data = alloc_percpu(struct trace_array_cpu);
-	if (!tr->trace_buffer.data)
-		goto out_free;
+	buf->data = alloc_percpu(struct trace_array_cpu);
+	if (!buf->data) {
+		ring_buffer_free(buf->buffer);
+		return -ENOMEM;
+	}
 
-	init_trace_buffers(tr, &tr->trace_buffer);
+	init_trace_buffers(tr, buf);
 
 	/* Allocate the first page for all buffers */
 	set_buffer_entries(&tr->trace_buffer,
 			   ring_buffer_size(tr->trace_buffer.buffer, 0));
 
-#ifdef CONFIG_TRACER_MAX_TRACE
-
-	tr->max_buffer.buffer = ring_buffer_alloc(1, rb_flags);
-	if (!tr->max_buffer.buffer)
-		goto out_free;
-
-	tr->max_buffer.data = alloc_percpu(struct trace_array_cpu);
-	if (!tr->max_buffer.data)
-		goto out_free;
+	return 0;
+}
 
-	init_trace_buffers(tr, &tr->max_buffer);
+static int allocate_trace_buffers(struct trace_array *tr, int size)
+{
+	int ret;
 
-	set_buffer_entries(&tr->max_buffer, 1);
-#endif
-	return 0;
+	ret = allocate_trace_buffer(tr, &tr->trace_buffer, size);
+	if (ret)
+		return ret;
 
- out_free:
-	if (tr->trace_buffer.buffer)
+#ifdef CONFIG_TRACER_MAX_TRACE
+	ret = allocate_trace_buffer(tr, &tr->max_buffer,
+				    allocate_snapshot ? size : 1);
+	if (WARN_ON(ret)) {
 		ring_buffer_free(tr->trace_buffer.buffer);
-	free_percpu(tr->trace_buffer.data);
+		free_percpu(tr->trace_buffer.data);
+		return -ENOMEM;
+	}
+	tr->allocated_snapshot = allocate_snapshot;
 
-#ifdef CONFIG_TRACER_MAX_TRACE
-	if (tr->max_buffer.buffer)
-		ring_buffer_free(tr->max_buffer.buffer);
-	free_percpu(tr->max_buffer.data);
+	/*
+	 * Only the top level trace array gets its snapshot allocated
+	 * from the kernel command line.
+	 */
+	allocate_snapshot = false;
 #endif
-	return -ENOMEM;
+	return 0;
 }
 
 static int new_instance_create(const char *name)
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index a19459d..0b7f424 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -656,7 +656,7 @@ extern int DYN_FTRACE_TEST_NAME(void);
 #define DYN_FTRACE_TEST_NAME2 trace_selftest_dynamic_test_func2
 extern int DYN_FTRACE_TEST_NAME2(void);
 
-extern int ring_buffer_expanded;
+extern bool ring_buffer_expanded;
 extern bool tracing_selftest_disabled;
 DECLARE_PER_CPU(int, ftrace_cpu_disabled);
 
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index a376ab5..38b54c5 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -1844,8 +1844,8 @@ static char bootup_event_buf[COMMAND_LINE_SIZE] __initdata;
 static __init int setup_trace_event(char *str)
 {
 	strlcpy(bootup_event_buf, str, COMMAND_LINE_SIZE);
-	ring_buffer_expanded = 1;
-	tracing_selftest_disabled = 1;
+	ring_buffer_expanded = true;
+	tracing_selftest_disabled = true;
 
 	return 1;
 }
-- 
1.7.10.4


