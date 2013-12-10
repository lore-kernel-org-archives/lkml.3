Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753326Ab3LJMu3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 07:50:29 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:62066 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277Ab3LJMuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 07:50:25 -0500
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH v5 1/3] perf diff: color the Delta column
Date: Tue, 10 Dec 2013 18:19:00 +0530
Message-Id: <1386679742-13357-2-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.5.rc0.5.g70ebc73.dirty
In-Reply-To: <1386679742-13357-1-git-send-email-artagnon@gmail.com>
References: <1386679742-13357-1-git-send-email-artagnon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Color the numbers in the Delta column using percent_color_snprintf(),
making sure that it can handle negative values first. Generalize the
coloring function so that we can accommodate all three comparison
methods in future patches: delta, ratio, and wdiff.

Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
---
 tools/perf/builtin-diff.c | 49 ++++++++++++++++++++++++++++++++++++++++++++++-
 tools/perf/util/color.c   |  6 ++++--
 2 files changed, 52 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 3b67ea2..a8fc525 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -769,6 +769,45 @@ static int hpp__entry_baseline(struct hist_entry *he, char *buf, size_t size)
 	return ret;
 }
 
+static int __hpp__color_compare(struct perf_hpp_fmt *fmt,
+				struct perf_hpp *hpp, struct hist_entry *he,
+				int comparison_method)
+{
+	struct diff_hpp_fmt *dfmt =
+		container_of(fmt, struct diff_hpp_fmt, fmt);
+	struct hist_entry *pair = get_pair_fmt(he, dfmt);
+	double diff;
+	char pfmt[20] = " ";
+
+	if (!pair)
+		goto dummy_print;
+
+	switch (comparison_method) {
+	case COMPUTE_DELTA:
+		if (pair->diff.computed)
+			diff = pair->diff.period_ratio_delta;
+		else
+			diff = compute_delta(he, pair);
+
+		if (fabs(diff) < 0.01)
+			goto dummy_print;
+		scnprintf(pfmt, 20, "%%%+d.2f%%%%", dfmt->header_width - 1);
+		return percent_color_snprintf(hpp->buf, hpp->size,
+					pfmt, diff);
+	default:
+		BUG_ON(1);
+	}
+dummy_print:
+	return scnprintf(hpp->buf, hpp->size, "%*s",
+			dfmt->header_width, pfmt);
+}
+
+static int hpp__color_delta(struct perf_hpp_fmt *fmt,
+			struct perf_hpp *hpp, struct hist_entry *he)
+{
+	return __hpp__color_compare(fmt, hpp, he, COMPUTE_DELTA);
+}
+
 static void
 hpp__entry_unpair(struct hist_entry *he, int idx, char *buf, size_t size)
 {
@@ -940,8 +979,16 @@ static void data__hpp_register(struct data__file *d, int idx)
 	fmt->entry  = hpp__entry_global;
 
 	/* TODO more colors */
-	if (idx == PERF_HPP_DIFF__BASELINE)
+	switch (idx) {
+	case PERF_HPP_DIFF__BASELINE:
 		fmt->color = hpp__color_baseline;
+		break;
+	case PERF_HPP_DIFF__DELTA:
+		fmt->color = hpp__color_delta;
+		break;
+	default:
+		break;
+	}
 
 	init_header(d, dfmt);
 	perf_hpp__column_register(fmt);
diff --git a/tools/perf/util/color.c b/tools/perf/util/color.c
index 66e44a5..ec5c756 100644
--- a/tools/perf/util/color.c
+++ b/tools/perf/util/color.c
@@ -2,6 +2,8 @@
 #include "cache.h"
 #include "color.h"
 
+#include <math.h>
+
 int perf_use_color_default = -1;
 
 static int parse_color(const char *name, int len)
@@ -298,10 +300,10 @@ const char *get_percent_color(double percent)
 	 * entries in green - and keep the low overhead places
 	 * normal:
 	 */
-	if (percent >= MIN_RED)
+	if (fabs(percent) >= MIN_RED)
 		color = PERF_COLOR_RED;
 	else {
-		if (percent > MIN_GREEN)
+		if (fabs(percent) > MIN_GREEN)
 			color = PERF_COLOR_GREEN;
 	}
 	return color;
-- 
1.8.5.rc0.5.g70ebc73.dirty

