Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755036Ab3KTV4h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 16:56:37 -0500
Received: from mail.skyhub.de ([78.46.96.112]:50203 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754491Ab3KTV4g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 16:56:36 -0500
From: Borislav Petkov <bp@alien8.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Borislav Petkov <bp@suse.de>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <rric@kernel.org>
Subject: [PATCH] perf: Move fs.* to generic lib/lk/
Date: Wed, 20 Nov 2013 22:56:25 +0100
Message-Id: <1384984585-24300-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

Move to generic library and kill magic.h as it is needed only in fs.h.

Signed-off-by: Borislav Petkov <bp@suse.de>
---

Ok, let's try the first one, see how it goes.

 tools/lib/lk/Makefile                                  |  2 ++
 tools/{perf/util => lib/lk}/fs.c                       | 11 ++++++++---
 tools/{perf/util/include/linux/magic.h => lib/lk/fs.h} |  9 ++++++---
 tools/perf/Makefile.perf                               |  3 ---
 tools/perf/tests/parse-events.c                        |  2 +-
 tools/perf/util/cpumap.c                               |  2 +-
 tools/perf/util/fs.h                                   |  7 -------
 tools/perf/util/pmu.c                                  |  2 +-
 tools/perf/util/python-ext-sources                     |  2 +-
 tools/perf/util/record.c                               |  2 +-
 10 files changed, 21 insertions(+), 21 deletions(-)
 rename tools/{perf/util => lib/lk}/fs.c (93%)
 rename tools/{perf/util/include/linux/magic.h => lib/lk/fs.h} (60%)
 delete mode 100644 tools/perf/util/fs.h

diff --git a/tools/lib/lk/Makefile b/tools/lib/lk/Makefile
index 3dba0a4aebbf..261febf6fd09 100644
--- a/tools/lib/lk/Makefile
+++ b/tools/lib/lk/Makefile
@@ -8,8 +8,10 @@ LIB_H=
 LIB_OBJS=
 
 LIB_H += debugfs.h
+LIB_H += fs.h
 
 LIB_OBJS += $(OUTPUT)debugfs.o
+LIB_OBJS += $(OUTPUT)fs.o
 
 LIBFILE = liblk.a
 
diff --git a/tools/perf/util/fs.c b/tools/lib/lk/fs.c
similarity index 93%
rename from tools/perf/util/fs.c
rename to tools/lib/lk/fs.c
index f5be1f26e724..7891fa715d9f 100644
--- a/tools/perf/util/fs.c
+++ b/tools/lib/lk/fs.c
@@ -1,8 +1,13 @@
-
 /* TODO merge/factor into tools/lib/lk/debugfs.c */
 
-#include "util.h"
-#include "util/fs.h"
+#include <errno.h>
+#include <stdbool.h>
+#include <stdio.h>
+#include <string.h>
+#include <sys/vfs.h>
+
+#include "debugfs.h"
+#include "fs.h"
 
 static const char * const sysfs__fs_known_mountpoints[] = {
 	"/sys",
diff --git a/tools/perf/util/include/linux/magic.h b/tools/lib/lk/fs.h
similarity index 60%
rename from tools/perf/util/include/linux/magic.h
rename to tools/lib/lk/fs.h
index 07d63cf3e0f6..72ddfec739f1 100644
--- a/tools/perf/util/include/linux/magic.h
+++ b/tools/lib/lk/fs.h
@@ -1,5 +1,5 @@
-#ifndef _PERF_LINUX_MAGIC_H_
-#define _PERF_LINUX_MAGIC_H_
+#ifndef __LK_FS_H__
+#define __LK_FS_H__
 
 #ifndef DEBUGFS_MAGIC
 #define DEBUGFS_MAGIC          0x64626720
@@ -13,4 +13,7 @@
 #define PROC_SUPER_MAGIC       0x9fa0
 #endif
 
-#endif
+const char *sysfs__mountpoint(void);
+const char *procfs__mountpoint(void);
+
+#endif /* __LK_FS_H__ */
diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index e416ccc7d831..f0c3fa913e98 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -216,7 +216,6 @@ LIB_H += util/include/linux/ctype.h
 LIB_H += util/include/linux/kernel.h
 LIB_H += util/include/linux/list.h
 LIB_H += util/include/linux/export.h
-LIB_H += util/include/linux/magic.h
 LIB_H += util/include/linux/poison.h
 LIB_H += util/include/linux/prefetch.h
 LIB_H += util/include/linux/rbtree.h
@@ -242,7 +241,6 @@ LIB_H += util/cache.h
 LIB_H += util/callchain.h
 LIB_H += util/build-id.h
 LIB_H += util/debug.h
-LIB_H += util/fs.h
 LIB_H += util/pmu.h
 LIB_H += util/event.h
 LIB_H += util/evsel.h
@@ -304,7 +302,6 @@ LIB_OBJS += $(OUTPUT)util/annotate.o
 LIB_OBJS += $(OUTPUT)util/build-id.o
 LIB_OBJS += $(OUTPUT)util/config.o
 LIB_OBJS += $(OUTPUT)util/ctype.o
-LIB_OBJS += $(OUTPUT)util/fs.o
 LIB_OBJS += $(OUTPUT)util/pmu.o
 LIB_OBJS += $(OUTPUT)util/environment.o
 LIB_OBJS += $(OUTPUT)util/event.o
diff --git a/tools/perf/tests/parse-events.c b/tools/perf/tests/parse-events.c
index 3cbd10496087..0bee94ec5cdb 100644
--- a/tools/perf/tests/parse-events.c
+++ b/tools/perf/tests/parse-events.c
@@ -2,7 +2,7 @@
 #include "parse-events.h"
 #include "evsel.h"
 #include "evlist.h"
-#include "fs.h"
+#include <lk/fs.h>
 #include <lk/debugfs.h>
 #include "tests.h"
 #include <linux/hw_breakpoint.h>
diff --git a/tools/perf/util/cpumap.c b/tools/perf/util/cpumap.c
index a9b48c42e81e..f092be9817ce 100644
--- a/tools/perf/util/cpumap.c
+++ b/tools/perf/util/cpumap.c
@@ -1,5 +1,5 @@
 #include "util.h"
-#include "fs.h"
+#include <lk/fs.h>
 #include "../perf.h"
 #include "cpumap.h"
 #include <assert.h>
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
diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index c232d8dd410b..508264a4929a 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -4,7 +4,7 @@
 #include <unistd.h>
 #include <stdio.h>
 #include <dirent.h>
-#include "fs.h"
+#include <lk/fs.h>
 #include "util.h"
 #include "pmu.h"
 #include "parse-events.h"
diff --git a/tools/perf/util/python-ext-sources b/tools/perf/util/python-ext-sources
index 239036fb2b2c..32bf22d1dd1b 100644
--- a/tools/perf/util/python-ext-sources
+++ b/tools/perf/util/python-ext-sources
@@ -17,5 +17,5 @@ util/xyarray.c
 util/cgroup.c
 util/rblist.c
 util/strlist.c
-util/fs.c
+../lib/lk/fs.c
 ../../lib/rbtree.c
diff --git a/tools/perf/util/record.c b/tools/perf/util/record.c
index c8845b107f60..a6b9e5c3cd45 100644
--- a/tools/perf/util/record.c
+++ b/tools/perf/util/record.c
@@ -2,7 +2,7 @@
 #include "evsel.h"
 #include "cpumap.h"
 #include "parse-events.h"
-#include "fs.h"
+#include <lk/fs.h>
 #include "util.h"
 
 typedef void (*setup_probe_fn_t)(struct perf_evsel *evsel);
-- 
1.8.4

