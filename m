Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752596AbaBBVjh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 16:39:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61265 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752544AbaBBVje (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 16:39:34 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 02/22] perf tools: Add time sort entry
Date: Sun,  2 Feb 2014 22:38:50 +0100
Message-Id: <1391377150-23920-3-git-send-email-jolsa@redhat.com>
In-Reply-To: <1391377150-23920-1-git-send-email-jolsa@redhat.com>
References: <1391377150-23920-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding time sort entry. It's mainly for displaying the
time for entries for --list display in following patch.

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
 tools/perf/builtin-annotate.c |  2 +-
 tools/perf/builtin-diff.c     |  2 +-
 tools/perf/tests/hists_link.c |  4 ++--
 tools/perf/util/hist.c        | 15 ++++++++-----
 tools/perf/util/hist.h        |  4 +++-
 tools/perf/util/sort.c        | 52 +++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/sort.h        |  2 ++
 tools/perf/util/util.h        | 17 ++++++++++++++
 8 files changed, 87 insertions(+), 11 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 70b2d52..875c117 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -65,7 +65,7 @@ static int perf_evsel__add_sample(struct perf_evsel *evsel,
 		return 0;
 	}
 
-	he = __hists__add_entry(&evsel->hists, al, NULL, NULL, NULL, 1, 1, 0,
+	he = __hists__add_entry(&evsel->hists, al, NULL, NULL, NULL, 1, 1, 0, 0,
 				true);
 	if (he == NULL)
 		return -ENOMEM;
diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 93912ad..92faed5 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -308,7 +308,7 @@ static int hists__add_entry(struct hists *hists,
 			    u64 weight, u64 transaction)
 {
 	if (__hists__add_entry(hists, al, NULL, NULL, NULL, period, weight,
-			       transaction, true) != NULL)
+			       transaction, 0, true) != NULL)
 		return 0;
 	return -ENOMEM;
 }
diff --git a/tools/perf/tests/hists_link.c b/tools/perf/tests/hists_link.c
index e4e931e..e3bc8a8 100644
--- a/tools/perf/tests/hists_link.c
+++ b/tools/perf/tests/hists_link.c
@@ -223,7 +223,7 @@ static int add_hist_entries(struct perf_evlist *evlist, struct machine *machine)
 				goto out;
 
 			he = __hists__add_entry(&evsel->hists, &al, NULL,
-						NULL, NULL, 1, 1, 0, true);
+						NULL, NULL, 1, 1, 0, 0, true);
 			if (he == NULL)
 				goto out;
 
@@ -246,7 +246,7 @@ static int add_hist_entries(struct perf_evlist *evlist, struct machine *machine)
 				goto out;
 
 			he = __hists__add_entry(&evsel->hists, &al, NULL,
-						NULL, NULL, 1, 1, 0, true);
+						NULL, NULL, 1, 1, 0, 0, true);
 			if (he == NULL)
 				goto out;
 
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index b14fa14..cf7d7e0 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -157,6 +157,8 @@ void hists__calc_col_len(struct hists *hists, struct hist_entry *h)
 	if (h->transaction)
 		hists__new_col_len(hists, HISTC_TRANSACTION,
 				   hist_entry__transaction_len());
+
+	hists__new_col_len(hists, HISTC_TIME, 32);
 }
 
 void hists__output_recalc_col_len(struct hists *hists, int max_rows)
