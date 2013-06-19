Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933850Ab3FSBCb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 21:02:31 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:60111 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932644Ab3FSBCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 21:02:30 -0400
X-AuditID: 9c93016f-b7b6cae000007078-db-51c103236d03
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 1/3] perf record: support duration option to run during specified time
Date: Wed, 19 Jun 2013 10:02:28 +0900
Message-Id: <1371603750-15053-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, there is no method to quit at specified time later.
We are used to using 'sleep N' as command argument if we need it,
but explicitly supporting this feature maybe makes sense.

Cc: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index cdf58ec..19c65b5 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -29,6 +29,7 @@
 #include <sched.h>
 #include <sys/mman.h>
 
+static unsigned int duration;
 #ifndef HAVE_ON_EXIT
 #ifndef ATEXIT_MAX
 #define ATEXIT_MAX 32
@@ -194,7 +195,7 @@ static void perf_record__sig_exit(int exit_status __maybe_unused, void *arg)
 			psignal(WTERMSIG(status), rec->progname);
 	}
 
-	if (signr == -1 || signr == SIGUSR1)
+	if (signr == -1 || signr == SIGUSR1 || signr == SIGALRM)
 		return;
 
 	signal(signr, SIG_DFL);
@@ -404,6 +405,7 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 	signal(SIGCHLD, sig_handler);
 	signal(SIGINT, sig_handler);
 	signal(SIGUSR1, sig_handler);
+	signal(SIGALRM, sig_handler);
 
 	if (!output_name) {
 		if (!fstat(STDOUT_FILENO, &st) && S_ISFIFO(st.st_mode))
@@ -471,6 +473,7 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 			goto out_delete_session;
 	}
 
+	alarm(duration);
 	if (forks) {
 		err = perf_evlist__prepare_workload(evsel_list, &opts->target,
 						    argv, opts->pipe_output,
@@ -955,6 +958,7 @@ const struct option record_options[] = {
 		     parse_branch_stack),
 	OPT_BOOLEAN('W', "weight", &record.opts.sample_weight,
 		    "sample by weight (on special events only)"),
+	OPT_UINTEGER(0, "duration", &duration, "run during specified seconds"),
 	OPT_END()
 };
 
-- 
1.7.9.5

