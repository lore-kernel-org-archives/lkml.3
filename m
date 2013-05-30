Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935400Ab3E3QLW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 12:11:22 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51036 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934508Ab3E3QCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 12:02:24 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Sam Ravnborg <sam@ravnborg.org>, Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 34/66] perf tools: Move arch check into config/Makefile
Date: Thu, 30 May 2013 19:01:07 +0300
Message-Id: <1369929699-8724-35-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1369929699-8724-1-git-send-email-acme@infradead.org>
References: <1369929699-8724-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Moving arch check into config/Makefile.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1369398928-9809-3-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile        | 43 ++++++++++++++-----------------------------
 tools/perf/config/Makefile | 34 ++++++++++++++++++++++++++++++++++
 2 files changed, 48 insertions(+), 29 deletions(-)
 create mode 100644 tools/perf/config/Makefile

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index c8fb0fd..a4abdaf 100644
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
@@ -208,7 +194,7 @@ ifneq ($(OUTPUT),)
 #$(info Determined 'OUTPUT' to be $(OUTPUT))
 endif
 
-BASIC_CFLAGS = \
+BASIC_CFLAGS += \
 	-Iutil/include \
 	-Iarch/$(ARCH)/include \
 	$(if $(objtree),-I$(objtree)/arch/$(ARCH)/include/generated/uapi) \
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
1.8.1.4

