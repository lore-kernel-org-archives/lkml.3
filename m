Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757106Ab3ENKRT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 06:17:19 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:43979 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756578Ab3ENKOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 06:14:04 -0400
X-AuditID: 9c930197-b7b76ae000003523-32-51920e69cd13
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>
Subject: [PATCH 05/15] perf tools: Introduce new 'ftrace' tool
Date: Tue, 14 May 2013 19:13:49 +0900
Message-Id: <1368526439-31966-6-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1368526439-31966-1-git-send-email-namhyung@kernel.org>
References: <1368526439-31966-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The ftrace command is a simple wrapper of kernel's ftrace
functionality.  It only supports single thread tracing currently and
just reads trace_pipe in text and then write it to stdout.

Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/Makefile         |   1 +
 tools/perf/builtin-ftrace.c | 227 ++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/builtin.h        |   1 +
 tools/perf/command-list.txt |   1 +
 tools/perf/perf.c           |   1 +
 5 files changed, 231 insertions(+)
 create mode 100644 tools/perf/builtin-ftrace.c

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index b0f164b133d9..7c03e9d0e560 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -552,6 +552,7 @@ BUILTIN_OBJS += $(OUTPUT)builtin-kmem.o
 BUILTIN_OBJS += $(OUTPUT)builtin-lock.o
 BUILTIN_OBJS += $(OUTPUT)builtin-kvm.o
 BUILTIN_OBJS += $(OUTPUT)builtin-inject.o
+BUILTIN_OBJS += $(OUTPUT)builtin-ftrace.o
 BUILTIN_OBJS += $(OUTPUT)tests/builtin-test.o
 BUILTIN_OBJS += $(OUTPUT)builtin-mem.o
 
