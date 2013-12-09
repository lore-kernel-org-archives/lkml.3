Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933957Ab3LIQOh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 11:14:37 -0500
Received: from mail.skyhub.de ([78.46.96.112]:44078 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933943Ab3LIQOb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 11:14:31 -0500
From: Borislav Petkov <bp@alien8.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Borislav Petkov <bp@suse.de>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <rric@kernel.org>, David Ahern <dsahern@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Stanislav Fomichev <stfomichev@yandex-team.ru>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Pekka Enberg <penberg@kernel.org>,
        Paul Mackerras <paulus@samba.org>
Subject: [PATCH 2/2] perf: Move fs.* to lib/api/fs/
Date: Mon,  9 Dec 2013 17:14:24 +0100
Message-Id: <1386605664-24041-3-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1386605664-24041-1-git-send-email-bp@alien8.de>
References: <1386605664-24041-1-git-send-email-bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

Move to generic library and kill magic.h as it is needed only in fs.h.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 tools/lib/api/Makefile                                     |  2 ++
 tools/{perf/util => lib/api/fs}/fs.c                       | 11 ++++++++---
 tools/{perf/util/include/linux/magic.h => lib/api/fs/fs.h} | 12 +++++-------
 tools/perf/Makefile.perf                                   |  3 ---
 tools/perf/tests/parse-events.c                            |  2 +-
 tools/perf/util/cpumap.c                                   |  2 +-
 tools/perf/util/fs.h                                       |  7 -------
 tools/perf/util/pmu.c                                      |  2 +-
 tools/perf/util/python-ext-sources                         |  2 +-
 tools/perf/util/record.c                                   |  2 +-
 10 files changed, 20 insertions(+), 25 deletions(-)
 rename tools/{perf/util => lib/api/fs}/fs.c (91%)
 rename tools/{perf/util/include/linux/magic.h => lib/api/fs/fs.h} (50%)
 delete mode 100644 tools/perf/util/fs.h

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
 
diff --git a/tools/perf/util/fs.c b/tools/lib/api/fs/fs.c
similarity index 91%
rename from tools/perf/util/fs.c
rename to tools/lib/api/fs/fs.c
index f5be1f26e724..5b5eb788996e 100644
--- a/tools/perf/util/fs.c
+++ b/tools/lib/api/fs/fs.c
@@ -1,8 +1,13 @@
+/* TODO merge/factor in debugfs.c here */
 
-/* TODO merge/factor into tools/lib/lk/debugfs.c */
+#include <errno.h>
+#include <stdbool.h>
+#include <stdio.h>
+#include <string.h>
+#include <sys/vfs.h>
 
-#include "util.h"
-#include "util/fs.h"
+#include "debugfs.h"
+#include "fs.h"
 
 static const char * const sysfs__fs_known_mountpoints[] = {
 	"/sys",
diff --git a/tools/perf/util/include/linux/magic.h b/tools/lib/api/fs/fs.h
similarity index 50%
rename from tools/perf/util/include/linux/magic.h
rename to tools/lib/api/fs/fs.h
index 07d63cf3e0f6..cb7049551f33 100644
--- a/tools/perf/util/include/linux/magic.h
+++ b/tools/lib/api/fs/fs.h
@@ -1,9 +1,5 @@
-#ifndef _PERF_LINUX_MAGIC_H_
-#define _PERF_LINUX_MAGIC_H_
-
-#ifndef DEBUGFS_MAGIC
-#define DEBUGFS_MAGIC          0x64626720
-#endif
+#ifndef __API_FS__
+#define __API_FS__
 
 #ifndef SYSFS_MAGIC
 #define SYSFS_MAGIC            0x62656572
@@ -13,4 +9,6 @@
 #define PROC_SUPER_MAGIC       0x9fa0
 #endif
 
-#endif
+const char *sysfs__mountpoint(void);
+const char *procfs__mountpoint(void);
+#endif /* __API_FS__ */
diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 532e5f21b918..1a51460c5903 100644
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
index e4ce8aed29d3..6109150d36cc 100644
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
index 56fc10a5e288..b22d2447550f 100644
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
index c8845b107f60..da4113679ae5 100644
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
-- 
1.8.4

