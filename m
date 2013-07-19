Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030237Ab3GSHw3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 03:52:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35795 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965772Ab3GSHwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 03:52:25 -0400
Date: Fri, 19 Jul 2013 00:52:06 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-8j3xer54ltvs76t0fh01gcvu@git.kernel.org>
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
  Change diff command to work over multiple data files
Git-Commit-ID: 22aeb7f597650284591ad0f61b069ded3ecf91db
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 19 Jul 2013 00:52:12 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  22aeb7f597650284591ad0f61b069ded3ecf91db
Gitweb:     http://git.kernel.org/tip/22aeb7f597650284591ad0f61b069ded3ecf91db
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Sat, 1 Dec 2012 22:00:00 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 12 Jul 2013 13:54:11 -0300

perf diff: Change diff command to work over multiple data files

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
 
