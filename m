Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753863Ab3KAO5D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 10:57:03 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53256 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753060Ab3KAO47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 10:56:59 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Michael Hudson-Doyle <michael.hudson@linaro.org>,
        Jean Pihet <jean.pihet@linaro.org>, Jiri Olsa <jolsa@redhat.com>,
        Will Deacon <will.deacon@arm.com>, stable@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 1/3] perf tools: Remove cast of non-variadic function to variadic
Date: Fri,  1 Nov 2013 11:56:45 -0300
Message-Id: <1383317807-25062-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1383317807-25062-1-git-send-email-acme@infradead.org>
References: <1383317807-25062-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Hudson-Doyle <michael.hudson@linaro.org>

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
Cc: stable@vger.kernel.org
Link: http://lkml.kernel.org/r/87zjppvw7y.fsf@canonical.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/hist.c    |  2 +-
 tools/perf/util/color.c | 11 +++++++++--
 tools/perf/util/color.h |  2 +-
 3 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index 0a193281eba8..78f4c92e9b73 100644
--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -117,7 +117,7 @@ static int hpp__color_##_type(struct perf_hpp_fmt *fmt __maybe_unused,		\
 			      struct perf_hpp *hpp, struct hist_entry *he) 	\
 {										\
 	return __hpp__fmt(hpp, he, he_get_##_field, " %6.2f%%",			\
-			  (hpp_snprint_fn)percent_color_snprintf, true);	\
+			  percent_color_snprintf, true);			\
 }
 
 #define __HPP_ENTRY_PERCENT_FN(_type, _field)					\
diff --git a/tools/perf/util/color.c b/tools/perf/util/color.c
index 11e46da17bbb..66e44a5019d5 100644
--- a/tools/perf/util/color.c
+++ b/tools/perf/util/color.c
@@ -318,8 +318,15 @@ int percent_color_fprintf(FILE *fp, const char *fmt, double percent)
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
diff --git a/tools/perf/util/color.h b/tools/perf/util/color.h
index dea082b79602..fced3840e99c 100644
--- a/tools/perf/util/color.h
+++ b/tools/perf/util/color.h
@@ -39,7 +39,7 @@ int color_fprintf(FILE *fp, const char *color, const char *fmt, ...);
 int color_snprintf(char *bf, size_t size, const char *color, const char *fmt, ...);
 int color_fprintf_ln(FILE *fp, const char *color, const char *fmt, ...);
 int color_fwrite_lines(FILE *fp, const char *color, size_t count, const char *buf);
-int percent_color_snprintf(char *bf, size_t size, const char *fmt, double percent);
+int percent_color_snprintf(char *bf, size_t size, const char *fmt, ...);
 int percent_color_fprintf(FILE *fp, const char *fmt, double percent);
 const char *get_percent_color(double percent);
 
-- 
1.8.1.4

