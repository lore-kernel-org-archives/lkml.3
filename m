Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752162AbaHOQus (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 12:50:48 -0400
Received: from mail.kernel.org ([198.145.19.201]:44723 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751976AbaHOQuo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 12:50:44 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Naohiro Aota <naota@elisp.net>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 07/18] perf: Use strerror_r instead of strerror
Date: Fri, 15 Aug 2014 13:49:52 -0300
Message-Id: <1408121403-11919-8-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1408121403-11919-1-git-send-email-acme@kernel.org>
References: <1408121403-11919-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Use strerror_r instead of strerror in error messages for thread-safety.
This also introduce STRERR_BUFSIZE macro for the default size of message
buffer for strerror_r.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Naohiro Aota <naota@elisp.net>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20140814022232.3545.14026.stgit@kbuild-fedora.novalocal
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/perf.c       | 10 +++++++---
 tools/perf/util/debug.h |  3 +++
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index 2282d41879a2..452a8474d29d 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -313,6 +313,7 @@ static int run_builtin(struct cmd_struct *p, int argc, const char **argv)
 	int status;
 	struct stat st;
 	const char *prefix;
+	char sbuf[STRERR_BUFSIZE];
 
 	prefix = NULL;
 	if (p->option & RUN_SETUP)
@@ -343,7 +344,8 @@ static int run_builtin(struct cmd_struct *p, int argc, const char **argv)
 	status = 1;
 	/* Check for ENOSPC and EIO errors.. */
 	if (fflush(stdout)) {
-		fprintf(stderr, "write failure on standard output: %s", strerror(errno));
+		fprintf(stderr, "write failure on standard output: %s",
+			strerror_r(errno, sbuf, sizeof(sbuf)));
 		goto out;
 	}
 	if (ferror(stdout)) {
@@ -351,7 +353,8 @@ static int run_builtin(struct cmd_struct *p, int argc, const char **argv)
 		goto out;
 	}
 	if (fclose(stdout)) {
-		fprintf(stderr, "close failed on standard output: %s", strerror(errno));
+		fprintf(stderr, "close failed on standard output: %s",
+			strerror_r(errno, sbuf, sizeof(sbuf)));
 		goto out;
 	}
 	status = 0;
@@ -466,6 +469,7 @@ void pthread__unblock_sigwinch(void)
 int main(int argc, const char **argv)
 {
 	const char *cmd;
+	char sbuf[STRERR_BUFSIZE];
 
 	/* The page_size is placed in util object. */
 	page_size = sysconf(_SC_PAGE_SIZE);
@@ -561,7 +565,7 @@ int main(int argc, const char **argv)
 	}
 
 	fprintf(stderr, "Failed to run command '%s': %s\n",
-		cmd, strerror(errno));
+		cmd, strerror_r(errno, sbuf, sizeof(sbuf)));
 out:
 	return 1;
 }
diff --git a/tools/perf/util/debug.h b/tools/perf/util/debug.h
index 6944ea3a119b..be264d6f3b30 100644
--- a/tools/perf/util/debug.h
+++ b/tools/perf/util/debug.h
@@ -3,6 +3,7 @@
 #define __PERF_DEBUG_H
 
 #include <stdbool.h>
+#include <string.h>
 #include "event.h"
 #include "../ui/helpline.h"
 #include "../ui/progress.h"
@@ -36,6 +37,8 @@ extern int debug_ordered_events;
 #define pr_oe_time(t, fmt, ...)  pr_time_N(1, debug_ordered_events, t, pr_fmt(fmt), ##__VA_ARGS__)
 #define pr_oe_time2(t, fmt, ...) pr_time_N(2, debug_ordered_events, t, pr_fmt(fmt), ##__VA_ARGS__)
 
+#define STRERR_BUFSIZE	128	/* For the buffer size of strerror_r */
+
 int dump_printf(const char *fmt, ...) __attribute__((format(printf, 1, 2)));
 void trace_event(union perf_event *event);
 
-- 
1.9.3

