Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752652AbaEUNOw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 09:14:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64765 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752381AbaEUNNP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 09:13:15 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>
Subject: [PATCH 17/22] perf tools: Get rid of obsolete hist_entry__sort_list
Date: Wed, 21 May 2014 15:12:39 +0200
Message-Id: <1400677964-25160-18-git-send-email-jolsa@kernel.org>
In-Reply-To: <1400677964-25160-1-git-send-email-jolsa@kernel.org>
References: <1400677964-25160-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

Now we moved to the perf_hpp_[_sort]_list so no need to keep the old
hist_entry__sort_list and sort__first_dimension.  Also the
hist_entry__sort_snprintf() can be gone as hist_entry__snprintf()
provides the functionality.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/r/1400480762-22852-18-git-send-email-namhyung@kernel.org
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/ui/hist.c       | 36 +++++++++---------------------------
 tools/perf/ui/stdio/hist.c | 22 +++++++++++++++-------
 tools/perf/util/sort.c     | 35 +++++++++++++++++++----------------
 3 files changed, 43 insertions(+), 50 deletions(-)

diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index b114c66..61cf31e 100644
--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -459,47 +459,29 @@ next:
 	}
 }
 
-int hist_entry__sort_snprintf(struct hist_entry *he, char *s, size_t size,
-			      struct hists *hists)
-{
-	const char *sep = symbol_conf.field_sep;
-	struct sort_entry *se;
-	int ret = 0;
-
-	list_for_each_entry(se, &hist_entry__sort_list, list) {
-		if (se->elide)
-			continue;
-
-		ret += scnprintf(s + ret, size - ret, "%s", sep ?: "  ");
-		ret += se->se_snprintf(he, s + ret, size - ret,
-				       hists__col_len(hists, se->se_width_idx));
-	}
-
-	return ret;
-}
-
 /*
  * See hists__fprintf to match the column widths
  */
 unsigned int hists__sort_list_width(struct hists *hists)
 {
 	struct perf_hpp_fmt *fmt;
-	struct sort_entry *se;
-	int i = 0, ret = 0;
+	int ret = 0;
+	bool first = true;
 	struct perf_hpp dummy_hpp;
 
 	perf_hpp__for_each_format(fmt) {
-		if (i)
+		if (perf_hpp__should_skip(fmt))
+			continue;
+
+		if (first)
+			first = false;
+		else
 			ret += 2;
 
 		ret += fmt->width(fmt, &dummy_hpp, hists_to_evsel(hists));
 	}
 
-	list_for_each_entry(se, &hist_entry__sort_list, list)
-		if (!se->elide)
-			ret += 2 + hists__col_len(hists, se->se_width_idx);
-
-	if (verbose) /* Addr + origin */
+	if (verbose && sort__has_sym) /* Addr + origin */
 		ret += 3 + BITS_PER_LONG / 4;
 
 	return ret;
diff --git a/tools/perf/ui/stdio/hist.c b/tools/perf/ui/stdio/hist.c
index cfcd3f6..9f57991 100644
--- a/tools/perf/ui/stdio/hist.c
+++ b/tools/perf/ui/stdio/hist.c
@@ -183,7 +183,8 @@ static size_t callchain__fprintf_graph(FILE *fp, struct rb_root *root,
 			 * the symbol. No need to print it otherwise it appears as
 			 * displayed twice.
 			 */
-			if (!i++ && sort__first_dimension == SORT_SYM)
+			if (!i++ && field_order == NULL &&
+			    sort_order && !prefixcmp(sort_order, "sym"))
 				continue;
 			if (!printed) {
 				ret += callchain__fprintf_left_margin(fp, left_margin);
@@ -296,13 +297,20 @@ static size_t hist_entry__callchain_fprintf(struct hist_entry *he,
 	int left_margin = 0;
 	u64 total_period = hists->stats.total_period;
 
-	if (sort__first_dimension == SORT_COMM) {
-		struct sort_entry *se = list_first_entry(&hist_entry__sort_list,
-							 typeof(*se), list);
-		left_margin = hists__col_len(hists, se->se_width_idx);
-		left_margin -= thread__comm_len(he->thread);
-	}
+	if (field_order == NULL && (sort_order == NULL ||
+				    !prefixcmp(sort_order, "comm"))) {
+		struct perf_hpp_fmt *fmt;
+
+		perf_hpp__for_each_format(fmt) {
+			if (!perf_hpp__is_sort_entry(fmt))
+				continue;
 
+			/* must be 'comm' sort entry */
+			left_margin = fmt->width(fmt, NULL, hists_to_evsel(hists));
+			left_margin -= thread__comm_len(he->thread);
+			break;
+		}
+	}
 	return hist_entry_callchain__fprintf(he, total_period, left_margin, fp);
 }
 
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 9bee728..d913206 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -22,9 +22,6 @@ int		sort__has_sym = 0;
 int		sort__has_dso = 0;
 enum sort_mode	sort__mode = SORT_MODE__NORMAL;
 
-enum sort_type	sort__first_dimension;
-
-LIST_HEAD(hist_entry__sort_list);
 
 static int repsep_snprintf(char *bf, size_t size, const char *fmt, ...)
 {
@@ -1190,7 +1187,7 @@ static int __sort_dimension__add_hpp_output(struct sort_dimension *sd)
 	return 0;
 }
 
-static int __sort_dimension__add(struct sort_dimension *sd, enum sort_type idx)
+static int __sort_dimension__add(struct sort_dimension *sd)
 {
 	if (sd->taken)
 		return 0;
@@ -1201,10 +1198,6 @@ static int __sort_dimension__add(struct sort_dimension *sd, enum sort_type idx)
 	if (sd->entry->se_collapse)
 		sort__need_collapse = 1;
 
-	if (list_empty(&hist_entry__sort_list))
-		sort__first_dimension = idx;
-
-	list_add_tail(&sd->entry->list, &hist_entry__sort_list);
 	sd->taken = 1;
 
 	return 0;
@@ -1268,7 +1261,7 @@ int sort_dimension__add(const char *tok)
 			sort__has_dso = 1;
 		}
 
-		return __sort_dimension__add(sd, i);
+		return __sort_dimension__add(sd);
 	}
 
 	for (i = 0; i < ARRAY_SIZE(hpp_sort_dimensions); i++) {
@@ -1292,7 +1285,7 @@ int sort_dimension__add(const char *tok)
 		if (sd->entry == &sort_sym_from || sd->entry == &sort_sym_to)
 			sort__has_sym = 1;
 
-		__sort_dimension__add(sd, i + __SORT_BRANCH_STACK);
+		__sort_dimension__add(sd);
 		return 0;
 	}
 
@@ -1308,7 +1301,7 @@ int sort_dimension__add(const char *tok)
 		if (sd->entry == &sort_mem_daddr_sym)
 			sort__has_sym = 1;
 
-		__sort_dimension__add(sd, i + __SORT_MEMORY_MODE);
+		__sort_dimension__add(sd);
 		return 0;
 	}
 
@@ -1395,7 +1388,8 @@ static void sort_entry__setup_elide(struct sort_entry *se,
 
 void sort__setup_elide(FILE *output)
 {
-	struct sort_entry *se;
+	struct perf_hpp_fmt *fmt;
+	struct hpp_sort_entry *hse;
 
 	sort_entry__setup_elide(&sort_dso, symbol_conf.dso_list,
 				"dso", output);
@@ -1436,13 +1430,22 @@ void sort__setup_elide(FILE *output)
 	 * It makes no sense to elide all of sort entries.
 	 * Just revert them to show up again.
 	 */
-	list_for_each_entry(se, &hist_entry__sort_list, list) {
-		if (!se->elide)
+	perf_hpp__for_each_format(fmt) {
+		if (!perf_hpp__is_sort_entry(fmt))
+			continue;
+
+		hse = container_of(fmt, struct hpp_sort_entry, hpp);
+		if (!hse->se->elide)
 			return;
 	}
 
-	list_for_each_entry(se, &hist_entry__sort_list, list)
-		se->elide = false;
+	perf_hpp__for_each_format(fmt) {
+		if (!perf_hpp__is_sort_entry(fmt))
+			continue;
+
+		hse = container_of(fmt, struct hpp_sort_entry, hpp);
+		hse->se->elide = false;
+	}
 }
 
 static int output_field_add(char *tok)
-- 
1.8.3.1

