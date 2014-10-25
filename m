Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752183AbaJYWZb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2014 18:25:31 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:43639 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625AbaJYWXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2014 18:23:33 -0400
From: Alexis Berlemont <alexis.berlemont@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Alexis Berlemont <alexis.berlemont@gmail.com>, jolsa@redhat.com,
        dsahern@gmail.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        paulus@samba.org, acme@kernel.org, namhyung@kernel.org, mmarek@suse.cz
Subject: [PATCH v4 08/14] perf kbuild: cross-compilation variables are now handled in Kconfig
Date: Sun, 26 Oct 2014 00:20:33 +0200
Message-Id: <1414275639-1053-9-git-send-email-alexis.berlemont@gmail.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1414275639-1053-1-git-send-email-alexis.berlemont@gmail.com>
References: <1414275639-1053-1-git-send-email-alexis.berlemont@gmail.com>
In-Reply-To: <20141024124601.GX14687@kernel.org>
References: <20141024124601.GX14687@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The variable CONFIG_ARCH and CONFIG_CROSS_COMPILE were added.

Signed-off-by: Alexis Berlemont <alexis.berlemont@gmail.com>
---
 tools/perf/Kconfig                          | 24 ++++++++++++++++++++++++
 tools/perf/Makefile.kbuild                  |  8 ++++----
 tools/perf/arch/x86/include/perf_regs.h     |  8 +++++---
 tools/perf/arch/x86/tests/regs_load.S       |  3 ++-
 tools/perf/arch/x86/util/unwind-libunwind.c |  5 +++--
 tools/perf/bench/mem-memcpy-arch.h          |  4 +++-
 tools/perf/bench/mem-memcpy.c               |  4 +++-
 tools/perf/bench/mem-memset-arch.h          |  4 +++-
 tools/perf/bench/mem-memset.c               |  4 +++-
 tools/perf/config/Makefile                  |  7 ++-----
 10 files changed, 52 insertions(+), 19 deletions(-)

diff --git a/tools/perf/Kconfig b/tools/perf/Kconfig
index 026ef67..5f85923 100644
--- a/tools/perf/Kconfig
+++ b/tools/perf/Kconfig
@@ -1,6 +1,30 @@
 
 mainmenu "The perf configuration"
 
+config TARGET_ARCH
+	string
+	option env="ARCH"
+
+config TARGET_IS_X86_64
+       string
+       option env="IS_X86_64"
+
+config TARGET_CROSS_COMPILE
+	string
+	option env="CROSS_COMPILE"
+
+config ARCH
+	string
+	default TARGET_ARCH
+
+config X86_64
+	bool
+	default y if TARGET_ARCH = "x86" && TARGET_IS_X86_64 = "1"
+
+config CROSS_COMPILE
+	string
+	default TARGET_CROSS_COMPILE
+
 menu "Built-in commands"
 
 config BUILTIN_RECORD
diff --git a/tools/perf/Makefile.kbuild b/tools/perf/Makefile.kbuild
index 8d9e8b0..b48fe7f 100644
--- a/tools/perf/Makefile.kbuild
+++ b/tools/perf/Makefile.kbuild
@@ -123,9 +123,12 @@ export KCONFIG_AUTOHEADER KCONFIG_AUTOCONFIG KCONFIG_SCRIPT
 
 # perf detected config
 CONFIG_DETECTED := $(obj-perf)/.config-detected
-
 export CONFIG_DETECTED
 
+# arch-related main variables
+include $(src-perf)/config/Makefile.arch
+export ARCH IS_X86_64 CROSS_COMPILE
+
 # external .a libs
 LIBTRACEEVENT   := $(obj-kernel)/tools/lib/traceevent/libtraceevent.a
 LIBAPIKFS       := $(obj-kernel)/tools/lib/api/libapikfs.a
@@ -202,9 +205,6 @@ ifndef dont-detect
 ifdef CONFIG_DETECTED_STORED
 # Following variables are needed within Kbuild files, we need
 # to export them as they are not part of the .config set.
