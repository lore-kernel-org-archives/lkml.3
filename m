Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965285AbaFCWJK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 18:09:10 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:35132 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965249AbaFCWJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 18:09:05 -0400
From: Alexis Berlemont <alexis.berlemont@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Alexis Berlemont <alexis.berlemont@gmail.com>, jolsa@redhat.com,
        dsahern@gmail.com, mingo@kernel.org, sam@ravnborg.org, mmarek@suse.cz
Subject: [PATCH 21/32] perf kbuild: remove legacy libelf-related build variables (1st part)
Date: Wed,  4 Jun 2014 00:06:14 +0200
Message-Id: <1401833185-10347-22-git-send-email-alexis.berlemont@gmail.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1401833185-10347-1-git-send-email-alexis.berlemont@gmail.com>
References: <1401833185-10347-1-git-send-email-alexis.berlemont@gmail.com>
In-Reply-To: <CAMesUR5h0687dTFCDC3LhKSOFyKTFmH3vUjU+p6XuOpawPUwxQ@mail.gmail.com>
References: <CAMesUR5h0687dTFCDC3LhKSOFyKTFmH3vUjU+p6XuOpawPUwxQ@mail.gmail.com>
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
index 9bc55fc..196d32c 100644
--- a/tools/perf/Kconfig
+++ b/tools/perf/Kconfig
@@ -203,6 +203,7 @@ config ON_EXIT
 	  On exit support
 
 config DEMANGLE
+       depends on LIBELF
 	bool "Demangle symbols"
 	default n
         ---help---
@@ -245,7 +246,14 @@ choice
 	  Builtin elf support.
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
 	  The library libunwind provides a portable C API to determine
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
1.9.3

