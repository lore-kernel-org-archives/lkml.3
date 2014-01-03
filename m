Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752175AbaACOdK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 09:33:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61922 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752069AbaACOdB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 09:33:01 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 1/2] perf tools: Move arch setup into seprate Makefile
Date: Fri,  3 Jan 2014 15:32:32 +0100
Message-Id: <1388759553-12974-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "jolsa@redhat.com" <jolsa@redhat.com>

I need to use arch related setup in the tests/make,
so moving arch setup into Makefile.arch.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: David Ahern <dsahern@gmail.com>
---
 tools/perf/config/Makefile      | 52 ++++++++++++++---------------------------
 tools/perf/config/Makefile.arch | 22 +++++++++++++++++
 2 files changed, 40 insertions(+), 34 deletions(-)
 create mode 100644 tools/perf/config/Makefile.arch

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 14faeeb..f2bc659 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -1,28 +1,26 @@
-uname_M := $(shell uname -m 2>/dev/null || echo not)
 
-ARCH ?= $(shell echo $(uname_M) | sed -e s/i.86/i386/ -e s/sun4u/sparc64/ \
-                                  -e s/arm.*/arm/ -e s/sa110/arm/ \
-                                  -e s/s390x/s390/ -e s/parisc64/parisc/ \
-                                  -e s/ppc.*/powerpc/ -e s/mips.*/mips/ \
-                                  -e s/sh[234].*/sh/ -e s/aarch64.*/arm64/ )
-NO_PERF_REGS := 1
-CFLAGS := $(EXTRA_CFLAGS) $(EXTRA_WARNINGS)
+ifeq ($(src-perf),)
+src-perf := $(srctree)/tools/perf
+endif
 
-# Additional ARCH settings for x86
-ifeq ($(ARCH),i386)
-  override ARCH := x86
-  NO_PERF_REGS := 0
-  LIBUNWIND_LIBS = -lunwind -lunwind-x86
+ifeq ($(obj-perf),)
+obj-perf := $(OUTPUT)
 endif
 
-ifeq ($(ARCH),x86_64)
-  override ARCH := x86
-  IS_X86_64 := 0
-  ifeq (, $(findstring m32,$(CFLAGS)))
-    IS_X86_64 := $(shell echo __x86_64__ | ${CC} -E -x c - | tail -n 1)
-  endif
+ifneq ($(obj-perf),)
+obj-perf := $(abspath $(obj-perf))/
+endif
+
+LIB_INCLUDE := $(srctree)/tools/lib/
+CFLAGS := $(EXTRA_CFLAGS) $(EXTRA_WARNINGS)
+
+include $(src-perf)/config/Makefile.arch
+
+NO_PERF_REGS := 1
+
+# Additional ARCH settings for x86
+ifeq ($(ARCH),x86)
   ifeq (${IS_X86_64}, 1)
-    RAW_ARCH := x86_64
     CFLAGS += -DHAVE_ARCH_X86_64_SUPPORT
     ARCH_INCLUDE = ../../arch/x86/lib/memcpy_64.S ../../arch/x86/lib/memset_64.S
     LIBUNWIND_LIBS = -lunwind -lunwind-x86_64
@@ -64,20 +62,6 @@ ifeq ($(NO_PERF_REGS),0)
   CFLAGS += -DHAVE_PERF_REGS_SUPPORT
 endif
 
-ifeq ($(src-perf),)
-src-perf := $(srctree)/tools/perf
-endif
-
-ifeq ($(obj-perf),)
-obj-perf := $(OUTPUT)
-endif
-
-ifneq ($(obj-perf),)
-obj-perf := $(abspath $(obj-perf))/
-endif
-
-LIB_INCLUDE := $(srctree)/tools/lib/
-
 # include ARCH specific config
 -include $(src-perf)/arch/$(ARCH)/Makefile
 
diff --git a/tools/perf/config/Makefile.arch b/tools/perf/config/Makefile.arch
new file mode 100644
index 0000000..fef8ae9
--- /dev/null
+++ b/tools/perf/config/Makefile.arch
@@ -0,0 +1,22 @@
+
+uname_M := $(shell uname -m 2>/dev/null || echo not)
+
+ARCH ?= $(shell echo $(uname_M) | sed -e s/i.86/i386/ -e s/sun4u/sparc64/ \
+                                  -e s/arm.*/arm/ -e s/sa110/arm/ \
+                                  -e s/s390x/s390/ -e s/parisc64/parisc/ \
+                                  -e s/ppc.*/powerpc/ -e s/mips.*/mips/ \
+                                  -e s/sh[234].*/sh/ -e s/aarch64.*/arm64/ )
+
+# Additional ARCH settings for x86
+ifeq ($(ARCH),i386)
+  override ARCH := x86
+endif
+
+ifeq ($(ARCH),x86_64)
+  override ARCH := x86
+  IS_X86_64 := 0
+  ifeq (, $(findstring m32,$(CFLAGS)))
+    IS_X86_64 := $(shell echo __x86_64__ | ${CC} -E -x c - | tail -n 1)
+    RAW_ARCH := x86_64
+  endif
+endif
-- 
1.8.3.1

