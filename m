Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760151Ab3DBD7E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 23:59:04 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:53804 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760485Ab3DBDzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 23:55:09 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>, Borislav Petkov <bp@alien8.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 09/23] perf: make cfi unwind support based on CONFIG_LIBUNWIND
Date: Mon,  1 Apr 2013 21:54:23 -0600
Message-Id: <1364874877-5618-10-git-send-email-dsahern@gmail.com>
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
 tools/perf/Makefile                 |   20 ++++++++++----------
 tools/perf/Pconfig                  |   15 +++++++++++++++
 tools/perf/arch/x86/Makefile        |    2 +-
 tools/perf/config/feature-tests.mak |    2 +-
 4 files changed, 27 insertions(+), 12 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 9bb12b5..5c060c8 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -36,9 +36,6 @@ include config/utilities.mak
 #
 # Define NO_DEMANGLE if you do not want C++ symbol demangling.
 #
-# Define NO_LIBUNWIND if you do not want libunwind dependency for dwarf
-# backtrace post unwind.
-#
 # Define NO_BACKTRACE if you do not want stack backtrace debug feature
 #
 # Define NO_LIBNUMA if you do not want numa perf benchmark
@@ -575,15 +572,19 @@ ifdef CONFIG_LIBELF
 else
     NO_DWARF := 1
     NO_DEMANGLE := 1
-    NO_LIBUNWIND := 1
+    ifdef CONFIG_LIBUNWIND
+        $(error CONFIG_LIBUNWIND depends on LIBELF)
+    endif
 endif
 
 # There's only x86 (both 32 and 64) support for CFI unwind so far
 ifneq ($(ARCH),x86)
-	NO_LIBUNWIND := 1
+ifdef CONFIG_LIBUNWIND
+	$(error CONFIG_LIBUNWIND only supported for x86 architecture)
+endif
 endif
 
-ifndef NO_LIBUNWIND
+ifdef CONFIG_LIBUNWIND
 # for linking with debug library, run like:
 # make DEBUG=1 LIBUNWIND_DIR=/opt/libunwind/
 ifdef LIBUNWIND_DIR
@@ -593,10 +594,9 @@ endif
 
 FLAGS_UNWIND=$(LIBUNWIND_CFLAGS) $(ALL_CFLAGS) $(LIBUNWIND_LDFLAGS) $(ALL_LDFLAGS) $(EXTLIBS) $(LIBUNWIND_LIBS)
 ifneq ($(call try-cc,$(SOURCE_LIBUNWIND),$(FLAGS_UNWIND),libunwind),y)
-	msg := $(warning No libunwind found, disabling post unwind support. Please install libunwind-dev[el] >= 0.99);
-	NO_LIBUNWIND := 1
+    $(error No libunwind found. Please install libunwind-dev[el] >= 0.99 or disable CONFIG_LIBUNWIND)
 endif # Libunwind support
-endif # NO_LIBUNWIND
+endif
 
 -include arch/$(ARCH)/Makefile
 
@@ -636,7 +636,7 @@ else
     LIB_OBJS += $(OUTPUT)util/symbol-minimal.o
 endif
 
-ifndef NO_LIBUNWIND
+ifdef CONFIG_LIBUNWIND
 	BASIC_CFLAGS += -DLIBUNWIND_SUPPORT
 	EXTLIBS += $(LIBUNWIND_LIBS)
 	BASIC_CFLAGS := $(LIBUNWIND_CFLAGS) $(BASIC_CFLAGS)
diff --git a/tools/perf/Pconfig b/tools/perf/Pconfig
index 334674c..d6e067e 100644
--- a/tools/perf/Pconfig
+++ b/tools/perf/Pconfig
@@ -1,3 +1,14 @@
+config ARCH
+    string
+    option env="ARCH"
+
+config X86
+    def_bool y if ARCH = "x86"
+    select HAVE_CFI_UNWIND_SUPPORT
+
+config HAVE_CFI_UNWIND_SUPPORT
+    bool
+
 config NEWT
     bool "Enable newt-based TUI"
 
@@ -11,6 +22,10 @@ config LIBELF
     bool "Enable support for libelf"
     depends on LIBC
 
+config LIBUNWIND
+    bool "Enable support for libunwind"
+    depends on HAVE_CFI_UNWIND_SUPPORT && LIBELF
+
 config LIBPERL
     bool "Enable support for perl scripting engine"
 
diff --git a/tools/perf/arch/x86/Makefile b/tools/perf/arch/x86/Makefile
index 815841c..3a6dc3d 100644
--- a/tools/perf/arch/x86/Makefile
+++ b/tools/perf/arch/x86/Makefile
@@ -2,7 +2,7 @@ ifndef NO_DWARF
 PERF_HAVE_DWARF_REGS := 1
 LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/dwarf-regs.o
 endif
-ifndef NO_LIBUNWIND
+ifdef CONFIG_LIBUNWIND
 LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/unwind.o
 endif
 LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/header.o
diff --git a/tools/perf/config/feature-tests.mak b/tools/perf/config/feature-tests.mak
index 7ec044f..b0c28b2 100644
--- a/tools/perf/config/feature-tests.mak
+++ b/tools/perf/config/feature-tests.mak
@@ -167,7 +167,7 @@ int main(void)
 }
 endef
 
-ifndef NO_LIBUNWIND
+ifdef CONFIG_LIBUNWIND
 define SOURCE_LIBUNWIND
 #include <libunwind.h>
 #include <stdlib.h>
-- 
1.7.10.1

