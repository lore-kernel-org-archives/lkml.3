Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753306AbaESG3k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 02:29:40 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:59715 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011AbaESG0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 02:26:10 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, Don Zickus <dzickus@rehdat.com>
Subject: [PATCH 18/20] perf tools: Introduce reset_output_field()
Date: Mon, 19 May 2014 15:26:00 +0900
Message-Id: <1400480762-22852-19-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1400480762-22852-1-git-send-email-namhyung@kernel.org>
References: <1400480762-22852-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The reset_output_field() function is for clearing output field
settings and will be used for test code in later patch.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/hist.c   | 17 +++++++++++++++++
 tools/perf/util/hist.h |  7 +++++++
 tools/perf/util/sort.c | 11 +++++++++++
 tools/perf/util/sort.h |  1 +
 4 files changed, 36 insertions(+)

diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index 61cf31e094f3..4484f5bd1b14 100644
--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -459,6 +459,23 @@ next:
 	}
 }
 
+void perf_hpp__reset_output_field(void)
+{
+	struct perf_hpp_fmt *fmt, *tmp;
+
+	/* reset output fields */
+	perf_hpp__for_each_format_safe(fmt, tmp) {
+		list_del_init(&fmt->list);
+		list_del_init(&fmt->sort_list);
+	}
+
+	/* reset sort keys */
+	perf_hpp__for_each_sort_list_safe(fmt, tmp) {
+		list_del_init(&fmt->list);
+		list_del_init(&fmt->sort_list);
+	}
+}
+
 /*
  * See hists__fprintf to match the column widths
  */
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 034db761630e..a8418d19808d 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -174,9 +174,15 @@ extern struct list_head perf_hpp__sort_list;
 #define perf_hpp__for_each_format(format) \
 	list_for_each_entry(format, &perf_hpp__list, list)
 
+#define perf_hpp__for_each_format_safe(format, tmp)	\
+	list_for_each_entry_safe(format, tmp, &perf_hpp__list, list)
+
 #define perf_hpp__for_each_sort_list(format) \
 	list_for_each_entry(format, &perf_hpp__sort_list, sort_list)
 
+#define perf_hpp__for_each_sort_list_safe(format, tmp)	\
+	list_for_each_entry_safe(format, tmp, &perf_hpp__sort_list, sort_list)
+
 extern struct perf_hpp_fmt perf_hpp__format[];
 
 enum {
@@ -197,6 +203,7 @@ void perf_hpp__column_register(struct perf_hpp_fmt *format);
 void perf_hpp__column_enable(unsigned col);
 void perf_hpp__register_sort_field(struct perf_hpp_fmt *format);
 void perf_hpp__setup_output_field(void);
+void perf_hpp__reset_output_field(void);
 void perf_hpp__append_sort_keys(void);
 
 bool perf_hpp__is_sort_entry(struct perf_hpp_fmt *format);
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index d9132069d3b1..901b9bece2ee 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -1573,3 +1573,14 @@ int setup_sorting(void)
 
 	return 0;
 }
+
+void reset_output_field(void)
+{
+	sort__need_collapse = 0;
+	sort__has_parent = 0;
+	sort__has_sym = 0;
+	sort__has_dso = 0;
+
+	reset_dimensions();
+	perf_hpp__reset_output_field();
+}
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index f5a831c3d0fb..5f38d925e92f 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -194,6 +194,7 @@ extern struct list_head hist_entry__sort_list;
 
 int setup_sorting(void);
 int setup_output_field(void);
+void reset_output_field(void);
 extern int sort_dimension__add(const char *);
 void sort__setup_elide(FILE *fp);
 
-- 
1.9.2

