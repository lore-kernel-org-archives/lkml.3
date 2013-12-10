Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753731Ab3LJJTk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 04:19:40 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44321 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753679Ab3LJJTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 04:19:35 -0500
Date: Tue, 10 Dec 2013 01:19:04 -0800
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-f772abc63462a48df605259fbe1af3fe9b223926@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        rostedt@goodmis.org, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        rostedt@goodmis.org, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1386076182-14484-12-git-send-email-jolsa@redhat.com>
References: <1386076182-14484-12-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Overload pr_stat traceevent print function
Git-Commit-ID: f772abc63462a48df605259fbe1af3fe9b223926
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 10 Dec 2013 01:19:10 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f772abc63462a48df605259fbe1af3fe9b223926
Gitweb:     http://git.kernel.org/tip/f772abc63462a48df605259fbe1af3fe9b223926
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Tue, 3 Dec 2013 14:09:25 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 4 Dec 2013 15:23:55 -0300

perf tools: Overload pr_stat traceevent print function

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
