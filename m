Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932399Ab3JNUUa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:20:30 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39006 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757715Ab3JNUDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:03:06 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 134/161] tools: Harmonize the various build messages in perf, lib-traceevent, lib-lk
Date: Mon, 14 Oct 2013 17:02:03 -0300
Message-Id: <1381780950-25642-135-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1381780950-25642-1-git-send-email-acme@infradead.org>
References: <1381780950-25642-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@kernel.org>

The various build lines from libtraceevent and perf mix up during a
parallel build and produce unaligned output like:

    CC builtin-buildid-list.o
    CC builtin-buildid-cache.o
    CC builtin-list.o
  CC FPIC            trace-seq.o
    CC builtin-record.o
  CC FPIC            parse-filter.o
    CC builtin-report.o
    CC builtin-stat.o
  CC FPIC            parse-utils.o
  CC FPIC            kbuffer-parse.o
    CC builtin-timechart.o
    CC builtin-top.o
    CC builtin-script.o
  BUILD STATIC LIB   libtraceevent.a
    CC builtin-probe.o
    CC builtin-kmem.o
    CC builtin-lock.o

To solve this, harmonize all the build message alignments to be similar
to the kernel's kbuild output: prefixed by two spaces and 11-char wide.

After the patch the output looks pretty tidy, even if output lines get
mixed up:

  CC      builtin-annotate.o
  FLAGS:  * new build flags or cross compiler
  CC      builtin-bench.o
  AR      liblk.a
  CC      bench/sched-messaging.o
  CC FPIC event-parse.o
  CC      bench/sched-pipe.o
  CC FPIC trace-seq.o
  CC      bench/mem-memcpy.o
  CC      bench/mem-memset.o
  CC FPIC parse-filter.o
  CC      builtin-diff.o
  CC      builtin-evlist.o
  CC      builtin-help.o

Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1381312169-17354-3-git-send-email-mingo@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/Makefile     | 18 +++++++++---------
 tools/perf/Documentation/Makefile | 17 +++++++++--------
 tools/perf/Makefile               |  2 +-
 tools/perf/Makefile.perf          |  2 +-
 tools/scripts/Makefile.include    | 23 ++++++++++++-----------
 5 files changed, 32 insertions(+), 30 deletions(-)

diff --git a/tools/lib/traceevent/Makefile b/tools/lib/traceevent/Makefile
index ca6cb779876a..fc1502098595 100644
--- a/tools/lib/traceevent/Makefile
+++ b/tools/lib/traceevent/Makefile
@@ -134,14 +134,14 @@ ifeq ($(VERBOSE),1)
   print_install =
 else
   Q = @
-  print_compile =		echo '  CC                 '$(OBJ);
-  print_app_build =		echo '  BUILD              '$(OBJ);
-  print_fpic_compile =		echo '  CC FPIC            '$(OBJ);
-  print_shared_lib_compile =	echo '  BUILD SHARED LIB   '$(OBJ);
-  print_plugin_obj_compile =	echo '  CC PLUGIN OBJ      '$(OBJ);
-  print_plugin_build =		echo '  CC PLUGI           '$(OBJ);
-  print_static_lib_build =	echo '  BUILD STATIC LIB   '$(OBJ);
-  print_install =		echo '  INSTALL     '$1'	to	$(DESTDIR_SQ)$2';
+  print_compile =		echo '  CC       '$(OBJ);
+  print_app_build =		echo '  BUILD    '$(OBJ);
+  print_fpic_compile =		echo '  CC FPIC  '$(OBJ);
+  print_shared_lib_compile =	echo '  BUILD    SHARED LIB '$(OBJ);
+  print_plugin_obj_compile =	echo '  BUILD    PLUGIN OBJ '$(OBJ);
+  print_plugin_build =		echo '  BUILD    PLUGIN     '$(OBJ);
+  print_static_lib_build =	echo '  BUILD    STATIC LIB '$(OBJ);
+  print_install =		echo '  INSTALL  '$1'	to	$(DESTDIR_SQ)$2';
 endif
 
 do_fpic_compile =					\
@@ -268,7 +268,7 @@ TRACK_CFLAGS = $(subst ','\'',$(CFLAGS)):$(ARCH):$(CROSS_COMPILE)
 TRACEEVENT-CFLAGS: force
 	@FLAGS='$(TRACK_CFLAGS)'; \
 	    if test x"$$FLAGS" != x"`cat TRACEEVENT-CFLAGS 2>/dev/null`" ; then \
-		echo 1>&2 "    * new build flags or cross compiler"; \
+		echo 1>&2 "  FLAGS:   * new build flags or cross compiler"; \
 		echo "$$FLAGS" >TRACEEVENT-CFLAGS; \
             fi
 
diff --git a/tools/perf/Documentation/Makefile b/tools/perf/Documentation/Makefile
index be5adb1e0290..c4c300cf155f 100644
--- a/tools/perf/Documentation/Makefile
+++ b/tools/perf/Documentation/Makefile
@@ -145,16 +145,17 @@ endif
 
 ifneq ($(findstring $(MAKEFLAGS),s),s)
 ifneq ($(V),1)
