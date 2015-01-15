Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878AbbAOM6w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 07:58:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48898 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754847AbbAOM6s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 07:58:48 -0500
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
Subject: [PATCH 36/36] perf build: Display make commands on V=1
Date: Thu, 15 Jan 2015 13:55:32 +0100
Message-Id: <1421326532-25660-37-git-send-email-jolsa@kernel.org>
In-Reply-To: <1421326532-25660-1-git-send-email-jolsa@kernel.org>
References: <1421326532-25660-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get more verbose output wrt displaying executed commands
from make.

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
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/Makefile.perf | 48 +++++++++++++++++++++++++++---------------------
 1 file changed, 27 insertions(+), 21 deletions(-)

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 6b6bef8a515a..d5f1d3feea17 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -89,13 +89,19 @@ VPATH += $(OUTPUT)
 export VPATH
 endif
 
+ifeq ($(V),1)
+  Q =
+else
+  Q = @
+endif
+
 # Do not use make's built-in rules and variables
 # (this increases performance and avoids hard-to-debug behaviour);
 MAKEFLAGS += -rR
 
 $(OUTPUT)PERF-VERSION-FILE: ../../.git/HEAD
-	@$(SHELL_PATH) util/PERF-VERSION-GEN $(OUTPUT)
-	@touch $(OUTPUT)PERF-VERSION-FILE
+	$(Q)$(SHELL_PATH) util/PERF-VERSION-GEN $(OUTPUT)
+	$(Q)touch $(OUTPUT)PERF-VERSION-FILE
 
 CC = $(CROSS_COMPILE)gcc
 LD = $(CROSS_COMPILE)ld
@@ -251,7 +257,7 @@ SHELL = $(SHELL_PATH)
 all: shell_compatibility_test $(ALL_PROGRAMS) $(LANG_BINDINGS) $(OTHER_PROGRAMS)
 
 please_set_SHELL_PATH_to_a_more_modern_shell:
-	@$$(:)
+	$(Q)$$(:)
 
 shell_compatibility_test: please_set_SHELL_PATH_to_a_more_modern_shell
 
@@ -264,13 +270,13 @@ export srctree OUTPUT RM CC LD CFLAGS V BISON FLEX
 build := -f $(srctree)/tools/build/Makefile.build dir=. obj
 
 $(PERF_IN): $(OUTPUT)PERF-VERSION-FILE $(OUTPUT)common-cmds.h FORCE
-	@$(MAKE) $(build)=perf
+	$(Q)$(MAKE) $(build)=perf
 
 $(OUTPUT)perf: $(PERFLIBS) $(PERF_IN)
 	$(QUIET_LINK)$(CC) $(CFLAGS) $(LDFLAGS) $(PERF_IN) $(LIBS) -o $@
 
 $(GTK_IN): FORCE
-	@$(MAKE) $(build)=gtk
+	$(Q)$(MAKE) $(build)=gtk
 
 $(OUTPUT)libperf-gtk.so: $(GTK_IN) $(PERFLIBS)
 	$(QUIET_LINK)$(CC) -o $@ -shared $(LDFLAGS) $(filter %.o,$^) $(GTK_LIBS)
@@ -315,25 +321,25 @@ build-dir   = $(if $(__build-dir),$(__build-dir),.)
 single_dep: $(OUTPUT)PERF-VERSION-FILE $(OUTPUT)common-cmds.h
 
 $(OUTPUT)%.o: %.c single_dep FORCE
-	@$(MAKE) -f $(srctree)/tools/build/Makefile.build dir=$(build-dir) $@
+	$(Q)$(MAKE) -f $(srctree)/tools/build/Makefile.build dir=$(build-dir) $@
 
 $(OUTPUT)%.i: %.c single_dep FORCE
-	@$(MAKE) -f $(srctree)/tools/build/Makefile.build dir=$(build-dir) $@
+	$(Q)$(MAKE) -f $(srctree)/tools/build/Makefile.build dir=$(build-dir) $@
 
 $(OUTPUT)%.s: %.c single_dep FORCE
-	@$(MAKE) -f $(srctree)/tools/build/Makefile.build dir=$(build-dir) $@
+	$(Q)$(MAKE) -f $(srctree)/tools/build/Makefile.build dir=$(build-dir) $@
 
 $(OUTPUT)%-bison.o: %.c single_dep FORCE
-	@$(MAKE) -f $(srctree)/tools/build/Makefile.build dir=$(build-dir) $@
+	$(Q)$(MAKE) -f $(srctree)/tools/build/Makefile.build dir=$(build-dir) $@
 
 $(OUTPUT)%-flex.o: %.c single_dep FORCE
-	@$(MAKE) -f $(srctree)/tools/build/Makefile.build dir=$(build-dir) $@
+	$(Q)$(MAKE) -f $(srctree)/tools/build/Makefile.build dir=$(build-dir) $@
 
 $(OUTPUT)%.o: %.S single_dep FORCE
