Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854AbaEVMVD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 08:21:03 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50938 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752617AbaEVMVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 08:21:01 -0400
Date: Thu, 22 May 2014 05:20:39 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-8b536999cd75e565125c74b2cf2a746d4f053a92@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jolsa@kernel.org, tglx@linutronix.de, namhyung@kernel.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jolsa@kernel.org, tglx@linutronix.de, namhyung@kernel.org
In-Reply-To: <1400480762-22852-3-git-send-email-namhyung@kernel.org>
References: <1400480762-22852-3-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Convert sort entries to hpp formats
Git-Commit-ID: 8b536999cd75e565125c74b2cf2a746d4f053a92
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8b536999cd75e565125c74b2cf2a746d4f053a92
Gitweb:     http://git.kernel.org/tip/8b536999cd75e565125c74b2cf2a746d4f053a92
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Mon, 3 Mar 2014 11:46:55 +0900
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Wed, 21 May 2014 11:45:34 +0200

perf tools: Convert sort entries to hpp formats

This is a preparation of consolidating management of output field and
sort keys.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Ingo Molnar <mingo@kernel.org>
Link: http://lkml.kernel.org/r/1400480762-22852-3-git-send-email-namhyung@kernel.org
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/ui/hist.c   |  6 ++++
 tools/perf/util/hist.h |  6 ++++
 tools/perf/util/sort.c | 80 +++++++++++++++++++++++++++++++++++++++++++++++---
 3 files changed, 88 insertions(+), 4 deletions(-)

diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index d4a4f2e..a6eea66 100644
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
index 36dbe00..eee154a 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -165,13 +165,18 @@ struct perf_hpp_fmt {
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
@@ -190,6 +195,7 @@ enum {
 void perf_hpp__init(void);
 void perf_hpp__column_register(struct perf_hpp_fmt *format);
 void perf_hpp__column_enable(unsigned col);
+void perf_hpp__register_sort_field(struct perf_hpp_fmt *format);
 
 typedef u64 (*hpp_field_fn)(struct hist_entry *he);
 typedef int (*hpp_callback_fn)(struct perf_hpp *hpp, bool front);
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 635cd8f..b2829f9 100644
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
