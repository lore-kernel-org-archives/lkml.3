Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754499AbbAXSOy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 13:14:54 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:30616 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753261AbbAXSOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 13:14:50 -0500
Message-Id: <20150124181448.499062732@goodmis.org>
User-Agent: quilt/0.61-1
Date: Sat, 24 Jan 2015 13:13:31 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 1/5] tools lib fs: Add helper to find mounted file systems
References: <20150124181330.195149364@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0001-tools-lib-fs-Add-helper-to-find-mounted-file-systems.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

In preparation for adding tracefs for perf to use, create a findfs
helper utility that find_debugfs uses instead of hard coding the search
in the code. This will allow for a find_tracefs to be used as well.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/lib/api/Makefile     |  2 ++
 tools/lib/api/fs/debugfs.c | 45 ++++-----------------------------
 tools/lib/api/fs/findfs.c  | 63 ++++++++++++++++++++++++++++++++++++++++++++++
 tools/lib/api/fs/findfs.h  | 10 ++++++++
 4 files changed, 80 insertions(+), 40 deletions(-)
 create mode 100644 tools/lib/api/fs/findfs.c
 create mode 100644 tools/lib/api/fs/findfs.h

diff --git a/tools/lib/api/Makefile b/tools/lib/api/Makefile
index 36c08b1f4afb..22b2f15d7255 100644
--- a/tools/lib/api/Makefile
+++ b/tools/lib/api/Makefile
@@ -9,11 +9,13 @@ LIB_H=
 LIB_OBJS=
 
 LIB_H += fs/debugfs.h
+LIB_H += fs/findfs.h
 LIB_H += fs/fs.h
 # See comment below about piggybacking...
 LIB_H += fd/array.h
 
 LIB_OBJS += $(OUTPUT)fs/debugfs.o
+LIB_OBJS += $(OUTPUT)fs/findfs.o
 LIB_OBJS += $(OUTPUT)fs/fs.o
 # XXX piggybacking here, need to introduce libapikfd, or rename this
 # to plain libapik.a and make it have it all api goodies
diff --git a/tools/lib/api/fs/debugfs.c b/tools/lib/api/fs/debugfs.c
index a74fba6d7743..76eb92c0623f 100644
--- a/tools/lib/api/fs/debugfs.c
+++ b/tools/lib/api/fs/debugfs.c
@@ -8,6 +8,7 @@
 #include <linux/kernel.h>
 
 #include "debugfs.h"
+#include "findfs.h"
 
 char debugfs_mountpoint[PATH_MAX + 1] = "/sys/kernel/debug";
 
@@ -22,55 +23,19 @@ static bool debugfs_found;
 /* find the path to the mounted debugfs */
 const char *debugfs_find_mountpoint(void)
 {
-	const char * const *ptr;
-	char type[100];
-	FILE *fp;
-
 	if (debugfs_found)
 		return (const char *)debugfs_mountpoint;
 
-	ptr = debugfs_known_mountpoints;
-	while (*ptr) {
-		if (debugfs_valid_mountpoint(*ptr) == 0) {
-			debugfs_found = true;
-			strcpy(debugfs_mountpoint, *ptr);
-			return debugfs_mountpoint;
-		}
-		ptr++;
-	}
-
-	/* give up and parse /proc/mounts */
-	fp = fopen("/proc/mounts", "r");
-	if (fp == NULL)
-		return NULL;
-
-	while (fscanf(fp, "%*s %" STR(PATH_MAX) "s %99s %*s %*d %*d\n",
-		      debugfs_mountpoint, type) == 2) {
-		if (strcmp(type, "debugfs") == 0)
-			break;
-	}
-	fclose(fp);
-
-	if (strcmp(type, "debugfs") != 0)
-		return NULL;
-
-	debugfs_found = true;
-
-	return debugfs_mountpoint;
+	return find_mountpoint("debugfs", (long) DEBUGFS_MAGIC,
+			       debugfs_mountpoint, PATH_MAX + 1,
+			       debugfs_known_mountpoints);
 }
 
 /* verify that a mountpoint is actually a debugfs instance */
 
 int debugfs_valid_mountpoint(const char *debugfs)
 {
-	struct statfs st_fs;
-
-	if (statfs(debugfs, &st_fs) < 0)
-		return -ENOENT;
-	else if (st_fs.f_type != (long) DEBUGFS_MAGIC)
-		return -ENOENT;
-
-	return 0;
+	return valid_mountpoint(debugfs, (long) DEBUGFS_MAGIC);
 }
 
 /* mount the debugfs somewhere if it's not mounted */
diff --git a/tools/lib/api/fs/findfs.c b/tools/lib/api/fs/findfs.c
new file mode 100644
index 000000000000..fc62c84cc2e9
--- /dev/null
+++ b/tools/lib/api/fs/findfs.c
@@ -0,0 +1,63 @@
+#include <errno.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <stdbool.h>
+#include <sys/vfs.h>
+
+#include "findfs.h"
+
+/* verify that a mountpoint is actually the type we want */
+
+int valid_mountpoint(const char *mount, long magic)
+{
+	struct statfs st_fs;
+
+	if (statfs(mount, &st_fs) < 0)
+		return -ENOENT;
+	else if (st_fs.f_type != magic)
+		return -ENOENT;
+
+	return 0;
+}
+
+/* find the path to a mounted file system */
+const char *find_mountpoint(const char *fstype, long magic,
+			    char *mountpoint, int len,
+			    const char * const *known_mountpoints)
+{
+	const char * const *ptr;
+	char format[128];
+	char type[100];
+	FILE *fp;
+
+	if (known_mountpoints) {
+		ptr = known_mountpoints;
+		while (*ptr) {
+			if (valid_mountpoint(*ptr, magic) == 0) {
+				strncpy(mountpoint, *ptr, len - 1);
+				mountpoint[len-1] = 0;
+				return mountpoint;
+			}
+			ptr++;
+		}
+	}
+
+	/* give up and parse /proc/mounts */
+	fp = fopen("/proc/mounts", "r");
+	if (fp == NULL)
+		return NULL;
+
+	snprintf(format, 128, "%%*s %%%ds %%99s %%*s %%*d %%*d\n", len);
+
+	while (fscanf(fp, format, mountpoint, type) == 2) {
+		if (strcmp(type, fstype) == 0)
+			break;
+	}
+	fclose(fp);
+
+	if (strcmp(type, fstype) != 0)
+		return NULL;
+
+	return mountpoint;
+}
diff --git a/tools/lib/api/fs/findfs.h b/tools/lib/api/fs/findfs.h
new file mode 100644
index 000000000000..37bd7d94ce7e
--- /dev/null
+++ b/tools/lib/api/fs/findfs.h
@@ -0,0 +1,10 @@
+#ifndef __API_FINDFS_H__
+#define __API_FINDFS_H__
+
+const char *find_mountpoint(const char *fstype, long magic,
+			    char *mountpoint, int len,
+			    const char * const *known_mountpoints);
+
+int valid_mountpoint(const char *mount, long magic);
+
+#endif /* __API_FINDFS_H__ */
-- 
2.1.4


