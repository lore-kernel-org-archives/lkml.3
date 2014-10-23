Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753674AbaJWV7W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 17:59:22 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:33179 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753499AbaJWV7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 17:59:17 -0400
From: Alexis Berlemont <alexis.berlemont@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Alexis Berlemont <alexis.berlemont@gmail.com>, jolsa@redhat.com
Subject: [PATCH v2 11/14] perf kbuild: remove legacy libdwarf-related build variables
Date: Thu, 23 Oct 2014 23:56:09 +0200
Message-Id: <1414101372-14443-12-git-send-email-alexis.berlemont@gmail.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1414101372-14443-1-git-send-email-alexis.berlemont@gmail.com>
References: <1414101372-14443-1-git-send-email-alexis.berlemont@gmail.com>
In-Reply-To: <54216F39.9030902@suse.cz>
References: <54216F39.9030902@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Remove NO_DWARF (replaced by CONFIG_LIBDWARF)
* Remove HAVE_DWARF_SUPPORT (replaced by CONFIG_LIBDWARF)
* Remove the useless variable PERF_HAVE_DWARF_REGS
* fix compilation issues if PERF_REGS is disabled

Signed-off-by: Alexis Berlemont <alexis.berlemont@gmail.com>
---

Changes since v1:
 * Add the config parameter SKIP_CALLCHAIN_IDX
 * Fix LIBDWARF_UNWIND directives

 tools/perf/Kconfig                           |  59 +++++++++-
 tools/perf/arch/arm/tests/Kbuild             |   2 +-
 tools/perf/arch/arm/util/Kbuild              |   4 +-
 tools/perf/arch/arm64/util/Kbuild            |   2 +-
 tools/perf/arch/powerpc/util/Kbuild          |   4 +-
 tools/perf/arch/s390/util/Kbuild             |   2 +-
 tools/perf/arch/sh/util/Kbuild               |   2 +-
 tools/perf/arch/sparc/util/Kbuild            |   2 +-
 tools/perf/arch/x86/Kbuild                   |   1 +
 tools/perf/arch/x86/Makefile                 |   8 +-
 tools/perf/arch/x86/tests/Kbuild             |   2 +-
 tools/perf/arch/x86/tests/perf-time-to-tsc.c |   2 +-
 tools/perf/arch/x86/util/Kbuild              |   3 +-
 tools/perf/builtin-probe.c                   |  15 +--
 tools/perf/builtin-record.c                  |   2 +-
 tools/perf/config/Makefile                   | 170 +++++++++++++--------------
 tools/perf/config/Makefile.fix-config        |   8 --
 tools/perf/config/Makefile.fix-legacy        |   4 -
 tools/perf/tests/Kbuild                      |   2 +
 tools/perf/tests/builtin-test.c              |   3 +-
 tools/perf/tests/tests.h                     |   6 +-
 tools/perf/util/Kbuild                       |  11 +-
 tools/perf/util/callchain.c                  |  11 +-
 tools/perf/util/callchain.h                  |   3 +-
 tools/perf/util/include/dwarf-regs.h         |   4 +-
 tools/perf/util/machine.c                    |   3 +-
 tools/perf/util/perf_regs.c                  |   2 -
 tools/perf/util/probe-event.c                |   6 +-
 tools/perf/util/probe-finder.h               |   5 +-
 tools/perf/util/unwind-libunwind.c           |   5 +-
 tools/perf/util/unwind.h                     |   7 +-
 31 files changed, 203 insertions(+), 157 deletions(-)

diff --git a/tools/perf/Kconfig b/tools/perf/Kconfig
index 2eaf3ca..54a194d 100644
--- a/tools/perf/Kconfig
+++ b/tools/perf/Kconfig
@@ -287,7 +287,6 @@ choice
 	  these tasks, perf can rely on either the libelf library or a
 	  minimal builtin support.
 
-
 	config LIBELF
 	bool "elf"
 	---help---
@@ -318,15 +317,51 @@ config LIBDWARF
 	bool "Dwarf (libdwarf)"
 	default y
         ---help---
-	  libdwarf
+	  A library for parsing DWARF debug information.
+
+config LIBDWARF_DIR
+	string "libdwarf directory"
+	depends on LIBDWARF
+        ---help---
+	  Directory holding the libdwarf dependency (headers +
+	  libraries)
+
+config UNWIND
+        depends on (LIBELF && PERF_REGS)
+	bool "User space unwind callchains"
+	default y
+        ---help---
+	  Enable call-chain unwinding of user-space application.
+
+choice UNWIND_DEPS
+       prompt "Unwind dependency"
+       depends on UNWIND
+       default LIBUNWIND
 
 config LIBUNWIND
-        depends on LIBELF
-	bool "User space libunwind callchains"
+        depends on (LIBELF && PERF_REGS)
+	bool "Libunwind"
+        ---help---
+	  Rely on libunwind post unwind support to determine the
+	  call-chain of a user-space program. The library libunwind
+	  supports all the architectures.
+
+config LIBDWARF_UNWIND
+        depends on (LIBDWARF && PERF_REGS && (ARCH = "x86" || ARCH = "arm"))
+	bool "Libdwarf unwind"
+        ---help---
+	  Rely on lidw DWARF post unwind support to determine the
+	  call-chain of a user-space program. So far there's only x86
+	  and arm libdw unwind support merged in perf.
+
+endchoice
+
+config LIBUNWIND_DEBUG_FRAME
+        depends on LIBUNWIND
+	bool "libunwind debug frame"
 	default y
         ---help---
