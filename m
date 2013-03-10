Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752939Ab3CJPfc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 11:35:32 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:14857 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110Ab3CJPf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 11:35:29 -0400
X-Authority-Analysis: v=2.0 cv=BZhaI8R2 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=bu3JpdXqkncA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=Obl0dpaqZIkA:10 a=ayC55rCoAAAA:8 a=RvlEQHu-AAAA:8 a=sYnQeex4rygA90x1-vsA:9 a=E6k37eg1NvgA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130310153527.656440417@goodmis.org>
User-Agent: quilt/0.60-1
Date: Sun, 10 Mar 2013 11:27:55 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [for-next][PATCH 3/4] tracing: Add internal ftrace trace_puts() for ftrace to use
References: <20130310152752.848922120@goodmis.org>
Content-Disposition: inline; filename=0003-tracing-Add-internal-ftrace-trace_puts-for-ftrace-to.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

There's a few places that ftrace uses trace_printk() for internal
use, but this requires context (normal, softirq, irq, NMI) buffers
to keep things lockless. But the trace_puts() does not, as it can
write the string directly into the ring buffer. Make a internal helper
for trace_puts() and have the internal functions use that.

This way the extra context buffers are not used.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |    8 ++++----
 kernel/trace/trace.h |   11 +++++++++++
 2 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 1b9a791..fa740e5 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -443,16 +443,16 @@ void tracing_snapshot(void)
 	unsigned long flags;
 
 	if (!tr->allocated_snapshot) {
-		trace_printk("*** SNAPSHOT NOT ALLOCATED ***\n");
-		trace_printk("*** stopping trace here!   ***\n");
+		internal_trace_puts("*** SNAPSHOT NOT ALLOCATED ***\n");
+		internal_trace_puts("*** stopping trace here!   ***\n");
 		tracing_off();
 		return;
 	}
 
 	/* Note, snapshot can not be used when the tracer uses it */
 	if (tracer->use_max_tr) {
-		trace_printk("*** LATENCY TRACER ACTIVE ***\n");
-		trace_printk("*** Can not use snapshot (sorry) ***\n");
+		internal_trace_puts("*** LATENCY TRACER ACTIVE ***\n");
+		internal_trace_puts("*** Can not use snapshot (sorry) ***\n");
 		return;
 	}
 
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 98dd79d..c729843 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -1034,6 +1034,17 @@ extern const char *__stop___trace_bprintk_fmt[];
 void trace_printk_init_buffers(void);
 void trace_printk_start_comm(void);
 
+/*
+ * Normal trace_printk() and friends allocates special buffers
+ * to do the manipulation, as well as saves the print formats
+ * into sections to display. But the trace infrastructure wants
+ * to use these without the added overhead at the price of being
+ * a bit slower (used mainly for warnings, where we don't care
+ * about performance). The internal_trace_puts() is for such
+ * a purpose.
+ */
+#define internal_trace_puts(str) __trace_puts(_THIS_IP_, str, strlen(str))
+
 #undef FTRACE_ENTRY
 #define FTRACE_ENTRY(call, struct_name, id, tstruct, print, filter)	\
 	extern struct ftrace_event_call					\
-- 
1.7.10.4


