Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425Ab3IMG2L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 02:28:11 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:59150 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753204Ab3IMG2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 02:28:09 -0400
X-AuditID: 9c930179-b7c0bae0000040ac-58-5232b077bba3
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Pekka Enberg <penberg@kernel.org>, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH v6] perf tools: Separate out GTK codes to libperf-gtk.so
Date: Fri, 13 Sep 2013 15:27:43 +0900
Message-Id: <1379053663-13706-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <20130912123156.GA15187@krava.brq.redhat.com>
References: <20130912123156.GA15187@krava.brq.redhat.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Separate out GTK codes to a shared object called libperf-gtk.so.  This
time only GTK codes are built with -fPIC and libperf remains as is.
Now run GTK hist and annotation browser using libdl.

Cc: Andi Kleen <ak@linux.intel.com>
Reviewed-by: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/Makefile           | 45 ++++++++++++++++++++++---------
 tools/perf/builtin-annotate.c | 26 +++++++++++++++---
 tools/perf/builtin-report.c   | 16 ++++++++++--
 tools/perf/config/Makefile    | 12 ++++++---
 tools/perf/ui/gtk/annotate.c  | 13 ++++++---
 tools/perf/ui/gtk/gtk.h       | 16 ++++++++++++
 tools/perf/ui/setup.c         | 61 +++++++++++++++++++++++++++++++++++++++++--
 tools/perf/ui/ui.h            | 12 +--------
 tools/perf/util/annotate.h    | 24 -----------------
 tools/perf/util/hist.h        | 15 -----------
 tools/perf/util/util.h        |  2 ++
 11 files changed, 167 insertions(+), 75 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index c5dc1ad1b8d7..1b2da241c86d 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -113,6 +113,7 @@ SPARSE_FLAGS = -D__BIG_ENDIAN__ -D__powerpc__
 BUILTIN_OBJS =
 LIB_H =
 LIB_OBJS =
+GTK_OBJS =
 PYRF_OBJS =
 SCRIPT_SH =
 
@@ -488,13 +489,19 @@ ifndef NO_SLANG
 endif
 
 ifndef NO_GTK2
-  LIB_OBJS += $(OUTPUT)ui/gtk/browser.o
-  LIB_OBJS += $(OUTPUT)ui/gtk/hists.o
-  LIB_OBJS += $(OUTPUT)ui/gtk/setup.o
-  LIB_OBJS += $(OUTPUT)ui/gtk/util.o
-  LIB_OBJS += $(OUTPUT)ui/gtk/helpline.o
-  LIB_OBJS += $(OUTPUT)ui/gtk/progress.o
-  LIB_OBJS += $(OUTPUT)ui/gtk/annotate.o
+  ALL_PROGRAMS += $(OUTPUT)libperf-gtk.so
+
+  GTK_OBJS += $(OUTPUT)ui/gtk/browser.o
+  GTK_OBJS += $(OUTPUT)ui/gtk/hists.o
+  GTK_OBJS += $(OUTPUT)ui/gtk/setup.o
+  GTK_OBJS += $(OUTPUT)ui/gtk/util.o
+  GTK_OBJS += $(OUTPUT)ui/gtk/helpline.o
+  GTK_OBJS += $(OUTPUT)ui/gtk/progress.o
+  GTK_OBJS += $(OUTPUT)ui/gtk/annotate.o
+
+install-gtk: $(OUTPUT)libperf-gtk.so
+	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(libdir_SQ)'
+	$(INSTALL) $(OUTPUT)libperf-gtk.so '$(DESTDIR_SQ)$(libdir_SQ)'
 endif
 
 ifndef NO_LIBPERL
@@ -548,6 +555,12 @@ $(OUTPUT)perf: $(OUTPUT)perf.o $(BUILTIN_OBJS) $(PERFLIBS)
 	$(QUIET_LINK)$(CC) $(CFLAGS) $(LDFLAGS) $(OUTPUT)perf.o \
                $(BUILTIN_OBJS) $(LIBS) -o $@
 
+$(GTK_OBJS): $(OUTPUT)%.o: %.c $(LIB_H)
+	$(QUIET_CC)$(CC) -o $@ -c -fPIC $(CFLAGS) $(GTK_CFLAGS) $<
+
+$(OUTPUT)libperf-gtk.so: $(GTK_OBJS) $(PERFLIBS)
+	$(QUIET_LINK)$(CC) -o $@ -shared $(ALL_LDFLAGS) $(filter %.o,$^) $(GTK_LIBS)
+
 $(OUTPUT)builtin-help.o: builtin-help.c $(OUTPUT)common-cmds.h $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) \
 		'-DPERF_HTML_PATH="$(htmldir_SQ)"' \
