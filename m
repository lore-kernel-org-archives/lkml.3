Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751895Ab3FZHQr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 03:16:47 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:61581 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774Ab3FZHOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 03:14:30 -0400
X-AuditID: 9c930179-b7cafae000004567-93-51ca94d25d24
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>
Subject: [PATCH 11/19] perf ftrace: Add 'report' sub-command
Date: Wed, 26 Jun 2013 16:14:14 +0900
Message-Id: <1372230862-15861-12-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1372230862-15861-1-git-send-email-namhyung@kernel.org>
References: <1372230862-15861-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The ftrace report command is for analyzing ftrace result as usual perf
report style.  Internal processing of the ftrace buffer is similar to
the 'show' sub-command but it synthesizes necessary information like
thread, dso, map and symbol from saved trace info.

It currently count number of samples as a period and it can be
extended to use calltime of funcgraph_exit in the future.

Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-ftrace.c | 281 +++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 279 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-ftrace.c b/tools/perf/builtin-ftrace.c
index 1ed415a19d53..1e28dc7e9743 100644
--- a/tools/perf/builtin-ftrace.c
+++ b/tools/perf/builtin-ftrace.c
@@ -21,6 +21,7 @@
 #include "util/target.h"
 #include "util/thread_map.h"
 #include "util/cpumap.h"
+#include "util/sort.h"
 #include "util/trace-event.h"
 #include "../lib/traceevent/kbuffer.h"
 #include "../lib/traceevent/event-parse.h"
@@ -35,6 +36,7 @@ struct perf_ftrace {
 	const char *tracer;
 	const char *dirname;
 	struct pevent *pevent;
+	bool show_full_info;
 };
 
 static bool done;
@@ -1154,6 +1156,212 @@ out:
 	return ret;
 }
 
