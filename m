Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753839Ab3JaG5n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 02:57:43 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:52116 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138Ab3JaG4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 02:56:23 -0400
X-AuditID: 9c930197-b7b3eae00000122e-ce-5271ff131c17
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@redhat.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>, Arun Sharma <asharma@fb.com>
Subject: [PATCH 05/14] perf hists: Check if accumulated when adding a hist entry
Date: Thu, 31 Oct 2013 15:56:07 +0900
Message-Id: <1383202576-28141-6-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1383202576-28141-1-git-send-email-namhyung@kernel.org>
References: <1383202576-28141-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

To support callchain accumulation, @entry should be recognized if it's
accumulated or not when add_hist_entry() called.  The period of an
accumulated entry should be added to ->stat_acc but not ->stat. Add
@sample_self arg for that.

Cc: Arun Sharma <asharma@fb.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-annotate.c |  3 ++-
 tools/perf/builtin-diff.c     |  2 +-
 tools/perf/builtin-report.c   |  6 +++---
 tools/perf/builtin-top.c      |  2 +-
 tools/perf/tests/hists_link.c |  4 ++--
 tools/perf/util/hist.c        | 23 ++++++++++++++---------
 tools/perf/util/hist.h        |  3 ++-
 7 files changed, 25 insertions(+), 18 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 4087ab19823c..dcc7706e2136 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -65,7 +65,8 @@ static int perf_evsel__add_sample(struct perf_evsel *evsel,
 		return 0;
 	}
 
-	he = __hists__add_entry(&evsel->hists, al, NULL, NULL, NULL, 1, 1, 0);
+	he = __hists__add_entry(&evsel->hists, al, NULL, NULL, NULL, 1, 1, 0,
+				true);
 	if (he == NULL)
 		return -ENOMEM;
 
diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 3b67ea2444bd..dd2638001372 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -308,7 +308,7 @@ static int hists__add_entry(struct hists *hists,
 			    u64 weight, u64 transaction)
 {
 	if (__hists__add_entry(hists, al, NULL, NULL, NULL, period, weight,
-			       transaction) != NULL)
+			       transaction, true) != NULL)
 		return 0;
 	return -ENOMEM;
 }
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index f18cd43687d9..d171f4d18b67 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -152,7 +152,7 @@ iter_add_single_mem_entry(struct add_entry_iter *iter, struct addr_location *al)
 	 * and the he_stat__add_period() function.
 	 */
 	he = __hists__add_entry(&iter->evsel->hists, al, iter->parent, NULL, mi,
-				cost, cost, 0);
+				cost, cost, 0, true);
 	if (!he)
 		return -ENOMEM;
 
@@ -280,7 +280,7 @@ iter_add_next_branch_entry(struct add_entry_iter *iter, struct addr_location *al
 	 * and not events sampled. Thus we use a pseudo period of 1.
 	 */
 	he = __hists__add_entry(&evsel->hists, al, iter->parent, &bi[i], NULL,
-				1, 1, 0);
+				1, 1, 0, true);
 	if (he == NULL)
 		return -ENOMEM;
 
@@ -344,7 +344,7 @@ iter_add_single_normal_entry(struct add_entry_iter *iter, struct addr_location *
 
 	he = __hists__add_entry(&evsel->hists, al, iter->parent, NULL, NULL,
 				sample->period, sample->weight,
-				sample->transaction);
+				sample->transaction, true);
 	if (he == NULL)
 		return -ENOMEM;
 
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 5c538a43f263..bd4cb3800943 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -248,7 +248,7 @@ static struct hist_entry *perf_evsel__add_hist_entry(struct perf_evsel *evsel,
 	pthread_mutex_lock(&evsel->hists.lock);
 	he = __hists__add_entry(&evsel->hists, al, NULL, NULL, NULL,
 				sample->period, sample->weight,
-				sample->transaction);
+				sample->transaction, true);
 	pthread_mutex_unlock(&evsel->hists.lock);
 	if (he == NULL)
 		return NULL;
diff --git a/tools/perf/tests/hists_link.c b/tools/perf/tests/hists_link.c
index 76992aba00a7..4ea3000e7663 100644
--- a/tools/perf/tests/hists_link.c
+++ b/tools/perf/tests/hists_link.c
@@ -223,7 +223,7 @@ static int add_hist_entries(struct perf_evlist *evlist, struct machine *machine)
 				goto out;
 
 			he = __hists__add_entry(&evsel->hists, &al, NULL,
-						NULL, NULL, 1, 1, 0);
+						NULL, NULL, 1, 1, 0, true);
 			if (he == NULL)
 				goto out;
 
