Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760527Ab3DBDzT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 23:55:19 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:61138 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759873Ab3DBDzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 23:55:14 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>, Borislav Petkov <bp@alien8.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 11/23] perf: make dwarf support based on CONFIG_DWARF
Date: Mon,  1 Apr 2013 21:54:25 -0600
Message-Id: <1364874877-5618-12-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1364874877-5618-1-git-send-email-dsahern@gmail.com>
References: <1364874877-5618-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/Makefile                 |   22 ++++++++++++----------
 tools/perf/Pconfig                  |    4 ++++
 tools/perf/arch/arm/Makefile        |    2 +-
 tools/perf/arch/powerpc/Makefile    |    2 +-
 tools/perf/arch/s390/Makefile       |    2 +-
 tools/perf/arch/sh/Makefile         |    2 +-
 tools/perf/arch/sparc/Makefile      |    2 +-
 tools/perf/arch/x86/Makefile        |    2 +-
 tools/perf/config/feature-tests.mak |    2 +-
 9 files changed, 23 insertions(+), 17 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 65283e6..d2707ee 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -30,8 +30,6 @@ include config/utilities.mak
 #
 # Define EXTRA_CFLAGS=-m64 or EXTRA_CFLAGS=-m32 as appropriate for cross-builds.
 #
-# Define NO_DWARF if you do not want debug-info analysis feature at all.
-#
 # Define WERROR=0 to disable treating any warnings as errors.
 #
 # Define NO_BACKTRACE if you do not want stack backtrace debug feature
@@ -562,13 +560,17 @@ ifdef CONFIG_LIBELF
 	endif
 
     # libelf supported - what about dwarf?
-	FLAGS_DWARF=$(ALL_CFLAGS) $(LIBDW_CFLAGS) -ldw -lelf $(LIBDW_LDFLAGS) $(ALL_LDFLAGS) $(EXTLIBS)
-	ifneq ($(call try-cc,$(SOURCE_DWARF),$(FLAGS_DWARF),libdw),y)
-		msg := $(warning No libdw.h found or old libdw.h found or elfutils is older than 0.138, disables dwarf support. Please install new elfutils-devel/libdw-dev);
-		NO_DWARF := 1
-	endif
+    ifdef CONFIG_DWARF
+        FLAGS_DWARF=$(ALL_CFLAGS) $(LIBDW_CFLAGS) -ldw -lelf $(LIBDW_LDFLAGS) $(ALL_LDFLAGS) $(EXTLIBS)
+        ifneq ($(call try-cc,$(SOURCE_DWARF),$(FLAGS_DWARF),libdw),y)
+            $(warning No libdw.h found or old libdw.h found or elfutils is older than 0.138.ables dwarf support.)
+            $(error Please install new elfutils-devel/libdw-dev or disable CONFIG_DWARF);
+        endif
+    endif
 else
-    NO_DWARF := 1
+    ifdef CONFIG_DWARF
+        $(error CONFIG_DWARF depends on LIBELF)
+    endif
     ifdef CONFIG_DEMANGLE
         $(error CONFIG_DEMANGLE depends on LIBELF)
     endif
@@ -612,7 +614,7 @@ ifdef CONFIG_LIBELF
 	    BASIC_CFLAGS += -DLIBELF_MMAP
     endif
 
-    ifndef NO_DWARF
+    ifdef CONFIG_DWARF
         ifeq ($(origin PERF_HAVE_DWARF_REGS), undefined)
 	        msg := $(warning DWARF register mappings have not been defined for architecture $(ARCH), DWARF support disabled);
         else
@@ -622,7 +624,7 @@ ifdef CONFIG_LIBELF
             LIB_OBJS += $(OUTPUT)util/probe-finder.o
             LIB_OBJS += $(OUTPUT)util/dwarf-aux.o
         endif # PERF_HAVE_DWARF_REGS
-    endif # NO_DWARF
+    endif
 
 else
     EXTLIBS := $(filter-out -lelf,$(EXTLIBS))
