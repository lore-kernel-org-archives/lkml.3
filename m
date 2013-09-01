Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757691Ab3IAKyr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 06:54:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53184 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757413Ab3IAKtb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 06:49:31 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>, David Ahern <dsahern@gmail.com>
Subject: [PATCH 09/24] tools list traceevent: Add jbd2 plugin
Date: Sun,  1 Sep 2013 12:48:34 +0200
Message-Id: <1378032529-18498-10-git-send-email-jolsa@redhat.com>
In-Reply-To: <1378032529-18498-1-git-send-email-jolsa@redhat.com>
References: <1378032529-18498-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Backporting jbd2 plugin.

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
 tools/lib/traceevent/Makefile      |  2 ++
 tools/lib/traceevent/plugin_jbd2.c | 68 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 70 insertions(+)
 create mode 100644 tools/lib/traceevent/plugin_jbd2.c

diff --git a/tools/lib/traceevent/Makefile b/tools/lib/traceevent/Makefile
index 19bde02..8ac2b34 100644
--- a/tools/lib/traceevent/Makefile
+++ b/tools/lib/traceevent/Makefile
@@ -195,6 +195,8 @@ $(obj)/%.o: $(src)/%.c
 PEVENT_LIB_OBJS = event-parse.o event-plugin.o trace-seq.o parse-filter.o parse-utils.o event-option.o
 PEVENT_LIB_OBJS += kbuffer-parse.o
 
+PLUGIN_OBJS = plugin_jbd2.o
+
 PLUGINS := $(PLUGIN_OBJS:.o=.so)
 
 ALL_OBJS = $(PEVENT_LIB_OBJS) $(PLUGIN_OBJS)
diff --git a/tools/lib/traceevent/plugin_jbd2.c b/tools/lib/traceevent/plugin_jbd2.c
new file mode 100644
index 0000000..047a6f5
--- /dev/null
+++ b/tools/lib/traceevent/plugin_jbd2.c
@@ -0,0 +1,68 @@
+/*
+ * Copyright (C) 2010 Red Hat Inc, Steven Rostedt <srostedt@redhat.com>
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
+#define MINORBITS	20
+#define MINORMASK	((1U << MINORBITS) - 1)
+
+#define MAJOR(dev)	((unsigned int) ((dev) >> MINORBITS))
+#define MINOR(dev)	((unsigned int) ((dev) & MINORMASK))
+
+unsigned long long process_jbd2_dev_to_name(struct trace_seq *s,
+					    unsigned long long *args)
+{
+	unsigned int dev = args[0];
+
+	trace_seq_printf(s, "%d:%d", MAJOR(dev), MINOR(dev));
+
+	return 0;
+}
+
+unsigned long long process_jiffies_to_msecs(struct trace_seq *s,
+					    unsigned long long *args)
+{
+	unsigned long long jiffies = args[0];
+
+	trace_seq_printf(s, "%lld", jiffies);
+
+	return jiffies;
+}
+
+int PEVENT_PLUGIN_LOADER(struct pevent *pevent)
+{
+	pevent_register_print_function(pevent,
+				       process_jbd2_dev_to_name,
+				       PEVENT_FUNC_ARG_STRING,
+				       "jbd2_dev_to_name",
+				       PEVENT_FUNC_ARG_INT,
+				       PEVENT_FUNC_ARG_VOID);
+
+	pevent_register_print_function(pevent,
+				       process_jiffies_to_msecs,
+				       PEVENT_FUNC_ARG_LONG,
+				       "jiffies_to_msecs",
+				       PEVENT_FUNC_ARG_LONG,
+				       PEVENT_FUNC_ARG_VOID);
+	return 0;
+}
-- 
1.7.11.7

