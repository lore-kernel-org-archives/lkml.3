Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964999Ab3E3QQX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 12:16:23 -0400
Received: from merlin.infradead.org ([205.233.59.134]:50757 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934256Ab3E3QCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 12:02:04 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 20/66] perf top: Get rid of *_threaded() functions
Date: Thu, 30 May 2013 19:00:53 +0300
Message-Id: <1369929699-8724-21-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1369929699-8724-1-git-send-email-acme@infradead.org>
References: <1369929699-8724-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Those _threaded() functions are needed to make hist tree handling
thread-safe, but AFAICS the only thing it does is forcing it to use
the intermediate 'collapsed' tree.

This can be acheived by setting sort__need_collapse to 1 in cmd_top() so
no need to keep those _threaded() variants.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1368497347-9628-4-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-top.c | 23 +++++++++++++----------
 tools/perf/util/hist.c   | 44 ++++++--------------------------------------
 tools/perf/util/hist.h   |  4 ----
 3 files changed, 19 insertions(+), 52 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 81adcaf..5cd41ec 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -284,11 +284,11 @@ static void perf_top__print_sym_table(struct perf_top *top)
 		return;
 	}
 
-	hists__collapse_resort_threaded(&top->sym_evsel->hists);
-	hists__output_resort_threaded(&top->sym_evsel->hists);
-	hists__decay_entries_threaded(&top->sym_evsel->hists,
-				      top->hide_user_symbols,
-				      top->hide_kernel_symbols);
+	hists__collapse_resort(&top->sym_evsel->hists);
+	hists__output_resort(&top->sym_evsel->hists);
+	hists__decay_entries(&top->sym_evsel->hists,
+			     top->hide_user_symbols,
+			     top->hide_kernel_symbols);
 	hists__output_recalc_col_len(&top->sym_evsel->hists,
 				     top->print_entries - printed);
 	putchar('\n');
@@ -549,11 +549,11 @@ static void perf_top__sort_new_samples(void *arg)
 	if (t->evlist->selected != NULL)
 		t->sym_evsel = t->evlist->selected;
 
-	hists__collapse_resort_threaded(&t->sym_evsel->hists);
-	hists__output_resort_threaded(&t->sym_evsel->hists);
-	hists__decay_entries_threaded(&t->sym_evsel->hists,
-				      t->hide_user_symbols,
-				      t->hide_kernel_symbols);
+	hists__collapse_resort(&t->sym_evsel->hists);
+	hists__output_resort(&t->sym_evsel->hists);
+	hists__decay_entries(&t->sym_evsel->hists,
+			     t->hide_user_symbols,
+			     t->hide_kernel_symbols);
 }
 
 static void *display_thread_tui(void *arg)
@@ -1126,6 +1126,9 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 	if (setup_sorting() < 0)
 		usage_with_options(top_usage, options);
 
+	/* display thread wants entries to be collapsed in a different tree */
+	sort__need_collapse = 1;
+
 	if (top.use_stdio)
 		use_browser = 0;
 	else if (top.use_tui)
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 72b4eec..7e0fa62 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -240,8 +240,7 @@ static bool hists__decay_entry(struct hists *hists, struct hist_entry *he)
 	return he->stat.period == 0;
 }
 
-static void __hists__decay_entries(struct hists *hists, bool zap_user,
-				   bool zap_kernel, bool threaded)
+void hists__decay_entries(struct hists *hists, bool zap_user, bool zap_kernel)
 {
 	struct rb_node *next = rb_first(&hists->entries);
 	struct hist_entry *n;
@@ -260,7 +259,7 @@ static void __hists__decay_entries(struct hists *hists, bool zap_user,
 		    !n->used) {
 			rb_erase(&n->rb_node, &hists->entries);
 
-			if (sort__need_collapse || threaded)
+			if (sort__need_collapse)
 				rb_erase(&n->rb_node_in, &hists->entries_collapsed);
 
 			hist_entry__free(n);
@@ -269,17 +268,6 @@ static void __hists__decay_entries(struct hists *hists, bool zap_user,
 	}
 }
 
-void hists__decay_entries(struct hists *hists, bool zap_user, bool zap_kernel)
-{
-	return __hists__decay_entries(hists, zap_user, zap_kernel, false);
-}
-
-void hists__decay_entries_threaded(struct hists *hists,
-				   bool zap_user, bool zap_kernel)
-{
-	return __hists__decay_entries(hists, zap_user, zap_kernel, true);
-}
-
 /*
  * histogram, sorted on item, collects periods
  */
@@ -613,13 +601,13 @@ static void hists__apply_filters(struct hists *hists, struct hist_entry *he)
 	hists__filter_entry_by_symbol(hists, he);
 }
 
-static void __hists__collapse_resort(struct hists *hists, bool threaded)
+void hists__collapse_resort(struct hists *hists)
 {
 	struct rb_root *root;
 	struct rb_node *next;
 	struct hist_entry *n;
 
-	if (!sort__need_collapse && !threaded)
+	if (!sort__need_collapse)
 		return;
 
 	root = hists__get_rotate_entries_in(hists);
@@ -641,16 +629,6 @@ static void __hists__collapse_resort(struct hists *hists, bool threaded)
 	}
 }
 
-void hists__collapse_resort(struct hists *hists)
-{
-	return __hists__collapse_resort(hists, false);
-}
-
-void hists__collapse_resort_threaded(struct hists *hists)
-{
-	return __hists__collapse_resort(hists, true);
-}
-
 /*
  * reverse the map, sort on period.
  */
@@ -737,7 +715,7 @@ static void __hists__insert_output_entry(struct rb_root *entries,
 	rb_insert_color(&he->rb_node, entries);
 }
 
-static void __hists__output_resort(struct hists *hists, bool threaded)
+void hists__output_resort(struct hists *hists)
 {
 	struct rb_root *root;
 	struct rb_node *next;
@@ -746,7 +724,7 @@ static void __hists__output_resort(struct hists *hists, bool threaded)
 
 	min_callchain_hits = hists->stats.total_period * (callchain_param.min_percent / 100);
 
-	if (sort__need_collapse || threaded)
+	if (sort__need_collapse)
 		root = &hists->entries_collapsed;
 	else
 		root = hists->entries_in;
@@ -767,16 +745,6 @@ static void __hists__output_resort(struct hists *hists, bool threaded)
 	}
 }
 
-void hists__output_resort(struct hists *hists)
-{
-	return __hists__output_resort(hists, false);
-}
-
-void hists__output_resort_threaded(struct hists *hists)
-{
-	return __hists__output_resort(hists, true);
-}
-
 static void hists__remove_entry_filter(struct hists *hists, struct hist_entry *h,
 				       enum hist_filter filter)
 {
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 6be88dc..bd81d79 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -104,13 +104,9 @@ struct hist_entry *__hists__add_mem_entry(struct hists *self,
 					  u64 weight);
 
 void hists__output_resort(struct hists *self);
-void hists__output_resort_threaded(struct hists *hists);
 void hists__collapse_resort(struct hists *self);
-void hists__collapse_resort_threaded(struct hists *hists);
 
 void hists__decay_entries(struct hists *hists, bool zap_user, bool zap_kernel);
-void hists__decay_entries_threaded(struct hists *hists, bool zap_user,
-				   bool zap_kernel);
 void hists__output_recalc_col_len(struct hists *hists, int max_rows);
 
 void hists__inc_nr_entries(struct hists *hists, struct hist_entry *h);
-- 
1.8.1.4

