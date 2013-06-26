Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751982Ab3FZHPq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 03:15:46 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:60899 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751843Ab3FZHOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 03:14:33 -0400
X-AuditID: 9c930179-b7cafae000004567-99-51ca94d31905
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>
Subject: [PATCH 14/19] perf ftrace: Cleanup using ftrace_setup/teardown()
Date: Wed, 26 Jun 2013 16:14:17 +0900
Message-Id: <1372230862-15861-15-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1372230862-15861-1-git-send-email-namhyung@kernel.org>
References: <1372230862-15861-1-git-send-email-namhyung@kernel.org>
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
 tools/perf/builtin-ftrace.c | 168 +++++++++++++++++---------------------------
 1 file changed, 64 insertions(+), 104 deletions(-)

diff --git a/tools/perf/builtin-ftrace.c b/tools/perf/builtin-ftrace.c
index 8bb2604517cc..698dd0b5cecf 100644
--- a/tools/perf/builtin-ftrace.c
+++ b/tools/perf/builtin-ftrace.c
@@ -1363,10 +1363,59 @@ out:
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
@@ -1391,47 +1440,22 @@ __cmd_ftrace_live(struct perf_ftrace *ftrace, int argc, const char **argv)
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
@@ -1458,39 +1482,13 @@ __cmd_ftrace_record(struct perf_ftrace *ftrace, int argc, const char **argv)
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
@@ -1499,7 +1497,7 @@ out:
 static int
 __cmd_ftrace_show(struct perf_ftrace *ftrace, int argc, const char **argv)
 {
-	int ret = -1;
+	int ret;
 	const char * const show_usage[] = {
 		"perf ftrace show [<options>]",
 		NULL
@@ -1519,41 +1517,22 @@ __cmd_ftrace_show(struct perf_ftrace *ftrace, int argc, const char **argv)
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
@@ -1579,25 +1558,9 @@ __cmd_ftrace_report(struct perf_ftrace *ftrace, int argc, const char **argv)
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
 
 	perf_hpp__column_enable(PERF_HPP__OVERHEAD);
 	perf_hpp__init();
@@ -1611,10 +1574,7 @@ __cmd_ftrace_report(struct perf_ftrace *ftrace, int argc, const char **argv)
 
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

