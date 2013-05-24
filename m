Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754881Ab3EXMgP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 08:36:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22145 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754717Ab3EXMgN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 08:36:13 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Borislav Petkov <bp@alien8.de>,
        Stephane Eranian <eranian@google.com>, Sam Ravnborg <sam@ravnborg.org>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 05/25] perf tools: Move libelf check config into config/Makefile
Date: Fri, 24 May 2013 14:35:08 +0200
Message-Id: <1369398928-9809-6-git-send-email-jolsa@redhat.com>
In-Reply-To: <1369398928-9809-1-git-send-email-jolsa@redhat.com>
References: <1369398928-9809-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moving libelf check config into config/Makefile.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Stephane Eranian <eranian@google.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: David Ahern <dsahern@gmail.com>
---
 tools/perf/Makefile        | 46 ---------------------------------------------
 tools/perf/config/Makefile | 47 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 47 insertions(+), 46 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index aa6f933..a174c68 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -473,45 +473,6 @@ ifneq ($(MAKECMDGOALS),tags)
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
-
-		NO_LIBELF := 1
-		NO_DWARF := 1
-		NO_DEMANGLE := 1
-	else
-		msg := $(error No gnu/libc-version.h found, please install glibc-dev[el]/glibc-static);
-	endif
-else
-	# for linking with debug library, run like:
-	# make DEBUG=1 LIBDW_DIR=/opt/libdw/
-	ifdef LIBDW_DIR
-		LIBDW_CFLAGS  := -I$(LIBDW_DIR)/include
-		LIBDW_LDFLAGS := -L$(LIBDW_DIR)/lib
-	endif
-
-	FLAGS_DWARF=$(ALL_CFLAGS) $(LIBDW_CFLAGS) -ldw -lelf $(LIBDW_LDFLAGS) $(ALL_LDFLAGS) $(EXTLIBS)
-	ifneq ($(call try-cc,$(SOURCE_DWARF),$(FLAGS_DWARF),libdw),y)
-		msg := $(warning No libdw.h found or old libdw.h found or elfutils is older than 0.138, disables dwarf support. Please install new elfutils-devel/libdw-dev);
-		NO_DWARF := 1
-	endif # Dwarf support
-endif # SOURCE_LIBELF
-endif # NO_LIBELF
-
 # There's only x86 (both 32 and 64) support for CFI unwind so far
 ifneq ($(ARCH),x86)
 	NO_LIBUNWIND := 1
@@ -553,13 +514,6 @@ BUILTIN_OBJS := $(filter-out $(OUTPUT)builtin-probe.o,$(BUILTIN_OBJS))
 LIB_OBJS += $(OUTPUT)util/symbol-minimal.o
 
 else # NO_LIBELF
-BASIC_CFLAGS += -DLIBELF_SUPPORT
-
-FLAGS_LIBELF=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS)
-ifeq ($(call try-cc,$(SOURCE_ELF_MMAP),$(FLAGS_LIBELF),-DLIBELF_MMAP),y)
-	BASIC_CFLAGS += -DLIBELF_MMAP
-endif
-
 ifndef NO_DWARF
 ifeq ($(origin PERF_HAVE_DWARF_REGS), undefined)
 	msg := $(warning DWARF register mappings have not been defined for architecture $(ARCH), DWARF support disabled);
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 9ce522a..ef09d6c 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -108,3 +108,50 @@ ifeq ($(call try-cc,$(SOURCE_BIONIC),$(CFLAGS),bionic),y)
 	EXTLIBS := $(filter-out -lpthread,$(EXTLIBS))
 	BASIC_CFLAGS += -I.
 endif
+
+ifdef NO_LIBELF
+	NO_DWARF := 1
+	NO_DEMANGLE := 1
+	NO_LIBUNWIND := 1
+else
+FLAGS_LIBELF=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS)
+ifneq ($(call try-cc,$(SOURCE_LIBELF),$(FLAGS_LIBELF),libelf),y)
+	FLAGS_GLIBC=$(ALL_CFLAGS) $(ALL_LDFLAGS)
+	ifeq ($(call try-cc,$(SOURCE_GLIBC),$(FLAGS_GLIBC),glibc),y)
+		LIBC_SUPPORT := 1
+	endif
+	ifeq ($(BIONIC),1)
+		LIBC_SUPPORT := 1
+	endif
+	ifeq ($(LIBC_SUPPORT),1)
+		msg := $(warning No libelf found, disables 'probe' tool, please install elfutils-libelf-devel/libelf-dev);
+
+		NO_LIBELF := 1
+		NO_DWARF := 1
+		NO_DEMANGLE := 1
+	else
+		msg := $(error No gnu/libc-version.h found, please install glibc-dev[el]/glibc-static);
+	endif
+else
+	# for linking with debug library, run like:
+	# make DEBUG=1 LIBDW_DIR=/opt/libdw/
+	ifdef LIBDW_DIR
+		LIBDW_CFLAGS  := -I$(LIBDW_DIR)/include
+		LIBDW_LDFLAGS := -L$(LIBDW_DIR)/lib
+	endif
+
+	FLAGS_DWARF=$(ALL_CFLAGS) $(LIBDW_CFLAGS) -ldw -lelf $(LIBDW_LDFLAGS) $(ALL_LDFLAGS) $(EXTLIBS)
+	ifneq ($(call try-cc,$(SOURCE_DWARF),$(FLAGS_DWARF),libdw),y)
+		msg := $(warning No libdw.h found or old libdw.h found or elfutils is older than 0.138, disables dwarf support. Please install new elfutils-devel/libdw-dev);
+		NO_DWARF := 1
+	endif # Dwarf support
+endif # SOURCE_LIBELF
+endif # NO_LIBELF
+
+ifndef NO_LIBELF
+BASIC_CFLAGS += -DLIBELF_SUPPORT
+FLAGS_LIBELF=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS)
+ifeq ($(call try-cc,$(SOURCE_ELF_MMAP),$(FLAGS_LIBELF),-DLIBELF_MMAP),y)
+	BASIC_CFLAGS += -DLIBELF_MMAP
+endif
+endif # NO_LIBELF
-- 
1.7.11.7

