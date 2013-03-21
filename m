Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757016Ab3CULJq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 07:09:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56265 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755569Ab3CULJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 07:09:45 -0400
Date: Thu, 21 Mar 2013 04:08:10 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-6ef73ec449af998ca34673636d00decc8e808544@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, jolsa@redhat.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, jolsa@redhat.com,
        dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1362987798-24969-4-git-send-email-namhyung@kernel.org>
References: <1362987798-24969-4-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf evlist:
  Pass struct perf_target to perf_evlist__prepare_workload()
Git-Commit-ID: 6ef73ec449af998ca34673636d00decc8e808544
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 21 Mar 2013 04:08:21 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6ef73ec449af998ca34673636d00decc8e808544
Gitweb:     http://git.kernel.org/tip/6ef73ec449af998ca34673636d00decc8e808544
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Mon, 11 Mar 2013 16:43:15 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 15 Mar 2013 13:06:02 -0300

perf evlist: Pass struct perf_target to perf_evlist__prepare_workload()

It's a preparation step of removing @opts arg from the function so that
it can be used more widely.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1362987798-24969-4-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c    | 3 ++-
 tools/perf/builtin-trace.c     | 3 ++-
 tools/perf/tests/perf-record.c | 2 +-
 tools/perf/util/evlist.c       | 3 ++-
 tools/perf/util/evlist.h       | 1 +
 5 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index e3261ea..a803017 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -474,7 +474,8 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 	}
 
 	if (forks) {
-		err = perf_evlist__prepare_workload(evsel_list, opts, argv);
+		err = perf_evlist__prepare_workload(evsel_list, &opts->target,
+						    opts, argv);
 		if (err < 0) {
 			pr_err("Couldn't run the workload!\n");
 			goto out_delete_session;
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 6198eb1..1de3971 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -461,7 +461,8 @@ static int trace__run(struct trace *trace, int argc, const char **argv)
 	signal(SIGINT, sig_handler);
 
 	if (forks) {
-		err = perf_evlist__prepare_workload(evlist, &trace->opts, argv);
+		err = perf_evlist__prepare_workload(evlist, &trace->opts.target,
+						    &trace->opts, argv);
 		if (err < 0) {
 			printf("Couldn't run the workload!\n");
 			goto out_delete_evlist;
diff --git a/tools/perf/tests/perf-record.c b/tools/perf/tests/perf-record.c
index f6ba75a..adf6b4a 100644
--- a/tools/perf/tests/perf-record.c
+++ b/tools/perf/tests/perf-record.c
@@ -93,7 +93,7 @@ int test__PERF_RECORD(void)
 	 * so that we have time to open the evlist (calling sys_perf_event_open
 	 * on all the fds) and then mmap them.
 	 */
-	err = perf_evlist__prepare_workload(evlist, &opts, argv);
+	err = perf_evlist__prepare_workload(evlist, &opts.target, &opts, argv);
 	if (err < 0) {
 		pr_debug("Couldn't run the workload!\n");
 		goto out_delete_maps;
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 7d71a69..291884c 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -745,6 +745,7 @@ out_err:
 }
 
 int perf_evlist__prepare_workload(struct perf_evlist *evlist,
+				  struct perf_target *target,
 				  struct perf_record_opts *opts,
 				  const char *argv[])
 {
@@ -800,7 +801,7 @@ int perf_evlist__prepare_workload(struct perf_evlist *evlist,
 		exit(-1);
 	}
 
-	if (perf_target__none(&opts->target))
+	if (perf_target__none(target))
 		evlist->threads->map[0] = evlist->workload.pid;
 
 	close(child_ready_pipe[1]);
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index 9a7b76e..e089906 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -86,6 +86,7 @@ void perf_evlist__config(struct perf_evlist *evlist,
 			 struct perf_record_opts *opts);
 
 int perf_evlist__prepare_workload(struct perf_evlist *evlist,
+				  struct perf_target *target,
 				  struct perf_record_opts *opts,
 				  const char *argv[]);
 int perf_evlist__start_workload(struct perf_evlist *evlist);
