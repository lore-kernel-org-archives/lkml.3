Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755752Ab3EaL4g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 07:56:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57054 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755087Ab3EaL43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 07:56:29 -0400
Date: Fri, 31 May 2013 04:55:55 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-8bd407b962e39f34d5df08de8cd02d0f5add802b@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org, sam@ravnborg.org,
        a.p.zijlstra@chello.nl, namhyung@kernel.org, bp@alien8.de,
        jolsa@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        a.p.zijlstra@chello.nl, sam@ravnborg.org, bp@alien8.de,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1369398928-9809-3-git-send-email-jolsa@redhat.com>
References: <1369398928-9809-3-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Move arch check into config/Makefile
Git-Commit-ID: 8bd407b962e39f34d5df08de8cd02d0f5add802b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8bd407b962e39f34d5df08de8cd02d0f5add802b
Gitweb:     http://git.kernel.org/tip/8bd407b962e39f34d5df08de8cd02d0f5add802b
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Fri, 15 Mar 2013 16:28:49 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 28 May 2013 16:24:05 +0300

perf tools: Move arch check into config/Makefile

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
