Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933386Ab3LDULh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 15:11:37 -0500
Received: from merlin.infradead.org ([205.233.59.134]:59390 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933287Ab3LDUHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 15:07:21 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 22/38] perf tools: Overload pr_stat traceevent print function
Date: Wed,  4 Dec 2013 17:06:46 -0300
Message-Id: <1386187622-2928-23-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1386187622-2928-1-git-send-email-acme@infradead.org>
References: <1386187622-2928-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

The traceevent lib uses pr_stat to display all standard info. It's
defined as __weak. Overloading it with perf version plugged into perf
output system logic.

Displaying the pr_stat stuff under '-v' option.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1386076182-14484-12-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/debug.c | 30 +++++++++++++++++++++++++++---
 tools/perf/util/debug.h |  2 ++
 2 files changed, 29 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/debug.c b/tools/perf/util/debug.c
index 399e74c34c1a..8640a9121e72 100644
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
index efbd98805ad0..443694c36b03 100644
--- a/tools/perf/util/debug.h
+++ b/tools/perf/util/debug.h
@@ -17,4 +17,6 @@ void trace_event(union perf_event *event);
 int ui__error(const char *format, ...) __attribute__((format(printf, 1, 2)));
 int ui__warning(const char *format, ...) __attribute__((format(printf, 1, 2)));
 
+void pr_stat(const char *fmt, ...);
+
 #endif	/* __PERF_DEBUG_H */
-- 
1.8.1.4

