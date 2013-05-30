Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934853Ab3E3QHZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 12:07:25 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51115 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934795Ab3E3QCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 12:02:34 -0400
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
Subject: [PATCH 36/66] perf tools: Move compiler and linker flags check into config/Makefile
Date: Thu, 30 May 2013 19:01:09 +0300
Message-Id: <1369929699-8724-37-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1369929699-8724-1-git-send-email-acme@infradead.org>
References: <1369929699-8724-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Moving compiler and linker flags check into config/Makefile.

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
Link: http://lkml.kernel.org/r/1369398928-9809-5-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile        | 110 ++++++++-------------------------------------
 tools/perf/config/Makefile |  66 +++++++++++++++++++++++++++
 2 files changed, 85 insertions(+), 91 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 2a75476..aa6f933 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -52,6 +52,20 @@ include config/utilities.mak
 #
 # Define NO_LIBNUMA if you do not want numa perf benchmark
 
+ifeq ($(srctree),)
+srctree := $(patsubst %/,%,$(dir $(shell pwd)))
+srctree := $(patsubst %/,%,$(dir $(srctree)))
+#$(info Determined 'srctree' to be $(srctree))
+endif
+
+ifneq ($(objtree),)
+#$(info Determined 'objtree' to be $(objtree))
+endif
+
+ifneq ($(OUTPUT),)
+#$(info Determined 'OUTPUT' to be $(OUTPUT))
+endif
+
 $(OUTPUT)PERF-VERSION-FILE: .FORCE-PERF-VERSION-FILE
 	@$(SHELL_PATH) util/PERF-VERSION-GEN $(OUTPUT)
 
@@ -66,6 +80,9 @@ FLEX    = flex
 BISON   = bison
 STRIP  ?= strip
 
+LK_DIR = ../lib/lk/
+TRACE_EVENT_DIR = ../lib/traceevent/
+
 # include config/Makefile by default and rule out
 # non-config cases
 config := 1
@@ -82,33 +99,10 @@ ifeq ($(config),1)
 include config/Makefile
 endif
 
-# Treat warnings as errors unless directed not to
-ifneq ($(WERROR),0)
-  CFLAGS_WERROR := -Werror
-endif
-
-ifeq ("$(origin DEBUG)", "command line")
-  PERF_DEBUG = $(DEBUG)
-endif
-ifndef PERF_DEBUG
-  CFLAGS_OPTIMIZE = -O6
-endif
-
-ifdef PARSER_DEBUG
-	PARSER_DEBUG_BISON  := -t
-	PARSER_DEBUG_FLEX   := -d
-	PARSER_DEBUG_CFLAGS := -DPARSER_DEBUG
-endif
-
 ifdef NO_NEWT
 	NO_SLANG=1
 endif
 
