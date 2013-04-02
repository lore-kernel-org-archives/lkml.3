Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760295Ab3DBDxs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 23:53:48 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:37736 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760280Ab3DBDxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 23:53:46 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>, Borislav Petkov <bp@alien8.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 03/23] perf: make python support based on CONFIG_LIBPYTHON
Date: Mon,  1 Apr 2013 21:53:09 -0600
Message-Id: <1364874809-5575-4-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1364874809-5575-1-git-send-email-dsahern@gmail.com>
References: <1364874809-5575-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/Makefile                     |  105 +++++++++++++++----------------
 tools/perf/Pconfig                      |    3 +
 tools/perf/builtin-script.c             |    2 +-
 tools/perf/config/feature-tests.mak     |    2 +-
 tools/perf/util/trace-event-scripting.c |   17 +++--
 5 files changed, 61 insertions(+), 68 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index af7b746..2225c3d 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -16,8 +16,6 @@ include config/utilities.mak
 #
 # Define CROSS_COMPILE as prefix name of compiler if you want cross-builds.
 #
-# Define NO_LIBPYTHON to disable python script extension.
-#
 # Define PYTHON to point to the python binary if the default
 # `python' is not correct; for example: PYTHON=python2
 #
@@ -733,69 +731,64 @@ ifdef CONFIG_LIBPERL
     LIB_OBJS += $(OUTPUT)scripts/perl/Perf-Trace-Util/Context.o
 endif
 
-disable-python = $(eval $(disable-python_code))
-define disable-python_code
-  BASIC_CFLAGS += -DNO_LIBPYTHON
-  $(if $(1),$(warning No $(1) was found))
-  $(warning Python support will not be built)
-endef
+ifdef CONFIG_LIBPYTHON
+    override PYTHON := \
+        $(call get-executable-or-default,PYTHON,python)
 
-override PYTHON := \
-  $(call get-executable-or-default,PYTHON,python)
+    ifndef PYTHON
+        $(error python interpreter not found. Install it or unset CONFIG_LIBPYTHON to continue.)
+    endif
 
-ifndef PYTHON
-  $(call disable-python,python interpreter)
-else
+    PYTHON_WORD := $(call shell-wordify,$(PYTHON))
 
-  PYTHON_WORD := $(call shell-wordify,$(PYTHON))
+    # python extension build directories
+    PYTHON_EXTBUILD     := $(OUTPUT)python_ext_build/
+    PYTHON_EXTBUILD_LIB := $(PYTHON_EXTBUILD)lib/
+    PYTHON_EXTBUILD_TMP := $(PYTHON_EXTBUILD)tmp/
+    export PYTHON_EXTBUILD_LIB PYTHON_EXTBUILD_TMP
 
-  ifdef NO_LIBPYTHON
-    $(call disable-python)
-  else
+    python-clean := rm -rf $(PYTHON_EXTBUILD) $(OUTPUT)python/perf.so
 
     override PYTHON_CONFIG := \
-      $(call get-executable-or-default,PYTHON_CONFIG,$(PYTHON)-config)
+        $(call get-executable-or-default,PYTHON_CONFIG,$(PYTHON)-config)
 
     ifndef PYTHON_CONFIG
-      $(call disable-python,python-config tool)
-    else
-
-      PYTHON_CONFIG_SQ := $(call shell-sq,$(PYTHON_CONFIG))
-
-      PYTHON_EMBED_LDOPTS := $(shell $(PYTHON_CONFIG_SQ) --ldflags 2>/dev/null)
-      PYTHON_EMBED_LDFLAGS := $(call strip-libs,$(PYTHON_EMBED_LDOPTS))
-      PYTHON_EMBED_LIBADD := $(call grep-libs,$(PYTHON_EMBED_LDOPTS))
-      PYTHON_EMBED_CCOPTS := $(shell $(PYTHON_CONFIG_SQ) --cflags 2>/dev/null)
-      FLAGS_PYTHON_EMBED := $(PYTHON_EMBED_CCOPTS) $(PYTHON_EMBED_LDOPTS)
-
-      ifneq ($(call try-cc,$(SOURCE_PYTHON_EMBED),$(FLAGS_PYTHON_EMBED),python),y)
-        $(call disable-python,Python.h (for Python 2.x))
-      else
-
-        ifneq ($(call try-cc,$(SOURCE_PYTHON_VERSION),$(FLAGS_PYTHON_EMBED),python version),y)
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
-        else
-          ALL_LDFLAGS += $(PYTHON_EMBED_LDFLAGS)
-          EXTLIBS += $(PYTHON_EMBED_LIBADD)
-          LIB_OBJS += $(OUTPUT)util/scripting-engines/trace-event-python.o
-          LIB_OBJS += $(OUTPUT)scripts/python/Perf-Trace-Util/Context.o
-          LANG_BINDINGS += $(OUTPUT)python/perf.so
-        endif
-
-      endif
+        $(error python-config not found. Install it or unset CONFIG_LIBPYTHON to continue.)
     endif
