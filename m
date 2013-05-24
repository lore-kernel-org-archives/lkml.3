Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755524Ab3EXMll (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 08:41:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29134 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755240Ab3EXMgi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 08:36:38 -0400
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
Subject: [PATCH 02/25] perf tools: Move arch check into config/Makefile
Date: Fri, 24 May 2013 14:35:05 +0200
Message-Id: <1369398928-9809-3-git-send-email-jolsa@redhat.com>
In-Reply-To: <1369398928-9809-1-git-send-email-jolsa@redhat.com>
References: <1369398928-9809-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moving arch check into config/Makefile.

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
 tools/perf/Makefile        | 41 +++++++++++++----------------------------
 tools/perf/config/Makefile | 34 ++++++++++++++++++++++++++++++++++
 2 files changed, 47 insertions(+), 28 deletions(-)
 create mode 100644 tools/perf/config/Makefile

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index c8fb0fd..10b4c7e 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -55,37 +55,23 @@ include config/utilities.mak
 $(OUTPUT)PERF-VERSION-FILE: .FORCE-PERF-VERSION-FILE
 	@$(SHELL_PATH) util/PERF-VERSION-GEN $(OUTPUT)
 
-uname_M := $(shell uname -m 2>/dev/null || echo not)
-
-ARCH ?= $(shell echo $(uname_M) | sed -e s/i.86/i386/ -e s/sun4u/sparc64/ \
-				  -e s/arm.*/arm/ -e s/sa110/arm/ \
-				  -e s/s390x/s390/ -e s/parisc64/parisc/ \
-				  -e s/ppc.*/powerpc/ -e s/mips.*/mips/ \
-				  -e s/sh[234].*/sh/ -e s/aarch64.*/arm64/ )
-NO_PERF_REGS := 1
-
 CC = $(CROSS_COMPILE)gcc
 AR = $(CROSS_COMPILE)ar
 
-# Additional ARCH settings for x86
-ifeq ($(ARCH),i386)
-	override ARCH := x86
-	NO_PERF_REGS := 0
-	LIBUNWIND_LIBS = -lunwind -lunwind-x86
+# include config/Makefile by default and rule out
+# non-config cases
+config := 1
+
+NON_CONFIG_TARGETS := clean TAGS tags cscope help
+
+ifdef MAKECMDGOALS
+ifeq ($(filter-out $(NON_CONFIG_TARGETS),$(MAKECMDGOALS)),)
+  config := 0
 endif
-ifeq ($(ARCH),x86_64)
-	override ARCH := x86
-	IS_X86_64 := 0
-	ifeq (, $(findstring m32,$(EXTRA_CFLAGS)))
-		IS_X86_64 := $(shell echo __x86_64__ | ${CC} -E -x c - | tail -n 1)
-	endif
-	ifeq (${IS_X86_64}, 1)
-		RAW_ARCH := x86_64
-		ARCH_CFLAGS := -DARCH_X86_64
-		ARCH_INCLUDE = ../../arch/x86/lib/memcpy_64.S ../../arch/x86/lib/memset_64.S
-	endif
-	NO_PERF_REGS := 0
-	LIBUNWIND_LIBS = -lunwind -lunwind-x86_64
+endif
+
+ifeq ($(config),1)
+include config/Makefile
 endif
 
 # Treat warnings as errors unless directed not to
@@ -857,7 +843,6 @@ ifeq ($(NO_PERF_REGS),0)
 	ifeq ($(ARCH),x86)
 		LIB_H += arch/x86/include/perf_regs.h
 	endif
-	BASIC_CFLAGS += -DHAVE_PERF_REGS
 endif
 
 ifndef NO_STRLCPY
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
new file mode 100644
index 0000000..fe317c2
--- /dev/null
+++ b/tools/perf/config/Makefile
@@ -0,0 +1,34 @@
+uname_M := $(shell uname -m 2>/dev/null || echo not)
+
+ARCH ?= $(shell echo $(uname_M) | sed -e s/i.86/i386/ -e s/sun4u/sparc64/ \
+				  -e s/arm.*/arm/ -e s/sa110/arm/ \
+				  -e s/s390x/s390/ -e s/parisc64/parisc/ \
+				  -e s/ppc.*/powerpc/ -e s/mips.*/mips/ \
+				  -e s/sh[234].*/sh/ -e s/aarch64.*/arm64/ )
+NO_PERF_REGS := 1
+
+# Additional ARCH settings for x86
+ifeq ($(ARCH),i386)
+	override ARCH := x86
+	NO_PERF_REGS := 0
+	LIBUNWIND_LIBS = -lunwind -lunwind-x86
+endif
+
+ifeq ($(ARCH),x86_64)
+	override ARCH := x86
+	IS_X86_64 := 0
+	ifeq (, $(findstring m32,$(EXTRA_CFLAGS)))
+		IS_X86_64 := $(shell echo __x86_64__ | ${CC} -E -x c - | tail -n 1)
+	endif
+	ifeq (${IS_X86_64}, 1)
+		RAW_ARCH := x86_64
+		ARCH_CFLAGS := -DARCH_X86_64
+		ARCH_INCLUDE = ../../arch/x86/lib/memcpy_64.S ../../arch/x86/lib/memset_64.S
+	endif
+	NO_PERF_REGS := 0
+	LIBUNWIND_LIBS = -lunwind -lunwind-x86_64
+endif
+
+ifeq ($(NO_PERF_REGS),0)
+        BASIC_CFLAGS += -DHAVE_PERF_REGS
+endif
-- 
1.7.11.7

