Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472AbaB1RoY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 12:44:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28421 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753456AbaB1RoW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 12:44:22 -0500
From: Don Zickus <dzickus@redhat.com>
To: acme@ghostprotocols.net
Cc: LKML <linux-kernel@vger.kernel.org>, jolsa@redhat.com, jmario@redhat.com,
        fowles@inreach.com, eranian@google.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Richard Fowles <rfowles@redhat.com>
Subject: [PATCH 08/19] perf c2c: Shared data analyser
Date: Fri, 28 Feb 2014 12:42:57 -0500
Message-Id: <1393609388-40489-9-git-send-email-dzickus@redhat.com>
In-Reply-To: <1393609388-40489-1-git-send-email-dzickus@redhat.com>
References: <1393609388-40489-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

This is the start of a new perf tool that will collect information about
memory accesses and analyse it to find things like hot cachelines, etc.

This is basically trying to get a prototype written by Richard Fowles
written using the tools/perf coding style and libraries.

Start it from 'perf sched', this patch starts the process by adding the
'record' subcommand to collect the needed mem loads and stores samples.

It also have the basic 'report' skeleton, resolving the sample address
and hooking the events found in a perf.data file with methods to handle
them, right now just printing the resolved perf_sample data structure
after each event name.

[dcz: refreshed to latest upstream changes]

Cc: David Ahern <dsahern@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Joe Mario <jmario@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Richard Fowles <rfowles@redhat.com>
Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Don Zickus <dzickus@redhat.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-c2c.c |  22 +++++
 tools/perf/Makefile.perf            |   1 +
 tools/perf/builtin-c2c.c            | 185 ++++++++++++++++++++++++++++++++++++
 tools/perf/builtin.h                |   1 +
 tools/perf/perf.c                   |   1 +
 5 files changed, 210 insertions(+)
 create mode 100644 tools/perf/Documentation/perf-c2c.c
 create mode 100644 tools/perf/builtin-c2c.c

diff --git a/tools/perf/Documentation/perf-c2c.c b/tools/perf/Documentation/perf-c2c.c
new file mode 100644
index 0000000..4d52798
--- /dev/null
+++ b/tools/perf/Documentation/perf-c2c.c
@@ -0,0 +1,22 @@
+perf-c2c(1)
+===========
+
+NAME
+----
+perf-c2c - Shared Data C2C/HITM Analyzer.
+
+SYNOPSIS
+--------
+[verse]
+'perf c2c' record
+
+DESCRIPTION
+-----------
+These are the variants of perf c2c:
+
+  'perf c2c record <command>' to record the memory accesses of an arbitrary
+  workload.
+
+SEE ALSO
+--------
+linkperf:perf-record[1], linkperf:perf-mem[1]
diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 1f7ec48..a9eebb4 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -427,6 +427,7 @@ endif
 BUILTIN_OBJS += $(OUTPUT)bench/mem-memcpy.o
 BUILTIN_OBJS += $(OUTPUT)bench/mem-memset.o
 
+BUILTIN_OBJS += $(OUTPUT)builtin-c2c.o
 BUILTIN_OBJS += $(OUTPUT)builtin-diff.o
 BUILTIN_OBJS += $(OUTPUT)builtin-evlist.o
 BUILTIN_OBJS += $(OUTPUT)builtin-help.o
