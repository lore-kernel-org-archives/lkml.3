Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030428Ab3HIG2v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 02:28:51 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:54151 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030206Ab3HIG2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 02:28:12 -0400
X-AuditID: 9c930179-b7c0bae0000040ac-ee-52048bfae12e
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Pekka Enberg <penberg@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 1/3] perf tools: Separate out GTK codes to libperf-gtk.so
Date: Fri,  9 Aug 2013 15:28:07 +0900
Message-Id: <1376029689-32593-2-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1376029689-32593-1-git-send-email-namhyung@kernel.org>
References: <1376029689-32593-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Separate out GTK codes to a shared object called libperf-gtk.so.  This
time only GTK codes are built with -fPIC and libperf remains as is.

Cc: Andi Kleen <ak@linux.intel.com>
Reviewed-by: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/Makefile        | 42 ++++++++++++++++++++++++++++++------------
 tools/perf/config/Makefile | 14 ++++++++++----
 2 files changed, 40 insertions(+), 16 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index e0d3d9f96771..5f96eedf9767 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -113,6 +113,7 @@ SPARSE_FLAGS = -D__BIG_ENDIAN__ -D__powerpc__
 BUILTIN_OBJS =
 LIB_H =
 LIB_OBJS =
+GTK_OBJS =
 PYRF_OBJS =
 SCRIPT_SH =
 
@@ -485,13 +486,19 @@ ifndef NO_SLANG
 endif
 
 ifndef NO_GTK2
-  LIB_OBJS += $(OUTPUT)ui/gtk/browser.o
-  LIB_OBJS += $(OUTPUT)ui/gtk/hists.o
-  LIB_OBJS += $(OUTPUT)ui/gtk/setup.o
-  LIB_OBJS += $(OUTPUT)ui/gtk/util.o
-  LIB_OBJS += $(OUTPUT)ui/gtk/helpline.o
-  LIB_OBJS += $(OUTPUT)ui/gtk/progress.o
-  LIB_OBJS += $(OUTPUT)ui/gtk/annotate.o
+  ALL_PROGRAMS += $(OUTPUT)libperf-gtk.so
+
+  GTK_OBJS += $(OUTPUT)ui/gtk/browser.o
+  GTK_OBJS += $(OUTPUT)ui/gtk/hists.o
+  GTK_OBJS += $(OUTPUT)ui/gtk/setup.o
+  GTK_OBJS += $(OUTPUT)ui/gtk/util.o
+  GTK_OBJS += $(OUTPUT)ui/gtk/helpline.o
+  GTK_OBJS += $(OUTPUT)ui/gtk/progress.o
+  GTK_OBJS += $(OUTPUT)ui/gtk/annotate.o
+
+install-gtk: $(OUTPUT)libperf-gtk.so
+	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(libdir_SQ)'
+	$(INSTALL) $(OUTPUT)libperf-gtk.so '$(DESTDIR_SQ)$(libdir_SQ)'
 endif
 
 ifndef NO_LIBPERL
@@ -545,6 +552,12 @@ $(OUTPUT)perf: $(OUTPUT)perf.o $(BUILTIN_OBJS) $(PERFLIBS)
 	$(QUIET_LINK)$(CC) $(CFLAGS) $(LDFLAGS) $(OUTPUT)perf.o \
                $(BUILTIN_OBJS) $(LIBS) -o $@
 
+$(GTK_OBJS): $(OUTPUT)%.o: %.c $(LIB_H)
+	$(QUIET_CC)$(CC) -o $@ -c -fPIC $(CFLAGS) $(GTK_CFLAGS) $<
+
+$(OUTPUT)libperf-gtk.so: $(GTK_OBJS) $(PERFLIBS)
+	$(QUIET_LINK)$(CC) -o $@ -shared $(ALL_LDFLAGS) $(filter %.o,$^) $(GTK_LIBS)
+
 $(OUTPUT)builtin-help.o: builtin-help.c $(OUTPUT)common-cmds.h $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) \
 		'-DPERF_HTML_PATH="$(htmldir_SQ)"' \
