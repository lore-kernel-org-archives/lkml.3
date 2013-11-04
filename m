Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751931Ab3KDLGj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 06:06:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36659 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750808Ab3KDLGh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 06:06:37 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Adrian Hunter <adrian.hunter@intel.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 1/3] perf tools: Factor sysfs code into generic fs object
Date: Mon,  4 Nov 2013 12:06:11 +0100
Message-Id: <1383563173-17466-2-git-send-email-jolsa@redhat.com>
In-Reply-To: <1383563173-17466-1-git-send-email-jolsa@redhat.com>
References: <1383563173-17466-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moving sysfs code into generic fs object and preparing
it to carry procfs support.

This should be merged with tools/lib/lk/debugfs.c at
some point in the future.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile.perf           |   4 +-
 tools/perf/tests/parse-events.c    |   2 +-
 tools/perf/util/cpumap.c           |   2 +-
 tools/perf/util/fs.c               | 107 +++++++++++++++++++++++++++++++++++++
 tools/perf/util/fs.h               |   6 +++
 tools/perf/util/pmu.c              |   2 +-
 tools/perf/util/python-ext-sources |   2 +-
 tools/perf/util/sysfs.c            |  60 ---------------------
 tools/perf/util/sysfs.h            |   6 ---
 9 files changed, 119 insertions(+), 72 deletions(-)
 create mode 100644 tools/perf/util/fs.c
 create mode 100644 tools/perf/util/fs.h
 delete mode 100644 tools/perf/util/sysfs.c
 delete mode 100644 tools/perf/util/sysfs.h

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index bc7cfa1..f5d3251 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -242,7 +242,7 @@ LIB_H += util/cache.h
 LIB_H += util/callchain.h
 LIB_H += util/build-id.h
 LIB_H += util/debug.h
-LIB_H += util/sysfs.h
+LIB_H += util/fs.h
 LIB_H += util/pmu.h
 LIB_H += util/event.h
 LIB_H += util/evsel.h
@@ -303,7 +303,7 @@ LIB_OBJS += $(OUTPUT)util/annotate.o
 LIB_OBJS += $(OUTPUT)util/build-id.o
 LIB_OBJS += $(OUTPUT)util/config.o
 LIB_OBJS += $(OUTPUT)util/ctype.o
-LIB_OBJS += $(OUTPUT)util/sysfs.o
+LIB_OBJS += $(OUTPUT)util/fs.o
 LIB_OBJS += $(OUTPUT)util/pmu.o
 LIB_OBJS += $(OUTPUT)util/environment.o
 LIB_OBJS += $(OUTPUT)util/event.o
diff --git a/tools/perf/tests/parse-events.c b/tools/perf/tests/parse-events.c
index 48114d1..f47bf45 100644
--- a/tools/perf/tests/parse-events.c
+++ b/tools/perf/tests/parse-events.c
@@ -2,7 +2,7 @@
 #include "parse-events.h"
 #include "evsel.h"
 #include "evlist.h"
-#include "sysfs.h"
+#include "fs.h"
 #include <lk/debugfs.h>
 #include "tests.h"
 #include <linux/hw_breakpoint.h>
diff --git a/tools/perf/util/cpumap.c b/tools/perf/util/cpumap.c
index beb8cf9..4af5a23 100644
--- a/tools/perf/util/cpumap.c
+++ b/tools/perf/util/cpumap.c
@@ -1,5 +1,5 @@
 #include "util.h"
-#include "sysfs.h"
+#include "fs.h"
 #include "../perf.h"
 #include "cpumap.h"
 #include <assert.h>
