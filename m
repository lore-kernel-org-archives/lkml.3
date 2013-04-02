Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760555Ab3DBD6L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 23:58:11 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:55887 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760532Ab3DBDzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 23:55:22 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>, Borislav Petkov <bp@alien8.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 14/23] perf: make backtrace support based on CONFIG_BACKTRACE
Date: Mon,  1 Apr 2013 21:54:28 -0600
Message-Id: <1364874877-5618-15-git-send-email-dsahern@gmail.com>
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
 tools/perf/Makefile                 |   10 ++++------
 tools/perf/Pconfig                  |    3 +++
 tools/perf/config/feature-tests.mak |    2 +-
 tools/perf/util/util.c              |    5 +++--
 4 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 3ada6e7..0baa19b 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -31,8 +31,6 @@ include config/utilities.mak
 # Define EXTRA_CFLAGS=-m64 or EXTRA_CFLAGS=-m32 as appropriate for cross-builds.
 #
 # Define WERROR=0 to disable treating any warnings as errors.
-#
-# Define NO_BACKTRACE if you do not want stack backtrace debug feature
 
 $(OUTPUT)PERF-VERSION-FILE: .FORCE-PERF-VERSION-FILE
 	@$(SHELL_PATH) util/PERF-VERSION-GEN $(OUTPUT)
@@ -829,10 +827,10 @@ ifndef NO_ON_EXIT
 	endif
 endif
 
-ifndef NO_BACKTRACE
-       ifeq ($(call try-cc,$(SOURCE_BACKTRACE),,-DBACKTRACE_SUPPORT),y)
-               BASIC_CFLAGS += -DBACKTRACE_SUPPORT
-       endif
+ifdef CONFIG_BACKTRACE
+    ifneq ($(call try-cc,$(SOURCE_BACKTRACE),,-DBACKTRACE_SUPPORT),y)
+        $(error backtrace not supported. Unset CONFIG_BACKTRACE)
+   endif
 endif
 
 ifdef CONFIG_LIBNUMA
diff --git a/tools/perf/Pconfig b/tools/perf/Pconfig
index c4e20cc..b03881c 100644
--- a/tools/perf/Pconfig
+++ b/tools/perf/Pconfig
@@ -49,3 +49,6 @@ config LIBNUMA
     bool "Enable support for libnuma"
     help
         Used for 'perf bench numa mem' benchmark
+
+config BACKTRACE
+    bool "Enable support for stack backtrace debugging"
diff --git a/tools/perf/config/feature-tests.mak b/tools/perf/config/feature-tests.mak
index 7873e6d..1d16481 100644
--- a/tools/perf/config/feature-tests.mak
+++ b/tools/perf/config/feature-tests.mak
@@ -192,7 +192,7 @@ int main(void)
 endef
 endif
 
-ifndef NO_BACKTRACE
+ifdef CONFIG_BACKTRACE
 define SOURCE_BACKTRACE
 #include <execinfo.h>
 #include <stdio.h>
diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
index 805d1f5..fa2916d 100644
--- a/tools/perf/util/util.c
+++ b/tools/perf/util/util.c
@@ -1,7 +1,8 @@
 #include "../perf.h"
 #include "util.h"
 #include <sys/mman.h>
-#ifdef BACKTRACE_SUPPORT
+#include <linux/kconfig.h>
+#ifdef CONFIG_BACKTRACE
 #include <execinfo.h>
 #endif
 #include <stdio.h>
@@ -202,7 +203,7 @@ int hex2u64(const char *ptr, u64 *long_val)
 }
 
 /* Obtain a backtrace and print it to stdout. */
-#ifdef BACKTRACE_SUPPORT
+#ifdef CONFIG_BACKTRACE
 void dump_stack(void)
 {
 	void *array[16];
-- 
1.7.10.1

