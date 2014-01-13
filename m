Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752915AbaAMUvH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 15:51:07 -0500
Received: from merlin.infradead.org ([205.233.59.134]:40456 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219AbaAMUsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 15:48:11 -0500
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
Subject: [PATCH 23/38] perf report: Move histogram entries collapsing to separate function
Date: Mon, 13 Jan 2014 17:47:24 -0300
Message-Id: <1389646059-24881-24-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1389646059-24881-1-git-send-email-acme@infradead.org>
References: <1389646059-24881-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Further uncluttering the main 'report' function by group related code in
separate function.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-b594zsbwke8khir13kudwqmj@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-report.c | 73 ++++++++++++++++++++++++++++-----------------
 1 file changed, 45 insertions(+), 28 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 03941ad8fc46..cff9465847f2 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -486,13 +486,55 @@ static int report__browse_hists(struct report *rep)
 	return ret;
 }
 
+static u64 report__collapse_hists(struct report *rep)
+{
+	struct ui_progress prog;
+	struct perf_evsel *pos;
+	u64 nr_samples = 0;
+	/*
+ 	 * Count number of histogram entries to use when showing progress,
+ 	 * reusing nr_samples variable.
+ 	 */
+	list_for_each_entry(pos, &rep->session->evlist->entries, node)
+		nr_samples += pos->hists.nr_entries;
+
+	ui_progress__init(&prog, nr_samples, "Merging related events...");
+	/*
+	 * Count total number of samples, will be used to check if this
+ 	 * session had any.
+ 	 */
+	nr_samples = 0;
+
+	list_for_each_entry(pos, &rep->session->evlist->entries, node) {
+		struct hists *hists = &pos->hists;
+
+		if (pos->idx == 0)
+			hists->symbol_filter_str = rep->symbol_filter_str;
+
+		hists__collapse_resort(hists, &prog);
+		nr_samples += hists->stats.nr_events[PERF_RECORD_SAMPLE];
+
+		/* Non-group events are considered as leader */
+		if (symbol_conf.event_group &&
+		    !perf_evsel__is_group_leader(pos)) {
+			struct hists *leader_hists = &pos->leader->hists;
+
+			hists__match(leader_hists, hists);
+			hists__link(leader_hists, hists);
+		}
+	}
+
+	ui_progress__finish();
+
+	return nr_samples;
+}
+
 static int __cmd_report(struct report *rep)
 {
-	int ret = -EINVAL;
+	int ret;
 	u64 nr_samples;
 	struct perf_session *session = rep->session;
 	struct perf_evsel *pos;
-	struct ui_progress prog;
 	struct perf_data_file *file = session->file;
 
 	signal(SIGINT, sig_handler);
@@ -530,32 +572,7 @@ static int __cmd_report(struct report *rep)
 		}
 	}
 
-	nr_samples = 0;
-	list_for_each_entry(pos, &session->evlist->entries, node)
-		nr_samples += pos->hists.nr_entries;
-
-	ui_progress__init(&prog, nr_samples, "Merging related events...");
-
-	nr_samples = 0;
-	list_for_each_entry(pos, &session->evlist->entries, node) {
-		struct hists *hists = &pos->hists;
-
-		if (pos->idx == 0)
-			hists->symbol_filter_str = rep->symbol_filter_str;
-
-		hists__collapse_resort(hists, &prog);
-		nr_samples += hists->stats.nr_events[PERF_RECORD_SAMPLE];
-
-		/* Non-group events are considered as leader */
-		if (symbol_conf.event_group &&
-		    !perf_evsel__is_group_leader(pos)) {
-			struct hists *leader_hists = &pos->leader->hists;
-
-			hists__match(leader_hists, hists);
-			hists__link(leader_hists, hists);
-		}
-	}
-	ui_progress__finish();
+	nr_samples = report__collapse_hists(rep);
 
 	if (session_done())
 		return 0;
-- 
1.8.1.4

