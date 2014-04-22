Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753636AbaDVIuC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 04:50:02 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:62679 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546AbaDVIt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 04:49:56 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: [PATCH 1/9] perf report: Count number of entries and samples separately
Date: Tue, 22 Apr 2014 17:49:43 +0900
Message-Id: <1398156591-11001-2-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1398156591-11001-1-git-send-email-namhyung@kernel.org>
References: <1398156591-11001-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Those stats are counted counted in multiple places so that they can
confuse readers of the code.  This is a preparation of later change
and do not intend any functional difference.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-report.c | 37 ++++++++++++++++++++++---------------
 1 file changed, 22 insertions(+), 15 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 76e2bb6cf571..375fc504386e 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -57,6 +57,8 @@ struct report {
 	const char		*cpu_list;
 	const char		*symbol_filter_str;
 	float			min_percent;
+	u64			nr_entries;
+	u64			nr_samples;
 	DECLARE_BITMAP(cpu_bitmap, MAX_NR_CPUS);
 };
 
@@ -121,6 +123,12 @@ static int report__add_mem_hist_entry(struct report *rep, struct addr_location *
 			goto out;
 	}
 
+	rep->nr_samples++;
+	if (he->stat.nr_events == 1) {
+		/* count new entries only */
+		rep->nr_entries++;
+	}
+
 	evsel->hists.stats.total_period += cost;
 	hists__inc_nr_events(&evsel->hists, PERF_RECORD_SAMPLE);
 	if (!he->filtered)
@@ -176,6 +184,12 @@ static int report__add_branch_hist_entry(struct report *rep, struct addr_locatio
 					goto out;
 			}
 
+			rep->nr_samples++;
+			if (he->stat.nr_events == 1) {
+				/* count new entries only */
+				rep->nr_entries++;
+			}
+
 			evsel->hists.stats.total_period += 1;
 			hists__inc_nr_events(&evsel->hists, PERF_RECORD_SAMPLE);
 			if (!he->filtered)
@@ -212,6 +226,12 @@ static int report__add_hist_entry(struct report *rep, struct perf_evsel *evsel,
 	if (ui__has_annotation())
 		err = hist_entry__inc_addr_samples(he, evsel->idx, al->addr);
 
+	rep->nr_samples++;
+	if (he->stat.nr_events == 1) {
+		/* count new entries only */
+		rep->nr_entries++;
+	}
+
 	evsel->hists.stats.total_period += sample->period;
 	if (!he->filtered)
 		evsel->hists.stats.nr_non_filtered_samples++;
@@ -490,20 +510,8 @@ static u64 report__collapse_hists(struct report *rep)
 {
 	struct ui_progress prog;
 	struct perf_evsel *pos;
-	u64 nr_samples = 0;
-	/*
- 	 * Count number of histogram entries to use when showing progress,
- 	 * reusing nr_samples variable.
- 	 */
-	evlist__for_each(rep->session->evlist, pos)
-		nr_samples += pos->hists.nr_entries;
 
-	ui_progress__init(&prog, nr_samples, "Merging related events...");
-	/*
-	 * Count total number of samples, will be used to check if this
- 	 * session had any.
- 	 */
-	nr_samples = 0;
+	ui_progress__init(&prog, rep->nr_entries, "Merging related events...");
 
 	evlist__for_each(rep->session->evlist, pos) {
 		struct hists *hists = &pos->hists;
@@ -512,7 +520,6 @@ static u64 report__collapse_hists(struct report *rep)
 			hists->symbol_filter_str = rep->symbol_filter_str;
 
 		hists__collapse_resort(hists, &prog);
-		nr_samples += hists->stats.nr_events[PERF_RECORD_SAMPLE];
 
 		/* Non-group events are considered as leader */
 		if (symbol_conf.event_group &&
@@ -526,7 +533,7 @@ static u64 report__collapse_hists(struct report *rep)
 
 	ui_progress__finish();
 
-	return nr_samples;
+	return rep->nr_samples;
 }
 
 static int __cmd_report(struct report *rep)
-- 
1.9.2

