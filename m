Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754555AbaCTFhs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 01:37:48 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:54032 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752226AbaCTFgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 01:36:54 -0400
X-AuditID: 9c93017e-b7b10ae000000e66-1b-532a7e7364e2
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
Subject: [PATCH 17/21] perf tools: Add callback function to hist_entry_iter
Date: Thu, 20 Mar 2014 14:36:42 +0900
Message-Id: <1395293806-25847-18-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1395293806-25847-1-git-send-email-namhyung@kernel.org>
References: <1395293806-25847-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new ->add_entry_cb() will be called after an entry was added to
the histogram.  It's used for code sharing between perf report and
perf top.  Note that ops->add_*_entry() should set iter->he properly
in order to call the ->add_entry_cb.

Also pass @arg to the callback function.  It'll be used by perf top
later.

Tested-by: Arun Sharma <asharma@fb.com>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-report.c | 34 +++++++++++++++++++++++++++++---
 tools/perf/util/hist.c      | 48 ++++++++++++++++++++++-----------------------
 tools/perf/util/hist.h      |  5 ++++-
 3 files changed, 59 insertions(+), 28 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index f175797036ed..b5ce7172e168 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -79,6 +79,30 @@ static int report__config(const char *var, const char *value, void *cb)
 	return perf_default_config(var, value, cb);
 }
 
