Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759167AbaDJULe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 16:11:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9856 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753679AbaDJULb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 16:11:31 -0400
From: Don Zickus <dzickus@redhat.com>
To: acme@kernel.org, namhyung@kernel.org, jolsa@redhat.com
Cc: eranian@google.com, Andi Kleen <andi@firstfloor.org>,
        LKML <linux-kernel@vger.kernel.org>, Don Zickus <dzickus@redhat.com>
Subject: [RFC 1/5] perf: Wrap __hists__add_entry to prep for group entry change
Date: Thu, 10 Apr 2014 16:10:57 -0400
Message-Id: <1397160661-33395-2-git-send-email-dzickus@redhat.com>
In-Reply-To: <1397160661-33395-1-git-send-email-dzickus@redhat.com>
References: <1397160661-33395-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is mainly mechanical and just wraps __hists__add_entry with
hists__add_entry.  Later on, we can modify hists__add_entry to include group
entry changes without disturbing the builtin-* files.

Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 tools/perf/builtin-annotate.c |  2 +-
 tools/perf/builtin-diff.c     | 14 +++++++-------
 tools/perf/builtin-report.c   | 12 ++++++------
 tools/perf/builtin-top.c      |  6 +++---
 tools/perf/tests/hists_link.c |  8 ++++----
 tools/perf/util/hist.c        | 25 +++++++++++++++++++------
 tools/perf/util/hist.h        | 12 ++++++------
 7 files changed, 46 insertions(+), 33 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 0da603b..0157787 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -65,7 +65,7 @@ static int perf_evsel__add_sample(struct perf_evsel *evsel,
 		return 0;
 	}
 
-	he = __hists__add_entry(&evsel->hists, al, NULL, NULL, NULL, 1, 1, 0);
+	he = hists__add_entry(&evsel->hists, al, NULL, NULL, NULL, 1, 1, 0);
 	if (he == NULL)
 		return -ENOMEM;
 
diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 204fffe..2e4857d 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -303,12 +303,12 @@ static int formula_fprintf(struct hist_entry *he, struct hist_entry *pair,
 	return -1;
 }
 
-static int hists__add_entry(struct hists *hists,
-			    struct addr_location *al, u64 period,
-			    u64 weight, u64 transaction)
+static int diff_hists__add_entry(struct hists *hists,
+				 struct addr_location *al, u64 period,
+				 u64 weight, u64 transaction)
 {
-	if (__hists__add_entry(hists, al, NULL, NULL, NULL, period, weight,
-			       transaction) != NULL)
+	if (hists__add_entry(hists, al, NULL, NULL, NULL, period, weight,
+			     transaction) != NULL)
 		return 0;
 	return -ENOMEM;
 }
