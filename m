Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755361AbaIHVUU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 17:20:20 -0400
Received: from mail.kernel.org ([198.145.19.201]:39166 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755206AbaIHVTC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 17:19:02 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 10/13] perf tools: Build programs to copy 32-bit compatibility VDSOs
Date: Mon,  8 Sep 2014 18:18:06 -0300
Message-Id: <1410211089-28668-11-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1410211089-28668-1-git-send-email-acme@kernel.org>
References: <1410211089-28668-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

perf tools copy VDSO out of memory.  However, on 64-bit machines there
may be 32-bit compatibility VDOs also.  To copy those requires separate
32-bit executables.  This patch adds to the build additional programs
perf-read-vdso32 and perf-read-vdsox32 for 32-bit and x32 respectively.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1406786474-9306-31-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile.perf        | 37 +++++++++++++++++++++++---
 tools/perf/config/Makefile      | 21 +++++++++++++++
 tools/perf/config/Makefile.arch |  8 ++++++
 tools/perf/perf-read-vdso.c     | 59 +++++++++++++++++++++++++++++++++++++++++
 4 files changed, 121 insertions(+), 4 deletions(-)
 create mode 100644 tools/perf/perf-read-vdso.c

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 171f4e65601b..8c57566205f0 100644
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
 
@@ -731,6 +742,16 @@ $(OUTPUT)scripts/python/Perf-Trace-Util/Context.o: scripts/python/Perf-Trace-Uti
 $(OUTPUT)perf-%: %.o $(PERFLIBS)
 	$(QUIET_LINK)$(CC) $(CFLAGS) -o $@ $(LDFLAGS) $(filter %.o,$^) $(LIBS)
 
+ifndef NO_PERF_READ_VDSO32
+$(OUTPUT)perf-read-vdso32: perf-read-vdso.c
+	$(QUIET_CC)$(CC) -m32 -Wall -Werror -o $@ perf-read-vdso.c
+endif
+
+ifndef NO_PERF_READ_VDSOX32
+$(OUTPUT)perf-read-vdsox32: perf-read-vdso.c
+	$(QUIET_CC)$(CC) -mx32 -Wall -Werror -o $@ perf-read-vdso.c
+endif
+
 $(LIB_OBJS) $(BUILTIN_OBJS): $(LIB_H)
 $(patsubst perf-%,%.o,$(PROGRAMS)): $(LIB_H) $(wildcard */*.h)
 
@@ -875,6 +896,14 @@ install-bin: all install-gtk
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
@@ -927,7 +956,7 @@ config-clean:
 
 clean: $(LIBTRACEEVENT)-clean $(LIBAPIKFS)-clean config-clean
 	$(call QUIET_CLEAN, core-objs)  $(RM) $(LIB_OBJS) $(BUILTIN_OBJS) $(LIB_FILE) $(OUTPUT)perf-archive $(OUTPUT)perf-with-kcore $(OUTPUT)perf.o $(LANG_BINDINGS) $(GTK_OBJS)
-	$(call QUIET_CLEAN, core-progs) $(RM) $(ALL_PROGRAMS) perf
+	$(call QUIET_CLEAN, core-progs) $(RM) $(ALL_PROGRAMS) perf perf-read-vdso32 perf-read-vdsox32
 	$(call QUIET_CLEAN, core-gen)   $(RM)  *.spec *.pyc *.pyo */*.pyc */*.pyo $(OUTPUT)common-cmds.h TAGS tags cscope* $(OUTPUT)PERF-VERSION-FILE $(OUTPUT)PERF-CFLAGS $(OUTPUT)PERF-FEATURES $(OUTPUT)util/*-bison* $(OUTPUT)util/*-flex*
 	$(QUIET_SUBDIR0)Documentation $(QUIET_SUBDIR1) clean
 	$(python-clean)
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 58f609198c6d..499601a49d8e 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -622,6 +622,27 @@ ifdef HAVE_KVM_STAT_SUPPORT
     CFLAGS += -DHAVE_KVM_STAT_SUPPORT
 endif
 
+ifeq (${IS_64_BIT}, 1)
+  ifndef NO_PERF_READ_VDSO32
+    CAN_DO := $(shell echo "main() {}" | ${CC} -m32 -x c - >/dev/null 2>/dev/null && echo 1 || echo 0)
+    ifneq (${CAN_DO}, 1)
+      NO_PERF_READ_VDSO32 := 1
+    endif
+  endif
+  ifneq (${IS_X86_64}, 1)
+    NO_PERF_READ_VDSOX32 := 1
+  endif
+  ifndef NO_PERF_READ_VDSOX32
+    CAN_DO := $(shell echo 'main() {}' | ${CC} -mx32 -x c - >/dev/null 2>/dev/null && echo 1 || echo 0)
+    ifneq (${CAN_DO}, 1)
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
index 4b06719ee984..851cd0172a76 100644
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
diff --git a/tools/perf/perf-read-vdso.c b/tools/perf/perf-read-vdso.c
new file mode 100644
index 000000000000..a6b49b5c2cf3
--- /dev/null
+++ b/tools/perf/perf-read-vdso.c
@@ -0,0 +1,59 @@
+#include <stdio.h>
+#include <string.h>
+
+#define VDSO__MAP_NAME "[vdso]"
+
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
-- 
1.9.3

