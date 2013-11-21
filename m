Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617Ab3KUOnM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 09:43:12 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:41336 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124Ab3KUOnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 09:43:09 -0500
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 3/4] perf diff: generalize hpp__color_delta for -c
Date: Thu, 21 Nov 2013 20:03:46 +0530
Message-Id: <1385044427-13995-4-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.5.rc0.5.g70ebc73.dirty
In-Reply-To: <1385044427-13995-1-git-send-email-artagnon@gmail.com>
References: <1385044427-13995-1-git-send-email-artagnon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Generalize the function so that we can accommodate all three comparison
methods: delta, ratio, and wdiff.

Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
---
 tools/perf/builtin-diff.c | 43 ++++++++++++++++++++++++++++++++++---------
 1 file changed, 34 insertions(+), 9 deletions(-)

diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 692c155..4477aa2 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -769,33 +769,58 @@ static int hpp__entry_baseline(struct hist_entry *he, char *buf, size_t size)
 	return ret;
 }
 
-static int hpp__color_delta(struct perf_hpp_fmt *fmt,
-			struct perf_hpp *hpp, struct hist_entry *he)
+static int __hpp__color_compare(struct perf_hpp_fmt *fmt,
+				struct perf_hpp *hpp, struct hist_entry *he,
+				int comparison_method)
 {
 	struct diff_hpp_fmt *dfmt =
 		container_of(fmt, struct diff_hpp_fmt, fmt);
 	struct hist_entry *pair = get_pair_fmt(he, dfmt);
-	double percent;
+	double delta;
 	char pfmt[20] = " ";
 
 	if (!pair)
 		goto dummy_print;
 	if (pair->diff.computed)
-		percent = pair->diff.period_ratio_delta;
+		switch (comparison_method) {
+		case COMPUTE_DELTA:
+			delta = pair->diff.period_ratio_delta;
+			break;
+		default:
+			BUG_ON(1);
+		}
 	else
-		percent = compute_delta(he, pair);
+		switch (comparison_method) {
+		case COMPUTE_DELTA:
+			delta = compute_delta(he, pair);
+			break;
+		default:
+			BUG_ON(1);
+		}
 
 	if (!he->dummy) {
-		scnprintf(pfmt, 20, "%%%+d.2f%%%%", dfmt->header_width - 1);
-		return color_snprintf(hpp->buf, hpp->size,
-				percent > 0 ? PERF_COLOR_GREEN : PERF_COLOR_RED,
-				pfmt, percent);
+		switch (comparison_method) {
+		case COMPUTE_DELTA:
+			scnprintf(pfmt, 20, "%%%+d.2f%%%%", dfmt->header_width - 1);
+			return color_snprintf(hpp->buf, hpp->size,
+					delta > 0 ? PERF_COLOR_GREEN : PERF_COLOR_RED,
+					pfmt, delta);
+			break;
+		default:
+			BUG_ON(1);
+		}
 	} else
 dummy_print:
 		return scnprintf(hpp->buf, hpp->size, "%*s",
 				dfmt->header_width, pfmt);
 }
 
+static int hpp__color_delta(struct perf_hpp_fmt *fmt,
+			struct perf_hpp *hpp, struct hist_entry *he)
+{
+	return __hpp__color_compare(fmt, hpp, he, COMPUTE_DELTA);
+}
+
 static void
 hpp__entry_unpair(struct hist_entry *he, int idx, char *buf, size_t size)
 {
-- 
1.8.5.rc0.5.g70ebc73.dirty

