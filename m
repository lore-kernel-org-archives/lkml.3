Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756007Ab3AXUKd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 15:10:33 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:54072
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755881Ab3AXUIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 15:08:44 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 03/74] perf diff: Use internal rb tree for compute resort
Date: Thu, 24 Jan 2013 17:07:12 -0300
Message-Id: <1359058103-31645-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1359058103-31645-1-git-send-email-acme@infradead.org>
References: <1359058103-31645-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

There's no reason to run hists_compute_resort() using output tree.
Convert it to use internal tree so that it can remove unnecessary
_output_resort.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1355128197-18193-4-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-diff.c | 31 +++++++++++++++++++++----------
 tools/perf/util/hist.c    |  2 +-
 tools/perf/util/hist.h    |  1 +
 3 files changed, 23 insertions(+), 11 deletions(-)

diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 8b896f5..4af0b58 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -414,19 +414,30 @@ static void insert_hist_entry_by_compute(struct rb_root *root,
 
 static void hists__compute_resort(struct hists *hists)
 {
-	struct rb_root tmp = RB_ROOT;
-	struct rb_node *next = rb_first(&hists->entries);
+	struct rb_root *root;
+	struct rb_node *next;
+
+	if (sort__need_collapse)
+		root = &hists->entries_collapsed;
+	else
+		root = hists->entries_in;
+
+	hists->entries = RB_ROOT;
+	next = rb_first(root);
+
+	hists->nr_entries = 0;
+	hists->stats.total_period = 0;
+	hists__reset_col_len(hists);
 
 	while (next != NULL) {
-		struct hist_entry *he = rb_entry(next, struct hist_entry, rb_node);
+		struct hist_entry *he;
 
-		next = rb_next(&he->rb_node);
+		he = rb_entry(next, struct hist_entry, rb_node_in);
+		next = rb_next(&he->rb_node_in);
 
-		rb_erase(&he->rb_node, &hists->entries);
-		insert_hist_entry_by_compute(&tmp, he, compute);
+		insert_hist_entry_by_compute(&hists->entries, he, compute);
+		hists__inc_nr_entries(hists, he);
 	}
-
-	hists->entries = tmp;
 }
 
 static void hists__process(struct hists *old, struct hists *new)
@@ -438,11 +449,11 @@ static void hists__process(struct hists *old, struct hists *new)
 	else
 		hists__link(new, old);
 
-	hists__output_resort(new);
-
 	if (sort_compute) {
 		hists__precompute(new);
 		hists__compute_resort(new);
+	} else {
+		hists__output_resort(new);
 	}
 
 	hists__fprintf(new, true, 0, 0, stdout);
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 8ff3c2f..37179af 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -251,7 +251,7 @@ static struct hist_entry *hist_entry__new(struct hist_entry *template)
 	return he;
 }
 
-static void hists__inc_nr_entries(struct hists *hists, struct hist_entry *h)
+void hists__inc_nr_entries(struct hists *hists, struct hist_entry *h)
 {
 	if (!h->filtered) {
 		hists__calc_col_len(hists, h);
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 5b3b007..d3664ab 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -96,6 +96,7 @@ void hists__decay_entries_threaded(struct hists *hists, bool zap_user,
 				   bool zap_kernel);
 void hists__output_recalc_col_len(struct hists *hists, int max_rows);
 
+void hists__inc_nr_entries(struct hists *hists, struct hist_entry *h);
 void hists__inc_nr_events(struct hists *self, u32 type);
 size_t hists__fprintf_nr_events(struct hists *self, FILE *fp);
 
-- 
1.8.1.1.361.gec3ae6e

