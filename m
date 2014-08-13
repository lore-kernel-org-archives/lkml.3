Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913AbaHMWtw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 18:49:52 -0400
Received: from mail.kernel.org ([198.145.19.201]:55148 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753844AbaHMWtt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 18:49:49 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Minchan Kim <minchan@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 16/41] perf annotate: Move session handling out of __cmd_annotate()
Date: Wed, 13 Aug 2014 19:48:02 -0300
Message-Id: <1407970107-24540-17-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1407970107-24540-1-git-send-email-acme@kernel.org>
References: <1407970107-24540-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

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
index 952b5ece6740..c0464dc38057 100644
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
-- 
1.9.3

