Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757734Ab3IAKux (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 06:50:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28314 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757239Ab3IAKuu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 06:50:50 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>, David Ahern <dsahern@gmail.com>
Subject: [PATCH 16/24] tools list traceevent: Add function plugin
Date: Sun,  1 Sep 2013 12:48:41 +0200
Message-Id: <1378032529-18498-17-git-send-email-jolsa@redhat.com>
In-Reply-To: <1378032529-18498-1-git-send-email-jolsa@redhat.com>
References: <1378032529-18498-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Backporting function plugin.

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
 tools/lib/traceevent/Makefile          |   2 +-
 tools/lib/traceevent/plugin_function.c | 182 +++++++++++++++++++++++++++++++++
 2 files changed, 183 insertions(+), 1 deletion(-)
 create mode 100644 tools/lib/traceevent/plugin_function.c

diff --git a/tools/lib/traceevent/Makefile b/tools/lib/traceevent/Makefile
index 3a5ffd3..c926d09 100644
--- a/tools/lib/traceevent/Makefile
+++ b/tools/lib/traceevent/Makefile
@@ -209,7 +209,7 @@ PEVENT_LIB_OBJS = event-parse.o event-plugin.o trace-seq.o parse-filter.o parse-
 PEVENT_LIB_OBJS += kbuffer-parse.o
 
 PLUGIN_OBJS = plugin_jbd2.o plugin_blk.o plugin_hrtimer.o plugin_kmem.o plugin_kvm.o \
-	plugin_mac80211.o plugin_sched_switch.o
+	plugin_mac80211.o plugin_sched_switch.o plugin_function.o
 
 PLUGINS := $(PLUGIN_OBJS:.o=.so)
 
diff --git a/tools/lib/traceevent/plugin_function.c b/tools/lib/traceevent/plugin_function.c
new file mode 100644
index 0000000..d0444ba
--- /dev/null
+++ b/tools/lib/traceevent/plugin_function.c
@@ -0,0 +1,182 @@
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
+#include "event-utils.h"
+
+static struct func_stack {
+	int index;
+	int size;
+	char **stack;
+} *fstack;
+
+static int cpus = -1;
+
+#define STK_BLK 10
+
+struct plugin_option plugin_options[] =
+{
+	{
+		.name = "parent",
+		.plugin_alias = "ftrace",
+		.description =
+		"Print parent of functions for function events",
+	},
+	{
+		.name = "indent",
+		.plugin_alias = "ftrace",
+		.description =
+		"Try to show function call indents, based on parents",
+		.set = 1,
+	},
+	{
+		.name = NULL,
+	}
+};
+
+static struct plugin_option *ftrace_parent = &plugin_options[0];
+static struct plugin_option *ftrace_indent = &plugin_options[1];
+
+static void add_child(struct func_stack *stack, const char *child, int pos)
+{
+	int i;
+
+	if (!child)
+		return;
+
+	if (pos < stack->size)
+		free(stack->stack[pos]);
+	else {
+		if (!stack->stack)
+			stack->stack = malloc_or_die(sizeof(char *) * STK_BLK);
+		else
+			stack->stack = realloc(stack->stack, sizeof(char *) *
+					       (stack->size + STK_BLK));
+		for (i = stack->size; i < stack->size + STK_BLK; i++)
+			stack->stack[i] = NULL;
+		stack->size += STK_BLK;
+	}
+
+	stack->stack[pos] = strdup(child);
+}
+
+static int get_index(const char *parent, const char *child, int cpu)
+{
+	int i;
+
+	if (cpu < 0)
+		return 0;
+
+	if (cpu > cpus) {
+		if (fstack)
+			fstack = realloc(fstack, sizeof(*fstack) * (cpu + 1));
+		else
+			fstack = malloc_or_die(sizeof(*fstack) * (cpu + 1));
+
+		/* Account for holes in the cpu count */
+		for (i = cpus + 1; i <= cpu; i++)
+			memset(&fstack[i], 0, sizeof(fstack[i]));
+		cpus = cpu;
+	}
+
+	for (i = 0; i < fstack[cpu].size && fstack[cpu].stack[i]; i++) {
+		if (strcmp(parent, fstack[cpu].stack[i]) == 0) {
+			add_child(&fstack[cpu], child, i+1);
+			return i;
+		}
+	}
+
+	/* Not found */
+	add_child(&fstack[cpu], parent, 0);
+	add_child(&fstack[cpu], child, 1);
+	return 0;
+}
+
+static int function_handler(struct trace_seq *s, struct pevent_record *record,
+			    struct event_format *event, void *context)
+{
+	struct pevent *pevent = event->pevent;
+	unsigned long long function;
+	unsigned long long pfunction;
+	const char *func;
+	const char *parent;
+	int i, index = 0;
+
+	if (pevent_get_field_val(s, event, "ip", record, &function, 1))
+		return trace_seq_putc(s, '!');
+
+	func = pevent_find_function(pevent, function);
+
+	if (pevent_get_field_val(s, event, "parent_ip", record, &pfunction, 1))
+		return trace_seq_putc(s, '!');
+
+	parent = pevent_find_function(pevent, pfunction);
+
+	if (ftrace_indent->set)
+		index = get_index(parent, func, record->cpu);
+
+	for (i = 0; i < index; i++)
+		trace_seq_printf(s, "   ");
+
+	if (func)
+		trace_seq_printf(s, "%s", func);
+	else
+		trace_seq_printf(s, "0x%llx", function);
+
+	if (ftrace_parent->set) {
+		trace_seq_printf(s, " <-- ");
+		if (parent)
+			trace_seq_printf(s, "%s", parent);
+		else
+			trace_seq_printf(s, "0x%llx", pfunction);
+	}
+
+	return 0;
+}
+
+int PEVENT_PLUGIN_LOADER(struct pevent *pevent)
+{
+	pevent_register_event_handler(pevent, -1, "ftrace", "function",
+				      function_handler, NULL);
+
+	traceevent_add_options("ftrace", plugin_options);
+
+	return 0;
+}
+
+void PEVENT_PLUGIN_UNLOADER(void)
+{
+	int i, x;
+
+	for (i = 0; i <= cpus; i++) {
+		for (x = 0; x < fstack[i].size && fstack[i].stack[x]; x++)
+			free(fstack[i].stack[x]);
+		free(fstack[i].stack);
+	}
+
+	traceevent_remove_options(plugin_options);
+
+	free(fstack);
+	fstack = NULL;
+	cpus = -1;
+}
-- 
1.7.11.7

