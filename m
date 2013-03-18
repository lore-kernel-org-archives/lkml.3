Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754266Ab3CRQkA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 12:40:00 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36408 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526Ab3CRQZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 12:25:56 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 10/54] perf tools: Introduce tools/lib/lk library
Date: Mon, 18 Mar 2013 13:24:55 -0300
Message-Id: <1363623939-10748-11-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1363623939-10748-1-git-send-email-acme@infradead.org>
References: <1363623939-10748-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

This introduces the tools/lib/lk library, that will gradually have the
routines that now are used in tools/perf/ and other tools and that can
be shared.

Start by carving out debugfs routines for general use.

Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1361374353-30385-5-git-send-email-bp@alien8.de
[ committer note: Add tools/lib/lk/ to perf's MANIFEST so that its tarballs continue to build ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/Makefile                     |   16 ++++-
 tools/lib/lk/Makefile              |   35 +++++++++++
 tools/lib/lk/debugfs.c             |  116 ++++++++++++++++++++++++++++++++++++
 tools/lib/lk/debugfs.h             |   31 ++++++++++
 tools/perf/MANIFEST                |    1 +
 tools/perf/Makefile                |   34 ++++++++--
 tools/perf/builtin-kvm.c           |    2 +-
 tools/perf/builtin-probe.c         |    2 +-
 tools/perf/perf.c                  |    2 +-
 tools/perf/tests/parse-events.c    |    2 +-
 tools/perf/util/debugfs.c          |  111 ----------------------------------
 tools/perf/util/debugfs.h          |   12 ----
 tools/perf/util/evlist.c           |    2 +-
 tools/perf/util/evsel.c            |    2 +-
 tools/perf/util/parse-events.c     |    2 +-
 tools/perf/util/probe-event.c      |    2 +-
 tools/perf/util/python-ext-sources |    1 -
 tools/perf/util/setup.py           |    3 +-
 tools/perf/util/trace-event-info.c |    2 +-
 19 files changed, 235 insertions(+), 143 deletions(-)
 create mode 100644 tools/lib/lk/Makefile
 create mode 100644 tools/lib/lk/debugfs.c
 create mode 100644 tools/lib/lk/debugfs.h
 delete mode 100644 tools/perf/util/debugfs.c
 delete mode 100644 tools/perf/util/debugfs.h

diff --git a/tools/Makefile b/tools/Makefile
index 798fa0e..623b1cd 100644
--- a/tools/Makefile
+++ b/tools/Makefile
@@ -33,7 +33,13 @@ help:
 cpupower: FORCE
 	$(call descend,power/$@)
 
-firewire lguest perf usb virtio vm: FORCE
+firewire guest usb virtio vm: FORCE
+	$(call descend,$@)
+
+liblk: FORCE
+	$(call descend,lib/lk)
+
+perf: liblk FORCE
 	$(call descend,$@)
 
 selftests: FORCE
@@ -61,7 +67,13 @@ install: cpupower_install firewire_install lguest_install perf_install \
 cpupower_clean:
 	$(call descend,power/cpupower,clean)
 
-firewire_clean lguest_clean perf_clean usb_clean virtio_clean vm_clean:
+firewire_clean lguest_clean usb_clean virtio_clean vm_clean:
+	$(call descend,$(@:_clean=),clean)
+
+liblk_clean:
+	$(call descend,lib/lk,clean)
+
+perf_clean: liblk_clean
 	$(call descend,$(@:_clean=),clean)
 
 selftests_clean:
diff --git a/tools/lib/lk/Makefile b/tools/lib/lk/Makefile
new file mode 100644
index 0000000..8cf576f
--- /dev/null
+++ b/tools/lib/lk/Makefile
@@ -0,0 +1,35 @@
+include ../../scripts/Makefile.include
+
+# guard against environment variables
+LIB_H=
+LIB_OBJS=
+
+LIB_H += debugfs.h
+
+LIB_OBJS += $(OUTPUT)debugfs.o
+
+LIBFILE = liblk.a
+
+CFLAGS = -ggdb3 -Wall -Wextra -std=gnu99 -Werror $(CFLAGS_OPTIMIZE) -D_FORTIFY_SOURCE=2 $(EXTRA_WARNINGS) $(EXTRA_CFLAGS) -fPIC
+EXTLIBS = -lpthread -lrt -lelf -lm
+ALL_CFLAGS = $(CFLAGS) $(BASIC_CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64
+ALL_LDFLAGS = $(LDFLAGS)
+
+RM = rm -f
+
+$(LIBFILE): $(LIB_OBJS)
+	$(QUIET_AR)$(RM) $@ && $(AR) rcs $(OUTPUT)$@ $(LIB_OBJS)
+
+$(LIB_OBJS): $(LIB_H)
+
+$(OUTPUT)%.o: %.c
+	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) $<
+$(OUTPUT)%.s: %.c
+	$(QUIET_CC)$(CC) -S $(ALL_CFLAGS) $<
+$(OUTPUT)%.o: %.S
+	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) $<
+
+clean:
+	$(RM) $(LIB_OBJS) $(LIBFILE)
+
+.PHONY: clean
diff --git a/tools/lib/lk/debugfs.c b/tools/lib/lk/debugfs.c
new file mode 100644
index 0000000..9cda7a6
--- /dev/null
+++ b/tools/lib/lk/debugfs.c
@@ -0,0 +1,116 @@
+#include <errno.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <stdbool.h>
+#include <sys/vfs.h>
+#include <sys/mount.h>
+#include <linux/magic.h>
+#include <linux/kernel.h>
+
+#include "debugfs.h"
+
+char debugfs_mountpoint[PATH_MAX + 1] = "/sys/kernel/debug";
+char tracing_events_path[PATH_MAX + 1] = "/sys/kernel/debug/tracing/events";
+
+static const char * const debugfs_known_mountpoints[] = {
+	"/sys/kernel/debug/",
+	"/debug/",
+	0,
+};
+
+static bool debugfs_found;
+
+/* find the path to the mounted debugfs */
+const char *debugfs_find_mountpoint(void)
+{
+	const char * const *ptr;
+	char type[100];
+	FILE *fp;
+
+	if (debugfs_found)
+		return (const char *)debugfs_mountpoint;
+
+	ptr = debugfs_known_mountpoints;
+	while (*ptr) {
+		if (debugfs_valid_mountpoint(*ptr) == 0) {
+			debugfs_found = true;
+			strcpy(debugfs_mountpoint, *ptr);
+			return debugfs_mountpoint;
+		}
+		ptr++;
+	}
+
+	/* give up and parse /proc/mounts */
+	fp = fopen("/proc/mounts", "r");
+	if (fp == NULL)
+		return NULL;
+
+	while (fscanf(fp, "%*s %" STR(PATH_MAX) "s %99s %*s %*d %*d\n",
+		      debugfs_mountpoint, type) == 2) {
+		if (strcmp(type, "debugfs") == 0)
+			break;
+	}
+	fclose(fp);
+
+	if (strcmp(type, "debugfs") != 0)
+		return NULL;
+
+	debugfs_found = true;
+
+	return debugfs_mountpoint;
+}
+
+/* verify that a mountpoint is actually a debugfs instance */
+
+int debugfs_valid_mountpoint(const char *debugfs)
+{
+	struct statfs st_fs;
+
+	if (statfs(debugfs, &st_fs) < 0)
+		return -ENOENT;
+	else if (st_fs.f_type != (long) DEBUGFS_MAGIC)
+		return -ENOENT;
+
+	return 0;
+}
+
+static void debugfs_set_tracing_events_path(const char *mountpoint)
+{
+	snprintf(tracing_events_path, sizeof(tracing_events_path), "%s/%s",
+		 mountpoint, "tracing/events");
+}
+
+/* mount the debugfs somewhere if it's not mounted */
+
+char *debugfs_mount(const char *mountpoint)
+{
+	/* see if it's already mounted */
+	if (debugfs_find_mountpoint())
+		goto out;
+
+	/* if not mounted and no argument */
+	if (mountpoint == NULL) {
+		/* see if environment variable set */
+		mountpoint = getenv(PERF_DEBUGFS_ENVIRONMENT);
+		/* if no environment variable, use default */
+		if (mountpoint == NULL)
+			mountpoint = "/sys/kernel/debug";
+	}
+
+	if (mount(NULL, mountpoint, "debugfs", 0, NULL) < 0)
+		return NULL;
+
+	/* save the mountpoint */
+	debugfs_found = true;
+	strncpy(debugfs_mountpoint, mountpoint, sizeof(debugfs_mountpoint));
+out:
+	debugfs_set_tracing_events_path(debugfs_mountpoint);
+	return debugfs_mountpoint;
+}
+
+void debugfs_set_path(const char *mountpoint)
+{
+	snprintf(debugfs_mountpoint, sizeof(debugfs_mountpoint), "%s", mountpoint);
+	debugfs_set_tracing_events_path(mountpoint);
+}
diff --git a/tools/lib/lk/debugfs.h b/tools/lib/lk/debugfs.h
new file mode 100644
index 0000000..bc5ad2d
--- /dev/null
+++ b/tools/lib/lk/debugfs.h
@@ -0,0 +1,31 @@
+#ifndef __LK_DEBUGFS_H__
+#define __LK_DEBUGFS_H__
+
+#define _STR(x) #x
+#define STR(x) _STR(x)
+
+/*
+ * On most systems <limits.h> would have given us this, but  not on some systems
+ * (e.g. GNU/Hurd).
+ */
+#ifndef PATH_MAX
+#define PATH_MAX 4096
+#endif
+
+#ifndef DEBUGFS_MAGIC
+#define DEBUGFS_MAGIC          0x64626720
+#endif
+
+#ifndef PERF_DEBUGFS_ENVIRONMENT
+#define PERF_DEBUGFS_ENVIRONMENT "PERF_DEBUGFS_DIR"
+#endif
+
+const char *debugfs_find_mountpoint(void);
+int debugfs_valid_mountpoint(const char *debugfs);
+char *debugfs_mount(const char *mountpoint);
+void debugfs_set_path(const char *mountpoint);
+
+extern char debugfs_mountpoint[];
+extern char tracing_events_path[];
+
+#endif /* __LK_DEBUGFS_H__ */
diff --git a/tools/perf/MANIFEST b/tools/perf/MANIFEST
index 39d4106..025de79 100644
--- a/tools/perf/MANIFEST
+++ b/tools/perf/MANIFEST
@@ -1,6 +1,7 @@
 tools/perf
 tools/scripts
 tools/lib/traceevent