@@ -246,7 +246,7 @@ static int add_hist_entries(struct perf_evlist *evlist, struct machine *machine)
 				goto out;
 
 			he = __hists__add_entry(&evsel->hists, &al, NULL,
-						NULL, NULL, 1, 1, 0);
+						NULL, NULL, 1, 1, 0, true);
 			if (he == NULL)
 				goto out;
 
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index c38655dedad3..229329a20ba5 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -279,7 +279,8 @@ void hists__decay_entries(struct hists *hists, bool zap_user, bool zap_kernel)
  * histogram, sorted on item, collects periods
  */
 
-static struct hist_entry *hist_entry__new(struct hist_entry *template)
+static struct hist_entry *hist_entry__new(struct hist_entry *template,
+					  bool sample_self)
 {
 	size_t callchain_size = symbol_conf.use_callchain ? sizeof(struct callchain_root) : 0;
 	struct hist_entry *he = zalloc(sizeof(*he) + callchain_size);
@@ -294,6 +295,8 @@ static struct hist_entry *hist_entry__new(struct hist_entry *template)
 				return NULL;
 			}
 			memcpy(he->stat_acc, &he->stat, sizeof(he->stat));
+			if (!sample_self)
+				memset(&he->stat, 0, sizeof(he->stat));
 		}
 
 		if (he->ms.map)
@@ -356,8 +359,7 @@ static u8 symbol__parent_filter(const struct symbol *parent)
 static struct hist_entry *add_hist_entry(struct hists *hists,
 				      struct hist_entry *entry,
 				      struct addr_location *al,
-				      u64 period,
-				      u64 weight)
+				      u64 period, u64 weight, bool sample_self)
 {
 	struct rb_node **p;
 	struct rb_node *parent = NULL;
@@ -379,7 +381,8 @@ static struct hist_entry *add_hist_entry(struct hists *hists,
 		cmp = hist_entry__cmp(he, entry);
 
 		if (!cmp) {
-			he_stat__add_period(&he->stat, period, weight);
+			if (sample_self)
+				he_stat__add_period(&he->stat, period, weight);
 			if (callchain_param.mode == CHAIN_CUMULATIVE)
 				he_stat__add_period(he->stat_acc, period, weight);
 
@@ -409,7 +412,7 @@ static struct hist_entry *add_hist_entry(struct hists *hists,
 			p = &(*p)->rb_right;
 	}
 
-	he = hist_entry__new(entry);
+	he = hist_entry__new(entry, sample_self);
 	if (!he)
 		return NULL;
 
@@ -417,7 +420,8 @@ static struct hist_entry *add_hist_entry(struct hists *hists,
 	rb_link_node(&he->rb_node_in, parent, p);
 	rb_insert_color(&he->rb_node_in, hists->entries_in);
 out:
-	hist_entry__add_cpumode_period(&he->stat, al->cpumode, period);
+	if (sample_self)
+		hist_entry__add_cpumode_period(&he->stat, al->cpumode, period);
 	if (callchain_param.mode == CHAIN_CUMULATIVE)
 		hist_entry__add_cpumode_period(he->stat_acc, al->cpumode, period);
 	return he;
@@ -428,7 +432,8 @@ struct hist_entry *__hists__add_entry(struct hists *hists,
 				      struct symbol *sym_parent,
 				      struct branch_info *bi,
 				      struct mem_info *mi,
-				      u64 period, u64 weight, u64 transaction)
+				      u64 period, u64 weight, u64 transaction,
+				      bool sample_self)
 {
 	struct hist_entry entry = {
 		.thread	= al->thread,
@@ -452,7 +457,7 @@ struct hist_entry *__hists__add_entry(struct hists *hists,
 		.transaction = transaction,
 	};
 
-	return add_hist_entry(hists, &entry, al, period, weight);
+	return add_hist_entry(hists, &entry, al, period, weight, sample_self);
 }
 
 int64_t
@@ -876,7 +881,7 @@ static struct hist_entry *hists__add_dummy_entry(struct hists *hists,
 			p = &(*p)->rb_right;
 	}
 
-	he = hist_entry__new(pair);
+	he = hist_entry__new(pair, true);
 	if (he) {
 		memset(&he->stat, 0, sizeof(he->stat));
 		he->hists = hists;
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 307f1c742563..3a31f5e72cf7 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -89,7 +89,8 @@ struct hist_entry *__hists__add_entry(struct hists *self,
 				      struct symbol *parent,
 				      struct branch_info *bi,
 				      struct mem_info *mi, u64 period,
-				      u64 weight, u64 transaction);
+				      u64 weight, u64 transaction,
+				      bool sample_self);
 int64_t hist_entry__cmp(struct hist_entry *left, struct hist_entry *right);
 int64_t hist_entry__collapse(struct hist_entry *left, struct hist_entry *right);
 int hist_entry__transaction_len(void);
-- 
1.7.11.7

