Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935833Ab3BTPdc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 10:33:32 -0500
Received: from mail.skyhub.de ([78.46.96.112]:51008 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935743Ab3BTPck (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 10:32:40 -0500
From: Borislav Petkov <bp@alien8.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 5/7] perf: Extract perf-specific stuff from debugfs.c
Date: Wed, 20 Feb 2013 16:32:31 +0100
Message-Id: <1361374353-30385-6-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.1.3.535.ga923c31
In-Reply-To: <1361374353-30385-1-git-send-email-bp@alien8.de>
References: <1361374353-30385-1-git-send-email-bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

Move them to util.c and simplify code a bit.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 tools/lib/lk/debugfs.c             | 15 ---------------
 tools/lib/lk/debugfs.h             |  2 --
 tools/perf/perf.c                  |  6 +++---
 tools/perf/util/trace-event-info.c |  2 +-
 tools/perf/util/util.c             | 27 +++++++++++++++++++++++++++
 tools/perf/util/util.h             |  7 +++++--
 6 files changed, 36 insertions(+), 23 deletions(-)

diff --git a/tools/lib/lk/debugfs.c b/tools/lib/lk/debugfs.c
index 9cda7a6f5917..099e7cd022e4 100644
--- a/tools/lib/lk/debugfs.c
+++ b/tools/lib/lk/debugfs.c
@@ -11,7 +11,6 @@
 #include "debugfs.h"
 
 char debugfs_mountpoint[PATH_MAX + 1] = "/sys/kernel/debug";
-char tracing_events_path[PATH_MAX + 1] = "/sys/kernel/debug/tracing/events";
 
 static const char * const debugfs_known_mountpoints[] = {
 	"/sys/kernel/debug/",
@@ -75,14 +74,7 @@ int debugfs_valid_mountpoint(const char *debugfs)
 	return 0;
 }
 
-static void debugfs_set_tracing_events_path(const char *mountpoint)
-{
-	snprintf(tracing_events_path, sizeof(tracing_events_path), "%s/%s",
-		 mountpoint, "tracing/events");
-}
-
 /* mount the debugfs somewhere if it's not mounted */
-
 char *debugfs_mount(const char *mountpoint)
 {
 	/* see if it's already mounted */
@@ -105,12 +97,5 @@ char *debugfs_mount(const char *mountpoint)
 	debugfs_found = true;
 	strncpy(debugfs_mountpoint, mountpoint, sizeof(debugfs_mountpoint));
 out:
-	debugfs_set_tracing_events_path(debugfs_mountpoint);
 	return debugfs_mountpoint;
 }
-
-void debugfs_set_path(const char *mountpoint)
-{
-	snprintf(debugfs_mountpoint, sizeof(debugfs_mountpoint), "%s", mountpoint);
-	debugfs_set_tracing_events_path(mountpoint);
-}
diff --git a/tools/lib/lk/debugfs.h b/tools/lib/lk/debugfs.h
index bc5ad2df7c0a..935c59bdb442 100644
--- a/tools/lib/lk/debugfs.h
+++ b/tools/lib/lk/debugfs.h
@@ -23,9 +23,7 @@
 const char *debugfs_find_mountpoint(void);
 int debugfs_valid_mountpoint(const char *debugfs);
 char *debugfs_mount(const char *mountpoint);
-void debugfs_set_path(const char *mountpoint);
 
 extern char debugfs_mountpoint[];
-extern char tracing_events_path[];
 
 #endif /* __LK_DEBUGFS_H__ */
diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index f53b735e2822..f6ba7b73f40e 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -193,13 +193,13 @@ static int handle_options(const char ***argv, int *argc, int *envchanged)
 				fprintf(stderr, "No directory given for --debugfs-dir.\n");
 				usage(perf_usage_string);
 			}
-			debugfs_set_path((*argv)[1]);
+			perf_debugfs_set_path((*argv)[1]);
 			if (envchanged)
 				*envchanged = 1;
 			(*argv)++;
 			(*argc)--;
 		} else if (!prefixcmp(cmd, CMD_DEBUGFS_DIR)) {
-			debugfs_set_path(cmd + strlen(CMD_DEBUGFS_DIR));
+			perf_debugfs_set_path(cmd + strlen(CMD_DEBUGFS_DIR));
 			fprintf(stderr, "dir: %s\n", debugfs_mountpoint);
 			if (envchanged)
 				*envchanged = 1;
@@ -461,7 +461,7 @@ int main(int argc, const char **argv)
 	if (!cmd)
 		cmd = "perf-help";
 	/* get debugfs mount point from /proc/mounts */
-	debugfs_mount(NULL);
+	perf_debugfs_mount(NULL);
 	/*
 	 * "perf-xxxx" is the same as "perf xxxx", but we obviously:
 	 *
diff --git a/tools/perf/util/trace-event-info.c b/tools/perf/util/trace-event-info.c
index 36b9b49d0177..5c1509ab0c29 100644
--- a/tools/perf/util/trace-event-info.c
+++ b/tools/perf/util/trace-event-info.c
@@ -80,7 +80,7 @@ static void *malloc_or_die(unsigned int size)
 
 static const char *find_debugfs(void)
 {
-	const char *path = debugfs_mount(NULL);
+	const char *path = perf_debugfs_mount(NULL);
 
 	if (!path)
 		die("Your kernel not support debugfs filesystem");
diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
index 805d1f52c5b4..59d868add275 100644
--- a/tools/perf/util/util.c
+++ b/tools/perf/util/util.c
@@ -17,6 +17,8 @@ bool test_attr__enabled;
 bool perf_host  = true;
 bool perf_guest = false;
 
+char tracing_events_path[PATH_MAX + 1] = "/sys/kernel/debug/tracing/events";
+
 void event_attr_init(struct perf_event_attr *attr)
 {
 	if (!perf_host)
@@ -242,3 +244,28 @@ void get_term_dimensions(struct winsize *ws)
 	ws->ws_row = 25;
 	ws->ws_col = 80;
 }
+
+static void set_tracing_events_path(const char *mountpoint)
+{
+	snprintf(tracing_events_path, sizeof(tracing_events_path), "%s/%s",
+		 mountpoint, "tracing/events");
+}
+
+const char *perf_debugfs_mount(const char *mountpoint)
+{
+	const char *mnt;
+
+	mnt = debugfs_mount(mountpoint);
+	if (!mnt)
+		return NULL;
+
+	set_tracing_events_path(mnt);
+
+	return mnt;
+}
+
+void perf_debugfs_set_path(const char *mntpt)
+{
+	snprintf(debugfs_mountpoint, strlen(debugfs_mountpoint), "%s", mntpt);
+	set_tracing_events_path(mntpt);
+}
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index 09b4c26b71aa..6a0781c3a573 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -73,10 +73,14 @@
 #include <linux/magic.h>
 #include "types.h"
 #include <sys/ttydefaults.h>
+#include <lk/debugfs.h>
 
 extern const char *graph_line;
 extern const char *graph_dotted_line;
 extern char buildid_dir[];
+extern char tracing_events_path[];
+extern void perf_debugfs_set_path(const char *mountpoint);
+const char *perf_debugfs_mount(const char *mountpoint);
 
 /* On most systems <limits.h> would have given us this, but
  * not on some systems (e.g. GNU/Hurd).
@@ -274,5 +278,4 @@ extern unsigned int page_size;
 
 struct winsize;
 void get_term_dimensions(struct winsize *ws);
-
-#endif
+#endif /* GIT_COMPAT_UTIL_H */
-- 
1.8.1.3.535.ga923c31