+static int hist_iter_cb(struct hist_entry_iter *iter,
+			struct addr_location *al, bool single,
+			void *arg __maybe_unused)
+{
+	int err = 0;
+	struct hist_entry *he = iter->he;
+	struct perf_evsel *evsel = iter->evsel;
+	struct perf_sample *sample = iter->sample;
+
+	if (ui__has_annotation())
+		err = hist_entry__inc_addr_samples(he, evsel->idx, al->addr);
+
+	if (!single)
+		goto out;
+
+	evsel->hists.stats.total_period += sample->period;
+	hists__inc_nr_events(&evsel->hists, PERF_RECORD_SAMPLE);
+	if (!he->filtered)
+		evsel->hists.stats.nr_non_filtered_samples++;
+
+out:
+	return err;
+}
+
 static int process_sample_event(struct perf_tool *tool,
 				union perf_event *event,
 				struct perf_sample *sample,
@@ -108,15 +132,19 @@ static int process_sample_event(struct perf_tool *tool,
 		iter.ops = &hist_iter_branch;
 	else if (rep->mem_mode)
 		iter.ops = &hist_iter_mem;
-	else if (symbol_conf.cumulate_callchain)
+	else if (symbol_conf.cumulate_callchain) {
 		iter.ops = &hist_iter_cumulative;
-	else
+		iter.add_entry_cb = hist_iter_cb;
+	} else {
 		iter.ops = &hist_iter_normal;
+		iter.add_entry_cb = hist_iter_cb;
+	}
 
 	if (al.map != NULL)
 		al.map->dso->hit = 1;
 
-	ret = hist_entry_iter__add(&iter, &al, evsel, sample, rep->max_stack);
+	ret = hist_entry_iter__add(&iter, &al, evsel, sample, rep->max_stack,
+				   NULL);
 	if (ret < 0)
 		pr_debug("problem adding hist entry, skipping event\n");
 
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 898cf0155c60..1d4c39048dfe 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -687,11 +687,10 @@ iter_add_single_normal_entry(struct hist_entry_iter *iter, struct addr_location
 }
 
 static int
-iter_finish_normal_entry(struct hist_entry_iter *iter, struct addr_location *al)
+iter_finish_normal_entry(struct hist_entry_iter *iter,
+			 struct addr_location *al __maybe_unused)
 {
-	int err;
 	struct hist_entry *he = iter->he;
-	struct perf_evsel *evsel = iter->evsel;
 	struct perf_sample *sample = iter->sample;
 
 	if (he == NULL)
@@ -699,17 +698,6 @@ iter_finish_normal_entry(struct hist_entry_iter *iter, struct addr_location *al)
 
 	iter->he = NULL;
 
-	if (ui__has_annotation()) {
-		err = hist_entry__inc_addr_samples(he, evsel->idx, al->addr);
-		if (err)
-			return err;
-	}
-
-	evsel->hists.stats.total_period += sample->period;
-	hists__inc_nr_events(&evsel->hists, PERF_RECORD_SAMPLE);
-	if (!he->filtered)
-		evsel->hists.stats.nr_non_filtered_samples++;
-
 	return hist_entry__append_callchain(he, sample);
 }
 static int
@@ -750,6 +738,7 @@ iter_add_single_cumulative_entry(struct hist_entry_iter *iter,
 	if (he == NULL)
 		return -ENOMEM;
 
+	iter->he = he;
 	he_cache[iter->curr++] = he;
 
 	callchain_append(he->callchain, &callchain_cursor, sample->period);
@@ -760,7 +749,7 @@ iter_add_single_cumulative_entry(struct hist_entry_iter *iter,
 	 */
 	callchain_cursor_commit(&callchain_cursor);
 
-	return hist_entry__inc_addr_samples(he, evsel->idx, al->addr);
+	return 0;
 }
 
 static int
@@ -807,8 +796,11 @@ iter_add_next_cumulative_entry(struct hist_entry_iter *iter,
 	 * It's possible that it has cycles or recursive calls.
 	 */
 	for (i = 0; i < iter->curr; i++) {
-		if (hist_entry__cmp(he_cache[i], &he_tmp) == 0)
+		if (hist_entry__cmp(he_cache[i], &he_tmp) == 0) {
+			/* to avoid calling callback function */
+			iter->he = NULL;
 			return 0;
+		}
 	}
 
 	he = __hists__add_entry(&evsel->hists, al, iter->parent, NULL, NULL,
@@ -817,24 +809,20 @@ iter_add_next_cumulative_entry(struct hist_entry_iter *iter,
 	if (he == NULL)
 		return -ENOMEM;
 
+	iter->he = he;
 	he_cache[iter->curr++] = he;
 
 	callchain_append(he->callchain, &cursor, sample->period);
 
-	return hist_entry__inc_addr_samples(he, evsel->idx, al->addr);
+	return 0;
 }
 
 static int
 iter_finish_cumulative_entry(struct hist_entry_iter *iter,
 			     struct addr_location *al __maybe_unused)
 {
-	struct perf_evsel *evsel = iter->evsel;
-	struct perf_sample *sample = iter->sample;
-
-	evsel->hists.stats.total_period += sample->period;
-	hists__inc_nr_events(&evsel->hists, PERF_RECORD_SAMPLE);
-
 	zfree(&iter->priv);
+	iter->he = NULL;
 	return 0;
 }
 
@@ -872,7 +860,7 @@ const struct hist_iter_ops hist_iter_cumulative = {
 
 int hist_entry_iter__add(struct hist_entry_iter *iter, struct addr_location *al,
 			 struct perf_evsel *evsel, struct perf_sample *sample,
-			 int max_stack_depth)
+			 int max_stack_depth, void *arg)
 {
 	int err, err2;
 
@@ -892,10 +880,22 @@ int hist_entry_iter__add(struct hist_entry_iter *iter, struct addr_location *al,
 	if (err)
 		goto out;
 
+	if (iter->he && iter->add_entry_cb) {
+		err = iter->add_entry_cb(iter, al, true, arg);
+		if (err)
+			goto out;
+	}
+
 	while (iter->ops->next_entry(iter, al)) {
 		err = iter->ops->add_next_entry(iter, al);
 		if (err)
 			break;
+
+		if (iter->he && iter->add_entry_cb) {
+			err = iter->add_entry_cb(iter, al, false, arg);
+			if (err)
+				goto out;
+		}
 	}
 
 out:
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 69cf92f7faf5..6838854ca658 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -119,6 +119,9 @@ struct hist_entry_iter {
 	void *priv;
 
 	const struct hist_iter_ops *ops;
+	/* user-defined callback function (optional) */
+	int (*add_entry_cb)(struct hist_entry_iter *iter,
+			    struct addr_location *al, bool single, void *arg);
 };
 
 extern const struct hist_iter_ops hist_iter_normal;
@@ -135,7 +138,7 @@ struct hist_entry *__hists__add_entry(struct hists *hists,
 				      bool sample_self);
 int hist_entry_iter__add(struct hist_entry_iter *iter, struct addr_location *al,
 			 struct perf_evsel *evsel, struct perf_sample *sample,
-			 int max_stack_depth);
+			 int max_stack_depth, void *arg);
 
 int64_t hist_entry__cmp(struct hist_entry *left, struct hist_entry *right);
 int64_t hist_entry__collapse(struct hist_entry *left, struct hist_entry *right);
-- 
1.7.11.7

