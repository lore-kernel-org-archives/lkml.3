Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755956Ab3EXMiD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 08:38:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11435 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755504Ab3EXMiA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 08:38:00 -0400
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
Subject: [PATCH 20/25] perf tools: Switch to full path C include directories
Date: Fri, 24 May 2013 14:35:23 +0200
Message-Id: <1369398928-9809-21-git-send-email-jolsa@redhat.com>
In-Reply-To: <1369398928-9809-1-git-send-email-jolsa@redhat.com>
References: <1369398928-9809-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Switching to full path C include directories, to make
the includes clear. Plus little include cleanup.

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
 tools/perf/Makefile        |  4 ++--
 tools/perf/config/Makefile | 49 ++++++++++++++++++++++++++++++++++------------
 2 files changed, 39 insertions(+), 14 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 0a74f14..87c70e8 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -80,8 +80,8 @@ FLEX    = flex
 BISON   = bison
 STRIP  ?= strip
 
-LK_DIR = ../lib/lk/
-TRACE_EVENT_DIR = ../lib/traceevent/
+LK_DIR          = $(srctree)/tools/lib/lk/
+TRACE_EVENT_DIR = $(srctree)/tools/lib/traceevent/
 
 # include config/Makefile by default and rule out
 # non-config cases
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index c6e4902..8762209 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -34,7 +34,23 @@ ifeq ($(NO_PERF_REGS),0)
         CFLAGS += -DHAVE_PERF_REGS
 endif
 
--include config/feature-tests.mak
+ifeq ($(src-perf),)
+src-perf := $(srctree)/tools/perf
+endif
+
+ifeq ($(obj-perf),)
+obj-perf := $(objtree)
+endif
+
+ifneq ($(obj-perf),)
+obj-perf := $(abspath $(obj-perf))/
+endif
+
+# include ARCH specific config
+-include $(src-perf)/arch/$(ARCH)/Makefile
+
+include $(src-perf)/config/feature-tests.mak
+include $(src-perf)/config/utilities.mak
 
 ifeq ($(call get-executable,$(FLEX)),)
 	dummy := $(error Error: $(FLEX) is missing on this system, please install it)
@@ -91,19 +107,28 @@ ifndef PERF_DEBUG
 endif
 
 CFLAGS += \
-	-Iutil/include \
-	-Iarch/$(ARCH)/include \
-	$(if $(objtree),-I$(objtree)/arch/$(ARCH)/include/generated/uapi) \
+	-I$(src-perf)/util/include \
+	-I$(src-perf)/arch/$(ARCH)/include \
 	-I$(srctree)/arch/$(ARCH)/include/uapi \
 	-I$(srctree)/arch/$(ARCH)/include \
-	$(if $(objtree),-I$(objtree)/include/generated/uapi) \
 	-I$(srctree)/include/uapi \
-	-I$(srctree)/include \
-	-I$(OUTPUT)util \
-	-Iutil \
-	-I. \
+	-I$(srctree)/include
+
+# $(obj-perf)      for generated common-cmds.h
+# $(obj-perf)/util for generated bison/flex headers
+ifneq ($(OUTPUT),)
+CFLAGS += \
+	-I$(obj-perf)/util \
+	-I$(obj-perf)
+endif
+
+CFLAGS += \
+	-I$(src-perf)/util \
+	-I$(src-perf) \
 	-I$(TRACE_EVENT_DIR) \
-	-I../lib/ \
+	-I$(srctree)/tools/lib/
+
+CFLAGS += \
 	-D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE
 
 ifeq ($(call try-cc,$(SOURCE_BIONIC),$(CFLAGS),bionic),y)
@@ -159,7 +184,7 @@ ifeq ($(call try-cc,$(SOURCE_ELF_MMAP),$(FLAGS_LIBELF),-DLIBELF_MMAP),y)
 endif
 
 # include ARCH specific config
--include arch/$(ARCH)/Makefile
+-include $(src-perf)/arch/$(ARCH)/Makefile
 
 ifndef NO_DWARF
 ifeq ($(origin PERF_HAVE_DWARF_REGS), undefined)
@@ -329,7 +354,7 @@ else
         else
           LDFLAGS += $(PYTHON_EMBED_LDFLAGS)
           EXTLIBS += $(PYTHON_EMBED_LIBADD)
-          LANG_BINDINGS += $(OUTPUT)python/perf.so
+          LANG_BINDINGS += $(obj-perf)python/perf.so
         endif
       endif
     endif
-- 
1.7.11.7