+tools/lib/lk
 include/linux/const.h
 include/linux/perf_event.h
 include/linux/rbtree.h
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index bb74c79..3dcd627 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -215,6 +215,7 @@ BASIC_CFLAGS = \
 	-Iutil \
 	-I. \
 	-I$(TRACE_EVENT_DIR) \
+	-I../lib/ \
 	-D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE
 
 BASIC_LDFLAGS =
@@ -240,19 +241,28 @@ SCRIPT_SH += perf-archive.sh
 grep-libs = $(filter -l%,$(1))
 strip-libs = $(filter-out -l%,$(1))
 
+LK_DIR = ../lib/lk/
 TRACE_EVENT_DIR = ../lib/traceevent/
 
+LK_PATH=$(LK_DIR)
+
 ifneq ($(OUTPUT),)
 	TE_PATH=$(OUTPUT)
+ifneq ($(subdir),)
+	LK_PATH=$(OUTPUT)$(LK_DIR)
+else
+	LK_PATH=$(OUTPUT)
+endif
 else
 	TE_PATH=$(TRACE_EVENT_DIR)
 endif
 
 LIBTRACEEVENT = $(TE_PATH)libtraceevent.a
-TE_LIB := -L$(TE_PATH) -ltraceevent
-
 export LIBTRACEEVENT
 
