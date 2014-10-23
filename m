Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932157AbaJWWbb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 18:31:31 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:51382 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754577AbaJWWb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 18:31:28 -0400
From: Alexis Berlemont <alexis.berlemont@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Alexis Berlemont <alexis.berlemont@gmail.com>, jolsa@redhat.com,
        dsahern@gmail.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        paulus@samba.org, acme@kernel.org, namhyung@kernel.org, mmarek@suse.cz
Subject: [PATCH v3 12/14] perf kbuild: remove legacy script-related build variables
Date: Fri, 24 Oct 2014 00:28:20 +0200
Message-Id: <1414103302-14906-13-git-send-email-alexis.berlemont@gmail.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1414103302-14906-1-git-send-email-alexis.berlemont@gmail.com>
References: <1414103302-14906-1-git-send-email-alexis.berlemont@gmail.com>
In-Reply-To: <1414101372-14443-1-git-send-email-alexis.berlemont@gmail.com>
References: <1414101372-14443-1-git-send-email-alexis.berlemont@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove NO_LIBPERL (replaced by CONFIG_LIBPERL)
Remove NO_LIBPYTHON (replaced by CONFIG_LIBPYTHON)

Signed-off-by: Alexis Berlemont <alexis.berlemont@gmail.com>
---
 tools/perf/builtin-script.c             |  6 +++--
 tools/perf/config/Makefile              | 41 +++++++++------------------------
 tools/perf/config/Makefile.fix-config   | 16 -------------
 tools/perf/config/Makefile.fix-legacy   |  8 -------
 tools/perf/util/trace-event-scripting.c | 13 ++++++-----
 5 files changed, 22 insertions(+), 62 deletions(-)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 9708a12..cc9c305 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -1,3 +1,5 @@
+#include "generated/autoconf.h"
+
 #include "builtin.h"
 
 #include "perf.h"
