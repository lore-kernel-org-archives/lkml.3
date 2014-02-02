Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938AbaBBVkk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 16:40:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9865 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752914AbaBBVki (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 16:40:38 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 22/22] perf tools: Add support for tracepoint fields
Date: Sun,  2 Feb 2014 22:39:10 +0100
Message-Id: <1391377150-23920-23-git-send-email-jolsa@redhat.com>
In-Reply-To: <1391377150-23920-1-git-send-email-jolsa@redhat.com>
References: <1391377150-23920-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding '--tp' option for report command to show
tracepoint related info. Use can specify following
switches:
   - fields: shows separated tracepoint fields
   - format: shows tracepoints 'print fmt' in single column
             (This is default if no switch is given.)

  $ perf report --tp --no-children
  Samples: 4K of event 'sched:sched_switch', Event count (approx.): 4788
   Overhead          Command      Shared Object          Symbol  Print fmt
  +  26.27%          swapper  [kernel.kallsyms]  [k] __schedule  swapper/2:0 [120] R ==> offlineimap:22134 [120]
  +  26.27%      offlineimap  [kernel.kallsyms]  [k] __schedule  offlineimap:22134 [120] S ==> swapper/2:0 [120]
  -   8.15%          swapper  [kernel.kallsyms]  [k] __schedule  swapper/3:0 [120] R ==> offlineimap:22134 [120]
       __schedule
       schedule_preempt_disabled
       cpu_startup_entry
       start_secondary
  +   8.15%      offlineimap  [kernel.kallsyms]  [k] __schedule  offlineimap:22134 [120] S ==> swapper/3:0 [120]

  $ perf report --tp=fields --no-children
  Samples: 4K of event 'sched:sched_switch', Event count (approx.): 4788
    Overhead          Command      Shared Object          Symbol                       prev_comm    prev_pid   prev_prio          prev_state                       next_comm    next_pid   next_prio
  +   26.27%          swapper  [kernel.kallsyms]  [k] __schedule                       swapper/2           0         120                   0                     offlineimap       22134         120
  +   26.27%      offlineimap  [kernel.kallsyms]  [k] __schedule                     offlineimap       22134         120                   1                       swapper/2           0         120
  -    8.15%          swapper  [kernel.kallsyms]  [k] __schedule                       swapper/3           0         120                   0                     offlineimap       22134         120
       __schedule
       schedule_preempt_disabled
       cpu_startup_entry
       start_secondary
  +    8.15%      offlineimap  [kernel.kallsyms]  [k] __schedule                     offlineimap       22134         120                   1                       swapper/3           0         120

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
---
 tools/perf/Documentation/perf-report.txt |   6 +
 tools/perf/Makefile.perf                 |   1 +
 tools/perf/builtin-report.c              |  15 ++
 tools/perf/util/report-tp.c              | 244 +++++++++++++++++++++++++++++++
 tools/perf/util/report-tp.h              |  18 +++
 5 files changed, 284 insertions(+)
 create mode 100644 tools/perf/util/report-tp.c
 create mode 100644 tools/perf/util/report-tp.h

diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
index 36eb187..ae1a0cf 100644
--- a/tools/perf/Documentation/perf-report.txt
+++ b/tools/perf/Documentation/perf-report.txt
@@ -263,6 +263,12 @@ OPTIONS
 --header-only::
 	Show only perf.data header (forces --stdio).
 
+--tp=::
+	Show tracepoint related info, following switches are supported:
+	- fields: shows separated tracepoint fields
+	- format: shows tracepoints 'print fmt' in single column
+		  (This is default if no switch is given.)
+
 SEE ALSO
 --------
 linkperf:perf-stat[1], linkperf:perf-annotate[1]
diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 7257e7e..baccf1d 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -373,6 +373,7 @@ LIB_OBJS += $(OUTPUT)util/stat.o
 LIB_OBJS += $(OUTPUT)util/record.o
 LIB_OBJS += $(OUTPUT)util/srcline.o
 LIB_OBJS += $(OUTPUT)util/data.o
+LIB_OBJS += $(OUTPUT)util/report-tp.o
 
 LIB_OBJS += $(OUTPUT)ui/setup.o
 LIB_OBJS += $(OUTPUT)ui/helpline.o
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 0938c4e..a46bdc9 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -35,6 +35,7 @@
 #include "util/hist.h"
 #include "util/data.h"
 #include "arch/common.h"
+#include "util/report-tp.h"
 
 #include <dlfcn.h>
 #include <linux/bitmap.h>
@@ -664,6 +665,7 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 		"perf report [<options>]",
 		NULL
 	};