@@ -616,6 +629,9 @@ $(OUTPUT)tests/python-use.o: tests/python-use.c $(OUTPUT)PERF-CFLAGS
 $(OUTPUT)util/config.o: util/config.c $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) -DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"' $<
 
+$(OUTPUT)ui/setup.o: ui/setup.c $(OUTPUT)PERF-CFLAGS
+	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) -DLIBDIR='"$(libdir_SQ)"' $<
+
 $(OUTPUT)ui/browser.o: ui/browser.c $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) -DENABLE_SLFUTURE_CONST $<
 
@@ -657,7 +673,8 @@ $(patsubst perf-%,%.o,$(PROGRAMS)): $(LIB_H) $(wildcard */*.h)
 
 # we compile into subdirectories. if the target directory is not the source directory, they might not exists. So
 # we depend the various files onto their directories.
-DIRECTORY_DEPS = $(LIB_OBJS) $(BUILTIN_OBJS) $(OUTPUT)PERF-VERSION-FILE $(OUTPUT)common-cmds.h
+DIRECTORY_DEPS = $(LIB_OBJS) $(BUILTIN_OBJS) $(GTK_OBJS)
+DIRECTORY_DEPS += $(OUTPUT)PERF-VERSION-FILE $(OUTPUT)common-cmds.h
 $(DIRECTORY_DEPS): | $(sort $(dir $(DIRECTORY_DEPS)))
 # In the second step, we make a rule to actually create these directories
 $(sort $(dir $(DIRECTORY_DEPS))):
@@ -766,7 +783,9 @@ check: $(OUTPUT)common-cmds.h
 
 ### Installation rules
 
-install-bin: all
+install-gtk:
+
+install-bin: all install-gtk
 	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(bindir_SQ)'
 	$(INSTALL) $(OUTPUT)perf '$(DESTDIR_SQ)$(bindir_SQ)'
 	$(INSTALL) $(OUTPUT)perf-archive -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)'
@@ -803,15 +822,17 @@ $(INSTALL_DOC_TARGETS):
 ### Cleaning rules
 
 clean: $(LIBTRACEEVENT)-clean $(LIBLK)-clean
-	$(RM) $(LIB_OBJS) $(BUILTIN_OBJS) $(LIB_FILE) $(OUTPUT)perf-archive $(OUTPUT)perf.o $(LANG_BINDINGS)
+	$(RM) $(LIB_OBJS) $(BUILTIN_OBJS) $(LIB_FILE) $(GTK_OBJS)
+	$(RM) $(OUTPUT)perf-archive $(OUTPUT)perf.o $(LANG_BINDINGS)
 	$(RM) $(ALL_PROGRAMS) perf
-	$(RM) *.spec *.pyc *.pyo */*.pyc */*.pyo $(OUTPUT)common-cmds.h TAGS tags cscope*
+	$(RM) *.spec *.pyc *.pyo */*.pyc */*.pyo
+	$(RM) $(OUTPUT)common-cmds.h TAGS tags cscope*
 	$(QUIET_SUBDIR0)Documentation $(QUIET_SUBDIR1) clean
 	$(RM) $(OUTPUT)PERF-VERSION-FILE $(OUTPUT)PERF-CFLAGS
 	$(RM) $(OUTPUT)util/*-bison*
 	$(RM) $(OUTPUT)util/*-flex*
 	$(python-clean)
 
-.PHONY: all install clean strip $(LIBTRACEEVENT) $(LIBLK)
+.PHONY: all install clean strip $(LIBTRACEEVENT) $(LIBLK) install-gtk
 .PHONY: shell_compatibility_test please_set_SHELL_PATH_to_a_more_modern_shell
 .PHONY: .FORCE-PERF-VERSION-FILE TAGS tags cscope .FORCE-PERF-CFLAGS
diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index f988d380c52f..057c5bf168c5 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -30,6 +30,7 @@
 #include "util/tool.h"
 #include "arch/common.h"
 
+#include <dlfcn.h>
 #include <linux/bitmap.h>
 
 struct perf_annotate {
@@ -142,8 +143,18 @@ find_next:
 
 		if (use_browser == 2) {
 			int ret;
+			int (*annotate)(struct hist_entry *he,
+					struct perf_evsel *evsel,
+					struct hist_browser_timer *hbt);
+
+			annotate = dlsym(perf_gtk_handle,
+					 "hist_entry__gtk_annotate");
+			if (annotate == NULL) {
+				ui__error("GTK browser not found!\n");
+				return;
+			}
 
-			ret = hist_entry__gtk_annotate(he, evsel, NULL);
+			ret = annotate(he, evsel, NULL);
 			if (!ret || !ann->skip_missing)
 				return;
 
@@ -247,8 +258,17 @@ static int __cmd_annotate(struct perf_annotate *ann)
 		goto out_delete;
 	}
 
-	if (use_browser == 2)
-		perf_gtk__show_annotations();
+	if (use_browser == 2) {
+		void (*show_annotations)(void);
+
+		show_annotations = dlsym(perf_gtk_handle,
+					 "perf_gtk__show_annotations");
+		if (show_annotations == NULL) {
+			ui__error("GTK browser not found!\n");
+			goto out_delete;
+		}
+		show_annotations();
+	}
 
 out_delete:
 	/*
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 9725aa375414..265471a7ad31 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -35,6 +35,7 @@
 #include "util/hist.h"
 #include "arch/common.h"
 
+#include <dlfcn.h>
 #include <linux/bitmap.h>
 
 struct perf_report {
@@ -590,8 +591,19 @@ static int __cmd_report(struct perf_report *rep)
 				ret = 0;
 
 		} else if (use_browser == 2) {
-			perf_evlist__gtk_browse_hists(session->evlist, help,
-						      NULL, rep->min_percent);
+			int (*hist_browser)(struct perf_evlist *,
+					    const char *,
+					    struct hist_browser_timer *,
+					    float min_pcnt);
+
+			hist_browser = dlsym(perf_gtk_handle,
+					     "perf_evlist__gtk_browse_hists");
+			if (hist_browser == NULL) {
+				ui__error("GTK browser not found!\n");
+				return ret;
+			}
+			hist_browser(session->evlist, help, NULL,
+				     rep->min_percent);
 		}
 	} else
 		perf_evlist__tty_browse_hists(session->evlist, rep, help);
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 214e17e97e5c..1b6ccb242609 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -267,11 +267,11 @@ ifndef NO_GTK2
     NO_GTK2 := 1
   else
     ifeq ($(call try-cc,$(SOURCE_GTK2_INFOBAR),$(FLAGS_GTK2),-DHAVE_GTK_INFO_BAR),y)
-      CFLAGS += -DHAVE_GTK_INFO_BAR
+      GTK_CFLAGS := -DHAVE_GTK_INFO_BAR
     endif
     CFLAGS += -DGTK2_SUPPORT
-    CFLAGS += $(shell pkg-config --cflags gtk+-2.0 2>/dev/null)
-    EXTLIBS += $(shell pkg-config --libs gtk+-2.0 2>/dev/null)
+    GTK_CFLAGS += $(shell pkg-config --cflags gtk+-2.0 2>/dev/null)
+    GTK_LIBS := $(shell pkg-config --libs gtk+-2.0 2>/dev/null)
   endif
 endif
 
@@ -456,7 +456,12 @@ else
 sysconfdir = $(prefix)/etc
 ETC_PERFCONFIG = etc/perfconfig
 endif
+ifeq ($(IS_X86_64),1)
+lib = lib64
+else
 lib = lib
+endif
+libdir = $(prefix)/$(lib)
 
 # Shell quote (do not use $(call) to accommodate ancient setups);
 ETC_PERFCONFIG_SQ = $(subst ','\'',$(ETC_PERFCONFIG))
@@ -469,6 +474,7 @@ template_dir_SQ = $(subst ','\'',$(template_dir))
 htmldir_SQ = $(subst ','\'',$(htmldir))
 prefix_SQ = $(subst ','\'',$(prefix))
 sysconfdir_SQ = $(subst ','\'',$(sysconfdir))
+libdir_SQ = $(subst ','\'',$(libdir))
 
 ifneq ($(filter /%,$(firstword $(perfexecdir))),)
 perfexec_instdir = $(perfexecdir)
diff --git a/tools/perf/ui/gtk/annotate.c b/tools/perf/ui/gtk/annotate.c
index f538794615db..9c7ff8d31b27 100644
--- a/tools/perf/ui/gtk/annotate.c
+++ b/tools/perf/ui/gtk/annotate.c
@@ -154,9 +154,9 @@ static int perf_gtk__annotate_symbol(GtkWidget *window, struct symbol *sym,
 	return 0;
 }
 
-int symbol__gtk_annotate(struct symbol *sym, struct map *map,
-			 struct perf_evsel *evsel,
-			 struct hist_browser_timer *hbt)
+static int symbol__gtk_annotate(struct symbol *sym, struct map *map,
+				struct perf_evsel *evsel,
+				struct hist_browser_timer *hbt)
 {
 	GtkWidget *window;
 	GtkWidget *notebook;
@@ -226,6 +226,13 @@ int symbol__gtk_annotate(struct symbol *sym, struct map *map,
 	return 0;
 }
 
+int hist_entry__gtk_annotate(struct hist_entry *he,
+			     struct perf_evsel *evsel,
+			     struct hist_browser_timer *hbt)
+{
+	return symbol__gtk_annotate(he->ms.sym, he->ms.map, evsel, hbt);
+}
+
 void perf_gtk__show_annotations(void)
 {
 	GtkWidget *window;
diff --git a/tools/perf/ui/gtk/gtk.h b/tools/perf/ui/gtk/gtk.h
index 3d96785ef155..62922d284bca 100644
--- a/tools/perf/ui/gtk/gtk.h
+++ b/tools/perf/ui/gtk/gtk.h
@@ -20,6 +20,9 @@ struct perf_gtk_context {
 	guint statbar_ctx_id;
 };
 
+int perf_gtk__init(void);
+void perf_gtk__exit(bool wait_for_ok);
+
 extern struct perf_gtk_context *pgctx;
 
 static inline bool perf_gtk__is_active_context(struct perf_gtk_context *ctx)
@@ -48,4 +51,17 @@ static inline GtkWidget *perf_gtk__setup_info_bar(void)
 }
 #endif
 
+struct perf_evsel;
+struct perf_evlist;
+struct hist_entry;
+struct hist_browser_timer;
+
+int perf_evlist__gtk_browse_hists(struct perf_evlist *evlist, const char *help,
+				  struct hist_browser_timer *hbt,
+				  float min_pcnt);
+int hist_entry__gtk_annotate(struct hist_entry *he,
+			     struct perf_evsel *evsel,
+			     struct hist_browser_timer *hbt);
+void perf_gtk__show_annotations(void);
+
 #endif /* _PERF_GTK_H_ */
diff --git a/tools/perf/ui/setup.c b/tools/perf/ui/setup.c
index 47d9a571f261..e840bb6c6413 100644
--- a/tools/perf/ui/setup.c
+++ b/tools/perf/ui/setup.c
@@ -1,10 +1,64 @@
 #include <pthread.h>
+#include <dlfcn.h>
 
 #include "../util/cache.h"
 #include "../util/debug.h"
 #include "../util/hist.h"
 
 pthread_mutex_t ui__lock = PTHREAD_MUTEX_INITIALIZER;
+void *perf_gtk_handle;
+
+#ifdef GTK2_SUPPORT
+static int setup_gtk_browser(void)
+{
+	int (*perf_ui_init)(void);
+
+	if (perf_gtk_handle)
+		return 0;
+
+	perf_gtk_handle = dlopen(PERF_GTK_DSO, RTLD_LAZY);
+	if (perf_gtk_handle == NULL) {
+		char buf[PATH_MAX];
+		scnprintf(buf, sizeof(buf), "%s/%s", LIBDIR, PERF_GTK_DSO);
+		perf_gtk_handle = dlopen(buf, RTLD_LAZY);
+	}
+	if (perf_gtk_handle == NULL)
+		return -1;
+
+	perf_ui_init = dlsym(perf_gtk_handle, "perf_gtk__init");
+	if (perf_ui_init == NULL)
+		goto out_close;
+
+	if (perf_ui_init() == 0)
+		return 0;
+
+out_close:
+	dlclose(perf_gtk_handle);
+	return -1;
+}
+
+static void exit_gtk_browser(bool wait_for_ok)
+{
+	void (*perf_ui_exit)(bool);
+
+	if (perf_gtk_handle == NULL)
+		return;
+
+	perf_ui_exit = dlsym(perf_gtk_handle, "perf_gtk__exit");
+	if (perf_ui_exit == NULL)
+		goto out_close;
+
+	perf_ui_exit(wait_for_ok);
+
+out_close:
+	dlclose(perf_gtk_handle);
+
+	perf_gtk_handle = NULL;
+}
+#else
+static inline int setup_gtk_browser(void) { return -1; }
+static inline void exit_gtk_browser(bool wait_for_ok __maybe_unused) {}
+#endif
 
 void setup_browser(bool fallback_to_pager)
 {
@@ -17,8 +71,11 @@ void setup_browser(bool fallback_to_pager)
 
 	switch (use_browser) {
 	case 2:
-		if (perf_gtk__init() == 0)
+		if (setup_gtk_browser() == 0)
 			break;
+		printf("GTK browser requested but could not find %s\n",
+		       PERF_GTK_DSO);
+		sleep(1);
 		/* fall through */
 	case 1:
 		use_browser = 1;
@@ -39,7 +96,7 @@ void exit_browser(bool wait_for_ok)
 {
 	switch (use_browser) {
 	case 2:
-		perf_gtk__exit(wait_for_ok);
+		exit_gtk_browser(wait_for_ok);
 		break;
 
 	case 1:
diff --git a/tools/perf/ui/ui.h b/tools/perf/ui/ui.h
index 70cb0d4eb8aa..4f7cbe6a2608 100644
--- a/tools/perf/ui/ui.h
+++ b/tools/perf/ui/ui.h
@@ -6,6 +6,7 @@
 #include <linux/compiler.h>
 
 extern pthread_mutex_t ui__lock;
+extern void *perf_gtk_handle;
 
 extern int use_browser;
 
@@ -23,17 +24,6 @@ static inline int ui__init(void)
 static inline void ui__exit(bool wait_for_ok __maybe_unused) {}
 #endif
 
-#ifdef GTK2_SUPPORT
-int perf_gtk__init(void);
-void perf_gtk__exit(bool wait_for_ok);
-#else
-static inline int perf_gtk__init(void)
-{
-	return -1;
-}
-static inline void perf_gtk__exit(bool wait_for_ok __maybe_unused) {}
-#endif
-
 void ui__refresh_dimensions(bool force);
 
 #endif /* _PERF_UI_H_ */
diff --git a/tools/perf/util/annotate.h b/tools/perf/util/annotate.h
index af755156d278..31b898312c3f 100644
--- a/tools/perf/util/annotate.h
+++ b/tools/perf/util/annotate.h
@@ -165,30 +165,6 @@ static inline int symbol__tui_annotate(struct symbol *sym __maybe_unused,
 }
 #endif
 
-#ifdef GTK2_SUPPORT
-int symbol__gtk_annotate(struct symbol *sym, struct map *map,
-			 struct perf_evsel *evsel,
-			 struct hist_browser_timer *hbt);
-
-static inline int hist_entry__gtk_annotate(struct hist_entry *he,
-					   struct perf_evsel *evsel,
-					   struct hist_browser_timer *hbt)
-{
-	return symbol__gtk_annotate(he->ms.sym, he->ms.map, evsel, hbt);
-}
-
-void perf_gtk__show_annotations(void);
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
-
 extern const char	*disassembler_style;
 
 #endif	/* __PERF_ANNOTATE_H */
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 1329b6b6ffe6..7f29792efc58 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -224,20 +224,5 @@ static inline int script_browse(const char *script_opt __maybe_unused)
 #define K_SWITCH_INPUT_DATA -3000
 #endif
 
-#ifdef GTK2_SUPPORT
-int perf_evlist__gtk_browse_hists(struct perf_evlist *evlist, const char *help,
-				  struct hist_browser_timer *hbt __maybe_unused,
-				  float min_pcnt);
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
-
 unsigned int hists__sort_list_width(struct hists *self);
 #endif	/* __PERF_HIST_H */
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index a53535949043..7172ec714603 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -128,6 +128,8 @@ void put_tracing_file(char *file);
 #endif
 #endif
 
+#define PERF_GTK_DSO  "libperf-gtk.so"
+
 /* General helper functions */
 extern void usage(const char *err) NORETURN;
 extern void die(const char *err, ...) NORETURN __attribute__((format (printf, 1, 2)));
-- 
1.7.11.7

