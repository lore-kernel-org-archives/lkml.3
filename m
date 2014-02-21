Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754271AbaBUCyD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 21:54:03 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:65424 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753198AbaBUCuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 21:50:05 -0500
Message-Id: <20140221025001.930593103@goodmis.org>
User-Agent: quilt/0.61-1
Date: Thu, 20 Feb 2014 21:49:13 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [for-next][PATCH 07/18] tracing: Disable tracers before deletion of instance
References: <20140221024906.901631810@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0007-tracing-Disable-tracers-before-deletion-of-instance.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

When an instance is about to be deleted, make sure the tracer
is set to nop. If it isn't reset the tracer and set it to the nop
tracer, otherwise memory leaks and bad pointers may result.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index da9543c..7d5913b 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3907,6 +3907,23 @@ create_trace_option_files(struct trace_array *tr, struct tracer *tracer);
 static void
 destroy_trace_option_files(struct trace_option_dentry *topts);
 
+/*
+ * Used to clear out the tracer before deletion of an instance.
+ * Must have trace_types_lock held.
+ */
+static void tracing_set_nop(struct trace_array *tr)
+{
+	if (tr->current_trace == &nop_trace)
+		return;
+	
+	tr->current_trace->enabled = false;
+
+	if (tr->current_trace->reset)
+		tr->current_trace->reset(tr);
+
+	tr->current_trace = &nop_trace;
+}
+
 static int tracing_set_tracer(struct trace_array *tr, const char *buf)
 {
 	static struct trace_option_dentry *topts;
@@ -6142,6 +6159,7 @@ static int instance_delete(const char *name)
 
 	list_del(&tr->list);
 
+	tracing_set_nop(tr);
 	event_trace_del_tracer(tr);
 	debugfs_remove_recursive(tr->dir);
 	free_percpu(tr->trace_buffer.data);
-- 
1.8.5.3


