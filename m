Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692AbaANQm0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 11:42:26 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52901 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578AbaANQmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 11:42:20 -0500
Date: Tue, 14 Jan 2014 08:42:02 -0800
From: tip-bot for Ramkumar Ramachandra <tipbot@zytor.com>
Message-ID: <tip-1f513b2c1e8a2008b8ab767fdb6fa6c154591ed3@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, artagnon@gmail.com, tglx@linutronix.de,
        jolsa@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, tglx@linutronix.de, artagnon@gmail.com,
        jolsa@redhat.com
In-Reply-To: <1388388861-7931-4-git-send-email-artagnon@gmail.com>
References: <1388388861-7931-4-git-send-email-artagnon@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf diff: Color the Ratio column
Git-Commit-ID: 1f513b2c1e8a2008b8ab767fdb6fa6c154591ed3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 14 Jan 2014 08:42:10 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1f513b2c1e8a2008b8ab767fdb6fa6c154591ed3
Gitweb:     http://git.kernel.org/tip/1f513b2c1e8a2008b8ab767fdb6fa6c154591ed3
Author:     Ramkumar Ramachandra <artagnon@gmail.com>
AuthorDate: Mon, 30 Dec 2013 13:04:20 +0530
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 13 Jan 2014 11:37:17 -0300

perf diff: Color the Ratio column

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
index 6c3f220..73d8bff 100644
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
index 8cda46c..87b8672 100644
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
