Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752620AbaBRVKm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 16:10:42 -0500
Received: from merlin.infradead.org ([205.233.59.134]:35752 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752581AbaBRVJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 16:09:15 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>, Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <rric@kernel.org>,
        Stanislav Fomichev <stfomichev@yandex-team.ru>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 18/32] perf tools: Move fs.* to lib/api/fs/
Date: Tue, 18 Feb 2014 18:08:37 -0300
Message-Id: <1392757731-32619-19-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1392757731-32619-1-git-send-email-acme@infradead.org>
References: <1392757731-32619-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

Move to generic library and kill magic.h as it is needed only in fs.h.

Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Robert Richter <rric@kernel.org>
Cc: Stanislav Fomichev <stfomichev@yandex-team.ru>
Cc: Stephane Eranian <eranian@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1386605664-24041-3-git-send-email-bp@alien8.de
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/api/Makefile                |   2 +
 tools/lib/api/fs/fs.c                 | 124 ++++++++++++++++++++++++++++++++++
 tools/lib/api/fs/fs.h                 |  14 ++++
 tools/perf/Makefile.perf              |   3 -
 tools/perf/tests/parse-events.c       |   2 +-
 tools/perf/util/cpumap.c              |   2 +-
 tools/perf/util/fs.c                  | 119 --------------------------------
 tools/perf/util/fs.h                  |   7 --
 tools/perf/util/include/linux/magic.h |  16 -----
 tools/perf/util/pmu.c                 |   2 +-
 tools/perf/util/python-ext-sources    |   2 +-
 tools/perf/util/record.c              |   2 +-
 tools/perf/util/util.c                |   2 +-
 13 files changed, 146 insertions(+), 151 deletions(-)
 create mode 100644 tools/lib/api/fs/fs.c
 create mode 100644 tools/lib/api/fs/fs.h
 delete mode 100644 tools/perf/util/fs.c
 delete mode 100644 tools/perf/util/fs.h
 delete mode 100644 tools/perf/util/include/linux/magic.h

diff --git a/tools/lib/api/Makefile b/tools/lib/api/Makefile
index ed2f51e11b80..ce00f7ee6455 100644
--- a/tools/lib/api/Makefile
+++ b/tools/lib/api/Makefile
@@ -9,8 +9,10 @@ LIB_H=
 LIB_OBJS=
 
 LIB_H += fs/debugfs.h
+LIB_H += fs/fs.h
 
 LIB_OBJS += $(OUTPUT)fs/debugfs.o
+LIB_OBJS += $(OUTPUT)fs/fs.o
 
 LIBFILE = libapikfs.a
 
