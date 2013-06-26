Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751891Ab3FZHSE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 03:18:04 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:58756 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020Ab3FZHO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 03:14:28 -0400
X-AuditID: 9c930179-b7cafae000004567-83-51ca94d13b3c
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>
Subject: [PATCH 06/19] perf ftrace: Add support for --pid option
Date: Wed, 26 Jun 2013 16:14:09 +0900
Message-Id: <1372230862-15861-7-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1372230862-15861-1-git-send-email-namhyung@kernel.org>
References: <1372230862-15861-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The -p (--pid) option enables to trace existing process by its pid.

Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-ftrace.c | 89 ++++++++++++++++++++++++++++++++-------------
 1 file changed, 63 insertions(+), 26 deletions(-)

diff --git a/tools/perf/builtin-ftrace.c b/tools/perf/builtin-ftrace.c
index a3ad246bbf54..2025161bbaed 100644
--- a/tools/perf/builtin-ftrace.c
+++ b/tools/perf/builtin-ftrace.c
@@ -11,6 +11,7 @@
 
 #include <unistd.h>
 #include <signal.h>
+#include <fcntl.h>
 
 #include "util/debug.h"
 #include "util/parse-options.h"
@@ -34,11 +35,12 @@ static void sig_handler(int sig __maybe_unused)
 	done = true;
 }
 
