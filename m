Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752029Ab3FZHRE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 03:17:04 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:58756 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767Ab3FZHO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 03:14:29 -0400
X-AuditID: 9c930179-b7cafae000004567-90-51ca94d2327b
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>
Subject: [PATCH 10/19] perf ftrace: Add 'show' sub-command
Date: Wed, 26 Jun 2013 16:14:13 +0900
Message-Id: <1372230862-15861-11-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1372230862-15861-1-git-send-email-namhyung@kernel.org>
References: <1372230862-15861-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The ftrace show subcommand is for viewing recorded ftrace files.  It
enters perf.data.dir directory and open perf.header file to find out
necessary information.  And then read out per-cpu trace records using
kbuffer helper and print them to stdout in time order.

It only shows its basic form so function graph doesn't show duration/
overhead and no leaf entry handling is provided yet.  Maybe it can be
handled by a proper plugin in the libtraceevent.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-ftrace.c | 427 +++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 425 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-ftrace.c b/tools/perf/builtin-ftrace.c
index b348f7952ad9..1ed415a19d53 100644
--- a/tools/perf/builtin-ftrace.c
+++ b/tools/perf/builtin-ftrace.c
@@ -13,6 +13,7 @@
 #include <signal.h>
 #include <fcntl.h>
 #include <dirent.h>
+#include <sys/mman.h>
 
 #include "util/debug.h"
 #include "util/parse-options.h"
@@ -21,6 +22,8 @@
 #include "util/thread_map.h"
 #include "util/cpumap.h"
 #include "util/trace-event.h"
+#include "../lib/traceevent/kbuffer.h"
+#include "../lib/traceevent/event-parse.h"
 
 
 #define DEFAULT_TRACER  "function_graph"
@@ -31,6 +34,7 @@ struct perf_ftrace {
 	struct perf_target target;
 	const char *tracer;
 	const char *dirname;
+	struct pevent *pevent;
 };
 
 static bool done;
@@ -786,6 +790,371 @@ out_reset:
 }
 
 static int
