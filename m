Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932106AbaIVV4S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 17:56:18 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:52977 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932080AbaIVV4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 17:56:14 -0400
From: Alexis Berlemont <alexis.berlemont@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Alexis Berlemont <alexis.berlemont@gmail.com>, jolsa@redhat.com,
        dsahern@gmail.com, mingo@kernel.org, sam@ravnborg.org, mmarek@suse.cz,
        namhyung@kernel.org
Subject: [PATCH 12/15] perf kbuild: remove legacy script-related build variables
Date: Mon, 22 Sep 2014 23:53:13 +0200
Message-Id: <1411422796-27049-13-git-send-email-alexis.berlemont@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1411422796-27049-1-git-send-email-alexis.berlemont@gmail.com>
References: <1411422796-27049-1-git-send-email-alexis.berlemont@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove NO_LIBPERL (replaced by CONFIG_LIBPERL)
Remove NO_LIBPYTHON (replaced by CONFIG_LIBPYTHON)
---
 tools/perf/builtin-script.c             |  6 ++--
 tools/perf/config/Makefile              | 51 +++++++++++----------------------
 tools/perf/config/Makefile.fix-config   | 16 -----------
 tools/perf/config/Makefile.fix-legacy   |  8 ------
 tools/perf/util/trace-event-scripting.c | 13 +++++----
 5 files changed, 27 insertions(+), 67 deletions(-)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index f57035b..3d2ecbf 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -1,3 +1,5 @@
+#include "generated/autoconf.h"
+
 #include "builtin.h"
 
 #include "perf.h"
@@ -1340,11 +1342,11 @@ int find_scripts(char **scripts_array, char **scripts_path_array)
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
index d555782..6dab83b 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -449,9 +449,7 @@ endif
 grep-libs  = $(filter -l%,$(1))
 strip-libs = $(filter-out -l%,$(1))
 
-ifdef NO_LIBPERL
-  CFLAGS += -DNO_LIBPERL
-else
+ifdef CONFIG_LIBPERL
   PERL_EMBED_LDOPTS = $(shell perl -MExtUtils::Embed -e ldopts 2>/dev/null)
   PERL_EMBED_LDFLAGS = $(call strip-libs,$(PERL_EMBED_LDOPTS))
   PERL_EMBED_LIBADD = $(call grep-libs,$(PERL_EMBED_LDOPTS))
@@ -459,9 +457,8 @@ else
   FLAGS_PERL_EMBED=$(PERL_EMBED_CCOPTS) $(PERL_EMBED_LDOPTS)
 
   ifneq ($(feature-libperl), 1)
-    CFLAGS += -DNO_LIBPERL
-    NO_LIBPERL := 1
     msg := $(warning Missing perl devel files. Disabling perl scripting support, consider installing perl-ExtUtils-Embed);
+    $(shell $(KCONFIG_SCRIPT) -d CONFIG_LIBPERL)
   else
     LDFLAGS += $(PERL_EMBED_LDFLAGS)
     EXTLIBS += $(PERL_EMBED_LIBADD)
@@ -475,27 +472,24 @@ ifdef CONFIG_TIMERFD
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
 
-override PYTHON := \
-  $(call get-executable-or-default,PYTHON,python)
+  disable-python = $(eval $(disable-python_code))
+  define disable-python_code
+    $(if $(1),$(warning No $(1) was found))
+    $(warning Python support will not be built)
+    $(shell $(KCONFIG_SCRIPT) -d CONFIG_LIBPYTHON)
+  endef
 
-ifndef PYTHON
-  $(call disable-python,python interpreter)
-else
+  override PYTHON := \
+    $(call get-executable-or-default,PYTHON,python)
 
-  PYTHON_WORD := $(call shell-wordify,$(PYTHON))
-
-  ifdef NO_LIBPYTHON
-    $(call disable-python)
+  ifndef PYTHON
+    $(call disable-python,python interpreter)
   else
 
+    PYTHON_WORD := $(call shell-wordify,$(PYTHON))
+
     override PYTHON_CONFIG := \
       $(call get-executable-or-default,PYTHON_CONFIG,$(PYTHON)-config)
 
@@ -516,18 +510,7 @@ else
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
@@ -775,8 +758,6 @@ all:
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
index 57aaccc..4a70ef7 100644
--- a/tools/perf/util/trace-event-scripting.c
+++ b/tools/perf/util/trace-event-scripting.c
@@ -24,6 +24,7 @@
 #include <string.h>
 #include <errno.h>
 
+#include "generated/autoconf.h"
 #include "../perf.h"
 #include "util.h"
 #include "trace-event.h"
@@ -93,7 +94,7 @@ static void register_python_scripting(struct scripting_ops *scripting_ops)
 	scripting_context = malloc(sizeof(struct scripting_context));
 }
 
-#ifdef NO_LIBPYTHON
+#ifndef CONFIG_LIBPYTHON
 void setup_python_scripting(void)
 {
 	register_python_scripting(&python_scripting_unsupported_ops);
@@ -156,16 +157,16 @@ static void register_perl_scripting(struct scripting_ops *scripting_ops)
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
2.1.0

