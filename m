Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759636Ab3DATX0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 15:23:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1952 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759485Ab3DATUp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 15:20:45 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Borislav Petkov <bp@alien8.de>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 13/27] perf tools: Move libpython check config into config/Makefile
Date: Mon,  1 Apr 2013 21:18:36 +0200
Message-Id: <1364843930-17974-14-git-send-email-jolsa@redhat.com>
In-Reply-To: <1364843930-17974-1-git-send-email-jolsa@redhat.com>
References: <1364843930-17974-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moving libpython check config into config/Makefile.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/Makefile        | 68 ++--------------------------------------------
 tools/perf/config/Makefile | 63 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 66 insertions(+), 65 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 972aa94..f02c0fd 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -184,8 +184,6 @@ SCRIPTS = $(patsubst %.sh,%,$(SCRIPT_SH))
 #
 PROGRAMS += $(OUTPUT)perf
 
-LANG_BINDINGS =
-
 # what 'all' will build and 'install' will install, in perfexecdir
 ALL_PROGRAMS = $(PROGRAMS) $(SCRIPTS)
 
@@ -523,69 +521,9 @@ ifndef NO_LIBPERL
 	LIB_OBJS += $(OUTPUT)scripts/perl/Perf-Trace-Util/Context.o
 endif
 
-disable-python = $(eval $(disable-python_code))
-define disable-python_code
-  BASIC_CFLAGS += -DNO_LIBPYTHON
-  $(if $(1),$(warning No $(1) was found))
-  $(warning Python support will not be built)
-endef
-
-override PYTHON := \
-  $(call get-executable-or-default,PYTHON,python)
-
-ifndef PYTHON
-  $(call disable-python,python interpreter)
-else
-
-  PYTHON_WORD := $(call shell-wordify,$(PYTHON))
-
-  ifdef NO_LIBPYTHON
-    $(call disable-python)
-  else
-
-    override PYTHON_CONFIG := \
-      $(call get-executable-or-default,PYTHON_CONFIG,$(PYTHON)-config)
-
-    ifndef PYTHON_CONFIG
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
-    endif
-  endif
+ifndef NO_LIBPYTHON
+	LIB_OBJS += $(OUTPUT)util/scripting-engines/trace-event-python.o
+	LIB_OBJS += $(OUTPUT)scripts/python/Perf-Trace-Util/Context.o
 endif
 
 ifdef NO_DEMANGLE
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 2c9e0a5..d5e0386 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -261,3 +261,66 @@ else
 		EXTLIBS += $(PERL_EMBED_LIBADD)
 	endif
 endif
+
+disable-python = $(eval $(disable-python_code))
+define disable-python_code
+  BASIC_CFLAGS += -DNO_LIBPYTHON
+  $(if $(1),$(warning No $(1) was found))
+  $(warning Python support will not be built)
+  NO_LIBPYTHON := 1
+endef
+
+override PYTHON := \
+  $(call get-executable-or-default,PYTHON,python)
+
+ifndef PYTHON
+  $(call disable-python,python interpreter)
+else
+
+  PYTHON_WORD := $(call shell-wordify,$(PYTHON))
+
+  ifdef NO_LIBPYTHON
+    $(call disable-python)
+  else
+
+    override PYTHON_CONFIG := \
+      $(call get-executable-or-default,PYTHON_CONFIG,$(PYTHON)-config)
+
+    ifndef PYTHON_CONFIG
+      $(call disable-python,python-config tool)
+    else
+
+      PYTHON_CONFIG_SQ := $(call shell-sq,$(PYTHON_CONFIG))
+
+      PYTHON_EMBED_LDOPTS := $(shell $(PYTHON_CONFIG_SQ) --ldflags 2>/dev/null)
+      PYTHON_EMBED_LDFLAGS := $(call strip-libs,$(PYTHON_EMBED_LDOPTS))
+      PYTHON_EMBED_LIBADD := $(call grep-libs,$(PYTHON_EMBED_LDOPTS))
+      PYTHON_EMBED_CCOPTS := $(shell $(PYTHON_CONFIG_SQ) --cflags 2>/dev/null)
+      FLAGS_PYTHON_EMBED := $(PYTHON_EMBED_CCOPTS) $(PYTHON_EMBED_LDOPTS)
+
+      ifneq ($(call try-cc,$(SOURCE_PYTHON_EMBED),$(FLAGS_PYTHON_EMBED),python),y)
+        $(call disable-python,Python.h (for Python 2.x))
+      else
+
+        ifneq ($(call try-cc,$(SOURCE_PYTHON_VERSION),$(FLAGS_PYTHON_EMBED),python version),y)
+          $(warning Python 3 is not yet supported; please set)
+          $(warning PYTHON and/or PYTHON_CONFIG appropriately.)
+          $(warning If you also have Python 2 installed, then)
+          $(warning try something like:)
+          $(warning $(and ,))
+          $(warning $(and ,)  make PYTHON=python2)
+          $(warning $(and ,))
+          $(warning Otherwise, disable Python support entirely:)
+          $(warning $(and ,))
+          $(warning $(and ,)  make NO_LIBPYTHON=1)
+          $(warning $(and ,))
+          $(error   $(and ,))
+        else
+          ALL_LDFLAGS += $(PYTHON_EMBED_LDFLAGS)
+          EXTLIBS += $(PYTHON_EMBED_LIBADD)
+          LANG_BINDINGS += $(OUTPUT)python/perf.so
+        endif
+      endif
+    endif
+  endif
+endif
-- 
1.7.11.7

