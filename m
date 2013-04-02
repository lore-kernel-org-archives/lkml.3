Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760281Ab3DBDxq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 23:53:46 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:53591 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758699Ab3DBDxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 23:53:43 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>, Borislav Petkov <bp@alien8.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 02/23] perf: make perl support based on CONFIG_LIBPERL
Date: Mon,  1 Apr 2013 21:53:08 -0600
Message-Id: <1364874809-5575-3-git-send-email-dsahern@gmail.com>
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
 tools/perf/Makefile                     |   34 ++++++++++++++-----------------
 tools/perf/Pconfig                      |    2 ++
 tools/perf/builtin-script.c             |    3 ++-
 tools/perf/config/feature-tests.mak     |    4 ++--
 tools/perf/util/trace-event-scripting.c |   13 ++++++------
 5 files changed, 28 insertions(+), 28 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 4e54d05..af7b746 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -16,8 +16,6 @@ include config/utilities.mak
 #
 # Define CROSS_COMPILE as prefix name of compiler if you want cross-builds.
 #
-# Define NO_LIBPERL to disable perl script extension.
-#
 # Define NO_LIBPYTHON to disable python script extension.
 #
 # Define PYTHON to point to the python binary if the default
@@ -718,23 +716,21 @@ ifndef NO_GTK2
 	endif
 endif
 
-ifdef NO_LIBPERL
-	BASIC_CFLAGS += -DNO_LIBPERL
-else
-       PERL_EMBED_LDOPTS = $(shell perl -MExtUtils::Embed -e ldopts 2>/dev/null)
-       PERL_EMBED_LDFLAGS = $(call strip-libs,$(PERL_EMBED_LDOPTS))
-       PERL_EMBED_LIBADD = $(call grep-libs,$(PERL_EMBED_LDOPTS))
-	PERL_EMBED_CCOPTS = `perl -MExtUtils::Embed -e ccopts 2>/dev/null`
-	FLAGS_PERL_EMBED=$(PERL_EMBED_CCOPTS) $(PERL_EMBED_LDOPTS)
-
-	ifneq ($(call try-cc,$(SOURCE_PERL_EMBED),$(FLAGS_PERL_EMBED),perl),y)
-		BASIC_CFLAGS += -DNO_LIBPERL
-	else
-               ALL_LDFLAGS += $(PERL_EMBED_LDFLAGS)
-               EXTLIBS += $(PERL_EMBED_LIBADD)
-		LIB_OBJS += $(OUTPUT)util/scripting-engines/trace-event-perl.o
-		LIB_OBJS += $(OUTPUT)scripts/perl/Perf-Trace-Util/Context.o
-	endif
+ifdef CONFIG_LIBPERL
+    PERL_EMBED_LDOPTS = $(shell perl -MExtUtils::Embed -e ldopts 2>/dev/null)
+    PERL_EMBED_LDFLAGS = $(call strip-libs,$(PERL_EMBED_LDOPTS))
+    PERL_EMBED_LIBADD = $(call grep-libs,$(PERL_EMBED_LDOPTS))
+    PERL_EMBED_CCOPTS = `perl -MExtUtils::Embed -e ccopts 2>/dev/null`
+    FLAGS_PERL_EMBED=$(PERL_EMBED_CCOPTS) $(PERL_EMBED_LDOPTS)
+
+    ifneq ($(call try-cc,$(SOURCE_PERL_EMBED),$(FLAGS_PERL_EMBED)),y)
+        $(error perl module ExtUtils::Embed not installed. Install it or unset CONFIG_LIBPERL to continue)
+    endif
+
+    ALL_LDFLAGS += $(PERL_EMBED_LDFLAGS)
+    EXTLIBS += $(PERL_EMBED_LIBADD)
+    LIB_OBJS += $(OUTPUT)util/scripting-engines/trace-event-perl.o
+    LIB_OBJS += $(OUTPUT)scripts/perl/Perf-Trace-Util/Context.o
 endif
 
 disable-python = $(eval $(disable-python_code))
diff --git a/tools/perf/Pconfig b/tools/perf/Pconfig
index e69de29..a636af3 100644
--- a/tools/perf/Pconfig
+++ b/tools/perf/Pconfig
@@ -0,0 +1,2 @@
+config LIBPERL
+    bool "Enable support for perl scripting engine"
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 92d4658..7841533 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -16,6 +16,7 @@
 #include "util/evsel.h"
 #include "util/sort.h"
 #include <linux/bitmap.h>
+#include <linux/kconfig.h>
 
 static char const		*script_name;
 static char const		*generate_script_lang;
@@ -1110,7 +1111,7 @@ int find_scripts(char **scripts_array, char **scripts_path_array)
 	for_each_lang(scripts_path, scripts_dir, lang_dirent, lang_next) {
 		snprintf(lang_path, MAXPATHLEN, "%s/%s", scripts_path,
 			 lang_dirent.d_name);
-#ifdef NO_LIBPERL
+#ifndef CONFIG_LIBPERL
 		if (strstr(lang_path, "perl"))
 			continue;
 #endif
diff --git a/tools/perf/config/feature-tests.mak b/tools/perf/config/feature-tests.mak
index b4eabb4..1222b33 100644
--- a/tools/perf/config/feature-tests.mak
+++ b/tools/perf/config/feature-tests.mak
@@ -102,7 +102,7 @@ int main(void)
 endef
 endif
 
-ifndef NO_LIBPERL
+ifdef CONFIG_LIBPERL
 define SOURCE_PERL_EMBED
 #include <EXTERN.h>
 #include <perl.h>
@@ -235,4 +235,4 @@ int main(void)
 	numa_available();
 	return 0;
 }
-endef
\ No newline at end of file
+endef
diff --git a/tools/perf/util/trace-event-scripting.c b/tools/perf/util/trace-event-scripting.c
index 8715a10..3343d97 100644
--- a/tools/perf/util/trace-event-scripting.c
+++ b/tools/perf/util/trace-event-scripting.c
@@ -27,6 +27,7 @@
 #include "../perf.h"
 #include "util.h"
 #include "trace-event.h"
+#include <linux/kconfig.h>
 
 struct scripting_context *scripting_context;
 
@@ -110,7 +111,7 @@ void setup_python_scripting(void)
 static void print_perl_unsupported_msg(void)
 {
 	fprintf(stderr, "Perl scripting not supported."
-		"  Install libperl and rebuild perf to enable it.\n"
+		"  Enable CONFIG_LIBPERL and rebuild perf.\n"
 		"For example:\n  # apt-get install libperl-dev (ubuntu)"
 		"\n  # yum install 'perl(ExtUtils::Embed)' (Fedora)"
 		"\n  etc.\n");
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
1.7.10.1

