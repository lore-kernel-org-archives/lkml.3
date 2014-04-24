Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758591AbaDXQHu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 12:07:50 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:34376 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758615AbaDXQD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 12:03:26 -0400
Message-Id: <20140424160320.288843353@goodmis.org>
User-Agent: quilt/0.61-1
Date: Thu, 24 Apr 2014 12:02:36 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [for-next][PATCH 4/8] tracing: Allow wakeup tracers to be used by instances
References: <20140424160232.271454710@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0004-tracing-Allow-wakeup-tracers-to-be-used-by-instances.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

The wakeup and wakeup_rt tracers can now be used by instances.
But they may only be used by one instance at a time (including the
top level directory). This allows multiple tracers to run while
the wakeup tracer is running simultaneously.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_sched_wakeup.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/kernel/trace/trace_sched_wakeup.c b/kernel/trace/trace_sched_wakeup.c
index 41e0b8a..1573c03 100644
--- a/kernel/trace/trace_sched_wakeup.c
+++ b/kernel/trace/trace_sched_wakeup.c
@@ -601,6 +601,8 @@ static void stop_wakeup_tracer(struct trace_array *tr)
 	unregister_trace_sched_migrate_task(probe_wakeup_migrate_task, NULL);
 }
 
+static bool wakeup_busy;
+
 static int __wakeup_tracer_init(struct trace_array *tr)
 {
 	save_flags = trace_flags;
@@ -613,11 +615,16 @@ static int __wakeup_tracer_init(struct trace_array *tr)
 	wakeup_trace = tr;
 	ftrace_init_array_ops(tr, wakeup_tracer_call);
 	start_wakeup_tracer(tr);
+
+	wakeup_busy = true;
 	return 0;
 }
 
 static int wakeup_tracer_init(struct trace_array *tr)
 {
+	if (wakeup_busy)
+		return -EBUSY;
+
 	wakeup_dl = 0;
 	wakeup_rt = 0;
 	return __wakeup_tracer_init(tr);
@@ -625,6 +632,9 @@ static int wakeup_tracer_init(struct trace_array *tr)
 
 static int wakeup_rt_tracer_init(struct trace_array *tr)
 {
+	if (wakeup_busy)
+		return -EBUSY;
+
 	wakeup_dl = 0;
 	wakeup_rt = 1;
 	return __wakeup_tracer_init(tr);
@@ -632,6 +642,9 @@ static int wakeup_rt_tracer_init(struct trace_array *tr)
 
 static int wakeup_dl_tracer_init(struct trace_array *tr)
 {
+	if (wakeup_busy)
+		return -EBUSY;
+
 	wakeup_dl = 1;
 	wakeup_rt = 0;
 	return __wakeup_tracer_init(tr);
@@ -649,6 +662,7 @@ static void wakeup_tracer_reset(struct trace_array *tr)
 	set_tracer_flag(tr, TRACE_ITER_LATENCY_FMT, lat_flag);
 	set_tracer_flag(tr, TRACE_ITER_OVERWRITE, overwrite_flag);
 	ftrace_reset_array_ops(tr);
+	wakeup_busy = false;
 }
 
 static void wakeup_tracer_start(struct trace_array *tr)
@@ -680,6 +694,7 @@ static struct tracer wakeup_tracer __read_mostly =
 #endif
 	.open		= wakeup_trace_open,
 	.close		= wakeup_trace_close,
+	.allow_instances = true,
 	.use_max_tr	= true,
 };
 
@@ -702,6 +717,7 @@ static struct tracer wakeup_rt_tracer __read_mostly =
 #endif
 	.open		= wakeup_trace_open,
 	.close		= wakeup_trace_close,
+	.allow_instances = true,
 	.use_max_tr	= true,
 };
 
-- 
1.8.5.3


