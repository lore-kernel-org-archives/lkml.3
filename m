Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333AbaDPDGP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 23:06:15 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:60164 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753011AbaDPDF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 23:05:58 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, Don Zickus <dzickus@redhat.com>
Subject: [PATCH 17/17] perf hists: Reset width of output fields with header length
Date: Wed, 16 Apr 2014 12:05:54 +0900
Message-Id: <1397617554-26319-18-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1397617554-26319-1-git-send-email-namhyung@kernel.org>
References: <1397617554-26319-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 tools/perf/ui/stdio/hist.c | 21 +++------------------
 tools/perf/util/hist.h     |  1 +
 tools/perf/util/sort.c     | 12 ++++++++++++
 3 files changed, 16 insertions(+), 18 deletions(-)

diff --git a/tools/perf/ui/stdio/hist.c b/tools/perf/ui/stdio/hist.c
index 5ecd433bee26..a1b133fed607 100644
--- a/tools/perf/ui/stdio/hist.c
+++ b/tools/perf/ui/stdio/hist.c
@@ -370,12 +370,10 @@ size_t hists__fprintf(struct hists *hists, bool show_header, int max_rows,
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
@@ -388,22 +386,9 @@ size_t hists__fprintf(struct hists *hists, bool show_header, int max_rows,
 
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
index 826ad4b354a4..ab47e122341b 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -195,6 +195,7 @@ void perf_hpp__append_sort_keys(void);
 bool perf_hpp__is_sort_entry(struct perf_hpp_fmt *format);
 bool perf_hpp__same_sort_entry(struct perf_hpp_fmt *a, struct perf_hpp_fmt *b);
 bool perf_hpp__should_skip(struct perf_hpp_fmt *format);
+void perf_hpp__reset_width(struct perf_hpp_fmt *fmt, struct hists *hists);
 
 typedef u64 (*hpp_field_fn)(struct hist_entry *he);
 typedef int (*hpp_callback_fn)(struct perf_hpp *hpp, bool front);
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 9dc33df4f9a6..d4502db36cba 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -1088,6 +1088,18 @@ bool perf_hpp__same_sort_entry(struct perf_hpp_fmt *a, struct perf_hpp_fmt *b)
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
1.9.2

