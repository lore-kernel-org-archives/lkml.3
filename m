Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965644AbaFCWO6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 18:14:58 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:51449 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965114AbaFCWIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 18:08:54 -0400
From: Alexis Berlemont <alexis.berlemont@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Alexis Berlemont <alexis.berlemont@gmail.com>, jolsa@redhat.com,
        dsahern@gmail.com, mingo@kernel.org, sam@ravnborg.org, mmarek@suse.cz
Subject: [PATCH 13/32] perf kbuild: remove legacy libgtk2-related build variables
Date: Wed,  4 Jun 2014 00:06:06 +0200
Message-Id: <1401833185-10347-14-git-send-email-alexis.berlemont@gmail.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1401833185-10347-1-git-send-email-alexis.berlemont@gmail.com>
References: <1401833185-10347-1-git-send-email-alexis.berlemont@gmail.com>
In-Reply-To: <CAMesUR5h0687dTFCDC3LhKSOFyKTFmH3vUjU+p6XuOpawPUwxQ@mail.gmail.com>
References: <CAMesUR5h0687dTFCDC3LhKSOFyKTFmH3vUjU+p6XuOpawPUwxQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove NO_GTK2 (replaced by CONFIG_LIBGTK2 or CONFIG_GTK2)
Remove HAVE_GTK2_SUPPORT from CFLAGS (replaced by CONFIG_LIBGTK2)
Remove HAVE_GTK_INFO_BAR_SUPPORT from CFLAGS (replaced by
CONFIG_LIBGTK2_INFOBAR)
---
 tools/perf/Kconfig                    | 13 +++++++++++++
 tools/perf/config/Makefile            |  8 +++-----
 tools/perf/config/Makefile.fix-config |  8 --------
 tools/perf/config/Makefile.fix-legacy |  4 ----
 tools/perf/ui/gtk/browser.c           |  4 +++-
 tools/perf/ui/gtk/gtk.h               |  5 +++--
 tools/perf/ui/gtk/util.c              |  6 ++++--
 tools/perf/ui/setup.c                 |  4 +++-
 8 files changed, 29 insertions(+), 23 deletions(-)

diff --git a/tools/perf/Kconfig b/tools/perf/Kconfig
index 5f5d1f7..5ca0527 100644
--- a/tools/perf/Kconfig
+++ b/tools/perf/Kconfig
@@ -165,6 +165,19 @@ config LIBAUDIT
         ---help---
 	  Linux audit framework dependency.
 
+config LIBGTK2
+	bool "Gtk2 (libgtk2)"
+	default n
+        ---help---
+	  libgtk2
+
+config LIBGTK2_INFOBAR
+	bool "Gtk2 infobar (libgtk2)"
+	depends on LIBGTK2
+	default n
+        ---help---
+	  libgtk2-infobar
+
 config LIBPERL
 	bool "Perl"
 	default n
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 96bb232..040cdcc 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -412,16 +412,15 @@ ifdef CONFIG_LIBSLANG
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
@@ -756,7 +755,6 @@ all:
 	$(call store,NO_LIBUNWIND)
 	$(call store,NO_LIBPERL)
 	$(call store,NO_LIBPYTHON)
-	$(call store,NO_GTK2)
 	$(call store,NO_DEMANGLE)
 	$(call store,NO_LIBELF)
 	$(call store,NO_LIBUNWIND)
diff --git a/tools/perf/config/Makefile.fix-config b/tools/perf/config/Makefile.fix-config
index 77f9840..efe2ee7 100644
--- a/tools/perf/config/Makefile.fix-config
+++ b/tools/perf/config/Makefile.fix-config
@@ -19,14 +19,6 @@ dummy := $(shell $(CONFIG) -d CONFIG_LIBPYTHON)
 endif
 endif
 
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
index ab72582..ae69a1b 100644
--- a/tools/perf/config/Makefile.fix-legacy
+++ b/tools/perf/config/Makefile.fix-legacy
@@ -9,10 +9,6 @@ ifndef CONFIG_LIBPYTHON
 NO_LIBPYTHON := 1
 endif
 
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
index cb69740..8bb51d2 100644
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
-- 
1.9.3

