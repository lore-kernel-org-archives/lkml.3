Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751824Ab3FZHOb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 03:14:31 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:57313 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734Ab3FZHO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 03:14:29 -0400
X-AuditID: 9c930179-b7cafae000004567-87-51ca94d1a60a
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>
Subject: [PATCH 08/19] perf ftrace: Split "live" sub-command
Date: Wed, 26 Jun 2013 16:14:11 +0900
Message-Id: <1372230862-15861-9-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1372230862-15861-1-git-send-email-namhyung@kernel.org>
References: <1372230862-15861-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Separate out the default behavior to "live" subcommand.  It's a
preparation to support more subcommands like "record" and "report".

Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-ftrace.c | 109 +++++++++++++++++++++++++++-----------------
 1 file changed, 68 insertions(+), 41 deletions(-)

diff --git a/tools/perf/builtin-ftrace.c b/tools/perf/builtin-ftrace.c
index efe907e4bd56..4ec96413d3a5 100644
--- a/tools/perf/builtin-ftrace.c
+++ b/tools/perf/builtin-ftrace.c
@@ -170,7 +170,7 @@ static int reset_tracing_cpu(void)
 	return 0;
 }
 
-static int __cmd_ftrace(struct perf_ftrace *ftrace, int argc, const char **argv)
+static int do_ftrace_live(struct perf_ftrace *ftrace)
 {
 	char *trace_file;
 	int trace_fd;
@@ -179,11 +179,6 @@ static int __cmd_ftrace(struct perf_ftrace *ftrace, int argc, const char **argv)
 		.events = POLLIN,
 	};
 
-	if (geteuid() != 0) {
-		pr_err("ftrace only works for root!\n");
-		return -1;
-	}
-
 	signal(SIGINT, sig_handler);
 	signal(SIGUSR1, sig_handler);
 	signal(SIGCHLD, sig_handler);
@@ -195,12 +190,6 @@ static int __cmd_ftrace(struct perf_ftrace *ftrace, int argc, const char **argv)
 	if (write_tracing_file("trace", "0") < 0)
 		goto out;
 
-	if (argc && perf_evlist__prepare_workload(ftrace->evlist,
-						  &ftrace->target,
-						  argv, false, true) < 0) {
-		goto out;
-	}
-
 	if (set_tracing_pid(ftrace) < 0) {
 		pr_err("failed to set ftrace pid\n");
 		goto out_reset;
@@ -273,61 +262,99 @@ out:
 	return done ? 0 : -1;
 }
 
-int cmd_ftrace(int argc, const char **argv, const char *prefix __maybe_unused)
+static int
+__cmd_ftrace_live(struct perf_ftrace *ftrace, int argc, const char **argv)
 {
-	int ret;
-	struct perf_ftrace ftrace = {
-		.target = { .uid = UINT_MAX, },
-	};
-	const char * const ftrace_usage[] = {
-		"perf ftrace [<options>] [<command>]",
-		"perf ftrace [<options>] -- <command> [<options>]",
+	int ret = -1;
+	const char * const live_usage[] = {
+		"perf ftrace live [<options>] [<command>]",
+		"perf ftrace live [<options>] -- <command> [<options>]",
 		NULL
 	};
-	const struct option ftrace_options[] = {
-	OPT_STRING('t', "tracer", &ftrace.tracer, "tracer",
+	const struct option live_options[] = {
+	OPT_STRING('t', "tracer", &ftrace->tracer, "tracer",
 		   "tracer to use"),
-	OPT_STRING('p', "pid", &ftrace.target.tid, "pid",
+	OPT_STRING('p', "pid", &ftrace->target.tid, "pid",
 		   "trace on existing process id"),
 	OPT_INCR('v', "verbose", &verbose,
 		 "be more verbose"),
-	OPT_BOOLEAN('a', "all-cpus", &ftrace.target.system_wide,
+	OPT_BOOLEAN('a', "all-cpus", &ftrace->target.system_wide,
 		    "system-wide collection from all CPUs"),
-	OPT_STRING('C', "cpu", &ftrace.target.cpu_list, "cpu",
+	OPT_STRING('C', "cpu", &ftrace->target.cpu_list, "cpu",
 		    "list of cpus to monitor"),
 	OPT_END()
 	};
 
-	argc = parse_options(argc, argv, ftrace_options, ftrace_usage,
-			    PARSE_OPT_STOP_AT_NON_OPTION);
-	if (!argc && perf_target__none(&ftrace.target))
-		usage_with_options(ftrace_usage, ftrace_options);
+	argc = parse_options(argc, argv, live_options, live_usage,
+			     PARSE_OPT_STOP_AT_NON_OPTION);
+	if (!argc && perf_target__none(&ftrace->target))
+		usage_with_options(live_usage, live_options);
 
-	ret = perf_target__validate(&ftrace.target);
+	ret = perf_target__validate(&ftrace->target);
 	if (ret) {
 		char errbuf[512];
 
-		perf_target__strerror(&ftrace.target, ret, errbuf, 512);
+		perf_target__strerror(&ftrace->target, ret, errbuf, 512);
 		pr_err("%s\n", errbuf);
 		return -EINVAL;
 	}
 
-	ftrace.evlist = perf_evlist__new();
-	if (ftrace.evlist == NULL)
+	ftrace->evlist = perf_evlist__new();
+	if (ftrace->evlist == NULL)
 		return -ENOMEM;
 
-	ret = perf_evlist__create_maps(ftrace.evlist, &ftrace.target);
+	ret = perf_evlist__create_maps(ftrace->evlist, &ftrace->target);
 	if (ret < 0)
-		goto out_delete_evlist;
+		goto out;
 
-	if (ftrace.tracer == NULL)
-		ftrace.tracer = DEFAULT_TRACER;
+	if (ftrace->tracer == NULL)
+		ftrace->tracer = DEFAULT_TRACER;
 
-	ret = __cmd_ftrace(&ftrace, argc, argv);
+	if (argc && perf_evlist__prepare_workload(ftrace->evlist,
+						  &ftrace->target,
+						  argv, false, true) < 0)
+		goto out_maps;
+
+	ret = do_ftrace_live(ftrace);
 
-	perf_evlist__delete_maps(ftrace.evlist);
-out_delete_evlist:
-	perf_evlist__delete(ftrace.evlist);
+out_maps:
+	perf_evlist__delete_maps(ftrace->evlist);
+out:
+	perf_evlist__delete(ftrace->evlist);
+
+	return ret;
+}
+
+int cmd_ftrace(int argc, const char **argv, const char *prefix __maybe_unused)
+{
+	int ret;
+	struct perf_ftrace ftrace = {
+		.target = { .uid = UINT_MAX, },
+	};
+	const char * const ftrace_usage[] = {
+		"perf ftrace {live} [<options>] [<command>]",
+		"perf ftrace {live} [<options>] -- <command> [<options>]",
+		NULL
+	};
+	const struct option ftrace_options[] = {
+	OPT_END()
+	};
+
+	argc = parse_options(argc, argv, ftrace_options, ftrace_usage,
+			     PARSE_OPT_STOP_AT_NON_OPTION);
+	if (!argc)
+		usage_with_options(ftrace_usage, ftrace_options);
+
+	if (geteuid() != 0) {
+		pr_err("ftrace only works for root!\n");
+		return -1;
+	}
+
+	if (strcmp(argv[0], "live") == 0) {
+		ret = __cmd_ftrace_live(&ftrace, argc, argv);
+	} else {
+		usage_with_options(ftrace_usage, ftrace_options);
+	}
 
 	return ret;
 }
-- 
1.7.11.7

