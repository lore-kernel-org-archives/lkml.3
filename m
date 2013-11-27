Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754991Ab3K0LMs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 06:12:48 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:33163 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754271Ab3K0LMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 06:12:30 -0500
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH v3 4/4] perf diff: color the Weighted Diff column
Date: Wed, 27 Nov 2013 16:32:34 +0530
Message-Id: <1385550154-11385-5-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.5.rc0.5.g70ebc73.dirty
In-Reply-To: <1385550154-11385-1-git-send-email-artagnon@gmail.com>
References: <1385550154-11385-1-git-send-email-artagnon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In

  $ perf diff -c wdiff:M,N

color the numbers in the Weighted Diff column either green or red,
depending on whether the number is positive or negative.

Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
---
 tools/perf/builtin-diff.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 26f6517..9422314 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -777,6 +777,7 @@ static int __hpp__color_compare(struct perf_hpp_fmt *fmt,
 		container_of(fmt, struct diff_hpp_fmt, fmt);
 	struct hist_entry *pair = get_pair_fmt(he, dfmt);
 	double diff;
+	s64 wdiff;
 	char pfmt[20] = " ";
 
 	if (!pair)
@@ -806,6 +807,18 @@ static int __hpp__color_compare(struct perf_hpp_fmt *fmt,
 		scnprintf(pfmt, 20, "%%%d.6f", dfmt->header_width);
 		return percent_color_snprintf(hpp->buf, hpp->size,
 					pfmt, diff);
+	case COMPUTE_WEIGHTED_DIFF:
+		if (he->dummy)
+			goto dummy_print;
+		if (pair->diff.computed)
+			wdiff = pair->diff.wdiff;
+		else
+			wdiff = compute_wdiff(he, pair);
+
+		scnprintf(pfmt, 20, "%%14ld", dfmt->header_width);
+		return color_snprintf(hpp->buf, hpp->size,
+				wdiff > 0 ? PERF_COLOR_GREEN : PERF_COLOR_RED,
+				pfmt, wdiff);
 	default:
 		BUG_ON(1);
 	}
@@ -826,6 +839,12 @@ static int hpp__color_ratio(struct perf_hpp_fmt *fmt,
 	return __hpp__color_compare(fmt, hpp, he, COMPUTE_RATIO);
 }
 
+static int hpp__color_wdiff(struct perf_hpp_fmt *fmt,
+			struct perf_hpp *hpp, struct hist_entry *he)
+{
+	return __hpp__color_compare(fmt, hpp, he, COMPUTE_WEIGHTED_DIFF);
+}
+
 static void
 hpp__entry_unpair(struct hist_entry *he, int idx, char *buf, size_t size)
 {
@@ -1007,6 +1026,9 @@ static void data__hpp_register(struct data__file *d, int idx)
 	case PERF_HPP_DIFF__RATIO:
 		fmt->color = hpp__color_ratio;
 		break;
+	case PERF_HPP_DIFF__WEIGHTED_DIFF:
+		fmt->color = hpp__color_wdiff;
+		break;
 	default:
 		break;
 	}
-- 
1.8.5.rc0.5.g70ebc73.dirty

