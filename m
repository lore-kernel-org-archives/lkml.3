Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752471AbaLXHSD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 02:18:03 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:40286 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194AbaLXHPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 02:15:42 -0500
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 32/37] perf report: Add --multi-thread option and config item
Date: Wed, 24 Dec 2014 16:15:28 +0900
Message-Id: <1419405333-27952-33-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1419405333-27952-1-git-send-email-namhyung@kernel.org>
References: <1419405333-27952-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The --multi-thread option is to enable parallel processing so user can
force serial processing even for multi-file data.  It default to false
but users also can changes this by setting "report.multi_thread"
config option in ~/.perfconfig file.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/Documentation/perf-report.txt |  3 +++
 tools/perf/builtin-report.c              | 18 +++++++++++++++---
 2 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
index dd7cccdde498..e00077a658c1 100644
--- a/tools/perf/Documentation/perf-report.txt
+++ b/tools/perf/Documentation/perf-report.txt
@@ -318,6 +318,9 @@ OPTIONS
 --header-only::
 	Show only perf.data header (forces --stdio).
 
+--multi-thread::
+	Speed up report by parallelizing sample processing using multi-thread.
+
 SEE ALSO
 --------
 linkperf:perf-stat[1], linkperf:perf-annotate[1]
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 796db514db31..6e260eaf3b1a 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -51,6 +51,7 @@ struct report {
 	bool			mem_mode;
 	bool			header;
 	bool			header_only;
+	bool			multi_thread;
 	int			max_stack;
 	struct perf_read_values	show_threads_values;
 	const char		*pretty_printing_style;
@@ -82,6 +83,10 @@ static int report__config(const char *var, const char *value, void *cb)
 		rep->queue_size = perf_config_u64(var, value);
 		return 0;
 	}
+	if (!strcmp(var, "report.multi-thread")) {
+		rep->multi_thread = perf_config_bool(var, value);
+		return 0;
+	}
 
 	return perf_default_config(var, value, cb);
 }
@@ -527,7 +532,7 @@ static int __cmd_report(struct report *rep)
 	if (ret)
 		return ret;
 
-	if (file->is_multi) {
+	if (rep->multi_thread) {
 		rep->tool.sample = process_sample_event_multi;
 		ret = perf_session__process_events_mt(session, &rep->tool,
 						      multi_report_init,
@@ -558,10 +563,10 @@ static int __cmd_report(struct report *rep)
 	}
 
 	/*
-	 * For multi-file report, it already calls hists__multi_resort()
+	 * For multi-thread report, it already calls hists__multi_resort()
 	 * so no need to collapse here.
 	 */
-	if (!file->is_multi)
+	if (!rep->multi_thread)
 		report__collapse_hists(rep);
 
 	if (session_done())
@@ -770,6 +775,8 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 		     "Don't show entries under that percent", parse_percent_limit),
 	OPT_CALLBACK(0, "percentage", NULL, "relative|absolute",
 		     "how to display percentage of filtered entries", parse_filter_percentage),
+	OPT_BOOLEAN(0, "multi-thread", &report.multi_thread,
+		    "Speed up sample processing using multi-thead"),
 	OPT_END()
 	};
 	struct perf_data_file file = {
@@ -814,6 +821,11 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 					       report.queue_size);
 	}
 
+	if (report.multi_thread && !file.is_multi) {
+		pr_debug("fallback to single thread for single data file.\n");
+		report.multi_thread = false;
+	}
+
 	report.session = session;
 
 	has_br_stack = perf_header__has_feat(&session->header,
-- 
2.1.3

