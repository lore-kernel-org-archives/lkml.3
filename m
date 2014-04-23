Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061AbaDWGlA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 02:41:00 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:49400 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753626AbaDWGkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 02:40:37 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH v2 1/2] perf record: Propagate exit status of a command line workload
Date: Wed, 23 Apr 2014 15:40:34 +0900
Message-Id: <1398235235-4239-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently perf record doesn't propagate the exit status of a workload
given by the command line.  But sometimes it'd useful if it's
propagated so that a monitoring script can handle errors
appropriately.

To do that, it got rid of exit handlers and run/call them directly in
the __cmd_record().  I don't see any reason why those are in a form of
exit handlers in the first place.  Also it cleaned up the resouce
management code in record__exit().

With this change, perf record returns the child exit status in case of
normal termination.  (Not sure what should be returned on abnormal
cases though).

Example run of Stephane's case:

  $ perf record false && echo yes || echo no
  [ perf record: Woken up 1 times to write data ]
  [ perf record: Captured and wrote 0.013 MB perf.data (~589 samples) ]
  no

And Jiri's case (error in parent):

  $ perf record -m 10G true && echo yes || echo no
  rounding mmap pages size to 17179869184 bytes (4194304 pages)
  failed to mmap with 12 (Cannot allocate memory)
  no

Reported-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-record.c | 119 ++++++++++++++++++--------------------------
 1 file changed, 49 insertions(+), 70 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index eb524f91bffe..d315be9e9be2 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -152,26 +152,6 @@ static void sig_handler(int sig)
 	signr = sig;
 }
 
-static void record__sig_exit(int exit_status __maybe_unused, void *arg)
-{
-	struct record *rec = arg;
-	int status;
-
-	if (rec->evlist->workload.pid > 0) {
-		if (!child_finished)
-			kill(rec->evlist->workload.pid, SIGTERM);
-
-		wait(&status);
-		if (WIFSIGNALED(status))
-			psignal(WTERMSIG(status), rec->progname);
-	}
-
-	if (signr == -1 || signr == SIGUSR1)
-		return;
-
-	signal(signr, SIG_DFL);
-}
-
 static int record__open(struct record *rec)
 {
 	char msg[512];
@@ -243,27 +223,6 @@ static int process_buildids(struct record *rec)
 					      size, &build_id__mark_dso_hit_ops);
 }
 
