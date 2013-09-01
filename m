Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757847Ab3IAKxn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 06:53:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14417 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757479Ab3IAKtg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 06:49:36 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>, David Ahern <dsahern@gmail.com>
Subject: [PATCH 11/24] tools list traceevent: Add hrtimer plugin
Date: Sun,  1 Sep 2013 12:48:36 +0200
Message-Id: <1378032529-18498-12-git-send-email-jolsa@redhat.com>
In-Reply-To: <1378032529-18498-1-git-send-email-jolsa@redhat.com>
References: <1378032529-18498-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Backporting hrtimer plugin.

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
 tools/lib/traceevent/Makefile         |  2 +-
 tools/lib/traceevent/plugin_hrtimer.c | 94 +++++++++++++++++++++++++++++++++++
 2 files changed, 95 insertions(+), 1 deletion(-)
 create mode 100644 tools/lib/traceevent/plugin_hrtimer.c

diff --git a/tools/lib/traceevent/Makefile b/tools/lib/traceevent/Makefile
index 178cfa1..6e29f26 100644
--- a/tools/lib/traceevent/Makefile
+++ b/tools/lib/traceevent/Makefile
@@ -208,7 +208,7 @@ $(obj)/%.o: $(src)/%.c
 PEVENT_LIB_OBJS = event-parse.o event-plugin.o trace-seq.o parse-filter.o parse-utils.o event-option.o
 PEVENT_LIB_OBJS += kbuffer-parse.o
 
-PLUGIN_OBJS = plugin_jbd2.o plugin_blk.o
+PLUGIN_OBJS = plugin_jbd2.o plugin_blk.o plugin_hrtimer.o
 
 PLUGINS := $(PLUGIN_OBJS:.o=.so)
 
diff --git a/tools/lib/traceevent/plugin_hrtimer.c b/tools/lib/traceevent/plugin_hrtimer.c
new file mode 100644
index 0000000..e7fb195
--- /dev/null
+++ b/tools/lib/traceevent/plugin_hrtimer.c
@@ -0,0 +1,94 @@
+/*
+ * Copyright (C) 2009 Red Hat Inc, Steven Rostedt <srostedt@redhat.com>
+ * Copyright (C) 2009 Johannes Berg <johannes@sipsolutions.net>
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
+static int timer_expire_handler(struct trace_seq *s,
+				struct pevent_record *record,
+				struct event_format *event, void *context)
+{
+	trace_seq_printf(s, "hrtimer=");
+
+	if (pevent_print_num_field(s, "0x%llx", event, "timer",
+				   record, 0) == -1)
+		pevent_print_num_field(s, "0x%llx", event, "hrtimer",
+				       record, 1);
+
+	trace_seq_printf(s, " now=");
+
+	pevent_print_num_field(s, "%llu", event, "now", record, 1);
+
+	pevent_print_func_field(s, " function=%s", event, "function",
+				record, 0);
+
+	return 0;
+}
+
+static int timer_start_handler(struct trace_seq *s, struct pevent_record *record,
+			       struct event_format *event, void *context)
+{
+	struct pevent *pevent = event->pevent;
+	struct format_field *fn = pevent_find_field(event, "function");
+	void *data = record->data;
+
+	trace_seq_printf(s, "hrtimer=");
+
+	if (pevent_print_num_field(s, "0x%llx", event, "timer",
+				   record, 0) == -1)
+		pevent_print_num_field(s, "0x%llx", event, "hrtimer",
+				       record, 1);
+
+	if (!fn) {
+		trace_seq_printf(s, " function=MISSING");
+	} else {
+		unsigned long long function;
+		const char *func;
+
+		if (pevent_read_number_field(fn, data, &function))
+			trace_seq_printf(s, " function=INVALID");
+
+		func = pevent_find_function(pevent, function);
+
+		trace_seq_printf(s, " function=%s", func);
+	}
+
+	trace_seq_printf(s, " expires=");
+	pevent_print_num_field(s, "%llu", event, "expires", record, 1);
+
+	trace_seq_printf(s, " softexpires=");
+	pevent_print_num_field(s, "%llu", event, "softexpires", record, 1);
+
+	return 0;
+}
+
+int PEVENT_PLUGIN_LOADER(struct pevent *pevent)
+{
+	pevent_register_event_handler(pevent, -1, "timer", "hrtimer_expire_entry",
+				      timer_expire_handler, NULL);
+
+	pevent_register_event_handler(pevent, -1, "timer", "hrtimer_start",
+				      timer_start_handler, NULL);
+
+	return 0;
+}
-- 
1.7.11.7

