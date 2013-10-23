Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585Ab3JWStw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 14:49:52 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:36958 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752119Ab3JWStv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 14:49:51 -0400
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: [PATCH] ftrace: open tracer when ftrace_dump_on_oops is used
Date: Wed, 23 Oct 2013 11:49:57 -0700
Message-Id: <1382554197-16961-1-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13102318-7182-0000-0000-000008DCCE20
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With ftrace_dump_on_oops, we previously did not open the tracer in
question, sometimes causing the trace output to be useless.

For example, the function_graph tracer with tracing_thresh set dumped via ftrace_dump_on_oops
would show a series of '}' indented at different levels, but no function
names.

call trace->open() (and do a few other fixups copied from the normal dump
path) to make the output more intelligible.

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 kernel/trace/trace.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 7974ba2..18a1b61 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -6253,6 +6253,17 @@ void trace_init_global_iter(struct trace_iterator *iter)
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
1.8.1.5