@@ -330,8 +330,8 @@ static int diff__process_sample_event(struct perf_tool *tool __maybe_unused,
 	if (al.filtered)
 		return 0;
 
-	if (hists__add_entry(&evsel->hists, &al, sample->period,
-			     sample->weight, sample->transaction)) {
+	if (diff_hists__add_entry(&evsel->hists, &al, sample->period,
+				  sample->weight, sample->transaction)) {
 		pr_warning("problem incrementing symbol period, skipping event\n");
 		return -1;
 	}
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index c8f2113..51a37d6 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -105,8 +105,8 @@ static int report__add_mem_hist_entry(struct report *rep, struct addr_location *
 	 * and this is indirectly achieved by passing period=weight here
 	 * and the he_stat__add_period() function.
 	 */
-	he = __hists__add_entry(&evsel->hists, al, parent, NULL, mi,
-				cost, cost, 0);
+	he = hists__add_entry(&evsel->hists, al, parent, NULL, mi,
+			      cost, cost, 0);
 	if (!he)
 		return -ENOMEM;
 
@@ -158,8 +158,8 @@ static int report__add_branch_hist_entry(struct report *rep, struct addr_locatio
 		 * The report shows the percentage of total branches captured
 		 * and not events sampled. Thus we use a pseudo period of 1.
 		 */
-		he = __hists__add_entry(&evsel->hists, al, parent, &bi[i], NULL,
-					1, 1, 0);
+		he = hists__add_entry(&evsel->hists, al, parent, &bi[i], NULL,
+			 	      1, 1, 0);
 		if (he) {
 			if (ui__has_annotation()) {
 				bx = he->branch_info;
@@ -195,8 +195,8 @@ static int report__add_hist_entry(struct report *rep, struct perf_evsel *evsel,
 	if (err)
 		return err;
 
-	he = __hists__add_entry(&evsel->hists, al, parent, NULL, NULL,
-				sample->period, sample->weight,
+	he = hists__add_entry(&evsel->hists, al, parent, NULL, NULL,
+			      sample->period, sample->weight,
 				sample->transaction);
 	if (he == NULL)
 		return -ENOMEM;
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 65aaa5b..e58b124 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -245,9 +245,9 @@ static struct hist_entry *perf_evsel__add_hist_entry(struct perf_evsel *evsel,
 	struct hist_entry *he;
 
 	pthread_mutex_lock(&evsel->hists.lock);
-	he = __hists__add_entry(&evsel->hists, al, NULL, NULL, NULL,
-				sample->period, sample->weight,
-				sample->transaction);
+	he = hists__add_entry(&evsel->hists, al, NULL, NULL, NULL,
+			      sample->period, sample->weight,
+			      sample->transaction);
 	pthread_mutex_unlock(&evsel->hists.lock);
 	if (he == NULL)
 		return NULL;
diff --git a/tools/perf/tests/hists_link.c b/tools/perf/tests/hists_link.c
index 7ccbc7b..bd851c6 100644
--- a/tools/perf/tests/hists_link.c
+++ b/tools/perf/tests/hists_link.c
@@ -223,8 +223,8 @@ static int add_hist_entries(struct perf_evlist *evlist, struct machine *machine)
 							  &sample) < 0)
 				goto out;
 
-			he = __hists__add_entry(&evsel->hists, &al, NULL,
-						NULL, NULL, 1, 1, 0);
+			he = hists__add_entry(&evsel->hists, &al, NULL,
+					      NULL, NULL, 1, 1, 0);
 			if (he == NULL)
 				goto out;
 
@@ -246,8 +246,8 @@ static int add_hist_entries(struct perf_evlist *evlist, struct machine *machine)
 							  &sample) < 0)
 				goto out;
 
-			he = __hists__add_entry(&evsel->hists, &al, NULL,
-						NULL, NULL, 1, 1, 0);
+			he = hists__add_entry(&evsel->hists, &al, NULL,
+					      NULL, NULL, 1, 1, 0);
 			if (he == NULL)
 				goto out;
 
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index f38590d..57545b3 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -399,12 +399,13 @@ out:
 	return he;
 }
 
-struct hist_entry *__hists__add_entry(struct hists *hists,
-				      struct addr_location *al,
-				      struct symbol *sym_parent,
-				      struct branch_info *bi,
-				      struct mem_info *mi,
-				      u64 period, u64 weight, u64 transaction)
+static struct hist_entry *__hists__add_entry(struct hists *hists,
+					     struct addr_location *al,
+					     struct symbol *sym_parent,
+					     struct branch_info *bi,
+					     struct mem_info *mi,
+					     u64 period, u64 weight,
+					     u64 transaction)
 {
 	struct hist_entry entry = {
 		.thread	= al->thread,
@@ -432,6 +433,18 @@ struct hist_entry *__hists__add_entry(struct hists *hists,
 	return add_hist_entry(hists, &entry, al);
 }
 
+struct hist_entry *hists__add_entry(struct hists *hists,
+				    struct addr_location *al,
+				    struct symbol *sym_parent,
+				    struct branch_info *bi,
+				    struct mem_info *mi,
+				    u64 period, u64 weight,
+				    u64 transaction)
+{
+	return __hists__add_entry(hists, al, sym_parent, bi, mi, period,
+				  weight, transaction);
+}
+
 int64_t
 hist_entry__cmp(struct hist_entry *left, struct hist_entry *right)
 {
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 1f1f513..1d24c27 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -93,12 +93,12 @@ struct hists {
 	u16			col_len[HISTC_NR_COLS];
 };
 
-struct hist_entry *__hists__add_entry(struct hists *hists,
-				      struct addr_location *al,
-				      struct symbol *parent,
-				      struct branch_info *bi,
-				      struct mem_info *mi, u64 period,
-				      u64 weight, u64 transaction);
+struct hist_entry *hists__add_entry(struct hists *hists,
+				    struct addr_location *al,
+				    struct symbol *parent,
+				    struct branch_info *bi,
+				    struct mem_info *mi, u64 period,
+				    u64 weight, u64 transaction);
 int64_t hist_entry__cmp(struct hist_entry *left, struct hist_entry *right);
 int64_t hist_entry__collapse(struct hist_entry *left, struct hist_entry *right);
 int hist_entry__transaction_len(void);
-- 
1.7.11.7