-static int write_tracing_file(const char *name, const char *val)
+static int __write_tracing_file(const char *name, const char *val, bool append)
 {
 	char *file;
 	int fd, ret = -1;
 	ssize_t size = strlen(val);
+	int flags = O_WRONLY;
 
 	file = get_tracing_file(name);
 	if (!file) {
@@ -46,7 +48,12 @@ static int write_tracing_file(const char *name, const char *val)
 		return -1;
 	}
 
-	fd = open(file, O_WRONLY);
+	if (append)
+		flags |= O_APPEND;
+	else
+		flags |= O_TRUNC;
+
+	fd = open(file, flags);
 	if (fd < 0) {
 		pr_debug("cannot open tracing file: %s\n", name);
 		goto out;
@@ -62,6 +69,16 @@ out:
 	return ret;
 }
 
+static int write_tracing_file(const char *name, const char *val)
+{
+	return __write_tracing_file(name, val, false);
+}
+
+static int append_tracing_file(const char *name, const char *val)
+{
+	return __write_tracing_file(name, val, true);
+}
+
 static int reset_tracing_files(struct perf_ftrace *ftrace __maybe_unused)
 {
 	if (write_tracing_file("tracing_on", "0") < 0)
@@ -76,11 +93,27 @@ static int reset_tracing_files(struct perf_ftrace *ftrace __maybe_unused)
 	return 0;
 }
 
+static int set_tracing_pid(struct perf_ftrace *ftrace)
+{
+	int i;
+	char buf[16];
+
+	if (perf_target__has_cpu(&ftrace->target))
+		return 0;
+
+	for (i = 0; i < thread_map__nr(ftrace->evlist->threads); i++) {
+		scnprintf(buf, sizeof(buf), "%d",
+			  ftrace->evlist->threads->map[i]);
+		if (append_tracing_file("set_ftrace_pid", buf) < 0)
+			return -1;
+	}
+	return 0;
+}
+
 static int __cmd_ftrace(struct perf_ftrace *ftrace, int argc, const char **argv)
 {
 	char *trace_file;
 	int trace_fd;
-	char *trace_pid;
 	char buf[4096];
 	struct pollfd pollfd = {
 		.events = POLLIN,
@@ -91,42 +124,37 @@ static int __cmd_ftrace(struct perf_ftrace *ftrace, int argc, const char **argv)
 		return -1;
 	}
 
-	if (argc < 1)
-		return -1;
-
 	signal(SIGINT, sig_handler);
 	signal(SIGUSR1, sig_handler);
 	signal(SIGCHLD, sig_handler);
 
-	reset_tracing_files(ftrace);
+	if (reset_tracing_files(ftrace) < 0)
+		goto out;
 
 	/* reset ftrace buffer */
 	if (write_tracing_file("trace", "0") < 0)
 		goto out;
 
-	if (perf_evlist__prepare_workload(ftrace->evlist, &ftrace->target,
-					  argv, false, true) < 0)
-		goto out;
-
-	if (write_tracing_file("current_tracer", ftrace->tracer) < 0) {
-		pr_err("failed to set current_tracer to %s\n", ftrace->tracer);
+	if (argc && perf_evlist__prepare_workload(ftrace->evlist,
+						  &ftrace->target,
+						  argv, false, true) < 0) {
 		goto out;
 	}
 
-	if (asprintf(&trace_pid, "%d", ftrace->evlist->threads->map[0]) < 0) {
-		pr_err("failed to allocate pid string\n");
-		goto out;
+	if (set_tracing_pid(ftrace) < 0) {
+		pr_err("failed to set ftrace pid\n");
+		goto out_reset;
 	}
 
-	if (write_tracing_file("set_ftrace_pid", trace_pid) < 0) {
-		pr_err("failed to set pid: %s\n", trace_pid);
-		goto out_free_pid;
+	if (write_tracing_file("current_tracer", ftrace->tracer) < 0) {
+		pr_err("failed to set current_tracer to %s\n", ftrace->tracer);
+		goto out_reset;
 	}
 
 	trace_file = get_tracing_file("trace_pipe");
 	if (!trace_file) {
 		pr_err("failed to open trace_pipe\n");
-		goto out_free_pid;
+		goto out_reset;
 	}
 
 	trace_fd = open(trace_file, O_RDONLY);
@@ -135,7 +163,7 @@ static int __cmd_ftrace(struct perf_ftrace *ftrace, int argc, const char **argv)
 
 	if (trace_fd < 0) {
 		pr_err("failed to open trace_pipe\n");
-		goto out_free_pid;
+		goto out_reset;
 	}
 
 	fcntl(trace_fd, F_SETFL, O_NONBLOCK);
@@ -174,11 +202,9 @@ static int __cmd_ftrace(struct perf_ftrace *ftrace, int argc, const char **argv)
 
 out_close_fd:
 	close(trace_fd);
-out_free_pid:
-	free(trace_pid);
-out:
+out_reset:
 	reset_tracing_files(ftrace);
-
+out:
 	return done ? 0 : -1;
 }
 
@@ -196,6 +222,8 @@ int cmd_ftrace(int argc, const char **argv, const char *prefix __maybe_unused)
 	const struct option ftrace_options[] = {
 	OPT_STRING('t', "tracer", &ftrace.tracer, "tracer",
 		   "tracer to use"),
+	OPT_STRING('p', "pid", &ftrace.target.tid, "pid",
+		   "trace on existing process id"),
 	OPT_INCR('v', "verbose", &verbose,
 		 "be more verbose"),
 	OPT_END()
@@ -203,9 +231,18 @@ int cmd_ftrace(int argc, const char **argv, const char *prefix __maybe_unused)
 
 	argc = parse_options(argc, argv, ftrace_options, ftrace_usage,
 			    PARSE_OPT_STOP_AT_NON_OPTION);
-	if (!argc)
+	if (!argc && perf_target__none(&ftrace.target))
 		usage_with_options(ftrace_usage, ftrace_options);
 
+	ret = perf_target__validate(&ftrace.target);
+	if (ret) {
+		char errbuf[512];
+
+		perf_target__strerror(&ftrace.target, ret, errbuf, 512);
+		pr_err("%s\n", errbuf);
+		return -EINVAL;
+	}
+
 	ftrace.evlist = perf_evlist__new();
 	if (ftrace.evlist == NULL)
 		return -ENOMEM;
-- 
1.7.11.7

