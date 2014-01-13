Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254AbaAMUyJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 15:54:09 -0500
Received: from merlin.infradead.org ([205.233.59.134]:40425 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010AbaAMUsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 15:48:09 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 03/38] perf evlist: Move the SIGUSR1 error reporting logic to prepare_workload
Date: Mon, 13 Jan 2014 17:47:04 -0300
Message-Id: <1389646059-24881-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1389646059-24881-1-git-send-email-acme@infradead.org>
References: <1389646059-24881-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

So that we have the boilerplate in the preparation method, instead of
open coded in tools wanting the reporting when the exec fails.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-purbdzcphdveskh7wwmnm4t7@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c    | 16 ++--------------
 tools/perf/builtin-stat.c      | 17 ++---------------
 tools/perf/builtin-trace.c     |  2 +-
 tools/perf/tests/perf-record.c |  3 +--
 tools/perf/tests/task-exit.c   | 19 ++++++++++++++-----
 tools/perf/util/evlist.c       | 12 ++++++++++--
 tools/perf/util/evlist.h       |  3 ++-
 7 files changed, 32 insertions(+), 40 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index f987d385c6f0..ea7c3060e8e7 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -390,7 +390,7 @@ static int __cmd_record(struct record *rec, int argc, const char **argv)
 	if (forks) {
 		err = perf_evlist__prepare_workload(evsel_list, &opts->target,
 						    argv, file->is_pipe,
-						    true);
+						    workload_exec_failed_signal);
 		if (err < 0) {
 			pr_err("Couldn't run the workload!\n");
 			goto out_delete_session;
@@ -507,20 +507,8 @@ static int __cmd_record(struct record *rec, int argc, const char **argv)
 	/*
 	 * Let the child rip
 	 */
-	if (forks) {
-		struct sigaction act = {
-			.sa_flags     = SA_SIGINFO,
-			.sa_sigaction = workload_exec_failed_signal,
-		};
-		/*
-		 * perf_evlist__prepare_workload will, after we call
-		 * perf_evlist__start_Workload, send a SIGUSR1 if the exec call
-		 * fails, that we will catch in workload_signal to flip
-		 * workload_exec_errno.
- 		 */
-		sigaction(SIGUSR1, &act, NULL);
+	if (forks)
 		perf_evlist__start_workload(evsel_list);
-	}
 
 	for (;;) {
 		int hits = rec->samples;
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 9d0d52d55ee6..f8456cad656d 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -58,7 +58,6 @@
 #include "util/thread.h"
 #include "util/thread_map.h"
 
-#include <signal.h>
 #include <stdlib.h>
 #include <sys/prctl.h>
 #include <locale.h>
@@ -542,8 +541,8 @@ static int __run_perf_stat(int argc, const char **argv)
 	}
 
 	if (forks) {
-		if (perf_evlist__prepare_workload(evsel_list, &target, argv,
-						  false, true) < 0) {
+		if (perf_evlist__prepare_workload(evsel_list, &target, argv, false,
+						  workload_exec_failed_signal) < 0) {
 			perror("failed to prepare workload");
 			return -1;
 		}
@@ -598,18 +597,6 @@ static int __run_perf_stat(int argc, const char **argv)
 	clock_gettime(CLOCK_MONOTONIC, &ref_time);
 
 	if (forks) {
-		struct sigaction act = {
-			.sa_flags     = SA_SIGINFO,
-			.sa_sigaction = workload_exec_failed_signal,
-		};
-		/*
-		 * perf_evlist__prepare_workload will, after we call
-		 * perf_evlist__start_Workload, send a SIGUSR1 if the exec call
-		 * fails, that we will catch in workload_signal to flip
-		 * workload_exec_errno.
- 		 */
-		sigaction(SIGUSR1, &act, NULL);
-
 		perf_evlist__start_workload(evsel_list);
 		handle_initial_delay();
 
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index c5b4bc51175c..5498eacf8fc6 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -1895,7 +1895,7 @@ static int trace__run(struct trace *trace, int argc, const char **argv)
 
 	if (forks) {
 		err = perf_evlist__prepare_workload(evlist, &trace->opts.target,
-						    argv, false, false);
+						    argv, false, NULL);
 		if (err < 0) {
 			fprintf(trace->output, "Couldn't run the workload!\n");
 			goto out_delete_maps;
diff --git a/tools/perf/tests/perf-record.c b/tools/perf/tests/perf-record.c
index eeba562920e9..fa0ed35afb9a 100644
--- a/tools/perf/tests/perf-record.c
+++ b/tools/perf/tests/perf-record.c
@@ -83,8 +83,7 @@ int test__PERF_RECORD(void)
 	 * so that we have time to open the evlist (calling sys_perf_event_open
 	 * on all the fds) and then mmap them.
 	 */
-	err = perf_evlist__prepare_workload(evlist, &opts.target, argv,
-					    false, false);
+	err = perf_evlist__prepare_workload(evlist, &opts.target, argv, false, NULL);
 	if (err < 0) {
 		pr_debug("Couldn't run the workload!\n");
 		goto out_delete_maps;
diff --git a/tools/perf/tests/task-exit.c b/tools/perf/tests/task-exit.c
index d09ab579119e..44e339d4e297 100644
--- a/tools/perf/tests/task-exit.c
+++ b/tools/perf/tests/task-exit.c
@@ -9,12 +9,21 @@
 static int exited;
 static int nr_exit;
 
-static void sig_handler(int sig)
+static void sig_handler(int sig __maybe_unused)
 {
 	exited = 1;
+}
 
-	if (sig == SIGUSR1)
-		nr_exit = -1;
+/*
+ * perf_evlist__prepare_workload will send a SIGUSR1 if the fork fails, since
+ * we asked by setting its exec_error to this handler.
+ */
+static void workload_exec_failed_signal(int signo __maybe_unused,
+					siginfo_t *info __maybe_unused,
+					void *ucontext __maybe_unused)
+{
+	exited	= 1;
+	nr_exit = -1;
 }
 
 /*
@@ -35,7 +44,6 @@ int test__task_exit(void)
 	const char *argv[] = { "true", NULL };
 
 	signal(SIGCHLD, sig_handler);
-	signal(SIGUSR1, sig_handler);
 
 	evlist = perf_evlist__new_default();
 	if (evlist == NULL) {
@@ -57,7 +65,8 @@ int test__task_exit(void)
 		goto out_delete_maps;
 	}
 
-	err = perf_evlist__prepare_workload(evlist, &target, argv, false, true);
+	err = perf_evlist__prepare_workload(evlist, &target, argv, false,
+					    workload_exec_failed_signal);
 	if (err < 0) {
 		pr_debug("Couldn't run the workload!\n");
 		goto out_delete_maps;
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 4a30c87d24ec..96b3ef547db4 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -1029,7 +1029,7 @@ out_err:
 
 int perf_evlist__prepare_workload(struct perf_evlist *evlist, struct target *target,
 				  const char *argv[], bool pipe_output,
-				  bool want_signal)
+				  void (*exec_error)(int signo, siginfo_t *info, void *ucontext))
 {
 	int child_ready_pipe[2], go_pipe[2];
 	char bf;
@@ -1073,7 +1073,7 @@ int perf_evlist__prepare_workload(struct perf_evlist *evlist, struct target *tar
 
 		execvp(argv[0], (char **)argv);
 
-		if (want_signal) {
+		if (exec_error) {
 			union sigval val;
 
 			val.sival_int = errno;
@@ -1084,6 +1084,14 @@ int perf_evlist__prepare_workload(struct perf_evlist *evlist, struct target *tar
 		exit(-1);
 	}
 
+	if (exec_error) {
+		struct sigaction act = {
+			.sa_flags     = SA_SIGINFO,
+			.sa_sigaction = exec_error,
+		};
+		sigaction(SIGUSR1, &act, NULL);
+	}
+
 	if (target__none(target))
 		evlist->threads->map[0] = evlist->workload.pid;
 
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index 2fe51958ed85..18d1222c0762 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -103,7 +103,8 @@ int record_opts__config(struct record_opts *opts);
 int perf_evlist__prepare_workload(struct perf_evlist *evlist,
 				  struct target *target,
 				  const char *argv[], bool pipe_output,
-				  bool want_signal);
+				  void (*exec_error)(int signo, siginfo_t *info,
+						     void *ucontext));
 int perf_evlist__start_workload(struct perf_evlist *evlist);
 
 int perf_evlist__parse_mmap_pages(const struct option *opt,
-- 
1.8.1.4

