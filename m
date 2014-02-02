Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310AbaBBVoO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 16:44:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3850 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752869AbaBBVka (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 16:40:30 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 18/22] perf tools: Factor sort entries loops
Date: Sun,  2 Feb 2014 22:39:06 +0100
Message-Id: <1391377150-23920-19-git-send-email-jolsa@redhat.com>
In-Reply-To: <1391377150-23920-1-git-send-email-jolsa@redhat.com>
References: <1391377150-23920-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Factoring sort entries loops so we could transparently
iterate over hists' specific list of sort entries.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
---
 tools/perf/ui/browsers/hists.c |  2 +-
 tools/perf/ui/gtk/hists.c      |  6 +++---
 tools/perf/ui/hist.c           |  5 +++--
 tools/perf/ui/stdio/hist.c     |  4 ++--
 tools/perf/util/hist.c         |  4 ++--
 tools/perf/util/sort.c         | 17 +++++++++++++++++
 tools/perf/util/sort.h         |  5 +++++
 7 files changed, 33 insertions(+), 10 deletions(-)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index 1d519e9..852aee7 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -342,7 +342,7 @@ static size_t scnprintf_header_se(struct hists *hists, char *buf, size_t size)
 	unsigned int width;
 	int ret = 0;
 
-	list_for_each_entry(se, &hist_entry__sort_list, list) {
+	hists__for_each_se(hists, se) {
 		if (se->elide)
 			continue;
 
diff --git a/tools/perf/ui/gtk/hists.c b/tools/perf/ui/gtk/hists.c
index bd9a491..cafc4b0 100644
--- a/tools/perf/ui/gtk/hists.c
+++ b/tools/perf/ui/gtk/hists.c
@@ -240,7 +240,7 @@ static void perf_gtk__show_hists(GtkWidget *window, struct hists *hists,
 	perf_hpp__for_each_format(fmt)
 		col_types[nr_cols++] = G_TYPE_STRING;
 
-	list_for_each_entry(se, &hist_entry__sort_list, list) {
+	hists__for_each_se(hists, se) {
 		if (se->elide)
 			continue;
 
@@ -267,7 +267,7 @@ static void perf_gtk__show_hists(GtkWidget *window, struct hists *hists,
 							    col_idx++, NULL);
 	}
 
-	list_for_each_entry(se, &hist_entry__sort_list, list) {
+	hists__for_each_se(hists, se) {
 		if (se->elide)
 			continue;
 
@@ -318,7 +318,7 @@ static void perf_gtk__show_hists(GtkWidget *window, struct hists *hists,
 			gtk_tree_store_set(store, &iter, col_idx++, s, -1);
 		}
 
-		list_for_each_entry(se, &hist_entry__sort_list, list) {
+		hists__for_each_se(hists, se) {
 			if (se->elide)
 				continue;
 
diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index 430c4ea..6bd2136 100644
--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -306,7 +306,7 @@ int hist_entry__sort_snprintf(struct hist_entry *he, bool selected,
 	struct sort_entry *se;
 	int ret = 0;
 
-	list_for_each_entry(se, &hist_entry__sort_list, list) {
+	hists__for_each_se(he->hists, se) {
 		if (se->elide)
 			continue;
 
@@ -337,9 +337,10 @@ unsigned int hists__sort_list_width(struct hists *hists)
 		ret += fmt->width(fmt, &dummy_hpp);
 	}
 
-	list_for_each_entry(se, &hist_entry__sort_list, list)
+	hists__for_each_se(hists, se) {
 		if (!se->elide)
 			ret += 2 + hists__col_len(hists, se->se_width_idx);
+	}
 
 	if (verbose) /* Addr + origin */
 		ret += 3 + BITS_PER_LONG / 4;
diff --git a/tools/perf/ui/stdio/hist.c b/tools/perf/ui/stdio/hist.c
index ab6f4d6..d13fc99 100644
--- a/tools/perf/ui/stdio/hist.c
+++ b/tools/perf/ui/stdio/hist.c
@@ -408,7 +408,7 @@ size_t hists__fprintf(struct hists *hists, bool show_header, int max_rows,
 		fprintf(fp, "%s", bf);
 	}
 
-	list_for_each_entry(se, &hist_entry__sort_list, list) {
+	hists__for_each_se(hists, se) {
 		if (se->elide)
 			continue;
 		if (sep) {
@@ -454,7 +454,7 @@ size_t hists__fprintf(struct hists *hists, bool show_header, int max_rows,
 			fprintf(fp, ".");
 	}
 
-	list_for_each_entry(se, &hist_entry__sort_list, list) {
+	hists__for_each_se(hists, se) {
 		unsigned int i;
 
 		if (se->elide)
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 164d20d..92c3d76 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -915,7 +915,7 @@ hist_entry__cmp(struct hist_entry *left, struct hist_entry *right)
 	struct sort_entry *se;
 	int64_t cmp = 0;
 
-	list_for_each_entry(se, &hist_entry__sort_list, list) {
+	hists__for_each_se(left->hists, se) {
 		cmp = se->se_cmp(se, left, right);
 		if (cmp)
 			break;
@@ -930,7 +930,7 @@ hist_entry__collapse(struct hist_entry *left, struct hist_entry *right)
 	struct sort_entry *se;
 	int64_t cmp = 0;
 
-	list_for_each_entry(se, &hist_entry__sort_list, list) {
+	hists__for_each_se(left->hists, se) {
 		int64_t (*f)(struct sort_entry *, struct hist_entry *,
 			     struct hist_entry *);
 
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 381139d..42e6038 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -1381,3 +1381,20 @@ void sort__setup_list(void)
 
 	sd_idx->entry->elide = true;
 }
+
+bool hists__next_se(struct hists *hists __maybe_unused, struct sort_entry **sep)
+{
+	struct list_head *head_global = &hist_entry__sort_list;
+	struct sort_entry *se = *sep;
+
+	if (!se) {
+		se = list_first_entry(head_global, struct sort_entry, list);
+	} else {
+		if (list_is_last(&se->list, head_global))
+			se = NULL;
+		else
+			se = list_next_entry(se, list);
+	}
+
+	return se ? (*sep = se) : false;
+}
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index 0b992fd..f0d501e 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -218,4 +218,9 @@ void sort__setup_list(void);
 
 int report_parse_ignore_callees_opt(const struct option *opt, const char *arg, int unset);
 
+bool hists__next_se(struct hists *hists, struct sort_entry **sep);
+
+#define hists__for_each_se(hists, se) \
+	for (se = NULL; hists__next_se(hists, &se);)
+
 #endif	/* __PERF_SORT_H */
-- 
1.8.3.1

