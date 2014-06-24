Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754409AbaFXWvg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 18:51:36 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:52729 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752381AbaFXWuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 18:50:24 -0400
From: Alexis Berlemont <alexis.berlemont@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Alexis Berlemont <alexis.berlemont@gmail.com>, jolsa@redhat.com,
        dsahern@gmail.com, mingo@kernel.org, sam@ravnborg.org, mmarek@suse.cz,
        namhyung@kernel.org
Subject: [PATCH 10/13] perf kbuild: remove legacy libdwarf-related build variables
Date: Wed, 25 Jun 2014 00:47:57 +0200
Message-Id: <1403650080-3130-11-git-send-email-alexis.berlemont@gmail.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1403650080-3130-1-git-send-email-alexis.berlemont@gmail.com>
References: <1403650080-3130-1-git-send-email-alexis.berlemont@gmail.com>
In-Reply-To: <CAMesUR4175wXt-Pov8Yu-ke7KG4FRaBCTYouCs=jK3n0CWi3zw@mail.gmail.com>
References: <CAMesUR4175wXt-Pov8Yu-ke7KG4FRaBCTYouCs=jK3n0CWi3zw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove NO_DWARF (replaced by CONFIG_LIBDWARF)
Remove HAVE_DWARF_SUPPORT (replaced by CONFIG_LIBDWARF)
---
 tools/perf/Kconfig                    |  44 +++++++--
 tools/perf/arch/arm/Makefile          |   4 +-
 tools/perf/arch/powerpc/Makefile      |   2 +-
 tools/perf/arch/s390/Makefile         |   2 +-
 tools/perf/arch/sh/Makefile           |   2 +-
 tools/perf/arch/sparc/Makefile        |   2 +-
 tools/perf/arch/x86/Kbuild            |   1 +
 tools/perf/arch/x86/Makefile          |   8 +-
 tools/perf/arch/x86/tests/Kbuild      |   2 +
 tools/perf/arch/x86/util/Kbuild       |   3 +-
 tools/perf/builtin-probe.c            |  15 ++--
 tools/perf/builtin-record.c           |  10 +--
 tools/perf/config/Makefile            | 165 +++++++++++++++++++---------------
 tools/perf/config/Makefile.fix-config |   8 --
 tools/perf/config/Makefile.fix-legacy |   4 -
 tools/perf/tests/builtin-test.c       |   3 +-
 tools/perf/tests/tests.h              |   4 +-
 tools/perf/util/Kbuild                |   8 +-
 tools/perf/util/include/dwarf-regs.h  |   4 +-
 tools/perf/util/probe-event.c         |   6 +-
 tools/perf/util/probe-finder.h        |   5 +-
 tools/perf/util/unwind-libunwind.c    |   5 +-
 tools/perf/util/unwind.h              |   7 +-
 23 files changed, 183 insertions(+), 131 deletions(-)
 create mode 100644 tools/perf/arch/x86/tests/Kbuild

diff --git a/tools/perf/Kconfig b/tools/perf/Kconfig
index c5733f0..a7e91db 100644
--- a/tools/perf/Kconfig
+++ b/tools/perf/Kconfig
@@ -263,7 +263,6 @@ choice
 	  these tasks, perf can rely on either the libelf library or a
 	  minimal builtin support.
 
-
 	config LIBELF
 	bool "elf"
 	---help---
@@ -294,15 +293,50 @@ config LIBDWARF
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
+        depends on LIBELF
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
         depends on LIBELF
-	bool "User space libunwind callchains"
+	bool "Libunwind"
+        ---help---
+	  Rely on libunwind post unwind support to determine the
+	  call-chain of a user-space program. The library libunwind
+	  supports all the architectures.
+
+config LIBDWARF_UNWIND
+        depends on LIBDWARF
+	bool "Libdwarf unwind"
+        ---help---
+	  Rely on lidw DWARF post unwind support to determine the
+	  call-chain of a user-space program.
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
diff --git a/tools/perf/arch/arm/Makefile b/tools/perf/arch/arm/Makefile
index 09d6215..09ae44f 100644
--- a/tools/perf/arch/arm/Makefile
+++ b/tools/perf/arch/arm/Makefile
@@ -1,8 +1,8 @@
-ifndef NO_DWARF
+ifeq ($(LIBDWARF), 1)
 PERF_HAVE_DWARF_REGS := 1
 LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/dwarf-regs.o
 endif
