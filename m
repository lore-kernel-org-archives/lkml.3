Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755504AbbATQsX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 11:48:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57921 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754838AbbATQlw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 11:41:52 -0500
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
Subject: [PATCH 09/36] perf build: Add libperf objects building
Date: Tue, 20 Jan 2015 17:39:06 +0100
Message-Id: <1421771973-6022-10-git-send-email-jolsa@kernel.org>
In-Reply-To: <1421771973-6022-1-git-send-email-jolsa@kernel.org>
References: <1421771973-6022-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the util objects building under build framework.

Add new libperf build object so it's separated from
the rest of the perf code and could be librarized.

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
 tools/build/Makefile.build |   3 +
 tools/perf/Build           |   3 +
 tools/perf/Makefile.perf   | 139 +++++----------------------------------------
 tools/perf/arch/Build      |   1 +
 tools/perf/config/Makefile |   5 ++
 tools/perf/util/Build      | 116 +++++++++++++++++++++++++++++++++++++
 6 files changed, 141 insertions(+), 126 deletions(-)
 create mode 100644 tools/perf/arch/Build
 create mode 100644 tools/perf/util/Build

diff --git a/tools/build/Makefile.build b/tools/build/Makefile.build
index cdcd78f024dc..82a3ce405f04 100644
--- a/tools/build/Makefile.build
+++ b/tools/build/Makefile.build
@@ -32,6 +32,9 @@ subdir-obj-y :=
 build-file := $(dir)/Build
 include $(build-file)
 
+quiet_cmd_flex  = FLEX     $@
+quiet_cmd_bison = BISON    $@
+
 # Create directory unless it exists
 quiet_cmd_mkdir = MKDIR    $(dir $@)
       cmd_mkdir = mkdir -p $(dir $@)
diff --git a/tools/perf/Build b/tools/perf/Build
index 80a944b929da..31c4c555cc81 100644
--- a/tools/perf/Build
+++ b/tools/perf/Build
@@ -30,3 +30,6 @@ paths += -DPERF_MAN_PATH="BUILD_STR($(mandir_SQ))"
 
 CFLAGS_builtin-help.o      += $(paths)
 CFLAGS_builtin-timechart.o += $(paths)
+
+libperf-y += util/
+libperf-y += arch/
diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index b0df3ec91104..e0b1c2227e5b 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -82,6 +82,11 @@ endif
 
 ifneq ($(OUTPUT),)
 #$(info Determined 'OUTPUT' to be $(OUTPUT))
+# Adding $(OUTPUT) as a directory to look for source files,
+# because use generated output files as sources dependency
+# for flex/bison parsers.
+VPATH += $(OUTPUT)
+export VPATH
 endif
 
 # Do not use make's built-in rules
@@ -211,21 +216,6 @@ endif
 
 export PERL_PATH
 
-$(OUTPUT)util/parse-events-flex.c: util/parse-events.l $(OUTPUT)util/parse-events-bison.c
-	$(QUIET_FLEX)$(FLEX) -o $@ --header-file=$(OUTPUT)util/parse-events-flex.h $(PARSER_DEBUG_FLEX) util/parse-events.l
-
-$(OUTPUT)util/parse-events-bison.c: util/parse-events.y
-	$(QUIET_BISON)$(BISON) -v util/parse-events.y -d $(PARSER_DEBUG_BISON) -o $(OUTPUT)util/parse-events-bison.c -p parse_events_
-
-$(OUTPUT)util/pmu-flex.c: util/pmu.l $(OUTPUT)util/pmu-bison.c
-	$(QUIET_FLEX)$(FLEX) -o $@ --header-file=$(OUTPUT)util/pmu-flex.h util/pmu.l
-
-$(OUTPUT)util/pmu-bison.c: util/pmu.y
-	$(QUIET_BISON)$(BISON) -v util/pmu.y -d -o $(OUTPUT)util/pmu-bison.c -p perf_pmu_
-
-$(OUTPUT)util/parse-events.o: $(OUTPUT)util/parse-events-flex.c $(OUTPUT)util/parse-events-bison.c
-$(OUTPUT)util/pmu.o: $(OUTPUT)util/pmu-flex.c $(OUTPUT)util/pmu-bison.c
-
 LIB_FILE=$(OUTPUT)libperf.a
 
 LIB_H += ../lib/symbol/kallsyms.h
