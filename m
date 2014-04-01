Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267AbaDAQY5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 12:24:57 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44660 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753076AbaDAQQC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 12:16:02 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Steven Rostedt <rostedt@goodmis.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 42/86] tracing: Do not add event files for modules that fail tracepoints
Date: Tue,  1 Apr 2014 09:07:55 -0700
Message-Id: <1396368519-12728-43-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1396368519-12728-1-git-send-email-kamal@canonical.com>
References: <1396368519-12728-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.21 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 include/linux/tracepoint.h  |  6 ++++++
 kernel/trace/trace_events.c | 10 ++++++++++
 kernel/tracepoint.c         |  7 ++++++-
 3 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index 2f322c3..eb68f19 100644
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
index 880073d..44141d4 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -1376,6 +1376,16 @@ static void trace_module_add_events(struct module *mod)
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
 
diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
index d96ba22..23d8560 100644
--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -628,6 +628,11 @@ void tracepoint_iter_reset(struct tracepoint_iter *iter)
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
@@ -638,7 +643,7 @@ static int tracepoint_module_coming(struct module *mod)
 	 * module headers (for forced load), to make sure we don't cause a crash.
 	 * Staging and out-of-tree GPL modules are fine.
 	 */
-	if (mod->taints & ~((1 << TAINT_OOT_MODULE) | (1 << TAINT_CRAP)))
+	if (trace_module_has_bad_taint(mod))
 		return 0;
 	mutex_lock(&tracepoints_mutex);
 	tp_mod = kmalloc(sizeof(struct tp_module), GFP_KERNEL);
-- 
1.8.3.2

