Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752690AbaEUNPW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 09:15:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35658 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752273AbaEUNNO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 09:13:14 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>
Subject: [PATCH 16/22] perf hists: Reset width of output fields with header length
Date: Wed, 21 May 2014 15:12:38 +0200
Message-Id: <1400677964-25160-17-git-send-email-jolsa@kernel.org>
In-Reply-To: <1400677964-25160-1-git-send-email-jolsa@kernel.org>
References: <1400677964-25160-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

Some fields missed to set default column length so it broke align in
--stdio output.  Add perf_hpp__reset_width() to set it to a sane
default value.

Note that this change will ignore -w/--column-widths option for now.

Before:
  $ perf report -F cpu,comm,overhead --stdio
  ...
  # CPU          Command  Overhead
  #   ...............  ........
  #
    0          firefox     2.65%
    0      kworker/0:0     1.45%
    0          swapper     5.52%
    0         synergys     0.92%
    1          firefox     4.54%

After:
  # CPU          Command  Overhead
  # ...  ...............  ........
  #
      0          firefox     2.65%
      0      kworker/0:0     1.45%
      0          swapper     5.52%
      0         synergys     0.92%
      1          firefox     4.54%

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/r/1400480762-22852-17-git-send-email-namhyung@kernel.org
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/ui/stdio/hist.c | 21 +++------------------
 tools/perf/util/hist.h     |  1 +
 tools/perf/util/sort.c     | 12 ++++++++++++
 3 files changed, 16 insertions(+), 18 deletions(-)

diff --git a/tools/perf/ui/stdio/hist.c b/tools/perf/ui/stdio/hist.c
index e3fdf4e..cfcd3f6 100644
--- a/tools/perf/ui/stdio/hist.c
+++ b/tools/perf/ui/stdio/hist.c
@@ -369,12 +369,10 @@ size_t hists__fprintf(struct hists *hists, bool show_header, int max_rows,
 		      int max_cols, float min_pcnt, FILE *fp)
 {
 	struct perf_hpp_fmt *fmt;
-	struct sort_entry *se;
 	struct rb_node *nd;
 	size_t ret = 0;
 	unsigned int width;
 	const char *sep = symbol_conf.field_sep;
-	const char *col_width = symbol_conf.col_width_list_str;
 	int nr_rows = 0;
 	char bf[96];
 	struct perf_hpp dummy_hpp = {
@@ -387,22 +385,9 @@ size_t hists__fprintf(struct hists *hists, bool show_header, int max_rows,
 
 	init_rem_hits();
 
-	list_for_each_entry(se, &hist_entry__sort_list, list) {
-		if (se->elide)
-			continue;
-		width = strlen(se->se_header);
-		if (symbol_conf.col_width_list_str) {
-			if (col_width) {
-				hists__set_col_len(hists, se->se_width_idx,
-						   atoi(col_width));
-				col_width = strchr(col_width, ',');
-				if (col_width)
-					++col_width;
-			}
-		}
-		if (!hists__new_col_len(hists, se->se_width_idx, width))
-			width = hists__col_len(hists, se->se_width_idx);
-	}
+
+	perf_hpp__for_each_format(fmt)
+		perf_hpp__reset_width(fmt, hists);
 
 	if (!show_header)
 		goto print_entries;
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index f67feb4..034db76 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -202,6 +202,7 @@ void perf_hpp__append_sort_keys(void);
 bool perf_hpp__is_sort_entry(struct perf_hpp_fmt *format);
 bool perf_hpp__same_sort_entry(struct perf_hpp_fmt *a, struct perf_hpp_fmt *b);
 bool perf_hpp__should_skip(struct perf_hpp_fmt *format);
+void perf_hpp__reset_width(struct perf_hpp_fmt *fmt, struct hists *hists);
 
 typedef u64 (*hpp_field_fn)(struct hist_entry *he);
 typedef int (*hpp_callback_fn)(struct perf_hpp *hpp, bool front);
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 0fe7cbe..9bee728 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -1089,6 +1089,18 @@ bool perf_hpp__same_sort_entry(struct perf_hpp_fmt *a, struct perf_hpp_fmt *b)
 	return hse_a->se == hse_b->se;
 }
 
+void perf_hpp__reset_width(struct perf_hpp_fmt *fmt, struct hists *hists)
+{
+	struct hpp_sort_entry *hse;
+
+	if (!perf_hpp__is_sort_entry(fmt))
+		return;
+
+	hse = container_of(fmt, struct hpp_sort_entry, hpp);
+	hists__new_col_len(hists, hse->se->se_width_idx,
+			   strlen(hse->se->se_header));
+}
+
 static int __sort__hpp_header(struct perf_hpp_fmt *fmt, struct perf_hpp *hpp,
 			      struct perf_evsel *evsel)
 {
-- 
1.8.3.1

