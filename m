Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987Ab3K3M43 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 07:56:29 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59654 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752946Ab3K3Mv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 07:51:58 -0500
Date: Sat, 30 Nov 2013 04:51:43 -0800
From: tip-bot for Stanislav Fomichev <tipbot@zytor.com>
Message-ID: <tip-c87097d39dae1c42a5068e00dd3b76a4162ee0fc@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, namhyung@kernel.org, stfomichev@yandex-team.ru,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, stfomichev@yandex-team.ru, tglx@linutronix.de
In-Reply-To: <1383323151-19810-5-git-send-email-stfomichev@yandex-team.ru>
References: <1383323151-19810-5-git-send-email-stfomichev@yandex-team.ru>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf timechart:
  Add support for displaying only tasks related data
Git-Commit-ID: c87097d39dae1c42a5068e00dd3b76a4162ee0fc
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sat, 30 Nov 2013 04:51:49 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c87097d39dae1c42a5068e00dd3b76a4162ee0fc
Gitweb:     http://git.kernel.org/tip/c87097d39dae1c42a5068e00dd3b76a4162ee0fc
Author:     Stanislav Fomichev <stfomichev@yandex-team.ru>
AuthorDate: Fri, 1 Nov 2013 20:25:48 +0400
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 27 Nov 2013 14:58:37 -0300

perf timechart: Add support for displaying only tasks related data

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
index 4373144..d844189 100644
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
index 6410c9e..b3f175a 100644
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