diff --git a/tools/perf/Pconfig b/tools/perf/Pconfig
index dc0fc36..f744b7b 100644
--- a/tools/perf/Pconfig
+++ b/tools/perf/Pconfig
@@ -26,6 +26,10 @@ config LIBUNWIND
     bool "Enable support for libunwind"
     depends on HAVE_CFI_UNWIND_SUPPORT && LIBELF
 
+config DWARF
+    bool "Enable support for dwarf"
+    depends on LIBELF
+
  config DEMANGLE
     bool "Enable support for demangle"
     depends on LIBELF
diff --git a/tools/perf/arch/arm/Makefile b/tools/perf/arch/arm/Makefile
index 15130b5..6d630e3 100644
--- a/tools/perf/arch/arm/Makefile
+++ b/tools/perf/arch/arm/Makefile
@@ -1,4 +1,4 @@
-ifndef NO_DWARF
+ifdef CONFIG_DWARF
 PERF_HAVE_DWARF_REGS := 1
 LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/dwarf-regs.o
 endif
diff --git a/tools/perf/arch/powerpc/Makefile b/tools/perf/arch/powerpc/Makefile
index 744e629..d01408e 100644
--- a/tools/perf/arch/powerpc/Makefile
+++ b/tools/perf/arch/powerpc/Makefile
@@ -1,4 +1,4 @@
-ifndef NO_DWARF
+ifdef CONFIG_DWARF
 PERF_HAVE_DWARF_REGS := 1
 LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/dwarf-regs.o
 endif
diff --git a/tools/perf/arch/s390/Makefile b/tools/perf/arch/s390/Makefile
index 15130b5..6d630e3 100644
--- a/tools/perf/arch/s390/Makefile
+++ b/tools/perf/arch/s390/Makefile
@@ -1,4 +1,4 @@
-ifndef NO_DWARF
+ifdef CONFIG_DWARF
 PERF_HAVE_DWARF_REGS := 1
 LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/dwarf-regs.o
 endif
diff --git a/tools/perf/arch/sh/Makefile b/tools/perf/arch/sh/Makefile
index 15130b5..6d630e3 100644
--- a/tools/perf/arch/sh/Makefile
+++ b/tools/perf/arch/sh/Makefile
@@ -1,4 +1,4 @@
-ifndef NO_DWARF
+ifdef CONFIG_DWARF
 PERF_HAVE_DWARF_REGS := 1
 LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/dwarf-regs.o
 endif
diff --git a/tools/perf/arch/sparc/Makefile b/tools/perf/arch/sparc/Makefile
index 15130b5..6d630e3 100644
--- a/tools/perf/arch/sparc/Makefile
+++ b/tools/perf/arch/sparc/Makefile
@@ -1,4 +1,4 @@
-ifndef NO_DWARF
+ifdef CONFIG_DWARF
 PERF_HAVE_DWARF_REGS := 1
 LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/dwarf-regs.o
 endif
diff --git a/tools/perf/arch/x86/Makefile b/tools/perf/arch/x86/Makefile
index 3a6dc3d..8d18b74 100644
--- a/tools/perf/arch/x86/Makefile
+++ b/tools/perf/arch/x86/Makefile
@@ -1,4 +1,4 @@
-ifndef NO_DWARF
+ifdef CONFIG_DWARF
 PERF_HAVE_DWARF_REGS := 1
 LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/dwarf-regs.o
 endif
diff --git a/tools/perf/config/feature-tests.mak b/tools/perf/config/feature-tests.mak
index b0c28b2..7873e6d 100644
--- a/tools/perf/config/feature-tests.mak
+++ b/tools/perf/config/feature-tests.mak
@@ -6,7 +6,7 @@ int main(void)
 }
 endef
 
-ifndef NO_DWARF
+ifdef CONFIG_DWARF
 define SOURCE_DWARF
 #include <dwarf.h>
 #include <elfutils/libdw.h>
-- 
1.7.10.1

