Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957Ab3IPCLW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Sep 2013 22:11:22 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:42449 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755249Ab3IPCLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Sep 2013 22:11:21 -0400
X-AuditID: 9c93017d-b7cdfae0000026c0-9b-523668c737bc
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Borislav Petkov <bp@alien8.de>
Subject: [PATCH] perf tools: Use per-file CFLAGS in Makefile
Date: Mon, 16 Sep 2013 11:11:16 +0900
Message-Id: <1379297476-20793-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Some files need additional compiler flags to be built successfully.
Cleanup Makefile by using optional per-file CFLAGS which look like
CFLAGS_dir_filename.o

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/Makefile        | 128 ++++++++++++++++++---------------------------
 tools/perf/config/Makefile |   2 +-
 2 files changed, 52 insertions(+), 78 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 3a0ff7fb71b6..101df0a7e9a1 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -522,7 +522,8 @@ ifdef ASCIIDOC8
   export ASCIIDOC8
 endif
 
-LIBS = -Wl,--whole-archive $(PERFLIBS) -Wl,--no-whole-archive -Wl,--start-group $(EXTLIBS) -Wl,--end-group
+LIBS = -Wl,--whole-archive $(PERFLIBS) -Wl,--no-whole-archive
+LIBS += -Wl,--start-group $(EXTLIBS) -Wl,--end-group
 
 export INSTALL SHELL_PATH
 
@@ -549,17 +550,11 @@ $(OUTPUT)perf: $(OUTPUT)perf.o $(BUILTIN_OBJS) $(PERFLIBS)
 	$(QUIET_LINK)$(CC) $(CFLAGS) $(LDFLAGS) $(OUTPUT)perf.o \
                $(BUILTIN_OBJS) $(LIBS) -o $@
 
-$(OUTPUT)builtin-help.o: builtin-help.c $(OUTPUT)common-cmds.h $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) \
-		'-DPERF_HTML_PATH="$(htmldir_SQ)"' \
-		'-DPERF_MAN_PATH="$(mandir_SQ)"' \
-		'-DPERF_INFO_PATH="$(infodir_SQ)"' $<
+$(OUTPUT)perf-%: %.o $(PERFLIBS)
+	$(QUIET_LINK)$(CC) $(CFLAGS) -o $@ $(LDFLAGS) $(filter %.o,$^) $(LIBS)
 
