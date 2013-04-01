Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759455Ab3DATT4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 15:19:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50353 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759415Ab3DATTu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 15:19:50 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Borislav Petkov <bp@alien8.de>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 05/27] perf tools: Move compiler and linker flags check into config/Makefile
Date: Mon,  1 Apr 2013 21:18:28 +0200
Message-Id: <1364843930-17974-6-git-send-email-jolsa@redhat.com>
In-Reply-To: <1364843930-17974-1-git-send-email-jolsa@redhat.com>
References: <1364843930-17974-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moving compiler and linker flags check into config/Makefile.

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
---
 tools/perf/Makefile        | 110 ++++++++-------------------------------------
 tools/perf/config/Makefile |  66 +++++++++++++++++++++++++++
 2 files changed, 85 insertions(+), 91 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 8dd3320..dcae71b 100644
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
 
@@ -66,37 +80,17 @@ FLEX    = flex
 BISON   = bison
 STRIP  ?= strip
 
+LK_DIR = ../lib/lk/
+TRACE_EVENT_DIR = ../lib/traceevent/
+
 ifeq ($(filter clean tags,$(MAKECMDGOALS)),)
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
@@ -136,71 +130,6 @@ export prefix bindir sharedir sysconfdir
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
@@ -213,9 +142,6 @@ SCRIPT_SH += perf-archive.sh
 grep-libs = $(filter -l%,$(1))
 strip-libs = $(filter-out -l%,$(1))
 
-LK_DIR = ../lib/lk/
-TRACE_EVENT_DIR = ../lib/traceevent/
-
 LK_PATH=$(LK_DIR)
 
 ifneq ($(OUTPUT),)
@@ -529,6 +455,8 @@ PERFLIBS = $(LIB_FILE) $(LIBLK) $(LIBTRACEEVENT)
 ifneq ($(MAKECMDGOALS),clean)
 ifneq ($(MAKECMDGOALS),tags)
 
+-include config/feature-tests.mak
+
 # We choose to avoid "if .. else if .. else .. endif endif"
 # because maintaining the nesting to match is a pain.  If
 # we had "elif" things would have been much nicer...
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 04bf8ac..9ce522a 100644
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
+BASIC_LDFLAGS =
+
+ifeq ($(call try-cc,$(SOURCE_BIONIC),$(CFLAGS),bionic),y)
+	BIONIC := 1
+	EXTLIBS := $(filter-out -lrt,$(EXTLIBS))
+	EXTLIBS := $(filter-out -lpthread,$(EXTLIBS))
+	BASIC_CFLAGS += -I.
+endif
-- 
1.7.11.7

