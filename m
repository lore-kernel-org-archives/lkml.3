Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752132AbaHRIYo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 04:24:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51611 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000AbaHRIYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 04:24:41 -0400
Date: Mon, 18 Aug 2014 01:23:05 -0700
From: tip-bot for Masami Hiramatsu <tipbot@zytor.com>
Message-ID: <tip-b2348e1d8a67c58de44820587fabc4f987eafbb6@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, naota@elisp.net, namhyung@kernel.org,
        masami.hiramatsu.pt@hitachi.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        naota@elisp.net, namhyung@kernel.org, masami.hiramatsu.pt@hitachi.com,
        tglx@linutronix.de
In-Reply-To: <20140814022232.3545.14026.stgit@kbuild-fedora.novalocal>
References: <20140814022232.3545.14026.stgit@kbuild-fedora.novalocal>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Use strerror_r instead of strerror
Git-Commit-ID: b2348e1d8a67c58de44820587fabc4f987eafbb6
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

Commit-ID:  b2348e1d8a67c58de44820587fabc4f987eafbb6
Gitweb:     http://git.kernel.org/tip/b2348e1d8a67c58de44820587fabc4f987eafbb6
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Thu, 14 Aug 2014 02:22:32 +0000
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 15 Aug 2014 10:54:29 -0300

perf: Use strerror_r instead of strerror

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
 
