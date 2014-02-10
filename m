Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834AbaBJCt2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 21:49:28 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:48677 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133AbaBJCrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 21:47:31 -0500
X-AuditID: 9c93017e-b7cf9ae000004b4b-b2-52f83dc0dffd
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Andi Kleen <andi@firstfloor.org>
Subject: [PATCH 2/8] perf hists: Add support for showing relative percentage
Date: Mon, 10 Feb 2014 11:47:19 +0900
Message-Id: <1392000446-14744-3-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1392000446-14744-1-git-send-email-namhyung@kernel.org>
References: <1392000446-14744-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When filtering by thread, dso or symbol on TUI it also update total
period so that the output shows different result than no filter - the
percentage changed to relative to filtered entries only.  Sometimes
this is not desired since users might expect same results with filter.

So new filtered_* fields to hists->stats to count them separately.
They'll be controlled/used by user later.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/hist.c | 19 +++++++++++++++----
 tools/perf/util/hist.h |  2 ++
 2 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index d0c40897c955..743947d891bd 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -675,8 +675,8 @@ void hists__output_resort(struct hists *hists)
 	next = rb_first(root);
 	hists->entries = RB_ROOT;
 
-	hists->nr_entries = 0;
-	hists->stats.total_period = 0;
+	hists->nr_entries = hists->nr_filtered_entries = 0;
+	hists->stats.total_period = hists->stats.total_filtered_period = 0;
 	hists__reset_col_len(hists);
 
 	while (next) {
@@ -695,12 +695,17 @@ static void hists__remove_entry_filter(struct hists *hists, struct hist_entry *h
 	if (h->filtered)
 		return;
 
-	++hists->nr_entries;
-	if (h->ms.unfolded)
+	hists->nr_entries++;
+	hists->nr_filtered_entries++;
+	if (h->ms.unfolded) {
 		hists->nr_entries += h->nr_rows;
+		hists->nr_filtered_entries += h->nr_rows;
+	}
 	h->row_offset = 0;
 	hists->stats.total_period += h->stat.period;
+	hists->stats.total_filtered_period += h->stat.period;
 	hists->stats.nr_events[PERF_RECORD_SAMPLE] += h->stat.nr_events;
+	hists->stats.nr_filtered_samples += h->stat.nr_events;
 
 	hists__calc_col_len(hists, h);
 }
@@ -723,7 +728,9 @@ void hists__filter_by_dso(struct hists *hists)
 	struct rb_node *nd;
 
 	hists->nr_entries = hists->stats.total_period = 0;
+	hists->nr_filtered_entries = hists->stats.total_filtered_period = 0;
 	hists->stats.nr_events[PERF_RECORD_SAMPLE] = 0;
+	hists->stats.nr_filtered_samples = 0;
 	hists__reset_col_len(hists);
 
 	for (nd = rb_first(&hists->entries); nd; nd = rb_next(nd)) {
@@ -756,7 +763,9 @@ void hists__filter_by_thread(struct hists *hists)
 	struct rb_node *nd;
 
 	hists->nr_entries = hists->stats.total_period = 0;
+	hists->nr_filtered_entries = hists->stats.total_filtered_period = 0;
 	hists->stats.nr_events[PERF_RECORD_SAMPLE] = 0;
+	hists->stats.nr_filtered_samples = 0;
 	hists__reset_col_len(hists);
 
 	for (nd = rb_first(&hists->entries); nd; nd = rb_next(nd)) {
@@ -787,7 +796,9 @@ void hists__filter_by_symbol(struct hists *hists)
 	struct rb_node *nd;
 
 	hists->nr_entries = hists->stats.total_period = 0;
+	hists->nr_filtered_entries = hists->stats.total_filtered_period = 0;
 	hists->stats.nr_events[PERF_RECORD_SAMPLE] = 0;
+	hists->stats.nr_filtered_samples = 0;
 	hists__reset_col_len(hists);
 
 	for (nd = rb_first(&hists->entries); nd; nd = rb_next(nd)) {
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index bdfd821e2435..2f5686f4031b 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -41,6 +41,7 @@ struct events_stats {
 	u64 total_lost;
 	u64 total_invalid_chains;
 	u32 nr_events[PERF_RECORD_HEADER_MAX];
+	u32 nr_filtered_samples;
 	u32 nr_lost_warned;
 	u32 nr_unknown_events;
 	u32 nr_invalid_chains;
@@ -84,6 +85,7 @@ struct hists {
 	struct rb_root		entries;
 	struct rb_root		entries_collapsed;
 	u64			nr_entries;
+	u64			nr_filtered_entries;
 	const struct thread	*thread_filter;
 	const struct dso	*dso_filter;
 	const char		*uid_filter_str;
-- 
1.7.11.7

