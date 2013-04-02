Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760497Ab3DBDzK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 23:55:10 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:45240 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760451Ab3DBDzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 23:55:07 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>, Borislav Petkov <bp@alien8.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 08/23] perf: make elf support based on CONFIG_LIBELF
Date: Mon,  1 Apr 2013 21:54:22 -0600
Message-Id: <1364874877-5618-9-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1364874877-5618-1-git-send-email-dsahern@gmail.com>
References: <1364874877-5618-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add CONFIG_LIBC as well. It is only used to determine if lack of elf
support is due to support missing for libc or libelf.

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
 tools/perf/Makefile |  103 +++++++++++++++++++++++----------------------------
 tools/perf/Pconfig  |    7 ++++
 2 files changed, 54 insertions(+), 56 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 0060275..9bb12b5 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -36,8 +36,6 @@ include config/utilities.mak
 #
 # Define NO_DEMANGLE if you do not want C++ symbol demangling.
 #
-# Define NO_LIBELF if you do not want libelf dependency (e.g. cross-builds)
-#
 # Define NO_LIBUNWIND if you do not want libunwind dependency for dwarf
 # backtrace post unwind.
 #
@@ -545,30 +543,22 @@ ifneq ($(MAKECMDGOALS),tags)
 # because maintaining the nesting to match is a pain.  If
 # we had "elif" things would have been much nicer...
 
-ifdef NO_LIBELF
-	NO_DWARF := 1
-	NO_DEMANGLE := 1
-	NO_LIBUNWIND := 1
-else
-FLAGS_LIBELF=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS)
-ifneq ($(call try-cc,$(SOURCE_LIBELF),$(FLAGS_LIBELF),libelf),y)
-	FLAGS_GLIBC=$(ALL_CFLAGS) $(ALL_LDFLAGS)
-	ifeq ($(call try-cc,$(SOURCE_GLIBC),$(FLAGS_GLIBC),glibc),y)
-		LIBC_SUPPORT := 1
-	endif
-	ifeq ($(BIONIC),1)
-		LIBC_SUPPORT := 1
-	endif
-	ifeq ($(LIBC_SUPPORT),1)
-		msg := $(warning No libelf found, disables 'probe' tool, please install elfutils-libelf-devel/libelf-dev);
+ifdef CONFIG_LIBELF
+    FLAGS_LIBELF=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS)
+
+    # try to compile with libelf support ...
+    ifneq ($(call try-cc,$(SOURCE_LIBELF),$(FLAGS_LIBELF),libelf),y)
+        FLAGS_GLIBC=$(ALL_CFLAGS) $(ALL_LDFLAGS)
+        # ... it failed. Is the failure due to missing libc or libelf
+        # development support?
+        ifneq ($(call try-cc,$(SOURCE_GLIBC),$(FLAGS_GLIBC),glibc),y)
+            $(error No gnu/libc-version.h found, please install glibc-dev[el]/glibc-static or disable CONFIG_LIBC)
+        endif
+
+        # libelf not installed
+        $(error No libelf found, please install elfutils-libelf-devel/libelf-dev or disable CONFIG_LIBELF);
+    endif
 
-		NO_LIBELF := 1
-		NO_DWARF := 1
-		NO_DEMANGLE := 1
-	else
-		msg := $(error No gnu/libc-version.h found, please install glibc-dev[el]/glibc-static);
-	endif
-else
 	# for linking with debug library, run like:
 	# make DEBUG=1 LIBDW_DIR=/opt/libdw/
 	ifdef LIBDW_DIR
@@ -576,13 +566,17 @@ else
 		LIBDW_LDFLAGS := -L$(LIBDW_DIR)/lib
 	endif
 
+    # libelf supported - what about dwarf?
 	FLAGS_DWARF=$(ALL_CFLAGS) $(LIBDW_CFLAGS) -ldw -lelf $(LIBDW_LDFLAGS) $(ALL_LDFLAGS) $(EXTLIBS)
 	ifneq ($(call try-cc,$(SOURCE_DWARF),$(FLAGS_DWARF),libdw),y)
 		msg := $(warning No libdw.h found or old libdw.h found or elfutils is older than 0.138, disables dwarf support. Please install new elfutils-devel/libdw-dev);
 		NO_DWARF := 1
-	endif # Dwarf support
-endif # SOURCE_LIBELF
-endif # NO_LIBELF
+	endif
+else
+    NO_DWARF := 1
+    NO_DEMANGLE := 1
+    NO_LIBUNWIND := 1
+endif
 
 # There's only x86 (both 32 and 64) support for CFI unwind so far
 ifneq ($(ARCH),x86)
@@ -610,41 +604,38 @@ ifneq ($(OUTPUT),)
 	BASIC_CFLAGS += -I$(OUTPUT)
 endif
 