@@ -337,84 +327,8 @@ LIB_H += util/data.h
 LIB_H += util/kvm-stat.h
 LIB_H += util/thread-stack.h
 
-LIB_OBJS += $(OUTPUT)util/abspath.o
-LIB_OBJS += $(OUTPUT)util/alias.o
-LIB_OBJS += $(OUTPUT)util/annotate.o
-LIB_OBJS += $(OUTPUT)util/build-id.o
-LIB_OBJS += $(OUTPUT)util/config.o
-LIB_OBJS += $(OUTPUT)util/ctype.o
-LIB_OBJS += $(OUTPUT)util/db-export.o
-LIB_OBJS += $(OUTPUT)util/pmu.o
-LIB_OBJS += $(OUTPUT)util/environment.o
-LIB_OBJS += $(OUTPUT)util/event.o
-LIB_OBJS += $(OUTPUT)util/evlist.o
-LIB_OBJS += $(OUTPUT)util/evsel.o
-LIB_OBJS += $(OUTPUT)util/exec_cmd.o
-LIB_OBJS += $(OUTPUT)util/find_next_bit.o
-LIB_OBJS += $(OUTPUT)util/help.o
-LIB_OBJS += $(OUTPUT)util/kallsyms.o
-LIB_OBJS += $(OUTPUT)util/levenshtein.o
-LIB_OBJS += $(OUTPUT)util/parse-options.o
-LIB_OBJS += $(OUTPUT)util/parse-events.o
-LIB_OBJS += $(OUTPUT)util/path.o
-LIB_OBJS += $(OUTPUT)util/rbtree.o
-LIB_OBJS += $(OUTPUT)util/bitmap.o
-LIB_OBJS += $(OUTPUT)util/hweight.o
-LIB_OBJS += $(OUTPUT)util/run-command.o
-LIB_OBJS += $(OUTPUT)util/quote.o
-LIB_OBJS += $(OUTPUT)util/strbuf.o
-LIB_OBJS += $(OUTPUT)util/string.o
-LIB_OBJS += $(OUTPUT)util/strlist.o
-LIB_OBJS += $(OUTPUT)util/strfilter.o
-LIB_OBJS += $(OUTPUT)util/top.o
-LIB_OBJS += $(OUTPUT)util/usage.o
-LIB_OBJS += $(OUTPUT)util/wrapper.o
-LIB_OBJS += $(OUTPUT)util/sigchain.o
-LIB_OBJS += $(OUTPUT)util/dso.o
-LIB_OBJS += $(OUTPUT)util/symbol.o
 LIB_OBJS += $(OUTPUT)util/symbol-elf.o
-LIB_OBJS += $(OUTPUT)util/color.o
-LIB_OBJS += $(OUTPUT)util/pager.o
-LIB_OBJS += $(OUTPUT)util/header.o
-LIB_OBJS += $(OUTPUT)util/callchain.o
-LIB_OBJS += $(OUTPUT)util/values.o
-LIB_OBJS += $(OUTPUT)util/debug.o
-LIB_OBJS += $(OUTPUT)util/machine.o
-LIB_OBJS += $(OUTPUT)util/map.o
-LIB_OBJS += $(OUTPUT)util/pstack.o
-LIB_OBJS += $(OUTPUT)util/session.o
-LIB_OBJS += $(OUTPUT)util/ordered-events.o
-LIB_OBJS += $(OUTPUT)util/comm.o
-LIB_OBJS += $(OUTPUT)util/thread.o
-LIB_OBJS += $(OUTPUT)util/thread_map.o
-LIB_OBJS += $(OUTPUT)util/trace-event-parse.o
-LIB_OBJS += $(OUTPUT)util/parse-events-flex.o
-LIB_OBJS += $(OUTPUT)util/parse-events-bison.o
-LIB_OBJS += $(OUTPUT)util/pmu-flex.o
-LIB_OBJS += $(OUTPUT)util/pmu-bison.o
-LIB_OBJS += $(OUTPUT)util/trace-event-read.o
-LIB_OBJS += $(OUTPUT)util/trace-event-info.o
-LIB_OBJS += $(OUTPUT)util/trace-event-scripting.o
-LIB_OBJS += $(OUTPUT)util/trace-event.o
-LIB_OBJS += $(OUTPUT)util/svghelper.o
-LIB_OBJS += $(OUTPUT)util/sort.o
-LIB_OBJS += $(OUTPUT)util/hist.o
 LIB_OBJS += $(OUTPUT)util/probe-event.o
