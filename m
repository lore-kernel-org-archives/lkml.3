Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754872Ab3I3LT6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 07:19:58 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:51773 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753815Ab3I3LTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 07:19:54 -0400
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jiri Olsa <jolsa@redhat.com>, Michael Witten <mfwitten@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 1/2] perf tool: simplify ARCH code in Makefile
Date: Mon, 30 Sep 2013 16:43:04 +0530
Message-Id: <1380539585-23859-2-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.4.477.g5d89aa9
In-Reply-To: <1380539585-23859-1-git-send-email-artagnon@gmail.com>
References: <1380539585-23859-1-git-send-email-artagnon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ARCH is first determined from `uname -m`, and then overridden to x86
anyway. This is unnecessarily ugly; follow the example set by
ffee0de (x86: Default to ARCH=x86 to avoid overriding CONFIG_64BIT,
2012-12-20) to simplify the code.

Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Michael Witten <mfwitten@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
---
 tools/perf/config/Makefile | 47 ++++++++++++++++++++++------------------------
 1 file changed, 22 insertions(+), 25 deletions(-)

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 5f6f9b3..45a8515 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -1,33 +1,30 @@
-uname_M := $(shell uname -m 2>/dev/null || echo not)
-
-ARCH ?= $(shell echo $(uname_M) | sed -e s/i.86/i386/ -e s/sun4u/sparc64/ \
-                                  -e s/arm.*/arm/ -e s/sa110/arm/ \
-                                  -e s/s390x/s390/ -e s/parisc64/parisc/ \
-                                  -e s/ppc.*/powerpc/ -e s/mips.*/mips/ \
-                                  -e s/sh[234].*/sh/ -e s/aarch64.*/arm64/ )
+ARCH ?= $(shell uname -m | sed -e s/i.86/x86/ -e s/x86_64/x86/ \
+                               -e s/sun4u/sparc64/ \
+                               -e s/arm.*/arm/ -e s/sa110/arm/ \
+                               -e s/s390x/s390/ -e s/parisc64/parisc/ \
+                               -e s/ppc.*/powerpc/ -e s/mips.*/mips/ \
+                               -e s/sh[234].*/sh/ -e s/aarch64.*/arm64/ )
 NO_PERF_REGS := 1
 CFLAGS := $(EXTRA_CFLAGS) $(EXTRA_WARNINGS)
 
 # Additional ARCH settings for x86
-ifeq ($(ARCH),i386)
-  override ARCH := x86
-  NO_PERF_REGS := 0
-  LIBUNWIND_LIBS = -lunwind -lunwind-x86
-endif
-
-ifeq ($(ARCH),x86_64)
-  override ARCH := x86
-  IS_X86_64 := 0
-  ifeq (, $(findstring m32,$(CFLAGS)))
-    IS_X86_64 := $(shell echo __x86_64__ | ${CC} -E -x c - | tail -n 1)
-  endif
-  ifeq (${IS_X86_64}, 1)
-    RAW_ARCH := x86_64
-    CFLAGS += -DARCH_X86_64
-    ARCH_INCLUDE = ../../arch/x86/lib/memcpy_64.S ../../arch/x86/lib/memset_64.S
+ifeq ($(ARCH),x86)
+  ifeq ($(shell uname -m),x86_64)
+    IS_X86_64 := 0
+    ifeq (, $(findstring m32,$(CFLAGS)))
+      IS_X86_64 := $(shell echo __x86_64__ | ${CC} -E -x c - | tail -n 1)
+    endif
+    ifeq (${IS_X86_64}, 1)
+      RAW_ARCH := x86_64
+      CFLAGS += -DARCH_X86_64
+      ARCH_INCLUDE = ../../arch/x86/lib/memcpy_64.S ../../arch/x86/lib/memset_64.S
+    endif
+    NO_PERF_REGS := 0
+    LIBUNWIND_LIBS = -lunwind -lunwind-x86_64
+  else
+    NO_PERF_REGS := 0
+    LIBUNWIND_LIBS = -lunwind -lunwind-x86
   endif
-  NO_PERF_REGS := 0
-  LIBUNWIND_LIBS = -lunwind -lunwind-x86_64
 endif
 
 ifeq ($(NO_PERF_REGS),0)
-- 
1.8.4.477.g5d89aa9

