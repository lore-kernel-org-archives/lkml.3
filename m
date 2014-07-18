Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965108AbaGRE2S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 00:28:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33405 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933537AbaGRE2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 00:28:14 -0400
Date: Thu, 17 Jul 2014 21:27:56 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-c95688aac7723c17b2badc23233706b2f02e58ed@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, jolsa@kernel.org,
        a.p.zijlstra@chello.nl, namhyung@kernel.org, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, jolsa@kernel.org,
        a.p.zijlstra@chello.nl, namhyung@kernel.org, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com
In-Reply-To: <1405374411-29012-4-git-send-email-jolsa@kernel.org>
References: <1405374411-29012-4-git-send-email-jolsa@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Factor eprintf to allow different debug variables
Git-Commit-ID: c95688aac7723c17b2badc23233706b2f02e58ed
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c95688aac7723c17b2badc23233706b2f02e58ed
Gitweb:     http://git.kernel.org/tip/c95688aac7723c17b2badc23233706b2f02e58ed
Author:     Jiri Olsa <jolsa@kernel.org>
AuthorDate: Mon, 14 Jul 2014 23:46:49 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 17 Jul 2014 12:58:59 -0300

perf tools: Factor eprintf to allow different debug variables

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
