Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757660AbaISFTm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 01:19:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52849 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753AbaISFTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 01:19:40 -0400
Date: Thu, 18 Sep 2014 22:19:09 -0700
From: tip-bot for Anton Blanchard <tipbot@zytor.com>
Message-ID: <tip-65ccb4faae872b63dd8f5fbc83d0195e3dfabf0d@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, anton@samba.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, mpe@ellerman.id.au, sukadev@linux.vnet.ibm.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, anton@samba.org, mingo@redhat.com,
        paulus@samba.org, linux-kernel@vger.kernel.org, acme@redhat.com,
        a.p.zijlstra@chello.nl, mpe@ellerman.id.au, tglx@linutronix.de,
        sukadev@linux.vnet.ibm.com
In-Reply-To: <20140825182506.2be6512d@kryten>
References: <20140825182506.2be6512d@kryten>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools powerpc:
  Fix build issue when DWARF support is disabled
Git-Commit-ID: 65ccb4faae872b63dd8f5fbc83d0195e3dfabf0d
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

Commit-ID:  65ccb4faae872b63dd8f5fbc83d0195e3dfabf0d
Gitweb:     http://git.kernel.org/tip/65ccb4faae872b63dd8f5fbc83d0195e3dfabf0d
Author:     Anton Blanchard <anton@samba.org>
AuthorDate: Mon, 25 Aug 2014 18:25:06 +1000
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 17 Sep 2014 17:08:07 -0300

perf tools powerpc: Fix build issue when DWARF support is disabled

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
index b92219b..6f7782b 100644
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
index 75d4c23..98c9fd1 100644
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
