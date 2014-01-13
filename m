Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752472AbaAMUsY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 15:48:24 -0500
Received: from merlin.infradead.org ([205.233.59.134]:40373 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549AbaAMUsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 15:48:07 -0500
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
Subject: [PATCH 04/38] perf record: Remove old evsel_list usage
Date: Mon, 13 Jan 2014 17:47:05 -0300
Message-Id: <1389646059-24881-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1389646059-24881-1-git-send-email-acme@infradead.org>
References: <1389646059-24881-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

To be consistent with other places, use just 'evlist' for the evsel list
variable, and since we have it in 'struct record', use it directly from
there.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-396bnfvmlxrsj3o2tk47b8t1@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c | 43 +++++++++++++++++++------------------------
 1 file changed, 19 insertions(+), 24 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index ea7c3060e8e7..6dcb8aae908c 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -324,7 +324,6 @@ out:
 
 static void record__init_features(struct record *rec)
 {
-	struct perf_evlist *evsel_list = rec->evlist;
 	struct perf_session *session = rec->session;
 	int feat;
 
@@ -334,7 +333,7 @@ static void record__init_features(struct record *rec)
 	if (rec->no_buildid)
 		perf_header__clear_feat(&session->header, HEADER_BUILD_ID);
 
-	if (!have_tracepoints(&evsel_list->entries))
+	if (!have_tracepoints(&rec->evlist->entries))
 		perf_header__clear_feat(&session->header, HEADER_TRACING_DATA);
 
 	if (!rec->opts.branch_stack)
@@ -365,7 +364,6 @@ static int __cmd_record(struct record *rec, int argc, const char **argv)
 	struct machine *machine;
 	struct perf_tool *tool = &rec->tool;
 	struct record_opts *opts = &rec->opts;
-	struct perf_evlist *evsel_list = rec->evlist;
 	struct perf_data_file *file = &rec->file;
 	struct perf_session *session;
 	bool disabled = false;
@@ -388,7 +386,7 @@ static int __cmd_record(struct record *rec, int argc, const char **argv)
 	record__init_features(rec);
 
 	if (forks) {
-		err = perf_evlist__prepare_workload(evsel_list, &opts->target,
+		err = perf_evlist__prepare_workload(rec->evlist, &opts->target,
 						    argv, file->is_pipe,
 						    workload_exec_failed_signal);
 		if (err < 0) {
@@ -402,7 +400,7 @@ static int __cmd_record(struct record *rec, int argc, const char **argv)
 		goto out_delete_session;
 	}
 
-	if (!evsel_list->nr_groups)
+	if (!rec->evlist->nr_groups)
 		perf_header__clear_feat(&session->header, HEADER_GROUP_DESC);
 
 	/*
@@ -415,7 +413,7 @@ static int __cmd_record(struct record *rec, int argc, const char **argv)
 		if (err < 0)
 			goto out_delete_session;
 	} else {
-		err = perf_session__write_header(session, evsel_list,
+		err = perf_session__write_header(session, rec->evlist,
 						 file->fd, false);
 		if (err < 0)
 			goto out_delete_session;
@@ -439,7 +437,7 @@ static int __cmd_record(struct record *rec, int argc, const char **argv)
 			goto out_delete_session;
 		}
 
-		if (have_tracepoints(&evsel_list->entries)) {
+		if (have_tracepoints(&rec->evlist->entries)) {
 			/*
 			 * FIXME err <= 0 here actually means that
 			 * there were no tracepoints so its not really
@@ -448,7 +446,7 @@ static int __cmd_record(struct record *rec, int argc, const char **argv)
 			 * return this more properly and also
 			 * propagate errors that now are calling die()
 			 */
-			err = perf_event__synthesize_tracing_data(tool, file->fd, evsel_list,
+			err = perf_event__synthesize_tracing_data(tool, file->fd, rec->evlist,
 								  process_synthesized_event);
 			if (err <= 0) {
 				pr_err("Couldn't record tracing data.\n");
@@ -480,7 +478,7 @@ static int __cmd_record(struct record *rec, int argc, const char **argv)
 					 perf_event__synthesize_guest_os, tool);
 	}
 
-	err = __machine__synthesize_threads(machine, tool, &opts->target, evsel_list->threads,
+	err = __machine__synthesize_threads(machine, tool, &opts->target, rec->evlist->threads,
 					    process_synthesized_event, opts->sample_address);
 	if (err != 0)
 		goto out_delete_session;
@@ -502,13 +500,13 @@ static int __cmd_record(struct record *rec, int argc, const char **argv)
 	 * so don't spoil it by prematurely enabling them.
 	 */
 	if (!target__none(&opts->target))
-		perf_evlist__enable(evsel_list);
+		perf_evlist__enable(rec->evlist);
 
 	/*
 	 * Let the child rip
 	 */
 	if (forks)
-		perf_evlist__start_workload(evsel_list);
+		perf_evlist__start_workload(rec->evlist);
 
 	for (;;) {
 		int hits = rec->samples;
@@ -521,7 +519,7 @@ static int __cmd_record(struct record *rec, int argc, const char **argv)
 		if (hits == rec->samples) {
 			if (done)
 				break;
-			err = poll(evsel_list->pollfd, evsel_list->nr_fds, -1);
+			err = poll(rec->evlist->pollfd, rec->evlist->nr_fds, -1);
 			waking++;
 		}
 
@@ -531,7 +529,7 @@ static int __cmd_record(struct record *rec, int argc, const char **argv)
 		 * disable events in this case.
 		 */
 		if (done && !disabled && !target__none(&opts->target)) {
-			perf_evlist__disable(evsel_list);
+			perf_evlist__disable(rec->evlist);
 			disabled = true;
 		}
 	}
@@ -901,16 +899,13 @@ const struct option record_options[] = {
 int cmd_record(int argc, const char **argv, const char *prefix __maybe_unused)
 {
 	int err = -ENOMEM;
-	struct perf_evlist *evsel_list;
 	struct record *rec = &record;
 	char errbuf[BUFSIZ];
 
-	evsel_list = perf_evlist__new();
-	if (evsel_list == NULL)
+	rec->evlist = perf_evlist__new();
+	if (rec->evlist == NULL)
 		return -ENOMEM;
 
-	rec->evlist = evsel_list;
-
 	argc = parse_options(argc, argv, record_options, record_usage,
 			    PARSE_OPT_STOP_AT_NON_OPTION);
 	if (!argc && target__none(&rec->opts.target))
@@ -937,8 +932,8 @@ int cmd_record(int argc, const char **argv, const char *prefix __maybe_unused)
 	if (rec->no_buildid_cache || rec->no_buildid)
 		disable_buildid_cache();
 
-	if (evsel_list->nr_entries == 0 &&
-	    perf_evlist__add_default(evsel_list) < 0) {
+	if (rec->evlist->nr_entries == 0 &&
+	    perf_evlist__add_default(rec->evlist) < 0) {
 		pr_err("Not enough memory for event selector list\n");
 		goto out_symbol_exit;
 	}
@@ -964,7 +959,7 @@ int cmd_record(int argc, const char **argv, const char *prefix __maybe_unused)
 	}
 
 	err = -ENOMEM;
-	if (perf_evlist__create_maps(evsel_list, &rec->opts.target) < 0)
+	if (perf_evlist__create_maps(rec->evlist, &rec->opts.target) < 0)
 		usage_with_options(record_usage, record_options);
 
 	if (record_opts__config(&rec->opts)) {
@@ -974,10 +969,10 @@ int cmd_record(int argc, const char **argv, const char *prefix __maybe_unused)
 
 	err = __cmd_record(&record, argc, argv);
 
-	perf_evlist__munmap(evsel_list);
-	perf_evlist__close(evsel_list);
+	perf_evlist__munmap(rec->evlist);
+	perf_evlist__close(rec->evlist);
 out_free_fd:
-	perf_evlist__delete_maps(evsel_list);
+	perf_evlist__delete_maps(rec->evlist);
 out_symbol_exit:
 	symbol__exit();
 	return err;
-- 
1.8.1.4

