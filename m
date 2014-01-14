Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751485AbaANQh3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 11:37:29 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52457 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751587AbaANQhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 11:37:24 -0500
Date: Tue, 14 Jan 2014 08:36:29 -0800
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-5yui3bv7e3hitxucnjsn6z8q@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, adrian.hunter@intel.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, adrian.hunter@intel.com, dsahern@gmail.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf stat: Don'
 t show counter information when workload fails
Git-Commit-ID: 6af206fd911c825b83dd4efb2534a3a34ce77072
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 14 Jan 2014 08:36:36 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6af206fd911c825b83dd4efb2534a3a34ce77072
Gitweb:     http://git.kernel.org/tip/6af206fd911c825b83dd4efb2534a3a34ce77072
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Sat, 28 Dec 2013 15:45:08 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 13 Jan 2014 10:06:21 -0300

perf stat: Don't show counter information when workload fails

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
index 106a5e5..1c76c7a 100644
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
