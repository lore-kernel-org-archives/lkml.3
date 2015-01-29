Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895AbbA2IMr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 03:12:47 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:51614 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753529AbbA2IKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 03:10:20 -0500
X-Original-SENDERIP: 10.177.220.203
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 37/42] perf report: Add --multi-thread option and config item
Date: Thu, 29 Jan 2015 17:07:18 +0900
Message-Id: <1422518843-25818-38-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1422518843-25818-1-git-send-email-namhyung@kernel.org>
References: <1422518843-25818-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The --multi-thread option is to enable parallel processing so user can
force serial processing even for indexed data file.  It default to false
for now but users also can changes this by setting "report.multi_thread"
config option in ~/.perfconfig file.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/Documentation/perf-report.txt |  3 ++
 tools/perf/builtin-report.c              | 66 +++++++++++++++++++++++++++-----
 tools/perf/util/session.c                |  1 +
 3 files changed, 61 insertions(+), 9 deletions(-)

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
index 8a40c79d9273..b0539c017898 100644
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
@@ -128,13 +133,14 @@ static int hist_iter__report_callback(struct hist_entry_iter *iter,
 	return err;
 }
 
-static int process_sample_event(struct perf_tool *tool,
-				union perf_event *event,
-				struct perf_sample *sample,
-				struct perf_evsel *evsel,
-				struct machine *machine)
+static int __process_sample_event(struct perf_tool *tool __maybe_unused,
+				  union perf_event *event,
+				  struct perf_sample *sample,
+				  struct perf_evsel *evsel,
+				  struct machine *machine,
+				  struct hists *hists,
+				  struct report *rep)
 {
-	struct report *rep = container_of(tool, struct report, tool);
 	struct addr_location al;
 	struct hist_entry_iter iter = {
 		.hide_unresolved = rep->hide_unresolved,
@@ -167,7 +173,7 @@ static int process_sample_event(struct perf_tool *tool,
 	if (al.map != NULL)
 		al.map->dso->hit = 1;
 
-	ret = hist_entry_iter__add(&iter, evsel__hists(evsel), evsel, &al,
+	ret = hist_entry_iter__add(&iter, hists, evsel, &al,
 				   sample, rep->max_stack, rep);
 	if (ret < 0)
 		pr_debug("problem adding hist entry, skipping event\n");
@@ -175,6 +181,31 @@ static int process_sample_event(struct perf_tool *tool,
 	return ret;
 }
 
+static int process_sample_event(struct perf_tool *tool,
+				union perf_event *event,
+				struct perf_sample *sample,
+				struct perf_evsel *evsel,
+				struct machine *machine)
+{
+	struct report *rep = container_of(tool, struct report, tool);
+
+	return __process_sample_event(tool, event, sample, evsel, machine,
+				      evsel__hists(evsel), rep);
+}
+
+static int process_sample_event_mt(struct perf_tool *tool,
+				   union perf_event *event,
+				   struct perf_sample *sample,
+				   struct perf_evsel *evsel,
+				   struct machine *machine)
+{
+	struct perf_tool_mt *mt = container_of(tool, struct perf_tool_mt, tool);
+	struct report *rep = mt->priv;
+
+	return __process_sample_event(tool, event, sample, evsel, machine,
+				      &mt->hists[evsel->idx], rep);
+}
+
 static int process_read_event(struct perf_tool *tool,
 			      union perf_event *event,
 			      struct perf_sample *sample __maybe_unused,
@@ -484,7 +515,12 @@ static int __cmd_report(struct report *rep)
 	if (ret)
 		return ret;
 
-	ret = perf_session__process_events(session, &rep->tool);
+	if (rep->multi_thread) {
+		rep->tool.sample = process_sample_event_mt;
+		ret = perf_session__process_events_mt(session, &rep->tool, rep);
+	} else {
+		ret = perf_session__process_events(session, &rep->tool);
+	}
 	if (ret)
 		return ret;
 
@@ -507,7 +543,12 @@ static int __cmd_report(struct report *rep)
 		}
 	}
 
-	report__collapse_hists(rep);
+	/*
+	 * For multi-thread report, it already calls hists__mt_resort()
+	 * so no need to collapse here.
+	 */
+	if (!rep->multi_thread)
+		report__collapse_hists(rep);
 
 	if (session_done())
 		return 0;
@@ -715,6 +756,8 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 		     "Don't show entries under that percent", parse_percent_limit),
 	OPT_CALLBACK(0, "percentage", NULL, "relative|absolute",
 		     "how to display percentage of filtered entries", parse_filter_percentage),
+	OPT_BOOLEAN(0, "multi-thread", &report.multi_thread,
+		    "Speed up sample processing using multi-thead"),
 	OPT_END()
 	};
 	struct perf_data_file file = {
@@ -759,6 +802,11 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 					       report.queue_size);
 	}
 
+	if (report.multi_thread && !perf_session__has_index(session)) {
+		pr_debug("fallback to single thread for normal data file.\n");
+		report.multi_thread = false;
+	}
+
 	report.session = session;
 
 	has_br_stack = perf_header__has_feat(&session->header,
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 3596bb608f3c..6d34c880010f 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1586,6 +1586,7 @@ int perf_session__process_events_mt(struct perf_session *session,
 
 	goto out;
 }
+
 bool perf_session__has_traces(struct perf_session *session, const char *msg)
 {
 	struct perf_evsel *evsel;
-- 
2.2.2

