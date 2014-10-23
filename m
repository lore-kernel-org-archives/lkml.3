Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755236AbaJWWdx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 18:33:53 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:48473 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753867AbaJWWbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 18:31:14 -0400
From: Alexis Berlemont <alexis.berlemont@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Alexis Berlemont <alexis.berlemont@gmail.com>, jolsa@redhat.com,
        dsahern@gmail.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        paulus@samba.org, acme@kernel.org, namhyung@kernel.org, mmarek@suse.cz
Subject: [PATCH v3 06/14] perf kbuild: remove legacy tui/gui-related build variables
Date: Fri, 24 Oct 2014 00:28:14 +0200
Message-Id: <1414103302-14906-7-git-send-email-alexis.berlemont@gmail.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1414103302-14906-1-git-send-email-alexis.berlemont@gmail.com>
References: <1414103302-14906-1-git-send-email-alexis.berlemont@gmail.com>
In-Reply-To: <1414101372-14443-1-git-send-email-alexis.berlemont@gmail.com>
References: <1414101372-14443-1-git-send-email-alexis.berlemont@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove NO_SLANG (replaced by CONFIG_LIBSLANG)
Remove HAVE_SLANG_SUPPORT from CFLAGS (replaced by CONFIG_LIBSLANG)
Remove NO_GTK2 (replaced by CONFIG_LIBGTK2 or CONFIG_GTK2)
Remove HAVE_GTK2_SUPPORT from CFLAGS (replaced by CONFIG_LIBGTK2)
Remove HAVE_GTK_INFO_BAR_SUPPORT from CFLAGS (replaced by
CONFIG_LIBGTK2_INFOBAR)

Signed-off-by: Alexis Berlemont <alexis.berlemont@gmail.com>
---
 tools/perf/Kconfig                    | 21 +++++++++++++++++++++
 tools/perf/config/Makefile            | 20 ++++++--------------
 tools/perf/config/Makefile.fix-config | 24 ------------------------
 tools/perf/config/Makefile.fix-legacy |  8 --------
 tools/perf/ui/gtk/browser.c           |  4 +++-
 tools/perf/ui/gtk/gtk.h               |  5 +++--
 tools/perf/ui/gtk/util.c              |  6 ++++--
 tools/perf/ui/setup.c                 |  4 +++-
 tools/perf/ui/ui.h                    |  4 +++-
 tools/perf/util/annotate.h            |  4 +++-
 tools/perf/util/hist.h                |  3 ++-
 11 files changed, 48 insertions(+), 55 deletions(-)

diff --git a/tools/perf/Kconfig b/tools/perf/Kconfig
index f9fcf9e..eb59567 100644
--- a/tools/perf/Kconfig
+++ b/tools/perf/Kconfig
@@ -171,6 +171,7 @@ config STDIO
 
 config TUI
 	bool "Tui (slang based)"
+	depends on LIBSLANG
 	default y
         ---help---
 	  Text-based user interface which provides windowing
@@ -179,6 +180,7 @@ config TUI
 config GTK2
 	bool "Gtk2"
 	default y
+	depends on LIBGTK2
         ---help---
 	  Elaborate display mode based on libgtk2.
 
@@ -186,12 +188,31 @@ endmenu
 
 menu "Libraries / Dependencies"
 
+config LIBSLANG
+	bool "Slang (libslang)"
+	default y
+        ---help---
+	  libslang
+
 config LIBAUDIT
 	bool "Audit (libaudit)"
 	default y
         ---help---
 	  Linux audit framework dependency.
 
+config LIBGTK2
+	bool "Gtk2 (libgtk2)"
+	default y
+        ---help---
+	  libgtk2
+
+config LIBGTK2_INFOBAR
+	bool "Gtk2 infobar (libgtk2)"
+	depends on LIBGTK2
+	default y
+        ---help---
+	  libgtk2-infobar
+
 config LIBPERL
 	bool "Perl"
 	default y
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 6106e24..27b092c 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -445,32 +445,26 @@ ifndef NO_LIBAUDIT
   endif
 endif
 
-ifdef NO_NEWT
-  NO_SLANG=1
-endif
-
-ifndef NO_SLANG
+ifdef CONFIG_LIBSLANG
   ifneq ($(feature-libslang), 1)
-    msg := $(warning slang not found, disables TUI support. Please install slang-devel or libslang-dev);
-    NO_SLANG := 1
+    msg := $(warning slang not found, disables SLANG and TUI supports. Please install slang-devel or libslang-dev);
+    $(shell $(KCONFIG_SCRIPT) -d CONFIG_LIBSLANG)
   else
     # Fedora has /usr/include/slang/slang.h, but ubuntu /usr/include/slang.h
     CFLAGS += -I/usr/include/slang
-    CFLAGS += -DHAVE_SLANG_SUPPORT
     EXTLIBS += -lslang
   endif
 endif
 
