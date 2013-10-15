Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933274Ab3JOFay (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:30:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33537 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904Ab3JOFav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:30:51 -0400
Date: Mon, 14 Oct 2013 22:30:34 -0700
From: tip-bot for David Ahern <tipbot@zytor.com>
Message-ID: <tip-5e2485b1a2813faa6b80007c653f8bbbed9457ee@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1380395584-9025-5-git-send-email-dsahern@gmail.com>
References: <1380395584-9025-5-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf trace: Add record option
Git-Commit-ID: 5e2485b1a2813faa6b80007c653f8bbbed9457ee
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:30:40 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5e2485b1a2813faa6b80007c653f8bbbed9457ee
Gitweb:     http://git.kernel.org/tip/5e2485b1a2813faa6b80007c653f8bbbed9457ee
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Sat, 28 Sep 2013 13:13:01 -0600
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 11 Oct 2013 12:17:49 -0300

perf trace: Add record option

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
index 7f70d36..1a22486 100644
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
index 5776b5f..1e2368f 100644
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
