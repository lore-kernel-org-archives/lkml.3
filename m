Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030262Ab3GSHw6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 03:52:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35825 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030234Ab3GSHwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 03:52:53 -0400
Date: Fri, 19 Jul 2013 00:52:34 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-l7dvhgt0azm7yiqg3fbn4dxw@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf diff:
  Add generic order option for compute sorting
Git-Commit-ID: 5f3f8d3b1207cba3664d57a33de43f5ee11c8a06
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 19 Jul 2013 00:52:40 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5f3f8d3b1207cba3664d57a33de43f5ee11c8a06
Gitweb:     http://git.kernel.org/tip/5f3f8d3b1207cba3664d57a33de43f5ee11c8a06
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Sun, 25 Nov 2012 23:10:20 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 12 Jul 2013 13:54:16 -0300

perf diff: Add generic order option for compute sorting

Adding option 'o' to allow sorting based on the input file number. By
default (without -o option) the output is sorted on baseline.

Also removing '+' sorting support from -c option, because it's not
needed anymore.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Reviewed-by: Namhyung Kim <namhyung@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-l7dvhgt0azm7yiqg3fbn4dxw@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-diff.txt |  6 ++-
 tools/perf/builtin-diff.c              | 95 +++++++++++++++++++++++-----------
 2 files changed, 70 insertions(+), 31 deletions(-)

diff --git a/tools/perf/Documentation/perf-diff.txt b/tools/perf/Documentation/perf-diff.txt
index 2d134f3..fdfceee 100644
--- a/tools/perf/Documentation/perf-diff.txt
+++ b/tools/perf/Documentation/perf-diff.txt
@@ -75,8 +75,6 @@ OPTIONS
 -c::
 --compute::
         Differential computation selection - delta,ratio,wdiff (default is delta).
-        If '+' is specified as a first character, the output is sorted based
-        on the computation results.
         See COMPARISON METHODS section for more info.
 
 -p::
@@ -87,6 +85,10 @@ OPTIONS
 --formula::
         Show formula for given computation.
 
+-o::
+--order::
+       Specify compute sorting column number.
+
 COMPARISON
 ----------
 The comparison is governed by the baseline file. The baseline perf.data
diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index f2fbf69..93de3ac 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -64,7 +64,7 @@ static bool force;
 static bool show_period;
 static bool show_formula;
 static bool show_baseline_only;
-static bool sort_compute;
+static unsigned int sort_compute;
 
 static s64 compute_wdiff_w1;
 static s64 compute_wdiff_w2;
@@ -188,13 +188,6 @@ static int setup_compute(const struct option *opt, const char *str,
 		return 0;
 	}
 
-	if (*str == '+') {
-		sort_compute = true;
-		cstr = (char *) ++str;
-		if (!*str)
-			return 0;
-	}
-
 	option = strchr(str, ':');
 	if (option) {
 		unsigned len = option++ - str;
@@ -378,6 +371,29 @@ static void perf_evlist__collapse_resort(struct perf_evlist *evlist)
 	}
 }
 
