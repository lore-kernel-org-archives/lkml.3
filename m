Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779AbaJWWBS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 18:01:18 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:65307 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752963AbaJWV7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 17:59:09 -0400
From: Alexis Berlemont <alexis.berlemont@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Alexis Berlemont <alexis.berlemont@gmail.com>, jolsa@redhat.com
Subject: [PATCH v2 07/14] perf kbuild: remove legacy demangle-related build variables
Date: Thu, 23 Oct 2014 23:56:05 +0200
Message-Id: <1414101372-14443-8-git-send-email-alexis.berlemont@gmail.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1414101372-14443-1-git-send-email-alexis.berlemont@gmail.com>
References: <1414101372-14443-1-git-send-email-alexis.berlemont@gmail.com>
In-Reply-To: <54216F39.9030902@suse.cz>
References: <54216F39.9030902@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove NO_DEMANGLE (replaced by CONFIG_DEMANGLE)
Remove HAVE_LIBBFD_SUPPORT (replaced by CONFIG_LIBBFD)
Remove HAVE_CPLUS_DEMANGLE_SUPPORT (replaced by CONFIG_LIBIBERTY_ONLY)

Signed-off-by: Alexis Berlemont <alexis.berlemont@gmail.com>
---
 tools/perf/Kconfig                    | 36 +++++++++++++++++++++------
 tools/perf/config/Makefile            | 46 ++++++++++++++++++-----------------
 tools/perf/config/Makefile.fix-legacy |  4 ---
 tools/perf/util/srcline.c             |  8 +++---
 tools/perf/util/symbol.h              | 25 +++++++++++++------
 5 files changed, 75 insertions(+), 44 deletions(-)

diff --git a/tools/perf/Kconfig b/tools/perf/Kconfig
index eb59567..026ef67 100644
--- a/tools/perf/Kconfig
+++ b/tools/perf/Kconfig
@@ -225,6 +225,35 @@ config LIBPYTHON
         ---help---
 	  Libpython dependency needed by the perf script feature.
 
+config TIMERFD
+	bool "Timer via file descriptor"
+	default y
+        ---help---
+	  Timer via file descriptor
+
+config DEMANGLE
+	bool "Demangle symbols"
+	default y
+        ---help---
+	  Enable demangling so as to display human-readable
+	  symbols. This option is convenient with C++ programs.
+
+choice DEMANGLE_DEPS
+       prompt "Demangle dependency(ies)"
+       depends on DEMANGLE
+       default LIBBFD
+
+config LIBBFD
+	bool "BFD + libiberty libraries"
+        ---help---
+	  Binary File Descriptor and libiberty libraries
+
+config LIBIBERTY_ONLY
+	bool "Libiberty only"
+        ---help---
+	  Libiberty
+endchoice
+
 choice
 	prompt "Elf library"
 	default LIBELF
@@ -266,13 +295,6 @@ config NUMA
 	  The library libnuma offers facilities to configure NUMA
 	  policies supported by the linux kernel.
 
-config DEMANGLE
-	bool "Demangle symbols"
-	default y
-        ---help---
-	  Enable demangling so as to display human-readable
-	  symbols. This option is convenient with C++ programs.
-
 config BIONIC
 	bool "Bionic support"
 	default n
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 27b092c..ce3a726 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -573,33 +573,36 @@ ifeq ($(feature-libbfd), 1)
   endif
 endif
 
-ifdef NO_DEMANGLE
-  CFLAGS += -DNO_DEMANGLE
-else
-  ifdef HAVE_CPLUS_DEMANGLE_SUPPORT
-    EXTLIBS += -liberty
-    CFLAGS += -DHAVE_CPLUS_DEMANGLE_SUPPORT
-  else
-    ifneq ($(feature-libbfd), 1)
-      ifneq ($(feature-liberty), 1)
-        ifneq ($(feature-liberty-z), 1)
-          # we dont have neither HAVE_CPLUS_DEMANGLE_SUPPORT
-          # or any of 'bfd iberty z' trinity
-          ifeq ($(feature-cplus-demangle), 1)
-            EXTLIBS += -liberty
-            CFLAGS += -DHAVE_CPLUS_DEMANGLE_SUPPORT
-          else
-            msg := $(warning No bfd.h/libbfd found, install binutils-dev[el]/zlib-static to gain symbol demangling)
-            CFLAGS += -DNO_DEMANGLE
-          endif
+ifdef CONFIG_LIBBFD
+  ifneq ($(feature-libbfd), 1)
+    # TODO: there might be an issue here: feature-liberty and
+    # feature-liberty-z cannot be set; they can be set only if
+    # feature-libbfd is set
+    ifneq ($(feature-liberty), 1)
+      ifneq ($(feature-liberty-z), 1)
+        # we dont have neither HAVE_CPLUS_DEMANGLE_SUPPORT
+        # or any of 'bfd iberty z' trinity
+        ifeq ($(feature-cplus-demangle), 1)
+          EXTLIBS += -liberty
+          $(shell $(KCONFIG_SCRIPT) -d CONFIG_LIBBFD)
+          $(shell $(KCONFIG_SCRIPT) -e CONFIG_LIBIBERTY_ONLY)
+        else
+          msg := $(warning No bfd.h/libbfd found, install binutils-dev[el]/zlib-static to gain symbol demangling)
+          $(shell $(KCONFIG_SCRIPT) -d CONFIG_DEMANGLE)
         endif
       endif
     endif
   endif
 endif
 