-	QUIET_ASCIIDOC	= @echo '   ' ASCIIDOC $@;
-	QUIET_XMLTO	= @echo '   ' XMLTO $@;
-	QUIET_DB2TEXI	= @echo '   ' DB2TEXI $@;
-	QUIET_MAKEINFO	= @echo '   ' MAKEINFO $@;
-	QUIET_DBLATEX	= @echo '   ' DBLATEX $@;
-	QUIET_XSLTPROC	= @echo '   ' XSLTPROC $@;
-	QUIET_GEN	= @echo '   ' GEN $@;
+	QUIET_ASCIIDOC	= @echo '  ASCIIDOC '$@;
+	QUIET_XMLTO	= @echo '  XMLTO    '$@;
+	QUIET_DB2TEXI	= @echo '  DB2TEXI  '$@;
+	QUIET_MAKEINFO	= @echo '  MAKEINFO '$@;
+	QUIET_DBLATEX	= @echo '  DBLATEX  '$@;
+	QUIET_XSLTPROC	= @echo '  XSLTPROC '$@;
+	QUIET_GEN	= @echo '  GEN      '$@;
 	QUIET_STDERR	= 2> /dev/null
 	QUIET_SUBDIR0	= +@subdir=
-	QUIET_SUBDIR1	= ;$(NO_SUBDIR) echo '   ' SUBDIR $$subdir; \
+	QUIET_SUBDIR1	= ;$(NO_SUBDIR) \
+			   echo '  SUBDIR   ' $$subdir; \
 			  $(MAKE) $(PRINT_DIR) -C $$subdir
 	export V
 endif
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 9580ebe260e0..5aa3d040bbf3 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -38,7 +38,7 @@ ifneq ($(O),)
 endif
 
 define print_msg
-  @printf '    BUILD: Doing '\''make \033[33m-j'$(JOBS)'\033[m'\'' parallel build\n'
+  @printf '  BUILD:   Doing '\''make \033[33m-j'$(JOBS)'\033[m'\'' parallel build\n'
 endef
 
 define make
diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 250b276c136f..f91bd5a9b50a 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -784,7 +784,7 @@ TRACK_CFLAGS = $(subst ','\'',$(CFLAGS)):\
 $(OUTPUT)PERF-CFLAGS: .FORCE-PERF-CFLAGS
 	@FLAGS='$(TRACK_CFLAGS)'; \
 	    if test x"$$FLAGS" != x"`cat $(OUTPUT)PERF-CFLAGS 2>/dev/null`" ; then \
-		echo 1>&2 "    * new build flags or prefix"; \
+		echo 1>&2 "  FLAGS:   * new build flags or prefix"; \
 		echo "$$FLAGS" >$(OUTPUT)PERF-CFLAGS; \
             fi
 
diff --git a/tools/scripts/Makefile.include b/tools/scripts/Makefile.include
index 1853736c8106..ee76544deecb 100644
--- a/tools/scripts/Makefile.include
+++ b/tools/scripts/Makefile.include
@@ -59,21 +59,22 @@ QUIET_SUBDIR0  = +$(MAKE) $(COMMAND_O) -C # space to separate -C and subdir
 QUIET_SUBDIR1  =
 
 ifneq ($(findstring $(MAKEFLAGS),s),s)
-ifneq ($(V),1)
-	QUIET_CC       = @echo '   ' CC $@;
-	QUIET_AR       = @echo '   ' AR $@;
-	QUIET_LINK     = @echo '   ' LINK $@;
-	QUIET_MKDIR    = @echo '   ' MKDIR $@;
-	QUIET_GEN      = @echo '   ' GEN $@;
+  ifneq ($(V),1)
+	QUIET_CC       = @echo '  CC       '$@;
+	QUIET_AR       = @echo '  AR       '$@;
+	QUIET_LINK     = @echo '  LINK     '$@;
+	QUIET_MKDIR    = @echo '  MKDIR    '$@;
+	QUIET_GEN      = @echo '  GEN      '$@;
 	QUIET_SUBDIR0  = +@subdir=
-	QUIET_SUBDIR1  = ;$(NO_SUBDIR) echo '  ' SUBDIR $$subdir; \
+	QUIET_SUBDIR1  = ;$(NO_SUBDIR) \
+			  echo '  SUBDIR   '$$subdir; \
 			 $(MAKE) $(PRINT_DIR) -C $$subdir
-	QUIET_FLEX     = @echo '   ' FLEX $@;
-	QUIET_BISON    = @echo '   ' BISON $@;
+	QUIET_FLEX     = @echo '  FLEX     '$@;
+	QUIET_BISON    = @echo '  BISON    '$@;
 
 	descend = \
-		+@echo '   ' DESCEND $(1); \
+		+@echo	       '  DESCEND  '$(1); \
 		mkdir -p $(OUTPUT)$(1) && \
 		$(MAKE) $(COMMAND_O) subdir=$(if $(subdir),$(subdir)/$(1),$(1)) $(PRINT_DIR) -C $(1) $(2)
-endif
+  endif
 endif
-- 
1.8.1.4