+struct cmdline_list {
+	struct cmdline_list	*next;
+	char			*comm;
+	int			pid;
+};
+
+struct func_list {
+	struct func_list	*next;
+	unsigned long long	addr;
+	char			*func;
+	char			*mod;
+};
+
+static int do_ftrace_report(struct perf_ftrace *ftrace)
+{
+	int ret = -1;
+	char buf[PATH_MAX];
+	unsigned long nr_samples;
+	struct perf_session *session;
+	struct perf_evsel *evsel;
+	struct pevent_record *record;
+	struct perf_ftrace_report report = {
+		.ftrace = ftrace,
+		.tool = {
+			.sample = process_sample_event,
+		},
+	};
+	struct cmdline_list *cmdline;
+	struct func_list *func;
+	struct machine *machine;
+	struct dso *dso;
+
+	scnprintf(buf, sizeof(buf), "%s.dir/perf.header", ftrace->dirname);
+
+	session = perf_session__new(buf, O_RDONLY, false, false, &report.tool);
+	if (session == NULL) {
+		pr_err("failed to create a session\n");
+		return -1;
+	}
+
+	ftrace->pevent = session->pevent;
+
+	if (perf_session__process_events(session, &report.tool) < 0) {
+		pr_err("failed to process events\n");
+		goto out;
+	}
+
+	machine = machines__findnew(&session->machines, HOST_KERNEL_ID);
+
+	/* Synthesize thread info from saved cmdlines */
+	cmdline = ftrace->pevent->cmdlist;
+	while (cmdline) {
+		struct thread *thread;
+
+		thread = machine__findnew_thread(machine, cmdline->pid);
+		if (thread && !thread->comm_set)
+			thread__set_comm(thread, cmdline->comm);
+
+		cmdline = cmdline->next;
+	}
+
+	/* Synthesize kernel dso and symbol info from saved kallsyms */
+	func = ftrace->pevent->funclist;
+	while (func) {
+		struct symbol *sym;
+
+		scnprintf(buf, sizeof(buf), "[%s]",
+			  func->mod ? func->mod : "kernel.kallsyms");
+
+		dso = dso__kernel_findnew(machine, buf, NULL, DSO_TYPE_KERNEL);
+		if (dso == NULL) {
+			pr_debug("can't find or allocate dso %s\n", buf);
+			continue;
+		}
+
+		sym = symbol__new(func->addr, 0, STB_GLOBAL, func->func);
+		if (sym == NULL) {
+			pr_debug("failed to allocate new symbol\n");
+			continue;
+		}
+		symbols__insert(&dso->symbols[MAP__FUNCTION], sym);
+
+		func = func->next;
+	}
+
+	/* Generate kernel maps */
+	list_for_each_entry(dso, &machine->kernel_dsos, node) {
+		struct map *map = map__new2(0, dso, MAP__FUNCTION);
+		if (map == NULL) {
+			pr_debug("failed to allocate new map\n");
+			goto out;
+		}
+
+		symbols__fixup_end(&dso->symbols[MAP__FUNCTION]);
+		map__fixup_start(map);
+		map__fixup_end(map);
+
+		dso__set_loaded(dso, MAP__FUNCTION);
+
+		map_groups__insert(&machine->kmaps, map);
+		if (strcmp(dso->name, "[kernel.kallsyms]") == 0)
+			machine->vmlinux_maps[MAP__FUNCTION] = map;
+	}
+
+	/* FIXME: no need to get ordered */
+	record = get_ordered_record(ftrace);
+	while (record) {
+		int type;
+		struct addr_location al;
+		union perf_event event = {
+			.header = {
+				.misc = PERF_RECORD_MISC_KERNEL,
+			},
+		};
+		struct perf_sample sample = {
+			.cpu = record->cpu,
+			.raw_data = record->data,
+			.period = 1,
+		};
+		struct format_field *field;
+		unsigned long long val;
+
+		type = pevent_data_type(ftrace->pevent, record);
+		evsel = perf_evlist__find_tracepoint_by_id(session->evlist,
+							   type);
+		if (evsel == NULL) {
+			pr_warning("no event found for type %d\n", type);
+			continue;
+		}
+
+		event.ip.pid = pevent_data_pid(ftrace->pevent, record);
+
+		if (!strcmp(perf_evsel__name(evsel), "ftrace:function"))
+			field = pevent_find_field(evsel->tp_format, "ip");
+		else
+			field = pevent_find_field(evsel->tp_format, "func");
+
+		if (pevent_read_number_field(field, record->data, &val) < 0) {
+			pr_err("failed to parse function address\n");
+			goto out;
+		}
+		event.ip.ip = val;
+
+		if (perf_event__preprocess_sample(&event, machine, &al,
+						  &sample, NULL) < 0) {
+			pr_err("problem processing %d event, skipping it.\n",
+				event.header.type);
+			goto out;
+		}
+
+		/* TODO: update sample.period using calltime */
+		if (!__hists__add_entry(&evsel->hists, &al, NULL,
+					sample.period, 0)) {
+			pr_err("failed to add a hist entry\n");
+			goto out;
+		}
+
+		evsel->hists.stats.total_period += sample.period;
+		hists__inc_nr_events(&evsel->hists, PERF_RECORD_SAMPLE);
+
+		free(record);
+		record = get_ordered_record(ftrace);
+	}
+	ret = 0;
+
+	perf_session__fprintf_info(session, stdout, ftrace->show_full_info);
+
+	nr_samples = 0;
+	list_for_each_entry(evsel, &session->evlist->entries, node) {
+		struct hists *hists = &evsel->hists;
+
+		hists__collapse_resort(hists);
+		hists__output_resort(&evsel->hists);
+		nr_samples += hists->stats.nr_events[PERF_RECORD_SAMPLE];
+	}
+
+	if (nr_samples == 0) {
+		pr_warning("The %s file has no samples!\n", session->filename);
+		goto out;
+	}
+
+	list_for_each_entry(evsel, &session->evlist->entries, node) {
+		struct hists *hists = &evsel->hists;
+		const char *evname = perf_evsel__name(evsel);
+		u64 nr_events = hists->stats.total_period;
+		char unit;
+
+		nr_samples = hists->stats.nr_events[PERF_RECORD_SAMPLE];
+		nr_samples = convert_unit(nr_samples, &unit);
+		fprintf(stdout, "# Samples: %lu%c", nr_samples, unit);
+		if (evname != NULL)
+			fprintf(stdout, " of event '%s'", evname);
+
+		fprintf(stdout, "\n# Event count (approx.): %" PRIu64, nr_events);
+		fprintf(stdout, "\n#\n");
+
+		hists__fprintf(hists, true, 0, 0, 0.0, stdout);
+		fprintf(stdout, "\n\n");
+	}
+
+out:
+	free_ftrace_report_args(ftrace);
+	perf_session__delete(session);
+	return ret;
+}
+
 static int
 __cmd_ftrace_live(struct perf_ftrace *ftrace, int argc, const char **argv)
 {
@@ -1337,6 +1545,73 @@ out:
 	return ret;
 }
 