-CFLAGS = -fno-omit-frame-pointer -ggdb3 -funwind-tables -Wall -Wextra -std=gnu99 $(CFLAGS_WERROR) $(CFLAGS_OPTIMIZE) $(EXTRA_WARNINGS) $(EXTRA_CFLAGS) $(PARSER_DEBUG_CFLAGS)
-EXTLIBS = -lpthread -lrt -lelf -lm
-ALL_CFLAGS = $(CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE
-ALL_LDFLAGS = $(LDFLAGS)
-
 # Among the variables below, these:
 #   perfexecdir
 #   template_dir
@@ -148,71 +142,6 @@ export prefix bindir sharedir sysconfdir
 # explicitly what architecture to check for. Fix this up for yours..
 SPARSE_FLAGS = -D__BIG_ENDIAN__ -D__powerpc__
 
-ifneq ($(MAKECMDGOALS),clean)
-ifneq ($(MAKECMDGOALS),tags)
--include config/feature-tests.mak
-
-ifeq ($(call try-cc,$(SOURCE_HELLO),$(CFLAGS) -Werror -fstack-protector-all,-fstack-protector-all),y)
-	CFLAGS := $(CFLAGS) -fstack-protector-all
-endif
-
-ifeq ($(call try-cc,$(SOURCE_HELLO),$(CFLAGS) -Werror -Wstack-protector,-Wstack-protector),y)
-       CFLAGS := $(CFLAGS) -Wstack-protector
-endif
-
-ifeq ($(call try-cc,$(SOURCE_HELLO),$(CFLAGS) -Werror -Wvolatile-register-var,-Wvolatile-register-var),y)
-       CFLAGS := $(CFLAGS) -Wvolatile-register-var
-endif
-
-ifndef PERF_DEBUG
-	ifeq ($(call try-cc,$(SOURCE_HELLO),$(CFLAGS) -D_FORTIFY_SOURCE=2,-D_FORTIFY_SOURCE=2),y)
-		CFLAGS := $(CFLAGS) -D_FORTIFY_SOURCE=2
-	endif
-endif
-
-### --- END CONFIGURATION SECTION ---
-
-ifeq ($(srctree),)
-srctree := $(patsubst %/,%,$(dir $(shell pwd)))
-srctree := $(patsubst %/,%,$(dir $(srctree)))
-#$(info Determined 'srctree' to be $(srctree))
-endif
-
-ifneq ($(objtree),)
-#$(info Determined 'objtree' to be $(objtree))
-endif
-
-ifneq ($(OUTPUT),)
-#$(info Determined 'OUTPUT' to be $(OUTPUT))
-endif
-
-BASIC_CFLAGS += \
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
-BASIC_LDFLAGS =
-
-ifeq ($(call try-cc,$(SOURCE_BIONIC),$(CFLAGS),bionic),y)
-	BIONIC := 1
-	EXTLIBS := $(filter-out -lrt,$(EXTLIBS))
-	EXTLIBS := $(filter-out -lpthread,$(EXTLIBS))
-	BASIC_CFLAGS += -I.
-endif
-endif # MAKECMDGOALS != tags
-endif # MAKECMDGOALS != clean
-
 # Guard against environment variables
 BUILTIN_OBJS =
 LIB_H =
@@ -225,9 +154,6 @@ SCRIPT_SH += perf-archive.sh
 grep-libs = $(filter -l%,$(1))
 strip-libs = $(filter-out -l%,$(1))
 
-LK_DIR = ../lib/lk/
-TRACE_EVENT_DIR = ../lib/traceevent/
-
 LK_PATH=$(LK_DIR)
 
 ifneq ($(OUTPUT),)
@@ -541,6 +467,8 @@ PERFLIBS = $(LIB_FILE) $(LIBLK) $(LIBTRACEEVENT)
 ifneq ($(MAKECMDGOALS),clean)
 ifneq ($(MAKECMDGOALS),tags)
 
+-include config/feature-tests.mak
+
 # We choose to avoid "if .. else if .. else .. endif endif"
 # because maintaining the nesting to match is a pain.  If
 # we had "elif" things would have been much nicer...
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 04bf8ac..8acbcfe 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -42,3 +42,69 @@ endif
 ifeq ($(call get-executable,$(BISON)),)
 	dummy := $(error Error: $(BISON) is missing on this system, please install it)
 endif
+
+# Treat warnings as errors unless directed not to
+ifneq ($(WERROR),0)
+	CFLAGS_WERROR := -Werror
+endif
+
+ifeq ("$(origin DEBUG)", "command line")
+	PERF_DEBUG = $(DEBUG)
+endif
+ifndef PERF_DEBUG
+	CFLAGS_OPTIMIZE = -O6
+endif
+
+ifdef PARSER_DEBUG
+	PARSER_DEBUG_BISON  := -t
+	PARSER_DEBUG_FLEX   := -d
+	PARSER_DEBUG_CFLAGS := -DPARSER_DEBUG
+endif
+
+CFLAGS = -fno-omit-frame-pointer -ggdb3 -funwind-tables -Wall -Wextra -std=gnu99 $(CFLAGS_WERROR) $(CFLAGS_OPTIMIZE) $(EXTRA_WARNINGS) $(EXTRA_CFLAGS) $(PARSER_DEBUG_CFLAGS)
+EXTLIBS = -lpthread -lrt -lelf -lm
+ALL_CFLAGS = $(CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE
+ALL_LDFLAGS = $(LDFLAGS)
+
+ifeq ($(call try-cc,$(SOURCE_HELLO),$(CFLAGS) -Werror -fstack-protector-all,-fstack-protector-all),y)
+	CFLAGS := $(CFLAGS) -fstack-protector-all
+endif
+
+ifeq ($(call try-cc,$(SOURCE_HELLO),$(CFLAGS) -Werror -Wstack-protector,-Wstack-protector),y)
+	CFLAGS := $(CFLAGS) -Wstack-protector
+endif
+
+ifeq ($(call try-cc,$(SOURCE_HELLO),$(CFLAGS) -Werror -Wvolatile-register-var,-Wvolatile-register-var),y)
+	CFLAGS := $(CFLAGS) -Wvolatile-register-var
+endif
+
+ifndef PERF_DEBUG
+	ifeq ($(call try-cc,$(SOURCE_HELLO),$(CFLAGS) -D_FORTIFY_SOURCE=2,-D_FORTIFY_SOURCE=2),y)
+		CFLAGS := $(CFLAGS) -D_FORTIFY_SOURCE=2
+	endif
+endif
+
+BASIC_CFLAGS += \
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
+BASIC_LDFLAGS =
+
+ifeq ($(call try-cc,$(SOURCE_BIONIC),$(CFLAGS),bionic),y)
+	BIONIC := 1
+	EXTLIBS := $(filter-out -lrt,$(EXTLIBS))
+	EXTLIBS := $(filter-out -lpthread,$(EXTLIBS))
+	BASIC_CFLAGS += -I.
+endif
-- 
1.8.1.4

