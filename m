Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731Ab3K0LM1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 06:12:27 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:38293 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754101Ab3K0LMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 06:12:23 -0500
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH v3 1/4] perf diff: color the Delta column
Date: Wed, 27 Nov 2013 16:32:31 +0530
Message-Id: <1385550154-11385-2-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.5.rc0.5.g70ebc73.dirty
In-Reply-To: <1385550154-11385-1-git-send-email-artagnon@gmail.com>
References: <1385550154-11385-1-git-send-email-artagnon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Color the numbers in the Delta column either green or red depending on
whether the number is positive or negative.

Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
---
 tools/perf/builtin-diff.c | 37 ++++++++++++++++++++++++++++++++++++-
 1 file changed, 36 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 3b67ea2..fe6e200 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -769,6 +769,33 @@ static int hpp__entry_baseline(struct hist_entry *he, char *buf, size_t size)
 	return ret;
 }
 
+static int hpp__color_delta(struct perf_hpp_fmt *fmt,
+			struct perf_hpp *hpp, struct hist_entry *he)
+{
+	struct diff_hpp_fmt *dfmt =
+		container_of(fmt, struct diff_hpp_fmt, fmt);
+	struct hist_entry *pair = get_pair_fmt(he, dfmt);
+	double percent;
+	char pfmt[20] = " ";
+
+	if (!pair)
+		goto dummy_print;
+	if (pair->diff.computed)
+		percent = pair->diff.period_ratio_delta;
+	else
+		percent = compute_delta(he, pair);
+
+	if (fabs(percent) >= 0.01) {
+		scnprintf(pfmt, 20, "%%%+d.2f%%%%", dfmt->header_width - 1);
+		return color_snprintf(hpp->buf, hpp->size,
+				percent > 0 ? PERF_COLOR_GREEN : PERF_COLOR_RED,
+				pfmt, percent);
+	} else
+dummy_print:
+		return scnprintf(hpp->buf, hpp->size, "%*s",
+				dfmt->header_width, pfmt);
+}
+
 static void
 hpp__entry_unpair(struct hist_entry *he, int idx, char *buf, size_t size)
 {
@@ -940,8 +967,16 @@ static void data__hpp_register(struct data__file *d, int idx)
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
1.8.5.rc0.5.g70ebc73.dirty