-ifdef NO_LIBELF
-EXTLIBS := $(filter-out -lelf,$(EXTLIBS))
+ifdef CONFIG_LIBELF
+    BASIC_CFLAGS += -DLIBELF_SUPPORT
 
-# Remove ELF/DWARF dependent codes
-LIB_OBJS := $(filter-out $(OUTPUT)util/symbol-elf.o,$(LIB_OBJS))
-LIB_OBJS := $(filter-out $(OUTPUT)util/dwarf-aux.o,$(LIB_OBJS))
-LIB_OBJS := $(filter-out $(OUTPUT)util/probe-event.o,$(LIB_OBJS))
-LIB_OBJS := $(filter-out $(OUTPUT)util/probe-finder.o,$(LIB_OBJS))
+    FLAGS_LIBELF=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS)
+    ifeq ($(call try-cc,$(SOURCE_ELF_MMAP),$(FLAGS_LIBELF),-DLIBELF_MMAP),y)
+	    BASIC_CFLAGS += -DLIBELF_MMAP
+    endif
 
-BUILTIN_OBJS := $(filter-out $(OUTPUT)builtin-probe.o,$(BUILTIN_OBJS))
+    ifndef NO_DWARF
+        ifeq ($(origin PERF_HAVE_DWARF_REGS), undefined)
+	        msg := $(warning DWARF register mappings have not been defined for architecture $(ARCH), DWARF support disabled);
+        else
+            BASIC_CFLAGS := -DDWARF_SUPPORT $(LIBDW_CFLAGS) $(BASIC_CFLAGS)
+            BASIC_LDFLAGS := $(LIBDW_LDFLAGS) $(BASIC_LDFLAGS)
+            EXTLIBS += -lelf -ldw
+            LIB_OBJS += $(OUTPUT)util/probe-finder.o
+            LIB_OBJS += $(OUTPUT)util/dwarf-aux.o
+        endif # PERF_HAVE_DWARF_REGS
+    endif # NO_DWARF
 
-# Use minimal symbol handling
-LIB_OBJS += $(OUTPUT)util/symbol-minimal.o
+else
+    EXTLIBS := $(filter-out -lelf,$(EXTLIBS))
 
-else # NO_LIBELF
-BASIC_CFLAGS += -DLIBELF_SUPPORT
+    # Remove ELF/DWARF dependent codes
+    LIB_OBJS := $(filter-out $(OUTPUT)util/symbol-elf.o,$(LIB_OBJS))
+    LIB_OBJS := $(filter-out $(OUTPUT)util/probe-event.o,$(LIB_OBJS))
+    BUILTIN_OBJS := $(filter-out $(OUTPUT)builtin-probe.o,$(BUILTIN_OBJS))
 
-FLAGS_LIBELF=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS)
-ifeq ($(call try-cc,$(SOURCE_ELF_MMAP),$(FLAGS_LIBELF),-DLIBELF_MMAP),y)
-	BASIC_CFLAGS += -DLIBELF_MMAP
+    # Use minimal symbol handling
+    LIB_OBJS += $(OUTPUT)util/symbol-minimal.o
 endif
 
-ifndef NO_DWARF
-ifeq ($(origin PERF_HAVE_DWARF_REGS), undefined)
-	msg := $(warning DWARF register mappings have not been defined for architecture $(ARCH), DWARF support disabled);
-else
-	BASIC_CFLAGS := -DDWARF_SUPPORT $(LIBDW_CFLAGS) $(BASIC_CFLAGS)
-	BASIC_LDFLAGS := $(LIBDW_LDFLAGS) $(BASIC_LDFLAGS)
-	EXTLIBS += -lelf -ldw
-	LIB_OBJS += $(OUTPUT)util/probe-finder.o
-	LIB_OBJS += $(OUTPUT)util/dwarf-aux.o
-endif # PERF_HAVE_DWARF_REGS
-endif # NO_DWARF
-endif # NO_LIBELF
-
 ifndef NO_LIBUNWIND
 	BASIC_CFLAGS += -DLIBUNWIND_SUPPORT
 	EXTLIBS += $(LIBUNWIND_LIBS)
diff --git a/tools/perf/Pconfig b/tools/perf/Pconfig
index 367cc65..334674c 100644
--- a/tools/perf/Pconfig
+++ b/tools/perf/Pconfig
@@ -4,6 +4,13 @@ config NEWT
 config GTK2
     bool "Enable GTK-based UI"
 
+config LIBC
+    bool "Development support for libc is available - glibc or bionic"
+
+config LIBELF
+    bool "Enable support for libelf"
+    depends on LIBC
+
 config LIBPERL
     bool "Enable support for perl scripting engine"
 
-- 
1.7.10.1

