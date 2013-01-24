Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755Ab3AXSjO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 13:39:14 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60883 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919Ab3AXSjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 13:39:12 -0500
Date: Thu, 24 Jan 2013 10:38:31 -0800
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-3cde41b0d63d0550ac9c8352f1ce0ea516690f46@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, tglx@linutronix.de, namhyung@kernel.org
In-Reply-To: <1352867990-658-1-git-send-email-namhyung@kernel.org>
References: <1352867990-658-1-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Don'
 t check configuration on make clean
Git-Commit-ID: 3cde41b0d63d0550ac9c8352f1ce0ea516690f46
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 24 Jan 2013 10:38:38 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3cde41b0d63d0550ac9c8352f1ce0ea516690f46
Gitweb:     http://git.kernel.org/tip/3cde41b0d63d0550ac9c8352f1ce0ea516690f46
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Wed, 14 Nov 2012 13:39:50 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Sun, 9 Dec 2012 08:46:04 -0300

perf tools: Don't check configuration on make clean

Current perf build process checks various system configuration on
invocation to make.  But this is not needed just for cleaning.

To do that, move some of python related variables out of conditional
since 'clean' target needs them.  Normal path should not be affected by
this.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1352867990-658-1-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/Makefile |  2 ++
 tools/perf/Makefile               | 28 ++++++++++++++++------------
 2 files changed, 18 insertions(+), 12 deletions(-)

diff --git a/tools/perf/Documentation/Makefile b/tools/perf/Documentation/Makefile
index ef6d22e..f6e5901 100644
--- a/tools/perf/Documentation/Makefile
+++ b/tools/perf/Documentation/Makefile
@@ -222,10 +222,12 @@ install-pdf: pdf
 #install-html: html
 #	'$(SHELL_PATH_SQ)' ./install-webdoc.sh $(DESTDIR)$(htmldir)
 
+ifneq ($(MAKECMDGOALS),clean)
 $(OUTPUT)PERF-VERSION-FILE: .FORCE-PERF-VERSION-FILE
 	$(QUIET_SUBDIR0)../ $(QUIET_SUBDIR1) $(OUTPUT)PERF-VERSION-FILE
 
 -include $(OUTPUT)PERF-VERSION-FILE
+endif
 
 #
 # Determine "include::" file references in asciidoc files.
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 8fca560..08da9fc 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -153,6 +153,7 @@ INSTALL = install
 # explicitly what architecture to check for. Fix this up for yours..
 SPARSE_FLAGS = -D__BIG_ENDIAN__ -D__powerpc__
 
+ifneq ($(MAKECMDGOALS),clean)
 -include config/feature-tests.mak
 
 ifeq ($(call try-cc,$(SOURCE_HELLO),$(CFLAGS) -Werror -fstack-protector-all,-fstack-protector-all),y)
@@ -206,6 +207,7 @@ ifeq ($(call try-cc,$(SOURCE_BIONIC),$(CFLAGS),bionic),y)
 	EXTLIBS := $(filter-out -lpthread,$(EXTLIBS))
 	BASIC_CFLAGS += -I.
 endif
+endif # MAKECMDGOALS != clean
 
 # Guard against environment variables
 BUILTIN_OBJS =
@@ -230,11 +232,19 @@ endif
 LIBTRACEEVENT = $(TE_PATH)libtraceevent.a
 TE_LIB := -L$(TE_PATH) -ltraceevent
 
+export LIBTRACEEVENT
+
+# python extension build directories
+PYTHON_EXTBUILD     := $(OUTPUT)python_ext_build/
+PYTHON_EXTBUILD_LIB := $(PYTHON_EXTBUILD)lib/
+PYTHON_EXTBUILD_TMP := $(PYTHON_EXTBUILD)tmp/
+export PYTHON_EXTBUILD_LIB PYTHON_EXTBUILD_TMP
+
+python-clean := rm -rf $(PYTHON_EXTBUILD) $(OUTPUT)python/perf.so
+
 PYTHON_EXT_SRCS := $(shell grep -v ^\# util/python-ext-sources)
 PYTHON_EXT_DEPS := util/python-ext-sources util/setup.py
 
-export LIBTRACEEVENT
-
 $(OUTPUT)python/perf.so: $(PYTHON_EXT_SRCS) $(PYTHON_EXT_DEPS)
 	$(QUIET_GEN)CFLAGS='$(BASIC_CFLAGS)' $(PYTHON_WORD) util/setup.py \
 	  --quiet build_ext; \
@@ -514,6 +524,7 @@ PERFLIBS = $(LIB_FILE) $(LIBTRACEEVENT)
 #
 # Platform specific tweaks
 #
+ifneq ($(MAKECMDGOALS),clean)
 
 # We choose to avoid "if .. else if .. else .. endif endif"
 # because maintaining the nesting to match is a pain.  If
@@ -703,7 +714,7 @@ disable-python = $(eval $(disable-python_code))
 define disable-python_code
   BASIC_CFLAGS += -DNO_LIBPYTHON
   $(if $(1),$(warning No $(1) was found))
-  $(warning Python support won't be built)
+  $(warning Python support will not be built)
 endef
 
 override PYTHON := \
@@ -711,19 +722,10 @@ override PYTHON := \
 
 ifndef PYTHON
   $(call disable-python,python interpreter)
-  python-clean :=
 else
 
   PYTHON_WORD := $(call shell-wordify,$(PYTHON))
 
-  # python extension build directories
-  PYTHON_EXTBUILD     := $(OUTPUT)python_ext_build/
-  PYTHON_EXTBUILD_LIB := $(PYTHON_EXTBUILD)lib/
-  PYTHON_EXTBUILD_TMP := $(PYTHON_EXTBUILD)tmp/
-  export PYTHON_EXTBUILD_LIB PYTHON_EXTBUILD_TMP
-
-  python-clean := rm -rf $(PYTHON_EXTBUILD) $(OUTPUT)python/perf.so
-
   ifdef NO_LIBPYTHON
     $(call disable-python)
   else
@@ -839,6 +841,8 @@ ifdef ASCIIDOC8
 	export ASCIIDOC8
 endif
 
+endif # MAKECMDGOALS != clean
+
 # Shell quote (do not use $(call) to accommodate ancient setups);
 
 ETC_PERFCONFIG_SQ = $(subst ','\'',$(ETC_PERFCONFIG))
