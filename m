Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753114AbaDPDF7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 23:05:59 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:59912 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752656AbaDPDF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 23:05:56 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, Don Zickus <dzickus@redhat.com>
Subject: [PATCH 02/17] perf tools: Convert sort entries to hpp formats
Date: Wed, 16 Apr 2014 12:05:39 +0900
Message-Id: <1397617554-26319-3-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1397617554-26319-1-git-send-email-namhyung@kernel.org>
References: <1397617554-26319-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a preparation of consolidating management of output field and
sort keys.

Acked-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/hist.c   |  6 ++++
 tools/perf/util/hist.h |  6 ++++
 tools/perf/util/sort.c | 80 +++++++++++++++++++++++++++++++++++++++++++++++---
 3 files changed, 88 insertions(+), 4 deletions(-)

diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index d4a4f2e7eb43..a6eea666b443 100644
--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -284,6 +284,7 @@ struct perf_hpp_fmt perf_hpp__format[] = {
 };
 
 LIST_HEAD(perf_hpp__list);
+LIST_HEAD(perf_hpp__sort_list);
 
 
 #undef HPP__COLOR_PRINT_FNS
@@ -325,6 +326,11 @@ void perf_hpp__column_register(struct perf_hpp_fmt *format)
 	list_add_tail(&format->list, &perf_hpp__list);
 }
 
+void perf_hpp__register_sort_field(struct perf_hpp_fmt *format)
+{
+	list_add_tail(&format->sort_list, &perf_hpp__sort_list);
+}
+
 void perf_hpp__column_enable(unsigned col)
 {
 	BUG_ON(col >= PERF_HPP__MAX_INDEX);
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 9ef3b3a75f03..0f8d46803c92 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -158,13 +158,18 @@ struct perf_hpp_fmt {
 	int64_t (*sort)(struct hist_entry *a, struct hist_entry *b);
 
 	struct list_head list;
+	struct list_head sort_list;
 };
 
 extern struct list_head perf_hpp__list;
+extern struct list_head perf_hpp__sort_list;
 
 #define perf_hpp__for_each_format(format) \
 	list_for_each_entry(format, &perf_hpp__list, list)
 
+#define perf_hpp__for_each_sort_list(format) \
+	list_for_each_entry(format, &perf_hpp__sort_list, sort_list)
+
 extern struct perf_hpp_fmt perf_hpp__format[];
 
 enum {
@@ -183,6 +188,7 @@ enum {
 void perf_hpp__init(void);
 void perf_hpp__column_register(struct perf_hpp_fmt *format);
 void perf_hpp__column_enable(unsigned col);
+void perf_hpp__register_sort_field(struct perf_hpp_fmt *format);
 
 typedef u64 (*hpp_field_fn)(struct hist_entry *he);
 typedef int (*hpp_callback_fn)(struct perf_hpp *hpp, bool front);
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 635cd8f8b22e..b2829f947053 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -2,6 +2,7 @@
 #include "hist.h"
 #include "comm.h"
 #include "symbol.h"
+#include "evsel.h"
 
 regex_t		parent_regex;
 const char	default_parent_pattern[] = "^sys_|^do_page_fault";
@@ -1027,10 +1028,80 @@ static struct sort_dimension memory_sort_dimensions[] = {
 
 #undef DIM
 
-static void __sort_dimension__add(struct sort_dimension *sd, enum sort_type idx)
+struct hpp_sort_entry {
+	struct perf_hpp_fmt hpp;
+	struct sort_entry *se;
+};
+
+static int __sort__hpp_header(struct perf_hpp_fmt *fmt, struct perf_hpp *hpp,
+			      struct perf_evsel *evsel)
+{
+	struct hpp_sort_entry *hse;
+	size_t len;
+
+	hse = container_of(fmt, struct hpp_sort_entry, hpp);
+	len = hists__col_len(&evsel->hists, hse->se->se_width_idx);
+
+	return scnprintf(hpp->buf, hpp->size, "%*s", len, hse->se->se_header);
+}
+
+static int __sort__hpp_width(struct perf_hpp_fmt *fmt,
+			     struct perf_hpp *hpp __maybe_unused,
+			     struct perf_evsel *evsel)
+{
+	struct hpp_sort_entry *hse;
+
+	hse = container_of(fmt, struct hpp_sort_entry, hpp);
+
+	return hists__col_len(&evsel->hists, hse->se->se_width_idx);
+}
+
+static int __sort__hpp_entry(struct perf_hpp_fmt *fmt, struct perf_hpp *hpp,
+			     struct hist_entry *he)
+{
+	struct hpp_sort_entry *hse;
+	size_t len;
+
+	hse = container_of(fmt, struct hpp_sort_entry, hpp);
+	len = hists__col_len(he->hists, hse->se->se_width_idx);
+
+	return hse->se->se_snprintf(he, hpp->buf, hpp->size, len);
+}
+
+static int __sort_dimension__add_hpp(struct sort_dimension *sd)
+{
+	struct hpp_sort_entry *hse;
+
+	hse = malloc(sizeof(*hse));
+	if (hse == NULL) {
+		pr_err("Memory allocation failed\n");
+		return -1;
+	}
+
+	hse->se = sd->entry;
+	hse->hpp.header = __sort__hpp_header;
+	hse->hpp.width = __sort__hpp_width;
+	hse->hpp.entry = __sort__hpp_entry;
+	hse->hpp.color = NULL;
+
+	hse->hpp.cmp = sd->entry->se_cmp;
+	hse->hpp.collapse = sd->entry->se_collapse ? : sd->entry->se_cmp;
+	hse->hpp.sort = hse->hpp.collapse;
+
+	INIT_LIST_HEAD(&hse->hpp.list);
+	INIT_LIST_HEAD(&hse->hpp.sort_list);
+
+	perf_hpp__register_sort_field(&hse->hpp);
+	return 0;
+}
+
+static int __sort_dimension__add(struct sort_dimension *sd, enum sort_type idx)
 {
 	if (sd->taken)
-		return;
+		return 0;
+
+	if (__sort_dimension__add_hpp(sd) < 0)
+		return -1;
 
 	if (sd->entry->se_collapse)
 		sort__need_collapse = 1;
@@ -1040,6 +1111,8 @@ static void __sort_dimension__add(struct sort_dimension *sd, enum sort_type idx)
 
 	list_add_tail(&sd->entry->list, &hist_entry__sort_list);
 	sd->taken = 1;
+
+	return 0;
 }
 
 int sort_dimension__add(const char *tok)
@@ -1068,8 +1141,7 @@ int sort_dimension__add(const char *tok)
 			sort__has_dso = 1;
 		}
 
-		__sort_dimension__add(sd, i);
-		return 0;
+		return __sort_dimension__add(sd, i);
 	}
 
 	for (i = 0; i < ARRAY_SIZE(bstack_sort_dimensions); i++) {
-- 
1.9.2

