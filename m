Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758355Ab3DXJis (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 05:38:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9564 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758335Ab3DXJio (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 05:38:44 -0400
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
Subject: [PATCH 07/26] perf tools: Move libdw check config into config/Makefile
Date: Wed, 24 Apr 2013 11:37:34 +0200
Message-Id: <1366796273-4780-8-git-send-email-jolsa@redhat.com>
In-Reply-To: <1366796273-4780-1-git-send-email-jolsa@redhat.com>
References: <1366796273-4780-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moving libdw check config into config/Makefile.

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
 tools/perf/Makefile        |  7 -------
 tools/perf/config/Makefile | 15 +++++++++++++++
 2 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index c309a5b..fd45172 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -517,15 +517,8 @@ LIB_OBJS += $(OUTPUT)util/symbol-minimal.o
 
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
index ef09d6c..3620877 100644
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
1.7.11.7

