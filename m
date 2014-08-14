Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755AbaHNIqi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 04:46:38 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36362 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752172AbaHNIqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 04:46:35 -0400
Date: Thu, 14 Aug 2014 01:46:10 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-fa10f316d59f39020d19d3f4a323598d05afa65c@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, jolsa@kernel.org,
        a.p.zijlstra@chello.nl, minchan@kernel.org, namhyung.kim@lge.com,
        namhyung@kernel.org, jolsa@redhat.com, adrian.hunter@intel.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, jolsa@kernel.org,
        minchan@kernel.org, a.p.zijlstra@chello.nl, namhyung.kim@lge.com,
        namhyung@kernel.org, jolsa@redhat.com, dsahern@gmail.com,
        adrian.hunter@intel.com, tglx@linutronix.de
In-Reply-To: <1407825645-24586-4-git-send-email-namhyung@kernel.org>
References: <1407825645-24586-4-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf annotate:
  Move session handling out of __cmd_annotate()
Git-Commit-ID: fa10f316d59f39020d19d3f4a323598d05afa65c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fa10f316d59f39020d19d3f4a323598d05afa65c
Gitweb:     http://git.kernel.org/tip/fa10f316d59f39020d19d3f4a323598d05afa65c
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Tue, 12 Aug 2014 15:40:35 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 13 Aug 2014 16:31:23 -0300

perf annotate: Move session handling out of __cmd_annotate()

This is a preparation of fixing dso__load_kernel_sym().  It needs a
session info before calling symbol__init().

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1407825645-24586-4-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-annotate.c | 75 +++++++++++++++++++++++--------------------
 1 file changed, 40 insertions(+), 35 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 952b5ec..c0464dc 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -36,7 +36,8 @@
 
 struct perf_annotate {
 	struct perf_tool tool;
-	bool	   force, use_tui, use_stdio, use_gtk;
+	struct perf_session *session;
+	bool	   use_tui, use_stdio, use_gtk;
 	bool	   full_paths;
 	bool	   print_line;
 	bool	   skip_missing;
@@ -188,18 +189,9 @@ find_next:
 static int __cmd_annotate(struct perf_annotate *ann)
 {
 	int ret;
-	struct perf_session *session;
+	struct perf_session *session = ann->session;
 	struct perf_evsel *pos;
 	u64 total_nr_samples;
-	struct perf_data_file file = {
-		.path  = input_name,
-		.mode  = PERF_DATA_MODE_READ,
-		.force = ann->force,
-	};
-
-	session = perf_session__new(&file, false, &ann->tool);
-	if (session == NULL)
-		return -ENOMEM;
 
 	machines__set_symbol_filter(&session->machines, symbol__annotate_init);
 
@@ -207,22 +199,22 @@ static int __cmd_annotate(struct perf_annotate *ann)
 		ret = perf_session__cpu_bitmap(session, ann->cpu_list,
 					       ann->cpu_bitmap);
 		if (ret)
-			goto out_delete;
+			goto out;
 	}
 
 	if (!objdump_path) {
 		ret = perf_session_env__lookup_objdump(&session->header.env);
 		if (ret)
-			goto out_delete;
+			goto out;
 	}
 
 	ret = perf_session__process_events(session, &ann->tool);
 	if (ret)
-		goto out_delete;
+		goto out;
 
 	if (dump_trace) {
 		perf_session__fprintf_nr_events(session, stdout);
-		goto out_delete;
+		goto out;
 	}
 
 	if (verbose > 3)
@@ -250,8 +242,8 @@ static int __cmd_annotate(struct perf_annotate *ann)
 	}
 
 	if (total_nr_samples == 0) {
-		ui__error("The %s file has no samples!\n", file.path);
-		goto out_delete;
+		ui__error("The %s file has no samples!\n", session->file->path);
+		goto out;
 	}
 
 	if (use_browser == 2) {
@@ -261,24 +253,12 @@ static int __cmd_annotate(struct perf_annotate *ann)
 					 "perf_gtk__show_annotations");
 		if (show_annotations == NULL) {
 			ui__error("GTK browser not found!\n");
-			goto out_delete;
+			goto out;
 		}
 		show_annotations();
 	}
 
-out_delete:
-	/*
-	 * Speed up the exit process, for large files this can
-	 * take quite a while.
-	 *
-	 * XXX Enable this when using valgrind or if we ever
-	 * librarize this command.
-	 *
-	 * Also experiment with obstacks to see how much speed
-	 * up we'll get here.
-	 *
-	 * perf_session__delete(session);
-	 */
+out:
 	return ret;
 }
 
@@ -301,6 +281,10 @@ int cmd_annotate(int argc, const char **argv, const char *prefix __maybe_unused)
 			.ordering_requires_timestamps = true,
 		},
 	};
+	struct perf_data_file file = {
+		.path  = input_name,
+		.mode  = PERF_DATA_MODE_READ,
+	};
 	const struct option options[] = {
 	OPT_STRING('i', "input", &input_name, "file",
 		    "input file name"),
@@ -308,7 +292,7 @@ int cmd_annotate(int argc, const char **argv, const char *prefix __maybe_unused)
 		   "only consider symbols in these dsos"),
 	OPT_STRING('s', "symbol", &annotate.sym_hist_filter, "symbol",
 		    "symbol to annotate"),
-	OPT_BOOLEAN('f', "force", &annotate.force, "don't complain, do it"),
+	OPT_BOOLEAN('f', "force", &file.force, "don't complain, do it"),
 	OPT_INCR('v', "verbose", &verbose,
 		    "be more verbose (show symbol address, etc)"),
 	OPT_BOOLEAN('D', "dump-raw-trace", &dump_trace,
@@ -341,6 +325,7 @@ int cmd_annotate(int argc, const char **argv, const char *prefix __maybe_unused)
 		    "Show event group information together"),
 	OPT_END()
 	};
+	int ret;
 
 	argc = parse_options(argc, argv, options, annotate_usage, 0);
 
@@ -353,11 +338,16 @@ int cmd_annotate(int argc, const char **argv, const char *prefix __maybe_unused)
 
 	setup_browser(true);
 
+	annotate.session = perf_session__new(&file, false, &annotate.tool);
+	if (annotate.session == NULL)
+		return -ENOMEM;
+
 	symbol_conf.priv_size = sizeof(struct annotation);
 	symbol_conf.try_vmlinux_path = true;
 
-	if (symbol__init() < 0)
-		return -1;
+	ret = symbol__init();
+	if (ret < 0)
+		goto out_delete;
 
 	if (setup_sorting() < 0)
 		usage_with_options(annotate_usage, options);
@@ -373,5 +363,20 @@ int cmd_annotate(int argc, const char **argv, const char *prefix __maybe_unused)
 		annotate.sym_hist_filter = argv[0];
 	}
 
-	return __cmd_annotate(&annotate);
+	ret = __cmd_annotate(&annotate);
+
+out_delete:
+	/*
+	 * Speed up the exit process, for large files this can
+	 * take quite a while.
+	 *
+	 * XXX Enable this when using valgrind or if we ever
+	 * librarize this command.
+	 *
+	 * Also experiment with obstacks to see how much speed
+	 * up we'll get here.
+	 *
+	 * perf_session__delete(session);
+	 */
+	return ret;
 }
