Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933400Ab3JOFcQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:32:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33628 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398Ab3JOFcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:32:08 -0400
Date: Mon, 14 Oct 2013 22:31:52 -0700
From: tip-bot for Ingo Molnar <tipbot@zytor.com>
Message-ID: <tip-8ec19c0eba73d7221e93e993c1c8bd62484354e9@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, a.p.zijlstra@chello.nl, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1381312169-17354-2-git-send-email-mingo@kernel.org>
References: <1381312169-17354-2-git-send-email-mingo@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Implement summary output for '
 make clean'
Git-Commit-ID: 8ec19c0eba73d7221e93e993c1c8bd62484354e9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:31:58 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8ec19c0eba73d7221e93e993c1c8bd62484354e9
Gitweb:     http://git.kernel.org/tip/8ec19c0eba73d7221e93e993c1c8bd62484354e9
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Wed, 9 Oct 2013 11:49:26 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 11 Oct 2013 12:18:06 -0300

perf tools: Implement summary output for 'make clean'

'make clean' used to show all the rm lines, which isn't really
informative in any way and spams the console.

Implement summary output:

  comet:~/tip/tools/perf> make clean
   CLEAN libtraceevent
   CLEAN liblk
   CLEAN config
   CLEAN core-objs
   CLEAN core-progs
   CLEAN core-gen
   CLEAN Documentation
   CLEAN python

'make clean V=1' will still show the old, detailed output.

Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1381312169-17354-2-git-send-email-mingo@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/Makefile | 18 ++++++++++--------
 tools/perf/Makefile.perf          | 24 ++++++++++++------------
 tools/perf/config/utilities.mak   |  6 ++++++
 tools/scripts/Makefile.include    |  2 +-
 4 files changed, 29 insertions(+), 21 deletions(-)

diff --git a/tools/perf/Documentation/Makefile b/tools/perf/Documentation/Makefile
index eaa477f..be5adb1 100644
--- a/tools/perf/Documentation/Makefile
+++ b/tools/perf/Documentation/Makefile
@@ -246,15 +246,17 @@ $(OUTPUT)cmd-list.made: cmd-list.perl ../command-list.txt $(MAN1_TXT)
 	$(PERL_PATH) ./cmd-list.perl ../command-list.txt $(QUIET_STDERR) && \
 	date >$@
 
