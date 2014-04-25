Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753081AbaDYNOO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 09:14:14 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40502 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752941AbaDYNOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 09:14:10 -0400
Date: Fri, 25 Apr 2014 06:13:58 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-9283ba9bd77a6940ecad8721429131d773c704b8@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jolsa@kernel.org, tglx@linutronix.de, namhyung@kernel.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jolsa@kernel.org, tglx@linutronix.de, namhyung@kernel.org
In-Reply-To: <1398327843-31845-5-git-send-email-namhyung@kernel.org>
References: <1398327843-31845-5-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf hists:
  Add a couple of hists stat helper functions
Git-Commit-ID: 9283ba9bd77a6940ecad8721429131d773c704b8
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

Commit-ID:  9283ba9bd77a6940ecad8721429131d773c704b8
Gitweb:     http://git.kernel.org/tip/9283ba9bd77a6940ecad8721429131d773c704b8
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Thu, 24 Apr 2014 16:37:26 +0900
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Thu, 24 Apr 2014 16:31:25 +0200

perf hists: Add a couple of hists stat helper functions

Add hists__{reset,inc}_[filter_]stats() functions to cleanup accesses
to hist stats (for output).  Note that number of samples in the stat
is not handled here since it belongs to the input stage.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/r/1398327843-31845-5-git-send-email-namhyung@kernel.org
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/builtin-diff.c |  5 +---
 tools/perf/util/hist.c    | 59 ++++++++++++++++++++++++++++++-----------------
 tools/perf/util/hist.h    |  1 +
 3 files changed, 40 insertions(+), 25 deletions(-)

diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index c9cc771..52d91ac 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -573,10 +573,7 @@ static void hists__compute_resort(struct hists *hists)
 	hists->entries = RB_ROOT;
 	next = rb_first(root);
 
-	hists->nr_entries = 0;
-	hists->nr_non_filtered_entries = 0;
-	hists->stats.total_period = 0;
-	hists->stats.total_non_filtered_period = 0;
+	hists__reset_stats(hists);
 	hists__reset_col_len(hists);
 
 	while (next != NULL) {
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index f5b388e..b675857 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -317,16 +317,6 @@ static struct hist_entry *hist_entry__new(struct hist_entry *template)
 	return he;
 }
 
-void hists__inc_stats(struct hists *hists, struct hist_entry *h)
-{
-	if (!h->filtered) {
-		hists->nr_non_filtered_entries++;
-		hists->stats.total_non_filtered_period += h->stat.period;
-	}
-	hists->nr_entries++;
-	hists->stats.total_period += h->stat.period;
-}
-
 static u8 symbol__parent_filter(const struct symbol *parent)
 {
 	if (symbol_conf.exclude_other && parent == NULL)
@@ -632,6 +622,35 @@ out:
 	return ret;
 }
 
+static void hists__reset_filter_stats(struct hists *hists)
+{
+	hists->nr_non_filtered_entries = 0;
+	hists->stats.total_non_filtered_period = 0;
+}
+
+void hists__reset_stats(struct hists *hists)
+{
+	hists->nr_entries = 0;
+	hists->stats.total_period = 0;
+
+	hists__reset_filter_stats(hists);
+}
+
+static void hists__inc_filter_stats(struct hists *hists, struct hist_entry *h)
+{
+	hists->nr_non_filtered_entries++;
+	hists->stats.total_non_filtered_period += h->stat.period;
+}
+
+void hists__inc_stats(struct hists *hists, struct hist_entry *h)
+{
+	if (!h->filtered)
+		hists__inc_filter_stats(hists, h);
+
+	hists->nr_entries++;
+	hists->stats.total_period += h->stat.period;
+}
+
 static void __hists__insert_output_entry(struct rb_root *entries,
 					 struct hist_entry *he,
 					 u64 min_callchain_hits)
@@ -675,9 +694,7 @@ void hists__output_resort(struct hists *hists)
 	next = rb_first(root);
 	hists->entries = RB_ROOT;
 
-	hists->nr_non_filtered_entries = 0;
-	hists->stats.total_period = 0;
-	hists->stats.total_non_filtered_period = 0;
+	hists__reset_stats(hists);
 	hists__reset_col_len(hists);
 
 	while (next) {
@@ -699,13 +716,13 @@ static void hists__remove_entry_filter(struct hists *hists, struct hist_entry *h
 	if (h->filtered)
 		return;
 
-	++hists->nr_non_filtered_entries;
 	if (h->ms.unfolded)
 		hists->nr_non_filtered_entries += h->nr_rows;
 	h->row_offset = 0;
-	hists->stats.total_non_filtered_period += h->stat.period;
+
 	hists->stats.nr_non_filtered_samples += h->stat.nr_events;
 
+	hists__inc_filter_stats(hists, h);
 	hists__calc_col_len(hists, h);
 }
 
@@ -726,9 +743,9 @@ void hists__filter_by_dso(struct hists *hists)
 {
 	struct rb_node *nd;
 
-	hists->nr_non_filtered_entries = 0;
-	hists->stats.total_non_filtered_period = 0;
 	hists->stats.nr_non_filtered_samples = 0;
+
+	hists__reset_filter_stats(hists);
 	hists__reset_col_len(hists);
 
 	for (nd = rb_first(&hists->entries); nd; nd = rb_next(nd)) {
@@ -760,9 +777,9 @@ void hists__filter_by_thread(struct hists *hists)
 {
 	struct rb_node *nd;
 
-	hists->nr_non_filtered_entries = 0;
-	hists->stats.total_non_filtered_period = 0;
 	hists->stats.nr_non_filtered_samples = 0;
+
+	hists__reset_filter_stats(hists);
 	hists__reset_col_len(hists);
 
 	for (nd = rb_first(&hists->entries); nd; nd = rb_next(nd)) {
@@ -792,9 +809,9 @@ void hists__filter_by_symbol(struct hists *hists)
 {
 	struct rb_node *nd;
 
-	hists->nr_non_filtered_entries = 0;
-	hists->stats.total_non_filtered_period = 0;
 	hists->stats.nr_non_filtered_samples = 0;
+
+	hists__reset_filter_stats(hists);
 	hists__reset_col_len(hists);
 
 	for (nd = rb_first(&hists->entries); nd; nd = rb_next(nd)) {
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 51478c9..ef1ad7a 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -116,6 +116,7 @@ void hists__decay_entries(struct hists *hists, bool zap_user, bool zap_kernel);
 void hists__output_recalc_col_len(struct hists *hists, int max_rows);
 
 u64 hists__total_period(struct hists *hists);
+void hists__reset_stats(struct hists *hists);
 void hists__inc_stats(struct hists *hists, struct hist_entry *h);
 void hists__inc_nr_events(struct hists *hists, u32 type);
 void events_stats__inc(struct events_stats *stats, u32 type);