@@ -654,7 +667,8 @@ $(patsubst perf-%,%.o,$(PROGRAMS)): $(LIB_H) $(wildcard */*.h)
 
 # we compile into subdirectories. if the target directory is not the source directory, they might not exists. So
 # we depend the various files onto their directories.
-DIRECTORY_DEPS = $(LIB_OBJS) $(BUILTIN_OBJS) $(OUTPUT)PERF-VERSION-FILE $(OUTPUT)common-cmds.h
+DIRECTORY_DEPS = $(LIB_OBJS) $(BUILTIN_OBJS) $(GTK_OBJS)
+DIRECTORY_DEPS += $(OUTPUT)PERF-VERSION-FILE $(OUTPUT)common-cmds.h
 $(DIRECTORY_DEPS): | $(sort $(dir $(DIRECTORY_DEPS)))
 # In the second step, we make a rule to actually create these directories
 $(sort $(dir $(DIRECTORY_DEPS))):
@@ -763,7 +777,9 @@ check: $(OUTPUT)common-cmds.h
 
 ### Installation rules
 
-install-bin: all
+install-gtk:
+
+install-bin: all install-gtk
 	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(bindir_SQ)'
 	$(INSTALL) $(OUTPUT)perf '$(DESTDIR_SQ)$(bindir_SQ)'
 	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/perl/Perf-Trace-Util/lib/Perf/Trace'
@@ -796,15 +812,17 @@ $(INSTALL_DOC_TARGETS):
 ### Cleaning rules
 
 clean: $(LIBTRACEEVENT)-clean $(LIBLK)-clean
-	$(RM) $(LIB_OBJS) $(BUILTIN_OBJS) $(LIB_FILE) $(OUTPUT)perf-archive $(OUTPUT)perf.o $(LANG_BINDINGS)
+	$(RM) $(LIB_OBJS) $(BUILTIN_OBJS) $(LIB_FILE) $(GTK_OBJS)
+	$(RM) $(OUTPUT)perf-archive $(OUTPUT)perf.o $(LANG_BINDINGS)
 	$(RM) $(ALL_PROGRAMS) perf
-	$(RM) *.spec *.pyc *.pyo */*.pyc */*.pyo $(OUTPUT)common-cmds.h TAGS tags cscope*
+	$(RM) *.spec *.pyc *.pyo */*.pyc */*.pyo
+	$(RM) $(OUTPUT)common-cmds.h TAGS tags cscope*
 	$(QUIET_SUBDIR0)Documentation $(QUIET_SUBDIR1) clean
 	$(RM) $(OUTPUT)PERF-VERSION-FILE $(OUTPUT)PERF-CFLAGS
 	$(RM) $(OUTPUT)util/*-bison*
 	$(RM) $(OUTPUT)util/*-flex*
 	$(python-clean)
 
-.PHONY: all install clean strip $(LIBTRACEEVENT) $(LIBLK)
+.PHONY: all install clean strip $(LIBTRACEEVENT) $(LIBLK) install-gtk
 .PHONY: shell_compatibility_test please_set_SHELL_PATH_to_a_more_modern_shell
 .PHONY: .FORCE-PERF-VERSION-FILE TAGS tags cscope .FORCE-PERF-CFLAGS
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 214e17e97e5c..6bdfd0302c4e 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -267,11 +267,11 @@ ifndef NO_GTK2
     NO_GTK2 := 1
   else
     ifeq ($(call try-cc,$(SOURCE_GTK2_INFOBAR),$(FLAGS_GTK2),-DHAVE_GTK_INFO_BAR),y)
-      CFLAGS += -DHAVE_GTK_INFO_BAR
+      GTK_CFLAGS := -DHAVE_GTK_INFO_BAR
     endif
-    CFLAGS += -DGTK2_SUPPORT
-    CFLAGS += $(shell pkg-config --cflags gtk+-2.0 2>/dev/null)
-    EXTLIBS += $(shell pkg-config --libs gtk+-2.0 2>/dev/null)
+    GTK_CFLAGS += -DGTK2_SUPPORT
+    GTK_CFLAGS += $(shell pkg-config --cflags gtk+-2.0 2>/dev/null)
+    GTK_LIBS := $(shell pkg-config --libs gtk+-2.0 2>/dev/null)
   endif
 endif
 
@@ -456,7 +456,12 @@ else
 sysconfdir = $(prefix)/etc
 ETC_PERFCONFIG = etc/perfconfig
 endif
+ifeq ($(IS_X86_64),1)
+lib = lib64
+else
 lib = lib
+endif
+libdir = $(prefix)/$(lib)
 
 # Shell quote (do not use $(call) to accommodate ancient setups);
 ETC_PERFCONFIG_SQ = $(subst ','\'',$(ETC_PERFCONFIG))
@@ -469,6 +474,7 @@ template_dir_SQ = $(subst ','\'',$(template_dir))
 htmldir_SQ = $(subst ','\'',$(htmldir))
 prefix_SQ = $(subst ','\'',$(prefix))
 sysconfdir_SQ = $(subst ','\'',$(sysconfdir))
+libdir_SQ = $(subst ','\'',$(libdir))
 
 ifneq ($(filter /%,$(firstword $(perfexecdir))),)
 perfexec_instdir = $(perfexecdir)
-- 
1.7.11.7

