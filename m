Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756681Ab3EQTAu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 15:00:50 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:36766 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754754Ab3EQTAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 15:00:48 -0400
From: David Daney <ddaney.cavm@gmail.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org,
        Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        David Daney <david.daney@cavium.com>
Subject: [PATCH 2/2] perf tools: Hook up MIPS unwind and dwarf-regs in the Makefile
Date: Fri, 17 May 2013 12:00:38 -0700
Message-Id: <1368817238-11548-3-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1368817238-11548-1-git-send-email-ddaney.cavm@gmail.com>
References: <1368817238-11548-1-git-send-email-ddaney.cavm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

Define a new symbol (ARCH_SUPPORTS_LIBUNWIND) in config/Makefile.
Use this from x86 and MIPS to gate testing of libunwind.

Signed-off-by: David Daney <david.daney@cavium.com>
---
 tools/perf/config/Makefile | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index f139dcd..90a0e58 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -11,6 +11,7 @@ CFLAGS := $(EXTRA_CFLAGS) $(EXTRA_WARNINGS)
 # Additional ARCH settings for x86
 ifeq ($(ARCH),i386)
   override ARCH := x86
+  ARCH_SUPPORTS_LIBUNWIND := 1
   NO_PERF_REGS := 0
   LIBUNWIND_LIBS = -lunwind -lunwind-x86
 endif
@@ -26,10 +27,18 @@ ifeq ($(ARCH),x86_64)
     CFLAGS += -DARCH_X86_64
     ARCH_INCLUDE = ../../arch/x86/lib/memcpy_64.S ../../arch/x86/lib/memset_64.S
   endif
+  ARCH_SUPPORTS_LIBUNWIND := 1
   NO_PERF_REGS := 0
   LIBUNWIND_LIBS = -lunwind -lunwind-x86_64
 endif
 
+# Additional ARCH settings for MIPS
+ifeq ($(ARCH),mips)
+  ARCH_SUPPORTS_LIBUNWIND := 1
+  NO_PERF_REGS := 0
+  LIBUNWIND_LIBS = -lunwind -lunwind-mips
+endif
+
 ifeq ($(NO_PERF_REGS),0)
   CFLAGS += -DHAVE_PERF_REGS
 endif
@@ -204,8 +213,7 @@ ifeq ($(call try-cc,$(SOURCE_ELF_MMAP),$(FLAGS_LIBELF),-DLIBELF_MMAP),y)
 endif # try-cc
 endif # NO_LIBELF
 
-# There's only x86 (both 32 and 64) support for CFI unwind so far
-ifneq ($(ARCH),x86)
+ifndef ARCH_SUPPORTS_LIBUNWIND
   NO_LIBUNWIND := 1
 endif
 
-- 
1.7.11.7

