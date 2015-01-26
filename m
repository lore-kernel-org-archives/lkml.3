Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755894AbbAZKV5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 05:21:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46825 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755154AbbAZKOr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 05:14:47 -0500
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>,
        Alexis Berlemont <alexis.berlemont@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 32/36] tools lib api: Use tools build framework
Date: Mon, 26 Jan 2015 11:12:32 +0100
Message-Id: <1422267156-13873-33-git-send-email-jolsa@kernel.org>
In-Reply-To: <1422267156-13873-1-git-send-email-jolsa@kernel.org>
References: <1422267156-13873-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the libapikfs library building under tools
build framework.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Tested-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Tested-by: Will Deacon <will.deacon@arm.com>
Cc: Alexis Berlemont <alexis.berlemont@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/lib/api/Build      |  2 ++
 tools/lib/api/Makefile   | 57 +++++++++++++++++++++---------------------------
 tools/lib/api/fd/Build   |  1 +
 tools/lib/api/fs/Build   |  2 ++
 tools/perf/Makefile.perf | 12 ++--------
 5 files changed, 32 insertions(+), 42 deletions(-)
 create mode 100644 tools/lib/api/Build
 create mode 100644 tools/lib/api/fd/Build
 create mode 100644 tools/lib/api/fs/Build

diff --git a/tools/lib/api/Build b/tools/lib/api/Build
new file mode 100644
index 000000000000..64dd8d466d2c
--- /dev/null
+++ b/tools/lib/api/Build
@@ -0,0 +1,2 @@
+libapikfs-y += fd/
+libapikfs-y += fs/
diff --git a/tools/lib/api/Makefile b/tools/lib/api/Makefile
index 36c08b1f4afb..27cedb273cca 100644
--- a/tools/lib/api/Makefile
+++ b/tools/lib/api/Makefile
@@ -1,49 +1,42 @@
 include ../../scripts/Makefile.include
 include ../../perf/config/utilities.mak		# QUIET_CLEAN
 
+ifeq ($(srctree),)
+srctree := $(patsubst %/,%,$(dir $(shell pwd)))
+srctree := $(patsubst %/,%,$(dir $(srctree)))
+srctree := $(patsubst %/,%,$(dir $(srctree)))
+#$(info Determined 'srctree' to be $(srctree))
+endif
+
 CC = $(CROSS_COMPILE)gcc
 AR = $(CROSS_COMPILE)ar
 
-# guard against environment variables
-LIB_H=
-LIB_OBJS=
-
-LIB_H += fs/debugfs.h
-LIB_H += fs/fs.h
-# See comment below about piggybacking...
-LIB_H += fd/array.h
-
-LIB_OBJS += $(OUTPUT)fs/debugfs.o
-LIB_OBJS += $(OUTPUT)fs/fs.o
-# XXX piggybacking here, need to introduce libapikfd, or rename this
-# to plain libapik.a and make it have it all api goodies
-LIB_OBJS += $(OUTPUT)fd/array.o
+MAKEFLAGS += --no-print-directory
 
-LIBFILE = libapikfs.a
+LIBFILE = $(OUTPUT)libapikfs.a
 
-CFLAGS = -ggdb3 -Wall -Wextra -std=gnu99 -Werror -O6 -D_FORTIFY_SOURCE=2 $(EXTRA_WARNINGS) $(EXTRA_CFLAGS) -fPIC
-EXTLIBS = -lelf -lpthread -lrt -lm
-ALL_CFLAGS = $(CFLAGS) $(BASIC_CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64
-ALL_LDFLAGS = $(LDFLAGS)
+CFLAGS += -ggdb3 -Wall -Wextra -std=gnu99 -Werror -O6 -D_FORTIFY_SOURCE=2 $(EXTRA_WARNINGS) $(EXTRA_CFLAGS) -fPIC
+CFLAGS += -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64
 
 RM = rm -f
 
-$(LIBFILE): $(LIB_OBJS)
-	$(QUIET_AR)$(RM) $@ && $(AR) rcs $(OUTPUT)$@ $(LIB_OBJS)
+build  := -f $(srctree)/tools/build/Makefile.build dir=. obj
+API_IN := $(OUTPUT)libapikfs-in.o
 
-$(LIB_OBJS): $(LIB_H)
+export srctree OUTPUT CC LD CFLAGS V
 
-libapi_dirs:
-	$(QUIET_MKDIR)mkdir -p $(OUTPUT)fd $(OUTPUT)fs
+all: $(LIBFILE)
 
-$(OUTPUT)%.o: %.c libapi_dirs
-	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) $<
-$(OUTPUT)%.s: %.c libapi_dirs
-	$(QUIET_CC)$(CC) -S $(ALL_CFLAGS) $<
-$(OUTPUT)%.o: %.S libapi_dirs
-	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) $<
+$(API_IN): FORCE
+	@$(MAKE) $(build)=libapikfs
+
+$(LIBFILE): $(API_IN)
+	$(QUIET_AR)$(RM) $@ && $(AR) rcs $@ $(API_IN)
 
 clean:
-	$(call QUIET_CLEAN, libapi) $(RM) $(LIB_OBJS) $(LIBFILE)
+	$(call QUIET_CLEAN, libapikfs) $(RM) $(LIBFILE); \
+	find $(if $(OUTPUT),$(OUTPUT),.) -name \*.o | xargs $(RM)
+
+FORCE:
 
-.PHONY: clean
+.PHONY: clean FORCE
diff --git a/tools/lib/api/fd/Build b/tools/lib/api/fd/Build
new file mode 100644
index 000000000000..4ddcb0ff7f49
--- /dev/null
+++ b/tools/lib/api/fd/Build
@@ -0,0 +1 @@
+libapikfs-y += array.o
diff --git a/tools/lib/api/fs/Build b/tools/lib/api/fs/Build
new file mode 100644
index 000000000000..de9c015794ff
--- /dev/null
+++ b/tools/lib/api/fs/Build
@@ -0,0 +1,2 @@
+libapikfs-y += fs.o
+libapikfs-y += debugfs.o
diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 97307a26fe10..0e5809b3be00 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -375,20 +375,12 @@ $(LIBTRACEEVENT)-clean:
 install-traceevent-plugins: $(LIBTRACEEVENT)
 	$(QUIET_SUBDIR0)$(TRACE_EVENT_DIR) $(LIBTRACEEVENT_FLAGS) install_plugins
 
-LIBAPIKFS_SOURCES = $(wildcard $(LIB_PATH)fs/*.[ch] $(LIB_PATH)fd/*.[ch])
-
-# if subdir is set, we've been called from above so target has been built
-# already
-$(LIBAPIKFS): $(LIBAPIKFS_SOURCES)
-ifeq ($(subdir),)
-	$(QUIET_SUBDIR0)$(LIB_DIR) $(QUIET_SUBDIR1) O=$(OUTPUT) libapikfs.a
-endif
+$(LIBAPIKFS): FORCE
+	@$(MAKE) -C $(LIB_DIR) O=$(OUTPUT) $(OUTPUT)libapikfs.a
 
 $(LIBAPIKFS)-clean:
-ifeq ($(subdir),)
 	$(call QUIET_CLEAN, libapikfs)
 	@$(MAKE) -C $(LIB_DIR) O=$(OUTPUT) clean >/dev/null
-endif
 
 help:
 	@echo 'Perf make targets:'
-- 
1.9.3

