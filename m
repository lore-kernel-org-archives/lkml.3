Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257AbaFCWJB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 18:09:01 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:49950 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965146AbaFCWIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 18:08:53 -0400
From: Alexis Berlemont <alexis.berlemont@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Alexis Berlemont <alexis.berlemont@gmail.com>, jolsa@redhat.com,
        dsahern@gmail.com, mingo@kernel.org, sam@ravnborg.org, mmarek@suse.cz
Subject: [PATCH 11/32] perf kbuild: remove legacy slang-related build variables
Date: Wed,  4 Jun 2014 00:06:04 +0200
Message-Id: <1401833185-10347-12-git-send-email-alexis.berlemont@gmail.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1401833185-10347-1-git-send-email-alexis.berlemont@gmail.com>
References: <1401833185-10347-1-git-send-email-alexis.berlemont@gmail.com>
In-Reply-To: <CAMesUR5h0687dTFCDC3LhKSOFyKTFmH3vUjU+p6XuOpawPUwxQ@mail.gmail.com>
References: <CAMesUR5h0687dTFCDC3LhKSOFyKTFmH3vUjU+p6XuOpawPUwxQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove NO_SLANG (replaced by CONFIG_LIBSLANG)
Remove HAVE_SLANG_SUPPORT from CFLAGS (replaced by CONFIG_LIBSLANG)
---
 tools/perf/Kconfig                    | 11 +++++++++--
 tools/perf/config/Makefile            | 12 +++---------
 tools/perf/config/Makefile.fix-config | 16 ----------------
 tools/perf/config/Makefile.fix-legacy |  4 ----
 tools/perf/ui/ui.h                    |  4 +++-
 tools/perf/util/annotate.h            |  4 +++-
 tools/perf/util/hist.h                |  4 +++-
 7 files changed, 21 insertions(+), 34 deletions(-)

diff --git a/tools/perf/Kconfig b/tools/perf/Kconfig
index 108b422..5f5d1f7 100644
--- a/tools/perf/Kconfig
+++ b/tools/perf/Kconfig
@@ -32,7 +32,7 @@ config BUILTIN_TOP
 config BUILTIN_TRACE
 	bool "trace"
 	default n
-	depends on CONFIG_LIBAUDIT
+	depends on LIBAUDIT
         ---help---
 	  Strace inspired tool.
 
@@ -153,6 +153,12 @@ endmenu
 
 menu "Libraries"
 
+config LIBSLANG
+	bool "Slang (libslang)"
+	default n
+        ---help---
+	  libslang
+
 config LIBAUDIT
 	bool "Audit (libaudit)"
 	default n
@@ -237,7 +243,8 @@ config STDIO
 	  Most basic display mode.
 
 config TUI
-	bool "Tui (newt based)"
+	bool "Tui (slang based)"
+	depends on LIBSLANG
 	default n
         ---help---
 	  Text-based user interface which provides windowing
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index e10e8bf..fa07862 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -402,18 +402,13 @@ ifndef NO_LIBAUDIT
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
@@ -762,7 +757,6 @@ all:
 	$(call store,NO_LIBUNWIND)
 	$(call store,NO_LIBPERL)
 	$(call store,NO_LIBPYTHON)
-	$(call store,NO_NEWT)
 	$(call store,NO_GTK2)
 	$(call store,NO_DEMANGLE)
 	$(call store,NO_LIBELF)
diff --git a/tools/perf/config/Makefile.fix-config b/tools/perf/config/Makefile.fix-config
index 7f65fdb..a8e5539 100644
--- a/tools/perf/config/Makefile.fix-config
+++ b/tools/perf/config/Makefile.fix-config
@@ -19,22 +19,6 @@ dummy := $(shell $(CONFIG) -d CONFIG_LIBPYTHON)
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
 # NO_GTK2
 ifdef CONFIG_GTK2
 ifdef NO_GTK2
diff --git a/tools/perf/config/Makefile.fix-legacy b/tools/perf/config/Makefile.fix-legacy
index 2ec91f3..18acc92 100644
--- a/tools/perf/config/Makefile.fix-legacy
+++ b/tools/perf/config/Makefile.fix-legacy
@@ -9,10 +9,6 @@ ifndef CONFIG_LIBPYTHON
 NO_LIBPYTHON := 1
 endif
 
-ifndef CONFIG_TUI
-NO_SLANG := 1
-endif
-
 ifndef CONFIG_GTK2
 NO_GTK2 := 1
 endif
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
index 56ad4f5..50aff7c 100644
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
index 1f1f513..0daa3a5 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -8,6 +8,8 @@
 #include "color.h"
 #include "ui/progress.h"
 
+#include "generated/autoconf.h"
+
 extern struct callchain_param callchain_param;
 
 struct hist_entry;
@@ -211,7 +213,7 @@ struct hist_browser_timer {
 	int refresh;
 };
 
-#ifdef HAVE_SLANG_SUPPORT
+#ifdef CONFIG_LIBSLANG
 #include "../ui/keysyms.h"
 int hist_entry__tui_annotate(struct hist_entry *he, struct perf_evsel *evsel,
 			     struct hist_browser_timer *hbt);
-- 
1.9.3