@@ -1372,11 +1374,11 @@ int find_scripts(char **scripts_array, char **scripts_path_array)
 	for_each_lang(scripts_path, scripts_dir, lang_dirent, lang_next) {
 		snprintf(lang_path, MAXPATHLEN, "%s/%s", scripts_path,
 			 lang_dirent.d_name);
-#ifdef NO_LIBPERL
+#ifndef CONFIG_LIBPERL
 		if (strstr(lang_path, "perl"))
 			continue;
 #endif
-#ifdef NO_LIBPYTHON
+#ifndef CONFIG_LIBPYTHON
 		if (strstr(lang_path, "python"))
 			continue;
 #endif
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index f667229..00d118c 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -101,7 +101,7 @@ ifdef PARSER_DEBUG
   CFLAGS             += -DPARSER_DEBUG
 endif
 
-ifndef NO_LIBPYTHON
+ifdef CONFIG_LIBPYTHON
   # Try different combinations to accommodate systems that only have
   # python[2][-config] in weird combinations but always preferring
   # python2 and python2-config as per pep-0394. If we catch a
@@ -460,9 +460,7 @@ endif
 grep-libs  = $(filter -l%,$(1))
 strip-libs = $(filter-out -l%,$(1))
 
-ifdef NO_LIBPERL
-  CFLAGS += -DNO_LIBPERL
-else
+ifdef CONFIG_LIBPERL
   PERL_EMBED_LDOPTS = $(shell perl -MExtUtils::Embed -e ldopts 2>/dev/null)
   PERL_EMBED_LDFLAGS = $(call strip-libs,$(PERL_EMBED_LDOPTS))
   PERL_EMBED_LIBADD = $(call grep-libs,$(PERL_EMBED_LDOPTS))
@@ -470,9 +468,8 @@ else
   FLAGS_PERL_EMBED=$(PERL_EMBED_CCOPTS) $(PERL_EMBED_LDOPTS)
 
   ifneq ($(feature-libperl), 1)
-    CFLAGS += -DNO_LIBPERL
-    NO_LIBPERL := 1
     msg := $(warning Missing perl devel files. Disabling perl scripting support, consider installing perl-ExtUtils-Embed);
+    $(shell $(KCONFIG_SCRIPT) -d CONFIG_LIBPERL)
   else
     LDFLAGS += $(PERL_EMBED_LDFLAGS)
     EXTLIBS += $(PERL_EMBED_LIBADD)
@@ -486,17 +483,14 @@ ifdef CONFIG_TIMERFD
   endif
 endif
 
-disable-python = $(eval $(disable-python_code))
-define disable-python_code
-  CFLAGS += -DNO_LIBPYTHON
-  $(if $(1),$(warning No $(1) was found))
-  $(warning Python support will not be built)
-  NO_LIBPYTHON := 1
-endef
+ifdef CONFIG_LIBPYTHON
 
-ifdef NO_LIBPYTHON
-  $(call disable-python)
-else
+  disable-python = $(eval $(disable-python_code))
+  define disable-python_code
+    $(if $(1),$(warning No $(1) was found))
+    $(warning Python support will not be built)
+    $(shell $(KCONFIG_SCRIPT) -d CONFIG_LIBPYTHON)
+  endef
 
   ifndef PYTHON
     $(call disable-python,python interpreter)
@@ -520,18 +514,7 @@ else
       else
 
         ifneq ($(feature-libpython-version), 1)
-          $(warning Python 3 is not yet supported; please set)
-          $(warning PYTHON and/or PYTHON_CONFIG appropriately.)
-          $(warning If you also have Python 2 installed, then)
-          $(warning try something like:)
-          $(warning $(and ,))
-          $(warning $(and ,)  make PYTHON=python2)
-          $(warning $(and ,))
-          $(warning Otherwise, disable Python support entirely:)
-          $(warning $(and ,))
-          $(warning $(and ,)  make NO_LIBPYTHON=1)
-          $(warning $(and ,))
-          $(error   $(and ,))
+          $(call disable-python,python2 interpreter)
         else
           LDFLAGS += $(PYTHON_EMBED_LDFLAGS)
           EXTLIBS += $(PYTHON_EMBED_LIBADD)
@@ -781,8 +764,6 @@ all:
 	$(call store,PYTHON_EMBED_CCOPTS)
 	$(call store,PERL_EMBED_CCOPTS)
 	$(call store,NO_LIBUNWIND)
-	$(call store,NO_LIBPERL)
-	$(call store,NO_LIBPYTHON)
 	$(call store,ETC_PERFCONFIG_SQ)
 	$(call store,DESTDIR_SQ)
 	$(call store,bindir_SQ)
diff --git a/tools/perf/config/Makefile.fix-config b/tools/perf/config/Makefile.fix-config
index e63539f..3f0e33e 100644
--- a/tools/perf/config/Makefile.fix-config
+++ b/tools/perf/config/Makefile.fix-config
@@ -3,20 +3,4 @@ include $(KCONFIG_CONFIG)
 
 CONFIG := $(srctree)/scripts/config --file $(KCONFIG_CONFIG)
 
-# NO_LIBPERL
-ifdef CONFIG_LIBPERL
-ifdef NO_LIBPERL
-dummy := $(info Disabling CONFIG_LIBPERL)
-dummy := $(shell $(CONFIG) -d CONFIG_LIBPERL)
-endif
-endif
-
-# NO_LIBPYTHON
-ifdef CONFIG_LIBPYTHON
-ifdef NO_LIBPYTHON
-dummy := $(info Disabling CONFIG_LIBPYTHON)
-dummy := $(shell $(CONFIG) -d CONFIG_LIBPYTHON)
-endif
-endif
-
 all:
diff --git a/tools/perf/config/Makefile.fix-legacy b/tools/perf/config/Makefile.fix-legacy
index 20a4062..431c9bf 100644
--- a/tools/perf/config/Makefile.fix-legacy
+++ b/tools/perf/config/Makefile.fix-legacy
@@ -1,10 +1,2 @@
 
 include $(KCONFIG_CONFIG)
-
-ifndef CONFIG_LIBPERL
-NO_LIBPERL := 1
-endif
-
-ifndef CONFIG_LIBPYTHON
-NO_LIBPYTHON := 1
-endif
diff --git a/tools/perf/util/trace-event-scripting.c b/tools/perf/util/trace-event-scripting.c
index 5c9bdd1..a8319bb 100644
--- a/tools/perf/util/trace-event-scripting.c
+++ b/tools/perf/util/trace-event-scripting.c
@@ -24,6 +24,7 @@
 #include <string.h>
 #include <errno.h>
 
+#include "generated/autoconf.h"
 #include "../perf.h"
 #include "util.h"
 #include "trace-event.h"
@@ -99,7 +100,7 @@ static void register_python_scripting(struct scripting_ops *scripting_ops)
 	scripting_context = malloc(sizeof(struct scripting_context));
 }
 
-#ifdef NO_LIBPYTHON
+#ifndef CONFIG_LIBPYTHON
 void setup_python_scripting(void)
 {
 	register_python_scripting(&python_scripting_unsupported_ops);
@@ -163,16 +164,16 @@ static void register_perl_scripting(struct scripting_ops *scripting_ops)
 	scripting_context = malloc(sizeof(struct scripting_context));
 }
 
-#ifdef NO_LIBPERL
+#ifdef CONFIG_LIBPERL
+extern struct scripting_ops perl_scripting_ops;
+
 void setup_perl_scripting(void)
 {
-	register_perl_scripting(&perl_scripting_unsupported_ops);
+	register_perl_scripting(&perl_scripting_ops);
 }
 #else
-extern struct scripting_ops perl_scripting_ops;
-
 void setup_perl_scripting(void)
 {
-	register_perl_scripting(&perl_scripting_ops);
+	register_perl_scripting(&perl_scripting_unsupported_ops);
 }
 #endif
-- 
2.1.1

