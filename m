Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756921AbaCTFnV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 01:43:21 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:54032 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186AbaCTFgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 01:36:51 -0400
X-AuditID: 9c93017e-b7b10ae000000e66-f5-532a7e70605b
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, Arun Sharma <asharma@fb.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>
Subject: [PATCH 03/21] perf hists: Check if accumulated when adding a hist entry
Date: Thu, 20 Mar 2014 14:36:28 +0900
Message-Id: <1395293806-25847-4-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1395293806-25847-1-git-send-email-namhyung@kernel.org>
References: <1395293806-25847-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To support callchain accumulation, @entry should be recognized if it's
accumulated or not when add_hist_entry() called.  The period of an
accumulated entry should be added to ->stat_acc but not ->stat. Add
@sample_self arg for that.

Tested-by: Arun Sharma <asharma@fb.com>
Acked-by: Jiri Olsa <jolsa@redhat.com>
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
index 6ef80f22c1e2..29aaedac6064 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -316,7 +316,7 @@ static int hists__add_entry(struct hists *hists,
 			    u64 weight, u64 transaction)
 {
 	if (__hists__add_entry(hists, al, NULL, NULL, NULL, period, weight,
-			       transaction) != NULL)
+			       transaction, true) != NULL)
 		return 0;
 	return -ENOMEM;
 }
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index dcda6d5e320b..542900472c87 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -247,7 +247,7 @@ static struct hist_entry *perf_evsel__add_hist_entry(struct perf_evsel *evsel,
 	pthread_mutex_lock(&evsel->hists.lock);
 	he = __hists__add_entry(&evsel->hists, al, NULL, NULL, NULL,
 				sample->period, sample->weight,
-				sample->transaction);
+				sample->transaction, true);
 	pthread_mutex_unlock(&evsel->hists.lock);
 	if (he == NULL)
 		return NULL;
diff --git a/tools/perf/tests/hists_link.c b/tools/perf/tests/hists_link.c
index 7ccbc7b6ae77..d5ec010b8854 100644
--- a/tools/perf/tests/hists_link.c
+++ b/tools/perf/tests/hists_link.c
@@ -224,7 +224,7 @@ static int add_hist_entries(struct perf_evlist *evlist, struct machine *machine)
 				goto out;
 
 			he = __hists__add_entry(&evsel->hists, &al, NULL,
-						NULL, NULL, 1, 1, 0);
+						NULL, NULL, 1, 1, 0, true);
 			if (he == NULL)
 				goto out;
 
@@ -247,7 +247,7 @@ static int add_hist_entries(struct perf_evlist *evlist, struct machine *machine)
 				goto out;
 
 			he = __hists__add_entry(&evsel->hists, &al, NULL,
-						NULL, NULL, 1, 1, 0);
+						NULL, NULL, 1, 1, 0, true);
 			if (he == NULL)
 				goto out;
 
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 84ed573e3b6d..f7e28be9f6e1 100644
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
@@ -355,7 +358,8 @@ static u8 symbol__parent_filter(const struct symbol *parent)
 
 static struct hist_entry *add_hist_entry(struct hists *hists,
 					 struct hist_entry *entry,
-					 struct addr_location *al)
+					 struct addr_location *al,
+					 bool sample_self)
 {
 	struct rb_node **p;
 	struct rb_node *parent = NULL;
@@ -379,7 +383,8 @@ static struct hist_entry *add_hist_entry(struct hists *hists,
 		cmp = hist_entry__cmp(he, entry);
 
 		if (!cmp) {
-			he_stat__add_period(&he->stat, period, weight);
+			if (sample_self)
+				he_stat__add_period(&he->stat, period, weight);
 			if (symbol_conf.cumulate_callchain)
 				he_stat__add_period(he->stat_acc, period, weight);
 
@@ -409,7 +414,7 @@ static struct hist_entry *add_hist_entry(struct hists *hists,
 			p = &(*p)->rb_right;
 	}
 
-	he = hist_entry__new(entry);
+	he = hist_entry__new(entry, sample_self);
 	if (!he)
 		return NULL;
 
@@ -417,7 +422,8 @@ static struct hist_entry *add_hist_entry(struct hists *hists,
 	rb_link_node(&he->rb_node_in, parent, p);
 	rb_insert_color(&he->rb_node_in, hists->entries_in);
 out:
-	he_stat__add_cpumode_period(&he->stat, al->cpumode, period);
+	if (sample_self)
+		he_stat__add_cpumode_period(&he->stat, al->cpumode, period);
 	if (symbol_conf.cumulate_callchain)
 		he_stat__add_cpumode_period(he->stat_acc, al->cpumode, period);
 	return he;
@@ -428,7 +434,8 @@ struct hist_entry *__hists__add_entry(struct hists *hists,
 				      struct symbol *sym_parent,
 				      struct branch_info *bi,
 				      struct mem_info *mi,
-				      u64 period, u64 weight, u64 transaction)
+				      u64 period, u64 weight, u64 transaction,
+				      bool sample_self)
 {
 	struct hist_entry entry = {
 		.thread	= al->thread,
@@ -453,7 +460,7 @@ struct hist_entry *__hists__add_entry(struct hists *hists,
 		.transaction = transaction,
 	};
 
-	return add_hist_entry(hists, &entry, al);
+	return add_hist_entry(hists, &entry, al, sample_self);
 }
 
 static int
@@ -506,7 +513,7 @@ iter_add_single_mem_entry(struct hist_entry_iter *iter, struct addr_location *al
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
 
@@ -671,7 +678,7 @@ iter_add_single_normal_entry(struct hist_entry_iter *iter, struct addr_location
 
 	he = __hists__add_entry(&evsel->hists, al, iter->parent, NULL, NULL,
 				sample->period, sample->weight,
-				sample->transaction);
+				sample->transaction, true);
 	if (he == NULL)
 		return -ENOMEM;
 
@@ -1140,7 +1147,7 @@ static struct hist_entry *hists__add_dummy_entry(struct hists *hists,
 			p = &(*p)->rb_right;
 	}
 
-	he = hist_entry__new(pair);
+	he = hist_entry__new(pair, true);
 	if (he) {
 		memset(&he->stat, 0, sizeof(he->stat));
 		he->hists = hists;
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 9693d491749a..742c18b73096 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -130,7 +130,8 @@ struct hist_entry *__hists__add_entry(struct hists *hists,
 				      struct symbol *parent,
 				      struct branch_info *bi,
 				      struct mem_info *mi, u64 period,
-				      u64 weight, u64 transaction);
+				      u64 weight, u64 transaction,
+				      bool sample_self);
 int hist_entry_iter__add(struct hist_entry_iter *iter, struct addr_location *al,
 			 struct perf_evsel *evsel, struct perf_sample *sample,
 			 int max_stack_depth);
-- 
1.7.11.7

