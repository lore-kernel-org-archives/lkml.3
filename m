Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754122Ab3L3Heq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 02:34:46 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:34113 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542Ab3L3HeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 02:34:01 -0500
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>, Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH v6 2/4] perf diff: color the Delta column
Date: Mon, 30 Dec 2013 13:04:19 +0530
Message-Id: <1388388861-7931-3-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.5.2.227.g53f3478
In-Reply-To: <1388388861-7931-1-git-send-email-artagnon@gmail.com>
References: <1388388861-7931-1-git-send-email-artagnon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Color the numbers in the Delta column using
percent_color_snprintf(). Generalize the coloring function so that we
can accommodate all three comparison methods in future patches: delta,
ratio, and wdiff.

Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
---
 tools/perf/builtin-diff.c | 49 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 48 insertions(+), 1 deletion(-)

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
-- 
1.8.5.2.227.g53f3478