-ifndef NO_LIBUNWIND
+ifeq ($(LIBUNWIND), 1)
 LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/unwind-libunwind.o
 endif
 ifndef NO_LIBDW_DWARF_UNWIND
diff --git a/tools/perf/arch/powerpc/Makefile b/tools/perf/arch/powerpc/Makefile
index 744e629..3c57a2e 100644
--- a/tools/perf/arch/powerpc/Makefile
+++ b/tools/perf/arch/powerpc/Makefile
@@ -1,4 +1,4 @@
-ifndef NO_DWARF
+ifeq ($(LIBDWARF), 1)
 PERF_HAVE_DWARF_REGS := 1
 LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/dwarf-regs.o
 endif
diff --git a/tools/perf/arch/s390/Makefile b/tools/perf/arch/s390/Makefile
index 15130b5..74e617d 100644
--- a/tools/perf/arch/s390/Makefile
+++ b/tools/perf/arch/s390/Makefile
@@ -1,4 +1,4 @@
-ifndef NO_DWARF
+ifeq ($(LIBDWARF), 1)
 PERF_HAVE_DWARF_REGS := 1
 LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/dwarf-regs.o
 endif
diff --git a/tools/perf/arch/sh/Makefile b/tools/perf/arch/sh/Makefile
index 15130b5..74e617d 100644
--- a/tools/perf/arch/sh/Makefile
+++ b/tools/perf/arch/sh/Makefile
@@ -1,4 +1,4 @@
-ifndef NO_DWARF
+ifeq ($(LIBDWARF), 1)
 PERF_HAVE_DWARF_REGS := 1
 LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/dwarf-regs.o
 endif
diff --git a/tools/perf/arch/sparc/Makefile b/tools/perf/arch/sparc/Makefile
index 15130b5..74e617d 100644
--- a/tools/perf/arch/sparc/Makefile
+++ b/tools/perf/arch/sparc/Makefile
@@ -1,4 +1,4 @@
-ifndef NO_DWARF
+ifeq ($(LIBDWARF), 1)
 PERF_HAVE_DWARF_REGS := 1
 LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/dwarf-regs.o
 endif
diff --git a/tools/perf/arch/x86/Kbuild b/tools/perf/arch/x86/Kbuild
index 52fd6fa..3b9a068 100644
--- a/tools/perf/arch/x86/Kbuild
+++ b/tools/perf/arch/x86/Kbuild
@@ -1 +1,2 @@
 obj-y += util/
+obj-y += tests/
\ No newline at end of file
diff --git a/tools/perf/arch/x86/Makefile b/tools/perf/arch/x86/Makefile
index 1641542..d37e641 100644
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
new file mode 100644
index 0000000..4717953
--- /dev/null
+++ b/tools/perf/arch/x86/tests/Kbuild
@@ -0,0 +1,2 @@
+obj-$(CONFIG_UNWIND) += regs_load.o
+obj-$(CONFIG_UNWIND) += dwarf-unwind.o
diff --git a/tools/perf/arch/x86/util/Kbuild b/tools/perf/arch/x86/util/Kbuild
index e033b94..0eed9c0 100644
--- a/tools/perf/arch/x86/util/Kbuild
+++ b/tools/perf/arch/x86/util/Kbuild
@@ -1,4 +1,5 @@
 obj-y += dwarf-regs.o
 obj-y += header.o
 obj-y += tsc.o
