Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743AbaEWKGh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 06:06:37 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:49204 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067AbaEWKEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 06:04:36 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, Arun Sharma <asharma@fb.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>
Subject: [PATCH 17/26] perf tools: Add callback function to hist_entry_iter
Date: Fri, 23 May 2014 19:04:14 +0900
Message-Id: <1400839463-21933-18-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1400839463-21933-1-git-send-email-namhyung@kernel.org>
References: <1400839463-21933-1-git-send-email-namhyung@kernel.org>
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
Tested-by: Rodrigo Campos <rodrigo@sdfg.com.ar>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-report.c     | 54 ++++++++++++++++++++++++++++++++++++++---
 tools/perf/tests/hists_filter.c | 22 ++++++++++++++++-
 tools/perf/tests/hists_output.c |  2 +-
 tools/perf/util/hist.c          | 50 +++++++++++++++++---------------------
 tools/perf/util/hist.h          |  5 +++-
 5 files changed, 98 insertions(+), 35 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index df7d431c0cbf..c9d780d48aba 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -80,6 +80,47 @@ static int report__config(const char *var, const char *value, void *cb)
 	return perf_default_config(var, value, cb);
 }
 
+static void report__inc_stats(struct report *rep, struct hist_entry *he)
+{
+	/*
+	 * The @he is either of a newly created one or an existing one
+	 * merging current sample.  We only want to count a new one so
+	 * checking ->nr_events being 1.
+	 */
+	if (he->stat.nr_events == 1)
+		rep->nr_entries++;
+
+	/*
+	 * Only counts number of samples at this stage as it's more
+	 * natural to do it here and non-sample events are also
+	 * counted in perf_session_deliver_event().  The dump_trace
+	 * requires this info is ready before going to the output tree.
+	 */
+	hists__inc_nr_events(he->hists, PERF_RECORD_SAMPLE);
+	if (!he->filtered)
+		he->hists->stats.nr_non_filtered_samples++;
+}
+
+static int hist_iter_cb(struct hist_entry_iter *iter,
+			struct addr_location *al, bool single, void *arg)
+{
+	int err = 0;
+	struct hist_entry *he = iter->he;
+	struct perf_evsel *evsel = iter->evsel;
+	struct report *rep = arg;
+
+	if (ui__has_annotation())
+		err = hist_entry__inc_addr_samples(he, evsel->idx, al->addr);
+
+	if (!single)
+		goto out;
+
+	report__inc_stats(rep, he);
+
+out:
+	return err;
+}
+
 static int process_sample_event(struct perf_tool *tool,
 				union perf_event *event,
 				struct perf_sample *sample,
@@ -109,17 +150,22 @@ static int process_sample_event(struct perf_tool *tool,
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
 
-	rep->nr_entries++;
+	if (iter.add_entry_cb == NULL)
+		rep->nr_entries++;
 
-	ret = hist_entry_iter__add(&iter, &al, evsel, sample, rep->max_stack);
+	ret = hist_entry_iter__add(&iter, &al, evsel, sample, rep->max_stack,
+				   rep);
 	if (ret < 0)
 		pr_debug("problem adding hist entry, skipping event\n");
 
diff --git a/tools/perf/tests/hists_filter.c b/tools/perf/tests/hists_filter.c
index 76b02e1de701..7063824c3566 100644
--- a/tools/perf/tests/hists_filter.c
+++ b/tools/perf/tests/hists_filter.c
@@ -42,6 +42,25 @@ static struct sample fake_samples[] = {
 	{ .pid = 300, .ip = 0xf0000 + 800, },
 };
 
+static int count_sample(struct hist_entry_iter *iter,
+			struct addr_location *al __maybe_unused, bool single,
+			void *arg __maybe_unused)
+{
+	struct hist_entry *he = iter->he;
+
+	if (he == NULL)
+		return -EINVAL;
+
+	if (!single)
+		return 0;
+
+	hists__inc_nr_events(he->hists, PERF_RECORD_SAMPLE);
+	if (!he->filtered)
+		he->hists->stats.nr_non_filtered_samples++;
+
+	return 0;
+}
+
 static int add_hist_entries(struct perf_evlist *evlist,
 			    struct machine *machine __maybe_unused)
 {
@@ -65,6 +84,7 @@ static int add_hist_entries(struct perf_evlist *evlist,
 			struct hist_entry_iter iter = {
 				.ops = &hist_iter_normal,
 				.hide_unresolved = false,
+				.add_entry_cb = count_sample,
 			};
 
 			/* make sure it has no filter at first */
@@ -82,7 +102,7 @@ static int add_hist_entries(struct perf_evlist *evlist,
 				goto out;
 
 			if (hist_entry_iter__add(&iter, &al, evsel, &sample,
-						 PERF_MAX_STACK_DEPTH) < 0)
+						 PERF_MAX_STACK_DEPTH, NULL) < 0)
 				goto out;
 
 			fake_samples[i].thread = al.thread;
diff --git a/tools/perf/tests/hists_output.c b/tools/perf/tests/hists_output.c
index 1308f88a9169..d40461ecd210 100644
--- a/tools/perf/tests/hists_output.c
+++ b/tools/perf/tests/hists_output.c
@@ -71,7 +71,7 @@ static int add_hist_entries(struct hists *hists, struct machine *machine)
 			goto out;
 
 		if (hist_entry_iter__add(&iter, &al, evsel, &sample,
-					 PERF_MAX_STACK_DEPTH) < 0)
+					 PERF_MAX_STACK_DEPTH, NULL) < 0)
 			goto out;
 
 		fake_samples[i].thread = al.thread;
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index de13f0a12940..0732a376afb9 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -675,11 +675,10 @@ iter_add_single_normal_entry(struct hist_entry_iter *iter, struct addr_location
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
@@ -687,16 +686,6 @@ iter_finish_normal_entry(struct hist_entry_iter *iter, struct addr_location *al)
 
 	iter->he = NULL;
 
-	if (ui__has_annotation()) {
-		err = hist_entry__inc_addr_samples(he, evsel->idx, al->addr);
-		if (err)
-			return err;
-	}
-
-	hists__inc_nr_events(&evsel->hists, PERF_RECORD_SAMPLE);
-	if (!he->filtered)
-		evsel->hists.stats.nr_non_filtered_samples++;
-
 	return hist_entry__append_callchain(he, sample);
 }
 
@@ -749,7 +738,7 @@ iter_add_single_cumulative_entry(struct hist_entry_iter *iter,
 	 */
 	callchain_cursor_commit(&callchain_cursor);
 
-	return hist_entry__inc_addr_samples(he, evsel->idx, al->addr);
+	return 0;
 }
 
 static int
@@ -796,8 +785,11 @@ iter_add_next_cumulative_entry(struct hist_entry_iter *iter,
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
@@ -806,31 +798,21 @@ iter_add_next_cumulative_entry(struct hist_entry_iter *iter,
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
-	struct hist_entry *he = iter->he;
-
 	zfree(&iter->priv);
-
-	if (he == NULL)
-		return 0;
-
 	iter->he = NULL;
 
-	hists__inc_nr_events(&evsel->hists, PERF_RECORD_SAMPLE);
-	if (!he->filtered)
-		evsel->hists.stats.nr_non_filtered_samples++;
-
 	return 0;
 }
 
@@ -868,7 +850,7 @@ const struct hist_iter_ops hist_iter_cumulative = {
 
 int hist_entry_iter__add(struct hist_entry_iter *iter, struct addr_location *al,
 			 struct perf_evsel *evsel, struct perf_sample *sample,
-			 int max_stack_depth)
+			 int max_stack_depth, void *arg)
 {
 	int err, err2;
 
@@ -888,10 +870,22 @@ int hist_entry_iter__add(struct hist_entry_iter *iter, struct addr_location *al,
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
index e8efb43b2355..b8a81adc63b7 100644
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
1.9.2

