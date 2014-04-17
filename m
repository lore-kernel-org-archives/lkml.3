Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756621AbaDQJz5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 05:55:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52816 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161245AbaDQJzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 05:55:52 -0400
Date: Thu, 17 Apr 2014 02:55:27 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-1ab1fa5dfb429c533fbc791e524788cf0cc43775@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, namhyung@kernel.org, jolsa@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, namhyung@kernel.org, jolsa@redhat.com
In-Reply-To: <1397145720-8063-2-git-send-email-namhyung@kernel.org>
References: <1397145720-8063-2-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf hists:
  Add support for showing relative percentage
Git-Commit-ID: 1ab1fa5dfb429c533fbc791e524788cf0cc43775
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

Commit-ID:  1ab1fa5dfb429c533fbc791e524788cf0cc43775
Gitweb:     http://git.kernel.org/tip/1ab1fa5dfb429c533fbc791e524788cf0cc43775
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Thu, 26 Dec 2013 15:11:52 +0900
Committer:  Jiri Olsa <jolsa@redhat.com>
CommitDate: Wed, 16 Apr 2014 17:16:03 +0200

perf hists: Add support for showing relative percentage

When filtering by thread, dso or symbol on TUI it also update total
period so that the output shows different result than no filter - the
percentage changed to relative to filtered entries only.  Sometimes
this is not desired since users might expect same results with filter.

So new filtered_* fields to hists->stats to count them separately.
They'll be controlled/used by user later.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/r/1397145720-8063-2-git-send-email-namhyung@kernel.org
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/builtin-report.c |  6 ++++++
 tools/perf/builtin-top.c    |  3 +++
 tools/perf/util/hist.c      | 17 ++++++++++++++---
 tools/perf/util/hist.h      |  3 +++
 4 files changed, 26 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index c8f2113..2fca56c9 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -123,6 +123,8 @@ static int report__add_mem_hist_entry(struct report *rep, struct addr_location *
 
 	evsel->hists.stats.total_period += cost;
 	hists__inc_nr_events(&evsel->hists, PERF_RECORD_SAMPLE);
+	if (!he->filtered)
+		evsel->hists.stats.nr_non_filtered_samples++;
 	err = hist_entry__append_callchain(he, sample);
 out:
 	return err;
@@ -176,6 +178,8 @@ static int report__add_branch_hist_entry(struct report *rep, struct addr_locatio
 
 			evsel->hists.stats.total_period += 1;
 			hists__inc_nr_events(&evsel->hists, PERF_RECORD_SAMPLE);
+			if (!he->filtered)
+				evsel->hists.stats.nr_non_filtered_samples++;
 		} else
 			goto out;
 	}
@@ -209,6 +213,8 @@ static int report__add_hist_entry(struct report *rep, struct perf_evsel *evsel,
 		err = hist_entry__inc_addr_samples(he, evsel->idx, al->addr);
 
 	evsel->hists.stats.total_period += sample->period;
+	if (!he->filtered)
+		evsel->hists.stats.nr_non_filtered_samples++;
 	hists__inc_nr_events(&evsel->hists, PERF_RECORD_SAMPLE);
 out:
 	return err;
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 65aaa5b..2526901 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -253,6 +253,9 @@ static struct hist_entry *perf_evsel__add_hist_entry(struct perf_evsel *evsel,
 		return NULL;
 
 	hists__inc_nr_events(&evsel->hists, PERF_RECORD_SAMPLE);
+	if (!he->filtered)
+		evsel->hists.stats.nr_non_filtered_samples++;
+
 	return he;
 }
 
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index f38590d..1ed3e2b 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -674,8 +674,8 @@ void hists__output_resort(struct hists *hists)
 	next = rb_first(root);
 	hists->entries = RB_ROOT;
 
-	hists->nr_entries = 0;
-	hists->stats.total_period = 0;
+	hists->nr_entries = hists->nr_non_filtered_entries = 0;
+	hists->stats.total_period = hists->stats.total_non_filtered_period = 0;
 	hists__reset_col_len(hists);
 
 	while (next) {
@@ -695,11 +695,16 @@ static void hists__remove_entry_filter(struct hists *hists, struct hist_entry *h
 		return;
 
 	++hists->nr_entries;
-	if (h->ms.unfolded)
+	++hists->nr_non_filtered_entries;
+	if (h->ms.unfolded) {
 		hists->nr_entries += h->nr_rows;
+		hists->nr_non_filtered_entries += h->nr_rows;
+	}
 	h->row_offset = 0;
 	hists->stats.total_period += h->stat.period;
+	hists->stats.total_non_filtered_period += h->stat.period;
 	hists->stats.nr_events[PERF_RECORD_SAMPLE] += h->stat.nr_events;
+	hists->stats.nr_non_filtered_samples += h->stat.nr_events;
 
 	hists__calc_col_len(hists, h);
 }
@@ -722,7 +727,9 @@ void hists__filter_by_dso(struct hists *hists)
 	struct rb_node *nd;
 
 	hists->nr_entries = hists->stats.total_period = 0;
+	hists->nr_non_filtered_entries = hists->stats.total_non_filtered_period = 0;
 	hists->stats.nr_events[PERF_RECORD_SAMPLE] = 0;
+	hists->stats.nr_non_filtered_samples = 0;
 	hists__reset_col_len(hists);
 
 	for (nd = rb_first(&hists->entries); nd; nd = rb_next(nd)) {
@@ -755,7 +762,9 @@ void hists__filter_by_thread(struct hists *hists)
 	struct rb_node *nd;
 
 	hists->nr_entries = hists->stats.total_period = 0;
+	hists->nr_non_filtered_entries = hists->stats.total_non_filtered_period = 0;
 	hists->stats.nr_events[PERF_RECORD_SAMPLE] = 0;
+	hists->stats.nr_non_filtered_samples = 0;
 	hists__reset_col_len(hists);
 
 	for (nd = rb_first(&hists->entries); nd; nd = rb_next(nd)) {
@@ -786,7 +795,9 @@ void hists__filter_by_symbol(struct hists *hists)
 	struct rb_node *nd;
 
 	hists->nr_entries = hists->stats.total_period = 0;
+	hists->nr_non_filtered_entries = hists->stats.total_non_filtered_period = 0;
 	hists->stats.nr_events[PERF_RECORD_SAMPLE] = 0;
+	hists->stats.nr_non_filtered_samples = 0;
 	hists__reset_col_len(hists);
 
 	for (nd = rb_first(&hists->entries); nd; nd = rb_next(nd)) {
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 1f1f513..2135514 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -37,9 +37,11 @@ enum hist_filter {
  */
 struct events_stats {
 	u64 total_period;
+	u64 total_non_filtered_period;
 	u64 total_lost;
 	u64 total_invalid_chains;
 	u32 nr_events[PERF_RECORD_HEADER_MAX];
+	u32 nr_non_filtered_samples;
 	u32 nr_lost_warned;
 	u32 nr_unknown_events;
 	u32 nr_invalid_chains;
@@ -83,6 +85,7 @@ struct hists {
 	struct rb_root		entries;
 	struct rb_root		entries_collapsed;
 	u64			nr_entries;
+	u64			nr_non_filtered_entries;
 	const struct thread	*thread_filter;
 	const struct dso	*dso_filter;
 	const char		*uid_filter_str;
