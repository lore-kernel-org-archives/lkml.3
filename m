Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760564Ab3DBDza (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 23:55:30 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:39069 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760549Ab3DBDz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 23:55:26 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>, Borislav Petkov <bp@alien8.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 15/23] perf: make libaudit support based on CONFIG_LIBAUDIT
Date: Mon,  1 Apr 2013 21:54:29 -0600
Message-Id: <1364874877-5618-16-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1364874877-5618-1-git-send-email-dsahern@gmail.com>
References: <1364874877-5618-1-git-send-email-dsahern@gmail.com>
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
 tools/perf/Makefile                 |   16 +++++++---------
 tools/perf/Pconfig                  |    5 +++++
 tools/perf/config/feature-tests.mak |    2 +-
 tools/perf/perf.c                   |    3 ++-
 4 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 0baa19b..62c10b8 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -644,15 +644,13 @@ ifdef CONFIG_LIBUNWIND
 	LIB_OBJS += $(OUTPUT)util/unwind.o
 endif
 
-ifndef NO_LIBAUDIT
-	FLAGS_LIBAUDIT = $(ALL_CFLAGS) $(ALL_LDFLAGS) -laudit
-	ifneq ($(call try-cc,$(SOURCE_LIBAUDIT),$(FLAGS_LIBAUDIT),libaudit),y)
-		msg := $(warning No libaudit.h found, disables 'trace' tool, please install audit-libs-devel or libaudit-dev);
-	else
-		BASIC_CFLAGS += -DLIBAUDIT_SUPPORT
-		BUILTIN_OBJS += $(OUTPUT)builtin-trace.o
-		EXTLIBS += -laudit
-	endif
+ifdef CONFIG_LIBAUDIT
+    FLAGS_LIBAUDIT = $(ALL_CFLAGS) $(ALL_LDFLAGS) -laudit
+    ifneq ($(call try-cc,$(SOURCE_LIBAUDIT),$(FLAGS_LIBAUDIT),libaudit),y)
+        $(error No libaudit.h found, please install audit-libs-devel or libaudit-dev or disable CONFIG_LIBAUDIT)
+    endif
+    BUILTIN_OBJS += $(OUTPUT)builtin-trace.o
+    EXTLIBS += -laudit
 endif
 
 ifdef CONFIG_NEWT
diff --git a/tools/perf/Pconfig b/tools/perf/Pconfig
index b03881c..4cfccf3 100644
--- a/tools/perf/Pconfig
+++ b/tools/perf/Pconfig
@@ -45,6 +45,11 @@ config LIBPERL
 config LIBPYTHON
     bool "Enable support for python scripting engine"
 
+config LIBAUDIT
+    bool "Enable support for libaudit"
+    help
+        Used for perf trace tool.
+
 config LIBNUMA
     bool "Enable support for libnuma"
     help
diff --git a/tools/perf/config/feature-tests.mak b/tools/perf/config/feature-tests.mak
index 1d16481..6e3ba0f 100644
--- a/tools/perf/config/feature-tests.mak
+++ b/tools/perf/config/feature-tests.mak
@@ -206,7 +206,7 @@ int main(void)
 endef
 endif
 
-ifndef NO_LIBAUDIT
+ifdef CONFIG_LIBAUDIT
 define SOURCE_LIBAUDIT
 #include <libaudit.h>
 
diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index 095b882..f7fcf78 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -14,6 +14,7 @@
 #include "util/run-command.h"
 #include "util/parse-events.h"
 #include "util/debugfs.h"
+#include <linux/kconfig.h>
 #include <pthread.h>
 
 const char perf_usage_string[] =
@@ -56,7 +57,7 @@ static struct cmd_struct commands[] = {
 	{ "lock",	cmd_lock,	0 },
 	{ "kvm",	cmd_kvm,	0 },
 	{ "test",	cmd_test,	0 },
-#ifdef LIBAUDIT_SUPPORT
+#ifdef CONFIG_LIBAUDIT
 	{ "trace",	cmd_trace,	0 },
 #endif
 	{ "inject",	cmd_inject,	0 },
-- 
1.7.10.1

