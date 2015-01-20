Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218AbbATQms (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 11:42:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53009 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751868AbbATQmp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 11:42:45 -0500
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
        "S. Lockwood-Childs" <sjl@vctlabs.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 35/36] tools lib lockdep: Use tools build framework
Date: Tue, 20 Jan 2015 17:39:32 +0100
Message-Id: <1421771973-6022-36-git-send-email-jolsa@kernel.org>
In-Reply-To: <1421771973-6022-1-git-send-email-jolsa@kernel.org>
References: <1421771973-6022-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the lockdep library building under tools
build framework.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
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
Cc: S. Lockwood-Childs <sjl@vctlabs.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/lib/lockdep/Build    |   1 +
 tools/lib/lockdep/Makefile | 132 ++++++++-------------------------------------
 2 files changed, 24 insertions(+), 109 deletions(-)
 create mode 100644 tools/lib/lockdep/Build

diff --git a/tools/lib/lockdep/Build b/tools/lib/lockdep/Build
new file mode 100644
index 000000000000..6f667355b068
--- /dev/null
+++ b/tools/lib/lockdep/Build
@@ -0,0 +1 @@
+liblockdep-y += common.o lockdep.o preload.o rbtree.o
diff --git a/tools/lib/lockdep/Makefile b/tools/lib/lockdep/Makefile
index 52f9279c6c13..8c3340a4b9f8 100644
--- a/tools/lib/lockdep/Makefile
+++ b/tools/lib/lockdep/Makefile
@@ -35,6 +35,10 @@ bindir = $(prefix)/$(bindir_relative)
 
 export DESTDIR DESTDIR_SQ INSTALL
 
+MAKEFLAGS += --no-print-directory
+
+include ../../scripts/Makefile.include
+
 # copy a bit from Linux kbuild
 
 ifeq ("$(origin V)", "command line")
@@ -44,56 +48,21 @@ ifndef VERBOSE
   VERBOSE = 0
 endif
 
-ifeq ("$(origin O)", "command line")
-  BUILD_OUTPUT := $(O)
+ifeq ($(srctree),)
+srctree := $(patsubst %/,%,$(dir $(shell pwd)))
+srctree := $(patsubst %/,%,$(dir $(srctree)))
+srctree := $(patsubst %/,%,$(dir $(srctree)))
+#$(info Determined 'srctree' to be $(srctree))
 endif
 
-ifeq ($(BUILD_SRC),)
-ifneq ($(BUILD_OUTPUT),)
-
-define build_output
-	$(if $(VERBOSE:1=),@)$(MAKE) -C $(BUILD_OUTPUT)	\
-	BUILD_SRC=$(CURDIR) -f $(CURDIR)/Makefile $1
-endef
-
-saved-output := $(BUILD_OUTPUT)
-BUILD_OUTPUT := $(shell cd $(BUILD_OUTPUT) && /bin/pwd)
-$(if $(BUILD_OUTPUT),, \
-     $(error output directory "$(saved-output)" does not exist))
-
-all: sub-make
-
-gui: force
-	$(call build_output, all_cmd)
-
-$(filter-out gui,$(MAKECMDGOALS)): sub-make
-
-sub-make: force
-	$(call build_output, $(MAKECMDGOALS))
-
-
-# Leave processing to above invocation of make
-skip-makefile := 1
-
-endif # BUILD_OUTPUT
-endif # BUILD_SRC
-
-# We process the rest of the Makefile if this is the final invocation of make
-ifeq ($(skip-makefile),)
-
-srctree		:= $(realpath $(if $(BUILD_SRC),$(BUILD_SRC),$(CURDIR)))
-objtree		:= $(realpath $(CURDIR))
-src		:= $(srctree)
-obj		:= $(objtree)
-
-export prefix libdir bindir src obj
-
 # Shell quotes
 libdir_SQ = $(subst ','\'',$(libdir))
 bindir_SQ = $(subst ','\'',$(bindir))
 
-LIB_FILE = liblockdep.a liblockdep.so.$(LIBLOCKDEP_VERSION)
+LIB_IN := $(OUTPUT)liblockdep-in.o
+
 BIN_FILE = lockdep
+LIB_FILE = $(OUTPUT)liblockdep.a $(OUTPUT)liblockdep.so.$(LIBLOCKDEP_VERSION)
 
 CONFIG_INCLUDES =
 CONFIG_LIBS	=
