Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755326Ab3AXS5N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 13:57:13 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33007 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975Ab3AXS5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 13:57:10 -0500
Date: Thu, 24 Jan 2013 10:56:42 -0800
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-db6d0bb86164497f6c9ef46020cf1881953f4b08@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <20121206132228.GB1080@krava.brq.redhat.com>
References: <20121206132228.GB1080@krava.brq.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf diff: Remove displacement output option
Git-Commit-ID: db6d0bb86164497f6c9ef46020cf1881953f4b08
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 24 Jan 2013 10:56:48 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  db6d0bb86164497f6c9ef46020cf1881953f4b08
Gitweb:     http://git.kernel.org/tip/db6d0bb86164497f6c9ef46020cf1881953f4b08
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Thu, 6 Dec 2012 14:22:28 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Sun, 9 Dec 2012 08:46:07 -0300

perf diff: Remove displacement output option

It seems not very useful, because it's possible and event more convenient to
lookup related symbol by name. Also the output value for both 'baseline' and
'new' data is quite apparent from diff output.

And above all it complicates hist code factoring ;)

Ditching out PERF_HPP__DISPL column with related output functions.

Suggested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/20121206132228.GB1080@krava.brq.redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-diff.txt |  4 ----
 tools/perf/builtin-diff.c              | 29 +++++++----------------------
 tools/perf/ui/hist.c                   | 25 -------------------------
 tools/perf/util/hist.h                 |  1 -
 4 files changed, 7 insertions(+), 52 deletions(-)

diff --git a/tools/perf/Documentation/perf-diff.txt b/tools/perf/Documentation/perf-diff.txt
index 194f37d..5b3123d 100644
--- a/tools/perf/Documentation/perf-diff.txt
+++ b/tools/perf/Documentation/perf-diff.txt
@@ -22,10 +22,6 @@ specified perf.data files.
 
 OPTIONS
 -------
--M::
---displacement::
-        Show position displacement relative to baseline.
-
 -D::
 --dump-raw-trace::
         Dump raw trace in ASCII.
diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index d869029..b2e7d39 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -23,7 +23,6 @@ static char const *input_old = "perf.data.old",
 		  *input_new = "perf.data";
 static char	  diff__default_sort_order[] = "dso,symbol";
 static bool  force;
-static bool show_displacement;
 static bool show_period;
 static bool show_formula;
 static bool show_baseline_only;
@@ -296,9 +295,8 @@ static void insert_hist_entry_by_name(struct rb_root *root,
 	rb_insert_color(&he->rb_node, root);
 }
 
-static void hists__name_resort(struct hists *self, bool sort)
+static void hists__name_resort(struct hists *self)
 {
-	unsigned long position = 1;
 	struct rb_root tmp = RB_ROOT;
 	struct rb_node *next = rb_first(&self->entries);
 
@@ -306,16 +304,12 @@ static void hists__name_resort(struct hists *self, bool sort)
 		struct hist_entry *n = rb_entry(next, struct hist_entry, rb_node);
 
 		next = rb_next(&n->rb_node);
-		n->position = position++;
 
-		if (sort) {
-			rb_erase(&n->rb_node, &self->entries);
-			insert_hist_entry_by_name(&tmp, n);
-		}
+		rb_erase(&n->rb_node, &self->entries);
+		insert_hist_entry_by_name(&tmp, n);
 	}
 
-	if (sort)
-		self->entries = tmp;
+	self->entries = tmp;
 }
 
 static struct perf_evsel *evsel_match(struct perf_evsel *evsel,
@@ -339,12 +333,8 @@ static void perf_evlist__resort_hists(struct perf_evlist *evlist, bool name)
 
 		hists__output_resort(hists);
 
-		/*
-		 * The hists__name_resort only sets possition
-		 * if name is false.
-		 */
-		if (name || ((!name) && show_displacement))
-			hists__name_resort(hists, name);
+		if (name)
+			hists__name_resort(hists);
 	}
 }
 
@@ -549,8 +539,6 @@ static const char * const diff_usage[] = {
 static const struct option options[] = {
 	OPT_INCR('v', "verbose", &verbose,
 		    "be more verbose (show symbol address, etc)"),
-	OPT_BOOLEAN('M', "displacement", &show_displacement,
-		    "Show position displacement relative to baseline"),
 	OPT_BOOLEAN('b', "baseline-only", &show_baseline_only,
 		    "Show only items with match in baseline"),
 	OPT_CALLBACK('c', "compute", &compute,
@@ -585,7 +573,7 @@ static const struct option options[] = {
 static void ui_init(void)
 {
 	/*
-	 * Display baseline/delta/ratio/displacement/
+	 * Display baseline/delta/ratio
 	 * formula/periods columns.
 	 */
 	perf_hpp__column_enable(PERF_HPP__BASELINE);
@@ -604,9 +592,6 @@ static void ui_init(void)
 		BUG_ON(1);
 	};
 
-	if (show_displacement)
-		perf_hpp__column_enable(PERF_HPP__DISPL);
-
 	if (show_formula)
 		perf_hpp__column_enable(PERF_HPP__FORMULA);
 
diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index 1785bab..1889c12 100644
--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -351,30 +351,6 @@ static int hpp__entry_wdiff(struct perf_hpp *hpp, struct hist_entry *he)
 	return scnprintf(hpp->buf, hpp->size, fmt, buf);
 }
 
-static int hpp__header_displ(struct perf_hpp *hpp)
-{
-	return scnprintf(hpp->buf, hpp->size, "Displ.");
-}
-
-static int hpp__width_displ(struct perf_hpp *hpp __maybe_unused)
-{
-	return 6;
-}
-
-static int hpp__entry_displ(struct perf_hpp *hpp,
-			    struct hist_entry *he)
-{
-	struct hist_entry *pair = hist_entry__next_pair(he);
-	long displacement = pair ? pair->position - he->position : 0;
-	const char *fmt = symbol_conf.field_sep ? "%s" : "%6.6s";
-	char buf[32] = " ";
-
-	if (displacement)
-		scnprintf(buf, sizeof(buf), "%+4ld", displacement);
-
-	return scnprintf(hpp->buf, hpp->size, fmt, buf);
-}
-
 static int hpp__header_formula(struct perf_hpp *hpp)
 {
 	const char *fmt = symbol_conf.field_sep ? "%s" : "%70s";
@@ -427,7 +403,6 @@ struct perf_hpp_fmt perf_hpp__format[] = {
 	HPP__PRINT_FNS(delta),
 	HPP__PRINT_FNS(ratio),
 	HPP__PRINT_FNS(wdiff),
-	HPP__PRINT_FNS(displ),
 	HPP__PRINT_FNS(formula)
 };
 
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index c1b2fad..5b3b007 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -154,7 +154,6 @@ enum {
 	PERF_HPP__DELTA,
 	PERF_HPP__RATIO,
 	PERF_HPP__WEIGHTED_DIFF,
-	PERF_HPP__DISPL,
 	PERF_HPP__FORMULA,
 
 	PERF_HPP__MAX_INDEX