-export CONFIG_ARCH := $(ARCH)
-export CROSS_COMPILE
-export CONFIG_X86_64
 export htmldir_SQ
 export infodir_SQ
 export mandir_SQ
diff --git a/tools/perf/arch/x86/include/perf_regs.h b/tools/perf/arch/x86/include/perf_regs.h
index 7df517a..d969cca 100644
--- a/tools/perf/arch/x86/include/perf_regs.h
+++ b/tools/perf/arch/x86/include/perf_regs.h
@@ -5,9 +5,11 @@
 #include <linux/types.h>
 #include <asm/perf_regs.h>
 
+#include "generated/autoconf.h"
+
 void perf_regs_load(u64 *regs);
 
-#ifndef HAVE_ARCH_X86_64_SUPPORT
+#ifndef CONFIG_X86_64
 #define PERF_REGS_MASK ((1ULL << PERF_REG_X86_32_MAX) - 1)
 #define PERF_REGS_MAX PERF_REG_X86_32_MAX
 #define PERF_SAMPLE_REGS_ABI PERF_SAMPLE_REGS_ABI_32
@@ -58,7 +60,7 @@ static inline const char *perf_reg_name(int id)
 		return "FS";
 	case PERF_REG_X86_GS:
 		return "GS";
-#ifdef HAVE_ARCH_X86_64_SUPPORT
+#ifdef CONFIG_X86_64
 	case PERF_REG_X86_R8:
 		return "R8";
 	case PERF_REG_X86_R9:
@@ -75,7 +77,7 @@ static inline const char *perf_reg_name(int id)
 		return "R14";
 	case PERF_REG_X86_R15:
 		return "R15";
-#endif /* HAVE_ARCH_X86_64_SUPPORT */
+#endif /* CONFIG_X86_64 */
 	default:
 		return NULL;
 	}
diff --git a/tools/perf/arch/x86/tests/regs_load.S b/tools/perf/arch/x86/tests/regs_load.S
index 60875d5..822a797 100644
--- a/tools/perf/arch/x86/tests/regs_load.S
+++ b/tools/perf/arch/x86/tests/regs_load.S
@@ -1,4 +1,5 @@
 #include <linux/linkage.h>
+#include "generated/autoconf.h"
 
 #define AX	 0
 #define BX	 1 * 8
@@ -26,7 +27,7 @@
 #define R15	23 * 8
 
 .text
-#ifdef HAVE_ARCH_X86_64_SUPPORT
+#ifdef CONFIG_X86_64
 ENTRY(perf_regs_load)
 	movq %rax, AX(%rdi)
 	movq %rbx, BX(%rdi)
diff --git a/tools/perf/arch/x86/util/unwind-libunwind.c b/tools/perf/arch/x86/util/unwind-libunwind.c
index db25e93..e4960c1 100644
--- a/tools/perf/arch/x86/util/unwind-libunwind.c
+++ b/tools/perf/arch/x86/util/unwind-libunwind.c
@@ -1,11 +1,12 @@
 
 #include <errno.h>
 #include <libunwind.h>
+#include "generated/autoconf.h"
 #include "perf_regs.h"
 #include "../../util/unwind.h"
 #include "../../util/debug.h"
 
-#ifdef HAVE_ARCH_X86_64_SUPPORT
+#ifdef CONFIG_X86_64
 int libunwind__arch_reg_id(int regnum)
 {
 	int id;
@@ -109,4 +110,4 @@ int libunwind__arch_reg_id(int regnum)
 
 	return id;
 }
-#endif /* HAVE_ARCH_X86_64_SUPPORT */
+#endif /* CONFIG_X86_64 */
diff --git a/tools/perf/bench/mem-memcpy-arch.h b/tools/perf/bench/mem-memcpy-arch.h
index 57b4ed8..8e3f0a9 100644
--- a/tools/perf/bench/mem-memcpy-arch.h
+++ b/tools/perf/bench/mem-memcpy-arch.h
@@ -1,5 +1,7 @@
 