+LIBLK = $(LK_PATH)liblk.a
+export LIBLK
+
 # python extension build directories
 PYTHON_EXTBUILD     := $(OUTPUT)python_ext_build/
 PYTHON_EXTBUILD_LIB := $(PYTHON_EXTBUILD)lib/
@@ -355,7 +365,6 @@ LIB_H += util/cache.h
 LIB_H += util/callchain.h
 LIB_H += util/build-id.h
 LIB_H += util/debug.h
-LIB_H += util/debugfs.h
 LIB_H += util/sysfs.h
 LIB_H += util/pmu.h
 LIB_H += util/event.h
@@ -416,7 +425,6 @@ LIB_OBJS += $(OUTPUT)util/annotate.o
 LIB_OBJS += $(OUTPUT)util/build-id.o
 LIB_OBJS += $(OUTPUT)util/config.o
 LIB_OBJS += $(OUTPUT)util/ctype.o
-LIB_OBJS += $(OUTPUT)util/debugfs.o
 LIB_OBJS += $(OUTPUT)util/sysfs.o
 LIB_OBJS += $(OUTPUT)util/pmu.o
 LIB_OBJS += $(OUTPUT)util/environment.o
@@ -536,7 +544,7 @@ BUILTIN_OBJS += $(OUTPUT)builtin-kvm.o
 BUILTIN_OBJS += $(OUTPUT)builtin-inject.o
 BUILTIN_OBJS += $(OUTPUT)tests/builtin-test.o
 
