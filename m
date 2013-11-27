Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932115Ab3K0USM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 15:18:12 -0500
Received: from merlin.infradead.org ([205.233.59.134]:32874 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757927Ab3K0URG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 15:17:06 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Stanislav Fomichev <stfomichev@yandex-team.ru>,
        Ingo Molnar <mingo@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 19/34] perf timechart: Add support for -P and -T in timechart recording
Date: Wed, 27 Nov 2013 17:16:19 -0300
Message-Id: <1385583394-3703-20-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1385583394-3703-1-git-send-email-acme@infradead.org>
References: <1385583394-3703-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stanislav Fomichev <stfomichev@yandex-team.ru>

If we don't want either power or task events we may use -T or -P with
the `perf timechart record` command to filter out events while recording
to keep perf.data small.

Signed-off-by: Stanislav Fomichev <stfomichev@yandex-team.ru>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1383323151-19810-7-git-send-email-stfomichev@yandex-team.ru
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-timechart.txt |  16 +++--
 tools/perf/builtin-timechart.c              | 101 +++++++++++++++++++++-------
 2 files changed, 87 insertions(+), 30 deletions(-)

diff --git a/tools/perf/Documentation/perf-timechart.txt b/tools/perf/Documentation/perf-timechart.txt
index d8441894d9ec..8359cfadf0ac 100644
--- a/tools/perf/Documentation/perf-timechart.txt
+++ b/tools/perf/Documentation/perf-timechart.txt
@@ -8,8 +8,7 @@ perf-timechart - Tool to visualize total system behavior during a workload
 SYNOPSIS
 --------
 [verse]
-'perf timechart' record <command>
-'perf timechart' [<options>]
+'perf timechart' [<timechart options>] {record} [<record options>]
 
 DESCRIPTION
 -----------
@@ -21,8 +20,8 @@ There are two variants of perf timechart:
   'perf timechart' to turn a trace into a Scalable Vector Graphics file,
   that can be viewed with popular SVG viewers such as 'Inkscape'.
 
-OPTIONS
--------
+TIMECHART OPTIONS
+-----------------
 -o::
 --output=::
         Select the output file (default: output.svg)
@@ -61,6 +60,15 @@ $ perf timechart
 --proc-num::
         Print task info for at least given number of tasks.
 
+RECORD OPTIONS
+--------------
+-P::
+--power-only::
+        Record only power-related events
+-T::
+--tasks-only::
+        Record only tasks-related events
+
 SEE ALSO
 --------
 linkperf:perf-record[1]
diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index 6a848b8c4c16..1c60ed3f5b97 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -1040,50 +1040,81 @@ out_delete:
 
 static int __cmd_record(int argc, const char **argv)
 {
-#ifdef SUPPORT_OLD_POWER_EVENTS
-	const char * const record_old_args[] = {
+	unsigned int rec_argc, i, j;
+	const char **rec_argv;
+	const char **p;
+	unsigned int record_elems;
+
+	const char * const common_args[] = {
 		"record", "-a", "-R", "-c", "1",
+	};
+	unsigned int common_args_nr = ARRAY_SIZE(common_args);
+
+	const char * const power_args[] = {
+		"-e", "power:cpu_frequency",
+		"-e", "power:cpu_idle",
+	};
+	unsigned int power_args_nr = ARRAY_SIZE(power_args);
+
+	const char * const old_power_args[] = {
+#ifdef SUPPORT_OLD_POWER_EVENTS
 		"-e", "power:power_start",
 		"-e", "power:power_end",
 		"-e", "power:power_frequency",
-		"-e", "sched:sched_wakeup",
-		"-e", "sched:sched_switch",
-	};
 #endif
-	const char * const record_new_args[] = {
-		"record", "-a", "-R", "-c", "1",
-		"-e", "power:cpu_frequency",
-		"-e", "power:cpu_idle",
+	};
+	unsigned int old_power_args_nr = ARRAY_SIZE(old_power_args);
+
+	const char * const tasks_args[] = {
 		"-e", "sched:sched_wakeup",
 		"-e", "sched:sched_switch",
 	};
-	unsigned int rec_argc, i, j;
-	const char **rec_argv;
-	const char * const *record_args = record_new_args;
-	unsigned int record_elems = ARRAY_SIZE(record_new_args);
+	unsigned int tasks_args_nr = ARRAY_SIZE(tasks_args);
 
 #ifdef SUPPORT_OLD_POWER_EVENTS
 	if (!is_valid_tracepoint("power:cpu_idle") &&
 	    is_valid_tracepoint("power:power_start")) {
 		use_old_power_events = 1;
-		record_args = record_old_args;
-		record_elems = ARRAY_SIZE(record_old_args);
+		power_args_nr = 0;
+	} else {
+		old_power_args_nr = 0;
 	}
 #endif
 
-	rec_argc = record_elems + argc - 1;
+	if (power_only)
+		tasks_args_nr = 0;
+
+	if (tasks_only) {
+		power_args_nr = 0;
+		old_power_args_nr = 0;
+	}
+
+	record_elems = common_args_nr + tasks_args_nr +
+		power_args_nr + old_power_args_nr;
+
+	rec_argc = record_elems + argc;
 	rec_argv = calloc(rec_argc + 1, sizeof(char *));
 
 	if (rec_argv == NULL)
 		return -ENOMEM;
 
-	for (i = 0; i < record_elems; i++)
-		rec_argv[i] = strdup(record_args[i]);
+	p = rec_argv;
+	for (i = 0; i < common_args_nr; i++)
+		*p++ = strdup(common_args[i]);
+
+	for (i = 0; i < tasks_args_nr; i++)
+		*p++ = strdup(tasks_args[i]);
+
+	for (i = 0; i < power_args_nr; i++)
+		*p++ = strdup(power_args[i]);
 
-	for (j = 1; j < (unsigned int)argc; j++, i++)
-		rec_argv[i] = argv[j];
+	for (i = 0; i < old_power_args_nr; i++)
+		*p++ = strdup(old_power_args[i]);
 
-	return cmd_record(i, rec_argv, NULL);
+	for (j = 1; j < (unsigned int)argc; j++)
+		*p++ = argv[j];
+
+	return cmd_record(rec_argc, rec_argv, NULL);
 }
 
 static int
@@ -1099,7 +1130,7 @@ int cmd_timechart(int argc, const char **argv,
 		  const char *prefix __maybe_unused)
 {
 	const char *output_name = "output.svg";
-	const struct option options[] = {
+	const struct option timechart_options[] = {
 	OPT_STRING('i', "input", &input_name, "file", "input file name"),
 	OPT_STRING('o', "output", &output_name, "file", "output file name"),
 	OPT_INTEGER('w', "width", &svg_page_width, "page width"),
@@ -1120,7 +1151,17 @@ int cmd_timechart(int argc, const char **argv,
 		NULL
 	};
 
-	argc = parse_options(argc, argv, options, timechart_usage,
+	const struct option record_options[] = {
+	OPT_BOOLEAN('P', "power-only", &power_only, "output power data only"),
+	OPT_BOOLEAN('T', "tasks-only", &tasks_only,
+		    "output processes data only"),
+	OPT_END()
+	};
+	const char * const record_usage[] = {
+		"perf timechart record [<options>]",
+		NULL
+	};
+	argc = parse_options(argc, argv, timechart_options, timechart_usage,
 			PARSE_OPT_STOP_AT_NON_OPTION);
 
 	if (power_only && tasks_only) {
@@ -1130,10 +1171,18 @@ int cmd_timechart(int argc, const char **argv,
 
 	symbol__init();
 
-	if (argc && !strncmp(argv[0], "rec", 3))
+	if (argc && !strncmp(argv[0], "rec", 3)) {
+		argc = parse_options(argc, argv, record_options, record_usage,
+				     PARSE_OPT_STOP_AT_NON_OPTION);
+
+		if (power_only && tasks_only) {
+			pr_err("-P and -T options cannot be used at the same time.\n");
+			return -1;
+		}
+
 		return __cmd_record(argc, argv);
-	else if (argc)
-		usage_with_options(timechart_usage, options);
+	} else if (argc)
+		usage_with_options(timechart_usage, timechart_options);
 
 	setup_pager();
 
-- 
1.8.1.4

