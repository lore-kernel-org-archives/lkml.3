Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382AbaEHIAG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 04:00:06 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:59200 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752732AbaEHIAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 04:00:04 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>, David Ahern <dsahern@gmail.com>
Subject: [PATCH v5 1/2] perf record: Propagate exit status of a command line workload
Date: Thu,  8 May 2014 16:59:53 +0900
Message-Id: <1399535994-8027-1-git-send-email-namhyung@kernel.org>
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
exit handlers in the first place.  Also it cleaned up the resource
management code in record__exit().

With this change, perf record returns the child exit status in case of
normal termination and send signal to itself when terminated by signal.

Example run of Stephane's case:

  $ perf record true && echo yes || echo no
  [ perf record: Woken up 1 times to write data ]
  [ perf record: Captured and wrote 0.013 MB perf.data (~589 samples) ]
  yes

  $ perf record false && echo yes || echo no
  [ perf record: Woken up 1 times to write data ]
  [ perf record: Captured and wrote 0.013 MB perf.data (~589 samples) ]
  no

Jiri's case (error in parent):

  $ perf record -m 10G true && echo yes || echo no
  rounding mmap pages size to 17179869184 bytes (4194304 pages)
  failed to mmap with 12 (Cannot allocate memory)
  no

And Peter's case (interrupted by signal):

  $ while :; do perf record sleep 1; done
  ^C[ perf record: Woken up 1 times to write data ]
  [ perf record: Captured and wrote 0.014 MB perf.data (~593 samples) ]

Reported-by: Stephane Eranian <eranian@google.com>
Acked-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-record.c | 133 ++++++++++++++++++++------------------------
 1 file changed, 60 insertions(+), 73 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 8ce62ef7f6c3..7bb9c1759dfa 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -147,29 +147,10 @@ static void sig_handler(int sig)
 {
 	if (sig == SIGCHLD)
 		child_finished = 1;
+	else
+		signr = sig;
 
 	done = 1;
-	signr = sig;
-}
-
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
 }
 
 static int record__open(struct record *rec)
@@ -243,27 +224,6 @@ static int process_buildids(struct record *rec)
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
@@ -344,18 +304,19 @@ static volatile int workload_exec_errno;
  * if the fork fails, since we asked by setting its
  * want_signal to true.
  */
-static void workload_exec_failed_signal(int signo, siginfo_t *info,
+static void workload_exec_failed_signal(int signo __maybe_unused,
+					siginfo_t *info,
 					void *ucontext __maybe_unused)
 {
 	workload_exec_errno = info->si_value.sival_int;
 	done = 1;
-	signr = signo;
 	child_finished = 1;
 }
 
 static int __cmd_record(struct record *rec, int argc, const char **argv)
 {
 	int err;
+	int status = 0;
 	unsigned long waking = 0;
 	const bool forks = argc > 0;
 	struct machine *machine;
@@ -367,7 +328,6 @@ static int __cmd_record(struct record *rec, int argc, const char **argv)
 
 	rec->progname = argv[0];
 
-	on_exit(record__sig_exit, rec);
 	signal(SIGCHLD, sig_handler);
 	signal(SIGINT, sig_handler);
 	signal(SIGTERM, sig_handler);
@@ -394,26 +354,21 @@ static int __cmd_record(struct record *rec, int argc, const char **argv)
 
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
@@ -421,7 +376,7 @@ static int __cmd_record(struct record *rec, int argc, const char **argv)
 		pr_err("Couldn't generate buildids. "
 		       "Use --no-buildid to profile anyway.\n");
 		err = -1;
-		goto out_delete_session;
+		goto out_child;
 	}
 
 	machine = &session->machines.host;
@@ -431,7 +386,7 @@ static int __cmd_record(struct record *rec, int argc, const char **argv)
 						   process_synthesized_event);
 		if (err < 0) {
 			pr_err("Couldn't synthesize attrs.\n");
-			goto out_delete_session;
+			goto out_child;
 		}
 
 		if (have_tracepoints(&rec->evlist->entries)) {
@@ -447,7 +402,7 @@ static int __cmd_record(struct record *rec, int argc, const char **argv)
 								  process_synthesized_event);
 			if (err <= 0) {
 				pr_err("Couldn't record tracing data.\n");
-				goto out_delete_session;
+				goto out_child;
 			}
 			rec->bytes_written += err;
 		}
@@ -475,7 +430,7 @@ static int __cmd_record(struct record *rec, int argc, const char **argv)
 	err = __machine__synthesize_threads(machine, tool, &opts->target, rec->evlist->threads,
 					    process_synthesized_event, opts->sample_address);
 	if (err != 0)
-		goto out_delete_session;
+		goto out_child;
 
 	if (rec->realtime_prio) {
 		struct sched_param param;
@@ -484,7 +439,7 @@ static int __cmd_record(struct record *rec, int argc, const char **argv)
 		if (sched_setscheduler(0, SCHED_FIFO, &param)) {
 			pr_err("Could not set realtime priority.\n");
 			err = -1;
-			goto out_delete_session;
+			goto out_child;
 		}
 	}
 
@@ -512,13 +467,15 @@ static int __cmd_record(struct record *rec, int argc, const char **argv)
 
 		if (record__mmap_read_all(rec) < 0) {
 			err = -1;
-			goto out_delete_session;
+			goto out_child;
 		}
 
 		if (hits == rec->samples) {
 			if (done)
 				break;
 			err = poll(rec->evlist->pollfd, rec->evlist->nr_fds, -1);
+			if (err < 0 && errno == EINTR)
+				err = 0;
 			waking++;
 		}
 
@@ -538,28 +495,57 @@ static int __cmd_record(struct record *rec, int argc, const char **argv)
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
+			signr = WTERMSIG(status);
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
+
+	if (signr != -1) {
+		signal(signr, SIG_DFL);
+		raise(signr);
+	}
 
 out_delete_session:
 	perf_session__delete(session);
-	return err;
+	return status;
 }
 
 #define BRANCH_OPT(n, m) \
@@ -988,6 +974,7 @@ int cmd_record(int argc, const char **argv, const char *prefix __maybe_unused)
 
 	err = __cmd_record(&record, argc, argv);
 out_symbol_exit:
+	perf_evlist__delete(rec->evlist);
 	symbol__exit();
 	return err;
 }
-- 
1.9.2