+function_handler(struct trace_seq *s, struct pevent_record *record,
+		 struct event_format *event, void *context __maybe_unused)
+{
+	struct pevent *pevent = event->pevent;
+	unsigned long long function;
+	const char *func;
+
+	if (pevent_get_field_val(s, event, "ip", record, &function, 1))
+		return trace_seq_putc(s, '!');
+
+	func = pevent_find_function(pevent, function);
+	if (func)
+		trace_seq_printf(s, "%s <-- ", func);
+	else
+		trace_seq_printf(s, "0x%llx", function);
+
+	if (pevent_get_field_val(s, event, "parent_ip", record, &function, 1))
+		return trace_seq_putc(s, '!');
+
+	func = pevent_find_function(pevent, function);
+	if (func)
+		trace_seq_printf(s, "%s", func);
+	else
+		trace_seq_printf(s, "0x%llx", function);
+
+	trace_seq_putc(s, '\n');
+	return 0;
+}
+
+#define TRACE_GRAPH_INDENT  2
+
+static int
+fgraph_ent_handler(struct trace_seq *s, struct pevent_record *record,
+		   struct event_format *event, void *context __maybe_unused)
+{
+	unsigned long long depth;
+	unsigned long long val;
+	const char *func;
+	int i;
+
+	if (pevent_get_field_val(s, event, "depth", record, &depth, 1))
+		return trace_seq_putc(s, '!');
+
+	/* Function */
+	for (i = 0; i < (int)(depth * TRACE_GRAPH_INDENT); i++)
+		trace_seq_putc(s, ' ');
+
+	if (pevent_get_field_val(s, event, "func", record, &val, 1))
+		return trace_seq_putc(s, '!');
+
+	func = pevent_find_function(event->pevent, val);
+
+	if (func)
+		trace_seq_printf(s, "%s() {", func);
+	else
+		trace_seq_printf(s, "%llx() {", val);
+
+	trace_seq_putc(s, '\n');
+	return 0;
+}
+
+static int
+fgraph_ret_handler(struct trace_seq *s, struct pevent_record *record,
+		   struct event_format *event, void *context __maybe_unused)
+{
+	unsigned long long depth;
+	int i;
+
+	if (pevent_get_field_val(s, event, "depth", record, &depth, 1))
+		return trace_seq_putc(s, '!');
+
+	/* Function */
+	for (i = 0; i < (int)(depth * TRACE_GRAPH_INDENT); i++)
+		trace_seq_putc(s, ' ');
+
+	trace_seq_puts(s, "}\n");
+	return 0;
+}
+
+struct perf_ftrace_report {
+	struct perf_ftrace *ftrace;
+	struct perf_tool tool;
+};
+
+struct ftrace_report_arg {
+	struct list_head node;
+	struct pevent_record *record;
+	struct kbuffer *kbuf;
+	void *map;
+	int cpu;
+	int fd;
+	off_t offset;
+	off_t size;
+};
+
+static LIST_HEAD(ftrace_cpu_buffers);
+
+static int process_sample_event(struct perf_tool *tool,
+				union perf_event * event __maybe_unused,
+				struct perf_sample *sample,
+				struct perf_evsel *evsel __maybe_unused,
+				struct machine *machine __maybe_unused)
+{
+	struct perf_ftrace *ftrace;
+	struct perf_ftrace_report *report;
+	struct ftrace_report_arg *fra;
+	struct stat statbuf;
+	enum kbuffer_long_size long_size;
+	enum kbuffer_endian endian;
+	char buf[PATH_MAX];
+
+	report = container_of(tool, struct perf_ftrace_report, tool);
+	ftrace = report->ftrace;
+
+	fra = zalloc(sizeof(*fra));
+	if (fra == NULL)
+		return -1;
+
+	fra->cpu = sample->cpu;
+
+	scnprintf(buf, sizeof(buf), "%s.dir/trace-cpu%d.buf",
+		  ftrace->dirname, fra->cpu);
+
+	fra->fd = open(buf, O_RDONLY);
+	if (fra->fd < 0)
+		goto out;
+
+	if (fstat(fra->fd, &statbuf) < 0)
+		goto out_close;
+
+	fra->size = statbuf.st_size;
+	if (fra->size == 0) {
+		/* skip zero-size buffers */
+		free(fra);
+		return 0;
+	}
+
+	/*
+	 * FIXME: What if pevent->page_size is smaller than current page size?
+	 */
+	fra->map = mmap(NULL, pevent_get_page_size(ftrace->pevent),
+			PROT_READ, MAP_PRIVATE, fra->fd, fra->offset);
+	if (fra->map == MAP_FAILED)
+		goto out_close;
+
+	fra->offset = 0;
+
+	if (pevent_is_file_bigendian(ftrace->pevent))
+		endian = KBUFFER_ENDIAN_BIG;
+	else
+		endian = KBUFFER_ENDIAN_LITTLE;
+
+	if (pevent_get_long_size(ftrace->pevent) == 8)
+		long_size = KBUFFER_LSIZE_8;
+	else
+		long_size = KBUFFER_LSIZE_4;
+
+	fra->kbuf = kbuffer_alloc(long_size, endian);
+	if (fra->kbuf == NULL)
+		goto out_unmap;
+
+	if (ftrace->pevent->old_format)
+		kbuffer_set_old_format(fra->kbuf);
+
+	kbuffer_load_subbuffer(fra->kbuf, fra->map);
+
+	pr_debug2("setup kbuffer for cpu%d\n", fra->cpu);
+	list_add_tail(&fra->node, &ftrace_cpu_buffers);
+	return 0;
+
+out_unmap:
+	munmap(fra->map, pevent_get_page_size(ftrace->pevent));
+out_close:
+	close(fra->fd);
+out:
+	free(fra);
+	return -1;
+}
+
+static struct pevent_record *
+get_next_ftrace_event_record(struct perf_ftrace *ftrace,
+			     struct ftrace_report_arg *fra)
+{
+	struct pevent_record *record;
+	unsigned long long ts;
+	void *data;
+
+retry:
+	data = kbuffer_read_event(fra->kbuf, &ts);
+	if (data) {
+		record = zalloc(sizeof(*record));
+		if (record == NULL) {
+			pr_err("memory allocation failure\n");
+			return NULL;
+		}
+
+		record->ts = ts;
+		record->cpu = fra->cpu;
+		record->data = data;
+		record->size = kbuffer_event_size(fra->kbuf);
+		record->record_size = kbuffer_curr_size(fra->kbuf);
+		record->offset = kbuffer_curr_offset(fra->kbuf);
+		record->missed_events = kbuffer_missed_events(fra->kbuf);
+		record->ref_count = 1;
+
+		kbuffer_next_event(fra->kbuf, NULL);
+		return record;
+	}
+
+	munmap(fra->map, pevent_get_page_size(ftrace->pevent));
+	fra->map = NULL;
+
+	fra->offset += pevent_get_page_size(ftrace->pevent);
+	if (fra->offset >= fra->size) {
+		/* EOF */
+		return NULL;
+	}
+
+	fra->map = mmap(NULL, pevent_get_page_size(ftrace->pevent),
+			PROT_READ, MAP_PRIVATE, fra->fd, fra->offset);
+	if (fra->map == MAP_FAILED) {
+		pr_err("memory mapping failed\n");
+		return NULL;
+	}
+
+	kbuffer_load_subbuffer(fra->kbuf, fra->map);
+
+	goto retry;
+}
+
+static struct pevent_record *
+get_ftrace_event_record(struct perf_ftrace *ftrace,
+			struct ftrace_report_arg *fra)
+{
+	if (fra->record == NULL)
+		fra->record = get_next_ftrace_event_record(ftrace, fra);
+
+	return fra->record;
+}
+
+static struct pevent_record *get_ordered_record(struct perf_ftrace *ftrace)
+{
+	struct ftrace_report_arg *fra = NULL;
+	struct ftrace_report_arg *tmp;
+	struct pevent_record *record;
+	unsigned long long min_ts = LLONG_MAX;
+
+	list_for_each_entry(tmp, &ftrace_cpu_buffers, node) {
+		if (perf_target__has_cpu(&ftrace->target)) {
+			int i;
+			bool found = false;
+
+			for (i = 0; i < cpu_map__nr(ftrace->evlist->cpus); i++) {
+				if (tmp->cpu == ftrace->evlist->cpus->map[i]) {
+					found = true;
+					break;
+				}
+			}
+			if (!found)
+				continue;
+		}
+
+		record = get_ftrace_event_record(ftrace, tmp);
+		if (record && record->ts < min_ts) {
+			min_ts = record->ts;
+			fra = tmp;
+		}
+	}
+
+	if (fra) {
+		record = fra->record;
+		fra->record = NULL;
+		return record;
+	}
+	return NULL;
+}
+
+static void free_ftrace_report_args(struct perf_ftrace *ftrace)
+{
+	struct ftrace_report_arg *fra, *tmp;
+
+	list_for_each_entry_safe(fra, tmp, &ftrace_cpu_buffers, node) {
+		list_del(&fra->node);
+
+		/* don't care about the errors */
+		munmap(fra->map, pevent_get_page_size(ftrace->pevent));
+		kbuffer_free(fra->kbuf);
+		free(fra->record);
+		close(fra->fd);
+		free(fra);
+	}
+}
+
+static int do_ftrace_show(struct perf_ftrace *ftrace)
+{
+	int ret = 0;
+	char buf[PATH_MAX];
+	struct perf_session *session;
+	struct pevent_record *record;
+	struct trace_seq seq;
+	struct perf_ftrace_report show = {
+		.ftrace = ftrace,
+		.tool = {
+			.sample = process_sample_event,
+		},
+	};
+
+	scnprintf(buf, sizeof(buf), "%s.dir/perf.header", ftrace->dirname);
+
+	session = perf_session__new(buf, O_RDONLY, false, false, &show.tool);
+	if (session == NULL) {
+		pr_err("failed to create a session\n");
+		return -1;
+	}
+
+	ftrace->pevent = session->pevent;
+
+	pevent_register_event_handler(ftrace->pevent, -1,
+				      "ftrace", "function",
+				      function_handler, NULL);
+	pevent_register_event_handler(ftrace->pevent, -1,
+				      "ftrace", "funcgraph_entry",
+				      fgraph_ent_handler, NULL);
+	pevent_register_event_handler(ftrace->pevent, -1,
+				      "ftrace", "funcgraph_exit",
+				      fgraph_ret_handler, NULL);
+
+	if (perf_session__process_events(session, &show.tool) < 0) {
+		pr_err("failed to process events\n");
+		ret = -1;
+		goto out;
+	}
+
+	trace_seq_init(&seq);
+
+	record = get_ordered_record(ftrace);
+	while (record) {
+		int type;
+		struct event_format *event;
+
+		type = pevent_data_type(ftrace->pevent, record);
+		event = pevent_find_event(ftrace->pevent, type);
+		if (!event) {
+			pr_warning("no event found for type %d", type);
+			continue;
+		}
+
+		pevent_print_event(ftrace->pevent, &seq, record);
+		trace_seq_do_printf(&seq);
+
+		trace_seq_reset(&seq);
+
+		free(record);
+		record = get_ordered_record(ftrace);
+	}
+
+	trace_seq_destroy(&seq);
+
+out:
+	free_ftrace_report_args(ftrace);
+	perf_session__delete(session);
+	return ret;
+}
+
+static int
 __cmd_ftrace_live(struct perf_ftrace *ftrace, int argc, const char **argv)
 {
 	int ret = -1;
@@ -916,6 +1285,58 @@ out:
 	return ret;
 }
 
