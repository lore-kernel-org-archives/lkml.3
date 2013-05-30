Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933925Ab3E3QIY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 12:08:24 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51099 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934461Ab3E3QCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 12:02:30 -0400
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
Subject: [PATCH 38/66] perf tools: Move libdw check config into config/Makefile
Date: Thu, 30 May 2013 19:01:11 +0300
Message-Id: <1369929699-8724-39-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1369929699-8724-1-git-send-email-acme@infradead.org>
References: <1369929699-8724-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Moving libdw check config into config/Makefile.

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
Link: http://lkml.kernel.org/r/1369398928-9809-7-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile        |  7 -------
 tools/perf/config/Makefile | 15 +++++++++++++++
 2 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index a174c68..51fac31 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -515,15 +515,8 @@ LIB_OBJS += $(OUTPUT)util/symbol-minimal.o
 
 else # NO_LIBELF
 ifndef NO_DWARF
-ifeq ($(origin PERF_HAVE_DWARF_REGS), undefined)
-	msg := $(warning DWARF register mappings have not been defined for architecture $(ARCH), DWARF support disabled);
-else
-	BASIC_CFLAGS := -DDWARF_SUPPORT $(LIBDW_CFLAGS) $(BASIC_CFLAGS)
-	BASIC_LDFLAGS := $(LIBDW_LDFLAGS) $(BASIC_LDFLAGS)
-	EXTLIBS += -lelf -ldw
 	LIB_OBJS += $(OUTPUT)util/probe-finder.o
 	LIB_OBJS += $(OUTPUT)util/dwarf-aux.o
-endif # PERF_HAVE_DWARF_REGS
 endif # NO_DWARF
 endif # NO_LIBELF
 
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 17614b1..71e737c 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -154,4 +154,19 @@ FLAGS_LIBELF=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS)
 ifeq ($(call try-cc,$(SOURCE_ELF_MMAP),$(FLAGS_LIBELF),-DLIBELF_MMAP),y)
 	BASIC_CFLAGS += -DLIBELF_MMAP
 endif
+
+# include ARCH specific config
+-include arch/$(ARCH)/Makefile
+
+ifndef NO_DWARF
+ifeq ($(origin PERF_HAVE_DWARF_REGS), undefined)
+	msg := $(warning DWARF register mappings have not been defined for architecture $(ARCH), DWARF support disabled);
+	NO_DWARF := 1
+else
+	BASIC_CFLAGS := -DDWARF_SUPPORT $(LIBDW_CFLAGS) $(BASIC_CFLAGS)
+	BASIC_LDFLAGS := $(LIBDW_LDFLAGS) $(BASIC_LDFLAGS)
+	EXTLIBS += -lelf -ldw
+endif # PERF_HAVE_DWARF_REGS
+endif # NO_DWARF
+
 endif # NO_LIBELF
-- 
1.8.1.4

