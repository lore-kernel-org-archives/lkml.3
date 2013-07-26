Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758861Ab3GZNGb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 09:06:31 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:30237 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757038Ab3GZNFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 09:05:17 -0400
X-Authority-Analysis: v=2.0 cv=KJ7Y/S5o c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=AGr_jgBdTAoA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=LiBVAXjy5VsA:10 a=VwQbUJbxAAAA:8 a=Q-fNiiVtAAAA:8 a=1XWaLZrsAAAA:8 a=S4XTqWYCxZEdMK2QbjYA:9 a=jeBq3FmKZ4MA:10 a=lcTMV_K9oDIA:10 a=UTB_XpHje0EA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130726130513.428993451@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 26 Jul 2013 09:03:36 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arend van Spril <arend@broadcom.com>, Alexander Z Lam <azl@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        David Sharp <dhsharp@google.com>, <stable@vger.kernel.org>
Subject: [PATCH 9/9] tracing: Remove locking trace_types_lock from
 tracing_reset_all_online_cpus()
References: <20130726130327.911599518@goodmis.org>
Content-Disposition: inline; filename=0009-tracing-Remove-locking-trace_types_lock-from-tracing.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Commit a82274151af "tracing: Protect ftrace_trace_arrays list in trace_events.c"
added taking the trace_types_lock mutex in trace_events.c as there were
several locations that needed it for protection. Unfortunately, it also
encapsulated a call to tracing_reset_all_online_cpus() which also takes
the trace_types_lock, causing a deadlock.

This happens when a module has tracepoints and has been traced. When the
module is removed, the trace events module notifier will grab the
trace_types_lock, do a bunch of clean ups, and also clears the buffer
by calling tracing_reset_all_online_cpus. This doesn't happen often
which explains why it wasn't caught right away.

Commit a82274151af was marked for stable, which means this must be
sent to stable too.

Link: http://lkml.kernel.org/r/51EEC646.7070306@broadcom.com

Reported-by: Arend van Spril <arend@broadcom.com>
Tested-by: Arend van Spriel <arend@broadcom.com>
Cc: Alexander Z Lam <azl@google.com>
Cc: Vaibhav Nagarnaik <vnagarnaik@google.com>
Cc: David Sharp <dhsharp@google.com>
Cc: stable@vger.kernel.org # 3.10
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 69cba47..882ec1d 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1224,18 +1224,17 @@ void tracing_reset_current(int cpu)
 	tracing_reset(&global_trace.trace_buffer, cpu);
 }
 
+/* Must have trace_types_lock held */
 void tracing_reset_all_online_cpus(void)
 {
 	struct trace_array *tr;
 
-	mutex_lock(&trace_types_lock);
 	list_for_each_entry(tr, &ftrace_trace_arrays, list) {
 		tracing_reset_online_cpus(&tr->trace_buffer);
 #ifdef CONFIG_TRACER_MAX_TRACE
 		tracing_reset_online_cpus(&tr->max_buffer);
 #endif
 	}
-	mutex_unlock(&trace_types_lock);
 }
 
 #define SAVED_CMDLINES 128
-- 
1.7.10.4