@@ -108,33 +77,23 @@ INCLUDES = -I. -I/usr/local/include -I./uinclude -I./include -I../../include $(C
 
 # Set compile option CFLAGS if not set elsewhere
 CFLAGS ?= -g -DCONFIG_LOCKDEP -DCONFIG_STACKTRACE -DCONFIG_PROVE_LOCKING -DBITS_PER_LONG=__WORDSIZE -DLIBLOCKDEP_VERSION='"$(LIBLOCKDEP_VERSION)"' -rdynamic -O0 -g
+CFLAGS += -fPIC
 
 override CFLAGS += $(CONFIG_FLAGS) $(INCLUDES) $(PLUGIN_DIR_SQ)
 
 ifeq ($(VERBOSE),1)
   Q =
-  print_compile =
-  print_app_build =
-  print_fpic_compile =
   print_shared_lib_compile =
   print_install =
 else
   Q = @
-  print_compile =		echo '  CC                 '$(OBJ);
-  print_app_build =		echo '  BUILD              '$(OBJ);
-  print_fpic_compile =		echo '  CC FPIC            '$(OBJ);
-  print_shared_lib_compile =	echo '  BUILD SHARED LIB   '$(OBJ);
-  print_static_lib_build =	echo '  BUILD STATIC LIB   '$(OBJ);
-  print_install =		echo '  INSTALL     '$1'	to	$(DESTDIR_SQ)$2';
+  print_shared_lib_compile =	echo '  LD       '$(OBJ);
+  print_static_lib_build =	echo '  LD       '$(OBJ);
+  print_install =		echo '  INSTALL  '$1'	to	$(DESTDIR_SQ)$2';
 endif
 
-do_fpic_compile =					\
-	($(print_fpic_compile)				\
-	$(CC) -c $(CFLAGS) $(EXT) -fPIC $< -o $@)
-
-do_app_build =						\
-	($(print_app_build)				\
-	$(CC) $^ -rdynamic -o $@ $(CONFIG_LIBS) $(LIBS))
+export srctree OUTPUT CC LD CFLAGS V
+build := -f $(srctree)/tools/build/Makefile.build dir=. obj
 
 do_compile_shared_library =			\
 	($(print_shared_lib_compile)		\
@@ -144,22 +103,6 @@ do_build_static_lib =				\
 	($(print_static_lib_build)		\
 	$(RM) $@;  $(AR) rcs $@ $^)
 
-
-define do_compile
-	$(print_compile)						\
-	$(CC) -c $(CFLAGS) $(EXT) $< -o $(obj)/$@;
-endef
-
-$(obj)/%.o: $(src)/%.c
-	$(Q)$(call do_compile)
-
-%.o: $(src)/%.c
-	$(Q)$(call do_compile)
-
-PEVENT_LIB_OBJS = common.o lockdep.o preload.o rbtree.o
-
-ALL_OBJS = $(PEVENT_LIB_OBJS)
-
 CMD_TARGETS = $(LIB_FILE)
 
 TARGETS = $(CMD_TARGETS)
@@ -169,42 +112,15 @@ all: all_cmd
 
 all_cmd: $(CMD_TARGETS)
 
-liblockdep.so.$(LIBLOCKDEP_VERSION): $(PEVENT_LIB_OBJS)
+$(LIB_IN): force
+	$(Q)$(MAKE) $(build)=liblockdep
+
+liblockdep.so.$(LIBLOCKDEP_VERSION): $(LIB_IN)
 	$(Q)$(do_compile_shared_library)
 
-liblockdep.a: $(PEVENT_LIB_OBJS)
+liblockdep.a: $(LIB_IN)
 	$(Q)$(do_build_static_lib)
 
-$(PEVENT_LIB_OBJS): %.o: $(src)/%.c
-	$(Q)$(do_fpic_compile)
-
-## make deps
-
-all_objs := $(sort $(ALL_OBJS))
-all_deps := $(all_objs:%.o=.%.d)
-
-# let .d file also depends on the source and header files
-define check_deps
-		@set -e; $(RM) $@; \
-		$(CC) -MM $(CFLAGS) $< > $@.$$$$; \
-		sed 's,\($*\)\.o[ :]*,\1.o $@ : ,g' < $@.$$$$ > $@; \
-		$(RM) $@.$$$$
-endef
-
-$(all_deps): .%.d: $(src)/%.c
-	$(Q)$(call check_deps)
-
-$(all_objs) : %.o : .%.d
-
-dep_includes := $(wildcard $(all_deps))
-
-ifneq ($(dep_includes),)
- include $(dep_includes)
-endif
-
-### Detect environment changes
-TRACK_CFLAGS = $(subst ','\'',$(CFLAGS)):$(ARCH):$(CROSS_COMPILE)
-
 tags:	force
 	$(RM) tags
 	find . -name '*.[ch]' | xargs ctags --extra=+f --c-kinds=+px \
@@ -233,8 +149,6 @@ clean:
 	$(RM) *.o *~ $(TARGETS) *.a *liblockdep*.so* $(VERSION_FILES) .*.d
 	$(RM) tags TAGS
 
-endif # skip-makefile
-
 PHONY += force
 force:
 
-- 
1.9.3

