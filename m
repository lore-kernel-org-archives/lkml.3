Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071AbaANQhx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 11:37:53 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52492 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751794AbaANQht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 11:37:49 -0500
Date: Tue, 14 Jan 2014 08:36:59 -0800
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-396bnfvmlxrsj3o2tk47b8t1@git.kernel.org>
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
Subject: [tip:perf/core] perf record: Remove old evsel_list usage
Git-Commit-ID: 3e2be2da8f76ef5b2e8e59c3dc8acd24640b4af4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 14 Jan 2014 08:37:06 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3e2be2da8f76ef5b2e8e59c3dc8acd24640b4af4
Gitweb:     http://git.kernel.org/tip/3e2be2da8f76ef5b2e8e59c3dc8acd24640b4af4
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Fri, 3 Jan 2014 15:03:26 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 13 Jan 2014 10:06:21 -0300

perf record: Remove old evsel_list usage

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
index ea7c306..6dcb8aa 100644
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
