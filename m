Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754253Ab3LTFNL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 00:13:11 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:50330 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963Ab3LTFLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 00:11:22 -0500
X-AuditID: 9c93016f-b7cc5ae000007121-44-52b3d178b6de
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 3/7] perf tools: Introduce struct perf_log
Date: Fri, 20 Dec 2013 14:11:14 +0900
Message-Id: <1387516278-17024-4-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1387516278-17024-1-git-send-email-namhyung@kernel.org>
References: <1387516278-17024-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Add new functions to save error messages in a temp file.  It'll be
used by some UI front-ends to see the messages.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/Makefile.perf |   1 +
 tools/perf/perf.c        |   3 ++
 tools/perf/util/debug.h  |  15 +++++++
 tools/perf/util/log.c    | 105 +++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 124 insertions(+)
 create mode 100644 tools/perf/util/log.c

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 97a2145e4cc6..ec8184014a76 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -372,6 +372,7 @@ LIB_OBJS += $(OUTPUT)util/stat.o
 LIB_OBJS += $(OUTPUT)util/record.o
 LIB_OBJS += $(OUTPUT)util/srcline.o
 LIB_OBJS += $(OUTPUT)util/data.o
+LIB_OBJS += $(OUTPUT)util/log.o
 
 LIB_OBJS += $(OUTPUT)ui/setup.o
 LIB_OBJS += $(OUTPUT)ui/helpline.o
diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index 431798a4110d..bdf7bd8e4394 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -10,6 +10,7 @@
 
 #include "util/exec_cmd.h"
 #include "util/cache.h"
+#include "util/debug.h"
 #include "util/quote.h"
 #include "util/run-command.h"
 #include "util/parse-events.h"
@@ -524,6 +525,7 @@ int main(int argc, const char **argv)
 	 */
 	pthread__block_sigwinch();
 
+	perf_log_init();
 	while (1) {
 		static int done_help;
 		int was_alias = run_argv(&argc, &argv);
@@ -543,6 +545,7 @@ int main(int argc, const char **argv)
 		} else
 			break;
 	}
+	perf_log_exit();
 
 	fprintf(stderr, "Failed to run command '%s': %s\n",
 		cmd, strerror(errno));
diff --git a/tools/perf/util/debug.h b/tools/perf/util/debug.h
index 443694c36b03..ea160abc2ae0 100644
--- a/tools/perf/util/debug.h
+++ b/tools/perf/util/debug.h
@@ -19,4 +19,19 @@ int ui__warning(const char *format, ...) __attribute__((format(printf, 1, 2)));
 
 void pr_stat(const char *fmt, ...);
 
+struct perf_log {
+	FILE *fp;
+	off_t *linemap;
+	u32 lines;
+	u32 nr_alloc;
+	bool seen_newline;
+};
+
+extern struct perf_log perf_log;
+
+int perf_log_init(void);
+int perf_log_exit(void);
+void perf_log_add(const char *msg);
+void perf_log_addv(const char *fmt, va_list ap);
+
 #endif	/* __PERF_DEBUG_H */
diff --git a/tools/perf/util/log.c b/tools/perf/util/log.c
new file mode 100644
index 000000000000..4a34bed2af44
--- /dev/null
+++ b/tools/perf/util/log.c
@@ -0,0 +1,105 @@
+#include <stdio.h>
+#include <stdlib.h>
+#include "util/debug.h"
+
+#define LINEMAP_GROW  128
+
+struct perf_log perf_log = {
+	.seen_newline = true,
+};
+
+int perf_log_init(void)
+{
+	FILE *fp;
+	char name[] = "/tmp/perf-tui-log-XXXXXX";
+	int fd = mkstemp(name);
+
+	if (fd < 0)
+		return -1;
+
+	fp = fdopen(fd, "r+");
+	if (fp == NULL) {
+		close(fd);
+		return -1;
+	}
+
+	perf_log.fp = fp;
+
+	return 0;
+}
+
+int perf_log_exit(void)
+{
+	FILE *fp = perf_log.fp;
+	if (fp)
+		fclose(fp);
+
+	free(perf_log.linemap);
+
+	perf_log.fp = NULL;
+	perf_log.linemap = NULL;
+	return 0;
+}
+
+static int grow_linemap(struct perf_log *log)
+{
+	off_t *newmap;
+	int newsize = log->nr_alloc + LINEMAP_GROW;
+
+	newmap = realloc(log->linemap, newsize * sizeof(*log->linemap));
+	if (newmap == NULL)
+		return -1;
+
+	log->nr_alloc = newsize;
+	log->linemap = newmap;
+	return 0;
+}
+
+static int __add_to_linemap(struct perf_log *log, off_t index)
+{
+	if (log->lines == log->nr_alloc)
+		if (grow_linemap(log) < 0)
+			return -1;
+
+	log->linemap[log->lines++] = index;
+	return 0;
+}
+
+static void add_to_linemap(struct perf_log *log, const char *msg, off_t base)
+{
+	const char *pos;
+
+	if (strlen(msg) == 0)
+		return;
+
+	if (log->seen_newline) {
+		if (__add_to_linemap(log, base) < 0)
+			return;
+	}
+
+	if ((pos = strchr(msg, '\n')) != NULL) {
+		log->seen_newline = true;
+		pos++;
+		add_to_linemap(log, pos, base + (pos - msg));
+	} else {
+		log->seen_newline = false;
+	}
+}
+
+void perf_log_add(const char *msg)
+{
+	FILE *fp = perf_log.fp;
+	off_t offset = ftello(fp);
+
+	add_to_linemap(&perf_log, msg, offset);
+
+	fwrite(msg, 1, strlen(msg), fp);
+}
+
+void perf_log_addv(const char *fmt, va_list ap)
+{
+	char buf[4096];
+
+	vsnprintf(buf, sizeof(buf), fmt, ap);
+	perf_log_add(buf);
+}
-- 
1.7.11.7

