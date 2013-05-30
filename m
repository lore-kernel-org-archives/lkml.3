Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935375Ab3E3QE2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 12:04:28 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51173 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935164Ab3E3QDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 12:03:17 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Sam Ravnborg <sam@ravnborg.org>, Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 61/66] perf tools: Switch to full path C include directories
Date: Thu, 30 May 2013 19:01:34 +0300
Message-Id: <1369929699-8724-62-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1369929699-8724-1-git-send-email-acme@infradead.org>
References: <1369929699-8724-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Switching to full path C include directories, to make the includes
clear. Plus little include cleanup.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1369398928-9809-21-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile        |  4 ++--
 tools/perf/config/Makefile | 49 ++++++++++++++++++++++++++++++++++------------
 2 files changed, 39 insertions(+), 14 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 1a3557c..4275ddc 100644
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
1.8.1.4

