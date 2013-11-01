Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755518Ab3KAQfn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 12:35:43 -0400
Received: from forward-corp1g.mail.yandex.net ([95.108.253.251]:33657 "EHLO
	forward-corp1g.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755177Ab3KAQfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 12:35:42 -0400
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
From: Stanislav Fomichev <stfomichev@yandex-team.ru>
To: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@ghostprotocols.net, namhyung@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 4/7] perf timechart: add support for displaying only tasks related data
Date: Fri,  1 Nov 2013 20:25:48 +0400
Message-Id: <1383323151-19810-5-git-send-email-stfomichev@yandex-team.ru>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1383323151-19810-1-git-send-email-stfomichev@yandex-team.ru>
References: <1383323151-19810-1-git-send-email-stfomichev@yandex-team.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to make SVG smaller and faster to browse add possibility to
switch off power related information with -T switch.

Signed-off-by: Stanislav Fomichev <stfomichev@yandex-team.ru>
---
 tools/perf/Documentation/perf-timechart.txt |  3 +++
 tools/perf/builtin-timechart.c              | 11 ++++++++++-
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/tools/perf/Documentation/perf-timechart.txt b/tools/perf/Documentation/perf-timechart.txt
index 919cbe9ce428..a79d473394f6 100644
--- a/tools/perf/Documentation/perf-timechart.txt
+++ b/tools/perf/Documentation/perf-timechart.txt
@@ -34,6 +34,9 @@ OPTIONS
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
index 74c040abb3af..7819006387f0 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -50,6 +50,7 @@ static u64		turbo_frequency;
 static u64		first_time, last_time;
 
 static bool		power_only;
+static bool		tasks_only;
 
 
 struct per_pid;
@@ -970,7 +971,8 @@ static void write_svg_file(const char *filename)
 	draw_cpu_usage();
 	if (proc_num)
 		draw_process_bars();
-	draw_c_p_states();
+	if (!tasks_only)
+		draw_c_p_states();
 	if (proc_num)
 		draw_wakeups();
 
@@ -1096,6 +1098,8 @@ int cmd_timechart(int argc, const char **argv,
 	OPT_STRING('o', "output", &output_name, "file", "output file name"),
 	OPT_INTEGER('w', "width", &svg_page_width, "page width"),
 	OPT_BOOLEAN('P', "power-only", &power_only, "output power data only"),
+	OPT_BOOLEAN('T', "tasks-only", &tasks_only,
+		    "output processes data only"),
 	OPT_CALLBACK('p', "process", NULL, "process",
 		      "process selector. Pass a pid or process name.",
 		       parse_process),
@@ -1113,6 +1117,11 @@ int cmd_timechart(int argc, const char **argv,
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
1.8.3.2