-ifneq ($(filter -lbfd,$(EXTLIBS)),)
-  CFLAGS += -DHAVE_LIBBFD_SUPPORT
+ifdef CONFIG_LIBIBERTY_ONLY
+  $(call feature_check,cplus-demangle)
+  ifeq ($(feature-cplus-demangle), 1)
+    EXTLIBS += -liberty
+  else
+    msg := $(warning No libiberty found, install binutils-dev[el]/zlib-static to gain symbol demangling)
+    $(shell $(KCONFIG_SCRIPT) -d CONFIG_DEMANGLE)
+  endif
 endif
 
 ifndef NO_BACKTRACE
@@ -795,7 +798,6 @@ all:
 	$(call store,NO_LIBUNWIND)
 	$(call store,NO_LIBPERL)
 	$(call store,NO_LIBPYTHON)
-	$(call store,NO_DEMANGLE)
 	$(call store,NO_LIBELF)
 	$(call store,NO_LIBUNWIND)
 	$(call store,NO_BACKTRACE)
diff --git a/tools/perf/config/Makefile.fix-legacy b/tools/perf/config/Makefile.fix-legacy
index ca219e7..64dbb1a 100644
--- a/tools/perf/config/Makefile.fix-legacy
+++ b/tools/perf/config/Makefile.fix-legacy
@@ -9,10 +9,6 @@ ifndef CONFIG_LIBPYTHON
 NO_LIBPYTHON := 1
 endif
 
-ifndef CONFIG_DEMANGLE
-NO_DEMANGLE := 1
-endif
-
 ifndef CONFIG_LIBELF
 NO_LIBELF := 1
 endif
diff --git a/tools/perf/util/srcline.c b/tools/perf/util/srcline.c
index f3e4bc5..38df8f4 100644
--- a/tools/perf/util/srcline.c
+++ b/tools/perf/util/srcline.c
@@ -4,11 +4,13 @@
 
 #include <linux/kernel.h>
 
+#include "generated/autoconf.h"
+
 #include "util/dso.h"
 #include "util/util.h"
 #include "util/debug.h"
 
-#ifdef HAVE_LIBBFD_SUPPORT
+#ifdef CONFIG_LIBBFD
 
 /*
  * Implement addr2line using libbfd.
@@ -189,7 +191,7 @@ void dso__free_a2l(struct dso *dso)
 	dso->a2l = NULL;
 }
 
-#else /* HAVE_LIBBFD_SUPPORT */
+#else /* !CONFIG_LIBBFD */
 
 static int addr2line(const char *dso_name, unsigned long addr,
 		     char **file, unsigned int *line_nr,
@@ -242,7 +244,7 @@ void dso__free_a2l(struct dso *dso __maybe_unused)
 {
 }
 
-#endif /* HAVE_LIBBFD_SUPPORT */
+#endif /* CONFIG_LIBBFD */
 
 /*
  * Number of addr2line failures (without success) before disabling it for that
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index eb2c19b..7e3a003 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -1,6 +1,8 @@
 #ifndef __PERF_SYMBOL
 #define __PERF_SYMBOL 1
 
+#include "generated/autoconf.h"
+
 #include <linux/types.h>
 #include <stdbool.h>
 #include <stdint.h>
@@ -23,26 +25,33 @@
 
 #include "dso.h"
 
-#ifdef HAVE_CPLUS_DEMANGLE_SUPPORT
+#ifdef CONFIG_DEMANGLE
+
+#ifdef CONFIG_LIBBFD
+
+#define PACKAGE 'perf'
+#include <bfd.h>
+
+#elif defined(CONFIG_LIBIBERTY_ONLY)
 extern char *cplus_demangle(const char *, int);
 
 static inline char *bfd_demangle(void __maybe_unused *v, const char *c, int i)
 {
 	return cplus_demangle(c, i);
 }
-#else
-#ifdef NO_DEMANGLE
+
+#else /* Unknown dependency */
+#error "Inconsistent demangling configuration"
+#endif
+
+#else /* !CONFIG_DEMANGLE */
 static inline char *bfd_demangle(void __maybe_unused *v,
 				 const char __maybe_unused *c,
 				 int __maybe_unused i)
 {
 	return NULL;
 }
-#else
-#define PACKAGE 'perf'
-#include <bfd.h>
-#endif
-#endif
+#endif /* CONFIG_DEMANGLE */
 
 /*
  * libelf 0.8.x and earlier do not support ELF_C_READ_MMAP;
-- 
2.1.1

