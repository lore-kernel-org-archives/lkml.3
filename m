Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756194AbaAHIsx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 03:48:53 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:42210 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755934AbaAHIqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 03:46:54 -0500
X-AuditID: 9c93017d-b7b66ae000006a2a-33-52cd10719b64
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Arun Sharma <asharma@fb.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>
Subject: [PATCH 24/28] perf tools: Add callback function to hist_entry_iter
Date: Wed,  8 Jan 2014 17:46:29 +0900
Message-Id: <1389170793-21926-25-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1389170793-21926-1-git-send-email-namhyung@kernel.org>
References: <1389170793-21926-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new ->add_entry_cb() will be called after an entry was added to
the histogram.  It's used for code sharing between perf report and
perf top.

Also pass @arg to the callback function.  It'll be used by perf top
later.

Cc: Arun Sharma <asharma@fb.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-report.c | 30 +++++++++++++++++++++++++++---
 tools/perf/util/hist.c      | 38 +++++++++++++++++++-------------------
 tools/perf/util/hist.h      |  6 +++++-
 3 files changed, 51 insertions(+), 23 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 2d603304e779..896d80c86347 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -79,6 +79,27 @@ static int report__config(const char *var, const char *value, void *cb)
 	return perf_default_config(var, value, cb);
 }
 
+static int hist_iter_cb(struct hist_entry_iter *iter,
+			struct addr_location *al, bool single,
+			void *arg __maybe_unused)
+{
+	int err;
+	struct hist_entry *he = iter->he;
+	struct perf_evsel *evsel = iter->evsel;
+	struct perf_sample *sample = iter->sample;
+
+	err = hist_entry__inc_addr_samples(he, evsel->idx, al->addr);
+
+	if (!single)
+		goto out;
+
+	evsel->hists.stats.total_period += sample->period;
+	hists__inc_nr_events(&evsel->hists, PERF_RECORD_SAMPLE);
+
+out:
+	return err;
+}
+
 static int process_sample_event(struct perf_tool *tool,
 				union perf_event *event,
 				struct perf_sample *sample,
@@ -106,16 +127,19 @@ static int process_sample_event(struct perf_tool *tool,
 		iter = &hist_iter_branch;
 	else if (rep->mem_mode == 1)
 		iter = &hist_iter_mem;
-	else if (symbol_conf.cumulate_callchain)
+	else if (symbol_conf.cumulate_callchain) {
 		iter = &hist_iter_cumulative;
-	else
+		iter->add_entry_cb = hist_iter_cb;
+	} else {
 		iter = &hist_iter_normal;
+		iter->add_entry_cb = hist_iter_cb;
+	}
 
 	if (al.map != NULL)
 		al.map->dso->hit = 1;
 
 	ret = hist_entry_iter__add(iter, &al, evsel, event, sample,
-				   rep->hide_unresolved, rep->max_stack);
+				   rep->hide_unresolved, rep->max_stack, NULL);
 	if (ret < 0)
 		pr_debug("problem adding hist entry, skipping event\n");
 
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index c1f5b664545a..3408b5095f0c 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -682,11 +682,10 @@ iter_add_single_normal_entry(struct hist_entry_iter *iter, struct addr_location
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
@@ -694,13 +693,6 @@ iter_finish_normal_entry(struct hist_entry_iter *iter, struct addr_location *al)
 
 	iter->he = NULL;
 
-	err = hist_entry__inc_addr_samples(he, evsel->idx, al->addr);
-	if (err)
-		return err;
-
-	evsel->hists.stats.total_period += sample->period;
-	hists__inc_nr_events(&evsel->hists, PERF_RECORD_SAMPLE);
-
 	return hist_entry__append_callchain(he, sample);
 }
 
@@ -742,6 +734,7 @@ iter_add_single_cumulative_entry(struct hist_entry_iter *iter,
 	if (he == NULL)
 		return -ENOMEM;
 
+	iter->he = he;
 	he_cache[iter->curr++] = he;
 
 	callchain_append(he->callchain, &callchain_cursor, sample->period);
@@ -752,7 +745,7 @@ iter_add_single_cumulative_entry(struct hist_entry_iter *iter,
 	 */
 	callchain_cursor_commit(&callchain_cursor);
 
-	return hist_entry__inc_addr_samples(he, evsel->idx, al->addr);
+	return 0;
 }
 
 static int
@@ -809,23 +802,18 @@ iter_add_next_cumulative_entry(struct hist_entry_iter *iter,
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
 	return 0;
 }
@@ -865,7 +853,7 @@ struct hist_entry_iter hist_iter_cumulative = {
 int hist_entry_iter__add(struct hist_entry_iter *iter, struct addr_location *al,
 			 struct perf_evsel *evsel, const union perf_event *event,
 			 struct perf_sample *sample, bool hide_unresolved,
-			 int max_stack_depth)
+			 int max_stack_depth, void *arg)
 {
 	int err, err2;
 
@@ -887,10 +875,22 @@ int hist_entry_iter__add(struct hist_entry_iter *iter, struct addr_location *al,
 	if (err)
 		goto out;
 
+	if (iter->add_entry_cb) {
+		err = iter->add_entry_cb(iter, al, true, arg);
+		if (err)
+			goto out;
+	}
+
 	while (iter->next_entry(iter, al)) {
 		err = iter->add_next_entry(iter, al);
 		if (err)
 			break;
+
+		if (iter->add_entry_cb) {
+			err = iter->add_entry_cb(iter, al, false, arg);
+			if (err)
+				goto out;
+		}
 	}
 
 out:
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 95fff1cd6727..90a94d6f0cae 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -109,6 +109,10 @@ struct hist_entry_iter {
 	int (*next_entry)(struct hist_entry_iter *, struct addr_location *);
 	int (*add_next_entry)(struct hist_entry_iter *, struct addr_location *);
 	int (*finish_entry)(struct hist_entry_iter *, struct addr_location *);
+
+	/* user-defined callback function (optional) */
+	int (*add_entry_cb)(struct hist_entry_iter *iter,
+			    struct addr_location *al, bool single, void *arg);
 };
 
 extern struct hist_entry_iter hist_iter_normal;
@@ -126,7 +130,7 @@ struct hist_entry *__hists__add_entry(struct hists *hists,
 int hist_entry_iter__add(struct hist_entry_iter *iter, struct addr_location *al,
 			 struct perf_evsel *evsel, const union perf_event *event,
 			 struct perf_sample *sample, bool hide_unresolved,
-			 int max_stack_depth);
+			 int max_stack_depth, void *arg);
 
 int64_t hist_entry__cmp(struct hist_entry *left, struct hist_entry *right);
 int64_t hist_entry__collapse(struct hist_entry *left, struct hist_entry *right);
-- 
1.7.11.7