diff --git a/tools/perf/util/fs.c b/tools/perf/util/fs.c
new file mode 100644
index 0000000..346669a
--- /dev/null
+++ b/tools/perf/util/fs.c
@@ -0,0 +1,107 @@
+
+/* TODO merge/factor into tools/lib/lk/debugfs.c */
+
+#include "util.h"
+#include "util/fs.h"
+
+static const char * const sysfs_known_mountpoints[] = {
+	"/sys",
+	0,
+};
+
+struct perf_fs {
+	const char		*name;
+	const char * const	*mounts;
+	char			 path[PATH_MAX + 1];
+	bool			 found;
+	long			 magic;
+};
+
+enum {
+	FS_SYSFS = 0,
+};
+
+static struct perf_fs fss[] = {
+	[FS_SYSFS] = {
+		.name	= "sysfs",
+		.mounts	= sysfs_known_mountpoints,
+		.magic	= SYSFS_MAGIC,
+	},
+};
+
+static bool read_mounts(struct perf_fs *fs)
+{
+	bool found = false;
+	char type[100];
+	FILE *fp;
+
+	fp = fopen("/proc/mounts", "r");
+	if (fp == NULL)
+		return NULL;
+
+	while (!found &&
+	       fscanf(fp, "%*s %" STR(PATH_MAX) "s %99s %*s %*d %*d\n",
+		      fs->path, type) == 2) {
+
+		if (strcmp(type, fs->name) == 0)
+			found = true;
+	}
+
+	fclose(fp);
+	return fs->found = found;
+}
+
+static int valid_mount(const char *fs, long magic)
+{
+	struct statfs st_fs;
+
+	if (statfs(fs, &st_fs) < 0)
+		return -ENOENT;
+	else if (st_fs.f_type != magic)
+		return -ENOENT;
+
+	return 0;
+}
+
+static bool check_mounts(struct perf_fs *fs)
+{
+	const char * const *ptr;
+
+	ptr = fs->mounts;
+	while (*ptr) {
+		if (valid_mount(*ptr, fs->magic) == 0) {
+			fs->found = true;
+			strcpy(fs->path, *ptr);
+			return true;
+		}
+		ptr++;
+	}
+
+	return false;
+}
+
+static const char *get_mountpoint(struct perf_fs *fs)
+{
+	if (check_mounts(fs))
+		return fs->path;
+
+	return read_mounts(fs) ? fs->path : NULL;
+}
+
+static const char *find_mountpoint(int idx)
+{
+	struct perf_fs *fs = &fss[idx];
+
+	if (fs->found)
+		return (const char *) fs->path;
+
+	return get_mountpoint(fs);
+}
+
+#define FIND_MOUNTPOINT(name, idx)		\
+const char *name##_find_mountpoint(void)	\
+{						\
+	return find_mountpoint(idx);		\
+}
+
+FIND_MOUNTPOINT(sysfs, FS_SYSFS);
diff --git a/tools/perf/util/fs.h b/tools/perf/util/fs.h
new file mode 100644
index 0000000..082edbd
--- /dev/null
+++ b/tools/perf/util/fs.h
@@ -0,0 +1,6 @@
+#ifndef __PERF_FS
+#define __PERF_FS
+
+const char *sysfs_find_mountpoint(void);
+
+#endif /* __PERF_FS */
diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index 64362fe..45b42df 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -4,7 +4,7 @@
 #include <unistd.h>
 #include <stdio.h>
 #include <dirent.h>
-#include "sysfs.h"
+#include "fs.h"
 #include "util.h"
 #include "pmu.h"
 #include "parse-events.h"
diff --git a/tools/perf/util/python-ext-sources b/tools/perf/util/python-ext-sources
index f75ae1b..239036f 100644
--- a/tools/perf/util/python-ext-sources
+++ b/tools/perf/util/python-ext-sources
@@ -17,5 +17,5 @@ util/xyarray.c
 util/cgroup.c
 util/rblist.c
 util/strlist.c
-util/sysfs.c
+util/fs.c
 ../../lib/rbtree.c
diff --git a/tools/perf/util/sysfs.c b/tools/perf/util/sysfs.c
deleted file mode 100644
index f71e9ea..0000000
--- a/tools/perf/util/sysfs.c
+++ /dev/null
@@ -1,60 +0,0 @@
-
-#include "util.h"
-#include "sysfs.h"
-
-static const char * const sysfs_known_mountpoints[] = {
-	"/sys",
-	0,
-};
-
-static int sysfs_found;
-char sysfs_mountpoint[PATH_MAX + 1];
-
-static int sysfs_valid_mountpoint(const char *sysfs)
-{
-	struct statfs st_fs;
-
-	if (statfs(sysfs, &st_fs) < 0)
-		return -ENOENT;
-	else if (st_fs.f_type != (long) SYSFS_MAGIC)
-		return -ENOENT;
-
-	return 0;
-}
-
-const char *sysfs_find_mountpoint(void)
-{
-	const char * const *ptr;
-	char type[100];
-	FILE *fp;
-
-	if (sysfs_found)
-		return (const char *) sysfs_mountpoint;
-
-	ptr = sysfs_known_mountpoints;
-	while (*ptr) {
-		if (sysfs_valid_mountpoint(*ptr) == 0) {
-			sysfs_found = 1;
-			strcpy(sysfs_mountpoint, *ptr);
-			return sysfs_mountpoint;
-		}
-		ptr++;
-	}
-
-	/* give up and parse /proc/mounts */
-	fp = fopen("/proc/mounts", "r");
-	if (fp == NULL)
-		return NULL;
-
-	while (!sysfs_found &&
-	       fscanf(fp, "%*s %" STR(PATH_MAX) "s %99s %*s %*d %*d\n",
-		      sysfs_mountpoint, type) == 2) {
-
-		if (strcmp(type, "sysfs") == 0)
-			sysfs_found = 1;
-	}
-
-	fclose(fp);
-
-	return sysfs_found ? sysfs_mountpoint : NULL;
-}
diff --git a/tools/perf/util/sysfs.h b/tools/perf/util/sysfs.h
deleted file mode 100644
index a813b72..0000000
--- a/tools/perf/util/sysfs.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef __SYSFS_H__
-#define __SYSFS_H__
-
-const char *sysfs_find_mountpoint(void);
-
-#endif /* __DEBUGFS_H__ */
-- 
1.7.11.7