-#ifdef HAVE_ARCH_X86_64_SUPPORT
+#include "generated/autoconf.h"
+
+#ifdef CONFIG_X86_64
 
 #define MEMCPY_FN(fn, name, desc)		\
 	extern void *fn(void *, const void *, size_t);
diff --git a/tools/perf/bench/mem-memcpy.c b/tools/perf/bench/mem-memcpy.c
index 2465141..9061d2b 100644
--- a/tools/perf/bench/mem-memcpy.c
+++ b/tools/perf/bench/mem-memcpy.c
@@ -6,6 +6,8 @@
  * Written by Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
  */
 
+#include "generated/autoconf.h"
+
 #include "../perf.h"
 #include "../util/util.h"
 #include "../util/parse-options.h"
@@ -59,7 +61,7 @@ struct routine routines[] = {
 	{ "default",
 	  "Default memcpy() provided by glibc",
 	  memcpy },
-#ifdef HAVE_ARCH_X86_64_SUPPORT
+#ifdef CONFIG_X86_64
 
 #define MEMCPY_FN(fn, name, desc) { name, desc, fn },
 #include "mem-memcpy-x86-64-asm-def.h"
diff --git a/tools/perf/bench/mem-memset-arch.h b/tools/perf/bench/mem-memset-arch.h
index 633800c..5dfc4c5 100644
--- a/tools/perf/bench/mem-memset-arch.h
+++ b/tools/perf/bench/mem-memset-arch.h
@@ -1,5 +1,7 @@
 
-#ifdef HAVE_ARCH_X86_64_SUPPORT
+#include "generated/autoconf.h"
+
+#ifdef CONFIG_X86_64
 
 #define MEMSET_FN(fn, name, desc)		\
 	extern void *fn(void *, int, size_t);
diff --git a/tools/perf/bench/mem-memset.c b/tools/perf/bench/mem-memset.c
index 75fc3e6..73e8d8d 100644
--- a/tools/perf/bench/mem-memset.c
+++ b/tools/perf/bench/mem-memset.c
@@ -6,6 +6,8 @@
  * Trivial clone of mem-memcpy.c.
  */
 
+#include "generated/autoconf.h"
+
 #include "../perf.h"
 #include "../util/util.h"
 #include "../util/parse-options.h"
@@ -59,7 +61,7 @@ static const struct routine routines[] = {
 	{ "default",
 	  "Default memset() provided by glibc",
 	  memset },
-#ifdef HAVE_ARCH_X86_64_SUPPORT
+#ifdef CONFIG_X86_64
 
 #define MEMSET_FN(fn, name, desc) { name, desc, fn },
 #include "mem-memset-x86-64-asm-def.h"
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 0e36bbe..1e7e369 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -20,11 +20,9 @@ NO_PERF_REGS := 1
 
 # Additional ARCH settings for x86
 ifeq ($(ARCH),x86)
-  ifeq (${IS_X86_64}, 1)
-    CFLAGS += -DHAVE_ARCH_X86_64_SUPPORT
-    ARCH_INCLUDE = ../../arch/x86/lib/memcpy_64.S ../../arch/x86/lib/memset_64.S
+  ifeq ($(IS_X86_64),1)
     LIBUNWIND_LIBS = -lunwind -lunwind-x86_64
-    CONFIG_X86_64=y
+    $(shell $(KCONFIG_SCRIPT) -e CONFIG_X86_64)
   else
     LIBUNWIND_LIBS = -lunwind -lunwind-x86
   endif
@@ -821,7 +819,6 @@ all:
 	$(call store,PARSER_DEBUG_FLEX)
 	$(call store,PYTHON_EMBED_CCOPTS)
 	$(call store,PERL_EMBED_CCOPTS)
-	$(call store,CONFIG_X86_64)
 	$(call store,NO_LIBUNWIND)
 	$(call store,NO_LIBPERL)
 	$(call store,NO_LIBPYTHON)
-- 
2.1.1