-	  The library libunwind provides a portable C API to determine
-	  the call-chain of a program.
+	  libunwind debug frame
 
 config LIBUNWIND_DIR
 	string "libunwind directory"
@@ -335,6 +370,18 @@ config LIBUNWIND_DIR
 	  Directory holding the libuwind dependency (headers +
 	  libraries).
 
+config SKIP_CALLCHAIN_IDX
+	depends on (LIBDWARF && ARCH = "powerpc")
+	bool "Skip unnecessary callchain entries thanks to Dwarf"
+	default y
+        ---help---
+	  When saving the callchain on Power, the kernel
+	  conservatively saves excess entries in the callchain. A few
+	  of these entries are needed in some cases but not others. If
+	  the unnecessary entries are not ignored, we end up with
+	  duplicate arcs in the call-graphs. Use DWARF debug
+	  information to skip over any unnecessary callchain entries.
+
 config LIBNUMA
 	bool "Libnuma support"
 	default y
diff --git a/tools/perf/arch/arm/tests/Kbuild b/tools/perf/arch/arm/tests/Kbuild
index 1318ed0..f1d8426 100644
--- a/tools/perf/arch/arm/tests/Kbuild
+++ b/tools/perf/arch/arm/tests/Kbuild
@@ -1,2 +1,2 @@
 obj-$(CONFIG_PERF_REGS) += regs_load.o
-obj-y += dwarf-unwind.o
+obj-$(CONFIG_LIBDWARF_UNWIND) += dwarf-unwind.o
diff --git a/tools/perf/arch/arm/util/Kbuild b/tools/perf/arch/arm/util/Kbuild
index c96666a..df195c0 100644
--- a/tools/perf/arch/arm/util/Kbuild
+++ b/tools/perf/arch/arm/util/Kbuild
@@ -1,3 +1,3 @@
-obj-y += dwarf-regs.o
+obj-$(CONFIG_LIBDWARF) += dwarf-regs.o
 obj-$(CONFIG_LIBUNWIND) += unwind-libunwind.o
-obj-y += unwind-libdw.o
+obj-$(CONFIG_LIBDWARF_UNWIND) += unwind-libdw.o
diff --git a/tools/perf/arch/arm64/util/Kbuild b/tools/perf/arch/arm64/util/Kbuild
index 136bc86..bd35d10 100644
--- a/tools/perf/arch/arm64/util/Kbuild
+++ b/tools/perf/arch/arm64/util/Kbuild
@@ -1,2 +1,2 @@
-obj-y += dwarf-regs.o
+obj-$(CONFIG_LIBDWARF) += dwarf-regs.o
 obj-$(CONFIG_LIBUNWIND) += unwind-libunwind.o
diff --git a/tools/perf/arch/powerpc/util/Kbuild b/tools/perf/arch/powerpc/util/Kbuild
index 244ff2c..f33f79d 100644
--- a/tools/perf/arch/powerpc/util/Kbuild
+++ b/tools/perf/arch/powerpc/util/Kbuild
@@ -1,3 +1,3 @@
 obj-y += header.o
-obj-y += skip-callchain-idx.o
-obj-y += dwarf-regs.o
+obj-$(CONFIG_SKIP_CALLCHAIN_IDX) += skip-callchain-idx.o
+obj-$(CONFIG_LIBDWARF) += dwarf-regs.o
diff --git a/tools/perf/arch/s390/util/Kbuild b/tools/perf/arch/s390/util/Kbuild
index 24e8ee7..73df1ff 100644
--- a/tools/perf/arch/s390/util/Kbuild
+++ b/tools/perf/arch/s390/util/Kbuild
@@ -1,2 +1,2 @@
 obj-y += kvm-stat.o
-obj-y += dwarf-regs.o
+obj-$(CONFIG_LIBDWARF) += dwarf-regs.o
diff --git a/tools/perf/arch/sh/util/Kbuild b/tools/perf/arch/sh/util/Kbuild
index 8e698ae..930ba99 100644
--- a/tools/perf/arch/sh/util/Kbuild
+++ b/tools/perf/arch/sh/util/Kbuild
@@ -1 +1 @@
-obj-y += dwarf-regs.o
+obj-$(CONFIG_LIBDWARF) += dwarf-regs.o
diff --git a/tools/perf/arch/sparc/util/Kbuild b/tools/perf/arch/sparc/util/Kbuild
index 8e698ae..930ba99 100644
--- a/tools/perf/arch/sparc/util/Kbuild
+++ b/tools/perf/arch/sparc/util/Kbuild
@@ -1 +1 @@
-obj-y += dwarf-regs.o
+obj-$(CONFIG_LIBDWARF) += dwarf-regs.o
diff --git a/tools/perf/arch/x86/Kbuild b/tools/perf/arch/x86/Kbuild
index 52fd6fa..f5581bee 100644
--- a/tools/perf/arch/x86/Kbuild
+++ b/tools/perf/arch/x86/Kbuild
@@ -1 +1,2 @@
 obj-y += util/
+obj-y += tests/
diff --git a/tools/perf/arch/x86/Makefile b/tools/perf/arch/x86/Makefile
index 9b21881..af36aad 100644
--- a/tools/perf/arch/x86/Makefile
+++ b/tools/perf/arch/x86/Makefile
@@ -1,14 +1,12 @@
-ifndef NO_DWARF
+ifeq ($(LIBDWARF), 1)
 PERF_HAVE_DWARF_REGS := 1
 LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/dwarf-regs.o
 endif
-ifndef NO_LIBUNWIND
+ifeq ($(LIBUNWIND), 1)
 LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/unwind-libunwind.o
 endif
