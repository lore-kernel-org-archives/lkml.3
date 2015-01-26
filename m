Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756831AbbAZRsp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 12:48:45 -0500
Received: from mail.kernel.org ([198.145.29.136]:53045 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755273AbbAZRsj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 12:48:39 -0500
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Kan Liang <kan.liang@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 16/26] perf tools: Pass struct perf_hpp_fmt to its callbacks
Date: Mon, 26 Jan 2015 14:47:19 -0300
Message-Id: <1422294449-12735-17-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1422294449-12735-1-git-send-email-acme@kernel.org>
References: <1422294449-12735-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

Currently ->cmp, ->collapse and ->sort callbacks doesn't pass
corresponding fmt.  But it'll be needed by upcoming changes in
perf diff command.

Suggested-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Kan Liang <kan.liang@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1420677949-6719-6-git-send-email-namhyung@kernel.org
[ fix build by passing perf_hpp_fmt pointer to hist_entry__cmp_ methods ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-diff.c | 15 ++++++++++-----
 tools/perf/ui/hist.c      | 12 ++++++++----
 tools/perf/util/hist.c    |  6 +++---
 tools/perf/util/hist.h    |  9 ++++++---
 tools/perf/util/sort.c    | 37 ++++++++++++++++++++++++++++++++++---
 5 files changed, 61 insertions(+), 18 deletions(-)

diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index ae8f62151b34..4816989a84b0 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -554,14 +554,16 @@ hist_entry__cmp_compute(struct hist_entry *left, struct hist_entry *right,
 }
 
 static int64_t
-hist_entry__cmp_nop(struct hist_entry *left __maybe_unused,
+hist_entry__cmp_nop(struct perf_hpp_fmt *fmt __maybe_unused,
+		    struct hist_entry *left __maybe_unused,
 		    struct hist_entry *right __maybe_unused)
 {
 	return 0;
 }
 
 static int64_t
-hist_entry__cmp_baseline(struct hist_entry *left, struct hist_entry *right)
+hist_entry__cmp_baseline(struct perf_hpp_fmt *fmt __maybe_unused,
+			 struct hist_entry *left, struct hist_entry *right)
 {
 	if (sort_compute)
 		return 0;
@@ -572,19 +574,22 @@ hist_entry__cmp_baseline(struct hist_entry *left, struct hist_entry *right)
 }
 
 static int64_t
-hist_entry__cmp_delta(struct hist_entry *left, struct hist_entry *right)
+hist_entry__cmp_delta(struct perf_hpp_fmt *fmt __maybe_unused,
+		      struct hist_entry *left, struct hist_entry *right)
 {
 	return hist_entry__cmp_compute(right, left, COMPUTE_DELTA);
 }
 
 static int64_t
-hist_entry__cmp_ratio(struct hist_entry *left, struct hist_entry *right)
+hist_entry__cmp_ratio(struct perf_hpp_fmt *fmt __maybe_unused,
+		      struct hist_entry *left, struct hist_entry *right)
 {
 	return hist_entry__cmp_compute(right, left, COMPUTE_RATIO);
 }
 
 static int64_t
-hist_entry__cmp_wdiff(struct hist_entry *left, struct hist_entry *right)
+hist_entry__cmp_wdiff(struct perf_hpp_fmt *fmt __maybe_unused,
+		      struct hist_entry *left, struct hist_entry *right)
 {
 	return hist_entry__cmp_compute(right, left, COMPUTE_WEIGHTED_DIFF);
 }
diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index 482adae3cc44..25d608394d74 100644
--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -285,7 +285,8 @@ static int hpp__entry_##_type(struct perf_hpp_fmt *fmt,				\
 }
 
 #define __HPP_SORT_FN(_type, _field)						\
-static int64_t hpp__sort_##_type(struct hist_entry *a, struct hist_entry *b)	\
+static int64_t hpp__sort_##_type(struct perf_hpp_fmt *fmt __maybe_unused, 	\
+				 struct hist_entry *a, struct hist_entry *b) 	\
 {										\
 	return __hpp__sort(a, b, he_get_##_field);				\
 }
@@ -312,7 +313,8 @@ static int hpp__entry_##_type(struct perf_hpp_fmt *fmt,				\
 }
 
 #define __HPP_SORT_ACC_FN(_type, _field)					\
-static int64_t hpp__sort_##_type(struct hist_entry *a, struct hist_entry *b)	\
+static int64_t hpp__sort_##_type(struct perf_hpp_fmt *fmt __maybe_unused, 	\
+				 struct hist_entry *a, struct hist_entry *b) 	\
 {										\
 	return __hpp__sort_acc(a, b, he_get_acc_##_field);			\
 }
@@ -331,7 +333,8 @@ static int hpp__entry_##_type(struct perf_hpp_fmt *fmt,				\
 }
 
 #define __HPP_SORT_RAW_FN(_type, _field)					\
-static int64_t hpp__sort_##_type(struct hist_entry *a, struct hist_entry *b)	\
+static int64_t hpp__sort_##_type(struct perf_hpp_fmt *fmt __maybe_unused, 	\
+				 struct hist_entry *a, struct hist_entry *b) 	\
 {										\
 	return __hpp__sort(a, b, he_get_raw_##_field);				\
 }
@@ -361,7 +364,8 @@ HPP_PERCENT_ACC_FNS(overhead_acc, period)
 HPP_RAW_FNS(samples, nr_events)
 HPP_RAW_FNS(period, period)
 
-static int64_t hpp__nop_cmp(struct hist_entry *a __maybe_unused,
+static int64_t hpp__nop_cmp(struct perf_hpp_fmt *fmt __maybe_unused,
+			    struct hist_entry *a __maybe_unused,
 			    struct hist_entry *b __maybe_unused)
 {
 	return 0;
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index e17163fcb702..70b48a65064c 100644
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
@@ -1061,7 +1061,7 @@ static int hist_entry__sort(struct hist_entry *a, struct hist_entry *b)
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
1.9.3