-obj-$(CONFIG_LIBUNWIND) += unwind.o
+obj-$(CONFIG_LIBUNWIND) += unwind-libunwind.o
+obj-$(CONFIG_LIBDWARF_UNWIND) += unwind-libdw.o
diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index c63fa29..ddd4ef4 100644
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
@@ -303,7 +304,7 @@ __cmd_probe(int argc, const char **argv, const char *prefix __maybe_unused)
 		"perf probe [<options>] --add 'PROBEDEF' [--add 'PROBEDEF' ...]",
 		"perf probe [<options>] --del '[GROUP:]EVENT' ...",
 		"perf probe --list",
-#ifdef HAVE_DWARF_SUPPORT
+#ifdef CONFIG_LIBDWARF
 		"perf probe [<options>] --line 'LINEDESC'",
 		"perf probe [<options>] --vars 'PROBEPOINT'",
 #endif
@@ -317,7 +318,7 @@ __cmd_probe(int argc, const char **argv, const char *prefix __maybe_unused)
 	OPT_CALLBACK('d', "del", NULL, "[GROUP:]EVENT", "delete a probe event.",
 		opt_del_probe_event),
 	OPT_CALLBACK('a', "add", NULL,
-#ifdef HAVE_DWARF_SUPPORT
+#ifdef CONFIG_LIBDWARF
 		"[EVENT=]FUNC[@SRC][+OFF|%return|:RL|;PT]|SRC:AL|SRC;PT"
 		" [[NAME=]ARG ...]",
 #else
@@ -329,7 +330,7 @@ __cmd_probe(int argc, const char **argv, const char *prefix __maybe_unused)
 		"\t\tFUNC:\tFunction name\n"
 		"\t\tOFF:\tOffset from function entry (in byte)\n"
 		"\t\t%return:\tPut the probe at function return\n"
-#ifdef HAVE_DWARF_SUPPORT
+#ifdef CONFIG_LIBDWARF
 		"\t\tSRC:\tSource code path\n"
 		"\t\tRL:\tRelative line number from function entry.\n"
 		"\t\tAL:\tAbsolute line number in file.\n"
@@ -342,7 +343,7 @@ __cmd_probe(int argc, const char **argv, const char *prefix __maybe_unused)
 		opt_add_probe_event),
 	OPT_BOOLEAN('f', "force", &params.force_add, "forcibly add events"
 		    " with existing name"),
-#ifdef HAVE_DWARF_SUPPORT
+#ifdef CONFIG_LIBDWARF
 	OPT_CALLBACK('L', "line", NULL,
 		     "FUNC[:RLN[+NUM|-RLN2]]|SRC:ALN[+NUM|-ALN2]",
 		     "Show source code lines.", opt_show_lines),
@@ -455,7 +456,7 @@ __cmd_probe(int argc, const char **argv, const char *prefix __maybe_unused)
 		return ret;
 	}
 
-#ifdef HAVE_DWARF_SUPPORT
+#ifdef CONFIG_LIBDWARF
 	if (params.show_lines) {
 		if (params.mod_events) {
 			pr_err("  Error: Don't use --line with"
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 42c127d..aafb786 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -617,7 +617,7 @@ error:
 	return ret;
 }
 
-#ifdef HAVE_DWARF_UNWIND_SUPPORT
+#ifdef CONFIG_UNWIND
 static int get_stack_size(char *str, unsigned long *_size)
 {
 	char *endptr;
@@ -643,7 +643,7 @@ static int get_stack_size(char *str, unsigned long *_size)
 	       max_size, str);
 	return -1;
 }
-#endif /* HAVE_DWARF_UNWIND_SUPPORT */
+#endif /* CONFIG_UNWIND */
 
 int record_parse_callchain(const char *arg, struct record_opts *opts)
 {
@@ -672,7 +672,7 @@ int record_parse_callchain(const char *arg, struct record_opts *opts)
 				       "needed for -g fp\n");
 			break;
 
-#ifdef HAVE_DWARF_UNWIND_SUPPORT
+#ifdef CONFIG_UNWIND
 		/* Dwarf style */
 		} else if (!strncmp(name, "dwarf", sizeof("dwarf"))) {
 			const unsigned long default_stack_dump_size = 8192;
@@ -688,7 +688,7 @@ int record_parse_callchain(const char *arg, struct record_opts *opts)
 				ret = get_stack_size(tok, &size);
 				opts->stack_dump_size = size;
 			}
