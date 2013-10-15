Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933448Ab3JOFci (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:32:38 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33668 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932813Ab3JOFcd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:32:33 -0400
Date: Mon, 14 Oct 2013 22:32:18 -0700
From: tip-bot for Ingo Molnar <tipbot@zytor.com>
Message-ID: <tip-8a5411e9a3e65ab70b094022e5aa6deaec82ae7c@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, a.p.zijlstra@chello.nl, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1381312169-17354-5-git-send-email-mingo@kernel.org>
References: <1381312169-17354-5-git-send-email-mingo@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Implement summary output for '
 make install'
Git-Commit-ID: 8a5411e9a3e65ab70b094022e5aa6deaec82ae7c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:32:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8a5411e9a3e65ab70b094022e5aa6deaec82ae7c
Gitweb:     http://git.kernel.org/tip/8a5411e9a3e65ab70b094022e5aa6deaec82ae7c
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Wed, 9 Oct 2013 11:49:29 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 11 Oct 2013 12:18:11 -0300

perf tools: Implement summary output for 'make install'

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

Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: http://lkml.kernel.org/r/1381312169-17354-5-git-send-email-mingo@kernel.org
[ Fixed conflict with libperf-gtk patches in acme/perf/core, cope with 'trace' alias ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/Makefile | 27 +++++++++++---------
 tools/perf/Makefile.perf          | 54 ++++++++++++++++++++++-----------------
 tools/perf/config/utilities.mak   |  3 ++-
 3 files changed, 48 insertions(+), 36 deletions(-)

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
index f91bd5a..c873e03 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -504,8 +504,9 @@ ifndef NO_GTK2
   GTK_OBJS += $(OUTPUT)ui/gtk/annotate.o
 
 install-gtk: $(OUTPUT)libperf-gtk.so
-	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(libdir_SQ)'
-	$(INSTALL) $(OUTPUT)libperf-gtk.so '$(DESTDIR_SQ)$(libdir_SQ)'
+	$(call QUIET_INSTALL, 'GTK UI') \
+		$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(libdir_SQ)'; \
+		$(INSTALL) $(OUTPUT)libperf-gtk.so '$(DESTDIR_SQ)$(libdir_SQ)'
 endif
 
 ifndef NO_LIBPERL
@@ -810,31 +811,38 @@ check: $(OUTPUT)common-cmds.h
 install-gtk:
 
 install-bin: all install-gtk
-	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(bindir_SQ)'
-	$(INSTALL) $(OUTPUT)perf '$(DESTDIR_SQ)$(bindir_SQ)'
-	$(LN) '$(DESTDIR_SQ)$(bindir_SQ)/perf' '$(DESTDIR_SQ)$(bindir_SQ)/trace'
-	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(perfexec_instdir_SQ)'
-	$(INSTALL) $(OUTPUT)perf-archive -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)'
+	$(call QUIET_INSTALL, binaries) \
+		$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(bindir_SQ)'; \
+		$(INSTALL) $(OUTPUT)perf '$(DESTDIR_SQ)$(bindir_SQ)'; \
+		$(LN) '$(DESTDIR_SQ)$(bindir_SQ)/perf' '$(DESTDIR_SQ)$(bindir_SQ)/trace'
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
index 94908a5..f168deb 100644
--- a/tools/perf/config/utilities.mak
+++ b/tools/perf/config/utilities.mak
@@ -181,6 +181,7 @@ _gea_err  = $(if $(1),$(error Please set '$(1)' appropriately))
 
 ifneq ($(findstring $(MAKEFLAGS),s),s)
   ifneq ($(V),1)
-    QUIET_CLEAN      = @printf '  CLEAN %s\n' $(1);
+    QUIET_CLEAN		= @printf '  CLEAN    %s\n' $1;
+    QUIET_INSTALL	= @printf '  INSTALL  %s\n' $1;
   endif
 endif
