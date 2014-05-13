Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392AbaEMWHu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 18:07:50 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:56306 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932207AbaEMWFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 18:05:47 -0400
From: Alexis Berlemont <alexis.berlemont@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Alexis Berlemont <alexis.berlemont@gmail.com>, jolsa@redhat.com,
        acme@ghostprotocols.net, dsahern@gmail.com, mingo@kernel.org
Subject: [PATCH 25/34] perf kbuild: remove legacy libunwind-related build variables
Date: Wed, 14 May 2014 00:03:20 +0200
Message-Id: <1400018609-20486-26-git-send-email-alexis.berlemont@gmail.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1400018609-20486-1-git-send-email-alexis.berlemont@gmail.com>
References: <1400018609-20486-1-git-send-email-alexis.berlemont@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove NO_UNWIND (replaced by CONFIG_LIBUNWIND)
Remove HAVE_LIBUNWIND_SUPPORT (replaced by CONFIG_LIBUNWIND)
Remove NO_LIBUNWIND_DEBUG_FRAME (replaced by
CONFIG_LIBUNWIND_DEBUG_FRAME)
---
 tools/perf/Kconfig                    | 37 +++++++++----
 tools/perf/arch/arm/Makefile          |  2 +-
 tools/perf/arch/x86/Makefile          |  2 +-
 tools/perf/arch/x86/tests/Kbuild      |  4 +-
 tools/perf/builtin-record.c           | 10 ++--
 tools/perf/config/Makefile            | 98 +++++++++++++++++++++--------------
 tools/perf/config/Makefile.fix-config |  8 ---
 tools/perf/config/Makefile.fix-legacy |  4 --
 tools/perf/util/unwind-libunwind.c    |  5 +-
 tools/perf/util/unwind.h              |  6 +--
 10 files changed, 102 insertions(+), 74 deletions(-)

diff --git a/tools/perf/Kconfig b/tools/perf/Kconfig
index 8da8409..15cebe9 100644
--- a/tools/perf/Kconfig
+++ b/tools/perf/Kconfig
@@ -255,26 +255,45 @@ config LIBDWARF
         ---help---
 	  libdwarf
 
-config LIBDWARF_UNWIND
-        depends on LIBDWARF
-	default y
-	bool "Dwarf unwind"
-        ---help---
-	  libdwarf unwind
-
 config LIBDWARF_DIR
 	string "libdwarf directory"
 	depends on LIBDWARF
         ---help---
 	  libdwarf directory
 
-config LIBUNWIND
+config UNWIND
         depends on LIBELF
-	bool "User space libunwind callchains"
+	bool "User space unwind callchains"
 	default n
         ---help---
+	  unwind
+
+choice UNWIND_DEPS
+       prompt "Unwind dependency"
+       depends on UNWIND
+       default LIBUNWIND
+
+config LIBUNWIND
+        depends on LIBELF
+	bool "Libunwind"
+        ---help---
 	  libunwind
 
+config LIBDWARF_UNWIND
+        depends on LIBDWARF
+	bool "Libdwarf unwind"
+        ---help---
+	  libdwarf unwind
+
+endchoice
+
+config LIBUNWIND_DEBUG_FRAME
+        depends on LIBUNWIND
+	bool "libunwind debug frame"
+	default y
+        ---help---
+	  libunwind debug frame
+
 config LIBUNWIND_DIR
 	string "libunwind directory"
 	depends on LIBUNWIND
diff --git a/tools/perf/arch/arm/Makefile b/tools/perf/arch/arm/Makefile
index 5f33855..04852ea 100644
--- a/tools/perf/arch/arm/Makefile
+++ b/tools/perf/arch/arm/Makefile
@@ -2,6 +2,6 @@ ifeq ($(LIBDWARF), 1)
 PERF_HAVE_DWARF_REGS := 1
 LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/dwarf-regs.o
 endif
-ifndef NO_LIBUNWIND
+ifeq ($(LIBUNWIND), 1)
 LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/unwind-libunwind.o
 endif