+static int
+__cmd_ftrace_report(struct perf_ftrace *ftrace, int argc, const char **argv)
+{
+	int ret = -1;
+	const char * const report_usage[] = {
+		"perf ftrace report [<options>]",
+		NULL
+	};
+	const struct option report_options[] = {
+	OPT_STRING('i', "input", &ftrace->dirname, "dirname",
+		   "input directory name to use (default: perf.data)"),
+	OPT_INCR('v', "verbose", &verbose,
+		 "be more verbose"),
+	OPT_BOOLEAN('D', "dump-raw-trace", &dump_trace,
+		    "dump raw trace in ASCII"),
+	OPT_STRING('C', "cpu", &ftrace->target.cpu_list, "cpu",
+		    "list of cpus to monitor"),
+	OPT_STRING('s', "sort", &sort_order, "key[,key2...]",
+		   "sort by key(s): pid, comm, dso, symbol, cpu"),
+	OPT_BOOLEAN('I', "show-info", &ftrace->show_full_info,
+		    "Display extended information like cpu/numa topology"),
+	OPT_END()
+	};
+
+	argc = parse_options(argc, argv, report_options, report_usage,
+			     PARSE_OPT_STOP_AT_NON_OPTION);
+	if (argc)
+		usage_with_options(report_usage, report_options);
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
+	perf_hpp__column_enable(PERF_HPP__OVERHEAD);
+	perf_hpp__init();
+
+	setup_sorting();
+
+	symbol_conf.exclude_other = false;
+	symbol_conf.try_vmlinux_path = false;
+	symbol__init();
+
+	ret = do_ftrace_report(ftrace);
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
@@ -1344,8 +1619,8 @@ int cmd_ftrace(int argc, const char **argv, const char *prefix __maybe_unused)
 		.target = { .uid = UINT_MAX, },
 	};
 	const char * const ftrace_usage[] = {
-		"perf ftrace {live|record|show} [<options>] [<command>]",
-		"perf ftrace {live|record|show} [<options>] -- <command> [<options>]",
+		"perf ftrace {live|record|show|report} [<options>] [<command>]",
+		"perf ftrace {live|record|show|report} [<options>] -- <command> [<options>]",
 		NULL
 	};
 	const struct option ftrace_options[] = {
@@ -1368,6 +1643,8 @@ int cmd_ftrace(int argc, const char **argv, const char *prefix __maybe_unused)
 		ret = __cmd_ftrace_record(&ftrace, argc, argv);
 	} else 	if (strcmp(argv[0], "show") == 0) {
 		ret = __cmd_ftrace_show(&ftrace, argc, argv);
+	} else 	if (strncmp(argv[0], "rep", 3) == 0) {
+		ret = __cmd_ftrace_report(&ftrace, argc, argv);
 	} else {
 		usage_with_options(ftrace_usage, ftrace_options);
 	}
-- 
1.7.11.7

