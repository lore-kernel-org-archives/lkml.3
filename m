Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525AbaC3X1j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 19:27:39 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36604 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753213AbaC3XZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:25:06 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Rusty Russell" <rusty@rustcorp.com.au>,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.355962850@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 158/200] tracing: Do not add event files for modules
 that fail tracepoints
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

commit 45ab2813d40d88fc575e753c38478de242d03f88 upstream.

If a module fails to add its tracepoints due to module tainting, do not
create the module event infrastructure in the debugfs directory. As the events
will not work and worse yet, they will silently fail, making the user wonder
why the events they enable do not display anything.

Having a warning on module load and the events not visible to the users
will make the cause of the problem much clearer.

Link: http://lkml.kernel.org/r/20140227154923.265882695@goodmis.org

Fixes: 6d723736e472 "tracing/events: add support for modules to TRACE_EVENT"
Acked-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/linux/tracepoint.h  |  6 ++++++
 kernel/trace/trace_events.c | 10 ++++++++++
 kernel/tracepoint.c         |  7 ++++++-
 3 files changed, 22 insertions(+), 1 deletion(-)

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
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -1345,6 +1345,16 @@ static void trace_module_add_events(stru
 	struct ftrace_module_file_ops *file_ops = NULL;
 	struct ftrace_event_call **call, **start, **end;
 
+	if (!mod->num_trace_events)
+		return;
+
+	/* Don't add infrastructure for mods without tracepoints */
+	if (trace_module_has_bad_taint(mod)) {
+		pr_err("%s: module has bad taint, not creating trace events\n",
+		       mod->name);
+		return;
+	}
+
 	start = mod->trace_events;
 	end = mod->trace_events + mod->num_trace_events;
 
--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -628,6 +628,11 @@ void tracepoint_iter_reset(struct tracep
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
@@ -638,7 +643,7 @@ static int tracepoint_module_coming(stru
 	 * module headers (for forced load), to make sure we don't cause a crash.
 	 * Staging and out-of-tree GPL modules are fine.
 	 */
-	if (mod->taints & ~((1 << TAINT_OOT_MODULE) | (1 << TAINT_CRAP)))
+	if (trace_module_has_bad_taint(mod))
 		return 0;
 	mutex_lock(&tracepoints_mutex);
 	tp_mod = kmalloc(sizeof(struct tp_module), GFP_KERNEL);

