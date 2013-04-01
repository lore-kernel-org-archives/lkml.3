Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759218Ab3DAQNA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 12:13:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29226 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759147Ab3DAQM7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 12:12:59 -0400
Date: Mon, 1 Apr 2013 18:08:48 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: Anton Arapov <anton@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/6] uprobes/tracing: Introduce is_ret_probe() and
	uretprobe_dispatcher()
Message-ID: <20130401160848.GA19573@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130401160827.GA19206@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create the new functions we need to support uretprobes, and change
alloc_trace_uprobe() to initialize consumer.ret_handler if the new
"is_ret" argument is true. Curently this argument is always false,
so the new code is never called and is_ret_probe(tu) is false too.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/trace/trace_uprobe.c |   42 ++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 40 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index 2ea9961..e91a354 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -75,6 +75,8 @@ static DEFINE_MUTEX(uprobe_lock);
 static LIST_HEAD(uprobe_list);
 
 static int uprobe_dispatcher(struct uprobe_consumer *con, struct pt_regs *regs);
+static int uretprobe_dispatcher(struct uprobe_consumer *con,
+				unsigned long func, struct pt_regs *regs);
 
 static inline void init_trace_uprobe_filter(struct trace_uprobe_filter *filter)
 {
@@ -88,11 +90,16 @@ static inline bool uprobe_filter_is_empty(struct trace_uprobe_filter *filter)
 	return !filter->nr_systemwide && list_empty(&filter->perf_events);
 }
 
+static inline bool is_ret_probe(struct trace_uprobe *tu)
+{
+	return tu->consumer.ret_handler != NULL;
+}
+
 /*
  * Allocate new trace_uprobe and initialize it (including uprobes).
  */
 static struct trace_uprobe *
-alloc_trace_uprobe(const char *group, const char *event, int nargs)
+alloc_trace_uprobe(const char *group, const char *event, int nargs, bool is_ret)
 {
 	struct trace_uprobe *tu;
 
@@ -117,6 +124,8 @@ alloc_trace_uprobe(const char *group, const char *event, int nargs)
 
 	INIT_LIST_HEAD(&tu->list);
 	tu->consumer.handler = uprobe_dispatcher;
+	if (is_ret)
+		tu->consumer.ret_handler = uretprobe_dispatcher;
 	init_trace_uprobe_filter(&tu->filter);
 	return tu;
 
@@ -314,7 +323,7 @@ static int create_trace_uprobe(int argc, char **argv)
 		kfree(tail);
 	}
 
-	tu = alloc_trace_uprobe(group, event, argc);
+	tu = alloc_trace_uprobe(group, event, argc, false);
 	if (IS_ERR(tu)) {
 		pr_info("Failed to allocate trace_uprobe.(%d)\n", (int)PTR_ERR(tu));
 		ret = PTR_ERR(tu);
@@ -529,6 +538,12 @@ static int uprobe_trace_func(struct trace_uprobe *tu, struct pt_regs *regs)
 	return 0;
 }
 
+static void uretprobe_trace_func(struct trace_uprobe *tu, unsigned long func,
+				struct pt_regs *regs)
+{
+	uprobe_trace_print(tu, func, regs);
+}
+
 /* Event entry printers */
 static enum print_line_t
 print_uprobe_event(struct trace_iterator *iter, int flags, struct trace_event *event)
@@ -799,6 +814,12 @@ static int uprobe_perf_func(struct trace_uprobe *tu, struct pt_regs *regs)
 	uprobe_perf_print(tu, 0, regs);
 	return 0;
 }
+
+static void uretprobe_perf_func(struct trace_uprobe *tu, unsigned long func,
+				struct pt_regs *regs)
+{
+	uprobe_perf_print(tu, func, regs);
+}
 #endif	/* CONFIG_PERF_EVENTS */
 
 static
@@ -853,6 +874,23 @@ static int uprobe_dispatcher(struct uprobe_consumer *con, struct pt_regs *regs)
 	return ret;
 }
 
+static int uretprobe_dispatcher(struct uprobe_consumer *con,
+				unsigned long func, struct pt_regs *regs)
+{
+	struct trace_uprobe *tu;
+
+	tu = container_of(con, struct trace_uprobe, consumer);
+
+	if (tu->flags & TP_FLAG_TRACE)
+		uretprobe_trace_func(tu, func, regs);
+
+#ifdef CONFIG_PERF_EVENTS
+	if (tu->flags & TP_FLAG_PROFILE)
+		uretprobe_perf_func(tu, func, regs);
+#endif
+	return 0;
+}
+
 static struct trace_event_functions uprobe_funcs = {
 	.trace		= print_uprobe_event
 };
-- 
1.5.5.1

