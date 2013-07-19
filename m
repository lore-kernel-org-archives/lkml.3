Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030271Ab3GSHxH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 03:53:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35837 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030211Ab3GSHxC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 03:53:02 -0400
Date: Fri, 19 Jul 2013 00:52:44 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-ah8ms343h8xygt20iqz91kz4@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Move hist_entry__period_snprintf into stdio code
Git-Commit-ID: be0e6d105d31a5818608ae243411aef5c976147a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 19 Jul 2013 00:52:50 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  be0e6d105d31a5818608ae243411aef5c976147a
Gitweb:     http://git.kernel.org/tip/be0e6d105d31a5818608ae243411aef5c976147a
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Mon, 4 Feb 2013 16:33:19 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 12 Jul 2013 13:54:18 -0300

perf tools: Move hist_entry__period_snprintf into stdio code

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
 