-PERFLIBS = $(LIB_FILE) $(LIBTRACEEVENT)
+PERFLIBS = $(LIB_FILE) $(LIBLK) $(LIBTRACEEVENT)
 
 #
 # Platform specific tweaks
@@ -1051,6 +1059,18 @@ $(LIBTRACEEVENT):
 $(LIBTRACEEVENT)-clean:
 	$(QUIET_SUBDIR0)$(TRACE_EVENT_DIR) $(QUIET_SUBDIR1) O=$(OUTPUT) clean
 
+# if subdir is set, we've been called from above so target has been built
+# already
+$(LIBLK):
+ifeq ($(subdir),)
+	$(QUIET_SUBDIR0)$(LK_DIR) $(QUIET_SUBDIR1) O=$(OUTPUT) liblk.a
+endif
+
+$(LIBLK)-clean:
+ifeq ($(subdir),)
+	$(QUIET_SUBDIR0)$(LK_DIR) $(QUIET_SUBDIR1) O=$(OUTPUT) clean
+endif
+
 help:
 	@echo 'Perf make targets:'
 	@echo '  doc		- make *all* documentation (see below)'
@@ -1171,7 +1191,7 @@ $(INSTALL_DOC_TARGETS):
 
 ### Cleaning rules
 
-clean: $(LIBTRACEEVENT)-clean
+clean: $(LIBTRACEEVENT)-clean $(LIBLK)-clean
 	$(RM) $(LIB_OBJS) $(BUILTIN_OBJS) $(LIB_FILE) $(OUTPUT)perf-archive $(OUTPUT)perf.o $(LANG_BINDINGS)
 	$(RM) $(ALL_PROGRAMS) perf
 	$(RM) *.spec *.pyc *.pyo */*.pyc */*.pyo $(OUTPUT)common-cmds.h TAGS tags cscope*
