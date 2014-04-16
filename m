Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751471AbaDPAas (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 20:30:48 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:56428 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864AbaDPAaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 20:30:46 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Stephane Eranian <eranian@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>
Subject: [PATCH 1/2] perf record: Propagate exit status of a command line workload
Date: Wed, 16 Apr 2014 09:30:43 +0900
Message-Id: <1397608244-15496-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <CABPqkBQeAqRUW8LLMsHhHBR8gJcE4VPZa++ji8i=RKUCd2jSvQ@mail.gmail.com>
References: <CABPqkBQeAqRUW8LLMsHhHBR8gJcE4VPZa++ji8i=RKUCd2jSvQ@mail.gmail.com>
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

Reported-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-record.c | 74 ++++++++++++++++++---------------------------
 1 file changed, 30 insertions(+), 44 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index eb524f91bffe..3d587d693873 100644
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
@@ -243,14 +223,11 @@ static int process_buildids(struct record *rec)
 					      size, &build_id__mark_dso_hit_ops);
 }
 
-static void record__exit(int status, void *arg)
+static void record__exit(void *arg)
 {
 	struct record *rec = arg;
 	struct perf_data_file *file = &rec->file;
 
-	if (status != 0)
-		return;
-
 	if (!file->is_pipe) {
 		rec->session->header.data_size += rec->bytes_written;
 
@@ -259,8 +236,6 @@ static void record__exit(int status, void *arg)
 		perf_session__write_header(rec->session, rec->evlist,
 					   file->fd, true);
 		perf_session__delete(rec->session);
-		perf_evlist__delete(rec->evlist);
-		symbol__exit();
 	}
 }
 
@@ -356,6 +331,7 @@ static void workload_exec_failed_signal(int signo, siginfo_t *info,
 static int __cmd_record(struct record *rec, int argc, const char **argv)
 {
 	int err;
+	int status = 0;
 	unsigned long waking = 0;
 	const bool forks = argc > 0;
 	struct machine *machine;
@@ -367,7 +343,6 @@ static int __cmd_record(struct record *rec, int argc, const char **argv)
 
 	rec->progname = argv[0];
 
-	on_exit(record__sig_exit, rec);
 	signal(SIGCHLD, sig_handler);
 	signal(SIGINT, sig_handler);
 	signal(SIGTERM, sig_handler);
@@ -400,11 +375,6 @@ static int __cmd_record(struct record *rec, int argc, const char **argv)
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
@@ -541,21 +511,36 @@ static int __cmd_record(struct record *rec, int argc, const char **argv)
 		goto out_delete_session;
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
+	if (forks) {
+		int exit_status;
 
-	return 0;
+		if (!child_finished)
+			kill(rec->evlist->workload.pid, SIGTERM);
+
+		wait(&exit_status);
+
+		if (WIFEXITED(exit_status))
+			status = WEXITSTATUS(exit_status);
+		else if (WIFSIGNALED(status))
+			psignal(WTERMSIG(status), rec->progname);
+	}
+
+	record__exit(rec);
+
+	return status;
 
 out_delete_session:
 	perf_session__delete(session);
@@ -988,6 +973,7 @@ int cmd_record(int argc, const char **argv, const char *prefix __maybe_unused)
 
 	err = __cmd_record(&record, argc, argv);
 out_symbol_exit:
+	perf_evlist__delete(rec->evlist);
 	symbol__exit();
 	return err;
 }
-- 
1.9.2

