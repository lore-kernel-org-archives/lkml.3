Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754923Ab3KAQ2R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 12:28:17 -0400
Received: from forward-corp1e.mail.yandex.net ([77.88.60.199]:49793 "EHLO
	forward-corp1e.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754672Ab3KAQ2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 12:28:13 -0400
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
From: Stanislav Fomichev <stfomichev@yandex-team.ru>
To: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@ghostprotocols.net, namhyung@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 6/7] perf timechart: add support for -P and -T in timechart recording
Date: Fri,  1 Nov 2013 20:25:50 +0400
Message-Id: <1383323151-19810-7-git-send-email-stfomichev@yandex-team.ru>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1383323151-19810-1-git-send-email-stfomichev@yandex-team.ru>
References: <1383323151-19810-1-git-send-email-stfomichev@yandex-team.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we don't want either power or task events we may use -T or -P
with the `perf timechart record` command to filter out events while
recording to keep perf.data small.

Signed-off-by: Stanislav Fomichev <stfomichev@yandex-team.ru>
---
 tools/perf/Documentation/perf-timechart.txt |  15 ++++-
 tools/perf/builtin-timechart.c              | 101 +++++++++++++++++++++-------
 2 files changed, 87 insertions(+), 29 deletions(-)

diff --git a/tools/perf/Documentation/perf-timechart.txt b/tools/perf/Documentation/perf-timechart.txt
index a79d473394f6..abfaff2707da 100644
--- a/tools/perf/Documentation/perf-timechart.txt
+++ b/tools/perf/Documentation/perf-timechart.txt
@@ -8,7 +8,7 @@ perf-timechart - Tool to visualize total system behavior during a workload
 SYNOPSIS
 --------
 [verse]
-'perf timechart' {record}
+'perf timechart' [<timechart options>] {record} [<record options>]
 
 DESCRIPTION
 -----------
@@ -20,8 +20,8 @@ There are two variants of perf timechart:
   'perf timechart' to turn a trace into a Scalable Vector Graphics file,
   that can be viewed with popular SVG viewers such as 'Inkscape'.
 
-OPTIONS
--------
+TIMECHART OPTIONS
+-----------------
 -o::
 --output=::
         Select the output file (default: output.svg)
@@ -48,6 +48,15 @@ OPTIONS
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
index cab1d0fd3fc0..b5b2726d6e32 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -1034,50 +1034,81 @@ out_delete:
 
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
@@ -1093,7 +1124,7 @@ int cmd_timechart(int argc, const char **argv,
 		  const char *prefix __maybe_unused)
 {
 	const char *output_name = "output.svg";
-	const struct option options[] = {
+	const struct option timechart_options[] = {
 	OPT_STRING('i', "input", &input_name, "file", "input file name"),
 	OPT_STRING('o', "output", &output_name, "file", "output file name"),
 	OPT_INTEGER('w', "width", &svg_page_width, "page width"),
@@ -1114,7 +1145,17 @@ int cmd_timechart(int argc, const char **argv,
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
@@ -1124,10 +1165,18 @@ int cmd_timechart(int argc, const char **argv,
 
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
1.8.3.2