-#endif /* HAVE_DWARF_UNWIND_SUPPORT */
+#endif /* CONFIG_UNWIND */
 		} else {
 			pr_err("callchain: Unknown --call-graph option "
 			       "value: %s\n", arg);
@@ -791,7 +791,7 @@ static struct record record = {
 
 #define CALLCHAIN_HELP "setup and enables call-graph (stack chain/backtrace) recording: "
 
-#ifdef HAVE_DWARF_UNWIND_SUPPORT
+#ifdef CONFIG_UNWIND
 const char record_callchain_help[] = CALLCHAIN_HELP "fp dwarf";
 #else
 const char record_callchain_help[] = CALLCHAIN_HELP "fp";
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 95db69d..f4b133e 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -41,23 +41,16 @@ ifeq ($(ARCH),arm64)
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
@@ -74,12 +67,10 @@ ifeq ($(NO_PERF_REGS),0)
   CFLAGS += -DHAVE_PERF_REGS_SUPPORT
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
@@ -306,16 +297,30 @@ ifdef CONFIG_LIBELF
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
+        # So far there's only x86 and arm libdw unwind support merged
+        # in perf. Disable it on all other architectures in case libdw
+        # unwind support is detected in system. Add supported
+        # architectures to the check.
+        ifeq ($(ARCH),$(filter $(ARCH),x86 arm))
+          ifneq ($(feature-libdw-dwarf-unwind),1)
+            msg := $(warning No libdw DWARF unwind found, Please install elfutils-devel/libdw-dev >= 0.158 and/or set CONFIG_LIBDWARF_DIR);
+            $(shell $(KCONFIG_SCRIPT) -d CONFIG_LIBDWARF_UNWIND)
+          else
+            LIBDWARF_UNWIND = 1
+          endif # Dwarf unwind support
+        else
+          $(shell $(KCONFIG_SCRIPT) -d CONFIG_LIBDWARF_UNWIND)
+        endif # Arch x86
+      endif # CONFIG_LIBDWARF_UNWIND
+    endif  # CONFIG_LIBDWARF
   endif # libelf support
 endif # CONFIG_LIBELF
 
@@ -336,66 +341,80 @@ ifeq ($(LIBELF), 1)
   # include ARCH specific config
   -include $(src-perf)/arch/$(ARCH)/Makefile
 
-  ifndef NO_DWARF
+  ifeq ($(LIBDWARF), 1)
     ifeq ($(origin PERF_HAVE_DWARF_REGS), undefined)
       msg := $(warning DWARF register mappings have not been defined for architecture $(ARCH), DWARF support disabled);
-      NO_DWARF := 1
+      $(shell $(KCONFIG_SCRIPT) -d CONFIG_LIBDWARF)
     else
-      CFLAGS += -DHAVE_DWARF_SUPPORT $(LIBDW_CFLAGS)
+      CFLAGS += $(LIBDW_CFLAGS)
       LDFLAGS += $(LIBDW_LDFLAGS)
       EXTLIBS += -lelf -ldw
     endif # PERF_HAVE_DWARF_REGS
-  endif # NO_DWARF
+  endif # LIBDWARF
 endif # LIBELF
 
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
@@ -759,8 +778,6 @@ all:
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
diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
index 6f8b01b..608c9ab 100644
--- a/tools/perf/tests/builtin-test.c
+++ b/tools/perf/tests/builtin-test.c
@@ -5,6 +5,7 @@
  */
 #include <unistd.h>
 #include <string.h>
+#include "generated/autoconf.h"
 #include "builtin.h"
 #include "intlist.h"
 #include "tests.h"
@@ -126,7 +127,7 @@ static struct test {
 		.func = test__parse_no_sample_id_all,
 	},
 #if defined(__x86_64__) || defined(__i386__) || defined(__arm__)
-#ifdef HAVE_DWARF_UNWIND_SUPPORT
+#ifdef CONFIG_LIBDWARF_UNWIND
 	{
 		.desc = "Test dwarf unwind",
 		.func = test__dwarf_unwind,
diff --git a/tools/perf/tests/tests.h b/tools/perf/tests/tests.h
index ed64790..bcc860d 100644
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
@@ -50,7 +52,7 @@ int test__hists_output(void);
 int test__hists_cumulate(void);
 
 #if defined(__x86_64__) || defined(__i386__) || defined(__arm__)
-#ifdef HAVE_DWARF_UNWIND_SUPPORT
+#ifdef CONFIG_LIBDWARF_UNWIND
 struct thread;
 struct perf_sample;
 int test__arch_unwind_sample(struct perf_sample *sample,
diff --git a/tools/perf/util/Kbuild b/tools/perf/util/Kbuild
index 4ddd43d..6e02080 100644
--- a/tools/perf/util/Kbuild
+++ b/tools/perf/util/Kbuild
@@ -51,12 +51,14 @@ obj-y += symbol.o
 obj-y += perf_regs.o
 
 
-obj-$(CONFIG_LIBUNWIND) += unwind.o
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
 
diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 9a0a183..b0120dd 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -32,6 +32,7 @@
 #include <limits.h>
 #include <elf.h>
 
+#include "generated/autoconf.h"
 #include "util.h"
 #include "event.h"
 #include "strlist.h"
@@ -255,8 +256,7 @@ static void clear_probe_trace_events(struct probe_trace_event *tevs, int ntevs)
 		clear_probe_trace_event(tevs + i);
 }
 
-#ifdef HAVE_DWARF_SUPPORT
-
+#ifdef CONFIG_LIBDWARF
 /* Open new debuginfo of given module */
 static struct debuginfo *open_debuginfo(const char *module)
 {
@@ -791,7 +791,7 @@ out:
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
index 25578b9..8325e158 100644
--- a/tools/perf/util/unwind-libunwind.c
+++ b/tools/perf/util/unwind-libunwind.c
@@ -24,6 +24,7 @@
 #include <linux/list.h>
 #include <libunwind.h>
 #include <libunwind-ptrace.h>
+#include "generated/autoconf.h"
 #include "thread.h"
 #include "session.h"
 #include "perf_regs.h"
@@ -259,7 +260,7 @@ static int read_unwind_spec_eh_frame(struct dso *dso, struct machine *machine,
 	return ret;
 }
 
-#ifndef NO_LIBUNWIND_DEBUG_FRAME
+#ifdef CONFIG_LIBUNWIND_DEBUG_FRAME
 static int read_unwind_spec_debug_frame(struct dso *dso,
 					struct machine *machine, u64 *offset)
 {
@@ -317,7 +318,7 @@ find_proc_info(unw_addr_space_t as, unw_word_t ip, unw_proc_info_t *pi,
 						 need_unwind_info, arg);
 	}
 
-#ifndef NO_LIBUNWIND_DEBUG_FRAME
+#ifdef CONFIG_LIBUNWIND_DEBUG_FRAME
 	/* Check the .debug_frame section for unwinding info */
 	if (!read_unwind_spec_debug_frame(map->dso, ui->machine, &segbase)) {
 		memset(&di, 0, sizeof(di));
diff --git a/tools/perf/util/unwind.h b/tools/perf/util/unwind.h
index f030612..c6b96e3 100644
--- a/tools/perf/util/unwind.h
+++ b/tools/perf/util/unwind.h
@@ -2,6 +2,7 @@
 #define __UNWIND_H
 
 #include <linux/types.h>
+#include "generated/autoconf.h"
 #include "event.h"
 #include "symbol.h"
 
@@ -13,13 +14,13 @@ struct unwind_entry {
 
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
 #endif
 #else
@@ -33,5 +34,5 @@ unwind__get_entries(unwind_entry_cb_t cb __maybe_unused,
 {
 	return 0;
 }
-#endif /* HAVE_DWARF_UNWIND_SUPPORT */
+#endif /* CONFIG__UNWIND */
 #endif /* __UNWIND_H */
-- 
1.9.3

