Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737AbaAMU5q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 15:57:46 -0500
Received: from merlin.infradead.org ([205.233.59.134]:40393 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747AbaAMUsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 15:48:08 -0500
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
Subject: [PATCH 02/38] perf evlist: Send the errno in the signal when workload fails
Date: Mon, 13 Jan 2014 17:47:03 -0300
Message-Id: <1389646059-24881-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1389646059-24881-1-git-send-email-acme@infradead.org>
References: <1389646059-24881-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

When a tool uses perf_evlist__start_workload and the supplied workload
fails (e.g.: its binary wasn't found), perror was being used to print
the error reason.

This is undesirable, as the caller may be a GUI, when it wants to have
total control of the error reporting process.

So move to using sigaction(SA_SIGINFO) + siginfo_t->sa_value->sival_int
to communicate to the caller the errno and let it print it using the UI
of its choosing.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-epgcv7kjq8ll2udqfken92pz@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c | 39 +++++++++++++++++++++++++++++++++++++--
 tools/perf/builtin-stat.c   | 21 +++++++++++++++------
 tools/perf/util/evlist.c    | 11 ++++++++---
 3 files changed, 60 insertions(+), 11 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 6ec0cbc2a5d5..f987d385c6f0 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -341,6 +341,22 @@ static void record__init_features(struct record *rec)
 		perf_header__clear_feat(&session->header, HEADER_BRANCH_STACK);
 }
 
+static volatile int workload_exec_errno;
+
+/*
+ * perf_evlist__prepare_workload will send a SIGUSR1
+ * if the fork fails, since we asked by setting its
+ * want_signal to true.
+ */
+static void workload_exec_failed_signal(int signo, siginfo_t *info,
+					void *ucontext __maybe_unused)
+{
+	workload_exec_errno = info->si_value.sival_int;
+	done = 1;
+	signr = signo;
+	child_finished = 1;
+}
+
 static int __cmd_record(struct record *rec, int argc, const char **argv)
 {
 	int err;
@@ -359,7 +375,6 @@ static int __cmd_record(struct record *rec, int argc, const char **argv)
 	on_exit(record__sig_exit, rec);
 	signal(SIGCHLD, sig_handler);
 	signal(SIGINT, sig_handler);
-	signal(SIGUSR1, sig_handler);
 	signal(SIGTERM, sig_handler);
 
 	session = perf_session__new(file, false, NULL);
@@ -492,8 +507,20 @@ static int __cmd_record(struct record *rec, int argc, const char **argv)
 	/*
 	 * Let the child rip
 	 */
-	if (forks)
+	if (forks) {
+		struct sigaction act = {
+			.sa_flags     = SA_SIGINFO,
+			.sa_sigaction = workload_exec_failed_signal,
+		};
+		/*
+		 * perf_evlist__prepare_workload will, after we call
+		 * perf_evlist__start_Workload, send a SIGUSR1 if the exec call
+		 * fails, that we will catch in workload_signal to flip
+		 * workload_exec_errno.
+ 		 */
+		sigaction(SIGUSR1, &act, NULL);
 		perf_evlist__start_workload(evsel_list);
+	}
 
 	for (;;) {
 		int hits = rec->samples;
@@ -521,6 +548,14 @@ static int __cmd_record(struct record *rec, int argc, const char **argv)
 		}
 	}
 
+	if (forks && workload_exec_errno) {
+		char msg[512];
+		const char *emsg = strerror_r(workload_exec_errno, msg, sizeof(msg));
+		pr_err("Workload failed: %s\n", emsg);
+		err = -1;
+		goto out_delete_session;
+	}
+
 	if (quiet || signr == SIGUSR1)
 		return 0;
 
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 1c76c7a66f78..9d0d52d55ee6 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -58,6 +58,7 @@
 #include "util/thread.h"
 #include "util/thread_map.h"
 
+#include <signal.h>
 #include <stdlib.h>
 #include <sys/prctl.h>
 #include <locale.h>
@@ -509,16 +510,17 @@ static void handle_initial_delay(void)
 	}
 }
 
-static volatile bool workload_exec_failed;
+static volatile int workload_exec_errno;
 
 /*
  * perf_evlist__prepare_workload will send a SIGUSR1
  * if the fork fails, since we asked by setting its
  * want_signal to true.
  */
-static void workload_exec_failed_signal(int signo __maybe_unused)
+static void workload_exec_failed_signal(int signo __maybe_unused, siginfo_t *info,
+					void *ucontext __maybe_unused)
 {
-	workload_exec_failed = true;
+	workload_exec_errno = info->si_value.sival_int;
 }
 
 static int __run_perf_stat(int argc, const char **argv)
@@ -596,13 +598,17 @@ static int __run_perf_stat(int argc, const char **argv)
 	clock_gettime(CLOCK_MONOTONIC, &ref_time);
 
 	if (forks) {
+		struct sigaction act = {
+			.sa_flags     = SA_SIGINFO,
+			.sa_sigaction = workload_exec_failed_signal,
+		};
 		/*
 		 * perf_evlist__prepare_workload will, after we call
 		 * perf_evlist__start_Workload, send a SIGUSR1 if the exec call
 		 * fails, that we will catch in workload_signal to flip
-		 * workload_exec_failed.
+		 * workload_exec_errno.
  		 */
-		signal(SIGUSR1, workload_exec_failed_signal);
+		sigaction(SIGUSR1, &act, NULL);
 
 		perf_evlist__start_workload(evsel_list);
 		handle_initial_delay();
@@ -615,8 +621,11 @@ static int __run_perf_stat(int argc, const char **argv)
 		}
 		wait(&status);
 
-		if (workload_exec_failed)
+		if (workload_exec_errno) {
+			const char *emsg = strerror_r(workload_exec_errno, msg, sizeof(msg));
+			pr_err("Workload failed: %s\n", emsg);
 			return -1;
+		}
 
 		if (WIFSIGNALED(status))
 			psignal(WTERMSIG(status), argv[0]);
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index b08a7ecdcea1..4a30c87d24ec 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -1073,9 +1073,14 @@ int perf_evlist__prepare_workload(struct perf_evlist *evlist, struct target *tar
 
 		execvp(argv[0], (char **)argv);
 
-		perror(argv[0]);
-		if (want_signal)
-			kill(getppid(), SIGUSR1);
+		if (want_signal) {
+			union sigval val;
+
+			val.sival_int = errno;
+			if (sigqueue(getppid(), SIGUSR1, val))
+				perror(argv[0]);
+		} else
+			perror(argv[0]);
 		exit(-1);
 	}
 
-- 
1.8.1.4