-LIB_OBJS += $(OUTPUT)util/util.o
-LIB_OBJS += $(OUTPUT)util/xyarray.o
-LIB_OBJS += $(OUTPUT)util/cpumap.o
-LIB_OBJS += $(OUTPUT)util/cgroup.o
-LIB_OBJS += $(OUTPUT)util/target.o
-LIB_OBJS += $(OUTPUT)util/rblist.o
-LIB_OBJS += $(OUTPUT)util/intlist.o
-LIB_OBJS += $(OUTPUT)util/vdso.o
-LIB_OBJS += $(OUTPUT)util/stat.o
-LIB_OBJS += $(OUTPUT)util/record.o
-LIB_OBJS += $(OUTPUT)util/srcline.o
-LIB_OBJS += $(OUTPUT)util/data.o
-LIB_OBJS += $(OUTPUT)util/tsc.o
-LIB_OBJS += $(OUTPUT)util/cloexec.o
-LIB_OBJS += $(OUTPUT)util/thread-stack.o
 
 LIB_OBJS += $(OUTPUT)ui/setup.o
 LIB_OBJS += $(OUTPUT)ui/helpline.o
@@ -423,8 +337,6 @@ LIB_OBJS += $(OUTPUT)ui/util.o
 LIB_OBJS += $(OUTPUT)ui/hist.o
 LIB_OBJS += $(OUTPUT)ui/stdio/hist.o
 
-LIB_OBJS += $(OUTPUT)arch/common.o
-
 BUILTIN_OBJS += $(OUTPUT)builtin-probe.o
 
 PERFLIBS = $(LIB_FILE) $(LIBAPIKFS) $(LIBTRACEEVENT)
@@ -547,7 +459,7 @@ strip: $(PROGRAMS) $(OUTPUT)perf
 
 PERF_IN := $(OUTPUT)perf-in.o
 
-export srctree OUTPUT RM CC LD AR CFLAGS V
+export srctree OUTPUT RM CC LD AR CFLAGS V BISON FLEX
 build := -f $(srctree)/tools/build/Makefile.build dir=. obj
 
 $(PERF_IN): FORCE
@@ -601,12 +513,6 @@ endif
 # These two need to be here so that when O= is not used they take precedence
 # over the general rule for .o
 
-$(OUTPUT)util/%-flex.o: $(OUTPUT)util/%-flex.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c -Iutil/ $(CFLAGS) -w $<
-
-$(OUTPUT)util/%-bison.o: $(OUTPUT)util/%-bison.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c -Iutil/ $(CFLAGS) -DYYENABLE_NLS=0 -DYYLTYPE_IS_TRIVIAL=0 -w $<
-
 $(OUTPUT)%.o: %.c $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) $<
 $(OUTPUT)%.i: %.c $(OUTPUT)PERF-CFLAGS
@@ -618,15 +524,6 @@ $(OUTPUT)%.o: %.S
 $(OUTPUT)%.s: %.S
 	$(QUIET_CC)$(CC) -o $@ -E $(CFLAGS) $<
 
-$(OUTPUT)util/exec_cmd.o: util/exec_cmd.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) \
-		'-DPERF_EXEC_PATH="$(perfexecdir_SQ)"' \
-		'-DPREFIX="$(prefix_SQ)"' \
-		$<
-
-$(OUTPUT)util/config.o: util/config.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) -DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"' $<
-
 $(OUTPUT)ui/setup.o: ui/setup.c $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) -DLIBDIR='"$(libdir_SQ)"' $<
 
@@ -645,21 +542,6 @@ $(OUTPUT)ui/browsers/map.o: ui/browsers/map.c $(OUTPUT)PERF-CFLAGS
 $(OUTPUT)ui/browsers/scripts.o: ui/browsers/scripts.c $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) -DENABLE_SLFUTURE_CONST $<
 
