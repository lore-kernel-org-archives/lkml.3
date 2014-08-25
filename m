Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896AbaHYIZK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 04:25:10 -0400
Received: from ozlabs.org ([103.22.144.67]:47378 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754571AbaHYIZI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 04:25:08 -0400
Date: Mon, 25 Aug 2014 18:25:06 +1000
From: Anton Blanchard <anton@samba.org>
To: sukadev@linux.vnet.ibm.com, mpe@ellerman.id.au, acme@redhat.com,
        a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] perf powerpc: Fix build issue when DWARF support is
 disabled
Message-ID: <20140825182506.2be6512d@kryten>
In-Reply-To: <20140825182307.49774a04@kryten>
References: <20140825182307.49774a04@kryten>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The powerpc skip callchain code uses DWARF, so we must disable it if
DWARF is disabled.

Signed-off-by: Anton Blanchard <anton@samba.org>
---

Index: b/tools/perf/arch/powerpc/Makefile
===================================================================
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
Index: b/tools/perf/config/Makefile
===================================================================
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -48,10 +48,6 @@ ifneq ($(ARCH),$(filter $(ARCH),x86 arm)
   NO_LIBDW_DWARF_UNWIND := 1
 endif
 
-ifeq ($(ARCH),powerpc)
-  CFLAGS += -DHAVE_SKIP_CALLCHAIN_IDX
-endif
-
 ifeq ($(LIBUNWIND_LIBS),)
   NO_LIBUNWIND := 1
 else
@@ -355,6 +351,12 @@ ifndef NO_LIBELF
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
