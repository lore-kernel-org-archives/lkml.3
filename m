Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965372Ab3GRUL2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 16:11:28 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41475 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759399Ab3GRTuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 15:50:21 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 09/76] perf util: Move debugfs/tracing helper functions to util.c
Date: Thu, 18 Jul 2013 16:48:56 -0300
Message-Id: <1374177003-3706-10-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1374177003-3706-1-git-send-email-acme@infradead.org>
References: <1374177003-3706-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Since they're generic helpers move them to util.c so that they can be
used by others.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1372230862-15861-2-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/trace-event-info.c | 59 --------------------------------------
 tools/perf/util/util.c             | 59 ++++++++++++++++++++++++++++++++++++++
 tools/perf/util/util.h             |  3 ++
 3 files changed, 62 insertions(+), 59 deletions(-)

diff --git a/tools/perf/util/trace-event-info.c b/tools/perf/util/trace-event-info.c
index 3917eb9..615c062 100644
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
index 59d868a..9a06584 100644
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
index 2732fad..cc1574e 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -80,6 +80,9 @@ extern char buildid_dir[];
 extern char tracing_events_path[];
 extern void perf_debugfs_set_path(const char *mountpoint);
 const char *perf_debugfs_mount(const char *mountpoint);
+const char *find_tracing_dir(void);
+char *get_tracing_file(const char *name);
+void put_tracing_file(char *file);
 
 /* On most systems <limits.h> would have given us this, but
  * not on some systems (e.g. GNU/Hurd).
-- 
1.8.1.4

