Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184AbaHNCWR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 22:22:17 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:51794 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752908AbaHNCUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 22:20:33 -0400
X-AuditID: 85900ec0-d312bb9000001514-aa-53ec1cef4ea9
Subject: [PATCH 2/8] perf: Use strerror_r instead of strerror
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Naohiro Aota <naota@elisp.net>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung@kernel.org>
Date: Thu, 14 Aug 2014 02:20:30 +0000
Message-ID: <20140814022030.3140.32103.stgit@kbuild-fedora.novalocal>
In-Reply-To: <20140814022025.3140.33134.stgit@kbuild-fedora.novalocal>
References: <20140814022025.3140.33134.stgit@kbuild-fedora.novalocal>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use strerror_r instead of strerror in error messages for
thread-safety. This also introduce STRERR_BUFSIZE macro
for the default size of message buffer for strerror_r.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
---
 tools/perf/perf.c       |   10 +++++++---
 tools/perf/util/debug.h |    3 +++
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index 2282d41..452a847 100644
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
index 6944ea3..be264d6 100644
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
 

