Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754376Ab3HECWu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Aug 2013 22:22:50 -0400
Received: from mga11.intel.com ([192.55.52.93]:49425 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754328Ab3HECWs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Aug 2013 22:22:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,815,1367996400"; 
   d="scan'208";a="376126088"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: acme@infradead.org, Andi Kleen <ak@linux.intel.com>,
        Namhyung Kim <namhyung.kim@lge.com>, mingo@kernel.org,
        peterz@infradead.org
Subject: [PATCH] RFC: perf, tools: Move gtk browser into separate perfgtk executable
Date: Sun,  4 Aug 2013 19:22:44 -0700
Message-Id: <1375669364-13838-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

By default perf currently links with the GTK2 gui. This pulls
in a lot of external libraries. It also causes dependency
problems for distribution packages: simply installing perf
requires pulling in GTK2 with all its dependencies.

I think the UI is valuable, but it shouldn't be everywhere.

The interfaces between the main perf and the GTK2 perf are
already quite clean, so it's very straight forward to just
add a few weak stubs and then generate two executables:
perf and perfgtk

The only difference is that the gtk version links in the
GTK code and overrides the weak stubs.
(so everything is still only compiled once)

I currently gave it the preliminary name "perfgtk".

This cuts down the library dependencies on the main perf
dramatically. It also completely eliminates the GTK2_SUPPORT
ifdef.

% ldd ./perf | wc -l
18
% ldd ./perfgtk | wc -l
53

Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: mingo@kernel.org
Cc: peterz@infradead.org
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/Makefile        | 34 +++++++++++++++++++++-------------
 tools/perf/config/Makefile |  4 ++--
 tools/perf/ui/gtkstub.c    | 37 +++++++++++++++++++++++++++++++++++++
 tools/perf/ui/ui.h         |  8 --------
 tools/perf/util/annotate.h | 11 -----------
 tools/perf/util/hist.h     | 11 -----------
 6 files changed, 60 insertions(+), 45 deletions(-)
 create mode 100644 tools/perf/ui/gtkstub.c

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 641fccd..25116fc 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -113,6 +113,7 @@ SPARSE_FLAGS = -D__BIG_ENDIAN__ -D__powerpc__
 BUILTIN_OBJS =
 LIB_H =
 LIB_OBJS =
+GUI_OBJS =
 PYRF_OBJS =
 SCRIPT_SH =
 
@@ -161,11 +162,12 @@ $(OUTPUT)python/perf.so: $(PYTHON_EXT_SRCS) $(PYTHON_EXT_DEPS)
 
 SCRIPTS = $(patsubst %.sh,%,$(SCRIPT_SH))
 
-#
-# Single 'perf' binary right now:
-#
 PROGRAMS += $(OUTPUT)perf
 
+ifndef NO_GTK2
+  PROGRAMS += $(OUTPUT)perfgtk
+endif
+
 # what 'all' will build and 'install' will install, in perfexecdir
 ALL_PROGRAMS = $(PROGRAMS) $(SCRIPTS)
 
@@ -366,6 +368,7 @@ LIB_OBJS += $(OUTPUT)ui/helpline.o
 LIB_OBJS += $(OUTPUT)ui/progress.o
 LIB_OBJS += $(OUTPUT)ui/util.o
 LIB_OBJS += $(OUTPUT)ui/hist.o
+LIB_OBJS += $(OUTPUT)ui/gtkstub.o
 LIB_OBJS += $(OUTPUT)ui/stdio/hist.o
 
 LIB_OBJS += $(OUTPUT)arch/common.o
@@ -481,13 +484,13 @@ ifndef NO_SLANG
 endif
 
 ifndef NO_GTK2
-  LIB_OBJS += $(OUTPUT)ui/gtk/browser.o
-  LIB_OBJS += $(OUTPUT)ui/gtk/hists.o
-  LIB_OBJS += $(OUTPUT)ui/gtk/setup.o
-  LIB_OBJS += $(OUTPUT)ui/gtk/util.o
-  LIB_OBJS += $(OUTPUT)ui/gtk/helpline.o
-  LIB_OBJS += $(OUTPUT)ui/gtk/progress.o
-  LIB_OBJS += $(OUTPUT)ui/gtk/annotate.o
+  GUI_OBJS += $(OUTPUT)ui/gtk/browser.o
+  GUI_OBJS += $(OUTPUT)ui/gtk/hists.o
+  GUI_OBJS += $(OUTPUT)ui/gtk/setup.o
+  GUI_OBJS += $(OUTPUT)ui/gtk/util.o
+  GUI_OBJS += $(OUTPUT)ui/gtk/helpline.o
+  GUI_OBJS += $(OUTPUT)ui/gtk/progress.o
+  GUI_OBJS += $(OUTPUT)ui/gtk/annotate.o
 endif
 
 ifndef NO_LIBPERL
@@ -541,6 +544,10 @@ $(OUTPUT)perf: $(OUTPUT)perf.o $(BUILTIN_OBJS) $(PERFLIBS)
 	$(QUIET_LINK)$(CC) $(CFLAGS) $(LDFLAGS) $(OUTPUT)perf.o \
                $(BUILTIN_OBJS) $(LIBS) -o $@
 
+$(OUTPUT)perfgtk: $(OUTPUT)perf.o $(BUILTIN_OBJS) $(PERFLIBS) $(GUI_OBJS)
+	$(QUIET_LINK)$(CC) $(CFLAGS) $(LDFLAGS) $(OUTPUT)perf.o \
+               $(BUILTIN_OBJS) $(GUI_OBJS) $(LIBS) $(GUI_EXTLIBS) -o $@
+
 $(OUTPUT)builtin-help.o: builtin-help.c $(OUTPUT)common-cmds.h $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) \
 		'-DPERF_HTML_PATH="$(htmldir_SQ)"' \
