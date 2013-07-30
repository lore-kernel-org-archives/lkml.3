Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758515Ab3G3JT0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 05:19:26 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:64877 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758478Ab3G3JTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 05:19:23 -0400
X-AuditID: 9c930179-b7c49ae000000e68-e3-51f785174cbe
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        Jeremy Eder <jeder@redhat.com>
Subject: [PATCH 06/17] perf ftrace: Split "live" sub-command
Date: Tue, 30 Jul 2013 18:19:03 +0900
Message-Id: <1375175954-798-7-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1375175954-798-1-git-send-email-namhyung@kernel.org>
References: <1375175954-798-1-git-send-email-namhyung@kernel.org>
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
 tools/perf/builtin-ftrace.c | 133 ++++++++++++++++++++++++++------------------
 1 file changed, 80 insertions(+), 53 deletions(-)

diff --git a/tools/perf/builtin-ftrace.c b/tools/perf/builtin-ftrace.c
index 642aa49c66d7..1bb6d1ff0eb1 100644
--- a/tools/perf/builtin-ftrace.c
+++ b/tools/perf/builtin-ftrace.c
@@ -171,19 +171,13 @@ static int reset_tracing_cpu(void)
 	return 0;
 }
 
-static int __cmd_ftrace(struct perf_ftrace *ftrace, int argc, const char **argv)
+static int do_ftrace_live(struct perf_ftrace *ftrace)
 {
 	char *trace_file;
 	int trace_fd;
 	char buf[4096];
-	struct pollfd pollfd = {
-		.events = POLLIN,
-	};
-
-	if (geteuid() != 0) {
-		pr_err("ftrace only works for root!\n");
-		return -1;
-	}
+	/* sleep 1ms if no data read */
+	struct timespec req = { .tv_nsec = 1000000 };
 
 	signal(SIGINT, sig_handler);
 	signal(SIGUSR1, sig_handler);
@@ -196,12 +190,6 @@ static int __cmd_ftrace(struct perf_ftrace *ftrace, int argc, const char **argv)
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
@@ -233,7 +221,6 @@ static int __cmd_ftrace(struct perf_ftrace *ftrace, int argc, const char **argv)
 	}
 
 	fcntl(trace_fd, F_SETFL, O_NONBLOCK);
-	pollfd.fd = trace_fd;
 
 	if (write_tracing_file("tracing_on", "1") < 0) {
 		pr_err("can't enable tracing\n");
@@ -243,16 +230,18 @@ static int __cmd_ftrace(struct perf_ftrace *ftrace, int argc, const char **argv)
 	perf_evlist__start_workload(ftrace->evlist);
 
 	while (!done) {
-		if (poll(&pollfd, 1, -1) < 0)
-			break;
+		int n = read(trace_fd, buf, sizeof(buf));
 
-		if (pollfd.revents & POLLIN) {
-			int n = read(trace_fd, buf, sizeof(buf));
-			if (n < 0)
-				break;
-			if (fwrite(buf, n, 1, stdout) != 1)
+		if (n < 0) {
+			if (errno == EINTR || errno == EAGAIN)
+				goto sleep;
+			else
 				break;
-		}
+		} else if (n == 0) {
+sleep:
+			clock_nanosleep(CLOCK_MONOTONIC, 0, &req, NULL);
+		} else if (fwrite(buf, n, 1, stdout) != 1)
+			break;
 	}
 
 	write_tracing_file("tracing_on", "0");
@@ -274,61 +263,99 @@ out:
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
 		   "tracer to use: function_graph or function"),
-	OPT_STRING('p', "pid", &ftrace.target.pid, "pid",
+	OPT_STRING('p', "pid", &ftrace->target.pid, "pid",
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
+
+	if (ftrace->tracer == NULL)
+		ftrace->tracer = DEFAULT_TRACER;
+
+	if (argc && perf_evlist__prepare_workload(ftrace->evlist,
+						  &ftrace->target,
+						  argv, false, true) < 0)
+		goto out_maps;
+
+	ret = do_ftrace_live(ftrace);
+
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
 
-	if (ftrace.tracer == NULL)
-		ftrace.tracer = DEFAULT_TRACER;
+	argc = parse_options(argc, argv, ftrace_options, ftrace_usage,
+			     PARSE_OPT_STOP_AT_NON_OPTION);
+	if (!argc)
+		usage_with_options(ftrace_usage, ftrace_options);
 
-	ret = __cmd_ftrace(&ftrace, argc, argv);
+	if (geteuid() != 0) {
+		pr_err("ftrace only works for root!\n");
+		return -1;
+	}
 
-	perf_evlist__delete_maps(ftrace.evlist);
-out_delete_evlist:
-	perf_evlist__delete(ftrace.evlist);
+	if (strcmp(argv[0], "live") == 0) {
+		ret = __cmd_ftrace_live(&ftrace, argc, argv);
+	} else {
+		usage_with_options(ftrace_usage, ftrace_options);
+	}
 
 	return ret;
 }
-- 
1.7.11.7