@@ -434,7 +436,7 @@ struct hist_entry *__hists__add_entry(struct hists *hists,
 				      struct branch_info *bi,
 				      struct mem_info *mi,
 				      u64 period, u64 weight, u64 transaction,
-				      bool sample_self)
+				      u64 t, bool sample_self)
 {
 	struct hist_entry entry = {
 		.thread	= al->thread,
@@ -457,6 +459,7 @@ struct hist_entry *__hists__add_entry(struct hists *hists,
 		.branch_info = bi,
 		.mem_info = mi,
 		.transaction = transaction,
+		.time = t,
 	};
 
 	return add_hist_entry(hists, &entry, al, sample_self);
@@ -516,7 +519,7 @@ iter_add_single_mem_entry(struct hist_entry_iter *iter, struct addr_location *al
 	 * and the he_stat__add_period() function.
 	 */
 	he = __hists__add_entry(&iter->evsel->hists, al, iter->parent, NULL, mi,
-				cost, cost, 0, true);
+				cost, cost, 0, 0, true);
 	if (!he)
 		return -ENOMEM;
 
@@ -628,7 +631,7 @@ iter_add_next_branch_entry(struct hist_entry_iter *iter, struct addr_location *a
 	 * and not events sampled. Thus we use a pseudo period of 1.
 	 */
 	he = __hists__add_entry(&evsel->hists, al, iter->parent, &bi[i], NULL,
-				1, 1, 0, true);
+				1, 1, 0, 0, true);
 	if (he == NULL)
 		return -ENOMEM;
 
@@ -674,7 +677,7 @@ iter_add_single_normal_entry(struct hist_entry_iter *iter, struct addr_location
 
 	he = __hists__add_entry(&evsel->hists, al, iter->parent, NULL, NULL,
 				sample->period, sample->weight,
-				sample->transaction, true);
+				sample->transaction, sample->time, true);
 	if (he == NULL)
 		return -ENOMEM;
 
@@ -730,7 +733,7 @@ iter_add_single_cumulative_entry(struct hist_entry_iter *iter,
 
 	he = __hists__add_entry(&evsel->hists, al, iter->parent, NULL, NULL,
 				sample->period, sample->weight,
-				sample->transaction, true);
+				sample->transaction, sample->time, true);
 	if (he == NULL)
 		return -ENOMEM;
 
@@ -801,7 +804,7 @@ iter_add_next_cumulative_entry(struct hist_entry_iter *iter,
 
 	he = __hists__add_entry(&evsel->hists, al, iter->parent, NULL, NULL,
 				sample->period, sample->weight,
-				sample->transaction, false);
+				sample->transaction, sample->time, false);
 	if (he == NULL)
 		return -ENOMEM;
 
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 2f52c4d..851beef 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -69,6 +69,7 @@ enum hist_column {
 	HISTC_MEM_LVL,
 	HISTC_MEM_SNOOP,
 	HISTC_TRANSACTION,
+	HISTC_TIME,
 	HISTC_NR_COLS, /* Last entry */
 };
 
@@ -87,6 +88,7 @@ struct hists {
 	const char		*symbol_filter_str;
 	pthread_mutex_t		lock;
 	struct events_stats	stats;
+	u64			time_base;
 	u64			event_stream;
 	u16			col_len[HISTC_NR_COLS];
 };
@@ -131,7 +133,7 @@ struct hist_entry *__hists__add_entry(struct hists *hists,
 				      struct branch_info *bi,
 				      struct mem_info *mi, u64 period,
 				      u64 weight, u64 transaction,
-				      bool sample_self);
+				      u64 time, bool sample_self);
 int hist_entry_iter__add(struct hist_entry_iter *iter, struct addr_location *al,
 			 struct perf_evsel *evsel, const union perf_event *event,
 			 struct perf_sample *sample, int max_stack_depth,
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 635cd8f..9438617 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -2,6 +2,7 @@
 #include "hist.h"
 #include "comm.h"
 #include "symbol.h"
+#include "util.h"
 
 regex_t		parent_regex;
 const char	default_parent_pattern[] = "^sys_|^do_page_fault";
@@ -54,6 +55,56 @@ static int64_t cmp_null(const void *l, const void *r)
 		return 1;
 }
 
+/* --sort time */
+
+static int64_t
+sort__time_cmp(struct hist_entry *left, struct hist_entry *right)
+{
+	return right->time - left->time;
+}
+
+static u64 get_time_base(struct hist_entry *he)
+{
+	struct hists *hists = he->hists;
+
+	if (!hists->time_base)
+		hists->time_base = he->time;
+
+	return hists->time_base;
+}
+
+static int hist_entry__time_snprintf(struct hist_entry *he, char *bf,
+				       size_t size, unsigned int width)
+{
+	char buf[100];
+	u64 time_base = get_time_base(he);
+	unsigned long time_sec, time_usec;
+	unsigned long base_sec, base_usec;
+	long delta_sec, delta_usec;
+	bool neg = (s64)(he->time - time_base) < 0;
+
+	time_sec  = nanotime_get_sec(he->time);
+	time_usec = nanotime_get_usec(he->time);
+	base_sec  = nanotime_get_sec(time_base);
+	base_usec = nanotime_get_usec(time_base);
+
+	delta_sec  = abs(time_sec - base_sec);
+	delta_usec = abs(time_usec - base_usec);
+
+	scnprintf(buf, 100, "%6lu.%06lu %s%06lu.%06lu",
+		  time_sec, time_usec,
+		  neg ? "-" : "+",
+		  delta_sec, delta_usec);
+	return repsep_snprintf(bf, size, "%*s", width, buf);
+}
+
+struct sort_entry sort_time = {
+	.se_header	= "Time",
+	.se_cmp		= sort__time_cmp,
+	.se_snprintf	= hist_entry__time_snprintf,
+	.se_width_idx	= HISTC_TIME,
+};
+
 /* --sort pid */
 
 static int64_t
@@ -996,6 +1047,7 @@ static struct sort_dimension common_sort_dimensions[] = {
 	DIM(SORT_LOCAL_WEIGHT, "local_weight", sort_local_weight),
 	DIM(SORT_GLOBAL_WEIGHT, "weight", sort_global_weight),
 	DIM(SORT_TRANSACTION, "transaction", sort_transaction),
+	DIM(SORT_TIME, "time", sort_time),
 };
 
 #undef DIM
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index 103748b..4eb684e 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -88,6 +88,7 @@ struct hist_entry {
 	u64			ip;
 	u64			transaction;
 	s32			cpu;
+	u64			time;
 
 	struct hist_entry_diff	diff;
 
@@ -163,6 +164,7 @@ enum sort_type {
 	SORT_LOCAL_WEIGHT,
 	SORT_GLOBAL_WEIGHT,
 	SORT_TRANSACTION,
+	SORT_TIME,
 
 	/* branch stack specific sort keys */
 	__SORT_BRANCH_STACK,
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index 6995d66..881db9b 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -75,6 +75,9 @@
 #include <termios.h>
 #include <linux/bitops.h>
 
+#define NSECS_PER_SEC	1000000000ULL
+#define NSECS_PER_USEC	1000ULL
+
 extern const char *graph_line;
 extern const char *graph_dotted_line;
 extern char buildid_dir[];
@@ -295,6 +298,20 @@ static inline unsigned long next_pow2_l(unsigned long x)
 #endif
 }
 
+static inline unsigned long nanotime_get_sec(u64 t)
+{
+	return t / NSECS_PER_SEC;
+}
+
+static inline unsigned long nanotime_get_usec(u64 t)
+{
+	unsigned long long secs;
+
+	secs = t / NSECS_PER_SEC;
+	t -= secs * NSECS_PER_SEC;
+	return t / NSECS_PER_USEC;
+}
+
 size_t hex_width(u64 v);
 int hex2u64(const char *ptr, u64 *val);
 
-- 
1.8.3.1