+CLEAN_FILES =									\
+	$(MAN_XML) $(addsuffix +,$(MAN_XML))					\
+	$(MAN_HTML) $(addsuffix +,$(MAN_HTML))					\
+	$(DOC_HTML) $(DOC_MAN1) $(DOC_MAN5) $(DOC_MAN7)				\
+	$(OUTPUT)*.texi $(OUTPUT)*.texi+ $(OUTPUT)*.texi++			\
+	$(OUTPUT)perf.info $(OUTPUT)perfman.info				\
+	$(OUTPUT)howto-index.txt $(OUTPUT)howto/*.html $(OUTPUT)doc.dep		\
+	$(OUTPUT)technical/api-*.html $(OUTPUT)technical/api-index.txt		\
+	$(cmds_txt) $(OUTPUT)*.made
 clean:
-	$(RM) $(MAN_XML) $(addsuffix +,$(MAN_XML))
-	$(RM) $(MAN_HTML) $(addsuffix +,$(MAN_HTML))
-	$(RM) $(DOC_HTML) $(DOC_MAN1) $(DOC_MAN5) $(DOC_MAN7)
-	$(RM) $(OUTPUT)*.texi $(OUTPUT)*.texi+ $(OUTPUT)*.texi++
-	$(RM) $(OUTPUT)perf.info $(OUTPUT)perfman.info
-	$(RM) $(OUTPUT)howto-index.txt $(OUTPUT)howto/*.html $(OUTPUT)doc.dep
-	$(RM) $(OUTPUT)technical/api-*.html $(OUTPUT)technical/api-index.txt
-	$(RM) $(cmds_txt) $(OUTPUT)*.made
+	$(call QUIET_CLEAN, Documentation) $(RM) $(CLEAN_FILES)
 
 $(MAN_HTML): $(OUTPUT)%.html : %.txt
 	$(QUIET_ASCIIDOC)$(RM) $@+ $@ && \
diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 8bc6d0c..250b276 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -148,7 +148,7 @@ PYTHON_EXTBUILD_LIB := $(PYTHON_EXTBUILD)lib/
 PYTHON_EXTBUILD_TMP := $(PYTHON_EXTBUILD)tmp/
 export PYTHON_EXTBUILD_LIB PYTHON_EXTBUILD_TMP
 
-python-clean := rm -rf $(PYTHON_EXTBUILD) $(OUTPUT)python/perf.so
+python-clean := $(call QUIET_CLEAN, python) $(RM) -r $(PYTHON_EXTBUILD) $(OUTPUT)python/perf.so
 
 PYTHON_EXT_SRCS := $(shell grep -v ^\# util/python-ext-sources)
 PYTHON_EXT_DEPS := util/python-ext-sources util/setup.py $(LIBTRACEEVENT) $(LIBLK)
@@ -708,7 +708,8 @@ $(LIBTRACEEVENT): $(TE_SOURCES)
 	$(QUIET_SUBDIR0)$(TRACE_EVENT_DIR) $(QUIET_SUBDIR1) O=$(OUTPUT) libtraceevent.a
 
 $(LIBTRACEEVENT)-clean:
-	$(QUIET_SUBDIR0)$(TRACE_EVENT_DIR) $(QUIET_SUBDIR1) O=$(OUTPUT) clean
+	$(call QUIET_CLEAN, libtraceevent)
+	@$(MAKE) -C $(TRACE_EVENT_DIR) O=$(OUTPUT) clean >/dev/null
 
 LIBLK_SOURCES = $(wildcard $(LK_PATH)*.[ch])
 
@@ -721,7 +722,8 @@ endif
 
 $(LIBLK)-clean:
 ifeq ($(subdir),)
-	$(QUIET_SUBDIR0)$(LK_DIR) $(QUIET_SUBDIR1) O=$(OUTPUT) clean
+	$(call QUIET_CLEAN, liblk)
+	@$(MAKE) -C $(LK_DIR) O=$(OUTPUT) clean >/dev/null
 endif
 
 help:
@@ -850,17 +852,15 @@ $(INSTALL_DOC_TARGETS):
 # not get included for the clean target:
 #
 config-clean:
-	@$(MAKE) -C config/feature-checks clean
+	$(call QUIET_CLEAN, config)
+	@$(MAKE) -C config/feature-checks clean >/dev/null
 
 clean: $(LIBTRACEEVENT)-clean $(LIBLK)-clean config-clean
-	$(RM) $(LIB_OBJS) $(BUILTIN_OBJS) $(LIB_FILE) $(GTK_OBJS)
-	$(RM) $(OUTPUT)perf-archive $(OUTPUT)perf.o $(LANG_BINDINGS)
-	$(RM) $(ALL_PROGRAMS) perf
-	$(RM) *.spec *.pyc *.pyo */*.pyc */*.pyo $(OUTPUT)common-cmds.h TAGS tags cscope*
-	$(QUIET_SUBDIR0)Documentation $(QUIET_SUBDIR1) clean
-	$(RM) $(OUTPUT)PERF-VERSION-FILE $(OUTPUT)PERF-CFLAGS
-	$(RM) $(OUTPUT)util/*-bison*
-	$(RM) $(OUTPUT)util/*-flex*
+	$(call QUIET_CLEAN, core-objs)  $(RM) $(LIB_OBJS) $(BUILTIN_OBJS) $(LIB_FILE) $(OUTPUT)perf-archive $(OUTPUT)perf.o $(LANG_BINDINGS) $(GTK_OBJS)
+	$(call QUIET_CLEAN, core-progs) $(RM) $(ALL_PROGRAMS) perf
+	$(call QUIET_CLEAN, core-gen)   $(RM)  *.spec *.pyc *.pyo */*.pyc */*.pyo $(OUTPUT)common-cmds.h TAGS tags cscope* $(OUTPUT)PERF-VERSION-FILE $(OUTPUT)PERF-CFLAGS $(OUTPUT)util/*-bison* $(OUTPUT)util/*-flex*
+	$(call QUIET_CLEAN, Documentation)
+	@$(MAKE) -C Documentation O=$(OUTPUT) clean >/dev/null
 	$(python-clean)
 
 #
diff --git a/tools/perf/config/utilities.mak b/tools/perf/config/utilities.mak
index 4d985e0..94908a5 100644
--- a/tools/perf/config/utilities.mak
+++ b/tools/perf/config/utilities.mak
@@ -178,3 +178,9 @@ endef
 _ge_attempt = $(if $(get-executable),$(get-executable),$(_gea_warn)$(call _gea_err,$(2)))
 _gea_warn = $(warning The path '$(1)' is not executable.)
 _gea_err  = $(if $(1),$(error Please set '$(1)' appropriately))
+
+ifneq ($(findstring $(MAKEFLAGS),s),s)
+  ifneq ($(V),1)
+    QUIET_CLEAN      = @printf '  CLEAN %s\n' $(1);
+  endif
+endif
diff --git a/tools/scripts/Makefile.include b/tools/scripts/Makefile.include
index 0d0506d..1853736 100644
--- a/tools/scripts/Makefile.include
+++ b/tools/scripts/Makefile.include
@@ -66,7 +66,7 @@ ifneq ($(V),1)
 	QUIET_MKDIR    = @echo '   ' MKDIR $@;
 	QUIET_GEN      = @echo '   ' GEN $@;
 	QUIET_SUBDIR0  = +@subdir=
-	QUIET_SUBDIR1  = ;$(NO_SUBDIR) echo '   ' SUBDIR $$subdir; \
+	QUIET_SUBDIR1  = ;$(NO_SUBDIR) echo '  ' SUBDIR $$subdir; \
 			 $(MAKE) $(PRINT_DIR) -C $$subdir
 	QUIET_FLEX     = @echo '   ' FLEX $@;
 	QUIET_BISON    = @echo '   ' BISON $@;
