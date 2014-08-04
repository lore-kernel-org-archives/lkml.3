Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310AbaHDQUz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 12:20:55 -0400
Received: from mail.kernel.org ([198.145.19.201]:39529 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751530AbaHDQUx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 12:20:53 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung.kim@lge.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Ilsche <thomas.ilsche@tu-dresden.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 24/33] perf tools: Fix make PYTHON override
Date: Mon,  4 Aug 2014 13:17:35 -0300
Message-Id: <1407169064-25625-25-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1407169064-25625-1-git-send-email-acme@kernel.org>
References: <1407169064-25625-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

Thomas reported that make PYTHON=python2 is not work on some systems.  I
can reproduce it on my ArchLinux box too.

This is because it's overridden by config/feature-checks/Makefile
regardless of PYTHON setting.  I guess it's a bug slipped into during
the feature checking change.

Actually, we don't need to check python-config in the feature-checks.
We can just pass appropriate FEATURE_CHECK_*FLAGS.

Reported-by: Thomas Ilsche <thomas.ilsche@tu-dresden.de>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Tested-by: Thomas Ilsche <thomas.ilsche@tu-dresden.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Ilsche <thomas.ilsche@tu-dresden.de>
Link: http://lkml.kernel.org/r/1406617040-26909-1-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/config/Makefile                | 34 ++++++++++++++++++++-----------
 tools/perf/config/feature-checks/Makefile | 18 ++--------------
 2 files changed, 24 insertions(+), 28 deletions(-)

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 1f67aa02d240..e05d8f99424d 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -120,6 +120,23 @@ ifdef PARSER_DEBUG
   CFLAGS             += -DPARSER_DEBUG
 endif
 
+ifndef NO_LIBPYTHON
+  override PYTHON := \
+    $(call get-executable-or-default,PYTHON,python)
+  override PYTHON_CONFIG := \
+    $(call get-executable-or-default,PYTHON_CONFIG,$(PYTHON)-config)
+
+  PYTHON_CONFIG_SQ := $(call shell-sq,$(PYTHON_CONFIG))
+
+  PYTHON_EMBED_LDOPTS := $(shell $(PYTHON_CONFIG_SQ) --ldflags 2>/dev/null)
+  PYTHON_EMBED_CCOPTS := $(shell $(PYTHON_CONFIG_SQ) --cflags 2>/dev/null)
+
+  FEATURE_CHECK_CFLAGS-libpython := $(PYTHON_EMBED_CCOPTS)
+  FEATURE_CHECK_LDFLAGS-libpython := $(PYTHON_EMBED_LDOPTS)
+  FEATURE_CHECK_CFLAGS-libpython-version := $(PYTHON_EMBED_CCOPTS)
+  FEATURE_CHECK_LDFLAGS-libpython-version := $(PYTHON_EMBED_LDOPTS)
+endif
+
 CFLAGS += -fno-omit-frame-pointer
 CFLAGS += -ggdb3
 CFLAGS += -funwind-tables
@@ -482,21 +499,14 @@ define disable-python_code
   NO_LIBPYTHON := 1
 endef
 
-override PYTHON := \
-  $(call get-executable-or-default,PYTHON,python)
-
-ifndef PYTHON
-  $(call disable-python,python interpreter)
+ifdef NO_LIBPYTHON
+  $(call disable-python)
 else
 
-  PYTHON_WORD := $(call shell-wordify,$(PYTHON))
-
-  ifdef NO_LIBPYTHON
-    $(call disable-python)
+  ifndef PYTHON
+    $(call disable-python,python interpreter)
   else
-
-    override PYTHON_CONFIG := \
-      $(call get-executable-or-default,PYTHON_CONFIG,$(PYTHON)-config)
+    PYTHON_WORD := $(call shell-wordify,$(PYTHON))
 
     ifndef PYTHON_CONFIG
       $(call disable-python,python-config tool)
diff --git a/tools/perf/config/feature-checks/Makefile b/tools/perf/config/feature-checks/Makefile
index 6088f8d8a434..72ab2984718e 100644
--- a/tools/perf/config/feature-checks/Makefile
+++ b/tools/perf/config/feature-checks/Makefile
@@ -101,25 +101,11 @@ FLAGS_PERL_EMBED=$(PERL_EMBED_CCOPTS) $(PERL_EMBED_LDOPTS)
 test-libperl.bin:
 	$(BUILD) $(FLAGS_PERL_EMBED)
 
-override PYTHON := python
-override PYTHON_CONFIG := python-config
-
-escape-for-shell-sq =  $(subst ','\'',$(1))
-shell-sq = '$(escape-for-shell-sq)'
-
-PYTHON_CONFIG_SQ = $(call shell-sq,$(PYTHON_CONFIG))
-
-PYTHON_EMBED_LDOPTS = $(shell $(PYTHON_CONFIG_SQ) --ldflags 2>/dev/null)
-PYTHON_EMBED_LDFLAGS = $(call strip-libs,$(PYTHON_EMBED_LDOPTS))
-PYTHON_EMBED_LIBADD = $(call grep-libs,$(PYTHON_EMBED_LDOPTS))
-PYTHON_EMBED_CCOPTS = $(shell $(PYTHON_CONFIG_SQ) --cflags 2>/dev/null)
-FLAGS_PYTHON_EMBED = $(PYTHON_EMBED_CCOPTS) $(PYTHON_EMBED_LDOPTS)
-
 test-libpython.bin:
-	$(BUILD) $(FLAGS_PYTHON_EMBED)
+	$(BUILD)
 
 test-libpython-version.bin:
-	$(BUILD) $(FLAGS_PYTHON_EMBED)
+	$(BUILD)
 
 test-libbfd.bin:
 	$(BUILD) -DPACKAGE='"perf"' -lbfd -lz -liberty -ldl
-- 
1.9.3

