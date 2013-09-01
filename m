Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757860Ab3IAKyK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 06:54:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11430 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757454Ab3IAKte (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 06:49:34 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>, David Ahern <dsahern@gmail.com>
Subject: [PATCH 10/24] tools list traceevent: Add blk plugin
Date: Sun,  1 Sep 2013 12:48:35 +0200
Message-Id: <1378032529-18498-11-git-send-email-jolsa@redhat.com>
In-Reply-To: <1378032529-18498-1-git-send-email-jolsa@redhat.com>
References: <1378032529-18498-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Backporting blk plugin.

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
 tools/lib/traceevent/Makefile     |  17 +-
 tools/lib/traceevent/plugin_blk.c | 389 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 404 insertions(+), 2 deletions(-)
 create mode 100644 tools/lib/traceevent/plugin_blk.c

diff --git a/tools/lib/traceevent/Makefile b/tools/lib/traceevent/Makefile
index 8ac2b34..178cfa1 100644
--- a/tools/lib/traceevent/Makefile
+++ b/tools/lib/traceevent/Makefile
@@ -63,6 +63,19 @@ ifndef VERBOSE
   VERBOSE = 0
 endif
 
+# $(call test-build, snippet, ret) -> ret if snippet compiles
+#                                  -> empty otherwise
+test-build = $(if $(shell sh -c 'echo "$(1)" | \
+        $(CC) -o /dev/null -c -x c - > /dev/null 2>&1 && echo y'), $2)
+
+define BLK_TC_FLUSH_SOURCE
+#include <linux/blktrace_api.h>
+int main(void) { return BLK_TC_FLUSH; }
+endef
+
+# have flush/fua block layer instead of barriers?
+blk-flags := $(call test-build,$(BLK_TC_FLUSH_SOURCE),-DHAVE_BLK_TC_FLUSH)
+
 ifeq ("$(origin O)", "command line")
   BUILD_OUTPUT := $(O)
 endif
@@ -133,7 +146,7 @@ CFLAGS ?= -g -Wall
 
 # Append required CFLAGS
 override CFLAGS += $(CONFIG_FLAGS) $(INCLUDES) $(PLUGIN_DIR_SQ)
-override CFLAGS += $(udis86-flags) -D_GNU_SOURCE
+override CFLAGS += $(blk-flags) -D_GNU_SOURCE
 
 ifeq ($(VERBOSE),1)
   Q =
@@ -195,7 +208,7 @@ $(obj)/%.o: $(src)/%.c
 PEVENT_LIB_OBJS = event-parse.o event-plugin.o trace-seq.o parse-filter.o parse-utils.o event-option.o
 PEVENT_LIB_OBJS += kbuffer-parse.o
 
-PLUGIN_OBJS = plugin_jbd2.o
+PLUGIN_OBJS = plugin_jbd2.o plugin_blk.o
 
 PLUGINS := $(PLUGIN_OBJS:.o=.so)
 
diff --git a/tools/lib/traceevent/plugin_blk.c b/tools/lib/traceevent/plugin_blk.c
new file mode 100644
index 0000000..3b6f226
--- /dev/null
+++ b/tools/lib/traceevent/plugin_blk.c
@@ -0,0 +1,389 @@
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
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ */
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+
+#include <linux/blktrace_api.h>
+
+#include "event-parse.h"
+
+#define MINORBITS	20
+#define MINORMASK	((1U << MINORBITS) - 1)
+#define MAJOR(dev)	((unsigned int) ((dev) >> MINORBITS))
+#define MINOR(dev)	((unsigned int) ((dev) & MINORMASK))
+#define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]))
+
+struct blk_data {
+	unsigned long long	sector;
+	struct event_format	*event;
+	unsigned int		action;
+	unsigned int		pid;
+	unsigned int		device;
+	unsigned int		bytes;
+	unsigned int		error;
+	void			*pdu_data;
+	unsigned short		pdu_len;
+};
+
+static void fill_rwbs(char *rwbs, int action, unsigned int bytes)
+{
+	int i = 0;
+	int tc = action >> BLK_TC_SHIFT;
+
+	if (action == BLK_TN_MESSAGE) {
+		rwbs[i++] = 'N';
+		goto out;
+	}
+
+#if defined(HAVE_BLK_TC_FLUSH)
+	if (tc & BLK_TC_FLUSH)
+		rwbs[i++] = 'F';
+#endif
+
+	if (tc & BLK_TC_DISCARD)
+		rwbs[i++] = 'D';
+	else if (tc & BLK_TC_WRITE)
+		rwbs[i++] = 'W';
+	else if (bytes)
+		rwbs[i++] = 'R';
+	else
+		rwbs[i++] = 'N';
+
+#if defined(HAVE_BLK_TC_FLUSH)
+	if (tc & BLK_TC_FUA)
+		rwbs[i++] = 'F';
+#endif
+	if (tc & BLK_TC_AHEAD)
+		rwbs[i++] = 'A';
+#if !defined(HAVE_BLK_TC_FLUSH)
+	if (tc & BLK_TC_BARRIER)
+		rwbs[i++] = 'B';
+#endif
+	if (tc & BLK_TC_SYNC)
+		rwbs[i++] = 'S';
+	if (tc & BLK_TC_META)
+		rwbs[i++] = 'M';
+out:
+	rwbs[i] = '\0';
+}
+
+static int log_action(struct trace_seq *s, struct blk_data *data,
+		      const char *act)
+{
+	char rwbs[6];
+
+	fill_rwbs(rwbs, data->action, data->bytes);
+	return trace_seq_printf(s, "%3d,%-3d %2s %3s ",
+				MAJOR(data->device),
+				MINOR(data->device), act, rwbs);
+}
+
+static void blk_log_msg(struct trace_seq *s, void *data, int len)
+{
+	trace_seq_printf(s, "%.*s", len, (char *)data);
+}
+
+static int blk_log_dump_pdu(struct trace_seq *s, const unsigned char *pdu_buf,
+			    int pdu_len)
+{
+	int i, end, ret;
+
+	if (!pdu_len)
+		return 1;
+
+	/* find the last zero that needs to be printed */
+	for (end = pdu_len - 1; end >= 0; end--)
+		if (pdu_buf[end])
+			break;
+	end++;
+
+	if (!trace_seq_putc(s, '('))
+		return 0;
+
+	for (i = 0; i < pdu_len; i++) {
+
+		ret = trace_seq_printf(s, "%s%02x",
+				       i == 0 ? "" : " ", pdu_buf[i]);
+		if (!ret)
+			return ret;
+
+		/*
+		 * stop when the rest is just zeroes and indicate so
+		 * with a ".." appended
+		 */
+		if (i == end && end != pdu_len - 1)
+			return trace_seq_puts(s, " ..) ");
+	}
+
+	return trace_seq_puts(s, ") ");
+}
+
+static unsigned int t_sec(int bytes)
+{
+	return bytes >> 9;
+}
+
+static unsigned int be32_to_cpu(unsigned int val)
+{
+	unsigned int swap;
+
+	if (traceevent_host_bigendian())
+		return val;
+
+	swap = ((val & 0xffULL) << 24) |
+		((val & (0xffULL << 8)) << 8) |
+		((val & (0xffULL << 16)) >> 8) |
+		((val & (0xffULL << 24)) >> 24);
+
+	return swap;
+}
+
+static unsigned long long be64_to_cpu(unsigned long long val)
+{
+	unsigned long long swap;
+
+	if (traceevent_host_bigendian())
+		return val;
+
+	swap = ((val & 0xffULL) << 56) |
+		((val & (0xffULL << 8)) << 40) |
+		((val & (0xffULL << 16)) << 24) |
+		((val & (0xffULL << 24)) << 8) |
+		((val & (0xffULL << 32)) >> 8) |
+		((val & (0xffULL << 40)) >> 24) |
+		((val & (0xffULL << 48)) >> 40) |
+		((val & (0xffULL << 56)) >> 56);
+
+	return swap;
+}
+
+static unsigned long long get_pdu_int(void *data)
+{
+	const unsigned long long *val = data;
+	return be64_to_cpu(*val);
+}
+
+static void get_pdu_remap(void *pdu_data,
+			  struct blk_io_trace_remap *r)
+{
+	const struct blk_io_trace_remap *__r = pdu_data;
+	unsigned long long sector_from = __r->sector_from;
+
+	r->device_from = be32_to_cpu(__r->device_from);
+	r->device_to   = be32_to_cpu(__r->device_to);
+	r->sector_from = be64_to_cpu(sector_from);
+}
+
+static int blk_log_remap(struct trace_seq *s, struct blk_data *data)
+{
+	struct blk_io_trace_remap r = { .device_from = 0, };
+
+	get_pdu_remap(data->pdu_data, &r);
+	return trace_seq_printf(s, "%llu + %u <- (%d,%d) %llu\n",
+				data->sector, t_sec(data->bytes),
+				MAJOR(r.device_from), MINOR(r.device_from),
+				(unsigned long long)r.sector_from);
+}
+
+static int blk_log_split(struct trace_seq *s, struct blk_data *data)
+{
+	const char *cmd;
+
+	cmd = pevent_data_comm_from_pid(data->event->pevent, data->pid);
+
+	return trace_seq_printf(s, "%llu / %llu [%s]\n", data->sector,
+				get_pdu_int(data->pdu_data), cmd);
+}
+
+static int blk_log_plug(struct trace_seq *s, struct blk_data *data)
+{
+	const char *cmd;
+
+	cmd = pevent_data_comm_from_pid(data->event->pevent, data->pid);
+
+	return trace_seq_printf(s, "[%s]\n", cmd);
+}
+
+static int blk_log_unplug(struct trace_seq *s, struct blk_data *data)
+{
+	const char *cmd;
+
+	cmd = pevent_data_comm_from_pid(data->event->pevent, data->pid);
+
+	return trace_seq_printf(s, "[%s] %llu\n", cmd,
+				get_pdu_int(data->pdu_data));
+}
+
+static int blk_log_with_error(struct trace_seq *s, struct blk_data *data)
+{
+	if (data->action & BLK_TC_ACT(BLK_TC_PC)) {
+		blk_log_dump_pdu(s, data->pdu_data, data->pdu_len);
+		trace_seq_printf(s, "[%d]\n", data->error);
+		return 0;
+	} else {
+		if (t_sec(data->bytes))
+			return trace_seq_printf(s, "%llu + %u [%d]\n",
+						data->sector,
+						t_sec(data->bytes),
+						data->error);
+		return trace_seq_printf(s, "%llu [%d]\n",
+					data->sector, data->error);
+	}
+}
+
+static int blk_log_generic(struct trace_seq *s, struct blk_data *data)
+{
+	const char *cmd;
+
+	cmd = pevent_data_comm_from_pid(data->event->pevent, data->pid);
+
+	if (data->action & BLK_TC_ACT(BLK_TC_PC)) {
+		int ret;
+
+		ret = trace_seq_printf(s, "%u ", data->bytes);
+		if (!ret)
+			return 0;
+		ret = blk_log_dump_pdu(s, data->pdu_data, data->pdu_len);
+		if (!ret)
+			return 0;
+		return trace_seq_printf(s, "[%s]\n", cmd);
+	} else {
+		if (t_sec(data->bytes))
+			return trace_seq_printf(s, "%llu + %u [%s]\n",
+						data->sector,
+						t_sec(data->bytes), cmd);
+		return trace_seq_printf(s, "[%s]\n", cmd);
+	}
+}
+
+static const struct {
+	const char *act[2];
+	int	   (*print)(struct trace_seq *s, struct blk_data *data);
+} what2act[] = {
+	[__BLK_TA_QUEUE]	= {{  "Q", "queue" },	   blk_log_generic },
+	[__BLK_TA_BACKMERGE]	= {{  "M", "backmerge" },  blk_log_generic },
+	[__BLK_TA_FRONTMERGE]	= {{  "F", "frontmerge" }, blk_log_generic },
+	[__BLK_TA_GETRQ]	= {{  "G", "getrq" },	   blk_log_generic },
+	[__BLK_TA_SLEEPRQ]	= {{  "S", "sleeprq" },	   blk_log_generic },
+	[__BLK_TA_REQUEUE]	= {{  "R", "requeue" },	   blk_log_with_error },
+	[__BLK_TA_ISSUE]	= {{  "D", "issue" },	   blk_log_generic },
+	[__BLK_TA_COMPLETE]	= {{  "C", "complete" },   blk_log_with_error },
+	[__BLK_TA_PLUG]		= {{  "P", "plug" },	   blk_log_plug },
+	[__BLK_TA_UNPLUG_IO]	= {{  "U", "unplug_io" },  blk_log_unplug },
+	[__BLK_TA_UNPLUG_TIMER]	= {{ "UT", "unplug_timer" }, blk_log_unplug },
+	[__BLK_TA_INSERT]	= {{  "I", "insert" },	   blk_log_generic },
+	[__BLK_TA_SPLIT]	= {{  "X", "split" },	   blk_log_split },
+	[__BLK_TA_BOUNCE]	= {{  "B", "bounce" },	   blk_log_generic },
+	[__BLK_TA_REMAP]	= {{  "A", "remap" },	   blk_log_remap },
+};
+
+static int blktrace_handler(struct trace_seq *s, struct pevent_record *record,
+			    struct event_format *event, void *context)
+{
+	struct format_field *field;
+	unsigned long long val;
+	void *data = record->data;
+	struct blk_data blk_data;
+	unsigned short what;
+	int long_act = 0;
+
+	field = pevent_find_field(event, "action");
+	if (!field)
+		return 1;
+	if (pevent_read_number_field(field, data, &val))
+		return 1;
+	blk_data.action = val;
+
+	field = pevent_find_field(event, "bytes");
+	if (!field)
+		return 1;
+	if (pevent_read_number_field(field, data, &val))
+		return 1;
+	blk_data.bytes = val;
+
+	field = pevent_find_field(event, "device");
+	if (!field)
+		return 1;
+	if (pevent_read_number_field(field, data, &val))
+		return 1;
+	blk_data.device = val;
+
+	field = pevent_find_field(event, "pdu_len");
+	if (!field)
+		return 1;
+	if (pevent_read_number_field(field, data, &val))
+		return 1;
+	blk_data.pdu_len = val;
+
+	field = pevent_find_field(event, "data");
+	if (!field)
+		return 1;
+	blk_data.pdu_data = data + field->offset;
+
+	field = pevent_find_field(event, "sector");
+	if (!field)
+		return 1;
+	if (pevent_read_number_field(field, data, &blk_data.sector))
+		return 1;
+
+	field = pevent_find_field(event, "pid");
+	if (!field)
+		return 1;
+	if (pevent_read_number_field(field, data, &val))
+		return 1;
+	blk_data.pid = val;
+
+	field = pevent_find_field(event, "error");
+	if (!field)
+		return 1;
+	if (pevent_read_number_field(field, data, &val))
+		return 1;
+	blk_data.error = val;
+
+	blk_data.event = event;
+
+
+	what	   = blk_data.action & ((1 << BLK_TC_SHIFT) - 1);
+
+	if (blk_data.action == BLK_TN_MESSAGE) {
+		log_action(s, &blk_data, "m");
+		blk_log_msg(s, blk_data.pdu_data, blk_data.pdu_len);
+		goto out;
+	}
+
+	if (what == 0 || what >= ARRAY_SIZE(what2act))
+		trace_seq_printf(s, "Unknown action %x\n", what);
+	else {
+		log_action(s, &blk_data, what2act[what].act[long_act]);
+		what2act[what].print(s, &blk_data);
+	}
+
+ out:
+	return 0;
+}
+
+int PEVENT_PLUGIN_LOADER(struct pevent *pevent)
+{
+	pevent_register_event_handler(pevent, -1, "ftrace", "blktrace",
+				      blktrace_handler, NULL);
+	return 0;
+}
-- 
1.7.11.7

