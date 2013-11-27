Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758256Ab3K0UV0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 15:21:26 -0500
Received: from merlin.infradead.org ([205.233.59.134]:32836 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757906Ab3K0URE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 15:17:04 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Stanislav Fomichev <stfomichev@yandex-team.ru>,
        Ingo Molnar <mingo@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 17/34] perf timechart: Add support for displaying only tasks related data
Date: Wed, 27 Nov 2013 17:16:17 -0300
Message-Id: <1385583394-3703-18-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1385583394-3703-1-git-send-email-acme@infradead.org>
References: <1385583394-3703-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stanislav Fomichev <stfomichev@yandex-team.ru>

In order to make SVG smaller and faster to browse add possibility to
switch off power related information with -T switch.

Signed-off-by: Stanislav Fomichev <stfomichev@yandex-team.ru>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1383323151-19810-5-git-send-email-stfomichev@yandex-team.ru
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-timechart.txt |  3 +++
 tools/perf/builtin-timechart.c              | 11 ++++++++++-
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/tools/perf/Documentation/perf-timechart.txt b/tools/perf/Documentation/perf-timechart.txt
index 4373144a43b4..d8441894d9ec 100644
--- a/tools/perf/Documentation/perf-timechart.txt
+++ b/tools/perf/Documentation/perf-timechart.txt
@@ -35,6 +35,9 @@ OPTIONS
 -P::
 --power-only::
         Only output the CPU power section of the diagram
+-T::
+--tasks-only::
+        Don't output processor state transitions
 -p::
 --process::
         Select the processes to display, by name or PID
diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index 6410c9ead9e2..b3f175a30d94 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -51,6 +51,7 @@ static u64		turbo_frequency;
 static u64		first_time, last_time;
 
 static bool		power_only;
+static bool		tasks_only;
 
 
 struct per_pid;
@@ -971,7 +972,8 @@ static void write_svg_file(const char *filename)
 	draw_cpu_usage();
 	if (proc_num)
 		draw_process_bars();
-	draw_c_p_states();
+	if (!tasks_only)
+		draw_c_p_states();
 	if (proc_num)
 		draw_wakeups();
 
@@ -1102,6 +1104,8 @@ int cmd_timechart(int argc, const char **argv,
 	OPT_STRING('o', "output", &output_name, "file", "output file name"),
 	OPT_INTEGER('w', "width", &svg_page_width, "page width"),
 	OPT_BOOLEAN('P', "power-only", &power_only, "output power data only"),
+	OPT_BOOLEAN('T', "tasks-only", &tasks_only,
+		    "output processes data only"),
 	OPT_CALLBACK('p', "process", NULL, "process",
 		      "process selector. Pass a pid or process name.",
 		       parse_process),
@@ -1119,6 +1123,11 @@ int cmd_timechart(int argc, const char **argv,
 	argc = parse_options(argc, argv, options, timechart_usage,
 			PARSE_OPT_STOP_AT_NON_OPTION);
 
+	if (power_only && tasks_only) {
+		pr_err("-P and -T options cannot be used at the same time.\n");
+		return -1;
+	}
+
 	symbol__init();
 
 	if (argc && !strncmp(argv[0], "rec", 3))
-- 
1.8.1.4

