Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055AbbAOEFM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 23:05:12 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:43732 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751072AbbAOEFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 23:05:08 -0500
Message-Id: <20150115040506.216066449@goodmis.org>
User-Agent: quilt/0.61-1
Date: Wed, 14 Jan 2015 23:04:09 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 2/2] tracing: Fix enabling of syscall events on the command line
References: <20150115040407.859948617@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0002-tracing-Fix-enabling-of-syscall-events-on-the-comman.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Commit 5f893b2639b2 "tracing: Move enabling tracepoints to just after
rcu_init()" broke the enabling of system call events from the command
line. The reason was that the enabling of command line trace events
was moved before PID 1 started, and the syscall tracepoints require
that all tasks have the TIF_SYSCALL_TRACEPOINT flag set. But the
swapper task (pid 0) is not part of that. Since the swapper task is the
only task that is running at this early in boot, no task gets the
flag set, and the tracepoint never gets reached.

Instead of setting the swapper task flag (there should be no reason to
do that), re-enabled trace events again after the init thread (PID 1)
has been started. It requires disabling all command line events and
re-enabling them, as just enabling them again will not reset the logic
to set the TIF_SYSCALL_TRACEPOINT flag, as the syscall tracepoint will
be fooled into thinking that it was already set, and wont try setting
it again. For this reason, we must first disable it and re-enable it.

Link: http://lkml.kernel.org/r/1421188517-18312-1-git-send-email-mpe@ellerman.id.au

Reported-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_events.c | 69 ++++++++++++++++++++++++++++++++++++---------
 1 file changed, 55 insertions(+), 14 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 366a78a3e61e..b03a0ea77b99 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -2429,12 +2429,39 @@ static __init int event_trace_memsetup(void)
 	return 0;
 }
 
+static __init void
+early_enable_events(struct trace_array *tr, bool disable_first)
+{
+	char *buf = bootup_event_buf;
+	char *token;
+	int ret;
+
+	while (true) {
+		token = strsep(&buf, ",");
+
+		if (!token)
+			break;
+		if (!*token)
+			continue;
+
+		/* Restarting syscalls requires that we stop them first */
+		if (disable_first)
+			ftrace_set_clr_event(tr, token, 0);
+
+		ret = ftrace_set_clr_event(tr, token, 1);
+		if (ret)
+			pr_warn("Failed to enable trace event: %s\n", token);
+
+		/* Put back the comma to allow this to be called again */
+		if (buf)
+			*(buf - 1) = ',';
+	}
+}
+
 static __init int event_trace_enable(void)
 {
 	struct trace_array *tr = top_trace_array();
 	struct ftrace_event_call **iter, *call;
-	char *buf = bootup_event_buf;
-	char *token;
 	int ret;
 
 	if (!tr)
@@ -2456,18 +2483,7 @@ static __init int event_trace_enable(void)
 	 */
 	__trace_early_add_events(tr);
 
-	while (true) {
-		token = strsep(&buf, ",");
-
-		if (!token)
-			break;
-		if (!*token)
-			continue;
-
-		ret = ftrace_set_clr_event(tr, token, 1);
-		if (ret)
-			pr_warn("Failed to enable trace event: %s\n", token);
-	}
+	early_enable_events(tr, false);
 
 	trace_printk_start_comm();
 
@@ -2478,6 +2494,31 @@ static __init int event_trace_enable(void)
 	return 0;
 }
 
+/*
+ * event_trace_enable() is called from trace_event_init() first to
+ * initialize events and perhaps start any events that are on the
+ * command line. Unfortunately, there are some events that will not
+ * start this early, like the system call tracepoints that need
+ * to set the TIF_SYSCALL_TRACEPOINT flag of pid 1. But event_trace_enable()
+ * is called before pid 1 starts, and this flag is never set, making
+ * the syscall tracepoint never get reached, but the event is enabled
+ * regardless (and not doing anything).
+ */
+static __init int event_trace_enable_again(void)
+{
+	struct trace_array *tr;
+
+	tr = top_trace_array();
+	if (!tr)
+		return -ENODEV;
+
+	early_enable_events(tr, true);
+
+	return 0;
+}
+
+early_initcall(event_trace_enable_again);
+
 static __init int event_trace_init(void)
 {
 	struct trace_array *tr;
-- 
2.1.4


