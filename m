Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755282AbbAZKPA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 05:15:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52490 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755212AbbAZKOx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 05:14:53 -0500
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
Subject: [PATCH 16/36] perf build: Add scripts objects building
Date: Mon, 26 Jan 2015 11:12:16 +0100
Message-Id: <1422267156-13873-17-git-send-email-jolsa@kernel.org>
In-Reply-To: <1422267156-13873-1-git-send-email-jolsa@kernel.org>
References: <1422267156-13873-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the scripts objects building under build framework
to be included in the libperf build object.

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
 tools/perf/Build                                |  1 +
 tools/perf/Makefile.perf                        | 22 ----------------------
 tools/perf/config/Makefile                      |  4 ++++
 tools/perf/scripts/Build                        |  2 ++
 tools/perf/scripts/perl/Perf-Trace-Util/Build   |  3 +++
 tools/perf/scripts/python/Perf-Trace-Util/Build |  3 +++
 tools/perf/util/Build                           |  2 ++
 tools/perf/util/scripting-engines/Build         |  6 ++++++
 8 files changed, 21 insertions(+), 22 deletions(-)
 create mode 100644 tools/perf/scripts/Build
 create mode 100644 tools/perf/scripts/perl/Perf-Trace-Util/Build
 create mode 100644 tools/perf/scripts/python/Perf-Trace-Util/Build
 create mode 100644 tools/perf/util/scripting-engines/Build

diff --git a/tools/perf/Build b/tools/perf/Build
index a9ff8fd0bff9..133ec649e5a2 100644
--- a/tools/perf/Build
+++ b/tools/perf/Build
@@ -35,5 +35,6 @@ CFLAGS_builtin-timechart.o += $(paths)
 libperf-y += util/
 libperf-y += arch/
 libperf-y += ui/
+libperf-y += scripts/
 
 gtk-y += ui/gtk/
diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 523de5cfcf48..ddf814aba60d 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -349,16 +349,6 @@ install-gtk: $(OUTPUT)libperf-gtk.so
 		$(INSTALL) $(OUTPUT)libperf-gtk.so '$(DESTDIR_SQ)$(libdir_SQ)'
 endif
 
-ifndef NO_LIBPERL
-  LIB_OBJS += $(OUTPUT)util/scripting-engines/trace-event-perl.o
-  LIB_OBJS += $(OUTPUT)scripts/perl/Perf-Trace-Util/Context.o
-endif
-
-ifndef NO_LIBPYTHON
-  LIB_OBJS += $(OUTPUT)util/scripting-engines/trace-event-python.o
-  LIB_OBJS += $(OUTPUT)scripts/python/Perf-Trace-Util/Context.o
-endif
-
 ifeq ($(NO_PERF_REGS),0)
   ifeq ($(ARCH),x86)
     LIB_H += arch/x86/include/perf_regs.h
@@ -459,18 +449,6 @@ $(OUTPUT)%.o: %.S
 $(OUTPUT)%.s: %.S
 	$(QUIET_CC)$(CC) -o $@ -E $(CFLAGS) $<
 
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
 $(OUTPUT)perf-%: %.o $(PERFLIBS)
 	$(QUIET_LINK)$(CC) $(CFLAGS) -o $@ $(LDFLAGS) $(filter %.o,$^) $(LIBS)
 
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 05b6724fdb19..fe5d09cc75c2 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -512,6 +512,7 @@ else
   else
     LDFLAGS += $(PERL_EMBED_LDFLAGS)
     EXTLIBS += $(PERL_EMBED_LIBADD)
+    $(call detected,CONFIG_LIBPERL)
   endif
 endif
 
@@ -571,6 +572,7 @@ else
           LDFLAGS += $(PYTHON_EMBED_LDFLAGS)
           EXTLIBS += $(PYTHON_EMBED_LIBADD)
           LANG_BINDINGS += $(obj-perf)python/perf.so
