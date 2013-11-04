Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751685Ab3KDGy6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 01:54:58 -0500
Received: from terminus.zytor.com ([198.137.202.10]:42438 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718Ab3KDGy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 01:54:56 -0500
Date: Sun, 3 Nov 2013 22:54:32 -0800
From: tip-bot for Michael Hudson-Doyle <tipbot@zytor.com>
Message-ID: <tip-53805eca3d89b095062c11a6798689bb0af09216@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, will.deacon@arm.com, jean.pihet@linaro.org,
        namhyung@kernel.org, jolsa@redhat.com, tglx@linutronix.de,
        michael.hudson@linaro.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, will.deacon@arm.com, jean.pihet@linaro.org,
        namhyung@kernel.org, jolsa@redhat.com, michael.hudson@linaro.org,
        tglx@linutronix.de
In-Reply-To: <87zjppvw7y.fsf@canonical.com>
References: <87zjppvw7y.fsf@canonical.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Remove cast of non-variadic function to variadic
Git-Commit-ID: 53805eca3d89b095062c11a6798689bb0af09216
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sun, 03 Nov 2013 22:54:38 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  53805eca3d89b095062c11a6798689bb0af09216
Gitweb:     http://git.kernel.org/tip/53805eca3d89b095062c11a6798689bb0af09216
Author:     Michael Hudson-Doyle <michael.hudson@linaro.org>
AuthorDate: Thu, 31 Oct 2013 16:47:45 -0700
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 1 Nov 2013 10:40:51 -0300

perf tools: Remove cast of non-variadic function to variadic

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
 