diff --git a/tools/perf/builtin-c2c.c b/tools/perf/builtin-c2c.c
new file mode 100644
index 0000000..2935484
--- /dev/null
+++ b/tools/perf/builtin-c2c.c
@@ -0,0 +1,185 @@
+#include "builtin.h"
+#include "cache.h"
+
+#include "util/evlist.h"
+#include "util/parse-options.h"
+#include "util/session.h"
+#include "util/tool.h"
+
+#include <linux/compiler.h>
+#include <linux/kernel.h>
+
+struct perf_c2c {
+	struct perf_tool tool;
+};
+
+static int perf_sample__fprintf(struct perf_sample *sample,
+				struct perf_evsel *evsel,
+				struct addr_location *al, FILE *fp)
+{
+	return fprintf(fp, "%25.25s: %5d %5d 0x%016" PRIx64 " 0x016%" PRIx64 " %5" PRIu64 " 0x%06" PRIx64 " %s:%s\n",
+		       perf_evsel__name(evsel),
+		       sample->pid, sample->tid, sample->ip, sample->addr,
+		       sample->weight, sample->data_src,
+		       al->map ? (al->map->dso ? al->map->dso->long_name : "???") : "???",
+		       al->sym ? al->sym->name : "???");
+}
+
+static int perf_c2c__process_load(struct perf_evsel *evsel,
+				  struct perf_sample *sample,
+				  struct addr_location *al)
+{
+	perf_sample__fprintf(sample, evsel, al, stdout);
+	return 0;
+}
+
+static int perf_c2c__process_store(struct perf_evsel *evsel,
+				   struct perf_sample *sample,
+				   struct addr_location *al)
+{
+	perf_sample__fprintf(sample, evsel, al, stdout);
+	return 0;
+}
+
+static const struct perf_evsel_str_handler handlers[] = {
+	{ "cpu/mem-loads,ldlat=30/pp", perf_c2c__process_load, },
+	{ "cpu/mem-stores/pp",	       perf_c2c__process_store, },
+};
+
+typedef int (*sample_handler)(struct perf_evsel *evsel,
+			      struct perf_sample *sample,
+			      struct addr_location *al);
+
+static int perf_c2c__process_sample(struct perf_tool *tool __maybe_unused,
+				    union perf_event *event,
+				    struct perf_sample *sample,
+				    struct perf_evsel *evsel,
+				    struct machine *machine)
+{
+	struct addr_location al;
+	int err = 0;
+
+	if (perf_event__preprocess_sample(event, machine, &al, sample) < 0) {
+		pr_err("problem processing %d event, skipping it.\n",
+		       event->header.type);
+		return -1;
+	}
+
+	if (evsel->handler != NULL) {
+		sample_handler f = evsel->handler;
+		err = f(evsel, sample, &al);
+	}
+
+	return err;
+}
+
+static int perf_c2c__read_events(struct perf_c2c *c2c)
+{
+	int err = -1;
+	struct perf_session *session;
+	struct perf_data_file file = {
+			.path = input_name,
+			.mode = PERF_DATA_MODE_READ,
+	};
+	struct perf_evsel *evsel;
+
+	session = perf_session__new(&file, 0, &c2c->tool);
+	if (session == NULL) {
+		pr_debug("No memory for session\n");
+		goto out;
+	}
+
+	/* setup the evsel handlers for each event type */
+	evlist__for_each(session->evlist, evsel) {
+		const char *name = perf_evsel__name(evsel);
+		unsigned int i;
+
+		for (i = 0; i < ARRAY_SIZE(handlers); i++) {
+			if (!strcmp(name, handlers[i].name))
+				evsel->handler = handlers[i].handler;
+		}
+	}
+
+	err = perf_session__process_events(session, &c2c->tool);
+	if (err)
+		pr_err("Failed to process events, error %d", err);
+
+out:
+	return err;
+}
+
+static int perf_c2c__report(struct perf_c2c *c2c)
+{
+	setup_pager();
+	return perf_c2c__read_events(c2c);
+}
+
+static int perf_c2c__record(int argc, const char **argv)
+{
+	unsigned int rec_argc, i, j;
+	const char **rec_argv;
+	const char * const record_args[] = {
+		"record",
+		/* "--phys-addr", */
+		"-W",
+		"-d",
+		"-a",
+	};
+
+	rec_argc = ARRAY_SIZE(record_args) + 2 * ARRAY_SIZE(handlers) + argc - 1;
+	rec_argv = calloc(rec_argc + 1, sizeof(char *));
+
+	if (rec_argv == NULL)
+		return -ENOMEM;
+
+	for (i = 0; i < ARRAY_SIZE(record_args); i++)
+		rec_argv[i] = strdup(record_args[i]);
+
+	for (j = 0; j < ARRAY_SIZE(handlers); j++) {
+		rec_argv[i++] = strdup("-e");
+		rec_argv[i++] = strdup(handlers[j].name);
+	}
+
+	for (j = 1; j < (unsigned int)argc; j++, i++)
+		rec_argv[i] = argv[j];
+
+	BUG_ON(i != rec_argc);
+
+	return cmd_record(i, rec_argv, NULL);
+}
+
+int cmd_c2c(int argc, const char **argv, const char *prefix __maybe_unused)
+{
+	struct perf_c2c c2c = {
+		.tool = {
+			.sample		 = perf_c2c__process_sample,
+			.comm		 = perf_event__process_comm,
+			.exit		 = perf_event__process_exit,
+			.fork		 = perf_event__process_fork,
+			.lost		 = perf_event__process_lost,
+			.ordered_samples = true,
+		},
+	};
+	const struct option c2c_options[] = {
+	OPT_END()
+	};
+	const char * const c2c_usage[] = {
+		"perf c2c {record|report}",
+		NULL
+	};
+
+	argc = parse_options(argc, argv, c2c_options, c2c_usage,
+			     PARSE_OPT_STOP_AT_NON_OPTION);
+	if (!argc)
+		usage_with_options(c2c_usage, c2c_options);
+
+	if (!strncmp(argv[0], "rec", 3)) {
+		return perf_c2c__record(argc, argv);
+	} else if (!strncmp(argv[0], "rep", 3)) {
+		return perf_c2c__report(&c2c);
+	} else {
+		usage_with_options(c2c_usage, c2c_options);
+	}
+
+	return 0;
+}
diff --git a/tools/perf/builtin.h b/tools/perf/builtin.h
index b210d62..2d0b1b5 100644
--- a/tools/perf/builtin.h
+++ b/tools/perf/builtin.h
@@ -17,6 +17,7 @@ extern int cmd_annotate(int argc, const char **argv, const char *prefix);
 extern int cmd_bench(int argc, const char **argv, const char *prefix);
 extern int cmd_buildid_cache(int argc, const char **argv, const char *prefix);
 extern int cmd_buildid_list(int argc, const char **argv, const char *prefix);
+extern int cmd_c2c(int argc, const char **argv, const char *prefix);
 extern int cmd_diff(int argc, const char **argv, const char *prefix);
 extern int cmd_evlist(int argc, const char **argv, const char *prefix);
 extern int cmd_help(int argc, const char **argv, const char *prefix);
diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index 431798a..c7012a3 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -35,6 +35,7 @@ struct cmd_struct {
 static struct cmd_struct commands[] = {
 	{ "buildid-cache", cmd_buildid_cache, 0 },
 	{ "buildid-list", cmd_buildid_list, 0 },
+	{ "c2c",	cmd_c2c,	0 },
 	{ "diff",	cmd_diff,	0 },
 	{ "evlist",	cmd_evlist,	0 },
 	{ "help",	cmd_help,	0 },
-- 
1.7.11.7

