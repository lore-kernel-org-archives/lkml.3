Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757716Ab3IAKur (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 06:50:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23669 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757669Ab3IAKup (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 06:50:45 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>, David Ahern <dsahern@gmail.com>
Subject: [PATCH 14/24] tools list traceevent: Add mac80211 plugin
Date: Sun,  1 Sep 2013 12:48:39 +0200
Message-Id: <1378032529-18498-15-git-send-email-jolsa@redhat.com>
In-Reply-To: <1378032529-18498-1-git-send-email-jolsa@redhat.com>
References: <1378032529-18498-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Backporting mac80211 plugin.

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
 tools/lib/traceevent/Makefile          |   3 +-
 tools/lib/traceevent/plugin_mac80211.c | 204 +++++++++++++++++++++++++++++++++
 2 files changed, 206 insertions(+), 1 deletion(-)
 create mode 100644 tools/lib/traceevent/plugin_mac80211.c

diff --git a/tools/lib/traceevent/Makefile b/tools/lib/traceevent/Makefile
index 3ac01c6..690e107 100644
--- a/tools/lib/traceevent/Makefile
+++ b/tools/lib/traceevent/Makefile
@@ -208,7 +208,8 @@ $(obj)/%.o: $(src)/%.c
 PEVENT_LIB_OBJS = event-parse.o event-plugin.o trace-seq.o parse-filter.o parse-utils.o event-option.o
 PEVENT_LIB_OBJS += kbuffer-parse.o
 
-PLUGIN_OBJS = plugin_jbd2.o plugin_blk.o plugin_hrtimer.o plugin_kmem.o plugin_kvm.o
+PLUGIN_OBJS = plugin_jbd2.o plugin_blk.o plugin_hrtimer.o plugin_kmem.o plugin_kvm.o \
+	plugin_mac80211.o
 
 PLUGINS := $(PLUGIN_OBJS:.o=.so)
 
diff --git a/tools/lib/traceevent/plugin_mac80211.c b/tools/lib/traceevent/plugin_mac80211.c
new file mode 100644
index 0000000..070c7c9
--- /dev/null
+++ b/tools/lib/traceevent/plugin_mac80211.c
@@ -0,0 +1,204 @@
+/*
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
+#define INDENT 65
+
+static void print_string(struct trace_seq *s, struct event_format *event,
+			 const char *name, const void *data)
+{
+	struct format_field *f = pevent_find_field(event, name);
+	int offset;
+	int length;
+
+	if (!f) {
+		trace_seq_printf(s, "NOTFOUND:%s", name);
+		return;
+	}
+
+	offset = f->offset;
+	length = f->size;
+
+	if (!strncmp(f->type, "__data_loc", 10)) {
+		unsigned long long v;
+		if (pevent_read_number_field(f, data, &v)) {
+			trace_seq_printf(s, "invalid_data_loc");
+			return;
+		}
+		offset = v & 0xffff;
+		length = v >> 16;
+	}
+
+	trace_seq_printf(s, "%.*s", length, (char *)data + offset);
+}
+
+struct value_name {
+	unsigned long long value;
+	const char *name;
+};
+
+static void _print_enum(struct trace_seq *s, struct event_format *event,
+			const char *name, const void *data,
+			const struct value_name *names, int n_names)
+{
+	struct format_field *f = pevent_find_field(event, name);
+	unsigned long long val;
+	int i;
+
+	if (!f) {
+		trace_seq_puts(s, "field-not-found");
+		return;
+	}
+
+	if (pevent_read_number_field(f, data, &val)) {
+		trace_seq_puts(s, "field-invalid");
+		return;
+	}
+
+	for (i = 0; i < n_names; i++) {
+		if (names[i].value == val) {
+			trace_seq_puts(s, names[i].name);
+			return;
+		}
+	}
+
+	trace_seq_printf(s, "%llu", val);
+}
+
+#define print_enum(s, ev, name, data, enums...)				\
+	({ static const struct value_name __n[] = { enums };		\
+	_print_enum(s, ev, name, data, __n, sizeof(__n)/sizeof(__n[0]));\
+	})
+
+static void _print_flag(struct trace_seq *s, struct event_format *event,
+			const char *name, const void *data,
+			const struct value_name *names, int n_names)
+{
+	struct format_field *f = pevent_find_field(event, name);
+	unsigned long long val;
+	int i, j, found, first = 1;
+
+	if (!f) {
+		trace_seq_puts(s, "field-not-found");
+		return;
+	}
+
+	if (pevent_read_number_field(f, data, &val)) {
+		trace_seq_puts(s, "field-invalid");
+		return;
+	}
+
+	for (i = 0; i < 64; i++) {
+		if (!(val & (1ULL<<i)))
+			continue;
+		if (!first)
+			trace_seq_putc(s, '|');
+		first = 0;
+
+		found = 0;
+		for (j = 0; j < n_names; j++) {
+			if (i == names[j].value) {
+				trace_seq_puts(s, names[j].name);
+				found = 1;
+				break;
+			}
+		}
+		if (!found)
+			trace_seq_printf(s, "flag_%d", i);
+	}
+}
+
+#define print_flag(s, ev, name, data, enums...)					\
+	({ static const struct value_name __n[] = { enums };			\
+	_print_flag(s, ev, name, data, __n, sizeof(__n)/sizeof(__n[0]));	\
+	})
+
+#define SF(fn)	pevent_print_num_field(s, fn ":%d", event, fn, record, 0)
+#define SFX(fn)	pevent_print_num_field(s, fn ":%#x", event, fn, record, 0)
+#define SP()	trace_seq_putc(s, ' ')
+
+static int drv_bss_info_changed(struct trace_seq *s,
+				struct pevent_record *record,
+				struct event_format *event, void *context)
+{
+	void *data = record->data;
+
+	print_string(s, event, "wiphy_name", data);
+	trace_seq_printf(s, " vif:");
+	print_string(s, event, "vif_name", data);
+	pevent_print_num_field(s, "(%d)", event, "vif_type", record, 1);
+
+	trace_seq_printf(s, "\n%*s", INDENT, "");
+	SF("assoc"); SP();
+	SF("aid"); SP();
+	SF("cts"); SP();
+	SF("shortpre"); SP();
+	SF("shortslot"); SP();
+	SF("dtimper"); SP();
+	trace_seq_printf(s, "\n%*s", INDENT, "");
+	SF("bcnint"); SP();
+	SFX("assoc_cap"); SP();
+	SFX("basic_rates"); SP();
+	SF("enable_beacon");
+	trace_seq_printf(s, "\n%*s", INDENT, "");
+	SF("ht_operation_mode");
+
+	return 0;
+}
+
+static int drv_config(struct trace_seq *s, struct pevent_record *record,
+		      struct event_format *event, void *context)
+{
+	void *data = record->data;
+
+	print_string(s, event, "wiphy_name", data);
+	trace_seq_putc(s, ' ');
+	print_flag(s, event, "flags", data,
+		{ 0, "MONITOR" },
+		{ 1, "PS" },
+		{ 2, "IDLE" },
+		{ 3, "QOS"},
+	);
+	pevent_print_num_field(s, " chan:%d/", event, "center_freq", record, 1);
+	print_enum(s, event, "channel_type", data,
+		{ 0, "noht" },
+		{ 1, "ht20" },
+		{ 2, "ht40-" },
+		{ 3, "ht40+" });
+	trace_seq_putc(s, ' ');
+	SF("power_level");
+
+	return 0;
+}
+
+int PEVENT_PLUGIN_LOADER(struct pevent *pevent)
+{
+	pevent_register_event_handler(pevent, -1, "mac80211",
+				      "drv_bss_info_changed",
+				      drv_bss_info_changed, NULL);
+	pevent_register_event_handler(pevent, -1, "mac80211", "drv_config",
+				      drv_config, NULL);
+
+	return 0;
+}
-- 
1.7.11.7

