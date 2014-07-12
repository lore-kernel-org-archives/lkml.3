Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320AbaGLV5T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 17:57:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55292 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752353AbaGLV4v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 17:56:51 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 3/4] perf tools: Factor eprintf to allow different debug variables
Date: Sat, 12 Jul 2014 23:56:27 +0200
Message-Id: <1405202188-5029-4-git-send-email-jolsa@kernel.org>
In-Reply-To: <1405202188-5029-1-git-send-email-jolsa@kernel.org>
References: <1405202188-5029-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This way we can easily reuse current debug functions for
another debug variables other than verbose.

Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/util/debug.c  | 12 ++++++------
 tools/perf/util/debug.h  | 12 ++++++------
 tools/perf/util/python.c |  4 ++--
 3 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/tools/perf/util/debug.c b/tools/perf/util/debug.c
index 299b555..c208d6f 100644
--- a/tools/perf/util/debug.c
+++ b/tools/perf/util/debug.c
@@ -16,11 +16,11 @@
 int verbose;
 bool dump_trace = false, quiet = false;
 
-static int _eprintf(int level, const char *fmt, va_list args)
+static int _eprintf(int level, int var, const char *fmt, va_list args)
 {
 	int ret = 0;
 
-	if (verbose >= level) {
+	if (var >= level) {
 		if (use_browser >= 1)
 			ui_helpline__vshow(fmt, args);
 		else
@@ -30,13 +30,13 @@ static int _eprintf(int level, const char *fmt, va_list args)
 	return ret;
 }
 
-int eprintf(int level, const char *fmt, ...)
+int eprintf(int level, int var, const char *fmt, ...)
 {
 	va_list args;
 	int ret;
 
 	va_start(args, fmt);
-	ret = _eprintf(level, fmt, args);
+	ret = _eprintf(level, var, fmt, args);
 	va_end(args);
 
 	return ret;
@@ -51,9 +51,9 @@ void pr_stat(const char *fmt, ...)
 	va_list args;
 
 	va_start(args, fmt);
-	_eprintf(1, fmt, args);
+	_eprintf(1, verbose, fmt, args);
 	va_end(args);
-	eprintf(1, "\n");
+	eprintf(1, verbose, "\n");
 }
 
 int dump_printf(const char *fmt, ...)
diff --git a/tools/perf/util/debug.h b/tools/perf/util/debug.h
index 8a8ceb3..1cb8081 100644
--- a/tools/perf/util/debug.h
+++ b/tools/perf/util/debug.h
@@ -16,15 +16,15 @@ extern bool quiet, dump_trace;
 #endif
 
 #define pr_err(fmt, ...) \
-	eprintf(0, pr_fmt(fmt), ##__VA_ARGS__)
+	eprintf(0, verbose, pr_fmt(fmt), ##__VA_ARGS__)
 #define pr_warning(fmt, ...) \
-	eprintf(0, pr_fmt(fmt), ##__VA_ARGS__)
+	eprintf(0, verbose, pr_fmt(fmt), ##__VA_ARGS__)
 #define pr_info(fmt, ...) \
-	eprintf(0, pr_fmt(fmt), ##__VA_ARGS__)
+	eprintf(0, verbose, pr_fmt(fmt), ##__VA_ARGS__)
 #define pr_debug(fmt, ...) \
-	eprintf(1, pr_fmt(fmt), ##__VA_ARGS__)
+	eprintf(1, verbose, pr_fmt(fmt), ##__VA_ARGS__)
 #define pr_debugN(n, fmt, ...) \
-	eprintf(n, pr_fmt(fmt), ##__VA_ARGS__)
+	eprintf(n, verbose, pr_fmt(fmt), ##__VA_ARGS__)
 #define pr_debug2(fmt, ...) pr_debugN(2, pr_fmt(fmt), ##__VA_ARGS__)
 #define pr_debug3(fmt, ...) pr_debugN(3, pr_fmt(fmt), ##__VA_ARGS__)
 #define pr_debug4(fmt, ...) pr_debugN(4, pr_fmt(fmt), ##__VA_ARGS__)
@@ -37,6 +37,6 @@ int ui__warning(const char *format, ...) __attribute__((format(printf, 1, 2)));
 
 void pr_stat(const char *fmt, ...);
 
-int eprintf(int level, const char *fmt, ...) __attribute__((format(printf, 2, 3)));
+int eprintf(int level, int var, const char *fmt, ...) __attribute__((format(printf, 3, 4)));
 
 #endif	/* __PERF_DEBUG_H */
diff --git a/tools/perf/util/python.c b/tools/perf/util/python.c
index 122669c..12aa9b0 100644
--- a/tools/perf/util/python.c
+++ b/tools/perf/util/python.c
@@ -14,12 +14,12 @@
  */
 int verbose;
 
-int eprintf(int level, const char *fmt, ...)
+int eprintf(int level, int var, const char *fmt, ...)
 {
 	va_list args;
 	int ret = 0;
 
-	if (verbose >= level) {
+	if (var >= level) {
 		va_start(args, fmt);
 		ret = vfprintf(stderr, fmt, args);
 		va_end(args);
-- 
1.8.3.1

