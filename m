Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754981AbaIHVSc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 17:18:32 -0400
Received: from mail.kernel.org ([198.145.19.201]:39037 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754619AbaIHVS3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 17:18:29 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Anton Blanchard <anton@samba.org>,
        Ingo Molnar <mingo@redhat.com>, Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 02/13] perf tools powerpc: Fix build issue when DWARF support is disabled
Date: Mon,  8 Sep 2014 18:17:58 -0300
Message-Id: <1410211089-28668-3-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1410211089-28668-1-git-send-email-acme@kernel.org>
References: <1410211089-28668-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anton Blanchard <anton@samba.org>

The powerpc skip callchain code uses DWARF, so we must disable it if
DWARF is disabled.

Signed-off-by: Anton Blanchard <anton@samba.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/20140825182506.2be6512d@kryten
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/arch/powerpc/Makefile |  2 +-
 tools/perf/config/Makefile       | 10 ++++++----
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/tools/perf/arch/powerpc/Makefile b/tools/perf/arch/powerpc/Makefile
index b92219b1900d..6f7782bea5dd 100644
--- a/tools/perf/arch/powerpc/Makefile
+++ b/tools/perf/arch/powerpc/Makefile
@@ -1,6 +1,6 @@
 ifndef NO_DWARF
 PERF_HAVE_DWARF_REGS := 1
 LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/dwarf-regs.o
+LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/skip-callchain-idx.o
 endif
 LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/header.o
-LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/skip-callchain-idx.o
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 75d4c237b03d..98c9fd174e98 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -48,10 +48,6 @@ ifneq ($(ARCH),$(filter $(ARCH),x86 arm))
   NO_LIBDW_DWARF_UNWIND := 1
 endif
 
-ifeq ($(ARCH),powerpc)
-  CFLAGS += -DHAVE_SKIP_CALLCHAIN_IDX
-endif
-
 ifeq ($(LIBUNWIND_LIBS),)
   NO_LIBUNWIND := 1
 else
@@ -378,6 +374,12 @@ ifndef NO_LIBELF
   endif # NO_DWARF
 endif # NO_LIBELF
 
+ifeq ($(ARCH),powerpc)
+  ifndef NO_DWARF
+    CFLAGS += -DHAVE_SKIP_CALLCHAIN_IDX
+  endif
+endif
+
 ifndef NO_LIBUNWIND
   ifneq ($(feature-libunwind), 1)
     msg := $(warning No libunwind found. Please install libunwind-dev[el] >= 1.1 and/or set LIBUNWIND_DIR);
-- 
1.9.3

