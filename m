Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310AbaBUCuG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 21:50:06 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:23969 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753185AbaBUCuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 21:50:03 -0500
Message-Id: <20140221025001.199452871@goodmis.org>
User-Agent: quilt/0.61-1
Date: Thu, 20 Feb 2014 21:49:08 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [for-next][PATCH 02/18] tracing: Pass trace_array to flag_changed callback
References: <20140221024906.901631810@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0002-tracing-Pass-trace_array-to-flag_changed-callback.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

As options (flags) may affect instances instead of being global
the flag_changed() callbacks need to receive the trace_array descriptor
of the instance they will be modifying.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c              | 2 +-
 kernel/trace/trace.h              | 2 +-
 kernel/trace/trace_irqsoff.c      | 4 +++-
 kernel/trace/trace_sched_wakeup.c | 4 +++-
 4 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index d7dfc7e..ee8da93 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3393,7 +3393,7 @@ int set_tracer_flag(struct trace_array *tr, unsigned int mask, int enabled)
 
 	/* Give the tracer a chance to approve the change */
 	if (tr->current_trace->flag_changed)
-		if (tr->current_trace->flag_changed(tr->current_trace, mask, !!enabled))
+		if (tr->current_trace->flag_changed(tr, mask, !!enabled))
 			return -EINVAL;
 
 	if (enabled)
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 649a23d..36e4473 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -358,7 +358,7 @@ struct tracer {
 	int			(*set_flag)(struct trace_array *tr,
 					    u32 old_flags, u32 bit, int set);
 	/* Return 0 if OK with change, else return non-zero */
-	int			(*flag_changed)(struct tracer *tracer,
+	int			(*flag_changed)(struct trace_array *tr,
 						u32 mask, int set);
 	struct tracer		*next;
 	struct tracer_flags	*flags;
diff --git a/kernel/trace/trace_irqsoff.c b/kernel/trace/trace_irqsoff.c
index fd99b0c..4bf812f 100644
--- a/kernel/trace/trace_irqsoff.c
+++ b/kernel/trace/trace_irqsoff.c
@@ -572,8 +572,10 @@ static void irqsoff_function_set(int set)
 		unregister_irqsoff_function(is_graph());
 }
 
-static int irqsoff_flag_changed(struct tracer *tracer, u32 mask, int set)
+static int irqsoff_flag_changed(struct trace_array *tr, u32 mask, int set)
 {
+	struct tracer *tracer = tr->current_trace;
+
 	if (mask & TRACE_ITER_FUNCTION)
 		irqsoff_function_set(set);
 
diff --git a/kernel/trace/trace_sched_wakeup.c b/kernel/trace/trace_sched_wakeup.c
index f0bbdc2..e14da5e 100644
--- a/kernel/trace/trace_sched_wakeup.c
+++ b/kernel/trace/trace_sched_wakeup.c
@@ -179,8 +179,10 @@ static void wakeup_function_set(int set)
 		unregister_wakeup_function(is_graph());
 }
 
-static int wakeup_flag_changed(struct tracer *tracer, u32 mask, int set)
+static int wakeup_flag_changed(struct trace_array *tr, u32 mask, int set)
 {
+	struct tracer *tracer = tr->current_trace;
+
 	if (mask & TRACE_ITER_FUNCTION)
 		wakeup_function_set(set);
 
-- 
1.8.5.3


