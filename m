Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608Ab3E0P2D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 11:28:03 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:57022 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193Ab3E0P2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 11:28:01 -0400
From: Runzhen Wang <icycoder@gmail.com>
To: linux-kernel@vger.kernel.org, jolsa@redhat.com
Cc: acme@redhat.com, mingo@kernel.org, dsahern@gmail.com,
        Runzhen Wang <icycoder@gmail.com>,
        Runzhen Wang <runzhen@linux.vnet.ibm.com>
Subject: [PATCH] perf tools: fix an error introduced by commit 93cbb398
Date: Mon, 27 May 2013 23:27:35 +0800
Message-Id: <1369668455-6246-1-git-send-email-icycoder@gmail.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 0a720538e5dd3f424bfcc15c1e4af09df0becf92
and
commit 93cbb3985d5de867fb32e6e130fcfb1b5de4142b
move some contents of Makefile from perf/Makefile to
perf/config/Makefile.

However, that introduce the following error messages when compile perf:

util/unwind.c: In function ‘access_mem’:
util/unwind.c:400:50: error: ‘PERF_REG_SP’ undeclared (first use in this
function)
util/unwind.c:400:50: note: each undeclared identifier is reported only
once for each function it appears in
util/unwind.c: In function ‘unwind__get_entries’:
util/unwind.c:562:41: error: ‘PERF_REG_IP’ undeclared (first use in this
function)

That because the assignment statement of 'BASIC_CFLAGS' is behind
'BASIC_CFLAGS += -DHAVE_PERF_REGS', which will rewrite the value of
'BASIC_CFLAGS'.

Without the definition of 'HAVE_PERF_REGS', perf/util/perf_regs.h can't
include perf/arch/x86/include/perf_regs.h, that will cause the error.

The solution is to move the assignment statement of BASIC_CFLAGS ahead of
BASIC_CFLAGS += -DHAVE_PERF_REGS.

Signed-off-by: Runzhen Wang <runzhen@linux.vnet.ibm.com>
---
 tools/perf/config/Makefile |   33 +++++++++++++++++----------------
 1 file changed, 17 insertions(+), 16 deletions(-)

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 1f12a55..a8ec66f 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -5,6 +5,23 @@ ARCH ?= $(shell echo $(uname_M) | sed -e s/i.86/i386/ -e s/sun4u/sparc64/ \
 				  -e s/s390x/s390/ -e s/parisc64/parisc/ \
 				  -e s/ppc.*/powerpc/ -e s/mips.*/mips/ \
 				  -e s/sh[234].*/sh/ -e s/aarch64.*/arm64/ )
+
+BASIC_CFLAGS = \
+	-Iutil/include \
+	-Iarch/$(ARCH)/include \
+	$(if $(objtree),-I$(objtree)/arch/$(ARCH)/include/generated/uapi) \
+	-I$(srctree)/arch/$(ARCH)/include/uapi \
+	-I$(srctree)/arch/$(ARCH)/include \
+	$(if $(objtree),-I$(objtree)/include/generated/uapi) \
+	-I$(srctree)/include/uapi \
+	-I$(srctree)/include \
+	-I$(OUTPUT)util \
+	-Iutil \
+	-I. \
+	-I$(TRACE_EVENT_DIR) \
+	-I../lib/ \
+	-D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE
+
 NO_PERF_REGS := 1
 
 # Additional ARCH settings for x86
@@ -84,22 +101,6 @@ ifndef PERF_DEBUG
 	endif
 endif
 
-BASIC_CFLAGS = \
-	-Iutil/include \
-	-Iarch/$(ARCH)/include \
-	$(if $(objtree),-I$(objtree)/arch/$(ARCH)/include/generated/uapi) \
-	-I$(srctree)/arch/$(ARCH)/include/uapi \
-	-I$(srctree)/arch/$(ARCH)/include \
-	$(if $(objtree),-I$(objtree)/include/generated/uapi) \
-	-I$(srctree)/include/uapi \
-	-I$(srctree)/include \
-	-I$(OUTPUT)util \
-	-Iutil \
-	-I. \
-	-I$(TRACE_EVENT_DIR) \
-	-I../lib/ \
-	-D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE
-
 BASIC_LDFLAGS =
 
 ifeq ($(call try-cc,$(SOURCE_BIONIC),$(CFLAGS),bionic),y)
-- 
1.7.9.5

