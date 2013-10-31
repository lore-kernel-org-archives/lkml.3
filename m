Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090Ab3JaXrx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 19:47:53 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46056 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766Ab3JaXrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 19:47:51 -0400
From: Michael Hudson-Doyle <michael.hudson@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Will Deacon <will.deacon@arm.com>, Jean Pihet <jean.pihet@linaro.org>
Subject: [PATCH v2] perf tools: Remove cast of non-variadic function to variadic
User-Agent: Notmuch/0.15.2 (http://notmuchmail.org) Emacs/24.3.50.2 (x86_64-pc-linux-gnu)
Date: Thu, 31 Oct 2013 16:47:45 -0700
Message-ID: <87zjppvw7y.fsf@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

4fb71074a570 (perf ui/hist: Consolidate hpp helpers) introduced a cast of
percent_color_snprintf to a function pointer type with varargs.  Change
percent_color_snprintf to be variadic and remove the cast.

The symptom of this was all percentages being reported as 0.00% in perf
report --stdio output.

Signed-off-by: Michael Hudson-Doyle <michael.hudson@linaro.org>
Acked-by: Will Deacon <will.deacon@arm.com>
Cc: <stable@vger.kernel.org>
---
 tools/perf/ui/hist.c    |  2 +-
 tools/perf/util/color.c | 11 +++++++++--
 tools/perf/util/color.h |  2 +-
 3 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index 0a19328..78f4c92 100644
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
index 11e46da..66e44a5 100644
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
index dea082b..fced384 100644
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
1.8.3.2

