Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935170AbaGXKHG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 06:07:06 -0400
Received: from mga02.intel.com ([134.134.136.20]:39962 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934337AbaGXKHB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 06:07:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,723,1400050800"; 
   d="scan'208";a="548315097"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] perf tools: Build programs to copy 32-bit compatibility VDSOs
Date: Thu, 24 Jul 2014 13:05:54 +0300
Message-Id: <1406196354-7139-1-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <20140723204412.GQ20303@kernel.org>
References: <20140723204412.GQ20303@kernel.org>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

perf tools copy VDSO out of memory.  However, on 64-bit
machines there may be 32-bit compatibility VDOs also.  To
copy those requires separate 32-bit executables.  This
patch adds to the build additional programs perf-read-vdso32
and perf-read-vdsox32 for 32-bit and x32 respectively.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---


V2:
	Move -m32/-mx32 checks under config/features/

	Put duplicated find_vdso_map() function into a
	separate source file and #include it

	Support static build of perf-read-vdso32 and
	perf-read-vdsox32


 tools/perf/Makefile.perf                        | 38 ++++++++++++++++++++++---
 tools/perf/config/Makefile                      | 25 +++++++++++++++-
 tools/perf/config/Makefile.arch                 |  8 ++++++
 tools/perf/config/feature-checks/Makefile       | 10 ++++++-
 tools/perf/config/feature-checks/test-compile.c |  4 +++
 tools/perf/perf-read-vdso.c                     | 34 ++++++++++++++++++++++
 tools/perf/util/find-vdso-map.c                 | 30 +++++++++++++++++++
 tools/perf/util/vdso.c                          | 37 ++++--------------------
 8 files changed, 149 insertions(+), 37 deletions(-)
 create mode 100644 tools/perf/config/feature-checks/test-compile.c
 create mode 100644 tools/perf/perf-read-vdso.c
 create mode 100644 tools/perf/util/find-vdso-map.c

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 9b1f05d..cd31be6 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -60,6 +60,12 @@ include config/utilities.mak
 #
 # Define NO_LIBDW_DWARF_UNWIND if you do not want libdw support
 # for dwarf backtrace post unwind.
+#
+# Define NO_PERF_READ_VDSO32 if you do not want to build perf-read-vdso32
+# for reading the 32-bit compatibility VDSO in 64-bit mode
+#
+# Define NO_PERF_READ_VDSOX32 if you do not want to build perf-read-vdsox32
+# for reading the x32 mode 32-bit compatibility VDSO in 64-bit mode
 
 ifeq ($(srctree),)
 srctree := $(patsubst %/,%,$(dir $(shell pwd)))
@@ -171,11 +177,16 @@ $(OUTPUT)python/perf.so: $(PYTHON_EXT_SRCS) $(PYTHON_EXT_DEPS)
 
 SCRIPTS = $(patsubst %.sh,%,$(SCRIPT_SH))
 
-#
-# Single 'perf' binary right now:
-#
 PROGRAMS += $(OUTPUT)perf
 
+ifndef NO_PERF_READ_VDSO32
+PROGRAMS += $(OUTPUT)perf-read-vdso32
+endif
+
+ifndef NO_PERF_READ_VDSOX32
+PROGRAMS += $(OUTPUT)perf-read-vdsox32
+endif
+
 # what 'all' will build and 'install' will install, in perfexecdir
 ALL_PROGRAMS = $(PROGRAMS) $(SCRIPTS)
 
@@ -305,6 +316,7 @@ LIB_H += util/data.h
 LIB_H += util/kvm-stat.h
 LIB_H += util/thread-stack.h
 LIB_H += util/db-export.h
+LIB_H += util/find-vdso-map.c
 
 LIB_OBJS += $(OUTPUT)util/abspath.o
 LIB_OBJS += $(OUTPUT)util/alias.o
@@ -732,6 +744,16 @@ $(OUTPUT)scripts/python/Perf-Trace-Util/Context.o: scripts/python/Perf-Trace-Uti
 $(OUTPUT)perf-%: %.o $(PERFLIBS)
 	$(QUIET_LINK)$(CC) $(CFLAGS) -o $@ $(LDFLAGS) $(filter %.o,$^) $(LIBS)
 