+static struct hist_entry*
+get_pair_data(struct hist_entry *he, struct data__file *d)
+{
+	if (hist_entry__has_pairs(he)) {
+		struct hist_entry *pair;
+
+		list_for_each_entry(pair, &he->pairs.head, pairs.node)
+			if (pair->hists == d->hists)
+				return pair;
+	}
+
+	return NULL;
+}
+
+static struct hist_entry*
+get_pair_fmt(struct hist_entry *he, struct diff_hpp_fmt *dfmt)
+{
+	void *ptr = dfmt - dfmt->idx;
+	struct data__file *d = container_of(ptr, struct data__file, fmt);
+
+	return get_pair_data(he, d);
+}
+
 static void hists__baseline_only(struct hists *hists)
 {
 	struct rb_root *root;
@@ -412,10 +428,12 @@ static void hists__precompute(struct hists *hists)
 
 	next = rb_first(root);
 	while (next != NULL) {
-		struct hist_entry *he = rb_entry(next, struct hist_entry, rb_node_in);
-		struct hist_entry *pair = hist_entry__next_pair(he);
+		struct hist_entry *he, *pair;
 
+		he   = rb_entry(next, struct hist_entry, rb_node_in);
 		next = rb_next(&he->rb_node_in);
+
+		pair = get_pair_data(he, &data__files[sort_compute]);
 		if (!pair)
 			continue;
 
@@ -446,7 +464,7 @@ static int64_t cmp_doubles(double l, double r)
 }
 
 static int64_t
-hist_entry__cmp_compute(struct hist_entry *left, struct hist_entry *right,
+__hist_entry__cmp_compute(struct hist_entry *left, struct hist_entry *right,
 			int c)
 {
 	switch (c) {
@@ -478,6 +496,36 @@ hist_entry__cmp_compute(struct hist_entry *left, struct hist_entry *right,
 	return 0;
 }
 
+static int64_t
+hist_entry__cmp_compute(struct hist_entry *left, struct hist_entry *right,
+			int c)
+{
+	bool pairs_left  = hist_entry__has_pairs(left);
+	bool pairs_right = hist_entry__has_pairs(right);
+	struct hist_entry *p_right, *p_left;
+
+	if (!pairs_left && !pairs_right)
+		return 0;
+
+	if (!pairs_left || !pairs_right)
+		return pairs_left ? -1 : 1;
+
+	p_left  = get_pair_data(left,  &data__files[sort_compute]);
+	p_right = get_pair_data(right, &data__files[sort_compute]);
+
+	if (!p_left && !p_right)
+		return 0;
+
+	if (!p_left || !p_right)
+		return p_left ? -1 : 1;
+
+	/*
+	 * We have 2 entries of same kind, let's
+	 * make the data comparison.
+	 */
+	return __hist_entry__cmp_compute(p_left, p_right, c);
+}
+
 static void insert_hist_entry_by_compute(struct rb_root *root,
 					 struct hist_entry *he,
 					 int c)
@@ -680,6 +728,7 @@ static const struct option options[] = {
 		   "columns '.' is reserved."),
 	OPT_STRING(0, "symfs", &symbol_conf.symfs, "directory",
 		    "Look for files with symbols relative to this directory"),
+	OPT_UINTEGER('o', "order", &sort_compute, "Specify compute sorting."),
 	OPT_END()
 };
 
@@ -791,28 +840,11 @@ hpp__entry_pair(struct hist_entry *he, struct hist_entry *pair,
 	};
 }
 
-static struct hist_entry *get_pair(struct hist_entry *he,
-				   struct diff_hpp_fmt *dfmt)
-{
-	void *ptr = dfmt - dfmt->idx;
-	struct data__file *d = container_of(ptr, struct data__file, fmt);
-
-	if (hist_entry__has_pairs(he)) {
-		struct hist_entry *pair;
-
-		list_for_each_entry(pair, &he->pairs.head, pairs.node)
-			if (pair->hists == d->hists)
-				return pair;
-	}
-
-	return NULL;
-}
-
 static void
 __hpp__entry_global(struct hist_entry *he, struct diff_hpp_fmt *dfmt,
 		    char *buf, size_t size)
 {
-	struct hist_entry *pair = get_pair(he, dfmt);
+	struct hist_entry *pair = get_pair_fmt(he, dfmt);
 	int idx = dfmt->idx;
 
 	/* baseline is special */
@@ -972,6 +1004,11 @@ static int data_init(int argc, const char **argv)
 		defaults[1] = "perf.data.guest";
 	}
 
+	if (sort_compute >= (unsigned int) data__files_cnt) {
+		pr_err("Order option out of limit.\n");
+		return -EINVAL;
+	}
+
 	data__files = zalloc(sizeof(*data__files) * data__files_cnt);
 	if (!data__files)
 		return -ENOMEM;