@@ -645,12 +652,12 @@ $(OUTPUT)scripts/python/Perf-Trace-Util/Context.o: scripts/python/Perf-Trace-Uti
 $(OUTPUT)perf-%: %.o $(PERFLIBS)
 	$(QUIET_LINK)$(CC) $(CFLAGS) -o $@ $(LDFLAGS) $(filter %.o,$^) $(LIBS)
 
-$(LIB_OBJS) $(BUILTIN_OBJS): $(LIB_H)
+$(LIB_OBJS) $(BUILTIN_OBJS) $(GUI_OBJS): $(LIB_H)
 $(patsubst perf-%,%.o,$(PROGRAMS)): $(LIB_H) $(wildcard */*.h)
 
 # we compile into subdirectories. if the target directory is not the source directory, they might not exists. So
 # we depend the various files onto their directories.
-DIRECTORY_DEPS = $(LIB_OBJS) $(BUILTIN_OBJS) $(OUTPUT)PERF-VERSION-FILE $(OUTPUT)common-cmds.h
+DIRECTORY_DEPS = $(LIB_OBJS) $(GUI_OBJS) $(BUILTIN_OBJS) $(OUTPUT)PERF-VERSION-FILE $(OUTPUT)common-cmds.h
 $(DIRECTORY_DEPS): | $(sort $(dir $(DIRECTORY_DEPS)))
 # In the second step, we make a rule to actually create these directories
 $(sort $(dir $(DIRECTORY_DEPS))):
@@ -792,7 +799,8 @@ $(INSTALL_DOC_TARGETS):
 ### Cleaning rules
 
 clean: $(LIBTRACEEVENT)-clean $(LIBLK)-clean
-	$(RM) $(LIB_OBJS) $(BUILTIN_OBJS) $(LIB_FILE) $(OUTPUT)perf-archive $(OUTPUT)perf.o $(LANG_BINDINGS)
+	$(RM) $(LIB_OBJS) $(GUI_OBJS) $(BUILTIN_OBJS) $(LIB_FILE)
+	$(RM) $(OUTPUT)perf-archive $(OUTPUT)perf.o $(LANG_BINDINGS)
 	$(RM) $(ALL_PROGRAMS) perf
 	$(RM) *.spec *.pyc *.pyo */*.pyc */*.pyo $(OUTPUT)common-cmds.h TAGS tags cscope*
 	$(QUIET_SUBDIR0)Documentation $(QUIET_SUBDIR1) clean
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index b5d9238..d718961 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -86,6 +86,7 @@ CFLAGS += -Wextra
 CFLAGS += -std=gnu99
 
 EXTLIBS = -lelf -lpthread -lrt -lm
+GUI_EXTLIBS =
 
 ifeq ($(call try-cc,$(SOURCE_HELLO),$(CFLAGS) -Werror -fstack-protector-all,-fstack-protector-all),y)
   CFLAGS += -fstack-protector-all
@@ -268,9 +269,8 @@ ifndef NO_GTK2
     ifeq ($(call try-cc,$(SOURCE_GTK2_INFOBAR),$(FLAGS_GTK2),-DHAVE_GTK_INFO_BAR),y)
       CFLAGS += -DHAVE_GTK_INFO_BAR
     endif
-    CFLAGS += -DGTK2_SUPPORT
     CFLAGS += $(shell pkg-config --cflags gtk+-2.0 2>/dev/null)
-    EXTLIBS += $(shell pkg-config --libs gtk+-2.0 2>/dev/null)
+    GUI_EXTLIBS += $(shell pkg-config --libs gtk+-2.0 2>/dev/null)
   endif
 endif
 
diff --git a/tools/perf/ui/gtkstub.c b/tools/perf/ui/gtkstub.c
new file mode 100644
index 0000000..cb58d31
--- /dev/null
+++ b/tools/perf/ui/gtkstub.c
@@ -0,0 +1,37 @@
+#include "ui/ui.h"
+#include "util/annotate.h"
+
+/* Stubs used when the gtk2 code is not linked in */
+
+#define __weak __attribute__((weak))
+
+__weak int perf_gtk__init(void)
+{
+	return -1;
+}
+
+__weak void perf_gtk__exit(bool wait_for_ok __maybe_unused)
+{
+}
+
+__weak int perf_evlist__gtk_browse_hists(struct perf_evlist *evlist __maybe_unused,
+					 const char *help __maybe_unused,
+					 struct hist_browser_timer *hbt __maybe_unused,
+					 float min_pcnt __maybe_unused)
+{
+	return 0;
+}
+
+
+__weak void perf_gtk__show_annotations(void)
+{
+}
+
+__weak int symbol__gtk_annotate(struct symbol *sym __maybe_unused,
+				struct map *map __maybe_unused,
+				struct perf_evsel *evsel __maybe_unused,
+				struct hist_browser_timer *hbt __maybe_unused)
+{
+	return 0;
+}
+
diff --git a/tools/perf/ui/ui.h b/tools/perf/ui/ui.h
index 70cb0d4..3a6ca86 100644
--- a/tools/perf/ui/ui.h
+++ b/tools/perf/ui/ui.h
@@ -23,16 +23,8 @@ static inline int ui__init(void)
 static inline void ui__exit(bool wait_for_ok __maybe_unused) {}
 #endif
 
-#ifdef GTK2_SUPPORT
 int perf_gtk__init(void);
 void perf_gtk__exit(bool wait_for_ok);
-#else
-static inline int perf_gtk__init(void)
-{
-	return -1;
-}
-static inline void perf_gtk__exit(bool wait_for_ok __maybe_unused) {}
-#endif
 
 void ui__refresh_dimensions(bool force);
 
diff --git a/tools/perf/util/annotate.h b/tools/perf/util/annotate.h
index af75515..ac70cc6 100644
--- a/tools/perf/util/annotate.h
+++ b/tools/perf/util/annotate.h
@@ -165,7 +165,6 @@ static inline int symbol__tui_annotate(struct symbol *sym __maybe_unused,
 }
 #endif
 
-#ifdef GTK2_SUPPORT
 int symbol__gtk_annotate(struct symbol *sym, struct map *map,
 			 struct perf_evsel *evsel,
 			 struct hist_browser_timer *hbt);
@@ -178,16 +177,6 @@ static inline int hist_entry__gtk_annotate(struct hist_entry *he,
 }
 
 void perf_gtk__show_annotations(void);
-#else
-static inline int hist_entry__gtk_annotate(struct hist_entry *he __maybe_unused,
-				struct perf_evsel *evsel __maybe_unused,
-				struct hist_browser_timer *hbt __maybe_unused)
-{
-	return 0;
-}
-
-static inline void perf_gtk__show_annotations(void) {}
-#endif
 
 extern const char	*disassembler_style;
 
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 2d3790f..9fa8b2d 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -229,20 +229,9 @@ static inline int script_browse(const char *script_opt __maybe_unused)
 #define K_SWITCH_INPUT_DATA -3000
 #endif
 
-#ifdef GTK2_SUPPORT
 int perf_evlist__gtk_browse_hists(struct perf_evlist *evlist, const char *help,
 				  struct hist_browser_timer *hbt __maybe_unused,
 				  float min_pcnt);
-#else
-static inline
-int perf_evlist__gtk_browse_hists(struct perf_evlist *evlist __maybe_unused,
-				  const char *help __maybe_unused,
-				  struct hist_browser_timer *hbt __maybe_unused,
-				  float min_pcnt __maybe_unused)
-{
-	return 0;
-}
-#endif
 
 unsigned int hists__sort_list_width(struct hists *self);
 
-- 
1.8.3.1

