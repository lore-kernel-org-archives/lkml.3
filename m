Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932196AbbAHAsL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 19:48:11 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:42657 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932107AbbAHAsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 19:48:08 -0500
X-Original-SENDERIP: 10.177.220.203
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Kan Liang <kan.liang@intel.com>, Jiri Olsa <jolsa@kernel.org>
Subject: [PATCH 5/7] perf tools: Pass struct perf_hpp_fmt to its callbacks
Date: Thu,  8 Jan 2015 09:45:46 +0900
Message-Id: <1420677949-6719-6-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1420677949-6719-1-git-send-email-namhyung@kernel.org>
References: <1420677949-6719-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently ->cmp, ->collapse and ->sort callbacks doesn't pass
corresponding fmt.  But it'll be needed by upcoming changes in
perf diff command.

Suggested-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/hist.c   | 12 ++++++++----
 tools/perf/util/hist.c |  6 +++---
 tools/perf/util/hist.h |  9 ++++++---
 tools/perf/util/sort.c | 37 ++++++++++++++++++++++++++++++++++---
 4 files changed, 51 insertions(+), 13 deletions(-)

diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index dc0d095f318c..a2db53f44a5b 100644
--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -282,7 +282,8 @@ static int hpp__entry_##_type(struct perf_hpp_fmt *fmt,				\
 }
 
 #define __HPP_SORT_FN(_type, _field)						\
-static int64_t hpp__sort_##_type(struct hist_entry *a, struct hist_entry *b)	\
+static int64_t hpp__sort_##_type(struct perf_hpp_fmt *fmt __maybe_unused, 	\
+				 struct hist_entry *a, struct hist_entry *b) 	\
 {										\
 	return __hpp__sort(a, b, he_get_##_field);				\
 }
@@ -309,7 +310,8 @@ static int hpp__entry_##_type(struct perf_hpp_fmt *fmt,				\
 }
 
 #define __HPP_SORT_ACC_FN(_type, _field)					\
-static int64_t hpp__sort_##_type(struct hist_entry *a, struct hist_entry *b)	\
+static int64_t hpp__sort_##_type(struct perf_hpp_fmt *fmt __maybe_unused, 	\
+				 struct hist_entry *a, struct hist_entry *b) 	\
 {										\
 	return __hpp__sort_acc(a, b, he_get_acc_##_field);			\
 }
@@ -328,7 +330,8 @@ static int hpp__entry_##_type(struct perf_hpp_fmt *fmt,				\
 }
 
 #define __HPP_SORT_RAW_FN(_type, _field)					\
-static int64_t hpp__sort_##_type(struct hist_entry *a, struct hist_entry *b)	\
+static int64_t hpp__sort_##_type(struct perf_hpp_fmt *fmt __maybe_unused, 	\
+				 struct hist_entry *a, struct hist_entry *b) 	\
 {										\
 	return __hpp__sort(a, b, he_get_raw_##_field);				\
 }
@@ -358,7 +361,8 @@ HPP_PERCENT_ACC_FNS(overhead_acc, period)
 HPP_RAW_FNS(samples, nr_events)
 HPP_RAW_FNS(period, period)
 
-static int64_t hpp__nop_cmp(struct hist_entry *a __maybe_unused,
+static int64_t hpp__nop_cmp(struct perf_hpp_fmt *fmt __maybe_unused,
+			    struct hist_entry *a __maybe_unused,
 			    struct hist_entry *b __maybe_unused)
 {
 	return 0;
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 30ff2cb92884..da77d52984db 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -913,7 +913,7 @@ hist_entry__cmp(struct hist_entry *left, struct hist_entry *right)
 		if (perf_hpp__should_skip(fmt))
 			continue;
 
-		cmp = fmt->cmp(left, right);
+		cmp = fmt->cmp(fmt, left, right);
 		if (cmp)
 			break;
 	}
@@ -931,7 +931,7 @@ hist_entry__collapse(struct hist_entry *left, struct hist_entry *right)
 		if (perf_hpp__should_skip(fmt))
 			continue;
 
-		cmp = fmt->collapse(left, right);
+		cmp = fmt->collapse(fmt, left, right);
 		if (cmp)
 			break;
 	}
@@ -1060,7 +1060,7 @@ static int hist_entry__sort(struct hist_entry *a, struct hist_entry *b)
 		if (perf_hpp__should_skip(fmt))
 			continue;
 
-		cmp = fmt->sort(a, b);
+		cmp = fmt->sort(fmt, a, b);
 		if (cmp)
 			break;
 	}
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 9305580cd53e..2b690d028907 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -195,9 +195,12 @@ struct perf_hpp_fmt {
 		     struct hist_entry *he);
 	int (*entry)(struct perf_hpp_fmt *fmt, struct perf_hpp *hpp,
 		     struct hist_entry *he);
