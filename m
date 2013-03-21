Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756793Ab3CULOc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 07:14:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56338 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828Ab3CULOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 07:14:30 -0400
Date: Thu, 21 Mar 2013 04:12:47 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-db8fd07a541fc2d5e8076f0151286e19591465b3@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, andi@firstfloor.org,
        a.p.zijlstra@chello.nl, penberg@kernel.org, namhyung.kim@lge.com,
        namhyung@kernel.org, jolsa@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, andi@firstfloor.org,
        a.p.zijlstra@chello.nl, penberg@kernel.org, namhyung.kim@lge.com,
        tglx@linutronix.de, namhyung@kernel.org, jolsa@redhat.com
In-Reply-To: <1362462812-30885-2-git-send-email-namhyung@kernel.org>
References: <1362462812-30885-2-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf annotate:
  Pass evsel instead of evidx on annotation functions
Git-Commit-ID: db8fd07a541fc2d5e8076f0151286e19591465b3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 21 Mar 2013 04:12:58 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  db8fd07a541fc2d5e8076f0151286e19591465b3
Gitweb:     http://git.kernel.org/tip/db8fd07a541fc2d5e8076f0151286e19591465b3
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Tue, 5 Mar 2013 14:53:21 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 15 Mar 2013 13:06:04 -0300

perf annotate: Pass evsel instead of evidx on annotation functions

Pass evsel instead of evidx.  This is a preparation for supporting event
group view in annotation and no functional change is intended.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1362462812-30885-2-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-annotate.c     | 16 +++++++++-------
 tools/perf/builtin-top.c          |  2 +-
 tools/perf/ui/browsers/annotate.c | 30 +++++++++++++++++-------------
 tools/perf/ui/browsers/hists.c    |  2 +-
 tools/perf/ui/gtk/annotate.c      | 10 ++++++----
 tools/perf/util/annotate.c        | 36 +++++++++++++++++++-----------------
 tools/perf/util/annotate.h        | 36 +++++++++++++++++++-----------------
 tools/perf/util/hist.h            |  5 +++--
 8 files changed, 75 insertions(+), 62 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 2e6961e..2f015a9 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -109,14 +109,16 @@ static int process_sample_event(struct perf_tool *tool,
 	return 0;
 }
 