+          $(call detected,CONFIG_LIBPYTHON)
         endif
       endif
     endif
@@ -841,3 +843,5 @@ $(call detected_var,prefix_SQ)
 $(call detected_var,perfexecdir_SQ)
 $(call detected_var,LIBDIR)
 $(call detected_var,GTK_CFLAGS)
+$(call detected_var,PERL_EMBED_CCOPTS)
+$(call detected_var,PYTHON_EMBED_CCOPTS)
diff --git a/tools/perf/scripts/Build b/tools/perf/scripts/Build
new file mode 100644
index 000000000000..41efd7e368b3
--- /dev/null
+++ b/tools/perf/scripts/Build
@@ -0,0 +1,2 @@
+libperf-$(CONFIG_LIBPERL)   += perl/Perf-Trace-Util/
+libperf-$(CONFIG_LIBPYTHON) += python/Perf-Trace-Util/
diff --git a/tools/perf/scripts/perl/Perf-Trace-Util/Build b/tools/perf/scripts/perl/Perf-Trace-Util/Build
new file mode 100644
index 000000000000..928e110179cb
--- /dev/null
+++ b/tools/perf/scripts/perl/Perf-Trace-Util/Build
@@ -0,0 +1,3 @@
+libperf-y += Context.o
+
+CFLAGS_Context.o += $(PERL_EMBED_CCOPTS) -Wno-redundant-decls -Wno-strict-prototypes -Wno-unused-parameter -Wno-nested-externs -Wno-undef -Wno-switch-default
diff --git a/tools/perf/scripts/python/Perf-Trace-Util/Build b/tools/perf/scripts/python/Perf-Trace-Util/Build
new file mode 100644
index 000000000000..aefc15c9444a
--- /dev/null
+++ b/tools/perf/scripts/python/Perf-Trace-Util/Build
@@ -0,0 +1,3 @@
+libperf-y += Context.o
+
+CFLAGS_Context.o += $(PYTHON_EMBED_CCOPTS) -Wno-redundant-decls -Wno-strict-prototypes -Wno-unused-parameter -Wno-nested-externs
diff --git a/tools/perf/util/Build b/tools/perf/util/Build
index 0401a80bab09..b0a65429da6c 100644
--- a/tools/perf/util/Build
+++ b/tools/perf/util/Build
@@ -88,6 +88,8 @@ libperf-$(CONFIG_DWARF) += dwarf-aux.o
 libperf-$(CONFIG_LIBDW_DWARF_UNWIND) += unwind-libdw.o
 libperf-$(CONFIG_LIBUNWIND)          += unwind-libunwind.o
 
+libperf-y += scripting-engines/
+
 CFLAGS_config.o   += -DETC_PERFCONFIG="BUILD_STR($(ETC_PERFCONFIG_SQ))"
 CFLAGS_exec_cmd.o += -DPERF_EXEC_PATH="BUILD_STR($(perfexecdir_SQ))" -DPREFIX="BUILD_STR($(prefix_SQ))"
 
diff --git a/tools/perf/util/scripting-engines/Build b/tools/perf/util/scripting-engines/Build
new file mode 100644
index 000000000000..6516e220c247
--- /dev/null
+++ b/tools/perf/util/scripting-engines/Build
@@ -0,0 +1,6 @@
+libperf-$(CONFIG_LIBPERL)   += trace-event-perl.o
+libperf-$(CONFIG_LIBPYTHON) += trace-event-python.o
+
+CFLAGS_trace-event-perl.o += $(PERL_EMBED_CCOPTS) -Wno-redundant-decls -Wno-strict-prototypes -Wno-unused-parameter -Wno-shadow -Wno-undef -Wno-switch-default
+
+CFLAGS_trace-event-python.o += $(PYTHON_EMBED_CCOPTS) -Wno-redundant-decls -Wno-strict-prototypes -Wno-unused-parameter -Wno-shadow
-- 
1.9.3