-ifndef NO_LIBDW_DWARF_UNWIND
+ifeq ($(LIBDWARF_UNWIND), 1)
 LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/unwind-libdw.o
-endif
-ifndef NO_DWARF_UNWIND
 LIB_OBJS += $(OUTPUT)arch/$(ARCH)/tests/regs_load.o
 LIB_OBJS += $(OUTPUT)arch/$(ARCH)/tests/dwarf-unwind.o
 endif
diff --git a/tools/perf/arch/x86/tests/Kbuild b/tools/perf/arch/x86/tests/Kbuild
index 8287dae..6d06051 100644
--- a/tools/perf/arch/x86/tests/Kbuild
+++ b/tools/perf/arch/x86/tests/Kbuild
@@ -1,3 +1,3 @@
 obj-y += perf-time-to-tsc.o
 obj-$(CONFIG_PERF_REGS) += regs_load.o
-obj-y += dwarf-unwind.o
+obj-$(CONFIG_LIBDWARF_UNWIND) += dwarf-unwind.o
diff --git a/tools/perf/arch/x86/tests/perf-time-to-tsc.c b/tools/perf/arch/x86/tests/perf-time-to-tsc.c
index f238442..4fff792 100644
--- a/tools/perf/arch/x86/tests/perf-time-to-tsc.c
+++ b/tools/perf/arch/x86/tests/perf-time-to-tsc.c
@@ -9,7 +9,7 @@
 #include "thread_map.h"
 #include "cpumap.h"
 #include "tsc.h"