@@ -1181,6 +1201,6 @@ clean: $(LIBTRACEEVENT)-clean
 	$(RM) $(OUTPUT)util/*-flex*
 	$(python-clean)
 
-.PHONY: all install clean strip $(LIBTRACEEVENT)
+.PHONY: all install clean strip $(LIBTRACEEVENT) $(LIBLK)
 .PHONY: shell_compatibility_test please_set_SHELL_PATH_to_a_more_modern_shell
 .PHONY: .FORCE-PERF-VERSION-FILE TAGS tags cscope .FORCE-PERF-CFLAGS
diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index 37a769d..533501e 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -12,7 +12,7 @@
 #include "util/parse-options.h"
 #include "util/trace-event.h"
 #include "util/debug.h"
-#include "util/debugfs.h"
+#include <lk/debugfs.h>
 #include "util/tool.h"
 #include "util/stat.h"
 
diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index de38a03..e8a66f9 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -37,7 +37,7 @@
 #include "util/strfilter.h"
 #include "util/symbol.h"
 #include "util/debug.h"
-#include "util/debugfs.h"
+#include <lk/debugfs.h>
 #include "util/parse-options.h"
 #include "util/probe-finder.h"
 #include "util/probe-event.h"
diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index 095b882..f53b735 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -13,7 +13,7 @@
 #include "util/quote.h"
 #include "util/run-command.h"
 #include "util/parse-events.h"
-#include "util/debugfs.h"
+#include <lk/debugfs.h>
 #include <pthread.h>
 
 const char perf_usage_string[] =
diff --git a/tools/perf/tests/parse-events.c b/tools/perf/tests/parse-events.c
index c5636f3..0d3d0c5 100644
--- a/tools/perf/tests/parse-events.c
+++ b/tools/perf/tests/parse-events.c
@@ -3,7 +3,7 @@
 #include "evsel.h"
 #include "evlist.h"
 #include "sysfs.h"
-#include "debugfs.h"
+#include <lk/debugfs.h>
 #include "tests.h"
 #include <linux/hw_breakpoint.h>
 
diff --git a/tools/perf/util/debugfs.c b/tools/perf/util/debugfs.c
deleted file mode 100644
index e55495c..0000000
--- a/tools/perf/util/debugfs.c
+++ /dev/null
@@ -1,111 +0,0 @@
-#include "util.h"
-#include "debugfs.h"
-#include "cache.h"
-
-#include <linux/kernel.h>
-#include <sys/mount.h>
-
-char debugfs_mountpoint[PATH_MAX + 1] = "/sys/kernel/debug";
-char tracing_events_path[PATH_MAX + 1] = "/sys/kernel/debug/tracing/events";
-
-static const char *debugfs_known_mountpoints[] = {
-	"/sys/kernel/debug/",
-	"/debug/",
-	0,
-};
-
-static bool debugfs_found;
-
-/* find the path to the mounted debugfs */
-const char *debugfs_find_mountpoint(void)
-{
-	const char **ptr;
-	char type[100];
-	FILE *fp;
-
-	if (debugfs_found)
-		return (const char *) debugfs_mountpoint;
-
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
-}
-
-/* verify that a mountpoint is actually a debugfs instance */
-
-int debugfs_valid_mountpoint(const char *debugfs)
-{
-	struct statfs st_fs;
-
-	if (statfs(debugfs, &st_fs) < 0)
-		return -ENOENT;
-	else if (st_fs.f_type != (long) DEBUGFS_MAGIC)
-		return -ENOENT;
-
-	return 0;
-}
-
-static void debugfs_set_tracing_events_path(const char *mountpoint)
-{
-	snprintf(tracing_events_path, sizeof(tracing_events_path), "%s/%s",
-		 mountpoint, "tracing/events");
-}
-
-/* mount the debugfs somewhere if it's not mounted */
-
-char *debugfs_mount(const char *mountpoint)
-{
-	/* see if it's already mounted */
-	if (debugfs_find_mountpoint())
-		goto out;
-
-	/* if not mounted and no argument */
-	if (mountpoint == NULL) {
-		/* see if environment variable set */
-		mountpoint = getenv(PERF_DEBUGFS_ENVIRONMENT);
-		/* if no environment variable, use default */
-		if (mountpoint == NULL)
-			mountpoint = "/sys/kernel/debug";
-	}
-
-	if (mount(NULL, mountpoint, "debugfs", 0, NULL) < 0)
-		return NULL;
-
-	/* save the mountpoint */
-	debugfs_found = true;
-	strncpy(debugfs_mountpoint, mountpoint, sizeof(debugfs_mountpoint));
-out:
-	debugfs_set_tracing_events_path(debugfs_mountpoint);
-	return debugfs_mountpoint;
-}
-
-void debugfs_set_path(const char *mountpoint)
-{
-	snprintf(debugfs_mountpoint, sizeof(debugfs_mountpoint), "%s", mountpoint);
-	debugfs_set_tracing_events_path(mountpoint);
-}
diff --git a/tools/perf/util/debugfs.h b/tools/perf/util/debugfs.h
deleted file mode 100644
index 68f3e87..0000000
--- a/tools/perf/util/debugfs.h
+++ /dev/null
@@ -1,12 +0,0 @@
-#ifndef __DEBUGFS_H__
-#define __DEBUGFS_H__
-
-const char *debugfs_find_mountpoint(void);
-int debugfs_valid_mountpoint(const char *debugfs);
-char *debugfs_mount(const char *mountpoint);
-void debugfs_set_path(const char *mountpoint);
-
-extern char debugfs_mountpoint[];
-extern char tracing_events_path[];
-
-#endif /* __DEBUGFS_H__ */
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index bc4ad79..7626bb4 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -7,7 +7,7 @@
  * Released under the GPL v2. (and only v2, not any later version)
  */
 #include "util.h"
