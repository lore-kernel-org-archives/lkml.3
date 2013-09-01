Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757602Ab3IAKtu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 06:49:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63023 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757398Ab3IAKts (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 06:49:48 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>, David Ahern <dsahern@gmail.com>
Subject: [PATCH 15/24] tools list traceevent: Add sched_switch plugin
Date: Sun,  1 Sep 2013 12:48:40 +0200
Message-Id: <1378032529-18498-16-git-send-email-jolsa@redhat.com>
In-Reply-To: <1378032529-18498-1-git-send-email-jolsa@redhat.com>
References: <1378032529-18498-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Backporting sched_switch plugin.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: David Ahern <dsahern@gmail.com>
---
 tools/lib/traceevent/Makefile              |   2 +-
 tools/lib/traceevent/plugin_sched_switch.c | 147 +++++++++++++++++++++++++++++
 2 files changed, 148 insertions(+), 1 deletion(-)
 create mode 100644 tools/lib/traceevent/plugin_sched_switch.c

diff --git a/tools/lib/traceevent/Makefile b/tools/lib/traceevent/Makefile
index 690e107..3a5ffd3 100644
--- a/tools/lib/traceevent/Makefile
+++ b/tools/lib/traceevent/Makefile
@@ -209,7 +209,7 @@ PEVENT_LIB_OBJS = event-parse.o event-plugin.o trace-seq.o parse-filter.o parse-
 PEVENT_LIB_OBJS += kbuffer-parse.o
 
 PLUGIN_OBJS = plugin_jbd2.o plugin_blk.o plugin_hrtimer.o plugin_kmem.o plugin_kvm.o \
-	plugin_mac80211.o
+	plugin_mac80211.o plugin_sched_switch.o
 
 PLUGINS := $(PLUGIN_OBJS:.o=.so)
 
diff --git a/tools/lib/traceevent/plugin_sched_switch.c b/tools/lib/traceevent/plugin_sched_switch.c
new file mode 100644
index 0000000..63c422c
--- /dev/null
+++ b/tools/lib/traceevent/plugin_sched_switch.c
@@ -0,0 +1,147 @@
+/*
+ * Copyright (C) 2009, 2010 Red Hat Inc, Steven Rostedt <srostedt@redhat.com>
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU Lesser General Public
+ * License as published by the Free Software Foundation;
+ * version 2.1 of the License (not later!)
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU Lesser General Public License for more details.
+ *
+ * You should have received a copy of the GNU Lesser General Public
+ * License along with this program; if not,  see <http://www.gnu.org/licenses>
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ */
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+
+#include "event-parse.h"
+
+static void write_state(struct trace_seq *s, int val)
+{
+	const char states[] = "SDTtZXxW";
+	int found = 0;
+	int i;
+
+	for (i=0; i < (sizeof(states) - 1); i++) {
+		if (!(val & (1 << i)))
+			continue;
+
+		if (found)
+			trace_seq_putc(s, '|');
+
+		found = 1;
+		trace_seq_putc(s, states[i]);
+	}
+
+	if (!found)
+		trace_seq_putc(s, 'R');
+}
+
+static void write_and_save_comm(struct format_field *field,
+				struct pevent_record *record,
+				struct trace_seq *s, int pid)
+{
+	const char *comm;
+	int len;
+
+	comm = (char *)(record->data + field->offset);
+	len = s->len;
+	trace_seq_printf(s, "%.*s",
+			 field->size, comm);
+
+	/* make sure the comm has a \0 at the end. */
+	trace_seq_terminate(s);
+	comm = &s->buffer[len];
+
+	/* Help out the comm to ids. This will handle dups */
+	pevent_register_comm(field->event->pevent, comm, pid);
+}
+
+static int sched_wakeup_handler(struct trace_seq *s, struct pevent_record *record,
+				struct event_format *event, void *context)
+{
+	struct format_field *field;
+	unsigned long long val;
+
+	if (pevent_get_field_val(s, event, "pid", record, &val, 1))
+		return trace_seq_putc(s, '!');
+
+	field = pevent_find_any_field(event, "comm");
+	if (field) {
+		write_and_save_comm(field, record, s, val);
+		trace_seq_putc(s, ':');
+	}
+	trace_seq_printf(s, "%lld", val);
+
+	if (pevent_get_field_val(s, event, "prio", record, &val, 0) == 0)
+		trace_seq_printf(s, " [%lld]", val);
+
+	if (pevent_get_field_val(s, event, "success", record, &val, 1) == 0)
+		trace_seq_printf(s, " success=%lld", val);
+
+	if (pevent_get_field_val(s, event, "target_cpu", record, &val, 0) == 0)
+		trace_seq_printf(s, " CPU:%03llu", val);
+
+	return 0;
+}
+
+static int sched_switch_handler(struct trace_seq *s, struct pevent_record *record,
+				struct event_format *event, void *context)
+{
+	struct format_field *field;
+	unsigned long long val;
+
+	if (pevent_get_field_val(s, event, "prev_pid", record, &val, 1))
+		return trace_seq_putc(s, '!');
+
+	field = pevent_find_any_field(event, "prev_comm");
+	if (field) {
+		write_and_save_comm(field, record, s, val);
+		trace_seq_putc(s, ':');
+	}
+	trace_seq_printf(s, "%lld ", val);
+
+	if (pevent_get_field_val(s, event, "prev_prio", record, &val, 0) == 0)
+		trace_seq_printf(s, "[%lld] ", val);
+
+	if (pevent_get_field_val(s,  event, "prev_state", record, &val, 0) == 0)
+		write_state(s, val);
+
+	trace_seq_puts(s, " ==> ");
+
+	if (pevent_get_field_val(s, event, "next_pid", record, &val, 1))
+		return trace_seq_putc(s, '!');
+
+	field = pevent_find_any_field(event, "next_comm");
+	if (field) {
+		write_and_save_comm(field, record, s, val);
+		trace_seq_putc(s, ':');
+	}
+	trace_seq_printf(s, "%lld", val);
+
+	if (pevent_get_field_val(s, event, "next_prio", record, &val, 0) == 0)
+		trace_seq_printf(s, " [%lld]", val);
+
+	return 0;
+}
+
+int PEVENT_PLUGIN_LOADER(struct pevent *pevent)
+{
+	pevent_register_event_handler(pevent, -1, "sched", "sched_switch",
+				      sched_switch_handler, NULL);
+
+	pevent_register_event_handler(pevent, -1, "sched", "sched_wakeup",
+				      sched_wakeup_handler, NULL);
+
+	pevent_register_event_handler(pevent, -1, "sched", "sched_wakeup_new",
+				      sched_wakeup_handler, NULL);
+
+	return 0;
+}
-- 
1.7.11.7

