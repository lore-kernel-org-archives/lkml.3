Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752617AbaBBVji (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 16:39:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63661 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752590AbaBBVjh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 16:39:37 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 03/22] perf tools: Add idx sort entry
Date: Sun,  2 Feb 2014 22:38:51 +0100
Message-Id: <1391377150-23920-4-git-send-email-jolsa@redhat.com>
In-Reply-To: <1391377150-23920-1-git-send-email-jolsa@redhat.com>
References: <1391377150-23920-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding idx sort entry to have a way sort entries
the way they are stored in the data file.

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
 tools/perf/util/hist.c |  2 ++
 tools/perf/util/hist.h |  1 +
 tools/perf/util/sort.c | 23 +++++++++++++++++++++++
 tools/perf/util/sort.h |  2 ++
 4 files changed, 28 insertions(+)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index cf7d7e0..2ecb976 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -438,6 +438,7 @@ struct hist_entry *__hists__add_entry(struct hists *hists,
 				      u64 period, u64 weight, u64 transaction,
 				      u64 t, bool sample_self)
 {
+	static u64 idx;
 	struct hist_entry entry = {
 		.thread	= al->thread,
 		.comm = thread__comm(al->thread),
@@ -460,6 +461,7 @@ struct hist_entry *__hists__add_entry(struct hists *hists,
 		.mem_info = mi,
 		.transaction = transaction,
 		.time = t,
+		.idx  = idx++,
 	};
 
 	return add_hist_entry(hists, &entry, al, sample_self);
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 851beef..ae403a6 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -70,6 +70,7 @@ enum hist_column {
 	HISTC_MEM_SNOOP,
 	HISTC_TRANSACTION,
 	HISTC_TIME,
+	HISTC_IDX,
 	HISTC_NR_COLS, /* Last entry */
 };
 
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 9438617..5607edb 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -55,6 +55,28 @@ static int64_t cmp_null(const void *l, const void *r)
 		return 1;
 }
 
+/* --sort idx */
+
+static int64_t
+sort__idx_cmp(struct hist_entry *left, struct hist_entry *right)
+{
+	return right->idx - left->idx;
+}
+
+static int hist_entry__idx_snprintf(struct hist_entry *he, char *bf,
+				    size_t size, unsigned int width)
+{
+	return repsep_snprintf(bf, size, "%*lu", width, he->idx);
+}
+
+struct sort_entry sort_idx = {
+	.se_header	= "Idx",
+	.se_cmp		= sort__idx_cmp,
+	.se_snprintf	= hist_entry__idx_snprintf,
+	.se_width_idx	= HISTC_IDX,
+};
+
+
 /* --sort time */
 
 static int64_t
@@ -1048,6 +1070,7 @@ static struct sort_dimension common_sort_dimensions[] = {
 	DIM(SORT_GLOBAL_WEIGHT, "weight", sort_global_weight),
 	DIM(SORT_TRANSACTION, "transaction", sort_transaction),
 	DIM(SORT_TIME, "time", sort_time),
+	DIM(SORT_IDX, "idx", sort_idx),
 };
 
 #undef DIM
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index 4eb684e..666bf0b 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -89,6 +89,7 @@ struct hist_entry {
 	u64			transaction;
 	s32			cpu;
 	u64			time;
+	u64			idx;
 
 	struct hist_entry_diff	diff;
 
@@ -165,6 +166,7 @@ enum sort_type {
 	SORT_GLOBAL_WEIGHT,
 	SORT_TRANSACTION,
 	SORT_TIME,
+	SORT_IDX,
 
 	/* branch stack specific sort keys */
 	__SORT_BRANCH_STACK,
-- 
1.8.3.1

