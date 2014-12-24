Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752233AbaLXHPo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 02:15:44 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:40191 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107AbaLXHPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 02:15:40 -0500
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 25/37] perf hists: Pass hists struct to hist_entry_iter functions
Date: Wed, 24 Dec 2014 16:15:21 +0900
Message-Id: <1419405333-27952-26-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1419405333-27952-1-git-send-email-namhyung@kernel.org>
References: <1419405333-27952-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a preparation for perf report multi-thread support.  When
multi-thread is enable, each thread will have its own hists during the
sample processing.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-report.c       |  4 ++--
 tools/perf/builtin-top.c          |  4 ++--
 tools/perf/tests/hists_cumulate.c |  4 ++--
 tools/perf/tests/hists_filter.c   |  3 ++-
 tools/perf/tests/hists_output.c   |  4 ++--
 tools/perf/util/hist.c            | 26 +++++++++++---------------
 tools/perf/util/hist.h            |  6 ++++--
 7 files changed, 25 insertions(+), 26 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 4cac79ad3085..aabcfc24afd1 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -166,8 +166,8 @@ static int process_sample_event(struct perf_tool *tool,
 	if (al.map != NULL)
 		al.map->dso->hit = 1;
 
-	ret = hist_entry_iter__add(&iter, &al, evsel, sample, rep->max_stack,
-				   rep);
+	ret = hist_entry_iter__add(&iter, evsel__hists(evsel), evsel, &al,
+				   sample, rep->max_stack, rep);
 	if (ret < 0)
 		pr_debug("problem adding hist entry, skipping event\n");
 
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 961cea183a83..818ae35cbd7b 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -784,8 +784,8 @@ static void perf_event__process_sample(struct perf_tool *tool,
 
 		pthread_mutex_lock(&hists->lock);
 
-		err = hist_entry_iter__add(&iter, &al, evsel, sample,
-					   top->max_stack, top);
+		err = hist_entry_iter__add(&iter, evsel__hists(evsel), evsel,
+					   &al, sample, top->max_stack, top);
 		if (err < 0)
 			pr_err("Problem incrementing symbol period, skipping event\n");
 
diff --git a/tools/perf/tests/hists_cumulate.c b/tools/perf/tests/hists_cumulate.c
index 4b8226e19a91..b1a2bed721a8 100644
--- a/tools/perf/tests/hists_cumulate.c
+++ b/tools/perf/tests/hists_cumulate.c
@@ -104,8 +104,8 @@ static int add_hist_entries(struct hists *hists, struct machine *machine)
 						  &sample) < 0)
 			goto out;
 
-		if (hist_entry_iter__add(&iter, &al, evsel, &sample,
-					 PERF_MAX_STACK_DEPTH, NULL) < 0)
+		if (hist_entry_iter__add(&iter, evsel__hists(evsel), evsel, &al,
+					 &sample, PERF_MAX_STACK_DEPTH, NULL) < 0)
 			goto out;
 
 		fake_samples[i].thread = al.thread;
diff --git a/tools/perf/tests/hists_filter.c b/tools/perf/tests/hists_filter.c
index 59e53db7914c..3c54264ec58d 100644
--- a/tools/perf/tests/hists_filter.c
+++ b/tools/perf/tests/hists_filter.c
@@ -81,7 +81,8 @@ static int add_hist_entries(struct perf_evlist *evlist,
 							  &sample) < 0)
 				goto out;
 
-			if (hist_entry_iter__add(&iter, &al, evsel, &sample,
+			if (hist_entry_iter__add(&iter, evsel__hists(evsel),
+						 evsel, &al, &sample,
 						 PERF_MAX_STACK_DEPTH, NULL) < 0)
 				goto out;
 
diff --git a/tools/perf/tests/hists_output.c b/tools/perf/tests/hists_output.c
index f5547610da02..c705bc7a5e78 100644
--- a/tools/perf/tests/hists_output.c
+++ b/tools/perf/tests/hists_output.c
@@ -70,8 +70,8 @@ static int add_hist_entries(struct hists *hists, struct machine *machine)
 						  &sample) < 0)
 			goto out;
 
