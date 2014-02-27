Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439AbaB0Ptb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 10:49:31 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:22937 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753400AbaB0Pt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 10:49:28 -0500
Message-Id: <20140227154923.265882695@goodmis.org>
User-Agent: quilt/0.61-1
Date: Thu, 27 Feb 2014 10:46:19 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        <stable@vger.kernel.org>, Rusty Russell <rusty@rustcorp.com.au>
Subject: [RFA][PATCH 3/5] tracing: Do not add event files for modules that fail tracepoints
References: <20140227154616.703252665@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0003-tracing-Do-not-add-event-files-for-modules-that-fail.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Request for Ack]

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

If a module fails to add its tracepoints due to module tainting, do not
create the module event infrastructure in the debugfs directory. As the events
will not work and worse yet, they will silently fail, making the user wonder
why the events they enable do not display anything.

Having a warning on module load and the events not visible to the users
will make the cause of the problem much clearer.

Fixes: 6d723736e472 "tracing/events: add support for modules to TRACE_EVENT"
Cc: stable@vger.kernel.org # 2.6.31+
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/tracepoint.h  | 6 ++++++
 kernel/trace/trace_events.c | 4 ++++
 kernel/tracepoint.c         | 7 ++++++-
 3 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index accc497..7159a0a 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -60,6 +60,12 @@ struct tp_module {
 	unsigned int num_tracepoints;
 	struct tracepoint * const *tracepoints_ptrs;
 };
+bool trace_module_has_bad_taint(struct module *mod);
+#else
+static inline bool trace_module_has_bad_taint(struct module *mod)
+{
+	return false;
+}
 #endif /* CONFIG_MODULES */
 
 struct tracepoint_iter {
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index e71ffd4..b2fee73 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -1777,6 +1777,10 @@ static void trace_module_add_events(struct module *mod)
 {
 	struct ftrace_event_call **call, **start, **end;
 
+	/* Don't add infrastructure for mods without tracepoints */
+	if (trace_module_has_bad_taint(mod))
+		return;
+
 	start = mod->trace_events;
 	end = mod->trace_events + mod->num_trace_events;
 
diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
index 29f2654..031cc56 100644
--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -631,6 +631,11 @@ void tracepoint_iter_reset(struct tracepoint_iter *iter)
 EXPORT_SYMBOL_GPL(tracepoint_iter_reset);
 
 #ifdef CONFIG_MODULES
+bool trace_module_has_bad_taint(struct module *mod)
+{
+	return mod->taints & ~((1 << TAINT_OOT_MODULE) | (1 << TAINT_CRAP));
+}
+
 static int tracepoint_module_coming(struct module *mod)
 {
 	struct tp_module *tp_mod, *iter;
@@ -641,7 +646,7 @@ static int tracepoint_module_coming(struct module *mod)
 	 * module headers (for forced load), to make sure we don't cause a crash.
 	 * Staging and out-of-tree GPL modules are fine.
 	 */
-	if (mod->taints & ~((1 << TAINT_OOT_MODULE) | (1 << TAINT_CRAP)))
+	if (trace_module_has_bad_taint(mod))
 		return 0;
 	mutex_lock(&tracepoints_mutex);
 	tp_mod = kmalloc(sizeof(struct tp_module), GFP_KERNEL);
-- 
1.8.5.3


