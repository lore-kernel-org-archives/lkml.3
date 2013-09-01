Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757523Ab3IAKxY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 06:53:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62738 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757396Ab3IAKti (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 06:49:38 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>, David Ahern <dsahern@gmail.com>
Subject: [PATCH 12/24] tools list traceevent: Add kmem plugin
Date: Sun,  1 Sep 2013 12:48:37 +0200
Message-Id: <1378032529-18498-13-git-send-email-jolsa@redhat.com>
In-Reply-To: <1378032529-18498-1-git-send-email-jolsa@redhat.com>
References: <1378032529-18498-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Backporting kmem plugin.

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
 tools/lib/traceevent/Makefile      |  2 +-
 tools/lib/traceevent/plugin_kmem.c | 76 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 77 insertions(+), 1 deletion(-)
 create mode 100644 tools/lib/traceevent/plugin_kmem.c

diff --git a/tools/lib/traceevent/Makefile b/tools/lib/traceevent/Makefile
index 6e29f26..8e391bc 100644
--- a/tools/lib/traceevent/Makefile
+++ b/tools/lib/traceevent/Makefile
@@ -208,7 +208,7 @@ $(obj)/%.o: $(src)/%.c
 PEVENT_LIB_OBJS = event-parse.o event-plugin.o trace-seq.o parse-filter.o parse-utils.o event-option.o
 PEVENT_LIB_OBJS += kbuffer-parse.o
 
-PLUGIN_OBJS = plugin_jbd2.o plugin_blk.o plugin_hrtimer.o
+PLUGIN_OBJS = plugin_jbd2.o plugin_blk.o plugin_hrtimer.o plugin_kmem.o
 
 PLUGINS := $(PLUGIN_OBJS:.o=.so)
 
diff --git a/tools/lib/traceevent/plugin_kmem.c b/tools/lib/traceevent/plugin_kmem.c
new file mode 100644
index 0000000..0f8323c
--- /dev/null
+++ b/tools/lib/traceevent/plugin_kmem.c
@@ -0,0 +1,76 @@
+/*
+ * Copyright (C) 2009 Red Hat Inc, Steven Rostedt <srostedt@redhat.com>
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
+static int call_site_handler(struct trace_seq *s, struct pevent_record *record,
+			     struct event_format *event, void *context)
+{
+	struct format_field *field;
+	unsigned long long val, addr;
+	void *data = record->data;
+	const char *func;
+
+	field = pevent_find_field(event, "call_site");
+	if (!field)
+		return 1;
+
+	if (pevent_read_number_field(field, data, &val))
+		return 1;
+
+	func = pevent_find_function(event->pevent, val);
+	if (!func)
+		return 1;
+	addr = pevent_find_function_address(event->pevent, val);
+
+	trace_seq_printf(s, "(%s+0x%x) ", func, (int)(val - addr));
+
+	return 1;
+}
+
+int PEVENT_PLUGIN_LOADER(struct pevent *pevent)
+{
+	pevent_register_event_handler(pevent, -1, "kmem", "kfree",
+				      call_site_handler, NULL);
+
+	pevent_register_event_handler(pevent, -1, "kmem", "kmalloc",
+				      call_site_handler, NULL);
+
+	pevent_register_event_handler(pevent, -1, "kmem", "kmalloc_node",
+				      call_site_handler, NULL);
+
+	pevent_register_event_handler(pevent, -1, "kmem", "kmem_cache_alloc",
+				      call_site_handler, NULL);
+
+	pevent_register_event_handler(pevent, -1, "kmem",
+				      "kmem_cache_alloc_node",
+				      call_site_handler, NULL);
+
+	pevent_register_event_handler(pevent, -1, "kmem", "kfree",
+				      call_site_handler, NULL);
+
+	pevent_register_event_handler(pevent, -1, "kmem", "kmem_cache_free",
+				      call_site_handler, NULL);
+
+	return 0;
+}
-- 
1.7.11.7

