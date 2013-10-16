Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758591Ab3JPFCb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 01:02:31 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:59850 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752336Ab3JPFA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 01:00:29 -0400
X-AuditID: 9c93016f-b7c63ae00000696f-36-525e1d689ccf
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Stephane Eranian <eranian@google.com>, Jeremy Eder <jeder@redhat.com>
Subject: [PATCH 12/18] perf ftrace: Cleanup using ftrace_setup/teardown()
Date: Wed, 16 Oct 2013 14:00:15 +0900
Message-Id: <1381899621-14638-13-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1381899621-14638-1-git-send-email-namhyung@kernel.org>
References: <1381899621-14638-1-git-send-email-namhyung@kernel.org>
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
 tools/perf/builtin-ftrace.c | 172 +++++++++++++++++---------------------------
 1 file changed, 65 insertions(+), 107 deletions(-)

diff --git a/tools/perf/builtin-ftrace.c b/tools/perf/builtin-ftrace.c
index 83ed6d797087..fa7a9c59e228 100644
--- a/tools/perf/builtin-ftrace.c
+++ b/tools/perf/builtin-ftrace.c
@@ -1413,10 +1413,59 @@ out:
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
@@ -1441,47 +1490,22 @@ __cmd_ftrace_live(struct perf_ftrace *ftrace, int argc, const char **argv)
 	if (!argc && perf_target__none(&ftrace->target))
 		usage_with_options(live_usage, live_options);
 
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
 
 	setup_pager();
 
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
@@ -1508,48 +1532,20 @@ __cmd_ftrace_record(struct perf_ftrace *ftrace, int argc, const char **argv)
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
-	perf_evlist__delete_maps(ftrace->evlist);
-out:
-	perf_evlist__delete(ftrace->evlist);
-
+	ftrace_teardown(ftrace);
 	return ret;
 }
 
 static int
 __cmd_ftrace_show(struct perf_ftrace *ftrace, int argc, const char **argv)
 {
-	int ret = -1;
+	int ret;
 	const char * const show_usage[] = {
 		"perf ftrace show [<options>]",
 		NULL
@@ -1569,41 +1565,22 @@ __cmd_ftrace_show(struct perf_ftrace *ftrace, int argc, const char **argv)
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
-
-	ret = perf_evlist__create_maps(ftrace->evlist, &ftrace->target);
+	ret = ftrace_setup(ftrace, argc, argv);
 	if (ret < 0)
-		goto out;
-
-	if (ftrace->dirname == NULL)
-		ftrace->dirname = DEFAULT_DIRNAME;
+		return ret;
 
 	setup_pager();
 
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
@@ -1629,25 +1606,9 @@ __cmd_ftrace_report(struct perf_ftrace *ftrace, int argc, const char **argv)
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
+	ret = ftrace_setup(ftrace, argc, argv);
 	if (ret < 0)
-		goto out;
-
-	if (ftrace->dirname == NULL)
-		ftrace->dirname = DEFAULT_DIRNAME;
+		return ret;
 
 	perf_hpp__init();
 
@@ -1660,10 +1621,7 @@ __cmd_ftrace_report(struct perf_ftrace *ftrace, int argc, const char **argv)
 
 	ret = do_ftrace_report(ftrace);
 
-	perf_evlist__delete_maps(ftrace->evlist);
-out:
-	perf_evlist__delete(ftrace->evlist);
-
+	ftrace_teardown(ftrace);
 	return ret;
 }
 
-- 
1.7.11.7

