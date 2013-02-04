Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755419Ab3BDTEM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 14:04:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13425 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755156Ab3BDTEI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 14:04:08 -0500
Date: Mon, 4 Feb 2013 20:02:54 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: Anton Arapov <anton@redhat.com>, Frank Eigler <fche@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Josh Stone <jistone@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "Suzuki K. Poulose" <suzuki@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 4/7] uprobes/perf: Teach trace_uprobe/perf code to track
	the active perf_event's
Message-ID: <20130204190254.GA10875@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130204190225.GA10840@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce "struct trace_uprobe_filter" which records the "active"
perf_event's attached to ftrace_event_call. For the start we simply
use list_head, we can optimize this later if needed. For example, we
do not really need to record an event with ->parent != NULL, we can
rely on parent->child_list. And we can certainly do some optimizations
for the case when 2 events have the same ->tp_target or tp_target->mm.

Change trace_uprobe_register() to process TRACE_REG_PERF_OPEN/CLOSE
and add/del this perf_event to the list.

We can probably avoid any locking, but lets start with the "obvioulsy
correct" trace_uprobe_filter->rwlock which protects everything.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/trace/trace_uprobe.c |   55 +++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 55 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index 0a9a8de..f05ec32 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -28,6 +28,12 @@
 
 #define UPROBE_EVENT_SYSTEM	"uprobes"
 
+struct trace_uprobe_filter {
+	rwlock_t		rwlock;
+	int			nr_systemwide;
+	struct list_head	perf_events;
+};
+
 /*
  * uprobe event core functions
  */
@@ -35,6 +41,7 @@ struct trace_uprobe {
 	struct list_head		list;
 	struct ftrace_event_class	class;
 	struct ftrace_event_call	call;
+	struct trace_uprobe_filter	filter;
 	struct uprobe_consumer		consumer;
 	struct inode			*inode;
 	char				*filename;
@@ -58,6 +65,18 @@ static LIST_HEAD(uprobe_list);
 
 static int uprobe_dispatcher(struct uprobe_consumer *con, struct pt_regs *regs);
 
+static inline void init_trace_uprobe_filter(struct trace_uprobe_filter *filter)
+{
+	rwlock_init(&filter->rwlock);
+	filter->nr_systemwide = 0;
+	INIT_LIST_HEAD(&filter->perf_events);
+}
+
+static inline bool uprobe_filter_is_empty(struct trace_uprobe_filter *filter)
+{
+	return !filter->nr_systemwide && list_empty(&filter->perf_events);
+}
+
 /*
  * Allocate new trace_uprobe and initialize it (including uprobes).
  */
@@ -87,6 +106,7 @@ alloc_trace_uprobe(const char *group, const char *event, int nargs)
 
 	INIT_LIST_HEAD(&tu->list);
 	tu->consumer.handler = uprobe_dispatcher;
+	init_trace_uprobe_filter(&tu->filter);
 	return tu;
 
 error:
@@ -541,6 +561,8 @@ static int probe_event_enable(struct trace_uprobe *tu, int flag)
 	if (is_trace_uprobe_enabled(tu))
 		return -EINTR;
 
+	WARN_ON(!uprobe_filter_is_empty(&tu->filter));
+
 	tu->flags |= flag;
 	ret = uprobe_register(tu->inode, tu->offset, &tu->consumer);
 	if (ret)
@@ -554,6 +576,8 @@ static void probe_event_disable(struct trace_uprobe *tu, int flag)
 	if (!is_trace_uprobe_enabled(tu))
 		return;
 
+	WARN_ON(!uprobe_filter_is_empty(&tu->filter));
+
 	uprobe_unregister(tu->inode, tu->offset, &tu->consumer);
 	tu->flags &= ~flag;
 }
@@ -629,6 +653,30 @@ static int set_print_fmt(struct trace_uprobe *tu)
 }
 
 #ifdef CONFIG_PERF_EVENTS
+static int uprobe_perf_open(struct trace_uprobe *tu, struct perf_event *event)
+{
+	write_lock(&tu->filter.rwlock);
+	if (event->hw.tp_target)
+		list_add(&event->hw.tp_list, &tu->filter.perf_events);
+	else
+		tu->filter.nr_systemwide++;
+	write_unlock(&tu->filter.rwlock);
+
+	return 0;
+}
+
+static int uprobe_perf_close(struct trace_uprobe *tu, struct perf_event *event)
+{
+	write_lock(&tu->filter.rwlock);
+	if (event->hw.tp_target)
+		list_del(&event->hw.tp_list);
+	else
+		tu->filter.nr_systemwide--;
+	write_unlock(&tu->filter.rwlock);
+
+	return 0;
+}
+
 /* uprobe profile handler */
 static void uprobe_perf_func(struct trace_uprobe *tu, struct pt_regs *regs)
 {
@@ -684,6 +732,13 @@ int trace_uprobe_register(struct ftrace_event_call *event, enum trace_reg type,
 	case TRACE_REG_PERF_UNREGISTER:
 		probe_event_disable(tu, TP_FLAG_PROFILE);
 		return 0;
+
+	case TRACE_REG_PERF_OPEN:
+		return uprobe_perf_open(tu, data);
+
+	case TRACE_REG_PERF_CLOSE:
+		return uprobe_perf_close(tu, data);
+
 #endif
 	default:
 		return 0;
-- 
1.5.5.1