diff --git a/tools/perf/builtin-ftrace.c b/tools/perf/builtin-ftrace.c
new file mode 100644
index 000000000000..a3ad246bbf54
--- /dev/null
+++ b/tools/perf/builtin-ftrace.c
@@ -0,0 +1,227 @@
+/*
+ * builtin-ftrace.c
+ *
+ * Copyright (c) 2013  LG Electronics,  Namhyung Kim <namhyung@kernel.org>
+ *
+ * Released under the GPL v2.
+ */
+
+#include "builtin.h"
+#include "perf.h"
+
+#include <unistd.h>
+#include <signal.h>
+
+#include "util/debug.h"
+#include "util/parse-options.h"
+#include "util/evlist.h"
+#include "util/target.h"
+#include "util/thread_map.h"
+
+
+#define DEFAULT_TRACER  "function_graph"
+
+struct perf_ftrace {
+	struct perf_evlist *evlist;
+	struct perf_target target;
+	const char *tracer;
+};
+
+static bool done;
+
+static void sig_handler(int sig __maybe_unused)
+{
+	done = true;
+}
+
+static int write_tracing_file(const char *name, const char *val)
+{
+	char *file;
+	int fd, ret = -1;
+	ssize_t size = strlen(val);
+
+	file = get_tracing_file(name);
+	if (!file) {
+		pr_debug("cannot get tracing file: %s\n", name);
+		return -1;
+	}
+
+	fd = open(file, O_WRONLY);
+	if (fd < 0) {
+		pr_debug("cannot open tracing file: %s\n", name);
+		goto out;
+	}
+
+	if (write(fd, val, size) == size)
+		ret = 0;
+	else
+		pr_debug("write '%s' to tracing/%s failed\n", val, name);
+
+out:
+	put_tracing_file(file);
+	return ret;
+}
+
+static int reset_tracing_files(struct perf_ftrace *ftrace __maybe_unused)
+{
+	if (write_tracing_file("tracing_on", "0") < 0)
+		return -1;
+
+	if (write_tracing_file("current_tracer", "nop") < 0)
+		return -1;
+
+	if (write_tracing_file("set_ftrace_pid", " ") < 0)
+		return -1;
+
+	return 0;
+}
+
+static int __cmd_ftrace(struct perf_ftrace *ftrace, int argc, const char **argv)
+{
+	char *trace_file;
+	int trace_fd;
+	char *trace_pid;
+	char buf[4096];
+	struct pollfd pollfd = {
+		.events = POLLIN,
+	};
+
+	if (geteuid() != 0) {
+		pr_err("ftrace only works for root!\n");
+		return -1;
+	}
+
+	if (argc < 1)
+		return -1;
+
+	signal(SIGINT, sig_handler);
+	signal(SIGUSR1, sig_handler);
+	signal(SIGCHLD, sig_handler);
+
+	reset_tracing_files(ftrace);
+
+	/* reset ftrace buffer */
+	if (write_tracing_file("trace", "0") < 0)
+		goto out;
+
+	if (perf_evlist__prepare_workload(ftrace->evlist, &ftrace->target,
+					  argv, false, true) < 0)
+		goto out;
+
+	if (write_tracing_file("current_tracer", ftrace->tracer) < 0) {
+		pr_err("failed to set current_tracer to %s\n", ftrace->tracer);
+		goto out;
+	}
+
+	if (asprintf(&trace_pid, "%d", ftrace->evlist->threads->map[0]) < 0) {
+		pr_err("failed to allocate pid string\n");
+		goto out;
+	}
+
+	if (write_tracing_file("set_ftrace_pid", trace_pid) < 0) {
+		pr_err("failed to set pid: %s\n", trace_pid);
+		goto out_free_pid;
+	}
+
+	trace_file = get_tracing_file("trace_pipe");
+	if (!trace_file) {
+		pr_err("failed to open trace_pipe\n");
+		goto out_free_pid;
+	}
+
+	trace_fd = open(trace_file, O_RDONLY);
+
+	put_tracing_file(trace_file);
+
+	if (trace_fd < 0) {
+		pr_err("failed to open trace_pipe\n");
+		goto out_free_pid;
+	}
+
+	fcntl(trace_fd, F_SETFL, O_NONBLOCK);
+	pollfd.fd = trace_fd;
+
+	if (write_tracing_file("tracing_on", "1") < 0) {
+		pr_err("can't enable tracing\n");
+		goto out_close_fd;
+	}
+
+	perf_evlist__start_workload(ftrace->evlist);
+
+	while (!done) {
+		if (poll(&pollfd, 1, -1) < 0)
+			break;
+
+		if (pollfd.revents & POLLIN) {
+			int n = read(trace_fd, buf, sizeof(buf));
+			if (n < 0)
+				break;
+			if (fwrite(buf, n, 1, stdout) != 1)
+				break;
+		}
+	}
+
+	write_tracing_file("tracing_on", "0");
+
+	/* read remaining buffer contents */
+	while (true) {
+		int n = read(trace_fd, buf, sizeof(buf));
+		if (n <= 0)
+			break;
+		if (fwrite(buf, n, 1, stdout) != 1)
+			break;
+	}
+
+out_close_fd:
+	close(trace_fd);
+out_free_pid:
+	free(trace_pid);
+out:
+	reset_tracing_files(ftrace);
+
+	return done ? 0 : -1;
+}
+
+int cmd_ftrace(int argc, const char **argv, const char *prefix __maybe_unused)
+{
+	int ret;
+	struct perf_ftrace ftrace = {
+		.target = { .uid = UINT_MAX, },
+	};
+	const char * const ftrace_usage[] = {
+		"perf ftrace [<options>] [<command>]",
+		"perf ftrace [<options>] -- <command> [<options>]",
+		NULL
+	};
+	const struct option ftrace_options[] = {
+	OPT_STRING('t', "tracer", &ftrace.tracer, "tracer",
+		   "tracer to use"),
+	OPT_INCR('v', "verbose", &verbose,
+		 "be more verbose"),
+	OPT_END()
+	};
+
+	argc = parse_options(argc, argv, ftrace_options, ftrace_usage,
+			    PARSE_OPT_STOP_AT_NON_OPTION);
+	if (!argc)
+		usage_with_options(ftrace_usage, ftrace_options);
+
+	ftrace.evlist = perf_evlist__new();
+	if (ftrace.evlist == NULL)
+		return -ENOMEM;
+
+	ret = perf_evlist__create_maps(ftrace.evlist, &ftrace.target);
+	if (ret < 0)
+		goto out_delete_evlist;
+
+	if (ftrace.tracer == NULL)
+		ftrace.tracer = DEFAULT_TRACER;
+
+	ret = __cmd_ftrace(&ftrace, argc, argv);
+
+	perf_evlist__delete_maps(ftrace.evlist);
+out_delete_evlist:
+	perf_evlist__delete(ftrace.evlist);
+
+	return ret;
+}
diff --git a/tools/perf/builtin.h b/tools/perf/builtin.h
index b210d62907e4..55da75c4e990 100644
--- a/tools/perf/builtin.h
+++ b/tools/perf/builtin.h
@@ -37,6 +37,7 @@ extern int cmd_test(int argc, const char **argv, const char *prefix);
 extern int cmd_trace(int argc, const char **argv, const char *prefix);
 extern int cmd_inject(int argc, const char **argv, const char *prefix);
 extern int cmd_mem(int argc, const char **argv, const char *prefix);
+extern int cmd_ftrace(int argc, const char **argv, const char *prefix);
 
 extern int find_scripts(char **scripts_array, char **scripts_path_array);
 #endif
diff --git a/tools/perf/command-list.txt b/tools/perf/command-list.txt
index 0906fc401c52..c24d76e61bc1 100644
--- a/tools/perf/command-list.txt
+++ b/tools/perf/command-list.txt
@@ -9,6 +9,7 @@ perf-buildid-cache		mainporcelain common
 perf-buildid-list		mainporcelain common
 perf-diff			mainporcelain common
 perf-evlist			mainporcelain common
+perf-ftrace			mainporcelain common
 perf-inject			mainporcelain common
 perf-kmem			mainporcelain common
 perf-kvm			mainporcelain common
diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index 85e1aed95204..8966f4b718b8 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -61,6 +61,7 @@ static struct cmd_struct commands[] = {
 #endif
 	{ "inject",	cmd_inject,	0 },
 	{ "mem",	cmd_mem,	0 },
+	{ "ftrace",	cmd_ftrace,	0 },
 };
 
 struct pager_config {
-- 
1.7.11.7

