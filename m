Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757126Ab3JIJuQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 05:50:16 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:64767 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497Ab3JIJtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 05:49:41 -0400
From: Ingo Molnar <mingo@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 4/4] tools/perf/build: Implement summary output for 'make install'
Date: Wed,  9 Oct 2013 11:49:29 +0200
Message-Id: <1381312169-17354-5-git-send-email-mingo@kernel.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1381312169-17354-1-git-send-email-mingo@kernel.org>
References: <1381312169-17354-1-git-send-email-mingo@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'make install' used to show all the install lines, which is way too
verbose to be really informative to the user.

Implement summary output instead:

  comet:~/tip/tools/perf> make install
    BUILD:   Doing 'make -j12' parallel build
    SUBDIR   Documentation
    INSTALL  Documentation-man
    INSTALL  binaries
    INSTALL  libexec
    INSTALL  perf-archive
    INSTALL  perl-scripts
    INSTALL  python-scripts
    INSTALL  bash_completion-script
    INSTALL  tests

'make install V=1' will still show the old, detailed output.

Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/Documentation/Makefile | 27 +++++++++++++++------------
 tools/perf/Makefile.perf          | 47 +++++++++++++++++++++++++++--------------------
 tools/perf/config/utilities.mak   |  3 ++-
 3 files changed, 44 insertions(+), 33 deletions(-)

diff --git a/tools/perf/Documentation/Makefile b/tools/perf/Documentation/Makefile
index c4c300c..3ba1c0b 100644
--- a/tools/perf/Documentation/Makefile
+++ b/tools/perf/Documentation/Makefile
@@ -184,12 +184,13 @@ ifdef missing_tools
 endif
 
 do-install-man: man
-	$(INSTALL) -d -m 755 $(DESTDIR)$(man1dir)
-#	$(INSTALL) -d -m 755 $(DESTDIR)$(man5dir)
-#	$(INSTALL) -d -m 755 $(DESTDIR)$(man7dir)
-	$(INSTALL) -m 644 $(DOC_MAN1) $(DESTDIR)$(man1dir)
-#	$(INSTALL) -m 644 $(DOC_MAN5) $(DESTDIR)$(man5dir)
-#	$(INSTALL) -m 644 $(DOC_MAN7) $(DESTDIR)$(man7dir)
+	$(call QUIET_INSTALL, Documentation-man) \
+		$(INSTALL) -d -m 755 $(DESTDIR)$(man1dir); \
+#		$(INSTALL) -d -m 755 $(DESTDIR)$(man5dir); \
+#		$(INSTALL) -d -m 755 $(DESTDIR)$(man7dir); \
+		$(INSTALL) -m 644 $(DOC_MAN1) $(DESTDIR)$(man1dir); \
+#		$(INSTALL) -m 644 $(DOC_MAN5) $(DESTDIR)$(man5dir); \
+#		$(INSTALL) -m 644 $(DOC_MAN7) $(DESTDIR)$(man7dir)
 
 install-man: check-man-tools man
 
@@ -202,18 +203,20 @@ endif
 try-install-man: $(DO_INSTALL_MAN)
 
 install-info: info
-	$(INSTALL) -d -m 755 $(DESTDIR)$(infodir)
-	$(INSTALL) -m 644 $(OUTPUT)perf.info $(OUTPUT)perfman.info $(DESTDIR)$(infodir)
+	$(call QUIET_INSTALL, Documentation-info) \
+		$(INSTALL) -d -m 755 $(DESTDIR)$(infodir); \
+		$(INSTALL) -m 644 $(OUTPUT)perf.info $(OUTPUT)perfman.info $(DESTDIR)$(infodir); \
 	if test -r $(DESTDIR)$(infodir)/dir; then \
-	  $(INSTALL_INFO) --info-dir=$(DESTDIR)$(infodir) perf.info ;\
-	  $(INSTALL_INFO) --info-dir=$(DESTDIR)$(infodir) perfman.info ;\
+		$(INSTALL_INFO) --info-dir=$(DESTDIR)$(infodir) perf.info ;\
+		$(INSTALL_INFO) --info-dir=$(DESTDIR)$(infodir) perfman.info ;\
 	else \
 	  echo "No directory found in $(DESTDIR)$(infodir)" >&2 ; \
 	fi
 
 install-pdf: pdf
-	$(INSTALL) -d -m 755 $(DESTDIR)$(pdfdir)
-	$(INSTALL) -m 644 $(OUTPUT)user-manual.pdf $(DESTDIR)$(pdfdir)
+	$(call QUIET_INSTALL, Documentation-pdf) \
+		$(INSTALL) -d -m 755 $(DESTDIR)$(pdfdir); \
+		$(INSTALL) -m 644 $(OUTPUT)user-manual.pdf $(DESTDIR)$(pdfdir)
 
 #install-html: html
 #	'$(SHELL_PATH_SQ)' ./install-webdoc.sh $(DESTDIR)$(htmldir)
diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 112d71a..ee97778 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -789,30 +789,37 @@ check: $(OUTPUT)common-cmds.h
 ### Installation rules
 
 install-bin: all
-	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(bindir_SQ)'
-	$(INSTALL) $(OUTPUT)perf '$(DESTDIR_SQ)$(bindir_SQ)'
-	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(perfexec_instdir_SQ)'
-	$(INSTALL) $(OUTPUT)perf-archive -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)'
+	$(call QUIET_INSTALL, binaries) \
+		$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(bindir_SQ)'; \
+		$(INSTALL) $(OUTPUT)perf '$(DESTDIR_SQ)$(bindir_SQ)'
+	$(call QUIET_INSTALL, libexec) \
+		$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(perfexec_instdir_SQ)'
+	$(call QUIET_INSTALL, perf-archive) \
+		$(INSTALL) $(OUTPUT)perf-archive -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)'
 ifndef NO_LIBPERL
-	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/perl/Perf-Trace-Util/lib/Perf/Trace'
-	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/perl/bin'
-	$(INSTALL) scripts/perl/Perf-Trace-Util/lib/Perf/Trace/* -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/perl/Perf-Trace-Util/lib/Perf/Trace'
-	$(INSTALL) scripts/perl/*.pl -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/perl'
-	$(INSTALL) scripts/perl/bin/* -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/perl/bin'
+	$(call QUIET_INSTALL, perl-scripts) \
+		$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/perl/Perf-Trace-Util/lib/Perf/Trace'; \
+		$(INSTALL) scripts/perl/Perf-Trace-Util/lib/Perf/Trace/* -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/perl/Perf-Trace-Util/lib/Perf/Trace'; \
+		$(INSTALL) scripts/perl/*.pl -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/perl'; \
+		$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/perl/bin'; \
+		$(INSTALL) scripts/perl/bin/* -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/perl/bin'
 endif
 ifndef NO_LIBPYTHON
-	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/python/Perf-Trace-Util/lib/Perf/Trace'
-	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/python/bin'
-	$(INSTALL) scripts/python/Perf-Trace-Util/lib/Perf/Trace/* -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/python/Perf-Trace-Util/lib/Perf/Trace'
-	$(INSTALL) scripts/python/*.py -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/python'
-	$(INSTALL) scripts/python/bin/* -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/python/bin'
+	$(call QUIET_INSTALL, python-scripts) \
+		$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/python/Perf-Trace-Util/lib/Perf/Trace'; \
+		$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/python/bin'; \
+		$(INSTALL) scripts/python/Perf-Trace-Util/lib/Perf/Trace/* -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/python/Perf-Trace-Util/lib/Perf/Trace'; \
+		$(INSTALL) scripts/python/*.py -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/python'; \
+		$(INSTALL) scripts/python/bin/* -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/python/bin'
 endif
-	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(sysconfdir_SQ)/bash_completion.d'
-	$(INSTALL) bash_completion '$(DESTDIR_SQ)$(sysconfdir_SQ)/bash_completion.d/perf'
-	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/tests'
-	$(INSTALL) tests/attr.py '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/tests'
-	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/tests/attr'
-	$(INSTALL) tests/attr/* '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/tests/attr'
+	$(call QUIET_INSTALL, bash_completion-script) \
+		$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(sysconfdir_SQ)/bash_completion.d'; \
+		$(INSTALL) bash_completion '$(DESTDIR_SQ)$(sysconfdir_SQ)/bash_completion.d/perf'
+	$(call QUIET_INSTALL, tests) \
+		$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/tests'; \
+		$(INSTALL) tests/attr.py '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/tests'; \
+		$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/tests/attr'; \
+		$(INSTALL) tests/attr/* '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/tests/attr'
 
 install: install-bin try-install-man
 
diff --git a/tools/perf/config/utilities.mak b/tools/perf/config/utilities.mak
index 573f471..ddaf131 100644
--- a/tools/perf/config/utilities.mak
+++ b/tools/perf/config/utilities.mak
@@ -181,7 +181,8 @@ _gea_err  = $(if $(1),$(error Please set '$(1)' appropriately))
 
 ifneq ($(findstring $(MAKEFLAGS),s),s)
   ifneq ($(V),1)
-    QUIET_CLEAN      = @printf '  CLEAN %s\n' $(1);
+    QUIET_CLEAN		= @printf '  CLEAN    %s\n' $1;
+    QUIET_INSTALL	= @printf '  INSTALL  %s\n' $1;
   endif
 endif
 
-- 
1.8.3.1

