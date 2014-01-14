Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752032AbaANQhf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 11:37:35 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52458 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669AbaANQhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 11:37:24 -0500
Date: Tue, 14 Jan 2014 08:36:39 -0800
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-epgcv7kjq8ll2udqfken92pz@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, adrian.hunter@intel.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, adrian.hunter@intel.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf evlist:
  Send the errno in the signal when workload fails
Git-Commit-ID: f33cbe72e6166b97d6fa2400cb00a885b47999d7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 14 Jan 2014 08:36:46 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f33cbe72e6166b97d6fa2400cb00a885b47999d7
Gitweb:     http://git.kernel.org/tip/f33cbe72e6166b97d6fa2400cb00a885b47999d7
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Thu, 2 Jan 2014 15:11:25 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 13 Jan 2014 10:06:21 -0300

perf evlist: Send the errno in the signal when workload fails

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
index 6ec0cbc..f987d38 100644
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
index 1c76c7a..9d0d52d 100644
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
index b08a7ec..4a30c87 100644
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
 
