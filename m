Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958AbaAWAON (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 19:14:13 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:58514 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753642AbaAWAOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 19:14:11 -0500
X-AuditID: 9c93017d-b7b51ae000000e33-52-52e05ed096a8
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Arun Sharma <asharma@fb.com>,
        Jiri Olsa <jolsa@redhat.com>, Rodrigo Campos <rodrigo@sdfg.com.ar>,
        Andi Kleen <andi@firstfloor.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 03/21] perf hists: Check if accumulated when adding a hist entry
Date: Thu, 23 Jan 2014 09:13:47 +0900
Message-Id: <1390436045-16830-4-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1390436045-16830-1-git-send-email-namhyung@kernel.org>
References: <1390436045-16830-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To support callchain accumulation, @entry should be recognized if it's
accumulated or not when add_hist_entry() called.  The period of an
accumulated entry should be added to ->stat_acc but not ->stat. Add
@sample_self arg for that.

Tested-by: Arun Sharma <asharma@fb.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-annotate.c |  3 ++-
 tools/perf/builtin-diff.c     |  2 +-
 tools/perf/builtin-top.c      |  2 +-
 tools/perf/tests/hists_link.c |  4 ++--
 tools/perf/util/hist.c        | 29 ++++++++++++++++++-----------
 tools/perf/util/hist.h        |  3 ++-
 6 files changed, 26 insertions(+), 17 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 0da603b79b61..70b2d52c3b2e 100644
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
index a77e31246c00..93912add75b5 100644
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
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 76cd510d34d0..c574c291383c 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -245,7 +245,7 @@ static struct hist_entry *perf_evsel__add_hist_entry(struct perf_evsel *evsel,
 	pthread_mutex_lock(&evsel->hists.lock);
 	he = __hists__add_entry(&evsel->hists, al, NULL, NULL, NULL,
 				sample->period, sample->weight,
-				sample->transaction);
+				sample->transaction, true);
 	pthread_mutex_unlock(&evsel->hists.lock);
 	if (he == NULL)
 		return NULL;
diff --git a/tools/perf/tests/hists_link.c b/tools/perf/tests/hists_link.c
index 2b6519e0e36f..e4e931ec1dbb 100644
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
index 45a962f40cea..2e9dd5d4ca1d 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -272,7 +272,8 @@ void hists__decay_entries(struct hists *hists, bool zap_user, bool zap_kernel)
  * histogram, sorted on item, collects periods
  */
 
-static struct hist_entry *hist_entry__new(struct hist_entry *template)
+static struct hist_entry *hist_entry__new(struct hist_entry *template,
+					  bool sample_self)
 {
 	size_t callchain_size = 0;
 	struct hist_entry *he;
@@ -292,6 +293,8 @@ static struct hist_entry *hist_entry__new(struct hist_entry *template)
 				return NULL;
 			}
 			memcpy(he->stat_acc, &he->stat, sizeof(he->stat));
+			if (!sample_self)
+				memset(&he->stat, 0, sizeof(he->stat));
 		}
 
 		if (he->ms.map)
@@ -354,7 +357,8 @@ static u8 symbol__parent_filter(const struct symbol *parent)
 
 static struct hist_entry *add_hist_entry(struct hists *hists,
 					 struct hist_entry *entry,
-					 struct addr_location *al)
+					 struct addr_location *al,
+					 bool sample_self)
 {
 	struct rb_node **p;
 	struct rb_node *parent = NULL;
@@ -378,7 +382,8 @@ static struct hist_entry *add_hist_entry(struct hists *hists,
 		cmp = hist_entry__cmp(he, entry);
 
 		if (!cmp) {
-			he_stat__add_period(&he->stat, period, weight);
+			if (sample_self)
+				he_stat__add_period(&he->stat, period, weight);
 			if (symbol_conf.cumulate_callchain)
 				he_stat__add_period(he->stat_acc, period, weight);
 
@@ -408,7 +413,7 @@ static struct hist_entry *add_hist_entry(struct hists *hists,
 			p = &(*p)->rb_right;
 	}
 
-	he = hist_entry__new(entry);
+	he = hist_entry__new(entry, sample_self);
 	if (!he)
 		return NULL;
 
@@ -416,7 +421,8 @@ static struct hist_entry *add_hist_entry(struct hists *hists,
 	rb_link_node(&he->rb_node_in, parent, p);
 	rb_insert_color(&he->rb_node_in, hists->entries_in);
 out:
-	he_stat__add_cpumode_period(&he->stat, al->cpumode, period);
+	if (sample_self)
+		he_stat__add_cpumode_period(&he->stat, al->cpumode, period);
 	if (symbol_conf.cumulate_callchain)
 		he_stat__add_cpumode_period(he->stat_acc, al->cpumode, period);
 	return he;
@@ -427,7 +433,8 @@ struct hist_entry *__hists__add_entry(struct hists *hists,
 				      struct symbol *sym_parent,
 				      struct branch_info *bi,
 				      struct mem_info *mi,
-				      u64 period, u64 weight, u64 transaction)
+				      u64 period, u64 weight, u64 transaction,
+				      bool sample_self)
 {
 	struct hist_entry entry = {
 		.thread	= al->thread,
@@ -452,7 +459,7 @@ struct hist_entry *__hists__add_entry(struct hists *hists,
 		.transaction = transaction,
 	};
 
-	return add_hist_entry(hists, &entry, al);
+	return add_hist_entry(hists, &entry, al, sample_self);
 }
 
 static int
@@ -509,7 +516,7 @@ iter_add_single_mem_entry(struct hist_entry_iter *iter, struct addr_location *al
 	 * and the he_stat__add_period() function.
 	 */
 	he = __hists__add_entry(&iter->evsel->hists, al, iter->parent, NULL, mi,
-				cost, cost, 0);
+				cost, cost, 0, true);
 	if (!he)
 		return -ENOMEM;
 
@@ -621,7 +628,7 @@ iter_add_next_branch_entry(struct hist_entry_iter *iter, struct addr_location *a
 	 * and not events sampled. Thus we use a pseudo period of 1.
 	 */
 	he = __hists__add_entry(&evsel->hists, al, iter->parent, &bi[i], NULL,
-				1, 1, 0);
+				1, 1, 0, true);
 	if (he == NULL)
 		return -ENOMEM;
 
@@ -667,7 +674,7 @@ iter_add_single_normal_entry(struct hist_entry_iter *iter, struct addr_location
 
 	he = __hists__add_entry(&evsel->hists, al, iter->parent, NULL, NULL,
 				sample->period, sample->weight,
-				sample->transaction);
+				sample->transaction, true);
 	if (he == NULL)
 		return -ENOMEM;
 
@@ -1177,7 +1184,7 @@ static struct hist_entry *hists__add_dummy_entry(struct hists *hists,
 			p = &(*p)->rb_right;
 	}
 
-	he = hist_entry__new(pair);
+	he = hist_entry__new(pair, true);
 	if (he) {
 		memset(&he->stat, 0, sizeof(he->stat));
 		he->hists = hists;
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 8182cb51d218..d482e673ecf5 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -126,7 +126,8 @@ struct hist_entry *__hists__add_entry(struct hists *hists,
 				      struct symbol *parent,
 				      struct branch_info *bi,
 				      struct mem_info *mi, u64 period,
-				      u64 weight, u64 transaction);
+				      u64 weight, u64 transaction,
+				      bool sample_self);
 int hist_entry_iter__add(struct hist_entry_iter *iter, struct addr_location *al,
 			 struct perf_evsel *evsel, const union perf_event *event,
 			 struct perf_sample *sample, int max_stack_depth);
-- 
1.7.11.7

