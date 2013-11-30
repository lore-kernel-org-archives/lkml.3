Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753203Ab3K3MwX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 07:52:23 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59673 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753025Ab3K3MwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 07:52:17 -0500
Date: Sat, 30 Nov 2013 04:52:01 -0800
From: tip-bot for Stanislav Fomichev <tipbot@zytor.com>
Message-ID: <tip-367b3152d72c20d789b07650bd1189ce0fe266b8@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, namhyung@kernel.org, stfomichev@yandex-team.ru,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, stfomichev@yandex-team.ru, tglx@linutronix.de
In-Reply-To: <1383323151-19810-7-git-send-email-stfomichev@yandex-team.ru>
References: <1383323151-19810-7-git-send-email-stfomichev@yandex-team.ru>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf timechart:
  Add support for -P and -T in timechart recording
Git-Commit-ID: 367b3152d72c20d789b07650bd1189ce0fe266b8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sat, 30 Nov 2013 04:52:08 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  367b3152d72c20d789b07650bd1189ce0fe266b8
Gitweb:     http://git.kernel.org/tip/367b3152d72c20d789b07650bd1189ce0fe266b8
Author:     Stanislav Fomichev <stfomichev@yandex-team.ru>
AuthorDate: Fri, 1 Nov 2013 20:25:50 +0400
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 27 Nov 2013 14:58:37 -0300

perf timechart: Add support for -P and -T in timechart recording

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
index d844189..8359cfa 100644
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
index 6a848b8..1c60ed3 100644
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
 