+static int
+__cmd_ftrace_show(struct perf_ftrace *ftrace, int argc, const char **argv)
+{
+	int ret = -1;
+	const char * const show_usage[] = {
+		"perf ftrace show [<options>]",
+		NULL
+	};
+	const struct option show_options[] = {
+	OPT_STRING('i', "input", &ftrace->dirname, "dirname",
+		   "input directory name to use (default: perf.data)"),
+	OPT_INCR('v', "verbose", &verbose,
+		 "be more verbose"),
+	OPT_STRING('C', "cpu", &ftrace->target.cpu_list, "cpu",
+		    "list of cpus to monitor"),
+	OPT_END()
+	};
+
+	argc = parse_options(argc, argv, show_options, show_usage,
+			     PARSE_OPT_STOP_AT_NON_OPTION);
+	if (argc)
+		usage_with_options(show_usage, show_options);
+
+	ret = perf_target__validate(&ftrace->target);
+	if (ret) {
+		char errbuf[512];
+
+		perf_target__strerror(&ftrace->target, ret, errbuf, 512);
+		pr_err("%s\n", errbuf);
+		return -EINVAL;
+	}
+
+	ftrace->evlist = perf_evlist__new();
+	if (ftrace->evlist == NULL)
+		return -ENOMEM;
+
+	ret = perf_evlist__create_maps(ftrace->evlist, &ftrace->target);
+	if (ret < 0)
+		goto out;
+
+	if (ftrace->dirname == NULL)
+		ftrace->dirname = DEFAULT_DIRNAME;
+
+	ret = do_ftrace_show(ftrace);
+
+	perf_evlist__delete_maps(ftrace->evlist);
+out:
+	perf_evlist__delete(ftrace->evlist);
+
+	return ret;
+}
+
 int cmd_ftrace(int argc, const char **argv, const char *prefix __maybe_unused)
 {
 	int ret;
@@ -923,8 +1344,8 @@ int cmd_ftrace(int argc, const char **argv, const char *prefix __maybe_unused)
 		.target = { .uid = UINT_MAX, },
 	};
 	const char * const ftrace_usage[] = {
-		"perf ftrace {live|record} [<options>] [<command>]",
-		"perf ftrace {live|record} [<options>] -- <command> [<options>]",
+		"perf ftrace {live|record|show} [<options>] [<command>]",
+		"perf ftrace {live|record|show} [<options>] -- <command> [<options>]",
 		NULL
 	};
 	const struct option ftrace_options[] = {
@@ -945,6 +1366,8 @@ int cmd_ftrace(int argc, const char **argv, const char *prefix __maybe_unused)
 		ret = __cmd_ftrace_live(&ftrace, argc, argv);
 	} else 	if (strncmp(argv[0], "rec", 3) == 0) {
 		ret = __cmd_ftrace_record(&ftrace, argc, argv);
+	} else 	if (strcmp(argv[0], "show") == 0) {
+		ret = __cmd_ftrace_show(&ftrace, argc, argv);
 	} else {
 		usage_with_options(ftrace_usage, ftrace_options);
 	}
-- 
1.7.11.7