-		if (hist_entry_iter__add(&iter, &al, evsel, &sample,
-					 PERF_MAX_STACK_DEPTH, NULL) < 0)
+		if (hist_entry_iter__add(&iter, evsel__hists(evsel), evsel, &al,
+					 &sample, PERF_MAX_STACK_DEPTH, NULL) < 0)
 			goto out;
 
 		fake_samples[i].thread = al.thread;
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index d322264bac22..d7cee7165bcd 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -514,7 +514,7 @@ iter_add_single_mem_entry(struct hist_entry_iter *iter, struct addr_location *al
 	u64 cost;
 	struct mem_info *mi = iter->priv;
 	struct perf_sample *sample = iter->sample;
-	struct hists *hists = evsel__hists(iter->evsel);
+	struct hists *hists = iter->hists;
 	struct hist_entry *he;
 
 	if (mi == NULL)
@@ -544,8 +544,7 @@ static int
 iter_finish_mem_entry(struct hist_entry_iter *iter,
 		      struct addr_location *al __maybe_unused)
 {
-	struct perf_evsel *evsel = iter->evsel;
-	struct hists *hists = evsel__hists(evsel);
+	struct hists *hists = iter->hists;
 	struct hist_entry *he = iter->he;
 	int err = -EINVAL;
 
@@ -617,8 +616,7 @@ static int
 iter_add_next_branch_entry(struct hist_entry_iter *iter, struct addr_location *al)
 {
 	struct branch_info *bi;
-	struct perf_evsel *evsel = iter->evsel;
-	struct hists *hists = evsel__hists(evsel);
+	struct hists *hists = iter->hists;
 	struct hist_entry *he = NULL;
 	int i = iter->curr;
 	int err = 0;
@@ -665,11 +663,10 @@ iter_prepare_normal_entry(struct hist_entry_iter *iter __maybe_unused,
 static int
 iter_add_single_normal_entry(struct hist_entry_iter *iter, struct addr_location *al)
 {
-	struct perf_evsel *evsel = iter->evsel;
 	struct perf_sample *sample = iter->sample;
 	struct hist_entry *he;
 
-	he = __hists__add_entry(evsel__hists(evsel), al, iter->parent, NULL, NULL,
+	he = __hists__add_entry(iter->hists, al, iter->parent, NULL, NULL,
 				sample->period, sample->weight,
 				sample->transaction, sample->time, true);
 	if (he == NULL)
@@ -684,7 +681,6 @@ iter_finish_normal_entry(struct hist_entry_iter *iter,
 			 struct addr_location *al __maybe_unused)
 {
 	struct hist_entry *he = iter->he;
-	struct perf_evsel *evsel = iter->evsel;
 	struct perf_sample *sample = iter->sample;
 
 	if (he == NULL)
@@ -692,7 +688,7 @@ iter_finish_normal_entry(struct hist_entry_iter *iter,
 
 	iter->he = NULL;
 
-	hists__inc_nr_samples(evsel__hists(evsel), he->filtered);
+	hists__inc_nr_samples(iter->hists, he->filtered);
 
 	return hist_entry__append_callchain(he, sample);
 }
@@ -724,8 +720,7 @@ static int
 iter_add_single_cumulative_entry(struct hist_entry_iter *iter,
 				 struct addr_location *al)
 {
-	struct perf_evsel *evsel = iter->evsel;
-	struct hists *hists = evsel__hists(evsel);
+	struct hists *hists = iter->hists;
 	struct perf_sample *sample = iter->sample;
 	struct hist_entry **he_cache = iter->priv;
 	struct hist_entry *he;
@@ -770,7 +765,6 @@ static int
 iter_add_next_cumulative_entry(struct hist_entry_iter *iter,
 			       struct addr_location *al)
 {
-	struct perf_evsel *evsel = iter->evsel;
 	struct perf_sample *sample = iter->sample;
 	struct hist_entry **he_cache = iter->priv;
 	struct hist_entry *he;
@@ -804,7 +798,7 @@ iter_add_next_cumulative_entry(struct hist_entry_iter *iter,
 		}
 	}
 
-	he = __hists__add_entry(evsel__hists(evsel), al, iter->parent, NULL, NULL,
+	he = __hists__add_entry(iter->hists, al, iter->parent, NULL, NULL,
 				sample->period, sample->weight,
 				sample->transaction, sample->time, false);
 	if (he == NULL)
@@ -860,8 +854,9 @@ const struct hist_iter_ops hist_iter_cumulative = {
 	.finish_entry 		= iter_finish_cumulative_entry,
 };
 
-int hist_entry_iter__add(struct hist_entry_iter *iter, struct addr_location *al,
-			 struct perf_evsel *evsel, struct perf_sample *sample,
+int hist_entry_iter__add(struct hist_entry_iter *iter, struct hists *hists,
+			 struct perf_evsel *evsel, struct addr_location *al,
+			 struct perf_sample *sample,
 			 int max_stack_depth, void *arg)
 {
 	int err, err2;
@@ -871,6 +866,7 @@ int hist_entry_iter__add(struct hist_entry_iter *iter, struct addr_location *al,
 	if (err)
 		return err;
 
+	iter->hists = hists;
 	iter->evsel = evsel;
 	iter->sample = sample;
 
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index b86966206ba8..2ee0e40cf44c 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -86,6 +86,7 @@ struct hist_entry_iter {
 
 	bool hide_unresolved;
 
+	struct hists *hists;
 	struct perf_evsel *evsel;
 	struct perf_sample *sample;
 	struct hist_entry *he;
@@ -110,8 +111,9 @@ struct hist_entry *__hists__add_entry(struct hists *hists,
 				      struct mem_info *mi, u64 period,
 				      u64 weight, u64 transaction,
 				      u64 timestamp, bool sample_self);
-int hist_entry_iter__add(struct hist_entry_iter *iter, struct addr_location *al,
-			 struct perf_evsel *evsel, struct perf_sample *sample,
+int hist_entry_iter__add(struct hist_entry_iter *iter, struct hists *hists,
+			 struct perf_evsel *evsel, struct addr_location *al,
+			 struct perf_sample *sample,
 			 int max_stack_depth, void *arg);
 
 int64_t hist_entry__cmp(struct hist_entry *left, struct hist_entry *right);
-- 
2.1.3

