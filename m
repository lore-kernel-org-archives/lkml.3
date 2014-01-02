Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751669AbaABOoy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 09:44:54 -0500
Received: from mail-qc0-f178.google.com ([209.85.216.178]:60613 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258AbaABOow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 09:44:52 -0500
Date: Thu, 2 Jan 2014 11:44:45 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH] perf stat: Do not show stats if workload fails
Message-ID: <20140102144445.GA8833@ghostprotocols.net>
References: <1387518748-25340-1-git-send-email-dsahern@gmail.com>
 <20131220075759.GA12937@gmail.com>
 <20131223193757.GA1396@ghostprotocols.net>
 <52B8D582.9090009@gmail.com>
 <20131224125342.GC17780@ghostprotocols.net>
 <20131224133003.GA23382@ghostprotocols.net>
 <52BC390A.2000504@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="0OAP2g/MAC+5xKAE"
Content-Disposition: inline
In-Reply-To: <52BC390A.2000504@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0OAP2g/MAC+5xKAE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Em Thu, Dec 26, 2013 at 09:11:22AM -0500, David Ahern escreveu:
> On 12/24/13, 8:30 AM, Arnaldo Carvalho de Melo wrote:
> >Em Tue, Dec 24, 2013 at 09:53:42AM -0300, Arnaldo Carvalho de Melo escreveu:
> >>>The thing to check is perf_evlist__{prepare,start}_workload notification
> >>>errors using SIGUSR1, that we need to check for in the caller, and emit
> >>>the message, no?
> >Something like this:
> >
> >1. We tell perf_evlist__prepare_workload that we want a signal if execvp
> >fails, it will be a SIGUSR1
> >
> >2. We catch that signal in 'stat' and check that we got a signal, only
> >problem so far with this signal maze is that we're getting a SIGCHLD
> >while I was expecting a SIGUSR1... I.e. the "if (signr != -1) test
> >really should be if (signr == SIGUSR1), but I'm getting a SIGCHLD there
> >and the elves are tugging me away...
> 
> Did the elves release you?
> 
> There are all kinds of failure paths with the workload functions. In
> the end I was focusing on perf-stat actually checking the rc on the
> start_workload function. If it fails, then write() failed and
> something happened to the workload process. In that case don't show
> the counters.
> 
> Handling the other error paths with appropriate messages will take
> additional effort - as you are finding. ;-)

So, please try the attached patch, then apply this one on top, still
needs work for 'record' and 'trace', that now don't print anything when
a workload fails. I'll work on passing a pointer to evlist to the
sigaction, then all this will be hidden away inside
perf_evlist__prepare_workload, etc.

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
 

--0OAP2g/MAC+5xKAE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0001-perf-stat-Don-t-show-counter-information-when-worklo.patch"

>From b015481108106b7ef42d46a5096b572b1bd71b50 Mon Sep 17 00:00:00 2001
From: Arnaldo Carvalho de Melo <acme@redhat.com>
Date: Sat, 28 Dec 2013 15:45:08 -0300
Subject: [PATCH] perf stat: Don't show counter information when workload fails

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
1.8.5.rc2


--0OAP2g/MAC+5xKAE--
