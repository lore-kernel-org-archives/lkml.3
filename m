Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966109Ab3GSHwU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 03:52:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35780 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965772Ab3GSHwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 03:52:15 -0400
Date: Fri, 19 Jul 2013 00:51:57 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-lnfqj7k7fqw8bz07pupi5464@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf diff: Move columns into struct data__file
Git-Commit-ID: c818b49820aea96d6a1b43815bae0ee38b09ca0d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 19 Jul 2013 00:52:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c818b49820aea96d6a1b43815bae0ee38b09ca0d
Gitweb:     http://git.kernel.org/tip/c818b49820aea96d6a1b43815bae0ee38b09ca0d
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Sat, 1 Dec 2012 21:57:04 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 12 Jul 2013 13:54:09 -0300

perf diff: Move columns into struct data__file

Another step towards multiple data files support. Having columns
definition within struct data__file force each data file having its own
columns.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Reviewed-by: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/n/tip-lnfqj7k7fqw8bz07pupi5464@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-diff.c | 97 +++++++++++++++++++++++++++--------------------
 1 file changed, 55 insertions(+), 42 deletions(-)

diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 8734f1c..7787ee2 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -44,6 +44,7 @@ struct data__file {
 	struct perf_session	*session;
 	const char		*file;
 	int			 idx;
+	struct diff_hpp_fmt	 fmt[PERF_HPP_DIFF__MAX_INDEX];
 };
 
 static struct data__file *data__files;
@@ -584,6 +585,17 @@ static void data_process(void)
 	}
 }
 
+static void data__free(struct data__file *d)
+{
+	int col;
+
+	for (col = 0; col < PERF_HPP_DIFF__MAX_INDEX; col++) {
+		struct diff_hpp_fmt *fmt = &d->fmt[col];
+
+		free(fmt->header);
+	}
+}
+
 static int __cmd_diff(void)
 {
 	struct data__file *d;
@@ -613,6 +625,8 @@ static int __cmd_diff(void)
 	data__for_each_file(i, d) {
 		if (d->session)
 			perf_session__delete(d->session);
+
+		data__free(d);
 	}
 
 	free(data__files);
@@ -818,32 +832,6 @@ static int hpp__width(struct perf_hpp_fmt *fmt,
 	return dfmt->header_width;
 }
 
-#define hpp__color_global hpp__entry_global
-
-#define FMT(_i, _entry, _color)					\
-	[_i] = {						\
-		.fmt = {					\
-			.header	= hpp__header,			\
-			.width	= hpp__width,			\
-			.entry	= hpp__entry_ ## _entry,	\
-			.color	= hpp__color_ ## _color,	\
-		},						\
-		.idx = _i,					\
-	}
-
-#define FMT_GLOBAL(_i)	 FMT(_i, global, global)
-#define FMT_BASELINE(_i) FMT(_i, global, baseline)
-
-static struct diff_hpp_fmt diff_fmt[] = {
-	FMT_BASELINE(PERF_HPP_DIFF__BASELINE),
-	FMT_GLOBAL(PERF_HPP_DIFF__PERIOD),
-	FMT_GLOBAL(PERF_HPP_DIFF__PERIOD_BASELINE),
-	FMT_GLOBAL(PERF_HPP_DIFF__DELTA),
-	FMT_GLOBAL(PERF_HPP_DIFF__RATIO),
-	FMT_GLOBAL(PERF_HPP_DIFF__WEIGHTED_DIFF),
-	FMT_GLOBAL(PERF_HPP_DIFF__FORMULA),
-};
-
 static void init_header(struct diff_hpp_fmt *dfmt)
 {
 #define MAX_HEADER_NAME 100
@@ -873,31 +861,56 @@ static void init_header(struct diff_hpp_fmt *dfmt)
 #undef NAME
 }
 
-static void column_enable(unsigned col)
+static void data__hpp_register(struct data__file *d, int idx)
 {
-	struct diff_hpp_fmt *dfmt;
+	struct diff_hpp_fmt *dfmt = &d->fmt[idx];
+	struct perf_hpp_fmt *fmt = &dfmt->fmt;
+
+	dfmt->idx = idx;
+
+	fmt->header = hpp__header;
+	fmt->width  = hpp__width;
+	fmt->entry  = hpp__entry_global;
+
+	/* TODO more colors */
+	if (idx == PERF_HPP_DIFF__BASELINE)
+		fmt->color = hpp__color_baseline;
 
-	BUG_ON(col >= PERF_HPP_DIFF__MAX_INDEX);
-	dfmt = &diff_fmt[col];
 	init_header(dfmt);
-	perf_hpp__column_register(&dfmt->fmt);
+	perf_hpp__column_register(fmt);
 }
 
 static void ui_init(void)
 {
-	/*
-	 * Display baseline/delta/ratio/
-	 * formula/periods columns.
-	 */
-	column_enable(PERF_HPP_DIFF__BASELINE);
-	column_enable(compute_2_hpp[compute]);
+	struct data__file *d;
+	int i;
+
+	data__for_each_file(i, d) {
+
+		/*
+		 * Baseline or compute realted columns:
+		 *
+		 *   PERF_HPP_DIFF__BASELINE
+		 *   PERF_HPP_DIFF__DELTA
+		 *   PERF_HPP_DIFF__RATIO
+		 *   PERF_HPP_DIFF__WEIGHTED_DIFF
+		 */
+		data__hpp_register(d, i ? compute_2_hpp[compute] :
+					  PERF_HPP_DIFF__BASELINE);
 
-	if (show_formula)
-		column_enable(PERF_HPP_DIFF__FORMULA);
+		/*
+		 * And the rest:
+		 *
+		 * PERF_HPP_DIFF__FORMULA
+		 * PERF_HPP_DIFF__PERIOD
+		 * PERF_HPP_DIFF__PERIOD_BASELINE
+		 */
+		if (show_formula && i)
+			data__hpp_register(d, PERF_HPP_DIFF__FORMULA);
 
-	if (show_period) {
-		column_enable(PERF_HPP_DIFF__PERIOD);
-		column_enable(PERF_HPP_DIFF__PERIOD_BASELINE);
+		if (show_period)
+			data__hpp_register(d, i ? PERF_HPP_DIFF__PERIOD :
+						  PERF_HPP_DIFF__PERIOD_BASELINE);
 	}
 }
 
