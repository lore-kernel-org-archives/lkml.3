Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756372Ab3EaMdR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 08:33:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57721 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755089Ab3EaMdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 08:33:06 -0400
Date: Fri, 31 May 2013 05:31:57 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-7c53746e6da21750760054ca9fd8797725e3842a@git.kernel.org>
Cc: acme@redhat.com, eranian@google.com, mingo@kernel.org, sam@ravnborg.org,
        a.p.zijlstra@chello.nl, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
        hpa@zytor.com, paulus@samba.org, linux-kernel@vger.kernel.org,
        bp@alien8.de, namhyung@kernel.org, mingo@elte.hu
Reply-To: mingo@kernel.org, eranian@google.com, acme@redhat.com,
        a.p.zijlstra@chello.nl, sam@ravnborg.org, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, bp@alien8.de, namhyung@kernel.org,
        mingo@elte.hu
In-Reply-To: <1369398928-9809-21-git-send-email-jolsa@redhat.com>
References: <1369398928-9809-21-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Switch to full path C include directories
Git-Commit-ID: 7c53746e6da21750760054ca9fd8797725e3842a
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

Commit-ID:  7c53746e6da21750760054ca9fd8797725e3842a
Gitweb:     http://git.kernel.org/tip/7c53746e6da21750760054ca9fd8797725e3842a
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Fri, 24 May 2013 14:35:23 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 30 May 2013 16:37:24 +0300

perf tools: Switch to full path C include directories

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