+ifndef NO_PERF_READ_VDSO32
+$(OUTPUT)perf-read-vdso32: perf-read-vdso.c util/find-vdso-map.c
+	$(QUIET_CC)$(CC) -m32 $(findstring -static,$(LDFLAGS)) -Wall -Werror -o $@ perf-read-vdso.c
+endif
+
+ifndef NO_PERF_READ_VDSOX32
+$(OUTPUT)perf-read-vdsox32: perf-read-vdso.c util/find-vdso-map.c
+	$(QUIET_CC)$(CC) -mx32 $(findstring -static,$(LDFLAGS)) -Wall -Werror -o $@ perf-read-vdso.c
+endif
+
 $(LIB_OBJS) $(BUILTIN_OBJS): $(LIB_H)
 $(patsubst perf-%,%.o,$(PROGRAMS)): $(LIB_H) $(wildcard */*.h)
 
@@ -876,6 +898,14 @@ install-bin: all install-gtk
 		$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(bindir_SQ)'; \
 		$(INSTALL) $(OUTPUT)perf '$(DESTDIR_SQ)$(bindir_SQ)'; \
 		$(LN) '$(DESTDIR_SQ)$(bindir_SQ)/perf' '$(DESTDIR_SQ)$(bindir_SQ)/trace'
+ifndef NO_PERF_READ_VDSO32
+	$(call QUIET_INSTALL, perf-read-vdso32) \
+		$(INSTALL) $(OUTPUT)perf-read-vdso32 '$(DESTDIR_SQ)$(bindir_SQ)';
+endif
+ifndef NO_PERF_READ_VDSOX32
+	$(call QUIET_INSTALL, perf-read-vdsox32) \
+		$(INSTALL) $(OUTPUT)perf-read-vdsox32 '$(DESTDIR_SQ)$(bindir_SQ)';
+endif
 	$(call QUIET_INSTALL, libexec) \
 		$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(perfexec_instdir_SQ)'
 	$(call QUIET_INSTALL, perf-archive) \
@@ -928,7 +958,7 @@ config-clean:
 
 clean: $(LIBTRACEEVENT)-clean $(LIBAPIKFS)-clean config-clean
 	$(call QUIET_CLEAN, core-objs)  $(RM) $(LIB_OBJS) $(BUILTIN_OBJS) $(LIB_FILE) $(OUTPUT)perf-archive $(OUTPUT)perf-with-kcore $(OUTPUT)perf.o $(LANG_BINDINGS) $(GTK_OBJS)
-	$(call QUIET_CLEAN, core-progs) $(RM) $(ALL_PROGRAMS) perf
+	$(call QUIET_CLEAN, core-progs) $(RM) $(ALL_PROGRAMS) perf perf-read-vdso32 perf-read-vdsox32
 	$(call QUIET_CLEAN, core-gen)   $(RM)  *.spec *.pyc *.pyo */*.pyc */*.pyo $(OUTPUT)common-cmds.h TAGS tags cscope* $(OUTPUT)PERF-VERSION-FILE $(OUTPUT)PERF-CFLAGS $(OUTPUT)PERF-FEATURES $(OUTPUT)util/*-bison* $(OUTPUT)util/*-flex*
 	$(QUIET_SUBDIR0)Documentation $(QUIET_SUBDIR1) clean
 	$(python-clean)
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 1f67aa0..81c44cb 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -211,7 +211,9 @@ VF_FEATURE_TESTS =			\
 	bionic				\
 	liberty				\
 	liberty-z			\
-	cplus-demangle
+	cplus-demangle			\
+	compile-32			\
+	compile-x32
 
 # Set FEATURE_CHECK_(C|LD)FLAGS-all for all CORE_FEATURE_TESTS features.
 # If in the future we need per-feature checks/flags for features not
@@ -604,6 +606,27 @@ ifdef HAVE_KVM_STAT_SUPPORT
     CFLAGS += -DHAVE_KVM_STAT_SUPPORT
 endif
 
+ifeq (${IS_64_BIT}, 1)
+  ifndef NO_PERF_READ_VDSO32
+    $(call feature_check,compile-32)
+    ifneq ($(feature-compile-32), 1)
+      NO_PERF_READ_VDSO32 := 1
+    endif
+  endif
+  ifneq (${IS_X86_64}, 1)
+    NO_PERF_READ_VDSOX32 := 1
+  endif
+  ifndef NO_PERF_READ_VDSOX32
+    $(call feature_check,compile-x32)
+    ifneq ($(feature-compile-x32), 1)
+      NO_PERF_READ_VDSOX32 := 1
+    endif
+  endif
+else
+  NO_PERF_READ_VDSO32 := 1
+  NO_PERF_READ_VDSOX32 := 1
+endif
+
 # Among the variables below, these:
 #   perfexecdir
 #   template_dir
diff --git a/tools/perf/config/Makefile.arch b/tools/perf/config/Makefile.arch
index 4b06719..851cd01 100644
--- a/tools/perf/config/Makefile.arch
+++ b/tools/perf/config/Makefile.arch
@@ -21,3 +21,11 @@ ifeq ($(ARCH),x86_64)
     RAW_ARCH := x86_64
   endif
 endif
+
+ifeq (${IS_X86_64}, 1)
+  IS_64_BIT := 1
+else ifeq ($(ARCH),x86)
+  IS_64_BIT := 0
+else
+  IS_64_BIT := $(shell echo __LP64__ | ${CC} ${CFLAGS} -E -x c - | tail -n 1)
+endif
diff --git a/tools/perf/config/feature-checks/Makefile b/tools/perf/config/feature-checks/Makefile
index 6088f8d..8065dc5 100644
--- a/tools/perf/config/feature-checks/Makefile
+++ b/tools/perf/config/feature-checks/Makefile
@@ -27,7 +27,9 @@ FILES=					\
 	test-libunwind-debug-frame.bin	\
 	test-stackprotector-all.bin	\
 	test-timerfd.bin		\
-	test-libdw-dwarf-unwind.bin
+	test-libdw-dwarf-unwind.bin	\
+	test-compile-32.bin		\
+	test-compile-x32.bin
 
 CC := $(CROSS_COMPILE)gcc -MD
 PKG_CONFIG := $(CROSS_COMPILE)pkg-config
@@ -145,6 +147,12 @@ test-libdw-dwarf-unwind.bin:
 test-sync-compare-and-swap.bin:
 	$(BUILD) -Werror
 
+test-compile-32.bin:
+	$(CC) -m32 -o $(OUTPUT)$@ test-compile.c
+
+test-compile-x32.bin:
+	$(CC) -mx32 -o $(OUTPUT)$@ test-compile.c
+
 -include *.d
 
 ###############################
diff --git a/tools/perf/config/feature-checks/test-compile.c b/tools/perf/config/feature-checks/test-compile.c
new file mode 100644
index 0000000..31dbf45
--- /dev/null
+++ b/tools/perf/config/feature-checks/test-compile.c
@@ -0,0 +1,4 @@
+int main(void)
+{
+	return 0;
+}
diff --git a/tools/perf/perf-read-vdso.c b/tools/perf/perf-read-vdso.c
new file mode 100644
index 0000000..764e254
--- /dev/null
+++ b/tools/perf/perf-read-vdso.c
@@ -0,0 +1,34 @@
+#include <stdio.h>
+#include <string.h>
+
+#define VDSO__MAP_NAME "[vdso]"
+
+/*
+ * Include definition of find_vdso_map() also used in util/vdso.c for
+ * building perf.
+ */
+#include "util/find-vdso-map.c"
+
+int main(void)
+{
+	void *start, *end;
+	size_t size, written;
+
+	if (find_vdso_map(&start, &end))
+		return 1;
+
+	size = end - start;
+
+	while (size) {
+		written = fwrite(start, 1, size, stdout);
+		if (!written)
+			return 1;
+		start += written;
+		size -= written;
+	}
+
+	if (fflush(stdout))
+		return 1;
+
+	return 0;
+}
diff --git a/tools/perf/util/find-vdso-map.c b/tools/perf/util/find-vdso-map.c
new file mode 100644
index 0000000..95ef1cf
--- /dev/null
+++ b/tools/perf/util/find-vdso-map.c
@@ -0,0 +1,30 @@
+static int find_vdso_map(void **start, void **end)
+{
+	FILE *maps;
+	char line[128];
+	int found = 0;
+
+	maps = fopen("/proc/self/maps", "r");
+	if (!maps) {
+		fprintf(stderr, "vdso: cannot open maps\n");
+		return -1;
+	}
+
+	while (!found && fgets(line, sizeof(line), maps)) {
+		int m = -1;
+
+		/* We care only about private r-x mappings. */
+		if (2 != sscanf(line, "%p-%p r-xp %*x %*x:%*x %*u %n",
+				start, end, &m))
+			continue;
+		if (m < 0)
+			continue;
+
+		if (!strncmp(&line[m], VDSO__MAP_NAME,
+			     sizeof(VDSO__MAP_NAME) - 1))
+			found = 1;
+	}
+
+	fclose(maps);
+	return !found;
+}
diff --git a/tools/perf/util/vdso.c b/tools/perf/util/vdso.c
index a9300f8..36151e6 100644
--- a/tools/perf/util/vdso.c
+++ b/tools/perf/util/vdso.c
@@ -15,6 +15,12 @@
 #include "linux/string.h"
 #include "debug.h"
 
+/*
+ * Include definition of find_vdso_map() also used in perf-read-vdso.c for
+ * building perf-read-vdso32 and perf-read-vdsox32.
+ */
+#include "find-vdso-map.c"
+
 #define VDSO__TEMP_FILE_NAME "/tmp/perf-vdso.so-XXXXXX"
 
 struct vdso_file {
@@ -40,37 +46,6 @@ static struct vdso_info *vdso_info__new(void)
 	return memdup(&vdso_info_init, sizeof(vdso_info_init));
 }
 
-static int find_vdso_map(void **start, void **end)
-{
-	FILE *maps;
-	char line[128];
-	int found = 0;
-
-	maps = fopen("/proc/self/maps", "r");
-	if (!maps) {
-		pr_err("vdso: cannot open maps\n");
-		return -1;
-	}
-
-	while (!found && fgets(line, sizeof(line), maps)) {
-		int m = -1;
-
-		/* We care only about private r-x mappings. */
-		if (2 != sscanf(line, "%p-%p r-xp %*x %*x:%*x %*u %n",
-				start, end, &m))
-			continue;
-		if (m < 0)
-			continue;
-
-		if (!strncmp(&line[m], VDSO__MAP_NAME,
-			     sizeof(VDSO__MAP_NAME) - 1))
-			found = 1;
-	}
-
-	fclose(maps);
-	return !found;
-}
-
 static char *get_file(struct vdso_file *vdso_file)
 {
 	char *vdso = NULL;
-- 
1.8.3.2