-#include "debugfs.h"
+#include <lk/debugfs.h>
 #include <poll.h>
 #include "cpumap.h"
 #include "thread_map.h"
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 9c82f98..dc16231 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -10,7 +10,7 @@
 #include <byteswap.h>
 #include <linux/bitops.h>
 #include "asm/bug.h"
-#include "debugfs.h"
+#include <lk/debugfs.h>
 #include "event-parse.h"
 #include "evsel.h"
 #include "evlist.h"
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index c84f48c..6c8bb0f 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -10,7 +10,7 @@
 #include "symbol.h"
 #include "cache.h"
 #include "header.h"
-#include "debugfs.h"
+#include <lk/debugfs.h>
 #include "parse-events-bison.h"
 #define YY_EXTRA_TYPE int
 #include "parse-events-flex.h"
diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 49a256e..aa04bf9 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -40,7 +40,7 @@
 #include "color.h"
 #include "symbol.h"
 #include "thread.h"
-#include "debugfs.h"
+#include <lk/debugfs.h>
 #include "trace-event.h"	/* For __maybe_unused */
 #include "probe-event.h"
 #include "probe-finder.h"
diff --git a/tools/perf/util/python-ext-sources b/tools/perf/util/python-ext-sources
index 64536a9..f75ae1b 100644
--- a/tools/perf/util/python-ext-sources
+++ b/tools/perf/util/python-ext-sources
@@ -15,7 +15,6 @@ util/thread_map.c
 util/util.c
 util/xyarray.c
 util/cgroup.c
-util/debugfs.c
 util/rblist.c
 util/strlist.c
 util/sysfs.c
diff --git a/tools/perf/util/setup.py b/tools/perf/util/setup.py
index 73d5102..6b0ed32 100644
--- a/tools/perf/util/setup.py
+++ b/tools/perf/util/setup.py
@@ -24,6 +24,7 @@ cflags += getenv('CFLAGS', '').split()
 build_lib = getenv('PYTHON_EXTBUILD_LIB')
 build_tmp = getenv('PYTHON_EXTBUILD_TMP')
 libtraceevent = getenv('LIBTRACEEVENT')
+liblk = getenv('LIBLK')
 
 ext_sources = [f.strip() for f in file('util/python-ext-sources')
 				if len(f.strip()) > 0 and f[0] != '#']
@@ -32,7 +33,7 @@ perf = Extension('perf',
 		  sources = ext_sources,
 		  include_dirs = ['util/include'],
 		  extra_compile_args = cflags,
-		  extra_objects = [libtraceevent],
+		  extra_objects = [libtraceevent, liblk],
                  )
 
 setup(name='perf',
diff --git a/tools/perf/util/trace-event-info.c b/tools/perf/util/trace-event-info.c
index a8d81c3..36b9b49 100644
--- a/tools/perf/util/trace-event-info.c
+++ b/tools/perf/util/trace-event-info.c
@@ -38,7 +38,7 @@
 
 #include "../perf.h"
 #include "trace-event.h"
-#include "debugfs.h"
+#include <lk/debugfs.h>
 #include "evsel.h"
 
 #define VERSION "0.5"
-- 
1.7.1

