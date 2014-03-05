Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755951AbaCEAwe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 19:52:34 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:52535 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754105AbaCEAwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 19:52:33 -0500
Date: Tue, 4 Mar 2014 19:52:30 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        stable@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: [GIT PULL] tracing: Do not add event files for modules that fail
 tracepoints
Message-ID: <20140304195230.30a017d6@gandalf.local.home>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

In the past, I've had lots of reports about trace events not working.
Developers would say they put a trace_printk() before and after the trace
event but when they enable it (and the trace event said it was enabled) they
would see the trace_printks but not the trace event.

I was not able to reproduce this, but that's because I wasn't looking at
the right location. Recently, another bug came up that showed the issue.

If your kernel supports signed modules but allows for non-signed modules
to be loaded, then when one is, the kernel will silently set the
MODULE_FORCED taint on the module. Although, this taint happens without
the need for insmod --force or anything of the kind, it labels the
module with that taint anyway.

If this tainted module has tracepoints, the tracepoints will be ignored
because of the MODULE_FORCED taint. But no error message will be
displayed. Worse yet, the event infrastructure will still be created
letting users enable the trace event represented by the tracepoint,
although that event will never actually be enabled. This is because
the tracepoint infrastructure allows for non-existing tracepoints to
be enabled for new modules to arrive and have their tracepoints set.

Although there are several things wrong with the above, this change
only addresses the creation of the trace event files for tracepoints
that are not created when a module is loaded and is tainted. This change
will print an error message about the module being tainted and the
trace events will not be created, and it does not create the trace event
infrastructure.

Please pull the latest trace-fixes-v3.14-rc5 tree, which can be found at:


  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
trace-fixes-v3.14-rc5

Tag SHA1: babb7844ff64d24d7206dd477c0dacc5683d05b7
Head SHA1: 45ab2813d40d88fc575e753c38478de242d03f88


Steven Rostedt (Red Hat) (1):
      tracing: Do not add event files for modules that fail tracepoints

----
 include/linux/tracepoint.h  |  6 ++++++
 kernel/trace/trace_events.c | 10 ++++++++++
 kernel/tracepoint.c         |  7 ++++++-
 3 files changed, 22 insertions(+), 1 deletion(-)
---------------------------
commit 45ab2813d40d88fc575e753c38478de242d03f88
Author: Steven Rostedt (Red Hat) <rostedt@goodmis.org>
Date:   Wed Feb 26 13:37:38 2014 -0500

    tracing: Do not add event files for modules that fail tracepoints
    
    If a module fails to add its tracepoints due to module tainting, do not
    create the module event infrastructure in the debugfs directory. As the events
    will not work and worse yet, they will silently fail, making the user wonder
    why the events they enable do not display anything.
    
    Having a warning on module load and the events not visible to the users
    will make the cause of the problem much clearer.
    
    Link: http://lkml.kernel.org/r/20140227154923.265882695@goodmis.org
    
    Fixes: 6d723736e472 "tracing/events: add support for modules to TRACE_EVENT"
    Acked-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
    Cc: stable@vger.kernel.org # 2.6.31+
    Cc: Rusty Russell <rusty@rustcorp.com.au>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

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
index e71ffd4..f3989ce 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -1777,6 +1777,16 @@ static void trace_module_add_events(struct module *mod)
 {
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
