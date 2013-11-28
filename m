Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759161Ab3K1LfJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 06:35:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50235 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759134Ab3K1LfC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 06:35:02 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Steven Rostedt <rostedt@goodmis.org>, David Ahern <dsahern@gmail.com>
Subject: [PATCH 29/29] perf tools: Overload pr_stat traceevent print function
Date: Thu, 28 Nov 2013 12:33:28 +0100
Message-Id: <1385638408-23519-30-git-send-email-jolsa@redhat.com>
In-Reply-To: <1385638408-23519-1-git-send-email-jolsa@redhat.com>
References: <1385638408-23519-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The traceevent lib uses pr_stat to display all standard
info. It's defined as __weak. Overloading it with perf
version plugged into perf output system logic.

Displaying the pr_stat stuff under '-v' option.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: David Ahern <dsahern@gmail.com>
---
 tools/perf/util/debug.c | 30 +++++++++++++++++++++++++++---
 tools/perf/util/debug.h |  2 ++
 2 files changed, 29 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/debug.c b/tools/perf/util/debug.c
index 399e74c..8640a91 100644
--- a/tools/perf/util/debug.c
+++ b/tools/perf/util/debug.c
@@ -16,13 +16,11 @@
 int verbose;
 bool dump_trace = false, quiet = false;
 
-int eprintf(int level, const char *fmt, ...)
+static int _eprintf(int level, const char *fmt, va_list args)
 {
-	va_list args;
 	int ret = 0;
 
 	if (verbose >= level) {
-		va_start(args, fmt);
 		if (use_browser >= 1)
 			ui_helpline__vshow(fmt, args);
 		else
@@ -33,6 +31,32 @@ int eprintf(int level, const char *fmt, ...)
 	return ret;
 }
 
+int eprintf(int level, const char *fmt, ...)
+{
+	va_list args;
+	int ret;
+
+	va_start(args, fmt);
+	ret = _eprintf(level, fmt, args);
+	va_end(args);
+
+	return ret;
+}
+
+/*
+ * Overloading libtraceevent standard info print
+ * function, display with -v in perf.
+ */
+void pr_stat(const char *fmt, ...)
+{
+	va_list args;
+
+	va_start(args, fmt);
+	_eprintf(1, fmt, args);
+	va_end(args);
+	eprintf(1, "\n");
+}
+
 int dump_printf(const char *fmt, ...)
 {
 	va_list args;
diff --git a/tools/perf/util/debug.h b/tools/perf/util/debug.h
index efbd988..443694c 100644
--- a/tools/perf/util/debug.h
+++ b/tools/perf/util/debug.h
@@ -17,4 +17,6 @@ void trace_event(union perf_event *event);
 int ui__error(const char *format, ...) __attribute__((format(printf, 1, 2)));
 int ui__warning(const char *format, ...) __attribute__((format(printf, 1, 2)));
 
+void pr_stat(const char *fmt, ...);
+
 #endif	/* __PERF_DEBUG_H */
-- 
1.8.3.1

