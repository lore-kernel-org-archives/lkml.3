Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753002Ab3CJPgl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 11:36:41 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:14857 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471Ab3CJPfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 11:35:30 -0400
X-Authority-Analysis: v=2.0 cv=BZhaI8R2 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=XWINSMWMnq4A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=45FX6mHFRCsA:10 a=i-_nWqZxkHUsQx0h1QQA:9 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130310153527.810267590@goodmis.org>
User-Agent: quilt/0.60-1
Date: Sun, 10 Mar 2013 11:27:56 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [for-next][PATCH 4/4] tracing: Let tracing_snapshot() be used by modules but not NMI
References: <20130310152752.848922120@goodmis.org>
Content-Disposition: inline; filename=0004-tracing-Let-tracing_snapshot-be-used-by-modules-but-.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Add EXPORT_SYMBOL_GPL() to let the tracing_snapshot() functions be
called from modules.

Also add a test to see if the snapshot was called from NMI context
and just warn in the tracing buffer if so, and return.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index fa740e5..feb6592 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -442,6 +442,12 @@ void tracing_snapshot(void)
 	struct tracer *tracer = tr->current_trace;
 	unsigned long flags;
 
+	if (in_nmi()) {
+		internal_trace_puts("*** SNAPSHOT CALLED FROM NMI CONTEXT ***\n");
+		internal_trace_puts("*** snapshot is being ignored        ***\n");
+		return;
+	}
+
 	if (!tr->allocated_snapshot) {
 		internal_trace_puts("*** SNAPSHOT NOT ALLOCATED ***\n");
 		internal_trace_puts("*** stopping trace here!   ***\n");
@@ -460,6 +466,7 @@ void tracing_snapshot(void)
 	update_max_tr(tr, current, smp_processor_id());
 	local_irq_restore(flags);
 }
+EXPORT_SYMBOL_GPL(tracing_snapshot);
 
 static int resize_buffer_duplicate_size(struct trace_buffer *trace_buf,
 					struct trace_buffer *size_buf, int cpu_id);
@@ -493,16 +500,19 @@ void tracing_snapshot_alloc(void)
 
 	tracing_snapshot();
 }
+EXPORT_SYMBOL_GPL(tracing_snapshot_alloc);
 #else
 void tracing_snapshot(void)
 {
 	WARN_ONCE(1, "Snapshot feature not enabled, but internal snapshot used");
 }
+EXPORT_SYMBOL_GPL(tracing_snapshot);
 void tracing_snapshot_alloc(void)
 {
 	/* Give warning */
 	tracing_snapshot();
 }
+EXPORT_SYMBOL_GPL(tracing_snapshot_alloc);
 #endif /* CONFIG_TRACER_SNAPSHOT */
 
 /**
-- 
1.7.10.4


