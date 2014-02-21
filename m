Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753585AbaBUCuO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 21:50:14 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:23969 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753196AbaBUCuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 21:50:04 -0500
Message-Id: <20140221025002.237178082@goodmis.org>
User-Agent: quilt/0.61-1
Date: Thu, 20 Feb 2014 21:49:14 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [for-next][PATCH 08/18] tracing: Convert tracer->enabled to counter
References: <20140221024906.901631810@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0008-tracing-Convert-tracer-enabled-to-counter.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

As tracers will soon be used by instances, the tracer enabled field
needs to be converted to a counter instead of a boolean.
This counter is protected by the trace_types_lock mutex.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c | 6 +++---
 kernel/trace/trace.h | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 7d5913b..f9f22c4 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3916,7 +3916,7 @@ static void tracing_set_nop(struct trace_array *tr)
 	if (tr->current_trace == &nop_trace)
 		return;
 	
-	tr->current_trace->enabled = false;
+	tr->current_trace->enabled--;
 
 	if (tr->current_trace->reset)
 		tr->current_trace->reset(tr);
@@ -3962,7 +3962,7 @@ static int tracing_set_tracer(struct trace_array *tr, const char *buf)
 
 	trace_branch_disable();
 
-	tr->current_trace->enabled = false;
+	tr->current_trace->enabled--;
 
 	if (tr->current_trace->reset)
 		tr->current_trace->reset(tr);
@@ -4006,7 +4006,7 @@ static int tracing_set_tracer(struct trace_array *tr, const char *buf)
 	}
 
 	tr->current_trace = t;
-	tr->current_trace->enabled = true;
+	tr->current_trace->enabled++;
 	trace_branch_enable(tr);
  out:
 	mutex_unlock(&trace_types_lock);
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index ea51bb2..86915b2 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -362,8 +362,8 @@ struct tracer {
 						u32 mask, int set);
 	struct tracer		*next;
 	struct tracer_flags	*flags;
+	int			enabled;
 	bool			print_max;
-	bool			enabled;
 	bool			allow_instances;
 #ifdef CONFIG_TRACER_MAX_TRACE
 	bool			use_max_tr;
-- 
1.8.5.3