-#include "tests.h"
+#include "tests/tests.h"
 
 #define CHECK__(x) {				\
 	while ((x) < 0) {			\
diff --git a/tools/perf/arch/x86/util/Kbuild b/tools/perf/arch/x86/util/Kbuild
index c7b86c0..adca885 100644
--- a/tools/perf/arch/x86/util/Kbuild
+++ b/tools/perf/arch/x86/util/Kbuild
@@ -1,5 +1,6 @@
-obj-y += dwarf-regs.o
 obj-y += header.o
 obj-y += tsc.o
 obj-y += kvm-stat.o
+obj-$(CONFIG_LIBDWARF) += dwarf-regs.o
 obj-$(CONFIG_LIBUNWIND) += unwind-libunwind.o
+obj-$(CONFIG_LIBDWARF_UNWIND) += unwind-libdw.o
diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index 04412b4..0a00a4d 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -30,6 +30,7 @@
 #include <stdlib.h>
 #include <string.h>
 
+#include "generated/autoconf.h"
 #include "perf.h"
 #include "builtin.h"
 #include "util/util.h"
@@ -180,7 +181,7 @@ static int opt_set_target(const struct option *opt, const char *str,
 	if  (str && !params.target) {
 		if (!strcmp(opt->long_name, "exec"))
 			params.uprobes = true;
-#ifdef HAVE_DWARF_SUPPORT
+#ifdef CONFIG_LIBDWARF
 		else if (!strcmp(opt->long_name, "module"))
 			params.uprobes = false;
 #endif
@@ -206,7 +207,7 @@ static int opt_set_target(const struct option *opt, const char *str,
 	return ret;
 }
 
-#ifdef HAVE_DWARF_SUPPORT
+#ifdef CONFIG_LIBDWARF
 static int opt_show_lines(const struct option *opt __maybe_unused,
 			  const char *str, int unset __maybe_unused)
 {
@@ -306,7 +307,7 @@ __cmd_probe(int argc, const char **argv, const char *prefix __maybe_unused)
 		"perf probe [<options>] --add 'PROBEDEF' [--add 'PROBEDEF' ...]",
 		"perf probe [<options>] --del '[GROUP:]EVENT' ...",
 		"perf probe --list",
-#ifdef HAVE_DWARF_SUPPORT
+#ifdef CONFIG_LIBDWARF
 		"perf probe [<options>] --line 'LINEDESC'",
 		"perf probe [<options>] --vars 'PROBEPOINT'",
 #endif
@@ -320,7 +321,7 @@ __cmd_probe(int argc, const char **argv, const char *prefix __maybe_unused)
 	OPT_CALLBACK('d', "del", NULL, "[GROUP:]EVENT", "delete a probe event.",
 		opt_del_probe_event),
 	OPT_CALLBACK('a', "add", NULL,
-#ifdef HAVE_DWARF_SUPPORT
+#ifdef CONFIG_LIBDWARF
 		"[EVENT=]FUNC[@SRC][+OFF|%return|:RL|;PT]|SRC:AL|SRC;PT"
 		" [[NAME=]ARG ...]",
 #else
@@ -332,7 +333,7 @@ __cmd_probe(int argc, const char **argv, const char *prefix __maybe_unused)
 		"\t\tFUNC:\tFunction name\n"
 		"\t\tOFF:\tOffset from function entry (in byte)\n"
 		"\t\t%return:\tPut the probe at function return\n"
-#ifdef HAVE_DWARF_SUPPORT
+#ifdef CONFIG_LIBDWARF
 		"\t\tSRC:\tSource code path\n"
 		"\t\tRL:\tRelative line number from function entry.\n"
 		"\t\tAL:\tAbsolute line number in file.\n"
@@ -345,7 +346,7 @@ __cmd_probe(int argc, const char **argv, const char *prefix __maybe_unused)
 		opt_add_probe_event),
 	OPT_BOOLEAN('f', "force", &params.force_add, "forcibly add events"
 		    " with existing name"),
-#ifdef HAVE_DWARF_SUPPORT
+#ifdef CONFIG_LIBDWARF
 	OPT_CALLBACK('L', "line", NULL,
 		     "FUNC[:RLN[+NUM|-RLN2]]|SRC:ALN[+NUM|-ALN2]",
 		     "Show source code lines.", opt_show_lines),
@@ -460,7 +461,7 @@ __cmd_probe(int argc, const char **argv, const char *prefix __maybe_unused)
 		return ret;
 	}
 
-#ifdef HAVE_DWARF_SUPPORT
+#ifdef CONFIG_LIBDWARF
 	if (params.show_lines) {
 		if (params.mod_events) {
 			pr_err("  Error: Don't use --line with"
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index dbba96c..bf56425 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -714,7 +714,7 @@ static struct record record = {
 
 #define CALLCHAIN_HELP "setup and enables call-graph (stack chain/backtrace) recording: "
 
-#ifdef HAVE_DWARF_UNWIND_SUPPORT
+#ifdef CONFIG_LIBDWARF_UNWIND
 const char record_callchain_help[] = CALLCHAIN_HELP "fp dwarf";
 #else
 const char record_callchain_help[] = CALLCHAIN_HELP "fp";
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 79fe047..f667229 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -34,23 +34,16 @@ ifeq ($(ARCH),arm64)
   LIBUNWIND_LIBS = -lunwind -lunwind-aarch64
 endif
 
-# So far there's only x86 and arm libdw unwind support merged in perf.
-# Disable it on all other architectures in case libdw unwind
-# support is detected in system. Add supported architectures
-# to the check.
-ifneq ($(ARCH),$(filter $(ARCH),x86 arm))
-  NO_LIBDW_DWARF_UNWIND := 1
-endif
-
 ifeq ($(LIBUNWIND_LIBS),)
-  NO_LIBUNWIND := 1
+  $(shell $(KCONFIG_SCRIPT) -d CONFIG_LIBUNWIND)
 else
+  LIBUNWIND = 1
   #
   # For linking with debug library, run like:
   #
   #   make DEBUG=1 LIBUNWIND_DIR=/opt/libunwind/
   #
-  ifdef LIBUNWIND_DIR
+  ifdef CONFIG_LIBUNWIND_DIR
     LIBUNWIND_CFLAGS  = -I$(LIBUNWIND_DIR)/include
     LIBUNWIND_LDFLAGS = -L$(LIBUNWIND_DIR)/lib
   endif
@@ -63,12 +56,10 @@ else
   FEATURE_CHECK_LDFLAGS-libunwind-debug-frame = $(LIBUNWIND_LDFLAGS)
 endif
 
-ifndef NO_LIBELF
-  # for linking with debug library, run like:
-  # make DEBUG=1 LIBDW_DIR=/opt/libdw/
-  ifdef LIBDW_DIR
-    LIBDW_CFLAGS  := -I$(LIBDW_DIR)/include
-    LIBDW_LDFLAGS := -L$(LIBDW_DIR)/lib
+ifdef CONFIG_LIBELF
+  ifdef CONFIG_LIBDWARF_DIR
+    LIBDW_CFLAGS  := -I$(CONFIG_LIBDWARF_DIR)/include
+    LIBDW_LDFLAGS := -L$(CONFIG_LIBDWARF_DIR)/lib
   endif
   FEATURE_CHECK_CFLAGS-libdw-dwarf-unwind := $(LIBDW_CFLAGS)
   FEATURE_CHECK_LDFLAGS-libdw-dwarf-unwind := $(LIBDW_LDFLAGS) -ldw
@@ -325,16 +316,22 @@ ifdef CONFIG_LIBELF
     endif
   else
     LIBELF = 1
-    ifndef NO_LIBDW_DWARF_UNWIND
-      ifneq ($(feature-libdw-dwarf-unwind),1)
-        NO_LIBDW_DWARF_UNWIND := 1
-        msg := $(warning No libdw DWARF unwind found, Please install elfutils-devel/libdw-dev >= 0.158 and/or set LIBDW_DIR);
-      endif
-    endif
-    ifneq ($(feature-dwarf), 1)
-      msg := $(warning No libdw.h found or old libdw.h found or elfutils is older than 0.138, disables dwarf support. Please install new elfutils-devel/libdw-dev);
-      NO_DWARF := 1
-    endif # Dwarf support
+    ifdef CONFIG_LIBDWARF
+      ifneq ($(feature-dwarf), 1)
+        msg := $(warning No libdw.h found or old libdw.h found or elfutils is older than 0.138, disables dwarf support. Please install new elfutils-devel/libdw-dev);
+        $(shell $(KCONFIG_SCRIPT) -d CONFIG_LIBDWARF)
+      else
+        LIBDWARF = 1
+      endif # Dwarf support
+      ifdef CONFIG_LIBDWARF_UNWIND
+        ifneq ($(feature-libdw-dwarf-unwind),1)
+          msg := $(warning No libdw DWARF unwind found, Please install elfutils-devel/libdw-dev >= 0.158 and/or set CONFIG_LIBDWARF_DIR);
+          $(shell $(KCONFIG_SCRIPT) -d CONFIG_LIBDWARF_UNWIND)
+        else
+          LIBDWARF_UNWIND = 1
+        endif # Dwarf unwind support detected
+      endif # CONFIG_LIBDWARF_UNWIND
+    endif  # CONFIG_LIBDWARF
   endif # libelf support
 endif # CONFIG_LIBELF
 
@@ -355,72 +352,75 @@ ifeq ($(LIBELF), 1)
   # include ARCH specific config
   -include $(src-perf)/arch/$(ARCH)/Makefile
 
-  ifndef NO_DWARF
-    ifeq ($(origin PERF_HAVE_DWARF_REGS), undefined)
-      msg := $(warning DWARF register mappings have not been defined for architecture $(ARCH), DWARF support disabled);
-      NO_DWARF := 1
-    else
-      CFLAGS += -DHAVE_DWARF_SUPPORT $(LIBDW_CFLAGS)
-      LDFLAGS += $(LIBDW_LDFLAGS)
-      EXTLIBS += -lelf -ldw
-    endif # PERF_HAVE_DWARF_REGS
-  endif # NO_DWARF
+  ifeq ($(LIBDWARF), 1)
+    CFLAGS += $(LIBDW_CFLAGS)
+    LDFLAGS += $(LIBDW_LDFLAGS)
+    EXTLIBS += -lelf -ldw
+  endif # LIBDWARF
 endif # LIBELF
 
-ifeq ($(ARCH),powerpc)
-  ifndef NO_DWARF
-    CFLAGS += -DHAVE_SKIP_CALLCHAIN_IDX
-  endif
-endif
-
-ifndef NO_LIBUNWIND
-  ifneq ($(feature-libunwind), 1)
-    msg := $(warning No libunwind found. Please install libunwind-dev[el] >= 1.1 and/or set LIBUNWIND_DIR);
-    NO_LIBUNWIND := 1
+ifdef CONFIG_UNWIND
+  # CONFIG_LIBUNWIND is the default choice; so, if it is not
+  # available, let's try another one
+  ifdef CONFIG_LIBUNWIND
+    ifeq ($(LIBUNWIND), 1)
+      ifneq ($(feature-libunwind), 1)
+        LIBUNWIND = 0
+        $(shell $(KCONFIG_SCRIPT) -d CONFIG_LIBUNWIND)
+        ifeq ($(LIBDWARF_UNWIND), 1)
+          msg := $(warning No libunwind found, post unwind will rely on libdwarf-unwind. Please install libunwind-dev[el] >= 1.1);
+          $(shell $(KCONFIG_SCRIPT) -e CONFIG_LIBDWARF_UNWIND)
+        else
+          msg := $(warning No libunwind found, disabling post unwind support. Please install libunwind-dev[el] >= 1.1);
+          $(shell $(KCONFIG_SCRIPT) -d CONFIG_UNWIND)
+        endif # LIBDWARF_UNWIND
+      else # feature-libunwind OK
+        EXTLIBS += $(LIBUNWIND_LIBS)
+        CFLAGS += $(LIBUNWIND_CFLAGS)
+        LDFLAGS += $(LIBUNWIND_LDFLAGS)
+      endif # feature-libunwind
+    endif # LIBUNWIND
+  endif # CONFIG_LIBUNWIND
+
+  # CONFIG_LIBDWARF_UNWIND is not the default choice (so the user's
+  # choice); so, we disable CONFIG_UNWIND if it is not available
+  ifdef CONFIG_LIBDWARF_UNWIND
+    ifneq ($(LIBDWARF_UNWIND), 1)
+      msg := $(warning Disabling post unwing because (libdwarf-unwind is not available));
+      $(shell $(KCONFIG_SCRIPT) -d CONFIG_UNWIND)
+    endif
+  endif # CONFIG_LIBDWARF_UNWIND
+
+  # if libunwind is OK, let's check the option DEBUG_FRAME
+  ifdef CONFIG_LIBUNWIND
+    ifeq ($(LIBUNWIND), 1)
+      ifeq ($(ARCH),$(filter $(ARCH),arm arm64))
+        $(call feature_check,libunwind-debug-frame)
+        ifneq ($(feature-libunwind-debug-frame), 1)
+          msg := $(warning No debug_frame support found in libunwind);
+          $(shell $(KCONFIG_SCRIPT) -d CONFIG_LIBUNWIND_DEBUG_FRAME)
+        endif
+      else
+        # non-ARM has no dwarf_find_debug_frame() function:
+        $(shell $(KCONFIG_SCRIPT) -d CONFIG_LIBUNWIND_DEBUG_FRAME)
+      endif
+    endif
   endif
-endif
 
-dwarf-post-unwind := 1
-dwarf-post-unwind-text := BUG
+dwarf-post-unwind = 0
+dwarf-post-unwind-text = BUG
 
-# setup DWARF post unwinder
-ifdef NO_LIBUNWIND
-  ifdef NO_LIBDW_DWARF_UNWIND
-    msg := $(warning Disabling post unwind, no support found.);
-    dwarf-post-unwind := 0
-  else
-    dwarf-post-unwind-text := libdw
-  endif
-else
+ifeq ($(LIBUNWIND), 1)
+  dwarf-post-unwind := 1
   dwarf-post-unwind-text := libunwind
-  # Enable libunwind support by default.
-  ifndef NO_LIBDW_DWARF_UNWIND
-    NO_LIBDW_DWARF_UNWIND := 1
-  endif
-endif
-
-ifeq ($(dwarf-post-unwind),1)
-  CFLAGS += -DHAVE_DWARF_UNWIND_SUPPORT
 else
-  NO_DWARF_UNWIND := 1
-endif
-
-ifndef NO_LIBUNWIND
-  ifeq ($(ARCH),$(filter $(ARCH),arm arm64))
-    $(call feature_check,libunwind-debug-frame)
-    ifneq ($(feature-libunwind-debug-frame), 1)
-      msg := $(warning No debug_frame support found in libunwind);
-      CFLAGS += -DNO_LIBUNWIND_DEBUG_FRAME
-    endif
-  else
-    # non-ARM has no dwarf_find_debug_frame() function:
-    CFLAGS += -DNO_LIBUNWIND_DEBUG_FRAME
+  ifeq ($(LIBDWARF_UNWIND), 1)
+    dwarf-post-unwind := 1
+    dwarf-post-unwind-text := libdw
   endif
-  CFLAGS  += -DHAVE_LIBUNWIND_SUPPORT
-  EXTLIBS += $(LIBUNWIND_LIBS)
-  CFLAGS  += $(LIBUNWIND_CFLAGS)
-  LDFLAGS += $(LIBUNWIND_LDFLAGS)
-endif
+endif # LIBUNWIND
+
+endif # CONFIG_UNWIND
 
 ifdef CONFIG_LIBAUDIT
   ifneq ($(feature-libaudit), 1)
@@ -783,8 +783,6 @@ all:
 	$(call store,NO_LIBUNWIND)
 	$(call store,NO_LIBPERL)
 	$(call store,NO_LIBPYTHON)
-	$(call store,NO_LIBUNWIND)
-	$(call store,NO_LIBBIONIC)
 	$(call store,ETC_PERFCONFIG_SQ)
 	$(call store,DESTDIR_SQ)
 	$(call store,bindir_SQ)
diff --git a/tools/perf/config/Makefile.fix-config b/tools/perf/config/Makefile.fix-config
index 99948b7..e63539f 100644
--- a/tools/perf/config/Makefile.fix-config
+++ b/tools/perf/config/Makefile.fix-config
@@ -19,12 +19,4 @@ dummy := $(shell $(CONFIG) -d CONFIG_LIBPYTHON)
 endif
 endif
 
-# NO_LIBUNWIND
-ifdef CONFIG_LIBUNWIND
-ifdef NO_LIBUNWIND
-dummy := $(info Disabling CONFIG_LIBUNWIND)
-dummy := $(shell $(CONFIG) -d CONFIG_LIBUNWIND)
-endif
-endif
-
 all:
diff --git a/tools/perf/config/Makefile.fix-legacy b/tools/perf/config/Makefile.fix-legacy
index 8568d37..20a4062 100644
--- a/tools/perf/config/Makefile.fix-legacy
+++ b/tools/perf/config/Makefile.fix-legacy
@@ -8,7 +8,3 @@ endif
 ifndef CONFIG_LIBPYTHON
 NO_LIBPYTHON := 1
 endif
-
-ifndef CONFIG_LIBUNWIND
-NO_LIBUNWIND := 1
-endif
diff --git a/tools/perf/tests/Kbuild b/tools/perf/tests/Kbuild
index 9f56ce8..f362620 100644
--- a/tools/perf/tests/Kbuild
+++ b/tools/perf/tests/Kbuild
@@ -31,6 +31,8 @@ obj-y += hists_cumulate.o
 obj-y += hists_common.o
 obj-y += hists_filter.o
 
+obj-$(LIBDWARF_UNWIND) += dwarf-unwind.o
+
 CFLAGS_python-use.o += -D"PYTHON=KBUILD_STR($(PYTHON_WORD))"
 CFLAGS_python-use.o += -D"PYTHONPATH=KBUILD_STR(python)"
 
diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
index 162c978..e3e21b1 100644
--- a/tools/perf/tests/builtin-test.c
+++ b/tools/perf/tests/builtin-test.c
@@ -5,6 +5,7 @@
  */
 #include <unistd.h>
 #include <string.h>
+#include "generated/autoconf.h"
 #include "builtin.h"
 #include "hist.h"
 #include "intlist.h"
@@ -127,7 +128,7 @@ static struct test {
 		.func = test__parse_no_sample_id_all,
 	},
 #if defined(__x86_64__) || defined(__i386__) || defined(__arm__)
-#ifdef HAVE_DWARF_UNWIND_SUPPORT
+#ifdef CONFIG_LIBDWARF_UNWIND
 	{
 		.desc = "Test dwarf unwind",
 		.func = test__dwarf_unwind,
diff --git a/tools/perf/tests/tests.h b/tools/perf/tests/tests.h
index 00e776a..a14555d 100644
--- a/tools/perf/tests/tests.h
+++ b/tools/perf/tests/tests.h
@@ -1,6 +1,8 @@
 #ifndef TESTS_H
 #define TESTS_H
 
+#include "generated/autoconf.h"
+
 #define TEST_ASSERT_VAL(text, cond)					 \
 do {									 \
 	if (!(cond)) {							 \
@@ -52,12 +54,10 @@ int test__switch_tracking(void);
 int test__fdarray__filter(void);
 int test__fdarray__add(void);
 
-#if defined(__x86_64__) || defined(__i386__) || defined(__arm__)
-#ifdef HAVE_DWARF_UNWIND_SUPPORT
+#ifdef CONFIG_LIBDWARF_UNWIND
 struct thread;
 struct perf_sample;
 int test__arch_unwind_sample(struct perf_sample *sample,
 			     struct thread *thread);
 #endif
-#endif
 #endif /* TESTS_H */
diff --git a/tools/perf/util/Kbuild b/tools/perf/util/Kbuild
index 98526db..4dd3e41 100644
--- a/tools/perf/util/Kbuild
+++ b/tools/perf/util/Kbuild
@@ -49,16 +49,19 @@ obj-y += string.o
 obj-y += strlist.o
 obj-y += svghelper.o
 obj-y += symbol.o
-obj-y += perf_regs.o
 obj-y += tsc.o
 obj-y += cloexec.o
 
-obj-$(CONFIG_LIBUNWIND) += unwind.o
+obj-$(CONFIG_PERF_REGS) += perf_regs.o
+
+obj-$(CONFIG_LIBUNWIND) += unwind-libunwind.o
+obj-$(CONFIG_LIBDWARF_UNWIND) += unwind-libdw.o
 
 obj-$(CONFIG_LIBELF) += symbol-elf.o
-obj-$(CONFIG_LIBELF) += dwarf-aux.o
 obj-$(CONFIG_LIBELF) += probe-event.o
-obj-$(CONFIG_LIBELF) += probe-finder.o
+
+obj-$(CONFIG_LIBDWARF) += dwarf-aux.o
+obj-$(CONFIG_LIBDWARF) += probe-finder.o
 
 obj-$(CONFIG_LIBELF_MINIMAL) += symbol-minimal.o
 
diff --git a/tools/perf/util/callchain.c b/tools/perf/util/callchain.c
index c84d3f8..b7c06b2 100644
--- a/tools/perf/util/callchain.c
+++ b/tools/perf/util/callchain.c
@@ -17,6 +17,7 @@
 
 #include "asm/bug.h"
 
+#include "generated/autoconf.h"
 #include "hist.h"
 #include "util.h"
 #include "sort.h"
@@ -25,7 +26,7 @@
 
 __thread struct callchain_cursor callchain_cursor;
 
-#ifdef HAVE_DWARF_UNWIND_SUPPORT
+#ifdef CONFIG_LIBDWARF_UNWIND
 static int get_stack_size(const char *str, unsigned long *_size)
 {
 	char *endptr;
@@ -51,7 +52,7 @@ static int get_stack_size(const char *str, unsigned long *_size)
 	       max_size, str);
 	return -1;
 }
-#endif /* HAVE_DWARF_UNWIND_SUPPORT */
+#endif /* CONFIG_LIBDWARF_UNWIND */
 
 int parse_callchain_record_opt(const char *arg)
 {
@@ -80,7 +81,7 @@ int parse_callchain_record_opt(const char *arg)
 				       "needed for -g fp\n");
 			break;
 
-#ifdef HAVE_DWARF_UNWIND_SUPPORT
+#ifdef CONFIG_LIBDWARF_UNWIND
 		/* Dwarf style */
 		} else if (!strncmp(name, "dwarf", sizeof("dwarf"))) {
 			const unsigned long default_stack_dump_size = 8192;
@@ -96,7 +97,7 @@ int parse_callchain_record_opt(const char *arg)
 				ret = get_stack_size(tok, &size);
 				callchain_param.dump_size = size;
 			}
-#endif /* HAVE_DWARF_UNWIND_SUPPORT */
+#endif /* CONFIG_LIBDWARF_UNWIND */
 		} else {
 			pr_err("callchain: Unknown --call-graph option "
 			       "value: %s\n", arg);
@@ -208,7 +209,7 @@ int perf_callchain_config(const char *var, const char *value)
 
 	if (!strcmp(var, "record-mode"))
 		return parse_callchain_record_opt(value);
-#ifdef HAVE_DWARF_UNWIND_SUPPORT
+#ifdef CONFIG_LIBDWARF_UNWIND
 	if (!strcmp(var, "dump-size")) {
 		unsigned long size = 0;
 		int ret;
diff --git a/tools/perf/util/callchain.h b/tools/perf/util/callchain.h
index 94cfefd..d9a9606 100644
--- a/tools/perf/util/callchain.h
+++ b/tools/perf/util/callchain.h
@@ -1,6 +1,7 @@
 #ifndef __PERF_CALLCHAIN_H
 #define __PERF_CALLCHAIN_H
 
+#include "generated/autoconf.h"
 #include "../perf.h"
 #include <linux/list.h>
 #include <linux/rbtree.h>
@@ -183,7 +184,7 @@ static inline void callchain_cursor_snapshot(struct callchain_cursor *dest,
 	dest->nr -= src->pos;
 }
 
-#ifdef HAVE_SKIP_CALLCHAIN_IDX
+#ifdef CONFIG_SKIP_CALLCHAIN_IDX
 extern int arch_skip_callchain_idx(struct machine *machine,
 			struct thread *thread, struct ip_callchain *chain);
 #else
diff --git a/tools/perf/util/include/dwarf-regs.h b/tools/perf/util/include/dwarf-regs.h
index 8f14965..93cd69c 100644
--- a/tools/perf/util/include/dwarf-regs.h
+++ b/tools/perf/util/include/dwarf-regs.h
@@ -1,7 +1,9 @@
 #ifndef _PERF_DWARF_REGS_H_
 #define _PERF_DWARF_REGS_H_
 
-#ifdef HAVE_DWARF_SUPPORT
+#include "generated/autoconf.h"
+
+#ifdef CONFIG_LIBDWARF
 const char *get_arch_regstr(unsigned int n);
 #endif
 
diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 34fc7c8..7804c6d 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1,3 +1,4 @@
+#include "generated/autoconf.h"
 #include "callchain.h"
 #include "debug.h"
 #include "event.h"
@@ -1407,7 +1408,7 @@ static int machine__resolve_callchain_sample(struct machine *machine,
 		else
 			j = chain->nr - i - 1;
 
-#ifdef HAVE_SKIP_CALLCHAIN_IDX
+#ifdef CONFIG_SKIP_CALLCHAIN_IDX
 		if (j == skip_idx)
 			continue;
 #endif
diff --git a/tools/perf/util/perf_regs.c b/tools/perf/util/perf_regs.c
index 01720b5..434f85b 100644
--- a/tools/perf/util/perf_regs.c
+++ b/tools/perf/util/perf_regs.c
@@ -3,7 +3,6 @@
 #include "perf_regs.h"
 #include "event.h"
 
-#ifdef CONFIG_PERF_REGS
 int perf_reg_value(u64 *valp, struct regs_dump *regs, int id)
 {
 	int i, idx = 0;
@@ -27,4 +26,3 @@ out:
 	*valp = regs->cache_regs[id];
 	return 0;
 }
-#endif /* CONFIG_PERF_REGS */
diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index c150ca4..d31d5d0 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -32,6 +32,7 @@
 #include <limits.h>
 #include <elf.h>
 
+#include "generated/autoconf.h"
 #include "util.h"
 #include "event.h"
 #include "strlist.h"
@@ -256,8 +257,7 @@ static void clear_probe_trace_events(struct probe_trace_event *tevs, int ntevs)
 		clear_probe_trace_event(tevs + i);
 }
 
-#ifdef HAVE_DWARF_SUPPORT
-
+#ifdef CONFIG_LIBDWARF
 /* Open new debuginfo of given module */
 static struct debuginfo *open_debuginfo(const char *module, bool silent)
 {
@@ -799,7 +799,7 @@ out:
 	return ret;
 }
 
-#else	/* !HAVE_DWARF_SUPPORT */
+#else	/* !CONFIG_LIBDWARF */
 
 static int
 find_perf_probe_point_from_dwarf(struct probe_trace_point *tp __maybe_unused,
diff --git a/tools/perf/util/probe-finder.h b/tools/perf/util/probe-finder.h
index 92590b2..13cb054 100644
--- a/tools/perf/util/probe-finder.h
+++ b/tools/perf/util/probe-finder.h
@@ -2,6 +2,7 @@
 #define _PROBE_FINDER_H
 
 #include <stdbool.h>
+#include "generated/autoconf.h"
 #include "util.h"
 #include "intlist.h"
 #include "probe-event.h"
@@ -16,7 +17,7 @@ static inline int is_c_varname(const char *name)
 	return isalpha(name[0]) || name[0] == '_';
 }
 
-#ifdef HAVE_DWARF_SUPPORT
+#ifdef CONFIG_LIBDWARF
 
 #include "dwarf-aux.h"
 
@@ -107,6 +108,6 @@ struct line_finder {
 	int			found;
 };
 
-#endif /* HAVE_DWARF_SUPPORT */
+#endif /* CONFIG_LIBDWARF */
 
 #endif /*_PROBE_FINDER_H */
diff --git a/tools/perf/util/unwind-libunwind.c b/tools/perf/util/unwind-libunwind.c
index e060386..dd98eb3 100644
--- a/tools/perf/util/unwind-libunwind.c
+++ b/tools/perf/util/unwind-libunwind.c
@@ -24,6 +24,7 @@
 #include <linux/list.h>
 #include <libunwind.h>
 #include <libunwind-ptrace.h>
+#include "generated/autoconf.h"
 #include "callchain.h"
 #include "thread.h"
 #include "session.h"
@@ -261,7 +262,7 @@ static int read_unwind_spec_eh_frame(struct dso *dso, struct machine *machine,
 	return ret;
 }
 
-#ifndef NO_LIBUNWIND_DEBUG_FRAME
+#ifdef CONFIG_LIBUNWIND_DEBUG_FRAME
 static int read_unwind_spec_debug_frame(struct dso *dso,
 					struct machine *machine, u64 *offset)
 {
@@ -319,7 +320,7 @@ find_proc_info(unw_addr_space_t as, unw_word_t ip, unw_proc_info_t *pi,
 						 need_unwind_info, arg);
 	}
 
-#ifndef NO_LIBUNWIND_DEBUG_FRAME
+#ifdef CONFIG_LIBUNWIND_DEBUG_FRAME
 	/* Check the .debug_frame section for unwinding info */
 	if (!read_unwind_spec_debug_frame(map->dso, ui->machine, &segbase)) {
 		memset(&di, 0, sizeof(di));
diff --git a/tools/perf/util/unwind.h b/tools/perf/util/unwind.h
index c17c485..63fdf3c 100644
--- a/tools/perf/util/unwind.h
+++ b/tools/perf/util/unwind.h
@@ -2,6 +2,7 @@
 #define __UNWIND_H
 
 #include <linux/types.h>
+#include "generated/autoconf.h"
 #include "event.h"
 #include "symbol.h"
 #include "thread.h"
@@ -14,13 +15,13 @@ struct unwind_entry {
 
 typedef int (*unwind_entry_cb_t)(struct unwind_entry *entry, void *arg);
 
-#ifdef HAVE_DWARF_UNWIND_SUPPORT
+#ifdef CONFIG_UNWIND
 int unwind__get_entries(unwind_entry_cb_t cb, void *arg,
 			struct machine *machine,
 			struct thread *thread,
 			struct perf_sample *data, int max_stack);
 /* libunwind specific */
-#ifdef HAVE_LIBUNWIND_SUPPORT
+#ifdef CONFIG_LIBUNWIND
 int libunwind__arch_reg_id(int regnum);
 int unwind__prepare_access(struct thread *thread);
 void unwind__finish_access(struct thread *thread);
@@ -50,5 +51,5 @@ static inline int unwind__prepare_access(struct thread *thread __maybe_unused)
 }
 
 static inline void unwind__finish_access(struct thread *thread __maybe_unused) {}
-#endif /* HAVE_DWARF_UNWIND_SUPPORT */
+#endif /* CONFIG_UNWIND */
 #endif /* __UNWIND_H */
-- 
2.1.1

