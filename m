Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755600Ab3KEUKT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 15:10:19 -0500
Received: from merlin.infradead.org ([205.233.59.134]:38826 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754644Ab3KEUKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 15:10:14 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 06/10] perf tools: Factor sysfs code into generic fs object
Date: Tue,  5 Nov 2013 17:09:57 -0300
Message-Id: <1383682201-19399-7-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1383682201-19399-1-git-send-email-acme@infradead.org>
References: <1383682201-19399-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Moving sysfs code into generic fs object and preparing it to carry
procfs support.

This should be merged with tools/lib/lk/debugfs.c at some point in the
future.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1383660887-1734-2-git-send-email-jolsa@redhat.com
[ Added fs__ namespace qualifier to some more functions ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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
index 5b8639025aae..7fc8f179cae7 100644
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
@@ -304,7 +304,7 @@ LIB_OBJS += $(OUTPUT)util/annotate.o
 LIB_OBJS += $(OUTPUT)util/build-id.o
 LIB_OBJS += $(OUTPUT)util/config.o
 LIB_OBJS += $(OUTPUT)util/ctype.o
-LIB_OBJS += $(OUTPUT)util/sysfs.o
+LIB_OBJS += $(OUTPUT)util/fs.o
 LIB_OBJS += $(OUTPUT)util/pmu.o
 LIB_OBJS += $(OUTPUT)util/environment.o
 LIB_OBJS += $(OUTPUT)util/event.o
diff --git a/tools/perf/tests/parse-events.c b/tools/perf/tests/parse-events.c
index 48114d164e9f..f47bf459c3f5 100644
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
index beb8cf9f9976..4af5a23b2423 100644
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
index 000000000000..a2413e842a02
--- /dev/null
+++ b/tools/perf/util/fs.c
@@ -0,0 +1,107 @@
+
+/* TODO merge/factor into tools/lib/lk/debugfs.c */
+
+#include "util.h"
+#include "util/fs.h"
+
+static const char * const sysfs__fs_known_mountpoints[] = {
+	"/sys",
+	0,
+};
+
+struct fs {
+	const char		*name;
+	const char * const	*mounts;
+	char			 path[PATH_MAX + 1];
+	bool			 found;
+	long			 magic;
+};
+
+enum {
+	FS__SYSFS = 0,
+};
+
+static struct fs fs__entries[] = {
+	[FS__SYSFS] = {
+		.name	= "sysfs",
+		.mounts	= sysfs__fs_known_mountpoints,
+		.magic	= SYSFS_MAGIC,
+	},
+};
+
+static bool fs__read_mounts(struct fs *fs)
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
+static int fs__valid_mount(const char *fs, long magic)
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
+static bool fs__check_mounts(struct fs *fs)
+{
+	const char * const *ptr;
+
+	ptr = fs->mounts;
+	while (*ptr) {
+		if (fs__valid_mount(*ptr, fs->magic) == 0) {
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
+static const char *fs__get_mountpoint(struct fs *fs)
+{
+	if (fs__check_mounts(fs))
+		return fs->path;
+
+	return fs__read_mounts(fs) ? fs->path : NULL;
+}
+
+static const char *fs__find_mountpoint(int idx)
+{
+	struct fs *fs = &fs__entries[idx];
+
+	if (fs->found)
+		return (const char *)fs->path;
+
+	return fs__get_mountpoint(fs);
+}
+
+#define FIND_MOUNTPOINT(name, idx)		\
+const char *name##_find_mountpoint(void)	\
+{						\
+	return fs__find_mountpoint(idx);	\
+}
+
+FIND_MOUNTPOINT(sysfs, FS__SYSFS);
diff --git a/tools/perf/util/fs.h b/tools/perf/util/fs.h
new file mode 100644
index 000000000000..082edbd2159b
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
index 64362fe45b71..45b42dffcd70 100644
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
index f75ae1b9900c..239036fb2b2c 100644
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
index f71e9eafe15a..000000000000
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
index a813b7203938..000000000000
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
1.8.1.4