-	@$(MAKE) -f $(srctree)/tools/build/Makefile.build dir=$(build-dir) $@
+	$(Q)$(MAKE) -f $(srctree)/tools/build/Makefile.build dir=$(build-dir) $@
 
 $(OUTPUT)%.i: %.S single_dep FORCE
-	@$(MAKE) -f $(srctree)/tools/build/Makefile.build dir=$(build-dir) $@
+	$(Q)$(MAKE) -f $(srctree)/tools/build/Makefile.build dir=$(build-dir) $@
 
 $(OUTPUT)perf-%: %.o $(PERFLIBS)
 	$(QUIET_LINK)$(CC) $(CFLAGS) -o $@ $(LDFLAGS) $(filter %.o,$^) $(LIBS)
@@ -353,7 +359,7 @@ $(patsubst perf-%,%.o,$(PROGRAMS)): $(wildcard */*.h)
 LIBPERF_IN := $(OUTPUT)libperf-in.o
 
 $(LIBPERF_IN): FORCE
-	@$(MAKE) $(build)=libperf
+	$(Q)$(MAKE) $(build)=libperf
 
 $(LIB_FILE): $(LIBPERF_IN)
 	$(QUIET_AR)$(RM) $@ && $(AR) rcs $@ $(LIBPERF_IN) $(LIB_OBJS)
@@ -362,21 +368,21 @@ LIBTRACEEVENT_FLAGS += CFLAGS="-g -Wall $(EXTRA_CFLAGS)"
 LIBTRACEEVENT_FLAGS += plugin_dir=$(plugindir_SQ)
 
 $(LIBTRACEEVENT): FORCE
-	@$(MAKE) -C $(TRACE_EVENT_DIR) $(LIBTRACEEVENT_FLAGS) O=$(OUTPUT) $(OUTPUT)libtraceevent.a plugins
+	$(Q)$(MAKE) -C $(TRACE_EVENT_DIR) $(LIBTRACEEVENT_FLAGS) O=$(OUTPUT) $(OUTPUT)libtraceevent.a plugins
 
 $(LIBTRACEEVENT)-clean:
 	$(call QUIET_CLEAN, libtraceevent)
-	@$(MAKE) -C $(TRACE_EVENT_DIR) O=$(OUTPUT) clean >/dev/null
+	$(Q)$(MAKE) -C $(TRACE_EVENT_DIR) O=$(OUTPUT) clean >/dev/null
 
 install-traceevent-plugins: $(LIBTRACEEVENT)
-	@$(MAKE) -C $(TRACE_EVENT_DIR) $(LIBTRACEEVENT_FLAGS) O=$(OUTPUT) install_plugins
+	$(Q)$(MAKE) -C $(TRACE_EVENT_DIR) $(LIBTRACEEVENT_FLAGS) O=$(OUTPUT) install_plugins
 
 $(LIBAPIKFS): FORCE
-	@$(MAKE) -C $(LIB_DIR) O=$(OUTPUT) $(OUTPUT)libapi.a
+	$(Q)$(MAKE) -C $(LIB_DIR) O=$(OUTPUT) $(OUTPUT)libapi.a
 
 $(LIBAPIKFS)-clean:
 	$(call QUIET_CLEAN, libapi)
-	@$(MAKE) -C $(LIB_DIR) O=$(OUTPUT) clean >/dev/null
+	$(Q)$(MAKE) -C $(LIB_DIR) O=$(OUTPUT) clean >/dev/null
 
 help:
 	@echo 'Perf make targets:'
@@ -514,12 +520,12 @@ $(INSTALL_DOC_TARGETS):
 #
 config-clean:
 	$(call QUIET_CLEAN, config)
-	@$(MAKE) -C config/feature-checks clean >/dev/null
+	$(Q)$(MAKE) -C config/feature-checks clean >/dev/null
 
 clean: $(LIBTRACEEVENT)-clean $(LIBAPIKFS)-clean config-clean
 	$(call QUIET_CLEAN, core-objs)  $(RM) $(LIB_FILE) $(OUTPUT)perf-archive $(OUTPUT)perf-with-kcore $(LANG_BINDINGS)
-	@find $(if $(OUTPUT),$(OUTPUT),.) -name \*.o | xargs $(RM)
-	@$(RM) .config-detected
+	$(Q)find $(if $(OUTPUT),$(OUTPUT),.) -name \*.o | xargs $(RM)
+	$(Q)$(RM) .config-detected
 	$(call QUIET_CLEAN, core-progs) $(RM) $(ALL_PROGRAMS) perf perf-read-vdso32 perf-read-vdsox32
 	$(call QUIET_CLEAN, core-gen)   $(RM)  *.spec *.pyc *.pyo */*.pyc */*.pyo $(OUTPUT)common-cmds.h TAGS tags cscope* $(OUTPUT)PERF-VERSION-FILE $(OUTPUT)PERF-FEATURES $(OUTPUT)util/*-bison* $(OUTPUT)util/*-flex*
 	$(QUIET_SUBDIR0)Documentation $(QUIET_SUBDIR1) clean
-- 
1.9.3

