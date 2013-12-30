Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751823Ab3L3HeW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 02:34:22 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:35076 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614Ab3L3HeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 02:34:06 -0500
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>, Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH v6 4/4] perf diff: color the Weighted Diff column
Date: Mon, 30 Dec 2013 13:04:21 +0530
Message-Id: <1388388861-7931-5-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.5.2.227.g53f3478
In-Reply-To: <1388388861-7931-1-git-send-email-artagnon@gmail.com>
References: <1388388861-7931-1-git-send-email-artagnon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In

  $ perf diff -c wdiff:M,N

color the numbers in the Weighted Diff column using
value_color_snprintf().

Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
---
 tools/perf/builtin-diff.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index c07cd3c..9c69620 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -777,6 +777,7 @@ static int __hpp__color_compare(struct perf_hpp_fmt *fmt,
 		container_of(fmt, struct diff_hpp_fmt, fmt);
 	struct hist_entry *pair = get_pair_fmt(he, dfmt);
 	double diff;
+	s64 wdiff;
 	char pfmt[20] = " ";
 
 	if (!pair)
@@ -805,6 +806,17 @@ static int __hpp__color_compare(struct perf_hpp_fmt *fmt,
 		scnprintf(pfmt, 20, "%%%d.6f", dfmt->header_width);
 		return value_color_snprintf(hpp->buf, hpp->size,
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
+		return value_color_snprintf(hpp->buf, hpp->size,
+					pfmt, wdiff);
 	default:
 		BUG_ON(1);
 	}
@@ -825,6 +837,12 @@ static int hpp__color_ratio(struct perf_hpp_fmt *fmt,
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
@@ -1006,6 +1024,9 @@ static void data__hpp_register(struct data__file *d, int idx)
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
1.8.5.2.227.g53f3478

