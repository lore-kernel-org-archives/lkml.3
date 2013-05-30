Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935034Ab3E3QIQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 12:08:16 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51103 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934761Ab3E3QCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 12:02:31 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Sam Ravnborg <sam@ravnborg.org>, Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 39/66] perf tools: Move libunwind check config into config/Makefile
Date: Thu, 30 May 2013 19:01:12 +0300
Message-Id: <1369929699-8724-40-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1369929699-8724-1-git-send-email-acme@infradead.org>
References: <1369929699-8724-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Moving libunwind check config into config/Makefile.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1369398928-9809-8-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile        | 24 ------------------------
 tools/perf/config/Makefile | 27 +++++++++++++++++++++++++++
 2 files changed, 27 insertions(+), 24 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 51fac31..7dc6615 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -473,26 +473,6 @@ ifneq ($(MAKECMDGOALS),tags)
 # because maintaining the nesting to match is a pain.  If
 # we had "elif" things would have been much nicer...
 
-# There's only x86 (both 32 and 64) support for CFI unwind so far
-ifneq ($(ARCH),x86)
-	NO_LIBUNWIND := 1
-endif
-
-ifndef NO_LIBUNWIND
-# for linking with debug library, run like:
-# make DEBUG=1 LIBUNWIND_DIR=/opt/libunwind/
-ifdef LIBUNWIND_DIR
-	LIBUNWIND_CFLAGS  := -I$(LIBUNWIND_DIR)/include
-	LIBUNWIND_LDFLAGS := -L$(LIBUNWIND_DIR)/lib
-endif
-
-FLAGS_UNWIND=$(LIBUNWIND_CFLAGS) $(ALL_CFLAGS) $(LIBUNWIND_LDFLAGS) $(ALL_LDFLAGS) $(EXTLIBS) $(LIBUNWIND_LIBS)
-ifneq ($(call try-cc,$(SOURCE_LIBUNWIND),$(FLAGS_UNWIND),libunwind),y)
-	msg := $(warning No libunwind found, disabling post unwind support. Please install libunwind-dev[el] >= 0.99);
-	NO_LIBUNWIND := 1
-endif # Libunwind support
-endif # NO_LIBUNWIND
-
 -include arch/$(ARCH)/Makefile
 
 ifneq ($(OUTPUT),)
@@ -521,10 +501,6 @@ endif # NO_DWARF
 endif # NO_LIBELF
 
 ifndef NO_LIBUNWIND
-	BASIC_CFLAGS += -DLIBUNWIND_SUPPORT
-	EXTLIBS += $(LIBUNWIND_LIBS)
-	BASIC_CFLAGS := $(LIBUNWIND_CFLAGS) $(BASIC_CFLAGS)
-	BASIC_LDFLAGS := $(LIBUNWIND_LDFLAGS) $(BASIC_LDFLAGS)
 	LIB_OBJS += $(OUTPUT)util/unwind.o
 endif
 
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 71e737c..438574b 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -170,3 +170,30 @@ endif # PERF_HAVE_DWARF_REGS
 endif # NO_DWARF
 
 endif # NO_LIBELF
+
+# There's only x86 (both 32 and 64) support for CFI unwind so far
+ifneq ($(ARCH),x86)
+	NO_LIBUNWIND := 1
+endif
+
+ifndef NO_LIBUNWIND
+# for linking with debug library, run like:
+# make DEBUG=1 LIBUNWIND_DIR=/opt/libunwind/
+ifdef LIBUNWIND_DIR
+	LIBUNWIND_CFLAGS  := -I$(LIBUNWIND_DIR)/include
+	LIBUNWIND_LDFLAGS := -L$(LIBUNWIND_DIR)/lib
+endif
+
+FLAGS_UNWIND=$(LIBUNWIND_CFLAGS) $(ALL_CFLAGS) $(LIBUNWIND_LDFLAGS) $(ALL_LDFLAGS) $(EXTLIBS) $(LIBUNWIND_LIBS)
+ifneq ($(call try-cc,$(SOURCE_LIBUNWIND),$(FLAGS_UNWIND),libunwind),y)
+	msg := $(warning No libunwind found, disabling post unwind support. Please install libunwind-dev[el] >= 0.99);
+	NO_LIBUNWIND := 1
+endif # Libunwind support
+endif # NO_LIBUNWIND
+
+ifndef NO_LIBUNWIND
+	BASIC_CFLAGS += -DLIBUNWIND_SUPPORT
+	EXTLIBS += $(LIBUNWIND_LIBS)
+	BASIC_CFLAGS := $(LIBUNWIND_CFLAGS) $(BASIC_CFLAGS)
+	BASIC_LDFLAGS := $(LIBUNWIND_LDFLAGS) $(BASIC_LDFLAGS)
+endif # NO_LIBUNWIND
-- 
1.8.1.4

