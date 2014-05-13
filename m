Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319AbaEMWH2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 18:07:28 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:47996 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932217AbaEMWFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 18:05:51 -0400
From: Alexis Berlemont <alexis.berlemont@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Alexis Berlemont <alexis.berlemont@gmail.com>, jolsa@redhat.com,
        acme@ghostprotocols.net, dsahern@gmail.com, mingo@kernel.org
Subject: [PATCH 28/34] perf kbuild: fix installation of traceevent plugins
Date: Wed, 14 May 2014 00:03:23 +0200
Message-Id: <1400018609-20486-29-git-send-email-alexis.berlemont@gmail.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1400018609-20486-1-git-send-email-alexis.berlemont@gmail.com>
References: <1400018609-20486-1-git-send-email-alexis.berlemont@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 tools/perf/Makefile.kbuild | 10 +++++++---
 tools/perf/config/Makefile |  1 +
 tools/perf/tests/make      |  3 ++-
 3 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/tools/perf/Makefile.kbuild b/tools/perf/Makefile.kbuild
index 2f980f7..5c034ad 100644
--- a/tools/perf/Makefile.kbuild
+++ b/tools/perf/Makefile.kbuild
@@ -92,7 +92,7 @@ export src-perf obj-perf
 
 OUTPUT := $(obj-perf)/
 
-export OUTPUT
+export OUTPUT DESTDIR
 
 AS      = as
 LD      = ld
@@ -214,6 +214,7 @@ export PARSER_DEBUG_BISON
 export PARSER_DEBUG_FLEX
 export ETC_PERFCONFIG_SQ
 export libdir_SQ
+export plugindir_SQ
 export PYTHON_EMBED_CCOPTS
 export PERL_EMBED_CCOPTS
 export GTK_CFLAGS
@@ -276,6 +277,9 @@ $(LIBTRACEEVENT)-clean: FORCE
 	@mkdir -p $(obj-kernel)/tools/lib/traceevent
 	$(Q)$(MAKE) -sC $(srctree)/tools/lib/traceevent O=$(obj-kernel)/tools/lib/traceevent clean
 
+$(LIBTRACEEVENT)-install: $(LIBTRACEEVENT) FORCE
+	$(Q)$(MAKE) -sC $(srctree)/tools/lib/traceevent O=$(obj-kernel)/tools/lib/traceevent plugin_dir=$(plugindir_SQ) install
+
 $(LIBAPIKFS): FORCE
 	@mkdir -p $(obj-kernel)/tools/lib/api
 	$(Q)$(MAKE) -C $(srctree)/tools/lib/api O=$(obj-kernel)/tools/lib/api
@@ -335,13 +339,13 @@ install-bin: all
 	$(INSTALL) $(src-perf)/scripts/python/*.py -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/python'
 	$(INSTALL) $(src-perf)/scripts/python/bin/* -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/python/bin'
 	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(sysconfdir_SQ)/bash_completion.d'
-	$(INSTALL) $(src-perf)/bash_completion '$(DESTDIR_SQ)$(sysconfdir_SQ)/bash_completion.d/perf'
+	$(INSTALL) $(src-perf)/perf-completion.sh '$(DESTDIR_SQ)$(sysconfdir_SQ)/bash_completion.d/perf'
 	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/tests'
 	$(INSTALL) $(src-perf)/tests/attr.py '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/tests'
 	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/tests/attr'
 	$(INSTALL) $(src-perf)/tests/attr/* '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/tests/attr'
 
-install: install-bin try-install-man
+install: install-bin try-install-man $(LIBTRACEEVENT)-install
 
 DOC_TARGETS := doc man html info pdf
 
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index b043c0e..ccade54 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -759,6 +759,7 @@ all:
 	$(call store,DESTDIR_SQ)
 	$(call store,bindir_SQ)
 	$(call store,libdir_SQ)
+	$(call store,plugindir_SQ)
 	$(call store,perfexec_instdir_SQ)
 	$(call store,sysconfdir_SQ)
 	$(call store,GTK_CFLAGS)
diff --git a/tools/perf/tests/make b/tools/perf/tests/make
index 2aa2ed7..fa60836 100644
--- a/tools/perf/tests/make
+++ b/tools/perf/tests/make
@@ -15,6 +15,7 @@ list = $(shell ls $1 2>/dev/null)
 has = $(shell which $1 2>/dev/null)
 
 # standard single make variable specified
+make_pure           := 
 make_clean_all      := clean all
 make_python_perf_so := python/perf.so
 make_tags           := tags
@@ -142,7 +143,7 @@ test_make_util_pmu_bison_o_O := test -f $$TMP_O/util/pmu-bison.o
 test_default = test -x $(PERF)/perf
 test = $(if $(test_$1),$(test_$1),$(test_default))
 
-test_default_O = test -x $$TMP_O/perf
+test_default_O = test -x $$TMP_O/tools/perf/perf
 test_O = $(if $(test_$1),$(test_$1),$(test_default_O))
 
 all:
-- 
1.9.2