-static int hist_entry__tty_annotate(struct hist_entry *he, int evidx,
+static int hist_entry__tty_annotate(struct hist_entry *he,
+				    struct perf_evsel *evsel,
 				    struct perf_annotate *ann)
 {
-	return symbol__tty_annotate(he->ms.sym, he->ms.map, evidx,
+	return symbol__tty_annotate(he->ms.sym, he->ms.map, evsel,
 				    ann->print_line, ann->full_paths, 0, 0);
 }
 
-static void hists__find_annotations(struct hists *self, int evidx,
+static void hists__find_annotations(struct hists *self,
+				    struct perf_evsel *evsel,
 				    struct perf_annotate *ann)
 {
 	struct rb_node *nd = rb_first(&self->entries), *next;
@@ -142,14 +144,14 @@ find_next:
 		if (use_browser == 2) {
 			int ret;
 
-			ret = hist_entry__gtk_annotate(he, evidx, NULL);
+			ret = hist_entry__gtk_annotate(he, evsel, NULL);
 			if (!ret || !ann->skip_missing)
 				return;
 
 			/* skip missing symbols */
 			nd = rb_next(nd);
 		} else if (use_browser == 1) {
-			key = hist_entry__tui_annotate(he, evidx, NULL);
+			key = hist_entry__tui_annotate(he, evsel, NULL);
 			switch (key) {
 			case -1:
 				if (!ann->skip_missing)
@@ -168,7 +170,7 @@ find_next:
 			if (next != NULL)
 				nd = next;
 		} else {
-			hist_entry__tty_annotate(he, evidx, ann);
+			hist_entry__tty_annotate(he, evsel, ann);
 			nd = rb_next(nd);
 			/*
 			 * Since we have a hist_entry per IP for the same
@@ -230,7 +232,7 @@ static int __cmd_annotate(struct perf_annotate *ann)
 			total_nr_samples += nr_samples;
 			hists__collapse_resort(hists);
 			hists__output_resort(hists);
-			hists__find_annotations(hists, pos->idx, ann);
+			hists__find_annotations(hists, pos, ann);
 		}
 	}
 
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index c5601aa..b5520ad 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -231,7 +231,7 @@ static void perf_top__show_details(struct perf_top *top)
 	printf("Showing %s for %s\n", perf_evsel__name(top->sym_evsel), symbol->name);
 	printf("  Events  Pcnt (>=%d%%)\n", top->sym_pcnt_filter);
 
-	more = symbol__annotate_printf(symbol, he->ms.map, top->sym_evsel->idx,
+	more = symbol__annotate_printf(symbol, he->ms.map, top->sym_evsel,
 				       0, top->sym_pcnt_filter, top->print_entries, 4);
 	if (top->zero)
 		symbol__annotate_zero_histogram(symbol, top->sym_evsel->idx);
diff --git a/tools/perf/ui/browsers/annotate.c b/tools/perf/ui/browsers/annotate.c
index 7dca155..6779847 100644
--- a/tools/perf/ui/browsers/annotate.c
+++ b/tools/perf/ui/browsers/annotate.c
@@ -8,6 +8,7 @@
 #include "../../util/hist.h"
 #include "../../util/sort.h"
 #include "../../util/symbol.h"
+#include "../../util/evsel.h"
 #include <pthread.h>
 #include <newt.h>
 
@@ -331,7 +332,7 @@ static void annotate_browser__set_rb_top(struct annotate_browser *browser,
 }
 
 static void annotate_browser__calc_percent(struct annotate_browser *browser,
-					   int evidx)
+					   struct perf_evsel *evsel)
 {
 	struct map_symbol *ms = browser->b.priv;
 	struct symbol *sym = ms->sym;
@@ -344,7 +345,7 @@ static void annotate_browser__calc_percent(struct annotate_browser *browser,
 
 	list_for_each_entry(pos, &notes->src->source, node) {
 		struct browser_disasm_line *bpos = disasm_line__browser(pos);
-		bpos->percent = disasm_line__calc_percent(pos, sym, evidx);
+		bpos->percent = disasm_line__calc_percent(pos, sym, evsel->idx);
 		if (bpos->percent < 0.01) {
 			RB_CLEAR_NODE(&bpos->rb_node);
 			continue;
@@ -401,7 +402,8 @@ static void annotate_browser__init_asm_mode(struct annotate_browser *browser)
 	browser->b.nr_entries = browser->nr_asm_entries;
 }
 
-static bool annotate_browser__callq(struct annotate_browser *browser, int evidx,
+static bool annotate_browser__callq(struct annotate_browser *browser,
+				    struct perf_evsel *evsel,
 				    struct hist_browser_timer *hbt)
 {
 	struct map_symbol *ms = browser->b.priv;
@@ -432,7 +434,7 @@ static bool annotate_browser__callq(struct annotate_browser *browser, int evidx,
 	}
 
 	pthread_mutex_unlock(&notes->lock);
-	symbol__tui_annotate(target, ms->map, evidx, hbt);
+	symbol__tui_annotate(target, ms->map, evsel, hbt);
 	ui_browser__show_title(&browser->b, sym->name);
 	return true;
 }
@@ -615,7 +617,8 @@ static void annotate_browser__update_addr_width(struct annotate_browser *browser
 		browser->addr_width += browser->jumps_width + 1;
 }
 
-static int annotate_browser__run(struct annotate_browser *browser, int evidx,
+static int annotate_browser__run(struct annotate_browser *browser,
+				 struct perf_evsel *evsel,
 				 struct hist_browser_timer *hbt)
 {
 	struct rb_node *nd = NULL;
@@ -628,7 +631,7 @@ static int annotate_browser__run(struct annotate_browser *browser, int evidx,
 	if (ui_browser__show(&browser->b, sym->name, help) < 0)
 		return -1;
 
-	annotate_browser__calc_percent(browser, evidx);
+	annotate_browser__calc_percent(browser, evsel);
 
 	if (browser->curr_hot) {
 		annotate_browser__set_rb_top(browser, browser->curr_hot);
@@ -641,7 +644,7 @@ static int annotate_browser__run(struct annotate_browser *browser, int evidx,
 		key = ui_browser__run(&browser->b, delay_secs);
 
 		if (delay_secs != 0) {
-			annotate_browser__calc_percent(browser, evidx);
+			annotate_browser__calc_percent(browser, evsel);
 			/*
 			 * Current line focus got out of the list of most active
 			 * lines, NULL it so that if TAB|UNTAB is pressed, we
@@ -657,7 +660,7 @@ static int annotate_browser__run(struct annotate_browser *browser, int evidx,
 				hbt->timer(hbt->arg);
 
 			if (delay_secs != 0)
-				symbol__annotate_decay_histogram(sym, evidx);
+				symbol__annotate_decay_histogram(sym, evsel->idx);
 			continue;
 		case K_TAB:
 			if (nd != NULL) {
@@ -754,7 +757,7 @@ show_help:
 					goto show_sup_ins;
 				goto out;
 			} else if (!(annotate_browser__jump(browser) ||
-				     annotate_browser__callq(browser, evidx, hbt))) {
+				     annotate_browser__callq(browser, evsel, hbt))) {
 show_sup_ins:
 				ui_helpline__puts("Actions are only available for 'callq', 'retq' & jump instructions.");
 			}
@@ -776,10 +779,10 @@ out:
 	return key;
 }
 
-int hist_entry__tui_annotate(struct hist_entry *he, int evidx,
+int hist_entry__tui_annotate(struct hist_entry *he, struct perf_evsel *evsel,
 			     struct hist_browser_timer *hbt)
 {
-	return symbol__tui_annotate(he->ms.sym, he->ms.map, evidx, hbt);
+	return symbol__tui_annotate(he->ms.sym, he->ms.map, evsel, hbt);
 }
 
 static void annotate_browser__mark_jump_targets(struct annotate_browser *browser,
@@ -826,7 +829,8 @@ static inline int width_jumps(int n)
 	return 1;
 }
 
-int symbol__tui_annotate(struct symbol *sym, struct map *map, int evidx,
+int symbol__tui_annotate(struct symbol *sym, struct map *map,
+			 struct perf_evsel *evsel,
 			 struct hist_browser_timer *hbt)
 {
 	struct disasm_line *pos, *n;
@@ -909,7 +913,7 @@ int symbol__tui_annotate(struct symbol *sym, struct map *map, int evidx,
 
 	annotate_browser__update_addr_width(&browser);
 
-	ret = annotate_browser__run(&browser, evidx, hbt);
+	ret = annotate_browser__run(&browser, evsel, hbt);
 	list_for_each_entry_safe(pos, n, &notes->src->source, node) {
 		list_del(&pos->node);
 		disasm_line__free(pos);
diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index aa22704..0e125e1 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -1599,7 +1599,7 @@ do_annotate:
 			 * Don't let this be freed, say, by hists__decay_entry.
 			 */
 			he->used = true;
-			err = hist_entry__tui_annotate(he, evsel->idx, hbt);
+			err = hist_entry__tui_annotate(he, evsel, hbt);
 			he->used = false;
 			/*
 			 * offer option to annotate the other branch source or target
diff --git a/tools/perf/ui/gtk/annotate.c b/tools/perf/ui/gtk/annotate.c
index 7d8dc58..6e2fc7e 100644
--- a/tools/perf/ui/gtk/annotate.c
+++ b/tools/perf/ui/gtk/annotate.c
@@ -1,6 +1,7 @@
 #include "gtk.h"
 #include "util/debug.h"
 #include "util/annotate.h"
+#include "util/evsel.h"
 #include "ui/helpline.h"
 
 
@@ -85,7 +86,7 @@ static int perf_gtk__get_line(char *buf, size_t size, struct disasm_line *dl)
 }
 
 static int perf_gtk__annotate_symbol(GtkWidget *window, struct symbol *sym,
-				struct map *map, int evidx,
+				struct map *map, struct perf_evsel *evsel,
 				struct hist_browser_timer *hbt __maybe_unused)
 {
 	struct disasm_line *pos, *n;
@@ -121,7 +122,7 @@ static int perf_gtk__annotate_symbol(GtkWidget *window, struct symbol *sym,
 
 		gtk_list_store_append(store, &iter);
 
-		if (perf_gtk__get_percent(s, sizeof(s), sym, pos, evidx))
+		if (perf_gtk__get_percent(s, sizeof(s), sym, pos, evsel->idx))
 			gtk_list_store_set(store, &iter, ANN_COL__PERCENT, s, -1);
 		if (perf_gtk__get_offset(s, sizeof(s), sym, map, pos))
 			gtk_list_store_set(store, &iter, ANN_COL__OFFSET, s, -1);
@@ -139,7 +140,8 @@ static int perf_gtk__annotate_symbol(GtkWidget *window, struct symbol *sym,
 	return 0;
 }
 
-int symbol__gtk_annotate(struct symbol *sym, struct map *map, int evidx,
+int symbol__gtk_annotate(struct symbol *sym, struct map *map,
+			 struct perf_evsel *evsel,
 			 struct hist_browser_timer *hbt)
 {
 	GtkWidget *window;
@@ -206,7 +208,7 @@ int symbol__gtk_annotate(struct symbol *sym, struct map *map, int evidx,
 	gtk_notebook_append_page(GTK_NOTEBOOK(notebook), scrolled_window,
 				 tab_label);
 
-	perf_gtk__annotate_symbol(scrolled_window, sym, map, evidx, hbt);
+	perf_gtk__annotate_symbol(scrolled_window, sym, map, evsel, hbt);
 	return 0;
 }
 
diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index d33fe93..7eac5f0 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -14,6 +14,7 @@
 #include "symbol.h"
 #include "debug.h"
 #include "annotate.h"
+#include "evsel.h"
 #include <pthread.h>
 #include <linux/bitops.h>
 
@@ -603,7 +604,7 @@ struct disasm_line *disasm__get_next_ip_line(struct list_head *head, struct disa
 }
 
 static int disasm_line__print(struct disasm_line *dl, struct symbol *sym, u64 start,
-		      int evidx, u64 len, int min_pcnt, int printed,
+		      struct perf_evsel *evsel, u64 len, int min_pcnt, int printed,
 		      int max_lines, struct disasm_line *queue)
 {
 	static const char *prev_line;
@@ -616,7 +617,7 @@ static int disasm_line__print(struct disasm_line *dl, struct symbol *sym, u64 st
 		const char *color;
 		struct annotation *notes = symbol__annotation(sym);
 		struct source_line *src_line = notes->src->lines;
-		struct sym_hist *h = annotation__histogram(notes, evidx);
+		struct sym_hist *h = annotation__histogram(notes, evsel->idx);
 		s64 offset = dl->offset;
 		const u64 addr = start + offset;
 		struct disasm_line *next;
@@ -648,7 +649,7 @@ static int disasm_line__print(struct disasm_line *dl, struct symbol *sym, u64 st
 			list_for_each_entry_from(queue, &notes->src->source, node) {
 				if (queue == dl)
 					break;
-				disasm_line__print(queue, sym, start, evidx, len,
+				disasm_line__print(queue, sym, start, evsel, len,
 						    0, 0, 1, NULL);
 			}
 		}
@@ -935,7 +936,8 @@ static void symbol__free_source_line(struct symbol *sym, int len)
 
 /* Get the filename:line for the colored entries */
 static int symbol__get_source_line(struct symbol *sym, struct map *map,
-				   int evidx, struct rb_root *root, int len,
+				   struct perf_evsel *evsel,
+				   struct rb_root *root, int len,
 				   const char *filename)
 {
 	u64 start;
@@ -943,7 +945,7 @@ static int symbol__get_source_line(struct symbol *sym, struct map *map,
 	char cmd[PATH_MAX * 2];
 	struct source_line *src_line;
 	struct annotation *notes = symbol__annotation(sym);
-	struct sym_hist *h = annotation__histogram(notes, evidx);
+	struct sym_hist *h = annotation__histogram(notes, evsel->idx);
 	struct rb_root tmp_root = RB_ROOT;
 
 	if (!h->sum)
@@ -1018,10 +1020,10 @@ static void print_summary(struct rb_root *root, const char *filename)
 	}
 }
 
-static void symbol__annotate_hits(struct symbol *sym, int evidx)
+static void symbol__annotate_hits(struct symbol *sym, struct perf_evsel *evsel)
 {
 	struct annotation *notes = symbol__annotation(sym);
-	struct sym_hist *h = annotation__histogram(notes, evidx);
+	struct sym_hist *h = annotation__histogram(notes, evsel->idx);
 	u64 len = symbol__size(sym), offset;
 
 	for (offset = 0; offset < len; ++offset)
@@ -1031,9 +1033,9 @@ static void symbol__annotate_hits(struct symbol *sym, int evidx)
 	printf("%*s: %" PRIu64 "\n", BITS_PER_LONG / 2, "h->sum", h->sum);
 }
 
-int symbol__annotate_printf(struct symbol *sym, struct map *map, int evidx,
-			    bool full_paths, int min_pcnt, int max_lines,
-			    int context)
+int symbol__annotate_printf(struct symbol *sym, struct map *map,
+			    struct perf_evsel *evsel, bool full_paths,
+			    int min_pcnt, int max_lines, int context)
 {
 	struct dso *dso = map->dso;
 	char *filename;
@@ -1060,7 +1062,7 @@ int symbol__annotate_printf(struct symbol *sym, struct map *map, int evidx,
 	printf("------------------------------------------------\n");
 
 	if (verbose)
-		symbol__annotate_hits(sym, evidx);
+		symbol__annotate_hits(sym, evsel);
 
 	list_for_each_entry(pos, &notes->src->source, node) {
 		if (context && queue == NULL) {
@@ -1068,7 +1070,7 @@ int symbol__annotate_printf(struct symbol *sym, struct map *map, int evidx,
 			queue_len = 0;
 		}
 
-		switch (disasm_line__print(pos, sym, start, evidx, len,
+		switch (disasm_line__print(pos, sym, start, evsel, len,
 					    min_pcnt, printed, max_lines,
 					    queue)) {
 		case 0:
@@ -1163,9 +1165,9 @@ size_t disasm__fprintf(struct list_head *head, FILE *fp)
 	return printed;
 }
 
-int symbol__tty_annotate(struct symbol *sym, struct map *map, int evidx,
-			 bool print_lines, bool full_paths, int min_pcnt,
-			 int max_lines)
+int symbol__tty_annotate(struct symbol *sym, struct map *map,
+			 struct perf_evsel *evsel, bool print_lines,
+			 bool full_paths, int min_pcnt, int max_lines)
 {
 	struct dso *dso = map->dso;
 	const char *filename = dso->long_name;
@@ -1178,12 +1180,12 @@ int symbol__tty_annotate(struct symbol *sym, struct map *map, int evidx,
 	len = symbol__size(sym);
 
 	if (print_lines) {
-		symbol__get_source_line(sym, map, evidx, &source_line,
+		symbol__get_source_line(sym, map, evsel, &source_line,
 					len, filename);
 		print_summary(&source_line, filename);
 	}
 
-	symbol__annotate_printf(sym, map, evidx, full_paths,
+	symbol__annotate_printf(sym, map, evsel, full_paths,
 				min_pcnt, max_lines, 0);
 	if (print_lines)
 		symbol__free_source_line(sym, len);
diff --git a/tools/perf/util/annotate.h b/tools/perf/util/annotate.h
index c422440..3763954 100644
--- a/tools/perf/util/annotate.h
+++ b/tools/perf/util/annotate.h
@@ -130,47 +130,49 @@ void symbol__annotate_zero_histograms(struct symbol *sym);
 
 int symbol__annotate(struct symbol *sym, struct map *map, size_t privsize);
 int symbol__annotate_init(struct map *map __maybe_unused, struct symbol *sym);
-int symbol__annotate_printf(struct symbol *sym, struct map *map, int evidx,
-			    bool full_paths, int min_pcnt, int max_lines,
-			    int context);
+int symbol__annotate_printf(struct symbol *sym, struct map *map,
+			    struct perf_evsel *evsel, bool full_paths,
+			    int min_pcnt, int max_lines, int context);
 void symbol__annotate_zero_histogram(struct symbol *sym, int evidx);
 void symbol__annotate_decay_histogram(struct symbol *sym, int evidx);
 void disasm__purge(struct list_head *head);
 
-int symbol__tty_annotate(struct symbol *sym, struct map *map, int evidx,
-			 bool print_lines, bool full_paths, int min_pcnt,
-			 int max_lines);
+int symbol__tty_annotate(struct symbol *sym, struct map *map,
+			 struct perf_evsel *evsel, bool print_lines,
+			 bool full_paths, int min_pcnt, int max_lines);
 
 #ifdef NEWT_SUPPORT
-int symbol__tui_annotate(struct symbol *sym, struct map *map, int evidx,
+int symbol__tui_annotate(struct symbol *sym, struct map *map,
+			 struct perf_evsel *evsel,
 			 struct hist_browser_timer *hbt);
 #else
 static inline int symbol__tui_annotate(struct symbol *sym __maybe_unused,
-				       struct map *map __maybe_unused,
-				       int evidx __maybe_unused,
-				       struct hist_browser_timer *hbt
-				       __maybe_unused)
+				struct map *map __maybe_unused,
+				struct perf_evsel *evsel  __maybe_unused,
+				struct hist_browser_timer *hbt
+				__maybe_unused)
 {
 	return 0;
 }
 #endif
 
 #ifdef GTK2_SUPPORT
-int symbol__gtk_annotate(struct symbol *sym, struct map *map, int evidx,
+int symbol__gtk_annotate(struct symbol *sym, struct map *map,
+			 struct perf_evsel *evsel,
 			 struct hist_browser_timer *hbt);
 
-static inline int hist_entry__gtk_annotate(struct hist_entry *he, int evidx,
+static inline int hist_entry__gtk_annotate(struct hist_entry *he,
+					   struct perf_evsel *evsel,
 					   struct hist_browser_timer *hbt)
 {
-	return symbol__gtk_annotate(he->ms.sym, he->ms.map, evidx, hbt);
+	return symbol__gtk_annotate(he->ms.sym, he->ms.map, evsel, hbt);
 }
 
 void perf_gtk__show_annotations(void);
 #else
 static inline int hist_entry__gtk_annotate(struct hist_entry *he __maybe_unused,
-					   int evidx __maybe_unused,
-					   struct hist_browser_timer *hbt
-					   __maybe_unused)
+				struct perf_evsel *evsel __maybe_unused,
+				struct hist_browser_timer *hbt __maybe_unused)
 {
 	return 0;
 }
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 226a4ae..8483313 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -177,7 +177,7 @@ struct hist_browser_timer {
 
 #ifdef NEWT_SUPPORT
 #include "../ui/keysyms.h"
-int hist_entry__tui_annotate(struct hist_entry *he, int evidx,
+int hist_entry__tui_annotate(struct hist_entry *he, struct perf_evsel *evsel,
 			     struct hist_browser_timer *hbt);
 
 int perf_evlist__tui_browse_hists(struct perf_evlist *evlist, const char *help,
@@ -196,7 +196,8 @@ int perf_evlist__tui_browse_hists(struct perf_evlist *evlist __maybe_unused,
 
 static inline int hist_entry__tui_annotate(struct hist_entry *self
 					   __maybe_unused,
-					   int evidx __maybe_unused,
+					   struct perf_evsel *evsel
+					   __maybe_unused,
 					   struct hist_browser_timer *hbt
 					   __maybe_unused)
 {
