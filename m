Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932198Ab3JNULb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:11:31 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39136 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757796Ab3JNUDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:03:11 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 124/161] perf trace: Add record option
Date: Mon, 14 Oct 2013 17:01:53 -0300
Message-Id: <1381780950-25642-125-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1381780950-25642-1-git-send-email-acme@infradead.org>
References: <1381780950-25642-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

The record option is a convience alias to include the -e raw_syscalls:*
argument to perf-record. All other options are passed to perf-record's
handler. Resulting data file can be analyzed by perf-trace -i.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1380395584-9025-5-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-trace.txt | 12 +++++++++---
 tools/perf/builtin-trace.c              | 32 ++++++++++++++++++++++++++++++++
 2 files changed, 41 insertions(+), 3 deletions(-)

diff --git a/tools/perf/Documentation/perf-trace.txt b/tools/perf/Documentation/perf-trace.txt
index 7f70d3640edd..1a224862118f 100644
--- a/tools/perf/Documentation/perf-trace.txt
+++ b/tools/perf/Documentation/perf-trace.txt
@@ -9,6 +9,7 @@ SYNOPSIS
 --------
 [verse]
 'perf trace'
+'perf trace record'
 
 DESCRIPTION
 -----------
@@ -16,9 +17,14 @@ This command will show the events associated with the target, initially
 syscalls, but other system events like pagefaults, task lifetime events,
 scheduling events, etc.
 
-Initially this is a live mode only tool, but eventually will work with
-perf.data files like the other tools, allowing a detached 'record' from
-analysis phases.
+This is a live mode tool in addition to working with perf.data files like
+the other perf tools. Files can be generated using the 'perf record' command
+but the session needs to include the raw_syscalls events (-e 'raw_syscalls:*').
+Alernatively, the 'perf trace record' can be used as a shortcut to
+automatically include the raw_syscalls events when writing events to a file.
+
+The following options apply to perf trace; options to perf trace record are
+found in the perf record man page.
 
 OPTIONS
 -------
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 5776b5f829e1..1e2368f56a74 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -1501,6 +1501,33 @@ static int parse_target_str(struct trace *trace)
 	return 0;
 }
 
+static int trace__record(int argc, const char **argv)
+{
+	unsigned int rec_argc, i, j;
+	const char **rec_argv;
+	const char * const record_args[] = {
+		"record",
+		"-R",
+		"-m", "1024",
+		"-c", "1",
+		"-e", "raw_syscalls:sys_enter,raw_syscalls:sys_exit",
+	};
+
+	rec_argc = ARRAY_SIZE(record_args) + argc;
+	rec_argv = calloc(rec_argc + 1, sizeof(char *));
+
+	if (rec_argv == NULL)
+		return -ENOMEM;
+
+	for (i = 0; i < ARRAY_SIZE(record_args); i++)
+		rec_argv[i] = record_args[i];
+
+	for (j = 0; j < (unsigned int)argc; j++, i++)
+		rec_argv[i] = argv[j];
+
+	return cmd_record(i, rec_argv, NULL);
+}
+
 static int trace__run(struct trace *trace, int argc, const char **argv)
 {
 	struct perf_evlist *evlist = perf_evlist__new();
@@ -1788,6 +1815,8 @@ int cmd_trace(int argc, const char **argv, const char *prefix __maybe_unused)
 	const char * const trace_usage[] = {
 		"perf trace [<options>] [<command>]",
 		"perf trace [<options>] -- <command> [<options>]",
+		"perf trace record [<options>] [<command>]",
+		"perf trace record [<options>] -- <command> [<options>]",
 		NULL
 	};
 	struct trace trace = {
@@ -1844,6 +1873,9 @@ int cmd_trace(int argc, const char **argv, const char *prefix __maybe_unused)
 	int err;
 	char bf[BUFSIZ];
 
+	if ((argc > 1) && (strcmp(argv[1], "record") == 0))
+		return trace__record(argc-2, &argv[2]);
+
 	argc = parse_options(argc, argv, trace_options, trace_usage, 0);
 
 	if (output_name != NULL) {
-- 
1.8.1.4

