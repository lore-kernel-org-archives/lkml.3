Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758848AbaELPMN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 11:12:13 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:63058 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758454AbaELPMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 11:12:05 -0400
Message-Id: <20140512151203.259054286@goodmis.org>
User-Agent: quilt/0.61-1
Date: Mon, 12 May 2014 11:11:34 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [for-next][PATCH 04/13] tracing: Add trace_<tracepoint>_enabled() function
References: <20140512151130.345864843@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0004-tracing-Add-trace_-tracepoint-_enabled-function.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

There are some code paths in the kernel that need to do some preparations
before it calls a tracepoint. As that code is worthless overhead when
the tracepoint is not enabled, it would be prudent to have that code
only run when the tracepoint is active. To accomplish this, all tracepoints
now get a static inline function called "trace_<tracepoint-name>_enabled()"
which returns true when the tracepoint is enabled and false otherwise.

As an added bonus, that function uses the static_key of the tracepoint
such that no branch is needed.

  if (trace_mytracepoint_enabled()) {
	arg = process_tp_arg();
	trace_mytracepoint(arg);
  }

Will keep the "process_tp_arg()" (which may be expensive to run) from
being executed when the tracepoint isn't enabled.

It's best to encapsulate the tracepoint itself in the if statement
just to keep races. For example, if you had:

  if (trace_mytracepoint_enabled())
	arg = process_tp_arg();
  trace_mytracepoint(arg);

There's a chance that the tracepoint could be enabled just after the
if statement, and arg will be undefined when calling the tracepoint.

Link: http://lkml.kernel.org/r/20140506094407.507b6435@gandalf.local.home

Acked-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 Documentation/trace/tracepoints.txt | 24 ++++++++++++++++++++++++
 include/linux/tracepoint.h          | 10 ++++++++++
 2 files changed, 34 insertions(+)

diff --git a/Documentation/trace/tracepoints.txt b/Documentation/trace/tracepoints.txt
index 6b018b5..a3efac6 100644
--- a/Documentation/trace/tracepoints.txt
+++ b/Documentation/trace/tracepoints.txt
@@ -115,6 +115,30 @@ If the tracepoint has to be used in kernel modules, an
 EXPORT_TRACEPOINT_SYMBOL_GPL() or EXPORT_TRACEPOINT_SYMBOL() can be
 used to export the defined tracepoints.
 
+If you need to do a bit of work for a tracepoint parameter, and
+that work is only used for the tracepoint, that work can be encapsulated
+within an if statement with the following:
+
+	if (trace_foo_bar_enabled()) {
+		int i;
+		int tot = 0;
+
+		for (i = 0; i < count; i++)
+			tot += calculate_nuggets();
+
+		trace_foo_bar(tot);
+	}
+
+All trace_<tracepoint>() calls have a matching trace_<tracepoint>_enabled()
+function defined that returns true if the tracepoint is enabled and
+false otherwise. The trace_<tracepoint>() should always be within the
+block of the if (trace_<tracepoint>_enabled()) to prevent races between
+the tracepoint being enabled and the check being seen.
+
+The advantage of using the trace_<tracepoint>_enabled() is that it uses
+the static_key of the tracepoint to allow the if statement to be implemented
+with jump labels and avoid conditional branches.
+
 Note: The convenience macro TRACE_EVENT provides an alternative way to
       define tracepoints. Check http://lwn.net/Articles/379903,
       http://lwn.net/Articles/381064 and http://lwn.net/Articles/383362
diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index 9d30ee4..2e2a5f7 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -185,6 +185,11 @@ extern void syscall_unregfunc(void);
 	static inline void						\
 	check_trace_callback_type_##name(void (*cb)(data_proto))	\
 	{								\
+	}								\
+	static inline bool						\
+	trace_##name##_enabled(void)					\
+	{								\
+		return static_key_false(&__tracepoint_##name.key);	\
 	}
 
 /*
@@ -230,6 +235,11 @@ extern void syscall_unregfunc(void);
 	}								\
 	static inline void check_trace_callback_type_##name(void (*cb)(data_proto)) \
 	{								\
+	}								\
+	static inline bool						\
+	trace_##name##_enabled(void)					\
+	{								\
+		return false;						\
 	}
 
 #define DEFINE_TRACE_FN(name, reg, unreg)
-- 
1.8.5.3


