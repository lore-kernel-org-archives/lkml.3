Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752618AbaAGPfz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 10:35:55 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:58916 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751481AbaAGPfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 10:35:52 -0500
Date: Tue, 7 Jan 2014 10:35:48 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Tom Zanussi <tom.zanussi@linux.intel.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [RFC][PATCH] tracing: Show available event triggers when no trigger
 is set
Message-ID: <20140107103548.0a84536d@gandalf.local.home>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Currently there's no way to know what triggers exist on a kernel without
looking at the source of the kernel or randomly trying out triggers.
Instead of creating another file in the debugfs system, simply show
what available triggers are there when cat'ing the trigger file when
it has no events:

 [root /sys/kernel/debug/tracing]# cat events/sched/sched_switch/trigger
 # Available triggers:
 # disable_event enable_event stacktrace snapshot traceoff traceon

This stays consistent with other debugfs files where meta data like
this is always proceeded with a '#' at the start of the line so that
tools can strip these out.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_events_trigger.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/kernel/trace/trace_events_trigger.c b/kernel/trace/trace_events_trigger.c
index a53e0da..90cf83c 100644
--- a/kernel/trace/trace_events_trigger.c
+++ b/kernel/trace/trace_events_trigger.c
@@ -115,10 +115,15 @@ event_triggers_post_call(struct ftrace_event_file *file,
 }
 EXPORT_SYMBOL_GPL(event_triggers_post_call);
 
+#define SHOW_AVAILABLE_TRIGGERS	(void *)(1UL)
+
 static void *trigger_next(struct seq_file *m, void *t, loff_t *pos)
 {
 	struct ftrace_event_file *event_file = event_file_data(m->private);
 
+	if (t == SHOW_AVAILABLE_TRIGGERS)
+		return NULL;
+
 	return seq_list_next(t, &event_file->triggers, pos);
 }
 
@@ -132,6 +137,9 @@ static void *trigger_start(struct seq_file *m, loff_t *pos)
 	if (unlikely(!event_file))
 		return ERR_PTR(-ENODEV);
 
+	if (list_empty(&event_file->triggers))
+		return *pos == 0 ? SHOW_AVAILABLE_TRIGGERS : NULL;
+
 	return seq_list_start(&event_file->triggers, *pos);
 }
 
@@ -143,6 +151,18 @@ static void trigger_stop(struct seq_file *m, void *t)
 static int trigger_show(struct seq_file *m, void *v)
 {
 	struct event_trigger_data *data;
+	struct event_command *p;
+
+	if (v == SHOW_AVAILABLE_TRIGGERS) {
+		seq_puts(m, "# Available triggers:\n");
+		seq_putc(m, '#');
+		mutex_lock(&trigger_cmd_mutex);
+		list_for_each_entry(p, &trigger_commands, list)
+			seq_printf(m, " %s", p->name);
+		seq_putc(m, '\n');
+		mutex_unlock(&trigger_cmd_mutex);
+		return 0;
+	}
 
 	data = list_entry(v, struct event_trigger_data, list);
 	data->ops->print(m, data->ops, data);
-- 
1.8.1.4