diff --git a/tools/lib/api/fs/fs.c b/tools/lib/api/fs/fs.c
new file mode 100644
index 000000000000..5b5eb788996e
--- /dev/null
+++ b/tools/lib/api/fs/fs.c
@@ -0,0 +1,124 @@
+/* TODO merge/factor in debugfs.c here */
+
+#include <errno.h>
+#include <stdbool.h>
+#include <stdio.h>
+#include <string.h>
+#include <sys/vfs.h>
+
+#include "debugfs.h"
+#include "fs.h"
+
+static const char * const sysfs__fs_known_mountpoints[] = {
+	"/sys",
+	0,
+};
+
+static const char * const procfs__known_mountpoints[] = {
+	"/proc",
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
+	FS__SYSFS  = 0,
+	FS__PROCFS = 1,
+};
+
+static struct fs fs__entries[] = {
+	[FS__SYSFS] = {
+		.name	= "sysfs",
+		.mounts	= sysfs__fs_known_mountpoints,
+		.magic	= SYSFS_MAGIC,
+	},
+	[FS__PROCFS] = {
+		.name	= "proc",
+		.mounts	= procfs__known_mountpoints,
+		.magic	= PROC_SUPER_MAGIC,
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
+static const char *fs__mountpoint(int idx)
+{
+	struct fs *fs = &fs__entries[idx];
+
+	if (fs->found)
+		return (const char *)fs->path;
+
+	return fs__get_mountpoint(fs);
+}
+
+#define FS__MOUNTPOINT(name, idx)	\
+const char *name##__mountpoint(void)	\
+{					\
+	return fs__mountpoint(idx);	\
+}
+
+FS__MOUNTPOINT(sysfs,  FS__SYSFS);
+FS__MOUNTPOINT(procfs, FS__PROCFS);
diff --git a/tools/lib/api/fs/fs.h b/tools/lib/api/fs/fs.h
new file mode 100644
index 000000000000..cb7049551f33
--- /dev/null
+++ b/tools/lib/api/fs/fs.h
@@ -0,0 +1,14 @@
+#ifndef __API_FS__
+#define __API_FS__
+
+#ifndef SYSFS_MAGIC
+#define SYSFS_MAGIC            0x62656572
+#endif
+
+#ifndef PROC_SUPER_MAGIC
+#define PROC_SUPER_MAGIC       0x9fa0
+#endif
+
+const char *sysfs__mountpoint(void);
+const char *procfs__mountpoint(void);
+#endif /* __API_FS__ */
diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index f99a392d20be..869b34a51c8c 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -218,7 +218,6 @@ LIB_H += util/include/linux/ctype.h
 LIB_H += util/include/linux/kernel.h
 LIB_H += util/include/linux/list.h
 LIB_H += util/include/linux/export.h
-LIB_H += util/include/linux/magic.h
 LIB_H += util/include/linux/poison.h
 LIB_H += util/include/linux/prefetch.h
 LIB_H += util/include/linux/rbtree.h
@@ -244,7 +243,6 @@ LIB_H += util/cache.h
 LIB_H += util/callchain.h
 LIB_H += util/build-id.h
 LIB_H += util/debug.h
-LIB_H += util/fs.h
 LIB_H += util/pmu.h
 LIB_H += util/event.h
 LIB_H += util/evsel.h
@@ -306,7 +304,6 @@ LIB_OBJS += $(OUTPUT)util/annotate.o
 LIB_OBJS += $(OUTPUT)util/build-id.o
 LIB_OBJS += $(OUTPUT)util/config.o
 LIB_OBJS += $(OUTPUT)util/ctype.o
-LIB_OBJS += $(OUTPUT)util/fs.o
 LIB_OBJS += $(OUTPUT)util/pmu.o
 LIB_OBJS += $(OUTPUT)util/environment.o
 LIB_OBJS += $(OUTPUT)util/event.o
diff --git a/tools/perf/tests/parse-events.c b/tools/perf/tests/parse-events.c
index 4db0ae617d70..8605ff5572ae 100644
--- a/tools/perf/tests/parse-events.c
+++ b/tools/perf/tests/parse-events.c
@@ -2,7 +2,7 @@
 #include "parse-events.h"
 #include "evsel.h"
 #include "evlist.h"
-#include "fs.h"
+#include <api/fs/fs.h>
 #include <api/fs/debugfs.h>
 #include "tests.h"
 #include <linux/hw_breakpoint.h>
diff --git a/tools/perf/util/cpumap.c b/tools/perf/util/cpumap.c
index a9b48c42e81e..7fe4994eeb63 100644
--- a/tools/perf/util/cpumap.c
+++ b/tools/perf/util/cpumap.c
@@ -1,5 +1,5 @@
 #include "util.h"
-#include "fs.h"
+#include <api/fs/fs.h>
 #include "../perf.h"
 #include "cpumap.h"
 #include <assert.h>
diff --git a/tools/perf/util/fs.c b/tools/perf/util/fs.c
deleted file mode 100644
index f5be1f26e724..000000000000
--- a/tools/perf/util/fs.c
+++ /dev/null
@@ -1,119 +0,0 @@
-
-/* TODO merge/factor into tools/lib/lk/debugfs.c */
-
-#include "util.h"
-#include "util/fs.h"
-
-static const char * const sysfs__fs_known_mountpoints[] = {
-	"/sys",
-	0,
-};
-
-static const char * const procfs__known_mountpoints[] = {
-	"/proc",
-	0,
-};
-
-struct fs {
-	const char		*name;
-	const char * const	*mounts;
-	char			 path[PATH_MAX + 1];
-	bool			 found;
-	long			 magic;
-};
-
-enum {
-	FS__SYSFS  = 0,
-	FS__PROCFS = 1,
-};
-
-static struct fs fs__entries[] = {
-	[FS__SYSFS] = {
-		.name	= "sysfs",
-		.mounts	= sysfs__fs_known_mountpoints,
-		.magic	= SYSFS_MAGIC,
-	},
-	[FS__PROCFS] = {
-		.name	= "proc",
-		.mounts	= procfs__known_mountpoints,
-		.magic	= PROC_SUPER_MAGIC,
-	},
-};
-
-static bool fs__read_mounts(struct fs *fs)
-{
-	bool found = false;
-	char type[100];
-	FILE *fp;
-
-	fp = fopen("/proc/mounts", "r");
-	if (fp == NULL)
-		return NULL;
-
-	while (!found &&
-	       fscanf(fp, "%*s %" STR(PATH_MAX) "s %99s %*s %*d %*d\n",
-		      fs->path, type) == 2) {
-
-		if (strcmp(type, fs->name) == 0)
-			found = true;
-	}
-
-	fclose(fp);
-	return fs->found = found;
-}
-
-static int fs__valid_mount(const char *fs, long magic)
-{
-	struct statfs st_fs;
-
-	if (statfs(fs, &st_fs) < 0)
-		return -ENOENT;
-	else if (st_fs.f_type != magic)
-		return -ENOENT;
-
-	return 0;
-}
-
-static bool fs__check_mounts(struct fs *fs)
-{
-	const char * const *ptr;
-
-	ptr = fs->mounts;
-	while (*ptr) {
-		if (fs__valid_mount(*ptr, fs->magic) == 0) {
-			fs->found = true;
-			strcpy(fs->path, *ptr);
-			return true;
-		}
-		ptr++;
-	}
-
-	return false;
-}
-
-static const char *fs__get_mountpoint(struct fs *fs)
-{
-	if (fs__check_mounts(fs))
-		return fs->path;
-
-	return fs__read_mounts(fs) ? fs->path : NULL;
-}
-
-static const char *fs__mountpoint(int idx)
-{
-	struct fs *fs = &fs__entries[idx];
-
-	if (fs->found)
-		return (const char *)fs->path;
-
-	return fs__get_mountpoint(fs);
-}
-
-#define FS__MOUNTPOINT(name, idx)	\
-const char *name##__mountpoint(void)	\
-{					\
-	return fs__mountpoint(idx);	\
-}
-
-FS__MOUNTPOINT(sysfs,  FS__SYSFS);
-FS__MOUNTPOINT(procfs, FS__PROCFS);
diff --git a/tools/perf/util/fs.h b/tools/perf/util/fs.h
deleted file mode 100644
index 5e09ce1bab0e..000000000000
--- a/tools/perf/util/fs.h
+++ /dev/null
@@ -1,7 +0,0 @@
-#ifndef __PERF_FS
-#define __PERF_FS
-
-const char *sysfs__mountpoint(void);
-const char *procfs__mountpoint(void);
-
-#endif /* __PERF_FS */
diff --git a/tools/perf/util/include/linux/magic.h b/tools/perf/util/include/linux/magic.h
deleted file mode 100644
index 07d63cf3e0f6..000000000000
--- a/tools/perf/util/include/linux/magic.h
+++ /dev/null
@@ -1,16 +0,0 @@
-#ifndef _PERF_LINUX_MAGIC_H_
-#define _PERF_LINUX_MAGIC_H_
-
-#ifndef DEBUGFS_MAGIC
-#define DEBUGFS_MAGIC          0x64626720
-#endif
-
-#ifndef SYSFS_MAGIC
-#define SYSFS_MAGIC            0x62656572
-#endif
-
-#ifndef PROC_SUPER_MAGIC
-#define PROC_SUPER_MAGIC       0x9fa0
-#endif
-
-#endif
diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index b752ecb40d86..00a7dcb2f55c 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -3,7 +3,7 @@
 #include <unistd.h>
 #include <stdio.h>
 #include <dirent.h>
-#include "fs.h"
+#include <api/fs/fs.h>
 #include <locale.h>
 #include "util.h"
 #include "pmu.h"
diff --git a/tools/perf/util/python-ext-sources b/tools/perf/util/python-ext-sources
index 595bfc73d2ed..16a475a7d492 100644
--- a/tools/perf/util/python-ext-sources
+++ b/tools/perf/util/python-ext-sources
@@ -17,6 +17,6 @@ util/xyarray.c
 util/cgroup.c
 util/rblist.c
 util/strlist.c
-util/fs.c
+../lib/api/fs/fs.c
 util/trace-event.c
 ../../lib/rbtree.c
diff --git a/tools/perf/util/record.c b/tools/perf/util/record.c
index 373762501dad..049e0a09ccd3 100644
--- a/tools/perf/util/record.c
+++ b/tools/perf/util/record.c
@@ -2,7 +2,7 @@
 #include "evsel.h"
 #include "cpumap.h"
 #include "parse-events.h"
-#include "fs.h"
+#include <api/fs/fs.h>
 #include "util.h"
 
 typedef void (*setup_probe_fn_t)(struct perf_evsel *evsel);
diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
index 42ad667bb317..9f66549562bd 100644
--- a/tools/perf/util/util.c
+++ b/tools/perf/util/util.c
@@ -1,6 +1,6 @@
 #include "../perf.h"
 #include "util.h"
-#include "fs.h"
+#include <api/fs/fs.h>
 #include <sys/mman.h>
 #ifdef HAVE_BACKTRACE_SUPPORT
 #include <execinfo.h>
-- 
1.8.1.4

