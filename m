Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757129Ab3ENKPf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 06:15:35 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:56164 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757010Ab3ENKOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 06:14:08 -0400
X-AuditID: 9c930197-b7b76ae000003523-40-51920e6ae857
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>
Subject: [PATCH 13/15] perf ftrace: Cleanup using ftrace_setup/teardown()
Date: Tue, 14 May 2013 19:13:57 +0900
Message-Id: <1368526439-31966-14-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1368526439-31966-1-git-send-email-namhyung@kernel.org>
References: <1368526439-31966-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The ftrace sub-commands share some common code so that factor it out
to ftrace_setup() and ftrace_teardown() helpers.

Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-ftrace.c | 174 +++++++++++++++++---------------------------
 1 file changed, 67 insertions(+), 107 deletions(-)

diff --git a/tools/perf/builtin-ftrace.c b/tools/perf/builtin-ftrace.c
index 588d61de1c89..6d69bf411314 100644
--- a/tools/perf/builtin-ftrace.c
+++ b/tools/perf/builtin-ftrace.c
@@ -1445,10 +1445,59 @@ out:
 	return ret;
 }
 
+static int ftrace_setup(struct perf_ftrace *ftrace, int argc, const char **argv)
+{
+	int ret;
+	char errbuf[512];
+
+	ret = perf_target__validate(&ftrace->target);
+	if (ret) {
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
+	if (ftrace->tracer == NULL)
+		ftrace->tracer = DEFAULT_TRACER;
+
+	if (ftrace->dirname == NULL)
+		ftrace->dirname = DEFAULT_DIRNAME;
+
+	if (argc) {
+		ret = perf_evlist__prepare_workload(ftrace->evlist,
+						    &ftrace->target,
+						    argv, false, true);
+		if (ret < 0)
+			goto out_maps;
+	}
+	return 0;
+
+out_maps:
+	perf_evlist__delete_maps(ftrace->evlist);
+out:
+	perf_evlist__delete(ftrace->evlist);
+
+	return ret;
+}
+
+static void ftrace_teardown(struct perf_ftrace *ftrace)
+{
+	perf_evlist__delete_maps(ftrace->evlist);
+	perf_evlist__delete(ftrace->evlist);
+}
+
 static int
 __cmd_ftrace_live(struct perf_ftrace *ftrace, int argc, const char **argv)
 {
-	int ret = -1;
+	int ret;
 	const char * const live_usage[] = {
 		"perf ftrace live [<options>] [<command>]",
 		"perf ftrace live [<options>] -- <command> [<options>]",
@@ -1475,45 +1524,20 @@ __cmd_ftrace_live(struct perf_ftrace *ftrace, int argc, const char **argv)
 
 	setup_pager();
 
-	ret = perf_target__validate(&ftrace->target);
-	if (ret) {
-		char errbuf[512];
-
-		perf_target__strerror(&ftrace->target, ret, errbuf, 512);
-		pr_err("%s\n", errbuf);
-		return -EINVAL;
-	}
-
-	ftrace->evlist = perf_evlist__new();
-	if (ftrace->evlist == NULL)
-		return -ENOMEM;
-
-	ret = perf_evlist__create_maps(ftrace->evlist, &ftrace->target);
+	ret = ftrace_setup(ftrace, argc, argv);
 	if (ret < 0)
-		goto out;
-
-	if (ftrace->tracer == NULL)
-		ftrace->tracer = DEFAULT_TRACER;
-
-	if (argc && perf_evlist__prepare_workload(ftrace->evlist,
-						  &ftrace->target,
-						  argv, false, true) < 0)
-		goto out_maps;
+		return ret;
 
 	ret = do_ftrace_live(ftrace);
 
-out_maps:
-	perf_evlist__delete_maps(ftrace->evlist);
-out:
-	perf_evlist__delete(ftrace->evlist);
-
+	ftrace_teardown(ftrace);
 	return ret;
 }
 
 static int
 __cmd_ftrace_record(struct perf_ftrace *ftrace, int argc, const char **argv)
 {
-	int ret = -1;
+	int ret;
 	const char * const record_usage[] = {
 		"perf ftrace record [<options>] [<command>]",
 		"perf ftrace record [<options>] -- <command> [<options>]",
@@ -1540,39 +1564,13 @@ __cmd_ftrace_record(struct perf_ftrace *ftrace, int argc, const char **argv)
 	if (!argc && perf_target__none(&ftrace->target))
 		usage_with_options(record_usage, record_options);
 
-	ret = perf_target__validate(&ftrace->target);
-	if (ret) {
-		char errbuf[512];
-
-		perf_target__strerror(&ftrace->target, ret, errbuf, 512);
-		pr_err("%s\n", errbuf);
-		return -EINVAL;
-	}
-
-	ftrace->evlist = perf_evlist__new();
-	if (ftrace->evlist == NULL)
-		return -ENOMEM;
-
-	ret = perf_evlist__create_maps(ftrace->evlist, &ftrace->target);
+	ret = ftrace_setup(ftrace, argc, argv);
 	if (ret < 0)
-		goto out;
-
-	if (ftrace->tracer == NULL)
-		ftrace->tracer = DEFAULT_TRACER;
-
-	if (ftrace->dirname == NULL)
-		ftrace->dirname = DEFAULT_DIRNAME;
-
-	if (argc && perf_evlist__prepare_workload(ftrace->evlist,
-						  &ftrace->target,
-						  argv, false, true) < 0)
-		goto out_maps;
+		return ret;
 
 	ret = do_ftrace_record(ftrace);
 
-out_maps:
 	perf_evlist__delete_maps(ftrace->evlist);
-out:
 	perf_evlist__delete(ftrace->evlist);
 
 	return ret;
@@ -1581,7 +1579,7 @@ out:
 static int
 __cmd_ftrace_show(struct perf_ftrace *ftrace, int argc, const char **argv)
 {
-	int ret = -1;
+	int ret;
 	const char * const show_usage[] = {
 		"perf ftrace show [<options>]",
 		NULL
@@ -1601,41 +1599,22 @@ __cmd_ftrace_show(struct perf_ftrace *ftrace, int argc, const char **argv)
 	if (argc)
 		usage_with_options(show_usage, show_options);
 
-	ret = perf_target__validate(&ftrace->target);
-	if (ret) {
-		char errbuf[512];
-
-		perf_target__strerror(&ftrace->target, ret, errbuf, 512);
-		pr_err("%s\n", errbuf);
-		return -EINVAL;
-	}
-
-	ftrace->evlist = perf_evlist__new();
-	if (ftrace->evlist == NULL)
-		return -ENOMEM;
+	setup_pager();
 
-	ret = perf_evlist__create_maps(ftrace->evlist, &ftrace->target);
+	ret = ftrace_setup(ftrace, argc, argv);
 	if (ret < 0)
-		goto out;
-
-	if (ftrace->dirname == NULL)
-		ftrace->dirname = DEFAULT_DIRNAME;
-
-	setup_pager();
+		return ret;
 
 	ret = do_ftrace_show(ftrace);
 
-	perf_evlist__delete_maps(ftrace->evlist);
-out:
-	perf_evlist__delete(ftrace->evlist);
-
+	ftrace_teardown(ftrace);
 	return ret;
 }
 
 static int
 __cmd_ftrace_report(struct perf_ftrace *ftrace, int argc, const char **argv)
 {
-	int ret = -1;
+	int ret;
 	const char * const report_usage[] = {
 		"perf ftrace report [<options>]",
 		NULL
@@ -1661,26 +1640,6 @@ __cmd_ftrace_report(struct perf_ftrace *ftrace, int argc, const char **argv)
 	if (argc)
 		usage_with_options(report_usage, report_options);
 
-	ret = perf_target__validate(&ftrace->target);
-	if (ret) {
-		char errbuf[512];
-
-		perf_target__strerror(&ftrace->target, ret, errbuf, 512);
-		pr_err("%s\n", errbuf);
-		return -EINVAL;
-	}
-
-	ftrace->evlist = perf_evlist__new();
-	if (ftrace->evlist == NULL)
-		return -ENOMEM;
-
-	ret = perf_evlist__create_maps(ftrace->evlist, &ftrace->target);
-	if (ret < 0)
-		goto out;
-
-	if (ftrace->dirname == NULL)
-		ftrace->dirname = DEFAULT_DIRNAME;
-
 	perf_hpp__column_enable(PERF_HPP__OVERHEAD);
 	perf_hpp__init();
 
@@ -1691,12 +1650,13 @@ __cmd_ftrace_report(struct perf_ftrace *ftrace, int argc, const char **argv)
 	symbol_conf.try_vmlinux_path = false;
 	symbol__init();
 
-	ret = do_ftrace_report(ftrace);
+	ret = ftrace_setup(ftrace, argc, argv);
+	if (ret < 0)
+		return ret;
 
-	perf_evlist__delete_maps(ftrace->evlist);
-out:
-	perf_evlist__delete(ftrace->evlist);
+	ret = do_ftrace_report(ftrace);
 
+	ftrace_teardown(ftrace);
 	return ret;
 }
 
-- 
1.7.11.7