-	int64_t (*cmp)(struct hist_entry *a, struct hist_entry *b);
-	int64_t (*collapse)(struct hist_entry *a, struct hist_entry *b);
-	int64_t (*sort)(struct hist_entry *a, struct hist_entry *b);
+	int64_t (*cmp)(struct perf_hpp_fmt *fmt,
+		       struct hist_entry *a, struct hist_entry *b);
+	int64_t (*collapse)(struct perf_hpp_fmt *fmt,
+			    struct hist_entry *a, struct hist_entry *b);
+	int64_t (*sort)(struct perf_hpp_fmt *fmt,
+			struct hist_entry *a, struct hist_entry *b);
 
 	struct list_head list;
 	struct list_head sort_list;
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 9139dda9f9a3..7a39c1ed8d37 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -1304,6 +1304,37 @@ static int __sort__hpp_entry(struct perf_hpp_fmt *fmt, struct perf_hpp *hpp,
 	return hse->se->se_snprintf(he, hpp->buf, hpp->size, len);
 }
 
+static int64_t __sort__hpp_cmp(struct perf_hpp_fmt *fmt,
+			       struct hist_entry *a, struct hist_entry *b)
+{
+	struct hpp_sort_entry *hse;
+
+	hse = container_of(fmt, struct hpp_sort_entry, hpp);
+	return hse->se->se_cmp(a, b);
+}
+
+static int64_t __sort__hpp_collapse(struct perf_hpp_fmt *fmt,
+				    struct hist_entry *a, struct hist_entry *b)
+{
+	struct hpp_sort_entry *hse;
+	int64_t (*collapse_fn)(struct hist_entry *, struct hist_entry *);
+
+	hse = container_of(fmt, struct hpp_sort_entry, hpp);
+	collapse_fn = hse->se->se_collapse ?: hse->se->se_cmp;
+	return collapse_fn(a, b);
+}
+
+static int64_t __sort__hpp_sort(struct perf_hpp_fmt *fmt,
+				struct hist_entry *a, struct hist_entry *b)
+{
+	struct hpp_sort_entry *hse;
+	int64_t (*sort_fn)(struct hist_entry *, struct hist_entry *);
+
+	hse = container_of(fmt, struct hpp_sort_entry, hpp);
+	sort_fn = hse->se->se_sort ?: hse->se->se_cmp;
+	return sort_fn(a, b);
+}
+
 static struct hpp_sort_entry *
 __sort_dimension__alloc_hpp(struct sort_dimension *sd)
 {
@@ -1322,9 +1353,9 @@ __sort_dimension__alloc_hpp(struct sort_dimension *sd)
 	hse->hpp.entry = __sort__hpp_entry;
 	hse->hpp.color = NULL;
 
-	hse->hpp.cmp = sd->entry->se_cmp;
-	hse->hpp.collapse = sd->entry->se_collapse ? : sd->entry->se_cmp;
-	hse->hpp.sort = sd->entry->se_sort ? : hse->hpp.collapse;
+	hse->hpp.cmp = __sort__hpp_cmp;
+	hse->hpp.collapse = __sort__hpp_collapse;
+	hse->hpp.sort = __sort__hpp_sort;
 
 	INIT_LIST_HEAD(&hse->hpp.list);
 	INIT_LIST_HEAD(&hse->hpp.sort_list);
-- 
2.1.3