-  endif
+
+    PYTHON_CONFIG_SQ := $(call shell-sq,$(PYTHON_CONFIG))
+
+    PYTHON_EMBED_LDOPTS := $(shell $(PYTHON_CONFIG_SQ) --ldflags 2>/dev/null)
+    PYTHON_EMBED_LDFLAGS := $(call strip-libs,$(PYTHON_EMBED_LDOPTS))
+    PYTHON_EMBED_LIBADD := $(call grep-libs,$(PYTHON_EMBED_LDOPTS))
+    PYTHON_EMBED_CCOPTS := $(shell $(PYTHON_CONFIG_SQ) --cflags 2>/dev/null)
+    FLAGS_PYTHON_EMBED := $(PYTHON_EMBED_CCOPTS) $(PYTHON_EMBED_LDOPTS)
+
+    ifneq ($(call try-cc,$(SOURCE_PYTHON_EMBED),$(FLAGS_PYTHON_EMBED)),y)
+        $(warning Failed to detect python development kit.)
+        $(warning Install it or unset CONFIG_LIBPYTHON to continue.)
+        $(warning e.g., apt-get install python-dev (ubuntu).)
+        $(warning       yum install python-devel (Fedora).)
+        $(error )
+    endif
+
+    ifneq ($(call try-cc,$(SOURCE_PYTHON_VERSION),$(FLAGS_PYTHON_EMBED),python version),y)
+        $(warning Python 3 is not yet supported; please set)
+        $(warning PYTHON and/or PYTHON_CONFIG appropriately.)
+        $(warning If you also have Python 2 installed, then)
+        $(warning try something like:)
+        $(warning $(and ,))
+        $(warning $(and ,)  make PYTHON=python2)
+        $(warning $(and ,))
+        $(warning Otherwise, disable Python support entirely by unsetting CONFIG_LIBPYTHON.)
+        $(error   $(and ,))
+    endif
+
+    ALL_LDFLAGS   += $(PYTHON_EMBED_LDFLAGS)
+    EXTLIBS       += $(PYTHON_EMBED_LIBADD)
+    LIB_OBJS      += $(OUTPUT)util/scripting-engines/trace-event-python.o
+    LIB_OBJS      += $(OUTPUT)scripts/python/Perf-Trace-Util/Context.o
+    LANG_BINDINGS += $(OUTPUT)python/perf.so
 endif
 
 ifdef NO_DEMANGLE
diff --git a/tools/perf/Pconfig b/tools/perf/Pconfig
index a636af3..67ae110 100644
--- a/tools/perf/Pconfig
+++ b/tools/perf/Pconfig
@@ -1,2 +1,5 @@
 config LIBPERL
     bool "Enable support for perl scripting engine"
+
+config LIBPYTHON
+    bool "Enable support for python scripting engine"
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 7841533..e57b87d 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -1115,7 +1115,7 @@ int find_scripts(char **scripts_array, char **scripts_path_array)
 		if (strstr(lang_path, "perl"))
 			continue;
 #endif
-#ifdef NO_LIBPYTHON
+#ifndef CONFIG_LIBPYTHON
 		if (strstr(lang_path, "python"))
 			continue;
 #endif
diff --git a/tools/perf/config/feature-tests.mak b/tools/perf/config/feature-tests.mak
index 1222b33..2a2fa3b 100644
--- a/tools/perf/config/feature-tests.mak
+++ b/tools/perf/config/feature-tests.mak
@@ -115,7 +115,7 @@ return 0;
 endef
 endif
 
-ifndef NO_LIBPYTHON
+ifdef CONFIG_LIBPYTHON
 define SOURCE_PYTHON_VERSION
 #include <Python.h>
 #if PY_VERSION_HEX >= 0x03000000
diff --git a/tools/perf/util/trace-event-scripting.c b/tools/perf/util/trace-event-scripting.c
index 3343d97..932d480 100644
--- a/tools/perf/util/trace-event-scripting.c
+++ b/tools/perf/util/trace-event-scripting.c
@@ -46,11 +46,8 @@ static void process_event_unsupported(union perf_event *event __maybe_unused,
 
 static void print_python_unsupported_msg(void)
 {
-	fprintf(stderr, "Python scripting not supported."
-		"  Install libpython and rebuild perf to enable it.\n"
-		"For example:\n  # apt-get install python-dev (ubuntu)"
-		"\n  # yum install python-devel (Fedora)"
-		"\n  etc.\n");
+	fprintf(stderr, "Python scripting not supported.\n"
+		"Enable CONFIG_LIBPYTHON and rebuild perf to enable it.\n");
 }
 
 static int python_start_script_unsupported(const char *script __maybe_unused,
@@ -94,17 +91,17 @@ static void register_python_scripting(struct scripting_ops *scripting_ops)
 	scripting_context = malloc(sizeof(struct scripting_context));
 }
 
-#ifdef NO_LIBPYTHON
+#ifdef CONFIG_LIBPYTHON
+extern struct scripting_ops python_scripting_ops;
+
 void setup_python_scripting(void)
 {
-	register_python_scripting(&python_scripting_unsupported_ops);
+	register_python_scripting(&python_scripting_ops);
 }
 #else
-extern struct scripting_ops python_scripting_ops;
-
 void setup_python_scripting(void)
 {
-	register_python_scripting(&python_scripting_ops);
+	register_python_scripting(&python_scripting_unsupported_ops);
 }
 #endif
 
-- 
1.7.10.1

