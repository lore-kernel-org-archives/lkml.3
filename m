Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759546Ab3LBVSK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 16:18:10 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38468 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753946Ab3LBTMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:12:52 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Michael Hudson-Doyle <michael.hudson@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>, Will Deacon <will.deacon@arm.com>,
        Jean Pihet <jean.pihet@linaro.org>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 3.10 021/173] perf tools: Remove cast of non-variadic function to variadic
Date: Mon,  2 Dec 2013 11:10:04 -0800
Message-Id: <20131202191145.268831917@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191142.873808297@linuxfoundation.org>
References: <20131202191142.873808297@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Hudson-Doyle <michael.hudson@linaro.org>

commit 53805eca3d89b095062c11a6798689bb0af09216 upstream.

The 4fb71074a570 (perf ui/hist: Consolidate hpp helpers) cset introduced
a cast of percent_color_snprintf to a function pointer type with
varargs.  Change percent_color_snprintf to be variadic and remove the
cast.

The symptom of this was all percentages being reported as 0.00% in perf
report --stdio output on the armhf arch.

Signed-off-by: Michael Hudson-Doyle <michael.hudson@linaro.org>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Will Deacon <will.deacon@arm.com>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Will Deacon <will.deacon@arm.com>
Link: http://lkml.kernel.org/r/87zjppvw7y.fsf@canonical.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/perf/ui/hist.c    |    2 +-
 tools/perf/util/color.c |   11 +++++++++--
 tools/perf/util/color.h |    2 +-
 3 files changed, 11 insertions(+), 4 deletions(-)

--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -113,7 +113,7 @@ static u64 he_get_##_field(struct hist_e
 static int hpp__color_##_type(struct perf_hpp *hpp, struct hist_entry *he) 	\
 {										\
 	return __hpp__fmt(hpp, he, he_get_##_field, " %6.2f%%",			\
-			  (hpp_snprint_fn)percent_color_snprintf, true);	\
+			  percent_color_snprintf, true);			\
 }
 
 #define __HPP_ENTRY_PERCENT_FN(_type, _field)					\
--- a/tools/perf/util/color.c
+++ b/tools/perf/util/color.c
@@ -318,8 +318,15 @@ int percent_color_fprintf(FILE *fp, cons
 	return r;
 }
 
-int percent_color_snprintf(char *bf, size_t size, const char *fmt, double percent)
+int percent_color_snprintf(char *bf, size_t size, const char *fmt, ...)
 {
-	const char *color = get_percent_color(percent);
+	va_list args;
+	double percent;
+	const char *color;
+
+	va_start(args, fmt);
+	percent = va_arg(args, double);
+	va_end(args);
+	color = get_percent_color(percent);
 	return color_snprintf(bf, size, color, fmt, percent);
 }
--- a/tools/perf/util/color.h
+++ b/tools/perf/util/color.h
@@ -39,7 +39,7 @@ int color_fprintf(FILE *fp, const char *
 int color_snprintf(char *bf, size_t size, const char *color, const char *fmt, ...);
 int color_fprintf_ln(FILE *fp, const char *color, const char *fmt, ...);
 int color_fwrite_lines(FILE *fp, const char *color, size_t count, const char *buf);
-int percent_color_snprintf(char *bf, size_t size, const char *fmt, double percent);
+int percent_color_snprintf(char *bf, size_t size, const char *fmt, ...);
 int percent_color_fprintf(FILE *fp, const char *fmt, double percent);
 const char *get_percent_color(double percent);
 


