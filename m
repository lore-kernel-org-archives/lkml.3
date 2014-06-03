Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965347AbaFCWJP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 18:09:15 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:45217 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965208AbaFCWJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 18:09:06 -0400
From: Alexis Berlemont <alexis.berlemont@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Alexis Berlemont <alexis.berlemont@gmail.com>, jolsa@redhat.com,
        dsahern@gmail.com, mingo@kernel.org, sam@ravnborg.org, mmarek@suse.cz
Subject: [PATCH 22/32] perf kbuild: remove legacy libelf-related build variables (2nd part)
Date: Wed,  4 Jun 2014 00:06:15 +0200
Message-Id: <1401833185-10347-23-git-send-email-alexis.berlemont@gmail.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1401833185-10347-1-git-send-email-alexis.berlemont@gmail.com>
References: <1401833185-10347-1-git-send-email-alexis.berlemont@gmail.com>
In-Reply-To: <CAMesUR5h0687dTFCDC3LhKSOFyKTFmH3vUjU+p6XuOpawPUwxQ@mail.gmail.com>
References: <CAMesUR5h0687dTFCDC3LhKSOFyKTFmH3vUjU+p6XuOpawPUwxQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove HAVE_LIBELF_SUPPORT (replaced by CONFIG_LIBELF)
Remove HAVE_LIBELF_MMAP_SUPPORT (replaced by CONFIG_LIBELF_MMAP)
Remove HAVE_LIBELF_GETPHDRNUM__SUPPORT (replaced by
CONFIG_LIBELF_GETPHDRNUM_)
---
 tools/perf/Kconfig                  | 16 ++++++++++++++++
 tools/perf/builtin-inject.c         |  2 +-
 tools/perf/config/Makefile          | 13 ++++++++-----
 tools/perf/perf.c                   |  2 +-
 tools/perf/util/generate-cmdlist.sh |  4 ++--
 tools/perf/util/map.c               |  3 ++-
 tools/perf/util/symbol-elf.c        |  3 ++-
 tools/perf/util/symbol.h            |  8 ++++----
 8 files changed, 36 insertions(+), 15 deletions(-)

diff --git a/tools/perf/Kconfig b/tools/perf/Kconfig
index 196d32c..434a596 100644
--- a/tools/perf/Kconfig
+++ b/tools/perf/Kconfig
@@ -246,8 +246,23 @@ choice
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
 config LIBDWARF
         depends on LIBELF
+	default n
 	bool "Dwarf (libdwarf)"
         ---help---
 	  libdwarf
@@ -255,6 +270,7 @@ config LIBDWARF
 config LIBUNWIND
         depends on LIBELF
 	bool "User space libunwind callchains"
+	default n
         ---help---
 	  The library libunwind provides a portable C API to determine
 	  the call-chain of a program.
diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index 3a73875..6e7883b 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -229,7 +229,7 @@ static int perf_event__inject_buildid(struct perf_tool *tool,
 				 * account this as unresolved.
 				 */
 			} else {
-#ifdef HAVE_LIBELF_SUPPORT
+#ifdef CONFIG_LIBELF
 				pr_warning("no symbols found in %s, maybe "
 					   "install a debug package?\n",
 					   al.map->dso->long_name);
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index f280b80..c102e91 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -312,14 +312,17 @@ ifdef CONFIG_LIBELF
 endif # CONFIG_LIBELF
 
 ifeq ($(LIBELF), 1)
-  CFLAGS += -DHAVE_LIBELF_SUPPORT
 
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
diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index 588221c..f9b919f 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -80,7 +80,7 @@ static struct cmd_struct commands[] = {
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
index 39cd2d0..82261f5 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -1,3 +1,4 @@
+#include "generated/autoconf.h"
 #include "symbol.h"
 #include <errno.h>
 #include <inttypes.h>
@@ -174,7 +175,7 @@ int map__load(struct map *map, symbol_filter_t filter)
 		pr_warning(", continuing without symbols\n");
 		return -1;
 	} else if (nr == 0) {
-#ifdef HAVE_LIBELF_SUPPORT
+#ifdef CONFIG_LIBELF
 		const size_t len = strlen(name);
 		const size_t real_len = len - sizeof(DSO__DELETED);
 
diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
index 6864661..1256595 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -5,12 +5,13 @@
 #include <unistd.h>
 #include <inttypes.h>
 
+#include "generated/autoconf.h"
 #include "symbol.h"
 #include "vdso.h"
 #include <symbol/kallsyms.h>
 #include "debug.h"
 
-#ifndef HAVE_ELF_GETPHDRNUM_SUPPORT
+#ifndef CONFIG_LIBELF_GETPHDRNUM
 static int elf_getphdrnum(Elf *elf, size_t *dst)
 {
 	GElf_Ehdr gehdr;
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index d8e886e..933cfd1 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -15,7 +15,7 @@
 #include <libgen.h>
 #include "build-id.h"
 
-#ifdef HAVE_LIBELF_SUPPORT
+#ifdef CONFIG_LIBELF
 #include <libelf.h>
 #include <gelf.h>
 #endif
@@ -55,13 +55,13 @@ static inline char *bfd_demangle(void __maybe_unused *v,
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
@@ -205,7 +205,7 @@ struct symsrc {
 	int fd;
 	enum dso_binary_type type;
 
-#ifdef HAVE_LIBELF_SUPPORT
+#ifdef CONFIG_LIBELF
 	Elf *elf;
 	GElf_Ehdr ehdr;
 
-- 
1.9.3