-$(OUTPUT)util/kallsyms.o: ../lib/symbol/kallsyms.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) $<
-
-$(OUTPUT)util/rbtree.o: ../../lib/rbtree.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) -Wno-unused-parameter -DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"' $<
-
-$(OUTPUT)util/hweight.o: ../../lib/hweight.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) -Wno-unused-parameter -DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"' $<
-
-$(OUTPUT)util/find_next_bit.o: ../lib/util/find_next_bit.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) -Wno-unused-parameter -DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"' $<
-
-$(OUTPUT)util/parse-events.o: util/parse-events.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) -Wno-redundant-decls $<
-
 $(OUTPUT)util/scripting-engines/trace-event-perl.o: util/scripting-engines/trace-event-perl.c $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) $(PERL_EMBED_CCOPTS) -Wno-redundant-decls -Wno-strict-prototypes -Wno-unused-parameter -Wno-shadow -Wno-undef -Wno-switch-default $<
 
@@ -703,8 +585,13 @@ $(DIRECTORY_DEPS): | $(OUTPUT_DIRECTORIES)
 $(OUTPUT_DIRECTORIES):
 	$(QUIET_MKDIR)$(MKDIR) -p $@ 2>/dev/null
 
-$(LIB_FILE): $(LIB_OBJS)
-	$(QUIET_AR)$(RM) $@ && $(AR) rcs $@ $(LIB_OBJS)
+LIBPERF_IN := $(OUTPUT)libperf-in.o
+
+$(LIBPERF_IN): FORCE
+	@$(MAKE) $(build)=libperf
+
+$(LIB_FILE): $(LIB_OBJS) $(LIBPERF_IN)
+	$(QUIET_AR)$(RM) $@ && $(AR) rcs $@ $(LIBPERF_IN) $(LIB_OBJS)
 
 # libtraceevent.a
 TE_SOURCES = $(wildcard $(TRACE_EVENT_DIR)*.[ch])
diff --git a/tools/perf/arch/Build b/tools/perf/arch/Build
new file mode 100644
index 000000000000..304f5e76c613
--- /dev/null
+++ b/tools/perf/arch/Build
@@ -0,0 +1 @@
+libperf-y += common.o
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index e8723b4134f1..0b61ec2c667d 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -122,6 +122,8 @@ ifdef PARSER_DEBUG
   PARSER_DEBUG_BISON := -t
   PARSER_DEBUG_FLEX  := -d
   CFLAGS             += -DPARSER_DEBUG
+  $(call detected_var,PARSER_DEBUG_BISON)
+  $(call detected_var,PARSER_DEBUG_FLEX)
 endif
 
 ifndef NO_LIBPYTHON
@@ -829,3 +831,6 @@ endif
 $(call detected_var,htmldir_SQ)
 $(call detected_var,infodir_SQ)
 $(call detected_var,mandir_SQ)
