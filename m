Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965629AbaFCWO5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 18:14:57 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:55603 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965184AbaFCWI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 18:08:56 -0400
From: Alexis Berlemont <alexis.berlemont@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Alexis Berlemont <alexis.berlemont@gmail.com>, jolsa@redhat.com,
        dsahern@gmail.com, mingo@kernel.org, sam@ravnborg.org, mmarek@suse.cz
Subject: [PATCH 14/32] perf kbuild: remove legacy libperl-related build variables
Date: Wed,  4 Jun 2014 00:06:07 +0200
Message-Id: <1401833185-10347-15-git-send-email-alexis.berlemont@gmail.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1401833185-10347-1-git-send-email-alexis.berlemont@gmail.com>
References: <1401833185-10347-1-git-send-email-alexis.berlemont@gmail.com>
In-Reply-To: <CAMesUR5h0687dTFCDC3LhKSOFyKTFmH3vUjU+p6XuOpawPUwxQ@mail.gmail.com>
References: <CAMesUR5h0687dTFCDC3LhKSOFyKTFmH3vUjU+p6XuOpawPUwxQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove NO_LIBPERL (replaced by CONFIG_LIBPERL)
---
 tools/perf/builtin-script.c             |  4 +++-
 tools/perf/config/Makefile              |  8 ++------
 tools/perf/config/Makefile.fix-config   |  8 --------
 tools/perf/config/Makefile.fix-legacy   |  4 ----
 tools/perf/util/trace-event-scripting.c | 10 +++++-----
 5 files changed, 10 insertions(+), 24 deletions(-)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 9e9c91f..ff67f0d 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -1,3 +1,5 @@
+#include "generated/autoconf.h"
+
 #include "builtin.h"
 
 #include "perf.h"
@@ -1362,7 +1364,7 @@ int find_scripts(char **scripts_array, char **scripts_path_array)
 	for_each_lang(scripts_path, scripts_dir, lang_dirent, lang_next) {
 		snprintf(lang_path, MAXPATHLEN, "%s/%s", scripts_path,
 			 lang_dirent.d_name);
-#ifdef NO_LIBPERL
+#ifndef CONFIG_LIBPERL
 		if (strstr(lang_path, "perl"))
 			continue;
 #endif
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 040cdcc..93c3321 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -430,9 +430,7 @@ endif
 grep-libs  = $(filter -l%,$(1))
 strip-libs = $(filter-out -l%,$(1))
 
-ifdef NO_LIBPERL
-  CFLAGS += -DNO_LIBPERL
-else
+ifdef CONFIG_LIBPERL
   PERL_EMBED_LDOPTS = $(shell perl -MExtUtils::Embed -e ldopts 2>/dev/null)
   PERL_EMBED_LDFLAGS = $(call strip-libs,$(PERL_EMBED_LDOPTS))
   PERL_EMBED_LIBADD = $(call grep-libs,$(PERL_EMBED_LDOPTS))
@@ -440,8 +438,7 @@ else
   FLAGS_PERL_EMBED=$(PERL_EMBED_CCOPTS) $(PERL_EMBED_LDOPTS)
 
   ifneq ($(feature-libperl), 1)
-    CFLAGS += -DNO_LIBPERL
-    NO_LIBPERL := 1
+    $(shell $(KCONFIG_SCRIPT) -d CONFIG_LIBPERL)
   else
     LDFLAGS += $(PERL_EMBED_LDFLAGS)
     EXTLIBS += $(PERL_EMBED_LIBADD)
@@ -753,7 +750,6 @@ all:
 	$(call store,PERL_EMBED_CCOPTS)
 	$(call store,CONFIG_X86_64)
 	$(call store,NO_LIBUNWIND)
-	$(call store,NO_LIBPERL)
 	$(call store,NO_LIBPYTHON)
 	$(call store,NO_DEMANGLE)
 	$(call store,NO_LIBELF)
diff --git a/tools/perf/config/Makefile.fix-config b/tools/perf/config/Makefile.fix-config
index efe2ee7..6402a47 100644
--- a/tools/perf/config/Makefile.fix-config
+++ b/tools/perf/config/Makefile.fix-config
@@ -3,14 +3,6 @@ include $(KCONFIG_CONFIG)
 
 CONFIG := $(srctree)/scripts/config --file $(KCONFIG_CONFIG)
 
-# NO_LIBPERL
-ifdef CONFIG_LIBPERL
-ifdef NO_LIBPERL
-dummy := $(info Disabling CONFIG_LIBPERL)
-dummy := $(shell $(CONFIG) -d CONFIG_LIBPERL)
-endif
-endif
-
 # NO_LIBPYTHON
 ifdef CONFIG_LIBPYTHON
 ifdef NO_LIBPYTHON
diff --git a/tools/perf/config/Makefile.fix-legacy b/tools/perf/config/Makefile.fix-legacy
index ae69a1b..2e93006 100644
--- a/tools/perf/config/Makefile.fix-legacy
+++ b/tools/perf/config/Makefile.fix-legacy
@@ -1,10 +1,6 @@
 
 include $(KCONFIG_CONFIG)
 
-ifndef CONFIG_LIBPERL
-NO_LIBPERL := 1
-endif
-
 ifndef CONFIG_LIBPYTHON
 NO_LIBPYTHON := 1
 endif
diff --git a/tools/perf/util/trace-event-scripting.c b/tools/perf/util/trace-event-scripting.c
index 57aaccc..51d8019 100644
--- a/tools/perf/util/trace-event-scripting.c
+++ b/tools/perf/util/trace-event-scripting.c
@@ -156,16 +156,16 @@ static void register_perl_scripting(struct scripting_ops *scripting_ops)
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
1.9.3

