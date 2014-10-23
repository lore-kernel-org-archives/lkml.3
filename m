Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754440AbaJWWAO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 18:00:14 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:44285 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753316AbaJWV7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 17:59:15 -0400
From: Alexis Berlemont <alexis.berlemont@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Alexis Berlemont <alexis.berlemont@gmail.com>, jolsa@redhat.com
Subject: [PATCH v2 10/14] perf kbuild: remove legacy libelf-related build variables
Date: Thu, 23 Oct 2014 23:56:08 +0200
Message-Id: <1414101372-14443-11-git-send-email-alexis.berlemont@gmail.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1414101372-14443-1-git-send-email-alexis.berlemont@gmail.com>
References: <1414101372-14443-1-git-send-email-alexis.berlemont@gmail.com>
In-Reply-To: <54216F39.9030902@suse.cz>
References: <54216F39.9030902@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove NO_LIBELF (replaced by CONFIG_LIBELF)
Remove HAVE_LIBELF_SUPPORT (replaced by CONFIG_LIBELF)
Remove HAVE_LIBELF_MMAP_SUPPORT (replaced by CONFIG_LIBELF_MMAP)
Remove HAVE_LIBELF_GETPHDRNUM__SUPPORT (replaced by
CONFIG_LIBELF_GETPHDRNUM_)

Signed-off-by: Alexis Berlemont <alexis.berlemont@gmail.com>
---
 tools/perf/Kconfig                    | 23 ++++++++++++++++++++++
 tools/perf/builtin-inject.c           |  2 +-
 tools/perf/config/Makefile            | 37 +++++++++++++++--------------------
 tools/perf/config/Makefile.fix-config | 18 -----------------
 tools/perf/config/Makefile.fix-legacy |  4 ----
 tools/perf/perf.c                     |  2 +-
 tools/perf/util/generate-cmdlist.sh   |  4 ++--
 tools/perf/util/map.c                 |  3 ++-
 tools/perf/util/symbol-elf.c          |  3 ++-
 tools/perf/util/symbol.h              |  8 ++++----
 10 files changed, 51 insertions(+), 53 deletions(-)

diff --git a/tools/perf/Kconfig b/tools/perf/Kconfig
index 29853a6..2eaf3ca 100644
--- a/tools/perf/Kconfig
+++ b/tools/perf/Kconfig
@@ -256,6 +256,7 @@ config TIMERFD
 	  Timer via file descriptor
 
 config DEMANGLE
+       depends on LIBELF
 	bool "Demangle symbols"
 	default y
         ---help---
@@ -298,7 +299,29 @@ choice
 	  Builtin elf support.
 endchoice
 
+config LIBELF_MMAP
+        depends on LIBELF
+	bool "Libelf mmap support"
+	default y
+        ---help---
+	  libdelf mmap
+
+config LIBELF_GETPHDRNUM
+        depends on LIBELF
+	default y
+	bool "Libelf getphdrnum support"
+        ---help---
+	  libdelf mmap
+
+config LIBDWARF
+	depends on LIBELF
+	bool "Dwarf (libdwarf)"
+	default y
+        ---help---
+	  libdwarf
+
 config LIBUNWIND
+        depends on LIBELF
 	bool "User space libunwind callchains"
 	default y
         ---help---
diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index de99ca1..9d59c7f 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -230,7 +230,7 @@ static int perf_event__inject_buildid(struct perf_tool *tool,
 				 * account this as unresolved.
 				 */
 			} else {
-#ifdef HAVE_LIBELF_SUPPORT
+#ifdef CONFIG_LIBELF
 				pr_warning("no symbols found in %s, maybe "
 					   "install a debug package?\n",
 					   al.map->dso->long_name);
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 5be574c3..79fe047 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -303,12 +303,7 @@ ifdef CONFIG_BIONIC
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
@@ -318,12 +313,9 @@ else
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
+      $(shell $(KCONFIG_SCRIPT) -e CONFIG_LIBELF_MINIMAL)
+      EXTLIBS := $(filter-out -lelf,$(EXTLIBS))
     else
       ifneq ($(filter s% -static%,$(LDFLAGS),),)
         msg := $(error No static glibc found, please install glibc-static);
@@ -332,6 +324,7 @@ else
       endif
     endif
   else
+    LIBELF = 1
     ifndef NO_LIBDW_DWARF_UNWIND
       ifneq ($(feature-libdw-dwarf-unwind),1)
         NO_LIBDW_DWARF_UNWIND := 1
@@ -343,17 +336,20 @@ else
       NO_DWARF := 1
     endif # Dwarf support
   endif # libelf support
-endif # NO_LIBELF
+endif # CONFIG_LIBELF
 
-ifndef NO_LIBELF
-  CFLAGS += -DHAVE_LIBELF_SUPPORT
+ifeq ($(LIBELF), 1)
 
-  ifeq ($(feature-libelf-mmap), 1)
-    CFLAGS += -DHAVE_LIBELF_MMAP_SUPPORT
+  ifdef CONFIG_LIBELF_MMAP
+    ifneq ($(feature-libelf-mmap), 1)
+      $(shell $(KCONFIG_SCRIPT) -d CONFIG_LIBELF_MMAP)
+    endif
   endif
 
-  ifeq ($(feature-libelf-getphdrnum), 1)
-    CFLAGS += -DHAVE_ELF_GETPHDRNUM_SUPPORT
+  ifdef CONFIG_LIBELF_MMAP
+    ifneq ($(feature-libelf-getphdrnum), 1)
+      $(shell $(KCONFIG_SCRIPT) -d CONFIG_LIBELF_MMAP)
+    endif
   endif
 
   # include ARCH specific config
@@ -369,7 +365,7 @@ ifndef NO_LIBELF
       EXTLIBS += -lelf -ldw
     endif # PERF_HAVE_DWARF_REGS
   endif # NO_DWARF
-endif # NO_LIBELF
+endif # LIBELF
 
 ifeq ($(ARCH),powerpc)
   ifndef NO_DWARF
@@ -787,7 +783,6 @@ all:
 	$(call store,NO_LIBUNWIND)
 	$(call store,NO_LIBPERL)
 	$(call store,NO_LIBPYTHON)
-	$(call store,NO_LIBELF)
 	$(call store,NO_LIBUNWIND)
 	$(call store,NO_LIBBIONIC)
 	$(call store,ETC_PERFCONFIG_SQ)
diff --git a/tools/perf/config/Makefile.fix-config b/tools/perf/config/Makefile.fix-config
index 2ba684b..99948b7 100644
--- a/tools/perf/config/Makefile.fix-config
+++ b/tools/perf/config/Makefile.fix-config
@@ -19,24 +19,6 @@ dummy := $(shell $(CONFIG) -d CONFIG_LIBPYTHON)
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
index 8e32b74..8568d37 100644
--- a/tools/perf/config/Makefile.fix-legacy
+++ b/tools/perf/config/Makefile.fix-legacy
@@ -9,10 +9,6 @@ ifndef CONFIG_LIBPYTHON
 NO_LIBPYTHON := 1
 endif
 
-ifndef CONFIG_LIBELF
-NO_LIBELF := 1
-endif
-
 ifndef CONFIG_LIBUNWIND
 NO_LIBUNWIND := 1
 endif
diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index 976ded6..b4fd910 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -81,7 +81,7 @@ static struct cmd_struct commands[] = {
 #ifdef CONFIG_BUILTIN_SCHED
 	{ "sched",	cmd_sched,	0 },
 #endif
-#if defined HAVE_LIBELF_SUPPORT && defined CONFIG_BUILTIN_PROBE
+#if defined CONFIG_LIBELF && defined CONFIG_BUILTIN_PROBE
 	{ "probe",	cmd_probe,	0 },
 #endif
 #ifdef CONFIG_BUILTIN_KMEM
diff --git a/tools/perf/util/generate-cmdlist.sh b/tools/perf/util/generate-cmdlist.sh
index 5d84ffc..a8dbdc2 100755
--- a/tools/perf/util/generate-cmdlist.sh
+++ b/tools/perf/util/generate-cmdlist.sh
@@ -30,7 +30,7 @@ do
      echo "#endif"
 done
 
-echo "#ifdef HAVE_LIBELF_SUPPORT"
+echo "#ifdef CONFIG_LIBELF"
 sed -n -e 's/^perf-\([^ 	]*\)[ 	].* full.*/\1/p' $1/command-list.txt |
 sort |
 while read cmd
@@ -45,5 +45,5 @@ do
      }' "$1/Documentation/perf-$cmd.txt"
      echo "#endif"
 done
-echo "#endif /* HAVE_LIBELF_SUPPORT */"
+echo "#endif /* CONFIG_LIBELF */"
 echo "};"
diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index 2137c45..4164fca 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -1,3 +1,4 @@
+#include "generated/autoconf.h"
 #include "symbol.h"
 #include <errno.h>
 #include <inttypes.h>
@@ -272,7 +273,7 @@ int map__load(struct map *map, symbol_filter_t filter)
 		pr_warning(", continuing without symbols\n");
 		return -1;
 	} else if (nr == 0) {
-#ifdef HAVE_LIBELF_SUPPORT
+#ifdef CONFIG_LIBELF
 		const size_t len = strlen(name);
 		const size_t real_len = len - sizeof(DSO__DELETED);
 
diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
index 1e23a5b..db340ab 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -5,13 +5,14 @@
 #include <unistd.h>
 #include <inttypes.h>
 
+#include "generated/autoconf.h"
 #include "symbol.h"
 #include "machine.h"
 #include "vdso.h"
 #include <symbol/kallsyms.h>
 #include "debug.h"
 
-#ifndef HAVE_ELF_GETPHDRNUM_SUPPORT
+#ifndef CONFIG_LIBELF_GETPHDRNUM
 static int elf_getphdrnum(Elf *elf, size_t *dst)
 {
 	GElf_Ehdr gehdr;
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 7e3a003..53bf6df 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -17,7 +17,7 @@
 #include "event.h"
 #include "util.h"
 
-#ifdef HAVE_LIBELF_SUPPORT
+#ifdef CONFIG_LIBELF
 #include <libelf.h>
 #include <gelf.h>
 #endif
@@ -57,13 +57,13 @@ static inline char *bfd_demangle(void __maybe_unused *v,
  * libelf 0.8.x and earlier do not support ELF_C_READ_MMAP;
  * for newer versions we can use mmap to reduce memory usage:
  */
-#ifdef HAVE_LIBELF_MMAP_SUPPORT
+#ifdef CONFIG_LIBELF_MMAP
 # define PERF_ELF_C_READ_MMAP ELF_C_READ_MMAP
 #else
 # define PERF_ELF_C_READ_MMAP ELF_C_READ
 #endif
 
-#ifdef HAVE_LIBELF_SUPPORT
+#ifdef CONFIG_LIBELF
 extern Elf_Scn *elf_section_by_name(Elf *elf, GElf_Ehdr *ep,
 				GElf_Shdr *shp, const char *name, size_t *idx);
 #endif
@@ -220,7 +220,7 @@ struct symsrc {
 	int fd;
 	enum dso_binary_type type;
 
-#ifdef HAVE_LIBELF_SUPPORT
+#ifdef CONFIG_LIBELF
 	Elf *elf;
 	GElf_Ehdr ehdr;
 
-- 
2.1.1