-ifndef NO_GTK2
+ifdef CONFIG_LIBGTK2
   FLAGS_GTK2=$(CFLAGS) $(LDFLAGS) $(EXTLIBS) $(shell $(PKG_CONFIG) --libs --cflags gtk+-2.0 2>/dev/null)
   ifneq ($(feature-gtk2), 1)
     msg := $(warning GTK2 not found, disables GTK2 support. Please install gtk2-devel or libgtk2.0-dev);
-    NO_GTK2 := 1
+    $(shell $(KCONFIG_SCRIPT) -d CONFIG_LIBGTK2)
   else
     ifeq ($(feature-gtk2-infobar), 1)
-      GTK_CFLAGS := -DHAVE_GTK_INFO_BAR_SUPPORT
+      $(shell $(KCONFIG_SCRIPT) -d CONFIG_LIBGTK2_INFOBAR)
     endif
-    CFLAGS += -DHAVE_GTK2_SUPPORT
     GTK_CFLAGS += $(shell $(PKG_CONFIG) --cflags gtk+-2.0 2>/dev/null)
     GTK_LIBS := $(shell $(PKG_CONFIG) --libs gtk+-2.0 2>/dev/null)
     EXTLIBS += -ldl
@@ -801,8 +795,6 @@ all:
 	$(call store,NO_LIBUNWIND)
 	$(call store,NO_LIBPERL)
 	$(call store,NO_LIBPYTHON)
-	$(call store,NO_NEWT)
-	$(call store,NO_GTK2)
 	$(call store,NO_DEMANGLE)
 	$(call store,NO_LIBELF)
 	$(call store,NO_LIBUNWIND)
diff --git a/tools/perf/config/Makefile.fix-config b/tools/perf/config/Makefile.fix-config
index 7f65fdb..3d84008 100644
--- a/tools/perf/config/Makefile.fix-config
+++ b/tools/perf/config/Makefile.fix-config
@@ -19,30 +19,6 @@ dummy := $(shell $(CONFIG) -d CONFIG_LIBPYTHON)
 endif
 endif
 
-# NO_NEWT
-ifdef CONFIG_TUI
-ifdef NO_NEWT
-dummy := $(info Disabling CONFIG_TUI)
-dummy := $(shell $(CONFIG) -d CONFIG_TUI)
-endif
-endif
-
-# NO_NEWT
-ifdef CONFIG_TUI
-ifdef NO_SLANG
-dummy := $(info Disabling CONFIG_TUI)
-dummy := $(shell $(CONFIG) -d CONFIG_TUI)
-endif
-endif
-
-# NO_GTK2
-ifdef CONFIG_GTK2
-ifdef NO_GTK2
-dummy := $(info Disabling CONFIG_GTK2)
-dummy := $(shell $(CONFIG) -d CONFIG_GTK2)
-endif
-endif
-
 # NO_DEMANGLE
 ifdef CONFIG_DEMANGLE
 ifdef NO_DEMANGLE
diff --git a/tools/perf/config/Makefile.fix-legacy b/tools/perf/config/Makefile.fix-legacy
index 2ec91f3..ca219e7 100644
--- a/tools/perf/config/Makefile.fix-legacy
+++ b/tools/perf/config/Makefile.fix-legacy
@@ -9,14 +9,6 @@ ifndef CONFIG_LIBPYTHON
 NO_LIBPYTHON := 1
 endif
 
-ifndef CONFIG_TUI
-NO_SLANG := 1
-endif
-
-ifndef CONFIG_GTK2
-NO_GTK2 := 1
-endif
-
 ifndef CONFIG_DEMANGLE
 NO_DEMANGLE := 1
 endif
diff --git a/tools/perf/ui/gtk/browser.c b/tools/perf/ui/gtk/browser.c
index c24d912..f4df6a6 100644
--- a/tools/perf/ui/gtk/browser.c
+++ b/tools/perf/ui/gtk/browser.c
@@ -1,3 +1,5 @@
+#include "generated/autoconf.h"
+
 #include "../evlist.h"
 #include "../cache.h"
 #include "../evsel.h"
@@ -43,7 +45,7 @@ const char *perf_gtk__get_percent_color(double percent)
 	return NULL;
 }
 
