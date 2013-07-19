Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754999Ab3GSHo3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 03:44:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35171 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964929Ab3GSHoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 03:44:25 -0400
Date: Fri, 19 Jul 2013 00:43:58 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-167aedc44e1743777e6aee71b0fe7ed94c6298cd@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, fweisbec@gmail.com, rostedt@goodmis.org,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, fweisbec@gmail.com, rostedt@goodmis.org,
        dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1372230862-15861-2-git-send-email-namhyung@kernel.org>
References: <1372230862-15861-2-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf util: Move debugfs/
 tracing helper functions to util.c
Git-Commit-ID: 167aedc44e1743777e6aee71b0fe7ed94c6298cd
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 19 Jul 2013 00:44:06 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  167aedc44e1743777e6aee71b0fe7ed94c6298cd
Gitweb:     http://git.kernel.org/tip/167aedc44e1743777e6aee71b0fe7ed94c6298cd
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Wed, 26 Jun 2013 16:14:04 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 12 Jul 2013 13:46:00 -0300

perf util: Move debugfs/tracing helper functions to util.c

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
