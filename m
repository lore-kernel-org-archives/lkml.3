Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753066AbaE2EAs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 00:00:48 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:53473 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932305AbaE2D6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 23:58:38 -0400
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
        Rodrigo Campos <rodrigo@sdfg.com.ar>, Don Zickus <dzickus@redhat.com>
Subject: [PATCH 18/27] perf tools: Add callback function to hist_entry_iter
Date: Thu, 29 May 2014 12:58:21 +0900
Message-Id: <1401335910-16832-19-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1401335910-16832-1-git-send-email-namhyung@kernel.org>
References: <1401335910-16832-1-git-send-email-namhyung@kernel.org>
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
 tools/perf/builtin-report.c     | 33 +++++++++++++++++++++++++--------
 tools/perf/tests/hists_filter.c |  2 +-
 tools/perf/tests/hists_output.c |  2 +-
 tools/perf/util/hist.c          | 19 +++++++++++++++++--
 tools/perf/util/hist.h          |  5 ++++-
 5 files changed, 48 insertions(+), 13 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 6cac509212ee..ed9f74dc2d27 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -80,14 +80,31 @@ static int report__config(const char *var, const char *value, void *cb)
 	return perf_default_config(var, value, cb);
 }
 
-static void report__inc_stats(struct report *rep,
-			      struct hist_entry *he __maybe_unused)
+static void report__inc_stats(struct report *rep, struct hist_entry *he)
 {
 	/*
-	 * We cannot access @he at this time.  Just assume it's a new entry.
-	 * It'll be fixed once we have a callback mechanism in hist_iter.
+	 * The @he is either of a newly created one or an existing one
+	 * merging current sample.  We only want to count a new one so
+	 * checking ->nr_events being 1.
 	 */
-	rep->nr_entries++;
+	if (he->stat.nr_events == 1)
+		rep->nr_entries++;
+}
+
+static int hist_iter__report_callback(struct hist_entry_iter *iter,
+				      struct addr_location *al, void *arg)
+{
+	int err = 0;
+	struct hist_entry *he = iter->he;
+	struct perf_evsel *evsel = iter->evsel;
+	struct report *rep = arg;
+
+	if (ui__has_annotation())
+		err = hist_entry__inc_addr_samples(he, evsel->idx, al->addr);
+
+	report__inc_stats(rep, he);
+
+	return err;
 }
 
 static int process_sample_event(struct perf_tool *tool,
@@ -100,6 +117,7 @@ static int process_sample_event(struct perf_tool *tool,
 	struct addr_location al;
 	struct hist_entry_iter iter = {
 		.hide_unresolved = rep->hide_unresolved,
+		.add_entry_cb = hist_iter__report_callback,
 	};
 	int ret;
 
@@ -127,9 +145,8 @@ static int process_sample_event(struct perf_tool *tool,
 	if (al.map != NULL)
 		al.map->dso->hit = 1;
 
-	report__inc_stats(rep, NULL);
-
-	ret = hist_entry_iter__add(&iter, &al, evsel, sample, rep->max_stack);
+	ret = hist_entry_iter__add(&iter, &al, evsel, sample, rep->max_stack,
+				   rep);
 	if (ret < 0)
 		pr_debug("problem adding hist entry, skipping event\n");
 
diff --git a/tools/perf/tests/hists_filter.c b/tools/perf/tests/hists_filter.c
index 76b02e1de701..3539403bbad4 100644
--- a/tools/perf/tests/hists_filter.c
+++ b/tools/perf/tests/hists_filter.c
@@ -82,7 +82,7 @@ static int add_hist_entries(struct perf_evlist *evlist,
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
index c6f5f5251aad..6ee042d5e8f6 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -802,8 +802,11 @@ iter_add_next_cumulative_entry(struct hist_entry_iter *iter,
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
@@ -863,7 +866,7 @@ const struct hist_iter_ops hist_iter_cumulative = {
 
 int hist_entry_iter__add(struct hist_entry_iter *iter, struct addr_location *al,
 			 struct perf_evsel *evsel, struct perf_sample *sample,
-			 int max_stack_depth)
+			 int max_stack_depth, void *arg)
 {
 	int err, err2;
 
@@ -883,10 +886,22 @@ int hist_entry_iter__add(struct hist_entry_iter *iter, struct addr_location *al,
 	if (err)
 		goto out;
 
+	if (iter->he && iter->add_entry_cb) {
+		err = iter->add_entry_cb(iter, al, arg);
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
+			err = iter->add_entry_cb(iter, al, arg);
+			if (err)
+				goto out;
+		}
 	}
 
 out:
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 99ad3cb433fb..e0a622651b00 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -119,6 +119,9 @@ struct hist_entry_iter {
 	void *priv;
 
 	const struct hist_iter_ops *ops;
+	/* user-defined callback function (optional) */
+	int (*add_entry_cb)(struct hist_entry_iter *iter,
+			    struct addr_location *al, void *arg);
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

