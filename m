Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372Ab3LJMug (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 07:50:36 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:46378 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277Ab3LJMuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 07:50:32 -0500
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH v5 2/3] perf diff: color the Ratio column
Date: Tue, 10 Dec 2013 18:19:01 +0530
Message-Id: <1386679742-13357-3-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.5.rc0.5.g70ebc73.dirty
In-Reply-To: <1386679742-13357-1-git-send-email-artagnon@gmail.com>
References: <1386679742-13357-1-git-send-email-artagnon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In

  $ perf diff -c ratio

color the Ratio column using value_color_snprintf(), a new function that
operates exactly like percent_color_snprintf(). At first glance, it
looks like percent_color_snprintf() can be turned into a non-variadic
function simplifying things; however, 53805ec (perf tools: Remove cast
of non-variadic function to variadic, 2013-10-31) explains why it needs
to be a variadic function.

Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
---
 tools/perf/builtin-diff.c | 20 ++++++++++++++++++++
 tools/perf/util/color.c   | 10 +++++++---
 tools/perf/util/color.h   |  1 +
 3 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index a8fc525..c07cd3c 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -794,6 +794,17 @@ static int __hpp__color_compare(struct perf_hpp_fmt *fmt,
 		scnprintf(pfmt, 20, "%%%+d.2f%%%%", dfmt->header_width - 1);
 		return percent_color_snprintf(hpp->buf, hpp->size,
 					pfmt, diff);
+	case COMPUTE_RATIO:
+		if (he->dummy)
+			goto dummy_print;
+		if (pair->diff.computed)
+			diff = pair->diff.period_ratio;
+		else
+			diff = compute_ratio(he, pair);
+
+		scnprintf(pfmt, 20, "%%%d.6f", dfmt->header_width);
+		return value_color_snprintf(hpp->buf, hpp->size,
+					pfmt, diff);
 	default:
 		BUG_ON(1);
 	}
@@ -808,6 +819,12 @@ static int hpp__color_delta(struct perf_hpp_fmt *fmt,
 	return __hpp__color_compare(fmt, hpp, he, COMPUTE_DELTA);
 }
 
+static int hpp__color_ratio(struct perf_hpp_fmt *fmt,
+			struct perf_hpp *hpp, struct hist_entry *he)
+{
+	return __hpp__color_compare(fmt, hpp, he, COMPUTE_RATIO);
+}
+
 static void
 hpp__entry_unpair(struct hist_entry *he, int idx, char *buf, size_t size)
 {
@@ -986,6 +1003,9 @@ static void data__hpp_register(struct data__file *d, int idx)
 	case PERF_HPP_DIFF__DELTA:
 		fmt->color = hpp__color_delta;
 		break;
+	case PERF_HPP_DIFF__RATIO:
+		fmt->color = hpp__color_ratio;
+		break;
 	default:
 		break;
 	}
diff --git a/tools/perf/util/color.c b/tools/perf/util/color.c
index ec5c756..0c0b552 100644
--- a/tools/perf/util/color.c
+++ b/tools/perf/util/color.c
@@ -320,15 +320,19 @@ int percent_color_fprintf(FILE *fp, const char *fmt, double percent)
 	return r;
 }
 
+int value_color_snprintf(char *bf, size_t size, const char *fmt, double value)
+{
+	const char *color = get_percent_color(value);
+	return color_snprintf(bf, size, color, fmt, value);
+}
+
 int percent_color_snprintf(char *bf, size_t size, const char *fmt, ...)
 {
 	va_list args;
 	double percent;
-	const char *color;
 
 	va_start(args, fmt);
 	percent = va_arg(args, double);
 	va_end(args);
-	color = get_percent_color(percent);
-	return color_snprintf(bf, size, color, fmt, percent);
+	return value_color_snprintf(bf, size, fmt, percent);
 }
diff --git a/tools/perf/util/color.h b/tools/perf/util/color.h
index fced384..7ff30a6 100644
--- a/tools/perf/util/color.h
+++ b/tools/perf/util/color.h
@@ -39,6 +39,7 @@ int color_fprintf(FILE *fp, const char *color, const char *fmt, ...);
 int color_snprintf(char *bf, size_t size, const char *color, const char *fmt, ...);
 int color_fprintf_ln(FILE *fp, const char *color, const char *fmt, ...);
 int color_fwrite_lines(FILE *fp, const char *color, size_t count, const char *buf);
+int value_color_snprintf(char *bf, size_t size, const char *fmt, double value);
 int percent_color_snprintf(char *bf, size_t size, const char *fmt, ...);
 int percent_color_fprintf(FILE *fp, const char *fmt, double percent);
 const char *get_percent_color(double percent);
-- 
1.8.5.rc0.5.g70ebc73.dirty

