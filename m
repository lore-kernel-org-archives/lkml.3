Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266AbaDXI3B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 04:29:01 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:38524 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752290AbaDXIYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 04:24:07 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: [PATCH 01/11] perf report: Count number of entries separately
Date: Thu, 24 Apr 2014 17:23:53 +0900
Message-Id: <1398327843-31845-2-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1398327843-31845-1-git-send-email-namhyung@kernel.org>
References: <1398327843-31845-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The hists->nr_entries is counted in multiple places so that they can
confuse readers of the code.  This is a preparation of later change
and do not intend any functional difference.

Note that report__collapse_hists() now changed to return nothing since
its return value (nr_samples) is only for checking if there's any data
in the input file and this can be acheived by checking ->nr_entries.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-report.c | 42 ++++++++++++++++++++++--------------------
 1 file changed, 22 insertions(+), 20 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 76e2bb6cf571..aed52036468d 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -57,6 +57,7 @@ struct report {
 	const char		*cpu_list;
 	const char		*symbol_filter_str;
 	float			min_percent;
+	u64			nr_entries;
 	DECLARE_BITMAP(cpu_bitmap, MAX_NR_CPUS);
 };
 
@@ -75,6 +76,17 @@ static int report__config(const char *var, const char *value, void *cb)
 	return perf_default_config(var, value, cb);
 }
 
+static void report__inc_stats(struct report *rep, struct hist_entry *he)
+{
+	/*
+	 * The @he is either of a newly created one or an existing one
+	 * merging current sample.  We only want to count a new one so
+	 * checking ->nr_events being 1.
+	 */
+	if (he->stat.nr_events == 1)
+		rep->nr_entries++;
+}
+
 static int report__add_mem_hist_entry(struct report *rep, struct addr_location *al,
 				      struct perf_sample *sample, struct perf_evsel *evsel)
 {
@@ -121,6 +133,8 @@ static int report__add_mem_hist_entry(struct report *rep, struct addr_location *
 			goto out;
 	}
 
+	report__inc_stats(rep, he);
+
 	evsel->hists.stats.total_period += cost;
 	hists__inc_nr_events(&evsel->hists, PERF_RECORD_SAMPLE);
 	if (!he->filtered)
@@ -176,6 +190,8 @@ static int report__add_branch_hist_entry(struct report *rep, struct addr_locatio
 					goto out;
 			}
 
+			report__inc_stats(rep, he);
+
 			evsel->hists.stats.total_period += 1;
 			hists__inc_nr_events(&evsel->hists, PERF_RECORD_SAMPLE);
 			if (!he->filtered)
@@ -212,6 +228,8 @@ static int report__add_hist_entry(struct report *rep, struct perf_evsel *evsel,
 	if (ui__has_annotation())
 		err = hist_entry__inc_addr_samples(he, evsel->idx, al->addr);
 
+	report__inc_stats(rep, he);
+
 	evsel->hists.stats.total_period += sample->period;
 	if (!he->filtered)
 		evsel->hists.stats.nr_non_filtered_samples++;
@@ -486,24 +504,12 @@ static int report__browse_hists(struct report *rep)
 	return ret;
 }
 
-static u64 report__collapse_hists(struct report *rep)
+static void report__collapse_hists(struct report *rep)
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
@@ -512,7 +518,6 @@ static u64 report__collapse_hists(struct report *rep)
 			hists->symbol_filter_str = rep->symbol_filter_str;
 
 		hists__collapse_resort(hists, &prog);
-		nr_samples += hists->stats.nr_events[PERF_RECORD_SAMPLE];
 
 		/* Non-group events are considered as leader */
 		if (symbol_conf.event_group &&
@@ -525,14 +530,11 @@ static u64 report__collapse_hists(struct report *rep)
 	}
 
 	ui_progress__finish();
-
-	return nr_samples;
 }
 
 static int __cmd_report(struct report *rep)
 {
 	int ret;
-	u64 nr_samples;
 	struct perf_session *session = rep->session;
 	struct perf_evsel *pos;
 	struct perf_data_file *file = session->file;
@@ -572,12 +574,12 @@ static int __cmd_report(struct report *rep)
 		}
 	}
 
-	nr_samples = report__collapse_hists(rep);
+	report__collapse_hists(rep);
 
 	if (session_done())
 		return 0;
 
-	if (nr_samples == 0) {
+	if (rep->nr_entries == 0) {
 		ui__error("The %s file has no samples!\n", file->path);
 		return 0;
 	}
-- 
1.9.2

