Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489AbaELGag (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 02:30:36 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:57634 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753009AbaELG3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 02:29:07 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, Don Zickus <dzickus@redhat.com>
Subject: [PATCH 18/20] perf tools: Introduce reset_output_field()
Date: Mon, 12 May 2014 15:28:51 +0900
Message-Id: <1399876133-17963-19-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1399876133-17963-1-git-send-email-namhyung@kernel.org>
References: <1399876133-17963-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The reset_output_field() function is for clearing output field
settings and will be used for test code in later patch.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/hist.c   | 17 +++++++++++++++++
 tools/perf/util/hist.h |  7 +++++++
 tools/perf/util/sort.c | 18 ++++++++++++++++++
 tools/perf/util/sort.h |  1 +
 4 files changed, 43 insertions(+)

diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index f51cba43e9e7..265c8a17c4ca 100644
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
 int hist_entry__sort_snprintf(struct hist_entry *he, char *s, size_t size,
 			      struct hists *hists)
 {
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
index d4502db36cba..aa52066b9a74 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -1540,3 +1540,21 @@ out:
 
 	return ret;
 }
+
+void reset_output_field(void)
+{
+	struct sort_entry *pos, *tmp;
+
+	sort__need_collapse = 0;
+	sort__has_parent = 0;
+	sort__has_sym = 0;
+	sort__has_dso = 0;
+
+	sort__first_dimension = 0;
+
+	list_for_each_entry_safe(pos, tmp, &hist_entry__sort_list, list)
+		list_del_init(&pos->list);
+
+	reset_dimensions();
+	perf_hpp__reset_output_field();
+}
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index cd679a56c81d..f7acf9dedf57 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -193,6 +193,7 @@ extern struct list_head hist_entry__sort_list;
 
 int setup_sorting(void);
 int setup_output_field(void);
+void reset_output_field(void);
 extern int sort_dimension__add(const char *);
 void sort__setup_elide(FILE *fp);
 
-- 
1.9.2

