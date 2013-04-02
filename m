Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760512Ab3DBDzR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 23:55:17 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50964 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760501Ab3DBDzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 23:55:12 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>, Borislav Petkov <bp@alien8.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 10/23] perf: make demangle support based on CONFIG_DEMANGLE
Date: Mon,  1 Apr 2013 21:54:24 -0600
Message-Id: <1364874877-5618-11-git-send-email-dsahern@gmail.com>
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
 tools/perf/Makefile      |   70 ++++++++++++++++++++++------------------------
 tools/perf/Pconfig       |    4 +++
 tools/perf/util/symbol.h |    3 +-
 3 files changed, 39 insertions(+), 38 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 5c060c8..65283e6 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -34,8 +34,6 @@ include config/utilities.mak
 #
 # Define WERROR=0 to disable treating any warnings as errors.
 #
-# Define NO_DEMANGLE if you do not want C++ symbol demangling.
-#
 # Define NO_BACKTRACE if you do not want stack backtrace debug feature
 #
 # Define NO_LIBNUMA if you do not want numa perf benchmark
@@ -571,7 +569,9 @@ ifdef CONFIG_LIBELF
 	endif
 else
     NO_DWARF := 1
-    NO_DEMANGLE := 1
+    ifdef CONFIG_DEMANGLE
+        $(error CONFIG_DEMANGLE depends on LIBELF)
+    endif
     ifdef CONFIG_LIBUNWIND
         $(error CONFIG_LIBUNWIND depends on LIBELF)
     endif
@@ -775,41 +775,37 @@ ifdef CONFIG_LIBPYTHON
     LANG_BINDINGS += $(OUTPUT)python/perf.so
 endif
 
-ifdef NO_DEMANGLE
-	BASIC_CFLAGS += -DNO_DEMANGLE
-else
-        ifdef HAVE_CPLUS_DEMANGLE
-		EXTLIBS += -liberty
-		BASIC_CFLAGS += -DHAVE_CPLUS_DEMANGLE
+ifdef CONFIG_DEMANGLE
+    ifdef HAVE_CPLUS_DEMANGLE
+        EXTLIBS += -liberty
+        BASIC_CFLAGS += -DHAVE_CPLUS_DEMANGLE
+    else
+        FLAGS_BFD=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS) -DPACKAGE='perf' -lbfd
+        has_bfd := $(call try-cc,$(SOURCE_BFD),$(FLAGS_BFD),libbfd)
+        ifeq ($(has_bfd),y)
+            EXTLIBS += -lbfd
         else
-		FLAGS_BFD=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS) -DPACKAGE='perf' -lbfd
-		has_bfd := $(call try-cc,$(SOURCE_BFD),$(FLAGS_BFD),libbfd)
-		ifeq ($(has_bfd),y)
-			EXTLIBS += -lbfd
-		else
-			FLAGS_BFD_IBERTY=$(FLAGS_BFD) -liberty
-			has_bfd_iberty := $(call try-cc,$(SOURCE_BFD),$(FLAGS_BFD_IBERTY),liberty)
-			ifeq ($(has_bfd_iberty),y)
-				EXTLIBS += -lbfd -liberty
-			else
-				FLAGS_BFD_IBERTY_Z=$(FLAGS_BFD_IBERTY) -lz
-				has_bfd_iberty_z := $(call try-cc,$(SOURCE_BFD),$(FLAGS_BFD_IBERTY_Z),libz)
-				ifeq ($(has_bfd_iberty_z),y)
-					EXTLIBS += -lbfd -liberty -lz
-				else
-					FLAGS_CPLUS_DEMANGLE=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS) -liberty
-					has_cplus_demangle := $(call try-cc,$(SOURCE_CPLUS_DEMANGLE),$(FLAGS_CPLUS_DEMANGLE),demangle)
-					ifeq ($(has_cplus_demangle),y)
-						EXTLIBS += -liberty
-						BASIC_CFLAGS += -DHAVE_CPLUS_DEMANGLE
-					else
-						msg := $(warning No bfd.h/libbfd found, install binutils-dev[el]/zlib-static to gain symbol demangling)
-						BASIC_CFLAGS += -DNO_DEMANGLE
-					endif
-				endif
-			endif
-		endif
-	endif
+            FLAGS_BFD_IBERTY=$(FLAGS_BFD) -liberty
+            has_bfd_iberty := $(call try-cc,$(SOURCE_BFD),$(FLAGS_BFD_IBERTY),liberty)
+            ifeq ($(has_bfd_iberty),y)
+                EXTLIBS += -lbfd -liberty
+            else
+                FLAGS_BFD_IBERTY_Z=$(FLAGS_BFD_IBERTY) -lz
+                has_bfd_iberty_z := $(call try-cc,$(SOURCE_BFD),$(FLAGS_BFD_IBERTY_Z),libz)
+                ifeq ($(has_bfd_iberty_z),y)
+                    EXTLIBS += -lbfd -liberty -lz
+                else
+                    FLAGS_CPLUS_DEMANGLE=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS) -liberty
+                    has_cplus_demangle := $(call try-cc,$(SOURCE_CPLUS_DEMANGLE),$(FLAGS_CPLUS_DEMANGLE),demangle)
+                    ifeq ($(has_cplus_demangle),y)
+                        EXTLIBS += -liberty
+                        BASIC_CFLAGS += -DHAVE_CPLUS_DEMANGLE
+                    endif
+                    $(error No bfd.h/libbfd found, install binutils-dev[el]/zlib-static to gain symbol demangling or unset CONFIG_DEMANGLE)
+                endif
+            endif
+        endif
+    endif
 endif
 
 ifeq ($(NO_PERF_REGS),0)
diff --git a/tools/perf/Pconfig b/tools/perf/Pconfig
index d6e067e..dc0fc36 100644
--- a/tools/perf/Pconfig
+++ b/tools/perf/Pconfig
@@ -26,6 +26,10 @@ config LIBUNWIND
     bool "Enable support for libunwind"
     depends on HAVE_CFI_UNWIND_SUPPORT && LIBELF
 
+ config DEMANGLE
+    bool "Enable support for demangle"
+    depends on LIBELF
+
 config LIBPERL
     bool "Enable support for perl scripting engine"
 
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index b62ca37..cd284dc 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -12,6 +12,7 @@
 #include <byteswap.h>
 #include <libgen.h>
 #include "build-id.h"
+#include <linux/kconfig.h>
 
 #ifdef LIBELF_SUPPORT
 #include <libelf.h>
@@ -29,7 +30,7 @@ static inline char *bfd_demangle(void __maybe_unused *v, const char *c, int i)
 	return cplus_demangle(c, i);
 }
 #else
-#ifdef NO_DEMANGLE
+#ifndef CONFIG_DEMANGLE
 static inline char *bfd_demangle(void __maybe_unused *v,
 				 const char __maybe_unused *c,
 				 int __maybe_unused i)
-- 
1.7.10.1