-$(OUTPUT)builtin-timechart.o: builtin-timechart.c $(OUTPUT)common-cmds.h $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) \
-		'-DPERF_HTML_PATH="$(htmldir_SQ)"' \
-		'-DPERF_MAN_PATH="$(mandir_SQ)"' \
-		'-DPERF_INFO_PATH="$(infodir_SQ)"' $<
+$(LIB_OBJS) $(BUILTIN_OBJS): $(LIB_H)
+$(patsubst perf-%,%.o,$(PROGRAMS)): $(LIB_H) $(wildcard */*.h)
 
 $(OUTPUT)common-cmds.h: util/generate-cmdlist.sh command-list.txt
 
@@ -577,15 +572,6 @@ $(OUTPUT)perf.o perf.spec \
 .SUFFIXES:
 .SUFFIXES: .o .c .S .s
 
-# These two need to be here so that when O= is not used they take precedence
-# over the general rule for .o
-
-$(OUTPUT)util/%-flex.o: $(OUTPUT)util/%-flex.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c -Iutil/ $(CFLAGS) -w $<
-
-$(OUTPUT)util/%-bison.o: $(OUTPUT)util/%-bison.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c -Iutil/ $(CFLAGS) -DYYENABLE_NLS=0 -DYYLTYPE_IS_TRIVIAL=0 -w $<
-
 $(OUTPUT)%.o: %.c $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) $<
 $(OUTPUT)%.i: %.c $(OUTPUT)PERF-CFLAGS
@@ -597,64 +583,52 @@ $(OUTPUT)%.o: %.S
 $(OUTPUT)%.s: %.S
 	$(QUIET_CC)$(CC) -o $@ -E $(CFLAGS) $<
 
-$(OUTPUT)util/exec_cmd.o: util/exec_cmd.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) \
-		'-DPERF_EXEC_PATH="$(perfexecdir_SQ)"' \
-		'-DPREFIX="$(prefix_SQ)"' \
-		$<
-
-$(OUTPUT)tests/attr.o: tests/attr.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) \
-		'-DBINDIR="$(bindir_SQ)"' -DPYTHON='"$(PYTHON_WORD)"' \
-		$<
-
-$(OUTPUT)tests/python-use.o: tests/python-use.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) \
-		-DPYTHONPATH='"$(OUTPUT)python"' \
-		-DPYTHON='"$(PYTHON_WORD)"' \
-		$<
-
-$(OUTPUT)util/config.o: util/config.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) -DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"' $<
-
-$(OUTPUT)ui/browser.o: ui/browser.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) -DENABLE_SLFUTURE_CONST $<
-
-$(OUTPUT)ui/browsers/annotate.o: ui/browsers/annotate.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) -DENABLE_SLFUTURE_CONST $<
-
-$(OUTPUT)ui/browsers/hists.o: ui/browsers/hists.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) -DENABLE_SLFUTURE_CONST $<
-
-$(OUTPUT)ui/browsers/map.o: ui/browsers/map.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) -DENABLE_SLFUTURE_CONST $<
+# Support to pass additional cflags per file
+# Directory was separated by '_'
 
-$(OUTPUT)ui/browsers/scripts.o: ui/browsers/scripts.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) -DENABLE_SLFUTURE_CONST $<
-
-$(OUTPUT)util/rbtree.o: ../../lib/rbtree.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) -Wno-unused-parameter -DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"' $<
-
-$(OUTPUT)util/parse-events.o: util/parse-events.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) -Wno-redundant-decls $<
-
-$(OUTPUT)util/scripting-engines/trace-event-perl.o: util/scripting-engines/trace-event-perl.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) $(PERL_EMBED_CCOPTS) -Wno-redundant-decls -Wno-strict-prototypes -Wno-unused-parameter -Wno-shadow -Wno-undef -Wno-switch-default $<
-
-$(OUTPUT)scripts/perl/Perf-Trace-Util/Context.o: scripts/perl/Perf-Trace-Util/Context.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) $(PERL_EMBED_CCOPTS) -Wno-redundant-decls -Wno-strict-prototypes -Wno-unused-parameter -Wno-nested-externs -Wno-undef -Wno-switch-default $<
-
-$(OUTPUT)util/scripting-engines/trace-event-python.o: util/scripting-engines/trace-event-python.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) $(PYTHON_EMBED_CCOPTS) -Wno-redundant-decls -Wno-strict-prototypes -Wno-unused-parameter -Wno-shadow $<
-
-$(OUTPUT)scripts/python/Perf-Trace-Util/Context.o: scripts/python/Perf-Trace-Util/Context.c $(OUTPUT)PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) $(PYTHON_EMBED_CCOPTS) -Wno-redundant-decls -Wno-strict-prototypes -Wno-unused-parameter -Wno-nested-externs $<
-
-$(OUTPUT)perf-%: %.o $(PERFLIBS)
-	$(QUIET_LINK)$(CC) $(CFLAGS) -o $@ $(LDFLAGS) $(filter %.o,$^) $(LIBS)
-
-$(LIB_OBJS) $(BUILTIN_OBJS): $(LIB_H)
-$(patsubst perf-%,%.o,$(PROGRAMS)): $(LIB_H) $(wildcard */*.h)
+ifneq ($(OUTPUT),)
+_target = $(filter-out $(OUTPUT),$@)
+else
+_target = $@
+endif
+target = $(subst /,_,$(_target))
+
+CFLAGS += $(CFLAGS_$(target))
+
+slang_cflags = -DENABLE_SLFUTURE_CONST
+flex_cflags = -w
+bison_cflags = -DYYENABLE_NLS=0 -DYYLTYPE_IS_TRIVIAL=0 -w
+perl_cflags = $(PERL_EMBED_CCOPTS) -w
+python_cflags = $(PYTHON_EMBED_CCOPTS) -w
+
+CFLAGS_builtin-help.o = -DPERF_HTML_PATH='"$(htmldir_SQ)"'
+CFLAGS_builtin-help.o += -DPERF_MAN_PATH='"$(mandir_SQ)"'
+CFLAGS_builtin-help.o += -DPERF_INFO_PATH='"$(infodir_SQ)"'
+CFLAGS_builtin-timechart.o = -DPERF_HTML_PATH='"$(htmldir_SQ)"'
+CFLAGS_builtin-timechart.o += -DPERF_MAN_PATH='"$(mandir_SQ)"'
+CFLAGS_builtin-timechart.o += -DPERF_INFO_PATH='"$(infodir_SQ)"'
+CFLAGS_util_config.o = -DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"'
+CFLAGS_util_exec_cmd.o = -DPERF_EXEC_PATH='"$(perfexecdir_SQ)"'
+CFLAGS_util_exec_cmd.o += -DPREFIX='"$(prefix_SQ)"'
+CFLAGS_util_parse-events.o = -Wno-redundant-decls
+CFLAGS_util_parse-events-flex.o = $(flex_cflags)
+CFLAGS_util_parse-events-bison.o = $(bison_cflags)
+CFLAGS_util_pmu-flex.o = $(flex_cflags)
+CFLAGS_util_pmu-bison.o = $(bison_cflags)
+CFLAGS_util_rbtree.o = -Wno-unused-parameter
+CFLAGS_util_rbtree.o += -DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"'
+CFLAGS_tests_attr.o = -DBINDIR='"$(bindir_SQ)"' -DPYTHON='"$(PYTHON_WORD)"'
+CFLAGS_tests_python-use.o = -DPYTHONPATH='"$(OUTPUT)python"'
+CFLAGS_tests_python-use.o += -DPYTHON='"$(PYTHON_WORD)"'
+CFLAGS_ui_browser.o = $(slang_cflags)
+CFLAGS_ui_browsers_annotate.o = $(slang_cflags)
+CFLAGS_ui_browsers_hists.o = $(slang_cflags)
+CFLAGS_ui_browsers_map.o = $(slang_cflags)
+CFLAGS_ui_browsers_scripts.o = $(slang_cflags)
+CFLAGS_util_scripting-engines_trace-event-perl.o = $(perl_cflags)
+CFLAGS_util_scripting-engines_trace-event-python.o = $(python_cflags)
+CFLAGS_scripts_perl_Perf-Trace-Util_Context.o = $(perl_cflags)
+CFLAGS_scripts_python_Perf-Trace-Util_Context.o = $(python_cflags)
 
 # we compile into subdirectories. if the target directory is not the source directory, they might not exists. So
 # we depend the various files onto their directories.
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 214e17e97e5c..53efd35fcfde 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -6,7 +6,7 @@ ARCH ?= $(shell echo $(uname_M) | sed -e s/i.86/i386/ -e s/sun4u/sparc64/ \
                                   -e s/ppc.*/powerpc/ -e s/mips.*/mips/ \
                                   -e s/sh[234].*/sh/ -e s/aarch64.*/arm64/ )
 NO_PERF_REGS := 1
-CFLAGS := $(EXTRA_CFLAGS) $(EXTRA_WARNINGS)
+CFLAGS = $(EXTRA_CFLAGS) $(EXTRA_WARNINGS)
 
 # Additional ARCH settings for x86
 ifeq ($(ARCH),i386)
-- 
1.7.11.7

