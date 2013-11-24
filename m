Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932213Ab3KXGaR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Nov 2013 01:30:17 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:53756 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753140Ab3KXG3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Nov 2013 01:29:44 -0500
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH v2 5/5] perf diff: color the Weighted Diff column
Date: Sun, 24 Nov 2013 11:50:25 +0530
Message-Id: <1385274025-30282-6-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.5.rc0.5.g70ebc73.dirty
In-Reply-To: <1385274025-30282-1-git-send-email-artagnon@gmail.com>
References: <1385274025-30282-1-git-send-email-artagnon@gmail.com>
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
index be2550c..f3f5d8e 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -777,6 +777,7 @@ static int __hpp__color_compare(struct perf_hpp_fmt *fmt,
 		container_of(fmt, struct diff_hpp_fmt, fmt);
 	struct hist_entry *pair = get_pair_fmt(he, dfmt);
 	double delta;
+	s64 wdiff;
 	char pfmt[20] = " ";
 
 	if (!pair)
@@ -789,6 +790,9 @@ static int __hpp__color_compare(struct perf_hpp_fmt *fmt,
 		case COMPUTE_RATIO:
 			delta = pair->diff.period_ratio;
 			break;
+		case COMPUTE_WEIGHTED_DIFF:
+			wdiff = pair->diff.wdiff;
+			break;
 		default:
 			BUG_ON(1);
 		}
@@ -800,6 +804,9 @@ static int __hpp__color_compare(struct perf_hpp_fmt *fmt,
 		case COMPUTE_RATIO:
 			delta = compute_ratio(he, pair);
 			break;
+		case COMPUTE_WEIGHTED_DIFF:
+			wdiff = compute_wdiff(he, pair);
+			break;
 		default:
 			BUG_ON(1);
 		}
@@ -819,6 +826,12 @@ static int __hpp__color_compare(struct perf_hpp_fmt *fmt,
 			return percent_color_snprintf(hpp->buf, hpp->size,
 						pfmt, delta);
 			break;
+		case COMPUTE_WEIGHTED_DIFF:
+			scnprintf(pfmt, 20, "%%14ld", dfmt->header_width);
+			return color_snprintf(hpp->buf, hpp->size,
+					wdiff > 0 ? PERF_COLOR_GREEN : PERF_COLOR_RED,
+					pfmt, wdiff);
+			break;
 		default:
 			BUG_ON(1);
 		}
@@ -840,6 +853,12 @@ static int hpp__color_ratio(struct perf_hpp_fmt *fmt,
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
@@ -1024,6 +1043,9 @@ static void data__hpp_register(struct data__file *d, int idx)
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