diff --git a/tools/perf/arch/x86/Makefile b/tools/perf/arch/x86/Makefile
index 238f75b..d37e641 100644
--- a/tools/perf/arch/x86/Makefile
+++ b/tools/perf/arch/x86/Makefile
@@ -2,7 +2,7 @@ ifeq ($(LIBDWARF), 1)
 PERF_HAVE_DWARF_REGS := 1
 LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/dwarf-regs.o
 endif
-ifndef NO_LIBUNWIND
+ifeq ($(LIBUNWIND), 1)
 LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/unwind-libunwind.o
 endif
 ifeq ($(LIBDWARF_UNWIND), 1)
diff --git a/tools/perf/arch/x86/tests/Kbuild b/tools/perf/arch/x86/tests/Kbuild
index 31269b4..4717953 100644
--- a/tools/perf/arch/x86/tests/Kbuild
+++ b/tools/perf/arch/x86/tests/Kbuild
@@ -1,2 +1,2 @@
-obj-$(CONFIG_LIBDWARF_UNWIND) += regs_load.o
-obj-$(CONFIG_LIBDWARF_UNWIND) += dwarf-unwind.o
+obj-$(CONFIG_UNWIND) += regs_load.o
+obj-$(CONFIG_UNWIND) += dwarf-unwind.o
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 1a832da..decaf8a 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -651,7 +651,7 @@ error:
 	return ret;
 }
 
-#ifdef CONFIG_LIBDWARF_UNWIND
+#ifdef CONFIG_UNWIND
 static int get_stack_size(char *str, unsigned long *_size)
 {
 	char *endptr;
@@ -677,7 +677,7 @@ static int get_stack_size(char *str, unsigned long *_size)
 	       max_size, str);
 	return -1;
 }
-#endif /* CONFIG_LIBDWARF_UNWIND */
+#endif /* CONFIG_UNWIND */
 
 int record_parse_callchain(const char *arg, struct record_opts *opts)
 {
@@ -706,7 +706,7 @@ int record_parse_callchain(const char *arg, struct record_opts *opts)
 				       "needed for -g fp\n");
 			break;
 
-#ifdef CONFIG_LIBDWARF_UNWIND
+#ifdef CONFIG_UNWIND
 		/* Dwarf style */
 		} else if (!strncmp(name, "dwarf", sizeof("dwarf"))) {
 			const unsigned long default_stack_dump_size = 8192;
@@ -722,7 +722,7 @@ int record_parse_callchain(const char *arg, struct record_opts *opts)
 				ret = get_stack_size(tok, &size);
 				opts->stack_dump_size = size;
 			}