-#ifdef HAVE_GTK_INFO_BAR_SUPPORT
+#ifdef CONFIG_LIBGTK2_INFOBAR
 GtkWidget *perf_gtk__setup_info_bar(void)
 {
 	GtkWidget *info_bar;
diff --git a/tools/perf/ui/gtk/gtk.h b/tools/perf/ui/gtk/gtk.h
index 0a9173f..3762980 100644
--- a/tools/perf/ui/gtk/gtk.h
+++ b/tools/perf/ui/gtk/gtk.h
@@ -7,12 +7,13 @@
 #include <gtk/gtk.h>
 #pragma GCC diagnostic error "-Wstrict-prototypes"
 
+#include "generated/autoconf.h"
 
 struct perf_gtk_context {
 	GtkWidget *main_window;
 	GtkWidget *notebook;
 
-#ifdef HAVE_GTK_INFO_BAR_SUPPORT
+#ifdef CONFIG_LIBGTK2_INFOBAR
 	GtkWidget *info_bar;
 	GtkWidget *message_label;
 #endif
@@ -42,7 +43,7 @@ void perf_gtk__resize_window(GtkWidget *window);
 const char *perf_gtk__get_percent_color(double percent);
 GtkWidget *perf_gtk__setup_statusbar(void);
 
-#ifdef HAVE_GTK_INFO_BAR_SUPPORT
+#ifdef CONFIG_LIBGTK2_INFOBAR
 GtkWidget *perf_gtk__setup_info_bar(void);
 #else
 static inline GtkWidget *perf_gtk__setup_info_bar(void)
diff --git a/tools/perf/ui/gtk/util.c b/tools/perf/ui/gtk/util.c
index 52e7fc4..dde1615 100644
--- a/tools/perf/ui/gtk/util.c
+++ b/tools/perf/ui/gtk/util.c
@@ -1,3 +1,5 @@
+#include "generated/autoconf.h"
+
 #include "../util.h"
 #include "../../util/debug.h"
 #include "gtk.h"
@@ -52,7 +54,7 @@ static int perf_gtk__error(const char *format, va_list args)
 	return 0;
 }
 
-#ifdef HAVE_GTK_INFO_BAR_SUPPORT
+#ifdef CONFIG_LIBGTK2_INFOBAR
 static int perf_gtk__warning_info_bar(const char *format, va_list args)
 {
 	char *msg;
@@ -104,7 +106,7 @@ static int perf_gtk__warning_statusbar(const char *format, va_list args)
 
 struct perf_error_ops perf_gtk_eops = {
 	.error		= perf_gtk__error,
-#ifdef HAVE_GTK_INFO_BAR_SUPPORT
+#ifdef CONFIG_LIBGTK2_INFOBAR
 	.warning	= perf_gtk__warning_info_bar,
 #else
 	.warning	= perf_gtk__warning_statusbar,
diff --git a/tools/perf/ui/setup.c b/tools/perf/ui/setup.c
index 7928984..0acaf1b 100644
--- a/tools/perf/ui/setup.c
+++ b/tools/perf/ui/setup.c
@@ -1,6 +1,8 @@
 #include <pthread.h>
 #include <dlfcn.h>
 
+#include "generated/autoconf.h"
+
 #include "../util/cache.h"
 #include "../util/debug.h"
 #include "../util/hist.h"
@@ -8,7 +10,7 @@
 pthread_mutex_t ui__lock = PTHREAD_MUTEX_INITIALIZER;
 void *perf_gtk_handle;
 
-#ifdef HAVE_GTK2_SUPPORT
+#ifdef CONFIG_GTK2
 static int setup_gtk_browser(void)
 {
 	int (*perf_ui_init)(void);
diff --git a/tools/perf/ui/ui.h b/tools/perf/ui/ui.h
index ab88383..bba3a0e 100644
--- a/tools/perf/ui/ui.h
+++ b/tools/perf/ui/ui.h
@@ -5,6 +5,8 @@
 #include <stdbool.h>
 #include <linux/compiler.h>
 
+#include "generated/autoconf.h"
+
 extern pthread_mutex_t ui__lock;
 extern void *perf_gtk_handle;
 
@@ -13,7 +15,7 @@ extern int use_browser;
 void setup_browser(bool fallback_to_pager);
 void exit_browser(bool wait_for_ok);
 
-#ifdef HAVE_SLANG_SUPPORT
+#ifdef CONFIG_LIBSLANG
 int ui__init(void);
 void ui__exit(bool wait_for_ok);
 #else
diff --git a/tools/perf/util/annotate.h b/tools/perf/util/annotate.h
index 112d6e2..692f46c 100644
--- a/tools/perf/util/annotate.h
+++ b/tools/perf/util/annotate.h
@@ -11,6 +11,8 @@
 #include <linux/rbtree.h>
 #include <pthread.h>
 
+#include "generated/autoconf.h"
+
 struct ins;
 
 struct ins_operands {
@@ -157,7 +159,7 @@ int symbol__tty_annotate(struct symbol *sym, struct map *map,
 			 struct perf_evsel *evsel, bool print_lines,
 			 bool full_paths, int min_pcnt, int max_lines);
 
-#ifdef HAVE_SLANG_SUPPORT
+#ifdef CONFIG_LIBSLANG
 int symbol__tui_annotate(struct symbol *sym, struct map *map,
 			 struct perf_evsel *evsel,
 			 struct hist_browser_timer *hbt);
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index d0ef9a1..622597d 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -3,6 +3,7 @@
 
 #include <linux/types.h>
 #include <pthread.h>
+#include "generated/autoconf.h"
 #include "callchain.h"
 #include "evsel.h"
 #include "header.h"
@@ -298,7 +299,7 @@ struct hist_browser_timer {
 	int refresh;
 };
 
-#ifdef HAVE_SLANG_SUPPORT
+#ifdef CONFIG_LIBSLANG
 #include "../ui/keysyms.h"
 int hist_entry__tui_annotate(struct hist_entry *he, struct perf_evsel *evsel,
 			     struct hist_browser_timer *hbt);
-- 
2.1.1

