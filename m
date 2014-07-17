Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935008AbaGQQPL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 12:15:11 -0400
Received: from mail.kernel.org ([198.145.19.201]:52738 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934972AbaGQQPG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 12:15:06 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 30/33] perf tools: Factor eprintf to allow different debug variables
Date: Thu, 17 Jul 2014 13:12:32 -0300
Message-Id: <1405613555-23380-31-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1405613555-23380-1-git-send-email-acme@kernel.org>
References: <1405613555-23380-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@kernel.org>

This way we can easily reuse current debug functions for another debug
variables other than verbose.
Signed-off-by: Jiri Olsa <jolsa@kernel.org>

Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1405374411-29012-4-git-send-email-jolsa@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/debug.c  | 12 ++++++------
 tools/perf/util/debug.h  | 12 ++++++------
 tools/perf/util/python.c |  4 ++--
 3 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/tools/perf/util/debug.c b/tools/perf/util/debug.c
index 299b55586502..c208d6f56e63 100644
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
index 8a8ceb3ccde9..1cb808123242 100644
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
index 122669c18ff4..12aa9b0d0ba1 100644
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
1.9.3

