Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079Ab3CULD0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 07:03:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56149 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754509Ab3CULDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 07:03:24 -0400
Date: Thu, 21 Mar 2013 04:01:13 -0700
From: tip-bot for Borislav Petkov <tipbot@zytor.com>
Message-ID: <tip-1355915ac626da30a0c02ccd4569c1e5ce2cbb82@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, rostedt@goodmis.org, tglx@linutronix.de, bp@suse.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, rostedt@goodmis.org, tglx@linutronix.de, bp@suse.de
In-Reply-To: <1361374353-30385-6-git-send-email-bp@alien8.de>
References: <1361374353-30385-6-git-send-email-bp@alien8.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Extract perf-specific stuff from debugfs.c
Git-Commit-ID: 1355915ac626da30a0c02ccd4569c1e5ce2cbb82
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 21 Mar 2013 04:01:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1355915ac626da30a0c02ccd4569c1e5ce2cbb82
Gitweb:     http://git.kernel.org/tip/1355915ac626da30a0c02ccd4569c1e5ce2cbb82
Author:     Borislav Petkov <bp@suse.de>
AuthorDate: Wed, 20 Feb 2013 16:32:31 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 15 Mar 2013 13:06:01 -0300

perf tools: Extract perf-specific stuff from debugfs.c

Move them to util.c and simplify code a bit.

Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1361374353-30385-6-git-send-email-bp@alien8.de
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/lk/debugfs.c             | 15 ---------------
 tools/lib/lk/debugfs.h             |  2 --
 tools/perf/perf.c                  |  6 +++---
 tools/perf/util/trace-event-info.c |  2 +-
 tools/perf/util/util.c             | 27 +++++++++++++++++++++++++++
 tools/perf/util/util.h             |  7 +++++--
 6 files changed, 36 insertions(+), 23 deletions(-)

diff --git a/tools/lib/lk/debugfs.c b/tools/lib/lk/debugfs.c
index 9cda7a6..099e7cd 100644
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
index bc5ad2d..935c59b 100644
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
index f53b735..f6ba7b7 100644
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
index 36b9b49..5c1509a 100644
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
index 805d1f5..59d868a 100644
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
index 09b4c26..6a0781c 100644
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
