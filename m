Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965258AbaFCWJF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 18:09:05 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:48062 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965208AbaFCWI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 18:08:58 -0400
From: Alexis Berlemont <alexis.berlemont@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Alexis Berlemont <alexis.berlemont@gmail.com>, jolsa@redhat.com,
        dsahern@gmail.com, mingo@kernel.org, sam@ravnborg.org, mmarek@suse.cz
Subject: [PATCH 16/32] perf kbuild: remove legacy demangle-related build variables
Date: Wed,  4 Jun 2014 00:06:09 +0200
Message-Id: <1401833185-10347-17-git-send-email-alexis.berlemont@gmail.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1401833185-10347-1-git-send-email-alexis.berlemont@gmail.com>
References: <1401833185-10347-1-git-send-email-alexis.berlemont@gmail.com>
In-Reply-To: <CAMesUR5h0687dTFCDC3LhKSOFyKTFmH3vUjU+p6XuOpawPUwxQ@mail.gmail.com>
References: <CAMesUR5h0687dTFCDC3LhKSOFyKTFmH3vUjU+p6XuOpawPUwxQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove NO_DEMANGLE (replaced by CONFIG_DEMANGLE)
Remove HAVE_LIBBFD_SUPPORT (replaced by CONFIG_LIBBFD)
Remove HAVE_CPLUS_DEMANGLE_SUPPORT (replaced by CONFIG_LIBIBERTY_ONLY)
---
 tools/perf/Kconfig         | 30 +++++++++++++++++++++++-------
 tools/perf/config/Makefile | 45 ++++++++++++++++++++++++---------------------
 tools/perf/util/srcline.c  |  8 +++++---
 tools/perf/util/symbol.h   | 25 +++++++++++++++++--------
 4 files changed, 69 insertions(+), 39 deletions(-)

diff --git a/tools/perf/Kconfig b/tools/perf/Kconfig
index 9b75649..762c50e 100644
--- a/tools/perf/Kconfig
+++ b/tools/perf/Kconfig
@@ -196,6 +196,29 @@ config TIMERFD
         ---help---
 	  Timer via file descriptor
 
+config DEMANGLE
+	bool "Demangle symbols"
+	default n
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
@@ -236,13 +259,6 @@ config NUMA
 	  The library libnuma offers facilities to configure NUMA
 	  policies supported by the linux kernel.
 
-config DEMANGLE
-	bool "Demangle symbols"
-	default n
-        ---help---
-	  Enable demangling so as to display human-readable
-	  symbols. This option is convenient with C++ programs.
-
 config BIONIC
 	bool "Bionic support"
 	default n
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 33843b7..ff7f01c 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -534,33 +534,36 @@ ifeq ($(feature-libbfd), 1)
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
 
 ifndef NO_ON_EXIT
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
index 501e4e7..d8e886e 100644
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
@@ -21,26 +23,33 @@
 
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
1.9.3

