Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965097Ab3GRTxF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 15:53:05 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41702 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759496Ab3GRTub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 15:50:31 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 59/76] perf diff: Change diff command to work over multiple data files
Date: Thu, 18 Jul 2013 16:49:46 -0300
Message-Id: <1374177003-3706-60-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1374177003-3706-1-git-send-email-acme@infradead.org>
References: <1374177003-3706-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Adding diff command the flexibility to specify multiple data files on
input. If not input file is given the standard behaviour stands and diff
inspects 'perf.data' and 'perf.data.old' files.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Reviewed-by: Namhyung Kim <namhyung@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-8j3xer54ltvs76t0fh01gcvu@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-diff.c | 99 +++++++++++++++++++++++++++++++----------------
 1 file changed, 66 insertions(+), 33 deletions(-)

diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 7787ee2..cc7bf4f 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -44,6 +44,7 @@ struct data__file {
 	struct perf_session	*session;
 	const char		*file;
 	int			 idx;
+	struct hists		*hists;
 	struct diff_hpp_fmt	 fmt[PERF_HPP_DIFF__MAX_INDEX];
 };
 
@@ -56,6 +57,7 @@ static int data__files_cnt;
 	     i++, d = &data__files[i])
 
 #define data__for_each_file(i, d) data__for_each_file_start(i, d, 0)
+#define data__for_each_file_new(i, d) data__for_each_file_start(i, d, 1)
 
 static char diff__default_sort_order[] = "dso,symbol";
 static bool force;
@@ -525,23 +527,19 @@ static void hists__compute_resort(struct hists *hists)
 	}
 }
 
-static void hists__process(struct hists *base, struct hists *new)
+static void hists__process(struct hists *hists)
 {
-	hists__match(base, new);
-
 	if (show_baseline_only)
-		hists__baseline_only(base);
-	else
-		hists__link(base, new);
+		hists__baseline_only(hists);
 
 	if (sort_compute) {
-		hists__precompute(base);
-		hists__compute_resort(base);
+		hists__precompute(hists);
+		hists__compute_resort(hists);
 	} else {
-		hists__output_resort(base);
+		hists__output_resort(hists);
 	}
 
-	hists__fprintf(base, true, 0, 0, 0, stdout);
+	hists__fprintf(hists, true, 0, 0, 0, stdout);
 }
 
 static void data__fprintf(void)
@@ -561,27 +559,40 @@ static void data__fprintf(void)
 
 static void data_process(void)
 {
-	struct perf_evlist *evlist_old = data__files[0].session->evlist;
-	struct perf_evlist *evlist_new = data__files[1].session->evlist;
-	struct perf_evsel *evsel_old;
+	struct perf_evlist *evlist_base = data__files[0].session->evlist;
+	struct perf_evsel *evsel_base;
 	bool first = true;
 
-	list_for_each_entry(evsel_old, &evlist_old->entries, node) {
-		struct perf_evsel *evsel_new;
+	list_for_each_entry(evsel_base, &evlist_base->entries, node) {
+		struct data__file *d;
+		int i;
 
-		evsel_new = evsel_match(evsel_old, evlist_new);
-		if (!evsel_new)
-			continue;
+		data__for_each_file_new(i, d) {
+			struct perf_evlist *evlist = d->session->evlist;
+			struct perf_evsel *evsel;
+
+			evsel = evsel_match(evsel_base, evlist);
+			if (!evsel)
+				continue;
+
+			d->hists = &evsel->hists;
+
+			hists__match(&evsel_base->hists, &evsel->hists);
+
+			if (!show_baseline_only)
+				hists__link(&evsel_base->hists,
+					    &evsel->hists);
+		}
 
 		fprintf(stdout, "%s# Event '%s'\n#\n", first ? "" : "\n",
-			perf_evsel__name(evsel_old));
+			perf_evsel__name(evsel_base));
 
 		first = false;
 
-		if (verbose)
+		if (verbose || data__files_cnt > 2)
 			data__fprintf();
 
-		hists__process(&evsel_old->hists, &evsel_new->hists);
+		hists__process(&evsel_base->hists);
 	}
 }
 
