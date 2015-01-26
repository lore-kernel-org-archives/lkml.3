Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755102AbbAZKOi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 05:14:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34836 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755044AbbAZKOd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 05:14:33 -0500
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
Subject: [PATCH 27/36] perf build: Add single target build framework support
Date: Mon, 26 Jan 2015 11:12:27 +0100
Message-Id: <1422267156-13873-28-git-send-email-jolsa@kernel.org>
In-Reply-To: <1422267156-13873-1-git-send-email-jolsa@kernel.org>
References: <1422267156-13873-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support to build single targets, like:

 $ make util/map.o    # objects
 $ make util/map.i    # preprocessor
 $ make util/map.s    # assembly

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
 tools/build/Makefile.build | 20 +++++++++++++++++++-
 tools/perf/Makefile.perf   | 39 ++++++++++++++++++++++++++++-----------
 tools/perf/util/Build      |  8 ++++++++
 3 files changed, 55 insertions(+), 12 deletions(-)

diff --git a/tools/build/Makefile.build b/tools/build/Makefile.build
index aced86d2bbf8..b5ded207f49b 100644
--- a/tools/build/Makefile.build
+++ b/tools/build/Makefile.build
@@ -49,6 +49,12 @@ quiet_cmd_mkdir = MKDIR    $(dir $@)
 quiet_cmd_cc_o_c = CC       $@
       cmd_cc_o_c = $(CC) $(c_flags) -c -o $@ $<
 
+quiet_cmd_cc_i_c = CPP      $@
+      cmd_cc_i_c = $(CC) $(c_flags) -E -o $@ $<
+
+quiet_cmd_cc_s_c = AS       $@
+      cmd_cc_s_c = $(CC) $(c_flags) -S -o $@ $<
+
 # Link agregate command
 # If there's nothing to link, create empty $@ object.
 quiet_cmd_ld_multi = LD       $@
@@ -64,6 +70,18 @@ $(OUTPUT)%.o: %.S FORCE
 	$(call rule_mkdir)
 	$(call if_changed_dep,cc_o_c)
 
+$(OUTPUT)%.i: %.c FORCE
+	$(call rule_mkdir)
+	$(call if_changed_dep,cc_i_c)
+
+$(OUTPUT)%.i: %.S FORCE
+	$(call rule_mkdir)
+	$(call if_changed_dep,cc_i_c)
+
+$(OUTPUT)%.s: %.c FORCE
+	$(call rule_mkdir)
+	$(call if_changed_dep,cc_s_c)
+
 # Gather build data:
 #   obj-y        - list of build objects
 #   subdir-y     - list of directories to nest
@@ -100,7 +118,7 @@ FORCE:
 
 # Include all cmd files to get all the dependency rules
 # for all objects included
-targets   := $(wildcard $(sort $(obj-y) $(in-target)))
+targets   := $(wildcard $(sort $(obj-y) $(in-target) $(MAKECMDGOALS)))
 cmd_files := $(wildcard $(foreach f,$(targets),$(dir $(f)).$(notdir $(f)).cmd))
 
 ifneq ($(cmd_files),)
diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index c68ff5fa8504..a5f0a63f020d 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -421,16 +421,33 @@ endif
 # These two need to be here so that when O= is not used they take precedence
 # over the general rule for .o
 
-$(OUTPUT)%.o: %.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) $<
-$(OUTPUT)%.i: %.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -E $(CFLAGS) $<
-$(OUTPUT)%.s: %.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -S $(CFLAGS) $<
-$(OUTPUT)%.o: %.S
-	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) $<
-$(OUTPUT)%.s: %.S
-	$(QUIET_CC)$(CC) -o $@ -E $(CFLAGS) $<
+# get relative building directory (to $(OUTPUT))
+# and '.' if it's $(OUTPUT) itself
+__build-dir = $(subst $(OUTPUT),,$(dir $@))
+build-dir   = $(if $(__build-dir),$(__build-dir),.)
+
+single_dep: $(OUTPUT)PERF-VERSION-FILE $(OUTPUT)common-cmds.h
+
+$(OUTPUT)%.o: %.c single_dep FORCE
+	@$(MAKE) -f $(srctree)/tools/build/Makefile.build dir=$(build-dir) $@
+
+$(OUTPUT)%.i: %.c single_dep FORCE
+	@$(MAKE) -f $(srctree)/tools/build/Makefile.build dir=$(build-dir) $@
+
+$(OUTPUT)%.s: %.c single_dep FORCE
+	@$(MAKE) -f $(srctree)/tools/build/Makefile.build dir=$(build-dir) $@
+
+$(OUTPUT)%-bison.o: %.c single_dep FORCE
+	@$(MAKE) -f $(srctree)/tools/build/Makefile.build dir=$(build-dir) $@
+
+$(OUTPUT)%-flex.o: %.c single_dep FORCE
+	@$(MAKE) -f $(srctree)/tools/build/Makefile.build dir=$(build-dir) $@
+
+$(OUTPUT)%.o: %.S single_dep FORCE
+	@$(MAKE) -f $(srctree)/tools/build/Makefile.build dir=$(build-dir) $@
+
+$(OUTPUT)%.i: %.S single_dep FORCE
+	@$(MAKE) -f $(srctree)/tools/build/Makefile.build dir=$(build-dir) $@
 
 $(OUTPUT)perf-%: %.o $(PERFLIBS)
 	$(QUIET_LINK)$(CC) $(CFLAGS) -o $@ $(LDFLAGS) $(filter %.o,$^) $(LIBS)
