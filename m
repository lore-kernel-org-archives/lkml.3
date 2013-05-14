Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756748Ab3ENKOE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 06:14:04 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:53910 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756223Ab3ENKOC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 06:14:02 -0400
X-AuditID: 9c930197-b7b76ae000003523-2b-51920e694b36
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>
Subject: [PATCH 01/15] perf util: Move debugfs/tracing helper functions to util.c
Date: Tue, 14 May 2013 19:13:45 +0900
Message-Id: <1368526439-31966-2-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1368526439-31966-1-git-send-email-namhyung@kernel.org>
References: <1368526439-31966-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Since they're generic helpers move them to util.c so that they can be
used by others.

Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/trace-event-info.c | 59 --------------------------------------
 tools/perf/util/util.c             | 59 ++++++++++++++++++++++++++++++++++++++
 tools/perf/util/util.h             |  3 ++
 3 files changed, 62 insertions(+), 59 deletions(-)

diff --git a/tools/perf/util/trace-event-info.c b/tools/perf/util/trace-event-info.c
index e85cbcf298f3..ab18bf12d54a 100644
--- a/tools/perf/util/trace-event-info.c
+++ b/tools/perf/util/trace-event-info.c
@@ -46,65 +46,6 @@
 static int output_fd;
 
 
-static const char *find_debugfs(void)
-{
-	const char *path = perf_debugfs_mount(NULL);
-
-	if (!path)
-		pr_debug("Your kernel does not support the debugfs filesystem");
-
-	return path;
-}
-
-/*
- * Finds the path to the debugfs/tracing
- * Allocates the string and stores it.
- */
-static const char *find_tracing_dir(void)
-{
-	static char *tracing;
-	static int tracing_found;
-	const char *debugfs;
-
-	if (tracing_found)
-		return tracing;
-
-	debugfs = find_debugfs();
-	if (!debugfs)
-		return NULL;
-
-	tracing = malloc(strlen(debugfs) + 9);
-	if (!tracing)
-		return NULL;
-
-	sprintf(tracing, "%s/tracing", debugfs);
-
-	tracing_found = 1;
-	return tracing;
-}
-
-static char *get_tracing_file(const char *name)
-{
-	const char *tracing;
-	char *file;
-
-	tracing = find_tracing_dir();
-	if (!tracing)
-		return NULL;
-
-	file = malloc(strlen(tracing) + strlen(name) + 2);
-	if (!file)
-		return NULL;
-
-	sprintf(file, "%s/%s", tracing, name);
-	return file;
-}
-
-static void put_tracing_file(char *file)
-{
-	free(file);
-}
-
 int bigendian(void)
 {
 	unsigned char str[] = { 0x1, 0x2, 0x3, 0x4, 0x0, 0x0, 0x0, 0x0};
diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
index 59d868add275..9a0658405760 100644
--- a/tools/perf/util/util.c
+++ b/tools/perf/util/util.c
@@ -269,3 +269,62 @@ void perf_debugfs_set_path(const char *mntpt)
 	snprintf(debugfs_mountpoint, strlen(debugfs_mountpoint), "%s", mntpt);
 	set_tracing_events_path(mntpt);
 }
+
+static const char *find_debugfs(void)
+{
+	const char *path = perf_debugfs_mount(NULL);
+
+	if (!path)
+		fprintf(stderr, "Your kernel does not support the debugfs filesystem");
+
+	return path;
+}
+
+/*
+ * Finds the path to the debugfs/tracing
+ * Allocates the string and stores it.
+ */
+const char *find_tracing_dir(void)
+{
+	static char *tracing;
+	static int tracing_found;
+	const char *debugfs;
+
+	if (tracing_found)
+		return tracing;
+
+	debugfs = find_debugfs();
+	if (!debugfs)
+		return NULL;
+
+	tracing = malloc(strlen(debugfs) + 9);
+	if (!tracing)
+		return NULL;
+
+	sprintf(tracing, "%s/tracing", debugfs);
+
+	tracing_found = 1;
+	return tracing;
+}
+
+char *get_tracing_file(const char *name)
+{
+	const char *tracing;
+	char *file;
+
+	tracing = find_tracing_dir();
+	if (!tracing)
+		return NULL;
+
+	file = malloc(strlen(tracing) + strlen(name) + 2);
+	if (!file)
+		return NULL;
+
+	sprintf(file, "%s/%s", tracing, name);
+	return file;
+}
+
+void put_tracing_file(char *file)
+{
+	free(file);
+}
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index 7a484c97e500..8f3e44ca1074 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -79,6 +79,9 @@ extern char buildid_dir[];
 extern char tracing_events_path[];
 extern void perf_debugfs_set_path(const char *mountpoint);
 const char *perf_debugfs_mount(const char *mountpoint);
+const char *find_tracing_dir(void);
+char *get_tracing_file(const char *name);
+void put_tracing_file(char *file);
 
 /* On most systems <limits.h> would have given us this, but
  * not on some systems (e.g. GNU/Hurd).
-- 
1.7.11.7

