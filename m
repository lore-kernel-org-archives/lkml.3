Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933623Ab3CHDHY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 22:07:24 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8123 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759556Ab3CHDGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 22:06:54 -0500
X-Authority-Analysis: v=2.0 cv=BZhaI8R2 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=eQDrctpqLacA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=Abhu8YY-PFcA:10 a=20KFwNOVAAAA:8 a=yMik4-lJTUdXD2NN_GEA:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130308030652.293108846@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 07 Mar 2013 22:00:01 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>, hcochran@lexmark.com,
        Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
Subject: [for-next][PATCH 03/17] tracing: Only clear trace buffer on module unload if event was
 traced
References: <20130308025958.501479677@goodmis.org>
Content-Disposition: inline; filename=0003-tracing-Only-clear-trace-buffer-on-module-unload-if-.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <srostedt@redhat.com>

Currently, when a module with events is unloaded, the trace buffer is
cleared. This is just a safety net in case the module might have some
strange callback when its event is outputted. But there's no reason
to reset the buffer if the module didn't have any of its events traced.

Add a flag to the event "call" structure called WAS_ENABLED and gets set
when the event is ever enabled, and this flag never gets cleared. When a
module gets unloaded, if any of its events have this flag set, then the
trace buffer will get cleared.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace_event.h |    5 +++++
 kernel/trace/trace_events.c  |   12 ++++++++----
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 0b0814d..d696424 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -197,6 +197,7 @@ enum {
 	TRACE_EVENT_FL_CAP_ANY_BIT,
 	TRACE_EVENT_FL_NO_SET_FILTER_BIT,
 	TRACE_EVENT_FL_IGNORE_ENABLE_BIT,
+	TRACE_EVENT_FL_WAS_ENABLED_BIT,
 };
 
 /*
@@ -205,12 +206,16 @@ enum {
  *  CAP_ANY	  - Any user can enable for perf
  *  NO_SET_FILTER - Set when filter has error and is to be ignored
  *  IGNORE_ENABLE - For ftrace internal events, do not enable with debugfs file
+ *  WAS_ENABLED   - Set and stays set when an event was ever enabled
+ *                    (used for module unloading, if a module event is enabled,
+ *                     it is best to clear the buffers that used it).
  */
 enum {
 	TRACE_EVENT_FL_FILTERED		= (1 << TRACE_EVENT_FL_FILTERED_BIT),
 	TRACE_EVENT_FL_CAP_ANY		= (1 << TRACE_EVENT_FL_CAP_ANY_BIT),
 	TRACE_EVENT_FL_NO_SET_FILTER	= (1 << TRACE_EVENT_FL_NO_SET_FILTER_BIT),
 	TRACE_EVENT_FL_IGNORE_ENABLE	= (1 << TRACE_EVENT_FL_IGNORE_ENABLE_BIT),
+	TRACE_EVENT_FL_WAS_ENABLED	= (1 << TRACE_EVENT_FL_WAS_ENABLED_BIT),
 };
 
 struct ftrace_event_call {
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 0f1307a..9a7dc4b 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -245,6 +245,9 @@ static int ftrace_event_enable_disable(struct ftrace_event_file *file,
 				break;
 			}
 			file->flags |= FTRACE_EVENT_FL_ENABLED;
+
+			/* WAS_ENABLED gets set but never cleared. */
+			call->flags |= TRACE_EVENT_FL_WAS_ENABLED;
 		}
 		break;
 	}
@@ -1626,12 +1629,13 @@ static void trace_module_remove_events(struct module *mod)
 {
 	struct ftrace_module_file_ops *file_ops;
 	struct ftrace_event_call *call, *p;
-	bool found = false;
+	bool clear_trace = false;
 
 	down_write(&trace_event_mutex);
 	list_for_each_entry_safe(call, p, &ftrace_events, list) {
 		if (call->mod == mod) {
-			found = true;
+			if (call->flags & TRACE_EVENT_FL_WAS_ENABLED)
+				clear_trace = true;
 			__trace_remove_event_call(call);
 		}
 	}
@@ -1648,9 +1652,9 @@ static void trace_module_remove_events(struct module *mod)
 
 	/*
 	 * It is safest to reset the ring buffer if the module being unloaded
-	 * registered any events.
+	 * registered any events that were used.
 	 */
-	if (found)
+	if (clear_trace)
 		tracing_reset_current_online_cpus();
 	up_write(&trace_event_mutex);
 }
-- 
1.7.10.4