-#endif /* CONFIG_LIBDWARF_UNWIND */
+#endif /* CONFIG_UNWIND */
 		} else {
 			pr_err("callchain: Unknown --call-graph option "
 			       "value: %s\n", arg);
@@ -825,7 +825,7 @@ static struct record record = {
 
 #define CALLCHAIN_HELP "setup and enables call-graph (stack chain/backtrace) recording: "
 
-#ifdef CONFIG_LIBDWARF_UNWIND
+#ifdef CONFIG_UNWIND
 const char record_callchain_help[] = CALLCHAIN_HELP "fp dwarf";
 #else
 const char record_callchain_help[] = CALLCHAIN_HELP "fp";
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index fa5f4f8..7636084 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -36,14 +36,15 @@ ifeq ($(ARCH),arm)
 endif
 
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
@@ -302,7 +303,7 @@ ifdef CONFIG_LIBELF
         # architectures to the check.
         ifeq ($(ARCH),x86)
           ifneq ($(feature-libdw-dwarf-unwind),1)
-            msg := $(warning No libdw DWARF unwind found, Please install elfutils-devel/libdw-dev >= 0.158 and/or set LIBDW_DIR);
+            msg := $(warning No libdw DWARF unwind found, Please install elfutils-devel/libdw-dev >= 0.158 and/or set CONFIG_LIBDWARF_DIR);
             $(shell $(KCONFIG_SCRIPT) -d CONFIG_LIBDWARF_UNWIND)
           else
             LIBDWARF_UNWIND = 1
@@ -344,46 +345,68 @@ ifeq ($(LIBELF), 1)
   endif # LIBDWARF
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
+      ifeq ($(ARCH),arm)
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
+ifeq ($(LIBUNWIND), 1)
+  dwarf-post-unwind := 1
+  dwarf-post-unwind-text := libunwind
+else
   ifeq ($(LIBDWARF_UNWIND), 1)
+    dwarf-post-unwind := 1
     dwarf-post-unwind-text := libdw
-  else
-    msg := $(warning Disabling post unwind, no support found.);
-    dwarf-post-unwind := 0
   endif
-else
-  dwarf-post-unwind-text := libunwind
-  # Enable libunwind support by default.
-  $(shell $(KCONFIG_SCRIPT) -d CONFIG_LIBDWARF_UNWIND)
-endif
+endif # LIBUNWIND
 
-ifndef NO_LIBUNWIND
-  ifeq ($(ARCH),arm)
-    $(call feature_check,libunwind-debug-frame)
-    ifneq ($(feature-libunwind-debug-frame), 1)
-      msg := $(warning No debug_frame support found in libunwind);
-      CFLAGS += -DNO_LIBUNWIND_DEBUG_FRAME
-    endif
-  else
-    # non-ARM has no dwarf_find_debug_frame() function:
-    CFLAGS += -DNO_LIBUNWIND_DEBUG_FRAME
-  endif
-  CFLAGS  += -DHAVE_LIBUNWIND_SUPPORT
-  EXTLIBS += $(LIBUNWIND_LIBS)
-  CFLAGS  += $(LIBUNWIND_CFLAGS)
-  LDFLAGS += $(LIBUNWIND_LDFLAGS)
-endif
+endif # CONFIG_UNWIND
 
 ifdef CONFIG_LIBAUDIT
   ifneq ($(feature-libaudit), 1)
@@ -746,10 +769,7 @@ all:
 	$(call store,PYTHON_EMBED_CCOPTS)
 	$(call store,PERL_EMBED_CCOPTS)
 	$(call store,CONFIG_X86_64)
-	$(call store,NO_LIBUNWIND)
 	$(call store,NO_LIBPYTHON)
-	$(call store,NO_LIBUNWIND)
-	$(call store,NO_LIBBIONIC)
 	$(call store,ETC_PERFCONFIG_SQ)
 	$(call store,DESTDIR_SQ)
 	$(call store,bindir_SQ)
diff --git a/tools/perf/config/Makefile.fix-config b/tools/perf/config/Makefile.fix-config
index 32a6701..273f793 100644
--- a/tools/perf/config/Makefile.fix-config
+++ b/tools/perf/config/Makefile.fix-config
@@ -11,12 +11,4 @@ dummy := $(shell $(CONFIG) -d CONFIG_LIBPYTHON)
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
index e3eab7c..275b6d9 100644
--- a/tools/perf/config/Makefile.fix-legacy
+++ b/tools/perf/config/Makefile.fix-legacy
@@ -4,7 +4,3 @@ include $(KCONFIG_CONFIG)
 ifndef CONFIG_LIBPYTHON
 NO_LIBPYTHON := 1
 endif
-
-ifndef CONFIG_LIBUNWIND
-NO_LIBUNWIND := 1
-endif
diff --git a/tools/perf/util/unwind-libunwind.c b/tools/perf/util/unwind-libunwind.c
index bd5768d..0cc7cdc 100644
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
@@ -260,7 +261,7 @@ static int read_unwind_spec_eh_frame(struct dso *dso, struct machine *machine,
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
index 681ad27..0d82d29 100644
--- a/tools/perf/util/unwind.h
+++ b/tools/perf/util/unwind.h
@@ -14,13 +14,13 @@ struct unwind_entry {
 
 typedef int (*unwind_entry_cb_t)(struct unwind_entry *entry, void *arg);
 
-#ifdef CONFIG_LIBDWARF_UNWIND
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
@@ -34,5 +34,5 @@ unwind__get_entries(unwind_entry_cb_t cb __maybe_unused,
 {
 	return 0;
 }
-#endif /* CONFIG_LIBDWARF_UNWIND */
+#endif /* CONFIG__UNWIND */
 #endif /* __UNWIND_H */
-- 
1.9.2