-static void record__exit(int status, void *arg)
-{
-	struct record *rec = arg;
-	struct perf_data_file *file = &rec->file;
-
-	if (status != 0)
-		return;
-
-	if (!file->is_pipe) {
-		rec->session->header.data_size += rec->bytes_written;
-
-		if (!rec->no_buildid)
-			process_buildids(rec);
-		perf_session__write_header(rec->session, rec->evlist,
-					   file->fd, true);
-		perf_session__delete(rec->session);
-		perf_evlist__delete(rec->evlist);
-		symbol__exit();
-	}
-}
-
 static void perf_event__synthesize_guest_os(struct machine *machine, void *data)
 {
 	int err;
@@ -356,6 +315,7 @@ static void workload_exec_failed_signal(int signo, siginfo_t *info,
 static int __cmd_record(struct record *rec, int argc, const char **argv)
 {
 	int err;
+	int status = 0;
 	unsigned long waking = 0;
 	const bool forks = argc > 0;
 	struct machine *machine;
@@ -367,7 +327,6 @@ static int __cmd_record(struct record *rec, int argc, const char **argv)
 
 	rec->progname = argv[0];
 
-	on_exit(record__sig_exit, rec);
 	signal(SIGCHLD, sig_handler);
 	signal(SIGINT, sig_handler);
 	signal(SIGTERM, sig_handler);
@@ -394,26 +353,21 @@ static int __cmd_record(struct record *rec, int argc, const char **argv)
 
 	if (record__open(rec) != 0) {
 		err = -1;
-		goto out_delete_session;
+		goto out_child;
 	}
 
 	if (!rec->evlist->nr_groups)
 		perf_header__clear_feat(&session->header, HEADER_GROUP_DESC);
 
-	/*
-	 * perf_session__delete(session) will be called at record__exit()
-	 */
-	on_exit(record__exit, rec);
-
 	if (file->is_pipe) {
 		err = perf_header__write_pipe(file->fd);
 		if (err < 0)
-			goto out_delete_session;
+			goto out_child;
 	} else {
 		err = perf_session__write_header(session, rec->evlist,
 						 file->fd, false);
 		if (err < 0)
-			goto out_delete_session;
+			goto out_child;
 	}
 
 	if (!rec->no_buildid
@@ -421,7 +375,7 @@ static int __cmd_record(struct record *rec, int argc, const char **argv)
 		pr_err("Couldn't generate buildids. "
 		       "Use --no-buildid to profile anyway.\n");
 		err = -1;
-		goto out_delete_session;
+		goto out_child;
 	}
 
 	machine = &session->machines.host;
@@ -431,7 +385,7 @@ static int __cmd_record(struct record *rec, int argc, const char **argv)
 						   process_synthesized_event);
 		if (err < 0) {
 			pr_err("Couldn't synthesize attrs.\n");
-			goto out_delete_session;
+			goto out_child;
 		}
 
 		if (have_tracepoints(&rec->evlist->entries)) {
@@ -447,7 +401,7 @@ static int __cmd_record(struct record *rec, int argc, const char **argv)
 								  process_synthesized_event);
 			if (err <= 0) {
 				pr_err("Couldn't record tracing data.\n");
-				goto out_delete_session;
+				goto out_child;
 			}
 			rec->bytes_written += err;
 		}
@@ -475,7 +429,7 @@ static int __cmd_record(struct record *rec, int argc, const char **argv)
 	err = __machine__synthesize_threads(machine, tool, &opts->target, rec->evlist->threads,
 					    process_synthesized_event, opts->sample_address);
 	if (err != 0)
-		goto out_delete_session;
+		goto out_child;
 
 	if (rec->realtime_prio) {
 		struct sched_param param;
@@ -484,7 +438,7 @@ static int __cmd_record(struct record *rec, int argc, const char **argv)
 		if (sched_setscheduler(0, SCHED_FIFO, &param)) {
 			pr_err("Could not set realtime priority.\n");
 			err = -1;
-			goto out_delete_session;
+			goto out_child;
 		}
 	}
 
@@ -512,7 +466,7 @@ static int __cmd_record(struct record *rec, int argc, const char **argv)
 
 		if (record__mmap_read_all(rec) < 0) {
 			err = -1;
-			goto out_delete_session;
+			goto out_child;
 		}
 
 		if (hits == rec->samples) {
@@ -538,28 +492,52 @@ static int __cmd_record(struct record *rec, int argc, const char **argv)
 		const char *emsg = strerror_r(workload_exec_errno, msg, sizeof(msg));
 		pr_err("Workload failed: %s\n", emsg);
 		err = -1;
-		goto out_delete_session;
+		goto out_child;
 	}
 
-	if (quiet || signr == SIGUSR1)
-		return 0;
+	if (!quiet) {
+		fprintf(stderr, "[ perf record: Woken up %ld times to write data ]\n", waking);
 
-	fprintf(stderr, "[ perf record: Woken up %ld times to write data ]\n", waking);
+		/*
+		 * Approximate RIP event size: 24 bytes.
+		 */
+		fprintf(stderr,
+			"[ perf record: Captured and wrote %.3f MB %s (~%" PRIu64 " samples) ]\n",
+			(double)rec->bytes_written / 1024.0 / 1024.0,
+			file->path,
+			rec->bytes_written / 24);
+	}
 
-	/*
-	 * Approximate RIP event size: 24 bytes.
-	 */
-	fprintf(stderr,
-		"[ perf record: Captured and wrote %.3f MB %s (~%" PRIu64 " samples) ]\n",
-		(double)rec->bytes_written / 1024.0 / 1024.0,
-		file->path,
-		rec->bytes_written / 24);
+out_child:
+	if (forks) {
+		int exit_status;
 
-	return 0;
+		if (!child_finished)
+			kill(rec->evlist->workload.pid, SIGTERM);
+
+		wait(&exit_status);
+
+		if (err < 0)
+			status = err;
+		else if (WIFEXITED(exit_status))
+			status = WEXITSTATUS(exit_status);
+		else if (WIFSIGNALED(status))
+			psignal(WTERMSIG(status), rec->progname);
+	} else
+		status = err;
+
+	if (!err && !file->is_pipe) {
+		rec->session->header.data_size += rec->bytes_written;
+
+		if (!rec->no_buildid)
+			process_buildids(rec);
+		perf_session__write_header(rec->session, rec->evlist,
+					   file->fd, true);
+	}
 
 out_delete_session:
 	perf_session__delete(session);
-	return err;
+	return status;
 }
 
 #define BRANCH_OPT(n, m) \
@@ -988,6 +966,7 @@ int cmd_record(int argc, const char **argv, const char *prefix __maybe_unused)
 
 	err = __cmd_record(&record, argc, argv);
 out_symbol_exit:
+	perf_evlist__delete(rec->evlist);
 	symbol__exit();
 	return err;
 }
-- 
1.9.2

