Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619AbaAMU5o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 15:57:44 -0500
Received: from merlin.infradead.org ([205.233.59.134]:40395 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868AbaAMUsI (ORCPT
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
Subject: [PATCH 01/38] perf stat: Don't show counter information when workload fails
Date: Mon, 13 Jan 2014 17:47:02 -0300
Message-Id: <1389646059-24881-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1389646059-24881-1-git-send-email-acme@infradead.org>
References: <1389646059-24881-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

When starting a workload 'stat' wasn't using prepare_workload evlist
method's signal based exec() error reporting mechanism.

Use it so that the we don't report 'not counted' counters.

Before:

  [acme@zoo linux]$ perf stat dfadsfa
  dfadsfa: No such file or directory

   Performance counter stats for 'dfadsfa':

       <not counted>      task-clock
       <not counted>      context-switches
       <not counted>      cpu-migrations
       <not counted>      page-faults
       <not counted>      cycles
       <not counted>      stalled-cycles-frontend
     <not supported>      stalled-cycles-backend
       <not counted>      instructions
       <not counted>      branches
       <not counted>      branch-misses

         0.001831462 seconds time elapsed

  [acme@zoo linux]$

After:

  [acme@zoo linux]$ perf stat dfadsfa
  dfadsfa: No such file or directory
  [acme@zoo linux]$

Reported-by: David Ahern <dsahern@gmail.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-5yui3bv7e3hitxucnjsn6z8q@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-stat.c | 26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 106a5e5b7842..1c76c7a66f78 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -509,6 +509,18 @@ static void handle_initial_delay(void)
 	}
 }
 
+static volatile bool workload_exec_failed;
+
+/*
+ * perf_evlist__prepare_workload will send a SIGUSR1
+ * if the fork fails, since we asked by setting its
+ * want_signal to true.
+ */
+static void workload_exec_failed_signal(int signo __maybe_unused)
+{
+	workload_exec_failed = true;
+}
+
 static int __run_perf_stat(int argc, const char **argv)
 {
 	char msg[512];
@@ -529,7 +541,7 @@ static int __run_perf_stat(int argc, const char **argv)
 
 	if (forks) {
 		if (perf_evlist__prepare_workload(evsel_list, &target, argv,
-						  false, false) < 0) {
+						  false, true) < 0) {
 			perror("failed to prepare workload");
 			return -1;
 		}
@@ -584,6 +596,14 @@ static int __run_perf_stat(int argc, const char **argv)
 	clock_gettime(CLOCK_MONOTONIC, &ref_time);
 
 	if (forks) {
+		/*
+		 * perf_evlist__prepare_workload will, after we call
+		 * perf_evlist__start_Workload, send a SIGUSR1 if the exec call
+		 * fails, that we will catch in workload_signal to flip
+		 * workload_exec_failed.
+ 		 */
+		signal(SIGUSR1, workload_exec_failed_signal);
+
 		perf_evlist__start_workload(evsel_list);
 		handle_initial_delay();
 
@@ -594,6 +614,10 @@ static int __run_perf_stat(int argc, const char **argv)
 			}
 		}
 		wait(&status);
+
+		if (workload_exec_failed)
+			return -1;
+
 		if (WIFSIGNALED(status))
 			psignal(WTERMSIG(status), argv[0]);
 	} else {
-- 
1.8.1.4

