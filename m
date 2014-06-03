Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404AbaFCWLx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 18:11:53 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:61042 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965272AbaFCWJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 18:09:09 -0400
From: Alexis Berlemont <alexis.berlemont@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Alexis Berlemont <alexis.berlemont@gmail.com>, jolsa@redhat.com,
        dsahern@gmail.com, mingo@kernel.org, sam@ravnborg.org, mmarek@suse.cz
Subject: [PATCH 24/32] perf kbuild: remove legacy libpython-related build variable
Date: Wed,  4 Jun 2014 00:06:17 +0200
Message-Id: <1401833185-10347-25-git-send-email-alexis.berlemont@gmail.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1401833185-10347-1-git-send-email-alexis.berlemont@gmail.com>
References: <1401833185-10347-1-git-send-email-alexis.berlemont@gmail.com>
In-Reply-To: <CAMesUR5h0687dTFCDC3LhKSOFyKTFmH3vUjU+p6XuOpawPUwxQ@mail.gmail.com>
References: <CAMesUR5h0687dTFCDC3LhKSOFyKTFmH3vUjU+p6XuOpawPUwxQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove NO_LIBPYTHON (replaced by CONFIG_LIBPYTHON)
---
 tools/perf/builtin-script.c             |  2 +-
 tools/perf/config/Makefile              | 43 +++++++++++----------------------
 tools/perf/config/Makefile.fix-config   |  8 ------
 tools/perf/config/Makefile.fix-legacy   |  4 ---
 tools/perf/util/trace-event-scripting.c |  3 ++-
 5 files changed, 17 insertions(+), 43 deletions(-)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index ff67f0d..3e59b24 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -1368,7 +1368,7 @@ int find_scripts(char **scripts_array, char **scripts_path_array)
 		if (strstr(lang_path, "perl"))
 			continue;
 #endif
-#ifdef NO_LIBPYTHON
+#ifndef CONFIG_LIBPYTHON
 		if (strstr(lang_path, "python"))
 			continue;
 #endif
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 36ba89f..1dd3469 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -469,27 +469,24 @@ ifdef CONFIG_TIMERFD
   endif
 endif
 
-disable-python = $(eval $(disable-python_code))
-define disable-python_code
-  CFLAGS += -DNO_LIBPYTHON
-  $(if $(1),$(warning No $(1) was found))
-  $(warning Python support will not be built)
-  NO_LIBPYTHON := 1
-endef
-
-override PYTHON := \
-  $(call get-executable-or-default,PYTHON,python)
+ifdef CONFIG_LIBPYTHON
 
-ifndef PYTHON
-  $(call disable-python,python interpreter)
-else
+  disable-python = $(eval $(disable-python_code))
+  define disable-python_code
+    $(if $(1),$(warning No $(1) was found))
+    $(warning Python support will not be built)
+    $(shell $(KCONFIG_SCRIPT) -d CONFIG_LIBPYTHON)
+  endef
 
-  PYTHON_WORD := $(call shell-wordify,$(PYTHON))
+  override PYTHON := \
+    $(call get-executable-or-default,PYTHON,python)
 
-  ifdef NO_LIBPYTHON
-    $(call disable-python)
+  ifndef PYTHON
+    $(call disable-python,python interpreter)
   else
 
+    PYTHON_WORD := $(call shell-wordify,$(PYTHON))
+
     override PYTHON_CONFIG := \
       $(call get-executable-or-default,PYTHON_CONFIG,$(PYTHON)-config)
 
@@ -510,18 +507,7 @@ else
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
@@ -769,7 +755,6 @@ all:
 	$(call store,PYTHON_EMBED_CCOPTS)
 	$(call store,PERL_EMBED_CCOPTS)
 	$(call store,CONFIG_X86_64)
-	$(call store,NO_LIBPYTHON)
 	$(call store,ETC_PERFCONFIG_SQ)
 	$(call store,DESTDIR_SQ)
 	$(call store,bindir_SQ)
diff --git a/tools/perf/config/Makefile.fix-config b/tools/perf/config/Makefile.fix-config
index 273f793..3f0e33e 100644
--- a/tools/perf/config/Makefile.fix-config
+++ b/tools/perf/config/Makefile.fix-config
@@ -3,12 +3,4 @@ include $(KCONFIG_CONFIG)
 
 CONFIG := $(srctree)/scripts/config --file $(KCONFIG_CONFIG)
 
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
index 275b6d9..431c9bf 100644
--- a/tools/perf/config/Makefile.fix-legacy
+++ b/tools/perf/config/Makefile.fix-legacy
@@ -1,6 +1,2 @@
 
 include $(KCONFIG_CONFIG)
-
-ifndef CONFIG_LIBPYTHON
-NO_LIBPYTHON := 1
-endif
diff --git a/tools/perf/util/trace-event-scripting.c b/tools/perf/util/trace-event-scripting.c
index 51d8019..4a70ef7 100644
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
-- 
1.9.3

