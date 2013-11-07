Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018Ab3KGEBf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 23:01:35 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:38763 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752774Ab3KGEAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 23:00:51 -0500
Message-Id: <20131107040050.054159903@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 06 Nov 2013 23:00:03 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: [for-next][PATCH 1/5] tracing: Open tracer when ftrace_dump_on_oops is used
References: <20131107040002.605895766@goodmis.org>
Content-Disposition: inline; filename=0001-tracing-Open-tracer-when-ftrace_dump_on_oops-is-used.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cody P Schafer <cody@linux.vnet.ibm.com>

With ftrace_dump_on_oops, we previously did not open the tracer in
question, sometimes causing the trace output to be useless.

For example, the function_graph tracer with tracing_thresh set dumped via
ftrace_dump_on_oops would show a series of '}' indented at different levels,
but no function names.

call trace->open() (and do a few other fixups copied from the normal dump
path) to make the output more intelligible.

Link: http://lkml.kernel.org/r/1382554197-16961-1-git-send-email-cody@linux.vnet.ibm.com

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index f9fa42b..eaacd3a 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -6276,6 +6276,17 @@ void trace_init_global_iter(struct trace_iterator *iter)
 	iter->trace = iter->tr->current_trace;
 	iter->cpu_file = RING_BUFFER_ALL_CPUS;
 	iter->trace_buffer = &global_trace.trace_buffer;
+
+	if (iter->trace && iter->trace->open)
+		iter->trace->open(iter);
+
+	/* Annotate start of buffers if we had overruns */
+	if (ring_buffer_overruns(iter->trace_buffer->buffer))
+		iter->iter_flags |= TRACE_FILE_ANNOTATE;
+
+	/* Output in nanoseconds only if we are using a clock in nanoseconds. */
+	if (trace_clocks[iter->tr->clock_id].in_ns)
+		iter->iter_flags |= TRACE_FILE_TIME_IN_NS;
 }
 
 void ftrace_dump(enum ftrace_dump_mode oops_dump_mode)
-- 
1.8.4.rc3


