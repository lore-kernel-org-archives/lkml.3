Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932483AbaEMWIR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 18:08:17 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:48289 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932198AbaEMWFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 18:05:42 -0400
From: Alexis Berlemont <alexis.berlemont@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Alexis Berlemont <alexis.berlemont@gmail.com>, jolsa@redhat.com,
        acme@ghostprotocols.net, dsahern@gmail.com, mingo@kernel.org
Subject: [PATCH 22/34] perf kbuild: remove legacy libelf-related build variables (1st part)
Date: Wed, 14 May 2014 00:03:17 +0200
Message-Id: <1400018609-20486-23-git-send-email-alexis.berlemont@gmail.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1400018609-20486-1-git-send-email-alexis.berlemont@gmail.com>
References: <1400018609-20486-1-git-send-email-alexis.berlemont@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove NO_LIBELF (replaced by CONFIG_LIBELF)
---
 tools/perf/Kconfig                    |  8 ++++++++
 tools/perf/config/Makefile            | 23 +++++++----------------
 tools/perf/config/Makefile.fix-config | 18 ------------------
 tools/perf/config/Makefile.fix-legacy |  4 ----
 4 files changed, 15 insertions(+), 38 deletions(-)

diff --git a/tools/perf/Kconfig b/tools/perf/Kconfig
index 2e285e5..909a737 100644
--- a/tools/perf/Kconfig
+++ b/tools/perf/Kconfig
@@ -197,6 +197,7 @@ config ON_EXIT
 	  On exit support
 
 config DEMANGLE
+       depends on LIBELF
 	bool "Demangle symbols"
 	default n
         ---help---
@@ -233,7 +234,14 @@ choice
 	  builtin elf support
 endchoice
 
+config LIBDWARF
+        depends on LIBELF
+	bool "Dwarf (libdwarf)"
+        ---help---
+	  libdwarf
+
 config LIBUNWIND
+        depends on LIBELF
 	bool "User space libunwind callchains"
         ---help---
 	  libunwind
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index f0f51cd..f280b80 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -281,12 +281,7 @@ ifdef CONFIG_BIONIC
   endif
 endif
 
-ifdef NO_LIBELF
-  NO_DWARF := 1
-  NO_DEMANGLE := 1
-  NO_LIBUNWIND := 1
-  NO_LIBDW_DWARF_UNWIND := 1
-else
+ifdef CONFIG_LIBELF
   ifeq ($(feature-libelf), 0)
     ifeq ($(feature-glibc), 1)
       LIBC_SUPPORT := 1
@@ -296,16 +291,13 @@ else
     endif
     ifeq ($(LIBC_SUPPORT),1)
       msg := $(warning No libelf found, disables 'probe' tool, please install elfutils-libelf-devel/libelf-dev);
-
-      NO_LIBELF := 1
-      NO_DWARF := 1
-      NO_DEMANGLE := 1
-      NO_LIBUNWIND := 1
-      NO_LIBDW_DWARF_UNWIND := 1
+      $(shell $(KCONFIG_SCRIPT) -d CONFIG_LIBELF)
+      $(shell $(KCONFIG_SCRIPT) -E CONFIG_LIBELF_MINIMAL)
     else
       msg := $(error No gnu/libc-version.h found, please install glibc-dev[el]/glibc-static);
     endif
   else
+    LIBELF = 1
     ifndef NO_LIBDW_DWARF_UNWIND
       ifneq ($(feature-libdw-dwarf-unwind),1)
         NO_LIBDW_DWARF_UNWIND := 1
@@ -317,9 +309,9 @@ else
       NO_DWARF := 1
     endif # Dwarf support
   endif # libelf support
-endif # NO_LIBELF
+endif # CONFIG_LIBELF
 
-ifndef NO_LIBELF
+ifeq ($(LIBELF), 1)
   CFLAGS += -DHAVE_LIBELF_SUPPORT
 
   ifeq ($(feature-libelf-mmap), 1)
@@ -343,7 +335,7 @@ ifndef NO_LIBELF
       EXTLIBS += -lelf -ldw
     endif # PERF_HAVE_DWARF_REGS
   endif # NO_DWARF
-endif # NO_LIBELF
+endif # LIBELF
 
 ifndef NO_LIBUNWIND
   ifneq ($(feature-libunwind), 1)
@@ -757,7 +749,6 @@ all:
 	$(call store,CONFIG_X86_64)
 	$(call store,NO_LIBUNWIND)
 	$(call store,NO_LIBPYTHON)
-	$(call store,NO_LIBELF)
 	$(call store,NO_LIBUNWIND)
 	$(call store,NO_LIBBIONIC)
 	$(call store,ETC_PERFCONFIG_SQ)
diff --git a/tools/perf/config/Makefile.fix-config b/tools/perf/config/Makefile.fix-config
index 5575a55..32a6701 100644
--- a/tools/perf/config/Makefile.fix-config
+++ b/tools/perf/config/Makefile.fix-config
@@ -11,24 +11,6 @@ dummy := $(shell $(CONFIG) -d CONFIG_LIBPYTHON)
 endif
 endif
 
-# NO_DEMANGLE
-ifdef CONFIG_DEMANGLE
-ifdef NO_DEMANGLE
-dummy := $(info Disabling CONFIG_DEMANGLE)
-dummy := $(shell $(CONFIG) -d CONFIG_DEMANGLE)
-endif
-endif
-
-# NO_LIBELF
-ifdef CONFIG_LIBELF
-ifdef NO_LIBELF
-dummy := $(info Disabling CONFIG_LIBELF)
-dummy := $(info Enabling  CONFIG_LIBELF_MINIMAL)
-dummy := $(shell $(CONFIG) -d CONFIG_LIBELF)
-dummy := $(shell $(CONFIG) -e CONFIG_LIBELF_MINIMAL)
-endif
-endif
-
 # NO_LIBUNWIND
 ifdef CONFIG_LIBUNWIND
 ifdef NO_LIBUNWIND
diff --git a/tools/perf/config/Makefile.fix-legacy b/tools/perf/config/Makefile.fix-legacy
index 00244f5..e3eab7c 100644
--- a/tools/perf/config/Makefile.fix-legacy
+++ b/tools/perf/config/Makefile.fix-legacy
@@ -5,10 +5,6 @@ ifndef CONFIG_LIBPYTHON
 NO_LIBPYTHON := 1
 endif
 
-ifndef CONFIG_LIBELF
-NO_LIBELF := 1
-endif
-
 ifndef CONFIG_LIBUNWIND
 NO_LIBUNWIND := 1
 endif
-- 
1.9.2

