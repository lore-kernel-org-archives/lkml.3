Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752184AbaHMFSP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 01:18:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45056 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751AbaHMFSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 01:18:12 -0400
Date: Tue, 12 Aug 2014 22:17:43 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-56c7d79e49776084b852e451bda5f59dc3bcf894@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, jolsa@redhat.com,
        thomas.ilsche@tu-dresden.de, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, thomas.ilsche@tu-dresden.de,
        jolsa@redhat.com, tglx@linutronix.de
In-Reply-To: <1406617040-26909-1-git-send-email-namhyung@kernel.org>
References: <1406617040-26909-1-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Fix make PYTHON override
Git-Commit-ID: 56c7d79e49776084b852e451bda5f59dc3bcf894
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  56c7d79e49776084b852e451bda5f59dc3bcf894
Gitweb:     http://git.kernel.org/tip/56c7d79e49776084b852e451bda5f59dc3bcf894
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Tue, 29 Jul 2014 15:57:19 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 12 Aug 2014 12:03:04 -0300

perf tools: Fix make PYTHON override

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
index 1f67aa0..e05d8f9 100644
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
index 6088f8d..72ab298 100644
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