+	enum report_tp_mode tp_mode;
 	struct report report = {
 		.tool = {
 			.sample		 = process_sample_event,
@@ -779,6 +781,9 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 	OPT_CALLBACK(0, "percentage", NULL, "relative|absolute",
 		     "how to display percentage of filtered entries", parse_percentage),
 	OPT_BOOLEAN(0, "list", &symbol_conf.show_list, "Show events list"),
+	OPT_CALLBACK_DEFAULT(0, "tp", &tp_mode, "fields,[format]", NULL,
+			     &report_tp_parse_mode, "format"),
+
 	OPT_END()
 	};
 	struct perf_data_file file = {
@@ -924,6 +929,16 @@ repeat:
 	if (symbol_conf.show_list)
 		sort__setup_list();
 
+	if (tp_mode != REPORT_TO_MODE__NONE) {
+		ret = perf_evlist__add_tp_sort_entries(session->evlist,
+						       tp_mode);
+		if (ret) {
+			pr_err("failed to add tracepoints sort entries\n");
+			goto error;
+		}
+		report.raw_info = true;
+	}
+
 	ret = __cmd_report(&report);
 	if (ret == K_SWITCH_INPUT_DATA) {
 		perf_session__delete(session);
diff --git a/tools/perf/util/report-tp.c b/tools/perf/util/report-tp.c
new file mode 100644
index 0000000..9608fd2
--- /dev/null
+++ b/tools/perf/util/report-tp.c
@@ -0,0 +1,244 @@
+#include <traceevent/event-parse.h>
+#include "evlist.h"
+#include "evsel.h"
+#include "sort.h"
+#include "report-tp.h"
+
+struct tp_sort_entry {
+	union {
+		struct format_field	*field;
+		struct event_format	*format;
+	};
+	struct sort_entry se;
+};
+
+#define tp_sort_entry(se) \
+	container_of(se, struct tp_sort_entry, se)
+
+int report_tp_parse_mode(const struct option *opt,
+			 const char *str, int unset)
+{
+	int *tp_mode = opt->value;
+
+	if (unset) {
+		*tp_mode = REPORT_TO_MODE__NONE;
+		return 0;
+	}
+
+	if (!str || !strcmp(str, "fields"))
+		*tp_mode = REPORT_TO_MODE__FIELDS;
+	else if (!strcmp(str, "format"))
+		*tp_mode = REPORT_TO_MODE__FORMAT;
+
+	return 0;
+}
+
+static int64_t field_sort_entry__cmp(struct sort_entry *se,
+				     struct hist_entry *left,
+				     struct hist_entry *right)
+{
+	struct tp_sort_entry *field_se = tp_sort_entry(se);
+	struct raw_info *raw_left = left->raw_info;
+	struct raw_info *raw_right = right->raw_info;
+
+	return pevent_field_cmp(field_se->field, field_se->field,
+				raw_left->data, raw_left->size,
+				raw_right->data, raw_right->size);
+}
+
+static int field_sort_entry__snprintf(struct sort_entry *se,
+				   bool selected __maybe_unused,
+				   struct hist_entry *he,
+				   char *bf, size_t size,
+				   unsigned int width)
+{
+	struct tp_sort_entry *field_se = tp_sort_entry(se);
+	struct raw_info *raw = he->raw_info;
+	struct trace_seq s;
+	int n;
+
+	trace_seq_init(&s);
+
+	pevent_field_info(&s, field_se->field, raw->data, raw->size, false);
+	n = scnprintf(bf, size, "%*s", width, s.buffer);
+	trace_seq_destroy(&s);
+	return n;
+}
+
+static struct tp_sort_entry*
+field_sort_entry__new(struct format_field *field, int width_idx)
+{
+	struct tp_sort_entry *field_se = zalloc(sizeof(*field_se));
+
+	if (field_se) {
+		INIT_LIST_HEAD(&field_se->se.list);
+		field_se->se.se_header		= strdup(field->name);
+		field_se->se.se_cmp		= field_sort_entry__cmp;
+		field_se->se.se_snprintf	= field_sort_entry__snprintf;
+		field_se->se.se_width_idx	= width_idx;
+		field_se->field			= field;
+	}
+
+	return field_se;
+}
+
+static int perf_format_field__width(struct format_field *field)
+{
+	int len = field->size * 2 + 2 /* '0x' */;
+
+	if (field->flags & FIELD_IS_ARRAY)
+		len = 30;
+
+	return len;
+}
+
+static int add_tp_field_entries(struct perf_evsel *evsel)
+{
+	struct format_field **fields, **iter;
+	struct hists *hists = &evsel->hists;
+	struct tp_sort_entry *field_se;
+	int width, width_idx = HISTC_NR_COLS;
+	int ret = -1;
+
+	fields = iter = pevent_event_fields(evsel->tp_format);
+	if (!fields)
+		return 0;
+
+	while (*iter) {
+		field_se = field_sort_entry__new(*iter, width_idx);
+		if (!field_se)
+			goto out;
+
+		if (hists__alloc_col_len(hists, width_idx + 1))
+			goto out;
+
+		width = perf_format_field__width(*iter);
+		hists__set_col_len(hists, width_idx, width);
+
+		hists__sort_entry_add(hists, &field_se->se);
+
+		width_idx++;
+		iter++;
+	}
+
+	ret = 0;
+
+ out:
+	free(fields);
+	return ret;
+}
+
+static int64_t format_sort_entry__cmp(struct sort_entry *se,
+				      struct hist_entry *left,
+				      struct hist_entry *right)
+{
+	struct tp_sort_entry *format_se = tp_sort_entry(se);
+	struct raw_info *raw_left = left->raw_info;
+	struct raw_info *raw_right = right->raw_info;
+	struct format_field **fields, **iter;
+	int ret = 0;
+
+	fields = iter = pevent_event_fields(format_se->format);
+	if (!fields)
+		return 0;
+
+	while (*iter) {
+		struct format_field *field = *iter;
+
+		ret = pevent_field_cmp(field, field,
+				       raw_left->data, raw_left->size,
+				       raw_right->data, raw_right->size);
+		if (ret)
+			break;
+
+		iter++;
+	}
+
+	free(fields);
+	return ret;
+}
+
+static int format_sort_entry__snprintf(struct sort_entry *se,
+				       bool selected __maybe_unused,
+				       struct hist_entry *he,
+				       char *bf, size_t size,
+				       unsigned int width)
+{
+	struct tp_sort_entry *format_se = tp_sort_entry(se);
+	struct raw_info *raw = he->raw_info;
+	struct pevent_record record;
+	struct trace_seq s;
+	int n;
+
+	trace_seq_init(&s);
+
+	memset(&record, 0, sizeof(record));
+	record.cpu  = he->cpu;
+	record.size = raw->size;
+	record.data = raw->data;
+
+	pevent_event_info(&s, format_se->format, &record);
+	n = scnprintf(bf, size, "%*s", width, s.buffer);
+	trace_seq_destroy(&s);
+	return n;
+}
+
+static int add_tp_format_entry(struct perf_evsel *evsel)
+{
+	struct tp_sort_entry *format_se = zalloc(sizeof(*format_se));
+	struct hists *hists = &evsel->hists;
+	int width_idx = HISTC_NR_COLS;
+
+	if (!format_se)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&format_se->se.list);
+	format_se->se.se_header		= "Print fmt";
+	format_se->se.se_cmp		= format_sort_entry__cmp;
+	format_se->se.se_snprintf	= format_sort_entry__snprintf;
+	format_se->se.se_width_idx	= width_idx;
+	format_se->format		= evsel->tp_format;
+
+	if (hists__alloc_col_len(hists, width_idx + 1)) {
+		free(format_se);
+		return -ENOMEM;
+	}
+
+	hists__set_col_len(hists, width_idx, 9);
+	hists__sort_entry_add(hists, &format_se->se);
+	return 0;
+}
+
+static bool perf_evsel__is_tracepoint(struct perf_evsel *evsel)
+{
+	return evsel->attr.type == PERF_TYPE_TRACEPOINT;
+}
+
+int perf_evlist__add_tp_sort_entries(struct perf_evlist *evlist,
+				     enum report_tp_mode mode)
+{
+	struct perf_evsel *evsel;
+	int ret = 0;
+
+	list_for_each_entry(evsel, &evlist->entries, node) {
+		if (!perf_evsel__is_tracepoint(evsel))
+			continue;
+
+		switch (mode) {
+		case REPORT_TO_MODE__FIELDS:
+			ret = add_tp_field_entries(evsel);
+			break;
+		case REPORT_TO_MODE__FORMAT:
+			ret = add_tp_format_entry(evsel);
+			break;
+		case REPORT_TO_MODE__NONE:
+		default:
+			BUG_ON(1);
+		}
+
+		if (ret)
+			break;
+	}
+
+	return ret;
+}
diff --git a/tools/perf/util/report-tp.h b/tools/perf/util/report-tp.h
new file mode 100644
index 0000000..e131982
--- /dev/null
+++ b/tools/perf/util/report-tp.h
@@ -0,0 +1,18 @@
+#ifndef PERF_REPORT_TP_H
+#define PERF_REPORT_TP_H
+
+#include "parse-options.h"
+
+enum report_tp_mode {
+	REPORT_TO_MODE__NONE,
+	REPORT_TO_MODE__FIELDS,
+	REPORT_TO_MODE__FORMAT,
+};
+
+int perf_evlist__add_tp_sort_entries(struct perf_evlist *evlist,
+				     enum report_tp_mode mode);
+
+int report_tp_parse_mode(const struct option *opt,
+			 const char *str, int unset);
+
+#endif /* PERF_REPORT_TP_H */
-- 
1.8.3.1