@@ -780,10 +791,29 @@ hpp__entry_pair(struct hist_entry *he, struct hist_entry *pair,
 	};
 }
 
+static struct hist_entry *get_pair(struct hist_entry *he,
+				   struct diff_hpp_fmt *dfmt)
+{
+	void *ptr = dfmt - dfmt->idx;
+	struct data__file *d = container_of(ptr, struct data__file, fmt);
+
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
 static void
-__hpp__entry_global(struct hist_entry *he, int idx, char *buf, size_t size)
+__hpp__entry_global(struct hist_entry *he, struct diff_hpp_fmt *dfmt,
+		    char *buf, size_t size)
 {
-	struct hist_entry *pair = hist_entry__next_pair(he);
+	struct hist_entry *pair = get_pair(he, dfmt);
+	int idx = dfmt->idx;
 
 	/* baseline is special */
 	if (idx == PERF_HPP_DIFF__BASELINE)
@@ -803,7 +833,7 @@ static int hpp__entry_global(struct perf_hpp_fmt *_fmt, struct perf_hpp *hpp,
 		container_of(_fmt, struct diff_hpp_fmt, fmt);
 	char buf[MAX_COL_WIDTH] = " ";
 
-	__hpp__entry_global(he, dfmt->idx, buf, MAX_COL_WIDTH);
+	__hpp__entry_global(he, dfmt, buf, MAX_COL_WIDTH);
 
 	if (symbol_conf.field_sep)
 		return scnprintf(hpp->buf, hpp->size, "%s", buf);
@@ -832,7 +862,7 @@ static int hpp__width(struct perf_hpp_fmt *fmt,
 	return dfmt->header_width;
 }
 
-static void init_header(struct diff_hpp_fmt *dfmt)
+static void init_header(struct data__file *d, struct diff_hpp_fmt *dfmt)
 {
 #define MAX_HEADER_NAME 100
 	char buf_indent[MAX_HEADER_NAME];
@@ -847,6 +877,9 @@ static void init_header(struct diff_hpp_fmt *dfmt)
 	/* Only our defined HPP fmts should appear here. */
 	BUG_ON(!header);
 
+	if (data__files_cnt > 2)
+		scnprintf(buf, MAX_HEADER_NAME, "%s/%d", header, d->idx);
+
 #define NAME (data__files_cnt > 2 ? buf : header)
 	dfmt->header_width = width;
 	width = (int) strlen(NAME);
@@ -876,7 +909,7 @@ static void data__hpp_register(struct data__file *d, int idx)
 	if (idx == PERF_HPP_DIFF__BASELINE)
 		fmt->color = hpp__color_baseline;
 
-	init_header(dfmt);
+	init_header(d, dfmt);
 	perf_hpp__column_register(fmt);
 }
 
@@ -921,18 +954,18 @@ static int data_init(int argc, const char **argv)
 		"perf.data.old",
 		"perf.data",
 	};
+	bool use_default = true;
 	int i;
 
 	data__files_cnt = 2;
 
 	if (argc) {
-		if (argc > 2)
-			usage_with_options(diff_usage, options);
-		if (argc == 2) {
-			defaults[0] = argv[0];
-			defaults[1] = argv[1];
-		} else
+		if (argc == 1)
 			defaults[1] = argv[0];
+		else {
+			data__files_cnt = argc;
+			use_default = false;
+		}
 	} else if (symbol_conf.default_guest_vmlinux_name ||
 		   symbol_conf.default_guest_kallsyms) {
 		defaults[0] = "perf.data.host";
@@ -944,7 +977,7 @@ static int data_init(int argc, const char **argv)
 		return -ENOMEM;
 
 	data__for_each_file(i, d) {
-		d->file = defaults[i];
+		d->file = use_default ? defaults[i] : argv[i];
 		d->idx  = i;
 	}
 
-- 
1.8.1.4