@@ -675,5 +692,5 @@ FORCE:
 
 .PHONY: all install clean config-clean strip install-gtk
 .PHONY: shell_compatibility_test please_set_SHELL_PATH_to_a_more_modern_shell
-.PHONY: $(GIT-HEAD-PHONY) TAGS tags cscope .FORCE-PERF-CFLAGS FORCE
+.PHONY: $(GIT-HEAD-PHONY) TAGS tags cscope .FORCE-PERF-CFLAGS FORCE single_dep
 
diff --git a/tools/perf/util/Build b/tools/perf/util/Build
index 459918872f07..32f9327b1a97 100644
--- a/tools/perf/util/Build
+++ b/tools/perf/util/Build
@@ -97,15 +97,19 @@ CFLAGS_config.o   += -DETC_PERFCONFIG="BUILD_STR($(ETC_PERFCONFIG_SQ))"
 CFLAGS_exec_cmd.o += -DPERF_EXEC_PATH="BUILD_STR($(perfexecdir_SQ))" -DPREFIX="BUILD_STR($(prefix_SQ))"
 
 $(OUTPUT)util/parse-events-flex.c: util/parse-events.l $(OUTPUT)util/parse-events-bison.c
+	$(call rule_mkdir)
 	@$(call echo-cmd,flex)$(FLEX) -o $@ --header-file=$(OUTPUT)util/parse-events-flex.h $(PARSER_DEBUG_FLEX) util/parse-events.l
 
 $(OUTPUT)util/parse-events-bison.c: util/parse-events.y
+	$(call rule_mkdir)
 	@$(call echo-cmd,bison)$(BISON) -v util/parse-events.y -d $(PARSER_DEBUG_BISON) -o $@ -p parse_events_
 
 $(OUTPUT)util/pmu-flex.c: util/pmu.l $(OUTPUT)util/pmu-bison.c
+	$(call rule_mkdir)
 	@$(call echo-cmd,flex)$(FLEX) -o $@ --header-file=$(OUTPUT)util/pmu-flex.h util/pmu.l
 
 $(OUTPUT)util/pmu-bison.c: util/pmu.y
+	$(call rule_mkdir)
 	@$(call echo-cmd,bison)$(BISON) -v util/pmu.y -d -o $@ -p perf_pmu_
 
 CFLAGS_parse-events-flex.o  += -w
@@ -122,13 +126,17 @@ CFLAGS_hweight.o       += -Wno-unused-parameter -DETC_PERFCONFIG="BUILD_STR($(ET
 CFLAGS_parse-events.o  += -Wno-redundant-decls
 
 $(OUTPUT)util/kallsyms.o: ../lib/symbol/kallsyms.c FORCE
+	$(call rule_mkdir)
 	$(call if_changed_dep,cc_o_c)
 
 $(OUTPUT)util/find_next_bit.o: ../lib/util/find_next_bit.c FORCE
+	$(call rule_mkdir)
 	$(call if_changed_dep,cc_o_c)
 
 $(OUTPUT)util/rbtree.o: ../../lib/rbtree.c FORCE
+	$(call rule_mkdir)
 	$(call if_changed_dep,cc_o_c)
 
 $(OUTPUT)util/hweight.o: ../../lib/hweight.c FORCE
+	$(call rule_mkdir)
 	$(call if_changed_dep,cc_o_c)
-- 
1.9.3

