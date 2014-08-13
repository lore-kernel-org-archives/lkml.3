Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754322AbaHMWut (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 18:50:49 -0400
Received: from mail.kernel.org ([198.145.19.201]:55471 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754282AbaHMWun (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 18:50:43 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 29/41] perf top: Fix -z option behavior
Date: Wed, 13 Aug 2014 19:48:15 -0300
Message-Id: <1407970107-24540-30-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1407970107-24540-1-git-send-email-acme@kernel.org>
References: <1407970107-24540-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

The current -z option does almost nothing.  It doesn't zero the existing
samples so that we can see profiles of exited process after last
refresh.  It seems it only affects annotation.

This patch clears existing entries before processing if -z option is
given.  For this original decaying logic also moved before processing.

Reported-by: Stephane Eranian <eranian@google.com>
Tested-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1407831366-28892-1-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-top.c | 23 +++++++++++++++++------
 tools/perf/util/hist.c   | 22 ++++++++++++++++++++++
 tools/perf/util/hist.h   |  1 +
 3 files changed, 40 insertions(+), 6 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 4b0e15c2b2a8..87a6615a40fa 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -276,11 +276,17 @@ static void perf_top__print_sym_table(struct perf_top *top)
 		return;
 	}
 
+	if (top->zero) {
+		hists__delete_entries(&top->sym_evsel->hists);
+	} else {
+		hists__decay_entries(&top->sym_evsel->hists,
+				     top->hide_user_symbols,
+				     top->hide_kernel_symbols);
+	}
+
 	hists__collapse_resort(&top->sym_evsel->hists, NULL);
 	hists__output_resort(&top->sym_evsel->hists);
-	hists__decay_entries(&top->sym_evsel->hists,
-			     top->hide_user_symbols,
-			     top->hide_kernel_symbols);
+
 	hists__output_recalc_col_len(&top->sym_evsel->hists,
 				     top->print_entries - printed);
 	putchar('\n');
@@ -542,11 +548,16 @@ static void perf_top__sort_new_samples(void *arg)
 	if (t->evlist->selected != NULL)
 		t->sym_evsel = t->evlist->selected;
 
+	if (t->zero) {
+		hists__delete_entries(&t->sym_evsel->hists);
+	} else {
+		hists__decay_entries(&t->sym_evsel->hists,
+				     t->hide_user_symbols,
+				     t->hide_kernel_symbols);
+	}
+
 	hists__collapse_resort(&t->sym_evsel->hists, NULL);
 	hists__output_resort(&t->sym_evsel->hists);
-	hists__decay_entries(&t->sym_evsel->hists,
-			     t->hide_user_symbols,
-			     t->hide_kernel_symbols);
 }
 
 static void *display_thread_tui(void *arg)
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 30df6187ee02..86569fa3651d 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -277,6 +277,28 @@ void hists__decay_entries(struct hists *hists, bool zap_user, bool zap_kernel)
 	}
 }
 
+void hists__delete_entries(struct hists *hists)
+{
+	struct rb_node *next = rb_first(&hists->entries);
+	struct hist_entry *n;
+
+	while (next) {
+		n = rb_entry(next, struct hist_entry, rb_node);
+		next = rb_next(&n->rb_node);
+
+		rb_erase(&n->rb_node, &hists->entries);
+
+		if (sort__need_collapse)
+			rb_erase(&n->rb_node_in, &hists->entries_collapsed);
+
+		--hists->nr_entries;
+		if (!n->filtered)
+			--hists->nr_non_filtered_entries;
+
+		hist_entry__free(n);
+	}
+}
+
 /*
  * histogram, sorted on item, collects periods
  */
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 95405a8fbd95..8c9c70e18cbb 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -152,6 +152,7 @@ void hists__output_resort(struct hists *hists);
 void hists__collapse_resort(struct hists *hists, struct ui_progress *prog);
 
 void hists__decay_entries(struct hists *hists, bool zap_user, bool zap_kernel);
+void hists__delete_entries(struct hists *hists);
 void hists__output_recalc_col_len(struct hists *hists, int max_rows);
 
 u64 hists__total_period(struct hists *hists);
-- 
1.9.3

