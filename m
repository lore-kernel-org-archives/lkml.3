Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752684AbaAMUyq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 15:54:46 -0500
Received: from merlin.infradead.org ([205.233.59.134]:40410 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912AbaAMUsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 15:48:09 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Ramkumar Ramachandra <artagnon@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 35/38] perf diff: Color the Ratio column
Date: Mon, 13 Jan 2014 17:47:36 -0300
Message-Id: <1389646059-24881-36-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1389646059-24881-1-git-send-email-acme@infradead.org>
References: <1389646059-24881-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ramkumar Ramachandra <artagnon@gmail.com>

In

  $ perf diff -c ratio

color the Ratio column using value_color_snprintf(), a new function that
operates exactly like percent_color_snprintf().

At first glance, it looks like percent_color_snprintf() can be turned
into a non-variadic function simplifying things; however, 53805ec (perf
tools: Remove cast of non-variadic function to variadic, 2013-10-31)
explains why it needs to be a variadic function.

Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/r/1388388861-7931-4-git-send-email-artagnon@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-diff.c | 20 ++++++++++++++++++++
 tools/perf/util/color.c   | 10 +++++++---
 tools/perf/util/color.h   |  1 +
 3 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 6c3f220115ac..73d8bffdd484 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -795,6 +795,17 @@ static int __hpp__color_compare(struct perf_hpp_fmt *fmt,
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
@@ -809,6 +820,12 @@ static int hpp__color_delta(struct perf_hpp_fmt *fmt,
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
@@ -987,6 +1004,9 @@ static void data__hpp_register(struct data__file *d, int idx)
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
index 8cda46c43e74..87b8672eb413 100644
--- a/tools/perf/util/color.c
+++ b/tools/perf/util/color.c
@@ -319,15 +319,19 @@ int percent_color_fprintf(FILE *fp, const char *fmt, double percent)
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
index fced3840e99c..7ff30a62a132 100644
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
1.8.1.4

