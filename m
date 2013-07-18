Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965032Ab3GRTxB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 15:53:01 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41705 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759500Ab3GRTub (ORCPT
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
Subject: [PATCH 63/76] perf tools: Move hist_entry__period_snprintf into stdio code
Date: Thu, 18 Jul 2013 16:49:50 -0300
Message-Id: <1374177003-3706-64-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1374177003-3706-1-git-send-email-acme@infradead.org>
References: <1374177003-3706-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Moving hist_entry__period_snprintf function into stdio code and making
it static, as it's no longer used anywhere else.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Reviewed-by: Namhyung Kim <namhyung@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-ah8ms343h8xygt20iqz91kz4@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/hist.c       | 40 ----------------------------------------
 tools/perf/ui/stdio/hist.c | 41 +++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/hist.h     |  2 --
 3 files changed, 41 insertions(+), 42 deletions(-)

diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index dc900d7..0a19328 100644
--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -236,46 +236,6 @@ void perf_hpp__column_enable(unsigned col)
 	perf_hpp__column_register(&perf_hpp__format[col]);
 }
 
-static inline void advance_hpp(struct perf_hpp *hpp, int inc)
-{
-	hpp->buf  += inc;
-	hpp->size -= inc;
-}
-
-int hist_entry__period_snprintf(struct perf_hpp *hpp, struct hist_entry *he,
-				bool color)
-{
-	const char *sep = symbol_conf.field_sep;
-	struct perf_hpp_fmt *fmt;
-	char *start = hpp->buf;
-	int ret;
-	bool first = true;
-
-	if (symbol_conf.exclude_other && !he->parent)
-		return 0;
-
-	perf_hpp__for_each_format(fmt) {
-		/*
-		 * If there's no field_sep, we still need
-		 * to display initial '  '.
-		 */
-		if (!sep || !first) {
-			ret = scnprintf(hpp->buf, hpp->size, "%s", sep ?: "  ");
-			advance_hpp(hpp, ret);
-		} else
-			first = false;
-
-		if (color && fmt->color)
-			ret = fmt->color(fmt, hpp, he);
-		else
-			ret = fmt->entry(fmt, hpp, he);
-
-		advance_hpp(hpp, ret);
-	}
-
-	return hpp->buf - start;
-}
-
 int hist_entry__sort_snprintf(struct hist_entry *he, char *s, size_t size,
 			      struct hists *hists)
 {
diff --git a/tools/perf/ui/stdio/hist.c b/tools/perf/ui/stdio/hist.c
index ee70372..5b4fb33 100644
--- a/tools/perf/ui/stdio/hist.c
+++ b/tools/perf/ui/stdio/hist.c
@@ -308,6 +308,47 @@ static size_t hist_entry__callchain_fprintf(struct hist_entry *he,
 	return hist_entry_callchain__fprintf(he, total_period, left_margin, fp);
 }
 
+static inline void advance_hpp(struct perf_hpp *hpp, int inc)
+{
+	hpp->buf  += inc;
+	hpp->size -= inc;
+}
+
+static int hist_entry__period_snprintf(struct perf_hpp *hpp,
+				       struct hist_entry *he,
+				       bool color)
+{
+	const char *sep = symbol_conf.field_sep;
+	struct perf_hpp_fmt *fmt;
+	char *start = hpp->buf;
+	int ret;
+	bool first = true;
+
+	if (symbol_conf.exclude_other && !he->parent)
+		return 0;
+
+	perf_hpp__for_each_format(fmt) {
+		/*
+		 * If there's no field_sep, we still need
+		 * to display initial '  '.
+		 */
+		if (!sep || !first) {
+			ret = scnprintf(hpp->buf, hpp->size, "%s", sep ?: "  ");
+			advance_hpp(hpp, ret);
+		} else
+			first = false;
+
+		if (color && fmt->color)
+			ret = fmt->color(fmt, hpp, he);
+		else
+			ret = fmt->entry(fmt, hpp, he);
+
+		advance_hpp(hpp, ret);
+	}
+
+	return hpp->buf - start;
+}
+
 static int hist_entry__fprintf(struct hist_entry *he, size_t size,
 			       struct hists *hists, FILE *fp)
 {
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index bfcbb11..1329b6b 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -174,8 +174,6 @@ enum {
 void perf_hpp__init(void);
 void perf_hpp__column_register(struct perf_hpp_fmt *format);
 void perf_hpp__column_enable(unsigned col);
-int hist_entry__period_snprintf(struct perf_hpp *hpp, struct hist_entry *he,
-				bool color);
 
 struct perf_evlist;
 
-- 
1.8.1.4