+$(call detected_var,ETC_PERFCONFIG_SQ)
+$(call detected_var,prefix_SQ)
+$(call detected_var,perfexecdir_SQ)
diff --git a/tools/perf/util/Build b/tools/perf/util/Build
new file mode 100644
index 000000000000..c107f309d29f
--- /dev/null
+++ b/tools/perf/util/Build
@@ -0,0 +1,116 @@
+libperf-y += abspath.o
+libperf-y += alias.o
+libperf-y += annotate.o
+libperf-y += build-id.o
+libperf-y += config.o
+libperf-y += ctype.o
+libperf-y += db-export.o
+libperf-y += environment.o
+libperf-y += event.o
+libperf-y += evlist.o
+libperf-y += evsel.o
+libperf-y += exec_cmd.o
+libperf-y += find_next_bit.o
+libperf-y += help.o
+libperf-y += kallsyms.o
+libperf-y += levenshtein.o
+libperf-y += parse-options.o
+libperf-y += parse-events.o
+libperf-y += path.o
+libperf-y += rbtree.o
+libperf-y += bitmap.o
+libperf-y += hweight.o
+libperf-y += run-command.o
+libperf-y += quote.o
+libperf-y += strbuf.o
+libperf-y += string.o
+libperf-y += strlist.o
+libperf-y += strfilter.o
+libperf-y += top.o
+libperf-y += usage.o
+libperf-y += wrapper.o
+libperf-y += sigchain.o
+libperf-y += dso.o
+libperf-y += symbol.o
+libperf-y += color.o
+libperf-y += pager.o
+libperf-y += header.o
+libperf-y += callchain.o
+libperf-y += values.o
+libperf-y += debug.o
+libperf-y += machine.o
+libperf-y += map.o
+libperf-y += pstack.o
+libperf-y += session.o
+libperf-y += ordered-events.o
+libperf-y += comm.o
+libperf-y += thread.o
+libperf-y += thread_map.o
+libperf-y += trace-event-parse.o
+libperf-y += parse-events-flex.o
+libperf-y += parse-events-bison.o
+libperf-y += pmu.o
+libperf-y += pmu-flex.o
+libperf-y += pmu-bison.o
+libperf-y += trace-event-read.o
+libperf-y += trace-event-info.o
+libperf-y += trace-event-scripting.o
+libperf-y += trace-event.o
+libperf-y += svghelper.o
+libperf-y += sort.o
+libperf-y += hist.o
+libperf-y += util.o
+libperf-y += xyarray.o
+libperf-y += cpumap.o
+libperf-y += cgroup.o
+libperf-y += target.o
+libperf-y += rblist.o
+libperf-y += intlist.o
+libperf-y += vdso.o
+libperf-y += stat.o
+libperf-y += record.o
+libperf-y += srcline.o
+libperf-y += data.o
+libperf-y += tsc.o
+libperf-y += cloexec.o
+libperf-y += thread-stack.o
+
+CFLAGS_config.o   += -DETC_PERFCONFIG="BUILD_STR($(ETC_PERFCONFIG_SQ))"
+CFLAGS_exec_cmd.o += -DPERF_EXEC_PATH="BUILD_STR($(perfexecdir_SQ))" -DPREFIX="BUILD_STR($(prefix_SQ))"
+
+$(OUTPUT)util/parse-events-flex.c: util/parse-events.l $(OUTPUT)util/parse-events-bison.c
+	@$(call echo-cmd,flex)$(FLEX) -o $@ --header-file=$(OUTPUT)util/parse-events-flex.h $(PARSER_DEBUG_FLEX) util/parse-events.l
+
+$(OUTPUT)util/parse-events-bison.c: util/parse-events.y
+	@$(call echo-cmd,bison)$(BISON) -v util/parse-events.y -d $(PARSER_DEBUG_BISON) -o $@ -p parse_events_
+
+$(OUTPUT)util/pmu-flex.c: util/pmu.l $(OUTPUT)util/pmu-bison.c
+	@$(call echo-cmd,flex)$(FLEX) -o $@ --header-file=$(OUTPUT)util/pmu-flex.h util/pmu.l
+
+$(OUTPUT)util/pmu-bison.c: util/pmu.y
+	@$(call echo-cmd,bison)$(BISON) -v util/pmu.y -d -o $@ -p perf_pmu_
+
+CFLAGS_parse-events-flex.o  += -w
+CFLAGS_pmu-flex.o           += -w
+CFLAGS_parse-events-bison.o += -DYYENABLE_NLS=0 -DYYLTYPE_IS_TRIVIAL=0 -w
+CFLAGS_pmu-bison.o          += -DYYENABLE_NLS=0 -DYYLTYPE_IS_TRIVIAL=0 -w
+
+$(OUTPUT)util/parse-events.o: $(OUTPUT)util/parse-events-flex.c $(OUTPUT)util/parse-events-bison.c
+$(OUTPUT)util/pmu.o: $(OUTPUT)util/pmu-flex.c $(OUTPUT)util/pmu-bison.c
+
+CFLAGS_find_next_bit.o += -Wno-unused-parameter -DETC_PERFCONFIG="BUILD_STR($(ETC_PERFCONFIG_SQ))"
+CFLAGS_rbtree.o        += -Wno-unused-parameter -DETC_PERFCONFIG="BUILD_STR($(ETC_PERFCONFIG_SQ))"
+CFLAGS_hweight.o       += -Wno-unused-parameter -DETC_PERFCONFIG="BUILD_STR($(ETC_PERFCONFIG_SQ))"
+CFLAGS_parse-events.o  += -Wno-redundant-decls
+
+$(OUTPUT)util/kallsyms.o: ../lib/symbol/kallsyms.c FORCE
+	$(call if_changed_dep,cc_o_c)
+
+$(OUTPUT)util/find_next_bit.o: ../lib/util/find_next_bit.c FORCE
+	$(call if_changed_dep,cc_o_c)
+
+$(OUTPUT)util/rbtree.o: ../../lib/rbtree.c FORCE
+	$(call if_changed_dep,cc_o_c)
+
+$(OUTPUT)util/hweight.o: ../../lib/hweight.c FORCE
+	$(call if_changed_dep,cc_o_c)
-- 
1.9.3

